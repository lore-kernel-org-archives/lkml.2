Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab0KLSCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:02:30 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50932 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932530Ab0KLSBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:01:17 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/20] ARM: LPAE: Factor out 2-level page table definitions into separate files
Date: Fri, 12 Nov 2010 18:00:22 +0000
Message-Id: <1289584840-18097-3-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c
In-Reply-To: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 12 Nov 2010 18:00:48.0563 (UTC) FILETIME=[894EB030:01CB8293]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves page table definitions from asm/page.h, asm/pgtable.h
and asm/ptgable-hwdef.h into corresponding *-2level* files.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/page.h                 |   40 +-------
 arch/arm/include/asm/pgtable-2level-hwdef.h |   91 +++++++++++++++++
 arch/arm/include/asm/pgtable-2level-types.h |   64 ++++++++++++
 arch/arm/include/asm/pgtable-2level.h       |  147 +++++++++++++++++++++++++++
 arch/arm/include/asm/pgtable-hwdef.h        |   77 +--------------
 arch/arm/include/asm/pgtable.h              |  139 +-------------------------
 6 files changed, 306 insertions(+), 252 deletions(-)
 create mode 100644 arch/arm/include/asm/pgtable-2level-hwdef.h
 create mode 100644 arch/arm/include/asm/pgtable-2level-types.h
 create mode 100644 arch/arm/include/asm/pgtable-2level.h

diff --git a/arch/arm/include/asm/page.h b/arch/arm/include/asm/page.h
index a485ac3..3848105 100644
--- a/arch/arm/include/asm/page.h
+++ b/arch/arm/include/asm/page.h
@@ -151,45 +151,7 @@ extern void __cpu_copy_user_highpage(struct page *to, struct page *from,
 #define clear_page(page)	memset((void *)(page), 0, PAGE_SIZE)
 extern void copy_page(void *to, const void *from);
 
-#undef STRICT_MM_TYPECHECKS
-
-#ifdef STRICT_MM_TYPECHECKS
-/*
- * These are used to make use of C type-checking..
- */
-typedef struct { unsigned long pte; } pte_t;
-typedef struct { unsigned long pmd; } pmd_t;
-typedef struct { unsigned long pgd[2]; } pgd_t;
-typedef struct { unsigned long pgprot; } pgprot_t;
-
-#define pte_val(x)      ((x).pte)
-#define pmd_val(x)      ((x).pmd)
-#define pgd_val(x)	((x).pgd[0])
-#define pgprot_val(x)   ((x).pgprot)
-
-#define __pte(x)        ((pte_t) { (x) } )
-#define __pmd(x)        ((pmd_t) { (x) } )
-#define __pgprot(x)     ((pgprot_t) { (x) } )
-
-#else
-/*
- * .. while these make it easier on the compiler
- */
-typedef unsigned long pte_t;
-typedef unsigned long pmd_t;
-typedef unsigned long pgd_t[2];
-typedef unsigned long pgprot_t;
-
-#define pte_val(x)      (x)
-#define pmd_val(x)      (x)
-#define pgd_val(x)	((x)[0])
-#define pgprot_val(x)   (x)
-
-#define __pte(x)        (x)
-#define __pmd(x)        (x)
-#define __pgprot(x)     (x)
-
-#endif /* STRICT_MM_TYPECHECKS */
+#include <asm/pgtable-2level-types.h>
 
 #endif /* CONFIG_MMU */
 
diff --git a/arch/arm/include/asm/pgtable-2level-hwdef.h b/arch/arm/include/asm/pgtable-2level-hwdef.h
new file mode 100644
index 0000000..436529c
--- /dev/null
+++ b/arch/arm/include/asm/pgtable-2level-hwdef.h
@@ -0,0 +1,91 @@
+/*
+ *  arch/arm/include/asm/pgtable-2level-hwdef.h
+ *
+ *  Copyright (C) 1995-2002 Russell King
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _ASM_PGTABLE_2LEVEL_HWDEF_H
+#define _ASM_PGTABLE_2LEVEL_HWDEF_H
+
+/*
+ * Hardware page table definitions.
+ *
+ * + Level 1 descriptor (PMD)
+ *   - common
+ */
+#define PMD_TYPE_MASK		(3 << 0)
+#define PMD_TYPE_FAULT		(0 << 0)
+#define PMD_TYPE_TABLE		(1 << 0)
+#define PMD_TYPE_SECT		(2 << 0)
+#define PMD_BIT4		(1 << 4)
+#define PMD_DOMAIN(x)		((x) << 5)
+#define PMD_PROTECTION		(1 << 9)	/* v5 */
+/*
+ *   - section
+ */
+#define PMD_SECT_BUFFERABLE	(1 << 2)
+#define PMD_SECT_CACHEABLE	(1 << 3)
+#define PMD_SECT_XN		(1 << 4)	/* v6 */
+#define PMD_SECT_AP_WRITE	(1 << 10)
+#define PMD_SECT_AP_READ	(1 << 11)
+#define PMD_SECT_TEX(x)		((x) << 12)	/* v5 */
+#define PMD_SECT_APX		(1 << 15)	/* v6 */
+#define PMD_SECT_S		(1 << 16)	/* v6 */
+#define PMD_SECT_nG		(1 << 17)	/* v6 */
+#define PMD_SECT_SUPER		(1 << 18)	/* v6 */
+#define PMD_SECT_AF		(0)
+
+#define PMD_SECT_UNCACHED	(0)
+#define PMD_SECT_BUFFERED	(PMD_SECT_BUFFERABLE)
+#define PMD_SECT_WT		(PMD_SECT_CACHEABLE)
+#define PMD_SECT_WB		(PMD_SECT_CACHEABLE | PMD_SECT_BUFFERABLE)
+#define PMD_SECT_MINICACHE	(PMD_SECT_TEX(1) | PMD_SECT_CACHEABLE)
+#define PMD_SECT_WBWA		(PMD_SECT_TEX(1) | PMD_SECT_CACHEABLE | PMD_SECT_BUFFERABLE)
+#define PMD_SECT_NONSHARED_DEV	(PMD_SECT_TEX(2))
+
+/*
+ *   - coarse table (not used)
+ */
+
+/*
+ * + Level 2 descriptor (PTE)
+ *   - common
+ */
+#define PTE_TYPE_MASK		(3 << 0)
+#define PTE_TYPE_FAULT		(0 << 0)
+#define PTE_TYPE_LARGE		(1 << 0)
+#define PTE_TYPE_SMALL		(2 << 0)
+#define PTE_TYPE_EXT		(3 << 0)	/* v5 */
+#define PTE_BUFFERABLE		(1 << 2)
+#define PTE_CACHEABLE		(1 << 3)
+
+/*
+ *   - extended small page/tiny page
+ */
+#define PTE_EXT_XN		(1 << 0)	/* v6 */
+#define PTE_EXT_AP_MASK		(3 << 4)
+#define PTE_EXT_AP0		(1 << 4)
+#define PTE_EXT_AP1		(2 << 4)
+#define PTE_EXT_AP_UNO_SRO	(0 << 4)
+#define PTE_EXT_AP_UNO_SRW	(PTE_EXT_AP0)
+#define PTE_EXT_AP_URO_SRW	(PTE_EXT_AP1)
+#define PTE_EXT_AP_URW_SRW	(PTE_EXT_AP1|PTE_EXT_AP0)
+#define PTE_EXT_TEX(x)		((x) << 6)	/* v5 */
+#define PTE_EXT_APX		(1 << 9)	/* v6 */
+#define PTE_EXT_COHERENT	(1 << 9)	/* XScale3 */
+#define PTE_EXT_SHARED		(1 << 10)	/* v6 */
+#define PTE_EXT_NG		(1 << 11)	/* v6 */
+
+/*
+ *   - small page
+ */
+#define PTE_SMALL_AP_MASK	(0xff << 4)
+#define PTE_SMALL_AP_UNO_SRO	(0x00 << 4)
+#define PTE_SMALL_AP_UNO_SRW	(0x55 << 4)
+#define PTE_SMALL_AP_URO_SRW	(0xaa << 4)
+#define PTE_SMALL_AP_URW_SRW	(0xff << 4)
+
+#endif
diff --git a/arch/arm/include/asm/pgtable-2level-types.h b/arch/arm/include/asm/pgtable-2level-types.h
new file mode 100644
index 0000000..30f6741
--- /dev/null
+++ b/arch/arm/include/asm/pgtable-2level-types.h
@@ -0,0 +1,64 @@
+/*
+ * arch/arm/include/asm/pgtable_32_types.h
+ *
+ * Copyright (C) 1995-2003 Russell King
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
+#ifndef _ASM_PGTABLE_2LEVEL_TYPES_H
+#define _ASM_PGTABLE_2LEVEL_TYPES_H
+
+#undef STRICT_MM_TYPECHECKS
+
+typedef unsigned long pteval_t;
+
+#ifdef STRICT_MM_TYPECHECKS
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef struct { unsigned long pte; } pte_t;
+typedef struct { unsigned long pmd; } pmd_t;
+typedef struct { unsigned long pgd[2]; } pgd_t;
+typedef struct { unsigned long pgprot; } pgprot_t;
+
+#define pte_val(x)      ((x).pte)
+#define pmd_val(x)      ((x).pmd)
+#define pgd_val(x)	((x).pgd[0])
+#define pgprot_val(x)   ((x).pgprot)
+
+#define __pte(x)        ((pte_t) { (x) } )
+#define __pmd(x)        ((pmd_t) { (x) } )
+#define __pgprot(x)     ((pgprot_t) { (x) } )
+
+#else
+/*
+ * .. while these make it easier on the compiler
+ */
+typedef unsigned long pte_t;
+typedef unsigned long pmd_t;
+typedef unsigned long pgd_t[2];
+typedef unsigned long pgprot_t;
+
+#define pte_val(x)      (x)
+#define pmd_val(x)      (x)
+#define pgd_val(x)	((x)[0])
+#define pgprot_val(x)   (x)
+
+#define __pte(x)        (x)
+#define __pmd(x)        (x)
+#define __pgprot(x)     (x)
+
+#endif /* STRICT_MM_TYPECHECKS */
+
+#endif	/* _ASM_PGTABLE_2LEVEL_TYPES_H */
diff --git a/arch/arm/include/asm/pgtable-2level.h b/arch/arm/include/asm/pgtable-2level.h
new file mode 100644
index 0000000..d60bda9
--- /dev/null
+++ b/arch/arm/include/asm/pgtable-2level.h
@@ -0,0 +1,147 @@
+/*
+ *  arch/arm/include/asm/pgtable-2level.h
+ *
+ *  Copyright (C) 1995-2002 Russell King
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _ASM_PGTABLE_2LEVEL_H
+#define _ASM_PGTABLE_2LEVEL_H
+
+/*
+ * Hardware-wise, we have a two level page table structure, where the first
+ * level has 4096 entries, and the second level has 256 entries.  Each entry
+ * is one 32-bit word.  Most of the bits in the second level entry are used
+ * by hardware, and there aren't any "accessed" and "dirty" bits.
+ *
+ * Linux on the other hand has a three level page table structure, which can
+ * be wrapped to fit a two level page table structure easily - using the PGD
+ * and PTE only.  However, Linux also expects one "PTE" table per page, and
+ * at least a "dirty" bit.
+ *
+ * Therefore, we tweak the implementation slightly - we tell Linux that we
+ * have 2048 entries in the first level, each of which is 8 bytes (iow, two
+ * hardware pointers to the second level.)  The second level contains two
+ * hardware PTE tables arranged contiguously, followed by Linux versions
+ * which contain the state information Linux needs.  We, therefore, end up
+ * with 512 entries in the "PTE" level.
+ *
+ * This leads to the page tables having the following layout:
+ *
+ *    pgd             pte
+ * |        |
+ * +--------+ +0
+ * |        |-----> +------------+ +0
+ * +- - - - + +4    |  h/w pt 0  |
+ * |        |-----> +------------+ +1024
+ * +--------+ +8    |  h/w pt 1  |
+ * |        |       +------------+ +2048
+ * +- - - - +       | Linux pt 0 |
+ * |        |       +------------+ +3072
+ * +--------+       | Linux pt 1 |
+ * |        |       +------------+ +4096
+ *
+ * See L_PTE_xxx below for definitions of bits in the "Linux pt", and
+ * PTE_xxx for definitions of bits appearing in the "h/w pt".
+ *
+ * PMD_xxx definitions refer to bits in the first level page table.
+ *
+ * The "dirty" bit is emulated by only granting hardware write permission
+ * iff the page is marked "writable" and "dirty" in the Linux PTE.  This
+ * means that a write to a clean page will cause a permission fault, and
+ * the Linux MM layer will mark the page dirty via handle_pte_fault().
+ * For the hardware to notice the permission change, the TLB entry must
+ * be flushed, and ptep_set_access_flags() does that for us.
+ *
+ * The "accessed" or "young" bit is emulated by a similar method; we only
+ * allow accesses to the page if the "young" bit is set.  Accesses to the
+ * page will cause a fault, and handle_pte_fault() will set the young bit
+ * for us as long as the page is marked present in the corresponding Linux
+ * PTE entry.  Again, ptep_set_access_flags() will ensure that the TLB is
+ * up to date.
+ *
+ * However, when the "young" bit is cleared, we deny access to the page
+ * by clearing the hardware PTE.  Currently Linux does not flush the TLB
+ * for us in this case, which means the TLB will retain the transation
+ * until either the TLB entry is evicted under pressure, or a context
+ * switch which changes the user space mapping occurs.
+ */
+#define PTRS_PER_PTE		512
+#define PTRS_PER_PMD		1
+#define PTRS_PER_PGD		2048
+
+/*
+ * PMD_SHIFT determines the size of the area a second-level page table can map
+ * PGDIR_SHIFT determines what a third-level page table entry can map
+ */
+#define PMD_SHIFT		21
+#define PGDIR_SHIFT		21
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
+#define SECTION_SHIFT		20
+#define SECTION_SIZE		(1UL << SECTION_SHIFT)
+#define SECTION_MASK		(~(SECTION_SIZE-1))
+
+/*
+ * ARMv6 supersection address mask and size definitions.
+ */
+#define SUPERSECTION_SHIFT	24
+#define SUPERSECTION_SIZE	(1UL << SUPERSECTION_SHIFT)
+#define SUPERSECTION_MASK	(~(SUPERSECTION_SIZE-1))
+
+/*
+ * "Linux" PTE definitions.
+ *
+ * We keep two sets of PTEs - the hardware and the linux version.
+ * This allows greater flexibility in the way we map the Linux bits
+ * onto the hardware tables, and allows us to have YOUNG and DIRTY
+ * bits.
+ *
+ * The PTE table pointer refers to the hardware entries; the "Linux"
+ * entries are stored 1024 bytes below.
+ */
+#define L_PTE_PRESENT		(1 << 0)
+#define L_PTE_YOUNG		(1 << 1)
+#define L_PTE_FILE		(1 << 2)	/* only when !PRESENT */
+#define L_PTE_DIRTY		(1 << 6)
+#define L_PTE_WRITE		(1 << 7)
+#define L_PTE_USER		(1 << 8)
+#define L_PTE_EXEC		(1 << 9)
+#define L_PTE_SHARED		(1 << 10)	/* shared(v6), coherent(xsc3) */
+
+/*
+ * These are the memory types, defined to be compatible with
+ * pre-ARMv6 CPUs cacheable and bufferable bits:   XXCB
+ */
+#define L_PTE_MT_UNCACHED	(0x00 << 2)	/* 0000 */
+#define L_PTE_MT_BUFFERABLE	(0x01 << 2)	/* 0001 */
+#define L_PTE_MT_WRITETHROUGH	(0x02 << 2)	/* 0010 */
+#define L_PTE_MT_WRITEBACK	(0x03 << 2)	/* 0011 */
+#define L_PTE_MT_MINICACHE	(0x06 << 2)	/* 0110 (sa1100, xscale) */
+#define L_PTE_MT_WRITEALLOC	(0x07 << 2)	/* 0111 */
+#define L_PTE_MT_DEV_SHARED	(0x04 << 2)	/* 0100 */
+#define L_PTE_MT_DEV_NONSHARED	(0x0c << 2)	/* 1100 */
+#define L_PTE_MT_DEV_WC		(0x09 << 2)	/* 1001 */
+#define L_PTE_MT_DEV_CACHED	(0x0b << 2)	/* 1011 */
+#define L_PTE_MT_MASK		(0x0f << 2)
+
+#endif /* _ASM_PGTABLE_2LEVEL_H */
diff --git a/arch/arm/include/asm/pgtable-hwdef.h b/arch/arm/include/asm/pgtable-hwdef.h
index fd1521d..1831111 100644
--- a/arch/arm/include/asm/pgtable-hwdef.h
+++ b/arch/arm/include/asm/pgtable-hwdef.h
@@ -10,81 +10,6 @@
 #ifndef _ASMARM_PGTABLE_HWDEF_H
 #define _ASMARM_PGTABLE_HWDEF_H
 
-/*
- * Hardware page table definitions.
- *
- * + Level 1 descriptor (PMD)
- *   - common
- */
-#define PMD_TYPE_MASK		(3 << 0)
-#define PMD_TYPE_FAULT		(0 << 0)
-#define PMD_TYPE_TABLE		(1 << 0)
-#define PMD_TYPE_SECT		(2 << 0)
-#define PMD_BIT4		(1 << 4)
-#define PMD_DOMAIN(x)		((x) << 5)
-#define PMD_PROTECTION		(1 << 9)	/* v5 */
-/*
- *   - section
- */
-#define PMD_SECT_BUFFERABLE	(1 << 2)
-#define PMD_SECT_CACHEABLE	(1 << 3)
-#define PMD_SECT_XN		(1 << 4)	/* v6 */
-#define PMD_SECT_AP_WRITE	(1 << 10)
-#define PMD_SECT_AP_READ	(1 << 11)
-#define PMD_SECT_TEX(x)		((x) << 12)	/* v5 */
-#define PMD_SECT_APX		(1 << 15)	/* v6 */
-#define PMD_SECT_S		(1 << 16)	/* v6 */
-#define PMD_SECT_nG		(1 << 17)	/* v6 */
-#define PMD_SECT_SUPER		(1 << 18)	/* v6 */
-
-#define PMD_SECT_UNCACHED	(0)
-#define PMD_SECT_BUFFERED	(PMD_SECT_BUFFERABLE)
-#define PMD_SECT_WT		(PMD_SECT_CACHEABLE)
-#define PMD_SECT_WB		(PMD_SECT_CACHEABLE | PMD_SECT_BUFFERABLE)
-#define PMD_SECT_MINICACHE	(PMD_SECT_TEX(1) | PMD_SECT_CACHEABLE)
-#define PMD_SECT_WBWA		(PMD_SECT_TEX(1) | PMD_SECT_CACHEABLE | PMD_SECT_BUFFERABLE)
-#define PMD_SECT_NONSHARED_DEV	(PMD_SECT_TEX(2))
-
-/*
- *   - coarse table (not used)
- */
-
-/*
- * + Level 2 descriptor (PTE)
- *   - common
- */
-#define PTE_TYPE_MASK		(3 << 0)
-#define PTE_TYPE_FAULT		(0 << 0)
-#define PTE_TYPE_LARGE		(1 << 0)
-#define PTE_TYPE_SMALL		(2 << 0)
-#define PTE_TYPE_EXT		(3 << 0)	/* v5 */
-#define PTE_BUFFERABLE		(1 << 2)
-#define PTE_CACHEABLE		(1 << 3)
-
-/*
- *   - extended small page/tiny page
- */
-#define PTE_EXT_XN		(1 << 0)	/* v6 */
-#define PTE_EXT_AP_MASK		(3 << 4)
-#define PTE_EXT_AP0		(1 << 4)
-#define PTE_EXT_AP1		(2 << 4)
-#define PTE_EXT_AP_UNO_SRO	(0 << 4)
-#define PTE_EXT_AP_UNO_SRW	(PTE_EXT_AP0)
-#define PTE_EXT_AP_URO_SRW	(PTE_EXT_AP1)
-#define PTE_EXT_AP_URW_SRW	(PTE_EXT_AP1|PTE_EXT_AP0)
-#define PTE_EXT_TEX(x)		((x) << 6)	/* v5 */
-#define PTE_EXT_APX		(1 << 9)	/* v6 */
-#define PTE_EXT_COHERENT	(1 << 9)	/* XScale3 */
-#define PTE_EXT_SHARED		(1 << 10)	/* v6 */
-#define PTE_EXT_NG		(1 << 11)	/* v6 */
-
-/*
- *   - small page
- */
-#define PTE_SMALL_AP_MASK	(0xff << 4)
-#define PTE_SMALL_AP_UNO_SRO	(0x00 << 4)
-#define PTE_SMALL_AP_UNO_SRW	(0x55 << 4)
-#define PTE_SMALL_AP_URO_SRW	(0xaa << 4)
-#define PTE_SMALL_AP_URW_SRW	(0xff << 4)
+#include <asm/pgtable-2level-hwdef.h>
 
 #endif
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index b155414..17e7ba6 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -23,6 +23,8 @@
 #include <mach/vmalloc.h>
 #include <asm/pgtable-hwdef.h>
 
+#include <asm/pgtable-2level.h>
+
 /*
  * Just any arbitrary offset to the start of the vmalloc VM area: the
  * current 8MB value just means that there will be a 8MB "hole" after the
@@ -40,75 +42,6 @@
 #define VMALLOC_START		(((unsigned long)high_memory + VMALLOC_OFFSET) & ~(VMALLOC_OFFSET-1))
 #endif
 
-/*
- * Hardware-wise, we have a two level page table structure, where the first
- * level has 4096 entries, and the second level has 256 entries.  Each entry
- * is one 32-bit word.  Most of the bits in the second level entry are used
- * by hardware, and there aren't any "accessed" and "dirty" bits.
- *
- * Linux on the other hand has a three level page table structure, which can
- * be wrapped to fit a two level page table structure easily - using the PGD
- * and PTE only.  However, Linux also expects one "PTE" table per page, and
- * at least a "dirty" bit.
- *
- * Therefore, we tweak the implementation slightly - we tell Linux that we
- * have 2048 entries in the first level, each of which is 8 bytes (iow, two
- * hardware pointers to the second level.)  The second level contains two
- * hardware PTE tables arranged contiguously, followed by Linux versions
- * which contain the state information Linux needs.  We, therefore, end up
- * with 512 entries in the "PTE" level.
- *
- * This leads to the page tables having the following layout:
- *
- *    pgd             pte
- * |        |
- * +--------+ +0
- * |        |-----> +------------+ +0
- * +- - - - + +4    |  h/w pt 0  |
- * |        |-----> +------------+ +1024
- * +--------+ +8    |  h/w pt 1  |
- * |        |       +------------+ +2048
- * +- - - - +       | Linux pt 0 |
- * |        |       +------------+ +3072
- * +--------+       | Linux pt 1 |
- * |        |       +------------+ +4096
- *
- * See L_PTE_xxx below for definitions of bits in the "Linux pt", and
- * PTE_xxx for definitions of bits appearing in the "h/w pt".
- *
- * PMD_xxx definitions refer to bits in the first level page table.
- *
- * The "dirty" bit is emulated by only granting hardware write permission
- * iff the page is marked "writable" and "dirty" in the Linux PTE.  This
- * means that a write to a clean page will cause a permission fault, and
- * the Linux MM layer will mark the page dirty via handle_pte_fault().
- * For the hardware to notice the permission change, the TLB entry must
- * be flushed, and ptep_set_access_flags() does that for us.
- *
- * The "accessed" or "young" bit is emulated by a similar method; we only
- * allow accesses to the page if the "young" bit is set.  Accesses to the
- * page will cause a fault, and handle_pte_fault() will set the young bit
- * for us as long as the page is marked present in the corresponding Linux
- * PTE entry.  Again, ptep_set_access_flags() will ensure that the TLB is
- * up to date.
- *
- * However, when the "young" bit is cleared, we deny access to the page
- * by clearing the hardware PTE.  Currently Linux does not flush the TLB
- * for us in this case, which means the TLB will retain the transation
- * until either the TLB entry is evicted under pressure, or a context
- * switch which changes the user space mapping occurs.
- */
-#define PTRS_PER_PTE		512
-#define PTRS_PER_PMD		1
-#define PTRS_PER_PGD		2048
-
-/*
- * PMD_SHIFT determines the size of the area a second-level page table can map
- * PGDIR_SHIFT determines what a third-level page table entry can map
- */
-#define PMD_SHIFT		21
-#define PGDIR_SHIFT		21
-
 #define LIBRARY_TEXT_START	0x0c000000
 
 #ifndef __ASSEMBLY__
@@ -119,74 +52,6 @@ extern void __pgd_error(const char *file, int line, unsigned long val);
 #define pte_ERROR(pte)		__pte_error(__FILE__, __LINE__, pte_val(pte))
 #define pmd_ERROR(pmd)		__pmd_error(__FILE__, __LINE__, pmd_val(pmd))
 #define pgd_ERROR(pgd)		__pgd_error(__FILE__, __LINE__, pgd_val(pgd))
-#endif /* !__ASSEMBLY__ */
-
-#define PMD_SIZE		(1UL << PMD_SHIFT)
-#define PMD_MASK		(~(PMD_SIZE-1))
-#define PGDIR_SIZE		(1UL << PGDIR_SHIFT)
-#define PGDIR_MASK		(~(PGDIR_SIZE-1))
-
-/*
- * This is the lowest virtual address we can permit any user space
- * mapping to be mapped at.  This is particularly important for
- * non-high vector CPUs.
- */
-#define FIRST_USER_ADDRESS	PAGE_SIZE
-
-#define FIRST_USER_PGD_NR	1
-#define USER_PTRS_PER_PGD	((TASK_SIZE/PGDIR_SIZE) - FIRST_USER_PGD_NR)
-
-/*
- * section address mask and size definitions.
- */
-#define SECTION_SHIFT		20
-#define SECTION_SIZE		(1UL << SECTION_SHIFT)
-#define SECTION_MASK		(~(SECTION_SIZE-1))
-
-/*
- * ARMv6 supersection address mask and size definitions.
- */
-#define SUPERSECTION_SHIFT	24
-#define SUPERSECTION_SIZE	(1UL << SUPERSECTION_SHIFT)
-#define SUPERSECTION_MASK	(~(SUPERSECTION_SIZE-1))
-
-/*
- * "Linux" PTE definitions.
- *
- * We keep two sets of PTEs - the hardware and the linux version.
- * This allows greater flexibility in the way we map the Linux bits
- * onto the hardware tables, and allows us to have YOUNG and DIRTY
- * bits.
- *
- * The PTE table pointer refers to the hardware entries; the "Linux"
- * entries are stored 1024 bytes below.
- */
-#define L_PTE_PRESENT		(1 << 0)
-#define L_PTE_YOUNG		(1 << 1)
-#define L_PTE_FILE		(1 << 2)	/* only when !PRESENT */
-#define L_PTE_DIRTY		(1 << 6)
-#define L_PTE_WRITE		(1 << 7)
-#define L_PTE_USER		(1 << 8)
-#define L_PTE_EXEC		(1 << 9)
-#define L_PTE_SHARED		(1 << 10)	/* shared(v6), coherent(xsc3) */
-
-/*
- * These are the memory types, defined to be compatible with
- * pre-ARMv6 CPUs cacheable and bufferable bits:   XXCB
- */
-#define L_PTE_MT_UNCACHED	(0x00 << 2)	/* 0000 */
-#define L_PTE_MT_BUFFERABLE	(0x01 << 2)	/* 0001 */
-#define L_PTE_MT_WRITETHROUGH	(0x02 << 2)	/* 0010 */
-#define L_PTE_MT_WRITEBACK	(0x03 << 2)	/* 0011 */
-#define L_PTE_MT_MINICACHE	(0x06 << 2)	/* 0110 (sa1100, xscale) */
-#define L_PTE_MT_WRITEALLOC	(0x07 << 2)	/* 0111 */
-#define L_PTE_MT_DEV_SHARED	(0x04 << 2)	/* 0100 */
-#define L_PTE_MT_DEV_NONSHARED	(0x0c << 2)	/* 1100 */
-#define L_PTE_MT_DEV_WC		(0x09 << 2)	/* 1001 */
-#define L_PTE_MT_DEV_CACHED	(0x0b << 2)	/* 1011 */
-#define L_PTE_MT_MASK		(0x0f << 2)
-
-#ifndef __ASSEMBLY__
 
 /*
  * The pgprot_* and protection_map entries will be fixed up in runtime
