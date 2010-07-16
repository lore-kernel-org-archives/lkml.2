Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968Ab0GPKPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 06:15:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33376 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964921Ab0GPKPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 06:15:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Subject: [PATCH 3/7] memcg: nid and zid can be calculated from zone
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100716191006.7369.A69D9226@jp.fujitsu.com>
References: <20100716191006.7369.A69D9226@jp.fujitsu.com>
Message-Id: <20100716191418.7372.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 16 Jul 2010 19:15:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mem_cgroup_soft_limit_reclaim() has zone, nid and zid argument. but nid
and zid can be calculated from zone. So remove it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    6 +++---
 include/linux/mmzone.h     |    5 +++++
 mm/memcontrol.c            |    5 ++---
 mm/vmscan.c                |    7 ++-----
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9411d32..9dec218 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -128,8 +128,8 @@ static inline bool mem_cgroup_disabled(void)
 
 void mem_cgroup_update_file_mapped(struct page *page, int val);
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
-						gfp_t gfp_mask, int nid,
-						int zid);
+					    gfp_t gfp_mask);
+
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -304,7 +304,7 @@ static inline void mem_cgroup_update_file_mapped(struct page *page,
 
 static inline
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
-					    gfp_t gfp_mask, int nid, int zid)
+					    gfp_t gfp_mask)
 {
 	return 0;
 }
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9ed9c45..34ac27a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -684,6 +684,11 @@ unsigned long __init node_memmap_size_bytes(int, unsigned long, unsigned long);
  */
 #define zone_idx(zone)		((zone) - (zone)->zone_pgdat->node_zones)
 
+static inline int zone_nid(struct zone *zone)
+{
+	return zone->zone_pgdat->node_id;
+}
+
 static inline int populated_zone(struct zone *zone)
 {
 	return (!!zone->present_pages);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 01f38ff..81bc9bf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2833,8 +2833,7 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
 }
 
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
-						gfp_t gfp_mask, int nid,
-						int zid)
+					    gfp_t gfp_mask)
 {
 	unsigned long nr_reclaimed = 0;
 	struct mem_cgroup_per_zone *mz, *next_mz = NULL;
@@ -2846,7 +2845,7 @@ unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 	if (order > 0)
 		return 0;
 
-	mctz = soft_limit_tree_node_zone(nid, zid);
+	mctz = soft_limit_tree_node_zone(zone_nid(zone), zone_idx(zone));
 	/*
 	 * This loop can run a while, specially if mem_cgroup's continuously
 	 * keep exceeding their soft limit and putting the system under
diff --git a/mm/vmscan.c b/mm/vmscan.c
index be860a0..89b4287 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2121,7 +2121,6 @@ loop_again:
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
 			int nr_slab;
-			int nid, zid;
 
 			if (!populated_zone(zone))
 				continue;
@@ -2133,14 +2132,12 @@ loop_again:
 			sc.nr_scanned = 0;
 			note_zone_scanning_priority(zone, priority);
 
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



