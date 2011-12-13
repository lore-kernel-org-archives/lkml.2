Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab1LMN7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 08:59:48 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:58151 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829Ab1LMN6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 08:58:46 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 2/4] mm: page_alloc: generalize order handling in __free_pages_bootmem()
Date: Tue, 13 Dec 2011 14:58:29 +0100
Message-Id: <1323784711-1937-3-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323784711-1937-1-git-send-email-hannes@cmpxchg.org>
References: <1323784711-1937-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__free_pages_bootmem() used to special-case higher-order frees to save
individual page checking with free_pages_bulk().

Nowadays, both zero order and non-zero order frees use free_pages(),
which checks each individual page anyway, and so there is little point
in making the distinction anymore.  The higher-order loop will work
just fine for zero order pages.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/page_alloc.c |   34 ++++++++++++----------------------
 1 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4d5e91c..1efacb3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -692,33 +692,23 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 	local_irq_restore(flags);
 }
 
-/*
- * permit the bootmem allocator to evade page validation on high-order frees
- */
 void __meminit __free_pages_bootmem(struct page *page, unsigned int order)
 {
-	if (order == 0) {
-		__ClearPageReserved(page);
-		set_page_count(page, 0);
-		set_page_refcounted(page);
-		__free_page(page);
-	} else {
-		unsigned int nr_pages = 1 << order;
-		unsigned int loop;
-
-		prefetchw(page);
-		for (loop = 0; loop < nr_pages; loop++) {
-			struct page *p = &page[loop];
+	unsigned int nr_pages = 1 << order;
+	unsigned int loop;
 
-			if (loop + 1 < nr_pages)
-				prefetchw(p + 1);
-			__ClearPageReserved(p);
-			set_page_count(p, 0);
-		}
+	prefetchw(page);
+	for (loop = 0; loop < nr_pages; loop++) {
+		struct page *p = &page[loop];
 
-		set_page_refcounted(page);
-		__free_pages(page, order);
+		if (loop + 1 < nr_pages)
+			prefetchw(p + 1);
+		__ClearPageReserved(p);
+		set_page_count(p, 0);
 	}
+
+	set_page_refcounted(page);
+	__free_pages(page, order);
 }
 
 
-- 
1.7.7.3

