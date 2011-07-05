Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1GEHl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 03:41:58 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46886 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab1GEHl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 03:41:56 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 05 Jul 2011 09:41:44 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/8] mm: alloc_contig_freed_pages() added
In-reply-to: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Chunsang Jeong <chunsang.jeong@linaro.org>
Message-id: <1309851710-3828-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.2.5
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This commit introduces alloc_contig_freed_pages() function
which allocates (ie. removes from buddy system) free pages
in range.  Caller has to guarantee that all pages in range
are in buddy system.

Along with this function, a free_contig_pages() function is
provided which frees all (or a subset of) pages allocated
with alloc_contig_free_pages().

Michal Nazarewicz has modified the function to make it easier
to allocate not MAX_ORDER_NR_PAGES aligned pages by making it
return pfn of one-past-the-last allocated page.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Michal Nazarewicz <mina86@mina86.com>
---
 include/linux/page-isolation.h |    3 ++
 mm/page_alloc.c                |   44 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/include/linux/page-isolation.h b/include/linux/page-isolation.h
index 58cdbac..f1417ed 100644
--- a/include/linux/page-isolation.h
+++ b/include/linux/page-isolation.h
@@ -32,6 +32,9 @@ test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn);
  */
 extern int set_migratetype_isolate(struct page *page);
 extern void unset_migratetype_isolate(struct page *page);
+extern unsigned long alloc_contig_freed_pages(unsigned long start,
+					      unsigned long end, gfp_t flag);
+extern void free_contig_pages(struct page *page, int nr_pages);
 
 /*
  * For migration.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4e8985a..00e9b24 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5600,6 +5600,50 @@ out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
+unsigned long alloc_contig_freed_pages(unsigned long start, unsigned long end,
+				       gfp_t flag)
+{
+	unsigned long pfn = start, count;
+	struct page *page;
+	struct zone *zone;
+	int order;
+
+	VM_BUG_ON(!pfn_valid(start));
+	zone = page_zone(pfn_to_page(start));
+
+	spin_lock_irq(&zone->lock);
+
+	page = pfn_to_page(pfn);
+	for (;;) {
+		VM_BUG_ON(page_count(page) || !PageBuddy(page));
+		list_del(&page->lru);
+		order = page_order(page);
+		zone->free_area[order].nr_free--;
+		rmv_page_order(page);
+		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order));
+		pfn  += 1 << order;
+		if (pfn >= end)
+			break;
+		VM_BUG_ON(!pfn_valid(pfn));
+		page += 1 << order;
+	}
+
+	spin_unlock_irq(&zone->lock);
+
+	/* After this, pages in the range can be freed one be one */
+	page = pfn_to_page(start);
+	for (count = pfn - start; count; --count, ++page)
+		prep_new_page(page, 0, flag);
+
+	return pfn;
+}
+
+void free_contig_pages(struct page *page, int nr_pages)
+{
+	for (; nr_pages; --nr_pages, ++page)
+		__free_page(page);
+}
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
 /*
  * All pages in the range must be isolated before calling this.
-- 
1.7.1.569.g6f426

