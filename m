Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2LNCPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 21:15:31 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:15355 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab2LNCPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 21:15:24 -0500
Message-ID: <50CA8B96.4000208@huawei.com>
Date: Fri, 14 Dec 2012 10:14:46 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xishi Qiu <qiuxishi@huawei.com>, WuJianguo <wujianguo@huawei.com>,
        Liujiang <jiang.liu@huawei.com>, Simon Jeons <simon.jeons@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, <n-horiguchi@ah.jp.nec.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V4 1/3 RESEND] MCE: fix an error of mce_bad_pages statistics
References: <50C7FB7D.2060801@huawei.com>
In-Reply-To: <50C7FB7D.2060801@huawei.com>
X-Forwarded-Message-Id: <50C7FB7D.2060801@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move poisoned page check at the beginning of the function in order to
fix the error.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Tested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/memory-failure.c |   38 +++++++++++++++++---------------------
 1 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 8b20278..3a8b4b2 100644
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
@@ -1441,12 +1440,11 @@ static int soft_offline_huge_page(struct page *page, int flags)
 		return ret;
 	}
 done:
-	if (!PageHWPoison(hpage))
-		atomic_long_add(1 << compound_trans_order(hpage),
-				&mce_bad_pages);
+	/* keep elevated page count for bad page */
+	atomic_long_add(1 << compound_trans_order(hpage), &mce_bad_pages);
 	set_page_hwpoison_huge_page(hpage);
 	dequeue_hwpoisoned_huge_page(hpage);
-	/* keep elevated page count for bad page */
+
 	return ret;
 }

@@ -1488,6 +1486,11 @@ int soft_offline_page(struct page *page, int flags)
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
@@ -1519,19 +1522,11 @@ int soft_offline_page(struct page *page, int flags)
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
@@ -1582,8 +1577,9 @@ int soft_offline_page(struct page *page, int flags)
 		return ret;

 done:
+	/* keep elevated page count for bad page */
 	atomic_long_add(1, &mce_bad_pages);
 	SetPageHWPoison(page);
-	/* keep elevated page count for bad page */
+
 	return ret;
 }
-- 
1.7.1



.


