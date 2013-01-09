Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab3AIQqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:46:20 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:42860 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab3AIQqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:46:18 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, chavey@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] block: add block_touch_buffer tracepoint
Date: Wed,  9 Jan 2013 08:45:07 -0800
Message-Id: <1357749908-16562-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1357749908-16562-1-git-send-email-tj@kernel.org>
References: <1357749908-16562-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add block_touch_buffer tracepoint which gets triggered on
touch_buffer().

This is part of tracepoint additions to improve visiblity into
dirtying / writeback operations for io tracer and userland.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/buffer.c                  |  2 ++
 include/trace/events/block.h | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index a8c2dfb..4d9169d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -41,6 +41,7 @@
 #include <linux/bitops.h>
 #include <linux/mpage.h>
 #include <linux/bit_spinlock.h>
+#include <trace/events/block.h>
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
 
@@ -55,6 +56,7 @@ EXPORT_SYMBOL(init_buffer);
 
 inline void touch_buffer(struct buffer_head *bh)
 {
+	trace_block_touch_buffer(bh);
 	mark_page_accessed(bh->b_page);
 }
 EXPORT_SYMBOL(touch_buffer);
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index b408f51..e206cc6 100644
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
+	TP_printk("%d,%d sector=%llu size=%zu",
+		MAJOR(__entry->dev), MINOR(__entry->dev),
+		(unsigned long long)__entry->sector, __entry->size
+	)
+);
+
 DECLARE_EVENT_CLASS(block_rq_with_error,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
-- 
1.8.0.2

