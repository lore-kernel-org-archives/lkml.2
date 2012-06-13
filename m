Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab2FPUgl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 16:36:41 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:39465 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab2FPUgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 16:36:39 -0400
Message-ID: <201206162036.q5GKacEK017774@lab-41.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 13 Jun 2012 14:46:40 -0400
Subject: [PATCH 1/3] tilegx pci: support I/O to arbitrarily-cached pages
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tilegx PCI root complex support (currently only in linux-next)
is limited to pages that are homed on cached in the default manner,
i.e. "hash-for-home".  This change supports delivery of I/O data to
pages that are cached in other ways (locally on a particular core,
uncached, user-managed incoherent, etc.).

A large part of the change is supporting flushing pages from cache
on particular homes so that we can transition the data that we are
delivering to or from the device appropriately.  The new homecache_finv*
routines handle this.

Some changes to page_table_range_init() were also required to make
the fixmap code work correctly on tilegx; it hadn't been used there
before.

We also remove some stub mark_caches_evicted_*() routines that
were just no-ops anyway.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/cache.h     |   12 ++-
 arch/tile/include/asm/fixmap.h    |   14 ++-
 arch/tile/include/asm/homecache.h |   19 ++--
 arch/tile/include/asm/page.h      |    7 +-
 arch/tile/kernel/pci-dma.c        |  182 +++++++++++++++++++++++++++++--------
 arch/tile/mm/homecache.c          |  156 +++++++++++++++----------------
 arch/tile/mm/init.c               |   59 +++++-------
 7 files changed, 278 insertions(+), 171 deletions(-)

diff --git a/arch/tile/include/asm/cache.h b/arch/tile/include/asm/cache.h
index 392e533..a9a5299 100644
--- a/arch/tile/include/asm/cache.h
+++ b/arch/tile/include/asm/cache.h
@@ -27,11 +27,17 @@
 #define L2_CACHE_ALIGN(x)	(((x)+(L2_CACHE_BYTES-1)) & -L2_CACHE_BYTES)
 
 /*
- * TILE-Gx is fully coherent so we don't need to define ARCH_DMA_MINALIGN.
+ * TILEPro I/O is not always coherent (networking typically uses coherent
+ * I/O, but PCI traffic does not) and setting ARCH_DMA_MINALIGN to the
+ * L2 cacheline size helps ensure that kernel heap allocations are aligned.
+ * TILE-Gx I/O is always coherent when used on hash-for-home pages.
+ *
+ * However, it's possible at runtime to request not to use hash-for-home
+ * for the kernel heap, in which case the kernel will use flush-and-inval
+ * to manage coherence.  As a result, we use L2_CACHE_BYTES for the
+ * DMA minimum alignment to avoid false sharing in the kernel heap.
  */
-#ifndef __tilegx__
 #define ARCH_DMA_MINALIGN	L2_CACHE_BYTES
-#endif
 
 /* use the cache line size for the L2, which is where it counts */
 #define SMP_CACHE_BYTES_SHIFT	L2_CACHE_SHIFT
diff --git a/arch/tile/include/asm/fixmap.h b/arch/tile/include/asm/fixmap.h
index c66f793..e16dbf9 100644
--- a/arch/tile/include/asm/fixmap.h
+++ b/arch/tile/include/asm/fixmap.h
@@ -45,15 +45,23 @@
  *
  * TLB entries of such buffers will not be flushed across
  * task switches.
- *
- * We don't bother with a FIX_HOLE since above the fixmaps
- * is unmapped memory in any case.
  */
 enum fixed_addresses {
+#ifdef __tilegx__
+	/*
+	 * TILEPro has unmapped memory above so the hole isn't needed,
+	 * and in any case the hole pushes us over a single 16MB pmd.
+	 */
+	FIX_HOLE,
+#endif
 #ifdef CONFIG_HIGHMEM
 	FIX_KMAP_BEGIN,	/* reserved pte's for temporary kernel mappings */
 	FIX_KMAP_END = FIX_KMAP_BEGIN+(KM_TYPE_NR*NR_CPUS)-1,
 #endif
+#ifdef __tilegx__  /* see homecache.c */
+	FIX_HOMECACHE_BEGIN,
+	FIX_HOMECACHE_END = FIX_HOMECACHE_BEGIN+(NR_CPUS)-1,
+#endif
 	__end_of_permanent_fixed_addresses,
 
 	/*
diff --git a/arch/tile/include/asm/homecache.h b/arch/tile/include/asm/homecache.h
index a824386..7b77713 100644
--- a/arch/tile/include/asm/homecache.h
+++ b/arch/tile/include/asm/homecache.h
@@ -79,10 +79,17 @@ extern void homecache_change_page_home(struct page *, int order, int home);
 /*
  * Flush a page out of whatever cache(s) it is in.
  * This is more than just finv, since it properly handles waiting
- * for the data to reach memory on tilepro, but it can be quite
- * heavyweight, particularly on hash-for-home memory.
+ * for the data to reach memory, but it can be quite
+ * heavyweight, particularly on incoherent or immutable memory.
  */
-extern void homecache_flush_cache(struct page *, int order);
+extern void homecache_finv_page(struct page *);
+
+/*
+ * Flush a page out of the specified home cache.
+ * Note that the specified home need not be the actual home of the page,
+ * as for example might be the case when coordinating with I/O devices.
+ */
+extern void homecache_finv_map_page(struct page *, int home);
 
 /*
  * Allocate a page with the given GFP flags, home, and optionally
@@ -104,10 +111,10 @@ extern struct page *homecache_alloc_pages_node(int nid, gfp_t gfp_mask,
  * routines use homecache_change_page_home() to reset the home
  * back to the default before returning the page to the allocator.
  */
+void __homecache_free_pages(struct page *, unsigned int order);
 void homecache_free_pages(unsigned long addr, unsigned int order);
-#define homecache_free_page(page) \
-  homecache_free_pages((page), 0)
-
+#define __homecache_free_page(page) __homecache_free_pages((page), 0)
+#define homecache_free_page(page) homecache_free_pages((page), 0)
 
 
 /*
diff --git a/arch/tile/include/asm/page.h b/arch/tile/include/asm/page.h
index 9d9131e..dd033a4 100644
--- a/arch/tile/include/asm/page.h
+++ b/arch/tile/include/asm/page.h
@@ -174,7 +174,9 @@ static inline __attribute_const__ int get_order(unsigned long size)
 #define MEM_LOW_END		(HALF_VA_SPACE - 1)         /* low half */
 #define MEM_HIGH_START		(-HALF_VA_SPACE)            /* high half */
 #define PAGE_OFFSET		MEM_HIGH_START
-#define _VMALLOC_START		_AC(0xfffffff500000000, UL) /* 4 GB */
+#define FIXADDR_BASE		_AC(0xfffffff400000000, UL) /* 4 GB */
+#define FIXADDR_TOP		_AC(0xfffffff500000000, UL) /* 4 GB */
+#define _VMALLOC_START		FIXADDR_TOP
 #define HUGE_VMAP_BASE		_AC(0xfffffff600000000, UL) /* 4 GB */
 #define MEM_SV_START		_AC(0xfffffff700000000, UL) /* 256 MB */
 #define MEM_SV_INTRPT		MEM_SV_START
@@ -185,9 +187,6 @@ static inline __attribute_const__ int get_order(unsigned long size)
 /* Highest DTLB address we will use */
 #define KERNEL_HIGH_VADDR	MEM_SV_START
 
-/* Since we don't currently provide any fixmaps, we use an impossible VA. */
-#define FIXADDR_TOP             MEM_HV_START
-
 #else /* !__tilegx__ */
 
 /*
diff --git a/arch/tile/kernel/pci-dma.c b/arch/tile/kernel/pci-dma.c
index b3ed19f..9814d70 100644
--- a/arch/tile/kernel/pci-dma.c
+++ b/arch/tile/kernel/pci-dma.c
@@ -22,9 +22,15 @@
 /* Generic DMA mapping functions: */
 
 /*
- * Allocate what Linux calls "coherent" memory, which for us just
- * means uncached.
+ * Allocate what Linux calls "coherent" memory.  On TILEPro this is
+ * uncached memory; on TILE-Gx it is hash-for-home memory.
  */
+#ifdef __tilepro__
+#define PAGE_HOME_DMA PAGE_HOME_UNCACHED
+#else
+#define PAGE_HOME_DMA PAGE_HOME_HASH
+#endif
+
 void *dma_alloc_coherent(struct device *dev,
 			 size_t size,
 			 dma_addr_t *dma_handle,
@@ -48,13 +54,13 @@ void *dma_alloc_coherent(struct device *dev,
 	if (dma_mask <= DMA_BIT_MASK(32))
 		node = 0;
 
-	pg = homecache_alloc_pages_node(node, gfp, order, PAGE_HOME_UNCACHED);
+	pg = homecache_alloc_pages_node(node, gfp, order, PAGE_HOME_DMA);
 	if (pg == NULL)
 		return NULL;
 
 	addr = page_to_phys(pg);
 	if (addr + size > dma_mask) {
-		homecache_free_pages(addr, order);
+		__homecache_free_pages(pg, order);
 		return NULL;
 	}
 
@@ -87,22 +93,110 @@ EXPORT_SYMBOL(dma_free_coherent);
  * can count on nothing having been touched.
  */
 
-/* Flush a PA range from cache page by page. */
-static void __dma_map_pa_range(dma_addr_t dma_addr, size_t size)
+/* Set up a single page for DMA access. */
+static void __dma_prep_page(struct page *page, unsigned long offset,
+			    size_t size, enum dma_data_direction direction)
 {
-	struct page *page = pfn_to_page(PFN_DOWN(dma_addr));
-	size_t bytesleft = PAGE_SIZE - (dma_addr & (PAGE_SIZE - 1));
+	/*
+	 * Flush the page from cache if necessary.
+	 * On tilegx, data is delivered to hash-for-home L3; on tilepro,
+	 * data is delivered direct to memory.
+	 *
+	 * NOTE: If we were just doing DMA_TO_DEVICE we could optimize
+	 * this to be a "flush" not a "finv" and keep some of the
+	 * state in cache across the DMA operation, but it doesn't seem
+	 * worth creating the necessary flush_buffer_xxx() infrastructure.
+	 */
+	int home = page_home(page);
+	switch (home) {
+	case PAGE_HOME_HASH:
+#ifdef __tilegx__
+		return;
+#endif
+		break;
+	case PAGE_HOME_UNCACHED:
+#ifdef __tilepro__
+		return;
+#endif
+		break;
+	case PAGE_HOME_IMMUTABLE:
+		/* Should be going to the device only. */
+		BUG_ON(direction == DMA_FROM_DEVICE ||
+		       direction == DMA_BIDIRECTIONAL);
+		return;
+	case PAGE_HOME_INCOHERENT:
+		/* Incoherent anyway, so no need to work hard here. */
+		return;
+	default:
+		BUG_ON(home < 0 || home >= NR_CPUS);
+		break;
+	}
+	homecache_finv_page(page);
+
+#ifdef DEBUG_ALIGNMENT
+	/* Warn if the region isn't cacheline aligned. */
+	if (offset & (L2_CACHE_BYTES - 1) || (size & (L2_CACHE_BYTES - 1)))
+		pr_warn("Unaligned DMA to non-hfh memory: PA %#llx/%#lx\n",
+			PFN_PHYS(page_to_pfn(page)) + offset, size);
+#endif
+}
 
-	while ((ssize_t)size > 0) {
-		/* Flush the page. */
-		homecache_flush_cache(page++, 0);
+/* Make the page ready to be read by the core. */
+static void __dma_complete_page(struct page *page, unsigned long offset,
+				size_t size, enum dma_data_direction direction)
+{
+#ifdef __tilegx__
+	switch (page_home(page)) {
+	case PAGE_HOME_HASH:
+		/* I/O device delivered data the way the cpu wanted it. */
+		break;
+	case PAGE_HOME_INCOHERENT:
+		/* Incoherent anyway, so no need to work hard here. */
+		break;
+	case PAGE_HOME_IMMUTABLE:
+		/* Extra read-only copies are not a problem. */
+		break;
+	default:
+		/* Flush the bogus hash-for-home I/O entries to memory. */
+		homecache_finv_map_page(page, PAGE_HOME_HASH);
+		break;
+	}
+#endif
+}
 
-		/* Figure out if we need to continue on the next page. */
-		size -= bytesleft;
-		bytesleft = PAGE_SIZE;
+static void __dma_prep_pa_range(dma_addr_t dma_addr, size_t size,
+				enum dma_data_direction direction)
+{
+	struct page *page = pfn_to_page(PFN_DOWN(dma_addr));
+	unsigned long offset = dma_addr & (PAGE_SIZE - 1);
+	size_t bytes = min(size, (size_t)(PAGE_SIZE - offset));
+
+	while (size != 0) {
+		__dma_prep_page(page, offset, bytes, direction);
+		size -= bytes;
+		++page;
+		offset = 0;
+		bytes = min((size_t)PAGE_SIZE, size);
+	}
+}
+
+static void __dma_complete_pa_range(dma_addr_t dma_addr, size_t size,
+				    enum dma_data_direction direction)
+{
+	struct page *page = pfn_to_page(PFN_DOWN(dma_addr));
+	unsigned long offset = dma_addr & (PAGE_SIZE - 1);
+	size_t bytes = min(size, (size_t)(PAGE_SIZE - offset));
+
+	while (size != 0) {
+		__dma_complete_page(page, offset, bytes, direction);
+		size -= bytes;
+		++page;
+		offset = 0;
+		bytes = min((size_t)PAGE_SIZE, size);
 	}
 }
 
+
 /*
  * dma_map_single can be passed any memory address, and there appear
  * to be no alignment constraints.
@@ -111,28 +205,29 @@ static void __dma_map_pa_range(dma_addr_t dma_addr, size_t size)
  * line with some other data that has been touched in the meantime.
  */
 dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
-	       enum dma_data_direction direction)
+			  enum dma_data_direction direction)
 {
 	dma_addr_t dma_addr = __pa(ptr);
 
 	BUG_ON(!valid_dma_direction(direction));
 	WARN_ON(size == 0);
 
-	__dma_map_pa_range(dma_addr, size);
+	__dma_prep_pa_range(dma_addr, size, direction);
 
 	return dma_addr;
 }
 EXPORT_SYMBOL(dma_map_single);
 
 void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		 enum dma_data_direction direction)
+		      enum dma_data_direction direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
+	__dma_complete_pa_range(dma_addr, size, direction);
 }
 EXPORT_SYMBOL(dma_unmap_single);
 
 int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
-	   enum dma_data_direction direction)
+	       enum dma_data_direction direction)
 {
 	struct scatterlist *sg;
 	int i;
@@ -143,17 +238,25 @@ int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 
 	for_each_sg(sglist, sg, nents, i) {
 		sg->dma_address = sg_phys(sg);
-		__dma_map_pa_range(sg->dma_address, sg->length);
+		__dma_prep_pa_range(sg->dma_address, sg->length, direction);
 	}
 
 	return nents;
 }
 EXPORT_SYMBOL(dma_map_sg);
 
-void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-	     enum dma_data_direction direction)
+void dma_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
+		  enum dma_data_direction direction)
 {
+	struct scatterlist *sg;
+	int i;
+
 	BUG_ON(!valid_dma_direction(direction));
+	for_each_sg(sglist, sg, nents, i) {
+		sg->dma_address = sg_phys(sg);
+		__dma_complete_pa_range(sg->dma_address, sg->length,
+					direction);
+	}
 }
 EXPORT_SYMBOL(dma_unmap_sg);
 
@@ -164,16 +267,17 @@ dma_addr_t dma_map_page(struct device *dev, struct page *page,
 	BUG_ON(!valid_dma_direction(direction));
 
 	BUG_ON(offset + size > PAGE_SIZE);
-	homecache_flush_cache(page, 0);
-
+	__dma_prep_page(page, offset, size, direction);
 	return page_to_pa(page) + offset;
 }
 EXPORT_SYMBOL(dma_map_page);
 
 void dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-	       enum dma_data_direction direction)
+		    enum dma_data_direction direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
+	__dma_complete_page(pfn_to_page(PFN_DOWN(dma_address)),
+			    dma_address & PAGE_OFFSET, size, direction);
 }
 EXPORT_SYMBOL(dma_unmap_page);
 
@@ -181,33 +285,33 @@ void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
 			     size_t size, enum dma_data_direction direction)
 {
 	BUG_ON(!valid_dma_direction(direction));
+	__dma_complete_pa_range(dma_handle, size, direction);
 }
 EXPORT_SYMBOL(dma_sync_single_for_cpu);
 
 void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
 				size_t size, enum dma_data_direction direction)
 {
-	unsigned long start = PFN_DOWN(dma_handle);
-	unsigned long end = PFN_DOWN(dma_handle + size - 1);
-	unsigned long i;
-
-	BUG_ON(!valid_dma_direction(direction));
-	for (i = start; i <= end; ++i)
-		homecache_flush_cache(pfn_to_page(i), 0);
+	__dma_prep_pa_range(dma_handle, size, direction);
 }
 EXPORT_SYMBOL(dma_sync_single_for_device);
 
-void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
-		    enum dma_data_direction direction)
+void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sglist,
+			 int nelems, enum dma_data_direction direction)
 {
+	struct scatterlist *sg;
+	int i;
+
 	BUG_ON(!valid_dma_direction(direction));
-	WARN_ON(nelems == 0 || sg[0].length == 0);
+	WARN_ON(nelems == 0 || sglist->length == 0);
+
+	for_each_sg(sglist, sg, nelems, i) {
+		dma_sync_single_for_cpu(dev, sg->dma_address,
+					sg_dma_len(sg), direction);
+	}
 }
 EXPORT_SYMBOL(dma_sync_sg_for_cpu);
 
-/*
- * Flush and invalidate cache for scatterlist.
- */
 void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
 			    int nelems, enum dma_data_direction direction)
 {
@@ -242,8 +346,8 @@ void dma_sync_single_range_for_device(struct device *dev,
 EXPORT_SYMBOL(dma_sync_single_range_for_device);
 
 /*
- * dma_alloc_noncoherent() returns non-cacheable memory, so there's no
- * need to do any flushing here.
+ * dma_alloc_noncoherent() is #defined to return coherent memory,
+ * so there's no need to do any flushing here.
  */
 void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		    enum dma_data_direction direction)
diff --git a/arch/tile/mm/homecache.c b/arch/tile/mm/homecache.c
index dbcbdf7..5f7868d 100644
--- a/arch/tile/mm/homecache.c
+++ b/arch/tile/mm/homecache.c
@@ -64,10 +64,6 @@ early_param("noallocl2", set_noallocl2);
 
 #endif
 
-/* Provide no-op versions of these routines to keep flush_remote() cleaner. */
-#define mark_caches_evicted_start() 0
-#define mark_caches_evicted_finish(mask, timestamp) do {} while (0)
-
 
 /*
  * Update the irq_stat for cpus that we are going to interrupt
@@ -107,7 +103,6 @@ static void hv_flush_update(const struct cpumask *cache_cpumask,
  *    there's never any good reason for hv_flush_remote() to fail.
  *  - Accepts a 32-bit PFN rather than a 64-bit PA, which generally
  *    is the type that Linux wants to pass around anyway.
- *  - Centralizes the mark_caches_evicted() handling.
  *  - Canonicalizes that lengths of zero make cpumasks NULL.
  *  - Handles deferring TLB flushes for dataplane tiles.
  *  - Tracks remote interrupts in the per-cpu irq_cpustat_t.
@@ -126,7 +121,6 @@ void flush_remote(unsigned long cache_pfn, unsigned long cache_control,
 		  HV_Remote_ASID *asids, int asidcount)
 {
 	int rc;
-	int timestamp = 0;  /* happy compiler */
 	struct cpumask cache_cpumask_copy, tlb_cpumask_copy;
 	struct cpumask *cache_cpumask, *tlb_cpumask;
 	HV_PhysAddr cache_pa;
@@ -157,15 +151,11 @@ void flush_remote(unsigned long cache_pfn, unsigned long cache_control,
 	hv_flush_update(cache_cpumask, tlb_cpumask, tlb_va, tlb_length,
 			asids, asidcount);
 	cache_pa = (HV_PhysAddr)cache_pfn << PAGE_SHIFT;
-	if (cache_control & HV_FLUSH_EVICT_L2)
-		timestamp = mark_caches_evicted_start();
 	rc = hv_flush_remote(cache_pa, cache_control,
 			     cpumask_bits(cache_cpumask),
 			     tlb_va, tlb_length, tlb_pgsize,
 			     cpumask_bits(tlb_cpumask),
 			     asids, asidcount);
-	if (cache_control & HV_FLUSH_EVICT_L2)
-		mark_caches_evicted_finish(cache_cpumask, timestamp);
 	if (rc == 0)
 		return;
 	cpumask_scnprintf(cache_buf, sizeof(cache_buf), &cache_cpumask_copy);
@@ -180,85 +170,86 @@ void flush_remote(unsigned long cache_pfn, unsigned long cache_control,
 	panic("Unsafe to continue.");
 }
 
-void flush_remote_page(struct page *page, int order)
+static void homecache_finv_page_va(void* va, int home)
 {
-	int i, pages = (1 << order);
-	for (i = 0; i < pages; ++i, ++page) {
-		void *p = kmap_atomic(page);
-		int hfh = 0;
-		int home = page_home(page);
-#if CHIP_HAS_CBOX_HOME_MAP()
-		if (home == PAGE_HOME_HASH)
-			hfh = 1;
-		else
-#endif
-			BUG_ON(home < 0 || home >= NR_CPUS);
-		finv_buffer_remote(p, PAGE_SIZE, hfh);
-		kunmap_atomic(p);
+	if (home == smp_processor_id()) {
+		finv_buffer_local(va, PAGE_SIZE);
+	} else if (home == PAGE_HOME_HASH) {
+		finv_buffer_remote(va, PAGE_SIZE, 1);
+	} else {
+		BUG_ON(home < 0 || home >= NR_CPUS);
+		finv_buffer_remote(va, PAGE_SIZE, 0);
 	}
 }
 
-void homecache_evict(const struct cpumask *mask)
+void homecache_finv_map_page(struct page *page, int home)
 {
-	flush_remote(0, HV_FLUSH_EVICT_L2, mask, 0, 0, 0, NULL, NULL, 0);
+	unsigned long flags;
+	unsigned long va;
+	pte_t *ptep;
+	pte_t pte;
+
+	if (home == PAGE_HOME_UNCACHED)
+		return;
+	local_irq_save(flags);
+#ifdef CONFIG_HIGHMEM
+	va = __fix_to_virt(FIX_KMAP_BEGIN + kmap_atomic_idx_push() +
+			   (KM_TYPE_NR * smp_processor_id()));
+#else
+	va = __fix_to_virt(FIX_HOMECACHE_BEGIN + smp_processor_id());
+#endif
+	ptep = virt_to_pte(NULL, (unsigned long)va);
+	pte = pfn_pte(page_to_pfn(page), PAGE_KERNEL);
+	__set_pte(ptep, pte_set_home(pte, home));
+	homecache_finv_page_va((void *)va, home);
+	__pte_clear(ptep);
+	hv_flush_page(va, PAGE_SIZE);
+#ifdef CONFIG_HIGHMEM
+	kmap_atomic_idx_pop();
+#endif
+	local_irq_restore(flags);
 }
 
-/*
- * Return a mask of the cpus whose caches currently own these pages.
- * The return value is whether the pages are all coherently cached
- * (i.e. none are immutable, incoherent, or uncached).
- */
-static int homecache_mask(struct page *page, int pages,
-			  struct cpumask *home_mask)
+static void homecache_finv_page_home(struct page *page, int home)
 {
-	int i;
-	int cached_coherently = 1;
-	cpumask_clear(home_mask);
-	for (i = 0; i < pages; ++i) {
-		int home = page_home(&page[i]);
-		if (home == PAGE_HOME_IMMUTABLE ||
-		    home == PAGE_HOME_INCOHERENT) {
-			cpumask_copy(home_mask, cpu_possible_mask);
-			return 0;
-		}
-#if CHIP_HAS_CBOX_HOME_MAP()
-		if (home == PAGE_HOME_HASH) {
-			cpumask_or(home_mask, home_mask, &hash_for_home_map);
-			continue;
-		}
-#endif
-		if (home == PAGE_HOME_UNCACHED) {
-			cached_coherently = 0;
-			continue;
-		}
-		BUG_ON(home < 0 || home >= NR_CPUS);
-		cpumask_set_cpu(home, home_mask);
-	}
-	return cached_coherently;
+	if (!PageHighMem(page) && home == page_home(page))
+		homecache_finv_page_va(page_address(page), home);
+	else
+		homecache_finv_map_page(page, home);
 }
 
-/*
- * Return the passed length, or zero if it's long enough that we
- * believe we should evict the whole L2 cache.
- */
-static unsigned long cache_flush_length(unsigned long length)
+static inline bool incoherent_home(int home)
 {
-	return (length >= CHIP_L2_CACHE_SIZE()) ? HV_FLUSH_EVICT_L2 : length;
+	return home == PAGE_HOME_IMMUTABLE || home == PAGE_HOME_INCOHERENT;
 }
 
-/* Flush a page out of whatever cache(s) it is in. */
-void homecache_flush_cache(struct page *page, int order)
+static void homecache_finv_page_internal(struct page *page, int force_map)
 {
-	int pages = 1 << order;
-	int length = cache_flush_length(pages * PAGE_SIZE);
-	unsigned long pfn = page_to_pfn(page);
-	struct cpumask home_mask;
-
-	homecache_mask(page, pages, &home_mask);
-	flush_remote(pfn, length, &home_mask, 0, 0, 0, NULL, NULL, 0);
-	sim_validate_lines_evicted(PFN_PHYS(pfn), pages * PAGE_SIZE);
+	int home = page_home(page);
+	if (home == PAGE_HOME_UNCACHED)
+		return;
+	if (incoherent_home(home)) {
+		int cpu;
+		for_each_cpu(cpu, &cpu_cacheable_map)
+			homecache_finv_map_page(page, cpu);
+	} else if (force_map) {
+		/* Force if, e.g., the normal mapping is migrating. */
+		homecache_finv_map_page(page, home);
+	} else {
+		homecache_finv_page_home(page, home);
+	}
+	sim_validate_lines_evicted(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
 }
 
+void homecache_finv_page(struct page *page)
+{
+	homecache_finv_page_internal(page, 0);
+}
+
+void homecache_evict(const struct cpumask *mask)
+{
+	flush_remote(0, HV_FLUSH_EVICT_L2, mask, 0, 0, 0, NULL, NULL, 0);
+}
 
 /* Report the home corresponding to a given PTE. */
 static int pte_to_home(pte_t pte)
@@ -441,15 +432,8 @@ struct page *homecache_alloc_pages_node(int nid, gfp_t gfp_mask,
 	return page;
 }
 
-void homecache_free_pages(unsigned long addr, unsigned int order)
+void __homecache_free_pages(struct page *page, unsigned int order)
 {
-	struct page *page;
-
-	if (addr == 0)
-		return;
-
-	VM_BUG_ON(!virt_addr_valid((void *)addr));
-	page = virt_to_page((void *)addr);
 	if (put_page_testzero(page)) {
 		homecache_change_page_home(page, order, initial_page_home());
 		if (order == 0) {
@@ -460,3 +444,13 @@ void homecache_free_pages(unsigned long addr, unsigned int order)
 		}
 	}
 }
+EXPORT_SYMBOL(__homecache_free_pages);
+
+void homecache_free_pages(unsigned long addr, unsigned int order)
+{
+	if (addr != 0) {
+		VM_BUG_ON(!virt_addr_valid((void *)addr));
+		__homecache_free_pages(virt_to_page((void *)addr), order);
+	}
+}
+EXPORT_SYMBOL(homecache_free_pages);
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 630dd2c..a2417a0 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -150,7 +150,21 @@ void __init shatter_pmd(pmd_t *pmd)
 	assign_pte(pmd, pte);
 }
 
-#ifdef CONFIG_HIGHMEM
+#ifdef __tilegx__
+static pmd_t *__init get_pmd(pgd_t pgtables[], unsigned long va)
+{
+	pud_t *pud = pud_offset(&pgtables[pgd_index(va)], va);
+	if (pud_none(*pud))
+		assign_pmd(pud, alloc_pmd());
+	return pmd_offset(pud, va);
+}
+#else
+static pmd_t *__init get_pmd(pgd_t pgtables[], unsigned long va)
+{
+	return pmd_offset(pud_offset(&pgtables[pgd_index(va)], va), va);
+}
+#endif
+
 /*
  * This function initializes a certain range of kernel virtual memory
  * with new bootmem page tables, everywhere page tables are missing in
@@ -163,24 +177,17 @@ void __init shatter_pmd(pmd_t *pmd)
  * checking the pgd every time.
  */
 static void __init page_table_range_init(unsigned long start,
-					 unsigned long end, pgd_t *pgd_base)
+					 unsigned long end, pgd_t *pgd)
 {
-	pgd_t *pgd;
-	int pgd_idx;
 	unsigned long vaddr;
-
-	vaddr = start;
-	pgd_idx = pgd_index(vaddr);
-	pgd = pgd_base + pgd_idx;
-
-	for ( ; (pgd_idx < PTRS_PER_PGD) && (vaddr != end); pgd++, pgd_idx++) {
-		pmd_t *pmd = pmd_offset(pud_offset(pgd, vaddr), vaddr);
+	start = round_down(start, PMD_SIZE);
+	end = round_up(end, PMD_SIZE);
+	for (vaddr = start; vaddr < end; vaddr += PMD_SIZE) {
+		pmd_t *pmd = get_pmd(pgd, vaddr);
 		if (pmd_none(*pmd))
 			assign_pte(pmd, alloc_pte());
-		vaddr += PMD_SIZE;
 	}
 }
-#endif /* CONFIG_HIGHMEM */
 
 
 #if CHIP_HAS_CBOX_HOME_MAP()
@@ -404,21 +411,6 @@ static inline pgprot_t ktext_set_nocache(pgprot_t prot)
 	return prot;
 }
 
-#ifndef __tilegx__
-static pmd_t *__init get_pmd(pgd_t pgtables[], unsigned long va)
-{
-	return pmd_offset(pud_offset(&pgtables[pgd_index(va)], va), va);
-}
-#else
-static pmd_t *__init get_pmd(pgd_t pgtables[], unsigned long va)
-{
-	pud_t *pud = pud_offset(&pgtables[pgd_index(va)], va);
-	if (pud_none(*pud))
-		assign_pmd(pud, alloc_pmd());
-	return pmd_offset(pud, va);
-}
-#endif
-
 /* Temporary page table we use for staging. */
 static pgd_t pgtables[PTRS_PER_PGD]
  __attribute__((aligned(HV_PAGE_TABLE_ALIGN)));
@@ -779,9 +771,6 @@ static void __init set_non_bootmem_pages_init(void)
  */
 void __init paging_init(void)
 {
-#ifdef CONFIG_HIGHMEM
-	unsigned long vaddr, end;
-#endif
 #ifdef __tilegx__
 	pud_t *pud;
 #endif
@@ -789,14 +778,14 @@ void __init paging_init(void)
 
 	kernel_physical_mapping_init(pgd_base);
 
-#ifdef CONFIG_HIGHMEM
 	/*
 	 * Fixed mappings, only the page table structure has to be
 	 * created - mappings will be set by set_fixmap():
 	 */
-	vaddr = __fix_to_virt(__end_of_fixed_addresses - 1) & PMD_MASK;
-	end = (FIXADDR_TOP + PMD_SIZE - 1) & PMD_MASK;
-	page_table_range_init(vaddr, end, pgd_base);
+	page_table_range_init(fix_to_virt(__end_of_fixed_addresses - 1),
+			      FIXADDR_TOP, pgd_base);
+
+#ifdef CONFIG_HIGHMEM
 	permanent_kmaps_init(pgd_base);
 #endif
 
-- 
1.7.10.3

