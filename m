Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab0KVPpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 10:45:03 -0500
Received: from gir.skynet.ie ([193.1.99.77]:48781 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab0KVPoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 10:44:00 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] mm: compaction: Perform a faster migration scan when migrating asynchronously
Date: Mon, 22 Nov 2010 15:43:54 +0000
Message-Id: <1290440635-30071-7-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290440635-30071-1-git-send-email-mel@csn.ul.ie>
References: <1290440635-30071-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try_to_compact_pages() is initially called to only migrate pages asychronously
and kswapd always compacts asynchronously. Both are being optimistic so it
is important to complete the work as quickly as possible to minimise stalls.

This patch alters the scanner when asynchronous to only consider
MIGRATE_MOVABLE pageblocks as migration candidates. This reduces stalls
when allocating huge pages while not impairing allocation success rates as
a full scan will be performed if necessary after direct reclaim.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/compaction.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index b6e589d..50b0a90 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -240,6 +240,7 @@ static unsigned long isolate_migratepages(struct zone *zone,
 					struct compact_control *cc)
 {
 	unsigned long low_pfn, end_pfn;
+	unsigned long last_pageblock_nr = 0, pageblock_nr;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
 
@@ -280,6 +281,20 @@ static unsigned long isolate_migratepages(struct zone *zone,
 		if (PageBuddy(page))
 			continue;
 
+		/*
+		 * For async migration, also only scan in MOVABLE blocks. Async
+		 * migration is optimistic to see if the minimum amount of work
+		 * satisfies the allocation
+		 */
+		pageblock_nr = low_pfn >> pageblock_order;
+		if (!cc->sync && last_pageblock_nr != pageblock_nr &&
+				get_pageblock_migratetype(page) != MIGRATE_MOVABLE) {
+			low_pfn += pageblock_nr_pages;
+			low_pfn = ALIGN(low_pfn, pageblock_nr_pages) - 1;
+			last_pageblock_nr = pageblock_nr;
+			continue;
+		}
+
 		/* Try isolate the page */
 		if (__isolate_lru_page(page, ISOLATE_BOTH, 0) != 0)
 			continue;
-- 
1.7.1

