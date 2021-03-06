//RUN: %clang_cc1 %s -cl-std=clc++ -verify -fsyntax-only -triple spir
//RUN: %clang_cc1 %s -cl-std=clc++ -verify -fsyntax-only -DFPTREXT -triple spir

#ifdef FPTREXT
#pragma OPENCL EXTENSION __cl_clang_function_pointers : enable
#endif // FPTREXT

// References to functions are not allowed.
struct myclass {
//FIXME: Here we provide incorrect diagnostic.
  void (&mem)(); //expected-error{{reference to function type cannot have '__generic' qualifier}}
};

void (&glob)();
#ifndef FPTREXT
//expected-error@-2{{references to functions are not allowed}}
#else
//expected-error@-4{{declaration of reference variable 'glob' requires an initializer}}
#endif // FPTREXT

using ref2fct_t = void (&)();
#ifndef FPTREXT
//expected-error@-2{{references to functions are not allowed}}
#endif // FPTREXT
typedef void (&ref2fct_t)();
#ifndef FPTREXT
//expected-error@-2{{references to functions are not allowed}}
#endif // FPTREXT

void test(void (&par)()) {
#ifndef FPTREXT
//expected-error@-2{{references to functions are not allowed}}
#endif // FPTREXT
  void (&loc)();
#ifndef FPTREXT
//expected-error@-2{{references to functions are not allowed}}
#else
//expected-error@-4{{declaration of reference variable 'loc' requires an initializer}}
#endif // FPTREXT

  void (*&ref2fptr)();
#ifndef FPTREXT
//expected-error@-2{{pointers to functions are not allowed}}
#endif // FPTREXT
//expected-error@-4{{declaration of reference variable 'ref2fptr' requires an initializer}}
}
