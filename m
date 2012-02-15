Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2BOW5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:57:50 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56730 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab2BOW5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:57:48 -0500
Subject: [PATCH RFC 10/15] mm: handle book relocks in compaction
To: linux-mm@kvack.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 16 Feb 2012 02:57:43 +0400
Message-ID: <20120215225743.22050.75259.stgit@zurg>
In-Reply-To: <20120215224221.22050.80605.stgit@zurg>
References: <20120215224221.22050.80605.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for lru_lock splitting in memory compaction code.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/compaction.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 680a725..f521edf 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -269,7 +269,7 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
 	isolate_mode_t mode = ISOLATE_ACTIVE|ISOLATE_INACTIVE;
-	struct book *book;
+	struct book *book = NULL;
 
 	/* Do not scan outside zone boundaries */
 	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
@@ -301,25 +301,23 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 
 	/* Time to isolate some pages for migration */
 	cond_resched();
-	spin_lock_irq(&zone->lru_lock);
 	for (; low_pfn < end_pfn; low_pfn++) {
 		struct page *page;
-		bool locked = true;
 
 		/* give a chance to irqs before checking need_resched() */
 		if (!((low_pfn+1) % SWAP_CLUSTER_MAX)) {
-			spin_unlock_irq(&zone->lru_lock);
-			locked = false;
+			if (book)
+				unlock_book_irq(book);
+			book = NULL;
 		}
 		if (need_resched() || spin_is_contended(&zone->lru_lock)) {
-			if (locked)
-				spin_unlock_irq(&zone->lru_lock);
+			if (book)
+				unlock_book_irq(book);
+			book = NULL;
 			cond_resched();
-			spin_lock_irq(&zone->lru_lock);
 			if (fatal_signal_pending(current))
 				break;
-		} else if (!locked)
-			spin_lock_irq(&zone->lru_lock);
+		}
 
 		/*
 		 * migrate_pfn does not necessarily start aligned to a
@@ -345,6 +343,7 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 		 * as memory compaction should not move pages between nodes.
 		 */
 		page = pfn_to_page(low_pfn);
+
 		if (page_zone(page) != zone)
 			continue;
 
@@ -369,6 +368,14 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 		if (!PageLRU(page))
 			continue;
 
+		if (book)
+			book = __relock_page_book(book, page);
+		else
+			book = lock_page_book_irq(page);
+
+		if (!PageLRU(page))
+			continue;
+
 		/*
 		 * PageLRU is set, and lru_lock excludes isolation,
 		 * splitting and collapsing (collapsing has already
@@ -389,7 +396,6 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 		VM_BUG_ON(PageTransCompound(page));
 
 		/* Successfully isolated */
-		book = page_book(page);
 		del_page_from_lru_list(book, page, page_lru(page));
 		list_add(&page->lru, migratelist);
 		cc->nr_migratepages++;
@@ -402,9 +408,11 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 		}
 	}
 
+	if (book)
+		unlock_book_irq(book);
+
 	acct_isolated(zone, cc);
 
-	spin_unlock_irq(&zone->lru_lock);
 	cc->migrate_pfn = low_pfn;
 
 	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);

