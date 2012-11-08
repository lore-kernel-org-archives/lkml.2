Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab2KHG7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 01:59:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:42811 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab2KHG7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 01:59:35 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-c7-509b58558ffb
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] mm: skip watermarks check for already isolated blocks in
 split_free_page()
Date: Thu, 08 Nov 2012 07:59:04 +0100
Message-id: <1352357944-14830-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jQd3QiNkBBr9Xa1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M2evWMRcs4ayYfGQFUwPjSfYuRk4OCQETiZ/znjJD2GISF+6t
	Z+ti5OIQEpjOKHHsUQ8ThLOCSeLL2jYmkCo2AUOJrrddbCC2iECYxJ/GbawgRcwCx5kk/lxc
	C5YQFoiVOLboKiOIzSKgKvFg7TOwdbwCHhK3/u0FsjmA1ilIzJlkM4GRewEjwypG0dSC5ILi
	pPRcQ73ixNzi0rx0veT83E2MYB8+k9rBuLLB4hCjAAejEg+vhuTsACHWxLLiytxDjBIczEoi
	vMucgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5mz1SAoQE0hNLUrNTUwtSi2CyTBycUg2MVQ9T
	7O7fnPeFUV/o2OH3e4/VG3KqBxgtOarhPC2W4Z/C0p9i5fMNGndez778OfYN4wMv9kineZL7
	w/bvtPT9MzVSp/Oiu4y3Rwc7y96+PydKJSNU7G87+wu29b7+6bDKlIkh6PLHCVtC1a7Jddgn
	Ck187lsg9flhl83vJ7F509eU32p/fGqFEktxRqKhFnNRcSIArGSD/d0BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 2139cbe627b8 ("cma: fix counting of isolated pages") free
pages in isolated pageblocks are not accounted to NR_FREE_PAGES counters,
so watermarks check is not required if one operates on a free page in
isolated pageblock.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 mm/page_alloc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fd154fe..43ab09f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1394,10 +1394,12 @@ int capture_free_page(struct page *page, int alloc_order, int migratetype)
 	zone = page_zone(page);
 	order = page_order(page);
 
-	/* Obey watermarks as if the page was being allocated */
-	watermark = low_wmark_pages(zone) + (1 << order);
-	if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
-		return 0;
+	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE) {
+		/* Obey watermarks as if the page was being allocated */
+		watermark = low_wmark_pages(zone) + (1 << order);
+		if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
+			return 0;
+	}
 
 	/* Remove page from free list */
 	list_del(&page->lru);
-- 
1.7.9.5

