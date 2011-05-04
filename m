Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab1EDPvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:51:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:22703 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab1EDPvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:51:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,314,1301900400"; 
   d="scan'208";a="430434251"
Date: Wed, 4 May 2011 23:51:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/6] writeback: make nr_to_write a per-file limit
Message-ID: <20110504155100.GA29029@localhost>
References: <20110504091707.910929441@intel.com>
 <20110504091909.520602641@intel.com>
 <20110504094221.GA20958@infradead.org>
 <20110504115251.GC5853@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504115251.GC5853@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Then writeback_sb_inodes can do something like
> > 
> > 	if (wbc.sync_mode == WB_SYNC_NONE)
> > 		wbc.nr_to_write = min(MAX_WRITEBACK_PAGES, work->nr_pages);
> 
> I like the min() idea. However it have the side effect of (very possible)
> smallish IO from balance_dirty_pages(), which may call us with small
> ->nr_pages. 
> 
> We may explicitly do "write_chunk = max(MAX_WRITEBACK_PAGES, write_chunk)"
> in balance_dirty_pages() to retain the old behavior.

Sorry I was confused and please ignore the above. At least VFS won't
enlarge the writeback request from balance_dirty_pages()..


Here is the scratch patch. I'll need to double check it tomorrow, but
it's already running fine in the dd+tar+sync test and get pretty good
performance numbers.

        # test-tar-dd.sh
        [...]
        246.62 1941.38
        1000+0 records in
        1000+0 records out
        1048576000 bytes (1.0 GB) copied, 11.4383 s, 91.7 MB/s
        dd if=/dev/zero of=/fs/zero bs=1M count=1000  0.00s user 2.57s system 22% cpu 11.499 total
        tar jxf /dev/shm/linux-2.6.38.3.tar.bz2  12.03s user 4.36s system 56% cpu 28.770 total
        286.04 2204.50
        elapsed: 263.23000000000025

Thanks,
Fengguang
---
Subject: writeback: make writeback_control.nr_to_write straight 
Date: Wed May 04 19:54:37 CST 2011

As suggested by Christoph:

Pass struct wb_writeback_work all the way down to writeback_sb_inodes(),
and initialize the struct writeback_control there.

struct writeback_control is basically designed to control writeback of a
single file, but we keep abuse it for writing multiple files in
writeback_sb_inodes() and its callers.

It immediately clean things up, e.g. suddenly wbc.nr_to_write vs
work->nr_pages starts to make sense, and instead of saving and restoring
pages_skipped in writeback_sb_inodes it can always start with a clean
zero value.

It also makes a neat IO pattern change: large dirty files are now
written in the full 4MB writeback chunk size, rather than whatever
remained quota in wbc->nr_to_write.

change set:
- move writeback_control from wb_writeback() down to writeback_sb_inodes()
- change return value of writeback_sb_inodes()/__writeback_inodes_wb()
  to enum writeback_progress
- move MAX_WRITEBACK_PAGES and wb_writeback_work definitions to writeback.h
- add wb_writeback_work.older_than_this
- remove writeback_control.inodes_cleaned
- remove wbc_writeback_* trace events for now

CC: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |  187 +++++++++++++++---------------------
 include/linux/writeback.h |   29 +++++
 mm/backing-dev.c          |    6 -
 mm/page-writeback.c       |   11 --
 4 files changed, 116 insertions(+), 117 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-04 21:30:32.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-04 23:40:59.000000000 +0800
@@ -30,22 +30,6 @@
 #include "internal.h"
 
 /*
- * Passed into wb_writeback(), essentially a subset of writeback_control
- */
-struct wb_writeback_work {
-	long nr_pages;
-	struct super_block *sb;
-	enum writeback_sync_modes sync_mode;
-	unsigned int tagged_sync:1;
-	unsigned int for_kupdate:1;
-	unsigned int range_cyclic:1;
-	unsigned int for_background:1;
-
-	struct list_head list;		/* pending work list */
-	struct completion *done;	/* set if the caller waits */
-};
-
-/*
  * Include the creation of the trace points after defining the
  * wb_writeback_work structure so that the definition remains local to this
  * file.
@@ -463,7 +447,6 @@ writeback_single_inode(struct inode *ino
 			 * No need to add it back to the LRU.
 			 */
 			list_del_init(&inode->i_wb_list);
-			wbc->inodes_cleaned++;
 		}
 	}
 	inode_sync_complete(inode);
@@ -502,19 +485,53 @@ static bool pin_sb_for_writeback(struct 
  * If @only_this_sb is true, then find and write all such
  * inodes. Otherwise write only ones which go sequentially
  * in reverse order.
- *
- * Return 1, if the caller writeback routine should be
- * interrupted. Otherwise return 0.
  */
-static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
-		struct writeback_control *wbc, bool only_this_sb)
+enum writeback_progress {
+	WROTE_FULL_CHUNK,
+	WROTE_SOME_PAGES,
+	WROTE_SOME_INODES,
+	WROTE_NOTHING,
+};
+
+static int writeback_sb_inodes(struct super_block *sb,
+			       struct bdi_writeback *wb,
+			       struct wb_writeback_work *work)
 {
+	struct writeback_control wbc = {
+		.sync_mode		= work->sync_mode,
+		.tagged_sync		= work->tagged_sync,
+		.older_than_this	= work->older_than_this,
+		.for_kupdate		= work->for_kupdate,
+		.for_background		= work->for_background,
+		.range_cyclic		= work->range_cyclic,
+		.range_start		= 0;
+		.range_end		= LLONG_MAX;
+	};
+	long write_chunk = MAX_WRITEBACK_PAGES;
+	long wrote = 0;
+	bool inode_cleaned = false;
+
+	/*
+	 * WB_SYNC_ALL mode does livelock avoidance by syncing dirty
+	 * inodes/pages in one big loop. Setting wbc.nr_to_write=LONG_MAX
+	 * here avoids calling into writeback_inodes_wb() more than once.
+	 *
+	 * The intended call sequence for WB_SYNC_ALL writeback is:
+	 *
+	 *      wb_writeback()
+	 *          writeback_sb_inodes()       <== called only once
+	 *              write_cache_pages()     <== called once for each inode
+	 *                   (quickly) tag currently dirty pages
+	 *                   (maybe slowly) sync all tagged pages
+	 */
+	if (work->sync_mode == WB_SYNC_ALL || work->tagged_sync)
+		write_chunk = LONG_MAX;
+
 	while (!list_empty(&wb->b_io)) {
-		long pages_skipped;
 		struct inode *inode = wb_inode(wb->b_io.prev);
 
 		if (inode->i_sb != sb) {
-			if (only_this_sb) {
+			if (work->sb) {
 				/*
 				 * We only want to write back data for this
 				 * superblock, move all inodes not belonging
@@ -529,7 +546,7 @@ static int writeback_sb_inodes(struct su
 			 * Bounce back to the caller to unpin this and
 			 * pin the next superblock.
 			 */
-			return 0;
+			break;
 		}
 
 		/*
@@ -543,34 +560,44 @@ static int writeback_sb_inodes(struct su
 			requeue_io(inode, wb);
 			continue;
 		}
-
 		__iget(inode);
+		write_chunk = min(write_chunk, work->nr_pages);
+		wbc.nr_to_write = write_chunk;
+		wbc.pages_skipped = 0;
+
+		writeback_single_inode(inode, wb, &wbc);
 
-		pages_skipped = wbc->pages_skipped;
-		writeback_single_inode(inode, wb, wbc);
-		if (wbc->pages_skipped != pages_skipped) {
+		work->nr_pages -= write_chunk - wbc.nr_to_write;
+		wrote += write_chunk - wbc.nr_to_write;
+		if (wbc.pages_skipped) {
 			/*
 			 * writeback is not making progress due to locked
 			 * buffers.  Skip this inode for now.
 			 */
 			redirty_tail(inode, wb);
-		}
+		} else if (!(inode->i_state & I_DIRTY))
+			inode_cleaned = true;
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&wb->list_lock);
 		iput(inode);
 		cond_resched();
 		spin_lock(&wb->list_lock);
-		if (wbc->nr_to_write <= 0)
-			return 1;
+		if (wrote >= MAX_WRITEBACK_PAGES)
+			return WROTE_FULL_CHUNK;
+		if (work->nr_pages <= 0)
+			return WROTE_FULL_CHUNK;
 	}
-	/* b_io is empty */
-	return 1;
+	if (wrote)
+		return WROTE_SOME_PAGES;
+	if (inode_cleaned)
+		return WROTE_SOME_INODES;
+	return WROTE_NOTHING;
 }
 
-static void __writeback_inodes_wb(struct bdi_writeback *wb,
-				  struct writeback_control *wbc)
+static int __writeback_inodes_wb(struct bdi_writeback *wb,
+				 struct wb_writeback_work *work)
 {
-	int ret = 0;
+	int ret = WROTE_NOTHING;
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = wb_inode(wb->b_io.prev);
@@ -580,34 +607,26 @@ static void __writeback_inodes_wb(struct
 			requeue_io(inode, wb);
 			continue;
 		}
-		ret = writeback_sb_inodes(sb, wb, wbc, false);
+		ret = writeback_sb_inodes(sb, wb, work);
 		drop_super(sb);
 
-		if (ret)
+		if (ret == WROTE_FULL_CHUNK)
 			break;
 	}
 	/* Leave any unwritten inodes on b_io */
+	return ret;
 }
 
 void writeback_inodes_wb(struct bdi_writeback *wb,
-		struct writeback_control *wbc)
+			 struct wb_writeback_work *work)
 {
 	spin_lock(&wb->list_lock);
 	if (list_empty(&wb->b_io))
-		queue_io(wb, wbc->older_than_this);
-	__writeback_inodes_wb(wb, wbc);
+		queue_io(wb, work->older_than_this);
+	__writeback_inodes_wb(wb, work);
 	spin_unlock(&wb->list_lock);
 }
 
-/*
- * The maximum number of pages to writeout in a single bdi flush/kupdate
- * operation.  We do this so we don't hold I_SYNC against an inode for
- * enormous amounts of time, which would block a userspace task which has
- * been forced to throttle against that inode.  Also, the code reevaluates
- * the dirty each time it has written this many pages.
- */
-#define MAX_WRITEBACK_PAGES     1024
-
 static inline bool over_bground_thresh(void)
 {
 	unsigned long background_thresh, dirty_thresh;
@@ -636,42 +655,12 @@ static inline bool over_bground_thresh(v
 static long wb_writeback(struct bdi_writeback *wb,
 			 struct wb_writeback_work *work)
 {
-	struct writeback_control wbc = {
-		.sync_mode		= work->sync_mode,
-		.tagged_sync		= work->tagged_sync,
-		.older_than_this	= NULL,
-		.for_kupdate		= work->for_kupdate,
-		.for_background		= work->for_background,
-		.range_cyclic		= work->range_cyclic,
-	};
-	unsigned long oldest_jif;
-	long wrote = 0;
-	long write_chunk = MAX_WRITEBACK_PAGES;
+	long nr_pages = work->nr_pages;
+	unsigned long oldest_jif = jiffies;
 	struct inode *inode;
+	int progress;
 
-	if (!wbc.range_cyclic) {
-		wbc.range_start = 0;
-		wbc.range_end = LLONG_MAX;
-	}
-
-	/*
-	 * WB_SYNC_ALL mode does livelock avoidance by syncing dirty
-	 * inodes/pages in one big loop. Setting wbc.nr_to_write=LONG_MAX
-	 * here avoids calling into writeback_inodes_wb() more than once.
-	 *
-	 * The intended call sequence for WB_SYNC_ALL writeback is:
-	 *
-	 *      wb_writeback()
-	 *          writeback_sb_inodes()       <== called only once
-	 *              write_cache_pages()     <== called once for each inode
-	 *                   (quickly) tag currently dirty pages
-	 *                   (maybe slowly) sync all tagged pages
-	 */
-	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_sync) {
-		write_chunk = LONG_MAX;
-		oldest_jif = jiffies;
-		wbc.older_than_this = &oldest_jif;
-	}
+	work->older_than_this = &oldest_jif;
 
 	for (;;) {
 		/*
@@ -700,27 +689,18 @@ static long wb_writeback(struct bdi_writ
 		if (work->for_kupdate || work->for_background) {
 			oldest_jif = jiffies -
 				msecs_to_jiffies(dirty_expire_interval * 10);
-			wbc.older_than_this = &oldest_jif;
+			work->older_than_this = &oldest_jif;
 		}
 
-		wbc.nr_to_write = write_chunk;
-		wbc.pages_skipped = 0;
-		wbc.inodes_cleaned = 0;
-
 retry:
-		trace_wbc_writeback_start(&wbc, wb->bdi);
 		spin_lock(&wb->list_lock);
 		if (list_empty(&wb->b_io))
-			queue_io(wb, wbc->older_than_this);
+			queue_io(wb, work->older_than_this);
 		if (work->sb)
-			writeback_sb_inodes(work->sb, wb, &wbc, true);
+			progress = writeback_sb_inodes(work->sb, wb, work);
 		else
-			__writeback_inodes_wb(wb, &wbc);
+			progress = __writeback_inodes_wb(wb, work);
 		spin_unlock(&wb->list_lock);
-		trace_wbc_writeback_written(&wbc, wb->bdi);
-
-		work->nr_pages -= write_chunk - wbc.nr_to_write;
-		wrote += write_chunk - wbc.nr_to_write;
 
 		/*
 		 * Did we write something? Try for more
@@ -730,9 +710,7 @@ retry:
 		 * mean the overall work is done. So we keep looping as long
 		 * as made some progress on cleaning pages or inodes.
 		 */
-		if (wbc.nr_to_write < write_chunk)
-			continue;
-		if (wbc.inodes_cleaned)
+		if (progress != WROTE_NOTHING)
 			continue;
 		/*
 		 * background writeback will start with expired inodes, and
@@ -741,10 +719,10 @@ retry:
 		 * lists and cause trouble to the page reclaim.
 		 */
 		if (work->for_background &&
-		    wbc.older_than_this &&
+		    work->older_than_this &&
 		    list_empty(&wb->b_io) &&
 		    list_empty(&wb->b_more_io)) {
-			wbc.older_than_this = NULL;
+			work->older_than_this = NULL;
 			goto retry;
 		}
 		/*
@@ -760,7 +738,6 @@ retry:
 		spin_lock(&wb->list_lock);
 		if (!list_empty(&wb->b_more_io))  {
 			inode = wb_inode(wb->b_more_io.prev);
-			trace_wbc_writeback_wait(&wbc, wb->bdi);
 			spin_lock(&inode->i_lock);
 			inode_wait_for_writeback(inode, wb);
 			spin_unlock(&inode->i_lock);
@@ -768,7 +745,7 @@ retry:
 		spin_unlock(&wb->list_lock);
 	}
 
-	return wrote;
+	return nr_pages - work->nr_pages;
 }
 
 /*
--- linux-next.orig/mm/backing-dev.c	2011-05-04 21:30:22.000000000 +0800
+++ linux-next/mm/backing-dev.c	2011-05-04 21:49:07.000000000 +0800
@@ -262,14 +262,14 @@ int bdi_has_dirty_io(struct backing_dev_
 
 static void bdi_flush_io(struct backing_dev_info *bdi)
 {
-	struct writeback_control wbc = {
+	struct wb_writeback_work work = {
 		.sync_mode		= WB_SYNC_NONE,
 		.older_than_this	= NULL,
 		.range_cyclic		= 1,
-		.nr_to_write		= 1024,
+		.nr_pages		= 1024,
 	};
 
-	writeback_inodes_wb(&bdi->wb, &wbc);
+	writeback_inodes_wb(&bdi->wb, &work);
 }
 
 /*
--- linux-next.orig/mm/page-writeback.c	2011-05-04 21:30:22.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-05-04 21:57:25.000000000 +0800
@@ -494,10 +494,10 @@ static void balance_dirty_pages(struct a
 		return;
 
 	for (;;) {
-		struct writeback_control wbc = {
+		struct wb_writeback_work work = {
 			.sync_mode	= WB_SYNC_NONE,
 			.older_than_this = NULL,
-			.nr_to_write	= write_chunk,
+			.nr_pages	= write_chunk,
 			.range_cyclic	= 1,
 		};
 
@@ -562,15 +562,12 @@ static void balance_dirty_pages(struct a
 		 * threshold otherwise wait until the disk writes catch
 		 * up.
 		 */
-		trace_wbc_balance_dirty_start(&wbc, bdi);
 		if (bdi_nr_reclaimable > bdi_thresh) {
-			writeback_inodes_wb(&bdi->wb, &wbc);
-			pages_written += write_chunk - wbc.nr_to_write;
-			trace_wbc_balance_dirty_written(&wbc, bdi);
+			writeback_inodes_wb(&bdi->wb, &work);
+			pages_written += write_chunk - work.nr_pages;
 			if (pages_written >= write_chunk)
 				break;		/* We've done our duty */
 		}
-		trace_wbc_balance_dirty_wait(&wbc, bdi);
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 		io_schedule_timeout(pause);
 
--- linux-next.orig/include/linux/writeback.h	2011-05-04 21:30:41.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-05-04 21:43:04.000000000 +0800
@@ -7,6 +7,15 @@
 #include <linux/sched.h>
 #include <linux/fs.h>
 
+/*
+ * The maximum number of pages to writeout in a single bdi flush/kupdate
+ * operation.  We do this so we don't hold I_SYNC against an inode for
+ * enormous amounts of time, which would block a userspace task which has
+ * been forced to throttle against that inode.  Also, the code reevaluates
+ * the dirty each time it has written this many pages.
+ */
+#define MAX_WRITEBACK_PAGES     1024
+
 struct backing_dev_info;
 
 /*
@@ -29,7 +38,6 @@ struct writeback_control {
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */
-	long inodes_cleaned;		/* # of inodes cleaned */
 
 	/*
 	 * For a_ops->writepages(): is start or end are non-zero then this is
@@ -49,6 +57,23 @@ struct writeback_control {
 };
 
 /*
+ * Passed into wb_writeback(), essentially a subset of writeback_control
+ */
+struct wb_writeback_work {
+	long nr_pages;
+	struct super_block *sb;
+	enum writeback_sync_modes sync_mode;
+	unsigned long *older_than_this;
+	unsigned int tagged_sync:1;
+	unsigned int for_kupdate:1;
+	unsigned int range_cyclic:1;
+	unsigned int for_background:1;
+
+	struct list_head list;		/* pending work list */
+	struct completion *done;	/* set if the caller waits */
+};
+
+/*
  * fs/fs-writeback.c
  */	
 struct bdi_writeback;
@@ -59,7 +84,7 @@ int writeback_inodes_sb_if_idle(struct s
 int writeback_inodes_sb_nr_if_idle(struct super_block *, unsigned long nr);
 void sync_inodes_sb(struct super_block *);
 void writeback_inodes_wb(struct bdi_writeback *wb,
-		struct writeback_control *wbc);
+		struct wb_writeback_work *work);
 long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
 void wakeup_flusher_threads(long nr_pages);
 
