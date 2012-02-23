Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2BWNwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 08:52:49 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39147 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab2BWNwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 08:52:46 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.205.117.16 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH v3 13/21] mm: push lruvecs from pagevec_lru_move_fn() to
 iterator
To: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>
Date: Thu, 23 Feb 2012 17:52:42 +0400
Message-ID: <20120223135242.12988.38183.stgit@zurg>
In-Reply-To: <20120223133728.12988.5432.stgit@zurg>
References: <20120223133728.12988.5432.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push lruvec pointer from pagevec_lru_move_fn() to iterator function.
Push lruvec pointer into lru_add_page_tail()

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/swap.h |    2 +-
 mm/huge_memory.c     |    4 +++-
 mm/swap.c            |   27 +++++++++++++--------------
 3 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index f7df3ea..8630354 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -224,7 +224,7 @@ extern unsigned int nr_free_pagecache_pages(void);
 /* linux/mm/swap.c */
 extern void __lru_cache_add(struct page *, enum lru_list lru);
 extern void lru_cache_add_lru(struct page *, enum lru_list lru);
-extern void lru_add_page_tail(struct zone* zone,
+extern void lru_add_page_tail(struct lruvec *lruvec,
 			      struct page *page, struct page *page_tail);
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 91d3efb..09e7069 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1229,10 +1229,12 @@ static void __split_huge_page_refcount(struct page *page)
 {
 	int i;
 	struct zone *zone = page_zone(page);
+	struct lruvec *lruvec;
 	int tail_count = 0;
 
 	/* prevent PageLRU to go away from under us, and freeze lru stats */
 	spin_lock_irq(&zone->lru_lock);
+	lruvec = page_lruvec(page);
 	compound_lock(page);
 	/* complete memcg works before add pages to LRU */
 	mem_cgroup_split_huge_fixup(page);
@@ -1308,7 +1310,7 @@ static void __split_huge_page_refcount(struct page *page)
 		BUG_ON(!PageSwapBacked(page_tail));
 
 
-		lru_add_page_tail(zone, page, page_tail);
+		lru_add_page_tail(lruvec, page, page_tail);
 	}
 	atomic_sub(tail_count, &page->_count);
 	BUG_ON(atomic_read(&page->_count) <= 0);
diff --git a/mm/swap.c b/mm/swap.c
index 1f5731e..f7b5896 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -204,7 +204,8 @@ void put_pages_list(struct list_head *pages)
 EXPORT_SYMBOL(put_pages_list);
 
 static void pagevec_lru_move_fn(struct pagevec *pvec,
-				void (*move_fn)(struct page *page, void *arg),
+				void (*move_fn)(struct lruvec *lruvec,
+						struct page *page, void *arg),
 				void *arg)
 {
 	int i;
@@ -214,6 +215,7 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
 		struct zone *pagezone = page_zone(page);
+		struct lruvec *lruvec;
 
 		if (pagezone != zone) {
 			if (zone)
@@ -222,7 +224,8 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
 			spin_lock_irqsave(&zone->lru_lock, flags);
 		}
 
-		(*move_fn)(page, arg);
+		lruvec = page_lruvec(page);
+		(*move_fn)(lruvec, page, arg);
 	}
 	if (zone)
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
@@ -230,13 +233,13 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
 	pagevec_reinit(pvec);
 }
 
-static void pagevec_move_tail_fn(struct page *page, void *arg)
+static void pagevec_move_tail_fn(struct lruvec *lruvec,
+				 struct page *page, void *arg)
 {
 	int *pgmoved = arg;
 
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		enum lru_list lru = page_lru_base_type(page);
-		struct lruvec *lruvec = page_lruvec(page);
 
 		list_move_tail(&page->lru, &lruvec->pages_lru[lru]);
 		(*pgmoved)++;
@@ -286,11 +289,10 @@ static void update_page_reclaim_stat(struct lruvec *lruvec, enum lru_list lru)
 		reclaim_stat->recent_rotated[file]++;
 }
 
-static void __activate_page(struct page *page, void *arg)
+static void __activate_page(struct lruvec *lruvec, struct page *page, void *arg)
 {
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		int lru = page_lru_base_type(page);
-		struct lruvec *lruvec = page_lruvec(page);
 
 		del_page_from_lru_list(lruvec, page, lru);
 
@@ -434,11 +436,10 @@ void add_page_to_unevictable_list(struct page *page)
  * be write it out by flusher threads as this is much more effective
  * than the single-page writeout from reclaim.
  */
-static void lru_deactivate_fn(struct page *page, void *arg)
+static void lru_deactivate_fn(struct lruvec *lruvec, struct page *page, void *arg)
 {
 	int lru, file;
 	bool active;
-	struct lruvec *lruvec;
 
 	if (!PageLRU(page))
 		return;
@@ -454,7 +455,6 @@ static void lru_deactivate_fn(struct page *page, void *arg)
 
 	file = page_is_file_cache(page);
 	lru = page_lru_base_type(page);
-	lruvec = page_lruvec(page);
 	del_page_from_lru_list(lruvec, page, lru + active);
 	ClearPageActive(page);
 	ClearPageReferenced(page);
@@ -640,16 +640,15 @@ EXPORT_SYMBOL(__pagevec_release);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /* used by __split_huge_page_refcount() */
-void lru_add_page_tail(struct zone* zone,
+void lru_add_page_tail(struct lruvec *lruvec,
 		       struct page *page, struct page *page_tail)
 {
 	enum lru_list lru;
-	struct lruvec *lruvec = page_lruvec(page);
 
 	VM_BUG_ON(!PageHead(page));
 	VM_BUG_ON(PageCompound(page_tail));
 	VM_BUG_ON(PageLRU(page_tail));
-	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&zone->lru_lock));
+	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&lruvec_zone(lruvec)->lru_lock));
 
 	SetPageLRU(page_tail);
 
@@ -684,10 +683,10 @@ void lru_add_page_tail(struct zone* zone,
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static void __pagevec_lru_add_fn(struct page *page, void *arg)
+static void __pagevec_lru_add_fn(struct lruvec *lruvec,
+				 struct page *page, void *arg)
 {
 	enum lru_list lru = (enum lru_list)arg;
-	struct lruvec *lruvec = page_lruvec(page);
 
 	VM_BUG_ON(PageActive(page));
 	VM_BUG_ON(PageUnevictable(page));

