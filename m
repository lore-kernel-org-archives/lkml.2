Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab2BOW6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:58:40 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56730 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab2BOW56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:57:58 -0500
Subject: [PATCH RFC 13/15] mm: optimize books in pagevec_lru_move_fn()
To: linux-mm@kvack.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 16 Feb 2012 02:57:55 +0400
Message-ID: <20120215225755.22050.684.stgit@zurg>
In-Reply-To: <20120215224221.22050.80605.stgit@zurg>
References: <20120215224221.22050.80605.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push book pointer from pagevec_lru_move_fn() to iterator function.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/swap.h |    2 +-
 mm/huge_memory.c     |    2 +-
 mm/swap.c            |   25 +++++++++++--------------
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 80cf6b8..7fa6f1d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -210,7 +210,7 @@ extern unsigned int nr_free_pagecache_pages(void);
 /* linux/mm/swap.c */
 extern void __lru_cache_add(struct page *, enum lru_list lru);
 extern void lru_cache_add_lru(struct page *, enum lru_list lru);
-extern void lru_add_page_tail(struct zone* zone,
+extern void lru_add_page_tail(struct book *book,
 			      struct page *page, struct page *page_tail);
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e7e289..0824655 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1308,7 +1308,7 @@ static void __split_huge_page_refcount(struct page *page)
 		BUG_ON(!PageSwapBacked(page_tail));
 
 
-		lru_add_page_tail(book_zone(book), page, page_tail);
+		lru_add_page_tail(book, page, page_tail);
 	}
 	atomic_sub(tail_count, &page->_count);
 	BUG_ON(atomic_read(&page->_count) <= 0);
diff --git a/mm/swap.c b/mm/swap.c
index e57c4c6..652e691 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -202,7 +202,8 @@ void put_pages_list(struct list_head *pages)
 EXPORT_SYMBOL(put_pages_list);
 
 static void pagevec_lru_move_fn(struct pagevec *pvec,
-				void (*move_fn)(struct page *page, void *arg),
+				void (*move_fn)(struct book *book,
+						struct page *page, void *arg),
 				void *arg)
 {
 	int i;
@@ -213,7 +214,7 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
 		struct page *page = pvec->pages[i];
 
 		book = relock_page_book(book, page, &flags);
-		(*move_fn)(page, arg);
+		(*move_fn)(book, page, arg);
 	}
 	if (book)
 		unlock_book(book, &flags);
@@ -221,13 +222,13 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
 	pagevec_reinit(pvec);
 }
 
-static void pagevec_move_tail_fn(struct page *page, void *arg)
+static void pagevec_move_tail_fn(struct book *book,
+				 struct page *page, void *arg)
 {
 	int *pgmoved = arg;
 
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		enum lru_list lru = page_lru_base_type(page);
-		struct book *book = page_book(page);
 
 		list_move_tail(&page->lru, &book->pages_lru[lru]);
 		(*pgmoved)++;
@@ -277,12 +278,11 @@ static void update_page_reclaim_stat(struct book *book, struct page *page,
 		reclaim_stat->recent_rotated[file]++;
 }
 
-static void __activate_page(struct page *page, void *arg)
+static void __activate_page(struct book *book, struct page *page, void *arg)
 {
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		int file = page_is_file_cache(page);
 		int lru = page_lru_base_type(page);
-		struct book *book = page_book(page);
 
 		del_page_from_lru_list(book, page, lru);
 
@@ -424,11 +424,10 @@ void add_page_to_unevictable_list(struct page *page)
  * be write it out by flusher threads as this is much more effective
  * than the single-page writeout from reclaim.
  */
-static void lru_deactivate_fn(struct page *page, void *arg)
+static void lru_deactivate_fn(struct book *book, struct page *page, void *arg)
 {
 	int lru, file;
 	bool active;
-	struct book *book;
 
 	if (!PageLRU(page))
 		return;
@@ -444,7 +443,6 @@ static void lru_deactivate_fn(struct page *page, void *arg)
 
 	file = page_is_file_cache(page);
 	lru = page_lru_base_type(page);
-	book = page_book(page);
 	del_page_from_lru_list(book, page, lru + active);
 	ClearPageActive(page);
 	ClearPageReferenced(page);
@@ -621,18 +619,17 @@ EXPORT_SYMBOL(__pagevec_release);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /* used by __split_huge_page_refcount() */
-void lru_add_page_tail(struct zone* zone,
+void lru_add_page_tail(struct book *book,
 		       struct page *page, struct page *page_tail)
 {
 	int active;
 	enum lru_list lru;
 	const int file = 0;
-	struct book *book = page_book(page);
 
 	VM_BUG_ON(!PageHead(page));
 	VM_BUG_ON(PageCompound(page_tail));
 	VM_BUG_ON(PageLRU(page_tail));
-	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&zone->lru_lock));
+	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&book_zone(book)->lru_lock));
 
 	SetPageLRU(page_tail);
 
@@ -669,10 +666,10 @@ void lru_add_page_tail(struct zone* zone,
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static void __pagevec_lru_add_fn(struct page *page, void *arg)
+static void __pagevec_lru_add_fn(struct book *book,
+				 struct page *page, void *arg)
 {
 	enum lru_list lru = (enum lru_list)arg;
-	struct book *book = page_book(page);
 	int file = is_file_lru(lru);
 	int active = is_active_lru(lru);
 

