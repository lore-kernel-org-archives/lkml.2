Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab1GFFZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 01:25:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38505 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab1GFFZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 01:25:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 6 Jul 2011 14:18:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] [Cleanup] memcg: export memory cgroup's swappiness v5
Message-Id: <20110706141825.2df34560.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110701161051.0ab237c5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110629190325.28aa2dc6.kamezawa.hiroyu@jp.fujitsu.com>
	<20110630130134.63a1dd37.akpm@linux-foundation.org>
	<20110701085013.4e8cbb02.kamezawa.hiroyu@jp.fujitsu.com>
	<20110701092059.be4400f7.kamezawa.hiroyu@jp.fujitsu.com>
	<20110630180653.1df10f38.akpm@linux-foundation.org>
	<20110701101624.a10b7e34.kamezawa.hiroyu@jp.fujitsu.com>
	<20110701103007.8110f130.kamezawa.hiroyu@jp.fujitsu.com>
	<20110701161051.0ab237c5.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jul 2011 16:10:51 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Sorry, this seems still buggy. I'll send a new one in the next week :(
> 

tested with allnoconfig, allyesconfig, CONFIG_SWAP=y/n,
CONFIG_CGROUP_MEM_RES_CTLR=y/n

Patch is onto mmotm-0630.

==
>From 7daf93a277e19026bb6edef3e0ac01bbd31dcb5e Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 1 Jul 2011 10:35:57 +0900
Subject: [PATCH] export memory cgroup's swappines by mem_cgroup_swappiness()

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
  - move definistions out of CONFIG_SWAP.
  - fixed/tested allyesconfig/allnoconfig compile failure.
  - adjusted signedness to vm_swappiness.
  - drop swappiness from scan_control
---
 include/linux/swap.h |   13 +++++++++----
 mm/memcontrol.c      |   15 +++++++--------
 mm/vmscan.c          |   23 ++++++++++-------------
 3 files changed, 26 insertions(+), 25 deletions(-)

Index: mmotm-0701/include/linux/swap.h
===================================================================
--- mmotm-0701.orig/include/linux/swap.h
+++ mmotm-0701/include/linux/swap.h
@@ -254,11 +254,9 @@ static inline void lru_cache_add_file(st
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
@@ -301,7 +299,14 @@ static inline void scan_unevictable_unre
 
 extern int kswapd_run(int nid);
 extern void kswapd_stop(int nid);
-
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+extern int mem_cgroup_swappiness(struct mem_cgroup *mem);
+#else
+static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
+{
+	return vm_swappiness;
+}
+#endif
 #ifdef CONFIG_SWAP
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct page *);
Index: mmotm-0701/mm/memcontrol.c
===================================================================
--- mmotm-0701.orig/mm/memcontrol.c
+++ mmotm-0701/mm/memcontrol.c
@@ -248,7 +248,7 @@ struct mem_cgroup {
 	atomic_t	oom_lock;
 	atomic_t	refcnt;
 
-	unsigned int	swappiness;
+	int	swappiness;
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
 
@@ -1328,7 +1328,7 @@ static unsigned long mem_cgroup_margin(s
 	return margin >> PAGE_SHIFT;
 }
 
-static unsigned int get_swappiness(struct mem_cgroup *memcg)
+int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
 	struct cgroup *cgrp = memcg->css.cgroup;
 
@@ -1775,12 +1775,11 @@ static int mem_cgroup_hierarchical_recla
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
@@ -3776,7 +3775,7 @@ try_to_free:
 			goto out;
 		}
 		progress = try_to_free_mem_cgroup_pages(mem, GFP_KERNEL,
-						false, get_swappiness(mem));
+						false);
 		if (!progress) {
 			nr_retries--;
 			/* maybe some writeback is necessary */
@@ -4238,7 +4237,7 @@ static u64 mem_cgroup_swappiness_read(st
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 
-	return get_swappiness(memcg);
+	return mem_cgroup_swappiness(memcg);
 }
 
 static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
@@ -4947,7 +4946,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	INIT_LIST_HEAD(&mem->oom_notify);
 
 	if (parent)
-		mem->swappiness = get_swappiness(parent);
+		mem->swappiness = mem_cgroup_swappiness(parent);
 	atomic_set(&mem->refcnt, 1);
 	mem->move_charge_at_immigrate = 0;
 	mutex_init(&mem->thresholds_lock);
Index: mmotm-0701/mm/vmscan.c
===================================================================
--- mmotm-0701.orig/mm/vmscan.c
+++ mmotm-0701/mm/vmscan.c
@@ -95,8 +95,6 @@ struct scan_control {
 	/* Can pages be swapped as part of reclaim? */
 	int may_swap;
 
-	int swappiness;
-
 	int order;
 
 	/*
@@ -1729,6 +1727,13 @@ static unsigned long shrink_list(enum lr
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
@@ -1789,8 +1794,8 @@ static void get_scan_count(struct zone *
 	 * With swappiness at 100, anonymous and file have the same priority.
 	 * This scanning priority is essentially the inverse of IO cost.
 	 */
-	anon_prio = sc->swappiness;
-	file_prio = 200 - sc->swappiness;
+	anon_prio = vmscan_swappiness(sc);
+	file_prio = 200 - vmscan_swappiness(sc);
 
 	/*
 	 * OK, so we have swap space and a fair amount of page cache
@@ -2179,7 +2184,6 @@ unsigned long try_to_free_pages(struct z
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.may_unmap = 1,
 		.may_swap = 1,
-		.swappiness = vm_swappiness,
 		.order = order,
 		.mem_cgroup = NULL,
 		.nodemask = nodemask,
@@ -2203,7 +2207,6 @@ unsigned long try_to_free_pages(struct z
 
 unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
-						unsigned int swappiness,
 						struct zone *zone,
 						unsigned long *nr_scanned)
 {
@@ -2213,7 +2216,6 @@ unsigned long mem_cgroup_shrink_node_zon
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
 		.may_swap = !noswap,
-		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem,
 	};
@@ -2242,8 +2244,7 @@ unsigned long mem_cgroup_shrink_node_zon
 
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
 					   gfp_t gfp_mask,
-					   bool noswap,
-					   unsigned int swappiness)
+					   bool noswap)
 {
 	struct zonelist *zonelist;
 	unsigned long nr_reclaimed;
@@ -2253,7 +2254,6 @@ unsigned long try_to_free_mem_cgroup_pag
 		.may_unmap = 1,
 		.may_swap = !noswap,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
-		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem_cont,
 		.nodemask = NULL, /* we don't care the placement */
@@ -2403,7 +2403,6 @@ static unsigned long balance_pgdat(pg_da
 		 * we want to put equal scanning pressure on each zone.
 		 */
 		.nr_to_reclaim = ULONG_MAX,
-		.swappiness = vm_swappiness,
 		.order = order,
 		.mem_cgroup = NULL,
 	};
@@ -2873,7 +2872,6 @@ unsigned long shrink_all_memory(unsigned
 		.may_writepage = 1,
 		.nr_to_reclaim = nr_to_reclaim,
 		.hibernation_mode = 1,
-		.swappiness = vm_swappiness,
 		.order = 0,
 	};
 	struct shrink_control shrink = {
@@ -3060,7 +3058,6 @@ static int __zone_reclaim(struct zone *z
 		.nr_to_reclaim = max_t(unsigned long, nr_pages,
 				       SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
-		.swappiness = vm_swappiness,
 		.order = order,
 	};
 	struct shrink_control shrink = {

