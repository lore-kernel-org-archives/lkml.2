Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab2KUHQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:16:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26351 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2KUHQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:16:32 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 04/12] x86, 64bit: add support for loading kernel above 512G
Date: Tue, 20 Nov 2012 23:16:02 -0800
Message-Id: <1353482170-10160-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current kernel is not allowed to be loaded above 512g, it thinks
that address is too big.

We only need to add one extra spare page for needed level3 to
point another 512g range.

Need to check _text range and set level4 pg to point to that spare
level3 page, and set level3 to point to level2 page to cover
[_text, _end] with extra mapping.

We need this to put relocatable bzImage high above 512g.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/x86/kernel/head_64.S |   34 +++++++++++++++++++++++++++-------
 1 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index efc0c08..32fa9d0 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -78,12 +78,6 @@ startup_64:
 	testl	%eax, %eax
 	jnz	bad_address
 
-	/* Is the address too large? */
-	leaq	_text(%rip), %rdx
-	movq	$PGDIR_SIZE, %rax
-	cmpq	%rax, %rdx
-	jae	bad_address
-
 	/* Fixup the physical addresses in the page table
 	 */
 	addq	%rbp, init_level4_pgt + 0(%rip)
@@ -102,12 +96,35 @@ startup_64:
 	andq	$PMD_PAGE_MASK, %rdi
 
 	movq	%rdi, %rax
+	shrq	$PGDIR_SHIFT, %rax
+	andq	$(PTRS_PER_PGD - 1), %rax
+	jz	skip_level3_spare
+
+	/* Set level3 at first */
+	leaq	(level3_spare_pgt - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	leaq	init_level4_pgt(%rip), %rbx
+	movq	%rdx, 0(%rbx, %rax, 8)
+	addq	$L4_PAGE_OFFSET, %rax
+	movq	%rdx, 0(%rbx, %rax, 8)
+
+	/* always need to set level2 */
+	movq	%rdi, %rax
+	shrq	$PUD_SHIFT, %rax
+	andq	$(PTRS_PER_PUD - 1), %rax
+	leaq	level3_spare_pgt(%rip), %rbx
+	jmp	set_level2_spare
+
+skip_level3_spare:
+	movq	%rdi, %rax
 	shrq	$PUD_SHIFT, %rax
 	andq	$(PTRS_PER_PUD - 1), %rax
 	jz	ident_complete
 
-	leaq	(level2_spare_pgt - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	/* only set level2 with out level3 spare */
 	leaq	level3_ident_pgt(%rip), %rbx
+
+set_level2_spare:
+	leaq	(level2_spare_pgt - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
 	movq	%rdx, 0(%rbx, %rax, 8)
 
 	movq	%rdi, %rax
@@ -435,6 +452,9 @@ NEXT_PAGE(level2_kernel_pgt)
 	PMDS(0, __PAGE_KERNEL_LARGE_EXEC,
 		KERNEL_IMAGE_SIZE/PMD_SIZE)
 
+NEXT_PAGE(level3_spare_pgt)
+	.fill   512, 8, 0
+
 NEXT_PAGE(level2_spare_pgt)
 	.fill   512, 8, 0
 
-- 
1.7.7

