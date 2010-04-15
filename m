Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab0DOKY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 06:24:58 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55646 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab0DOKY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:24:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 3/4] mm: introduce free_pages_bulk
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Chinner <david@fromorbit.com>,
       Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20100415185310.D1A1.A69D9226@jp.fujitsu.com>
References: <20100415085420.GT2493@dastard> <20100415185310.D1A1.A69D9226@jp.fujitsu.com>
Message-Id: <20100415192412.D1AA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Apr 2010 19:24:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, vmscan is using __pagevec_free() for batch freeing. but
pagevec consume slightly lots stack (sizeof(long)*8), and x86_64
stack is very strictly limited.

Then, now we are planning to use page->lru list instead pagevec
for reducing stack. and introduce new helper function.

This is similar to __pagevec_free(), but receive list instead
pagevec. and this don't use pcp cache. it is good characteristics
for vmscan.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/gfp.h |    1 +
 mm/page_alloc.c     |   44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 4c6d413..dbcac56 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -332,6 +332,7 @@ extern void free_hot_cold_page(struct page *page, int cold);
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr),0)
 
+void free_pages_bulk(struct zone *zone, struct list_head *list);
 void page_alloc_init(void);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
 void drain_all_pages(void);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ba9aea7..1f68832 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2049,6 +2049,50 @@ void free_pages(unsigned long addr, unsigned int order)
 
 EXPORT_SYMBOL(free_pages);
 
+/*
+ * Frees a number of pages from the list
+ * Assumes all pages on list are in same zone and order==0.
+ *
+ * This is similar to __pagevec_free(), but receive list instead pagevec.
+ * and this don't use pcp cache. it is good characteristics for vmscan.
+ */
+void free_pages_bulk(struct zone *zone, struct list_head *list)
+{
+	unsigned long flags;
+	struct page *page;
+	struct page *page2;
+	int nr_pages = 0;
+
+	list_for_each_entry_safe(page, page2, list, lru) {
+		int wasMlocked = __TestClearPageMlocked(page);
+
+		if (free_pages_prepare(page, 0)) {
+			/* Make orphan the corrupted page. */
+			list_del(&page->lru);
+			continue;
+		}
+		if (unlikely(wasMlocked)) {
+			local_irq_save(flags);
+			free_page_mlock(page);
+			local_irq_restore(flags);
+		}
+		nr_pages++;
+	}
+
+	spin_lock_irqsave(&zone->lock, flags);
+	__count_vm_events(PGFREE, nr_pages);
+	zone->all_unreclaimable = 0;
+	zone->pages_scanned = 0;
+	__mod_zone_page_state(zone, NR_FREE_PAGES, nr_pages);
+
+	list_for_each_entry_safe(page, page2, list, lru) {
+		/* have to delete it as __free_one_page list manipulates */
+		list_del(&page->lru);
+		__free_one_page(page, zone, 0, page_private(page));
+	}
+	spin_unlock_irqrestore(&zone->lock, flags);
+}
+
 /**
  * alloc_pages_exact - allocate an exact number physically-contiguous pages.
  * @size: the number of bytes to allocate
-- 
1.6.5.2



