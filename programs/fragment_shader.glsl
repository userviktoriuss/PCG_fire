#version 430

out vec4 fragColor;

uniform vec2 resolution;
uniform float time;

float random (in vec2 st) {
    float a = 25;
    float b = 30;
    float c = 43900;

    return fract(sin(dot(st.xy, vec2(a,b))) * c);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f;

    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

#define OCTAVES 8
float fbm (in vec2 st) {
    // Initial values
    float value = 0.0;
    float amplitude = .55;
    float frequency = 0.;
    //
    // Loop of octaves
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * noise(st);
        st *= 2.;
        amplitude *= .5;
    }
    return value;
}


void main() {
//noise
    vec2 fragCoord = gl_FragCoord.xy;
    const float speed = 125.; //250
    const float details = 0.01;
    const float force = 1.4;
    const float shift = 0.4;
    vec2 xyFast = details * vec2(fragCoord.x, fragCoord.y - time * speed);
    float noise1 = fbm(xyFast); // * 0.01);
    float noise2 = force * (fbm(xyFast + noise1 + 0.5 * time) - shift); //1 * time

    float nnoise1 = force * fbm(vec2(noise1, noise2));
    float nnoise2 = fbm(vec2(noise2, noise1));
//cg
    const vec3 red = vec3(0.9, 0.4, 0.2);
    const vec3 yellow = vec3(0.9, 0.9, 0);
    const vec3 darkRed = vec3(0.5, 0, 0);
    const vec3 dark = vec3(0.1, 0.1, 0.1);
    vec3 c1 = mix(red, darkRed, nnoise1 + shift);
    vec3 c2 = mix(yellow, dark, nnoise2);



//mask
    const float scaleFactor = 3;
    vec3 gradient = vec3(scaleFactor * fragCoord.y / resolution.y) - shift;

    vec3 c = c1 + c2 - nnoise2 - gradient;
// out
    fragColor = vec4(c, 1.);
}


/*
//SAVE WORKING VERSION
#version 430

out vec4 fragColor;

uniform vec2 resolution;
uniform float time;

float random (in vec2 st) {
    float a = 25;
    float b = 30;
    float c = 43900;

    return fract(sin(dot(st.xy, vec2(a,b))) * c);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f;

    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

#define OCTAVES 8
float fbm (in vec2 st) {
    // Initial values
    float value = 0.0;
    float amplitude = .55;
    float frequency = 0.;
    //
    // Loop of octaves
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * noise(st);
        st *= 2.;
        amplitude *= .5;
    }
    return value;
}


void main() {
//noise
    vec2 fragCoord = gl_FragCoord.xy;
    const float speed = 125.; //250
    const float details = 0.01;
    const float force = 1.4;
    const float shift = 0.4;
    vec2 xyFast = details * vec2(fragCoord.x, fragCoord.y - time * speed);
    float noise1 = fbm(xyFast); // * 0.01);
    float noise2 = force * (fbm(xyFast + noise1 + 0.5 * time) - shift); //1 * time

    float nnoise1 = force * fbm(vec2(noise1, noise2));
    float nnoise2 = fbm(vec2(noise2, noise1));
//cg
    const vec3 red = vec3(0.9, 0.4, 0.2);
    const vec3 yellow = vec3(0.9, 0.9, 0);
    const vec3 darkRed = vec3(0.5, 0, 0);
    const vec3 dark = vec3(0.1, 0.1, 0.1);
    vec3 c1 = mix(red, darkRed, nnoise1 + shift);
    vec3 c2 = mix(yellow, dark, nnoise2);



//mask
    const float scaleFactor = 3;
    vec3 gradient = vec3(scaleFactor * fragCoord.y / resolution.y) - shift;

    vec3 c = c1 + c2 - nnoise2 - gradient;
// out
    fragColor = vec4(c, 1.);
}
*/