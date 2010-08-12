Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab0HLICT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 04:02:19 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:36472 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab0HLICO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 04:02:14 -0400
Date: Thu, 12 Aug 2010 17:00:23 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] HWPOISON: replace locking functions into hugepage
 variants
Message-ID: <20100812080023.GE6112@spritzera.linux.bs1.fc.nec.co.jp>
References: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <alpine.DEB.2.00.1008110806070.673@router.home>
 <20100812075323.GA6112@spritzera.linux.bs1.fc.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20100812075323.GA6112@spritzera.linux.bs1.fc.nec.co.jp>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/memory-failure.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e387098..2eb740e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1052,7 +1052,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	 * It's very difficult to mess with pages currently under IO
 	 * and in many cases impossible, so we just avoid it here.
 	 */
-	lock_page_nosync(hpage);
+	lock_page_against_memory_failure(hpage);
 
 	/*
 	 * unpoison always clear PG_hwpoison inside page lock
@@ -1065,7 +1065,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
 			atomic_long_sub(nr_pages, &mce_bad_pages);
-		unlock_page(hpage);
+		unlock_page_against_memory_failure(hpage);
 		put_page(hpage);
 		return 0;
 	}
@@ -1077,7 +1077,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	if (PageTail(p) && TestSetPageHWPoison(hpage)) {
 		action_result(pfn, "hugepage already hardware poisoned",
 				IGNORED);
-		unlock_page(hpage);
+		unlock_page_against_memory_failure(hpage);
 		put_page(hpage);
 		return 0;
 	}
@@ -1090,7 +1090,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	if (PageHuge(p))
 		set_page_hwpoison_huge_page(hpage);
 
-	wait_on_page_writeback(p);
+	wait_on_pages_writeback_against_memory_failure(hpage);
 
 	/*
 	 * Now take care of user space mappings.
@@ -1119,7 +1119,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 		}
 	}
 out:
-	unlock_page(hpage);
+	unlock_page_against_memory_failure(hpage);
 	return res;
 }
 EXPORT_SYMBOL_GPL(__memory_failure);
@@ -1195,7 +1195,7 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
-	lock_page_nosync(page);
+	lock_page_against_memory_failure(page);
 	/*
 	 * This test is racy because PG_hwpoison is set outside of page lock.
 	 * That's acceptable because that won't trigger kernel panic. Instead,
@@ -1209,7 +1209,7 @@ int unpoison_memory(unsigned long pfn)
 		if (PageHuge(page))
 			clear_page_hwpoison_huge_page(page);
 	}
-	unlock_page(page);
+	unlock_page_against_memory_failure(page);
 
 	put_page(page);
 	if (freeit)
@@ -1341,14 +1341,14 @@ int soft_offline_page(struct page *page, int flags)
 		return -EIO;
 	}
 
-	lock_page(hpage);
-	wait_on_page_writeback(hpage);
+	lock_page_against_memory_failure(hpage);
+	wait_on_pages_writeback_against_memory_failure(hpage);
 
 	/*
 	 * Synchronized using the page lock with memory_failure()
 	 */
 	if (PageHWPoison(hpage)) {
-		unlock_page(hpage);
+		unlock_page_against_memory_failure(hpage);
 		put_page(hpage);
 		pr_debug("soft offline: %#lx page already poisoned\n", pfn);
 		return -EBUSY;
-- 
1.7.2.1

