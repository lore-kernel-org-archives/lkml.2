Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab1GNV2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:28:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:39023 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab1GNV2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:28:20 -0400
Date: Thu, 14 Jul 2011 21:27:56 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-5dfe8660a3d7f1ee1265c3536433ee53da3f98a3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20110714074610.GD3455@htj.dyndns.org>
References: <20110714074610.GD3455@htj.dyndns.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] bootmem: Replace work_with_active_regions() with for_each_mem_pfn_range()
Git-Commit-ID: 5dfe8660a3d7f1ee1265c3536433ee53da3f98a3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 21:28:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5dfe8660a3d7f1ee1265c3536433ee53da3f98a3
Gitweb:     http://git.kernel.org/tip/5dfe8660a3d7f1ee1265c3536433ee53da3f98a3
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Thu, 14 Jul 2011 09:46:10 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 11:45:29 -0700

bootmem: Replace work_with_active_regions() with for_each_mem_pfn_range()

Callback based iteration is cumbersome and much less useful than
for_each_*() iterator.  This patch implements for_each_mem_pfn_range()
which replaces work_with_active_regions().  All the current users of
work_with_active_regions() are converted.

This simplifies walking over early_node_map and will allow converting
internal logics in page_alloc to use iterator instead of walking
early_node_map directly, which in turn will enable moving node
information to memblock.

powerpc change is only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/20110714074610.GD3455@htj.dyndns.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/powerpc/mm/numa.c    |   52 +++++++++++++-------------------------------
 arch/x86/mm/memblock.c    |   23 +++----------------
 drivers/pci/intel-iommu.c |   24 +++++++-------------
 include/linux/mm.h        |   22 +++++++++++++++++-
 mm/page_alloc.c           |   40 ++++++++++++++++++++++++----------
 5 files changed, 77 insertions(+), 84 deletions(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 2164006..6f06ea5 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -127,45 +127,25 @@ static int __cpuinit fake_numa_create_new_node(unsigned long end_pfn,
 }
 
 /*
- * get_active_region_work_fn - A helper function for get_node_active_region
- *	Returns datax set to the start_pfn and end_pfn if they contain
- *	the initial value of datax->start_pfn between them
- * @start_pfn: start page(inclusive) of region to check
- * @end_pfn: end page(exclusive) of region to check
- * @datax: comes in with ->start_pfn set to value to search for and
- *	goes out with active range if it contains it
- * Returns 1 if search value is in range else 0
- */
-static int __init get_active_region_work_fn(unsigned long start_pfn,
-					unsigned long end_pfn, void *datax)
-{
-	struct node_active_region *data;
-	data = (struct node_active_region *)datax;
-
-	if (start_pfn <= data->start_pfn && end_pfn > data->start_pfn) {
-		data->start_pfn = start_pfn;
-		data->end_pfn = end_pfn;
-		return 1;
-	}
-	return 0;
-
-}
-
-/*
- * get_node_active_region - Return active region containing start_pfn
+ * get_node_active_region - Return active region containing pfn
  * Active range returned is empty if none found.
- * @start_pfn: The page to return the region for.
- * @node_ar: Returned set to the active region containing start_pfn
+ * @pfn: The page to return the region for
+ * @node_ar: Returned set to the active region containing @pfn
  */
-static void __init get_node_active_region(unsigned long start_pfn,
-		       struct node_active_region *node_ar)
+static void __init get_node_active_region(unsigned long pfn,
+					  struct node_active_region *node_ar)
 {
-	int nid = early_pfn_to_nid(start_pfn);
+	unsigned long start_pfn, end_pfn;
+	int i, nid;
 
-	node_ar->nid = nid;
-	node_ar->start_pfn = start_pfn;
-	node_ar->end_pfn = start_pfn;
-	work_with_active_regions(nid, get_active_region_work_fn, node_ar);
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		if (pfn >= start_pfn && pfn < end_pfn) {
+			node_ar->nid = nid;
+			node_ar->start_pfn = start_pfn;
+			node_ar->end_pfn = end_pfn;
+			break;
+		}
+	}
 }
 
 static void map_cpu_to_node(int cpu, int node)
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index e126117..da0d5c8 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -115,28 +115,13 @@ static void __init memblock_x86_subtract_reserved(struct range *range, int az)
 	memblock_reserve_reserved_regions();
 }
 
-struct count_data {
-	int nr;
-};
-
-static int __init count_work_fn(unsigned long start_pfn,
-				unsigned long end_pfn, void *datax)
-{
-	struct count_data *data = datax;
-
-	data->nr++;
-
-	return 0;
-}
-
 static int __init count_early_node_map(int nodeid)
 {
-	struct count_data data;
-
-	data.nr = 0;
-	work_with_active_regions(nodeid, count_work_fn, &data);
+	int i, cnt = 0;
 
-	return data.nr;
+	for_each_mem_pfn_range(i, nodeid, NULL, NULL, NULL)
+		cnt++;
+	return cnt;
 }
 
 int __init __get_free_all_memory_range(struct range **rangep, int nodeid,
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index f02c34d..8ec3520 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2178,18 +2178,6 @@ static inline void iommu_prepare_isa(void)
 
 static int md_domain_init(struct dmar_domain *domain, int guest_width);
 
-static int __init si_domain_work_fn(unsigned long start_pfn,
-				    unsigned long end_pfn, void *datax)
-{
-	int *ret = datax;
-
-	*ret = iommu_domain_identity_map(si_domain,
-					 (uint64_t)start_pfn << PAGE_SHIFT,
-					 (uint64_t)end_pfn << PAGE_SHIFT);
-	return *ret;
-
-}
-
 static int __init si_domain_init(int hw)
 {
 	struct dmar_drhd_unit *drhd;
@@ -2221,9 +2209,15 @@ static int __init si_domain_init(int hw)
 		return 0;
 
 	for_each_online_node(nid) {
-		work_with_active_regions(nid, si_domain_work_fn, &ret);
-		if (ret)
-			return ret;
+		unsigned long start_pfn, end_pfn;
+		int i;
+
+		for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
+			ret = iommu_domain_identity_map(si_domain,
+					PFN_PHYS(start_pfn), PFN_PHYS(end_pfn));
+			if (ret)
+				return ret;
+		}
 	}
 
 	return 0;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c70a326..57e4c9f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1327,9 +1327,27 @@ int add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid);
 u64 __init find_memory_core_early(int nid, u64 size, u64 align,
 					u64 goal, u64 limit);
-typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
-extern void work_with_active_regions(int nid, work_fn_t work_fn, void *data);
 extern void sparse_memory_present_with_active_regions(int nid);
+
+extern void __next_mem_pfn_range(int *idx, int nid,
+				 unsigned long *out_start_pfn,
+				 unsigned long *out_end_pfn, int *out_nid);
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
+
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
 #if !defined(CONFIG_ARCH_POPULATES_NODE_MAP) && \
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c7f0e5b..69fffab 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3903,18 +3903,6 @@ int __init add_from_early_node_map(struct range *range, int az,
 	return nr_range;
 }
 
-void __init work_with_active_regions(int nid, work_fn_t work_fn, void *data)
-{
-	int i;
-	int ret;
-
-	for_each_active_range_index_in_nid(i, nid) {
-		ret = work_fn(early_node_map[i].start_pfn,
-			      early_node_map[i].end_pfn, data);
-		if (ret)
-			break;
-	}
-}
 /**
  * sparse_memory_present_with_active_regions - Call memory_present for each active range
  * @nid: The node to call memory_present for. If MAX_NUMNODES, all nodes will be used.
@@ -4421,6 +4409,34 @@ static inline void setup_nr_node_ids(void)
 }
 #endif
 
+/*
+ * Common iterator interface used to define for_each_mem_pfn_range().
+ */
+void __meminit __next_mem_pfn_range(int *idx, int nid,
+				    unsigned long *out_start_pfn,
+				    unsigned long *out_end_pfn, int *out_nid)
+{
+	struct node_active_region *r = NULL;
+
+	while (++*idx < nr_nodemap_entries) {
+		if (nid == MAX_NUMNODES || nid == early_node_map[*idx].nid) {
+			r = &early_node_map[*idx];
+			break;
+		}
+	}
+	if (!r) {
+		*idx = -1;
+		return;
+	}
+
+	if (out_start_pfn)
+		*out_start_pfn = r->start_pfn;
+	if (out_end_pfn)
+		*out_end_pfn = r->end_pfn;
+	if (out_nid)
+		*out_nid = r->nid;
+}
+
 /**
  * add_active_range - Register a range of PFNs backed by physical memory
  * @nid: The node ID the range resides on
