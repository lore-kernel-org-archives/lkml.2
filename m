Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab1EXFZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:25:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:54844 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab1EXFVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:21:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,260,1304319600"; 
   d="scan'208";a="6613953"
Message-Id: <20110524051859.843053641@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 24 May 2011 13:14:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/18] writeback: remove writeback_control.more_io
References: <20110524051411.924582719@intel.com>
Content-Disposition: inline; filename=writeback-kill-more_io.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When wbc.more_io was first introduced, it indicates whether there are
at least one superblock whose s_more_io contains more IO work. Now with
the per-bdi writeback, it can be replaced with a simple b_more_io test.

Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c                |    9 ++-------
 include/linux/writeback.h        |    1 -
 include/trace/events/ext4.h      |    6 ++----
 include/trace/events/writeback.h |    5 +----
 4 files changed, 5 insertions(+), 16 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-24 11:17:22.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-24 11:17:25.000000000 +0800
@@ -560,12 +560,8 @@ static int writeback_sb_inodes(struct su
 		iput(inode);
 		cond_resched();
 		spin_lock(&wb->list_lock);
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
@@ -708,7 +704,6 @@ static long wb_writeback(struct bdi_writ
 			wbc.older_than_this = &oldest_jif;
 		}
 
-		wbc.more_io = 0;
 		wbc.nr_to_write = write_chunk;
 		wbc.pages_skipped = 0;
 		wbc.inodes_cleaned = 0;
@@ -754,7 +749,7 @@ retry:
 		/*
 		 * No more inodes for IO, bail
 		 */
-		if (!wbc.more_io)
+		if (list_empty(&wb->b_more_io))
 			break;
 		/*
 		 * Nothing written. Wait for some inode to
--- linux-next.orig/include/linux/writeback.h	2011-05-24 11:17:22.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-05-24 11:17:25.000000000 +0800
@@ -46,7 +46,6 @@ struct writeback_control {
 	unsigned tagged_writepages:1;	/* tag-and-write to avoid livelock */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
-	unsigned more_io:1;		/* more io to be dispatched */
 };
 
 /*
--- linux-next.orig/include/trace/events/writeback.h	2011-05-24 11:17:12.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-05-24 11:17:25.000000000 +0800
@@ -101,7 +101,6 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__field(int, for_background)
 		__field(int, for_reclaim)
 		__field(int, range_cyclic)
-		__field(int, more_io)
 		__field(unsigned long, older_than_this)
 		__field(long, range_start)
 		__field(long, range_end)
@@ -116,7 +115,6 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__entry->for_background	= wbc->for_background;
 		__entry->for_reclaim	= wbc->for_reclaim;
 		__entry->range_cyclic	= wbc->range_cyclic;
-		__entry->more_io	= wbc->more_io;
 		__entry->older_than_this = wbc->older_than_this ?
 						*wbc->older_than_this : 0;
 		__entry->range_start	= (long)wbc->range_start;
@@ -124,7 +122,7 @@ DECLARE_EVENT_CLASS(wbc_class,
 	),
 
 	TP_printk("bdi %s: towrt=%ld skip=%ld mode=%d kupd=%d "
-		"bgrd=%d reclm=%d cyclic=%d more=%d older=0x%lx "
+		"bgrd=%d reclm=%d cyclic=%d older=0x%lx "
 		"start=0x%lx end=0x%lx",
 		__entry->name,
 		__entry->nr_to_write,
@@ -134,7 +132,6 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__entry->for_background,
 		__entry->for_reclaim,
 		__entry->range_cyclic,
-		__entry->more_io,
 		__entry->older_than_this,
 		__entry->range_start,
 		__entry->range_end)
--- linux-next.orig/include/trace/events/ext4.h	2011-05-24 11:17:12.000000000 +0800
+++ linux-next/include/trace/events/ext4.h	2011-05-24 11:17:25.000000000 +0800
@@ -404,7 +404,6 @@ TRACE_EVENT(ext4_da_writepages_result,
 		__field(	int,	pages_written		)
 		__field(	long,	pages_skipped		)
 		__field(	int,	sync_mode		)
-		__field(	char,	more_io			)	
 		__field(       pgoff_t,	writeback_index		)
 	),
 
@@ -415,16 +414,15 @@ TRACE_EVENT(ext4_da_writepages_result,
 		__entry->pages_written	= pages_written;
 		__entry->pages_skipped	= wbc->pages_skipped;
 		__entry->sync_mode	= wbc->sync_mode;
-		__entry->more_io	= wbc->more_io;
 		__entry->writeback_index = inode->i_mapping->writeback_index;
 	),
 
 	TP_printk("dev %d,%d ino %lu ret %d pages_written %d pages_skipped %ld "
-		  " more_io %d sync_mode %d writeback_index %lu",
+		  "sync_mode %d writeback_index %lu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino, __entry->ret,
 		  __entry->pages_written, __entry->pages_skipped,
-		  __entry->more_io, __entry->sync_mode,
+		  __entry->sync_mode,
 		  (unsigned long) __entry->writeback_index)
 );
 


