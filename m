Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab2KLJAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 04:00:20 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:27034 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab2KLJAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 04:00:19 -0500
X-AuditID: cbfee61b-b7f616d00000319b-29-50a0baa29f13
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] mm: cma: allocate pages from CMA if NR_FREE_PAGES approaches
 low water mark
Date: Mon, 12 Nov 2012 09:59:42 +0100
Message-id: <1352710782-25425-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jAd1FuxYEGMyYLGZxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyFv/bzVawlLti4cHZzA2Myzi7GDk5JARMJE6damOHsMUkLtxb
	z9bFyMUhJLCIUeLOnmXMEM4KJomu6d9ZQKrYBAwlut52sYHYIgJhEn8at7GCFDGDFF28u48V
	JCEsECcx/c0usCIWAVWJph1vwOK8Ah4Sh49dZupi5ABapyAxZ5LNBEbuBYwMqxhFUwuSC4qT
	0nON9IoTc4tL89L1kvNzNzGCffhMegfjqgaLQ4wCHIxKPLwKEQsChFgTy4orcw8xSnAwK4nw
	+u4ECvGmJFZWpRblxxeV5qQWH2KU5mBREudt9kgJEBJITyxJzU5NLUgtgskycXBKNTA2SQvM
	lAnlljnYUiPyce4X/s5rs9IP1fc1nTO066tr+Gk6x7TilUl229sjO/7sEHvwrv2Exla7A+c8
	0/PYxWU9G7cn3t6x9PuNreJ93esCePbG2cw7PP/4jQS5kvdnXt45vV3t5uYdTYcbvhQZC+8O
	rNoUcPZs0PsbIe6SVZZuId3s+ZeqtwsqsRRnJBpqMRcVJwIArDa+ON0BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been observed that system tends to keep a lot of CMA free pages
even in very high memory pressure use cases. The CMA fallback for movable
pages is used very rarely, only when system is completely pruned from
MOVABLE pages, what usually means that the out-of-memory even will be
triggered very soon. To avoid such situation and make better use of CMA
pages, a heuristics is introduced which turns on CMA fallback for movable
pages when the real number of free pages (excluding CMA free pages)
approaches low water mark.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Michal Nazarewicz <mina86@mina86.com>
---
 mm/page_alloc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fcb9719..90b51f3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1076,6 +1076,15 @@ static struct page *__rmqueue(struct zone *zone, unsigned int order,
 {
 	struct page *page;
 
+#ifdef CONFIG_CMA
+	unsigned long nr_free = zone_page_state(zone, NR_FREE_PAGES);
+	unsigned long nr_cma_free = zone_page_state(zone, NR_FREE_CMA_PAGES);
+
+	if (migratetype == MIGRATE_MOVABLE && nr_cma_free &&
+	    nr_free - nr_cma_free < 2 * low_wmark_pages(zone))
+		migratetype = MIGRATE_CMA;
+#endif /* CONFIG_CMA */
+
 retry_reserve:
 	page = __rmqueue_smallest(zone, order, migratetype);
 
-- 
1.7.9.5

