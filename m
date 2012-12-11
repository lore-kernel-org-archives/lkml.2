Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab2LKMTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 07:19:13 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:31261 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab2LKMTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 07:19:08 -0500
Message-ID: <50C72493.3080009@huawei.com>
Date: Tue, 11 Dec 2012 20:18:27 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: WuJianguo <wujianguo@huawei.com>, Xishi Qiu <qiuxishi@huawei.com>,
        Liujiang <jiang.liu@huawei.com>, Simon Jeons <simon.jeons@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V3 1/2] MCE: fix an error of mce_bad_pages statistics
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) move poisoned page check at the beginning of the function.
2) add page_lock to avoid unpoison clear the flag.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
﻿Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 mm/memory-failure.c |   43 ++++++++++++++++++++++---------------------
 1 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 8b20278..9b74983 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1419,18 +1419,17 @@ static int soft_offline_huge_page(struct page *page, int flags)
 	unsigned long pfn = page_to_pfn(page);
 	struct page *hpage = compound_head(page);

+	if (PageHWPoison(hpage)) {
+		pr_info("soft offline: %#lx hugepage already poisoned\n", pfn);
+		return -EBUSY;
+	}
+
 	ret = get_any_page(page, pfn, flags);
 	if (ret < 0)
 		return ret;
 	if (ret == 0)
 		goto done;

-	if (PageHWPoison(hpage)) {
-		put_page(hpage);
-		pr_info("soft offline: %#lx hugepage already poisoned\n", pfn);
-		return -EBUSY;
-	}
-
 	/* Keep page count to indicate a given hugepage is isolated. */
 	ret = migrate_huge_page(hpage, new_page, MPOL_MF_MOVE_ALL, false,
 				MIGRATE_SYNC);
@@ -1441,12 +1440,14 @@ static int soft_offline_huge_page(struct page *page, int flags)
 		return ret;
 	}
 done:
-	if (!PageHWPoison(hpage))
-		atomic_long_add(1 << compound_trans_order(hpage),
-				&mce_bad_pages);
+	/* keep elevated page count for bad page */
+	lock_page(hpage);
+	atomic_long_add(1 << compound_trans_order(hpage), &mce_bad_pages);
 	set_page_hwpoison_huge_page(hpage);
+	unlock_page(hpage);
+
 	dequeue_hwpoisoned_huge_page(hpage);
-	/* keep elevated page count for bad page */
+
 	return ret;
 }

@@ -1488,6 +1489,11 @@ int soft_offline_page(struct page *page, int flags)
 		}
 	}

+	if (PageHWPoison(page)) {
+		pr_info("soft offline: %#lx page already poisoned\n", pfn);
+		return -EBUSY;
+	}
+
 	ret = get_any_page(page, pfn, flags);
 	if (ret < 0)
 		return ret;
@@ -1519,19 +1525,11 @@ int soft_offline_page(struct page *page, int flags)
 		return -EIO;
 	}

-	lock_page(page);
-	wait_on_page_writeback(page);
-
 	/*
 	 * Synchronized using the page lock with memory_failure()
 	 */
-	if (PageHWPoison(page)) {
-		unlock_page(page);
-		put_page(page);
-		pr_info("soft offline: %#lx page already poisoned\n", pfn);
-		return -EBUSY;
-	}
-
+	lock_page(page);
+	wait_on_page_writeback(page);
 	/*
 	 * Try to invalidate first. This should work for
 	 * non dirty unmapped page cache pages.
@@ -1582,8 +1580,11 @@ int soft_offline_page(struct page *page, int flags)
 		return ret;

 done:
+	/* keep elevated page count for bad page */
+	lock_page(page);
 	atomic_long_add(1, &mce_bad_pages);
 	SetPageHWPoison(page);
-	/* keep elevated page count for bad page */
+	unlock_page(page);
+
 	return ret;
 }
-- 
1.7.1


