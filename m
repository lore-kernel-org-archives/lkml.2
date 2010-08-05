Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661Ab0HEQ3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:29:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:19701 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760524Ab0HEQ3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:29:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,323,1278313200"; 
   d="scan'208";a="308628122"
Message-Id: <20100805162434.089718341@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 Aug 2010 00:11:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>
CC: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 10/13] writeback: kill writeback_control.more_io
References: <20100805161051.501816677@intel.com>
Content-Disposition: inline; filename=writeback-kill-more_io.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When wbc.more_io was first introduced, it indicates whether there are
at least one superblock whose s_more_io contains more IO work. Now with
the per-bdi writeback, it can be replaced with a simple b_more_io test.

Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mel@csn.ul.ie>
CC: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c                |    9 ++-------
 include/linux/writeback.h        |    1 -
 include/trace/events/ext4.h      |    5 +----
 include/trace/events/writeback.h |    5 +----
 4 files changed, 4 insertions(+), 16 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2010-08-05 23:28:10.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-08-05 23:28:11.000000000 +0800
@@ -516,12 +516,8 @@ static int writeback_sb_inodes(struct su
 		iput(inode);
 		cond_resched();
 		spin_lock(&inode_lock);
-		if (wbc->nr_to_write <= 0) {
-			wbc->more_io = 1;
+		if (wbc->nr_to_write <= 0)
 			return 1;
-		}
-		if (!list_empty(&wb->b_more_io))
-			wbc->more_io = 1;
 	}
 	/* b_io is empty */
 	return 1;
@@ -631,7 +627,6 @@ static long wb_writeback(struct bdi_writ
 		if (work->for_background && !over_bground_thresh())
 			break;
 
-		wbc.more_io = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
 
@@ -653,7 +648,7 @@ static long wb_writeback(struct bdi_writ
 		/*
 		 * Didn't write everything and we don't have more IO, bail
 		 */
-		if (!wbc.more_io)
+		if (list_empty(&wb->b_more_io))
 			break;
 		/*
 		 * Did we write something? Try for more
--- linux-next.orig/include/linux/writeback.h	2010-08-05 23:28:10.000000000 +0800
+++ linux-next/include/linux/writeback.h	2010-08-05 23:28:11.000000000 +0800
@@ -49,7 +49,6 @@ struct writeback_control {
 	unsigned for_background:1;	/* A background writeback */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
-	unsigned more_io:1;		/* more io to be dispatched */
 };
 
 /*
--- linux-next.orig/include/trace/events/writeback.h	2010-08-05 23:28:10.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2010-08-05 23:28:11.000000000 +0800
@@ -100,7 +100,6 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__field(int, for_background)
 		__field(int, for_reclaim)
 		__field(int, range_cyclic)
-		__field(int, more_io)
 		__field(long, range_start)
 		__field(long, range_end)
 	),
@@ -114,13 +113,12 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__entry->for_background	= wbc->for_background;
 		__entry->for_reclaim	= wbc->for_reclaim;
 		__entry->range_cyclic	= wbc->range_cyclic;
-		__entry->more_io	= wbc->more_io;
 		__entry->range_start	= (long)wbc->range_start;
 		__entry->range_end	= (long)wbc->range_end;
 	),
 
 	TP_printk("bdi %s: towrt=%ld skip=%ld mode=%d kupd=%d "
-		"bgrd=%d reclm=%d cyclic=%d more=%d "
+		"bgrd=%d reclm=%d cyclic=%d "
 		"start=0x%lx end=0x%lx",
 		__entry->name,
 		__entry->nr_to_write,
@@ -130,7 +128,6 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__entry->for_background,
 		__entry->for_reclaim,
 		__entry->range_cyclic,
-		__entry->more_io,
 		__entry->range_start,
 		__entry->range_end)
 )
--- linux-next.orig/include/trace/events/ext4.h	2010-08-05 23:27:33.000000000 +0800
+++ linux-next/include/trace/events/ext4.h	2010-08-05 23:28:11.000000000 +0800
@@ -305,7 +305,6 @@ TRACE_EVENT(ext4_da_writepages_result,
 		__field(	int,	ret			)
 		__field(	int,	pages_written		)
 		__field(	long,	pages_skipped		)
-		__field(	char,	more_io			)	
 		__field(       pgoff_t,	writeback_index		)
 	),
 
@@ -315,15 +314,13 @@ TRACE_EVENT(ext4_da_writepages_result,
 		__entry->ret		= ret;
 		__entry->pages_written	= pages_written;
 		__entry->pages_skipped	= wbc->pages_skipped;
-		__entry->more_io	= wbc->more_io;
 		__entry->writeback_index = inode->i_mapping->writeback_index;
 	),
 
-	TP_printk("dev %s ino %lu ret %d pages_written %d pages_skipped %ld more_io %d writeback_index %lu",
+       TP_printk("dev %s ino %lu ret %d pages_written %d pages_skipped %ld writeback_index %lu",
 		  jbd2_dev_to_name(__entry->dev),
 		  (unsigned long) __entry->ino, __entry->ret,
 		  __entry->pages_written, __entry->pages_skipped,
-		  __entry->more_io,
 		  (unsigned long) __entry->writeback_index)
 );
 


