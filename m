Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab2KSOnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 09:43:12 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:38007 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2KSOnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 09:43:10 -0500
X-AuditID: cbfee61b-b7f616d00000319b-92-50aa457d8f04
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Francesco Lavra <francescolavra.fl@gmail.com>
Subject: [PATCH] mm: cma: skip watermarks check for already isolated blocks in
 split_free_page() fix
Date: Mon, 19 Nov 2012 15:42:49 +0100
Message-id: <1353336169-23868-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <50A7D524.2060809@gmail.com>
References: <50A7D524.2060809@gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJMWRmVeSWpSXmKPExsVy+t9jAd1a11UBBsueC1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MI5N/sBdc5qp40nSMrYHxFkcXIyeHhICJxKP2tewQtpjEhXvr
	2boYuTiEBBYxSnyY084KkhASWMEkcfubPYjNJmAo0fW2iw3EFhEIk/jTuA2shlngB5NEQ0tw
	FyMHh7BAmsSfJXkgYRYBVYkZXc+YQGxeAQ+JB4+/MYKUSAgoSMyZZAMS5hTQlHhyajUTxCYN
	iT2dF5gnMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRHs7WfSOxhXNVgcYhTgYFTi
	4fWYsDJAiDWxrLgy9xCjBAezkgjvK6VVAUK8KYmVValF+fFFpTmpxYcYpTlYlMR5mz1SAoQE
	0hNLUrNTUwtSi2CyTBycUg2MunWbvnkk/XskW7zy3HvL4PiLa3gdXTn2X2C4kdjZ+0Ci6JBu
	f/S7bp6WK5FlqkdUSw72Gt+KM3Q9UPzUc/eSFQc6Y6yfH954/1pfq3duTttLD5uysq1ZnqVd
	l6wmOl/z4fP/Vh9krxNSdavv1Xru68JBjtVemxd1XL7A+qNvIuck6aijdT+VWIozEg21mIuK
	EwHJQ70T8gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup and simplify the code which uses page migrate type.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 mm/page_alloc.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6b990cb..f05365f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1393,12 +1393,15 @@ int capture_free_page(struct page *page, int alloc_order, int migratetype)
 
 	zone = page_zone(page);
 	order = page_order(page);
+	mt = get_pageblock_migratetype(page);
 
-	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE) {
+	if (mt != MIGRATE_ISOLATE) {
 		/* Obey watermarks as if the page was being allocated */
 		watermark = low_wmark_pages(zone) + (1 << order);
 		if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
 			return 0;
+
+		__mod_zone_freepage_state(zone, -(1UL << order), mt);
 	}
 
 	/* Remove page from free list */
@@ -1406,10 +1409,6 @@ int capture_free_page(struct page *page, int alloc_order, int migratetype)
 	zone->free_area[order].nr_free--;
 	rmv_page_order(page);
 
-	mt = get_pageblock_migratetype(page);
-	if (unlikely(mt != MIGRATE_ISOLATE))
-		__mod_zone_freepage_state(zone, -(1UL << order), mt);
-
 	if (alloc_order != order)
 		expand(zone, page, alloc_order, order,
 			&zone->free_area[order], migratetype);
-- 
1.7.9.5

