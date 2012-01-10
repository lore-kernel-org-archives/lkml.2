Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab2AJS2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:28:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52173 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711Ab2AJS2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:28:49 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com
Cc: linux-kernel@vger.kernel.org, winget@google.com, namhyung@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/9] writeback: add more tracepoints
Date: Tue, 10 Jan 2012 10:28:22 -0800
Message-Id: <1326220106-5765-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1326220106-5765-1-git-send-email-tj@kernel.org>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
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

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fs-writeback.c                |   16 +++++-
 include/trace/events/writeback.h |  113 ++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c              |    2 +
 3 files changed, 129 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a97cb49..ace4a45 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -298,8 +298,14 @@ static void queue_io(struct bdi_writeback *wb, struct wb_writeback_work *work)
 
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
 
@@ -380,6 +386,8 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&wb->list_lock);
 
+	trace_writeback_single_inode_start(inode, wbc, nr_to_write);
+
 	ret = do_writepages(mapping, wbc);
 
 	/*
@@ -1037,8 +1045,12 @@ void __mark_inode_dirty(struct inode *inode, int flags)
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
index 99d1d0d..c8fc9d9 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -33,6 +33,112 @@
 
 struct wb_writeback_work;
 
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
+		strncpy(__entry->name,
+			dev_name(inode->i_mapping->backing_dev_info->dev), 32);
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
+	TP_printk("bdi %s: ino=%lu mode=%d",
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
@@ -447,6 +553,13 @@ DEFINE_EVENT(writeback_single_inode_template, writeback_single_inode_requeue,
 	TP_ARGS(inode, wbc, nr_to_write)
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
index 8616ef3..4cf8c6d9 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1735,6 +1735,8 @@ int __set_page_dirty_no_writeback(struct page *page)
  */
 void account_page_dirtied(struct page *page, struct address_space *mapping)
 {
+	trace_writeback_dirty_page(page, mapping);
+
 	if (mapping_cap_account_dirty(mapping)) {
 		__inc_zone_page_state(page, NR_FILE_DIRTY);
 		__inc_zone_page_state(page, NR_DIRTIED);
-- 
1.7.3.1

