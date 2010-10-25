Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0JYJAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:00:36 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46468 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754080Ab0JYJA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:00:29 -0400
Subject: [RFC PATCH 08/18] ARM: LPAE: MMU setup for the 3-level page table
 format
To: linux-arm-kernel@lists.infradead.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 25 Oct 2010 10:00:18 +0100
Message-ID: <20101025090018.25275.85077.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
References: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-103-g0e84
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 09:00:19.0113 (UTC) FILETIME=[0C69D190:01CB7423]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the MMU initialisation for the LPAE page table format.
The swapper_pg_dir size with LPAE is 5 rather than 4 pages. The
__v7_setup function configures the TTBRx split based on the PAGE_OFFSET
and sets the corresponding TTB control and MAIRx bits (similar to
PRRR/NMRR for TEX remapping). The 36-bit mappings (supersections) and
a few other memory types in mmu.c are conditionally compiled.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/kernel/head.S    |   77 +++++++++++++++++++++++++++++++++-------
 arch/arm/mm/mmu.c         |   32 ++++++++++++++++-
 arch/arm/mm/proc-macros.S |    5 ++-
 arch/arm/mm/proc-v7.S     |   86 ++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 179 insertions(+), 21 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index eb62bf9..eb59839 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -41,11 +41,18 @@
 #error KERNEL_RAM_VADDR must start at 0xXXXX8000
 #endif
 
+#ifdef CONFIG_ARM_LPAE
+	/* LPAE requires an additional page for the PGD */
+#define PG_DIR_SIZE	0x5000
+#else
+#define PG_DIR_SIZE	0x4000
+#endif
+
 	.globl	swapper_pg_dir
-	.equ	swapper_pg_dir, KERNEL_RAM_VADDR - 0x4000
+	.equ	swapper_pg_dir, KERNEL_RAM_VADDR - PG_DIR_SIZE
 
 	.macro	pgtbl, rd
-	ldr	\rd, =(KERNEL_RAM_PADDR - 0x4000)
+	ldr	\rd, =(KERNEL_RAM_PADDR - PG_DIR_SIZE)
 	.endm
 
 #ifdef CONFIG_XIP_KERNEL
@@ -172,12 +179,17 @@ __enable_mmu:
 #ifdef CONFIG_CPU_ICACHE_DISABLE
 	bic	r0, r0, #CR_I
 #endif
+#ifdef CONFIG_ARM_LPAE
+	mov	r5, #0
+	mcrr	p15, 0, r4, r5, c2		@ load TTBR0
+#else
 	mov	r5, #(domain_val(DOMAIN_USER, DOMAIN_MANAGER) | \
 		      domain_val(DOMAIN_KERNEL, DOMAIN_MANAGER) | \
 		      domain_val(DOMAIN_TABLE, DOMAIN_MANAGER) | \
 		      domain_val(DOMAIN_IO, DOMAIN_CLIENT))
 	mcr	p15, 0, r5, c3, c0, 0		@ load domain access register
 	mcr	p15, 0, r4, c2, c0, 0		@ load page table pointer
+#endif
 	b	__turn_mmu_on
 ENDPROC(__enable_mmu)
 
@@ -220,11 +232,11 @@ __create_page_tables:
 	pgtbl	r4				@ page table address
 
 	/*
-	 * Clear the 16K level 1 swapper page table
+	 * Clear the swapper page table
 	 */
 	mov	r0, r4
 	mov	r3, #0
-	add	r6, r0, #0x4000
+	add	r6, r0, #PG_DIR_SIZE
 1:	str	r3, [r0], #4
 	str	r3, [r0], #4
 	str	r3, [r0], #4
@@ -232,31 +244,57 @@ __create_page_tables:
 	teq	r0, r6
 	bne	1b
 
+#ifdef CONFIG_ARM_LPAE
+	/*
+	 * Build the PGD table (first level) to point to the PMD table. A PGD
+	 * entry is 64-bit wide and the top 32 bits are 0.
+	 */
+	mov	r0, r4
+	add	r3, r4, #4096			@ first PMD table address
+	orr	r3, r3, #3			@ PGD block type
+	mov	r6, #4				@ PTRS_PER_PGD
+1:	str	r3, [r0], #8			@ set PGD entry
+	add	r3, r3, #4096			@ next PMD table
+	subs	r6, r6, #1
+	bne	1b
+
+	add	r4, r4, #4096			@ point to the PMD tables
+#endif
+
 	ldr	r7, [r10, #PROCINFO_MM_MMUFLAGS] @ mm_mmuflags
 
 	/*
-	 * Create identity mapping for first MB of kernel to
+	 * Create identity mapping for first 1 or 2 MB of kernel to
 	 * cater for the MMU enable.  This identity mapping
 	 * will be removed by paging_init().  We use our current program
 	 * counter to determine corresponding section base address.
 	 */
 	mov	r6, pc
-	mov	r6, r6, lsr #20			@ start of kernel section
-	orr	r3, r7, r6, lsl #20		@ flags + kernel base
-	str	r3, [r4, r6, lsl #2]		@ identity mapping
+	mov	r6, r6, lsr #21			@ start of kernel section
+	orr	r3, r7, r6, lsl #21		@ flags + kernel base
+	str	r3, [r4, r6, lsl #3]		@ identity mapping
 
 	/*
 	 * Now setup the pagetables for our kernel direct
 	 * mapped region.
 	 */
 	add	r0, r4,  #(KERNEL_START & 0xff000000) >> 18
-	str	r3, [r0, #(KERNEL_START & 0x00f00000) >> 18]!
+	str	r3, [r0, #(KERNEL_START & 0x00e00000) >> 18]!
 	ldr	r6, =(KERNEL_END - 1)
+#ifdef CONFIG_ARM_LPAE
+	add	r0, r0, #8
+#else
 	add	r0, r0, #4
+#endif
 	add	r6, r4, r6, lsr #18
 1:	cmp	r0, r6
+#ifdef CONFIG_ARM_LPAE
+	add	r3, r3, #1 << 21
+	strls	r3, [r0], #8
+#else
 	add	r3, r3, #1 << 20
 	strls	r3, [r0], #4
+#endif
 	bls	1b
 
 #ifdef CONFIG_XIP_KERNEL
@@ -279,12 +317,12 @@ __create_page_tables:
 #endif
 
 	/*
-	 * Then map first 1MB of ram in case it contains our boot params.
+	 * Then map first 1 or 2 MB of ram in case it contains our boot params.
 	 */
 	add	r0, r4, #PAGE_OFFSET >> 18
 	orr	r6, r7, #(PHYS_OFFSET & 0xff000000)
-	.if	(PHYS_OFFSET & 0x00f00000)
-	orr	r6, r6, #(PHYS_OFFSET & 0x00f00000)
+	.if	(PHYS_OFFSET & 0x00e00000)
+	orr	r6, r6, #(PHYS_OFFSET & 0x00e00000)
 	.endif
 	str	r6, [r0]
 
@@ -303,8 +341,18 @@ __create_page_tables:
 	add	r6, r0, r3
 	ldr	r3, [r8, #MACHINFO_PHYSIO]
 	orr	r3, r3, r7
-1:	str	r3, [r0], #4
+#ifdef CONFIG_ARM_LPAE
+	mov	r7, #1 << (54 - 32)		@ XN
+#endif
+1:
+#ifdef CONFIG_ARM_LPAE
+	str	r3, [r0], #4
+	str	r7, [r0], #4
+	add	r3, r3, #1 << 21
+#else
+	str	r3, [r0], #4
 	add	r3, r3, #1 << 20
+#endif
 	teq	r0, r6
 	bne	1b
 #if defined(CONFIG_ARCH_NETWINDER) || defined(CONFIG_ARCH_CATS)
@@ -329,6 +377,9 @@ __create_page_tables:
 	str	r3, [r0]
 #endif
 #endif
+#ifdef CONFIG_ARM_LPAE
+	sub	r4, r4, #4096		@ point to the PGD table
+#endif
 	mov	pc, lr
 ENDPROC(__create_page_tables)
 	.ltorg
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 4fc28ee..42929fb 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -153,6 +153,7 @@ static int __init early_nowrite(char *__unused)
 }
 early_param("nowb", early_nowrite);
 
+#ifndef CONFIG_ARM_LPAE
 static int __init early_ecc(char *p)
 {
 	if (memcmp(p, "on", 2) == 0)
@@ -162,6 +163,7 @@ static int __init early_ecc(char *p)
 	return 0;
 }
 early_param("ecc", early_ecc);
+#endif
 
 static int __init noalign_setup(char *__unused)
 {
@@ -231,10 +233,12 @@ static struct mem_type mem_types[] = {
 		.prot_sect = PMD_TYPE_SECT | PMD_SECT_XN,
 		.domain    = DOMAIN_KERNEL,
 	},
+#ifndef CONFIG_ARM_LPAE
 	[MT_MINICLEAN] = {
 		.prot_sect = PMD_TYPE_SECT | PMD_SECT_XN | PMD_SECT_MINICACHE,
 		.domain    = DOMAIN_KERNEL,
 	},
+#endif
 	[MT_LOW_VECTORS] = {
 		.prot_pte  = L_PTE_PRESENT | L_PTE_YOUNG | L_PTE_DIRTY |
 				L_PTE_EXEC | L_PTE_NOWRITE,
@@ -429,6 +433,7 @@ static void __init build_mem_type_table(void)
 	 * ARMv6 and above have extended page tables.
 	 */
 	if (cpu_arch >= CPU_ARCH_ARMv6 && (cr & CR_XP)) {
+#ifndef CONFIG_ARM_LPAE
 		/*
 		 * Mark cache clean areas and XIP ROM read only
 		 * from SVC mode and no access from userspace.
@@ -436,6 +441,7 @@ static void __init build_mem_type_table(void)
 		mem_types[MT_ROM].prot_sect |= PMD_SECT_APX|PMD_SECT_AP_WRITE;
 		mem_types[MT_MINICLEAN].prot_sect |= PMD_SECT_APX|PMD_SECT_AP_WRITE;
 		mem_types[MT_CACHECLEAN].prot_sect |= PMD_SECT_APX|PMD_SECT_AP_WRITE;
+#endif
 
 #ifdef CONFIG_SMP
 		/*
@@ -473,6 +479,18 @@ static void __init build_mem_type_table(void)
 		mem_types[MT_MEMORY_NONCACHED].prot_sect |= PMD_SECT_BUFFERABLE;
 	}
 
+#ifdef CONFIG_ARM_LPAE
+	/*
+	 * Do not generate access flag faults for the kernel mappings.
+	 */
+	for (i = 0; i < ARRAY_SIZE(mem_types); i++) {
+		mem_types[i].prot_pte |= PTE_EXT_AF;
+		mem_types[i].prot_sect |= PMD_SECT_AF;
+	}
+	kern_pgprot |= PTE_EXT_AF;
+	vecs_pgprot |= PTE_EXT_AF;
+#endif
+
 	for (i = 0; i < 16; i++) {
 		unsigned long v = pgprot_val(protection_map[i]);
 		protection_map[i] = __pgprot(v | user_pgprot);
@@ -590,6 +608,7 @@ static void __init alloc_init_section(pgd_t *pgd, unsigned long addr,
 	}
 }
 
+#ifndef CONFIG_ARM_LPAE
 static void __init create_36bit_mapping(struct map_desc *md,
 					const struct mem_type *type)
 {
@@ -647,6 +666,7 @@ static void __init create_36bit_mapping(struct map_desc *md,
 		pgd += SUPERSECTION_SIZE >> PGDIR_SHIFT;
 	} while (addr != end);
 }
+#endif	/* !CONFIG_ARM_LPAE */
 
 /*
  * Create the page directory entries and any necessary
@@ -677,6 +697,7 @@ static void __init create_mapping(struct map_desc *md)
 
 	type = &mem_types[md->type];
 
+#ifndef CONFIG_ARM_LPAE
 	/*
 	 * Catch 36-bit addresses
 	 */
@@ -684,6 +705,7 @@ static void __init create_mapping(struct map_desc *md)
 		create_36bit_mapping(md, type);
 		return;
 	}
+#endif
 
 	addr = md->virtual & PAGE_MASK;
 	phys = (unsigned long)__pfn_to_phys(md->pfn);
@@ -881,6 +903,14 @@ static inline void prepare_page_table(void)
 		pmd_clear(pmd_off_k(addr));
 }
 
+#ifdef CONFIG_ARM_LPAE
+/* the first page is reserved for pgd */
+#define SWAPPER_PG_DIR_SIZE	(PAGE_SIZE + \
+				 PTRS_PER_PGD * PTRS_PER_PMD * sizeof(pmd_t))
+#else
+#define SWAPPER_PG_DIR_SIZE	(PTRS_PER_PGD * sizeof(pgd_t))
+#endif
+
 /*
  * Reserve the special regions of memory
  */
@@ -890,7 +920,7 @@ void __init arm_mm_memblock_reserve(void)
 	 * Reserve the page tables.  These are already in use,
 	 * and can only be in node 0.
 	 */
-	memblock_reserve(__pa(swapper_pg_dir), PTRS_PER_PGD * sizeof(pgd_t));
+	memblock_reserve(__pa(swapper_pg_dir), SWAPPER_PG_DIR_SIZE);
 
 #ifdef CONFIG_SA1111
 	/*
diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index 337f102..fed053c 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -81,8 +81,9 @@
 #if L_PTE_SHARED != PTE_EXT_SHARED
 #error PTE shared bit mismatch
 #endif
-#if (L_PTE_EXEC+L_PTE_USER+L_PTE_WRITE+L_PTE_DIRTY+L_PTE_YOUNG+\
-     L_PTE_FILE+L_PTE_PRESENT) > L_PTE_SHARED
+#if !defined(CONFIG_ARM_LPAE) && \
+		(L_PTE_EXEC+L_PTE_USER+L_PTE_WRITE+L_PTE_DIRTY+L_PTE_YOUNG+ \
+		 L_PTE_FILE+L_PTE_PRESENT) > L_PTE_SHARED
 #error Invalid Linux PTE bit settings
 #endif
 #endif	/* CONFIG_MMU */
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 8c7b0f1..4db926c 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -19,6 +19,19 @@
 
 #include "proc-macros.S"
 
+#ifdef CONFIG_ARM_LPAE
+#define TTB_IRGN_NC	((0 << 8) | (0 << 24))
+#define TTB_IRGN_WBWA	((1 << 8) | (1 << 24))
+#define TTB_IRGN_WT	((2 << 8) | (2 << 24))
+#define TTB_IRGN_WB	((3 << 8) | (3 << 24))
+#define TTB_RGN_NC	((0 << 10) | (0 << 26))
+#define TTB_RGN_OC_WBWA	((1 << 10) | (1 << 26))
+#define TTB_RGN_OC_WT	((2 << 10) | (2 << 26))
+#define TTB_RGN_OC_WB	((3 << 10) | (3 << 26))
+#define TTB_S		((3 << 12) | (3 << 28))
+#define TTB_NOS		(0)
+#define TTB_EAE		(1 << 31)
+#else
 #define TTB_S		(1 << 1)
 #define TTB_RGN_NC	(0 << 3)
 #define TTB_RGN_OC_WBWA	(1 << 3)
@@ -29,6 +42,7 @@
 #define TTB_IRGN_WBWA	((0 << 0) | (1 << 6))
 #define TTB_IRGN_WT	((1 << 0) | (0 << 6))
 #define TTB_IRGN_WB	((1 << 0) | (1 << 6))
+#endif
 
 #ifndef CONFIG_SMP
 /* PTWs cacheable, inner WB not shareable, outer WB not shareable */
@@ -280,9 +294,41 @@ __v7_setup:
 	dsb
 #ifdef CONFIG_MMU
 	mcr	p15, 0, r10, c8, c7, 0		@ invalidate I + D TLBs
+#ifdef CONFIG_ARM_LPAE
+	ldr	r5, =TTB_FLAGS|TTB_EAE
+	mrc	p15, 0, r10, c2, c0, 2
+	orr	r10, r10, r5
+#if PHYS_OFFSET <= PAGE_OFFSET
+	/*
+	 * TTBR0/TTBR1 split (PAGE_OFFSET):
+	 *   0x40000000: T0SZ = 2, T1SZ = 0 (not used)
+	 *   0x80000000: T0SZ = 0, T1SZ = 1
+	 *   0xc0000000: T0SZ = 0, T1SZ = 2
+	 *
+	 * Only use this feature if PAGE_OFFSET <=  PAGE_OFFSET, otherwise
+	 * booting secondary CPUs would end up using TTBR1 for the identity
+	 * mapping set up in TTBR0.
+	 */
+	orr	r10, r10, #(((PAGE_OFFSET >> 30) - 1) << 16)	@ TTBCR.T1SZ
+#endif
+#endif
 	mcr	p15, 0, r10, c2, c0, 2		@ TTB control register
+#ifdef CONFIG_ARM_LPAE
+	mov	r5, #0
+#if defined CONFIG_VMSPLIT_2G
+	/* PAGE_OFFSET == 0x80000000, T1SZ == 1 */
+	add	r6, r4, #1 << 4			@ skip two L1 entries
+#elif defined CONFIG_VMSPLIT_3G
+	/* PAGE_OFFSET == 0xc0000000, T1SZ == 2 */
+	add	r6, r4, #4096 * (1 + 3)		@ only L2 used, skip pgd+3*pmd
+#else
+	mov	r6, r4
+#endif
+	mcrr	p15, 1, r6, r5, c2		@ load TTBR1
+#else	/* !CONFIG_ARM_LPAE */
 	orr	r4, r4, #TTB_FLAGS
 	mcr	p15, 0, r4, c2, c0, 1		@ load TTB1
+#endif	/* CONFIG_ARM_LPAE */
 	/*
 	 * Memory region attributes with SCTLR.TRE=1
 	 *
@@ -310,11 +356,33 @@ __v7_setup:
 	 *   NS0 = PRRR[18] = 0		- normal shareable property
 	 *   NS1 = PRRR[19] = 1		- normal shareable property
 	 *   NOS = PRRR[24+n] = 1	- not outer shareable
+	 *
+	 * Memory region attributes for LPAE (defined in pgtable-3level.h):
+	 *
+	 *   n = AttrIndx[2:0]
+	 *
+	 *			n	MAIR
+	 *   UNCACHED		000	00000000
+	 *   BUFFERABLE		001	01000100
+	 *   DEV_WC		001	01000100
+	 *   WRITETHROUGH	010	10101010
+	 *   WRITEBACK		011	11101110
+	 *   DEV_CACHED		011	11101110
+	 *   DEV_SHARED		100	00000100
+	 *   DEV_NONSHARED	100	00000100
+	 *   unused		101
+	 *   unused		110
+	 *   WRITEALLOC		111	11111111
 	 */
+#ifdef CONFIG_ARM_LPAE
+	ldr	r5, =0xeeaa4400			@ MAIR0
+	ldr	r6, =0xff000004			@ MAIR1
+#else
 	ldr	r5, =0xff0a81a8			@ PRRR
 	ldr	r6, =0x40e040e0			@ NMRR
-	mcr	p15, 0, r5, c10, c2, 0		@ write PRRR
-	mcr	p15, 0, r6, c10, c2, 1		@ write NMRR
+#endif
+	mcr	p15, 0, r5, c10, c2, 0		@ write PRRR/MAIR0
+	mcr	p15, 0, r6, c10, c2, 1		@ write NMRR/MAIR1
 #endif
 	adr	r5, v7_crval
 	ldmia	r5, {r5, r6}
@@ -333,14 +401,19 @@ __v7_setup:
 ENDPROC(__v7_setup)
 
 	/*   AT
-	 *  TFR   EV X F   I D LR    S
-	 * .EEE ..EE PUI. .T.T 4RVI ZWRS BLDP WCAM
+	 *  TFR   EV X F   IHD LR    S
+	 * .EEE ..EE PUI. .TAT 4RVI ZWRS BLDP WCAM
 	 * rxxx rrxx xxx0 0101 xxxx xxxx x111 xxxx < forced
 	 *    1    0 110       0011 1100 .111 1101 < we want
+	 *   11    0 110    1  0011 1100 .111 1101 < we want (LPAE)
 	 */
 	.type	v7_crval, #object
 v7_crval:
+#ifdef CONFIG_ARM_LPAE
+	crval	clear=0x0120c302, mmuset=0x30c23c7d, ucset=0x00c01c7c
+#else
 	crval	clear=0x0120c302, mmuset=0x10c03c7d, ucset=0x00c01c7c
+#endif
 
 __v7_setup_stack:
 	.space	4 * 11				@ 11 registers
@@ -404,11 +477,14 @@ __v7_proc_info:
 	.long   PMD_TYPE_SECT | \
 		PMD_SECT_AP_WRITE | \
 		PMD_SECT_AP_READ | \
+		PMD_SECT_AF | \
 		PMD_FLAGS
+		/* PMD_SECT_XN is set explicitly in head.S for LPAE */
 	.long   PMD_TYPE_SECT | \
 		PMD_SECT_XN | \
 		PMD_SECT_AP_WRITE | \
-		PMD_SECT_AP_READ
+		PMD_SECT_AP_READ | \
+		PMD_SECT_AF
 	b	__v7_setup
 	.long	cpu_arch_name
 	.long	cpu_elf_name

