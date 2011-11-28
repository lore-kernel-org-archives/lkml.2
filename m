Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab1K1TdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:33:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57739 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab1K1TdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:18 -0500
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@redhat.com, jonas@southpole.se, lennox.wu@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 22/23] memblock: Kill early_node_map[]
Date: Mon, 28 Nov 2011 11:31:24 -0800
Message-Id: <1322508685-32532-23-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1322508685-32532-1-git-send-email-tj@kernel.org>
References: <1322508685-32532-1-git-send-email-tj@kernel.org>
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
 arch/ia64/Kconfig           |    3 -
 arch/mips/Kconfig           |    3 -
 arch/powerpc/Kconfig        |    3 -
 arch/s390/Kconfig           |    3 -
 arch/score/Kconfig          |    3 -
 arch/sh/mm/Kconfig          |    3 -
 arch/sparc/Kconfig          |    3 -
 arch/x86/Kconfig            |    3 -
 drivers/iommu/intel-iommu.c |    1 +
 include/linux/memblock.h    |   23 ++++-
 include/linux/mm.h          |   50 ++-------
 include/linux/mmzone.h      |    8 +-
 mm/memblock.c               |    2 +-
 mm/page_alloc.c             |  259 +++----------------------------------------
 14 files changed, 55 insertions(+), 312 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index e2c7de0..3b7a7c4 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -477,9 +477,6 @@ config NODES_SHIFT
 	  MAX_NUMNODES will be 2^(This value).
 	  If in doubt, use the default.
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 # VIRTUAL_MEM_MAP and FLAT_NODE_MEM_MAP are functionally equivalent.
 # VIRTUAL_MEM_MAP has been retained for historical reasons.
 config VIRTUAL_MEM_MAP
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index b789847..9c652eb 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2067,9 +2067,6 @@ config ARCH_DISCONTIGMEM_ENABLE
 	  or have huge holes in the physical address space for other reasons.
 	  See <file:Documentation/vm/numa> for more.
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 config ARCH_SPARSEMEM_ENABLE
 	bool
 	select SPARSEMEM_STATIC
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 8516477..ead0bc6 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -422,9 +422,6 @@ config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
 	depends on (SMP && PPC_PSERIES) || PPC_PS3
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 config SYS_SUPPORTS_HUGETLBFS
 	bool
 
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index e383caf..d48ede3 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -348,9 +348,6 @@ config WARN_DYNAMIC_STACK
 
 	  Say N if you are unsure.
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 comment "Kernel preemption"
 
 source "kernel/Kconfig.preempt"
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 5f8743b..1b4d02b 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -63,9 +63,6 @@ config 32BIT
 config ARCH_FLATMEM_ENABLE
 	def_bool y
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 source "mm/Kconfig"
 
 config MEMORY_START
diff --git a/arch/sh/mm/Kconfig b/arch/sh/mm/Kconfig
index c3e61b3..cb8f992 100644
--- a/arch/sh/mm/Kconfig
+++ b/arch/sh/mm/Kconfig
@@ -143,9 +143,6 @@ config MAX_ACTIVE_REGIONS
 		       CPU_SUBTYPE_SH7785)
 	default "1"
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 91a6d1e..70ae9d8 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -353,9 +353,6 @@ config NODES_SPAN_OTHER_NODES
 	def_bool y
 	depends on NEED_MULTIPLE_NODES
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y if SPARC64
-
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y if SPARC64
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5d1514c..9bab4a9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -206,9 +206,6 @@ config ZONE_DMA32
 	bool
 	default X86_64
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 config AUDIT_ARCH
 	bool
 	default X86_64
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index bcbd693..d1c1793 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -41,6 +41,7 @@
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 #include <linux/pci-ats.h>
+#include <linux/memblock.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index c7b68f4..cd7606b 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -58,6 +58,26 @@ int memblock_remove(phys_addr_t base, phys_addr_t size);
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
 
@@ -101,9 +121,6 @@ static inline int memblock_get_region_node(const struct memblock_region *r)
 }
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
-/* The numa aware allocator is only available if
- * CONFIG_ARCH_POPULATES_NODE_MAP is set
- */
 phys_addr_t memblock_find_in_range_node(phys_addr_t start, phys_addr_t end,
 					phys_addr_t size, phys_addr_t align, int nid);
 phys_addr_t memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6b365ae..c6f49be 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1252,43 +1252,34 @@ static inline void pgtable_page_dtor(struct page *page)
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
@@ -1303,28 +1294,9 @@ int add_from_early_node_map(struct range *range, int az,
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
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 188cb2f..6c10fa0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -598,13 +598,13 @@ struct zonelist {
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
@@ -720,7 +720,7 @@ extern int movable_zone;
 
 static inline int zone_movable_is_highmem(void)
 {
-#if defined(CONFIG_HIGHMEM) && defined(CONFIG_ARCH_POPULATES_NODE_MAP)
+#if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE)
 	return movable_zone == ZONE_HIGHMEM;
 #else
 	return 0;
@@ -938,7 +938,7 @@ static inline struct zoneref *first_zones_zonelist(struct zonelist *zonelist,
 #endif
 
 #if !defined(CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID) && \
-	!defined(CONFIG_ARCH_POPULATES_NODE_MAP)
+	!defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
 static inline unsigned long early_pfn_to_nid(unsigned long pfn)
 {
 	return 0;
diff --git a/mm/memblock.c b/mm/memblock.c
index ef4987b..1adbef0 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -716,7 +716,7 @@ phys_addr_t __init memblock_alloc(phys_addr_t size, phys_addr_t align)
 static phys_addr_t __init memblock_nid_range_rev(phys_addr_t start,
 						 phys_addr_t end, int *nid)
 {
-#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	unsigned long start_pfn, end_pfn;
 	int i;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6ce2733..63ff8da 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -181,42 +181,17 @@ static unsigned long __meminitdata nr_kernel_pages;
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
@@ -3734,7 +3709,7 @@ __meminit int init_currently_empty_zone(struct zone *zone,
 	return 0;
 }
 
-#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 /*
  * Required by SPARSEMEM. Given a PFN, return what node the PFN is on.
@@ -4002,7 +3977,7 @@ static unsigned long __meminit zone_absent_pages_in_node(int nid,
 	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
 }
 
-#else
+#else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
 					unsigned long *zones_size)
@@ -4020,7 +3995,7 @@ static inline unsigned long __meminit zone_absent_pages_in_node(int nid,
 	return zholes_size[zone_type];
 }
 
-#endif
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 static void __meminit calculate_node_totalpages(struct pglist_data *pgdat,
 		unsigned long *zones_size, unsigned long *zholes_size)
@@ -4243,10 +4218,10 @@ static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
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
@@ -4271,7 +4246,7 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 	free_area_init_core(pgdat, zones_size, zholes_size);
 }
 
-#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 
 #if MAX_NUMNODES > 1
 /*
@@ -4292,201 +4267,6 @@ static inline void setup_nr_node_ids(void)
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
@@ -4764,9 +4544,6 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
 	unsigned long start_pfn, end_pfn;
 	int i, nid;
 
-	/* Sort early_node_map as initialisation assumes it is sorted */
-	sort_node_map();
-
 	/* Record where the zone boundaries are */
 	memset(arch_zone_lowest_possible_pfn, 0,
 				sizeof(arch_zone_lowest_possible_pfn));
@@ -4867,7 +4644,7 @@ static int __init cmdline_parse_movablecore(char *p)
 early_param("kernelcore", cmdline_parse_kernelcore);
 early_param("movablecore", cmdline_parse_movablecore);
 
-#endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 /**
  * set_dma_reserve - set the specified number of pages reserved in the first zone
-- 
1.7.3.1

