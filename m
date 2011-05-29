Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab1E2SOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 14:14:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47370 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab1E2SOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 14:14:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ijtl52NkN/Mb+qR/+DRJsJi7ZEXcl5Jid2KxkqucZae6/JF5GnoQIJN15WGflRRJjA
         hB9Bdh0UT9j/dGgfgXek032Mca+lcjJhtAuGJdM0kqlCBgosTs3aaKkLVvKPEaOvGyNn
         J9QYboyRsKFlA/loWkMXvNroDBTKMHPcR1odU=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v2 10/10] add tracepoints
Date: Mon, 30 May 2011 03:13:49 +0900
Message-Id: <9777d8d136811e8790a4be18af6f6c5628232f09.1306689214.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1306689214.git.minchan.kim@gmail.com>
References: <cover.1306689214.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1306689214.git.minchan.kim@gmail.com>
References: <cover.1306689214.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds some tracepints for see the effect this patch
series. This tracepoints isn't for merge but just see the effect.

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 include/trace/events/inorder_putback.h |   79 ++++++++++++++++++++++++++++++++
 mm/compaction.c                        |    2 +
 mm/migrate.c                           |    7 +++
 mm/vmscan.c                            |    3 +-
 4 files changed, 89 insertions(+), 2 deletions(-)
 create mode 100644 include/trace/events/inorder_putback.h

diff --git a/include/trace/events/inorder_putback.h b/include/trace/events/inorder_putback.h
new file mode 100644
index 0000000..c615ed8
--- /dev/null
+++ b/include/trace/events/inorder_putback.h
@@ -0,0 +1,79 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM inorder_putback
+
+#if !defined(_TRACE_INP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_INP_H
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(mm_compaction_inorder,
+
+	TP_PROTO(struct page *page,
+		 struct page *newpage),
+
+	TP_ARGS(page, newpage),
+
+	TP_STRUCT__entry(
+		__field(struct page *, page)
+		__field(struct page *, newpage)
+	),
+
+	TP_fast_assign(
+		__entry->page = page;
+		__entry->newpage = newpage;
+	),
+
+	TP_printk("pfn=%lu new pfn=%lu",
+		page_to_pfn(__entry->page),
+		page_to_pfn(__entry->newpage))
+);
+
+TRACE_EVENT(mm_compaction_outoforder,
+
+	TP_PROTO(struct page *page,
+		 struct page *newpage),
+
+	TP_ARGS(page, newpage),
+
+	TP_STRUCT__entry(
+		__field(struct page *, page)
+		__field(struct page *, newpage)
+	),
+
+	TP_fast_assign(
+		__entry->page = page;
+		__entry->newpage = newpage;
+	),
+
+	TP_printk("pfn=%lu new pfn=%lu",
+		page_to_pfn(__entry->page),
+		page_to_pfn(__entry->newpage))
+);
+
+TRACE_EVENT(mm_compact_isolate,
+
+	TP_PROTO(struct page *prev_page,
+		struct page *page),
+
+	TP_ARGS(prev_page, page),
+
+	TP_STRUCT__entry(
+		__field(struct page *, prev_page)
+		__field(struct page *, page)
+	),
+
+	TP_fast_assign(
+		__entry->prev_page = prev_page;
+		__entry->page = page;
+	),
+
+	TP_printk("pfn=%lu prev_pfn=%lu",
+		page_to_pfn(__entry->page),
+		page_to_pfn(__entry->prev_page))
+);
+
+#endif /* _TRACE_INP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/mm/compaction.c b/mm/compaction.c
index 00e710a..92c180d 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -16,6 +16,7 @@
 #include <linux/sysfs.h>
 #include "internal.h"
 
+#include <trace/events/inorder_putback.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/compaction.h>
 
@@ -333,6 +334,7 @@ static unsigned long isolate_migratepages(struct zone *zone,
 		if (__isolate_inorder_lru_page(page, mode, 0, &prev_page) != 0)
 			continue;
 
+		trace_mm_compact_isolate(prev_page, page);
 		VM_BUG_ON(PageTransCompound(page));
 
 		/* Successfully isolated */
diff --git a/mm/migrate.c b/mm/migrate.c
index bc614d3..6ec98c1 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -39,6 +39,9 @@
 
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/inorder_putback.h>
+
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
 
 /*
@@ -96,10 +99,12 @@ void putback_inorder_lru_pages(struct inorder_lru *l)
 		spin_lock_irq(&zone->lru_lock);
 		prev = page->ilru.prev_page;
 		if (keep_lru_order(page, prev)) {
+			trace_mm_compaction_inorder(page, page);
 			putback_page_to_lru(page, prev);
 			spin_unlock_irq(&zone->lru_lock);
 		}
 		else {
+			trace_mm_compaction_outoforder(page, page);
 			spin_unlock_irq(&zone->lru_lock);
 			putback_lru_page(page);
 		}
@@ -1060,6 +1065,7 @@ move_newpage:
 	if (keep_lru_order(page, prev_page)) {
 		putback_page_to_lru(newpage, prev_page);
 		spin_unlock_irq(&zone->lru_lock);
+		trace_mm_compaction_inorder(page, newpage);
 		/*
 		 * The newpage will replace LRU position of old page and
 		 * old one would be freed. So let's adjust prev_page of pages
@@ -1071,6 +1077,7 @@ move_newpage:
 	else {
 
 		spin_unlock_irq(&zone->lru_lock);
+		trace_mm_compaction_inorder(page, newpage);
 		putback_lru_page(newpage);
 	}
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 118ce9f..10e4577 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -49,10 +49,9 @@
 #include <linux/swapops.h>
 
 #include "internal.h"
-
+#include <trace/events/inorder_putback.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmscan.h>
-
 /*
  * reclaim_mode determines how the inactive list is shrunk
  * RECLAIM_MODE_SINGLE: Reclaim only order-0 pages
-- 
1.7.0.4

