Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab1DZJYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:24:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50384 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab1DZJYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:24:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 26 Apr 2011 18:17:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        "mgorman@suse.de" <mgorman@suse.de>, Ying Han <yinghan@google.com>
Subject: [PATCH] fix get_scan_count for working well with small targets
Message-Id: <20110426181724.f8cdad57.kamezawa.hiroyu@jp.fujitsu.com>
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

If scan < SWAP_CLUSTER_MAX, shlink_list will be skipped for this
priority and results no-sacn.  This has some problems.

  1. This increases priority as 1 without any scan.
     To do scan in DEF_PRIORITY always, amount of pages should be larger than
     512M. If pages>>priority < SWAP_CLUSTER_MAX, it's recorded and scan will be
     batched, later. (But we lose 1 priority.)
     But if the amount of pages is smaller than 16M, no scan at priority==0
     forever.

  2. If zone->all_unreclaimabe==true, it's scanned only when priority==0.
     So, x86's ZONE_DMA will never be recoverred until the user of pages
     frees memory by itself.

  3. With memcg, the limit of memory can be small. When using small memcg,
     it gets priority < DEF_PRIORITY-2 very easily and need to call
     wait_iff_congested().
     For doing scan before priorty=9, 64MB of memory should be used.

This patch tries to scan SWAP_CLUSTER_MAX of pages in force...when

  1. the target is enough small.
  2. it's kswapd or memcg reclaim.

Then we can avoid rapid priority drop and may be able to recover
all_unreclaimable in a small zones.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/vmscan.c |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

Index: memcg/mm/vmscan.c
===================================================================
--- memcg.orig/mm/vmscan.c
+++ memcg/mm/vmscan.c
@@ -1737,6 +1737,16 @@ static void get_scan_count(struct zone *
 	u64 fraction[2], denominator;
 	enum lru_list l;
 	int noswap = 0;
+	int may_noscan = 0;
+
+
+	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
+		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
+	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
+		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
+
+	if (((anon + file) >> priority) < SWAP_CLUSTER_MAX)
+		may_noscan = 1;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
 	if (!sc->may_swap || (nr_swap_pages <= 0)) {
@@ -1747,11 +1757,6 @@ static void get_scan_count(struct zone *
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
@@ -1814,10 +1819,26 @@ out:
 		unsigned long scan;
 
 		scan = zone_nr_lru_pages(zone, sc, l);
+
 		if (priority || noswap) {
 			scan >>= priority;
 			scan = div64_u64(scan * fraction[file], denominator);
 		}
+
+		if (!scan &&
+		    may_noscan &&
+		    (current_is_kswapd() || !scanning_global_lru(sc))) {
+			/*
+ 			 * if we do target scan, the whole amount of memory
+ 			 * can be too small to scan with low priority value.
+ 			 * This raise up priority rapidly without any scan.
+ 			 * Avoid that and give some scan.
+ 			 */
+			if (file)
+				scan = SWAP_CLUSTER_MAX;
+			else if (!noswap && (fraction[anon] > fraction[file]*16))
+				scan = SWAP_CLUSTER_MAX;
+		}
 		nr[l] = nr_scan_try_batch(scan,
 					  &reclaim_stat->nr_saved_scan[l]);
 	}

