Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab2GWArx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 20:47:53 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44978 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab2GWArt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 20:47:49 -0400
X-AuditID: 9c930197-b7b66ae000006a2c-28-500c9f327c59
From: Minchan Kim <minchan@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, lliubbo@gmail.com,
        Minchan Kim <minchan@kernel.org>
Subject: [RESEND RFC 2/3] mm: remain migratetype in freed page
Date: Mon, 23 Jul 2012 09:48:01 +0900
Message-Id: <1343004482-6916-3-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343004482-6916-1-git-send-email-minchan@kernel.org>
References: <1343004482-6916-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Page allocator doesn't keep migratetype information to page
when the page is freed. This patch remains the information
to freed page's index field which isn't used by free/alloc
preparing so it shouldn't change any behavir except below one.

This patch adds a new call site in __free_pages_ok so it might be
overhead a bit but it's for high order allocation.
So I believe damage isn't hurt.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/mm.h |    6 ++++--
 mm/page_alloc.c    |    7 ++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 86d61d6..8fd32da 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -251,12 +251,14 @@ struct inode;
 
 static inline void set_page_migratetype(struct page *page, int migratetype)
 {
-	set_page_private(page, migratetype);
+	VM_BUG_ON((unsigned int)migratetype >= MIGRATE_TYPES);
+	page->index = migratetype;
 }
 
 static inline int get_page_migratetype(struct page *page)
 {
-	return page_private(page);
+	VM_BUG_ON((unsigned int)page->index >= MIGRATE_TYPES);
+	return page->index;
 }
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 103ba66..32985dd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -723,6 +723,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 {
 	unsigned long flags;
 	int wasMlocked = __TestClearPageMlocked(page);
+	int migratetype;
 
 	if (!free_pages_prepare(page, order))
 		return;
@@ -731,9 +732,9 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 	if (unlikely(wasMlocked))
 		free_page_mlock(page);
 	__count_vm_events(PGFREE, 1 << order);
-	free_one_page(page_zone(page), page, order,
-					get_pageblock_migratetype(page));
-
+	migratetype = get_pageblock_migratetype(page);
+	set_page_migratetype(page, migratetype);
+	free_one_page(page_zone(page), page, order, migratetype);
 	local_irq_restore(flags);
 }
 
-- 
1.7.9.5

