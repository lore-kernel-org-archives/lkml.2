Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab0EMH5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:57:49 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:48591 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758154Ab0EMH5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:57:36 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: n-horiguchi@ah.jp.nec.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 4/7] HWPOISON, hugetlb: maintain mce_bad_pages in handling hugepage error
Date: Thu, 13 May 2010 16:55:23 +0900
Message-Id: <1273737326-21211-5-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1273737326-21211-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1273737326-21211-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now all pages in the error hugepage are considered as hwpoisoned,
so count all of them in mce_bad_pages.

Dependency:
  "HWPOISON, hugetlb: enable error handling path for hugepage"

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memory-failure.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git v2.6.34-rc7/mm/memory-failure.c v2.6.34-rc7/mm/memory-failure.c
index fee648b..473f15a 100644
--- v2.6.34-rc7/mm/memory-failure.c
+++ v2.6.34-rc7/mm/memory-failure.c
@@ -942,6 +942,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	struct page *p;
 	struct page *hpage;
 	int res;
+	unsigned int nr_pages;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure from trap %d on page %lx", trapno, pfn);
@@ -960,7 +961,8 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 		return 0;
 	}
 
-	atomic_long_add(1, &mce_bad_pages);
+	nr_pages = 1 << compound_order(hpage);
+	atomic_long_add(nr_pages, &mce_bad_pages);
 
 	/*
 	 * We need/can do nothing about count=0 pages.
@@ -1024,7 +1026,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	}
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
-			atomic_long_dec(&mce_bad_pages);
+			atomic_long_sub(nr_pages, &mce_bad_pages);
 		unlock_page(hpage);
 		put_page(hpage);
 		return 0;
@@ -1123,6 +1125,7 @@ int unpoison_memory(unsigned long pfn)
 	struct page *page;
 	struct page *p;
 	int freeit = 0;
+	unsigned int nr_pages;
 
 	if (!pfn_valid(pfn))
 		return -ENXIO;
@@ -1135,9 +1138,11 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
+	nr_pages = 1 << compound_order(page);
+
 	if (!get_page_unless_zero(page)) {
 		if (TestClearPageHWPoison(p))
-			atomic_long_dec(&mce_bad_pages);
+			atomic_long_sub(nr_pages, &mce_bad_pages);
 		pr_debug("MCE: Software-unpoisoned free page %#lx\n", pfn);
 		return 0;
 	}
@@ -1149,9 +1154,9 @@ int unpoison_memory(unsigned long pfn)
 	 * the PG_hwpoison page will be caught and isolated on the entrance to
 	 * the free buddy page pool.
 	 */
-	if (TestClearPageHWPoison(p)) {
+	if (TestClearPageHWPoison(page)) {
 		pr_debug("MCE: Software-unpoisoned page %#lx\n", pfn);
-		atomic_long_dec(&mce_bad_pages);
+		atomic_long_sub(nr_pages, &mce_bad_pages);
 		freeit = 1;
 	}
 	if (PageHuge(p))
-- 
1.7.0

