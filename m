Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2A3Ner (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:34:47 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:39377 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681Ab2A3Nep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:34:45 -0500
From: Maxime Coquelin <maxime.coquelin@stericsson.com>
To: <linux-mm@kvack.org>, <linaro-mm-sig@lists.linaro.org>,
        Mel Gorman <mel@csn.ul.ie>, Ankita Garg <ankita@in.ibm.com>
Cc: <linux-kernel@vger.kernel.org>,
        Maxime Coquelin <maxime.coquelin@stericsson.com>,
        <linus.walleij@stericsson.com>, <andrea.gallo@stericsson.com>,
        <vincent.guittot@stericsson.com>, <philippe.langlais@stericsson.com>,
        <loic.pallardy@stericsson.com>
Subject: [RFCv1 3/6] PASR: mm: Integrate PASR in Buddy allocator
Date: Mon, 30 Jan 2012 14:33:53 +0100
Message-ID: <1327930436-10263-4-git-send-email-maxime.coquelin@stericsson.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1327930436-10263-1-git-send-email-maxime.coquelin@stericsson.com>
References: <1327930436-10263-1-git-send-email-maxime.coquelin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any allocators might call the PASR Framework for DDR power savings. Currently,
only Linux Buddy allocator is patched, but HWMEM and PMEM physically
contiguous memory allocators will follow.

Linux Buddy allocator porting uses Buddy specificities to reduce the overhead
induced by the PASR Framework counter updates. Indeed, the PASR Framework is
called only when MAX_ORDER (4MB page blocs by default) buddies are
inserted/removed from the free lists.

To port PASR FW into a new allocator:

* Call pasr_put(phys_addr, size) each time a memory chunk becomes unused.
* Call pasr_get(phys_addr, size) each time a memory chunk becomes used.


Signed-off-by: Maxime Coquelin <maxime.coquelin@stericsson.com>
---
 mm/page_alloc.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 03d8c48..c62fe11 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -57,6 +57,7 @@
 #include <linux/ftrace_event.h>
 #include <linux/memcontrol.h>
 #include <linux/prefetch.h>
+#include <linux/pasr.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -534,6 +535,7 @@ static inline void __free_one_page(struct page *page,
 		/* Our buddy is free, merge with it and move up one order. */
 		list_del(&buddy->lru);
 		zone->free_area[order].nr_free--;
+		pasr_kget(buddy, order);
 		rmv_page_order(buddy);
 		combined_idx = buddy_idx & page_idx;
 		page = page + (combined_idx - page_idx);
@@ -566,6 +568,7 @@ static inline void __free_one_page(struct page *page,
 	list_add(&page->lru, &zone->free_area[order].free_list[migratetype]);
 out:
 	zone->free_area[order].nr_free++;
+	pasr_kput(page, order);
 }
 
 /*
@@ -762,6 +765,7 @@ static inline void expand(struct zone *zone, struct page *page,
 		VM_BUG_ON(bad_range(zone, &page[size]));
 		list_add(&page[size].lru, &area->free_list[migratetype]);
 		area->nr_free++;
+		pasr_kput(page, high);
 		set_page_order(&page[size], high);
 	}
 }
@@ -830,6 +834,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		list_del(&page->lru);
 		rmv_page_order(page);
 		area->nr_free--;
+		pasr_kget(page, current_order);
 		expand(zone, page, order, current_order, area, migratetype);
 		return page;
 	}
@@ -955,6 +960,7 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 			page = list_entry(area->free_list[migratetype].next,
 					struct page, lru);
 			area->nr_free--;
+			pasr_kget(page, current_order);
 
 			/*
 			 * If breaking a large block of pages, move all free
@@ -1281,6 +1287,8 @@ int split_free_page(struct page *page)
 	/* Remove page from free list */
 	list_del(&page->lru);
 	zone->free_area[order].nr_free--;
+	pasr_kget(page, order);
+
 	rmv_page_order(page);
 	__mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order));
 
@@ -5692,6 +5700,7 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
 		list_del(&page->lru);
 		rmv_page_order(page);
 		zone->free_area[order].nr_free--;
+		pasr_kget(page, order);
 		__mod_zone_page_state(zone, NR_FREE_PAGES,
 				      - (1UL << order));
 		for (i = 0; i < (1 << order); i++)
-- 
1.7.8

