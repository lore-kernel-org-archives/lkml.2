Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab2IGAiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 20:38:54 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48599 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078Ab2IGAiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 20:38:04 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-f9-504941e6969c
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Xishi Qiu <qiuxishi@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v3 2/4] mm: remain migratetype in freed page
Date: Fri,  7 Sep 2012 09:39:30 +0900
Message-Id: <1346978372-17903-3-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346978372-17903-1-git-send-email-minchan@kernel.org>
References: <1346978372-17903-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The page allocator caches the pageblock information in page->private while
it is in the PCP freelists but this is overwritten with the order of the
page when freed to the buddy allocator. This patch stores the migratetype
of the page in the page->index field so that it is available at all times
when the page remain in free_list.

This patch adds a new call site in __free_pages_ok so it might be
overhead a bit but it's for high order allocation.
So I believe damage isn't hurt.

* from v2
  * Add Acked-by of Kame

* from v1
  * Fix move_freepages's migratetype - Mel
  * Add more kind explanation in description - Mel

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/mm.h |    4 ++--
 mm/page_alloc.c    |    7 +++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 84d1663f..68f9e8d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -240,13 +240,13 @@ struct inode;
 /* It's valid only if the page is free path or free_list */
 static inline void set_freepage_migratetype(struct page *page, int migratetype)
 {
-	set_page_private(page, migratetype);
+	page->index = migratetype;
 }
 
 /* It's valid only if the page is free path or free_list */
 static inline int get_freepage_migratetype(struct page *page)
 {
-	return page_private(page);
+	return page->index;
 }
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f5ba236..8531fa3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -723,6 +723,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 {
 	unsigned long flags;
 	int wasMlocked = __TestClearPageMlocked(page);
+	int migratetype;
 
 	if (!free_pages_prepare(page, order))
 		return;
@@ -731,8 +732,9 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 	if (unlikely(wasMlocked))
 		free_page_mlock(page);
 	__count_vm_events(PGFREE, 1 << order);
-	free_one_page(page_zone(page), page, order,
-					get_pageblock_migratetype(page));
+	migratetype = get_pageblock_migratetype(page);
+	set_freepage_migratetype(page, migratetype);
+	free_one_page(page_zone(page), page, order, migratetype);
 	local_irq_restore(flags);
 }
 
@@ -952,6 +954,7 @@ static int move_freepages(struct zone *zone,
 		order = page_order(page);
 		list_move(&page->lru,
 			  &zone->free_area[order].free_list[migratetype]);
+		set_freepage_migratetype(page, migratetype);
 		page += 1 << order;
 		pages_moved += 1 << order;
 	}
-- 
1.7.9.5

