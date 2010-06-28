Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0F2CWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 22:22:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:57045 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab0F2CWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 22:22:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,501,1272870000"; 
   d="scan'208";a="634467491"
From: ling.ma@intel.com
To: mingo@elte.hu
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Ma Ling <ling.ma@intel.com>
Subject: [PATCH RFC] [X86] Optimize memcpy by avoiding memory false dependece
Date: Tue, 29 Jun 2010 03:24:25 +0800
Message-Id: <1277753065-18610-1-git-send-email-ling.ma@intel.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ma Ling <ling.ma@intel.com>

All read operations after allocation stage can run speculatively,
all write operation will run in program order, and if addresses are
different read may run before older write operation, otherwise wait
until write commit. However CPU don't check each address bit,
so read could fail to recognize different address even they
are in different page.For example if rsi is 0xf004, rdi is 0xe008,
in following operation there will generate big performance latency.
1. movq (%rsi),	%rax
2. movq %rax,	(%rdi)
3. movq 8(%rsi), %rax
4. movq %rax,	8(%rdi)

If %rsi and rdi were in really the same meory page, there are TRUE
read-after-write dependence because instruction 2 write 0x008 and 
instruction 3 read 0x00c, the two address are overlap partially.
Actually there are in different page and no any issues,
but without checking each address bit CPU could think they are
in the same page, and instruction 3 have to wait for instruction 2
to write data into cache from write buffer, then load data from cache,
the cost time read spent is equal to mfence instruction. We may avoid it by
tuning operation sequence as follow.

1. movq 8(%rsi), %rax
2. movq %rax,	8(%rdi)
3. movq (%rsi),	%rax
4. movq %rax,	(%rdi)

Instruction 3 read 0x004, instruction 2 write address 0x010, no any dependence.
At last on Core2 we gain 1.83x speedup compared with original instruction sequence.
In this patch we first handle small size(less 20bytes), then jump to
different copy mode. Based on our micro-benchmark small bytes from 1 to 127 bytes,
we got up to 2X improvement, and up to 1.5X improvement for 1024 bytes on Corei7.
(We use our micro-benchmark, and will do further test according to your requirment)

Thanks
Ling

---
 arch/x86/lib/memcpy_64.S |  158 ++++++++++++++++++++++++++++++----------------
 1 files changed, 103 insertions(+), 55 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index f82e884..5902438 100644
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
+ 	cmpl $0, %edx
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
-- 
1.6.5.2

