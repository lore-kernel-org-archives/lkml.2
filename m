Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935116Ab1ESV63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:58:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:28947 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935004Ab1ESVyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:54:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,239,1304319600"; 
   d="scan'208";a="1185204"
Message-Id: <20110519214745.534355616@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 20 May 2011 05:45:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/18] writeback: avoid extra sync work at enqueue time
References: <20110519214530.939830917@intel.com>
Content-Disposition: inline; filename=writeback-kill-wb_start.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes writeback_control.wb_start and does more straightforward
sync livelock prevention by setting .older_than_this to prevent extra
inodes from being enqueued in the first place.

Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |   16 +++-------------
 include/linux/writeback.h |    3 ---
 2 files changed, 3 insertions(+), 16 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-20 05:12:41.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-20 05:12:42.000000000 +0800
@@ -544,15 +544,6 @@ static int writeback_sb_inodes(struct su
 			continue;
 		}
 
-		/*
-		 * Was this inode dirtied after sync_sb_inodes was called?
-		 * This keeps sync from extra jobs and livelock.
-		 */
-		if (inode_dirtied_after(inode, wbc->wb_start)) {
-			spin_unlock(&inode->i_lock);
-			return 1;
-		}
-
 		__iget(inode);
 
 		pages_skipped = wbc->pages_skipped;
@@ -585,9 +576,6 @@ static void __writeback_inodes_wb(struct
 {
 	int ret = 0;
 
-	if (!wbc->wb_start)
-		wbc->wb_start = jiffies; /* livelock avoidance */
-
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = wb_inode(wb->b_io.prev);
 		struct super_block *sb = inode->i_sb;
@@ -686,7 +674,9 @@ static long wb_writeback(struct bdi_writ
 	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_writepages)
 		write_chunk = LONG_MAX;
 
-	wbc.wb_start = jiffies; /* livelock avoidance */
+	oldest_jif = jiffies;
+	wbc.older_than_this = &oldest_jif;
+
 	spin_lock(&wb->list_lock);
 	for (;;) {
 		/*
--- linux-next.orig/include/linux/writeback.h	2011-05-20 05:11:32.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-05-20 05:12:42.000000000 +0800
@@ -26,9 +26,6 @@ struct writeback_control {
 	enum writeback_sync_modes sync_mode;
 	unsigned long *older_than_this;	/* If !NULL, only write back inodes
 					   older than this */
-	unsigned long wb_start;         /* Time writeback_inodes_wb was
-					   called. This is needed to avoid
-					   extra jobs and livelock */
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */


