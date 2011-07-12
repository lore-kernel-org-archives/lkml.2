Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab1GLIqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:46:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37565 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab1GLIqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:46:46 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/8] bootmem: Use for_each_mem_pfn_range() in page_alloc.c
Date: Tue, 12 Jul 2011 10:46:30 +0200
Message-Id: <1310460395-30913-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310460395-30913-1-git-send-email-tj@kernel.org>
References: <1310460395-30913-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch added for_each_mem_pfn_range() which is more
versatile than for_each_active_range_index_in_nid().  This patch
replaces for_each_active_range_index_in_nid() and open coded
early_node_map[] walks with for_each_mem_pfn_range().

All conversions in this patch are straight-forward and shouldn't cause
any functional difference.  After the conversions,
for_each_active_range_index_in_nid() doesn't have any user left and is
removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/page_alloc.c |  165 +++++++++++++++++++------------------------------------
 1 files changed, 56 insertions(+), 109 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3092a97..902f03a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3711,34 +3711,6 @@ __meminit int init_currently_empty_zone(struct zone *zone,
 }
 
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
-/*
- * Basic iterator support. Return the first range of PFNs for a node
- * Note: nid == MAX_NUMNODES returns first region regardless of node
- */
-static int __meminit first_active_region_index_in_nid(int nid)
-{
-	int i;
-
-	for (i = 0; i < nr_nodemap_entries; i++)
-		if (nid == MAX_NUMNODES || early_node_map[i].nid == nid)
-			return i;
-
-	return -1;
-}
-
-/*
- * Basic iterator support. Return the next active range of PFNs for a node
- * Note: nid == MAX_NUMNODES returns next region regardless of node
- */
-static int __meminit next_active_region_index_in_nid(int index, int nid)
-{
-	for (index = index + 1; index < nr_nodemap_entries; index++)
-		if (nid == MAX_NUMNODES || early_node_map[index].nid == nid)
-			return index;
-
-	return -1;
-}
-
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 /*
  * Required by SPARSEMEM. Given a PFN, return what node the PFN is on.
@@ -3748,15 +3720,12 @@ static int __meminit next_active_region_index_in_nid(int index, int nid)
  */
 int __meminit __early_pfn_to_nid(unsigned long pfn)
 {
-	int i;
-
-	for (i = 0; i < nr_nodemap_entries; i++) {
-		unsigned long start_pfn = early_node_map[i].start_pfn;
-		unsigned long end_pfn = early_node_map[i].end_pfn;
+	unsigned long start_pfn, end_pfn;
+	int i, nid;
 
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
 		if (start_pfn <= pfn && pfn < end_pfn)
-			return early_node_map[i].nid;
-	}
+			return nid;
 	/* This is a memory hole */
 	return -1;
 }
@@ -3785,11 +3754,6 @@ bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
 }
 #endif
 
-/* Basic iterator support to walk early_node_map[] */
-#define for_each_active_range_index_in_nid(i, nid) \
-	for (i = first_active_region_index_in_nid(nid); i != -1; \
-				i = next_active_region_index_in_nid(i, nid))
-
 /**
  * free_bootmem_with_active_regions - Call free_bootmem_node for each active range
  * @nid: The node to free memory on. If MAX_NUMNODES, all nodes are freed.
@@ -3799,25 +3763,19 @@ bool __meminit early_pfn_in_nid(unsigned long pfn, int node)
  * add_active_ranges() contain no holes and may be freed, this
  * this function may be used instead of calling free_bootmem() manually.
  */
-void __init free_bootmem_with_active_regions(int nid,
-						unsigned long max_low_pfn)
+void __init free_bootmem_with_active_regions(int nid, unsigned long max_low_pfn)
 {
-	int i;
-
-	for_each_active_range_index_in_nid(i, nid) {
-		unsigned long size_pages = 0;
-		unsigned long end_pfn = early_node_map[i].end_pfn;
-
-		if (early_node_map[i].start_pfn >= max_low_pfn)
-			continue;
+	unsigned long start_pfn, end_pfn;
+	int i, this_nid;
 
-		if (end_pfn > max_low_pfn)
-			end_pfn = max_low_pfn;
+	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, &this_nid) {
+		start_pfn = min(start_pfn, max_low_pfn);
+		end_pfn = min(end_pfn, max_low_pfn);
 
-		size_pages = end_pfn - early_node_map[i].start_pfn;
-		free_bootmem_node(NODE_DATA(early_node_map[i].nid),
-				PFN_PHYS(early_node_map[i].start_pfn),
-				size_pages << PAGE_SHIFT);
+		if (start_pfn < end_pfn)
+			free_bootmem_node(NODE_DATA(this_nid),
+					  PFN_PHYS(start_pfn),
+					  (end_pfn - start_pfn) << PAGE_SHIFT);
 	}
 }
 
@@ -3891,15 +3849,12 @@ u64 __init find_memory_core_early(int nid, u64 size, u64 align,
 int __init add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid)
 {
+	unsigned long start_pfn, end_pfn;
 	int i;
-	u64 start, end;
 
 	/* need to go over early_node_map to find out good range for node */
-	for_each_active_range_index_in_nid(i, nid) {
-		start = early_node_map[i].start_pfn;
-		end = early_node_map[i].end_pfn;
-		nr_range = add_range(range, az, nr_range, start, end);
-	}
+	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL)
+		nr_range = add_range(range, az, nr_range, start_pfn, end_pfn);
 	return nr_range;
 }
 
@@ -3913,12 +3868,11 @@ int __init add_from_early_node_map(struct range *range, int az,
  */
 void __init sparse_memory_present_with_active_regions(int nid)
 {
-	int i;
+	unsigned long start_pfn, end_pfn;
+	int i, this_nid;
 
-	for_each_active_range_index_in_nid(i, nid)
-		memory_present(early_node_map[i].nid,
-				early_node_map[i].start_pfn,
-				early_node_map[i].end_pfn);
+	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, &this_nid)
+		memory_present(this_nid, start_pfn, end_pfn);
 }
 
 /**
@@ -3935,13 +3889,15 @@ void __init sparse_memory_present_with_active_regions(int nid)
 void __meminit get_pfn_range_for_nid(unsigned int nid,
 			unsigned long *start_pfn, unsigned long *end_pfn)
 {
+	unsigned long this_start_pfn, this_end_pfn;
 	int i;
+
 	*start_pfn = -1UL;
 	*end_pfn = 0;
 
-	for_each_active_range_index_in_nid(i, nid) {
-		*start_pfn = min(*start_pfn, early_node_map[i].start_pfn);
-		*end_pfn = max(*end_pfn, early_node_map[i].end_pfn);
+	for_each_mem_pfn_range(i, nid, &this_start_pfn, &this_end_pfn, NULL) {
+		*start_pfn = min(*start_pfn, this_start_pfn);
+		*end_pfn = max(*end_pfn, this_end_pfn);
 	}
 
 	if (*start_pfn == -1UL)
@@ -4484,6 +4440,7 @@ void __init add_active_range(unsigned int nid, unsigned long start_pfn,
 void __init remove_active_range(unsigned int nid, unsigned long start_pfn,
 				unsigned long end_pfn)
 {
+	unsigned long this_start_pfn, this_end_pfn;
 	int i, j;
 	int removed = 0;
 
@@ -4491,26 +4448,22 @@ void __init remove_active_range(unsigned int nid, unsigned long start_pfn,
 			  nid, start_pfn, end_pfn);
 
 	/* Find the old active region end and shrink */
-	for_each_active_range_index_in_nid(i, nid) {
-		if (early_node_map[i].start_pfn >= start_pfn &&
-		    early_node_map[i].end_pfn <= end_pfn) {
+	for_each_mem_pfn_range(i, nid, &this_start_pfn, &this_end_pfn, NULL) {
+		if (this_start_pfn >= start_pfn && this_end_pfn <= end_pfn) {
 			/* clear it */
 			early_node_map[i].start_pfn = 0;
 			early_node_map[i].end_pfn = 0;
 			removed = 1;
 			continue;
 		}
-		if (early_node_map[i].start_pfn < start_pfn &&
-		    early_node_map[i].end_pfn > start_pfn) {
-			unsigned long temp_end_pfn = early_node_map[i].end_pfn;
+		if (this_start_pfn < start_pfn && this_end_pfn > start_pfn) {
 			early_node_map[i].end_pfn = start_pfn;
-			if (temp_end_pfn > end_pfn)
-				add_active_range(nid, end_pfn, temp_end_pfn);
+			if (this_end_pfn > end_pfn)
+				add_active_range(nid, end_pfn, this_end_pfn);
 			continue;
 		}
-		if (early_node_map[i].start_pfn >= start_pfn &&
-		    early_node_map[i].end_pfn > end_pfn &&
-		    early_node_map[i].start_pfn < end_pfn) {
+		if (this_start_pfn >= start_pfn && this_end_pfn > end_pfn &&
+		    this_start_pfn < end_pfn) {
 			early_node_map[i].start_pfn = end_pfn;
 			continue;
 		}
@@ -4593,15 +4546,11 @@ void __init sort_node_map(void)
 unsigned long __init node_map_pfn_alignment(void)
 {
 	unsigned long accl_mask = 0, last_end = 0;
+	unsigned long start, end, mask;
 	int last_nid = -1;
-	int i;
-
-	for_each_active_range_index_in_nid(i, MAX_NUMNODES) {
-		int nid = early_node_map[i].nid;
-		unsigned long start = early_node_map[i].start_pfn;
-		unsigned long end = early_node_map[i].end_pfn;
-		unsigned long mask;
+	int i, nid;
 
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid) {
 		if (!start || last_nid < 0 || last_nid == nid) {
 			last_nid = nid;
 			last_end = end;
@@ -4628,12 +4577,12 @@ unsigned long __init node_map_pfn_alignment(void)
 /* Find the lowest pfn for a node */
 static unsigned long __init find_min_pfn_for_node(int nid)
 {
-	int i;
 	unsigned long min_pfn = ULONG_MAX;
+	unsigned long start_pfn;
+	int i;
 
-	/* Assuming a sorted map, the first range found has the starting pfn */
-	for_each_active_range_index_in_nid(i, nid)
-		min_pfn = min(min_pfn, early_node_map[i].start_pfn);
+	for_each_mem_pfn_range(i, nid, &start_pfn, NULL, NULL)
+		min_pfn = min(min_pfn, start_pfn);
 
 	if (min_pfn == ULONG_MAX) {
 		printk(KERN_WARNING
@@ -4662,15 +4611,16 @@ unsigned long __init find_min_pfn_with_active_regions(void)
  */
 static unsigned long __init early_calculate_totalpages(void)
 {
-	int i;
 	unsigned long totalpages = 0;
+	unsigned long start_pfn, end_pfn;
+	int i, nid;
+
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		unsigned long pages = end_pfn - start_pfn;
 
-	for (i = 0; i < nr_nodemap_entries; i++) {
-		unsigned long pages = early_node_map[i].end_pfn -
-						early_node_map[i].start_pfn;
 		totalpages += pages;
 		if (pages)
-			node_set_state(early_node_map[i].nid, N_HIGH_MEMORY);
+			node_set_state(nid, N_HIGH_MEMORY);
 	}
   	return totalpages;
 }
@@ -4725,6 +4675,8 @@ restart:
 	/* Spread kernelcore memory as evenly as possible throughout nodes */
 	kernelcore_node = required_kernelcore / usable_nodes;
 	for_each_node_state(nid, N_HIGH_MEMORY) {
+		unsigned long start_pfn, end_pfn;
+
 		/*
 		 * Recalculate kernelcore_node if the division per node
 		 * now exceeds what is necessary to satisfy the requested
@@ -4741,13 +4693,10 @@ restart:
 		kernelcore_remaining = kernelcore_node;
 
 		/* Go through each range of PFNs within this node */
-		for_each_active_range_index_in_nid(i, nid) {
-			unsigned long start_pfn, end_pfn;
+		for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 			unsigned long size_pages;
 
-			start_pfn = max(early_node_map[i].start_pfn,
-						zone_movable_pfn[nid]);
-			end_pfn = early_node_map[i].end_pfn;
+			start_pfn = max(start_pfn, zone_movable_pfn[nid]);
 			if (start_pfn >= end_pfn)
 				continue;
 
@@ -4849,8 +4798,8 @@ static void check_for_regular_memory(pg_data_t *pgdat)
  */
 void __init free_area_init_nodes(unsigned long *max_zone_pfn)
 {
-	unsigned long nid;
-	int i;
+	unsigned long start_pfn, end_pfn;
+	int i, nid;
 
 	/* Sort early_node_map as initialisation assumes it is sorted */
 	sort_node_map();
@@ -4900,11 +4849,9 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
 	}
 
 	/* Print out the early_node_map[] */
-	printk("early_node_map[%d] active PFN ranges\n", nr_nodemap_entries);
-	for (i = 0; i < nr_nodemap_entries; i++)
-		printk("  %3d: %0#10lx -> %0#10lx\n", early_node_map[i].nid,
-						early_node_map[i].start_pfn,
-						early_node_map[i].end_pfn);
+	printk("Early memory PFN ranges\n");
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
+		printk("  %3d: %0#10lx -> %0#10lx\n", nid, start_pfn, end_pfn);
 
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
-- 
1.7.6

