Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab2EKIfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:35:11 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49481 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab2EKIfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:35:02 -0400
MIME-Version: 1.0
Date: Fri, 11 May 2012 14:05:01 +0530
Message-ID: <CAEtiSau7w+aUf_pK39JS+-SgRRqHav4b1UZMiNFHCJTNPfN7EQ@mail.gmail.com>
Subject: [RFC][PATCH] mm: Update zone->un_reclaimable in direct reclaim path
From: Aaditya Kumar <aaditya.kumar.30@gmail.com>
To: linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com
Cc: frank.rowand@am.sony.com, tim.bird@am.sony.com, takuzo.ohara@ap.sony.com,
        kan.iibuchi@jp.sony.com, kosaki.motohiro@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

 Commit 929bea7c714220fc76ce3f75bef9056477c28e74 seems to have broken the
 OOM invocation during memory hot unplug in low memory conditions. This commit
 modifies the 'un-reclaimabilty check'  for  giving up trying to
reclaim pages in the
direct reclaim path and invoke OOM  killer to be based on zone->unreclaimable.

 While doing memory offline, if the memory to be off lined spans almost all the
 node then the memory needed to migrate pages for off lining can not
be allocated
 from the node that is being off lined as all pages are now in ISOLATED state
 (and also free).

 Since most pages are would be free due to pages having been migrated,
kswapd would
 not balance the zones as all zone watermarks would be OK and so
zone->un_reclaimable
 flag which is currently only set by kswapd will NOT be set.

 If page allocator has been passed the zones from above node(being
offlined) then
 OOM killer will never be invoked for low memory conditions because
buddy allocator
 will not allocate ISOLATED pages and direct reclaim path will not
give up trying
 because zone->unreclaimable flag would not be set for zone(s) in node
being off lined
 and thus resulting in a system hang.

The above issue is reproducible when off lining memory in low memory
conditions on ARM
systems for Cortex-A9, but the issue should be architecture independent.

This patch fixes this BUG by updating zone->unreclaimable in direct
reclaim path also.
---
  mm/vmscan.c |   11 	8 +	3 -	0 !
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1997,7 +1997,7 @@ restart:
  * scan then give up on it.
  */
 static void shrink_zones(int priority, struct zonelist *zonelist,
-					struct scan_control *sc)
+					struct scan_control *sc, int prev_nr_slab)
 {
 	struct zoneref *z;
 	struct zone *zone;
@@ -2033,6 +2033,8 @@ static void shrink_zones(int priority, s
 		}

 		shrink_zone(priority, zone, sc);
+		if (prev_nr_slab == 0 && !zone_reclaimable(zone))
+			zone->all_unreclaimable = 1;
 	}
 }

@@ -2091,6 +2093,7 @@ static unsigned long do_try_to_free_page
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long writeback_threshold;
+	int prev_nr_slab = 1;

 	get_mems_allowed();
 	delayacct_freepages_start();
@@ -2102,7 +2105,9 @@ static unsigned long do_try_to_free_page
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token(sc->mem_cgroup);
-		shrink_zones(priority, zonelist, sc);
+		shrink_zones(priority, zonelist, sc, prev_nr_slab);
+		prev_nr_slab = 1;
+
 		/*
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
@@ -2117,7 +2122,7 @@ static unsigned long do_try_to_free_page
 				lru_pages += zone_reclaimable_pages(zone);
 			}

-			shrink_slab(shrink, sc->nr_scanned, lru_pages);
+			prev_nr_slab = shrink_slab(shrink, sc->nr_scanned, lru_pages);
 			if (reclaim_state) {
 				sc->nr_reclaimed += reclaim_state->reclaimed_slab;
 				reclaim_state->reclaimed_slab = 0;

Regards,
Aaditya Kumar.
