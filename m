Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2AZPtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 10:49:46 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:28697 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2AZPtp convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 26 Jan 2012 10:49:45 -0500
Message-Id: <4F21846F020000780006F3FA@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 26 Jan 2012 15:50:55 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix memcpy() to support sizes of 4Gb and above
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While currently there doesn't appear to be any reachable in-tree case
where such large memory blocks may be passed to memcpy(), we already
had hit the problem in our Xen kernels. Just like done recently for
mmeset(), rather than working around it, prevent others from falling
into the same trap by fixing this long standing limitation.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/lib/memcpy_64.S |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

--- 3.3-rc1/arch/x86/lib/memcpy_64.S
+++ 3.3-rc1-x86_64-memcpy/arch/x86/lib/memcpy_64.S
@@ -27,9 +27,8 @@
 	.section .altinstr_replacement, "ax", @progbits
 .Lmemcpy_c:
 	movq %rdi, %rax
-
-	movl %edx, %ecx
-	shrl $3, %ecx
+	movq %rdx, %rcx
+	shrq $3, %rcx
 	andl $7, %edx
 	rep movsq
 	movl %edx, %ecx
@@ -48,8 +47,7 @@
 	.section .altinstr_replacement, "ax", @progbits
 .Lmemcpy_c_e:
 	movq %rdi, %rax
-
-	movl %edx, %ecx
+	movq %rdx, %rcx
 	rep movsb
 	ret
 .Lmemcpy_e_e:
@@ -60,10 +58,7 @@ ENTRY(memcpy)
 	CFI_STARTPROC
 	movq %rdi, %rax
 
-	/*
-	 * Use 32bit CMP here to avoid long NOP padding.
-	 */
-	cmp  $0x20, %edx
+	cmpq $0x20, %rdx
 	jb .Lhandle_tail
 
 	/*
@@ -72,7 +67,7 @@ ENTRY(memcpy)
 	 */
 	cmp  %dil, %sil
 	jl .Lcopy_backward
-	subl $0x20, %edx
+	subq $0x20, %rdx
 .Lcopy_forward_loop:
 	subq $0x20,	%rdx
 
@@ -91,7 +86,7 @@ ENTRY(memcpy)
 	movq %r11,	3*8(%rdi)
 	leaq 4*8(%rdi),	%rdi
 	jae  .Lcopy_forward_loop
-	addq $0x20,	%rdx
+	addl $0x20,	%edx
 	jmp  .Lhandle_tail
 
 .Lcopy_backward:
@@ -123,11 +118,11 @@ ENTRY(memcpy)
 	/*
 	 * Calculate copy position to head.
 	 */
-	addq $0x20,	%rdx
+	addl $0x20,	%edx
 	subq %rdx,	%rsi
 	subq %rdx,	%rdi
 .Lhandle_tail:
-	cmpq $16,	%rdx
+	cmpl $16,	%edx
 	jb   .Lless_16bytes
 
 	/*
@@ -144,7 +139,7 @@ ENTRY(memcpy)
 	retq
 	.p2align 4
 .Lless_16bytes:
-	cmpq $8,	%rdx
+	cmpl $8,	%edx
 	jb   .Lless_8bytes
 	/*
 	 * Move data from 8 bytes to 15 bytes.
@@ -156,7 +151,7 @@ ENTRY(memcpy)
 	retq
 	.p2align 4
 .Lless_8bytes:
-	cmpq $4,	%rdx
+	cmpl $4,	%edx
 	jb   .Lless_3bytes
 
 	/*



