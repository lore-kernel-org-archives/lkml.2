Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab2KXUgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 15:36:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18257 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab2KXUgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 15:36:25 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 03/11] x86, 64bit: Set extra ident mapping for whole kernel range
Date: Sat, 24 Nov 2012 12:35:29 -0800
Message-Id: <1353789337-19409-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353789337-19409-1-git-send-email-yinghai@kernel.org>
References: <1353789337-19409-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current when kernel is loaded above 1G, only [_text, _text+2M] is set
up with extra ident page table.
That is not enough, some variables that could be used early are out of
that range, like BRK for early page table.
Need to set map for [_text, _end] include text/data/bss/brk...

Also current kernel is not allowed to be loaded above 512g, it thinks
that address is too big.
We need to add one extra spare page for level3 to point that 512g range.
Need to check _text range and set level4 pg with that spare level3 page,
and set level3 with level2 page to cover [_text, _end] with extra mapping.

At last, to handle crossing GB boundary, we need to add another
level2 spare page. To handle crossing 512GB boundary, we need to
add another level3 spare page to next 512G range.

Test on with kexec-tools with local test code to force loading kernel
cross 1G, 5G, 512g, 513g.

We need this to put relocatable 64bit bzImage high above 1g.

-v4: add crossing GB boundary handling.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/x86/kernel/head_64.S |  149 ++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 139 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 94bf9cc..036dd0e 100644
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
@@ -97,25 +91,153 @@ startup_64:
 
 	addq	%rbp, level2_fixmap_pgt + (506*8)(%rip)
 
-	/* Add an Identity mapping if I am above 1G */
+	/* Add an Identity mapping if _end is above 1G */
+	leaq	_end(%rip), %r9
+	decq	%r9
+	cmp	$PUD_SIZE, %r9
+	jl	ident_complete
+
+	/* get end */
+	andq	$PMD_PAGE_MASK, %r9
+	/* round start to 1G if it is below 1G */
 	leaq	_text(%rip), %rdi
 	andq	$PMD_PAGE_MASK, %rdi
+	cmp	$PUD_SIZE, %rdi
+	jg	1f
+	movq	$PUD_SIZE, %rdi
+1:
+	/* get 512G index */
+	movq	%r9, %r8
+	shrq	$PGDIR_SHIFT, %r8
+	andq	$(PTRS_PER_PGD - 1), %r8
+	movq	%rdi, %rax
+	shrq	$PGDIR_SHIFT, %rax
+	andq	$(PTRS_PER_PGD - 1), %rax
+
+	/* cross two 512G ? */
+	cmp	%r8, %rax
+	jne	set_level3_other_512g
+
+	/* all in first 512G ? */
+	cmp	$0, %rax
+	je	skip_level3_spare
+
+	/* same 512G other than first 512g */
+	leaq    (level3_spare_pgt - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	leaq    init_level4_pgt(%rip), %rbx
+	movq    %rdx, 0(%rbx, %rax, 8)
+	addq    $L4_PAGE_OFFSET, %rax
+	movq    %rdx, 0(%rbx, %rax, 8)
+
+	/* get 1G index */
+	movq    %r9, %r8
+	shrq    $PUD_SHIFT, %r8
+	andq    $(PTRS_PER_PUD - 1), %r8
+	movq    %rdi, %rax
+	shrq    $PUD_SHIFT, %rax
+	andq    $(PTRS_PER_PUD - 1), %rax
+
+	/* same 1G ? */
+	cmp     %r8, %rax
+	je	set_level2_start_only_not_first_512g
+
+	/* set level2 for end */
+	leaq    level3_spare_pgt(%rip), %rbx
+	leaq    (level2_spare2_pgt - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	movq    %rdx, 0(%rbx, %r8, 8)
 
+set_level2_start_only_not_first_512g:
+	leaq    level3_spare_pgt(%rip), %rbx
+	leaq    (level2_spare_pgt - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	movq    %rdx, 0(%rbx, %rax, 8)
+
+	jmp	set_level2_spare
+
+set_level3_other_512g:
+	/* for level2 last on first 512g */
+	leaq	level3_ident_pgt(%rip), %rcx
+	/* start is in first 512G ? */
+	cmp	$0, %rax
+	je	set_level2_start_other_512g
+
+	/* Set level3 for _text */
+	leaq	(level3_spare_pgt - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	leaq	init_level4_pgt(%rip), %rbx
+	movq	%rdx, 0(%rbx, %rax, 8)
+	addq	$L4_PAGE_OFFSET, %rax
+	movq	%rdx, 0(%rbx, %rax, 8)
+
+	/* for level2 last not on first 512G */
+	leaq	level3_spare_pgt(%rip), %rcx
+
+set_level2_start_other_512g:
+	/* always need to set level2 */
 	movq	%rdi, %rax
 	shrq	$PUD_SHIFT, %rax
 	andq	$(PTRS_PER_PUD - 1), %rax
-	jz	ident_complete
-
+	movq	%rcx, %rbx    /* %rcx has level3_spare_pgt or level3_ident_pgt */
 	leaq	(level2_spare_pgt - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	movq	%rdx, 0(%rbx, %rax, 8)
+
+set_level3_end_other_512g:
+	leaq	(level3_spare2_pgt - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	leaq	init_level4_pgt(%rip), %rbx
+	movq	%rdx, 0(%rbx, %r8, 8)
+	addq	$L4_PAGE_OFFSET, %r8
+	movq	%rdx, 0(%rbx, %r8, 8)
+
+	/* always need to set level2 */
+	movq	%r9, %r8
+	shrq	$PUD_SHIFT, %r8
+	andq	$(PTRS_PER_PUD - 1), %r8
+	leaq	level3_spare2_pgt(%rip), %rbx
+	leaq	(level2_spare2_pgt - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	movq	%rdx, 0(%rbx, %r8, 8)
+
+	jmp	set_level2_spare
+
+skip_level3_spare:
+	/* get 1G index */
+	movq	%r9, %r8
+	shrq	$PUD_SHIFT, %r8
+	andq	$(PTRS_PER_PUD - 1), %r8
+	movq	%rdi, %rax
+	shrq	$PUD_SHIFT, %rax
+	andq	$(PTRS_PER_PUD - 1), %rax
+
+	/* same 1G ? */
+	cmp	%r8, %rax
+	je	set_level2_start_only_first_512g
+
+	/* set level2 without level3 spare */
 	leaq	level3_ident_pgt(%rip), %rbx
+	leaq	(level2_spare2_pgt - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	movq	%rdx, 0(%rbx, %r8, 8)
+
+set_level2_start_only_first_512g:
+	/*  set level2 without level3 spare */
+	leaq	level3_ident_pgt(%rip), %rbx
+	leaq	(level2_spare_pgt - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
 	movq	%rdx, 0(%rbx, %rax, 8)
 
+set_level2_spare:
 	movq	%rdi, %rax
 	shrq	$PMD_SHIFT, %rax
 	andq	$(PTRS_PER_PMD - 1), %rax
 	leaq	__PAGE_KERNEL_IDENT_LARGE_EXEC(%rdi), %rdx
 	leaq	level2_spare_pgt(%rip), %rbx
-	movq	%rdx, 0(%rbx, %rax, 8)
+	movq	%r9, %r8
+	shrq	$PMD_SHIFT, %r8
+	andq	$(PTRS_PER_PMD - 1), %r8
+	cmp	%r8, %rax
+	jl	1f
+	addq	$PTRS_PER_PMD, %r8
+1:	movq	%rdx, 0(%rbx, %rax, 8)
+	addq	$PMD_SIZE, %rdx
+	incq	%rax
+	cmp	%r8, %rax
+	jle	1b
+
 ident_complete:
 
 	/*
@@ -426,8 +548,15 @@ NEXT_PAGE(level2_kernel_pgt)
 	PMDS(0, __PAGE_KERNEL_LARGE_EXEC,
 		KERNEL_IMAGE_SIZE/PMD_SIZE)
 
+NEXT_PAGE(level3_spare_pgt)
+	.fill   512, 8, 0
+NEXT_PAGE(level3_spare2_pgt)
+	.fill   512, 8, 0
+
 NEXT_PAGE(level2_spare_pgt)
 	.fill   512, 8, 0
+NEXT_PAGE(level2_spare2_pgt)
+	.fill   512, 8, 0
 
 #undef PMDS
 #undef NEXT_PAGE
-- 
1.7.7

