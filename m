Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab0G2F2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 01:28:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52253 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab0G2F23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 01:28:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [PATCH 3/5] memcg: mem_cgroup_shrink_node_zone() doesn't need sc.nodemask
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100729140700.4AA2.A69D9226@jp.fujitsu.com>
References: <20100729140700.4AA2.A69D9226@jp.fujitsu.com>
Message-Id: <20100729142735.4AAE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 29 Jul 2010 14:28:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently mem_cgroup_shrink_node_zone() call shrink_zone() directly.
thus it doesn't need to initialize sc.nodemask because shrink_zone()
doesn't use it at all.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/swap.h |    3 +--
 mm/memcontrol.c      |    3 +--
 mm/vmscan.c          |    5 +----
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index ff4acea..bf4eb62 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -244,8 +244,7 @@ extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
 extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						unsigned int swappiness,
-						struct zone *zone,
-						int nid);
+						struct zone *zone);
 extern int __isolate_lru_page(struct page *page, int mode, int file);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2600776..fee5cfa 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1282,8 +1282,7 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 		/* we use swappiness of local cgroup */
 		if (check_soft)
 			ret = mem_cgroup_shrink_node_zone(victim, gfp_mask,
-				noswap, get_swappiness(victim), zone,
-				zone->zone_pgdat->node_id);
+				noswap, get_swappiness(victim), zone);
 		else
 			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
 						noswap, get_swappiness(victim));
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 102ee3a..5e37c84 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1932,7 +1932,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						unsigned int swappiness,
-						struct zone *zone, int nid)
+						struct zone *zone)
 {
 	struct scan_control sc = {
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
@@ -1943,11 +1943,8 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 		.order = 0,
 		.mem_cgroup = mem,
 	};
-	nodemask_t nm  = nodemask_of_node(nid);
-
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
-	sc.nodemask = &nm;
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_begin(0,
 						      sc.may_writepage,
-- 
1.6.5.2



