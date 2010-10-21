Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab0JUNwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:52:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54213 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187Ab0JUNwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:52:18 -0400
Date: Thu, 21 Oct 2010 15:52:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mem for v2.6.37
Message-ID: <20101021135209.GA7051@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mem-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mem-for-linus

 Thanks,

	Ingo

------------------>
Ma Ling (2):
      x86, mem: Optimize memcpy by avoiding memory false dependece
      x86, mem: Optimize memmove for small size and unaligned cases

Ma, Ling (1):
      x86, mem: Don't implement forward memmove() as memcpy()


 arch/x86/lib/memcpy_32.c  |  199 +++++++++++++++++++++++++++++++++++++++++----
 arch/x86/lib/memcpy_64.S  |  158 +++++++++++++++++++++++-------------
 arch/x86/lib/memmove_64.c |  189 ++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 465 insertions(+), 81 deletions(-)

diff --git a/arch/x86/lib/memcpy_32.c b/arch/x86/lib/memcpy_32.c
index 5415a9d..b908a59 100644
--- a/arch/x86/lib/memcpy_32.c
+++ b/arch/x86/lib/memcpy_32.c
@@ -22,22 +22,187 @@ EXPORT_SYMBOL(memset);
 
 void *memmove(void *dest, const void *src, size_t n)
 {
-	int d0, d1, d2;
-
-	if (dest < src) {
-		memcpy(dest, src, n);
-	} else {
-		__asm__ __volatile__(
-			"std\n\t"
-			"rep\n\t"
-			"movsb\n\t"
-			"cld"
-			: "=&c" (d0), "=&S" (d1), "=&D" (d2)
-			:"0" (n),
-			 "1" (n-1+src),
-			 "2" (n-1+dest)
-			:"memory");
-	}
-	return dest;
+	int d0,d1,d2,d3,d4,d5;
+	char *ret = dest;
+
+	__asm__ __volatile__(
+		/* Handle more 16bytes in loop */
+		"cmp $0x10, %0\n\t"
+		"jb	1f\n\t"
+
+		/* Decide forward/backward copy mode */
+		"cmp %2, %1\n\t"
+		"jb	2f\n\t"
+
+		/*
+		 * movs instruction have many startup latency
+		 * so we handle small size by general register.
+		 */
+		"cmp  $680, %0\n\t"
+		"jb 3f\n\t"
+		/*
+		 * movs instruction is only good for aligned case.
+		 */
+		"mov %1, %3\n\t"
+		"xor %2, %3\n\t"
+		"and $0xff, %3\n\t"
+		"jz 4f\n\t"
+		"3:\n\t"
+		"sub $0x10, %0\n\t"
+
+		/*
+		 * We gobble 16byts forward in each loop.
+		 */
+		"3:\n\t"
+		"sub $0x10, %0\n\t"
+		"mov 0*4(%1), %3\n\t"
+		"mov 1*4(%1), %4\n\t"
+		"mov  %3, 0*4(%2)\n\t"
+		"mov  %4, 1*4(%2)\n\t"
+		"mov 2*4(%1), %3\n\t"
+		"mov 3*4(%1), %4\n\t"
+		"mov  %3, 2*4(%2)\n\t"
+		"mov  %4, 3*4(%2)\n\t"
+		"lea  0x10(%1), %1\n\t"
+		"lea  0x10(%2), %2\n\t"
+		"jae 3b\n\t"
+		"add $0x10, %0\n\t"
+		"jmp 1f\n\t"
+
+		/*
+		 * Handle data forward by movs.
+		 */
+		".p2align 4\n\t"
+		"4:\n\t"
+		"mov -4(%1, %0), %3\n\t"
+		"lea -4(%2, %0), %4\n\t"
+		"shr $2, %0\n\t"
+		"rep movsl\n\t"
+		"mov %3, (%4)\n\t"
+		"jmp 11f\n\t"
+		/*
+		 * Handle data backward by movs.
+		 */
+		".p2align 4\n\t"
+		"6:\n\t"
+		"mov (%1), %3\n\t"
+		"mov %2, %4\n\t"
+		"lea -4(%1, %0), %1\n\t"
+		"lea -4(%2, %0), %2\n\t"
+		"shr $2, %0\n\t"
+		"std\n\t"
+		"rep movsl\n\t"
+		"mov %3,(%4)\n\t"
+		"cld\n\t"
+		"jmp 11f\n\t"
+
+		/*
+		 * Start to prepare for backward copy.
+		 */
+		".p2align 4\n\t"
+		"2:\n\t"
+		"cmp  $680, %0\n\t"
+		"jb 5f\n\t"
+		"mov %1, %3\n\t"
+		"xor %2, %3\n\t"
+		"and $0xff, %3\n\t"
+		"jz 6b\n\t"
+
+		/*
+		 * Calculate copy position to tail.
+		 */
+		"5:\n\t"
+		"add %0, %1\n\t"
+		"add %0, %2\n\t"
+		"sub $0x10, %0\n\t"
+
+		/*
+		 * We gobble 16byts backward in each loop.
+		 */
+		"7:\n\t"
+		"sub $0x10, %0\n\t"
+
+		"mov -1*4(%1), %3\n\t"
+		"mov -2*4(%1), %4\n\t"
+		"mov  %3, -1*4(%2)\n\t"
+		"mov  %4, -2*4(%2)\n\t"
+		"mov -3*4(%1), %3\n\t"
+		"mov -4*4(%1), %4\n\t"
+		"mov  %3, -3*4(%2)\n\t"
+		"mov  %4, -4*4(%2)\n\t"
+		"lea  -0x10(%1), %1\n\t"
+		"lea  -0x10(%2), %2\n\t"
+		"jae 7b\n\t"
+		/*
+		 * Calculate copy position to head.
+		 */
+		"add $0x10, %0\n\t"
+		"sub %0, %1\n\t"
+		"sub %0, %2\n\t"
+
+		/*
+		 * Move data from 8 bytes to 15 bytes.
+		 */
+		".p2align 4\n\t"
+		"1:\n\t"
+		"cmp $8, %0\n\t"
+		"jb 8f\n\t"
+		"mov 0*4(%1), %3\n\t"
+		"mov 1*4(%1), %4\n\t"
+		"mov -2*4(%1, %0), %5\n\t"
+		"mov -1*4(%1, %0), %1\n\t"
+
+		"mov  %3, 0*4(%2)\n\t"
+		"mov  %4, 1*4(%2)\n\t"
+		"mov  %5, -2*4(%2, %0)\n\t"
+		"mov  %1, -1*4(%2, %0)\n\t"
+		"jmp 11f\n\t"
+
+		/*
+		 * Move data from 4 bytes to 7 bytes.
+		 */
+		".p2align 4\n\t"
+		"8:\n\t"
+		"cmp $4, %0\n\t"
+		"jb 9f\n\t"
+		"mov 0*4(%1), %3\n\t"
+		"mov -1*4(%1, %0), %4\n\t"
+		"mov  %3, 0*4(%2)\n\t"
+		"mov  %4, -1*4(%2, %0)\n\t"
+		"jmp 11f\n\t"
+
+		/*
+		 * Move data from 2 bytes to 3 bytes.
+		 */
+		".p2align 4\n\t"
+		"9:\n\t"
+		"cmp $2, %0\n\t"
+		"jb 10f\n\t"
+		"movw 0*2(%1), %%dx\n\t"
+		"movw -1*2(%1, %0), %%bx\n\t"
+		"movw %%dx, 0*2(%2)\n\t"
+		"movw %%bx, -1*2(%2, %0)\n\t"
+		"jmp 11f\n\t"
+
+		/*
+		 * Move data for 1 byte.
+		 */
+		".p2align 4\n\t"
+		"10:\n\t"
+		"cmp $1, %0\n\t"
+		"jb 11f\n\t"
+		"movb (%1), %%cl\n\t"
+		"movb %%cl, (%2)\n\t"
+		".p2align 4\n\t"
+		"11:"
+		: "=&c" (d0), "=&S" (d1), "=&D" (d2),
+		  "=r" (d3),"=r" (d4), "=r"(d5)
+		:"0" (n),
+		 "1" (src),
+		 "2" (dest)
+		:"memory");
+
+	return ret;
+
 }
 EXPORT_SYMBOL(memmove);
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index bcbcd1e..75ef61e 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -40,84 +40,132 @@
 ENTRY(__memcpy)
 ENTRY(memcpy)
 	CFI_STARTPROC
+	movq %rdi, %rax
 
 	/*
-	 * Put the number of full 64-byte blocks into %ecx.
-	 * Tail portion is handled at the end:
+	 * Use 32bit CMP here to avoid long NOP padding.
 	 */
-	movq %rdi, %rax
-	movl %edx, %ecx
-	shrl   $6, %ecx
-	jz .Lhandle_tail
+	cmp  $0x20, %edx
+	jb .Lhandle_tail
 
-	.p2align 4
-.Lloop_64:
 	/*
-	 * We decrement the loop index here - and the zero-flag is
-	 * checked at the end of the loop (instructions inbetween do
-	 * not change the zero flag):
+	 * We check whether memory false dependece could occur,
+	 * then jump to corresponding copy mode.
 	 */
-	decl %ecx
+	cmp  %dil, %sil
+	jl .Lcopy_backward
+	subl $0x20, %edx
+.Lcopy_forward_loop:
+	subq $0x20,	%rdx
 
 	/*
-	 * Move in blocks of 4x16 bytes:
+	 * Move in blocks of 4x8 bytes:
 	 */
-	movq 0*8(%rsi),		%r11
-	movq 1*8(%rsi),		%r8
-	movq %r11,		0*8(%rdi)
-	movq %r8,		1*8(%rdi)
-
-	movq 2*8(%rsi),		%r9
-	movq 3*8(%rsi),		%r10
-	movq %r9,		2*8(%rdi)
-	movq %r10,		3*8(%rdi)
-
-	movq 4*8(%rsi),		%r11
-	movq 5*8(%rsi),		%r8
-	movq %r11,		4*8(%rdi)
-	movq %r8,		5*8(%rdi)
-
-	movq 6*8(%rsi),		%r9
-	movq 7*8(%rsi),		%r10
-	movq %r9,		6*8(%rdi)
-	movq %r10,		7*8(%rdi)
-
-	leaq 64(%rsi), %rsi
-	leaq 64(%rdi), %rdi
-
-	jnz  .Lloop_64
+	movq 0*8(%rsi),	%r8
+	movq 1*8(%rsi),	%r9
+	movq 2*8(%rsi),	%r10
+	movq 3*8(%rsi),	%r11
+	leaq 4*8(%rsi),	%rsi
+
+	movq %r8,	0*8(%rdi)
+	movq %r9,	1*8(%rdi)
+	movq %r10,	2*8(%rdi)
+	movq %r11,	3*8(%rdi)
+	leaq 4*8(%rdi),	%rdi
+	jae  .Lcopy_forward_loop
+	addq $0x20,	%rdx
+	jmp  .Lhandle_tail
+
+.Lcopy_backward:
+	/*
+	 * Calculate copy position to tail.
+	 */
+	addq %rdx,	%rsi
+	addq %rdx,	%rdi
+	subq $0x20,	%rdx
+	/*
+	 * At most 3 ALU operations in one cycle,
+	 * so append NOPS in the same 16bytes trunk.
+	 */
+	.p2align 4
+.Lcopy_backward_loop:
+	subq $0x20,	%rdx
+	movq -1*8(%rsi),	%r8
+	movq -2*8(%rsi),	%r9
+	movq -3*8(%rsi),	%r10
+	movq -4*8(%rsi),	%r11
+	leaq -4*8(%rsi),	%rsi
+	movq %r8,		-1*8(%rdi)
+	movq %r9,		-2*8(%rdi)
+	movq %r10,		-3*8(%rdi)
+	movq %r11,		-4*8(%rdi)
+	leaq -4*8(%rdi),	%rdi
+	jae  .Lcopy_backward_loop
 
+	/*
+	 * Calculate copy position to head.
+	 */
+	addq $0x20,	%rdx
+	subq %rdx,	%rsi
+	subq %rdx,	%rdi
 .Lhandle_tail:
-	movl %edx, %ecx
-	andl  $63, %ecx
-	shrl   $3, %ecx
-	jz   .Lhandle_7
+	cmpq $16,	%rdx
+	jb   .Lless_16bytes
 
+	/*
+	 * Move data from 16 bytes to 31 bytes.
+	 */
+	movq 0*8(%rsi), %r8
+	movq 1*8(%rsi),	%r9
+	movq -2*8(%rsi, %rdx),	%r10
+	movq -1*8(%rsi, %rdx),	%r11
+	movq %r8,	0*8(%rdi)
+	movq %r9,	1*8(%rdi)
+	movq %r10,	-2*8(%rdi, %rdx)
+	movq %r11,	-1*8(%rdi, %rdx)
+	retq
 	.p2align 4
-.Lloop_8:
-	decl %ecx
-	movq (%rsi),		%r8
-	movq %r8,		(%rdi)
-	leaq 8(%rdi),		%rdi
-	leaq 8(%rsi),		%rsi
-	jnz  .Lloop_8
-
-.Lhandle_7:
-	movl %edx, %ecx
-	andl $7, %ecx
-	jz .Lend
+.Lless_16bytes:
+	cmpq $8,	%rdx
+	jb   .Lless_8bytes
+	/*
+	 * Move data from 8 bytes to 15 bytes.
+	 */
+	movq 0*8(%rsi),	%r8
+	movq -1*8(%rsi, %rdx),	%r9
+	movq %r8,	0*8(%rdi)
+	movq %r9,	-1*8(%rdi, %rdx)
+	retq
+	.p2align 4
+.Lless_8bytes:
+	cmpq $4,	%rdx
+	jb   .Lless_3bytes
 
+	/*
+	 * Move data from 4 bytes to 7 bytes.
+	 */
+	movl (%rsi), %ecx
+	movl -4(%rsi, %rdx), %r8d
+	movl %ecx, (%rdi)
+	movl %r8d, -4(%rdi, %rdx)
+	retq
 	.p2align 4
+.Lless_3bytes:
+	cmpl $0, %edx
+	je .Lend
+	/*
+	 * Move data from 1 bytes to 3 bytes.
+	 */
 .Lloop_1:
 	movb (%rsi), %r8b
 	movb %r8b, (%rdi)
 	incq %rdi
 	incq %rsi
-	decl %ecx
+	decl %edx
 	jnz .Lloop_1
 
 .Lend:
-	ret
+	retq
 	CFI_ENDPROC
 ENDPROC(memcpy)
 ENDPROC(__memcpy)
diff --git a/arch/x86/lib/memmove_64.c b/arch/x86/lib/memmove_64.c
index 0a33909..6d0f0ec 100644
--- a/arch/x86/lib/memmove_64.c
+++ b/arch/x86/lib/memmove_64.c
@@ -8,14 +8,185 @@
 #undef memmove
 void *memmove(void *dest, const void *src, size_t count)
 {
-	if (dest < src) {
-		return memcpy(dest, src, count);
-	} else {
-		char *p = dest + count;
-		const char *s = src + count;
-		while (count--)
-			*--p = *--s;
-	}
-	return dest;
+	unsigned long d0,d1,d2,d3,d4,d5,d6,d7;
+	char *ret;
+
+	__asm__ __volatile__(
+		/* Handle more 32bytes in loop */
+		"mov %2, %3\n\t"
+		"cmp $0x20, %0\n\t"
+		"jb	1f\n\t"
+
+		/* Decide forward/backward copy mode */
+		"cmp %2, %1\n\t"
+		"jb	2f\n\t"
+
+		/*
+		 * movsq instruction have many startup latency
+		 * so we handle small size by general register.
+		 */
+		"cmp  $680, %0\n\t"
+		"jb 3f\n\t"
+		/*
+		 * movsq instruction is only good for aligned case.
+		 */
+		"cmpb %%dil, %%sil\n\t"
+		"je 4f\n\t"
+		"3:\n\t"
+		"sub $0x20, %0\n\t"
+		/*
+		 * We gobble 32byts forward in each loop.
+		 */
+		"5:\n\t"
+		"sub $0x20, %0\n\t"
+		"movq 0*8(%1), %4\n\t"
+		"movq 1*8(%1), %5\n\t"
+		"movq 2*8(%1), %6\n\t"
+		"movq 3*8(%1), %7\n\t"
+		"leaq 4*8(%1), %1\n\t"
+
+		"movq %4, 0*8(%2)\n\t"
+		"movq %5, 1*8(%2)\n\t"
+		"movq %6, 2*8(%2)\n\t"
+		"movq %7, 3*8(%2)\n\t"
+		"leaq 4*8(%2), %2\n\t"
+		"jae 5b\n\t"
+		"addq $0x20, %0\n\t"
+		"jmp 1f\n\t"
+		/*
+		 * Handle data forward by movsq.
+		 */
+		".p2align 4\n\t"
+		"4:\n\t"
+		"movq %0, %8\n\t"
+		"movq -8(%1, %0), %4\n\t"
+		"lea -8(%2, %0), %5\n\t"
+		"shrq $3, %8\n\t"
+		"rep movsq\n\t"
+		"movq %4, (%5)\n\t"
+		"jmp 13f\n\t"
+		/*
+		 * Handle data backward by movsq.
+		 */
+		".p2align 4\n\t"
+		"7:\n\t"
+		"movq %0, %8\n\t"
+		"movq (%1), %4\n\t"
+		"movq %2, %5\n\t"
+		"leaq -8(%1, %0), %1\n\t"
+		"leaq -8(%2, %0), %2\n\t"
+		"shrq $3, %8\n\t"
+		"std\n\t"
+		"rep movsq\n\t"
+		"cld\n\t"
+		"movq %4, (%5)\n\t"
+		"jmp 13f\n\t"
+
+		/*
+		 * Start to prepare for backward copy.
+		 */
+		".p2align 4\n\t"
+		"2:\n\t"
+		"cmp $680, %0\n\t"
+		"jb 6f \n\t"
+		"cmp %%dil, %%sil\n\t"
+		"je 7b \n\t"
+		"6:\n\t"
+		/*
+		 * Calculate copy position to tail.
+		 */
+		"addq %0, %1\n\t"
+		"addq %0, %2\n\t"
+		"subq $0x20, %0\n\t"
+		/*
+		 * We gobble 32byts backward in each loop.
+		 */
+		"8:\n\t"
+		"subq $0x20, %0\n\t"
+		"movq -1*8(%1), %4\n\t"
+		"movq -2*8(%1), %5\n\t"
+		"movq -3*8(%1), %6\n\t"
+		"movq -4*8(%1), %7\n\t"
+		"leaq -4*8(%1), %1\n\t"
+
+		"movq %4, -1*8(%2)\n\t"
+		"movq %5, -2*8(%2)\n\t"
+		"movq %6, -3*8(%2)\n\t"
+		"movq %7, -4*8(%2)\n\t"
+		"leaq -4*8(%2), %2\n\t"
+		"jae 8b\n\t"
+		/*
+		 * Calculate copy position to head.
+		 */
+		"addq $0x20, %0\n\t"
+		"subq %0, %1\n\t"
+		"subq %0, %2\n\t"
+		"1:\n\t"
+		"cmpq $16, %0\n\t"
+		"jb 9f\n\t"
+		/*
+		 * Move data from 16 bytes to 31 bytes.
+		 */
+		"movq 0*8(%1), %4\n\t"
+		"movq 1*8(%1), %5\n\t"
+		"movq -2*8(%1, %0), %6\n\t"
+		"movq -1*8(%1, %0), %7\n\t"
+		"movq %4, 0*8(%2)\n\t"
+		"movq %5, 1*8(%2)\n\t"
+		"movq %6, -2*8(%2, %0)\n\t"
+		"movq %7, -1*8(%2, %0)\n\t"
+		"jmp 13f\n\t"
+		".p2align 4\n\t"
+		"9:\n\t"
+		"cmpq $8, %0\n\t"
+		"jb 10f\n\t"
+		/*
+		 * Move data from 8 bytes to 15 bytes.
+		 */
+		"movq 0*8(%1), %4\n\t"
+		"movq -1*8(%1, %0), %5\n\t"
+		"movq %4, 0*8(%2)\n\t"
+		"movq %5, -1*8(%2, %0)\n\t"
+		"jmp 13f\n\t"
+		"10:\n\t"
+		"cmpq $4, %0\n\t"
+		"jb 11f\n\t"
+		/*
+		 * Move data from 4 bytes to 7 bytes.
+		 */
+		"movl (%1), %4d\n\t"
+		"movl -4(%1, %0), %5d\n\t"
+		"movl %4d, (%2)\n\t"
+		"movl %5d, -4(%2, %0)\n\t"
+		"jmp 13f\n\t"
+		"11:\n\t"
+		"cmp $2, %0\n\t"
+		"jb 12f\n\t"
+		/*
+		 * Move data from 2 bytes to 3 bytes.
+		 */
+		"movw (%1), %4w\n\t"
+		"movw -2(%1, %0), %5w\n\t"
+		"movw %4w, (%2)\n\t"
+		"movw %5w, -2(%2, %0)\n\t"
+		"jmp 13f\n\t"
+		"12:\n\t"
+		"cmp $1, %0\n\t"
+		"jb 13f\n\t"
+		/*
+		 * Move data for 1 byte.
+		 */
+		"movb (%1), %4b\n\t"
+		"movb %4b, (%2)\n\t"
+		"13:\n\t"
+		: "=&d" (d0), "=&S" (d1), "=&D" (d2), "=&a" (ret) ,
+		  "=r"(d3), "=r"(d4), "=r"(d5), "=r"(d6), "=&c" (d7)
+		:"0" (count),
+		 "1" (src),
+		 "2" (dest)
+		:"memory");
+
+		return ret;
+
 }
 EXPORT_SYMBOL(memmove);
