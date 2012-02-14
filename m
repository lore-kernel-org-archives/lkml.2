Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293Ab2BNMxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 07:53:55 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43268 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab2BNMxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 07:53:52 -0500
MIME-Version: 1.0
Date: Tue, 14 Feb 2012 20:53:51 +0800
Message-ID: <CAJd=RBATj97k5UESDFx82bzt0K4OquhBoDkfjPBPacdmdfJE8g@mail.gmail.com>
Subject: [PATCH] mm: hugetlb: defer freeing pages when gathering surplus pages
From: Hillf Danton <dhillf@gmail.com>
To: Linux-MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When gathering surplus pages, the number of needed pages is recomputed after
reacquiring hugetlb lock to catch changes in resv_huge_pages and
free_huge_pages. Plus it is recomputed with the number of newly allocated
pages involved.

Thus freeing pages could be deferred a bit to see if the final page request is
satisfied, though pages could be allocated less than needed.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/hugetlb.c	Tue Feb 14 20:10:46 2012
+++ b/mm/hugetlb.c	Tue Feb 14 20:19:42 2012
@@ -852,6 +852,7 @@ static int gather_surplus_pages(struct h
 	struct page *page, *tmp;
 	int ret, i;
 	int needed, allocated;
+	bool alloc_ok = true;

 	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
 	if (needed <= 0) {
@@ -867,17 +868,13 @@ retry:
 	spin_unlock(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
-		if (!page)
-			/*
-			 * We were not able to allocate enough pages to
-			 * satisfy the entire reservation so we free what
-			 * we've allocated so far.
-			 */
-			goto free;
-
+		if (!page) {
+			alloc_ok = false;
+			break;
+		}
 		list_add(&page->lru, &surplus_list);
 	}
-	allocated += needed;
+	allocated += i;

 	/*
 	 * After retaking hugetlb_lock, we need to recalculate 'needed'
@@ -886,9 +883,16 @@ retry:
 	spin_lock(&hugetlb_lock);
 	needed = (h->resv_huge_pages + delta) -
 			(h->free_huge_pages + allocated);
-	if (needed > 0)
-		goto retry;
-
+	if (needed > 0) {
+		if (alloc_ok)
+			goto retry;
+		/*
+		 * We were not able to allocate enough pages to
+		 * satisfy the entire reservation so we free what
+		 * we've allocated so far.
+		 */
+		goto free;
+	}
 	/*
 	 * The surplus_list now contains _at_least_ the number of extra pages
 	 * needed to accommodate the reservation.  Add the appropriate number
@@ -914,10 +918,10 @@ retry:
 		VM_BUG_ON(page_count(page));
 		enqueue_huge_page(h, page);
 	}
+free:
 	spin_unlock(&hugetlb_lock);

 	/* Free unnecessary surplus pages to the buddy allocator */
-free:
 	if (!list_empty(&surplus_list)) {
 		list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
 			list_del(&page->lru);
--
