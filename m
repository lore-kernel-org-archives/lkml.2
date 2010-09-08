Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab0IHB3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 21:29:43 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:63388 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855Ab0IHB3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 21:29:40 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/10] hugetlb: move refcounting in hugepage allocation inside hugetlb_lock
Date: Wed,  8 Sep 2010 10:19:37 +0900
Message-Id: <1283908781-13810-7-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently alloc_huge_page() raises page refcount outside hugetlb_lock.
but it causes race when dequeue_hwpoison_huge_page() runs concurrently
with alloc_huge_page().
To avoid it, this patch moves set_page_refcounted() in hugetlb_lock.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/hugetlb.c |   35 +++++++++++++----------------------
 1 files changed, 13 insertions(+), 22 deletions(-)

diff --git v2.6.36-rc2/mm/hugetlb.c v2.6.36-rc2/mm/hugetlb.c
index 8948abc..adb5dfa 100644
--- v2.6.36-rc2/mm/hugetlb.c
+++ v2.6.36-rc2/mm/hugetlb.c
@@ -509,6 +509,7 @@ static struct page *dequeue_huge_page_node(struct hstate *h, int nid)
 		return NULL;
 	page = list_entry(h->hugepage_freelists[nid].next, struct page, lru);
 	list_del(&page->lru);
+	set_page_refcounted(page);
 	h->free_huge_pages--;
 	h->free_huge_pages_node[nid]--;
 	return page;
@@ -868,12 +869,6 @@ static struct page *alloc_buddy_huge_page(struct hstate *h, int nid)
 
 	spin_lock(&hugetlb_lock);
 	if (page) {
-		/*
-		 * This page is now managed by the hugetlb allocator and has
-		 * no users -- drop the buddy allocator's reference.
-		 */
-		put_page_testzero(page);
-		VM_BUG_ON(page_count(page));
 		r_nid = page_to_nid(page);
 		set_compound_page_dtor(page, free_huge_page);
 		/*
@@ -936,16 +931,13 @@ retry:
 	spin_unlock(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
-		if (!page) {
+		if (!page)
 			/*
 			 * We were not able to allocate enough pages to
 			 * satisfy the entire reservation so we free what
 			 * we've allocated so far.
 			 */
-			spin_lock(&hugetlb_lock);
-			needed = 0;
 			goto free;
-		}
 
 		list_add(&page->lru, &surplus_list);
 	}
@@ -972,31 +964,31 @@ retry:
 	needed += allocated;
 	h->resv_huge_pages += delta;
 	ret = 0;
-free:
+
+	spin_unlock(&hugetlb_lock);
 	/* Free the needed pages to the hugetlb pool */
 	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
 		if ((--needed) < 0)
 			break;
 		list_del(&page->lru);
+		/*
+		 * This page is now managed by the hugetlb allocator and has
+		 * no users -- drop the buddy allocator's reference.
+		 */
+		put_page_testzero(page);
+		VM_BUG_ON(page_count(page));
 		enqueue_huge_page(h, page);
 	}
 
 	/* Free unnecessary surplus pages to the buddy allocator */
+free:
 	if (!list_empty(&surplus_list)) {
-		spin_unlock(&hugetlb_lock);
 		list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
 			list_del(&page->lru);
-			/*
-			 * The page has a reference count of zero already, so
-			 * call free_huge_page directly instead of using
-			 * put_page.  This must be done with hugetlb_lock
-			 * unlocked which is safe because free_huge_page takes
-			 * hugetlb_lock before deciding how to free the page.
-			 */
-			free_huge_page(page);
+			put_page(page);
 		}
-		spin_lock(&hugetlb_lock);
 	}
+	spin_lock(&hugetlb_lock);
 
 	return ret;
 }
@@ -1123,7 +1115,6 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 		}
 	}
 
-	set_page_refcounted(page);
 	set_page_private(page, (unsigned long) mapping);
 
 	vma_commit_reservation(h, vma, addr);
-- 
1.7.2.2

