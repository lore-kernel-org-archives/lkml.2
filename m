Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2ENFBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 01:01:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63230 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2ENFBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 01:01:32 -0400
Date: Sun, 13 May 2012 22:01:15 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] mm: trivial cleanups in vmscan.c
In-Reply-To: <alpine.LSU.2.00.1205132152530.6148@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1205132200150.6148@eggly.anvils>
References: <alpine.LSU.2.00.1205132152530.6148@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Utter trivia in mm/vmscan.c, mostly just reducing the linecount slightly;
most exciting change being get_scan_count() calling vmscan_swappiness()
once instead of twice.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/vmscan.c |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

--- 3046N.orig/mm/vmscan.c	2012-05-13 20:41:24.334117380 -0700
+++ 3046N/mm/vmscan.c	2012-05-13 20:41:51.566118170 -0700
@@ -1025,12 +1025,9 @@ static unsigned long isolate_lru_pages(u
 		unsigned long *nr_scanned, struct scan_control *sc,
 		isolate_mode_t mode, enum lru_list lru)
 {
-	struct list_head *src;
+	struct list_head *src = &lruvec->lists[lru];
 	unsigned long nr_taken = 0;
 	unsigned long scan;
-	int file = is_file_lru(lru);
-
-	src = &lruvec->lists[lru];
 
 	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
 		struct page *page;
@@ -1058,11 +1055,8 @@ static unsigned long isolate_lru_pages(u
 	}
 
 	*nr_scanned = scan;
-
-	trace_mm_vmscan_lru_isolate(sc->order,
-			nr_to_scan, scan,
-			nr_taken,
-			mode, file);
+	trace_mm_vmscan_lru_isolate(sc->order, nr_to_scan, scan,
+				    nr_taken, mode, is_file_lru(lru));
 	return nr_taken;
 }
 
@@ -1140,8 +1134,7 @@ static int too_many_isolated(struct zone
 }
 
 static noinline_for_stack void
-putback_inactive_pages(struct lruvec *lruvec,
-		       struct list_head *page_list)
+putback_inactive_pages(struct lruvec *lruvec, struct list_head *page_list)
 {
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 	struct zone *zone = lruvec_zone(lruvec);
@@ -1235,11 +1228,9 @@ shrink_inactive_list(unsigned long nr_to
 	if (global_reclaim(sc)) {
 		zone->pages_scanned += nr_scanned;
 		if (current_is_kswapd())
-			__count_zone_vm_events(PGSCAN_KSWAPD, zone,
-					       nr_scanned);
+			__count_zone_vm_events(PGSCAN_KSWAPD, zone, nr_scanned);
 		else
-			__count_zone_vm_events(PGSCAN_DIRECT, zone,
-					       nr_scanned);
+			__count_zone_vm_events(PGSCAN_DIRECT, zone, nr_scanned);
 	}
 	spin_unlock_irq(&zone->lru_lock);
 
@@ -1534,9 +1525,9 @@ static int inactive_file_is_low(struct l
 	return inactive_file_is_low_global(lruvec_zone(lruvec));
 }
 
-static int inactive_list_is_low(struct lruvec *lruvec, int file)
+static int inactive_list_is_low(struct lruvec *lruvec, enum lru_list lru)
 {
-	if (file)
+	if (is_file_lru(lru))
 		return inactive_file_is_low(lruvec);
 	else
 		return inactive_anon_is_low(lruvec);
@@ -1545,10 +1536,8 @@ static int inactive_list_is_low(struct l
 static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
 				 struct lruvec *lruvec, struct scan_control *sc)
 {
-	int file = is_file_lru(lru);
-
 	if (is_active_lru(lru)) {
-		if (inactive_list_is_low(lruvec, file))
+		if (inactive_list_is_low(lruvec, lru))
 			shrink_active_list(nr_to_scan, lruvec, sc, lru);
 		return 0;
 	}
@@ -1630,7 +1619,7 @@ static void get_scan_count(struct lruvec
 	 * This scanning priority is essentially the inverse of IO cost.
 	 */
 	anon_prio = vmscan_swappiness(sc);
-	file_prio = 200 - vmscan_swappiness(sc);
+	file_prio = 200 - anon_prio;
 
 	/*
 	 * OK, so we have swap space and a fair amount of page cache
