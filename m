Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab2HBGDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:03:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26224 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab2HBGBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:01:12 -0400
X-IronPort-AV: E=Sophos;i="4.77,698,1336320000"; 
   d="scan'208";a="5534632"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org
Subject: [RFC PATCH 13/23 V2] page_alloc: use N_MEMORY instead N_HIGH_MEMORY change the node_states initialization
Date: Thu, 2 Aug 2012 14:01:18 +0800
Message-Id: <1343887288-8866-14-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
References: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/02 14:01:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/02 14:01:42,
	Serialize complete at 2012/08/02 14:01:42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Since we introduced N_MEMORY, we update the initialization of node_states.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 arch/x86/mm/init_64.c |    4 +++-
 mm/page_alloc.c       |   40 ++++++++++++++++++++++------------------
 2 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 2b6b4a3..005f00c 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -625,7 +625,9 @@ void __init paging_init(void)
 	 *	 numa support is not compiled in, and later node_set_state
 	 *	 will not set it back.
 	 */
-	node_clear_state(0, N_NORMAL_MEMORY);
+	node_clear_state(0, N_MEMORY);
+	if (N_MEMORY != N_NORMAL_MEMORY)
+		node_clear_state(0, N_NORMAL_MEMORY);
 
 	zone_sizes_init();
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4a4f921..0571f2a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1646,7 +1646,7 @@ bool zone_watermark_ok_safe(struct zone *z, int order, unsigned long mark,
  *
  * If the zonelist cache is present in the passed in zonelist, then
  * returns a pointer to the allowed node mask (either the current
- * tasks mems_allowed, or node_states[N_HIGH_MEMORY].)
+ * tasks mems_allowed, or node_states[N_MEMORY].)
  *
  * If the zonelist cache is not available for this zonelist, does
  * nothing and returns NULL.
@@ -1675,7 +1675,7 @@ static nodemask_t *zlc_setup(struct zonelist *zonelist, int alloc_flags)
 
 	allowednodes = !in_interrupt() && (alloc_flags & ALLOC_CPUSET) ?
 					&cpuset_current_mems_allowed :
-					&node_states[N_HIGH_MEMORY];
+					&node_states[N_MEMORY];
 	return allowednodes;
 }
 
@@ -3070,7 +3070,7 @@ static int find_next_best_node(int node, nodemask_t *used_node_mask)
 		return node;
 	}
 
-	for_each_node_state(n, N_HIGH_MEMORY) {
+	for_each_node_state(n, N_MEMORY) {
 
 		/* Don't want a node to appear more than once */
 		if (node_isset(n, *used_node_mask))
@@ -3212,7 +3212,7 @@ static int default_zonelist_order(void)
  	 * local memory, NODE_ORDER may be suitable.
          */
 	average_size = total_size /
-				(nodes_weight(node_states[N_HIGH_MEMORY]) + 1);
+				(nodes_weight(node_states[N_MEMORY]) + 1);
 	for_each_online_node(nid) {
 		low_kmem_size = 0;
 		total_size = 0;
@@ -4587,7 +4587,7 @@ unsigned long __init find_min_pfn_with_active_regions(void)
 /*
  * early_calculate_totalpages()
  * Sum pages in active regions for movable zone.
- * Populate N_HIGH_MEMORY for calculating usable_nodes.
+ * Populate N_MEMORY for calculating usable_nodes.
  */
 static unsigned long __init early_calculate_totalpages(void)
 {
@@ -4600,7 +4600,7 @@ static unsigned long __init early_calculate_totalpages(void)
 
 		totalpages += pages;
 		if (pages)
-			node_set_state(nid, N_HIGH_MEMORY);
+			node_set_state(nid, N_MEMORY);
 	}
   	return totalpages;
 }
@@ -4617,9 +4617,9 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 	unsigned long usable_startpfn;
 	unsigned long kernelcore_node, kernelcore_remaining;
 	/* save the state before borrow the nodemask */
-	nodemask_t saved_node_state = node_states[N_HIGH_MEMORY];
+	nodemask_t saved_node_state = node_states[N_MEMORY];
 	unsigned long totalpages = early_calculate_totalpages();
-	int usable_nodes = nodes_weight(node_states[N_HIGH_MEMORY]);
+	int usable_nodes = nodes_weight(node_states[N_MEMORY]);
 
 	/*
 	 * If movablecore was specified, calculate what size of
@@ -4654,7 +4654,7 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 restart:
 	/* Spread kernelcore memory as evenly as possible throughout nodes */
 	kernelcore_node = required_kernelcore / usable_nodes;
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		unsigned long start_pfn, end_pfn;
 
 		/*
@@ -4746,23 +4746,27 @@ restart:
 
 out:
 	/* restore the node_state */
-	node_states[N_HIGH_MEMORY] = saved_node_state;
+	node_states[N_MEMORY] = saved_node_state;
 }
 
-/* Any regular memory on that node ? */
-static void check_for_regular_memory(pg_data_t *pgdat)
+/* Any regular or high memory on that node ? */
+static void check_for_memory(pg_data_t *pgdat, int nid)
 {
-#ifdef CONFIG_HIGHMEM
 	enum zone_type zone_type;
 
-	for (zone_type = 0; zone_type <= ZONE_NORMAL; zone_type++) {
+	if (N_MEMORY == N_NORMAL_MEMORY)
+		return;
+
+	for (zone_type = 0; zone_type <= ZONE_MOVABLE - 1; zone_type++) {
 		struct zone *zone = &pgdat->node_zones[zone_type];
 		if (zone->present_pages) {
-			node_set_state(zone_to_nid(zone), N_NORMAL_MEMORY);
+			node_set_state(nid, N_HIGH_MEMORY);
+			if (N_NORMAL_MEMORY != N_HIGH_MEMORY &&
+			    zone_type <= ZONE_NORMAL)
+				node_set_state(nid, N_NORMAL_MEMORY);
 			break;
 		}
 	}
-#endif
 }
 
 /**
@@ -4845,8 +4849,8 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
 
 		/* Any memory on that node */
 		if (pgdat->node_present_pages)
-			node_set_state(nid, N_HIGH_MEMORY);
-		check_for_regular_memory(pgdat);
+			node_set_state(nid, N_MEMORY);
+		check_for_memory(pgdat, nid);
 	}
 }
 
-- 
1.7.1

