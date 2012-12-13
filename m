Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab2LMOf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:35:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44717 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826Ab2LMOKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:10:10 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 152/241] mm: vmscan: fix endless loop in kswapd balancing
Date: Thu, 13 Dec 2012 11:58:37 -0200
Message-Id: <1355407206-17100-153-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 mm/vmscan.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index cdfdfc5..610e725 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2277,6 +2277,19 @@ static void age_active_anon(struct zone *zone, struct scan_control *sc)
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
@@ -2336,8 +2349,7 @@ static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining,
 			continue;
 		}
 
-		if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone),
-							i, 0))
+		if (!zone_balanced(zone, order, 0, i))
 			all_zones_ok = false;
 		else
 			balanced += zone->present_pages;
@@ -2446,8 +2458,7 @@ loop_again:
 				break;
 			}
 
-			if (!zone_watermark_ok_safe(zone, order,
-					high_wmark_pages(zone), 0, 0)) {
+			if (!zone_balanced(zone, order, 0, 0)) {
 				end_zone = i;
 				break;
 			} else {
@@ -2523,9 +2534,8 @@ loop_again:
 				testorder = 0;
 
 			if ((buffer_heads_over_limit && is_highmem_idx(i)) ||
-				    !zone_watermark_ok_safe(zone, testorder,
-					high_wmark_pages(zone) + balance_gap,
-					end_zone, 0)) {
+			    !zone_balanced(zone, testorder,
+					   balance_gap, end_zone)) {
 				shrink_zone(zone, &sc);
 
 				reclaim_state->reclaimed_slab = 0;
@@ -2552,8 +2562,7 @@ loop_again:
 				continue;
 			}
 
-			if (!zone_watermark_ok_safe(zone, testorder,
-					high_wmark_pages(zone), end_zone, 0)) {
+			if (!zone_balanced(zone, testorder, 0, end_zone)) {
 				all_zones_ok = 0;
 				/*
 				 * We are still under min water mark.  This
-- 
1.7.9.5

