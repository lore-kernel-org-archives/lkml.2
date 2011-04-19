Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab1DSDKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 23:10:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:18507 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab1DSDKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 23:10:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,236,1301900400"; 
   d="scan'208";a="421623783"
Message-Id: <20110419030532.515923886@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 19 Apr 2011 11:00:06 +0800
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
Subject: [PATCH 3/6] writeback: sync expired inodes first in background writeback
References: <20110419030003.108796967@intel.com>
Content-Disposition: inline; filename=writeback-expired-for-background.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A background flush work may run for ever. So it's reasonable for it to
mimic the kupdate behavior of syncing old/expired inodes first.

The policy is
- enqueue all newly expired inodes at each queue_io() time
- enqueue all dirty inodes if there are no more expired inodes to sync

This will help reduce the number of dirty pages encountered by page
reclaim, eg. the pageout() calls. Normally older inodes contain older
dirty pages, which are more close to the end of the LRU lists. So
syncing older inodes first helps reducing the dirty pages reached by
the page reclaim code.

Side effects: it will reduce the batch size and hence reduce
inode_wb_list_lock hold time, but also make the cluster-by-partition
logic in the same function less effective on reducing disk seeks.

CC: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-04-19 10:18:29.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-04-19 10:18:30.000000000 +0800
@@ -255,14 +255,14 @@ static void move_expired_inodes(struct l
 				struct writeback_control *wbc)
 {
 	unsigned long expire_interval = 0;
-	unsigned long older_than_this;
+	unsigned long uninitialized_var(older_than_this);
 	LIST_HEAD(tmp);
 	struct list_head *pos, *node;
 	struct super_block *sb = NULL;
 	struct inode *inode;
 	int do_sb_sort = 0;
 
-	if (wbc->for_kupdate) {
+	if (wbc->for_kupdate || wbc->for_background) {
 		expire_interval = msecs_to_jiffies(dirty_expire_interval * 10);
 		older_than_this = jiffies - expire_interval;
 	}
@@ -270,8 +270,20 @@ static void move_expired_inodes(struct l
 	while (!list_empty(delaying_queue)) {
 		inode = wb_inode(delaying_queue->prev);
 		if (expire_interval &&
-		    inode_dirtied_after(inode, older_than_this))
+		    inode_dirtied_after(inode, older_than_this)) {
+			/*
+			 * background writeback will start with expired inodes,
+			 * and then fresh inodes. This order helps reduce the
+			 * number of dirty pages reaching the end of LRU lists
+			 * and cause trouble to the page reclaim.
+			 */
+			if (wbc->for_background &&
+			    list_empty(dispatch_queue) && list_empty(&tmp)) {
+				expire_interval = 0;
+				continue;
+			}
 			break;
+		}
 		if (sb && sb != inode->i_sb)
 			do_sb_sort = 1;
 		sb = inode->i_sb;
@@ -585,7 +597,8 @@ void writeback_inodes_wb(struct bdi_writ
 	if (!wbc->wb_start)
 		wbc->wb_start = jiffies; /* livelock avoidance */
 	spin_lock(&inode_wb_list_lock);
-	if (!wbc->for_kupdate || list_empty(&wb->b_io))
+
+	if (list_empty(&wb->b_io))
 		queue_io(wb, wbc);
 
 	while (!list_empty(&wb->b_io)) {
@@ -612,7 +625,7 @@ static void __writeback_inodes_sb(struct
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	spin_lock(&inode_wb_list_lock);
-	if (!wbc->for_kupdate || list_empty(&wb->b_io))
+	if (list_empty(&wb->b_io))
 		queue_io(wb, wbc);
 	writeback_sb_inodes(sb, wb, wbc, true);
 	spin_unlock(&inode_wb_list_lock);


