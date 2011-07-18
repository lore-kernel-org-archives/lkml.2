Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106Ab1GRVjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 17:39:06 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:52590 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1GRVjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 17:39:04 -0400
Message-ID: <4E24A7BB.1040800@bx.jp.nec.com>
Date: Mon, 18 Jul 2011 17:38:03 -0400
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Keiichi KII <k-keiichi@bx.jp.nec.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Tom Zanussi <tzanussi@gmail.com>, "riel@redhat.com" <riel@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "BA, Moussa" <Moussa.BA@numonyx.com>
Subject: [RFC PATCH -tip 4/5] tracepoints: add tracepoints for pagecache
References: <4E24A61D.4060702@bx.jp.nec.com>
In-Reply-To: <4E24A61D.4060702@bx.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keiichi Kii <k-keiichi@bx.jp.nec.com>

This patch adds several tracepoints to track pagecach behavior.
These trecepoints would help us monitor pagecache usage with high resolution.

Signed-off-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>
Cc: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
---

 include/trace/events/filemap.h |   75 ++++++++++++++++++++++++++++++++++++++++
 mm/filemap.c                   |    4 ++
 mm/truncate.c                  |    2 +
 mm/vmscan.c                    |    2 +
 4 files changed, 83 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/filemap.h


diff --git a/include/trace/events/filemap.h b/include/trace/events/filemap.h
new file mode 100644
index 0000000..0f83992
--- /dev/null
+++ b/include/trace/events/filemap.h
@@ -0,0 +1,75 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM filemap
+
+#if !defined(_TRACE_FILEMAP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_FILEMAP_H
+
+#include <linux/fs.h>
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(find_get_page,
+
+	TP_PROTO(struct address_space *mapping, pgoff_t offset,
+		struct page *page),
+
+	TP_ARGS(mapping, offset, page),
+
+	TP_STRUCT__entry(
+		__field(dev_t, s_dev)
+		__field(ino_t, i_ino)
+		__field(pgoff_t, offset)
+		__field(struct page *, page)
+		),
+
+	TP_fast_assign(
+		__entry->s_dev = mapping->host ? mapping->host->i_sb->s_dev : 0;
+		__entry->i_ino = mapping->host ? mapping->host->i_ino : 0;
+		__entry->offset = offset;
+		__entry->page = page;
+		),
+
+	TP_printk("s_dev=%u:%u i_ino=%lu offset=%lu %s", MAJOR(__entry->s_dev),
+		MINOR(__entry->s_dev), __entry->i_ino, __entry->offset,
+		__entry->page == NULL ? "page_not_found" : "page_found")
+);
+
+DECLARE_EVENT_CLASS(page_cache_template,
+
+	TP_PROTO(struct address_space *mapping, pgoff_t offset),
+
+	TP_ARGS(mapping, offset),
+
+	TP_STRUCT__entry(
+		__field(dev_t, s_dev)
+		__field(ino_t, i_ino)
+		__field(pgoff_t, offset)
+		),
+
+	TP_fast_assign(
+		__entry->s_dev = mapping->host->i_sb->s_dev;
+		__entry->i_ino = mapping->host->i_ino;
+		__entry->offset = offset;
+		),
+
+	TP_printk("s_dev=%u:%u i_ino=%lu offset=%lu", MAJOR(__entry->s_dev),
+		MINOR(__entry->s_dev), __entry->i_ino, __entry->offset)
+);
+
+DEFINE_EVENT(page_cache_template, add_to_page_cache,
+
+	TP_PROTO(struct address_space *mapping, pgoff_t offset),
+
+	TP_ARGS(mapping, offset)
+);
+
+DEFINE_EVENT(page_cache_template, remove_from_page_cache,
+
+	TP_PROTO(struct address_space *mapping, pgoff_t offset),
+
+	TP_ARGS(mapping, offset)
+);
+
+#endif /* _TRACE_FILEMAP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/mm/filemap.c b/mm/filemap.c
index a8251a8..9382785 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -35,6 +35,7 @@
 #include <linux/memcontrol.h>
 #include <linux/mm_inline.h> /* for page_is_file_cache() */
 #include <linux/cleancache.h>
+#include <trace/events/filemap.h>
 #include "internal.h"
 
 /*
@@ -169,6 +170,7 @@ void delete_from_page_cache(struct page *page)
 	spin_lock_irq(&mapping->tree_lock);
 	__delete_from_page_cache(page);
 	spin_unlock_irq(&mapping->tree_lock);
+	trace_remove_from_page_cache(mapping, page->index);
 	mem_cgroup_uncharge_cache_page(page);
 
 	if (freepage)
@@ -484,6 +486,7 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 			if (PageSwapBacked(page))
 				__inc_zone_page_state(page, NR_SHMEM);
 			spin_unlock_irq(&mapping->tree_lock);
+			trace_add_to_page_cache(mapping, offset);
 		} else {
 			page->mapping = NULL;
 			spin_unlock_irq(&mapping->tree_lock);
@@ -734,6 +737,7 @@ repeat:
 out:
 	rcu_read_unlock();
 
+	trace_find_get_page(mapping, offset, page);
 	return page;
 }
 EXPORT_SYMBOL(find_get_page);
diff --git a/mm/truncate.c b/mm/truncate.c
index e13f22e..5b10356 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -22,6 +22,7 @@
 #include <linux/cleancache.h>
 #include "internal.h"
 
+#include <trace/events/filemap.h>
 
 /**
  * do_invalidatepage - invalidate part or all of a page
@@ -406,6 +407,7 @@ invalidate_complete_page2(struct address_space *mapping, struct page *page)
 	BUG_ON(page_has_private(page));
 	__delete_from_page_cache(page);
 	spin_unlock_irq(&mapping->tree_lock);
+	trace_remove_from_page_cache(mapping, page->index);
 	mem_cgroup_uncharge_cache_page(page);
 
 	if (mapping->a_ops->freepage)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5ed24b9..b7aea3a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -53,6 +53,7 @@
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmscan.h>
+#include <trace/events/filemap.h>
 
 /*
  * reclaim_mode determines how the inactive list is shrunk
@@ -532,6 +533,7 @@ static int __remove_mapping(struct address_space *mapping, struct page *page)
 
 		__delete_from_page_cache(page);
 		spin_unlock_irq(&mapping->tree_lock);
+		trace_remove_from_page_cache(mapping, page->index);
 		mem_cgroup_uncharge_cache_page(page);
 
 		if (freepage != NULL)


