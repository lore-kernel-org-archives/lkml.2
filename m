Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2K1Hws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 02:52:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40383 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab2K1Hv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 02:51:26 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 03/13] x86, 64bit: Set extra ident mapping for whole kernel range
Date: Tue, 27 Nov 2012 23:50:32 -0800
Message-Id: <1354089042-10023-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
References: <1354089042-10023-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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
-v5: use spare pages from BRK, so could save pages when kernel is not
	loaded above 1GB.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/x86/kernel/head_64.S |  203 +++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 187 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 94bf9cc..338799a 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -20,6 +20,7 @@
 #include <asm/processor-flags.h>
 #include <asm/percpu.h>
 #include <asm/nops.h>
+#include <asm/setup.h>
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/asm-offsets.h>
@@ -42,6 +43,13 @@ L3_PAGE_OFFSET = pud_index(__PAGE_OFFSET)
 L4_START_KERNEL = pgd_index(__START_KERNEL_map)
 L3_START_KERNEL = pud_index(__START_KERNEL_map)
 
+/* two for level3, and two for level2 */
+SPARE_MAP_SIZE = (4 * PAGE_SIZE)
+RESERVE_BRK(spare_map, SPARE_MAP_SIZE)
+
+#define spare_page(x)	(__brk_base + (x) * PAGE_SIZE)
+#define add_one_spare_page	addq $PAGE_SIZE, _brk_end(%rip)
+
 	.text
 	__HEAD
 	.code64
@@ -78,12 +86,6 @@ startup_64:
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
@@ -97,25 +99,196 @@ startup_64:
 
 	addq	%rbp, level2_fixmap_pgt + (506*8)(%rip)
 
-	/* Add an Identity mapping if I am above 1G */
+	/* Add an Identity mapping if _end is above 1G */
+	leaq	_end(%rip), %r9
+	decq	%r9
+	cmp	$PUD_SIZE, %r9
+	jl	ident_complete
+
+	/* Clear spare pages */
+	leaq	__brk_base(%rip), %rdi
+	xorq	%rax, %rax
+	movq	$(SPARE_MAP_SIZE/8), %rcx
+1:	decq	%rcx
+	movq	%rax, (%rdi)
+	leaq	8(%rdi), %rdi
+	jnz	1b
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
+	/*
+	 * We need one level3, one or two level 2,
+	 * so use first one for level3.
+	 */
+	leaq    (spare_page(0) - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	leaq    init_level4_pgt(%rip), %rbx
+	movq    %rdx, 0(%rbx, %rax, 8)
+	addq    $L4_PAGE_OFFSET, %rax
+	movq    %rdx, 0(%rbx, %rax, 8)
+	/* one level3 in BRK */
+	add_one_spare_page
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
+	leaq    spare_page(0)(%rip), %rbx
+	leaq    (spare_page(2) - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	movq    %rdx, 0(%rbx, %r8, 8)
+	/* second one level2 in BRK */
+	add_one_spare_page
+
+set_level2_start_only_not_first_512g:
+	leaq    spare_page(0)(%rip), %rbx
+	leaq    (spare_page(1) - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	movq    %rdx, 0(%rbx, %rax, 8)
+	/* first one level2 in BRK */
+	add_one_spare_page
+
+	/* one spare level3 before level2*/
+	leaq    spare_page(1)(%rip), %rbx
+	jmp	set_level2_spare
+
+set_level3_other_512g:
+	/*
+	 * We need one or two level3, and two level2,
+	 * so use first two for level2.
+	 */
+	/* for level2 last on first 512g */
+	leaq	level3_ident_pgt(%rip), %rcx
+	/* start is in first 512G ? */
+	cmp	$0, %rax
+	je	set_level2_start_other_512g
 
+	/* Set level3 for _text */
+	leaq	(spare_page(3) - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	leaq	init_level4_pgt(%rip), %rbx
+	movq	%rdx, 0(%rbx, %rax, 8)
+	addq	$L4_PAGE_OFFSET, %rax
+	movq	%rdx, 0(%rbx, %rax, 8)
+	/* first one level3 in BRK */
+	add_one_spare_page
+
+	/* for level2 last not on first 512G */
+	leaq	spare_page(3)(%rip), %rcx
+
+set_level2_start_other_512g:
+	/* always need to set level2 */
 	movq	%rdi, %rax
 	shrq	$PUD_SHIFT, %rax
 	andq	$(PTRS_PER_PUD - 1), %rax
-	jz	ident_complete
+	movq	%rcx, %rbx  /* %rcx : level3 spare or level3_ident_pgt */
+	leaq	(spare_page(0) - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	movq	%rdx, 0(%rbx, %rax, 8)
+	/* first one level2 in BRK */
+	add_one_spare_page
 
-	leaq	(level2_spare_pgt - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+set_level3_end_other_512g:
+	leaq	(spare_page(2) - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	leaq	init_level4_pgt(%rip), %rbx
+	movq	%rdx, 0(%rbx, %r8, 8)
+	addq	$L4_PAGE_OFFSET, %r8
+	movq	%rdx, 0(%rbx, %r8, 8)
+	/* second one level3 in BRK */
+	add_one_spare_page
+
+	/* always need to set level2 */
+	movq	%r9, %r8
+	shrq	$PUD_SHIFT, %r8
+	andq	$(PTRS_PER_PUD - 1), %r8
+	leaq	spare_page(2)(%rip), %rbx
+	leaq	(spare_page(1) - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	movq	%rdx, 0(%rbx, %r8, 8)
+	/* second one level2 in BRK */
+	add_one_spare_page
+
+	/* no spare level3 before level2 */
+	leaq    spare_page(0)(%rip), %rbx
+	jmp	set_level2_spare
+
+skip_level3_spare:
+	/* We have one or two level2 */
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
+	leaq	level3_ident_pgt(%rip), %rbx
+	leaq	(spare_page(1) - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
+	movq	%rdx, 0(%rbx, %r8, 8)
+	/* second one level2 in BRK */
+	add_one_spare_page
+
+set_level2_start_only_first_512g:
+	/*  set level2 without level3 spare */
 	leaq	level3_ident_pgt(%rip), %rbx
+	leaq	(spare_page(0) - __START_KERNEL_map + _KERNPG_TABLE)(%rbp), %rdx
 	movq	%rdx, 0(%rbx, %rax, 8)
+	/* first one level2 in BRK */
+	add_one_spare_page
 
+	/* no spare level3 */
+	leaq    spare_page(0)(%rip), %rbx
+
+set_level2_spare:
 	movq	%rdi, %rax
 	shrq	$PMD_SHIFT, %rax
 	andq	$(PTRS_PER_PMD - 1), %rax
 	leaq	__PAGE_KERNEL_IDENT_LARGE_EXEC(%rdi), %rdx
-	leaq	level2_spare_pgt(%rip), %rbx
-	movq	%rdx, 0(%rbx, %rax, 8)
+	/* %rbx is set before */
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
@@ -423,11 +596,9 @@ NEXT_PAGE(level2_kernel_pgt)
 	 *  If you want to increase this then increase MODULES_VADDR
 	 *  too.)
 	 */
-	PMDS(0, __PAGE_KERNEL_LARGE_EXEC,
-		KERNEL_IMAGE_SIZE/PMD_SIZE)
-
-NEXT_PAGE(level2_spare_pgt)
-	.fill   512, 8, 0
+	PMDS(0, __PAGE_KERNEL_LARGE_EXEC, KERNEL_IMAGE_SIZE/PMD_SIZE)
+	/* hold the whole page */
+	.fill (PTRS_PER_PMD - (KERNEL_IMAGE_SIZE/PMD_SIZE)), 8, 0
 
 #undef PMDS
 #undef NEXT_PAGE
-- 
1.7.7

