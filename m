Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab0G2F3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 01:29:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52308 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab0G2F3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 01:29:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [PATCH 4/5] memcg: remove nid and zid argument from mem_cgroup_soft_limit_reclaim()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100729140700.4AA2.A69D9226@jp.fujitsu.com>
References: <20100729140700.4AA2.A69D9226@jp.fujitsu.com>
Message-Id: <20100729142810.4AB1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 29 Jul 2010 14:29:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_cgroup_soft_limit_reclaim() has zone, nid and zid argument. but nid
and zid can be calculated from zone. So remove it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>

---
 include/linux/memcontrol.h |    6 +++---
 mm/memcontrol.c            |    5 ++---
 mm/vmscan.c                |    7 ++-----
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9f1afd3..fd8ddbd 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -123,8 +123,8 @@ static inline bool mem_cgroup_disabled(void)
 
 void mem_cgroup_update_file_mapped(struct page *page, int val);
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
-						gfp_t gfp_mask, int nid,
-						int zid);
+					    gfp_t gfp_mask);
+
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -299,7 +299,7 @@ static inline void mem_cgroup_update_file_mapped(struct page *page,
 
 static inline
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
-					    gfp_t gfp_mask, int nid, int zid)
+					    gfp_t gfp_mask)
 {
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fee5cfa..b9ffc0c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2847,8 +2847,7 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
 }
 
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
-						gfp_t gfp_mask, int nid,
-						int zid)
+					    gfp_t gfp_mask)
 {
 	unsigned long nr_reclaimed = 0;
 	struct mem_cgroup_per_zone *mz, *next_mz = NULL;
@@ -2860,7 +2859,7 @@ unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 	if (order > 0)
 		return 0;
 
-	mctz = soft_limit_tree_node_zone(nid, zid);
+	mctz = soft_limit_tree_node_zone(zone_to_nid(zone), zone_idx(zone));
 	/*
 	 * This loop can run a while, specially if mem_cgroup's continuously
 	 * keep exceeding their soft limit and putting the system under
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5e37c84..6faae10 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2131,7 +2131,6 @@ loop_again:
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
 			int nr_slab;
-			int nid, zid;
 
 			if (!populated_zone(zone))
 				continue;
@@ -2141,14 +2140,12 @@ loop_again:
 
 			sc.nr_scanned = 0;
 
-			nid = pgdat->node_id;
-			zid = zone_idx(zone);
 			/*
 			 * Call soft limit reclaim before calling shrink_zone.
 			 * For now we ignore the return value
 			 */
-			mem_cgroup_soft_limit_reclaim(zone, order, sc.gfp_mask,
-							nid, zid);
+			mem_cgroup_soft_limit_reclaim(zone, order, sc.gfp_mask);
+
 			/*
 			 * We put equal pressure on every zone, unless one
 			 * zone has way too many pages free already.
-- 
1.6.5.2



