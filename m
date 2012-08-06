Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab2HFJXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:23:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33398 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab2HFJXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:23:24 -0400
X-IronPort-AV: E=Sophos;i="4.77,719,1336320000"; 
   d="scan'208";a="5560124"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org
Subject: [RFC V3 PATCH 01/25] page_alloc.c: don't subtract unrelated memmap from zone's present pages
Date: Mon, 6 Aug 2012 17:22:55 +0800
Message-Id: <1344244999-5081-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1344244999-5081-1-git-send-email-laijs@cn.fujitsu.com>
References: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
 <1344244999-5081-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/06 17:23:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/06 17:23:48,
	Serialize complete at 2012/08/06 17:23:48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A)======
Currently, memory-page-map(struct page array) is not defined in struct zone.
It is defined in several ways:

FLATMEM: global memmap, can be allocated from any zone <= ZONE_NORMAL
CONFIG_DISCONTIGMEM: node-specific memmap, can be allocated from any
		     zone <= ZONE_NORMAL within that node.
CONFIG_SPARSEMEM: memorysection-specific memmap, can be allocated from any zone,
		  when CONFIG_SPARSEMEM_VMEMMAP, it is even not physical continuous.

So, the memmap has nothing directly related with the zone. And it's memory can be
allocated outside, so it is wrong to subtract memmap's size from zone's
present pages.

B)======
When system has large holes, the subtracted-present-pages-size will become
very small or negative, make the memory management works bad at the zone or
make the zone unusable even the real-present-pages-size is actually large.

C)======
And subtracted-present-pages-size has problem when memory-hot-removing,
the zone->zone->present_pages may overflow and become huge(unsigned long).

D)======
memory-page-map is large and long living unreclaimable memory, it is good to
subtract them for proper watermark.
So a new proper approach is needed to do it similarly
and new approach should also handle other long living unreclaimable memory.

Current blindly subtracted-present-pages-size approach does wrong, remove it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/page_alloc.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4a4f921..9312702 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4357,30 +4357,12 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 
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

