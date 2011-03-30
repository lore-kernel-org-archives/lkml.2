Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1C3Fb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 01:31:28 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:42685 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab1C3Fb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 01:31:26 -0400
Subject: [PATCH 2/3] Refactor zone_reclaim code (v5)
To: linux-mm@kvack.org, akpm@linux-foundation.org
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: npiggin@kernel.dk, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com
Date: Wed, 30 Mar 2011 11:01:20 +0530
Message-ID: <20110330053112.8212.43893.stgit@localhost6.localdomain6>
In-Reply-To: <20110330052819.8212.1359.stgit@localhost6.localdomain6>
References: <20110330052819.8212.1359.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog v3
1. Renamed zone_reclaim_unmapped_pages to zone_reclaim_pages

Refactor zone_reclaim, move reusable functionality outside
of zone_reclaim. Make zone_reclaim_unmapped_pages modular

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
---
 mm/vmscan.c |   35 +++++++++++++++++++++++------------
 1 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4923160..5b24e74 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2949,6 +2949,27 @@ static long zone_pagecache_reclaimable(struct zone *zone)
 }
 
 /*
+ * Helper function to reclaim unmapped pages, we might add something
+ * similar to this for slab cache as well. Currently this function
+ * is shared with __zone_reclaim()
+ */
+static inline void
+zone_reclaim_pages(struct zone *zone, struct scan_control *sc,
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
@@ -2957,7 +2978,6 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	const unsigned long nr_pages = 1 << order;
 	struct task_struct *p = current;
 	struct reclaim_state reclaim_state;
-	int priority;
 	struct scan_control sc = {
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
 		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
@@ -2981,17 +3001,8 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
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
+		zone_reclaim_pages(zone, &sc, nr_pages);
 
 	nr_slab_pages0 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
 	if (nr_slab_pages0 > zone->min_slab_pages) {

