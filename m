Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab2LNCPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 21:15:32 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:15356 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab2LNCPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 21:15:24 -0500
Message-ID: <50CA8B9F.7050800@huawei.com>
Date: Fri, 14 Dec 2012 10:14:55 +0800
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
Subject: [PATCH V4 2/3 RESEND] MCE: do code refactor of soft_offline_page
References: <50C7FB82.7050802@huawei.com>
In-Reply-To: <50C7FB82.7050802@huawei.com>
X-Forwarded-Message-Id: <50C7FB82.7050802@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are too many return points randomly intermingled with some
"goto done" return points. So adjust the function structure, one
for the success path, the other for the failure path.
Use atomic_long_inc instead of atomic_long_add.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/memory-failure.c |   34 ++++++++++++++++++++--------------
 1 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 3a8b4b2..e513a7b 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1421,12 +1421,13 @@ static int soft_offline_huge_page(struct page *page, int flags)

 	if (PageHWPoison(hpage)) {
 		pr_info("soft offline: %#lx hugepage already poisoned\n", pfn);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out;
 	}

 	ret = get_any_page(page, pfn, flags);
 	if (ret < 0)
-		return ret;
+		goto out;
 	if (ret == 0)
 		goto done;

@@ -1437,14 +1438,14 @@ static int soft_offline_huge_page(struct page *page, int flags)
 	if (ret) {
 		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
 			pfn, ret, page->flags);
-		return ret;
+		goto out;
 	}
 done:
 	/* keep elevated page count for bad page */
 	atomic_long_add(1 << compound_trans_order(hpage), &mce_bad_pages);
 	set_page_hwpoison_huge_page(hpage);
 	dequeue_hwpoisoned_huge_page(hpage);
-
+out:
 	return ret;
 }

@@ -1476,24 +1477,28 @@ int soft_offline_page(struct page *page, int flags)
 	unsigned long pfn = page_to_pfn(page);
 	struct page *hpage = compound_trans_head(page);

-	if (PageHuge(page))
-		return soft_offline_huge_page(page, flags);
+	if (PageHuge(page)) {
+		ret = soft_offline_huge_page(page, flags);
+		goto out;
+	}
 	if (PageTransHuge(hpage)) {
 		if (PageAnon(hpage) && unlikely(split_huge_page(hpage))) {
 			pr_info("soft offline: %#lx: failed to split THP\n",
 				pfn);
-			return -EBUSY;
+			ret = -EBUSY;
+			goto out;
 		}
 	}

 	if (PageHWPoison(page)) {
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out;
 	}

 	ret = get_any_page(page, pfn, flags);
 	if (ret < 0)
-		return ret;
+		goto out;
 	if (ret == 0)
 		goto done;

@@ -1512,14 +1517,15 @@ int soft_offline_page(struct page *page, int flags)
 		 */
 		ret = get_any_page(page, pfn, 0);
 		if (ret < 0)
-			return ret;
+			goto out;
 		if (ret == 0)
 			goto done;
 	}
 	if (!PageLRU(page)) {
 		pr_info("soft_offline: %#lx: unknown non LRU page type %lx\n",
 			pfn, page->flags);
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}

 	/*
@@ -1574,12 +1580,12 @@ int soft_offline_page(struct page *page, int flags)
 			pfn, ret, page_count(page), page->flags);
 	}
 	if (ret)
-		return ret;
+		goto out;

 done:
 	/* keep elevated page count for bad page */
-	atomic_long_add(1, &mce_bad_pages);
+	atomic_long_inc(&mce_bad_pages);
 	SetPageHWPoison(page);
-
+out:
 	return ret;
 }
-- 
1.7.1



.


