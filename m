Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab1D3WsH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 18:48:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:12407 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477Ab1D3WsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 18:48:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,294,1301900400"; 
   d="scan'208";a="428361815"
Message-Id: <20110430224552.227301247@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 01 May 2011 06:36:06 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 1/3] writeback: introduce wbc.for_sync to cover the two sync stages
References: <20110430223605.034517922@intel.com>
Content-Disposition: inline; filename=writeback-for-sync.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sync(2) is performed in two stages: the WB_SYNC_NONE sync and the
WB_SYNC_ALL sync. Tag both stages with wbc.for_sync for livelock
prevention.

Note that writeback_inodes_sb() is called by not only sync(), they
are treated the same because the other callers need also need livelock
prevention.

Impacts:

- it changes the order in which pages/inodes are synced to disk. Now in
  the WB_SYNC_NONE stage, it won't proceed to write the next inode until
  finished with the current inode.

- this adds a new field to the writeback trace events and may possibly
  break some scripts.

CC: Jan Kara <jack@suse.cz>
CC: Dave Chinner <david@fromorbit.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/ext4/inode.c                  |    4 ++--
 fs/fs-writeback.c                |   10 ++++++----
 include/linux/writeback.h        |    1 +
 include/trace/events/writeback.h |   10 ++++++++--
 mm/page-writeback.c              |    4 ++--
 5 files changed, 19 insertions(+), 10 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-01 06:35:15.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-01 06:35:17.000000000 +0800
@@ -36,6 +36,7 @@ struct wb_writeback_work {
 	long nr_pages;
 	struct super_block *sb;
 	enum writeback_sync_modes sync_mode;
+	unsigned int for_sync:1;
 	unsigned int for_kupdate:1;
 	unsigned int range_cyclic:1;
 	unsigned int for_background:1;
@@ -645,13 +646,14 @@ static long wb_writeback(struct bdi_writ
 	struct writeback_control wbc = {
 		.sync_mode		= work->sync_mode,
 		.older_than_this	= NULL,
+		.for_sync		= work->for_sync,
 		.for_kupdate		= work->for_kupdate,
 		.for_background		= work->for_background,
 		.range_cyclic		= work->range_cyclic,
 	};
 	unsigned long oldest_jif;
 	long wrote = 0;
-	long write_chunk;
+	long write_chunk = MAX_WRITEBACK_PAGES;
 	struct inode *inode;
 
 	if (!wbc.range_cyclic) {
@@ -672,9 +674,7 @@ static long wb_writeback(struct bdi_writ
 	 *                   (quickly) tag currently dirty pages
 	 *                   (maybe slowly) sync all tagged pages
 	 */
-	if (wbc.sync_mode == WB_SYNC_NONE)
-		write_chunk = MAX_WRITEBACK_PAGES;
-	else
+	if (wbc.for_sync)
 		write_chunk = LONG_MAX;
 
 	wbc.wb_start = jiffies; /* livelock avoidance */
@@ -1209,6 +1209,7 @@ void writeback_inodes_sb_nr(struct super
 	struct wb_writeback_work work = {
 		.sb		= sb,
 		.sync_mode	= WB_SYNC_NONE,
+		.for_sync	= 1,
 		.done		= &done,
 		.nr_pages	= nr,
 	};
@@ -1286,6 +1287,7 @@ void sync_inodes_sb(struct super_block *
 	struct wb_writeback_work work = {
 		.sb		= sb,
 		.sync_mode	= WB_SYNC_ALL,
+		.for_sync	= 1,
 		.nr_pages	= LONG_MAX,
 		.range_cyclic	= 0,
 		.done		= &done,
--- linux-next.orig/include/linux/writeback.h	2011-05-01 06:35:16.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-05-01 06:35:17.000000000 +0800
@@ -46,6 +46,7 @@ struct writeback_control {
 	unsigned encountered_congestion:1; /* An output: a queue is full */
 	unsigned for_kupdate:1;		/* A kupdate writeback */
 	unsigned for_background:1;	/* A background writeback */
+	unsigned for_sync:1;		/* do livelock prevention for sync */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
--- linux-next.orig/mm/page-writeback.c	2011-05-01 06:35:16.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-05-01 06:35:17.000000000 +0800
@@ -892,12 +892,12 @@ int write_cache_pages(struct address_spa
 			range_whole = 1;
 		cycled = 1; /* ignore range_cyclic tests */
 	}
-	if (wbc->sync_mode == WB_SYNC_ALL)
+	if (wbc->for_sync)
 		tag = PAGECACHE_TAG_TOWRITE;
 	else
 		tag = PAGECACHE_TAG_DIRTY;
 retry:
-	if (wbc->sync_mode == WB_SYNC_ALL)
+	if (wbc->for_sync)
 		tag_pages_for_writeback(mapping, index, end);
 	done_index = index;
 	while (!done && (index <= end)) {
--- linux-next.orig/include/trace/events/writeback.h	2011-05-01 06:35:16.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-05-01 06:35:17.000000000 +0800
@@ -17,6 +17,7 @@ DECLARE_EVENT_CLASS(writeback_work_class
 		__array(char, name, 32)
 		__field(long, nr_pages)
 		__field(dev_t, sb_dev)
+		__field(int, for_sync)
 		__field(int, sync_mode)
 		__field(int, for_kupdate)
 		__field(int, range_cyclic)
@@ -26,16 +27,18 @@ DECLARE_EVENT_CLASS(writeback_work_class
 		strncpy(__entry->name, dev_name(bdi->dev), 32);
 		__entry->nr_pages = work->nr_pages;
 		__entry->sb_dev = work->sb ? work->sb->s_dev : 0;
+		__entry->for_sync = work->for_sync;
 		__entry->sync_mode = work->sync_mode;
 		__entry->for_kupdate = work->for_kupdate;
 		__entry->range_cyclic = work->range_cyclic;
 		__entry->for_background	= work->for_background;
 	),
-	TP_printk("bdi %s: sb_dev %d:%d nr_pages=%ld sync_mode=%d "
+	TP_printk("bdi %s: sb_dev %d:%d nr_pages=%ld sync=%d sync_mode=%d "
 		  "kupdate=%d range_cyclic=%d background=%d",
 		  __entry->name,
 		  MAJOR(__entry->sb_dev), MINOR(__entry->sb_dev),
 		  __entry->nr_pages,
+		  __entry->for_sync,
 		  __entry->sync_mode,
 		  __entry->for_kupdate,
 		  __entry->range_cyclic,
@@ -96,6 +99,7 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__array(char, name, 32)
 		__field(long, nr_to_write)
 		__field(long, pages_skipped)
+		__field(int, for_sync)
 		__field(int, sync_mode)
 		__field(int, for_kupdate)
 		__field(int, for_background)
@@ -111,6 +115,7 @@ DECLARE_EVENT_CLASS(wbc_class,
 		strncpy(__entry->name, dev_name(bdi->dev), 32);
 		__entry->nr_to_write	= wbc->nr_to_write;
 		__entry->pages_skipped	= wbc->pages_skipped;
+		__entry->for_sync	= wbc->for_sync;
 		__entry->sync_mode	= wbc->sync_mode;
 		__entry->for_kupdate	= wbc->for_kupdate;
 		__entry->for_background	= wbc->for_background;
@@ -123,12 +128,13 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__entry->range_end	= (long)wbc->range_end;
 	),
 
-	TP_printk("bdi %s: towrt=%ld skip=%ld mode=%d kupd=%d "
+	TP_printk("bdi %s: towrt=%ld skip=%ld sync=%d mode=%d kupd=%d "
 		"bgrd=%d reclm=%d cyclic=%d more=%d older=0x%lx "
 		"start=0x%lx end=0x%lx",
 		__entry->name,
 		__entry->nr_to_write,
 		__entry->pages_skipped,
+		__entry->for_sync,
 		__entry->sync_mode,
 		__entry->for_kupdate,
 		__entry->for_background,
--- linux-next.orig/fs/ext4/inode.c	2011-05-01 06:35:15.000000000 +0800
+++ linux-next/fs/ext4/inode.c	2011-05-01 06:35:17.000000000 +0800
@@ -2741,7 +2741,7 @@ static int write_cache_pages_da(struct a
 	index = wbc->range_start >> PAGE_CACHE_SHIFT;
 	end = wbc->range_end >> PAGE_CACHE_SHIFT;
 
-	if (wbc->sync_mode == WB_SYNC_ALL)
+	if (wbc->for_sync)
 		tag = PAGECACHE_TAG_TOWRITE;
 	else
 		tag = PAGECACHE_TAG_DIRTY;
@@ -2975,7 +2975,7 @@ static int ext4_da_writepages(struct add
 	}
 
 retry:
-	if (wbc->sync_mode == WB_SYNC_ALL)
+	if (wbc->for_sync)
 		tag_pages_for_writeback(mapping, index, end);
 
 	while (!ret && wbc->nr_to_write > 0) {


