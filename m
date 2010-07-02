Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab0GBFuD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 01:50:03 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:46326 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab0GBFtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 01:49:47 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] hugetlb: pin oldpage in page migration
Date: Fri,  2 Jul 2010 14:47:24 +0900
Message-Id: <1278049646-29769-6-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces pinning the old page during page migration
to avoid freeing it before we complete copying.
This race condition can happen for privately mapped or anonymous hugepage.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 mm/migrate.c |   26 +++++++++++++++++++++++---
 1 files changed, 23 insertions(+), 3 deletions(-)

diff --git v2.6.35-rc3-hwpoison/mm/migrate.c v2.6.35-rc3-hwpoison/mm/migrate.c
index 4205b1d..e4a381c 100644
--- v2.6.35-rc3-hwpoison/mm/migrate.c
+++ v2.6.35-rc3-hwpoison/mm/migrate.c
@@ -214,7 +214,7 @@ static int migrate_page_move_mapping(struct address_space *mapping,
 
 	if (!mapping) {
 		/* Anonymous page without mapping */
-		if (page_count(page) != 1)
+		if (page_count(page) != 2 - PageHuge(page))
 			return -EAGAIN;
 		return 0;
 	}
@@ -224,7 +224,11 @@ static int migrate_page_move_mapping(struct address_space *mapping,
 	pslot = radix_tree_lookup_slot(&mapping->page_tree,
  					page_index(page));
 
-	expected_count = 2 + page_has_private(page);
+	/*
+	 * Hugepages are expected to have only one remained reference
+	 * from pagecache, because hugepages are not linked to LRU list.
+	 */
+	expected_count = 3 + page_has_private(page) - PageHuge(page);
 	if (page_count(page) != expected_count ||
 			(struct page *)radix_tree_deref_slot(pslot) != page) {
 		spin_unlock_irq(&mapping->tree_lock);
@@ -561,7 +565,11 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 	if (!newpage)
 		return -ENOMEM;
 
-	if (page_count(page) == 1) {
+	/*
+	 * For anonymous hugepages, reference count is equal to mapcount,
+	 * so don't consider migration is done for anonymou hugepage.
+	 */
+	if (page_count(page) == 1 && !(PageHuge(page) && PageAnon(page))) {
 		/* page was freed from under us. So we are done. */
 		goto move_newpage;
 	}
@@ -644,6 +652,16 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 	}
 
 	/*
+	 * It's reasonable to pin the old page until unmapping and copying
+	 * complete, because when the original page is an anonymous hugepage,
+	 * it will be freed in try_to_unmap() due to the fact that
+	 * all references of anonymous hugepage come from mapcount.
+	 * Although in the other cases no problem comes out without pinning,
+	 * it looks logically correct to do it.
+	 */
+	get_page(page);
+
+	/*
 	 * Corner case handling:
 	 * 1. When a new swap-cache page is read into, it is added to the LRU
 	 * and treated as swapcache but it has no rmap yet.
@@ -697,6 +715,8 @@ uncharge:
 unlock:
 	unlock_page(page);
 
+	put_page(page);
+
 	if (rc != -EAGAIN) {
  		/*
  		 * A page that has been migrated has all references
-- 
1.7.1

