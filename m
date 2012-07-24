Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab2GXBMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:12:19 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57351 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab2GXBKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:10:21 -0400
X-AuditID: 9c93016f-b7b08ae00000790d-00-500df5f93a15
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 3/3] mm: remove redundant initialization
Date: Tue, 24 Jul 2012 10:10:35 +0900
Message-Id: <1343092235-13399-3-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343092235-13399-1-git-send-email-minchan@kernel.org>
References: <1343092235-13399-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pg_data_t should be zero out before reaching free_area_init_core
so remove unnecessary initialization.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/vmstat.h |    5 -----
 mm/page_alloc.c        |    9 ++-------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 65efb92..ad2cfd5 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -179,11 +179,6 @@ extern void zone_statistics(struct zone *, struct zone *, gfp_t gfp);
 #define add_zone_page_state(__z, __i, __d) mod_zone_page_state(__z, __i, __d)
 #define sub_zone_page_state(__z, __i, __d) mod_zone_page_state(__z, __i, -(__d))
 
-static inline void zap_zone_vm_stats(struct zone *zone)
-{
-	memset(zone->vm_stat, 0, sizeof(zone->vm_stat));
-}
-
 extern void inc_zone_state(struct zone *, enum zone_stat_item);
 
 #ifdef CONFIG_SMP
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2037eeb..7b09ecc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4376,6 +4376,8 @@ void __init set_pageblock_order(void)
  *   - mark all pages reserved
  *   - mark all memory queues empty
  *   - clear the memory bitmaps
+ *
+ * NOTE: pgdat should get zeroed by caller.
  */
 static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 		unsigned long *zones_size, unsigned long *zholes_size)
@@ -4386,10 +4388,8 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 	int ret;
 
 	pgdat_resize_init(pgdat);
-	pgdat->nr_zones = 0;
 	init_waitqueue_head(&pgdat->kswapd_wait);
 	init_waitqueue_head(&pgdat->pfmemalloc_wait);
-	pgdat->kswapd_max_order = 0;
 	pgdat_page_cgroup_init(pgdat);
 
 	for (j = 0; j < MAX_NR_ZONES; j++) {
@@ -4450,11 +4450,6 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 
 		zone_pcp_init(zone);
 		lruvec_init(&zone->lruvec, zone);
-		zap_zone_vm_stats(zone);
-		zone->flags = 0;
-#ifdef CONFIG_MEMORY_ISOLATION
-		zone->nr_pageblock_isolate = 0;
-#endif
 		if (!size)
 			continue;
 
-- 
1.7.9.5

