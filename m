Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936724Ab2C3XBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:01:20 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934853Ab2C3VFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:18 -0400
Message-Id: <201203302104.q2UL4wL6006262@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 13:58:43 -0400
Subject: [PATCH] arch/tile: Allow tilegx to build with either 16K or 64K page size
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Joe Perches <joe@perches.com>, Ralf Baechle <ralf@linux-mips.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Julia Lawall <julia@diku.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:03.0444 (UTC) FILETIME=[C6B9A940:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change introduces new flags for the hv_install_context()
API that passes a page table pointer to the hypervisor.  Clients
can explicitly request 4K, 16K, or 64K small pages when they
install a new context.  In practice, the page size is fixed at
kernel compile time and the same size is always requested every
time a new page table is installed.

The <hv/hypervisor.h> header changes so that it provides more abstract
macros for managing "page" things like PFNs and page tables.  For
example there is now a HV_DEFAULT_PAGE_SIZE_SMALL instead of the old
HV_PAGE_SIZE_SMALL.  The various PFN routines have been eliminated and
only PA- or PTFN-based ones remain (since PTFNs are always expressed
in fixed 2KB "page" size).  The page-table management macros are
renamed with a leading underscore and take page-size arguments with
the presumption that clients will use those macros in some single
place to provide the "real" macros they will use themselves.

I happened to notice the old hv_set_caching() API was totally broken
(it assumed 4KB pages) so I changed it so it would nominally work
correctly with other page sizes.

Tag modules with the page size so you can't load a module built with
a conflicting page size.  (And add a test for SMP while we're at it.)

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig                    |   25 ++++
 arch/tile/include/asm/Kbuild         |    1 -
 arch/tile/include/asm/mmu.h          |    2 +-
 arch/tile/include/asm/mmu_context.h  |    8 +-
 arch/tile/include/asm/module.h       |   40 +++++++
 arch/tile/include/asm/page.h         |   13 ++-
 arch/tile/include/asm/pgalloc.h      |   92 +++++++++++----
 arch/tile/include/asm/pgtable.h      |   10 +-
 arch/tile/include/asm/pgtable_32.h   |   14 ++-
 arch/tile/include/asm/pgtable_64.h   |   28 +++--
 arch/tile/include/hv/drv_xgbe_intf.h |    2 +-
 arch/tile/include/hv/hypervisor.h    |  214 +++++++++++++++++++---------------
 arch/tile/kernel/head_32.S           |    8 +-
 arch/tile/kernel/head_64.S           |   22 ++--
 arch/tile/kernel/machine_kexec.c     |    7 +-
 arch/tile/kernel/setup.c             |    8 +-
 arch/tile/kernel/smp.c               |    2 +-
 arch/tile/kernel/stack.c             |   13 +-
 arch/tile/lib/memcpy_tile64.c        |    8 +-
 arch/tile/mm/init.c                  |   11 +--
 arch/tile/mm/pgtable.c               |   27 ++---
 21 files changed, 351 insertions(+), 204 deletions(-)
 create mode 100644 arch/tile/include/asm/module.h

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 96033e2..d5f2e57 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -138,6 +138,31 @@ config NR_CPUS
 	  smaller kernel memory footprint results from using a smaller
 	  value on chips with fewer tiles.
 
+if TILEGX
+
+choice
+	prompt "Kernel page size"
+	default PAGE_SIZE_64KB
+	help
+	  This lets you select the page size of the kernel.  For best
+	  performance on memory-intensive applications, a page size of 64KB
+	  is recommended.  For workloads involving many small files, many
+	  connections, etc., it may be better to select 16KB, which uses
+	  memory more efficiently at some cost in TLB performance.
+
+	  Note that this option is TILE-Gx specific; currently
+	  TILEPro page size is set by rebuilding the hypervisor.
+
+config PAGE_SIZE_16KB
+	bool "16KB"
+
+config PAGE_SIZE_64KB
+	bool "64KB"
+
+endchoice
+
+endif
+
 source "kernel/time/Kconfig"
 
 source "kernel/Kconfig.hz"
diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index 0bb4264..6b2e681 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -21,7 +21,6 @@ generic-y += ipcbuf.h
 generic-y += irq_regs.h
 generic-y += kdebug.h
 generic-y += local.h
-generic-y += module.h
 generic-y += msgbuf.h
 generic-y += mutex.h
 generic-y += param.h
diff --git a/arch/tile/include/asm/mmu.h b/arch/tile/include/asm/mmu.h
index 92f94c7..e2c7890 100644
--- a/arch/tile/include/asm/mmu.h
+++ b/arch/tile/include/asm/mmu.h
@@ -21,7 +21,7 @@ struct mm_context {
 	 * Written under the mmap_sem semaphore; read without the
 	 * semaphore but atomically, but it is conservatively set.
 	 */
-	unsigned int priority_cached;
+	unsigned long priority_cached;
 };
 
 typedef struct mm_context mm_context_t;
diff --git a/arch/tile/include/asm/mmu_context.h b/arch/tile/include/asm/mmu_context.h
index 15fb246..37f0b74 100644
--- a/arch/tile/include/asm/mmu_context.h
+++ b/arch/tile/include/asm/mmu_context.h
@@ -30,11 +30,15 @@ init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 	return 0;
 }
 
-/* Note that arch/tile/kernel/head.S also calls hv_install_context() */
+/*
+ * Note that arch/tile/kernel/head_NN.S and arch/tile/mm/migrate_NN.S
+ * also call hv_install_context().
+ */
 static inline void __install_page_table(pgd_t *pgdir, int asid, pgprot_t prot)
 {
 	/* FIXME: DIRECTIO should not always be set. FIXME. */
-	int rc = hv_install_context(__pa(pgdir), prot, asid, HV_CTX_DIRECTIO);
+	int rc = hv_install_context(__pa(pgdir), prot, asid,
+				    HV_CTX_DIRECTIO | CTX_PAGE_FLAG);
 	if (rc < 0)
 		panic("hv_install_context failed: %d", rc);
 }
diff --git a/arch/tile/include/asm/module.h b/arch/tile/include/asm/module.h
new file mode 100644
index 0000000..44ed07c
--- /dev/null
+++ b/arch/tile/include/asm/module.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_MODULE_H
+#define _ASM_TILE_MODULE_H
+
+#include <arch/chip.h>
+
+#include <asm-generic/module.h>
+
+/* We can't use modules built with different page sizes. */
+#if defined(CONFIG_PAGE_SIZE_16KB)
+# define MODULE_PGSZ " 16KB"
+#elif defined(CONFIG_PAGE_SIZE_64KB)
+# define MODULE_PGSZ " 64KB"
+#else
+# define MODULE_PGSZ ""
+#endif
+
+/* We don't really support no-SMP so tag if someone tries. */
+#ifdef CONFIG_SMP
+#define MODULE_NOSMP ""
+#else
+#define MODULE_NOSMP " nosmp"
+#endif
+
+#define MODULE_ARCH_VERMAGIC CHIP_ARCH_NAME MODULE_PGSZ MODULE_NOSMP
+
+#endif /* _ASM_TILE_MODULE_H */
diff --git a/arch/tile/include/asm/page.h b/arch/tile/include/asm/page.h
index db93518..c750943 100644
--- a/arch/tile/include/asm/page.h
+++ b/arch/tile/include/asm/page.h
@@ -20,8 +20,17 @@
 #include <arch/chip.h>
 
 /* PAGE_SHIFT and HPAGE_SHIFT determine the page sizes. */
-#define PAGE_SHIFT	HV_LOG2_PAGE_SIZE_SMALL
-#define HPAGE_SHIFT	HV_LOG2_PAGE_SIZE_LARGE
+#if defined(CONFIG_PAGE_SIZE_16KB)
+#define PAGE_SHIFT	14
+#define CTX_PAGE_FLAG	HV_CTX_PG_SM_16K
+#elif defined(CONFIG_PAGE_SIZE_64KB)
+#define PAGE_SHIFT	16
+#define CTX_PAGE_FLAG	HV_CTX_PG_SM_64K
+#else
+#define PAGE_SHIFT	HV_LOG2_DEFAULT_PAGE_SIZE_SMALL
+#define CTX_PAGE_FLAG	0
+#endif
+#define HPAGE_SHIFT	HV_LOG2_DEFAULT_PAGE_SIZE_LARGE
 
 #define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
 #define HPAGE_SIZE	(_AC(1, UL) << HPAGE_SHIFT)
diff --git a/arch/tile/include/asm/pgalloc.h b/arch/tile/include/asm/pgalloc.h
index e919c0b..1b90250 100644
--- a/arch/tile/include/asm/pgalloc.h
+++ b/arch/tile/include/asm/pgalloc.h
@@ -19,24 +19,24 @@
 #include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <asm/fixmap.h>
+#include <asm/page.h>
 #include <hv/hypervisor.h>
 
 /* Bits for the size of the second-level page table. */
-#define L2_KERNEL_PGTABLE_SHIFT \
-  (HV_LOG2_PAGE_SIZE_LARGE - HV_LOG2_PAGE_SIZE_SMALL + HV_LOG2_PTE_SIZE)
+#define L2_KERNEL_PGTABLE_SHIFT _HV_LOG2_L2_SIZE(HPAGE_SHIFT, PAGE_SHIFT)
+
+/* How big is a kernel L2 page table? */
+#define L2_KERNEL_PGTABLE_SIZE (1UL << L2_KERNEL_PGTABLE_SHIFT)
 
 /* We currently allocate user L2 page tables by page (unlike kernel L2s). */
-#if L2_KERNEL_PGTABLE_SHIFT < HV_LOG2_PAGE_SIZE_SMALL
-#define L2_USER_PGTABLE_SHIFT HV_LOG2_PAGE_SIZE_SMALL
+#if L2_KERNEL_PGTABLE_SHIFT < PAGE_SHIFT
+#define L2_USER_PGTABLE_SHIFT PAGE_SHIFT
 #else
 #define L2_USER_PGTABLE_SHIFT L2_KERNEL_PGTABLE_SHIFT
 #endif
 
 /* How many pages do we need, as an "order", for a user L2 page table? */
-#define L2_USER_PGTABLE_ORDER (L2_USER_PGTABLE_SHIFT - HV_LOG2_PAGE_SIZE_SMALL)
-
-/* How big is a kernel L2 page table? */
-#define L2_KERNEL_PGTABLE_SIZE (1 << L2_KERNEL_PGTABLE_SHIFT)
+#define L2_USER_PGTABLE_ORDER (L2_USER_PGTABLE_SHIFT - PAGE_SHIFT)
 
 static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
@@ -50,14 +50,14 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 static inline void pmd_populate_kernel(struct mm_struct *mm,
 				       pmd_t *pmd, pte_t *ptep)
 {
-	set_pmd(pmd, ptfn_pmd(__pa(ptep) >> HV_LOG2_PAGE_TABLE_ALIGN,
+	set_pmd(pmd, ptfn_pmd(HV_CPA_TO_PTFN(__pa(ptep)),
 			      __pgprot(_PAGE_PRESENT)));
 }
 
 static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
 				pgtable_t page)
 {
-	set_pmd(pmd, ptfn_pmd(HV_PFN_TO_PTFN(page_to_pfn(page)),
+	set_pmd(pmd, ptfn_pmd(HV_CPA_TO_PTFN(PFN_PHYS(page_to_pfn(page))),
 			      __pgprot(_PAGE_PRESENT)));
 }
 
@@ -68,8 +68,20 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
 
-extern pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address);
-extern void pte_free(struct mm_struct *mm, struct page *pte);
+extern pgtable_t pgtable_alloc_one(struct mm_struct *mm, unsigned long address,
+				   int order);
+extern void pgtable_free(struct mm_struct *mm, struct page *pte, int order);
+
+static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
+				      unsigned long address)
+{
+	return pgtable_alloc_one(mm, address, L2_USER_PGTABLE_ORDER);
+}
+
+static inline void pte_free(struct mm_struct *mm, struct page *pte)
+{
+	pgtable_free(mm, pte, L2_USER_PGTABLE_ORDER);
+}
 
 #define pmd_pgtable(pmd) pmd_page(pmd)
 
@@ -85,8 +97,13 @@ static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 	pte_free(mm, virt_to_page(pte));
 }
 
-extern void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte,
-			   unsigned long address);
+extern void __pgtable_free_tlb(struct mmu_gather *tlb, struct page *pte,
+			       unsigned long address, int order);
+static inline void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte,
+				  unsigned long address)
+{
+	__pgtable_free_tlb(tlb, pte, address, L2_USER_PGTABLE_ORDER);
+}
 
 #define check_pgt_cache()	do { } while (0)
 
@@ -104,19 +121,44 @@ void shatter_pmd(pmd_t *pmd);
 void shatter_huge_page(unsigned long addr);
 
 #ifdef __tilegx__
-/* We share a single page allocator for both L1 and L2 page tables. */
-#if HV_L1_SIZE != HV_L2_SIZE
-# error Rework assumption that L1 and L2 page tables are same size.
-#endif
-#define L1_USER_PGTABLE_ORDER L2_USER_PGTABLE_ORDER
+
 #define pud_populate(mm, pud, pmd) \
   pmd_populate_kernel((mm), (pmd_t *)(pud), (pte_t *)(pmd))
-#define pmd_alloc_one(mm, addr) \
-  ((pmd_t *)page_to_virt(pte_alloc_one((mm), (addr))))
-#define pmd_free(mm, pmdp) \
-  pte_free((mm), virt_to_page(pmdp))
-#define __pmd_free_tlb(tlb, pmdp, address) \
-  __pte_free_tlb((tlb), virt_to_page(pmdp), (address))
+
+/* Bits for the size of the L1 (intermediate) page table. */
+#define L1_KERNEL_PGTABLE_SHIFT _HV_LOG2_L1_SIZE(HPAGE_SHIFT)
+
+/* How big is a kernel L2 page table? */
+#define L1_KERNEL_PGTABLE_SIZE (1UL << L1_KERNEL_PGTABLE_SHIFT)
+
+/* We currently allocate L1 page tables by page. */
+#if L1_KERNEL_PGTABLE_SHIFT < PAGE_SHIFT
+#define L1_USER_PGTABLE_SHIFT PAGE_SHIFT
+#else
+#define L1_USER_PGTABLE_SHIFT L1_KERNEL_PGTABLE_SHIFT
 #endif
 
+/* How many pages do we need, as an "order", for an L1 page table? */
+#define L1_USER_PGTABLE_ORDER (L1_USER_PGTABLE_SHIFT - PAGE_SHIFT)
+
+static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
+{
+	struct page *p = pgtable_alloc_one(mm, address, L1_USER_PGTABLE_ORDER);
+	return (pmd_t *)page_to_virt(p);
+}
+
+static inline void pmd_free(struct mm_struct *mm, pmd_t *pmdp)
+{
+	pgtable_free(mm, virt_to_page(pmdp), L1_USER_PGTABLE_ORDER);
+}
+
+static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
+				  unsigned long address)
+{
+	__pgtable_free_tlb(tlb, virt_to_page(pmdp), address,
+			   L1_USER_PGTABLE_ORDER);
+}
+
+#endif /* __tilegx__ */
+
 #endif /* _ASM_TILE_PGALLOC_H */
diff --git a/arch/tile/include/asm/pgtable.h b/arch/tile/include/asm/pgtable.h
index 17ad0ed..ae43301 100644
--- a/arch/tile/include/asm/pgtable.h
+++ b/arch/tile/include/asm/pgtable.h
@@ -27,9 +27,11 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/pfn.h>
 #include <asm/processor.h>
 #include <asm/fixmap.h>
 #include <asm/system.h>
+#include <asm/page.h>
 
 struct mm_struct;
 struct vm_area_struct;
@@ -163,7 +165,7 @@ extern void set_page_homes(void);
   (pgprot_t) { ((oldprot).val & ~_PAGE_ALL) | (newprot).val }
 
 /* Just setting the PFN to zero suffices. */
-#define pte_pgprot(x) hv_pte_set_pfn((x), 0)
+#define pte_pgprot(x) hv_pte_set_pa((x), 0)
 
 /*
  * For PTEs and PDEs, we must clear the Present bit first when
@@ -263,7 +265,7 @@ static inline int pte_none(pte_t pte)
 
 static inline unsigned long pte_pfn(pte_t pte)
 {
-	return hv_pte_get_pfn(pte);
+	return PFN_DOWN(hv_pte_get_pa(pte));
 }
 
 /* Set or get the remote cache cpu in a pgprot with remote caching. */
@@ -272,7 +274,7 @@ extern int get_remote_cache_cpu(pgprot_t prot);
 
 static inline pte_t pfn_pte(unsigned long pfn, pgprot_t prot)
 {
-	return hv_pte_set_pfn(prot, pfn);
+	return hv_pte_set_pa(prot, PFN_PHYS(pfn));
 }
 
 /* Support for priority mappings. */
@@ -472,7 +474,7 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
  * OK for pte_lockptr(), since we just end up with potentially one
  * lock being used for several pte_t arrays.
  */
-#define pmd_page(pmd) pfn_to_page(HV_PTFN_TO_PFN(pmd_ptfn(pmd)))
+#define pmd_page(pmd) pfn_to_page(PFN_DOWN(HV_PTFN_TO_CPA(pmd_ptfn(pmd))))
 
 static inline void pmd_clear(pmd_t *pmdp)
 {
diff --git a/arch/tile/include/asm/pgtable_32.h b/arch/tile/include/asm/pgtable_32.h
index 27e20f6..4ce4a7a 100644
--- a/arch/tile/include/asm/pgtable_32.h
+++ b/arch/tile/include/asm/pgtable_32.h
@@ -20,11 +20,12 @@
  * The level-1 index is defined by the huge page size.  A PGD is composed
  * of PTRS_PER_PGD pgd_t's and is the top level of the page table.
  */
-#define PGDIR_SHIFT	HV_LOG2_PAGE_SIZE_LARGE
-#define PGDIR_SIZE	HV_PAGE_SIZE_LARGE
+#define PGDIR_SHIFT	HPAGE_SHIFT
+#define PGDIR_SIZE	HPAGE_SIZE
 #define PGDIR_MASK	(~(PGDIR_SIZE-1))
-#define PTRS_PER_PGD	(1 << (32 - PGDIR_SHIFT))
-#define SIZEOF_PGD	(PTRS_PER_PGD * sizeof(pgd_t))
+#define PTRS_PER_PGD	_HV_L1_ENTRIES(HPAGE_SHIFT)
+#define PGD_INDEX(va)	_HV_L1_INDEX(va, HPAGE_SHIFT)
+#define SIZEOF_PGD	_HV_L1_SIZE(HPAGE_SHIFT)
 
 /*
  * The level-2 index is defined by the difference between the huge
@@ -33,8 +34,9 @@
  * Note that the hypervisor docs use PTE for what we call pte_t, so
  * this nomenclature is somewhat confusing.
  */
-#define PTRS_PER_PTE (1 << (HV_LOG2_PAGE_SIZE_LARGE - HV_LOG2_PAGE_SIZE_SMALL))
-#define SIZEOF_PTE	(PTRS_PER_PTE * sizeof(pte_t))
+#define PTRS_PER_PTE	_HV_L2_ENTRIES(HPAGE_SHIFT, PAGE_SHIFT)
+#define PTE_INDEX(va)	_HV_L2_INDEX(va, HPAGE_SHIFT, PAGE_SHIFT)
+#define SIZEOF_PTE	_HV_L2_SIZE(HPAGE_SHIFT, PAGE_SHIFT)
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/tile/include/asm/pgtable_64.h b/arch/tile/include/asm/pgtable_64.h
index e105f3a..2492fa5 100644
--- a/arch/tile/include/asm/pgtable_64.h
+++ b/arch/tile/include/asm/pgtable_64.h
@@ -21,17 +21,19 @@
 #define PGDIR_SIZE	HV_L1_SPAN
 #define PGDIR_MASK	(~(PGDIR_SIZE-1))
 #define PTRS_PER_PGD	HV_L0_ENTRIES
-#define SIZEOF_PGD	(PTRS_PER_PGD * sizeof(pgd_t))
+#define PGD_INDEX(va)	HV_L0_INDEX(va)
+#define SIZEOF_PGD	HV_L0_SIZE
 
 /*
  * The level-1 index is defined by the huge page size.  A PMD is composed
  * of PTRS_PER_PMD pgd_t's and is the middle level of the page table.
  */
-#define PMD_SHIFT	HV_LOG2_PAGE_SIZE_LARGE
-#define PMD_SIZE	HV_PAGE_SIZE_LARGE
+#define PMD_SHIFT	HPAGE_SHIFT
+#define PMD_SIZE	HPAGE_SIZE
 #define PMD_MASK	(~(PMD_SIZE-1))
-#define PTRS_PER_PMD	(1 << (PGDIR_SHIFT - PMD_SHIFT))
-#define SIZEOF_PMD	(PTRS_PER_PMD * sizeof(pmd_t))
+#define PTRS_PER_PMD	_HV_L1_ENTRIES(HPAGE_SHIFT)
+#define PMD_INDEX(va)	_HV_L1_INDEX(va, HPAGE_SHIFT)
+#define SIZEOF_PMD	_HV_L1_SIZE(HPAGE_SHIFT)
 
 /*
  * The level-2 index is defined by the difference between the huge
@@ -40,17 +42,19 @@
  * Note that the hypervisor docs use PTE for what we call pte_t, so
  * this nomenclature is somewhat confusing.
  */
-#define PTRS_PER_PTE (1 << (HV_LOG2_PAGE_SIZE_LARGE - HV_LOG2_PAGE_SIZE_SMALL))
-#define SIZEOF_PTE	(PTRS_PER_PTE * sizeof(pte_t))
+#define PTRS_PER_PTE	_HV_L2_ENTRIES(HPAGE_SHIFT, PAGE_SHIFT)
+#define PTE_INDEX(va)	_HV_L2_INDEX(va, HPAGE_SHIFT, PAGE_SHIFT)
+#define SIZEOF_PTE	_HV_L2_SIZE(HPAGE_SHIFT, PAGE_SHIFT)
 
 /*
- * Align the vmalloc area to an L2 page table, and leave a guard page
- * at the beginning and end.  The vmalloc code also puts in an internal
+ * Align the vmalloc area to an L2 page table.  Omit guard pages at
+ * the beginning and end for simplicity (particularly in the per-cpu
+ * memory allocation code).  The vmalloc code puts in an internal
  * guard page between each allocation.
  */
 #define _VMALLOC_END	HUGE_VMAP_BASE
-#define VMALLOC_END	(_VMALLOC_END - PAGE_SIZE)
-#define VMALLOC_START	(_VMALLOC_START + PAGE_SIZE)
+#define VMALLOC_END	_VMALLOC_END
+#define VMALLOC_START	_VMALLOC_START
 
 #define HUGE_VMAP_END	(HUGE_VMAP_BASE + PGDIR_SIZE)
 
@@ -98,7 +102,7 @@ static inline int pud_bad(pud_t pud)
  * A pud_t points to a pmd_t array.  Since we can have multiple per
  * page, we don't have a one-to-one mapping of pud_t's to pages.
  */
-#define pud_page(pud) pfn_to_page(HV_PTFN_TO_PFN(pud_ptfn(pud)))
+#define pud_page(pud) pfn_to_page(PFN_DOWN(HV_PTFN_TO_CPA(pud_ptfn(pud))))
 
 static inline unsigned long pud_index(unsigned long address)
 {
diff --git a/arch/tile/include/hv/drv_xgbe_intf.h b/arch/tile/include/hv/drv_xgbe_intf.h
index f13188a..2a20b26 100644
--- a/arch/tile/include/hv/drv_xgbe_intf.h
+++ b/arch/tile/include/hv/drv_xgbe_intf.h
@@ -460,7 +460,7 @@ typedef void* lepp_comp_t;
  *  linux's "MAX_SKB_FRAGS", and presumably over-estimates by one, for
  *  our page size of exactly 65536.  We add one for a "body" fragment.
  */
-#define LEPP_MAX_FRAGS (65536 / HV_PAGE_SIZE_SMALL + 2 + 1)
+#define LEPP_MAX_FRAGS (65536 / HV_DEFAULT_PAGE_SIZE_SMALL + 2 + 1)
 
 /** Total number of bytes needed for an lepp_tso_cmd_t. */
 #define LEPP_TSO_CMD_SIZE(num_frags, header_size) \
diff --git a/arch/tile/include/hv/hypervisor.h b/arch/tile/include/hv/hypervisor.h
index 793123e..16c18e4 100644
--- a/arch/tile/include/hv/hypervisor.h
+++ b/arch/tile/include/hv/hypervisor.h
@@ -17,8 +17,8 @@
  * The hypervisor's public API.
  */
 
-#ifndef _TILE_HV_H
-#define _TILE_HV_H
+#ifndef _HV_HV_H
+#define _HV_HV_H
 
 #include <arch/chip.h>
 
@@ -42,25 +42,29 @@
  */
 #define HV_L1_SPAN (__HV_SIZE_ONE << HV_LOG2_L1_SPAN)
 
-/** The log2 of the size of small pages, in bytes. This value should
- * be verified at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_SMALL).
+/** The log2 of the initial size of small pages, in bytes.
+ * See HV_DEFAULT_PAGE_SIZE_SMALL.
  */
-#define HV_LOG2_PAGE_SIZE_SMALL 16
+#define HV_LOG2_DEFAULT_PAGE_SIZE_SMALL 16
 
-/** The size of small pages, in bytes. This value should be verified
+/** The initial size of small pages, in bytes. This value should be verified
  * at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_SMALL).
+ * It may also be modified when installing a new context.
  */
-#define HV_PAGE_SIZE_SMALL (__HV_SIZE_ONE << HV_LOG2_PAGE_SIZE_SMALL)
+#define HV_DEFAULT_PAGE_SIZE_SMALL \
+  (__HV_SIZE_ONE << HV_LOG2_DEFAULT_PAGE_SIZE_SMALL)
 
-/** The log2 of the size of large pages, in bytes. This value should be
- * verified at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_LARGE).
+/** The log2 of the initial size of large pages, in bytes.
+ * See HV_DEFAULT_PAGE_SIZE_LARGE.
  */
-#define HV_LOG2_PAGE_SIZE_LARGE 24
+#define HV_LOG2_DEFAULT_PAGE_SIZE_LARGE 24
 
-/** The size of large pages, in bytes. This value should be verified
+/** The initial size of large pages, in bytes. This value should be verified
  * at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_LARGE).
+ * It may also be modified when installing a new context.
  */
-#define HV_PAGE_SIZE_LARGE (__HV_SIZE_ONE << HV_LOG2_PAGE_SIZE_LARGE)
+#define HV_DEFAULT_PAGE_SIZE_LARGE \
+  (__HV_SIZE_ONE << HV_LOG2_DEFAULT_PAGE_SIZE_LARGE)
 
 /** The log2 of the granularity at which page tables must be aligned;
  *  in other words, the CPA for a page table must have this many zero
@@ -401,7 +405,13 @@ typedef enum {
    *  that the temperature has hit an upper limit and is no longer being
    *  accurately tracked.
    */
-  HV_SYSCONF_BOARD_TEMP      = 6
+  HV_SYSCONF_BOARD_TEMP      = 6,
+
+  /** Legal page size bitmask for hv_install_context().
+   * For example, if 16KB and 64KB small pages are supported,
+   * it would return "HV_CTX_PG_SM_16K | HV_CTX_PG_SM_64K".
+   */
+  HV_SYSCONF_VALID_PAGE_SIZES = 7,
 
 } HV_SysconfQuery;
 
@@ -649,6 +659,12 @@ void hv_set_rtc(HV_RTCTime time);
  *  new page table does not need to contain any mapping for the
  *  hv_install_context address itself.
  *
+ *  At most one HV_CTX_PG_SM_* flag may be specified in "flags";
+ *  if multiple flags are specified, HV_EINVAL is returned.
+ *  Specifying none of the flags results in using the default page size.
+ *  All cores participating in a given client must request the same
+ *  page size, or the results are undefined.
+ *
  * @param page_table Root of the page table.
  * @param access PTE providing info on how to read the page table.  This
  *   value must be consistent between multiple tiles sharing a page table,
@@ -667,6 +683,11 @@ int hv_install_context(HV_PhysAddr page_table, HV_PTE access, HV_ASID asid,
 #define HV_CTX_DIRECTIO     0x1   /**< Direct I/O requests are accepted from
                                        PL0. */
 
+#define HV_CTX_PG_SM_4K     0x10  /**< Use 4K small pages, if available. */
+#define HV_CTX_PG_SM_16K    0x20  /**< Use 16K small pages, if available. */
+#define HV_CTX_PG_SM_64K    0x40  /**< Use 64K small pages, if available. */
+#define HV_CTX_PG_SM_MASK   0xf0  /**< Mask of all possible small pages. */
+
 #ifndef __ASSEMBLER__
 
 /** Value returned from hv_inquire_context(). */
@@ -1238,11 +1259,14 @@ HV_Errno hv_set_command_line(HV_VirtAddr buf, int length);
  * with the existing priority pages) or "red/black" (if they don't).
  * The bitmask provides information on which parts of the cache
  * have been used for pinned pages so far on this tile; if (1 << N)
- * appears in the bitmask, that indicates that a page has been marked
- * "priority" whose PFN equals N, mod 8.
+ * appears in the bitmask, that indicates that a 4KB region of the
+ * cache starting at (N * 4KB) is in use by a "priority" page.
+ * The portion of cache used by a particular page can be computed
+ * by taking the page's PA, modulo CHIP_L2_CACHE_SIZE(), and setting
+ * all the "4KB" bits corresponding to the actual page size.
  * @param bitmask A bitmap of priority page set values
  */
-void hv_set_caching(unsigned int bitmask);
+void hv_set_caching(unsigned long bitmask);
 
 
 /** Zero out a specified number of pages.
@@ -1868,15 +1892,6 @@ int hv_flush_remote(HV_PhysAddr cache_pa, unsigned long cache_control,
                                               of word */
 #define HV_PTE_PTFN_BITS             29  /**< Number of bits in a PTFN */
 
-/** Position of the PFN field within the PTE (subset of the PTFN). */
-#define HV_PTE_INDEX_PFN (HV_PTE_INDEX_PTFN + (HV_LOG2_PAGE_SIZE_SMALL - \
-                                               HV_LOG2_PAGE_TABLE_ALIGN))
-
-/** Length of the PFN field within the PTE (subset of the PTFN). */
-#define HV_PTE_INDEX_PFN_BITS (HV_PTE_INDEX_PTFN_BITS - \
-                               (HV_LOG2_PAGE_SIZE_SMALL - \
-                                HV_LOG2_PAGE_TABLE_ALIGN))
-
 /*
  * Legal values for the PTE's mode field
  */
@@ -2229,40 +2244,11 @@ hv_pte_set_mode(HV_PTE pte, unsigned int val)
  *
  * This field contains the upper bits of the CPA (client physical
  * address) of the target page; the complete CPA is this field with
- * HV_LOG2_PAGE_SIZE_SMALL zero bits appended to it.
+ * HV_LOG2_PAGE_TABLE_ALIGN zero bits appended to it.
  *
- * For PTEs in a level-1 page table where the Page bit is set, the
- * CPA must be aligned modulo the large page size.
- */
-static __inline unsigned int
-hv_pte_get_pfn(const HV_PTE pte)
-{
-  return pte.val >> HV_PTE_INDEX_PFN;
-}
-
-
-/** Set the page frame number into a PTE.  See hv_pte_get_pfn. */
-static __inline HV_PTE
-hv_pte_set_pfn(HV_PTE pte, unsigned int val)
-{
-  /*
-   * Note that the use of "PTFN" in the next line is intentional; we
-   * don't want any garbage lower bits left in that field.
-   */
-  pte.val &= ~(((1ULL << HV_PTE_PTFN_BITS) - 1) << HV_PTE_INDEX_PTFN);
-  pte.val |= (__hv64) val << HV_PTE_INDEX_PFN;
-  return pte;
-}
-
-/** Get the page table frame number from the PTE.
- *
- * This field contains the upper bits of the CPA (client physical
- * address) of the target page table; the complete CPA is this field with
- * with HV_PAGE_TABLE_ALIGN zero bits appended to it.
- *
- * For PTEs in a level-1 page table when the Page bit is not set, the
- * CPA must be aligned modulo the sticter of HV_PAGE_TABLE_ALIGN and
- * the level-2 page table size.
+ * For all PTEs in the lowest-level page table, and for all PTEs with
+ * the Page bit set in all page tables, the CPA must be aligned modulo
+ * the relevant page size.
  */
 static __inline unsigned long
 hv_pte_get_ptfn(const HV_PTE pte)
@@ -2270,7 +2256,6 @@ hv_pte_get_ptfn(const HV_PTE pte)
   return pte.val >> HV_PTE_INDEX_PTFN;
 }
 
-
 /** Set the page table frame number into a PTE.  See hv_pte_get_ptfn. */
 static __inline HV_PTE
 hv_pte_set_ptfn(HV_PTE pte, unsigned long val)
@@ -2280,6 +2265,20 @@ hv_pte_set_ptfn(HV_PTE pte, unsigned long val)
   return pte;
 }
 
+/** Get the client physical address from the PTE.  See hv_pte_set_ptfn. */
+static __inline HV_PhysAddr
+hv_pte_get_pa(const HV_PTE pte)
+{
+  return (__hv64) hv_pte_get_ptfn(pte) << HV_LOG2_PAGE_TABLE_ALIGN;
+}
+
+/** Set the client physical address into a PTE.  See hv_pte_get_ptfn. */
+static __inline HV_PTE
+hv_pte_set_pa(HV_PTE pte, HV_PhysAddr pa)
+{
+  return hv_pte_set_ptfn(pte, pa >> HV_LOG2_PAGE_TABLE_ALIGN);
+}
+
 
 /** Get the remote tile caching this page.
  *
@@ -2315,28 +2314,20 @@ hv_pte_set_lotar(HV_PTE pte, unsigned int val)
 
 #endif  /* !__ASSEMBLER__ */
 
-/** Converts a client physical address to a pfn. */
-#define HV_CPA_TO_PFN(p) ((p) >> HV_LOG2_PAGE_SIZE_SMALL)
-
-/** Converts a pfn to a client physical address. */
-#define HV_PFN_TO_CPA(p) (((HV_PhysAddr)(p)) << HV_LOG2_PAGE_SIZE_SMALL)
-
 /** Converts a client physical address to a ptfn. */
 #define HV_CPA_TO_PTFN(p) ((p) >> HV_LOG2_PAGE_TABLE_ALIGN)
 
 /** Converts a ptfn to a client physical address. */
 #define HV_PTFN_TO_CPA(p) (((HV_PhysAddr)(p)) << HV_LOG2_PAGE_TABLE_ALIGN)
 
-/** Converts a ptfn to a pfn. */
-#define HV_PTFN_TO_PFN(p) \
-  ((p) >> (HV_LOG2_PAGE_SIZE_SMALL - HV_LOG2_PAGE_TABLE_ALIGN))
-
-/** Converts a pfn to a ptfn. */
-#define HV_PFN_TO_PTFN(p) \
-  ((p) << (HV_LOG2_PAGE_SIZE_SMALL - HV_LOG2_PAGE_TABLE_ALIGN))
-
 #if CHIP_VA_WIDTH() > 32
 
+/*
+ * Note that we currently do not allow customizing the page size
+ * of the L0 pages, but fix them at 4GB, so we do not use the
+ * "_HV_xxx" nomenclature for the L0 macros.
+ */
+
 /** Log number of HV_PTE entries in L0 page table */
 #define HV_LOG2_L0_ENTRIES (CHIP_VA_WIDTH() - HV_LOG2_L1_SPAN)
 
@@ -2366,69 +2357,104 @@ hv_pte_set_lotar(HV_PTE pte, unsigned int val)
 #endif /* CHIP_VA_WIDTH() > 32 */
 
 /** Log number of HV_PTE entries in L1 page table */
-#define HV_LOG2_L1_ENTRIES (HV_LOG2_L1_SPAN - HV_LOG2_PAGE_SIZE_LARGE)
+#define _HV_LOG2_L1_ENTRIES(log2_page_size_large) \
+  (HV_LOG2_L1_SPAN - log2_page_size_large)
 
 /** Number of HV_PTE entries in L1 page table */
-#define HV_L1_ENTRIES (1 << HV_LOG2_L1_ENTRIES)
+#define _HV_L1_ENTRIES(log2_page_size_large) \
+  (1 << _HV_LOG2_L1_ENTRIES(log2_page_size_large))
 
 /** Log size of L1 page table in bytes */
-#define HV_LOG2_L1_SIZE (HV_LOG2_PTE_SIZE + HV_LOG2_L1_ENTRIES)
+#define _HV_LOG2_L1_SIZE(log2_page_size_large) \
+  (HV_LOG2_PTE_SIZE + _HV_LOG2_L1_ENTRIES(log2_page_size_large))
 
 /** Size of L1 page table in bytes */
-#define HV_L1_SIZE (1 << HV_LOG2_L1_SIZE)
+#define _HV_L1_SIZE(log2_page_size_large) \
+  (1 << _HV_LOG2_L1_SIZE(log2_page_size_large))
 
 /** Log number of HV_PTE entries in level-2 page table */
-#define HV_LOG2_L2_ENTRIES (HV_LOG2_PAGE_SIZE_LARGE - HV_LOG2_PAGE_SIZE_SMALL)
+#define _HV_LOG2_L2_ENTRIES(log2_page_size_large, log2_page_size_small) \
+  (log2_page_size_large - log2_page_size_small)
 
 /** Number of HV_PTE entries in level-2 page table */
-#define HV_L2_ENTRIES (1 << HV_LOG2_L2_ENTRIES)
+#define _HV_L2_ENTRIES(log2_page_size_large, log2_page_size_small) \
+  (1 << _HV_LOG2_L2_ENTRIES(log2_page_size_large, log2_page_size_small))
 
 /** Log size of level-2 page table in bytes */
-#define HV_LOG2_L2_SIZE (HV_LOG2_PTE_SIZE + HV_LOG2_L2_ENTRIES)
+#define _HV_LOG2_L2_SIZE(log2_page_size_large, log2_page_size_small) \
+  (HV_LOG2_PTE_SIZE + \
+   _HV_LOG2_L2_ENTRIES(log2_page_size_large, log2_page_size_small))
 
 /** Size of level-2 page table in bytes */
-#define HV_L2_SIZE (1 << HV_LOG2_L2_SIZE)
+#define _HV_L2_SIZE(log2_page_size_large, log2_page_size_small) \
+  (1 << _HV_LOG2_L2_SIZE(log2_page_size_large, log2_page_size_small))
 
 #ifdef __ASSEMBLER__
 
 #if CHIP_VA_WIDTH() > 32
 
 /** Index in L1 for a specific VA */
-#define HV_L1_INDEX(va) \
-  (((va) >> HV_LOG2_PAGE_SIZE_LARGE) & (HV_L1_ENTRIES - 1))
+#define _HV_L1_INDEX(va, log2_page_size_large) \
+  (((va) >> log2_page_size_large) & (_HV_L1_ENTRIES(log2_page_size_large) - 1))
 
 #else /* CHIP_VA_WIDTH() > 32 */
 
 /** Index in L1 for a specific VA */
-#define HV_L1_INDEX(va) \
-  (((va) >> HV_LOG2_PAGE_SIZE_LARGE))
+#define _HV_L1_INDEX(va, log2_page_size_large) \
+  (((va) >> log2_page_size_large))
 
 #endif /* CHIP_VA_WIDTH() > 32 */
 
 /** Index in level-2 page table for a specific VA */
-#define HV_L2_INDEX(va) \
-  (((va) >> HV_LOG2_PAGE_SIZE_SMALL) & (HV_L2_ENTRIES - 1))
+#define _HV_L2_INDEX(va, log2_page_size_large, log2_page_size_small) \
+  (((va) >> log2_page_size_small) & \
+   (_HV_L2_ENTRIES(log2_page_size_large, log2_page_size_small) - 1))
 
 #else /* __ASSEMBLER __ */
 
 #if CHIP_VA_WIDTH() > 32
 
 /** Index in L1 for a specific VA */
-#define HV_L1_INDEX(va) \
-  (((HV_VirtAddr)(va) >> HV_LOG2_PAGE_SIZE_LARGE) & (HV_L1_ENTRIES - 1))
+#define _HV_L1_INDEX(va, log2_page_size_large) \
+  (((HV_VirtAddr)(va) >> log2_page_size_large) & \
+   (_HV_L1_ENTRIES(log2_page_size_large) - 1))
 
 #else /* CHIP_VA_WIDTH() > 32 */
 
 /** Index in L1 for a specific VA */
-#define HV_L1_INDEX(va) \
-  (((HV_VirtAddr)(va) >> HV_LOG2_PAGE_SIZE_LARGE))
+#define _HV_L1_INDEX(va, log2_page_size_large) \
+  (((HV_VirtAddr)(va) >> log2_page_size_large))
 
 #endif /* CHIP_VA_WIDTH() > 32 */
 
 /** Index in level-2 page table for a specific VA */
-#define HV_L2_INDEX(va) \
-  (((HV_VirtAddr)(va) >> HV_LOG2_PAGE_SIZE_SMALL) & (HV_L2_ENTRIES - 1))
+#define _HV_L2_INDEX(va, log2_page_size_large, log2_page_size_small) \
+  (((HV_VirtAddr)(va) >> log2_page_size_small) & \
+   (_HV_L2_ENTRIES(log2_page_size_large, log2_page_size_small) - 1))
 
 #endif /* __ASSEMBLER __ */
 
-#endif /* _TILE_HV_H */
+/** Position of the PFN field within the PTE (subset of the PTFN). */
+#define _HV_PTE_INDEX_PFN(log2_page_size) \
+  (HV_PTE_INDEX_PTFN + (log2_page_size - HV_LOG2_PAGE_TABLE_ALIGN))
+
+/** Length of the PFN field within the PTE (subset of the PTFN). */
+#define _HV_PTE_INDEX_PFN_BITS(log2_page_size) \
+  (HV_PTE_INDEX_PTFN_BITS - (log2_page_size - HV_LOG2_PAGE_TABLE_ALIGN))
+
+/** Converts a client physical address to a pfn. */
+#define _HV_CPA_TO_PFN(p, log2_page_size) ((p) >> log2_page_size)
+
+/** Converts a pfn to a client physical address. */
+#define _HV_PFN_TO_CPA(p, log2_page_size) \
+  (((HV_PhysAddr)(p)) << log2_page_size)
+
+/** Converts a ptfn to a pfn. */
+#define _HV_PTFN_TO_PFN(p, log2_page_size) \
+  ((p) >> (log2_page_size - HV_LOG2_PAGE_TABLE_ALIGN))
+
+/** Converts a pfn to a ptfn. */
+#define _HV_PFN_TO_PTFN(p, log2_page_size) \
+  ((p) << (log2_page_size - HV_LOG2_PAGE_TABLE_ALIGN))
+
+#endif /* _HV_HV_H */
diff --git a/arch/tile/kernel/head_32.S b/arch/tile/kernel/head_32.S
index 1a39b7c..f71bfee 100644
--- a/arch/tile/kernel/head_32.S
+++ b/arch/tile/kernel/head_32.S
@@ -69,7 +69,7 @@ ENTRY(_start)
 	}
 	{
 	  moveli lr, lo16(1f)
-	  move r5, zero
+	  moveli r5, CTX_PAGE_FLAG
 	}
 	{
 	  auli lr, lr, ha16(1f)
@@ -141,11 +141,11 @@ ENTRY(empty_zero_page)
 
 	.macro PTE va, cpa, bits1, no_org=0
 	.ifeq \no_org
-	.org swapper_pg_dir + HV_L1_INDEX(\va) * HV_PTE_SIZE
+	.org swapper_pg_dir + PGD_INDEX(\va) * HV_PTE_SIZE
 	.endif
 	.word HV_PTE_PAGE | HV_PTE_DIRTY | HV_PTE_PRESENT | HV_PTE_ACCESSED | \
 	      (HV_PTE_MODE_CACHE_NO_L3 << HV_PTE_INDEX_MODE)
-	.word (\bits1) | (HV_CPA_TO_PFN(\cpa) << (HV_PTE_INDEX_PFN - 32))
+	.word (\bits1) | (HV_CPA_TO_PTFN(\cpa) << (HV_PTE_INDEX_PTFN - 32))
 	.endm
 
 __PAGE_ALIGNED_DATA
@@ -166,7 +166,7 @@ ENTRY(swapper_pg_dir)
 	/* The true text VAs are mapped as VA = PA + MEM_SV_INTRPT */
 	PTE MEM_SV_INTRPT, 0, (1 << (HV_PTE_INDEX_READABLE - 32)) | \
 			      (1 << (HV_PTE_INDEX_EXECUTABLE - 32))
-	.org swapper_pg_dir + HV_L1_SIZE
+	.org swapper_pg_dir + PGDIR_SIZE
 	END(swapper_pg_dir)
 
 	/*
diff --git a/arch/tile/kernel/head_64.S b/arch/tile/kernel/head_64.S
index 6bc3a93..f9a2734 100644
--- a/arch/tile/kernel/head_64.S
+++ b/arch/tile/kernel/head_64.S
@@ -114,7 +114,7 @@ ENTRY(_start)
 	  shl16insli r0, r0, hw0(swapper_pg_dir - PAGE_OFFSET)
 	}
 	{
-	  move r3, zero
+	  moveli r3, CTX_PAGE_FLAG
 	  j hv_install_context
 	}
 1:
@@ -210,19 +210,19 @@ ENTRY(empty_zero_page)
 	.macro PTE cpa, bits1
 	.quad HV_PTE_PAGE | HV_PTE_DIRTY | HV_PTE_PRESENT | HV_PTE_ACCESSED |\
 	      HV_PTE_GLOBAL | (HV_PTE_MODE_CACHE_NO_L3 << HV_PTE_INDEX_MODE) |\
-	      (\bits1) | (HV_CPA_TO_PFN(\cpa) << HV_PTE_INDEX_PFN)
+	      (\bits1) | (HV_CPA_TO_PTFN(\cpa) << HV_PTE_INDEX_PTFN)
 	.endm
 
 __PAGE_ALIGNED_DATA
 	.align PAGE_SIZE
 ENTRY(swapper_pg_dir)
-	.org swapper_pg_dir + HV_L0_INDEX(PAGE_OFFSET) * HV_PTE_SIZE
+	.org swapper_pg_dir + PGD_INDEX(PAGE_OFFSET) * HV_PTE_SIZE
 .Lsv_data_pmd:
 	.quad 0  /* PTE temp_data_pmd - PAGE_OFFSET, 0 */
-	.org swapper_pg_dir + HV_L0_INDEX(MEM_SV_START) * HV_PTE_SIZE
+	.org swapper_pg_dir + PGD_INDEX(MEM_SV_START) * HV_PTE_SIZE
 .Lsv_code_pmd:
 	.quad 0  /* PTE temp_code_pmd - PAGE_OFFSET, 0 */
-	.org swapper_pg_dir + HV_L0_SIZE
+	.org swapper_pg_dir + SIZEOF_PGD
 	END(swapper_pg_dir)
 
 	.align HV_PAGE_TABLE_ALIGN
@@ -233,11 +233,11 @@ ENTRY(temp_data_pmd)
 	 * permissions later.
 	 */
 	.set addr, 0
-	.rept HV_L1_ENTRIES
+	.rept PTRS_PER_PMD
 	PTE addr, HV_PTE_READABLE | HV_PTE_WRITABLE
-	.set addr, addr + HV_PAGE_SIZE_LARGE
+	.set addr, addr + HPAGE_SIZE
 	.endr
-	.org temp_data_pmd + HV_L1_SIZE
+	.org temp_data_pmd + SIZEOF_PMD
 	END(temp_data_pmd)
 
 	.align HV_PAGE_TABLE_ALIGN
@@ -248,11 +248,11 @@ ENTRY(temp_code_pmd)
 	 * permissions later.
 	 */
 	.set addr, 0
-	.rept HV_L1_ENTRIES
+	.rept PTRS_PER_PMD
 	PTE addr, HV_PTE_READABLE | HV_PTE_EXECUTABLE
-	.set addr, addr + HV_PAGE_SIZE_LARGE
+	.set addr, addr + HPAGE_SIZE
 	.endr
-	.org temp_code_pmd + HV_L1_SIZE
+	.org temp_code_pmd + SIZEOF_PMD
 	END(temp_code_pmd)
 
 	/*
diff --git a/arch/tile/kernel/machine_kexec.c b/arch/tile/kernel/machine_kexec.c
index 6255f2e..b0fa37c 100644
--- a/arch/tile/kernel/machine_kexec.c
+++ b/arch/tile/kernel/machine_kexec.c
@@ -251,6 +251,7 @@ static void setup_quasi_va_is_pa(void)
 void machine_kexec(struct kimage *image)
 {
 	void *reboot_code_buffer;
+	pte_t *ptep;
 	void (*rnk)(unsigned long, void *, unsigned long)
 		__noreturn;
 
@@ -266,8 +267,10 @@ void machine_kexec(struct kimage *image)
 	 */
 	homecache_change_page_home(image->control_code_page, 0,
 				   smp_processor_id());
-	reboot_code_buffer = vmap(&image->control_code_page, 1, 0,
-				  __pgprot(_PAGE_KERNEL | _PAGE_EXECUTABLE));
+	reboot_code_buffer = page_address(image->control_code_page);
+	BUG_ON(reboot_code_buffer == NULL);
+	ptep = virt_to_pte(NULL, (unsigned long)reboot_code_buffer);
+	__set_pte(ptep, pte_mkexec(*ptep));
 	memcpy(reboot_code_buffer, relocate_new_kernel,
 	       relocate_new_kernel_size);
 	__flush_icache_range(
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 5f85d8b..1a7276a 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -1390,13 +1390,13 @@ void __init setup_per_cpu_areas(void)
 		for (i = 0; i < size; i += PAGE_SIZE, ++pfn, ++pg) {
 
 			/* Update the vmalloc mapping and page home. */
-			pte_t *ptep =
-				virt_to_pte(NULL, (unsigned long)ptr + i);
+			unsigned long addr = (unsigned long)ptr + i;
+			pte_t *ptep = virt_to_pte(NULL, addr);
 			pte_t pte = *ptep;
 			BUG_ON(pfn != pte_pfn(pte));
 			pte = hv_pte_set_mode(pte, HV_PTE_MODE_CACHE_TILE_L3);
 			pte = set_remote_cache_cpu(pte, cpu);
-			set_pte(ptep, pte);
+			set_pte_at(&init_mm, addr, ptep, pte);
 
 			/* Update the lowmem mapping for consistency. */
 			lowmem_va = (unsigned long)pfn_to_kaddr(pfn);
@@ -1409,7 +1409,7 @@ void __init setup_per_cpu_areas(void)
 				BUG_ON(pte_huge(*ptep));
 			}
 			BUG_ON(pfn != pte_pfn(*ptep));
-			set_pte(ptep, pte);
+			set_pte_at(&init_mm, lowmem_va, ptep, pte);
 		}
 	}
 
diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
index c52224d..7579607 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -216,7 +216,7 @@ void __init ipi_init(void)
 		if (hv_get_ipi_pte(tile, KERNEL_PL, &pte) != 0)
 			panic("Failed to initialize IPI for cpu %d\n", cpu);
 
-		offset = hv_pte_get_pfn(pte) << PAGE_SHIFT;
+		offset = PFN_PHYS(pte_pfn(pte));
 		ipi_mappings[cpu] = ioremap_prot(offset, PAGE_SIZE, pte);
 	}
 #endif
diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index 37ee4d0..9016d1c 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -56,12 +56,12 @@ static int valid_address(struct KBacktraceIterator *kbt, unsigned long address)
 	if (l1_pgtable == NULL)
 		return 0;	/* can't read user space in other tasks */
 
+	pte = l1_pgtable[PGD_INDEX(address)];
 #ifdef CONFIG_64BIT
 	/* Find the real l1_pgtable by looking in the l0_pgtable. */
-	pte = l1_pgtable[HV_L0_INDEX(address)];
 	if (!hv_pte_get_present(pte))
 		return 0;
-	pfn = hv_pte_get_pfn(pte);
+	pfn = pte_pfn(pte);
 	if (pte_huge(pte)) {
 		if (!pfn_valid(pfn)) {
 			pr_err("L0 huge page has bad pfn %#lx\n", pfn);
@@ -72,11 +72,11 @@ static int valid_address(struct KBacktraceIterator *kbt, unsigned long address)
 	page = pfn_to_page(pfn);
 	BUG_ON(PageHighMem(page));  /* No HIGHMEM on 64-bit. */
 	l1_pgtable = (HV_PTE *)pfn_to_kaddr(pfn);
+	pte = l1_pgtable[PMD_INDEX(address)];
 #endif
-	pte = l1_pgtable[HV_L1_INDEX(address)];
 	if (!hv_pte_get_present(pte))
 		return 0;
-	pfn = hv_pte_get_pfn(pte);
+	pfn = pte_pfn(pte);
 	if (pte_huge(pte)) {
 		if (!pfn_valid(pfn)) {
 			pr_err("huge page has bad pfn %#lx\n", pfn);
@@ -87,12 +87,11 @@ static int valid_address(struct KBacktraceIterator *kbt, unsigned long address)
 
 	page = pfn_to_page(pfn);
 	if (PageHighMem(page)) {
-		pr_err("L2 page table not in LOWMEM (%#llx)\n",
-		       HV_PFN_TO_CPA(pfn));
+		pr_err("L2 page table not in LOWMEM (%#llx)\n", PFN_PHYS(pfn));
 		return 0;
 	}
 	l2_pgtable = (HV_PTE *)pfn_to_kaddr(pfn);
-	pte = l2_pgtable[HV_L2_INDEX(address)];
+	pte = l2_pgtable[PTE_INDEX(address)];
 	return hv_pte_get_present(pte) && hv_pte_get_readable(pte);
 }
 
diff --git a/arch/tile/lib/memcpy_tile64.c b/arch/tile/lib/memcpy_tile64.c
index b2fe15e..3bc4b4e 100644
--- a/arch/tile/lib/memcpy_tile64.c
+++ b/arch/tile/lib/memcpy_tile64.c
@@ -160,7 +160,7 @@ retry_source:
 			break;
 		if (get_remote_cache_cpu(src_pte) == smp_processor_id())
 			break;
-		src_page = pfn_to_page(hv_pte_get_pfn(src_pte));
+		src_page = pfn_to_page(pte_pfn(src_pte));
 		get_page(src_page);
 		if (pte_val(src_pte) != pte_val(*src_ptep)) {
 			put_page(src_page);
@@ -168,7 +168,7 @@ retry_source:
 		}
 		if (pte_huge(src_pte)) {
 			/* Adjust the PTE to correspond to a small page */
-			int pfn = hv_pte_get_pfn(src_pte);
+			int pfn = pte_pfn(src_pte);
 			pfn += (((unsigned long)source & (HPAGE_SIZE-1))
 				>> PAGE_SHIFT);
 			src_pte = pfn_pte(pfn, src_pte);
@@ -188,7 +188,7 @@ retry_dest:
 			put_page(src_page);
 			break;
 		}
-		dst_page = pfn_to_page(hv_pte_get_pfn(dst_pte));
+		dst_page = pfn_to_page(pte_pfn(dst_pte));
 		if (dst_page == src_page) {
 			/*
 			 * Source and dest are on the same page; this
@@ -206,7 +206,7 @@ retry_dest:
 		}
 		if (pte_huge(dst_pte)) {
 			/* Adjust the PTE to correspond to a small page */
-			int pfn = hv_pte_get_pfn(dst_pte);
+			int pfn = pte_pfn(dst_pte);
 			pfn += (((unsigned long)dest & (HPAGE_SIZE-1))
 				>> PAGE_SHIFT);
 			dst_pte = pfn_pte(pfn, dst_pte);
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 51c5e51..d1c6391 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -83,7 +83,7 @@ static int num_l2_ptes[MAX_NUMNODES];
 
 static void init_prealloc_ptes(int node, int pages)
 {
-	BUG_ON(pages & (HV_L2_ENTRIES-1));
+	BUG_ON(pages & (PTRS_PER_PTE - 1));
 	if (pages) {
 		num_l2_ptes[node] = pages;
 		l2_ptes[node] = __alloc_bootmem(pages * sizeof(pte_t),
@@ -132,14 +132,9 @@ static void __init assign_pte(pmd_t *pmd, pte_t *page_table)
 
 #ifdef __tilegx__
 
-#if HV_L1_SIZE != HV_L2_SIZE
-# error Rework assumption that L1 and L2 page tables are same size.
-#endif
-
-/* Since pmd_t arrays and pte_t arrays are the same size, just use casts. */
 static inline pmd_t *alloc_pmd(void)
 {
-	return (pmd_t *)alloc_pte();
+	return __alloc_bootmem(L1_KERNEL_PGTABLE_SIZE, HV_PAGE_TABLE_ALIGN, 0);
 }
 
 static inline void assign_pmd(pud_t *pud, pmd_t *pmd)
@@ -808,7 +803,7 @@ void __init paging_init(void)
 	 * changing init_mm once we get up and running, and there's no
 	 * need for e.g. vmalloc_sync_all().
 	 */
-	BUILD_BUG_ON(pgd_index(VMALLOC_START) != pgd_index(VMALLOC_END));
+	BUILD_BUG_ON(pgd_index(VMALLOC_START) != pgd_index(VMALLOC_END - 1));
 	pud = pud_offset(pgd_base + pgd_index(VMALLOC_START), VMALLOC_START);
 	assign_pmd(pud, alloc_pmd());
 #endif
diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
index de7d8e2..14e7e9e 100644
--- a/arch/tile/mm/pgtable.c
+++ b/arch/tile/mm/pgtable.c
@@ -288,13 +288,12 @@ void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 
 #define L2_USER_PGTABLE_PAGES (1 << L2_USER_PGTABLE_ORDER)
 
-struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
+struct page *pgtable_alloc_one(struct mm_struct *mm, unsigned long address,
+			       int order)
 {
 	gfp_t flags = GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO;
 	struct page *p;
-#if L2_USER_PGTABLE_ORDER > 0
 	int i;
-#endif
 
 #ifdef CONFIG_HIGHPTE
 	flags |= __GFP_HIGHMEM;
@@ -304,17 +303,15 @@ struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
 	if (p == NULL)
 		return NULL;
 
-#if L2_USER_PGTABLE_ORDER > 0
 	/*
 	 * Make every page have a page_count() of one, not just the first.
 	 * We don't use __GFP_COMP since it doesn't look like it works
 	 * correctly with tlb_remove_page().
 	 */
-	for (i = 1; i < L2_USER_PGTABLE_PAGES; ++i) {
+	for (i = 1; i < order; ++i) {
 		init_page_count(p+i);
 		inc_zone_page_state(p+i, NR_PAGETABLE);
 	}
-#endif
 
 	pgtable_page_ctor(p);
 	return p;
@@ -325,28 +322,28 @@ struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
  * process).  We have to correct whatever pte_alloc_one() did before
  * returning the pages to the allocator.
  */
-void pte_free(struct mm_struct *mm, struct page *p)
+void pgtable_free(struct mm_struct *mm, struct page *p, int order)
 {
 	int i;
 
 	pgtable_page_dtor(p);
 	__free_page(p);
 
-	for (i = 1; i < L2_USER_PGTABLE_PAGES; ++i) {
+	for (i = 1; i < order; ++i) {
 		__free_page(p+i);
 		dec_zone_page_state(p+i, NR_PAGETABLE);
 	}
 }
 
-void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte,
-		    unsigned long address)
+void __pgtable_free_tlb(struct mmu_gather *tlb, struct page *pte,
+			unsigned long address, int order)
 {
 	int i;
 
 	pgtable_page_dtor(pte);
 	tlb_remove_page(tlb, pte);
 
-	for (i = 1; i < L2_USER_PGTABLE_PAGES; ++i) {
+	for (i = 1; i < order; ++i) {
 		tlb_remove_page(tlb, pte + i);
 		dec_zone_page_state(pte + i, NR_PAGETABLE);
 	}
@@ -481,7 +478,7 @@ void set_pte(pte_t *ptep, pte_t pte)
 /* Can this mm load a PTE with cached_priority set? */
 static inline int mm_is_priority_cached(struct mm_struct *mm)
 {
-	return mm->context.priority_cached;
+	return mm->context.priority_cached != 0;
 }
 
 /*
@@ -491,8 +488,8 @@ static inline int mm_is_priority_cached(struct mm_struct *mm)
 void start_mm_caching(struct mm_struct *mm)
 {
 	if (!mm_is_priority_cached(mm)) {
-		mm->context.priority_cached = -1U;
-		hv_set_caching(-1U);
+		mm->context.priority_cached = -1UL;
+		hv_set_caching(-1UL);
 	}
 }
 
@@ -507,7 +504,7 @@ void start_mm_caching(struct mm_struct *mm)
  * Presumably we'll come back later and have more luck and clear
  * the value then; for now we'll just keep the cache marked for priority.
  */
-static unsigned int update_priority_cached(struct mm_struct *mm)
+static unsigned long update_priority_cached(struct mm_struct *mm)
 {
 	if (mm->context.priority_cached && down_write_trylock(&mm->mmap_sem)) {
 		struct vm_area_struct *vm;
-- 
1.6.5.2

