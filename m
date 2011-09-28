Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab1I1KCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 06:02:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab1I1KCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 06:02:20 -0400
Date: Wed, 28 Sep 2011 11:02:16 +0100
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Johannes Weiner <hannes@cmpxchg.org>,
        aarcange@redhat.com
Subject: Re: [PATCH v2 -mm] limit direct reclaim for higher order allocations
Message-ID: <20110928100216.GF11313@suse.de>
References: <20110927105246.164e2fc7@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110927105246.164e2fc7@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 10:52:46AM -0400, Rik van Riel wrote:
> When suffering from memory fragmentation due to unfreeable pages,
> THP page faults will repeatedly try to compact memory.  Due to
> the unfreeable pages, compaction fails.
> 
> Needless to say, at that point page reclaim also fails to create
> free contiguous 2MB areas.  However, that doesn't stop the current
> code from trying, over and over again, and freeing a minimum of
> 4MB (2UL << sc->order pages) at every single invocation.
> 
> This resulted in my 12GB system having 2-3GB free memory, a
> corresponding amount of used swap and very sluggish response times.
> 
> This can be avoided by having the direct reclaim code not reclaim
> from zones that already have plenty of free memory available for
> compaction.
> 
> If compaction still fails due to unmovable memory, doing additional
> reclaim will only hurt the system, not help.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> 

Because this patch improves things;

Acked-by: Mel Gorman <mgorman@suse.de>

That said, shrink_zones potentially returns having scanning
and reclaimed 0 pages. We still fall through to shrink_slab and
because we are reclaiming 0 pages, we loop over all priorities in
do_try_to_free_pages() and potentially even call wait_iff_congested. I
think this patch would be better if shrink_zones() returned true if
we did not reclaim because compaction was ready and returned early
from shrink_zones.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 117eb4d..ead9c94 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2061,14 +2061,19 @@ restart:
  *
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
+ *
+ * This function returns true if a zone is being reclaimed for a high-order
+ * allocation that will use compaction and compaction is ready to begin. This
+ * indicates to the caller that further reclaim is unnecessary.
  */
-static void shrink_zones(int priority, struct zonelist *zonelist,
+static bool shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
+	bool abort_reclaim_compaction = false;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
@@ -2090,8 +2095,10 @@ static void shrink_zones(int priority, struct zonelist *zonelist,
 				 */
 				if (sc->order > PAGE_ALLOC_COSTLY_ORDER &&
 					(compaction_suitable(zone, sc->order) ||
-					 compaction_deferred(zone)))
+					 compaction_deferred(zone))) {
+					abort_reclaim_compaction = true;
 					continue;
+				}
 			}
 			/*
 			 * This steals pages from memory cgroups over softlimit
@@ -2110,6 +2117,8 @@ static void shrink_zones(int priority, struct zonelist *zonelist,
 
 		shrink_zone(priority, zone, sc);
 	}
+
+	return abort_reclaim_compaction;
 }
 
 static bool zone_reclaimable(struct zone *zone)
@@ -2174,7 +2183,8 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token(sc->mem_cgroup);
-		shrink_zones(priority, zonelist, sc);
+		if (shrink_zones(priority, zonelist, sc))
+			break;
 		/*
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
