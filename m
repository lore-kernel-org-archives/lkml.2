Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1GZPid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:38:33 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:60404 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab1GZPgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:36:18 -0400
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 23/23] memblock: Reimplement memblock allocation using reverse free area iterator
Date: Tue, 26 Jul 2011 17:35:34 +0200
Message-Id: <1311694534-5161-24-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311694534-5161-1-git-send-email-tj@kernel.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all early memory information is in memblock when enabled, we
can implement reverse free area iterator and use it to implement NUMA
aware allocator which is then wrapped for simpler variants instead of
the confusing and inefficient mending of information in separate NUMA
aware allocator.

Implement for_each_free_mem_range_reverse(), use it to reimplement
memblock_find_in_range_node() which in turn is used by all allocators.

The visible allocator interface is inconsistent and can probably use
some cleanup too.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/memblock.h |   24 ++++-
 mm/memblock.c            |  273 +++++++++++++++++++++------------------------
 2 files changed, 149 insertions(+), 148 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 22fc2a6..7c59804 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -46,6 +46,8 @@ extern int memblock_debug;
 #define memblock_dbg(fmt, ...) \
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 
+phys_addr_t memblock_find_in_range_node(phys_addr_t start, phys_addr_t end,
+				phys_addr_t size, phys_addr_t align, int nid);
 phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 				   phys_addr_t size, phys_addr_t align);
 int memblock_free_reserved_regions(void);
@@ -98,6 +100,26 @@ void __next_free_mem_range(u64 *idx, int nid, phys_addr_t *out_start,
 	     i != (u64)ULLONG_MAX;					\
 	     __next_free_mem_range(&i, nid, p_start, p_end, p_nid))
 
+void __next_free_mem_range_rev(u64 *idx, int nid, phys_addr_t *out_start,
+			       phys_addr_t *out_end, int *out_nid);
+
+/**
+ * for_each_free_mem_range_reverse - rev-iterate through free memblock areas
+ * @i: u64 used as loop variable
+ * @nid: node selector, %MAX_NUMNODES for all nodes
+ * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ * @p_nid: ptr to int for nid of the range, can be %NULL
+ *
+ * Walks over free (memory && !reserved) areas of memblock in reverse
+ * order.  Available as soon as memblock is initialized.
+ */
+#define for_each_free_mem_range_reverse(i, nid, p_start, p_end, p_nid)	\
+	for (i = (u64)ULLONG_MAX,					\
+	     __next_free_mem_range_rev(&i, nid, p_start, p_end, p_nid);	\
+	     i != (u64)ULLONG_MAX;					\
+	     __next_free_mem_range_rev(&i, nid, p_start, p_end, p_nid))
+
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 int memblock_set_node(phys_addr_t base, phys_addr_t size, int nid);
 
@@ -121,8 +143,6 @@ static inline int memblock_get_region_node(const struct memblock_region *r)
 }
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
-phys_addr_t memblock_find_in_range_node(phys_addr_t start, phys_addr_t end,
-				phys_addr_t size, phys_addr_t align, int nid);
 phys_addr_t memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid);
 phys_addr_t memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, int nid);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 4159046..230a4b7 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -79,78 +79,66 @@ static long __init_memblock memblock_overlaps_region(struct memblock_type *type,
 	return (i < type->cnt) ? i : -1;
 }
 
-/*
- * Find, allocate, deallocate or reserve unreserved regions. All allocations
- * are top-down.
+/**
+ * memblock_find_in_range_node - find free area in given range and node
+ * @start: start of candidate range
+ * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
+ * @size: size of free area to find
+ * @align: alignment of free area to find
+ * @nid: nid of the free area to find, %MAX_NUMNODES for any node
+ *
+ * Find @size free area aligned to @align in the specified range and node.
+ *
+ * RETURNS:
+ * Found address on success, %0 on failure.
  */
-
-static phys_addr_t __init_memblock memblock_find_region(phys_addr_t start, phys_addr_t end,
-					  phys_addr_t size, phys_addr_t align)
+phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
+					phys_addr_t end, phys_addr_t size,
+					phys_addr_t align, int nid)
 {
-	phys_addr_t base, res_base;
-	long j;
+	phys_addr_t this_start, this_end, cand;
+	u64 i;
 
-	/* In case, huge size is requested */
-	if (end < size)
-		return 0;
+	/* align @size to avoid excessive fragmentation on reserved array */
+	size = round_up(size, align);
+
+	/* pump up @end */
+	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
+		end = memblock.current_limit;
 
-	base = round_down(end - size, align);
+	/* adjust @start to avoid underflow and allocating the first page */
+	start = max3(start, size, (phys_addr_t)PAGE_SIZE);
+	end = max(start, end);
 
-	/* Prevent allocations returning 0 as it's also used to
-	 * indicate an allocation failure
-	 */
-	if (start == 0)
-		start = PAGE_SIZE;
-
-	while (start <= base) {
-		j = memblock_overlaps_region(&memblock.reserved, base, size);
-		if (j < 0)
-			return base;
-		res_base = memblock.reserved.regions[j].base;
-		if (res_base < size)
-			break;
-		base = round_down(res_base - size, align);
-	}
+	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
+		this_start = clamp(this_start, start, end);
+		this_end = clamp(this_end, start, end);
 
+		cand = round_down(this_end - size, align);
+		if (cand >= this_start)
+			return cand;
+	}
 	return 0;
 }
 
-/*
- * Find a free area with specified alignment in a specific range.
+/**
+ * memblock_find_in_range - find free area in given range
+ * @start: start of candidate range
+ * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
+ * @size: size of free area to find
+ * @align: alignment of free area to find
+ *
+ * Find @size free area aligned to @align in the specified range.
+ *
+ * RETURNS:
+ * Found address on success, %0 on failure.
  */
-phys_addr_t __init_memblock memblock_find_in_range(phys_addr_t start, phys_addr_t end,
-					phys_addr_t size, phys_addr_t align)
+phys_addr_t __init_memblock memblock_find_in_range(phys_addr_t start,
+					phys_addr_t end, phys_addr_t size,
+					phys_addr_t align)
 {
-	long i;
-
-	BUG_ON(0 == size);
-
-	/* Pump up max_addr */
-	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
-		end = memblock.current_limit;
-
-	/* We do a top-down search, this tends to limit memory
-	 * fragmentation by keeping early boot allocs near the
-	 * top of memory
-	 */
-	for (i = memblock.memory.cnt - 1; i >= 0; i--) {
-		phys_addr_t memblockbase = memblock.memory.regions[i].base;
-		phys_addr_t memblocksize = memblock.memory.regions[i].size;
-		phys_addr_t bottom, top, found;
-
-		if (memblocksize < size)
-			continue;
-		if ((memblockbase + memblocksize) <= start)
-			break;
-		bottom = max(memblockbase, start);
-		top = min(memblockbase + memblocksize, end);
-		if (bottom >= top)
-			continue;
-		found = memblock_find_region(bottom, top, size, align);
-		if (found)
-			return found;
-	}
-	return 0;
+	return memblock_find_in_range_node(start, end, size, align,
+					   MAX_NUMNODES);
 }
 
 /*
@@ -607,6 +595,70 @@ void __init_memblock __next_free_mem_range(u64 *idx, int nid,
 	*idx = ULLONG_MAX;
 }
 
+/**
+ * __next_free_mem_range_rev - next function for for_each_free_mem_range_reverse()
+ * @idx: pointer to u64 loop variable
+ * @nid: nid: node selector, %MAX_NUMNODES for all nodes
+ * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ * @p_nid: ptr to int for nid of the range, can be %NULL
+ *
+ * Reverse of __next_free_mem_range().
+ */
+void __init_memblock __next_free_mem_range_rev(u64 *idx, int nid,
+					   phys_addr_t *out_start,
+					   phys_addr_t *out_end, int *out_nid)
+{
+	struct memblock_type *mem = &memblock.memory;
+	struct memblock_type *rsv = &memblock.reserved;
+	int mi = *idx & 0xffffffff;
+	int ri = *idx >> 32;
+
+	if (*idx == (u64)ULLONG_MAX) {
+		mi = mem->cnt - 1;
+		ri = rsv->cnt;
+	}
+
+	for ( ; mi >= 0; mi--) {
+		struct memblock_region *m = &mem->regions[mi];
+		phys_addr_t m_start = m->base;
+		phys_addr_t m_end = m->base + m->size;
+
+		/* only memory regions are associated with nodes, check it */
+		if (nid != MAX_NUMNODES && nid != memblock_get_region_node(m))
+			continue;
+
+		/* scan areas before each reservation for intersection */
+		for ( ; ri >= 0; ri--) {
+			struct memblock_region *r = &rsv->regions[ri];
+			phys_addr_t r_start = ri ? r[-1].base + r[-1].size : 0;
+			phys_addr_t r_end = ri < rsv->cnt ? r->base : ULLONG_MAX;
+
+			/* if ri advanced past mi, break out to advance mi */
+			if (r_end <= m_start)
+				break;
+			/* if the two regions intersect, we're done */
+			if (m_end > r_start) {
+				if (out_start)
+					*out_start = max(m_start, r_start);
+				if (out_end)
+					*out_end = min(m_end, r_end);
+				if (out_nid)
+					*out_nid = memblock_get_region_node(m);
+
+				if (m_start >= r_start)
+					mi--;
+				else
+					ri--;
+				*idx = (u32)mi | (u64)ri << 32;
+				return;
+			}
+		}
+	}
+
+	*idx = ULLONG_MAX;
+}
+
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 /*
  * Common iterator interface used to define for_each_mem_range().
@@ -670,22 +722,29 @@ int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
 }
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
-phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
+static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
+					phys_addr_t align, phys_addr_t max_addr,
+					int nid)
 {
 	phys_addr_t found;
 
-	/* We align the size to limit fragmentation. Without this, a lot of
-	 * small allocs quickly eat up the whole reserve array on sparc
-	 */
-	size = round_up(size, align);
-
-	found = memblock_find_in_range(0, max_addr, size, align);
+	found = memblock_find_in_range_node(0, max_addr, size, align, nid);
 	if (found && !memblock_reserve(found, size))
 		return found;
 
 	return 0;
 }
 
+phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid)
+{
+	return memblock_alloc_base_nid(size, align, MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+}
+
+phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
+{
+	return memblock_alloc_base_nid(size, align, max_addr, MAX_NUMNODES);
+}
+
 phys_addr_t __init memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
 {
 	phys_addr_t alloc;
@@ -704,84 +763,6 @@ phys_addr_t __init memblock_alloc(phys_addr_t size, phys_addr_t align)
 	return memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
 }
 
-
-/*
- * Additional node-local top-down allocators.
- *
- * WARNING: Only available after early_node_map[] has been populated,
- * on some architectures, that is after all the calls to add_active_range()
- * have been done to populate it.
- */
-
-static phys_addr_t __init memblock_nid_range_rev(phys_addr_t start,
-						 phys_addr_t end, int *nid)
-{
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-	unsigned long start_pfn, end_pfn;
-	int i;
-
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, nid)
-		if (end > PFN_PHYS(start_pfn) && end <= PFN_PHYS(end_pfn))
-			return max(start, PFN_PHYS(start_pfn));
-#endif
-	*nid = 0;
-	return start;
-}
-
-phys_addr_t __init memblock_find_in_range_node(phys_addr_t start,
-					       phys_addr_t end,
-					       phys_addr_t size,
-					       phys_addr_t align, int nid)
-{
-	struct memblock_type *mem = &memblock.memory;
-	int i;
-
-	BUG_ON(0 == size);
-
-	/* Pump up max_addr */
-	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
-		end = memblock.current_limit;
-
-	for (i = mem->cnt - 1; i >= 0; i--) {
-		struct memblock_region *r = &mem->regions[i];
-		phys_addr_t base = max(start, r->base);
-		phys_addr_t top = min(end, r->base + r->size);
-
-		while (base < top) {
-			phys_addr_t tbase, ret;
-			int tnid;
-
-			tbase = memblock_nid_range_rev(base, top, &tnid);
-			if (nid == MAX_NUMNODES || tnid == nid) {
-				ret = memblock_find_region(tbase, top, size, align);
-				if (ret)
-					return ret;
-			}
-			top = tbase;
-		}
-	}
-
-	return 0;
-}
-
-phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid)
-{
-	phys_addr_t found;
-
-	/*
-	 * We align the size to limit fragmentation. Without this, a lot of
-	 * small allocs quickly eat up the whole reserve array on sparc
-	 */
-	size = round_up(size, align);
-
-	found = memblock_find_in_range_node(0, MEMBLOCK_ALLOC_ACCESSIBLE,
-					    size, align, nid);
-	if (found && !memblock_reserve(found, size))
-		return found;
-
-	return 0;
-}
-
 phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, int nid)
 {
 	phys_addr_t res = memblock_alloc_nid(size, align, nid);
-- 
1.7.6

