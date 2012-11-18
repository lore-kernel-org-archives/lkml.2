Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab2KRQKH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 11:10:07 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37965 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab2KRQKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 11:10:03 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFT PATCH v1 4/5] mm: provide more accurate estimation of pages occupied by memmap
Date: Mon, 19 Nov 2012 00:07:29 +0800
Message-Id: <1353254850-27336-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353254850-27336-1-git-send-email-jiang.liu@huawei.com>
References: <20121115112454.e582a033.akpm@linux-foundation.org>
 <1353254850-27336-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If SPARSEMEM is enabled, it won't build page structures for
non-existing pages (holes) within a zone, so provide a more accurate
estimation of pages occupied by memmap if there are big holes within
the zone.

And pages for highmem zones' memmap will be allocated from lowmem,
so charge nr_kernel_pages for that.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 mm/page_alloc.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5b327d7..eb25679 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4435,6 +4435,22 @@ void __init set_pageblock_order(void)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
+static unsigned long calc_memmap_size(unsigned long spanned_pages,
+				      unsigned long present_pages)
+{
+	unsigned long pages = spanned_pages;
+
+	/*
+	 * Provide a more accurate estimation if there are big holes within
+	 * the zone and SPARSEMEM is in use.
+	 */
+	if (spanned_pages > present_pages + (present_pages >> 4) &&
+	    IS_ENABLED(CONFIG_SPARSEMEM))
+		pages = present_pages;
+
+	return PAGE_ALIGN(pages * sizeof(struct page)) >> PAGE_SHIFT;
+}
+
 /*
  * Set up the zone data structures:
  *   - mark all pages reserved
@@ -4469,8 +4485,7 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 		 * is used by this zone for memmap. This affects the watermark
 		 * and per-cpu initialisations
 		 */
-		memmap_pages =
-			PAGE_ALIGN(size * sizeof(struct page)) >> PAGE_SHIFT;
+		memmap_pages = calc_memmap_size(size, realsize);
 		if (freesize >= memmap_pages) {
 			freesize -= memmap_pages;
 			if (memmap_pages)
@@ -4491,6 +4506,9 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 
 		if (!is_highmem_idx(j))
 			nr_kernel_pages += freesize;
+		/* Charge for highmem memmap if there are enough kernel pages */
+		else if (nr_kernel_pages > memmap_pages * 2)
+			nr_kernel_pages -= memmap_pages;
 		nr_all_pages += freesize;
 
 		zone->spanned_pages = size;
-- 
1.7.9.5

