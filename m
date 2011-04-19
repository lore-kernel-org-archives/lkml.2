Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab1DSDK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 23:10:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:6529 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab1DSDKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 23:10:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,236,1301900400"; 
   d="scan'208";a="911423210"
Message-Id: <20110419030532.268874944@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 19 Apr 2011 11:00:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Mel Gorman <mel@linux.vnet.ibm.com>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>
cc: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
CC: Minchan Kim <minchan.kim@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 1/6] writeback: pass writeback_control down to move_expired_inodes()
References: <20110419030003.108796967@intel.com>
Content-Disposition: inline; filename=writeback-pass-wbc-to-queue_io.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to prepare for moving the dirty expire policy to move_expired_inodes().
No behavior change.

Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-04-19 10:18:17.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-04-19 10:18:28.000000000 +0800
@@ -251,8 +251,8 @@ static bool inode_dirtied_after(struct i
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
@@ -262,8 +262,8 @@ static void move_expired_inodes(struct l
 
 	while (!list_empty(delaying_queue)) {
 		inode = wb_inode(delaying_queue->prev);
-		if (older_than_this &&
-		    inode_dirtied_after(inode, *older_than_this))
+		if (wbc->older_than_this &&
+		    inode_dirtied_after(inode, *wbc->older_than_this))
 			break;
 		if (sb && sb != inode->i_sb)
 			do_sb_sort = 1;
@@ -299,11 +299,11 @@ static void move_expired_inodes(struct l
  *                                           |
  *                                           +--> dequeue for IO
  */
-static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
+static void queue_io(struct bdi_writeback *wb, struct writeback_control *wbc)
 {
 	assert_spin_locked(&inode_wb_list_lock);
 	list_splice_init(&wb->b_more_io, &wb->b_io);
-	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
+	move_expired_inodes(&wb->b_dirty, &wb->b_io, wbc);
 }
 
 static int write_inode(struct inode *inode, struct writeback_control *wbc)
@@ -579,7 +579,7 @@ void writeback_inodes_wb(struct bdi_writ
 		wbc->wb_start = jiffies; /* livelock avoidance */
 	spin_lock(&inode_wb_list_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
-		queue_io(wb, wbc->older_than_this);
+		queue_io(wb, wbc);
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = wb_inode(wb->b_io.prev);
@@ -606,7 +606,7 @@ static void __writeback_inodes_sb(struct
 
 	spin_lock(&inode_wb_list_lock);
 	if (!wbc->for_kupdate || list_empty(&wb->b_io))
-		queue_io(wb, wbc->older_than_this);
+		queue_io(wb, wbc);
 	writeback_sb_inodes(sb, wb, wbc, true);
 	spin_unlock(&inode_wb_list_lock);
 }


