Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab2KLLHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:07:53 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36315 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2KLLHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:07:52 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ad-50a0d886ecf8
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] mm: cma: WARN if freed memory is still in use
Date: Mon, 12 Nov 2012 12:07:26 +0100
Message-id: <1352718446-32313-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t9jAd22GwsCDBpumVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M9ZNnsRSsZ69YvjuzgbGFrYuRk0NCwERi9fcWZghbTOLCvfVA
	cS4OIYFFjBLPG08xQzgrmCReHd3ACFLFJmAo0fW2C6xbRCBM4k/jNlaQImaQoot397GCJIQF
	7CQeHegBa2ARUJXY+f0FE4jNK+Ahsf3Kf5YuRg6gdQoScybZTGDkXsDIsIpRNLUguaA4KT3X
	SK84Mbe4NC9dLzk/dxMj2IPPpHcwrmqwOMQowMGoxMOrELEgQIg1say4MvcQowQHs5IIr+9O
	oBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeZo+UACGB9MSS1OzU1ILUIpgsEwenVAMj6zLvK/J2
	Edv+q6/Um1dnzPbKqfFImeKM5/IM00Ucri6dqZi0+05o4uatMhq/mBt/HytzWRM0a3GZQd+/
	1ges7T1SxvZ7c7JY25Tzvkw9yPDv86LmjO3637ZFR222nper3/ViWs3cfUuaavSsLu997Ft3
	pukcx+2lK562m6lpn1y0+eHphQ97lFiKMxINtZiLihMBkCRz99wBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory return to free_contig_range() must have no other references. Let
kernel to complain loudly if page reference count is not equal to 1.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Michal Nazarewicz <mina86@mina86.com>
---
 mm/page_alloc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 022e4ed..290c2eb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5888,8 +5888,13 @@ done:
 
 void free_contig_range(unsigned long pfn, unsigned nr_pages)
 {
-	for (; nr_pages--; ++pfn)
-		__free_page(pfn_to_page(pfn));
+	struct page *page = pfn_to_page(pfn);
+	int refcount = nr_pages;
+	for (; nr_pages--; page++) {
+		refcount -= page_count(page) == 1;
+		__free_page(page);
+	}
+	WARN(refcount != 0, "some pages are still in use!\n");
 }
 #endif
 
-- 
1.7.9.5

