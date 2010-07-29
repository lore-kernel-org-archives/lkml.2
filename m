Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab0G2MXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 08:23:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:34429 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301Ab0G2MXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 08:23:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,280,1278313200"; 
   d="scan'208";a="822872621"
Message-Id: <20100729121423.471866750@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 29 Jul 2010 19:51:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
cc: "linux-mm@kvack.org" <linux-mm@kvack.org>
cc: Dave Chinner <david@fromorbit.com>
cc: Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>
cc: Rik van Riel <riel@redhat.com>
cc: Johannes Weiner <hannes@cmpxchg.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>
cc: Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 3/5] writeback: prevent sync livelock with the sync_after timestamp
References: <20100729115142.102255590@intel.com>
Content-Disposition: inline; filename=writeback-sync-pending-start_time.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The start time in writeback_inodes_wb() is not very useful because it
slips at each invocation time. Preferrably one _constant_ time shall be
used at the beginning to cover the whole sync() work.

The newly dirtied inodes are now guarded at the queue_io() time instead
of the b_io walk time. This is more natural: non-empty b_io/b_more_io
means "more work pending".

The timestamp is now grabbed the sync work submission time, and may be
further optimized to the initial sync() call time.

CC: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |   16 ++++++----------
 include/linux/writeback.h |    4 ++--
 2 files changed, 8 insertions(+), 12 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2010-07-29 17:13:49.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-07-29 17:13:58.000000000 +0800
@@ -228,6 +228,10 @@ static void move_expired_inodes(struct l
 	struct inode *inode;
 	int do_sb_sort = 0;
 
+	if (wbc->for_sync) {
+		expire_interval = 1;
+		older_than_this = wbc->sync_after;
+	}
 	if (wbc->for_kupdate || wbc->for_background) {
 		expire_interval = msecs_to_jiffies(dirty_expire_interval * 10);
 		older_than_this = jiffies - expire_interval;
@@ -507,12 +511,6 @@ static int writeback_sb_inodes(struct su
 			requeue_io(inode);
 			continue;
 		}
-		/*
-		 * Was this inode dirtied after sync_sb_inodes was called?
-		 * This keeps sync from extra jobs and livelock.
-		 */
-		if (inode_dirtied_after(inode, wbc->wb_start))
-			return 1;
 
 		BUG_ON(inode->i_state & I_FREEING);
 		__iget(inode);
@@ -541,10 +539,9 @@ void writeback_inodes_wb(struct bdi_writ
 {
 	int ret = 0;
 
-	wbc->wb_start = jiffies; /* livelock avoidance */
 	spin_lock(&inode_lock);
 
-	if (!(wbc->for_kupdate || wbc->for_background) || list_empty(&wb->b_io))
+	if (list_empty(&wb->b_io))
 		queue_io(wb, wbc);
 
 	while (!list_empty(&wb->b_io)) {
@@ -571,9 +568,8 @@ static void __writeback_inodes_sb(struct
 {
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	wbc->wb_start = jiffies; /* livelock avoidance */
 	spin_lock(&inode_lock);
-	if (!(wbc->for_kupdate || wbc->for_background) || list_empty(&wb->b_io))
+	if (list_empty(&wb->b_io))
 		queue_io(wb, wbc);
 	writeback_sb_inodes(sb, wb, wbc, true);
 	spin_unlock(&inode_lock);
--- linux-next.orig/include/linux/writeback.h	2010-07-29 17:13:18.000000000 +0800
+++ linux-next/include/linux/writeback.h	2010-07-29 17:13:58.000000000 +0800
@@ -28,8 +28,8 @@ enum writeback_sync_modes {
  */
 struct writeback_control {
 	enum writeback_sync_modes sync_mode;
-	unsigned long wb_start;         /* Time writeback_inodes_wb was
-					   called. This is needed to avoid
+	unsigned long sync_after;	/* Only sync inodes dirtied after this
+					   timestamp. This is needed to avoid
 					   extra jobs and livelock */
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */


