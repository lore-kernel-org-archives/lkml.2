Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab1ABHYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:24:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:36265 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab1ABHYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:20 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 148/260] mm: page allocator: update free page counters after pages are placed on the free list
Date: Sun,  2 Jan 2011 02:17:24 -0500
Message-Id: <1293952756-15010-149-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:52.0665 (UTC) FILETIME=[DE296690:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mel@csn.ul.ie>

commit 72853e2991a2702ae93aaf889ac7db743a415dd3 upstream.

When allocating a page, the system uses NR_FREE_PAGES counters to
determine if watermarks would remain intact after the allocation was made.
This check is made without interrupts disabled or the zone lock held and
so is race-prone by nature.  Unfortunately, when pages are being freed in
batch, the counters are updated before the pages are added on the list.
During this window, the counters are misleading as the pages do not exist
yet.  When under significant pressure on systems with large numbers of
CPUs, it's possible for processes to make progress even though they should
have been stalled.  This is particularly problematic if a number of the
processes are using GFP_ATOMIC as the min watermark can be accidentally
breached and in extreme cases, the system can livelock.

This patch updates the counters after the pages have been added to the
list.  This makes the allocator more cautious with respect to preserving
the watermarks and mitigates livelock possibilities.

[akpm@linux-foundation.org: avoid modifying incoming args]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/page_alloc.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0de096a..9826a8d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -551,13 +551,13 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 {
 	int migratetype = 0;
 	int batch_free = 0;
+	int to_free = count;
 
 	spin_lock(&zone->lock);
 	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
-	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
-	while (count) {
+	while (to_free) {
 		struct page *page;
 		struct list_head *list;
 
@@ -582,8 +582,9 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, zone, 0, page_private(page));
 			trace_mm_page_pcpu_drain(page, 0, page_private(page));
-		} while (--count && --batch_free && !list_empty(list));
+		} while (--to_free && --batch_free && !list_empty(list));
 	}
+	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
 	spin_unlock(&zone->lock);
 }
 
@@ -594,8 +595,8 @@ static void free_one_page(struct zone *zone, struct page *page, int order,
 	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
-	__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
 	__free_one_page(page, zone, order, migratetype);
+	__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
 	spin_unlock(&zone->lock);
 }
 
-- 
1.7.3.3

