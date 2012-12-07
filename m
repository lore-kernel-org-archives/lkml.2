Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424067Ab2LGBFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:05:55 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40159 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423480Ab2LGA7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:59:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johannes Weiner <hannes@cmpxchg.org>,
        George Spelvin <linux@horizon.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        Tomas Racek <tracek@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 07/27] mm: vmscan: fix endless loop in kswapd balancing
Date: Thu,  6 Dec 2012 16:58:51 -0800
Message-Id: <20121207005827.599339384@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005825.232489605@linuxfoundation.org>
References: <20121207005825.232489605@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 60cefed485a02bd99b6299dad70666fe49245da7 upstream.

Kswapd does not in all places have the same criteria for a balanced
zone.  Zones are only being reclaimed when their high watermark is
breached, but compaction checks loop over the zonelist again when the
zone does not meet the low watermark plus two times the size of the
allocation.  This gets kswapd stuck in an endless loop over a small
zone, like the DMA zone, where the high watermark is smaller than the
compaction requirement.

Add a function, zone_balanced(), that checks the watermark, and, for
higher order allocations, if compaction has enough free memory.  Then
use it uniformly to check for balanced zones.

This makes sure that when the compaction watermark is not met, at least
reclaim happens and progress is made - or the zone is declared
unreclaimable at some point and skipped entirely.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: George Spelvin <linux@horizon.com>
Reported-by: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Reported-by: Tomas Racek <tracek@redhat.com>
Tested-by: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2383,6 +2383,19 @@ static void age_active_anon(struct zone
 	} while (memcg);
 }
 
+static bool zone_balanced(struct zone *zone, int order,
+			  unsigned long balance_gap, int classzone_idx)
+{
+	if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone) +
+				    balance_gap, classzone_idx, 0))
+		return false;
+
+	if (COMPACTION_BUILD && order && !compaction_suitable(zone, order))
+		return false;
+
+	return true;
+}
+
 /*
  * pgdat_balanced is used when checking if a node is balanced for high-order
  * allocations. Only zones that meet watermarks and are in a zone allowed
@@ -2461,8 +2474,7 @@ static bool prepare_kswapd_sleep(pg_data
 			continue;
 		}
 
-		if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone),
-							i, 0))
+		if (!zone_balanced(zone, order, 0, i))
 			all_zones_ok = false;
 		else
 			balanced += zone->present_pages;
@@ -2571,8 +2583,7 @@ loop_again:
 				break;
 			}
 
-			if (!zone_watermark_ok_safe(zone, order,
-					high_wmark_pages(zone), 0, 0)) {
+			if (!zone_balanced(zone, order, 0, 0)) {
 				end_zone = i;
 				break;
 			} else {
@@ -2648,9 +2659,8 @@ loop_again:
 				testorder = 0;
 
 			if ((buffer_heads_over_limit && is_highmem_idx(i)) ||
-				    !zone_watermark_ok_safe(zone, testorder,
-					high_wmark_pages(zone) + balance_gap,
-					end_zone, 0)) {
+			    !zone_balanced(zone, testorder,
+					   balance_gap, end_zone)) {
 				shrink_zone(zone, &sc);
 
 				reclaim_state->reclaimed_slab = 0;
@@ -2677,8 +2687,7 @@ loop_again:
 				continue;
 			}
 
-			if (!zone_watermark_ok_safe(zone, testorder,
-					high_wmark_pages(zone), end_zone, 0)) {
+			if (!zone_balanced(zone, testorder, 0, end_zone)) {
 				all_zones_ok = 0;
 				/*
 				 * We are still under min water mark.  This


