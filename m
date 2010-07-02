Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab0GBFtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 01:49:42 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:46294 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab0GBFtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 01:49:40 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] hugetlb, HWPOISON: soft offlining for hugepage
Date: Fri,  2 Jul 2010 14:47:26 +0900
Message-Id: <1278049646-29769-8-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends soft offlining framework to support hugepage.
When memory corrected errors occur repeatedly on a hugepage,
we can choose to stop using it by migrating data onto another hugepage
and disabling the original (maybe half-broken) one.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 include/linux/hugetlb.h |    2 +
 mm/hugetlb.c            |    7 +++++
 mm/memory-failure.c     |   57 +++++++++++++++++++++++++++++++++++-----------
 3 files changed, 52 insertions(+), 14 deletions(-)

diff --git v2.6.35-rc3-hwpoison/include/linux/hugetlb.h v2.6.35-rc3-hwpoison/include/linux/hugetlb.h
index 952e3ce..cb3c373 100644
--- v2.6.35-rc3-hwpoison/include/linux/hugetlb.h
+++ v2.6.35-rc3-hwpoison/include/linux/hugetlb.h
@@ -44,6 +44,7 @@ int hugetlb_reserve_pages(struct inode *inode, long from, long to,
 						int acctflags);
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed);
 void __isolate_hwpoisoned_huge_page(struct page *page);
+void isolate_hwpoisoned_huge_page(struct page *page);
 
 extern unsigned long hugepages_treat_as_movable;
 extern const unsigned long hugetlb_zero, hugetlb_infinity;
@@ -102,6 +103,7 @@ static inline void hugetlb_report_meminfo(struct seq_file *m)
 #define hugetlb_fault(mm, vma, addr, flags)	({ BUG(); 0; })
 #define huge_pte_offset(mm, address)	0
 #define __isolate_hwpoisoned_huge_page(page)	0
+#define isolate_hwpoisoned_huge_page(page)	0
 
 #define hugetlb_change_protection(vma, address, end, newprot)
 
diff --git v2.6.35-rc3-hwpoison/mm/hugetlb.c v2.6.35-rc3-hwpoison/mm/hugetlb.c
index 6e7f5f2..fe01ff2 100644
--- v2.6.35-rc3-hwpoison/mm/hugetlb.c
+++ v2.6.35-rc3-hwpoison/mm/hugetlb.c
@@ -2947,3 +2947,10 @@ void __isolate_hwpoisoned_huge_page(struct page *hpage)
 	h->free_huge_pages_node[nid]--;
 	spin_unlock(&hugetlb_lock);
 }
+
+void isolate_hwpoisoned_huge_page(struct page *hpage)
+{
+	lock_page(hpage);
+	__isolate_hwpoisoned_huge_page(hpage);
+	unlock_page(hpage);
+}
diff --git v2.6.35-rc3-hwpoison/mm/memory-failure.c v2.6.35-rc3-hwpoison/mm/memory-failure.c
index d0b420a..c6516df 100644
--- v2.6.35-rc3-hwpoison/mm/memory-failure.c
+++ v2.6.35-rc3-hwpoison/mm/memory-failure.c
@@ -1186,7 +1186,10 @@ EXPORT_SYMBOL(unpoison_memory);
 static struct page *new_page(struct page *p, unsigned long private, int **x)
 {
 	int nid = page_to_nid(p);
-	return alloc_pages_exact_node(nid, GFP_HIGHUSER_MOVABLE, 0);
+	if (PageHuge(p))
+		return alloc_huge_page_node(page_hstate(compound_head(p)), nid);
+	else
+		return alloc_pages_exact_node(nid, GFP_HIGHUSER_MOVABLE, 0);
 }
 
 /*
@@ -1214,7 +1217,20 @@ static int get_any_page(struct page *p, unsigned long pfn, int flags)
 	 * was free.
 	 */
 	set_migratetype_isolate(p);
-	if (!get_page_unless_zero(compound_head(p))) {
+	/*
+	 * When the target page is a free hugepage, just remove it
+	 * from free hugepage list.
+	 */
+	if (PageHuge(p)) {
+		struct page *hpage = compound_head(p);
+		if (!get_page_unless_zero(hpage)) {
+			pr_debug("get_any_page: %#lx free huge page\n", pfn);
+			isolate_hwpoisoned_huge_page(hpage);
+			set_page_hwpoison_huge_page(hpage);
+			ret = 0;
+		} else
+			ret = 1;
+	} else if (!get_page_unless_zero(compound_head(p))) {
 		if (is_free_buddy_page(p)) {
 			pr_debug("get_any_page: %#lx free buddy page\n", pfn);
 			/* Set hwpoison bit while page is still isolated */
@@ -1260,6 +1276,7 @@ int soft_offline_page(struct page *page, int flags)
 {
 	int ret;
 	unsigned long pfn = page_to_pfn(page);
+	struct page *hpage = compound_head(page);
 
 	ret = get_any_page(page, pfn, flags);
 	if (ret < 0)
@@ -1270,7 +1287,7 @@ int soft_offline_page(struct page *page, int flags)
 	/*
 	 * Page cache page we can handle?
 	 */
-	if (!PageLRU(page)) {
+	if (!PageLRU(page) && !PageHuge(page)) {
 		/*
 		 * Try to free it.
 		 */
@@ -1286,21 +1303,21 @@ int soft_offline_page(struct page *page, int flags)
 		if (ret == 0)
 			goto done;
 	}
-	if (!PageLRU(page)) {
+	if (!PageLRU(page) && !PageHuge(page)) {
 		pr_debug("soft_offline: %#lx: unknown non LRU page type %lx\n",
 				pfn, page->flags);
 		return -EIO;
 	}
 
-	lock_page(page);
-	wait_on_page_writeback(page);
+	lock_page(hpage);
+	wait_on_page_writeback(hpage);
 
 	/*
 	 * Synchronized using the page lock with memory_failure()
 	 */
-	if (PageHWPoison(page)) {
-		unlock_page(page);
-		put_page(page);
+	if (PageHWPoison(page) || (PageTail(page) && PageHWPoison(hpage))) {
+		unlock_page(hpage);
+		put_page(hpage);
 		pr_debug("soft offline: %#lx page already poisoned\n", pfn);
 		return -EBUSY;
 	}
@@ -1310,7 +1327,7 @@ int soft_offline_page(struct page *page, int flags)
 	 * non dirty unmapped page cache pages.
 	 */
 	ret = invalidate_inode_page(page);
-	unlock_page(page);
+	unlock_page(hpage);
 
 	/*
 	 * Drop count because page migration doesn't like raised
@@ -1319,7 +1336,16 @@ int soft_offline_page(struct page *page, int flags)
 	 * RED-PEN would be better to keep it isolated here, but we
 	 * would need to fix isolation locking first.
 	 */
-	put_page(page);
+	put_page(hpage);
+
+	/*
+	 * Hugepage is not involved in LRU list, so skip LRU isolation.
+	 */
+	if (PageHuge(page)) {
+		ret = 0;
+		goto do_migrate;
+	}
+
 	if (ret == 1) {
 		ret = 0;
 		pr_debug("soft_offline: %#lx: invalidated\n", pfn);
@@ -1332,10 +1358,11 @@ int soft_offline_page(struct page *page, int flags)
 	 * handles a large number of cases for us.
 	 */
 	ret = isolate_lru_page(page);
+do_migrate:
 	if (!ret) {
 		LIST_HEAD(pagelist);
 
-		list_add(&page->lru, &pagelist);
+		list_add(&hpage->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0);
 		if (ret) {
 			pr_debug("soft offline: %#lx: migration failed %d, type %lx\n",
@@ -1343,6 +1370,8 @@ int soft_offline_page(struct page *page, int flags)
 			if (ret > 0)
 				ret = -EIO;
 		}
+		if (!ret && PageHuge(hpage))
+			isolate_hwpoisoned_huge_page(hpage);
 	} else {
 		pr_debug("soft offline: %#lx: isolation failed: %d, page count %d, type %lx\n",
 				pfn, ret, page_count(page), page->flags);
@@ -1351,8 +1380,8 @@ int soft_offline_page(struct page *page, int flags)
 		return ret;
 
 done:
-	atomic_long_add(1, &mce_bad_pages);
-	SetPageHWPoison(page);
+	atomic_long_add(1 << compound_order(hpage), &mce_bad_pages);
+	set_page_hwpoison_huge_page(hpage);
 	/* keep elevated page count for bad page */
 	return ret;
 }
-- 
1.7.1

