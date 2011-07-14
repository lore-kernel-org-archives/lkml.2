Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab1GNJnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 05:43:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49219 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab1GNJns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 05:43:48 -0400
Date: Thu, 14 Jul 2011 11:43:42 +0200
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org
Subject: [PATCH UPDATED 03/13] memblock: Add optional region->nid
Message-ID: <20110714094342.GF3455@htj.dyndns.org>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
 <1310462166-31469-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310462166-31469-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 83103b92f3234ec830852bbc5c45911bd6cbdb20 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 14 Jul 2011 11:22:16 +0200

Add optional region->nid which can be enabled by arch using
CONFIG_HAVE_MEMBLOCK_NODE_MAP.  When enabled, memblock also carries
NUMA node information and replaces early_node_map[].

Newly added memblocks have MAX_NUMNODES as nid.  Arch can then call
memblock_set_node() to set node information.  memblock takes care of
merging and node affine allocations w.r.t. node information.

When MEMBLOCK_NODE_MAP is enabled, early_node_map[], related data
structures and functions to manipulate and iterate it are disabled.
memblock version of __next_mem_pfn_range() is provided such that
for_each_mem_pfn_range() behaves the same and its users don't have to
be updated.

-v2: Yinghai spotted section mismatch caused by missing
     __init_memblock in memblock_set_node().  Fixed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/memblock.h |   26 ++++++++
 include/linux/mm.h       |    2 +
 mm/Kconfig               |    3 +
 mm/memblock.c            |  142 ++++++++++++++++++++++++++++++++++++++++------
 mm/page_alloc.c          |   47 +++++++++------
 5 files changed, 183 insertions(+), 37 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 434b958..c36a55d 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -24,6 +24,9 @@
 struct memblock_region {
 	phys_addr_t base;
 	phys_addr_t size;
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+	int nid;
+#endif
 };
 
 struct memblock_type {
@@ -58,6 +61,29 @@ extern long memblock_remove(phys_addr_t base, phys_addr_t size);
 extern long memblock_free(phys_addr_t base, phys_addr_t size);
 extern long memblock_reserve(phys_addr_t base, phys_addr_t size);
 
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+extern int memblock_set_node(phys_addr_t base, phys_addr_t size, int nid);
+
+static inline void memblock_set_region_node(struct memblock_region *r, int nid)
+{
+	r->nid = nid;
+}
+
+static inline int memblock_get_region_node(const struct memblock_region *r)
+{
+	return r->nid;
+}
+#else
+static inline void memblock_set_region_node(struct memblock_region *r, int nid)
+{
+}
+
+static inline int memblock_get_region_node(const struct memblock_region *r)
+{
+	return 0;
+}
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+
 /* The numa aware allocator is only available if
  * CONFIG_ARCH_POPULATES_NODE_MAP is set
  */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9ebc65a..ceb1e4a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1307,12 +1307,14 @@ extern void free_area_init_node(int nid, unsigned long * zones_size,
  * CONFIG_ARCH_POPULATES_NODE_MAP
  */
 extern void free_area_init_nodes(unsigned long *max_zone_pfn);
+#ifndef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 extern void add_active_range(unsigned int nid, unsigned long start_pfn,
 					unsigned long end_pfn);
 extern void remove_active_range(unsigned int nid, unsigned long start_pfn,
 					unsigned long end_pfn);
 extern void remove_all_active_ranges(void);
 void sort_node_map(void);
+#endif
 unsigned long node_map_pfn_alignment(void);
 unsigned long __absent_pages_in_range(int nid, unsigned long start_pfn,
 						unsigned long end_pfn);
diff --git a/mm/Kconfig b/mm/Kconfig
index 8ca47a5..30a5d47 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -131,6 +131,9 @@ config SPARSEMEM_VMEMMAP
 config HAVE_MEMBLOCK
 	boolean
 
+config HAVE_MEMBLOCK_NODE_MAP
+	boolean
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
diff --git a/mm/memblock.c b/mm/memblock.c
index 992aa18..e815f4b 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -161,12 +161,8 @@ int __init_memblock memblock_reserve_reserved_regions(void)
 
 static void __init_memblock memblock_remove_region(struct memblock_type *type, unsigned long r)
 {
-	unsigned long i;
-
-	for (i = r; i < type->cnt - 1; i++) {
-		type->regions[i].base = type->regions[i + 1].base;
-		type->regions[i].size = type->regions[i + 1].size;
-	}
+	memmove(&type->regions[r], &type->regions[r + 1],
+		(type->cnt - (r + 1)) * sizeof(type->regions[r]));
 	type->cnt--;
 
 	/* Special case for empty arrays */
@@ -174,6 +170,7 @@ static void __init_memblock memblock_remove_region(struct memblock_type *type, u
 		type->cnt = 1;
 		type->regions[0].base = 0;
 		type->regions[0].size = 0;
+		memblock_set_region_node(&type->regions[0], MAX_NUMNODES);
 	}
 }
 
@@ -266,7 +263,9 @@ static void __init_memblock memblock_merge_regions(struct memblock_type *type)
 		struct memblock_region *this = &type->regions[i];
 		struct memblock_region *next = &type->regions[i + 1];
 
-		if (this->base + this->size != next->base) {
+		if (this->base + this->size != next->base ||
+		    memblock_get_region_node(this) !=
+		    memblock_get_region_node(next)) {
 			BUG_ON(this->base + this->size > next->base);
 			i++;
 			continue;
@@ -290,7 +289,7 @@ static void __init_memblock memblock_merge_regions(struct memblock_type *type)
  */
 static void __init_memblock memblock_insert_region(struct memblock_type *type,
 						   int idx, phys_addr_t base,
-						   phys_addr_t size)
+						   phys_addr_t size, int nid)
 {
 	struct memblock_region *rgn = &type->regions[idx];
 
@@ -298,6 +297,7 @@ static void __init_memblock memblock_insert_region(struct memblock_type *type,
 	memmove(rgn + 1, rgn, (type->cnt - idx) * sizeof(*rgn));
 	rgn->base = base;
 	rgn->size = size;
+	memblock_set_region_node(rgn, nid);
 	type->cnt++;
 }
 
@@ -327,6 +327,7 @@ static long __init_memblock memblock_add_region(struct memblock_type *type,
 		WARN_ON(type->cnt != 1);
 		type->regions[0].base = base;
 		type->regions[0].size = size;
+		memblock_set_region_node(&type->regions[0], MAX_NUMNODES);
 		return 0;
 	}
 repeat:
@@ -355,7 +356,7 @@ repeat:
 			nr_new++;
 			if (insert)
 				memblock_insert_region(type, i++, base,
-						       rbase - base);
+						rbase - base, MAX_NUMNODES);
 		}
 		/* area below @rend is dealt with, forget about it */
 		base = min(rend, end);
@@ -365,7 +366,8 @@ repeat:
 	if (base < end) {
 		nr_new++;
 		if (insert)
-			memblock_insert_region(type, i, base, end - base);
+			memblock_insert_region(type, i, base, end - base,
+					       MAX_NUMNODES);
 	}
 
 	/*
@@ -459,6 +461,101 @@ long __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 	return memblock_add_region(_rgn, base, size);
 }
 
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+/*
+ * Common iterator interface used to define for_each_mem_range().
+ */
+void __init_memblock __next_mem_pfn_range(int *idx, int nid,
+				unsigned long *out_start_pfn,
+				unsigned long *out_end_pfn, int *out_nid)
+{
+	struct memblock_type *type = &memblock.memory;
+	struct memblock_region *r;
+
+	while (++*idx < type->cnt) {
+		r = &type->regions[*idx];
+
+		if (PFN_UP(r->base) >= PFN_DOWN(r->base + r->size))
+			continue;
+		if (nid == MAX_NUMNODES || nid == r->nid)
+			break;
+	}
+	if (*idx >= type->cnt) {
+		*idx = -1;
+		return;
+	}
+
+	if (out_start_pfn)
+		*out_start_pfn = PFN_UP(r->base);
+	if (out_end_pfn)
+		*out_end_pfn = PFN_DOWN(r->base + r->size);
+	if (out_nid)
+		*out_nid = r->nid;
+}
+
+/**
+ * memblock_set_node - set node ID on memblock regions
+ * @base: base of area to set node ID for
+ * @size: size of area to set node ID for
+ * @nid: node ID to set
+ *
+ * Set the nid of memblock memory regions in [@base,@base+@size) to @nid.
+ * Regions which cross the area boundaries are split as necessary.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
+				      int nid)
+{
+	struct memblock_type *type = &memblock.memory;
+	phys_addr_t end = base + size;
+	int i;
+
+	/* we'll create at most two more regions */
+	while (type->cnt + 2 > type->max)
+		if (memblock_double_array(type) < 0)
+			return -ENOMEM;
+
+	for (i = 0; i < type->cnt; i++) {
+		struct memblock_region *rgn = &type->regions[i];
+		phys_addr_t rbase = rgn->base;
+		phys_addr_t rend = rbase + rgn->size;
+
+		if (rbase >= end)
+			break;
+		if (rend <= base)
+			continue;
+
+		if (rbase < base) {
+			/*
+			 * @rgn intersects from below.  Split and continue
+			 * to process the next region - the new top half.
+			 */
+			rgn->base = base;
+			rgn->size = rend - rgn->base;
+			memblock_insert_region(type, i, rbase, base - rbase,
+					       rgn->nid);
+		} else if (rend > end) {
+			/*
+			 * @rgn intersects from above.  Split and redo the
+			 * current region - the new bottom half.
+			 */
+			rgn->base = end;
+			rgn->size = rend - rgn->base;
+			memblock_insert_region(type, i--, rbase, end - rbase,
+					       rgn->nid);
+		} else {
+			/* @rgn is fully contained, set ->nid */
+			rgn->nid = nid;
+		}
+	}
+
+	memblock_merge_regions(type);
+	return 0;
+}
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+
 phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
 {
 	phys_addr_t found;
@@ -689,19 +786,26 @@ void __init_memblock memblock_set_current_limit(phys_addr_t limit)
 	memblock.current_limit = limit;
 }
 
-static void __init_memblock memblock_dump(struct memblock_type *region, char *name)
+static void __init_memblock memblock_dump(struct memblock_type *type, char *name)
 {
 	unsigned long long base, size;
 	int i;
 
-	pr_info(" %s.cnt  = 0x%lx\n", name, region->cnt);
-
-	for (i = 0; i < region->cnt; i++) {
-		base = region->regions[i].base;
-		size = region->regions[i].size;
+	pr_info(" %s.cnt  = 0x%lx\n", name, type->cnt);
 
-		pr_info(" %s[%#x]\t[%#016llx-%#016llx], %#llx bytes\n",
-		    name, i, base, base + size - 1, size);
+	for (i = 0; i < type->cnt; i++) {
+		struct memblock_region *rgn = &type->regions[i];
+		char nid_buf[32] = "";
+
+		base = rgn->base;
+		size = rgn->size;
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+		if (memblock_get_region_node(rgn) != MAX_NUMNODES)
+			snprintf(nid_buf, sizeof(nid_buf), " on node %d",
+				 memblock_get_region_node(rgn));
+#endif
+		pr_info(" %s[%#x]\t[%#016llx-%#016llx], %#llx bytes%s\n",
+			name, i, base, base + size - 1, size, nid_buf);
 	}
 }
 
@@ -759,11 +863,13 @@ void __init memblock_init(void)
 	 */
 	memblock.memory.regions[0].base = 0;
 	memblock.memory.regions[0].size = 0;
+	memblock_set_region_node(&memblock.memory.regions[0], MAX_NUMNODES);
 	memblock.memory.cnt = 1;
 
 	/* Ditto. */
 	memblock.reserved.regions[0].base = 0;
 	memblock.reserved.regions[0].size = 0;
+	memblock_set_region_node(&memblock.reserved.regions[0], MAX_NUMNODES);
 	memblock.reserved.cnt = 1;
 
 	memblock.current_limit = MEMBLOCK_ALLOC_ANYWHERE;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8ab5e5e..3c7ea45 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -182,28 +182,31 @@ static unsigned long __meminitdata nr_all_pages;
 static unsigned long __meminitdata dma_reserve;
 
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
-  /*
-   * MAX_ACTIVE_REGIONS determines the maximum number of distinct
-   * ranges of memory (RAM) that may be registered with add_active_range().
-   * Ranges passed to add_active_range() will be merged if possible
-   * so the number of times add_active_range() can be called is
-   * related to the number of nodes and the number of holes
-   */
-  #ifdef CONFIG_MAX_ACTIVE_REGIONS
-    /* Allow an architecture to set MAX_ACTIVE_REGIONS to save memory */
-    #define MAX_ACTIVE_REGIONS CONFIG_MAX_ACTIVE_REGIONS
-  #else
-    #if MAX_NUMNODES >= 32
-      /* If there can be many nodes, allow up to 50 holes per node */
-      #define MAX_ACTIVE_REGIONS (MAX_NUMNODES*50)
+  #ifndef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+    /*
+     * MAX_ACTIVE_REGIONS determines the maximum number of distinct ranges
+     * of memory (RAM) that may be registered with add_active_range().
+     * Ranges passed to add_active_range() will be merged if possible so
+     * the number of times add_active_range() can be called is related to
+     * the number of nodes and the number of holes
+     */
+    #ifdef CONFIG_MAX_ACTIVE_REGIONS
+      /* Allow an architecture to set MAX_ACTIVE_REGIONS to save memory */
+      #define MAX_ACTIVE_REGIONS CONFIG_MAX_ACTIVE_REGIONS
     #else
-      /* By default, allow up to 256 distinct regions */
-      #define MAX_ACTIVE_REGIONS 256
+      #if MAX_NUMNODES >= 32
+        /* If there can be many nodes, allow up to 50 holes per node */
+        #define MAX_ACTIVE_REGIONS (MAX_NUMNODES*50)
+      #else
+        /* By default, allow up to 256 distinct regions */
+        #define MAX_ACTIVE_REGIONS 256
+      #endif
     #endif
-  #endif
 
-  static struct node_active_region __meminitdata early_node_map[MAX_ACTIVE_REGIONS];
-  static int __meminitdata nr_nodemap_entries;
+    static struct node_active_region __meminitdata early_node_map[MAX_ACTIVE_REGIONS];
+    static int __meminitdata nr_nodemap_entries;
+#endif /* !CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+
   static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
   static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
   static unsigned long __initdata required_kernelcore;
@@ -4268,6 +4271,7 @@ static inline void setup_nr_node_ids(void)
 }
 #endif
 
+#ifndef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 /*
  * Common iterator interface used to define for_each_mem_pfn_range().
  */
@@ -4456,6 +4460,11 @@ void __init sort_node_map(void)
 			sizeof(struct node_active_region),
 			cmp_node_active_region, NULL);
 }
+#else /* !CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+static inline void sort_node_map(void)
+{
+}
+#endif
 
 /**
  * node_map_pfn_alignment - determine the maximum internode alignment
-- 
1.7.6

