Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab2KQGev (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 01:34:51 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52805 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab2KQGeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 01:34:50 -0500
MIME-Version: 1.0
Date: Fri, 16 Nov 2012 22:34:49 -0800
Message-ID: <CAO=7uoa8P_j3f3bHWhraMi8VrftYmYTjKogDXLYMNEzG824sqw@mail.gmail.com>
Subject: Improving the security of Linux processes
From: Scott Wisniewski <scott@scottdw2.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on an idea I had for improving the security of processes
in Linux. What I'm trying to do is a little complex, and I'm new to
Kernel development, so I figured it might be a good idea to reach out
to the Kernel community before I got too deep into the development.
Basically, I was hoping to have a high level architecture discussion
and get a feel for whether or not what I'm thinking about is the kind
of thing you guys would be receptive to adding to the kernel
(eventually).

I'm working on something that I like to call "Address Space Layout
Randomization Extreme", or ASLRX. ASLRX aims to extend ASLR by adding
support for dynamically randomizing the CONTENTS of an image, and not
just it's base address.

I've included a copy of the feature's "README" file below. It's been
written as if all of the required components have already been
implemented (they haven't). The general idea is just to provide a
quick description of what I'd like to like to implement. I'd
appreciate any comments or suggestions you might have. In particular,
I'm wondering:

1. Does this sound interesting to anyone?
2. Are there any major "philosophical" barriers to including this sort
of thing in the Kernel?
3. Do you have any advice?

Thanks,

-Scott

------------------------------------------------------------

Intro
==============================

ASLRX, or Address Space Layout Randomization Extreme, is an enhanced form of
address space layout randomization designed to improve the security of programs
running under Linux. Traditional ASLR (address space layout randomization) works
be selecting a random address for the stack space used by a program and
selecting random base addresses for each image loaded into a process (including
the "main" image). When combined with non executable data pages, it can
frustrate many attacks.

Unfortunately, because only base addresses are randomized, processes using ASLR
are still vulnerable to many attacks, including return-to-libc attacks. In
particular, if an attacker is able to guess a base address, he can deduce the
address of every function in an image.

There are many forms of information leakage that can be exploited to allow
attackers to infer a base address. It can be done with a web server, for
example, by sending iterative attack payloads that attempt to jump to a
particular (even innocuous) address inside libc. By examining the response
behavior of the server (error codes, timings, etc), an adversary can learn the
address of a function, and hence the base address of the target image. Once the
base address is know, an attacker can pepare a "return-oriented program" to
invoke arbitrary code in the target process. That defeats the benefits of ASLR.

The purpose of ASLRX is to eliminate (or extremely frustrate) such attack
vectors. It works by randomizing the _contents_ of an image, not just its base
address. Thus, even if an attacker is able to deduce the address of a single
function, it (alone) will not tell him the address of other functions in the
image.

An attacker must either deduce each target function individually, or
deduce a large number of functions to enable a high probability of inference. In
either case, the difficult of scucess, the length of time required to
perform an attack, and the
probability of early detection are all increased. Future versions of
ASLRX may also
add the ability to dynamically re-randomize an image as it is running, thus
enabling such attacks to be thwarted without taking target systems offline.
Hardened stack smashing prevention is also possible.

How Does It Work?
==============================

ASLRX works using a technique know as Software Dynamic Translation, or SDT. It
"rewrites" executables as they are running, in a manner similar to a JIT
compiler. However, instead of translating from an IR to native code (as in a JIT
compiler), or between CPU architectures (as in typical SDT systems), its source
and target languages are the same (X64 machine code).

When an image is loaded under ASLRX, it's executable code is not loaded into the
process. Instead, functions are inserted into the process, on demand, as they
are first executed, into random locations within random pages. Function calls
(and other symbolic references to addresses in other functions) are initially
translated into system calls. When the system calls are executed, the kernel
ensures the target address is loaded into the process (at a random location),
and then modifies the call site to reference the address of the translated
function.

The kernel based SDT scheme offers several advantages:

1. Both the meta-data used to perform translation, and the translation code, is
not accessible to user space. This increases the difficulty of attacks on the
translation infrastructure itself.

2. Given suitable meta-data, arbitrarily complex rewrites are possible. For
example, code can be modified to maintain a shadow stack of return
addresses. This enables dynamic re-randomization of images (the shadow stack can
be walked to cleanup return addresses), and could be used to detect buffer
overruns. Together, they could be used to support self-healing processes. For
example, upon detection of a buffer-overrun, the kernel could re-randomize a
process. This would require substantial compiler support and is not supported in
V1 of ASLRX, however.

Goals
==============================

1. To be both backwards and forwards compatible. Executables compiled to support
ASLRX can run on kernels that don't support it (or even know it exists), or can
run with ASLRX disabled. In that case, they will simply just not receive the
added security benefits. Programs that run under a particular version of ASLRX
will run under all later versions of ASLRX. New features that extend the
capabilities of ASLRX should, wherever possible, be written in a way that
programs may gracefully degrade to run successfully under older versions of
ASLRX.

2. To not require explicit compiler support. Someone wishing to take advantage
of ASLRX will not need to upgrade their compiler, or rewrite their build
scripts. The meta-data needed by ASLRX can be generated by simply instrumenting
the build process, provided that reasonably recent versions of gcc and the gnu
build tools are used. That is, an ASLRX compatible binary can be generated by
running "aslrx_build make" in place of "make". Features requiring explicit
compiler support (such as re-randomization of running processes) may be added in
future releases, however.

3. To require programs to opt-in to ASLRX. Using ASLRX involves a
trade off. Programs running under it will sacrifice some run-time performance
for the benefit of improved security. That trade off should be an explicit one,
made by the user.

4. To minimize the performance impact of ASLRX. Although a C program run with
ASLRX enabled will be faster than a C program run with ASLRX disabled, it should
still be significantly faster than a comparable JAVA program, for example.

Non-Goals
==============================

1. ASLRX does not support all ARBITRARY executables. There are lots of things
"clever" programs can do that would confuse ASLRX, such as self modifying code
and jumping into the middle of instructions. We are interested in supporting
"ordinary" programs produced by typical compilers such as GCC.

Please note that some of these limitations are due to performance
concerns. Traditional SDT techniques are more than capable of handling
self-modifying code. However, they do that by generating code at
"basic block boundaries", usually with some sort of cache to avoid
excessive regeneration.

To support its security objectives, ASLRX does it rewriting inside the kernel.
The running process does not have write access to the adress space. This means
that each time a chunk of code needs to be translated, a system call must be
executed. If this was done on every branch or function call taken inside a
process, the system's performance would suffer tremendously.

As a result, ASLRX only triggers such system calls at "symbolic code
reference sites*", and only at the first time such a site is executed (the
system calls fixup the code to run the image). This provides a good trade-off
between performance and security. Initialization costs are amortized (code is
only translated when it's needed), and overhead is only paid once. Any "hot"
code paths will run at "native" speeds. Calls will just be calls, not syscalls.

*These sites (even those that are not call instructions), can be inferred by
parsing the output of assembly listing files produced by "as" when an image
is built. When combined with linker maps, this information can be used to
generate metadata suitable for differentiating between symbolic  addresses and
immediate values in machine code.

2. We will not support all Linux hardware platforms. V1 of ASLRX will only
support X64. Support for other platforms may be added later.

3. We do not allow "mixed" images, where some portions of the text segment of an
image can be "rewritten" by ASLRX and other portions cannot. Although a process
may load both ASLRX enabled and ASLRX disabled images, within a given image all
executable code must support ASLRX. When an image is loaded under ASLRX, it's
raw executable pages will NOT be loaded into the process.

4. ASLRX does not randomize the contents of non-executable pages. Generally, we
assume that it is safe to relocate functions, provided that any necessary
symbolic references are cleaned up (and are willing to not support programs that
do not fit that model). This does not hold for data, however. Safely randomizing
data sections requires knowledge that can't be inferred by simply consulting
build artifacts such as assembly listing files, linker maps, and object-file
symbol tables (which is how function boundaries and symbolic code references are
inferred by aslrx_build).

For example, some compilers will use various linker tricks to allow symbols in
separate object files to be combined into a single table in the final executable
image. These techniques are often used to support features such as:

    a. Initialization of "static" variables in C++.
    b. Thread local storage.
    c. Exception handlers.

They require certain symbols to placed near each other. Properly supporting
randomizing data sections would require additional meta-data to be supplied
directly by the compiler, and would likely require explicit linker support. In
some cases it may even requires additional source-language features. As a
result, adding proper support for randomizing the contents of data sections is
outside the scope of ASLRX V1.

5. ASLRX may not properly support undocumented or brand-new CPU
instructions. When aslrx_build constructs meta-data for an image, it will embed
a "minimum version number" into the image based on the instructions
it has encountered. Similarly, it will also reject images that contain
instructions it does not understand.

At run-time, ASLRX will only load an image if the version of ASLRX in the kernel
is >= an image's "minimum required version". Such programs may still be run with
ASLRX disabled, however, and can take advantage of "traditional" ASLR. Also,
aside from instruction support, use of newer ASLRX features will not typically
trigger higher "minimum version numbers". Instead, such features will usually be
designed to degrade gracefully on older systems. Both forward and backwards
compatibility are large goals of ASLRX.

Meta-data
==============================

To function, ASLRX requires additional meta-data to be included in an executable
image. In particular:

1. The start address and size of every function in the image.
2. The location and "formula" of all symbolic references in an image. For V1,
this will be limited to references in the text section.

This is mainly because absent such meta-data, the kernel would not be able to
produce disassembly of a sufficiently high quality to support the re-writing
necessary to randomize executable contents at run-time.

aslrx_build
==============================

aslrx_build is a suite of user-space tools that can be used to automatically
infer the necessary meta-data for programs built using gcc and the gnu
bin-utils. It works by intercepting all processes launched by a build script
(transitively), instrumenting invocations of 'as', and 'ld', modifying their
command lines to produce additional artifacts (listing files, linker maps, etc),
and then analyzing the results.

Status
==============================

Currently, there's not much implemented. In particular, all I've written so far
is this README, and a few stub system calls.
