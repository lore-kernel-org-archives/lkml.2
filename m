Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab1F0IwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 04:52:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35335 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab1F0IuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 04:50:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 27 Jun 2011 17:42:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>
Subject: [BUGFIX][PATCH] Fix direct softlimit reclaim to be called in memcg
 limit path.
Message-Id: <20110627174205.ccee1027.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 702df89e4cd8e7734223c367ebc56d47afea403a Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 27 Jun 2011 17:24:54 +0900
Subject: [PATCH] Fix direct softlimit reclaim to be called in memcg limit path.

commit d149e3b(memcg: add the soft_limit reclaim in global direct reclaim)
adds a softlimit hook to shrink_zones(). By this, soft limit is called
as

   try_to_free_pages()
       do_try_to_free_pages()
           shrink_zones()
               mem_cgroup_soft_limit_reclaim()

Then, direct reclaim is memcg softlimit hint aware, now.

But, the memory cgroup's "limit" path can call softlimit shrinker.

   try_to_free_mem_cgroup_pages()
       do_try_to_free_pages()
           shrink_zones()
               mem_cgroup_soft_limit_reclaim()

This will cause a global reclaim when a memcg hits limit.

This is bug. soft_limit_reclaim() should be called when
scanning_global_lru(sc) == true.

And the commit adds a variable "total_scanned" for counting
softlimit scanned pages....it's not "total".
This patch removes the variable and update sc->nr_scanned
instead of it. This will affect shrink_slab()'s scan condition
but, global LRU is scanned by softlimit and I think this change makes
sense.

TODO
  - avoid too much scan in a zone when softlimit did enough jobs.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/vmscan.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8ff834e..4f49535 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1995,14 +1995,13 @@ restart:
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
  */
-static unsigned long shrink_zones(int priority, struct zonelist *zonelist,
+static void shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
-	unsigned long total_scanned = 0;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
@@ -2017,19 +2016,23 @@ static unsigned long shrink_zones(int priority, struct zonelist *zonelist,
 				continue;
 			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;	/* Let kswapd poll it */
+			/*
+			 * This steals pages from memory cgroups over softlimit
+			 * and returns the number of reclaimed pages and
+			 * scanned pages. This works for global memory pressure
+			 * and balancing, not for a memcg's limit.
+			 */
+			nr_soft_scanned = 0;
+			nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(zone,
+						sc->order, sc->gfp_mask,
+						&nr_soft_scanned);
+			sc->nr_reclaimed += nr_soft_reclaimed;
+			sc->nr_scanned += nr_soft_scanned;
+			/* need some check for avoid more shrink_zone() */
 		}
 
-		nr_soft_scanned = 0;
-		nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(zone,
-							sc->order, sc->gfp_mask,
-							&nr_soft_scanned);
-		sc->nr_reclaimed += nr_soft_reclaimed;
-		total_scanned += nr_soft_scanned;
-
 		shrink_zone(priority, zone, sc);
 	}
-
-	return total_scanned;
 }
 
 static bool zone_reclaimable(struct zone *zone)
@@ -2094,7 +2097,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token(sc->mem_cgroup);
-		total_scanned += shrink_zones(priority, zonelist, sc);
+		shrink_zones(priority, zonelist, sc);
 		/*
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
-- 
1.7.4.1


