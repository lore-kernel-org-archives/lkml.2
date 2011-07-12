Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab1GLIrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:47:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37565 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab1GLIqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:46:52 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/8] memblock, x86: Replace memblock_x86_find_in_range_node() with generic memblock calls
Date: Tue, 12 Jul 2011 10:46:35 +0200
Message-Id: <1310460395-30913-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310460395-30913-1-git-send-email-tj@kernel.org>
References: <1310460395-30913-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous changes, generic NUMA aware memblock API has feature
parity with memblock_x86_find_in_range_node().  There currently are
two users - x86 setup_node_data() and __alloc_memory_core_early() in
nobootmem.c.

This patch converts the former to use memblock_alloc_nid() and the
latter memblock_find_range_in_node(), and kills
memblock_x86_find_in_range_node() and related functions including
find_memory_early_core_early() in page_alloc.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/memblock.h |    1 -
 arch/x86/mm/memblock.c          |   15 ---------
 arch/x86/mm/numa.c              |    9 +-----
 include/linux/mm.h              |    2 -
 mm/nobootmem.c                  |    3 +-
 mm/page_alloc.c                 |   67 ---------------------------------------
 6 files changed, 2 insertions(+), 95 deletions(-)

diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
index 0cd3800..161792e 100644
--- a/arch/x86/include/asm/memblock.h
+++ b/arch/x86/include/asm/memblock.h
@@ -15,7 +15,6 @@ int get_free_all_memory_range(struct range **rangep, int nodeid);
 void memblock_x86_register_active_regions(int nid, unsigned long start_pfn,
 					 unsigned long last_pfn);
 u64 memblock_x86_hole_size(u64 start, u64 end);
-u64 memblock_x86_find_in_range_node(int nid, u64 start, u64 end, u64 size, u64 align);
 u64 memblock_x86_free_memory_in_range(u64 addr, u64 limit);
 u64 memblock_x86_memory_in_range(u64 addr, u64 limit);
 bool memblock_x86_check_reserved_size(u64 *addrp, u64 *sizep, u64 align);
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index da0d5c8..e4569f8 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -252,21 +252,6 @@ void __init memblock_x86_free_range(u64 start, u64 end)
 }
 
 /*
- * Need to call this function after memblock_x86_register_active_regions,
- * so early_node_map[] is filled already.
- */
-u64 __init memblock_x86_find_in_range_node(int nid, u64 start, u64 end, u64 size, u64 align)
-{
-	u64 addr;
-	addr = find_memory_core_early(nid, size, align, start, end);
-	if (addr)
-		return addr;
-
-	/* Fallback, should already have start end within node range */
-	return memblock_find_in_range(start, end, size, align);
-}
-
-/*
  * Finds an active region in the address range from start_pfn to last_pfn and
  * returns its range in ei_startpfn and ei_endpfn for the memblock entry.
  */
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index fa1015d..824efad 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -192,8 +192,6 @@ int __init numa_add_memblk(int nid, u64 start, u64 end)
 /* Initialize NODE_DATA for a node on the local memory */
 static void __init setup_node_data(int nid, u64 start, u64 end)
 {
-	const u64 nd_low = PFN_PHYS(MAX_DMA_PFN);
-	const u64 nd_high = PFN_PHYS(max_pfn_mapped);
 	const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
 	bool remapped = false;
 	u64 nd_pa;
@@ -224,17 +222,12 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 		nd_pa = __pa(nd);
 		remapped = true;
 	} else {
-		nd_pa = memblock_x86_find_in_range_node(nid, nd_low, nd_high,
-						nd_size, SMP_CACHE_BYTES);
-		if (!nd_pa)
-			nd_pa = memblock_find_in_range(nd_low, nd_high,
-						nd_size, SMP_CACHE_BYTES);
+		nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
 		if (!nd_pa) {
 			pr_err("Cannot find %zu bytes in node %d\n",
 			       nd_size, nid);
 			return;
 		}
-		memblock_x86_reserve_range(nd_pa, nd_pa + nd_size, "NODE_DATA");
 		nd = __va(nd_pa);
 	}
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 57e4c9f..9ebc65a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1325,8 +1325,6 @@ extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
 int add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid);
-u64 __init find_memory_core_early(int nid, u64 size, u64 align,
-					u64 goal, u64 limit);
 extern void sparse_memory_present_with_active_regions(int nid);
 
 extern void __next_mem_pfn_range(int *idx, int nid,
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 5b0eb06..c781626 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -41,8 +41,7 @@ static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 	if (limit > memblock.current_limit)
 		limit = memblock.current_limit;
 
-	addr = find_memory_core_early(nid, size, align, goal, limit);
-
+	addr = memblock_find_in_range_node(goal, limit, size, align, nid);
 	if (!addr)
 		return NULL;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 902f03a..8ab5e5e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3779,73 +3779,6 @@ void __init free_bootmem_with_active_regions(int nid, unsigned long max_low_pfn)
 	}
 }
 
-#ifdef CONFIG_HAVE_MEMBLOCK
-/*
- * Basic iterator support. Return the last range of PFNs for a node
- * Note: nid == MAX_NUMNODES returns last region regardless of node
- */
-static int __meminit last_active_region_index_in_nid(int nid)
-{
-	int i;
-
-	for (i = nr_nodemap_entries - 1; i >= 0; i--)
-		if (nid == MAX_NUMNODES || early_node_map[i].nid == nid)
-			return i;
-
-	return -1;
-}
-
-/*
- * Basic iterator support. Return the previous active range of PFNs for a node
- * Note: nid == MAX_NUMNODES returns next region regardless of node
- */
-static int __meminit previous_active_region_index_in_nid(int index, int nid)
-{
-	for (index = index - 1; index >= 0; index--)
-		if (nid == MAX_NUMNODES || early_node_map[index].nid == nid)
-			return index;
-
-	return -1;
-}
-
-#define for_each_active_range_index_in_nid_reverse(i, nid) \
-	for (i = last_active_region_index_in_nid(nid); i != -1; \
-				i = previous_active_region_index_in_nid(i, nid))
-
-u64 __init find_memory_core_early(int nid, u64 size, u64 align,
-					u64 goal, u64 limit)
-{
-	int i;
-
-	/* Need to go over early_node_map to find out good range for node */
-	for_each_active_range_index_in_nid_reverse(i, nid) {
-		u64 addr;
-		u64 ei_start, ei_last;
-		u64 final_start, final_end;
-
-		ei_last = early_node_map[i].end_pfn;
-		ei_last <<= PAGE_SHIFT;
-		ei_start = early_node_map[i].start_pfn;
-		ei_start <<= PAGE_SHIFT;
-
-		final_start = max(ei_start, goal);
-		final_end = min(ei_last, limit);
-
-		if (final_start >= final_end)
-			continue;
-
-		addr = memblock_find_in_range(final_start, final_end, size, align);
-
-		if (!addr)
-			continue;
-
-		return addr;
-	}
-
-	return 0;
-}
-#endif
-
 int __init add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid)
 {
-- 
1.7.6

