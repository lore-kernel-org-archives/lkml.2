Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524Ab1JFNy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:54:58 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8205 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab1JFNy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:54:56 -0400
Date: Thu, 06 Oct 2011 15:54:42 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/9] mm: alloc_contig_freed_pages() added
In-reply-to: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Message-id: <1317909290-29832-3-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.6.3
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
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
[m.nazarewicz: added checks if all allocated pages comes from the
same memory zone]
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
[m.szyprowski: fixed wrong condition in VM_BUG_ON assert]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/mmzone.h         |   16 +++++++++
 include/linux/page-isolation.h |    5 +++
 mm/page_alloc.c                |   67 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a2760bb..862a834 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1168,6 +1168,22 @@ static inline int memmap_valid_within(unsigned long pfn,
 }
 #endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
 
+#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+/*
+ * Both PFNs must be from the same zone!  If this function returns
+ * true, pfn_to_page(pfn1) + (pfn2 - pfn1) == pfn_to_page(pfn2).
+ */
+static inline bool zone_pfn_same_memmap(unsigned long pfn1, unsigned long pfn2)
+{
+	return pfn_to_section_nr(pfn1) == pfn_to_section_nr(pfn2);
+}
+
+#else
+
+#define zone_pfn_same_memmap(pfn1, pfn2) (true)
+
+#endif
+
 #endif /* !__GENERATING_BOUNDS.H */
 #endif /* !__ASSEMBLY__ */
 #endif /* _LINUX_MMZONE_H */
diff --git a/include/linux/page-isolation.h b/include/linux/page-isolation.h
index 58cdbac..b9fc428 100644
--- a/include/linux/page-isolation.h
+++ b/include/linux/page-isolation.h
@@ -33,6 +33,11 @@ test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn);
 extern int set_migratetype_isolate(struct page *page);
 extern void unset_migratetype_isolate(struct page *page);
 
+/* The below functions must be run on a range from a single zone. */
+extern unsigned long alloc_contig_freed_pages(unsigned long start,
+					      unsigned long end, gfp_t flag);
+extern void free_contig_pages(unsigned long pfn, unsigned nr_pages);
+
 /*
  * For migration.
  */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bf4399a..fbfb920 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5706,6 +5706,73 @@ out:
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
+	page = pfn_to_page(start);
+	zone = page_zone(page);
+
+	spin_lock_irq(&zone->lock);
+
+	for (;;) {
+		VM_BUG_ON(page_count(page) || !PageBuddy(page) ||
+			  page_zone(page) != zone);
+
+		list_del(&page->lru);
+		order = page_order(page);
+		count = 1UL << order;
+		zone->free_area[order].nr_free--;
+		rmv_page_order(page);
+		__mod_zone_page_state(zone, NR_FREE_PAGES, -(long)count);
+
+		pfn += count;
+		if (pfn >= end)
+			break;
+		VM_BUG_ON(!pfn_valid(pfn));
+
+		if (zone_pfn_same_memmap(pfn - count, pfn))
+			page += count;
+		else
+			page = pfn_to_page(pfn);
+	}
+
+	spin_unlock_irq(&zone->lock);
+
+	/* After this, pages in the range can be freed one be one */
+	count = pfn - start;
+	pfn = start;
+	for (page = pfn_to_page(pfn); count; --count) {
+		prep_new_page(page, 0, flag);
+		++pfn;
+		if (likely(zone_pfn_same_memmap(pfn - 1, pfn)))
+			++page;
+		else
+			page = pfn_to_page(pfn);
+	}
+
+	return pfn;
+}
+
+void free_contig_pages(unsigned long pfn, unsigned nr_pages)
+{
+	struct page *page = pfn_to_page(pfn);
+
+	while (nr_pages--) {
+		__free_page(page);
+		++pfn;
+		if (likely(zone_pfn_same_memmap(pfn - 1, pfn)))
+			++page;
+		else
+			page = pfn_to_page(pfn);
+	}
+}
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
 /*
  * All pages in the range must be isolated before calling this.
-- 
1.7.1.569.g6f426

