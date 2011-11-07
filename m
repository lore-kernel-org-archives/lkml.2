Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab1KGQT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:19:28 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49932 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618Ab1KGQRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:17:23 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 09/16] ARM: LPAE: MMU setup for the 3-level page table format
Date: Mon,  7 Nov 2011 16:16:51 +0000
Message-Id: <1320682618-1182-10-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Nov 2011 16:17:12.0482 (UTC) FILETIME=[B4F20020:01CC9D68]
X-MC-Unique: 111110716172005601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pA7GJlHc015310

This patch adds the MMU initialisation for the LPAE page table format.
The swapper_pg_dir size with LPAE is 5 rather than 4 pages. A new
proc-v7-3level.S file contains the TTB initialisation, context switch
and PTE setting code with the LPAE. The TTBRx split is based on the
PAGE_OFFSET with TTBR1 used for the kernel mappings. The 36-bit mappings
(supersections) and a few other memory types in mmu.c are conditionally
compiled.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/kernel/head.S       |   43 ++++++++++++-
 arch/arm/mm/mmu.c            |   30 +++++++++
 arch/arm/mm/proc-macros.S    |    5 +-
 arch/arm/mm/proc-v7-3level.S |  149 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mm/proc-v7.S        |   23 +++++--
 5 files changed, 239 insertions(+), 11 deletions(-)
 create mode 100644 arch/arm/mm/proc-v7-3level.S

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 6ee994c..efa8bdb 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -39,8 +39,14 @@
 #error KERNEL_RAM_VADDR must start at 0xXXXX8000
 #endif
 
+#ifdef CONFIG_ARM_LPAE
+	/* LPAE requires an additional page for the PGD */
+#define PG_DIR_SIZE	0x5000
+#define PMD_ORDER	3
+#else
 #define PG_DIR_SIZE	0x4000
 #define PMD_ORDER	2
+#endif
 
 	.globl	swapper_pg_dir
 	.equ	swapper_pg_dir, KERNEL_RAM_VADDR - PG_DIR_SIZE
@@ -164,6 +170,25 @@ __create_page_tables:
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
@@ -219,8 +244,8 @@ __create_page_tables:
 #endif
 
 	/*
-	 * Then map boot params address in r2 or
-	 * the first 1MB of ram if boot params address is not specified.
+	 * Then map boot params address in r2 or the first 1MB (2MB with LPAE)
+	 * of ram if boot params address is not specified.
 	 */
 	mov	r0, r2, lsr #SECTION_SHIFT
 	movs	r0, r0, lsl #SECTION_SHIFT
@@ -251,7 +276,13 @@ __create_page_tables:
 	mov	r3, r7, lsr #SECTION_SHIFT
 	ldr	r7, [r10, #PROCINFO_IO_MMUFLAGS] @ io_mmuflags
 	orr	r3, r7, r3, lsl #SECTION_SHIFT
+#ifdef CONFIG_ARM_LPAE
+	mov	r7, #1 << (54 - 32)		@ XN
+#endif
 1:	str	r3, [r0], #4
+#ifdef CONFIG_ARM_LPAE
+	str	r7, [r0], #4
+#endif
 	add	r3, r3, #1 << SECTION_SHIFT
 	cmp	r0, r6
 	blo	1b
@@ -283,6 +314,9 @@ __create_page_tables:
 	str	r3, [r0]
 #endif
 #endif
+#ifdef CONFIG_ARM_LPAE
+	sub	r4, r4, #0x1000		@ point to the PGD table
+#endif
 	mov	pc, lr
 ENDPROC(__create_page_tables)
 	.ltorg
@@ -374,12 +408,17 @@ __enable_mmu:
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
index dc8c550..1935311 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -150,6 +150,7 @@ static int __init early_nowrite(char *__unused)
 }
 early_param("nowb", early_nowrite);
 
+#ifndef CONFIG_ARM_LPAE
 static int __init early_ecc(char *p)
 {
 	if (memcmp(p, "on", 2) == 0)
@@ -159,6 +160,7 @@ static int __init early_ecc(char *p)
 	return 0;
 }
 early_param("ecc", early_ecc);
+#endif
 
 static int __init noalign_setup(char *__unused)
 {
@@ -228,10 +230,12 @@ static struct mem_type mem_types[] = {
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
 
 		if (is_smp()) {
 			/*
@@ -474,6 +480,18 @@ static void __init build_mem_type_table(void)
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
@@ -572,8 +590,10 @@ static void __init alloc_init_section(pud_t *pud, unsigned long addr,
 	if (((addr | end | phys) & ~SECTION_MASK) == 0) {
 		pmd_t *p = pmd;
 
+#ifndef CONFIG_ARM_LPAE
 		if (addr & SECTION_SIZE)
 			pmd++;
+#endif
 
 		do {
 			*pmd = __pmd(phys | type->prot_sect);
@@ -603,6 +623,7 @@ static void alloc_init_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
 	} while (pud++, addr = next, addr != end);
 }
 
+#ifndef CONFIG_ARM_LPAE
 static void __init create_36bit_mapping(struct map_desc *md,
 					const struct mem_type *type)
 {
@@ -662,6 +683,7 @@ static void __init create_36bit_mapping(struct map_desc *md,
 		pgd += SUPERSECTION_SIZE >> PGDIR_SHIFT;
 	} while (addr != end);
 }
+#endif	/* !CONFIG_ARM_LPAE */
 
 /*
  * Create the page directory entries and any necessary
@@ -693,6 +715,7 @@ static void __init create_mapping(struct map_desc *md)
 
 	type = &mem_types[md->type];
 
+#ifndef CONFIG_ARM_LPAE
 	/*
 	 * Catch 36-bit addresses
 	 */
@@ -700,6 +723,7 @@ static void __init create_mapping(struct map_desc *md)
 		create_36bit_mapping(md, type);
 		return;
 	}
+#endif
 
 	addr = md->virtual & PAGE_MASK;
 	phys = __pfn_to_phys(md->pfn);
@@ -897,7 +921,13 @@ static inline void prepare_page_table(void)
 		pmd_clear(pmd_off_k(addr));
 }
 
+#ifdef CONFIG_ARM_LPAE
+/* the first page is reserved for pgd */
+#define SWAPPER_PG_DIR_SIZE	(PAGE_SIZE + \
+				 PTRS_PER_PGD * PTRS_PER_PMD * sizeof(pmd_t))
+#else
 #define SWAPPER_PG_DIR_SIZE	(PTRS_PER_PGD * sizeof(pgd_t))
+#endif
 
 /*
  * Reserve the special regions of memory
diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index 307a4de..2d8ff3a 100644
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
diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
new file mode 100644
index 0000000..e2ec6db
--- /dev/null
+++ b/arch/arm/mm/proc-v7-3level.S
@@ -0,0 +1,149 @@
+/*
+ * arch/arm/mm/proc-v7-3level.S
+ *
+ * Copyright (C) 2001 Deep Blue Solutions Ltd.
+ * Copyright (C) 2011 ARM Ltd.
+ * Author: Catalin Marinas <catalin.marinas@arm.com>
+ *   based on arch/arm/mm/proc-v7-2level.S
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#define TTB_IRGN_NC	(0 << 8)
+#define TTB_IRGN_WBWA	(1 << 8)
+#define TTB_IRGN_WT	(2 << 8)
+#define TTB_IRGN_WB	(3 << 8)
+#define TTB_RGN_NC	(0 << 10)
+#define TTB_RGN_OC_WBWA	(1 << 10)
+#define TTB_RGN_OC_WT	(2 << 10)
+#define TTB_RGN_OC_WB	(3 << 10)
+#define TTB_S		(3 << 12)
+#define TTB_EAE		(1 << 31)
+
+/* PTWs cacheable, inner WB not shareable, outer WB not shareable */
+#define TTB_FLAGS_UP	(TTB_IRGN_WB|TTB_RGN_OC_WB)
+#define PMD_FLAGS_UP	(PMD_SECT_WB)
+
+/* PTWs cacheable, inner WBWA shareable, outer WBWA not shareable */
+#define TTB_FLAGS_SMP	(TTB_IRGN_WBWA|TTB_S|TTB_RGN_OC_WBWA)
+#define PMD_FLAGS_SMP	(PMD_SECT_WBWA|PMD_SECT_S)
+
+/*
+ * cpu_v7_switch_mm(pgd_phys, tsk)
+ *
+ * Set the translation table base pointer to be pgd_phys (physical address of
+ * the new TTB).
+ */
+ENTRY(cpu_v7_switch_mm)
+#ifdef CONFIG_MMU
+	ldr	r1, [r1, #MM_CONTEXT_ID]	@ get mm->context.id
+	mov	r2, #0
+	and	r3, r1, #0xff
+	mov	r3, r3, lsl #(48 - 32)		@ ASID
+	mcrr	p15, 0, r0, r3, c2		@ set TTB 0
+	isb
+#endif
+	mov	pc, lr
+ENDPROC(cpu_v7_switch_mm)
+
+/*
+ * cpu_v7_set_pte_ext(ptep, pte)
+ *
+ * Set a level 2 translation table entry.
+ * - ptep - pointer to level 3 translation table entry
+ * - pte - PTE value to store (64-bit in r2 and r3)
+ */
+ENTRY(cpu_v7_set_pte_ext)
+#ifdef CONFIG_MMU
+	tst	r2, #L_PTE_PRESENT
+	beq	1f
+	tst	r3, #1 << (55 - 32)		@ L_PTE_DIRTY
+	orreq	r2, #L_PTE_RDONLY
+1:	strd	r2, r3, [r0]
+	mcr	p15, 0, r0, c7, c10, 1		@ flush_pte
+#endif
+	mov	pc, lr
+ENDPROC(cpu_v7_set_pte_ext)
+
+	/*
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
+	 */
+.equ	PRRR,	0xeeaa4400			@ MAIR0
+.equ	NMRR,	0xff000004			@ MAIR1
+
+	/*
+	 * Macro for setting up the TTBRx and TTBCR registers.
+	 * - \ttbr1 updated.
+	 */
+	.macro	v7_ttb_setup, zero, ttbr0, ttbr1, tmp
+	mrc	p15, 0, \tmp, c2, c0, 2		@ TTB control register
+	orr	\tmp, \tmp, #TTB_EAE
+	ALT_SMP(orr	\tmp, \tmp, #TTB_FLAGS_SMP)
+	ALT_SMP(orr	\tmp, \tmp, #TTB_FLAGS_SMP << 16)
+	ALT_UP(orr	\tmp, \tmp, #TTB_FLAGS_UP)
+	ALT_UP(orr	\tmp, \tmp, #TTB_FLAGS_UP << 16)
+#if PHYS_OFFSET <= PAGE_OFFSET
+	/*
+	 * TTBR0/TTBR1 split (PAGE_OFFSET):
+	 *   0x40000000: T0SZ = 2, T1SZ = 0 (not used)
+	 *   0x80000000: T0SZ = 0, T1SZ = 1
+	 *   0xc0000000: T0SZ = 0, T1SZ = 2
+	 *
+	 * Only use this feature if PHYS_OFFSET <= PAGE_OFFSET, otherwise
+	 * booting secondary CPUs would end up using TTBR1 for the identity
+	 * mapping set up in TTBR0.
+	 */
+	orr	\tmp, \tmp, #(((PAGE_OFFSET >> 30) - 1) << 16) @ TTBCR.T1SZ
+#if defined CONFIG_VMSPLIT_2G
+	/* PAGE_OFFSET == 0x80000000, T1SZ == 1 */
+	add	\ttbr1, \ttbr1, #1 << 4		@ skip two L1 entries
+#elif defined CONFIG_VMSPLIT_3G
+	/* PAGE_OFFSET == 0xc0000000, T1SZ == 2 */
+	add	\ttbr1, \ttbr1, #4096 * (1 + 3)	@ only L2 used, skip pgd+3*pmd
+#endif
+#endif	/* PHYS_OFFSET <= PAGE_OFFSET */
+	mcr	p15, 0, \tmp, c2, c0, 2	@ TTB control register
+	mcrr	p15, 1, \ttbr1, \zero, c2	@ load TTBR1
+	.endm
+
+	__CPUINIT
+
+	/*
+	 *   AT
+	 *  TFR   EV X F   IHD LR    S
+	 * .EEE ..EE PUI. .TAT 4RVI ZWRS BLDP WCAM
+	 * rxxx rrxx xxx0 0101 xxxx xxxx x111 xxxx < forced
+	 *   11    0 110    1  0011 1100 .111 1101 < we want
+	 */
+	.align	2
+	.type	v7_crval, #object
+v7_crval:
+	crval	clear=0x0120c302, mmuset=0x30c23c7d, ucset=0x00c01c7c
+
+	.previous
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 8debdba..468b8b5 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -19,7 +19,11 @@
 
 #include "proc-macros.S"
 
+#ifdef CONFIG_ARM_LPAE
+#include "proc-v7-3level.S"
+#else
 #include "proc-v7-2level.S"
+#endif
 
 ENTRY(cpu_v7_proc_init)
 	mov	pc, lr
@@ -85,7 +89,7 @@ ENDPROC(cpu_v7_dcache_clean_area)
 
 /* Suspend/resume support: derived from arch/arm/mach-s5pv210/sleep.S */
 .globl	cpu_v7_suspend_size
-.equ	cpu_v7_suspend_size, 4 * 7
+.equ	cpu_v7_suspend_size, 4 * 8
 #ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_v7_do_suspend)
 	stmfd	sp!, {r4 - r10, lr}
@@ -94,10 +98,11 @@ ENTRY(cpu_v7_do_suspend)
 	stmia	r0!, {r4 - r5}
 	mrc	p15, 0, r6, c3, c0, 0	@ Domain ID
 	mrc	p15, 0, r7, c2, c0, 1	@ TTB 1
+	mrc	p15, 0, r11, c2, c0, 2	@ TTB control register
 	mrc	p15, 0, r8, c1, c0, 0	@ Control register
 	mrc	p15, 0, r9, c1, c0, 1	@ Auxiliary control register
 	mrc	p15, 0, r10, c1, c0, 2	@ Co-processor access control
-	stmia	r0, {r6 - r10}
+	stmia	r0, {r6 - r11}
 	ldmfd	sp!, {r4 - r10, pc}
 ENDPROC(cpu_v7_do_suspend)
 
@@ -109,13 +114,15 @@ ENTRY(cpu_v7_do_resume)
 	ldmia	r0!, {r4 - r5}
 	mcr	p15, 0, r4, c13, c0, 0	@ FCSE/PID
 	mcr	p15, 0, r5, c13, c0, 3	@ User r/o thread ID
-	ldmia	r0, {r6 - r10}
+	ldmia	r0, {r6 - r11}
 	mcr	p15, 0, r6, c3, c0, 0	@ Domain ID
+#ifndef CONFIG_ARM_LPAE
 	ALT_SMP(orr	r1, r1, #TTB_FLAGS_SMP)
 	ALT_UP(orr	r1, r1, #TTB_FLAGS_UP)
+#endif
 	mcr	p15, 0, r1, c2, c0, 0	@ TTB 0
 	mcr	p15, 0, r7, c2, c0, 1	@ TTB 1
-	mcr	p15, 0, ip, c2, c0, 2	@ TTB control register
+	mcr	p15, 0, r11, c2, c0, 2	@ TTB control register
 	mrc	p15, 0, r4, c1, c0, 1	@ Read Auxiliary control register
 	teq	r4, r9			@ Is it already set?
 	mcrne	p15, 0, r9, c1, c0, 1	@ No, so write it
@@ -289,11 +296,11 @@ __v7_setup_stack:
 	 */
 .macro __v7_proc initfunc, mm_mmuflags = 0, io_mmuflags = 0, hwcaps = 0
 	ALT_SMP(.long	PMD_TYPE_SECT | PMD_SECT_AP_WRITE | PMD_SECT_AP_READ | \
-			PMD_FLAGS_SMP | \mm_mmuflags)
+			PMD_SECT_AF | PMD_FLAGS_SMP | \mm_mmuflags)
 	ALT_UP(.long	PMD_TYPE_SECT | PMD_SECT_AP_WRITE | PMD_SECT_AP_READ | \
-			PMD_FLAGS_UP | \mm_mmuflags)
+			PMD_SECT_AF | PMD_FLAGS_UP | \mm_mmuflags)
 	.long	PMD_TYPE_SECT | PMD_SECT_XN | PMD_SECT_AP_WRITE | \
-		PMD_SECT_AP_READ | \io_mmuflags
+		PMD_SECT_AP_READ | PMD_SECT_AF | \io_mmuflags
 	W(b)	\initfunc
 	.long	cpu_arch_name
 	.long	cpu_elf_name
@@ -306,6 +313,7 @@ __v7_setup_stack:
 	.long	v7_cache_fns
 .endm
 
+#ifndef CONFIG_ARM_LPAE
 	/*
 	 * ARM Ltd. Cortex A5 processor.
 	 */
@@ -325,6 +333,7 @@ __v7_ca9mp_proc_info:
 	.long	0xff0ffff0
 	__v7_proc __v7_ca9mp_setup
 	.size	__v7_ca9mp_proc_info, . - __v7_ca9mp_proc_info
+#endif	/* CONFIG_ARM_LPAE */
 
 	/*
 	 * ARM Ltd. Cortex A15 processor.

