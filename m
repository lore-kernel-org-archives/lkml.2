Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab1CATh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:37:29 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52544 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab1CATh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:26 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Mar 2011 14:37:17 EST
Message-Id: <201103011934.p21JYec6010312@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 28 Feb 2011 16:37:34 -0500
Subject: [PATCH] arch/tile: support 4KB page size as well as 64KB
To: linux-kernel@vger.kernel.org
In-Reply-To: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
X-OriginalArrivalTime: 01 Mar 2011 19:34:41.0014 (UTC) FILETIME=[B5894160:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tilera architecture traditionally supports 64KB page sizes
to improve TLB utilization and improve performance when the
hardware is being used primarily to run a single application.

For more generic server scenarios, it can be beneficial to run
with 4KB page sizes, so this commit allows that to be specified
(by modifying the arch/tile/include/hv/pagesize.h header).

As part of this change, we also re-worked the PTE management
slightly so that PTE writes all go through a __set_pte() function
where we can do some additional validation.  The set_pte_order()
function was eliminated since the "order" argument wasn't being used.

One bug uncovered was in the PCI DMA code, which wasn't properly
flushing the specified range.  This was benign with 64KB pages,
but with 4KB pages we were getting some larger flushes wrong.

The per-cpu memory reservation code also needed updating to
conform with the newer percpu stuff; before it always chose 64KB,
and that was always correct, but with 4KB granularity we now have
to pay closer attention and reserve the amount of memory that will
be requested when the percpu code starts allocating.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig                   |    6 --
 arch/tile/include/asm/hugetlb.h     |    2 +-
 arch/tile/include/asm/page.h        |   34 +++-----
 arch/tile/include/asm/pgalloc.h     |    7 +-
 arch/tile/include/asm/pgtable.h     |   31 +++----
 arch/tile/include/asm/pgtable_32.h  |    8 ++-
 arch/tile/include/asm/stack.h       |    3 +-
 arch/tile/include/asm/thread_info.h |    1 +
 arch/tile/kernel/intvec_32.S        |   16 +++-
 arch/tile/kernel/machine_kexec.c    |    7 +-
 arch/tile/kernel/pci-dma.c          |   38 ++++----
 arch/tile/kernel/process.c          |    2 +-
 arch/tile/kernel/setup.c            |   20 +++--
 arch/tile/lib/memcpy_tile64.c       |    4 +-
 arch/tile/mm/homecache.c            |    2 +-
 arch/tile/mm/init.c                 |   18 +----
 arch/tile/mm/migrate_32.S           |    1 +
 arch/tile/mm/pgtable.c              |  170 +++++++++++++++++++++++++++++------
 18 files changed, 235 insertions(+), 135 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index eed0fc5..f3b7870 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -202,12 +202,6 @@ config NODES_SHIFT
 	  By default, 2, i.e. 2^2 == 4 DDR2 controllers.
 	  In a system with more controllers, this value should be raised.
 
-# Need 16MB areas to enable hugetlb
-# See build-time check in arch/tile/mm/init.c.
-config FORCE_MAX_ZONEORDER
-	int
-	default 9
-
 choice
 	depends on !TILEGX
 	prompt "Memory split" if EXPERT
diff --git a/arch/tile/include/asm/hugetlb.h b/arch/tile/include/asm/hugetlb.h
index 0521c27..d396d18 100644
--- a/arch/tile/include/asm/hugetlb.h
+++ b/arch/tile/include/asm/hugetlb.h
@@ -54,7 +54,7 @@ static inline void hugetlb_free_pgd_range(struct mmu_gather *tlb,
 static inline void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 				   pte_t *ptep, pte_t pte)
 {
-	set_pte_order(ptep, pte, HUGETLB_PAGE_ORDER);
+	set_pte(ptep, pte);
 }
 
 static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
diff --git a/arch/tile/include/asm/page.h b/arch/tile/include/asm/page.h
index 7979a45..3eb5352 100644
--- a/arch/tile/include/asm/page.h
+++ b/arch/tile/include/asm/page.h
@@ -16,10 +16,11 @@
 #define _ASM_TILE_PAGE_H
 
 #include <linux/const.h>
+#include <hv/pagesize.h>
 
 /* PAGE_SHIFT and HPAGE_SHIFT determine the page sizes. */
-#define PAGE_SHIFT	16
-#define HPAGE_SHIFT	24
+#define PAGE_SHIFT	HV_LOG2_PAGE_SIZE_SMALL
+#define HPAGE_SHIFT	HV_LOG2_PAGE_SIZE_LARGE
 
 #define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
 #define HPAGE_SIZE	(_AC(1, UL) << HPAGE_SHIFT)
@@ -29,25 +30,18 @@
 
 #ifdef __KERNEL__
 
-#include <hv/hypervisor.h>
-#include <arch/chip.h>
-
 /*
- * The {,H}PAGE_SHIFT values must match the HV_LOG2_PAGE_SIZE_xxx
- * definitions in <hv/hypervisor.h>.  We validate this at build time
- * here, and again at runtime during early boot.  We provide a
- * separate definition since userspace doesn't have <hv/hypervisor.h>.
- *
- * Be careful to distinguish PAGE_SHIFT from HV_PTE_INDEX_PFN, since
- * they are the same on i386 but not TILE.
+ * If the Kconfig doesn't specify, set a maximum zone order that
+ * is enough so that we can create huge pages from small pages given
+ * the respective sizes of the two page types.  See <linux/mmzone.h>.
  */
-#if HV_LOG2_PAGE_SIZE_SMALL != PAGE_SHIFT
-# error Small page size mismatch in Linux
-#endif
-#if HV_LOG2_PAGE_SIZE_LARGE != HPAGE_SHIFT
-# error Huge page size mismatch in Linux
+#ifndef CONFIG_FORCE_MAX_ZONEORDER
+#define CONFIG_FORCE_MAX_ZONEORDER (HPAGE_SHIFT - PAGE_SHIFT + 1)
 #endif
 
+#include <hv/hypervisor.h>
+#include <arch/chip.h>
+
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
@@ -81,12 +75,6 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
  * Hypervisor page tables are made of the same basic structure.
  */
 
-typedef __u64 pteval_t;
-typedef __u64 pmdval_t;
-typedef __u64 pudval_t;
-typedef __u64 pgdval_t;
-typedef __u64 pgprotval_t;
-
 typedef HV_PTE pte_t;
 typedef HV_PTE pgd_t;
 typedef HV_PTE pgprot_t;
diff --git a/arch/tile/include/asm/pgalloc.h b/arch/tile/include/asm/pgalloc.h
index cf52791..e919c0b 100644
--- a/arch/tile/include/asm/pgalloc.h
+++ b/arch/tile/include/asm/pgalloc.h
@@ -41,9 +41,9 @@
 static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
 #ifdef CONFIG_64BIT
-	set_pte_order(pmdp, pmd, L2_USER_PGTABLE_ORDER);
+	set_pte(pmdp, pmd);
 #else
-	set_pte_order(&pmdp->pud.pgd, pmd.pud.pgd, L2_USER_PGTABLE_ORDER);
+	set_pte(&pmdp->pud.pgd, pmd.pud.pgd);
 #endif
 }
 
@@ -100,6 +100,9 @@ pte_t *get_prealloc_pte(unsigned long pfn);
 /* During init, we can shatter kernel huge pages if needed. */
 void shatter_pmd(pmd_t *pmd);
 
+/* After init, a more complex technique is required. */
+void shatter_huge_page(unsigned long addr);
+
 #ifdef __tilegx__
 /* We share a single page allocator for both L1 and L2 page tables. */
 #if HV_L1_SIZE != HV_L2_SIZE
diff --git a/arch/tile/include/asm/pgtable.h b/arch/tile/include/asm/pgtable.h
index a6604e9..1a20b7e 100644
--- a/arch/tile/include/asm/pgtable.h
+++ b/arch/tile/include/asm/pgtable.h
@@ -233,15 +233,23 @@ static inline void __pte_clear(pte_t *ptep)
 #define pgd_ERROR(e) \
 	pr_err("%s:%d: bad pgd 0x%016llx.\n", __FILE__, __LINE__, pgd_val(e))
 
+/* Return PA and protection info for a given kernel VA. */
+int va_to_cpa_and_pte(void *va, phys_addr_t *cpa, pte_t *pte);
+
+/*
+ * __set_pte() ensures we write the 64-bit PTE with 32-bit words in
+ * the right order on 32-bit platforms and also allows us to write
+ * hooks to check valid PTEs, etc., if we want.
+ */
+void __set_pte(pte_t *ptep, pte_t pte);
+
 /*
- * set_pte_order() sets the given PTE and also sanity-checks the
+ * set_pte() sets the given PTE and also sanity-checks the
  * requested PTE against the page homecaching.  Unspecified parts
  * of the PTE are filled in when it is written to memory, i.e. all
  * caching attributes if "!forcecache", or the home cpu if "anyhome".
  */
-extern void set_pte_order(pte_t *ptep, pte_t pte, int order);
-
-#define set_pte(ptep, pteval) set_pte_order(ptep, pteval, 0)
+extern void set_pte(pte_t *ptep, pte_t pte);
 #define set_pte_at(mm, addr, ptep, pteval) set_pte(ptep, pteval)
 #define set_pte_atomic(pteptr, pteval) set_pte(pteptr, pteval)
 
@@ -293,21 +301,6 @@ extern void check_mm_caching(struct mm_struct *prev, struct mm_struct *next);
 #define __swp_entry_to_pte(swp)	((pte_t) { (((long long) ((swp).val)) << 32) })
 
 /*
- * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
- *
- *  dst - pointer to pgd range anwhere on a pgd page
- *  src - ""
- *  count - the number of pgds to copy.
- *
- * dst and src can be on the same page, but the range must not overlap,
- * and must not cross a page boundary.
- */
-static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
-{
-       memcpy(dst, src, count * sizeof(pgd_t));
-}
-
-/*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
  */
diff --git a/arch/tile/include/asm/pgtable_32.h b/arch/tile/include/asm/pgtable_32.h
index 53ec348..9f98529 100644
--- a/arch/tile/include/asm/pgtable_32.h
+++ b/arch/tile/include/asm/pgtable_32.h
@@ -24,6 +24,7 @@
 #define PGDIR_SIZE	HV_PAGE_SIZE_LARGE
 #define PGDIR_MASK	(~(PGDIR_SIZE-1))
 #define PTRS_PER_PGD	(1 << (32 - PGDIR_SHIFT))
+#define SIZEOF_PGD	(PTRS_PER_PGD * sizeof(pgd_t))
 
 /*
  * The level-2 index is defined by the difference between the huge
@@ -33,6 +34,7 @@
  * this nomenclature is somewhat confusing.
  */
 #define PTRS_PER_PTE (1 << (HV_LOG2_PAGE_SIZE_LARGE - HV_LOG2_PAGE_SIZE_SMALL))
+#define SIZEOF_PTE	(PTRS_PER_PTE * sizeof(pte_t))
 
 #ifndef __ASSEMBLY__
 
@@ -94,7 +96,6 @@ static inline int pgd_addr_invalid(unsigned long addr)
  */
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
-#define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 
 extern int ptep_test_and_clear_young(struct vm_area_struct *,
 				     unsigned long addr, pte_t *);
@@ -110,6 +111,11 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 	return pte;
 }
 
+static inline void __set_pmd(pmd_t *pmdp, pmd_t pmdval)
+{
+	set_pte(&pmdp->pud.pgd, pmdval.pud.pgd);
+}
+
 /* Create a pmd from a PTFN. */
 static inline pmd_t ptfn_pmd(unsigned long ptfn, pgprot_t prot)
 {
diff --git a/arch/tile/include/asm/stack.h b/arch/tile/include/asm/stack.h
index f908473..4d97a2d 100644
--- a/arch/tile/include/asm/stack.h
+++ b/arch/tile/include/asm/stack.h
@@ -18,13 +18,14 @@
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <asm/backtrace.h>
+#include <asm/page.h>
 #include <hv/hypervisor.h>
 
 /* Everything we need to keep track of a backtrace iteration */
 struct KBacktraceIterator {
 	BacktraceIterator it;
 	struct task_struct *task;     /* task we are backtracing */
-	HV_PTE *pgtable;	      /* page table for user space access */
+	pte_t *pgtable;		      /* page table for user space access */
 	int end;		      /* iteration complete. */
 	int new_context;              /* new context is starting */
 	int profile;                  /* profiling, so stop on async intrpt */
diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index 3872f2b..9e8e9c4 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -68,6 +68,7 @@ struct thread_info {
 #else
 #define THREAD_SIZE_ORDER (0)
 #endif
+#define THREAD_SIZE_PAGES (1 << THREAD_SIZE_ORDER)
 
 #define THREAD_SIZE (PAGE_SIZE << THREAD_SIZE_ORDER)
 #define LOG2_THREAD_SIZE (PAGE_SHIFT + THREAD_SIZE_ORDER)
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index eabf1ef..fffcfa6 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -1556,7 +1556,10 @@ STD_ENTRY(_sys_clone)
 	.align 64
 	/* Align much later jump on the start of a cache line. */
 #if !ATOMIC_LOCKS_FOUND_VIA_TABLE()
-	nop; nop
+	nop
+#if PAGE_SIZE >= 0x10000
+	nop
+#endif
 #endif
 ENTRY(sys_cmpxchg)
 
@@ -1587,6 +1590,10 @@ ENTRY(sys_cmpxchg)
 	 * NOTE: this must match __atomic_hashed_lock() in lib/atomic_32.c.
 	 */
 
+#if (PAGE_OFFSET & 0xffff) != 0
+# error Code here assumes PAGE_OFFSET can be loaded with just hi16()
+#endif
+
 #if ATOMIC_LOCKS_FOUND_VIA_TABLE()
 	{
 	 /* Check for unaligned input. */
@@ -1679,11 +1686,14 @@ ENTRY(sys_cmpxchg)
 	 lw	r26, r0
 	}
 	{
-	 /* atomic_locks is page aligned so this suffices to get its addr. */
-	 auli	r21, zero, hi16(atomic_locks)
+	 auli	r21, zero, ha16(atomic_locks)
 
 	 bbns   r23, .Lcmpxchg_badaddr
 	}
+#if PAGE_SIZE < 0x10000
+	/* atomic_locks is page-aligned so for big pages we don't need this. */
+	addli   r21, r21, lo16(atomic_locks)
+#endif
 	{
 	 /*
 	  * Insert the hash bits into the page-aligned pointer.
diff --git a/arch/tile/kernel/machine_kexec.c b/arch/tile/kernel/machine_kexec.c
index 0d8b9e9..e00d717 100644
--- a/arch/tile/kernel/machine_kexec.c
+++ b/arch/tile/kernel/machine_kexec.c
@@ -240,8 +240,11 @@ static void setup_quasi_va_is_pa(void)
 	pte = hv_pte(_PAGE_KERNEL | _PAGE_HUGE_PAGE);
 	pte = hv_pte_set_mode(pte, HV_PTE_MODE_CACHE_NO_L3);
 
-	for (i = 0; i < pgd_index(PAGE_OFFSET); i++)
-		pgtable[i] = pfn_pte(i << (HPAGE_SHIFT - PAGE_SHIFT), pte);
+	for (i = 0; i < pgd_index(PAGE_OFFSET); i++) {
+		unsigned long pfn = i << (HPAGE_SHIFT - PAGE_SHIFT);
+		if (pfn_valid(pfn))
+			__set_pte(&pgtable[i], pfn_pte(pfn, pte));
+	}
 }
 
 
diff --git a/arch/tile/kernel/pci-dma.c b/arch/tile/kernel/pci-dma.c
index 5ad5e13..658752b 100644
--- a/arch/tile/kernel/pci-dma.c
+++ b/arch/tile/kernel/pci-dma.c
@@ -86,6 +86,21 @@ EXPORT_SYMBOL(dma_free_coherent);
  * can count on nothing having been touched.
  */
 
+/* Flush a PA range from cache page by page. */
+static void __dma_map_pa_range(dma_addr_t dma_addr, size_t size)
+{
+	struct page *page = pfn_to_page(PFN_DOWN(dma_addr));
+	size_t bytesleft = PAGE_SIZE - (dma_addr & (PAGE_SIZE - 1));
+
+	while ((ssize_t)size > 0) {
+		/* Flush the page. */
+		homecache_flush_cache(page++, 0);
+
+		/* Figure out if we need to continue on the next page. */
+		size -= bytesleft;
+		bytesleft = PAGE_SIZE;
+	}
+}
 
 /*
  * dma_map_single can be passed any memory address, and there appear
@@ -97,26 +112,12 @@ EXPORT_SYMBOL(dma_free_coherent);
 dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 	       enum dma_data_direction direction)
 {
-	struct page *page;
-	dma_addr_t dma_addr;
-	int thispage;
+	dma_addr_t dma_addr = __pa(ptr);
 
 	BUG_ON(!valid_dma_direction(direction));
 	WARN_ON(size == 0);
 
-	dma_addr = __pa(ptr);
-
-	/* We might have been handed a buffer that wraps a page boundary */
-	while ((int)size > 0) {
-		/* The amount to flush that's on this page */
-		thispage = PAGE_SIZE - ((unsigned long)ptr & (PAGE_SIZE - 1));
-		thispage = min((int)thispage, (int)size);
-		/* Is this valid for any page we could be handed? */
-		page = pfn_to_page(kaddr_to_pfn(ptr));
-		homecache_flush_cache(page, 0);
-		ptr += thispage;
-		size -= thispage;
-	}
+	__dma_map_pa_range(dma_addr, size);
 
 	return dma_addr;
 }
@@ -140,10 +141,8 @@ int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	WARN_ON(nents == 0 || sglist->length == 0);
 
 	for_each_sg(sglist, sg, nents, i) {
-		struct page *page;
 		sg->dma_address = sg_phys(sg);
-		page = pfn_to_page(sg->dma_address >> PAGE_SHIFT);
-		homecache_flush_cache(page, 0);
+		__dma_map_pa_range(sg->dma_address, sg->length);
 	}
 
 	return nents;
@@ -163,6 +162,7 @@ dma_addr_t dma_map_page(struct device *dev, struct page *page,
 {
 	BUG_ON(!valid_dma_direction(direction));
 
+	BUG_ON(offset + size > PAGE_SIZE);
 	homecache_flush_cache(page, 0);
 
 	return page_to_pa(page) + offset;
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 5db8b5b..b9cd962 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -165,7 +165,7 @@ void free_thread_info(struct thread_info *info)
 		kfree(step_state);
 	}
 
-	free_page((unsigned long)info);
+	free_pages((unsigned long)info, THREAD_SIZE_ORDER);
 }
 
 static void save_arch_state(struct thread_struct *t);
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index f185736..3696b18 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -59,6 +59,8 @@ unsigned long __initdata node_memmap_pfn[MAX_NUMNODES];
 unsigned long __initdata node_percpu_pfn[MAX_NUMNODES];
 unsigned long __initdata node_free_pfn[MAX_NUMNODES];
 
+static unsigned long __initdata node_percpu[MAX_NUMNODES];
+
 #ifdef CONFIG_HIGHMEM
 /* Page frame index of end of lowmem on each controller. */
 unsigned long __cpuinitdata node_lowmem_end_pfn[MAX_NUMNODES];
@@ -554,7 +556,6 @@ static void __init setup_bootmem_allocator(void)
 		reserve_bootmem(crashk_res.start,
 			crashk_res.end - crashk_res.start + 1, 0);
 #endif
-
 }
 
 void *__init alloc_remap(int nid, unsigned long size)
@@ -568,11 +569,13 @@ void *__init alloc_remap(int nid, unsigned long size)
 
 static int __init percpu_size(void)
 {
-	int size = ALIGN(__per_cpu_end - __per_cpu_start, PAGE_SIZE);
-#ifdef CONFIG_MODULES
-	if (size < PERCPU_ENOUGH_ROOM)
-		size = PERCPU_ENOUGH_ROOM;
-#endif
+	int size = __per_cpu_end - __per_cpu_start;
+	size += PERCPU_MODULE_RESERVE;
+	size += PERCPU_DYNAMIC_EARLY_SIZE;
+	if (size < PCPU_MIN_UNIT_SIZE)
+		size = PCPU_MIN_UNIT_SIZE;
+	size = roundup(size, PAGE_SIZE);
+
 	/* In several places we assume the per-cpu data fits on a huge page. */
 	BUG_ON(kdata_huge && size > HPAGE_SIZE);
 	return size;
@@ -589,7 +592,6 @@ static inline unsigned long alloc_bootmem_pfn(int size, unsigned long goal)
 static void __init zone_sizes_init(void)
 {
 	unsigned long zones_size[MAX_NR_ZONES] = { 0 };
-	unsigned long node_percpu[MAX_NUMNODES] = { 0 };
 	int size = percpu_size();
 	int num_cpus = smp_height * smp_width;
 	int i;
@@ -674,7 +676,7 @@ static void __init zone_sizes_init(void)
 		NODE_DATA(i)->bdata = NODE_DATA(0)->bdata;
 
 		free_area_init_node(i, zones_size, start, NULL);
-		printk(KERN_DEBUG "  DMA zone: %ld per-cpu pages\n",
+		printk(KERN_DEBUG "  Normal zone: %ld per-cpu pages\n",
 		       PFN_UP(node_percpu[i]));
 
 		/* Track the type of memory on each node */
@@ -1312,6 +1314,8 @@ static void *__init pcpu_fc_alloc(unsigned int cpu, size_t size, size_t align)
 
 	BUG_ON(size % PAGE_SIZE != 0);
 	pfn_offset[nid] += size / PAGE_SIZE;
+	BUG_ON(node_percpu[nid] < size);
+	node_percpu[nid] -= size;
 	if (percpu_pfn[cpu] == 0)
 		percpu_pfn[cpu] = pfn;
 	return pfn_to_kaddr(pfn);
diff --git a/arch/tile/lib/memcpy_tile64.c b/arch/tile/lib/memcpy_tile64.c
index f7d4a6a..b2fe15e 100644
--- a/arch/tile/lib/memcpy_tile64.c
+++ b/arch/tile/lib/memcpy_tile64.c
@@ -96,7 +96,7 @@ static void memcpy_multicache(void *dest, const void *source,
 	newsrc = __fix_to_virt(idx) + ((unsigned long)source & (PAGE_SIZE-1));
 	pmdp = pmd_offset(pud_offset(pgd_offset_k(newsrc), newsrc), newsrc);
 	ptep = pte_offset_kernel(pmdp, newsrc);
-	*ptep = src_pte;   /* set_pte() would be confused by this */
+	__set_pte(ptep, src_pte);   /* set_pte() would be confused by this */
 	local_flush_tlb_page(NULL, newsrc, PAGE_SIZE);
 
 	/* Actually move the data. */
@@ -109,7 +109,7 @@ static void memcpy_multicache(void *dest, const void *source,
 	 */
 	src_pte = hv_pte_set_mode(src_pte, HV_PTE_MODE_CACHE_NO_L3);
 	src_pte = hv_pte_set_writable(src_pte); /* need write access for inv */
-	*ptep = src_pte;   /* set_pte() would be confused by this */
+	__set_pte(ptep, src_pte);   /* set_pte() would be confused by this */
 	local_flush_tlb_page(NULL, newsrc, PAGE_SIZE);
 
 	/*
diff --git a/arch/tile/mm/homecache.c b/arch/tile/mm/homecache.c
index f344f4f..cbe6f4f 100644
--- a/arch/tile/mm/homecache.c
+++ b/arch/tile/mm/homecache.c
@@ -412,7 +412,7 @@ void homecache_change_page_home(struct page *page, int order, int home)
 		pte_t *ptep = virt_to_pte(NULL, kva);
 		pte_t pteval = *ptep;
 		BUG_ON(!pte_present(pteval) || pte_huge(pteval));
-		*ptep = pte_set_home(pteval, home);
+		__set_pte(ptep, pte_set_home(pteval, home));
 	}
 }
 
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index f89ed5d..d6e87fd 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -53,18 +53,6 @@
 
 #include "migrate.h"
 
-/*
- * We could set FORCE_MAX_ZONEORDER to "(HPAGE_SHIFT - PAGE_SHIFT + 1)"
- * in the Tile Kconfig, but this generates configure warnings.
- * Do it here and force people to get it right to compile this file.
- * The problem is that with 4KB small pages and 16MB huge pages,
- * the default value doesn't allow us to group enough small pages
- * together to make up a huge page.
- */
-#if CONFIG_FORCE_MAX_ZONEORDER < HPAGE_SHIFT - PAGE_SHIFT + 1
-# error "Change FORCE_MAX_ZONEORDER in arch/tile/Kconfig to match page size"
-#endif
-
 #define clear_pgd(pmdptr) (*(pmdptr) = hv_pte(0))
 
 #ifndef __tilegx__
@@ -962,11 +950,7 @@ struct kmem_cache *pgd_cache;
 
 void __init pgtable_cache_init(void)
 {
-	pgd_cache = kmem_cache_create("pgd",
-				PTRS_PER_PGD*sizeof(pgd_t),
-				PTRS_PER_PGD*sizeof(pgd_t),
-				0,
-				NULL);
+	pgd_cache = kmem_cache_create("pgd", SIZEOF_PGD, SIZEOF_PGD, 0, NULL);
 	if (!pgd_cache)
 		panic("pgtable_cache_init(): Cannot create pgd cache");
 }
diff --git a/arch/tile/mm/migrate_32.S b/arch/tile/mm/migrate_32.S
index f738765..ac01a7c 100644
--- a/arch/tile/mm/migrate_32.S
+++ b/arch/tile/mm/migrate_32.S
@@ -18,6 +18,7 @@
 #include <linux/linkage.h>
 #include <linux/threads.h>
 #include <asm/page.h>
+#include <asm/thread_info.h>
 #include <asm/types.h>
 #include <asm/asm-offsets.h>
 #include <hv/hypervisor.h>
diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
index 2c850d9..1a2b36f 100644
--- a/arch/tile/mm/pgtable.c
+++ b/arch/tile/mm/pgtable.c
@@ -142,6 +142,76 @@ pte_t *_pte_offset_map(pmd_t *dir, unsigned long address)
 }
 #endif
 
+/**
+ * shatter_huge_page() - ensure a given address is mapped by a small page.
+ *
+ * This function converts a huge PTE mapping kernel LOWMEM into a bunch
+ * of small PTEs with the same caching.  No cache flush required, but we
+ * must do a global TLB flush.
+ *
+ * Any caller that wishes to modify a kernel mapping that might
+ * have been made with a huge page should call this function,
+ * since doing so properly avoids race conditions with installing the
+ * newly-shattered page and then flushing all the TLB entries.
+ *
+ * @addr: Address at which to shatter any existing huge page.
+ */
+void shatter_huge_page(unsigned long addr)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	unsigned long flags = 0;  /* happy compiler */
+#ifdef __PAGETABLE_PMD_FOLDED
+	struct list_head *pos;
+#endif
+
+	/* Get a pointer to the pmd entry that we need to change. */
+	addr &= HPAGE_MASK;
+	BUG_ON(pgd_addr_invalid(addr));
+	BUG_ON(addr < PAGE_OFFSET);  /* only for kernel LOWMEM */
+	pgd = swapper_pg_dir + pgd_index(addr);
+	pud = pud_offset(pgd, addr);
+	BUG_ON(!pud_present(*pud));
+	pmd = pmd_offset(pud, addr);
+	BUG_ON(!pmd_present(*pmd));
+	if (!pmd_huge_page(*pmd))
+		return;
+
+	/*
+	 * Grab the pgd_lock, since we may need it to walk the pgd_list,
+	 * and since we need some kind of lock here to avoid races.
+	 */
+	spin_lock_irqsave(&pgd_lock, flags);
+	if (!pmd_huge_page(*pmd)) {
+		/* Lost the race to convert the huge page. */
+		spin_unlock_irqrestore(&pgd_lock, flags);
+		return;
+	}
+
+	/* Shatter the huge page into the preallocated L2 page table. */
+	pmd_populate_kernel(&init_mm, pmd,
+			    get_prealloc_pte(pte_pfn(*(pte_t *)pmd)));
+
+#ifdef __PAGETABLE_PMD_FOLDED
+	/* Walk every pgd on the system and update the pmd there. */
+	list_for_each(pos, &pgd_list) {
+		pmd_t *copy_pmd;
+		pgd = list_to_pgd(pos) + pgd_index(addr);
+		pud = pud_offset(pgd, addr);
+		copy_pmd = pmd_offset(pud, addr);
+		__set_pmd(copy_pmd, *pmd);
+	}
+#endif
+
+	/* Tell every cpu to notice the change. */
+	flush_remote(0, 0, NULL, addr, HPAGE_SIZE, HPAGE_SIZE,
+		     cpu_possible_mask, NULL, 0);
+
+	/* Hold the lock until the TLB flush is finished to avoid races. */
+	spin_unlock_irqrestore(&pgd_lock, flags);
+}
+
 /*
  * List of all pgd's needed so it can invalidate entries in both cached
  * and uncached pgd's. This is essentially codepath-based locking
@@ -184,9 +254,9 @@ static void pgd_ctor(pgd_t *pgd)
 	BUG_ON(((u64 *)swapper_pg_dir)[pgd_index(MEM_USER_INTRPT)] != 0);
 #endif
 
-	clone_pgd_range(pgd + KERNEL_PGD_INDEX_START,
-			swapper_pg_dir + KERNEL_PGD_INDEX_START,
-			KERNEL_PGD_PTRS);
+	memcpy(pgd + KERNEL_PGD_INDEX_START,
+	       swapper_pg_dir + KERNEL_PGD_INDEX_START,
+	       KERNEL_PGD_PTRS * sizeof(pgd_t));
 
 	pgd_list_add(pgd);
 	spin_unlock_irqrestore(&pgd_lock, flags);
@@ -220,8 +290,11 @@ void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 
 struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	gfp_t flags = GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO|__GFP_COMP;
+	gfp_t flags = GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO;
 	struct page *p;
+#if L2_USER_PGTABLE_ORDER > 0
+	int i;
+#endif
 
 #ifdef CONFIG_HIGHPTE
 	flags |= __GFP_HIGHMEM;
@@ -231,6 +304,18 @@ struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
 	if (p == NULL)
 		return NULL;
 
+#if L2_USER_PGTABLE_ORDER > 0
+	/*
+	 * Make every page have a page_count() of one, not just the first.
+	 * We don't use __GFP_COMP since it doesn't look like it works
+	 * correctly with tlb_remove_page().
+	 */
+	for (i = 1; i < L2_USER_PGTABLE_PAGES; ++i) {
+		init_page_count(p+i);
+		inc_zone_page_state(p+i, NR_PAGETABLE);
+	}
+#endif
+
 	pgtable_page_ctor(p);
 	return p;
 }
@@ -242,8 +327,15 @@ struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
  */
 void pte_free(struct mm_struct *mm, struct page *p)
 {
+	int i;
+
 	pgtable_page_dtor(p);
-	__free_pages(p, L2_USER_PGTABLE_ORDER);
+	__free_page(p);
+
+	for (i = 1; i < L2_USER_PGTABLE_PAGES; ++i) {
+		__free_page(p+i);
+		dec_zone_page_state(p+i, NR_PAGETABLE);
+	}
 }
 
 void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte,
@@ -252,8 +344,12 @@ void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte,
 	int i;
 
 	pgtable_page_dtor(pte);
-	for (i = 0; i < L2_USER_PGTABLE_PAGES; ++i)
+	tlb_remove_page(tlb, pte);
+
+	for (i = 1; i < L2_USER_PGTABLE_PAGES; ++i) {
 		tlb_remove_page(tlb, pte + i);
+		dec_zone_page_state(pte + i, NR_PAGETABLE);
+	}
 }
 
 #ifndef __tilegx__
@@ -335,35 +431,51 @@ int get_remote_cache_cpu(pgprot_t prot)
 	return x + y * smp_width;
 }
 
-void set_pte_order(pte_t *ptep, pte_t pte, int order)
+/*
+ * Convert a kernel VA to a PA and homing information.
+ */
+int va_to_cpa_and_pte(void *va, unsigned long long *cpa, pte_t *pte)
 {
-	unsigned long pfn = pte_pfn(pte);
-	struct page *page = pfn_to_page(pfn);
+	struct page *page = virt_to_page(va);
+	pte_t null_pte = { 0 };
 
-	/* Update the home of a PTE if necessary */
-	pte = pte_set_home(pte, page_home(page));
+	*cpa = __pa(va);
+
+	/* Note that this is not writing a page table, just returning a pte. */
+	*pte = pte_set_home(null_pte, page_home(page));
+
+	return 0; /* return non-zero if not hfh? */
+}
+EXPORT_SYMBOL(va_to_cpa_and_pte);
 
+void __set_pte(pte_t *ptep, pte_t pte)
+{
 #ifdef __tilegx__
 	*ptep = pte;
 #else
-	/*
-	 * When setting a PTE, write the high bits first, then write
-	 * the low bits.  This sets the "present" bit only after the
-	 * other bits are in place.  If a particular PTE update
-	 * involves transitioning from one valid PTE to another, it
-	 * may be necessary to call set_pte_order() more than once,
-	 * transitioning via a suitable intermediate state.
-	 * Note that this sequence also means that if we are transitioning
-	 * from any migrating PTE to a non-migrating one, we will not
-	 * see a half-updated PTE with the migrating bit off.
-	 */
-#if HV_PTE_INDEX_PRESENT >= 32 || HV_PTE_INDEX_MIGRATING >= 32
-# error Must write the present and migrating bits last
-#endif
-	((u32 *)ptep)[1] = (u32)(pte_val(pte) >> 32);
-	barrier();
-	((u32 *)ptep)[0] = (u32)(pte_val(pte));
-#endif
+# if HV_PTE_INDEX_PRESENT >= 32 || HV_PTE_INDEX_MIGRATING >= 32
+#  error Must write the present and migrating bits last
+# endif
+	if (pte_present(pte)) {
+		((u32 *)ptep)[1] = (u32)(pte_val(pte) >> 32);
+		barrier();
+		((u32 *)ptep)[0] = (u32)(pte_val(pte));
+	} else {
+		((u32 *)ptep)[0] = (u32)(pte_val(pte));
+		barrier();
+		((u32 *)ptep)[1] = (u32)(pte_val(pte) >> 32);
+	}
+#endif /* __tilegx__ */
+}
+
+void set_pte(pte_t *ptep, pte_t pte)
+{
+	struct page *page = pfn_to_page(pte_pfn(pte));
+
+	/* Update the home of a PTE if necessary */
+	pte = pte_set_home(pte, page_home(page));
+
+	__set_pte(ptep, pte);
 }
 
 /* Can this mm load a PTE with cached_priority set? */
-- 
1.6.5.2

