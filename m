Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1EDJ27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:28:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:6973 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab1EDJ2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:28:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,313,1301900400"; 
   d="scan'208";a="637712462"
Message-Id: <20110504091909.766872085@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 04 May 2011 17:17:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 5/6] writeback: trace event writeback_queue_io
References: <20110504091707.910929441@intel.com>
Content-Disposition: inline; filename=writeback-trace-queue_io.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that it adds a little overheads to account the moved/enqueued
inodes from b_dirty to b_io. The "moved" accounting may be later used to
limit the number of inodes that can be moved in one shot, in order to
keep spinlock hold time under control.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c                |   16 +++++++++++-----
 include/trace/events/writeback.h |   23 +++++++++++++++++++++++
 2 files changed, 34 insertions(+), 5 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-04 16:01:27.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-04 16:09:01.000000000 +0800
@@ -248,15 +248,16 @@ static bool inode_dirtied_after(struct i
 /*
  * Move expired dirty inodes from @delaying_queue to @dispatch_queue.
  */
-static void move_expired_inodes(struct list_head *delaying_queue,
-				struct list_head *dispatch_queue,
-				struct writeback_control *wbc)
+static int move_expired_inodes(struct list_head *delaying_queue,
+			       struct list_head *dispatch_queue,
+			       struct writeback_control *wbc)
 {
 	LIST_HEAD(tmp);
 	struct list_head *pos, *node;
 	struct super_block *sb = NULL;
 	struct inode *inode;
 	int do_sb_sort = 0;
+	int moved = 0;
 
 	while (!list_empty(delaying_queue)) {
 		inode = wb_inode(delaying_queue->prev);
@@ -267,12 +268,13 @@ static void move_expired_inodes(struct l
 			do_sb_sort = 1;
 		sb = inode->i_sb;
 		list_move(&inode->i_wb_list, &tmp);
+		moved++;
 	}
 
 	/* just one sb in list, splice to dispatch_queue and we're done */
 	if (!do_sb_sort) {
 		list_splice(&tmp, dispatch_queue);
-		return;
+		goto out;
 	}
 
 	/* Move inodes from one superblock together */
@@ -284,6 +286,8 @@ static void move_expired_inodes(struct l
 				list_move(&inode->i_wb_list, dispatch_queue);
 		}
 	}
+out:
+	return moved;
 }
 
 /*
@@ -299,9 +303,11 @@ static void move_expired_inodes(struct l
  */
 static void queue_io(struct bdi_writeback *wb, struct writeback_control *wbc)
 {
+	int moved;
 	assert_spin_locked(&wb->list_lock);
 	list_splice_init(&wb->b_more_io, &wb->b_io);
-	move_expired_inodes(&wb->b_dirty, &wb->b_io, wbc);
+	moved = move_expired_inodes(&wb->b_dirty, &wb->b_io, wbc);
+	trace_writeback_queue_io(wb, wbc, moved);
 }
 
 static int write_inode(struct inode *inode, struct writeback_control *wbc)
--- linux-next.orig/include/trace/events/writeback.h	2011-05-04 16:06:50.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-05-04 16:08:58.000000000 +0800
@@ -165,6 +165,29 @@ DEFINE_WBC_EVENT(wbc_balance_dirty_writt
 DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
 DEFINE_WBC_EVENT(wbc_writepage);
 
+TRACE_EVENT(writeback_queue_io,
+	TP_PROTO(struct bdi_writeback *wb,
+		 struct writeback_control *wbc,
+		 int moved),
+	TP_ARGS(wb, wbc, moved),
+	TP_STRUCT__entry(
+		__array(char,	name, 32)
+		__field(int,	older)
+		__field(int,	moved)
+	),
+	TP_fast_assign(
+		strncpy(__entry->name, dev_name(wb->bdi->dev), 32);
+		__entry->older	= wbc->older_than_this ?
+				  (jiffies - *wbc->older_than_this) * 1000 / HZ
+				  : -1;
+		__entry->moved	= moved;
+	),
+	TP_printk("bdi %s: older=%d enqueue=%d",
+		__entry->name,
+		__entry->older,
+		__entry->moved)
+);
+
 DECLARE_EVENT_CLASS(writeback_congest_waited_template,
 
 	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),


