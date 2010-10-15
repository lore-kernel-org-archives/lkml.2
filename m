Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab0JNTm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:42:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:25690 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076Ab0JNTm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:42:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,332,1283756400"; 
   d="scan'208";a="667561573"
From: ling.ma@intel.com
To: mingo@elte.hu
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Ma Ling <ling.ma@intel.com>
Subject: [RFC PATCH 2] [X86/mem] Handle unaligned case by avoiding store crossing cache line
Date: Fri, 15 Oct 2010 11:45:42 +0800
Message-Id: <1287114342-6475-1-git-send-email-ling.ma@intel.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ma Ling <ling.ma@intel.com>

In this patch we manage to reduce penalty from crossing cache line
on some CPU archs. There are two crossing-cache-line cases:
read and write, but write is more expensive because of
no cache-way predication and read-for-ownership operations
on some archs, here we avoid sotre unaligned cases,
another reason is shift register will cause more penalty
on decode stages, so tolerate read.

Signed-off-by: Ma Ling <ling.ma@intel.com>
---
In this version we append detail comments.

 arch/x86/lib/memcpy_64.S |   67 ++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 75ef61e..9ec6694 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -43,9 +43,9 @@ ENTRY(memcpy)
 	movq %rdi, %rax
 
 	/*
-	 * Use 32bit CMP here to avoid long NOP padding.
+	 * Use 64bit CMP here to get 16bytes aligned on .Lcopy_forward_loop.
 	 */
-	cmp  $0x20, %edx
+	cmp  $0x28, %rdx
 	jb .Lhandle_tail
 
 	/*
@@ -54,7 +54,23 @@ ENTRY(memcpy)
 	 */
 	cmp  %dil, %sil
 	jl .Lcopy_backward
-	subl $0x20, %edx
+
+	/*
+	 * By overlap writing we force store to handle data
+         * with 8bytes aligned later. After that it never 
+         * cross cache line in one operation because cache line
+         * size should be multiple of 8bytes.
+	 */
+	movq (%rsi), %rcx
+	movq %rdi, %r8
+	addq $8, %rdi
+	andq $-8, %rdi
+	movq %rcx, (%r8)
+	subq %rdi, %r8
+	addq %r8, %rdx
+	subq %r8, %rsi
+	
+	subq $0x20, %rdx
 .Lcopy_forward_loop:
 	subq $0x20,	%rdx
 
@@ -74,20 +90,31 @@ ENTRY(memcpy)
 	leaq 4*8(%rdi),	%rdi
 	jae  .Lcopy_forward_loop
 	addq $0x20,	%rdx
-	jmp  .Lhandle_tail
+	jmp   .Lless_32bytes
 
+	.p2align 4
 .Lcopy_backward:
 	/*
 	 * Calculate copy position to tail.
 	 */
 	addq %rdx,	%rsi
 	addq %rdx,	%rdi
-	subq $0x20,	%rdx
+
 	/*
-	 * At most 3 ALU operations in one cycle,
-	 * so append NOPS in the same 16bytes trunk.
+	 * By overlap writing we force store to handle data
+         * with 8bytes aligned later. After that it never 
+         * cross cache line in one operation because cache line
+         * size should be multiple of 8bytes.
 	 */
-	.p2align 4
+	movq -8(%rsi), %rcx
+	movq %rdi, %r8
+	andq $-8, %rdi
+	movq %rcx, -8(%r8)
+	subq %rdi, %r8
+	subq %r8, %rdx
+	subq %r8, %rsi
+
+	subq $0x20,	%rdx
 .Lcopy_backward_loop:
 	subq $0x20,	%rdx
 	movq -1*8(%rsi),	%r8
@@ -108,7 +135,31 @@ ENTRY(memcpy)
 	addq $0x20,	%rdx
 	subq %rdx,	%rsi
 	subq %rdx,	%rdi
+	jmp   .Lless_32bytes
+
+	.p2align 4
 .Lhandle_tail:
+
+	cmpq $32,	%rdx
+	jb   .Lless_32bytes
+
+	/*
+	 * Move data from 32 bytes to 39 bytes.
+	 */
+	movq 0*8(%rsi), %rcx
+	movq 1*8(%rsi),	%r8
+	movq -3*8(%rsi, %rdx),	%r9
+	movq -2*8(%rsi, %rdx),	%r10
+	movq -1*8(%rsi, %rdx),	%r11
+	movq %rcx,	0*8(%rdi)
+	movq %r8,	1*8(%rdi)
+	movq %r9,	-3*8(%rdi, %rdx)
+	movq %r10,	-2*8(%rdi, %rdx)
+	movq %r11,	-1*8(%rdi, %rdx)
+	retq
+
+	.p2align 4
+.Lless_32bytes:
 	cmpq $16,	%rdx
 	jb   .Lless_16bytes
 
-- 
1.6.5.2

