Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab2KHTzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:55:00 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:37353 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab2KHTy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:54:58 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: linux-kernel@vger.kernel.org
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [RFC PATCH] mm: trace filemap add and del
Date: Thu,  8 Nov 2012 20:54:10 +0100
Message-Id: <1352404450-30100-1-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the events API to trace filemap loading and
unloading of file pieces into the page cache.

This patch aims at tracing the eviction reload
cycle of executable and shared libraries pages in
a memory constrained environment.

The typical usage is to spot a specific device and
inode (for example /lib/libc.so) to see the eviction
cycles, and find out if frequently used code is
rather spread across many pages (bad) or coallesced
(good).

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 include/trace/events/filemap.h |   79 ++++++++++++++++++++++++++++++++++++++++
 mm/filemap.c                   |    5 +++
 2 files changed, 84 insertions(+)
 create mode 100644 include/trace/events/filemap.h

diff --git a/include/trace/events/filemap.h b/include/trace/events/filemap.h
new file mode 100644
index 0000000..a8319e2
--- /dev/null
+++ b/include/trace/events/filemap.h
@@ -0,0 +1,79 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM filemap
+
+#if !defined(_TRACE_FILEMAP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_FILEMAP_H
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+#include <linux/mm.h>
+#include <linux/memcontrol.h>
+#include <linux/device.h>
+#include <linux/kdev_t.h>
+
+TRACE_EVENT(mm_filemap_delete_from_page_cache,
+
+	TP_PROTO(struct page *page),
+
+	TP_ARGS(page),
+
+	TP_STRUCT__entry(
+		__field(struct page *, page)
+		__field(unsigned long, i_no)
+		__field(unsigned long, pageofs)
+		__field(dev_t, s_dev)
+	),
+
+	TP_fast_assign(
+		__entry->page = page;
+		__entry->i_no = page->mapping->host->i_ino;
+		__entry->pageofs = page->index;
+		if (page->mapping->host->i_sb)
+			__entry->s_dev = page->mapping->host->i_sb->s_dev;
+		else
+			__entry->s_dev = page->mapping->host->i_rdev;
+	),
+
+	TP_printk("page=%p pfn=%lu blk=%d:%d inode+ofs=%lu+%lu",
+		__entry->page,
+		page_to_pfn(__entry->page),
+		MAJOR(__entry->s_dev), MINOR(__entry->s_dev),
+		__entry->i_no,
+		__entry->pageofs << PAGE_SHIFT)
+);
+
+TRACE_EVENT(mm_filemap_add_to_page_cache,
+
+	TP_PROTO(struct page *page),
+
+	TP_ARGS(page),
+
+	TP_STRUCT__entry(
+		__field(struct page *, page)
+		__field(unsigned long, i_no)
+		__field(unsigned long, pageofs)
+		__field(dev_t, s_dev)
+	),
+
+	TP_fast_assign(
+		__entry->page = page;
+		__entry->i_no = page->mapping->host->i_ino;
+		__entry->pageofs = page->index;
+		if (page->mapping->host->i_sb)
+			__entry->s_dev = page->mapping->host->i_sb->s_dev;
+		else
+			__entry->s_dev = page->mapping->host->i_rdev;
+	),
+
+	TP_printk("page=%p pfn=%lu blk=%d:%d inode+ofs=%lu+%lu",
+		__entry->page,
+		page_to_pfn(__entry->page),
+		MAJOR(__entry->s_dev), MINOR(__entry->s_dev),
+		__entry->i_no,
+		__entry->pageofs)
+);
+
+#endif /* _TRACE_FILEMAP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/mm/filemap.c b/mm/filemap.c
index 3843445..9753b7c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -35,6 +35,9 @@
 #include <linux/cleancache.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/filemap.h>
+
 /*
  * FIXME: remove all knowledge of the buffer layer from the core VM
  */
@@ -113,6 +116,7 @@ void __delete_from_page_cache(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
 
+	trace_mm_filemap_delete_from_page_cache(page);
 	/*
 	 * if we're uptodate, flush out into the cleancache, otherwise
 	 * invalidate any existing cleancache entries.  We can't leave
@@ -467,6 +471,7 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 		} else {
 			page->mapping = NULL;
 			/* Leave page->index set: truncation relies upon it */
+			trace_mm_filemap_add_to_page_cache(page);
 			spin_unlock_irq(&mapping->tree_lock);
 			mem_cgroup_uncharge_cache_page(page);
 			page_cache_release(page);
-- 
1.7.9.5

