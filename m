Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab1EZF1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:27:01 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49835 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab1EZF07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:26:59 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 26 May 2011 14:20:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [RFC][PATCH v3 4/10] memcg: export swappiness
Message-Id: <20110526142008.2da02f47.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110526141047.dc828124.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110526141047.dc828124.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ying Han <yinghan@google.com>
change mem_cgroup's swappiness interface.

Now, memcg's swappiness interface is defined as 'static' and
the value is passed as an argument to try_to_free_xxxx...

This patch adds an function mem_cgroup_swappiness() and export it,
reduce arguments. This interface will be used in async reclaim, later.

I think an function is better than passing arguments because it's
clearer where the swappiness comes from to scan_control.

Changelog: v2->v3
  - added comments.

Signed-off-by: Ying Han <yinghan@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    2 ++
 include/linux/swap.h       |    4 +---
 mm/memcontrol.c            |   21 +++++++++++++--------
 mm/vmscan.c                |    9 ++++-----
 4 files changed, 20 insertions(+), 16 deletions(-)

Index: memcg_async/mm/memcontrol.c
===================================================================
--- memcg_async.orig/mm/memcontrol.c
+++ memcg_async/mm/memcontrol.c
@@ -1373,7 +1373,14 @@ static unsigned long mem_cgroup_margin(s
 	return margin >> PAGE_SHIFT;
 }
 
-static unsigned int get_swappiness(struct mem_cgroup *memcg)
+/**
+ * mem_cgroup_swappiness
+ * @memcg: the memcg
+ *
+ * Returnes user defined swappiness of memory cgroup. Root cgroup uses
+ * system's value always.
+ */
+unsigned int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
 	struct cgroup *cgrp = memcg->css.cgroup;
 
@@ -1818,14 +1825,13 @@ static int mem_cgroup_hierarchical_recla
 		/* we use swappiness of local cgroup */
 		if (check_soft) {
 			ret = mem_cgroup_shrink_node_zone(victim, gfp_mask,
-				noswap, get_swappiness(victim), zone,
-				&nr_scanned);
+				noswap, zone, &nr_scanned);
 			*total_scanned += nr_scanned;
 			mem_cgroup_soft_steal(victim, is_kswapd, ret);
 			mem_cgroup_soft_scan(victim, is_kswapd, nr_scanned);
 		} else
 			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
-						noswap, get_swappiness(victim));
+					noswap);
 		css_put(&victim->css);
 		/*
 		 * At shrinking usage, we can't check we should stop here or
@@ -3854,8 +3860,7 @@ try_to_free:
 			ret = -EINTR;
 			goto out;
 		}
-		progress = try_to_free_mem_cgroup_pages(mem, GFP_KERNEL,
-						false, get_swappiness(mem));
+		progress = try_to_free_mem_cgroup_pages(mem, GFP_KERNEL, false);
 		if (!progress) {
 			nr_retries--;
 			/* maybe some writeback is necessary */
@@ -4333,7 +4338,7 @@ static u64 mem_cgroup_swappiness_read(st
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 
-	return get_swappiness(memcg);
+	return mem_cgroup_swappiness(memcg);
 }
 
 static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
@@ -5041,7 +5046,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	INIT_LIST_HEAD(&mem->oom_notify);
 
 	if (parent)
-		mem->swappiness = get_swappiness(parent);
+		mem->swappiness = mem_cgroup_swappiness(parent);
 	atomic_set(&mem->refcnt, 1);
 	mem->move_charge_at_immigrate = 0;
 	mutex_init(&mem->thresholds_lock);
Index: memcg_async/include/linux/swap.h
===================================================================
--- memcg_async.orig/include/linux/swap.h
+++ memcg_async/include/linux/swap.h
@@ -252,11 +252,9 @@ static inline void lru_cache_add_file(st
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
-						  gfp_t gfp_mask, bool noswap,
-						  unsigned int swappiness);
+						  gfp_t gfp_mask, bool noswap);
 extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
-						unsigned int swappiness,
 						struct zone *zone,
 						unsigned long *nr_scanned);
 extern int __isolate_lru_page(struct page *page, int mode, int file);
Index: memcg_async/mm/vmscan.c
===================================================================
--- memcg_async.orig/mm/vmscan.c
+++ memcg_async/mm/vmscan.c
@@ -2182,7 +2182,6 @@ unsigned long try_to_free_pages(struct z
 
 unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
-						unsigned int swappiness,
 						struct zone *zone,
 						unsigned long *nr_scanned)
 {
@@ -2192,7 +2191,6 @@ unsigned long mem_cgroup_shrink_node_zon
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
 		.may_swap = !noswap,
-		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem,
 	};
@@ -2200,6 +2198,8 @@ unsigned long mem_cgroup_shrink_node_zon
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
 
+	sc.swappiness = mem_cgroup_swappiness(mem);
+
 	trace_mm_vmscan_memcg_softlimit_reclaim_begin(0,
 						      sc.may_writepage,
 						      sc.gfp_mask);
@@ -2221,8 +2221,7 @@ unsigned long mem_cgroup_shrink_node_zon
 
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
 					   gfp_t gfp_mask,
-					   bool noswap,
-					   unsigned int swappiness)
+					   bool noswap)
 {
 	struct zonelist *zonelist;
 	unsigned long nr_reclaimed;
@@ -2232,7 +2231,6 @@ unsigned long try_to_free_mem_cgroup_pag
 		.may_unmap = 1,
 		.may_swap = !noswap,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
-		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem_cont,
 		.nodemask = NULL, /* we don't care the placement */
@@ -2249,6 +2247,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	 * scan does not need to be the current node.
 	 */
 	nid = mem_cgroup_select_victim_node(mem_cont);
+	sc.swappiness = mem_cgroup_swappiness(mem_cont);
 
 	zonelist = NODE_DATA(nid)->node_zonelists;
 
Index: memcg_async/include/linux/memcontrol.h
===================================================================
--- memcg_async.orig/include/linux/memcontrol.h
+++ memcg_async/include/linux/memcontrol.h
@@ -112,6 +112,7 @@ int mem_cgroup_inactive_file_is_low(stru
 unsigned long
 mem_cgroup_zone_reclaimable_pages(struct mem_cgroup *memcg, int nid, int zid);
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
+unsigned int mem_cgroup_swappiness(struct mem_cgroup *memcg);
 unsigned long mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg,
 						struct zone *zone,
 						enum lru_list lru);
@@ -121,6 +122,7 @@ struct zone_reclaim_stat*
 mem_cgroup_get_reclaim_stat_from_page(struct page *page);
 extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
 					struct task_struct *p);
+
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
 #endif

