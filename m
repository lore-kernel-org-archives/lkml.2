Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab1DZOoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:44:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:30551 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab1DZOoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:44:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,268,1301900400"; 
   d="scan'208";a="425717149"
Date: Tue, 26 Apr 2011 22:44:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 2/2] writeback: elevate queue_io() into wb_writeback()
Message-ID: <20110426144402.GA15166@localhost>
References: <20110426144218.GA14862@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426144218.GA14862@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code refactor for more logical code layout.
No behavior change.

- remove the mis-named __writeback_inodes_sb()

- wb_writeback()/writeback_inodes_wb() will decide when to queue_io()
  before calling __writeback_inodes_wb()

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-04-26 13:20:17.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-04-26 13:30:19.000000000 +0800
@@ -570,17 +570,13 @@ static int writeback_sb_inodes(struct su
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
-		queue_io(wb, wbc);
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = wb_inode(wb->b_io.prev);
@@ -596,19 +592,16 @@ void writeback_inodes_wb(struct bdi_writ
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
 		queue_io(wb, wbc);
-	writeback_sb_inodes(sb, wb, wbc, true);
+	__writeback_inodes_wb(wb, wbc);
 	spin_unlock(&wb->list_lock);
 }
 
@@ -674,7 +667,7 @@ static long wb_writeback(struct bdi_writ
 	 * The intended call sequence for WB_SYNC_ALL writeback is:
 	 *
 	 *      wb_writeback()
-	 *          __writeback_inodes_sb()     <== called only once
+	 *          writeback_sb_inodes()       <== called only once
 	 *              write_cache_pages()     <== called once for each inode
 	 *                   (quickly) tag currently dirty pages
 	 *                   (maybe slowly) sync all tagged pages
@@ -722,10 +715,14 @@ static long wb_writeback(struct bdi_writ
 
 retry:
 		trace_wbc_writeback_start(&wbc, wb->bdi);
+		spin_lock(&wb->list_lock);
+		if (list_empty(&wb->b_io))
+			queue_io(wb, &wbc);
 		if (work->sb)
-			__writeback_inodes_sb(work->sb, wb, &wbc);
+			writeback_sb_inodes(work->sb, wb, &wbc, true);
 		else
-			writeback_inodes_wb(wb, &wbc);
+			__writeback_inodes_wb(wb, &wbc);
+		spin_unlock(&wb->list_lock);
 		trace_wbc_writeback_written(&wbc, wb->bdi);
 
 		work->nr_pages -= write_chunk - wbc.nr_to_write;
