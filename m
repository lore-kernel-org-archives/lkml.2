Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0LJObK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 09:31:10 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:50111 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab0LJObJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 09:31:09 -0500
Subject: [PATCH 2/3] Refactor zone_reclaim (v2)
To: linux-mm@kvack.org, akpm@linux-foundation.org
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: npiggin@kernel.dk, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com
Date: Fri, 10 Dec 2010 20:01:02 +0530
Message-ID: <20101210143018.29934.11893.stgit@localhost6.localdomain6>
In-Reply-To: <20101210142745.29934.29186.stgit@localhost6.localdomain6>
References: <20101210142745.29934.29186.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move reusable functionality outside of zone_reclaim.
Make zone_reclaim_unmapped_pages modular

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---
 mm/vmscan.c |   35 +++++++++++++++++++++++------------
 1 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e841cae..4e2ad05 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2815,6 +2815,27 @@ static long zone_pagecache_reclaimable(struct zone *zone)
 }
 
 /*
+ * Helper function to reclaim unmapped pages, we might add something
+ * similar to this for slab cache as well. Currently this function
+ * is shared with __zone_reclaim()
+ */
+static inline void
+zone_reclaim_unmapped_pages(struct zone *zone, struct scan_control *sc,
+				unsigned long nr_pages)
+{
+	int priority;
+	/*
+	 * Free memory by calling shrink zone with increasing
+	 * priorities until we have enough memory freed.
+	 */
+	priority = ZONE_RECLAIM_PRIORITY;
+	do {
+		shrink_zone(priority, zone, sc);
+		priority--;
+	} while (priority >= 0 && sc->nr_reclaimed < nr_pages);
+}
+
+/*
  * Try to free up some pages from this zone through reclaim.
  */
 static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
@@ -2823,7 +2844,6 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	const unsigned long nr_pages = 1 << order;
 	struct task_struct *p = current;
 	struct reclaim_state reclaim_state;
-	int priority;
 	struct scan_control sc = {
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
 		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
@@ -2847,17 +2867,8 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
-	if (zone_pagecache_reclaimable(zone) > zone->min_unmapped_pages) {
-		/*
-		 * Free memory by calling shrink zone with increasing
-		 * priorities until we have enough memory freed.
-		 */
-		priority = ZONE_RECLAIM_PRIORITY;
-		do {
-			shrink_zone(priority, zone, &sc);
-			priority--;
-		} while (priority >= 0 && sc.nr_reclaimed < nr_pages);
-	}
+	if (zone_pagecache_reclaimable(zone) > zone->min_unmapped_pages)
+		zone_reclaim_unmapped_pages(zone, &sc, nr_pages);
 
 	nr_slab_pages0 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
 	if (nr_slab_pages0 > zone->min_slab_pages) {

