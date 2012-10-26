Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab2JZJ6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:58:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46929 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab2JZJ57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:57:59 -0400
X-IronPort-AV: E=Sophos;i="4.80,653,1344182400"; 
   d="scan'208";a="6078438"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org
Subject: [PATCH] page_alloc: fix the incorrect adjustment to zone->present_pages
Date: Fri, 26 Oct 2012 17:59:31 +0800
Message-Id: <1351245581-16652-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/26 17:57:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/26 17:57:22,
	Serialize complete at 2012/10/26 17:57:22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current free_area_init_core() has incorrect adjustment code to adjust
->present_pages. It will cause ->present_pages overflow, make the
system unusable(can't create any process/thread in our test) and cause further problem.

Details:
1) Some/many ZONEs don't have memory which is used by memmap.
   { Or all the actual memory used for memmap is much less than the "memmap_pages"
   (memmap_pages = PAGE_ALIGN(span_size * sizeof(struct page)) >> PAGE_SHIFT)
   CONFIG_SPARSEMEM is an example. }

2) incorrect adjustment in free_area_init_core(): zone->present_pages -= memmap_pages
3) but the zone has big hole, it causes the result of zone->present_pages become much smaller
4) when we offline a/several memory section of the zone: zone->present_pages -= offline_size
5) Now, zone->present_pages will/may be *OVERFLOW*.

So the adjustment is dangerous and incorrect.

Addition 1:
And in current kernel, the memmaps have nothing related/bound to any ZONE:
	FLATMEM: global memmap
	CONFIG_DISCONTIGMEM: node-specific memmap
	CONFIG_SPARSEMEM: memorysection-specific memmap
None of them is ZONE-specific memmap, and the memory used for memmap is not bound to any ZONE.
So the adjustment "zone->present_pages -= memmap_pages" subtracts unrelated value
and makes no sense.

Addition 2:
We introduced this adjustment and tried to make page-reclaim/watermark happier,
but the adjustment is wrong in current kernel, and even makes page-reclaim/watermark
worse. It is against its original purpose/reason.

This adjustment is incorrect/buggy, subtracts unrelated value and violates its original
purpose, so we simply remove the adjustment.

CC: Mel Gorman <mgorman@suse.de>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/page_alloc.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bb90971..6bf72e3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4455,30 +4455,12 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
-		unsigned long size, realsize, memmap_pages;
+		unsigned long size, realsize;
 
 		size = zone_spanned_pages_in_node(nid, j, zones_size);
 		realsize = size - zone_absent_pages_in_node(nid, j,
 								zholes_size);
 
-		/*
-		 * Adjust realsize so that it accounts for how much memory
-		 * is used by this zone for memmap. This affects the watermark
-		 * and per-cpu initialisations
-		 */
-		memmap_pages =
-			PAGE_ALIGN(size * sizeof(struct page)) >> PAGE_SHIFT;
-		if (realsize >= memmap_pages) {
-			realsize -= memmap_pages;
-			if (memmap_pages)
-				printk(KERN_DEBUG
-				       "  %s zone: %lu pages used for memmap\n",
-				       zone_names[j], memmap_pages);
-		} else
-			printk(KERN_WARNING
-				"  %s zone: %lu pages exceeds realsize %lu\n",
-				zone_names[j], memmap_pages, realsize);
-
 		/* Account for reserved pages */
 		if (j == 0 && realsize > dma_reserve) {
 			realsize -= dma_reserve;
-- 
1.7.4.4

