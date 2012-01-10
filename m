Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab2AJS36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:29:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52173 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab2AJS2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:28:52 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com
Cc: linux-kernel@vger.kernel.org, winget@google.com, namhyung@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/9] block: add block_touch_buffer tracepoint
Date: Tue, 10 Jan 2012 10:28:23 -0800
Message-Id: <1326220106-5765-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1326220106-5765-1-git-send-email-tj@kernel.org>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add block_touch_buffer tracepoint which gets triggered on
touch_buffer().

Because touch_buffer() is defined as macro in linux/buffer_head.h,
this creates circular dependency between linux/buffer_head.h and
events/block.h.  As event header needs buffer_head details only when
the tracepoints are actually created (CREATE_TRACE_POINTS is defined),
this can be easily solved by including buffer_head.h before setting
CREATE_TRACE_POINTS and including the event header to create
tracepoints.

This is part of tracepoint additions to improve visiblity into
dirtying / writeback operations for io tracer and userland.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c             |    1 +
 include/linux/buffer_head.h  |    7 ++++++-
 include/trace/events/block.h |   25 +++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index dd45d6e..8f59db3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -29,6 +29,7 @@
 #include <linux/fault-inject.h>
 #include <linux/list_sort.h>
 #include <linux/delay.h>
+#include <linux/buffer_head.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/block.h>
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 458f497..245caed 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/wait.h>
 #include <linux/atomic.h>
+#include <trace/events/block.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -126,7 +127,11 @@ BUFFER_FNS(Write_EIO, write_io_error)
 BUFFER_FNS(Unwritten, unwritten)
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
-#define touch_buffer(bh)	mark_page_accessed(bh->b_page)
+
+#define touch_buffer(bh)	do {				\
+		trace_block_touch_buffer(bh);			\
+		mark_page_accessed(bh->b_page);			\
+	} while (0)
 
 /* If we *know* page->private refers to buffer_heads */
 #define page_buffers(page)					\
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 983f8a8..4fcc09d 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -6,10 +6,35 @@
 
 #include <linux/blktrace_api.h>
 #include <linux/blkdev.h>
+#include <linux/buffer_head.h>
 #include <linux/tracepoint.h>
 
 #define RWBS_LEN	8
 
+TRACE_EVENT(block_touch_buffer,
+
+	TP_PROTO(struct buffer_head *bh),
+
+	TP_ARGS(bh),
+
+	TP_STRUCT__entry (
+		__field(  dev_t,	dev			)
+		__field(  sector_t,	sector			)
+		__field(  size_t,	size			)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bh->b_bdev->bd_dev;
+		__entry->sector		= bh->b_blocknr;
+		__entry->size		= bh->b_size;
+	),
+
+	TP_printk("%d,%d get_bh sector=%llu size=%zu",
+		MAJOR(__entry->dev), MINOR(__entry->dev),
+		(unsigned long long)__entry->sector, __entry->size
+	)
+);
+
 DECLARE_EVENT_CLASS(block_rq_with_error,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
-- 
1.7.3.1

