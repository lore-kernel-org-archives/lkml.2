Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0IOM2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 08:28:37 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45574 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab0IOM15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 08:27:57 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 6/8] vmscan: isolated_lru_pages() stop neighbour search if neighbour cannot be isolated
Date: Wed, 15 Sep 2010 13:27:49 +0100
Message-Id: <1284553671-31574-7-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284553671-31574-1-git-send-email-mel@csn.ul.ie>
References: <1284553671-31574-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

isolate_lru_pages() does not just isolate LRU tail pages, but also isolate
neighbour pages of the eviction page. The neighbour search does not stop even
if neighbours cannot be isolated which is excessive as the lumpy reclaim will
no longer result in a successful higher order allocation. This patch stops
the PFN neighbour pages if an isolation fails and moves on to the next block.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/vmscan.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 00075f3..2836913 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1052,7 +1052,7 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 
 			/* Check that we have not crossed a zone boundary. */
 			if (unlikely(page_zone_id(cursor_page) != zone_id))
-				continue;
+				break;
 
 			/*
 			 * If we don't have enough swap space, reclaiming of
@@ -1060,8 +1060,8 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 			 * pointless.
 			 */
 			if (nr_swap_pages <= 0 && PageAnon(cursor_page) &&
-					!PageSwapCache(cursor_page))
-				continue;
+			    !PageSwapCache(cursor_page))
+				break;
 
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
 				list_move(&cursor_page->lru, dst);
@@ -1072,11 +1072,16 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 					nr_lumpy_dirty++;
 				scan++;
 			} else {
-				if (mode == ISOLATE_BOTH &&
-						page_count(cursor_page))
-					nr_lumpy_failed++;
+				/* the page is freed already. */
+				if (!page_count(cursor_page))
+					continue;
+				break;
 			}
 		}
+
+		/* If we break out of the loop above, lumpy reclaim failed */
+		if (pfn < end_pfn)
+			nr_lumpy_failed++;
 	}
 
 	*scanned = scan;
-- 
1.7.1

