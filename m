Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0FYJN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 05:13:26 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37733 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab0FYJNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 05:13:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH] vmscan: recalculate lru_pages on each priority
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100625181221.805A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 25 Jun 2010 18:13:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shrink_zones() need relatively long time. and lru_pages can be
changed dramatically while shrink_zones().
then, lru_pages need recalculate on each priority.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0c961f1..0ebfe12 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1785,7 +1785,6 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 	bool all_unreclaimable;
 	unsigned long total_scanned = 0;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
-	unsigned long lru_pages = 0;
 	struct zoneref *z;
 	struct zone *zone;
 	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
@@ -1796,18 +1795,6 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 
 	if (scanning_global_lru(sc))
 		count_vm_event(ALLOCSTALL);
-	/*
-	 * mem_cgroup will not do shrink_slab.
-	 */
-	if (scanning_global_lru(sc)) {
-		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
-
-			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
-				continue;
-
-			lru_pages += zone_reclaimable_pages(zone);
-		}
-	}
 
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
 		sc->nr_scanned = 0;
@@ -1819,6 +1806,14 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		 * over limit cgroups
 		 */
 		if (scanning_global_lru(sc)) {
+			unsigned long lru_pages = 0;
+			for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
+				if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
+					continue;
+
+				lru_pages += zone_reclaimable_pages(zone);
+			}
+
 			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages);
 			if (reclaim_state) {
 				sc->nr_reclaimed += reclaim_state->reclaimed_slab;
-- 
1.6.5.2



