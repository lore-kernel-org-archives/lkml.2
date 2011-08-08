Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab1HHMci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 08:32:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37582 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1HHMcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 08:32:36 -0400
Date: Mon, 8 Aug 2011 14:32:30 +0200
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@redhat.com
Subject: [PATCH UPDATED 22/23] memblock: Kill early_node_map[]
Message-ID: <20110808123230.GM23937@htj.dyndns.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
 <1311694534-5161-23-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311694534-5161-23-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now all ARCH_POPULATES_NODE_MAP archs select HAVE_MEBLOCK_NODE_MAP -
there's no user of early_node_map[] left.  Kill early_node_map[] and
replace ARCH_POPULATES_NODE_MAP with HAVE_MEMBLOCK_NODE_MAP.  Also,
relocate for_each_mem_pfn_range() and helper from mm.h to memblock.h
as page_alloc.c would no longer host an alternative implementation.

This change is ultimately one to one mapping and shouldn't cause any
observable difference; however, after the recent changes, there are
some functions which now would fit memblock.c better than page_alloc.c
and dependency on HAVE_MEMBLOCK_NODE_MAP instead of HAVE_MEMBLOCK
doesn't make much sense on some of them.  Further cleanups for
functions inside HAVE_MEMBLOCK_NODE_MAP in mm.h would be nice.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
Trivial conflict resolution from the earlier sparc Kconfig change.
git tree is also updated.

Thanks.

 arch/ia64/Kconfig         |    3 
 arch/mips/Kconfig         |    3 
 arch/powerpc/Kconfig      |    3 
 arch/s390/Kconfig         |    3 
 arch/score/Kconfig        |    3 
 arch/sh/mm/Kconfig        |    3 
 arch/sparc/Kconfig        |    3 
 arch/x86/Kconfig          |    3 
 drivers/pci/intel-iommu.c |    1 
 include/linux/memblock.h  |   23 +++-
 include/linux/mm.h        |   50 +-------
 include/linux/mmzone.h    |    8 -
 mm/memblock.c             |    2 
 mm/page_alloc.c           |  259 +++-------------------------------------------
 14 files changed, 55 insertions(+), 312 deletions(-)

Index: work/include/linux/memblock.h
===================================================================
--- work.orig/include/linux/memblock.h
+++ work/include/linux/memblock.h
@@ -58,6 +58,26 @@ int memblock_remove(phys_addr_t base, ph
 int memblock_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
 
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
+			  unsigned long *out_end_pfn, int *out_nid);
+
+/**
+ * for_each_mem_pfn_range - early memory pfn range iterator
+ * @i: an integer used as loop variable
+ * @nid: node selector, %MAX_NUMNODES for all nodes
+ * @p_start: ptr to ulong for start pfn of the range, can be %NULL
+ * @p_end: ptr to ulong for end pfn of the range, can be %NULL
+ * @p_nid: ptr to int for nid of the range, can be %NULL
+ *
+ * Walks over configured memory ranges.  Available after early_node_map is
+ * populated.
+ */
+#define for_each_mem_pfn_range(i, nid, p_start, p_end, p_nid)		\
+	for (i = -1, __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid); \
+	     i >= 0; __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid))
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+
 void __next_free_mem_range(u64 *idx, int nid, phys_addr_t *out_start,
 			   phys_addr_t *out_end, int *out_nid);
 
@@ -101,9 +121,6 @@ static inline int memblock_get_region_no
 }
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
-/* The numa aware allocator is only available if
- * CONFIG_ARCH_POPULATES_NODE_MAP is set
- */
 phys_addr_t memblock_find_in_range_node(phys_addr_t start, phys_addr_t end,
 				phys_addr_t size, phys_addr_t align, int nid);
 phys_addr_t memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid);
Index: work/include/linux/mm.h
===================================================================
--- work.orig/include/linux/mm.h
+++ work/include/linux/mm.h
@@ -1278,43 +1278,34 @@ static inline void pgtable_page_dtor(str
 extern void free_area_init(unsigned long * zones_size);
 extern void free_area_init_node(int nid, unsigned long * zones_size,
 		unsigned long zone_start_pfn, unsigned long *zholes_size);
-#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 /*
- * With CONFIG_ARCH_POPULATES_NODE_MAP set, an architecture may initialise its
+ * With CONFIG_HAVE_MEMBLOCK_NODE_MAP set, an architecture may initialise its
  * zones, allocate the backing mem_map and account for memory holes in a more
  * architecture independent manner. This is a substitute for creating the
  * zone_sizes[] and zholes_size[] arrays and passing them to
  * free_area_init_node()
  *
  * An architecture is expected to register range of page frames backed by
- * physical memory with add_active_range() before calling
+ * physical memory with memblock_add[_node]() before calling
  * free_area_init_nodes() passing in the PFN each zone ends at. At a basic
  * usage, an architecture is expected to do something like
  *
  * unsigned long max_zone_pfns[MAX_NR_ZONES] = {max_dma, max_normal_pfn,
  * 							 max_highmem_pfn};
  * for_each_valid_physical_page_range()
- * 	add_active_range(node_id, start_pfn, end_pfn)
+ * 	memblock_add_node(base, size, nid)
  * free_area_init_nodes(max_zone_pfns);
  *
- * If the architecture guarantees that there are no holes in the ranges
- * registered with add_active_range(), free_bootmem_active_regions()
- * will call free_bootmem_node() for each registered physical page range.
- * Similarly sparse_memory_present_with_active_regions() calls
- * memory_present() for each range when SPARSEMEM is enabled.
+ * free_bootmem_with_active_regions() calls free_bootmem_node() for each
+ * registered physical page range.  Similarly
+ * sparse_memory_present_with_active_regions() calls memory_present() for
+ * each range when SPARSEMEM is enabled.
  *
  * See mm/page_alloc.c for more information on each function exposed by
- * CONFIG_ARCH_POPULATES_NODE_MAP
+ * CONFIG_HAVE_MEMBLOCK_NODE_MAP.
  */
 extern void free_area_init_nodes(unsigned long *max_zone_pfn);
-#ifndef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-extern void add_active_range(unsigned int nid, unsigned long start_pfn,
-					unsigned long end_pfn);
-extern void remove_active_range(unsigned int nid, unsigned long start_pfn,
-					unsigned long end_pfn);
-extern void remove_all_active_ranges(void);
-void sort_node_map(void);
-#endif
 unsigned long node_map_pfn_alignment(void);
 unsigned long __absent_pages_in_range(int nid, unsigned long start_pfn,
 						unsigned long end_pfn);
@@ -1329,28 +1320,9 @@ int add_from_early_node_map(struct range
 				   int nr_range, int nid);
 extern void sparse_memory_present_with_active_regions(int nid);
 
-extern void __next_mem_pfn_range(int *idx, int nid,
-				 unsigned long *out_start_pfn,
-				 unsigned long *out_end_pfn, int *out_nid);
-
-/**
- * for_each_mem_pfn_range - early memory pfn range iterator
- * @i: an integer used as loop variable
- * @nid: node selector, %MAX_NUMNODES for all nodes
- * @p_start: ptr to ulong for start pfn of the range, can be %NULL
- * @p_end: ptr to ulong for end pfn of the range, can be %NULL
- * @p_nid: ptr to int for nid of the range, can be %NULL
- *
- * Walks over configured memory ranges.  Available after early_node_map is
- * populated.
- */
-#define for_each_mem_pfn_range(i, nid, p_start, p_end, p_nid)		\
-	for (i = -1, __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid); \
-	     i >= 0; __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid))
-
-#endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
-#if !defined(CONFIG_ARCH_POPULATES_NODE_MAP) && \
+#if !defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) && \
     !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID)
 static inline int __early_pfn_to_nid(unsigned long pfn)
 {
Index: work/include/linux/mmzone.h
===================================================================
--- work.orig/include/linux/mmzone.h
+++ work/include/linux/mmzone.h
@@ -579,13 +579,13 @@ struct zonelist {
 #endif
 };
 
-#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+#ifdef CONFIG_MEMBLOCK_HAVE_NODE_MAP
 struct node_active_region {
 	unsigned long start_pfn;
 	unsigned long end_pfn;
 	int nid;
 };
-#endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
+#endif /* CONFIG_MEMBLOCK_HAVE_NODE_MAP */
 
 #ifndef CONFIG_DISCONTIGMEM
 /* The array of struct pages - for discontigmem use pgdat->lmem_map */
@@ -701,7 +701,7 @@ extern int movable_zone;
 
 static inline int zone_movable_is_highmem(void)
 {
-#if defined(CONFIG_HIGHMEM) && defined(CONFIG_ARCH_POPULATES_NODE_MAP)
+#if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE)
 	return movable_zone == ZONE_HIGHMEM;
 #else
 	return 0;
@@ -919,7 +919,7 @@ static inline struct zoneref *first_zone
 #endif
 
 #if !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID) && \
-	!defined(CONFIG_ARCH_POPULATES_NODE_MAP)
+	!defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
 static inline unsigned long early_pfn_to_nid(unsigned long pfn)
 {
 	return 0;
Index: work/mm/page_alloc.c
===================================================================
--- work.orig/mm/page_alloc.c
+++ work/mm/page_alloc.c
@@ -181,42 +181,17 @@ static unsigned long __meminitdata nr_ke
 static unsigned long __meminitdata nr_all_pages;
 static unsigned long __meminitdata dma_reserve;
 
-#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
-  #ifndef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-    /*
-     * MAX_ACTIVE_REGIONS determines the maximum number of distinct ranges
-     * of memory (RAM) that may be registered with add_active_range().
-     * Ranges passed to add_active_range() will be merged if possible so
-     * the number of times add_active_range() can be called is related to
-     * the number of nodes and the number of holes
-     */
-    #ifdef CONFIG_MAX_ACTIVE_REGIONS
-      /* Allow an architecture to set MAX_ACTIVE_REGIONS to save memory */
-      #define MAX_ACTIVE_REGIONS CONFIG_MAX_ACTIVE_REGIONS
-    #else
-      #if MAX_NUMNODES >= 32
-        /* If there can be many nodes, allow up to 50 holes per node */
-        #define MAX_ACTIVE_REGIONS (MAX_NUMNODES*50)
-      #else
-        /* By default, allow up to 256 distinct regions */
-        #define MAX_ACTIVE_REGIONS 256
-      #endif
-    #endif
-
-    static struct node_active_region __meminitdata early_node_map[MAX_ACTIVE_REGIONS];
-    static int __meminitdata nr_nodemap_entries;
-#endif /* !CONFIG_HAVE_MEMBLOCK_NODE_MAP */
-
-  static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
-  static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
-  static unsigned long __initdata required_kernelcore;
-  static unsigned long __initdata required_movablecore;
-  static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
-
-  /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
-  int movable_zone;
-  EXPORT_SYMBOL(movable_zone);
-#endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
+static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
+static unsigned long __initdata required_kernelcore;
+static unsigned long __initdata required_movablecore;
+static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
+
+/* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
+int movable_zone;
+EXPORT_SYMBOL(movable_zone);
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 #if MAX_NUMNODES > 1
 int nr_node_ids __read_mostly = MAX_NUMNODES;
@@ -3713,7 +3688,7 @@ __meminit int init_currently_empty_zone(
 	return 0;
 }
 
-#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 /*
  * Required by SPARSEMEM. Given a PFN, return what node the PFN is on.
@@ -3981,7 +3956,7 @@ static unsigned long __meminit zone_abse
 	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
 }
 
-#else
+#else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
 					unsigned long *zones_size)
@@ -3999,7 +3974,7 @@ static inline unsigned long __meminit zo
 	return zholes_size[zone_type];
 }
 
-#endif
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 static void __meminit calculate_node_totalpages(struct pglist_data *pgdat,
 		unsigned long *zones_size, unsigned long *zholes_size)
@@ -4222,10 +4197,10 @@ static void __init_refok alloc_node_mem_
 	 */
 	if (pgdat == NODE_DATA(0)) {
 		mem_map = NODE_DATA(0)->node_mem_map;
-#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 		if (page_to_pfn(mem_map) != pgdat->node_start_pfn)
 			mem_map -= (pgdat->node_start_pfn - ARCH_PFN_OFFSET);
-#endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 	}
 #endif
 #endif /* CONFIG_FLAT_NODE_MEM_MAP */
@@ -4250,7 +4225,7 @@ void __paginginit free_area_init_node(in
 	free_area_init_core(pgdat, zones_size, zholes_size);
 }
 
-#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 
 #if MAX_NUMNODES > 1
 /*
@@ -4271,201 +4246,6 @@ static inline void setup_nr_node_ids(voi
 }
 #endif
 
-#ifndef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-/*
- * Common iterator interface used to define for_each_mem_pfn_range().
- */
-void __meminit __next_mem_pfn_range(int *idx, int nid,
-				    unsigned long *out_start_pfn,
-				    unsigned long *out_end_pfn, int *out_nid)
-{
-	struct node_active_region *r = NULL;
-
-	while (++*idx < nr_nodemap_entries) {
-		if (nid == MAX_NUMNODES || nid == early_node_map[*idx].nid) {
-			r = &early_node_map[*idx];
-			break;
-		}
-	}
-	if (!r) {
-		*idx = -1;
-		return;
-	}
-
-	if (out_start_pfn)
-		*out_start_pfn = r->start_pfn;
-	if (out_end_pfn)
-		*out_end_pfn = r->end_pfn;
-	if (out_nid)
-		*out_nid = r->nid;
-}
-
-/**
- * add_active_range - Register a range of PFNs backed by physical memory
- * @nid: The node ID the range resides on
- * @start_pfn: The start PFN of the available physical memory
- * @end_pfn: The end PFN of the available physical memory
- *
- * These ranges are stored in an early_node_map[] and later used by
- * free_area_init_nodes() to calculate zone sizes and holes. If the
- * range spans a memory hole, it is up to the architecture to ensure
- * the memory is not freed by the bootmem allocator. If possible
- * the range being registered will be merged with existing ranges.
- */
-void __init add_active_range(unsigned int nid, unsigned long start_pfn,
-						unsigned long end_pfn)
-{
-	int i;
-
-	mminit_dprintk(MMINIT_TRACE, "memory_register",
-			"Entering add_active_range(%d, %#lx, %#lx) "
-			"%d entries of %d used\n",
-			nid, start_pfn, end_pfn,
-			nr_nodemap_entries, MAX_ACTIVE_REGIONS);
-
-	mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
-
-	/* Merge with existing active regions if possible */
-	for (i = 0; i < nr_nodemap_entries; i++) {
-		if (early_node_map[i].nid != nid)
-			continue;
-
-		/* Skip if an existing region covers this new one */
-		if (start_pfn >= early_node_map[i].start_pfn &&
-				end_pfn <= early_node_map[i].end_pfn)
-			return;
-
-		/* Merge forward if suitable */
-		if (start_pfn <= early_node_map[i].end_pfn &&
-				end_pfn > early_node_map[i].end_pfn) {
-			early_node_map[i].end_pfn = end_pfn;
-			return;
-		}
-
-		/* Merge backward if suitable */
-		if (start_pfn < early_node_map[i].start_pfn &&
-				end_pfn >= early_node_map[i].start_pfn) {
-			early_node_map[i].start_pfn = start_pfn;
-			return;
-		}
-	}
-
-	/* Check that early_node_map is large enough */
-	if (i >= MAX_ACTIVE_REGIONS) {
-		printk(KERN_CRIT "More than %d memory regions, truncating\n",
-							MAX_ACTIVE_REGIONS);
-		return;
-	}
-
-	early_node_map[i].nid = nid;
-	early_node_map[i].start_pfn = start_pfn;
-	early_node_map[i].end_pfn = end_pfn;
-	nr_nodemap_entries = i + 1;
-}
-
-/**
- * remove_active_range - Shrink an existing registered range of PFNs
- * @nid: The node id the range is on that should be shrunk
- * @start_pfn: The new PFN of the range
- * @end_pfn: The new PFN of the range
- *
- * i386 with NUMA use alloc_remap() to store a node_mem_map on a local node.
- * The map is kept near the end physical page range that has already been
- * registered. This function allows an arch to shrink an existing registered
- * range.
- */
-void __init remove_active_range(unsigned int nid, unsigned long start_pfn,
-				unsigned long end_pfn)
-{
-	unsigned long this_start_pfn, this_end_pfn;
-	int i, j;
-	int removed = 0;
-
-	printk(KERN_DEBUG "remove_active_range (%d, %lu, %lu)\n",
-			  nid, start_pfn, end_pfn);
-
-	/* Find the old active region end and shrink */
-	for_each_mem_pfn_range(i, nid, &this_start_pfn, &this_end_pfn, NULL) {
-		if (this_start_pfn >= start_pfn && this_end_pfn <= end_pfn) {
-			/* clear it */
-			early_node_map[i].start_pfn = 0;
-			early_node_map[i].end_pfn = 0;
-			removed = 1;
-			continue;
-		}
-		if (this_start_pfn < start_pfn && this_end_pfn > start_pfn) {
-			early_node_map[i].end_pfn = start_pfn;
-			if (this_end_pfn > end_pfn)
-				add_active_range(nid, end_pfn, this_end_pfn);
-			continue;
-		}
-		if (this_start_pfn >= start_pfn && this_end_pfn > end_pfn &&
-		    this_start_pfn < end_pfn) {
-			early_node_map[i].start_pfn = end_pfn;
-			continue;
-		}
-	}
-
-	if (!removed)
-		return;
-
-	/* remove the blank ones */
-	for (i = nr_nodemap_entries - 1; i > 0; i--) {
-		if (early_node_map[i].nid != nid)
-			continue;
-		if (early_node_map[i].end_pfn)
-			continue;
-		/* we found it, get rid of it */
-		for (j = i; j < nr_nodemap_entries - 1; j++)
-			memcpy(&early_node_map[j], &early_node_map[j+1],
-				sizeof(early_node_map[j]));
-		j = nr_nodemap_entries - 1;
-		memset(&early_node_map[j], 0, sizeof(early_node_map[j]));
-		nr_nodemap_entries--;
-	}
-}
-
-/**
- * remove_all_active_ranges - Remove all currently registered regions
- *
- * During discovery, it may be found that a table like SRAT is invalid
- * and an alternative discovery method must be used. This function removes
- * all currently registered regions.
- */
-void __init remove_all_active_ranges(void)
-{
-	memset(early_node_map, 0, sizeof(early_node_map));
-	nr_nodemap_entries = 0;
-}
-
-/* Compare two active node_active_regions */
-static int __init cmp_node_active_region(const void *a, const void *b)
-{
-	struct node_active_region *arange = (struct node_active_region *)a;
-	struct node_active_region *brange = (struct node_active_region *)b;
-
-	/* Done this way to avoid overflows */
-	if (arange->start_pfn > brange->start_pfn)
-		return 1;
-	if (arange->start_pfn < brange->start_pfn)
-		return -1;
-
-	return 0;
-}
-
-/* sort the node_map by start_pfn */
-void __init sort_node_map(void)
-{
-	sort(early_node_map, (size_t)nr_nodemap_entries,
-			sizeof(struct node_active_region),
-			cmp_node_active_region, NULL);
-}
-#else /* !CONFIG_HAVE_MEMBLOCK_NODE_MAP */
-static inline void sort_node_map(void)
-{
-}
-#endif
-
 /**
  * node_map_pfn_alignment - determine the maximum internode alignment
  *
@@ -4743,9 +4523,6 @@ void __init free_area_init_nodes(unsigne
 	unsigned long start_pfn, end_pfn;
 	int i, nid;
 
-	/* Sort early_node_map as initialisation assumes it is sorted */
-	sort_node_map();
-
 	/* Record where the zone boundaries are */
 	memset(arch_zone_lowest_possible_pfn, 0,
 				sizeof(arch_zone_lowest_possible_pfn));
@@ -4846,7 +4623,7 @@ static int __init cmdline_parse_movablec
 early_param("kernelcore", cmdline_parse_kernelcore);
 early_param("movablecore", cmdline_parse_movablecore);
 
-#endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 /**
  * set_dma_reserve - set the specified number of pages reserved in the first zone
Index: work/arch/ia64/Kconfig
===================================================================
--- work.orig/arch/ia64/Kconfig
+++ work/arch/ia64/Kconfig
@@ -470,9 +470,6 @@ config NODES_SHIFT
 	  MAX_NUMNODES will be 2^(This value).
 	  If in doubt, use the default.
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 # VIRTUAL_MEM_MAP and FLAT_NODE_MEM_MAP are functionally equivalent.
 # VIRTUAL_MEM_MAP has been retained for historical reasons.
 config VIRTUAL_MEM_MAP
Index: work/arch/mips/Kconfig
===================================================================
--- work.orig/arch/mips/Kconfig
+++ work/arch/mips/Kconfig
@@ -2065,9 +2065,6 @@ config ARCH_DISCONTIGMEM_ENABLE
 	  or have huge holes in the physical address space for other reasons.
 	  See <file:Documentation/vm/numa> for more.
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 config ARCH_SPARSEMEM_ENABLE
 	bool
 	select SPARSEMEM_STATIC
Index: work/arch/powerpc/Kconfig
===================================================================
--- work.orig/arch/powerpc/Kconfig
+++ work/arch/powerpc/Kconfig
@@ -423,9 +423,6 @@ config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
 	depends on (SMP && PPC_PSERIES) || PPC_PS3
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 config SYS_SUPPORTS_HUGETLBFS
        def_bool y
        depends on PPC_BOOK3S_64
Index: work/arch/s390/Kconfig
===================================================================
--- work.orig/arch/s390/Kconfig
+++ work/arch/s390/Kconfig
@@ -346,9 +346,6 @@ config WARN_DYNAMIC_STACK
 
 	  Say N if you are unsure.
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 comment "Kernel preemption"
 
 source "kernel/Kconfig.preempt"
Index: work/arch/score/Kconfig
===================================================================
--- work.orig/arch/score/Kconfig
+++ work/arch/score/Kconfig
@@ -73,9 +73,6 @@ config 32BIT
 config ARCH_FLATMEM_ENABLE
 	def_bool y
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 source "mm/Kconfig"
 
 config MEMORY_START
Index: work/arch/sh/mm/Kconfig
===================================================================
--- work.orig/arch/sh/mm/Kconfig
+++ work/arch/sh/mm/Kconfig
@@ -143,9 +143,6 @@ config MAX_ACTIVE_REGIONS
 		       CPU_SUBTYPE_SH7785)
 	default "1"
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
 
Index: work/arch/sparc/Kconfig
===================================================================
--- work.orig/arch/sparc/Kconfig
+++ work/arch/sparc/Kconfig
@@ -354,9 +354,6 @@ config NODES_SPAN_OTHER_NODES
 	def_bool y
 	depends on NEED_MULTIPLE_NODES
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y if SPARC64
-
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y if SPARC64
 
Index: work/arch/x86/Kconfig
===================================================================
--- work.orig/arch/x86/Kconfig
+++ work/arch/x86/Kconfig
@@ -200,9 +200,6 @@ config ZONE_DMA32
 	bool
 	default X86_64
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 config AUDIT_ARCH
 	bool
 	default X86_64
Index: work/mm/memblock.c
===================================================================
--- work.orig/mm/memblock.c
+++ work/mm/memblock.c
@@ -716,7 +716,7 @@ phys_addr_t __init memblock_alloc(phys_a
 static phys_addr_t __init memblock_nid_range_rev(phys_addr_t start,
 						 phys_addr_t end, int *nid)
 {
-#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	unsigned long start_pfn, end_pfn;
 	int i;
 
Index: work/drivers/pci/intel-iommu.c
===================================================================
--- work.orig/drivers/pci/intel-iommu.c
+++ work/drivers/pci/intel-iommu.c
@@ -40,6 +40,7 @@
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 #include <linux/pci-ats.h>
+#include <linux/memblock.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 #include "pci.h"
