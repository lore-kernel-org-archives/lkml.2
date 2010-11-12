Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab0KLSBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:01:16 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50918 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756871Ab0KLSBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:01:11 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/20] ARM: LPAE: Introduce the 3-level page table format definitions
Date: Fri, 12 Nov 2010 18:00:26 +0000
Message-Id: <1289584840-18097-7-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c
In-Reply-To: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 12 Nov 2010 18:00:49.0938 (UTC) FILETIME=[8A207F20:01CB8293]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the pgtable-3level*.h files with definitions
specific to the LPAE page table format (3 levels of page tables).

Each table is 4KB and has 512 64-bit entries. An entry can point to a
40-bit physical address. The young, write and exec software bits share
the corresponding hardware bits (negated). Other software bits use spare
bits in the PTE.

The patch also changes some variable types from unsigned long or int to
pteval_t or pgprot_t.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/page.h                 |    4 +
 arch/arm/include/asm/pgtable-3level-hwdef.h |   78 ++++++++++++++++++
 arch/arm/include/asm/pgtable-3level-types.h |   55 +++++++++++++
 arch/arm/include/asm/pgtable-3level.h       |  113 +++++++++++++++++++++++++++
 arch/arm/include/asm/pgtable-hwdef.h        |    4 +
 arch/arm/include/asm/pgtable.h              |    6 +-
 arch/arm/mm/mm.h                            |    8 +-
 arch/arm/mm/mmu.c                           |    2 +-
 8 files changed, 264 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm/include/asm/pgtable-3level-hwdef.h
 create mode 100644 arch/arm/include/asm/pgtable-3level-types.h
 create mode 100644 arch/arm/include/asm/pgtable-3level.h

diff --git a/arch/arm/include/asm/page.h b/arch/arm/include/asm/page.h
index 3848105..e5124db 100644
--- a/arch/arm/include/asm/page.h
+++ b/arch/arm/include/asm/page.h
@@ -151,7 +151,11 @@ extern void __cpu_copy_user_highpage(struct page *to, struct page *from,
 #define clear_page(page)	memset((void *)(page), 0, PAGE_SIZE)
 extern void copy_page(void *to, const void *from);
 
+#ifdef CONFIG_ARM_LPAE
+#include <asm/pgtable-3level-types.h>
+#else
 #include <asm/pgtable-2level-types.h>
+#endif
 
 #endif /* CONFIG_MMU */
 
diff --git a/arch/arm/include/asm/pgtable-3level-hwdef.h b/arch/arm/include/asm/pgtable-3level-hwdef.h
new file mode 100644
index 0000000..2f99c3c
--- /dev/null
+++ b/arch/arm/include/asm/pgtable-3level-hwdef.h
@@ -0,0 +1,78 @@
+/*
+ * arch/arm/include/asm/pgtable-3level-hwdef.h
+ *
+ * Copyright (C) 2010 ARM Ltd.
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
+#ifndef _ASM_PGTABLE_3LEVEL_HWDEF_H
+#define _ASM_PGTABLE_3LEVEL_HWDEF_H
+
+#include <linux/const.h>
+#include <asm/pgtable-3level-types.h>
+
+/*
+ * Hardware page table definitions.
+ *
+ * + Level 1/2 descriptor
+ *   - common
+ */
+#define PMD_TYPE_MASK		(_AT(pmd_t, 3) << 0)
+#define PMD_TYPE_FAULT		(_AT(pmd_t, 0) << 0)
+#define PMD_TYPE_TABLE		(_AT(pmd_t, 3) << 0)
+#define PMD_TYPE_SECT		(_AT(pmd_t, 1) << 0)
+#define PMD_BIT4		(_AT(pmd_t, 0))
+#define PMD_DOMAIN(x)		(_AT(pmd_t, 0))
+
+/*
+ *   - section
+ */
+#define PMD_SECT_BUFFERABLE	(_AT(pmd_t, 1) << 2)
+#define PMD_SECT_CACHEABLE	(_AT(pmd_t, 1) << 3)
+#define PMD_SECT_S		(_AT(pmd_t, 3) << 8)
+#define PMD_SECT_AF		(_AT(pmd_t, 1) << 10)
+#define PMD_SECT_nG		(_AT(pmd_t, 1) << 11)
+#ifdef __ASSEMBLY__
+/* avoid 'shift count out of range' warning */
+#define PMD_SECT_XN		(0)
+#else
+#define PMD_SECT_XN		((pmd_t)1 << 54)
+#endif
+#define PMD_SECT_AP_WRITE	(_AT(pmd_t, 0))
+#define PMD_SECT_AP_READ	(_AT(pmd_t, 0))
+#define PMD_SECT_TEX(x)		(_AT(pmd_t, 0))
+
+/*
+ * AttrIndx[2:0] encoding (mapping attributes defined in the MAIR* registers).
+ */
+#define PMD_SECT_UNCACHED	(_AT(pteval_t, 0) << 2)	/* strongly ordered */
+#define PMD_SECT_BUFFERED	(_AT(pteval_t, 1) << 2)	/* normal non-cacheable */
+#define PMD_SECT_WT		(_AT(pteval_t, 2) << 2)	/* normal inner write-through */
+#define PMD_SECT_WB		(_AT(pteval_t, 3) << 2)	/* normal inner write-back */
+#define PMD_SECT_WBWA		(_AT(pteval_t, 7) << 2)	/* normal inner write-alloc */
+
+/*
+ * + Level 3 descriptor (PTE)
+ */
+#define PTE_TYPE_MASK		(_AT(pteval_t, 3) << 0)
+#define PTE_TYPE_FAULT		(_AT(pteval_t, 0) << 0)
+#define PTE_TYPE_PAGE		(_AT(pteval_t, 3) << 0)
+#define PTE_BUFFERABLE		(_AT(pteval_t, 1) << 2)		/* AttrIndx[0] */
+#define PTE_CACHEABLE		(_AT(pteval_t, 1) << 3)		/* AttrIndx[1] */
+#define PTE_EXT_SHARED		(_AT(pteval_t, 3) << 8)		/* SH[1:0], inner shareable */
+#define PTE_EXT_AF		(_AT(pteval_t, 1) << 10)	/* Access Flag */
+#define PTE_EXT_NG		(_AT(pteval_t, 1) << 11)	/* nG */
+#define PTE_EXT_XN		(_AT(pteval_t, 1) << 54)	/* XN */
+
+#endif
diff --git a/arch/arm/include/asm/pgtable-3level-types.h b/arch/arm/include/asm/pgtable-3level-types.h
new file mode 100644
index 0000000..c9aca5b
--- /dev/null
+++ b/arch/arm/include/asm/pgtable-3level-types.h
@@ -0,0 +1,55 @@
+/*
+ * arch/arm/include/asm/pgtable-3level-types.h
+ *
+ * Copyright (C) 2010 ARM Ltd.
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
+#ifndef _ASM_PGTABLE_3LEVEL_TYPES_H
+#define _ASM_PGTABLE_3LEVEL_TYPES_H
+
+#ifndef __ASSEMBLY__
+
+typedef u64 pteval_t;
+typedef u64 pte_t;
+typedef u64 pmd_t;
+typedef u64 pgd_t;
+typedef u64 pgprot_t;
+
+#define pte_val(x)	(x)
+#define pmd_val(x)	(x)
+#define pgd_val(x)	(x)
+#define pgprot_val(x)	(x)
+
+#define __pte(x)	(x)
+#define __pmd(x)	(x)
+#define __pgd(x)	(x)
+#define __pgprot(x)	(x)
+
+/*
+ * 40-bit physical address supported.
+ */
+#define __PHYSICAL_MASK_SHIFT	(40)
+#define __PHYSICAL_MASK		((1ULL << __PHYSICAL_MASK_SHIFT) - 1)
+
+/*
+ * Mask for extracting the PFN from a PTE value. The PAGE_MASK is
+ * sign-extended to 64-bit because the physical range is larger than the
+ * virtual one.
+ */
+#define PTE_PFN_MASK	((u64)((s32)PAGE_MASK & __PHYSICAL_MASK))
+
+#endif	/* __ASSEMBLY__ */
+
+#endif	/* _ASM_PGTABLE_3LEVEL_TYPES_H */
diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
new file mode 100644
index 0000000..5b1482d
--- /dev/null
+++ b/arch/arm/include/asm/pgtable-3level.h
@@ -0,0 +1,113 @@
+/*
+ * arch/arm/include/asm/pgtable-3level.h
+ *
+ * Copyright (C) 2010 ARM Ltd.
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
+#ifndef _ASM_PGTABLE_3LEVEL_H
+#define _ASM_PGTABLE_3LEVEL_H
+
+#include <linux/const.h>
+#include <asm/pgtable-3level-types.h>
+
+/*
+ * With LPAE, there are 3 levels of page tables. Each level has 512 entries of
+ * 8 bytes each, occupying a 4K page. The first level table covers a range of
+ * 512GB, each entry representing 1GB. Since we are limited to 4GB input
+ * address range, only 4 entries in the PGD are used.
+ *
+ * There are enough spare bits in a page table entry for the kernel specific
+ * state.
+ */
+#define PTRS_PER_PTE		512
+#define PTRS_PER_PMD		512
+#define PTRS_PER_PGD		4
+#define LINUX_PTE_OFFSET	0
+
+/*
+ * PGDIR_SHIFT determines the size a top-level page table entry can map.
+ */
+#define PGDIR_SHIFT		30
+
+/*
+ * PMD_SHIFT determines the size a middle-level page table entry can map.
+ */
+#define PMD_SHIFT		21
+
+#define PMD_SIZE		(1UL << PMD_SHIFT)
+#define PMD_MASK		(~(PMD_SIZE-1))
+#define PGDIR_SIZE		(1UL << PGDIR_SHIFT)
+#define PGDIR_MASK		(~(PGDIR_SIZE-1))
+
+/*
+ * This is the lowest virtual address we can permit any user space
+ * mapping to be mapped at.  This is particularly important for
+ * non-high vector CPUs.
+ */
+#define FIRST_USER_ADDRESS	PAGE_SIZE
+
+#define FIRST_USER_PGD_NR	1
+#define USER_PTRS_PER_PGD	((TASK_SIZE/PGDIR_SIZE) - FIRST_USER_PGD_NR)
+
+/*
+ * section address mask and size definitions.
+ */
+#define SECTION_SHIFT		21
+#define SECTION_SIZE		(1UL << SECTION_SHIFT)
+#define SECTION_MASK		(~(SECTION_SIZE-1))
+
+/*
+ * "Linux" PTE definitions for LPAE.
+ *
+ * These bits overlap with the hardware bits but the naming is preserved for
+ * consistency with the classic page table format.
+ */
+#define L_PTE_PRESENT		(_AT(pteval_t, 3) << 0)		/* Valid */
+#define L_PTE_FILE		(_AT(pteval_t, 1) << 2)		/* only when !PRESENT */
+#define L_PTE_BUFFERABLE	(_AT(pteval_t, 1) << 2)		/* AttrIndx[0] */
+#define L_PTE_CACHEABLE		(_AT(pteval_t, 1) << 3)		/* AttrIndx[1] */
+#define L_PTE_USER		(_AT(pteval_t, 1) << 6)		/* AP[1] */
+#define L_PTE_NOWRITE		(_AT(pteval_t, 1) << 7)		/* AP[2] */
+#define L_PTE_SHARED		(_AT(pteval_t, 3) << 8)		/* SH[1:0], inner shareable */
+#define L_PTE_YOUNG		(_AT(pteval_t, 1) << 10)	/* AF */
+#define L_PTE_NOEXEC		(_AT(pteval_t, 1) << 54)	/* XN */
+#define L_PTE_DIRTY		(_AT(pteval_t, 1) << 55)	/* unused */
+#define L_PTE_SPECIAL		(_AT(pteval_t, 1) << 56)	/* unused */
+#define L_PTE_EXEC		(_AT(pteval_t, 0))
+#define L_PTE_WRITE		(_AT(pteval_t, 0))
+
+/*
+ * To be used in assembly code with the upper page attributes.
+ */
+#define L_PTE_NOEXEC_HIGH	(1 << (54 - 32))
+#define L_PTE_DIRTY_HIGH	(1 << (55 - 32))
+
+#define L_PTE_SWP_SHIFT		2	/* shift for the swap or file PTE */
+
+/*
+ * AttrIndx[2:0] encoding (mapping attributes defined in the MAIR* registers).
+ */
+#define L_PTE_MT_UNCACHED	(_AT(pteval_t, 0) << 2)	/* strongly ordered */
+#define L_PTE_MT_BUFFERABLE	(_AT(pteval_t, 1) << 2)	/* normal non-cacheable */
+#define L_PTE_MT_WRITETHROUGH	(_AT(pteval_t, 2) << 2)	/* normal inner write-through */
+#define L_PTE_MT_WRITEBACK	(_AT(pteval_t, 3) << 2)	/* normal inner write-back */
+#define L_PTE_MT_WRITEALLOC	(_AT(pteval_t, 7) << 2)	/* normal inner write-alloc */
+#define L_PTE_MT_DEV_SHARED	(_AT(pteval_t, 4) << 2)	/* device */
+#define L_PTE_MT_DEV_NONSHARED	(_AT(pteval_t, 4) << 2)	/* device */
+#define L_PTE_MT_DEV_WC		(_AT(pteval_t, 1) << 2)	/* normal non-cacheable */
+#define L_PTE_MT_DEV_CACHED	(_AT(pteval_t, 3) << 2)	/* normal inner write-back */
+#define L_PTE_MT_MASK		(_AT(pteval_t, 7) << 2)
+
+#endif /* _ASM_PGTABLE_3LEVEL_H */
diff --git a/arch/arm/include/asm/pgtable-hwdef.h b/arch/arm/include/asm/pgtable-hwdef.h
index 1831111..8426229 100644
--- a/arch/arm/include/asm/pgtable-hwdef.h
+++ b/arch/arm/include/asm/pgtable-hwdef.h
@@ -10,6 +10,10 @@
 #ifndef _ASMARM_PGTABLE_HWDEF_H
 #define _ASMARM_PGTABLE_HWDEF_H
 
+#ifdef CONFIG_ARM_LPAE
+#include <asm/pgtable-3level-hwdef.h>
+#else
 #include <asm/pgtable-2level-hwdef.h>
+#endif
 
 #endif
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 5bd0e64..97a5de3 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -23,7 +23,11 @@
 #include <mach/vmalloc.h>
 #include <asm/pgtable-hwdef.h>
 
+#ifdef CONFIG_ARM_LPAE
+#include <asm/pgtable-3level.h>
+#else
 #include <asm/pgtable-2level.h>
+#endif
 
 /*
  * Just any arbitrary offset to the start of the vmalloc VM area: the
@@ -283,7 +287,7 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
-	const unsigned long mask = L_PTE_EXEC | L_PTE_WRITE | L_PTE_USER |
+	const pteval_t mask = L_PTE_EXEC | L_PTE_WRITE | L_PTE_USER |
 		L_PTE_NOEXEC | L_PTE_NOWRITE;
 	pte_val(pte) = (pte_val(pte) & ~mask) | (pgprot_val(newprot) & mask);
 	return pte;
diff --git a/arch/arm/mm/mm.h b/arch/arm/mm/mm.h
index 6630620..a62f093 100644
--- a/arch/arm/mm/mm.h
+++ b/arch/arm/mm/mm.h
@@ -16,10 +16,10 @@ static inline pmd_t *pmd_off_k(unsigned long virt)
 }
 
 struct mem_type {
-	unsigned int prot_pte;
-	unsigned int prot_l1;
-	unsigned int prot_sect;
-	unsigned int domain;
+	pgprot_t prot_pte;
+	pgprot_t prot_l1;
+	pgprot_t prot_sect;
+	pgprot_t domain;
 };
 
 const struct mem_type *get_mem_type(unsigned int type);
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 0ca33dd..7c803c4 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -292,7 +292,7 @@ static void __init build_mem_type_table(void)
 {
 	struct cachepolicy *cp;
 	unsigned int cr = get_cr();
-	unsigned int user_pgprot, kern_pgprot, vecs_pgprot;
+	pgprot_t user_pgprot, kern_pgprot, vecs_pgprot;
 	int cpu_arch = cpu_architecture();
 	int i;
 
