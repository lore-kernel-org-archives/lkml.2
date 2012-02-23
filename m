Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab2BWNwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 08:52:44 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39147 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab2BWNwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 08:52:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.204.128.143 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH v3 12/21] mm: push lruvec into update_page_reclaim_stat()
To: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>
Date: Thu, 23 Feb 2012 17:52:38 +0400
Message-ID: <20120223135238.12988.79360.stgit@zurg>
In-Reply-To: <20120223133728.12988.5432.stgit@zurg>
References: <20120223133728.12988.5432.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push lruvec pointer into update_page_reclaim_stat()
* drop page argument
* drop active and file arguments, use lru instead

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/swap.c |   30 +++++++++---------------------
 1 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 0cbc558..1f5731e 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -276,24 +276,19 @@ void rotate_reclaimable_page(struct page *page)
 	}
 }
 
-static void update_page_reclaim_stat(struct zone *zone, struct page *page,
-				     int file, int rotated)
+static void update_page_reclaim_stat(struct lruvec *lruvec, enum lru_list lru)
 {
-	struct zone_reclaim_stat *reclaim_stat;
-
-	reclaim_stat = &page_lruvec(page)->reclaim_stat;
+	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
+	int file = is_file_lru(lru);
 
 	reclaim_stat->recent_scanned[file]++;
-	if (rotated)
+	if (is_active_lru(lru))
 		reclaim_stat->recent_rotated[file]++;
 }
 
 static void __activate_page(struct page *page, void *arg)
 {
-	struct zone *zone = page_zone(page);
-
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
-		int file = page_is_file_cache(page);
 		int lru = page_lru_base_type(page);
 		struct lruvec *lruvec = page_lruvec(page);
 
@@ -304,7 +299,7 @@ static void __activate_page(struct page *page, void *arg)
 		add_page_to_lru_list(lruvec, page, lru);
 		__count_vm_event(PGACTIVATE);
 
-		update_page_reclaim_stat(zone, page, file, 1);
+		update_page_reclaim_stat(lruvec, lru);
 	}
 }
 
@@ -443,7 +438,6 @@ static void lru_deactivate_fn(struct page *page, void *arg)
 {
 	int lru, file;
 	bool active;
-	struct zone *zone = page_zone(page);
 	struct lruvec *lruvec;
 
 	if (!PageLRU(page))
@@ -484,7 +478,7 @@ static void lru_deactivate_fn(struct page *page, void *arg)
 
 	if (active)
 		__count_vm_event(PGDEACTIVATE);
-	update_page_reclaim_stat(zone, page, file, 0);
+	update_page_reclaim_stat(lruvec, lru);
 }
 
 /*
@@ -649,9 +643,7 @@ EXPORT_SYMBOL(__pagevec_release);
 void lru_add_page_tail(struct zone* zone,
 		       struct page *page, struct page *page_tail)
 {
-	int active;
 	enum lru_list lru;
-	const int file = 0;
 	struct lruvec *lruvec = page_lruvec(page);
 
 	VM_BUG_ON(!PageHead(page));
@@ -664,13 +656,11 @@ void lru_add_page_tail(struct zone* zone,
 	if (page_evictable(page_tail, NULL)) {
 		if (PageActive(page)) {
 			SetPageActive(page_tail);
-			active = 1;
 			lru = LRU_ACTIVE_ANON;
 		} else {
-			active = 0;
 			lru = LRU_INACTIVE_ANON;
 		}
-		update_page_reclaim_stat(zone, page_tail, file, active);
+		update_page_reclaim_stat(lruvec, lru);
 	} else {
 		SetPageUnevictable(page_tail);
 		lru = LRU_UNEVICTABLE;
@@ -698,17 +688,15 @@ static void __pagevec_lru_add_fn(struct page *page, void *arg)
 {
 	enum lru_list lru = (enum lru_list)arg;
 	struct lruvec *lruvec = page_lruvec(page);
-	int file = is_file_lru(lru);
-	int active = is_active_lru(lru);
 
 	VM_BUG_ON(PageActive(page));
 	VM_BUG_ON(PageUnevictable(page));
 	VM_BUG_ON(PageLRU(page));
 
 	SetPageLRU(page);
-	if (active)
+	if (is_active_lru(lru))
 		SetPageActive(page);
-	update_page_reclaim_stat(lruvec_zone(lruvec), page, file, active);
+	update_page_reclaim_stat(lruvec, lru);
 	add_page_to_lru_list(lruvec, page, lru);
 }
 

