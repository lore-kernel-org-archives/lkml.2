Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab0FYLV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 07:21:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46657 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab0FYLVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 07:21:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 1/2] vmscan: shrink_slab() require number of lru_pages, not page order
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100625201915.8067.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 25 Jun 2010 20:21:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix simple argument error. Usually 'order' is very small value than
lru_pages. then it can makes unnecessary icache dropping.

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0ebfe12..c927948 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2611,6 +2611,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 
 	slab_reclaimable = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
 	if (slab_reclaimable > zone->min_slab_pages) {
+		unsigned long lru_pages = zone_reclaimable_pages(zone);
 		/*
 		 * shrink_slab() does not currently allow us to determine how
 		 * many pages were freed in this zone. So we take the current
@@ -2621,7 +2622,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		 * Note that shrink_slab will free memory on all zones and may
 		 * take a long time.
 		 */
-		while (shrink_slab(sc.nr_scanned, gfp_mask, order) &&
+		while (shrink_slab(sc.nr_scanned, gfp_mask, lru_pages) &&
 			zone_page_state(zone, NR_SLAB_RECLAIMABLE) >
 				slab_reclaimable - nr_pages)
 			;
-- 
1.6.5.2



