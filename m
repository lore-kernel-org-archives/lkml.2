Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab1D3Wss (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 18:48:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:9222 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833Ab1D3WsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 18:48:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,294,1301900400"; 
   d="scan'208";a="740667241"
Message-Id: <20110430224552.472068133@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 01 May 2011 06:36:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 3/3] writeback: avoid extra sync work at enqueue time
References: <20110430223605.034517922@intel.com>
Content-Disposition: inline; filename=writeback-kill-wb_start.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes writeback_control.wb_start and does more straightforward
sync livelock prevention by setting .older_than_this to prevent extra
inodes from being enqueued in the first place.

CC: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |   17 ++++-------------
 include/linux/writeback.h |    3 ---
 2 files changed, 4 insertions(+), 16 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-01 06:35:19.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-01 06:35:21.000000000 +0800
@@ -543,15 +543,6 @@ static int writeback_sb_inodes(struct su
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
@@ -584,8 +575,6 @@ static void __writeback_inodes_wb(struct
 {
 	int ret = 0;
 
-	if (!wbc->wb_start)
-		wbc->wb_start = jiffies; /* livelock avoidance */
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = wb_inode(wb->b_io.prev);
@@ -682,10 +671,12 @@ static long wb_writeback(struct bdi_writ
 	 *                   (quickly) tag currently dirty pages
 	 *                   (maybe slowly) sync all tagged pages
 	 */
-	if (wbc.for_sync)
+	if (wbc.for_sync) {
 		write_chunk = LONG_MAX;
+		oldest_jif = jiffies;
+		wbc.older_than_this = &oldest_jif;
+	}
 
-	wbc.wb_start = jiffies; /* livelock avoidance */
 	for (;;) {
 		/*
 		 * Stop writeback when nr_pages has been consumed
--- linux-next.orig/include/linux/writeback.h	2011-05-01 06:35:17.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-05-01 06:35:21.000000000 +0800
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


