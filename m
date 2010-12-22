Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab0LVNrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:47:39 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:35147 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab0LVNrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:47:37 -0500
From: KyongHo Cho <pullip.cho@samsung.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: kgene.kim@samsung.com, Ilho Lee <ilho215.lee@samsung.com>,
        KyongHo Cho <pullip.cho@samsung.com>
Subject: [PATCH] mm: simple approach to calculate combined index of adjacent buddy lists
Date: Wed, 22 Dec 2010 22:26:52 +0900
Message-Id: <1293024412-15617-1-git-send-email-pullip.cho@samsung.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous approach of calucation of combined index was

page_idx & ~(1 << order))

but we have same result with

page_idx & buddy_idx
.

I think this reduces instructions slightly as well as enhances readability.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 mm/page_alloc.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f12ad18..6033053 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -420,18 +420,10 @@ static inline void rmv_page_order(struct page *page)
  *
  * Assumption: *_mem_map is contiguous at least up to MAX_ORDER
  */
-static inline struct page *
-__page_find_buddy(struct page *page, unsigned long page_idx, unsigned int order)
-{
-	unsigned long buddy_idx = page_idx ^ (1 << order);
-
-	return page + (buddy_idx - page_idx);
-}
-
 static inline unsigned long
-__find_combined_index(unsigned long page_idx, unsigned int order)
+__find_buddy_index(unsigned long page_idx, unsigned int order)
 {
-	return (page_idx & ~(1 << order));
+	return (page_idx ^ (1 << order));
 }
 
 /*
@@ -493,6 +485,7 @@ static inline void __free_one_page(struct page *page,
 {
 	unsigned long page_idx;
 	unsigned long combined_idx;
+	unsigned long buddy_idx;
 	struct page *buddy;
 
 	if (unlikely(PageCompound(page)))
@@ -507,7 +500,8 @@ static inline void __free_one_page(struct page *page,
 	VM_BUG_ON(bad_range(zone, page));
 
 	while (order < MAX_ORDER-1) {
-		buddy = __page_find_buddy(page, page_idx, order);
+		buddy_idx = __find_buddy_index(page_idx, order);
+		buddy = page + (buddy_idx - page_idx);
 		if (!page_is_buddy(page, buddy, order))
 			break;
 
@@ -515,7 +509,7 @@ static inline void __free_one_page(struct page *page,
 		list_del(&buddy->lru);
 		zone->free_area[order].nr_free--;
 		rmv_page_order(buddy);
-		combined_idx = __find_combined_index(page_idx, order);
+		combined_idx = buddy_idx & page_idx;
 		page = page + (combined_idx - page_idx);
 		page_idx = combined_idx;
 		order++;
@@ -532,9 +526,10 @@ static inline void __free_one_page(struct page *page,
 	 */
 	if ((order < MAX_ORDER-1) && pfn_valid_within(page_to_pfn(buddy))) {
 		struct page *higher_page, *higher_buddy;
-		combined_idx = __find_combined_index(page_idx, order);
-		higher_page = page + combined_idx - page_idx;
-		higher_buddy = __page_find_buddy(higher_page, combined_idx, order + 1);
+		combined_idx = buddy_idx & page_idx;
+		higher_page = page + (combined_idx - page_idx);
+		buddy_idx = __find_buddy_index(combined_idx, order + 1);
+		higher_buddy = page + (buddy_idx - combined_idx);
 		if (page_is_buddy(higher_page, higher_buddy, order + 1)) {
 			list_add_tail(&page->lru,
 				&zone->free_area[order].free_list[migratetype]);
-- 
1.6.2.5

