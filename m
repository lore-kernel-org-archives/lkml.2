Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab2JQNBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:01:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:34979 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab2JQNBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:01:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,600,1344236400"; 
   d="scan'208";a="235027523"
From: ling.ma@intel.com
To: mingo@elte.hu
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        iant@google.com, Ma Ling <ling.ma@intel.com>
Subject: [PATCH RFC V2 2/2] [x86] Optimize copy_page by re-arranging instruction sequence and saving register
Date: Thu, 18 Oct 2012 03:53:06 +0800
Message-Id: <1350503586-19198-1-git-send-email-ling.ma@intel.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ma Ling <ling.ma@intel.com>

Load and write operation occupy about 35% and 10% respectively
for most industry benchmarks. Fetched 16-aligned bytes code include 
about 4 instructions, implying 1.40(0.35 * 4) load, 0.4 write.  
Modern CPU support 2 load and 1 write per cycle, throughput from write is
bottleneck for memcpy or copy_page, and some slight CPU only support one mem
operation per cycle. So it is enough to issue one read and write instruction
per cycle, and we can save registers. 

In this patch we also re-arrange instruction sequence to improve performance
The performance on atom is improved about 11%, 9% on hot/cold-cache case respectively.

Signed-off-by: Ma Ling <ling.ma@intel.com>

---
In this version update comments.

Thanks
Ling

 arch/x86/lib/copy_page_64.S |  103 +++++++++++++++++-------------------------
 1 files changed, 42 insertions(+), 61 deletions(-)

diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
index cda2e51..0d22f0a 100644
--- a/arch/x86/lib/copy_page_64.S
+++ b/arch/x86/lib/copy_page_64.S
@@ -20,75 +20,56 @@ ENDPROC(copy_page_rep)
 
 ENTRY(copy_page)
 	CFI_STARTPROC
-	subq	$2*8,	%rsp
-	CFI_ADJUST_CFA_OFFSET 2*8
-	movq	%rbx,	(%rsp)
-	CFI_REL_OFFSET rbx, 0
-	movq	%r12,	1*8(%rsp)
-	CFI_REL_OFFSET r12, 1*8
-
 	movl	$(4096/64)-5,	%ecx
-	.p2align 4
-.Loop64:
-	dec	%rcx
-	movq	0x8*0(%rsi), %rax
-	movq	0x8*1(%rsi), %rbx
-	movq	0x8*2(%rsi), %rdx
-	movq	0x8*3(%rsi), %r8
-	movq	0x8*4(%rsi), %r9
-	movq	0x8*5(%rsi), %r10
-	movq	0x8*6(%rsi), %r11
-	movq	0x8*7(%rsi), %r12
 
+.Loop64:
 	prefetcht0 5*64(%rsi)
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
+	decb	%cl
+	movq	0x8*0(%rsi), %r10
+	movq	0x8*1(%rsi), %rax
+	movq	0x8*2(%rsi), %r8
+	movq	0x8*3(%rsi), %r9
+	movq	%r10, 0x8*0(%rdi)
+	movq	%rax, 0x8*1(%rdi)
+	movq	%r8, 0x8*2(%rdi)
+	movq	%r9, 0x8*3(%rdi)
+
+	movq	0x8*4(%rsi), %r10
+	movq	0x8*5(%rsi), %rax
+	movq	0x8*6(%rsi), %r8
+	movq	0x8*7(%rsi), %r9
+	leaq	0x8*8(%rsi), %rsi
+	movq	%r10, 0x8*4(%rdi)
+	movq	%rax, 0x8*5(%rdi)
+	movq	%r8, 0x8*6(%rdi)
+	movq	%r9, 0x8*7(%rdi)
+	leaq	0x8*8(%rdi), %rdi
 	jnz	.Loop64
 
-	movl	$5, %ecx
-	.p2align 4
+	mov	$5, %dl
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
-
-	leaq	64(%rdi), %rdi
-	leaq	64(%rsi), %rsi
+	decb	%dl
+	movq	0x8*0(%rsi), %r10
+	movq	0x8*1(%rsi), %rax
+	movq	0x8*2(%rsi), %r8
+	movq	0x8*3(%rsi), %r9
+	movq	%r10, 0x8*0(%rdi)
+	movq	%rax, 0x8*1(%rdi)
+	movq	%r8, 0x8*2(%rdi)
+	movq	%r9, 0x8*3(%rdi)
+
+	movq	0x8*4(%rsi), %r10
+	movq	0x8*5(%rsi), %rax
+	movq	0x8*6(%rsi), %r8
+	movq	0x8*7(%rsi), %r9
+ 	leaq	0x8*8(%rsi), %rsi
+	movq	%r10, 0x8*4(%rdi)
+	movq	%rax, 0x8*5(%rdi)
+	movq	%r8, 0x8*6(%rdi)
+	movq	%r9, 0x8*7(%rdi)
+	leaq	0x8*8(%rdi), %rdi
 	jnz	.Loop2
 
-	movq	(%rsp), %rbx
-	CFI_RESTORE rbx
-	movq	1*8(%rsp), %r12
-	CFI_RESTORE r12
-	addq	$2*8, %rsp
-	CFI_ADJUST_CFA_OFFSET -2*8
 	ret
 .Lcopy_page_end:
 	CFI_ENDPROC
-- 
1.6.5.2

