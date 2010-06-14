Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab0FNLTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 07:19:42 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47645 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab0FNLSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 07:18:00 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 09/12] vmscan: Setup pagevec as late as possible in shrink_page_list()
Date: Mon, 14 Jun 2010 12:17:50 +0100
Message-Id: <1276514273-27693-10-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shrink_page_list() sets up a pagevec to release pages as according as they
are free. It uses significant amounts of stack on the pagevec. This
patch adds pages to be freed via pagevec to a linked list which is then
freed en-masse at the end. This avoids using stack in the main path that
potentially calls writepage().

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/vmscan.c |   37 +++++++++++++++++++++++++++++--------
 1 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 34c5c87..165c2f5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -620,6 +620,25 @@ static enum page_references page_check_references(struct page *page,
 	return PAGEREF_RECLAIM;
 }
 
+static noinline_for_stack void free_page_list(struct list_head *free_pages)
+{
+	struct pagevec freed_pvec;
+	struct page *page, *tmp;
+
+	pagevec_init(&freed_pvec, 1);
+
+	list_for_each_entry_safe(page, tmp, free_pages, lru) {
+		list_del(&page->lru);
+		if (!pagevec_add(&freed_pvec, page)) {
+			__pagevec_free(&freed_pvec);
+			pagevec_reinit(&freed_pvec);
+		}
+	}
+
+	if (pagevec_count(&freed_pvec))
+		__pagevec_free(&freed_pvec);
+}
+
 /*
  * shrink_page_list() returns the number of reclaimed pages
  */
@@ -628,13 +647,12 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 					enum pageout_io sync_writeback)
 {
 	LIST_HEAD(ret_pages);
-	struct pagevec freed_pvec;
+	LIST_HEAD(free_pages);
 	int pgactivate = 0;
 	unsigned long nr_reclaimed = 0;
 
 	cond_resched();
 
-	pagevec_init(&freed_pvec, 1);
 	while (!list_empty(page_list)) {
 		enum page_references references;
 		struct address_space *mapping;
@@ -809,10 +827,12 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		__clear_page_locked(page);
 free_it:
 		nr_reclaimed++;
-		if (!pagevec_add(&freed_pvec, page)) {
-			__pagevec_free(&freed_pvec);
-			pagevec_reinit(&freed_pvec);
-		}
+
+		/*
+		 * Is there need to periodically free_page_list? It would
+		 * appear not as the counts should be low
+		 */
+		list_add(&page->lru, &free_pages);
 		continue;
 
 cull_mlocked:
@@ -835,9 +855,10 @@ keep:
 		list_add(&page->lru, &ret_pages);
 		VM_BUG_ON(PageLRU(page) || PageUnevictable(page));
 	}
+
+	free_page_list(&free_pages);
+
 	list_splice(&ret_pages, page_list);
-	if (pagevec_count(&freed_pvec))
-		__pagevec_free(&freed_pvec);
 	count_vm_events(PGACTIVATE, pgactivate);
 	return nr_reclaimed;
 }
-- 
1.7.1

