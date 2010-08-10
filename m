Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750842Ab0HJJeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:34:01 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:47013 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab0HJJdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:33:43 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/9] HWPOISON, hugetlb: fix unpoison for hugepage
Date: Tue, 10 Aug 2010 18:27:42 +0900
Message-Id: <1281432464-14833-8-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently unpoisoning hugepages doesn't work because it's not enough
to just clear PG_HWPoison bits and we need to link the hugepage
to be unpoisoned back to the free hugepage list.
To do this, we get and put hwpoisoned hugepage whose refcount is 0.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 mm/memory-failure.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git linux-mce-hwpoison/mm/memory-failure.c linux-mce-hwpoison/mm/memory-failure.c
index 0bfe5b3..1f54901 100644
--- linux-mce-hwpoison/mm/memory-failure.c
+++ linux-mce-hwpoison/mm/memory-failure.c
@@ -1153,9 +1153,19 @@ int unpoison_memory(unsigned long pfn)
 	nr_pages = 1 << compound_order(page);
 
 	if (!get_page_unless_zero(page)) {
-		if (TestClearPageHWPoison(p))
+		/* The page to be unpoisoned was free one when hwpoisoned */
+		if (TestClearPageHWPoison(page))
 			atomic_long_sub(nr_pages, &mce_bad_pages);
 		pr_debug("MCE: Software-unpoisoned free page %#lx\n", pfn);
+		if (PageHuge(page)) {
+			/*
+			 * To unpoison free hugepage, we get and put it
+			 * to move it back to the free list.
+			 */
+			get_page(page);
+			clear_page_hwpoison_huge_page(page);
+			put_page(page);
+		}
 		return 0;
 	}
 
@@ -1170,9 +1180,9 @@ int unpoison_memory(unsigned long pfn)
 		pr_debug("MCE: Software-unpoisoned page %#lx\n", pfn);
 		atomic_long_sub(nr_pages, &mce_bad_pages);
 		freeit = 1;
+		if (PageHuge(page))
+			clear_page_hwpoison_huge_page(page);
 	}
-	if (PageHuge(p))
-		clear_page_hwpoison_huge_page(page);
 	unlock_page(page);
 
 	put_page(page);
-- 
1.7.2.1

