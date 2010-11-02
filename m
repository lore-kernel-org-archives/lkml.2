Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab0KBAqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 20:46:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:46206 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab0KBAqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 20:46:06 -0400
Date: Tue, 2 Nov 2010 00:45:25 GMT
From: tip-bot for Ma Ling <ling.ma@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ling.ma@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ling.ma@intel.com, tglx@linutronix.de
In-Reply-To: <1277753065-18610-1-git-send-email-ling.ma@intel.com>
References: <1277753065-18610-1-git-send-email-ling.ma@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] x86, mem: Optimize memcpy by avoiding memory false dependece
Message-ID: <tip-59daa706fbec745684702741b9f5373142dd9fdc@git.kernel.org>
Git-Commit-ID: 59daa706fbec745684702741b9f5373142dd9fdc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Nov 2010 00:45:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59daa706fbec745684702741b9f5373142dd9fdc
Gitweb:     http://git.kernel.org/tip/59daa706fbec745684702741b9f5373142dd9fdc
Author:     Ma Ling <ling.ma@intel.com>
AuthorDate: Tue, 29 Jun 2010 03:24:25 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 23 Aug 2010 14:56:41 -0700

x86, mem: Optimize memcpy by avoiding memory false dependece

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

Instruction 3 read 0x004, instruction 2 write address 0x010, no any
dependence.  At last on Core2 we gain 1.83x speedup compared with
original instruction sequence.  In this patch we first handle small
size(less 20bytes), then jump to different copy mode. Based on our
micro-benchmark small bytes from 1 to 127 bytes, we got up to 2X
improvement, and up to 1.5X improvement for 1024 bytes on Corei7.  (We
use our micro-benchmark, and will do further test according to your
requirment)

Signed-off-by: Ma Ling <ling.ma@intel.com>
LKML-Reference: <1277753065-18610-1-git-send-email-ling.ma@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/lib/memcpy_32.c |    6 +-
 arch/x86/lib/memcpy_64.S |  158 ++++++++++++++++++++++++++++++----------------
 2 files changed, 105 insertions(+), 59 deletions(-)

diff --git a/arch/x86/lib/memcpy_32.c b/arch/x86/lib/memcpy_32.c
index be424df..81130d4 100644
--- a/arch/x86/lib/memcpy_32.c
+++ b/arch/x86/lib/memcpy_32.c
@@ -36,11 +36,9 @@ void *memmove(void *dest, const void *src, size_t n)
 				 "1" (src),
 				 "2" (dest)
 				:"memory");
-
 	} else {
-
-		if((src + count) < dest)
-			return memcpy(dest, src, count);
+		if((src + n) < dest)
+			return memcpy(dest, src, n);
 		else
 			__asm__ __volatile__(
 				"std\n\t"
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
