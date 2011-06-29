Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab1F2KKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:10:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39086 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab1F2KKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:10:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 29 Jun 2011 19:03:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Subject: [PATCH] [Cleanup] memcg: export memory cgroup's swappiness v2
Message-Id: <20110629190325.28aa2dc6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is onto 3 patches I posted yesterday.
I'm sorry I once got Acks in v1 but refleshed totally. 
==
>From fda72071ee473be1caee163920da0f5c397c95e8 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 29 Jun 2011 18:24:49 +0900
Subject: [PATCH] export memory cgroup's swappines

Each memory cgroup has 'swappiness' value and it can be accessed by
get_swappiness(memcg). The major user is try_to_free_mem_cgroup_pages()
and swappiness is passed by argument. It's propagated by scan_control.

get_swappiness is static function but some planned updates will need to
get swappiness from files other than memcontrol.c
This patch exports get_swappiness() as mem_cgroup_swappiness().
By this, we can remove the argument of swapiness from try_to_free...
and drop swappiness from scan_control. only memcg uses it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Changelog:
  - drop swappiness from scan_control
---
 include/linux/swap.h |   10 +++++++---
 mm/memcontrol.c      |   13 ++++++-------
 mm/vmscan.c          |   23 ++++++++++-------------
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index a273468..aabcca4 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -252,11 +252,9 @@ static inline void lru_cache_add_file(struct page *page)
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
@@ -365,11 +363,17 @@ static inline void put_swap_token(struct mm_struct *mm)
 extern void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout);
 extern int mem_cgroup_count_swap_user(swp_entry_t ent, struct page **pagep);
+extern unsigned int mem_cgroup_swappiness(struct mem_cgroup *mem);
 #else
 static inline void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
 {
 }
+
+static inline unsigned int mem_cgroup_swappiness(struct mem_cgroup *mem)
+{
+	return vm_swappiness;
+}
 #endif
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern void mem_cgroup_uncharge_swap(swp_entry_t ent);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3e7d5e6..ae10796 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1330,7 +1330,7 @@ static unsigned long mem_cgroup_margin(struct mem_cgroup *mem)
 	return margin >> PAGE_SHIFT;
 }
 
-static unsigned int get_swappiness(struct mem_cgroup *memcg)
+unsigned int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
 	struct cgroup *cgrp = memcg->css.cgroup;
 
@@ -1776,12 +1776,11 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 		/* we use swappiness of local cgroup */
 		if (check_soft) {
 			ret = mem_cgroup_shrink_node_zone(victim, gfp_mask,
-				noswap, get_swappiness(victim), zone,
-				&nr_scanned);
+				noswap, zone, &nr_scanned);
 			*total_scanned += nr_scanned;
 		} else
 			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
-						noswap, get_swappiness(victim));
+						noswap);
 		css_put(&victim->css);
 		/*
 		 * At shrinking usage, we can't check we should stop here or
@@ -3826,7 +3825,7 @@ try_to_free:
 			goto out;
 		}
 		progress = try_to_free_mem_cgroup_pages(mem, GFP_KERNEL,
-						false, get_swappiness(mem));
+						false);
 		if (!progress) {
 			nr_retries--;
 			/* maybe some writeback is necessary */
@@ -4288,7 +4287,7 @@ static u64 mem_cgroup_swappiness_read(struct cgroup *cgrp, struct cftype *cft)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 
-	return get_swappiness(memcg);
+	return mem_cgroup_swappiness(memcg);
 }
 
 static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
@@ -4997,7 +4996,7 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 	INIT_LIST_HEAD(&mem->oom_notify);
 
 	if (parent)
-		mem->swappiness = get_swappiness(parent);
+		mem->swappiness = mem_cgroup_swappiness(parent);
 	atomic_set(&mem->refcnt, 1);
 	mem->move_charge_at_immigrate = 0;
 	mutex_init(&mem->thresholds_lock);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4f49535..fb37699 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -95,8 +95,6 @@ struct scan_control {
 	/* Can pages be swapped as part of reclaim? */
 	int may_swap;
 
-	int swappiness;
-
 	int order;
 
 	/*
@@ -1729,6 +1727,13 @@ static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
 	return shrink_inactive_list(nr_to_scan, zone, sc, priority, file);
 }
 
+static int vmscan_swappiness(struct scan_control *sc)
+{
+	if (scanning_global_lru(sc))
+		return vm_swappiness;
+	return mem_cgroup_swappiness(sc->mem_cgroup);
+}
+
 /*
  * Determine how aggressively the anon and file LRU lists should be
  * scanned.  The relative value of each set of LRU lists is determined
@@ -1789,8 +1794,8 @@ static void get_scan_count(struct zone *zone, struct scan_control *sc,
 	 * With swappiness at 100, anonymous and file have the same priority.
 	 * This scanning priority is essentially the inverse of IO cost.
 	 */
-	anon_prio = sc->swappiness;
-	file_prio = 200 - sc->swappiness;
+	anon_prio = vmscan_swappiness(sc);
+	file_prio = 200 - vmscan_swappiness(sc);
 
 	/*
 	 * OK, so we have swap space and a fair amount of page cache
@@ -2179,7 +2184,6 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.may_unmap = 1,
 		.may_swap = 1,
-		.swappiness = vm_swappiness,
 		.order = order,
 		.mem_cgroup = NULL,
 		.nodemask = nodemask,
@@ -2203,7 +2207,6 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 
 unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
-						unsigned int swappiness,
 						struct zone *zone,
 						unsigned long *nr_scanned)
 {
@@ -2213,7 +2216,6 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
 		.may_swap = !noswap,
-		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem,
 	};
@@ -2242,8 +2244,7 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
 					   gfp_t gfp_mask,
-					   bool noswap,
-					   unsigned int swappiness)
+					   bool noswap)
 {
 	struct zonelist *zonelist;
 	unsigned long nr_reclaimed;
@@ -2253,7 +2254,6 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
 		.may_unmap = 1,
 		.may_swap = !noswap,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
-		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem_cont,
 		.nodemask = NULL, /* we don't care the placement */
@@ -2403,7 +2403,6 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
 		 * we want to put equal scanning pressure on each zone.
 		 */
 		.nr_to_reclaim = ULONG_MAX,
-		.swappiness = vm_swappiness,
 		.order = order,
 		.mem_cgroup = NULL,
 	};
@@ -2862,7 +2861,6 @@ unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
 		.may_writepage = 1,
 		.nr_to_reclaim = nr_to_reclaim,
 		.hibernation_mode = 1,
-		.swappiness = vm_swappiness,
 		.order = 0,
 	};
 	struct shrink_control shrink = {
@@ -3049,7 +3047,6 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		.nr_to_reclaim = max_t(unsigned long, nr_pages,
 				       SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
-		.swappiness = vm_swappiness,
 		.order = order,
 	};
 	struct shrink_control shrink = {
-- 
1.7.4.1


