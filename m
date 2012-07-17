Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab2GQHCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 03:02:12 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48966 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab2GQHBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 03:01:23 -0400
X-AuditID: 9c930179-b7bdcae000003d91-be-50050dbf3840
From: Minchan Kim <minchan@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Minchan Kim <minchan@kernel.org>
Subject: [RFC 3/3] memory-hotplug: bug fix race between isolation and allocation
Date: Tue, 17 Jul 2012 16:01:45 +0900
Message-Id: <1342508505-23492-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342508505-23492-1-git-send-email-minchan@kernel.org>
References: <1342508505-23492-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like below, memory-hotplug makes race between page-isolation
and page-allocation so it can hit BUG_ON in __offline_isolated_pages.

	CPU A					CPU B

start_isolate_page_range
set_migratetype_isolate
spin_lock_irqsave(zone->lock)

				free_hot_cold_page(Page A)
				/* without zone->lock */
				migratetype = get_pageblock_migratetype(Page A);
				/*
				 * Page could be moved into MIGRATE_MOVABLE
				 * of per_cpu_pages
				 */
				list_add_tail(&page->lru, &pcp->lists[migratetype]);

set_pageblock_isolate
move_freepages_block
drain_all_pages

				/* Page A could be in MIGRATE_MOVABLE of free_list. */

check_pages_isolated
__test_page_isolated_in_pageblock
/*
 * We can't catch freed page which
 * is free_list[MIGRATE_MOVABLE]
 */
if (PageBuddy(page A))
	pfn += 1 << page_order(page A);

				/* So, Page A could be allocated */

__offline_isolated_pages
/*
 * BUG_ON hit or offline page
 * which is used by someone
 */
BUG_ON(!PageBuddy(page A));

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
I found this problem during code review so please confirm it.
Kame?

 mm/page_isolation.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index acf65a7..4699d1f 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -196,8 +196,11 @@ __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn)
 			continue;
 		}
 		page = pfn_to_page(pfn);
-		if (PageBuddy(page))
+		if (PageBuddy(page)) {
 			pfn += 1 << page_order(page);
+			if (get_page_migratetype(page) != MIGRATE_ISOLATE)
+				break;
+		}
 		else if (page_count(page) == 0 &&
 				get_page_migratetype(page) == MIGRATE_ISOLATE)
 			pfn += 1;
-- 
1.7.9.5

