Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab0E1AeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:34:00 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:47194 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab0E1AdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:33:00 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 4/8] HWPOISON, hugetlb: set/clear PG_hwpoison bits on hugepage
Date: Fri, 28 May 2010 09:29:18 +0900
Message-Id: <1275006562-18946-5-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1275006562-18946-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1275006562-18946-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid race condition between concurrent memory errors on identified
hugepage, we atomically test and set PG_hwpoison bit on the head page.
All pages in the error hugepage are considered as hwpoisoned
for now, so set and clear all PG_hwpoison bits in the hugepage
with page lock of the head page held.

Dependency:
  "HWPOISON, hugetlb: enable error handling path for hugepage"

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/memory-failure.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git v2.6.34/mm/memory-failure.c v2.6.34/mm/memory-failure.c
index 1ec68c8..fee648b 100644
--- v2.6.34/mm/memory-failure.c
+++ v2.6.34/mm/memory-failure.c
@@ -920,6 +920,22 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	return ret;
 }
 
+static void set_page_hwpoison_huge_page(struct page *hpage)
+{
+	int i;
+	int nr_pages = 1 << compound_order(hpage);
+	for (i = 0; i < nr_pages; i++)
+		SetPageHWPoison(hpage + i);
+}
+
+static void clear_page_hwpoison_huge_page(struct page *hpage)
+{
+	int i;
+	int nr_pages = 1 << compound_order(hpage);
+	for (i = 0; i < nr_pages; i++)
+		ClearPageHWPoison(hpage + i);
+}
+
 int __memory_failure(unsigned long pfn, int trapno, int flags)
 {
 	struct page_state *ps;
@@ -1014,6 +1030,26 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 		return 0;
 	}
 
+	/*
+	 * For error on the tail page, we should set PG_hwpoison
+	 * on the head page to show that the hugepage is hwpoisoned
+	 */
+	if (PageTail(p) && TestSetPageHWPoison(hpage)) {
+		action_result(pfn, "hugepage already hardware poisoned",
+				IGNORED);
+		unlock_page(hpage);
+		put_page(hpage);
+		return 0;
+	}
+	/*
+	 * Set PG_hwpoison on all pages in an error hugepage,
+	 * because containment is done in hugepage unit for now.
+	 * Since we have done TestSetPageHWPoison() for the head page with
+	 * page lock held, we can safely set PG_hwpoison bits on tail pages.
+	 */
+	if (PageHuge(p))
+		set_page_hwpoison_huge_page(hpage);
+
 	wait_on_page_writeback(p);
 
 	/*
@@ -1118,6 +1154,8 @@ int unpoison_memory(unsigned long pfn)
 		atomic_long_dec(&mce_bad_pages);
 		freeit = 1;
 	}
+	if (PageHuge(p))
+		clear_page_hwpoison_huge_page(page);
 	unlock_page(page);
 
 	put_page(page);
-- 
1.7.0

