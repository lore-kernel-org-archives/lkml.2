Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab0KSISV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 03:18:21 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48154 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab0KSISU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 03:18:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 19 Nov 2010 17:12:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        minchan.kim@gmail.com, Bob Liu <lliubbo@gmail.com>,
        fujita.tomonori@lab.ntt.co.jp, m.nazarewicz@samsung.com,
        pawel@osciak.com, andi.kleen@intel.com, felipe.contreras@gmail.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 1/4] alloc_contig_pages() move some functions to
 page_isolation.c
Message-Id: <20101119171239.7f544c7c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101119171033.a8d9dc8f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101119171033.a8d9dc8f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Memory hotplug is a logic for making pages unused in the specified range
of pfn. So, some of core logics can be used for other purpose as
allocating a very large contigous memory block.

This patch moves some functions from mm/memory_hotplug.c to
mm/page_isolation.c. This helps adding a function for large-alloc in
page_isolation.c with memory-unplug technique.

Changelog: 2010/10/26
 - adjusted to mmotm-1024 + Bob's 3 clean ups.
Changelog: 2010/10/21
 - adjusted to mmotm-1020

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/page-isolation.h |    7 ++
 mm/memory_hotplug.c            |  108 ---------------------------------------
 mm/page_isolation.c            |  111 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 118 insertions(+), 108 deletions(-)

Index: mmotm-1117/include/linux/page-isolation.h
===================================================================
--- mmotm-1117.orig/include/linux/page-isolation.h
+++ mmotm-1117/include/linux/page-isolation.h
@@ -33,5 +33,12 @@ test_pages_isolated(unsigned long start_
 extern int set_migratetype_isolate(struct page *page);
 extern void unset_migratetype_isolate(struct page *page);
 
+/*
+ * For migration.
+ */
+
+int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn);
+unsigned long scan_lru_pages(unsigned long start, unsigned long end);
+int do_migrate_range(unsigned long start_pfn, unsigned long end_pfn);
 
 #endif
Index: mmotm-1117/mm/memory_hotplug.c
===================================================================
--- mmotm-1117.orig/mm/memory_hotplug.c
+++ mmotm-1117/mm/memory_hotplug.c
@@ -615,114 +615,6 @@ int is_mem_section_removable(unsigned lo
 }
 
 /*
- * Confirm all pages in a range [start, end) is belongs to the same zone.
- */
-static int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)
-{
-	unsigned long pfn;
-	struct zone *zone = NULL;
-	struct page *page;
-	int i;
-	for (pfn = start_pfn;
-	     pfn < end_pfn;
-	     pfn += MAX_ORDER_NR_PAGES) {
-		i = 0;
-		/* This is just a CONFIG_HOLES_IN_ZONE check.*/
-		while ((i < MAX_ORDER_NR_PAGES) && !pfn_valid_within(pfn + i))
-			i++;
-		if (i == MAX_ORDER_NR_PAGES)
-			continue;
-		page = pfn_to_page(pfn + i);
-		if (zone && page_zone(page) != zone)
-			return 0;
-		zone = page_zone(page);
-	}
-	return 1;
-}
-
-/*
- * Scanning pfn is much easier than scanning lru list.
- * Scan pfn from start to end and Find LRU page.
- */
-static unsigned long scan_lru_pages(unsigned long start, unsigned long end)
-{
-	unsigned long pfn;
-	struct page *page;
-	for (pfn = start; pfn < end; pfn++) {
-		if (pfn_valid(pfn)) {
-			page = pfn_to_page(pfn);
-			if (PageLRU(page))
-				return pfn;
-		}
-	}
-	return 0;
-}
-
-static struct page *
-hotremove_migrate_alloc(struct page *page, unsigned long private, int **x)
-{
-	/* This should be improooooved!! */
-	return alloc_page(GFP_HIGHUSER_MOVABLE);
-}
-
-#define NR_OFFLINE_AT_ONCE_PAGES	(256)
-static int
-do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
-{
-	unsigned long pfn;
-	struct page *page;
-	int move_pages = NR_OFFLINE_AT_ONCE_PAGES;
-	int not_managed = 0;
-	int ret = 0;
-	LIST_HEAD(source);
-
-	for (pfn = start_pfn; pfn < end_pfn && move_pages > 0; pfn++) {
-		if (!pfn_valid(pfn))
-			continue;
-		page = pfn_to_page(pfn);
-		if (!page_count(page))
-			continue;
-		/*
-		 * We can skip free pages. And we can only deal with pages on
-		 * LRU.
-		 */
-		ret = isolate_lru_page(page);
-		if (!ret) { /* Success */
-			list_add_tail(&page->lru, &source);
-			move_pages--;
-			inc_zone_page_state(page, NR_ISOLATED_ANON +
-					    page_is_file_cache(page));
-
-		} else {
-#ifdef CONFIG_DEBUG_VM
-			printk(KERN_ALERT "removing pfn %lx from LRU failed\n",
-			       pfn);
-			dump_page(page);
-#endif
-			/* Becasue we don't have big zone->lock. we should
-			   check this again here. */
-			if (page_count(page)) {
-				not_managed++;
-				ret = -EBUSY;
-				break;
-			}
-		}
-	}
-	if (!list_empty(&source)) {
-		if (not_managed) {
-			putback_lru_pages(&source);
-			goto out;
-		}
-		/* this function returns # of failed pages */
-		ret = migrate_pages(&source, hotremove_migrate_alloc, 0, 1);
-		if (ret)
-			putback_lru_pages(&source);
-	}
-out:
-	return ret;
-}
-
-/*
  * remove from free_area[] and mark all as Reserved.
  */
 static int
Index: mmotm-1117/mm/page_isolation.c
===================================================================
--- mmotm-1117.orig/mm/page_isolation.c
+++ mmotm-1117/mm/page_isolation.c
@@ -5,6 +5,9 @@
 #include <linux/mm.h>
 #include <linux/page-isolation.h>
 #include <linux/pageblock-flags.h>
+#include <linux/memcontrol.h>
+#include <linux/migrate.h>
+#include <linux/mm_inline.h>
 #include "internal.h"
 
 static inline struct page *
@@ -139,3 +142,111 @@ int test_pages_isolated(unsigned long st
 	spin_unlock_irqrestore(&zone->lock, flags);
 	return ret ? 0 : -EBUSY;
 }
+
+
+/*
+ * Confirm all pages in a range [start, end) is belongs to the same zone.
+ */
+int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)
+{
+	unsigned long pfn;
+	struct zone *zone = NULL;
+	struct page *page;
+	int i;
+	for (pfn = start_pfn;
+	     pfn < end_pfn;
+	     pfn += MAX_ORDER_NR_PAGES) {
+		i = 0;
+		/* This is just a CONFIG_HOLES_IN_ZONE check.*/
+		while ((i < MAX_ORDER_NR_PAGES) && !pfn_valid_within(pfn + i))
+			i++;
+		if (i == MAX_ORDER_NR_PAGES)
+			continue;
+		page = pfn_to_page(pfn + i);
+		if (zone && page_zone(page) != zone)
+			return 0;
+		zone = page_zone(page);
+	}
+	return 1;
+}
+
+/*
+ * Scanning pfn is much easier than scanning lru list.
+ * Scan pfn from start to end and Find LRU page.
+ */
+unsigned long scan_lru_pages(unsigned long start, unsigned long end)
+{
+	unsigned long pfn;
+	struct page *page;
+	for (pfn = start; pfn < end; pfn++) {
+		if (pfn_valid(pfn)) {
+			page = pfn_to_page(pfn);
+			if (PageLRU(page))
+				return pfn;
+		}
+	}
+	return 0;
+}
+
+struct page *
+hotremove_migrate_alloc(struct page *page, unsigned long private, int **x)
+{
+	/* This should be improooooved!! */
+	return alloc_page(GFP_HIGHUSER_MOVABLE);
+}
+
+#define NR_OFFLINE_AT_ONCE_PAGES	(256)
+int do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
+{
+	unsigned long pfn;
+	struct page *page;
+	int move_pages = NR_OFFLINE_AT_ONCE_PAGES;
+	int not_managed = 0;
+	int ret = 0;
+	LIST_HEAD(source);
+
+	for (pfn = start_pfn; pfn < end_pfn && move_pages > 0; pfn++) {
+		if (!pfn_valid(pfn))
+			continue;
+		page = pfn_to_page(pfn);
+		if (!page_count(page))
+			continue;
+		/*
+		 * We can skip free pages. And we can only deal with pages on
+		 * LRU.
+		 */
+		ret = isolate_lru_page(page);
+		if (!ret) { /* Success */
+			list_add_tail(&page->lru, &source);
+			move_pages--;
+			inc_zone_page_state(page, NR_ISOLATED_ANON +
+					    page_is_file_cache(page));
+
+		} else {
+#ifdef CONFIG_DEBUG_VM
+			printk(KERN_ALERT "removing pfn %lx from LRU failed\n",
+			       pfn);
+			dump_page(page);
+#endif
+			/* Because we don't have big zone->lock. we should
+			   check this again here. */
+			if (page_count(page)) {
+				not_managed++;
+				ret = -EBUSY;
+				break;
+			}
+		}
+	}
+	if (!list_empty(&source)) {
+		if (not_managed) {
+			putback_lru_pages(&source);
+			goto out;
+		}
+		/* this function returns # of failed pages */
+		ret = migrate_pages(&source, hotremove_migrate_alloc, 0, 1);
+		if (ret)
+			putback_lru_pages(&source);
+	}
+out:
+	return ret;
+}

