Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab1HYOMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:12:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39500 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1HYOMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:12:17 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH -v2] debug-pagealloc: add support for highmem pages
Date: Thu, 25 Aug 2011 23:14:09 +0900
Message-Id: <1314281649-21508-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for highmem pages poisoning and verification to the
debug-pagealloc feature for no-architecture support.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v2
- unify the handling of highmem and no-highmem pages

 mm/debug-pagealloc.c |   47 ++++++++++++++---------------------------------
 1 files changed, 14 insertions(+), 33 deletions(-)

diff --git a/mm/debug-pagealloc.c b/mm/debug-pagealloc.c
index 2618933..bda7ed0 100644
--- a/mm/debug-pagealloc.c
+++ b/mm/debug-pagealloc.c
@@ -1,6 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/mm.h>
+#include <linux/highmem.h>
 #include <linux/page-debug-flags.h>
 #include <linux/poison.h>
 #include <linux/ratelimit.h>
@@ -20,28 +21,16 @@ static inline bool page_poison(struct page *page)
 	return test_bit(PAGE_DEBUG_FLAG_POISON, &page->debug_flags);
 }
 
-static void poison_highpage(struct page *page)
-{
-	/*
-	 * Page poisoning for highmem pages is not implemented.
-	 *
-	 * This can be called from interrupt contexts.
-	 * So we need to create a new kmap_atomic slot for this
-	 * application and it will need interrupt protection.
-	 */
-}
-
 static void poison_page(struct page *page)
 {
 	void *addr;
 
-	if (PageHighMem(page)) {
-		poison_highpage(page);
-		return;
-	}
+	preempt_disable();
+	addr = kmap_atomic(page);
 	set_page_poison(page);
-	addr = page_address(page);
 	memset(addr, PAGE_POISON, PAGE_SIZE);
+	kunmap_atomic(addr);
+	preempt_enable();
 }
 
 static void poison_pages(struct page *page, int n)
@@ -86,27 +75,19 @@ static void check_poison_mem(unsigned char *mem, size_t bytes)
 	dump_stack();
 }
 
-static void unpoison_highpage(struct page *page)
-{
-	/*
-	 * See comment in poison_highpage().
-	 * Highmem pages should not be poisoned for now
-	 */
-	BUG_ON(page_poison(page));
-}
-
 static void unpoison_page(struct page *page)
 {
-	if (PageHighMem(page)) {
-		unpoison_highpage(page);
+	void *addr;
+
+	if (!page_poison(page))
 		return;
-	}
-	if (page_poison(page)) {
-		void *addr = page_address(page);
 
-		check_poison_mem(addr, PAGE_SIZE);
-		clear_page_poison(page);
-	}
+	preempt_disable();
+	addr = kmap_atomic(page);
+	check_poison_mem(addr, PAGE_SIZE);
+	clear_page_poison(page);
+	kunmap_atomic(addr);
+	preempt_enable();
 }
 
 static void unpoison_pages(struct page *page, int n)
-- 
1.7.4.4

