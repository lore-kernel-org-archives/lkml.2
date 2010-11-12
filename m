Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab0KLSBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:01:14 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50920 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932377Ab0KLSBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:01:12 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/20] ARM: LPAE: MMU setup for the 3-level page table format
Date: Fri, 12 Nov 2010 18:00:28 +0000
Message-Id: <1289584840-18097-9-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c
In-Reply-To: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 12 Nov 2010 18:00:50.0938 (UTC) FILETIME=[8AB915A0:01CB8293]
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
 arch/arm/kernel/head.S    |   96 +++++++++++++++++++++++++++++++------------
 arch/arm/mm/mmu.c         |   32 ++++++++++++++-
 arch/arm/mm/proc-macros.S |    5 +-
 arch/arm/mm/proc-v7.S     |   99 ++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 193 insertions(+), 39 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index dd6b369..fd8a29e 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -21,6 +21,7 @@
 #include <asm/memory.h>
 #include <asm/thread_info.h>
 #include <asm/system.h>
+#include <asm/pgtable.h>
 
 #ifdef CONFIG_DEBUG_LL
 #include <mach/debug-macro.S>
@@ -45,11 +46,20 @@
 #error KERNEL_RAM_VADDR must start at 0xXXXX8000
 #endif
 
+#ifdef CONFIG_ARM_LPAE
+	/* LPAE requires an additional page for the PGD */
+#define PG_DIR_SIZE	0x5000
+#define PTE_WORDS	3
+#else
+#define PG_DIR_SIZE	0x4000
+#define PTE_WORDS	2
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
@@ -129,11 +139,11 @@ __create_page_tables:
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
@@ -141,6 +151,23 @@ __create_page_tables:
 	teq	r0, r6
 	bne	1b
 
+#ifdef CONFIG_ARM_LPAE
+	/*
+	 * Build the PGD table (first level) to point to the PMD table. A PGD
+	 * entry is 64-bit wide and the top 32 bits are 0.
+	 */
+	mov	r0, r4
+	add	r3, r4, #0x1000			@ first PMD table address
+	orr	r3, r3, #3			@ PGD block type
+	mov	r6, #4				@ PTRS_PER_PGD
+1:	str	r3, [r0], #8			@ set PGD entry
+	add	r3, r3, #0x1000			@ next PMD table
+	subs	r6, r6, #1
+	bne	1b
+
+	add	r4, r4, #0x1000			@ point to the PMD tables
+#endif
+
 	ldr	r7, [r10, #PROCINFO_MM_MMUFLAGS] @ mm_mmuflags
 
 	/*
@@ -152,30 +179,30 @@ __create_page_tables:
 	sub	r0, r0, r3			@ virt->phys offset
 	add	r5, r5, r0			@ phys __enable_mmu
 	add	r6, r6, r0			@ phys __enable_mmu_end
-	mov	r5, r5, lsr #20
-	mov	r6, r6, lsr #20
+	mov	r5, r5, lsr #SECTION_SHIFT
+	mov	r6, r6, lsr #SECTION_SHIFT
 
-1:	orr	r3, r7, r5, lsl #20		@ flags + kernel base
-	str	r3, [r4, r5, lsl #2]		@ identity mapping
-	teq	r5, r6
-	addne	r5, r5, #1			@ next section
-	bne	1b
+1:	orr	r3, r7, r5, lsl #SECTION_SHIFT	@ flags + kernel base
+	str	r3, [r4, r5, lsl #PTE_WORDS]	@ identity mapping
+	cmp	r5, r6
+	addlo	r5, r5, #SECTION_SHIFT >> 20	@ next section
+	blo	1b
 
 	/*
 	 * Now setup the pagetables for our kernel direct
 	 * mapped region.
 	 */
 	mov	r3, pc
-	mov	r3, r3, lsr #20
-	orr	r3, r7, r3, lsl #20
+	mov	r3, r3, lsr #SECTION_SHIFT
+	orr	r3, r7, r3, lsl #SECTION_SHIFT
 	add	r0, r4,  #(KERNEL_START & 0xff000000) >> 18
-	str	r3, [r0, #(KERNEL_START & 0x00f00000) >> 18]!
+	str	r3, [r0, #(KERNEL_START & 0x00e00000) >> 18]!
 	ldr	r6, =(KERNEL_END - 1)
-	add	r0, r0, #4
+	add	r0, r0, #1 << PTE_WORDS
 	add	r6, r4, r6, lsr #18
 1:	cmp	r0, r6
-	add	r3, r3, #1 << 20
-	strls	r3, [r0], #4
+	add	r3, r3, #1 << SECTION_SHIFT
+	strls	r3, [r0], #1 << PTE_WORDS
 	bls	1b
 
 #ifdef CONFIG_XIP_KERNEL
@@ -198,12 +225,13 @@ __create_page_tables:
 #endif
 
 	/*
-	 * Then map first 1MB of ram in case it contains our boot params.
+	 * Then map first section of RAM in case it contains our boot params.
+	 * It assumes that PAGE_OFFSET is 2MB-aligned.
 	 */
 	add	r0, r4, #PAGE_OFFSET >> 18
 	orr	r6, r7, #(PHYS_OFFSET & 0xff000000)
-	.if	(PHYS_OFFSET & 0x00f00000)
-	orr	r6, r6, #(PHYS_OFFSET & 0x00f00000)
+	.if	(PHYS_OFFSET & 0x00e00000)
+	orr	r6, r6, #(PHYS_OFFSET & 0x00e00000)
 	.endif
 	str	r6, [r0]
 
@@ -216,21 +244,27 @@ __create_page_tables:
 	 */
 	addruart r7, r3
 
-	mov	r3, r3, lsr #20
-	mov	r3, r3, lsl #2
+	mov	r3, r3, lsr #SECTION_SHIFT
+	mov	r3, r3, lsl #PTE_WORDS
 
 	add	r0, r4, r3
 	rsb	r3, r3, #0x4000			@ PTRS_PER_PGD*sizeof(long)
 	cmp	r3, #0x0800			@ limit to 512MB
 	movhi	r3, #0x0800
 	add	r6, r0, r3
-	mov	r3, r7, lsr #20
+	mov	r3, r7, lsr #SECTION_SHIFT
 	ldr	r7, [r10, #PROCINFO_IO_MMUFLAGS] @ io_mmuflags
-	orr	r3, r7, r3, lsl #20
+	orr	r3, r7, r3, lsl #SECTION_SHIFT
+#ifdef CONFIG_ARM_LPAE
+	mov	r7, #1 << (54 - 32)		@ XN
+#endif
 1:	str	r3, [r0], #4
-	add	r3, r3, #1 << 20
-	teq	r0, r6
-	bne	1b
+#ifdef CONFIG_ARM_LPAE
+	str	r7, [r0], #4
+#endif
+	add	r3, r3, #1 << SECTION_SHIFT
+	cmp	r0, r6
+	blo	1b
 
 #else /* CONFIG_DEBUG_ICEDCC */
 	/* we don't need any serial debugging mappings for ICEDCC */
@@ -259,6 +293,9 @@ __create_page_tables:
 	str	r3, [r0]
 #endif
 #endif
+#ifdef CONFIG_ARM_LPAE
+	sub	r4, r4, #0x1000		@ point to the PGD table
+#endif
 	mov	pc, lr
 ENDPROC(__create_page_tables)
 	.ltorg
@@ -344,12 +381,17 @@ __enable_mmu:
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
 
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 7c803c4..4147cc6 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -152,6 +152,7 @@ static int __init early_nowrite(char *__unused)
 }
 early_param("nowb", early_nowrite);
 
+#ifndef CONFIG_ARM_LPAE
 static int __init early_ecc(char *p)
 {
 	if (memcmp(p, "on", 2) == 0)
@@ -161,6 +162,7 @@ static int __init early_ecc(char *p)
 	return 0;
 }
 early_param("ecc", early_ecc);
+#endif
 
 static int __init noalign_setup(char *__unused)
 {
@@ -230,10 +232,12 @@ static struct mem_type mem_types[] = {
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
@@ -425,6 +429,7 @@ static void __init build_mem_type_table(void)
 	 * ARMv6 and above have extended page tables.
 	 */
 	if (cpu_arch >= CPU_ARCH_ARMv6 && (cr & CR_XP)) {
+#ifndef CONFIG_ARM_LPAE
 		/*
 		 * Mark cache clean areas and XIP ROM read only
 		 * from SVC mode and no access from userspace.
@@ -432,6 +437,7 @@ static void __init build_mem_type_table(void)
 		mem_types[MT_ROM].prot_sect |= PMD_SECT_APX|PMD_SECT_AP_WRITE;
 		mem_types[MT_MINICLEAN].prot_sect |= PMD_SECT_APX|PMD_SECT_AP_WRITE;
 		mem_types[MT_CACHECLEAN].prot_sect |= PMD_SECT_APX|PMD_SECT_AP_WRITE;
+#endif
 
 		if (is_smp()) {
 			/*
@@ -470,6 +476,18 @@ static void __init build_mem_type_table(void)
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
@@ -587,6 +605,7 @@ static void __init alloc_init_section(pgd_t *pgd, unsigned long addr,
 	}
 }
 
+#ifndef CONFIG_ARM_LPAE
 static void __init create_36bit_mapping(struct map_desc *md,
 					const struct mem_type *type)
 {
@@ -644,6 +663,7 @@ static void __init create_36bit_mapping(struct map_desc *md,
 		pgd += SUPERSECTION_SIZE >> PGDIR_SHIFT;
 	} while (addr != end);
 }
+#endif	/* !CONFIG_ARM_LPAE */
 
 /*
  * Create the page directory entries and any necessary
@@ -674,6 +694,7 @@ static void __init create_mapping(struct map_desc *md)
 
 	type = &mem_types[md->type];
 
+#ifndef CONFIG_ARM_LPAE
 	/*
 	 * Catch 36-bit addresses
 	 */
@@ -681,6 +702,7 @@ static void __init create_mapping(struct map_desc *md)
 		create_36bit_mapping(md, type);
 		return;
 	}
+#endif
 
 	addr = md->virtual & PAGE_MASK;
 	phys = (unsigned long)__pfn_to_phys(md->pfn);
@@ -885,6 +907,14 @@ static inline void prepare_page_table(void)
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
@@ -894,7 +924,7 @@ void __init arm_mm_memblock_reserve(void)
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
index 1098a49..33a8c82 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -19,6 +19,19 @@
 
 #include "proc-macros.S"
 
+#ifdef CONFIG_ARM_LPAE
+#define TTB_IRGN_NC	(0 << 8)
+#define TTB_IRGN_WBWA	(1 << 8)
+#define TTB_IRGN_WT	(2 << 8)
+#define TTB_IRGN_WB	(3 << 8)
+#define TTB_RGN_NC	(0 << 10)
+#define TTB_RGN_OC_WBWA	(1 << 10)
+#define TTB_RGN_OC_WT	(2 << 10)
+#define TTB_RGN_OC_WB	(3 << 10)
+#define TTB_S		(3 << 12)
+#define TTB_NOS		(0)
+#define TTB_EAE		(1 << 31)
+#else
 #define TTB_S		(1 << 1)
 #define TTB_RGN_NC	(0 << 3)
 #define TTB_RGN_OC_WBWA	(1 << 3)
@@ -29,14 +42,15 @@
 #define TTB_IRGN_WBWA	((0 << 0) | (1 << 6))
 #define TTB_IRGN_WT	((1 << 0) | (0 << 6))
 #define TTB_IRGN_WB	((1 << 0) | (1 << 6))
+#endif
 
 /* PTWs cacheable, inner WB not shareable, outer WB not shareable */
-#define TTB_FLAGS_UP	TTB_IRGN_WB|TTB_RGN_OC_WB
-#define PMD_FLAGS_UP	PMD_SECT_WB
+#define TTB_FLAGS_UP	(TTB_IRGN_WB|TTB_RGN_OC_WB)
+#define PMD_FLAGS_UP	(PMD_SECT_WB)
 
 /* PTWs cacheable, inner WBWA shareable, outer WBWA not shareable */
-#define TTB_FLAGS_SMP	TTB_IRGN_WBWA|TTB_S|TTB_NOS|TTB_RGN_OC_WBWA
-#define PMD_FLAGS_SMP	PMD_SECT_WBWA|PMD_SECT_S
+#define TTB_FLAGS_SMP	(TTB_IRGN_WBWA|TTB_S|TTB_NOS|TTB_RGN_OC_WBWA)
+#define PMD_FLAGS_SMP	(PMD_SECT_WBWA|PMD_SECT_S)
 
 ENTRY(cpu_v7_proc_init)
 	mov	pc, lr
@@ -280,10 +294,46 @@ __v7_setup:
 	dsb
 #ifdef CONFIG_MMU
 	mcr	p15, 0, r10, c8, c7, 0		@ invalidate I + D TLBs
+#ifdef CONFIG_ARM_LPAE
+	mov	r5, #TTB_EAE
+	ALT_SMP(orr	r5, r5, #TTB_FLAGS_SMP)
+	ALT_SMP(orr	r5, r5, #TTB_FLAGS_SMP << 16)
+	ALT_UP(orr	r5, r5, #TTB_FLAGS_UP)
+	ALT_UP(orr	r5, r5, #TTB_FLAGS_UP << 16)
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
 	ALT_SMP(orr	r4, r4, #TTB_FLAGS_SMP)
 	ALT_UP(orr	r4, r4, #TTB_FLAGS_UP)
 	mcr	p15, 0, r4, c2, c0, 1		@ load TTB1
+#endif	/* CONFIG_ARM_LPAE */
 	/*
 	 * Memory region attributes with SCTLR.TRE=1
 	 *
@@ -311,11 +361,33 @@ __v7_setup:
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
@@ -334,14 +406,19 @@ __v7_setup:
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
@@ -416,16 +493,20 @@ __v7_proc_info:
 		PMD_TYPE_SECT | \
 		PMD_SECT_AP_WRITE | \
 		PMD_SECT_AP_READ | \
+		PMD_SECT_AF | \
 		PMD_FLAGS_SMP)
 	ALT_UP(.long \
 		PMD_TYPE_SECT | \
 		PMD_SECT_AP_WRITE | \
 		PMD_SECT_AP_READ | \
+		PMD_SECT_AF | \
 		PMD_FLAGS_UP)
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
