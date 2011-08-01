Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab1HAX2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:28:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab1HAX17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:27:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:56 2011
Message-Id: <20110801232056.914258413@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:19:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, mgorman@suse.de,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: [63/70] mm: vmscan: do not apply pressure to slab if we are not applying pressure to zone
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit d7868dae893c83c50c7824bc2bc75f93d114669f upstream

During allocator-intensive workloads, kswapd will be woken frequently
causing free memory to oscillate between the high and min watermark.  This
is expected behaviour.

When kswapd applies pressure to zones during node balancing, it checks if
the zone is above a high+balance_gap threshold.  If it is, it does not
apply pressure but it unconditionally shrinks slab on a global basis which
is excessive.  In the event kswapd is being kept awake due to a high small
unreclaimable zone, it skips zone shrinking but still calls shrink_slab().

Once pressure has been applied, the check for zone being unreclaimable is
being made before the check is made if all_unreclaimable should be set.
This miss of unreclaimable can cause has_under_min_watermark_zone to be
set due to an unreclaimable zone preventing kswapd backing off on
congestion_wait().

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Pádraig Brady <P@draigBrady.com>
Tested-by: Pádraig Brady <P@draigBrady.com>
Tested-by: Andrew Lutomirski <luto@mit.edu>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 mm/vmscan.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2449,19 +2449,19 @@ loop_again:
 				KSWAPD_ZONE_BALANCE_GAP_RATIO);
 			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone) + balance_gap,
-					end_zone, 0))
+					end_zone, 0)) {
 				shrink_zone(priority, zone, &sc);
-			reclaim_state->reclaimed_slab = 0;
-			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
-						lru_pages);
-			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
-			total_scanned += sc.nr_scanned;
 
-			if (zone->all_unreclaimable)
-				continue;
-			if (nr_slab == 0 &&
-			    !zone_reclaimable(zone))
-				zone->all_unreclaimable = 1;
+				reclaim_state->reclaimed_slab = 0;
+				nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
+							lru_pages);
+				sc.nr_reclaimed += reclaim_state->reclaimed_slab;
+				total_scanned += sc.nr_scanned;
+
+				if (nr_slab == 0 && !zone_reclaimable(zone))
+					zone->all_unreclaimable = 1;
+			}
+
 			/*
 			 * If we've done a decent amount of scanning and
 			 * the reclaim ratio is low, start doing writepage
@@ -2471,6 +2471,9 @@ loop_again:
 			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
 				sc.may_writepage = 1;
 
+			if (zone->all_unreclaimable)
+				continue;
+
 			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone), end_zone, 0)) {
 				all_zones_ok = 0;


