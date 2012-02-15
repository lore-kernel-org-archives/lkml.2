Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2BOW5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:57:48 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56730 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab2BOW5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:57:43 -0500
Subject: [PATCH RFC 09/15] mm: handle book relocks on lumpy reclaim
To: linux-mm@kvack.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 16 Feb 2012 02:57:40 +0400
Message-ID: <20120215225740.22050.35218.stgit@zurg>
In-Reply-To: <20120215224221.22050.80605.stgit@zurg>
References: <20120215224221.22050.80605.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for lock splitting in move_active_pages_to_lru() and putback_inactive_pages()
on lumpy reclaim they can put pages into different books.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/vmscan.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0b973ff..9a3fb72 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1335,7 +1335,10 @@ static int too_many_isolated(struct zone *zone, int file,
 	return isolated > inactive;
 }
 
-static noinline_for_stack void
+/*
+ * Returns currently locked book
+ */
+static noinline_for_stack struct book *
 putback_inactive_pages(struct book *book,
 		       struct list_head *page_list)
 {
@@ -1386,6 +1389,8 @@ putback_inactive_pages(struct book *book,
 	 * To save our caller's stack, now use input list for pages to free.
 	 */
 	list_splice(&pages_to_free, page_list);
+
+	return book;
 }
 
 static noinline_for_stack void
@@ -1555,7 +1560,7 @@ shrink_inactive_list(unsigned long nr_to_scan, struct book *book,
 		__count_vm_events(KSWAPD_STEAL, nr_reclaimed);
 	__count_zone_vm_events(PGSTEAL, zone, nr_reclaimed);
 
-	putback_inactive_pages(book, &page_list);
+	book = putback_inactive_pages(book, &page_list);
 
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
 	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
@@ -1614,12 +1619,15 @@ shrink_inactive_list(unsigned long nr_to_scan, struct book *book,
  *
  * The downside is that we have to touch page->_count against each page.
  * But we had to alter page->flags anyway.
+ *
+ * Returns currently locked book
  */
 
-static void move_active_pages_to_lru(struct book *book,
-				     struct list_head *list,
-				     struct list_head *pages_to_free,
-				     enum lru_list lru)
+static struct book *
+move_active_pages_to_lru(struct book *book,
+			 struct list_head *list,
+			 struct list_head *pages_to_free,
+			 enum lru_list lru)
 {
 	unsigned long pgmoved = 0;
 	struct page *page;
@@ -1667,6 +1675,8 @@ static void move_active_pages_to_lru(struct book *book,
 	__mod_zone_page_state(book_zone(book), NR_LRU_BASE + lru, pgmoved);
 	if (!is_active_lru(lru))
 		__count_vm_events(PGDEACTIVATE, pgmoved);
+
+	return book;
 }
 
 static void shrink_active_list(unsigned long nr_to_scan,
@@ -1755,9 +1765,9 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	 */
 	reclaim_stat->recent_rotated[file] += nr_rotated;
 
-	move_active_pages_to_lru(book, &l_active, &l_hold,
+	book = move_active_pages_to_lru(book, &l_active, &l_hold,
 						LRU_ACTIVE + file * LRU_FILE);
-	move_active_pages_to_lru(book, &l_inactive, &l_hold,
+	book = move_active_pages_to_lru(book, &l_inactive, &l_hold,
 						LRU_BASE   + file * LRU_FILE);
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
 	unlock_book_irq(book);

