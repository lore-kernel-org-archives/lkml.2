Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006Ab1DUEKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 00:10:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:27220 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab1DUEKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 00:10:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,249,1301900400"; 
   d="scan'208";a="631854216"
Date: Thu, 21 Apr 2011 12:10:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 3/6] writeback: sync expired inodes first in background
 writeback
Message-ID: <20110421041010.GA18710@localhost>
References: <20110419030532.515923886@intel.com>
 <20110419073523.GF23985@dastard>
 <20110419095740.GC5257@quack.suse.cz>
 <20110419125616.GA20059@localhost>
 <20110420012120.GK23985@dastard>
 <20110420025321.GA14398@localhost>
 <20110421004547.GD1814@dastard>
 <20110421020617.GB12191@localhost>
 <20110421030152.GG1814@dastard>
 <20110421035954.GA15461@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421035954.GA15461@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Still, given wb_writeback() is the only caller of both
> > __writeback_inodes_sb and writeback_inodes_wb(), I'm wondering if
> > moving the queue_io calls up into wb_writeback() would clean up this
> > logic somewhat. I think Jan mentioned doing something like this as
> > well elsewhere in the thread...
> 
> Unfortunately they call queue_io() inside the lock..

OK, let's try moving up the lock too. Do you like this change? :)

Thanks,
Fengguang
---
 fs/fs-writeback.c |   22 ++++++----------------
 mm/backing-dev.c  |    4 ++++
 2 files changed, 10 insertions(+), 16 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-04-21 12:04:02.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-04-21 12:05:54.000000000 +0800
@@ -591,7 +591,6 @@ void writeback_inodes_wb(struct bdi_writ
 
 	if (!wbc->wb_start)
 		wbc->wb_start = jiffies; /* livelock avoidance */
-	spin_lock(&inode_wb_list_lock);
 
 	if (list_empty(&wb->b_io))
 		queue_io(wb, wbc);
@@ -610,22 +609,9 @@ void writeback_inodes_wb(struct bdi_writ
 		if (ret)
 			break;
 	}
-	spin_unlock(&inode_wb_list_lock);
 	/* Leave any unwritten inodes on b_io */
 }
 
-static void __writeback_inodes_sb(struct super_block *sb,
-		struct bdi_writeback *wb, struct writeback_control *wbc)
-{
-	WARN_ON(!rwsem_is_locked(&sb->s_umount));
-
-	spin_lock(&inode_wb_list_lock);
-	if (list_empty(&wb->b_io))
-		queue_io(wb, wbc);
-	writeback_sb_inodes(sb, wb, wbc, true);
-	spin_unlock(&inode_wb_list_lock);
-}
-
 static inline bool over_bground_thresh(void)
 {
 	unsigned long background_thresh, dirty_thresh;
@@ -652,7 +638,7 @@ static unsigned long writeback_chunk_siz
 	 * The intended call sequence for WB_SYNC_ALL writeback is:
 	 *
 	 *      wb_writeback()
-	 *          __writeback_inodes_sb()     <== called only once
+	 *          writeback_sb_inodes()       <== called only once
 	 *              write_cache_pages()     <== called once for each inode
 	 *                  (quickly) tag currently dirty pages
 	 *                  (maybe slowly) sync all tagged pages
@@ -742,10 +728,14 @@ static long wb_writeback(struct bdi_writ
 
 retry:
 		trace_wbc_writeback_start(&wbc, wb->bdi);
+		spin_lock(&inode_wb_list_lock);
+		if (list_empty(&wb->b_io))
+			queue_io(wb, wbc);
 		if (work->sb)
-			__writeback_inodes_sb(work->sb, wb, &wbc);
+			writeback_sb_inodes(work->sb, wb, &wbc, true);
 		else
 			writeback_inodes_wb(wb, &wbc);
+		spin_unlock(&inode_wb_list_lock);
 		trace_wbc_writeback_written(&wbc, wb->bdi);
 
 		bdi_update_write_bandwidth(wb->bdi, wbc.wb_start);
--- linux-next.orig/mm/backing-dev.c	2011-04-21 12:06:02.000000000 +0800
+++ linux-next/mm/backing-dev.c	2011-04-21 12:06:31.000000000 +0800
@@ -268,7 +268,11 @@ static void bdi_flush_io(struct backing_
 		.nr_to_write		= 1024,
 	};
 
+	spin_lock(&inode_wb_list_lock);
+	if (list_empty(&wb->b_io))
+		queue_io(wb, wbc);
 	writeback_inodes_wb(&bdi->wb, &wbc);
+	spin_unlock(&inode_wb_list_lock);
 }
 
 /*
