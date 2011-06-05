Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab1FEPvi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 11:51:38 -0400
Received: from science.horizon.com ([71.41.210.146]:31566 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755600Ab1FEPvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 11:51:33 -0400
Date: 5 Jun 2011 11:51:32 -0400
Message-ID: <20110605155132.15623.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: james.dutton@gmail.com, linux@horizon.com
Subject: Re: How to measure enable_kernel_fpu overhead?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTimyCodUvBUEVUJcb8TALF5x3H3UEQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What primitives are you working on?

An implmenetation of Dan Bernstein's ChaCha stream cipher/CPRNG.
It's an improved version of the Salsa20 cipher that's already there,
tweaked to fit into SSE registers even better.

It uses a 4x4 array of 32-bit words, and does everything to 4 words
in parallel.  The mapping to SSE is pretty obvious.

> Can you post your source code to the list?

If you like.  It's not in kernel form yet, since I developed it in
user space.  And half of it is very similar to Dan Bernstein's sample
implementation at http://cr.yp.to/chacha.html

(The code sequences are very similar; I didn't use his
%.q -> %.s preprocessor.)

I did manage two MMX implementations that are quite different from his
code, faster than the SSE code on some processors which support both,
and I already sent those to him.

But it's all a bit voluminous and, as I said, currently in the form of
a user-space timing test harness.  I haven't added the <linux/linkage.h>
and <asm/asm.h> macros yet.

It was while trying to convert it to fit into the kernel that I realized
that the code selection harness was going to be a bit tricky...


Here's the MMX code, which is actually novel.  As I said, it is Not Ready
For Submission yet.  The 4x4 state array is divided into 4 rows, A through
D, which are divided into two halves, A0 and A1.  T are temporaries.

The first version has more spills, but parallelism is easier to find.
The second has fewer spills, but requires much more aggressive
OOO scheduling to find the paralleism.

==8<== chacha1.S ==8<==
#define AC0 %mm0
#define AC1 %mm1
#define B0 %mm2
#define B1 %mm3
#define D0 %mm4
#define D1 %mm5
#define T0 %mm6
#define T1 %mm7

# A and C get stack slots
#define A0 (%esp)
#define A1 8(%esp)
#define C0 16(%esp)
#define C1 24(%esp)

.set ROUNDS, 12

# The basic quarter round.  Pairable starting with U or V.
.macro OP x0, x1, st0, st1, z0, z1, k, ld0, ld1, y0=AC0, y1=AC1, t0=T0, t1=T1
	paddd	\z0, \y0
	paddd	\z1, \y1
	pxor	\y0, \x0
	pxor	\y1, \x1
	movq	\y0, \st0
	movq	\y1, \st1
	movq	\x0, \t0
	movq	\x1, \t1
	pslld	$\k, \x0
	pslld	$\k, \x1
	psrld	$(32-(\k)), \t0
	psrld	$(32-(\k)), \t1
	movq	\ld0, \y0
	movq	\ld1, \y1
	por	\t0, \x0
	por	\t1, \x1
.endm

# Quarter round with rotate before store.  Also pairable.
.macro OP_ROTW x0, x1, st0, st1, z0, z1, k, ld0, ld1, y0=AC0, y1=AC1, t0=T0, t1=T1
	paddd	\z0, \y0
	paddd	\z1, \y1
	punpckldq	\y0, \t1
	pxor	\y0, \x0
	punpckhdq	\y0, \y0
	pxor	\y1, \x1
	punpckldq	\y1, \y0
	movq	\x0, \t0
	punpckhdq	\t1, \y1
	movq	\x1, \t1
	movq	\y0, \st0
	movq	\y1, \st1
	pslld	$\k, \x0
	pslld	$\k, \x1
	psrld	$(32-(\k)), \t0
	psrld	$(32-(\k)), \t1
	movq	\ld0, \y0
	movq	\ld1, \y1
	por	\t0, \x0
	por	\t1, \x1
.endm

# Rotate MMX register pair right by 32 bits
# The words of y:x are 3:2:1:0, rotate right to 0:3:2:1
# Little-endian, that's 0123 -> 1230
# Combine with swap halves to rotate left
.macro ROTW x, y, t
	punpckldq	\x, \t	# Destination's value not important
	punpckhdq	\x, \x	# Source (!) not important
	punpckldq	\y, \x
	punpckhdq	\t, \y
.endm

	.text
	.globl	chacha1
	.type	chacha1, @function
# Arguments are key (%eax), iv (%edx), out (%ecx)
chacha1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset %ebp, -8

	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset %ebx, -12

	subl	$36, %esp
	.cfi_def_cfa_offset 48

	movq	sigma,AC0
	movq	sigma+8,AC1
	movq	(%eax),B0
	movq	8(%eax),B1
	movq	16(%eax),T0
	movq	24(%eax),T1
	movq	(%edx),D0
	movq	8(%edx),D1
	movl	$ROUNDS/2, %ebx
	movq	T0,C0
	movq	T1,C1
1:
	OP	D0, D1, A0, A1, B0, B1, 16, C0, C1
	OP	B0, B1, C0, C1, D0, D1, 12, A0, A1
	OP_ROTW	D0, D1, A1, A0, B0, B1,  8, C0, C1	# Swap A
	OP_ROTW	B0, B1, C0, C1, D0, D1,  7, A0, A1

	OP	D1, D0, A0, A1, B0, B1, 16, C0, C1
	OP	B0, B1, C0, C1, D1, D0, 12, A0, A1
	OP_ROTW	D1, D0, A0, A1, B0, B1,  8, C0, C1
	decl	%ebx
	OP_ROTW	B0, B1, C1, C0, D1, D0,  7, A0, A1	# Swap C

	jne	1b

	movq	C0,T0
	movq	C1,T1
# Add the input back to make it irreversible
	paddd	sigma, AC0
	paddd	sigma+8, AC1
	paddd	(%eax),B0
	paddd	8(%eax),B1
	paddd	16(%eax),T0
	paddd	24(%eax),T1
	paddd	(%edx),D0
	paddd	8(%edx),D1
# And store out.
	movq	AC0,(%ecx)
	movq	AC1,8(%ecx)
	movq	B0,16(%ecx)
	movq	B1,24(%ecx)
	movq	T0,32(%ecx)
	movq	T1,40(%ecx)
	movq	D0,48(%ecx)
	movq	D1,56(%ecx)

	addl	$36, %esp
	.cfi_def_cfa_offset 28
	popl	%ebx
	.cfi_def_cfa_offset 8
	.cfi_restore %ebx
	popl	%ebp
	.cfi_def_cfa_offset 4
	.cfi_restore %ebp
	ret
	.cfi_endproc
	.size	chacha1, .-chacha1
==8<== chacha2.S ==8<==
# This MMX code relies on out-of-order execution for parallelism.
# As coded, there is very little parallelism, but if the processor
# looks ahead past a group of 4 OPs (24 instructions!), it will find
# a second group with no data dependencies.
#
# It is not suitable for an in-order dual-issue machine like Pentium MMX.

#define A0 %mm0
#define A1 %mm1
#define B0 %mm2
#define B1 %mm3
#define C0 %mm4
#define C1 %mm5
#define D  %mm6
#define T  %mm7

# Stack slots
#define D0 (%esp)
#define D1 8(%esp)

.set ROUNDS, 12

# Bitwise rotate left
.macro ROTL x, k, t=T
        movq    \x, \t
        pslld   $\k, \x
        psrld   $(32-(\k)), \t
        por     \t, \x
.endm

# Q: Can I do a bitwise 16-bit rotate using
# pack & unpack?  Not in 3 instructions or less, it
# seems...
# Want to start with 0x1111222233334444, end with 0x2222111144443333.
# punpckhwd would need inputs 0x22224444xxxxxxxx & 0x11113333xxxxxxxx.
# packus requires the high halves be cleared first, which is too much....
# The basic quarter round
.macro OP x, y, z, k, t=T
        paddd   \z, \y
        pxor    \y, \x
	ROTL	\x, \k, \t
.endm

# The same, plus load \z after using it
.macro OP_LD x, y, z, k, mem, t=T
        paddd   \z, \y
	movq	\mem,\z
        pxor    \y, \x
	ROTL	\x, \k, \t
.endm


# Rotate words right 32 bits
# The words of y:x are 3:2:1:0, rotate right to 0:3:2:1
# Little-endian, that's 0123 -> 1230
.macro ROTW l, r, t=T
	punpckldq	\l, \t
	punpckhdq	\l, \l
	punpckldq	\r, \l
	punpckhdq	\t, \r
.endm

# OP + ROTW
.macro OP_ROTW x, y, z, k, l, r, t=T
        paddd   \z, \y
	punpckldq	\l, \t
	punpckhdq	\l, \l
        pxor    \y, \x
	punpckldq	\r, \l
	punpckhdq	\t, \r
	ROTL	\x, \k, \t
.endm

	.text
	.globl	chacha2
	.type	chacha2, @function
# Arguments are key (%eax), iv (%edx), out (%ecx)
chacha2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset %ebp, -8

	pushl	%ebx
	.cfi_def_cfa_offset 12
	.cfi_offset %ebx, -12

	subl	$20, %esp
	.cfi_def_cfa_offset 32

	movq	sigma,A0
	movq	sigma+8,A1
	movq	(%eax),B0
	movq	8(%eax),B1
	movq	16(%eax),C0
	movq	24(%eax),C1
	movq	(%edx),D
	movq	8(%edx),T
	movl	$ROUNDS/4, %ebx
	movq	T,D1
1:
	decl	%ebx

	OP	D, A0, B0, 16
	OP	B0, C0, D, 12
	OP	D, A0, B0,  8
	movq	D,D0
	OP_LD	B0, C0, D,  7, D1

	OP	D, A1, B1, 16
	OP	B1, C1, D, 12
	OP	D, A1, B1,  8
	OP_ROTW	B1, C1, D,  7, A1, A0

	/* Swap halves of A and D (i.e. don't reload D) */

	OP_ROTW	D, A1, B0, 16, C0, C1
	OP	B0, C0, D, 12
	OP	D, A1, B0,  8
	movq	D,D1
	OP_LD	B0, C0, D,  7, D0

	OP	D, A0, B1, 16
	OP	B1, C1, D, 12
	OP	D, A0, B1,  8
	OP_ROTW	B1, C1, D,  7, A1, A0

	/* Now A and C are swapped */

	OP_ROTW	D, A1, B0, 16, C1, C0
	OP	B0, C1, D, 12
	OP	D, A1, B0,  8
	movq	D, D0
	OP_LD	B0, C1, D,  7, D1

	OP	D, A0, B1, 16
	OP	B1, C0, D, 12
	OP	D, A0, B1,  8
	OP_ROTW	B1, C0, D,  7, A0, A1

	/* Now C and D are swapped */

	OP_ROTW	D, A0, B0, 16, C1, C0
	OP	B0, C1, D, 12
	OP	D, A0, B0,  8
	movq	D,D1
	OP_LD	B0, C1, D,  7, D0

	OP	D, A1, B1, 16
	OP	B1, C0, D, 12
	OP	D, A1, B1,  8
	OP_ROTW	B1, C0, D,  7, A0, A1

	ROTW	C0, C1

	jne	1b

	movq	D1,T
        paddd   sigma, A0
        paddd   sigma+8, A1
	paddd	(%eax),B0
	paddd	8(%eax),B1
	paddd	16(%eax),C0
	paddd	24(%eax),C1
	paddd	(%edx),D
	paddd	8(%edx),T

	movq	A0,(%ecx)
	movq	A1,8(%ecx)
	movq	B0,16(%ecx)
	movq	B1,24(%ecx)
	movq	C0,32(%ecx)
	movq	C1,40(%ecx)
	movq	D,48(%ecx)
	movq	T,56(%ecx)

	addl	$20, %esp
	.cfi_def_cfa_offset 12
	popl	%ebx
	.cfi_def_cfa_offset 8
	.cfi_restore %ebx
	popl	%ebp
	.cfi_def_cfa_offset 4
	.cfi_restore %ebp
	ret
	.cfi_endproc
	.size	chacha2, .-chacha2
==8<== END ==8<==
