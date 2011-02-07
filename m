Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1BGEop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 23:44:45 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48092 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1BGEon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 23:44:43 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4D4F798C.1040205@np.css.fujitsu.com>
Date: Mon, 07 Feb 2011 13:48:12 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Huang Ying <ying.huang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: [Resend][PATCH -v2 3/3 -next] Fix the wrong corrupted page information
 of hugetlb page.
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When more than on tail page of the same mapped hugetlb page are
poisoned at the same time, the sum of corrupted page should be
the size of one hugetlb page(512 pages). But HardwareCorrupted
information in /proc/meminfo is 1024 pages or more.

That is because when the above condition happened,
__memory_failure() will be called many times and pages in hugetlb
page are accounted more than one time.

This patch fixed it by incrementing the number of corrupted page
one by one.

-v2 fix checking for "just unpoisoned".

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/memory-failure.c |   75 +++++++++++++++++++++++++++++++-------------------
 1 files changed, 46 insertions(+), 29 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 0317cb3..0a11f6d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -974,16 +974,22 @@ static void set_page_hwpoison_huge_page(struct page *hpage)
 {
 	int i;
 	int nr_pages = 1 << compound_trans_order(hpage);
-	for (i = 0; i < nr_pages; i++)
-		SetPageHWPoison(hpage + i);
+	for (i = 0; i < nr_pages; i++) {
+		if (TestSetPageHWPoison(hpage + i))
+			continue;
+
+		atomic_long_inc(&mce_bad_pages);
+	}
 }
 
 static void clear_page_hwpoison_huge_page(struct page *hpage)
 {
 	int i;
 	int nr_pages = 1 << compound_trans_order(hpage);
-	for (i = 0; i < nr_pages; i++)
-		ClearPageHWPoison(hpage + i);
+	for (i = 0; i < nr_pages; i++) {
+		if (TestClearPageHWPoison(hpage + i))
+			atomic_long_dec(&mce_bad_pages);
+	}
 }
 
 int __memory_failure(unsigned long pfn, int trapno, int flags)
@@ -992,7 +998,6 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	struct page *p;
 	struct page *hpage;
 	int res;
-	unsigned int nr_pages;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure from trap %d on page %lx", trapno, pfn);
@@ -1011,8 +1016,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 		return 0;
 	}
 
-	nr_pages = 1 << compound_trans_order(hpage);
-	atomic_long_add(nr_pages, &mce_bad_pages);
+	atomic_long_inc(&mce_bad_pages);
 
 	/*
 	 * We need/can do nothing about count=0 pages.
@@ -1034,18 +1038,32 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 			action_result(pfn, "free buddy", DELAYED);
 			return 0;
 		} else if (PageHuge(hpage)) {
-			/*
-			 * Check "just unpoisoned", "filter hit", and
-			 * "race with other subpage."
-			 */
 			lock_page_nosync(hpage);
-			if (!PageHWPoison(p)
-			    || (hwpoison_filter(p) && TestClearPageHWPoison(p))
-			    || (p != hpage && TestSetPageHWPoison(hpage))) {
-				atomic_long_sub(nr_pages, &mce_bad_pages);
+			/* Check "just unpoisoned". */
+			if (!PageHWPoison(p)) {
 				unlock_page(hpage);
 				return 0;
 			}
+
+			/* Check "filter hit". */
+			if (hwpoison_filter(p)) {
+				if (TestClearPageHWPoison(p))
+					atomic_long_dec(&mce_bad_pages);
+
+				unlock_page(hpage);
+				return 0;
+			}
+
+			/* Check "race with other subpage". */
+			if (p != hpage) {
+				if (TestSetPageHWPoison(hpage)) {
+					unlock_page(hpage);
+					return 0;
+				}
+
+				atomic_long_inc(&mce_bad_pages);
+			}
+
 			set_page_hwpoison_huge_page(hpage);
 			res = dequeue_hwpoisoned_huge_page(hpage);
 			action_result(pfn, "free huge",
@@ -1101,7 +1119,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	}
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
-			atomic_long_sub(nr_pages, &mce_bad_pages);
+			atomic_long_dec(&mce_bad_pages);
 		unlock_page(hpage);
 		put_page(hpage);
 		return 0;
@@ -1111,12 +1129,16 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	 * For error on the tail page, we should set PG_hwpoison
 	 * on the head page to show that the hugepage is hwpoisoned
 	 */
-	if (PageHuge(p) && PageTail(p) && TestSetPageHWPoison(hpage)) {
-		action_result(pfn, "hugepage already hardware poisoned",
+	if (PageHuge(p) && PageTail(p)) {
+		if (TestSetPageHWPoison(hpage)) {
+			action_result(pfn, "hugepage already hardware poisoned",
 				IGNORED);
-		unlock_page(hpage);
-		put_page(hpage);
-		return 0;
+			unlock_page(hpage);
+			put_page(hpage);
+			return 0;
+		}
+
+		atomic_long_inc(&mce_bad_pages);
 	}
 	/*
 	 * Set PG_hwpoison on all pages in an error hugepage,
@@ -1200,7 +1222,6 @@ int unpoison_memory(unsigned long pfn)
 	struct page *page;
 	struct page *p;
 	int freeit = 0;
-	unsigned int nr_pages;
 
 	if (!pfn_valid(pfn))
 		return -ENXIO;
@@ -1213,8 +1234,6 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
-	nr_pages = 1 << compound_trans_order(page);
-
 	if (!get_page_unless_zero(page)) {
 		/*
 		 * Since HWPoisoned hugepage should have non-zero refcount,
@@ -1227,7 +1246,7 @@ int unpoison_memory(unsigned long pfn)
 			return 0;
 		}
 		if (TestClearPageHWPoison(p))
-			atomic_long_sub(nr_pages, &mce_bad_pages);
+			atomic_long_dec(&mce_bad_pages);
 		pr_info("MCE: Software-unpoisoned free page %#lx\n", pfn);
 		return 0;
 	}
@@ -1241,7 +1260,7 @@ int unpoison_memory(unsigned long pfn)
 	 */
 	if (TestClearPageHWPoison(page)) {
 		pr_info("MCE: Software-unpoisoned page %#lx\n", pfn);
-		atomic_long_sub(nr_pages, &mce_bad_pages);
+		atomic_long_dec(&mce_bad_pages);
 		freeit = 1;
 		if (PageHuge(page))
 			clear_page_hwpoison_huge_page(page);
@@ -1353,8 +1372,6 @@ static int soft_offline_huge_page(struct page *page, int flags)
 		return ret;
 	}
 done:
-	if (!PageHWPoison(hpage))
-		atomic_long_add(1 << compound_trans_order(hpage), &mce_bad_pages);
 	set_page_hwpoison_huge_page(hpage);
 	dequeue_hwpoisoned_huge_page(hpage);
 	/* keep elevated page count for bad page */
@@ -1483,7 +1500,7 @@ int soft_offline_page(struct page *page, int flags)
 		return ret;
 
 done:
-	atomic_long_add(1, &mce_bad_pages);
+	atomic_long_inc(&mce_bad_pages);
 	SetPageHWPoison(page);
 	/* keep elevated page count for bad page */
 	return ret;
-- 
1.7.2.2


