Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab0GVGTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 02:19:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:4212 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab0GVGT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 02:19:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,241,1278313200"; 
   d="scan'208";a="640650034"
Message-Id: <20100722061822.484666925@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 22 Jul 2010 13:09:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Chinner <david@fromorbit.com>, Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Chris Mason <chris.mason@oracle.com>
CC: Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org
CC: linux-mm@kvack.org
Subject: [PATCH 1/6] writeback: pass writeback_control down to move_expired_inodes()
References: <20100722050928.653312535@intel.com>
Content-Disposition: inline; filename=writeback-pass-wbc-to-queue_io.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to prepare for moving the dirty expire policy to move_expired_inodes().
No behavior change.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2010-07-21 20:12:38.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-07-21 20:14:38.000000000 +0800
@@ -213,8 +213,8 @@ static bool inode_dirtied_after(struct i
  * Move expired dirty inodes from @delaying_queue to @dispatch_queue.
  */
 static void move_expired_inodes(struct list_head *delaying_queue,
-			       struct list_head *dispatch_queue,
-				unsigned long *older_than_this)
+				struct list_head *dispatch_queue,
+				struct writeback_control *wbc)
 {
 	LIST_HEAD(tmp);
 	struct list_head *pos, *node;
@@ -224,8 +224,8 @@ static void move_expired_inodes(struct l
 
 	while (!list_empty(delaying_queue)) {
 		inode = list_entry(delaying_queue->prev, struct inode, i_list);
-		if (older_than_this &&
-		    inode_dirtied_after(inode, *older_than_this))
+		if (wbc->older_than_this &&
+		    inode_dirtied_after(inode, *wbc->older_than_this))
 			break;
 		if (sb && sb != inode->i_sb)
 			do_sb_sort = 1;
@@ -257,10 +257,10 @@ static void move_expired_inodes(struct l
  *                 => b_more_io inodes
  *                 => remaining inodes in b_io => (dequeue for sync)
  */
-static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
+static void queue_io(struct bdi_writeback *wb, struct writeback_control *wbc)
 {
 	list_splice_init(&wb->b_more_io, &wb->b_io);
-	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
+	move_expired_inodes(&wb->b_dirty, &wb->b_io, wbc);
 }
 
 static int write_inode(struct inode *inode, struct writeback_control *wbc)
@@ -519,7 +519,7 @@ void writeback_inodes_wb(struct bdi_writ
 	wbc->wb_start = jiffies; /* livelock avoidance */
 	spin_lock(&inode_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
-		queue_io(wb, wbc->older_than_this);
+		queue_io(wb, wbc);
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = list_entry(wb->b_io.prev,
@@ -548,7 +548,7 @@ static void __writeback_inodes_sb(struct
 	wbc->wb_start = jiffies; /* livelock avoidance */
 	spin_lock(&inode_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
-		queue_io(wb, wbc->older_than_this);
+		queue_io(wb, wbc);
 	writeback_sb_inodes(sb, wb, wbc, true);
 	spin_unlock(&inode_lock);
 }


