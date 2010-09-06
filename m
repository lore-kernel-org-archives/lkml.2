Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab0IFKse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 06:48:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60506 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817Ab0IFKrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 06:47:39 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 08/10] vmscan: isolated_lru_pages() stop neighbour search if neighbour cannot be isolated
Date: Mon,  6 Sep 2010 11:47:31 +0100
Message-Id: <1283770053-18833-9-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
References: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
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
---
 mm/vmscan.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 64f9ca5..ff52b46 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1047,14 +1047,18 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 				continue;
 
 			/* Avoid holes within the zone. */
-			if (unlikely(!pfn_valid_within(pfn)))
+			if (unlikely(!pfn_valid_within(pfn))) {
+				nr_lumpy_failed++;
 				break;
+			}
 
 			cursor_page = pfn_to_page(pfn);
 
 			/* Check that we have not crossed a zone boundary. */
-			if (unlikely(page_zone_id(cursor_page) != zone_id))
-				continue;
+			if (unlikely(page_zone_id(cursor_page) != zone_id)) {
+				nr_lumpy_failed++;
+				break;
+			}
 
 			/*
 			 * If we don't have enough swap space, reclaiming of
@@ -1062,8 +1066,10 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 			 * pointless.
 			 */
 			if (nr_swap_pages <= 0 && PageAnon(cursor_page) &&
-					!PageSwapCache(cursor_page))
-				continue;
+			    !PageSwapCache(cursor_page)) {
+				nr_lumpy_failed++;
+				break;
+			}
 
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
 				list_move(&cursor_page->lru, dst);
@@ -1074,9 +1080,11 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 					nr_lumpy_dirty++;
 				scan++;
 			} else {
-				if (mode == ISOLATE_BOTH &&
-						page_count(cursor_page))
-					nr_lumpy_failed++;
+				/* the page is freed already. */
+				if (!page_count(cursor_page))
+					continue;
+				nr_lumpy_failed++;
+				break;
 			}
 		}
 	}
-- 
1.7.1

