Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab3AIQqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:46:23 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:59984 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab3AIQqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:46:20 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, chavey@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] writeback: add more tracepoints
Date: Wed,  9 Jan 2013 08:45:08 -0800
Message-Id: <1357749908-16562-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1357749908-16562-1-git-send-email-tj@kernel.org>
References: <1357749908-16562-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tracepoints for page dirtying, writeback_single_inode start, inode
dirtying and writeback.  For the latter two inode events, a pair of
events are defined to denote start and end of the operations (the
starting one has _start suffix and the one w/o suffix happens after
the operation is complete).  These inode ops are FS specific and can
be non-trivial and having enclosing tracepoints is useful for external
tracers.

This is part of tracepoint additions to improve visiblity into
dirtying / writeback operations for io tracer and userland.

v2: writeback_dirty_inode[_start] TPs may be called for files on
    pseudo FSes w/ unregistered bdi.  Check whether bdi->dev is %NULL
    before dereferencing.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fs-writeback.c                |  17 ++++-
 include/trace/events/writeback.h | 135 +++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c              |   2 +
 3 files changed, 152 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 310972b..6cc8872 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -27,6 +27,7 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/tracepoint.h>
+#include <linux/buffer_head.h>
 #include "internal.h"
 
 /*
@@ -318,8 +319,14 @@ static void queue_io(struct bdi_writeback *wb, struct wb_writeback_work *work)
 
 static int write_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	if (inode->i_sb->s_op->write_inode && !is_bad_inode(inode))
-		return inode->i_sb->s_op->write_inode(inode, wbc);
+	int ret;
+
+	if (inode->i_sb->s_op->write_inode && !is_bad_inode(inode)) {
+		trace_writeback_write_inode_start(inode, wbc);
+		ret = inode->i_sb->s_op->write_inode(inode, wbc);
+		trace_writeback_write_inode(inode, wbc);
+		return ret;
+	}
 	return 0;
 }
 
@@ -450,6 +457,8 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 
 	WARN_ON(!(inode->i_state & I_SYNC));
 
+	trace_writeback_single_inode_start(inode, wbc, nr_to_write);
+
 	ret = do_writepages(mapping, wbc);
 
 	/*
@@ -1150,8 +1159,12 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	 * dirty the inode itself
 	 */
 	if (flags & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
+		trace_writeback_dirty_inode_start(inode, flags);
+
 		if (sb->s_op->dirty_inode)
 			sb->s_op->dirty_inode(inode, flags);
+
+		trace_writeback_dirty_inode(inode, flags);
 	}
 
 	/*
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index b453d92..2aff757 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -32,6 +32,134 @@
 
 struct wb_writeback_work;
 
+TRACE_EVENT(writeback_dirty_buffer,
+
+	TP_PROTO(struct buffer_head *bh),
+
+	TP_ARGS(bh),
+
+	TP_STRUCT__entry(
+		__array(char, name, 32)
+		__field(unsigned long long, block)
+	),
+
+	TP_fast_assign(
+		strncpy(__entry->name, bh->b_bdev->bd_disk->disk_name, 32);
+		__entry->block = bh->b_blocknr;
+	),
+
+	TP_printk("%s: dirty buffer %llu", __entry->name, __entry->block)
+);
+
+TRACE_EVENT(writeback_dirty_page,
+
+	TP_PROTO(struct page *page, struct address_space *mapping),
+
+	TP_ARGS(page, mapping),
+
+	TP_STRUCT__entry (
+		__array(char, name, 32)
+		__field(unsigned long, ino)
+		__field(pgoff_t, index)
+	),
+
+	TP_fast_assign(
+		strncpy(__entry->name,
+			mapping ? dev_name(mapping->backing_dev_info->dev) : "(unknown)", 32);
+		__entry->ino = mapping ? mapping->host->i_ino : 0;
+		__entry->index = page->index;
+	),
+
+	TP_printk("bdi %s: ino=%lu index=%lu",
+		__entry->name,
+		__entry->ino,
+		__entry->index
+	)
+);
+
+DECLARE_EVENT_CLASS(writeback_dirty_inode_template,
+
+	TP_PROTO(struct inode *inode, int flags),
+
+	TP_ARGS(inode, flags),
+
+	TP_STRUCT__entry (
+		__array(char, name, 32)
+		__field(unsigned long, ino)
+		__field(unsigned long, flags)
+	),
+
+	TP_fast_assign(
+		struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
+
+		/* may be called for files on pseudo FSes w/ unregistered bdi */
+		strncpy(__entry->name,
+			bdi->dev ? dev_name(bdi->dev) : "(unknown)", 32);
+		__entry->ino		= inode->i_ino;
+		__entry->flags		= flags;
+	),
+
+	TP_printk("bdi %s: ino=%lu flags=%s",
+		__entry->name,
+		__entry->ino,
+		show_inode_state(__entry->flags)
+	)
+);
+
+DEFINE_EVENT(writeback_dirty_inode_template, writeback_dirty_inode_start,
+
+	TP_PROTO(struct inode *inode, int flags),
+
+	TP_ARGS(inode, flags)
+);
+
+DEFINE_EVENT(writeback_dirty_inode_template, writeback_dirty_inode,
+
+	TP_PROTO(struct inode *inode, int flags),
+
+	TP_ARGS(inode, flags)
+);
+
+DECLARE_EVENT_CLASS(writeback_write_inode_template,
+
+	TP_PROTO(struct inode *inode, struct writeback_control *wbc),
+
+	TP_ARGS(inode, wbc),
+
+	TP_STRUCT__entry (
+		__array(char, name, 32)
+		__field(unsigned long, ino)
+		__field(int, sync_mode)
+	),
+
+	TP_fast_assign(
+		strncpy(__entry->name,
+			dev_name(inode->i_mapping->backing_dev_info->dev), 32);
+		__entry->ino		= inode->i_ino;
+		__entry->sync_mode	= wbc->sync_mode;
+	),
+
+	TP_printk("bdi %s: ino=%lu sync_mode=%d",
+		__entry->name,
+		__entry->ino,
+		__entry->sync_mode
+	)
+);
+
+DEFINE_EVENT(writeback_write_inode_template, writeback_write_inode_start,
+
+	TP_PROTO(struct inode *inode, struct writeback_control *wbc),
+
+	TP_ARGS(inode, wbc)
+);
+
+DEFINE_EVENT(writeback_write_inode_template, writeback_write_inode,
+
+	TP_PROTO(struct inode *inode, struct writeback_control *wbc),
+
+	TP_ARGS(inode, wbc)
+);
+
 DECLARE_EVENT_CLASS(writeback_work_class,
 	TP_PROTO(struct backing_dev_info *bdi, struct wb_writeback_work *work),
 	TP_ARGS(bdi, work),
@@ -479,6 +607,13 @@ DECLARE_EVENT_CLASS(writeback_single_inode_template,
 	)
 );
 
+DEFINE_EVENT(writeback_single_inode_template, writeback_single_inode_start,
+	TP_PROTO(struct inode *inode,
+		 struct writeback_control *wbc,
+		 unsigned long nr_to_write),
+	TP_ARGS(inode, wbc, nr_to_write)
+);
+
 DEFINE_EVENT(writeback_single_inode_template, writeback_single_inode,
 	TP_PROTO(struct inode *inode,
 		 struct writeback_control *wbc,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0713bfb..3734cef 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1982,6 +1982,8 @@ int __set_page_dirty_no_writeback(struct page *page)
  */
 void account_page_dirtied(struct page *page, struct address_space *mapping)
 {
+	trace_writeback_dirty_page(page, mapping);
+
 	if (mapping_cap_account_dirty(mapping)) {
 		__inc_zone_page_state(page, NR_FILE_DIRTY);
 		__inc_zone_page_state(page, NR_DIRTIED);
-- 
1.8.0.2

