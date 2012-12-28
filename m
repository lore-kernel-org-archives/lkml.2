Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab2L1T4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:56:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54957 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754354Ab2L1TRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:06 -0500
Message-Id: <20121228190401.828390911@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [ 164/173] Revert "mm: vmscan: fix endless loop in kswapd balancing"
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This reverts commit 39d18dc4b8b0c000fa681cbae10ac3f8a132814b which
was commit 60cefed485a02bd99b6299dad70666fe49245da7 upstream.

This was not needed and is not suitable for 3.2.y.

Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2492,19 +2492,6 @@
 }
 #endif
 
-static bool zone_balanced(struct zone *zone, int order,
-			  unsigned long balance_gap, int classzone_idx)
-{
-	if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone) +
-				    balance_gap, classzone_idx, 0))
-		return false;
-
-	if (COMPACTION_BUILD && order && !compaction_suitable(zone, order))
-		return false;
-
-	return true;
-}
-
 /*
  * pgdat_balanced is used when checking if a node is balanced for high-order
  * allocations. Only zones that meet watermarks and are in a zone allowed
@@ -2564,7 +2551,8 @@
 			continue;
 		}
 
-		if (!zone_balanced(zone, order, 0, i))
+		if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone),
+							i, 0))
 			all_zones_ok = false;
 		else
 			balanced += zone->present_pages;
@@ -2667,7 +2655,8 @@
 				shrink_active_list(SWAP_CLUSTER_MAX, zone,
 							&sc, priority, 0);
 
-			if (!zone_balanced(zone, order, 0, 0)) {
+			if (!zone_watermark_ok_safe(zone, order,
+					high_wmark_pages(zone), 0, 0)) {
 				end_zone = i;
 				break;
 			} else {
@@ -2728,8 +2717,9 @@
 				(zone->present_pages +
 					KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
 				KSWAPD_ZONE_BALANCE_GAP_RATIO);
-			if (!zone_balanced(zone, order,
-					   balance_gap, end_zone)) {
+			if (!zone_watermark_ok_safe(zone, order,
+					high_wmark_pages(zone) + balance_gap,
+					end_zone, 0)) {
 				shrink_zone(priority, zone, &sc);
 
 				reclaim_state->reclaimed_slab = 0;
@@ -2756,7 +2746,8 @@
 				continue;
 			}
 
-			if (!zone_balanced(zone, order, 0, end_zone)) {
+			if (!zone_watermark_ok_safe(zone, order,
+					high_wmark_pages(zone), end_zone, 0)) {
 				all_zones_ok = 0;
 				/*
 				 * We are still under min water mark.  This


