Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab1D0Hxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 03:53:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43786 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab1D0Hxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 03:53:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 27 Apr 2011 16:47:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        Ying Han <yinghan@google.com>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: [PATCHv3] memcg: fix get_scan_count for small targets
Message-Id: <20110427164708.1143395e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At memory reclaim, we determine the number of pages to be scanned
per zone as
	(anon + file) >> priority.
Assume 
	scan = (anon + file) >> priority.

If scan < SWAP_CLUSTER_MAX, the scan will be skipped for this time
and priority gets higher. This has some problems.

  1. This increases priority as 1 without any scan.
     To do scan in this priority, amount of pages should be larger than 512M.
     If pages>>priority < SWAP_CLUSTER_MAX, it's recorded and scan will be
     batched, later. (But we lose 1 priority.)
     If memory size is below 16M, pages >> priority is 0 and no scan in
     DEF_PRIORITY forever.

  2. If zone->all_unreclaimabe==true, it's scanned only when priority==0.
     So, x86's ZONE_DMA will never be recoverred until the user of pages
     frees memory by itself.

  3. With memcg, the limit of memory can be small. When using small memcg,
     it gets priority < DEF_PRIORITY-2 very easily and need to call
     wait_iff_congested().
     For doing scan before priorty=9, 64MB of memory should be used.

Then, this patch tries to scan SWAP_CLUSTER_MAX of pages in force...when

  1. the target is enough small.
  2. it's kswapd or memcg reclaim.

Then we can avoid rapid priority drop and may be able to recover
all_unreclaimable in a small zones. And this patch removes nr_saved_scan.
This will allow scanning in this priority even when pages >> priority
is very small.

Changelog v2->v3
  - removed nr_saved_scan completely.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/mmzone.h |    5 ----
 mm/page_alloc.c        |    4 ---
 mm/vmscan.c            |   60 ++++++++++++++++++++++++++-----------------------
 3 files changed, 34 insertions(+), 35 deletions(-)

Index: memcg/mm/vmscan.c
===================================================================
--- memcg.orig/mm/vmscan.c
+++ memcg/mm/vmscan.c
@@ -1700,26 +1700,6 @@ static unsigned long shrink_list(enum lr
 }
 
 /*
- * Smallish @nr_to_scan's are deposited in @nr_saved_scan,
- * until we collected @swap_cluster_max pages to scan.
- */
-static unsigned long nr_scan_try_batch(unsigned long nr_to_scan,
-				       unsigned long *nr_saved_scan)
-{
-	unsigned long nr;
-
-	*nr_saved_scan += nr_to_scan;
-	nr = *nr_saved_scan;
-
-	if (nr >= SWAP_CLUSTER_MAX)
-		*nr_saved_scan = 0;
-	else
-		nr = 0;
-
-	return nr;
-}
-
-/*
  * Determine how aggressively the anon and file LRU lists should be
  * scanned.  The relative value of each set of LRU lists is determined
  * by looking at the fraction of the pages scanned we did rotate back
@@ -1737,6 +1717,22 @@ static void get_scan_count(struct zone *
 	u64 fraction[2], denominator;
 	enum lru_list l;
 	int noswap = 0;
+	int force_scan = 0;
+
+
+	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
+		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
+	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
+		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
+
+	if (((anon + file) >> priority) < SWAP_CLUSTER_MAX) {
+		/* kswapd does zone balancing and need to scan this zone */
+		if (scanning_global_lru(sc) && current_is_kswapd())
+			force_scan = 1;
+		/* memcg may have small limit and need to avoid priority drop */
+		if (!scanning_global_lru(sc))
+			force_scan = 1;
+	}
 
 	/* If we have no swap space, do not bother scanning anon pages. */
 	if (!sc->may_swap || (nr_swap_pages <= 0)) {
@@ -1747,11 +1743,6 @@ static void get_scan_count(struct zone *
 		goto out;
 	}
 
-	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
-		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
-	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
-		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
-
 	if (scanning_global_lru(sc)) {
 		free  = zone_page_state(zone, NR_FREE_PAGES);
 		/* If we have very few page cache pages,
@@ -1818,8 +1809,23 @@ out:
 			scan >>= priority;
 			scan = div64_u64(scan * fraction[file], denominator);
 		}
-		nr[l] = nr_scan_try_batch(scan,
-					  &reclaim_stat->nr_saved_scan[l]);
+
+		/*
+		 * If zone is small or memcg is small, nr[l] can be 0.
+		 * This results no-scan on this priority and priority drop down.
+		 * For global direct reclaim, it can visit next zone and tend
+		 * not to have problems. For global kswapd, it's for zone
+		 * balancing and it need to scan a small amounts. When using
+		 * memcg, priority drop can cause big latency. So, it's better
+		 * to scan small amount. See may_noscan above.
+		 */
+		if (!scan && force_scan) {
+			if (file)
+				scan = SWAP_CLUSTER_MAX;
+			else if (!noswap)
+				scan = SWAP_CLUSTER_MAX;
+		}
+		nr[l] = scan;
 	}
 }
 
Index: memcg/include/linux/mmzone.h
===================================================================
--- memcg.orig/include/linux/mmzone.h
+++ memcg/include/linux/mmzone.h
@@ -273,11 +273,6 @@ struct zone_reclaim_stat {
 	 */
 	unsigned long		recent_rotated[2];
 	unsigned long		recent_scanned[2];
-
-	/*
-	 * accumulated for batching
-	 */
-	unsigned long		nr_saved_scan[NR_LRU_LISTS];
 };
 
 struct zone {
Index: memcg/mm/page_alloc.c
===================================================================
--- memcg.orig/mm/page_alloc.c
+++ memcg/mm/page_alloc.c
@@ -4256,10 +4256,8 @@ static void __paginginit free_area_init_
 		zone->zone_pgdat = pgdat;
 
 		zone_pcp_init(zone);
-		for_each_lru(l) {
+		for_each_lru(l)
 			INIT_LIST_HEAD(&zone->lru[l].list);
-			zone->reclaim_stat.nr_saved_scan[l] = 0;
-		}
 		zone->reclaim_stat.recent_rotated[0] = 0;
 		zone->reclaim_stat.recent_rotated[1] = 0;
 		zone->reclaim_stat.recent_scanned[0] = 0;

