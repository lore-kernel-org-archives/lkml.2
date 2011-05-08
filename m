Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1EHMxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 08:53:49 -0400
Received: from service87.mimecast.com ([94.185.240.25]:42916 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753571Ab1EHMwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 08:52:03 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v5 11/19] ARM: LPAE: MMU setup for the 3-level page table format
Date: Sun,  8 May 2011 13:51:30 +0100
Message-Id: <1304859098-10760-12-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 08 May 2011 12:51:51.0663 (UTC) FILETIME=[B391F7F0:01CC0D7E]
X-MC-Unique: 111050813520001301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p48CrxLH020079

This patch adds the MMU initialisation for the LPAE page table format.
The swapper_pg_dir size with LPAE is 5 rather than 4 pages. The
__v7_setup function configures the TTBRx split based on the PAGE_OFFSET
and sets the corresponding TTB control and MAIRx bits (similar to
PRRR/NMRR for TEX remapping). The 36-bit mappings (supersections) and
a few other memory types in mmu.c are conditionally compiled.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/kernel/head.S    |  117 ++++++++++++++++++++++++++++++--------------
 arch/arm/mm/mmu.c         |   32 ++++++++++++-
 arch/arm/mm/proc-macros.S |    5 +-
 arch/arm/mm/proc-v7.S     |  108 +++++++++++++++++++++++++++++++++++++-----
 4 files changed, 210 insertions(+), 52 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index ac368e6..4eea9cf 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -21,6 +21,7 @@
 #include <asm/memory.h>
 #include <asm/thread_info.h>
 #include <asm/system.h>
+#include <asm/pgtable.h>
 
 #ifdef CONFIG_DEBUG_LL
 #include <mach/debug-macro.S>
@@ -38,11 +39,20 @@
 #error KERNEL_RAM_VADDR must start at 0xXXXX8000
 #endif
 
+#ifdef CONFIG_ARM_LPAE
+	/* LPAE requires an additional page for the PGD */
+#define PG_DIR_SIZE	0x5000
+#define PMD_ORDER	3
+#else
+#define PG_DIR_SIZE	0x4000
+#define PMD_ORDER	2
+#endif
+
 	.globl	swapper_pg_dir
-	.equ	swapper_pg_dir, KERNEL_RAM_VADDR - 0x4000
+	.equ	swapper_pg_dir, KERNEL_RAM_VADDR - PG_DIR_SIZE
 
 	.macro	pgtbl, rd, phys
-	add	\rd, \phys, #TEXT_OFFSET - 0x4000
+	add	\rd, \phys, #TEXT_OFFSET - PG_DIR_SIZE
 	.endm
 
 #ifdef CONFIG_XIP_KERNEL
@@ -140,11 +150,11 @@ __create_page_tables:
 	pgtbl	r4, r8				@ page table address
 
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
@@ -152,6 +162,25 @@ __create_page_tables:
 	teq	r0, r6
 	bne	1b
 
+#ifdef CONFIG_ARM_LPAE
+	/*
+	 * Build the PGD table (first level) to point to the PMD table. A PGD
+	 * entry is 64-bit wide.
+	 */
+	mov	r0, r4
+	add	r3, r4, #0x1000			@ first PMD table address
+	orr	r3, r3, #3			@ PGD block type
+	mov	r6, #4				@ PTRS_PER_PGD
+	mov	r7, #1 << (55 - 32)		@ L_PGD_SWAPPER
+1:	str	r3, [r0], #4			@ set bottom PGD entry bits
+	str	r7, [r0], #4			@ set top PGD entry bits
+	add	r3, r3, #0x1000			@ next PMD table
+	subs	r6, r6, #1
+	bne	1b
+
+	add	r4, r4, #0x1000			@ point to the PMD tables
+#endif
+
 	ldr	r7, [r10, #PROCINFO_MM_MMUFLAGS] @ mm_mmuflags
 
 	/*
@@ -163,30 +192,30 @@ __create_page_tables:
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
+	str	r3, [r4, r5, lsl #PMD_ORDER]	@ identity mapping
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
-	add	r0, r4,  #(KERNEL_START & 0xff000000) >> 18
-	str	r3, [r0, #(KERNEL_START & 0x00f00000) >> 18]!
+	mov	r3, r3, lsr #SECTION_SHIFT
+	orr	r3, r7, r3, lsl #SECTION_SHIFT
+	add	r0, r4,  #(KERNEL_START & 0xff000000) >> (SECTION_SHIFT - PMD_ORDER)
+	str	r3, [r0, #(KERNEL_START & 0x00e00000) >> (SECTION_SHIFT - PMD_ORDER)]!
 	ldr	r6, =(KERNEL_END - 1)
-	add	r0, r0, #4
-	add	r6, r4, r6, lsr #18
+	add	r0, r0, #1 << PMD_ORDER
+	add	r6, r4, r6, lsr #(SECTION_SHIFT - PMD_ORDER)
 1:	cmp	r0, r6
-	add	r3, r3, #1 << 20
-	strls	r3, [r0], #4
+	add	r3, r3, #1 << SECTION_SHIFT
+	strls	r3, [r0], #1 << PMD_ORDER
 	bls	1b
 
 #ifdef CONFIG_XIP_KERNEL
@@ -195,11 +224,11 @@ __create_page_tables:
 	 */
 	add	r3, r8, #TEXT_OFFSET
 	orr	r3, r3, r7
-	add	r0, r4,  #(KERNEL_RAM_VADDR & 0xff000000) >> 18
-	str	r3, [r0, #(KERNEL_RAM_VADDR & 0x00f00000) >> 18]!
+	add	r0, r4,  #(KERNEL_RAM_VADDR & 0xff000000) >> (SECTION_SHIFT - PMD_ORDER)
+	str	r3, [r0, #(KERNEL_RAM_VADDR & 0x00f00000) >> (SECTION_SHIFT - PMD_ORDER)]!
 	ldr	r6, =(_end - 1)
 	add	r0, r0, #4
-	add	r6, r4, r6, lsr #18
+	add	r6, r4, r6, lsr #(SECTION_SHIFT - PMD_ORDER)
 1:	cmp	r0, r6
 	add	r3, r3, #1 << 20
 	strls	r3, [r0], #4
@@ -207,15 +236,15 @@ __create_page_tables:
 #endif
 
 	/*
-	 * Then map boot params address in r2 or
-	 * the first 1MB of ram if boot params address is not specified.
+	 * Then map boot params address in r2 or the first 1MB (2MB with LPAE)
+	 * of ram if boot params address is not specified.
 	 */
-	mov	r0, r2, lsr #20
-	movs	r0, r0, lsl #20
+	mov	r0, r2, lsr #SECTION_SHIFT
+	movs	r0, r0, lsl #SECTION_SHIFT
 	moveq	r0, r8
 	sub	r3, r0, r8
 	add	r3, r3, #PAGE_OFFSET
-	add	r3, r4, r3, lsr #18
+	add	r3, r4, r3, lsr #(SECTION_SHIFT - PMD_ORDER)
 	orr	r6, r7, r0
 	str	r6, [r3]
 
@@ -228,21 +257,27 @@ __create_page_tables:
 	 */
 	addruart r7, r3
 
-	mov	r3, r3, lsr #20
-	mov	r3, r3, lsl #2
+	mov	r3, r3, lsr #SECTION_SHIFT
+	mov	r3, r3, lsl #PMD_ORDER
 
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
@@ -254,7 +289,7 @@ __create_page_tables:
 	 * If we're using the NetWinder or CATS, we also need to map
 	 * in the 16550-type serial port for the debug messages
 	 */
-	add	r0, r4, #0xff000000 >> 18
+	add	r0, r4, #0xff000000 >> (SECTION_SHIFT - PMD_ORDER)
 	orr	r3, r7, #0x7c000000
 	str	r3, [r0]
 #endif
@@ -264,13 +299,16 @@ __create_page_tables:
 	 * Similar reasons here - for debug.  This is
 	 * only for Acorn RiscPC architectures.
 	 */
-	add	r0, r4, #0x02000000 >> 18
+	add	r0, r4, #0x02000000 >> (SECTION_SHIFT - PMD_ORDER)
 	orr	r3, r7, #0x02000000
 	str	r3, [r0]
-	add	r0, r4, #0xd8000000 >> 18
+	add	r0, r4, #0xd8000000 >> (SECTION_SHIFT - PMD_ORDER)
 	str	r3, [r0]
 #endif
 #endif
+#ifdef CONFIG_ARM_LPAE
+	sub	r4, r4, #0x1000		@ point to the PGD table
+#endif
 	mov	pc, lr
 ENDPROC(__create_page_tables)
 	.ltorg
@@ -362,12 +400,17 @@ __enable_mmu:
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
index 1e4e05a..6794c92 100644
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
 				L_PTE_RDONLY,
@@ -423,6 +427,7 @@ static void __init build_mem_type_table(void)
 	 * ARMv6 and above have extended page tables.
 	 */
 	if (cpu_arch >= CPU_ARCH_ARMv6 && (cr & CR_XP)) {
+#ifndef CONFIG_ARM_LPAE
 		/*
 		 * Mark cache clean areas and XIP ROM read only
 		 * from SVC mode and no access from userspace.
@@ -430,6 +435,7 @@ static void __init build_mem_type_table(void)
 		mem_types[MT_ROM].prot_sect |= PMD_SECT_APX|PMD_SECT_AP_WRITE;
 		mem_types[MT_MINICLEAN].prot_sect |= PMD_SECT_APX|PMD_SECT_AP_WRITE;
 		mem_types[MT_CACHECLEAN].prot_sect |= PMD_SECT_APX|PMD_SECT_AP_WRITE;
+#endif
 
 		if (is_smp()) {
 			/*
@@ -468,6 +474,18 @@ static void __init build_mem_type_table(void)
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
@@ -597,6 +615,7 @@ static void alloc_init_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
 	} while (pud++, addr = next, addr != end);
 }
 
+#ifndef CONFIG_ARM_LPAE
 static void __init create_36bit_mapping(struct map_desc *md,
 					const struct mem_type *type)
 {
@@ -656,6 +675,7 @@ static void __init create_36bit_mapping(struct map_desc *md,
 		pgd += SUPERSECTION_SIZE >> PGDIR_SHIFT;
 	} while (addr != end);
 }
+#endif	/* !CONFIG_ARM_LPAE */
 
 /*
  * Create the page directory entries and any necessary
@@ -687,6 +707,7 @@ static void __init create_mapping(struct map_desc *md)
 
 	type = &mem_types[md->type];
 
+#ifndef CONFIG_ARM_LPAE
 	/*
 	 * Catch 36-bit addresses
 	 */
@@ -694,6 +715,7 @@ static void __init create_mapping(struct map_desc *md)
 		create_36bit_mapping(md, type);
 		return;
 	}
+#endif
 
 	addr = md->virtual & PAGE_MASK;
 	phys = __pfn_to_phys(md->pfn);
@@ -890,6 +912,14 @@ static inline void prepare_page_table(void)
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
@@ -899,7 +929,7 @@ void __init arm_mm_memblock_reserve(void)
 	 * Reserve the page tables.  These are already in use,
 	 * and can only be in node 0.
 	 */
-	memblock_reserve(__pa(swapper_pg_dir), PTRS_PER_PGD * sizeof(pgd_t));
+	memblock_reserve(__pa(swapper_pg_dir), SWAPPER_PG_DIR_SIZE);
 
 #ifdef CONFIG_SA1111
 	/*
diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index 34261f9..48b85f6 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -91,8 +91,9 @@
 #if L_PTE_SHARED != PTE_EXT_SHARED
 #error PTE shared bit mismatch
 #endif
-#if (L_PTE_XN+L_PTE_USER+L_PTE_RDONLY+L_PTE_DIRTY+L_PTE_YOUNG+\
-     L_PTE_FILE+L_PTE_PRESENT) > L_PTE_SHARED
+#if !defined (CONFIG_ARM_LPAE) && \
+	(L_PTE_XN+L_PTE_USER+L_PTE_RDONLY+L_PTE_DIRTY+L_PTE_YOUNG+\
+	 L_PTE_FILE+L_PTE_PRESENT) > L_PTE_SHARED
 #error Invalid Linux PTE bit settings
 #endif
 #endif	/* CONFIG_MMU */
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 0459397..0996713 100644
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
@@ -212,9 +226,31 @@ cpu_v7_name:
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
+.equ	PRRR,	0xeeaa4400			@ MAIR0
+.equ	NMRR,	0xff000004			@ MAIR1
+#else
 .equ	PRRR,	0xff0a81a8
 .equ	NMRR,	0x40e040e0
+#endif
 
 /* Suspend/resume support: derived from arch/arm/mach-s5pv210/sleep.S */
 .globl	cpu_v7_suspend_size
@@ -380,16 +416,52 @@ __v7_setup:
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
+	add	r6, r8, #1 << 4			@ skip two L1 entries
+#elif defined CONFIG_VMSPLIT_3G
+	/* PAGE_OFFSET == 0xc0000000, T1SZ == 2 */
+	add	r6, r8, #4096 * (1 + 3)		@ only L2 used, skip pgd+3*pmd
+#else
+	mov	r6, r8
+#endif
+	mcrr	p15, 1, r6, r5, c2		@ load TTBR1
+#else	/* !CONFIG_ARM_LPAE */
 	ALT_SMP(orr	r4, r4, #TTB_FLAGS_SMP)
 	ALT_UP(orr	r4, r4, #TTB_FLAGS_UP)
 	ALT_SMP(orr	r8, r8, #TTB_FLAGS_SMP)
 	ALT_UP(orr	r8, r8, #TTB_FLAGS_UP)
 	mcr	p15, 0, r8, c2, c0, 1		@ load TTB1
-	ldr	r5, =PRRR			@ PRRR
-	ldr	r6, =NMRR			@ NMRR
-	mcr	p15, 0, r5, c10, c2, 0		@ write PRRR
-	mcr	p15, 0, r6, c10, c2, 1		@ write NMRR
+#endif	/* CONFIG_ARM_LPAE */
+	ldr	r5, =PRRR			@ PRRR/MAIR0
+	ldr	r6, =NMRR			@ NMRR/MAIR1
+	mcr	p15, 0, r5, c10, c2, 0		@ write PRRR/MAIR0
+	mcr	p15, 0, r6, c10, c2, 1		@ write NMRR/MAIR1
 #endif
 	adr	r5, v7_crval
 	ldmia	r5, {r5, r6}
@@ -408,14 +480,19 @@ __v7_setup:
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
@@ -519,17 +596,20 @@ __v7_ca15mp_proc_info:
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
 		/* PMD_SECT_XN is set explicitly in head.S for LPAE */
 	.long   PMD_TYPE_SECT | \
 		PMD_SECT_XN | \
 		PMD_SECT_AP_WRITE | \
-		PMD_SECT_AP_READ
+		PMD_SECT_AP_READ | \
+		PMD_SECT_AF
 	b	__v7_ca15mp_setup
 	.long	cpu_arch_name
 	.long	cpu_elf_name
@@ -552,16 +632,20 @@ __v7_proc_info:
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
 	W(b)	__v7_setup
 	.long	cpu_arch_name
 	.long	cpu_elf_name

