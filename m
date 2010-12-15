Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0LOUip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:38:45 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:18875 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab0LOUij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:38:39 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 15 Dec 2010 21:34:25 +0100
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv8 05/12] mm: alloc_contig_freed_pages() added
In-reply-to: <cover.1292443200.git.m.nazarewicz@samsung.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mel@csn.ul.ie>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org
Message-id: <2fa6b6c1db8640cca1e8f0be7bce5d152b10c6f4.1292443200.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.2.3
References: <cover.1292443200.git.m.nazarewicz@samsung.com>
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
index 826ba69..be240a3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5425,6 +5425,50 @@ out:
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
1.7.2.3

