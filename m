Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab1ELOHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:07:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:58027 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757470Ab1ELOEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:04:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,358,1301900400"; 
   d="scan'208";a="746250954"
Message-Id: <20110512140031.797468050@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 12 May 2011 21:57:15 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/17] writeback: elevate queue_io() into wb_writeback()
References: <20110512135706.937596128@intel.com>
Content-Disposition: inline; filename=move-queue_io.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code refactor for more logical code layout.
No behavior change.

- remove the mis-named __writeback_inodes_sb()

- wb_writeback()/writeback_inodes_wb() will decide when to queue_io()
  before calling __writeback_inodes_wb()

Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-05 23:41:36.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-05 23:51:59.000000000 +0800
@@ -580,17 +580,13 @@ static int writeback_sb_inodes(struct su
 	return 1;
 }
 
-void writeback_inodes_wb(struct bdi_writeback *wb,
-		struct writeback_control *wbc)
+static void __writeback_inodes_wb(struct bdi_writeback *wb,
+				  struct writeback_control *wbc)
 {
 	int ret = 0;
 
 	if (!wbc->wb_start)
 		wbc->wb_start = jiffies; /* livelock avoidance */
-	spin_lock(&wb->list_lock);
-
-	if (list_empty(&wb->b_io))
-		queue_io(wb, wbc->older_than_this);
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = wb_inode(wb->b_io.prev);
@@ -606,19 +602,16 @@ void writeback_inodes_wb(struct bdi_writ
 		if (ret)
 			break;
 	}
-	spin_unlock(&wb->list_lock);
 	/* Leave any unwritten inodes on b_io */
 }
 
-static void __writeback_inodes_sb(struct super_block *sb,
-		struct bdi_writeback *wb, struct writeback_control *wbc)
+void writeback_inodes_wb(struct bdi_writeback *wb,
+		struct writeback_control *wbc)
 {
-	WARN_ON(!rwsem_is_locked(&sb->s_umount));
-
 	spin_lock(&wb->list_lock);
 	if (list_empty(&wb->b_io))
 		queue_io(wb, wbc->older_than_this);
-	writeback_sb_inodes(sb, wb, wbc, true);
+	__writeback_inodes_wb(wb, wbc);
 	spin_unlock(&wb->list_lock);
 }
 
@@ -685,7 +678,7 @@ static long wb_writeback(struct bdi_writ
 	 * The intended call sequence for WB_SYNC_ALL writeback is:
 	 *
 	 *      wb_writeback()
-	 *          __writeback_inodes_sb()     <== called only once
+	 *          writeback_sb_inodes()       <== called only once
 	 *              write_cache_pages()     <== called once for each inode
 	 *                   (quickly) tag currently dirty pages
 	 *                   (maybe slowly) sync all tagged pages
@@ -731,10 +724,14 @@ static long wb_writeback(struct bdi_writ
 
 retry:
 		trace_wbc_writeback_start(&wbc, wb->bdi);
+		spin_lock(&wb->list_lock);
+		if (list_empty(&wb->b_io))
+			queue_io(wb, wbc.older_than_this);
 		if (work->sb)
-			__writeback_inodes_sb(work->sb, wb, &wbc);
+			writeback_sb_inodes(work->sb, wb, &wbc, true);
 		else
-			writeback_inodes_wb(wb, &wbc);
+			__writeback_inodes_wb(wb, &wbc);
+		spin_unlock(&wb->list_lock);
 		trace_wbc_writeback_written(&wbc, wb->bdi);
 
 		work->nr_pages -= write_chunk - wbc.nr_to_write;


