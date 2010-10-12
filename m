Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab0JLMon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 08:44:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:36741 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169Ab0JLMom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 08:44:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,320,1283756400"; 
   d="scan'208";a="666609301"
From: ling.ma@intel.com
To: mingo@elte.hu
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Ma Ling <ling.ma@intel.com>
Subject: [RFC PATCH] [X86/mem] Handle unaligned case by avoiding store crossing cache line
Date: Wed, 13 Oct 2010 04:48:07 +0800
Message-Id: <1286916487-11967-1-git-send-email-ling.ma@intel.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ma Ling <ling.ma@intel.com>

In this patch we mannage to reduce penalty from crossing cache line
on some CPU archs. There are two crossing-cache-line cases:
read and write, but write is more expensive because of
no cache-way predication and read-for-ownership operations
on some archs, here we avoid sotre unaligned cases,
another reason is shift register will cause more penalty
on decode stages, so tolerate read.

Bellow tests cases are on Atom 64bit based on Xie's patch(value is 1).

 Len   src/dst  improvement speedup(x)
    1, 	 0/ 0:	1
    1, 	 4/ 0:	1
    1, 	 0/ 4:	1
    1, 	 4/ 4:	1
    2, 	 0/ 0:	1
    2, 	 4/ 0:	1
    2, 	 0/ 4:	1
    2, 	 4/ 4:	1
    4, 	 0/ 0:	1
    4, 	 4/ 0:	1
    4, 	 0/ 4:	1
    4, 	 4/ 4:	1
    8, 	 0/ 0:	1
    8, 	 4/ 0:	1
    8, 	 0/ 4:	1
    8, 	 4/ 4:	1
   16, 	 0/ 0:	1
   16, 	 4/ 0:	1
   16, 	 0/ 4:	1
   16, 	 4/ 4:	1
   32, 	 0/ 0:	1
   32, 	 4/ 0:	1
   32, 	 0/ 4:	1
   32, 	 4/ 4:	1
   64, 	 0/ 0:	1
   64, 	 4/ 0:	0.7
   64, 	 0/ 4:	1
   64, 	 4/ 4:	0.8
  128, 	 0/ 0:	1.3
  128, 	 4/ 0:	1.7
  128, 	 0/ 4:	1
  128, 	 4/ 4:	1.1
  256, 	 0/ 0:	1.1
  256, 	 4/ 0:	1.4
  256, 	 0/ 4:	1
  256, 	 4/ 4:	1.1
  512, 	 0/ 0:	1
  512, 	 4/ 0:	1.5
  512, 	 0/ 4:	1
  512, 	 4/ 4:	1
 1024, 	 0/ 0:	1
 1024, 	 4/ 0:	1.5
 1024, 	 0/ 4:	1
 1024, 	 4/ 4:	1
 2048, 	 0/ 0:	1
 2048, 	 4/ 0:	1.6
 2048, 	 0/ 4:	1
 2048, 	 4/ 4:	1
 4096, 	 0/ 0:	1
 4096, 	 4/ 0:	1.6
 4096, 	 0/ 4:	1
 4096, 	 4/ 4:	1

Signed-off-by: Ma Ling <ling.ma@intel.com>
---
 arch/x86/lib/memcpy_64.S |   59 ++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 75ef61e..7545b08 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -45,7 +45,7 @@ ENTRY(memcpy)
 	/*
 	 * Use 32bit CMP here to avoid long NOP padding.
 	 */
-	cmp  $0x20, %edx
+	cmp  $0x28, %rdx
 	jb .Lhandle_tail
 
 	/*
@@ -54,7 +54,20 @@ ENTRY(memcpy)
 	 */
 	cmp  %dil, %sil
 	jl .Lcopy_backward
-	subl $0x20, %edx
+
+	/*
+	 * We append data to avoid store crossing cache.
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
 
@@ -74,20 +87,28 @@ ENTRY(memcpy)
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
+	 * We append data to avoid store crossing cache.
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
@@ -108,7 +129,31 @@ ENTRY(memcpy)
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

