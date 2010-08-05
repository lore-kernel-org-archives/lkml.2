Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703Ab0HEGQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:16:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37482 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699Ab0HEGQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:16:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 7/7] vmscan: isolated_lru_pages() stop neighbor search if neighbor can't be isolated
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100805150624.31B7.A69D9226@jp.fujitsu.com>
References: <20100805150624.31B7.A69D9226@jp.fujitsu.com>
Message-Id: <20100805151525.31CC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  5 Aug 2010 15:16:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

isolate_lru_pages() doesn't only isolate LRU tail pages, but also
isolate neighbor pages of the eviction page.

Now, the neighbor search don't stop even if neighbors can't be isolated.
It is silly. successful higher order allocation need full contenious
memory, even though only one page reclaim failure mean to fail making
enough contenious memory.

Then, isolate_lru_pages() should stop to search PFN neighbor pages and
try to search next page on LRU soon. This patch does it. Also all of
lumpy reclaim failure account nr_lumpy_failed.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e043e97..264addc 100644
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
1.6.5.2



