Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab1F1PX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:23:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:30746 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758570Ab1F1PWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:22:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,437,1304319600"; 
   d="scan'208";a="21081685"
From: ling.ma@intel.com
To: mingo@elte.hu
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        ling.ma@intel.com
Subject: [PATCH RFC 1/2 ] [x86] Optimize copy-page by reducing impact from HW prefetch
Date: Wed, 29 Jun 2011 06:36:46 +0800
Message-Id: <1309300606-826-1-git-send-email-ling.ma@intel.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ma Ling <ling.ma@intel.com>

Program's temporal & spatial locality introduce cache unit to overcome
the processor-memory performance gap, hardware prefetch is very important
to improve performance by reducing cache miss. Modern CPU micro-architecture
mainly support two kinds of prefetch mechanism in L1 data cache:

a. Data cache unit (DCU) prefetcher. Data spatial locality ask us to provide
   adjacent data while handling current data. larger cache line size
   is one choice, but it would cause more cached data to be evicted and latency
   to load, so we simply prefetch next line when accessing current data.
   This mode only prefetch data of ascending address.
  
b. Instruction pointer (IP)- based strided prefetcher. Based on Load/write
   instruction address the mechanism predicate to prefetch data with adaptive stride,
   including ascending and descending address

DCU mode is good when time program data operation spend is longer than that of
prefetch next line, however copy-page function breaks the assumption,
DCU mode is hardly helpful, specially we append software prefetch and data is
in cache, so bus traffic is more busy that impact perforamnce seriously.

In this patch we introduce backward copy to successfully avoid HW prfetch
impact(DCU prefetcher), and simplify original code.
The performance on atom is improved about 11%, 8% on hot/cold-cache case respectively.
(We use our micro-benchmark, and will do further test according to your requirement)

Thanks
Ling

---
In this version we re-use prefetcht0 for atom cpu, although prefetchnta is better on snb.

 arch/x86/lib/copy_page_64.S |  140 +++++++++++++++++++-----------------------
 1 files changed, 63 insertions(+), 77 deletions(-)

diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
index 45f7db7..35e08fe 100644
--- a/arch/x86/lib/copy_page_64.S
+++ b/arch/x86/lib/copy_page_64.S
@@ -1,4 +1,5 @@
 /* Written 2003 by Andi Kleen, based on a kernel by Evandro Menezes */
+/* Updated 2011 by Ma Ling to introduce backward copy */
 
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
@@ -13,89 +14,74 @@ copy_page_rep:
 	CFI_ENDPROC
 ENDPROC(copy_page_rep)
 
-/*
-   Don't use streaming copy unless cpu indicate X86_FEATURE_REP_GOOD
-   Could vary the prefetch distance based on SMP/UP
-*/
-
+/* 
+ * Don't use streaming copy unless cpu indicate X86_FEATURE_REP_GOOD.
+ * By backward copy we manage to reduce impact from HW prefetch
+ * when data is in L1 cache, and get benefit when data is not in L1 cache.
+ */
 ENTRY(copy_page)
 	CFI_STARTPROC
-	subq	$3*8, %rsp
-	CFI_ADJUST_CFA_OFFSET 3*8
-	movq	%rbx, (%rsp)
-	CFI_REL_OFFSET rbx, 0
-	movq	%r12, 1*8(%rsp)
-	CFI_REL_OFFSET r12, 1*8
-	movq	%r13, 2*8(%rsp)
-	CFI_REL_OFFSET r13, 2*8
-
-	movl	$(4096/64)-5, %ecx
-	.p2align 4
+	lea	4096(%rsi), %rsi
+	lea	4096(%rdi), %rdi
+	mov	$(4096/64)-5, %cl
+	mov	$5, %dl
+	/*
+	 * Nop force following instruction to be 16 bytes aligned.
+	 */
+	nop
 .Loop64:
-  	dec	%rcx
-
-	movq	0x8*0(%rsi), %rax
-	movq	0x8*1(%rsi), %rbx
-	movq	0x8*2(%rsi), %rdx
-	movq	0x8*3(%rsi), %r8
-	movq	0x8*4(%rsi), %r9
-	movq	0x8*5(%rsi), %r10
-	movq	0x8*6(%rsi), %r11
-	movq	0x8*7(%rsi), %r12
-
-	prefetcht0 5*64(%rsi)
-
-	movq	%rax, 0x8*0(%rdi)
-	movq	%rbx, 0x8*1(%rdi)
-	movq	%rdx, 0x8*2(%rdi)
-	movq	%r8,  0x8*3(%rdi)
-	movq	%r9,  0x8*4(%rdi)
-	movq	%r10, 0x8*5(%rdi)
-	movq	%r11, 0x8*6(%rdi)
-	movq	%r12, 0x8*7(%rdi)
-
-	leaq	64 (%rsi), %rsi
-	leaq	64 (%rdi), %rdi
-
-	jnz	.Loop64
-
-	movl	$5, %ecx
-	.p2align 4
+	prefetcht0 -5*64(%rsi)
+	decb	%cl
+
+	movq	-0x8*1(%rsi), %rax
+	movq	-0x8*2(%rsi), %r8
+	movq	-0x8*3(%rsi), %r9
+	movq	-0x8*4(%rsi), %r10
+	movq	%rax, -0x8*1(%rdi)
+	movq	%r8, -0x8*2(%rdi)
+	movq	%r9, -0x8*3(%rdi)
+	movq	%r10, -0x8*4(%rdi)
+
+	movq	-0x8*5(%rsi), %rax
+	movq	-0x8*6(%rsi), %r8
+	movq	-0x8*7(%rsi), %r9
+	movq	-0x8*8(%rsi), %r10
+	leaq	-64(%rsi), %rsi
+	movq	%rax, -0x8*5(%rdi)
+	movq	%r8, -0x8*6(%rdi)
+	movq	%r9, -0x8*7(%rdi)
+	movq	%r10, -0x8*8(%rdi)
+	leaq	-64(%rdi), %rdi
+ 
+ 	jnz     .Loop64
+ 
 .Loop2:
-	decl	%ecx
-
-	movq	0x8*0(%rsi), %rax
-	movq	0x8*1(%rsi), %rbx
-	movq	0x8*2(%rsi), %rdx
-	movq	0x8*3(%rsi), %r8
-	movq	0x8*4(%rsi), %r9
-	movq	0x8*5(%rsi), %r10
-	movq	0x8*6(%rsi), %r11
-	movq	0x8*7(%rsi), %r12
-
-	movq	%rax, 0x8*0(%rdi)
-	movq	%rbx, 0x8*1(%rdi)
-	movq	%rdx, 0x8*2(%rdi)
-	movq	%r8,  0x8*3(%rdi)
-	movq	%r9,  0x8*4(%rdi)
-	movq	%r10, 0x8*5(%rdi)
-	movq	%r11, 0x8*6(%rdi)
-	movq	%r12, 0x8*7(%rdi)
+	decb	%dl
+
+	movq	-0x8*1(%rsi), %rax
+	movq	-0x8*2(%rsi), %r8
+	movq	-0x8*3(%rsi), %r9
+	movq	-0x8*4(%rsi), %r10
+	movq	%rax, -0x8*1(%rdi)
+	movq	%r8, -0x8*2(%rdi)
+	movq	%r9, -0x8*3(%rdi)
+	movq	%r10, -0x8*4(%rdi)
+
+	movq	-0x8*5(%rsi), %rax
+	movq	-0x8*6(%rsi), %r8
+	movq	-0x8*7(%rsi), %r9
+	movq	-0x8*8(%rsi), %r10
+	leaq	-64(%rsi), %rsi
+	movq	%rax, -0x8*5(%rdi)
+	movq	%r8, -0x8*6(%rdi)
+	movq	%r9, -0x8*7(%rdi)
+	movq	%r10, -0x8*8(%rdi)
+	leaq	-64(%rdi), %rdi
+ 
+ 	jnz	.Loop2
 
-	leaq	64(%rdi), %rdi
-	leaq	64(%rsi), %rsi
-
-	jnz	.Loop2
-
-	movq	(%rsp), %rbx
-	CFI_RESTORE rbx
-	movq	1*8(%rsp), %r12
-	CFI_RESTORE r12
-	movq	2*8(%rsp), %r13
-	CFI_RESTORE r13
-	addq	$3*8, %rsp
-	CFI_ADJUST_CFA_OFFSET -3*8
 	ret
+
 .Lcopy_page_end:
 	CFI_ENDPROC
 ENDPROC(copy_page)
-- 
1.6.5.2

