Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2G3RcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:32:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38517 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab2G3RcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:32:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [ 16/41] vmscan: abort reclaim/compaction if compaction can proceed
Date: Mon, 30 Jul 2012 10:31:15 -0700
Message-Id: <20120730172902.575124685@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120730172901.306897424@linuxfoundation.org>
References: <20120730172901.306897424@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit e0c23279c9f800c403f37511484d9014ac83adec upstream.

Stable note: Not tracked on Bugzilla. THP and compaction was found to
	aggressively reclaim pages and stall systems under different
	situations that was addressed piecemeal over time.

If compaction can proceed, shrink_zones() stops doing any work but its
callers still call shrink_slab() which raises the priority and potentially
sleeps.  This is unnecessary and wasteful so this patch aborts direct
reclaim/compaction entirely if compaction can proceed.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2037,14 +2037,19 @@ restart:
  *
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
+ *
+ * This function returns true if a zone is being reclaimed for a costly
+ * high-order allocation and compaction is either ready to begin or deferred.
+ * This indicates to the caller that it should retry the allocation or fail.
  */
-static void shrink_zones(int priority, struct zonelist *zonelist,
+static bool shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
+	bool should_abort_reclaim = false;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
@@ -2061,19 +2066,20 @@ static void shrink_zones(int priority, s
 				continue;	/* Let kswapd poll it */
 			if (COMPACTION_BUILD) {
 				/*
-				 * If we already have plenty of memory
-				 * free for compaction, don't free any
-				 * more.  Even though compaction is
-				 * invoked for any non-zero order,
-				 * only frequent costly order
-				 * reclamation is disruptive enough to
-				 * become a noticable problem, like
-				 * transparent huge page allocations.
+				 * If we already have plenty of memory free for
+				 * compaction in this zone, don't free any more.
+				 * Even though compaction is invoked for any
+				 * non-zero order, only frequent costly order
+				 * reclamation is disruptive enough to become a
+				 * noticable problem, like transparent huge page
+				 * allocations.
 				 */
 				if (sc->order > PAGE_ALLOC_COSTLY_ORDER &&
 					(compaction_suitable(zone, sc->order) ||
-					 compaction_deferred(zone)))
+					 compaction_deferred(zone))) {
+					should_abort_reclaim = true;
 					continue;
+				}
 			}
 			/*
 			 * This steals pages from memory cgroups over softlimit
@@ -2092,6 +2098,8 @@ static void shrink_zones(int priority, s
 
 		shrink_zone(priority, zone, sc);
 	}
+
+	return should_abort_reclaim;
 }
 
 static bool zone_reclaimable(struct zone *zone)
@@ -2156,7 +2164,9 @@ static unsigned long do_try_to_free_page
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token(sc->mem_cgroup);
-		shrink_zones(priority, zonelist, sc);
+		if (shrink_zones(priority, zonelist, sc))
+			break;
+
 		/*
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups


