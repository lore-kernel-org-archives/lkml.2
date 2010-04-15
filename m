Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab0DOKYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 06:24:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60197 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab0DOKYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:24:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 2/4] [cleanup] mm: introduce free_pages_prepare
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Chinner <david@fromorbit.com>,
       Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20100415185310.D1A1.A69D9226@jp.fujitsu.com>
References: <20100415085420.GT2493@dastard> <20100415185310.D1A1.A69D9226@jp.fujitsu.com>
Message-Id: <20100415192310.D1A7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Apr 2010 19:24:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is used from [3/4]

===================================
Free_hot_cold_page() and __free_pages_ok() have very similar
freeing preparation. This patch make consolicate it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/page_alloc.c |   40 +++++++++++++++++++++-------------------
 1 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 88513c0..ba9aea7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -599,20 +599,23 @@ static void free_one_page(struct zone *zone, struct page *page, int order,
 	spin_unlock(&zone->lock);
 }
 
-static void __free_pages_ok(struct page *page, unsigned int order)
+static int free_pages_prepare(struct page *page, unsigned int order)
 {
-	unsigned long flags;
 	int i;
 	int bad = 0;
-	int wasMlocked = __TestClearPageMlocked(page);
 
 	trace_mm_page_free_direct(page, order);
 	kmemcheck_free_shadow(page, order);
 
-	for (i = 0 ; i < (1 << order) ; ++i)
-		bad += free_pages_check(page + i);
+	for (i = 0 ; i < (1 << order) ; ++i) {
+		struct page *pg = page + i;
+
+		if (PageAnon(pg))
+			pg->mapping = NULL;
+		bad += free_pages_check(pg);
+	}
 	if (bad)
-		return;
+		return -EINVAL;
 
 	if (!PageHighMem(page)) {
 		debug_check_no_locks_freed(page_address(page),PAGE_SIZE<<order);
@@ -622,6 +625,17 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 	arch_free_page(page, order);
 	kernel_map_pages(page, 1 << order, 0);
 
+	return 0;
+}
+
+static void __free_pages_ok(struct page *page, unsigned int order)
+{
+	unsigned long flags;
+	int wasMlocked = __TestClearPageMlocked(page);
+
+	if (free_pages_prepare(page, order))
+		return;
+
 	local_irq_save(flags);
 	if (unlikely(wasMlocked))
 		free_page_mlock(page);
@@ -1107,21 +1121,9 @@ void free_hot_cold_page(struct page *page, int cold)
 	int migratetype;
 	int wasMlocked = __TestClearPageMlocked(page);
 
-	trace_mm_page_free_direct(page, 0);
-	kmemcheck_free_shadow(page, 0);
-
-	if (PageAnon(page))
-		page->mapping = NULL;
-	if (free_pages_check(page))
+	if (free_pages_prepare(page, 0))
 		return;
 
-	if (!PageHighMem(page)) {
-		debug_check_no_locks_freed(page_address(page), PAGE_SIZE);
-		debug_check_no_obj_freed(page_address(page), PAGE_SIZE);
-	}
-	arch_free_page(page, 0);
-	kernel_map_pages(page, 1, 0);
-
 	migratetype = get_pageblock_migratetype(page);
 	set_page_private(page, migratetype);
 	local_irq_save(flags);
-- 
1.6.5.2



