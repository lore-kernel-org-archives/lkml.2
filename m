Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab1EEKrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 06:47:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:8226 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab1EEKrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 06:47:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,318,1301900400"; 
   d="scan'208";a="430984898"
Date: Thu, 5 May 2011 18:47:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/6] writeback: make nr_to_write a per-file limit
Message-ID: <20110505104716.GA31313@localhost>
References: <20110504091707.910929441@intel.com>
 <20110504091909.520602641@intel.com>
 <20110504094221.GA20958@infradead.org>
 <20110504115251.GC5853@localhost>
 <20110504155100.GA29029@localhost>
 <20110504161816.GA8147@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504161816.GA8147@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 12:18:16AM +0800, Christoph Hellwig wrote:
> > - move MAX_WRITEBACK_PAGES and wb_writeback_work definitions to writeback.h
> 
> I think it would be a good idea to keep this in fs/fs-writeback.c, which
> means we'd need a small writeback_inodes_wb wrapper for
> balance_dirty_pages and bdi_flush_io.  But IIRC your tree already has
> __writeback_inodes_wb for use in wb_writeback, so writeback_inodes_wb
> could be that wrapper.

No problem. We can later move bdi_flush_io() to fs-writeback.c and
kill the wbc=>work=>wbc double conversions once balance_dirty_pages()
switches to IO-less.

> > +	long write_chunk = MAX_WRITEBACK_PAGES;
> > +	long wrote = 0;
> > +	bool inode_cleaned = false;
> > +
> > +	/*
> > +	 * WB_SYNC_ALL mode does livelock avoidance by syncing dirty
> > +	 * inodes/pages in one big loop. Setting wbc.nr_to_write=LONG_MAX
> > +	 * here avoids calling into writeback_inodes_wb() more than once.
> > +	 *
> > +	 * The intended call sequence for WB_SYNC_ALL writeback is:
> > +	 *
> > +	 *      wb_writeback()
> > +	 *          writeback_sb_inodes()       <== called only once
> > +	 *              write_cache_pages()     <== called once for each inode
> > +	 *                   (quickly) tag currently dirty pages
> > +	 *                   (maybe slowly) sync all tagged pages
> > +	 */
> > +	if (work->sync_mode == WB_SYNC_ALL || work->tagged_sync)
> > +		write_chunk = LONG_MAX;
> 
> I think this would be easier to read if kept as and if / else clause
> with the MAX_WRITEBACK_PAGES usage.
> 
> > +		write_chunk = min(write_chunk, work->nr_pages);
> 
> Or in fact done here - for the WB_SYNC_ALL case LONG_MAX should
> always be larger than work->nr_pages, so the whole thing could be
> simplified to:
> 
> 		if (work->sync_mode == WB_SYNC_ALL || work->tagged_sync)
> 			write_chunk = LONG_MAX;
> 		else
> 			write_chunk = min(MAX_WRITEBACK_PAGES, work->nr_pages);

OK, I created a standalone function writeback_chunk_size() for that.
Otherwise the comment block will look very weird deep inside the
function and deeply indented.

> 
> Other notes:
> 
>  - older_than_this in writeback_control shouldn't be needed anymore

Yes. Good catch!

>  - is the early return for the mis-matching sb in writeback_sb_inodes
>    handled correctly?  Before it had the special 0 return value, and
>    I'm not quite sure how that fits into your new enum scheme.

Good question. This is the tricky point of the patch.

The original 0/1 return values are to tell __writeback_inodes_wb()
whether it's done with the current batch. Now __writeback_inodes_wb()
will do the test on itself (the below v2 patch).

The v1 patch does have some tricky problem regarding the early return:
if there are two super blocks that return WROTE_SOME_PAGES and
WROTE_NOTHING in turn, __writeback_inodes_wb() will wrongly pick up
the latter as the final return value.

I updated the patch to accumulate the number of pages/inodes cleaned
over multiple writeback_sb_inodes() invocations inside
__writeback_inodes_wb(). This way it can reliably return to
wb_writeback() to check various terminate conditions when made enough
progress.

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
  to the number of pages and/or inodes written
- move writeback_control.older_than_this to struct wb_writeback_work
- remove writeback_control.inodes_cleaned
- remove wbc_writeback_* trace events for now

CC: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/btrfs/extent_io.c             |    2 
 fs/fs-writeback.c                |  184 +++++++++++++++--------------
 include/linux/writeback.h        |    3 
 include/trace/events/writeback.h |    6 
 mm/backing-dev.c                 |    1 
 mm/page-writeback.c              |    1 
 6 files changed, 99 insertions(+), 98 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-05 18:24:21.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-05 18:24:53.000000000 +0800
@@ -30,11 +30,21 @@
 #include "internal.h"
 
 /*
+ * The maximum number of pages to writeout in a single bdi flush/kupdate
+ * operation.  We do this so we don't hold I_SYNC against an inode for
+ * enormous amounts of time, which would block a userspace task which has
+ * been forced to throttle against that inode.  Also, the code reevaluates
+ * the dirty each time it has written this many pages.
+ */
+#define MAX_WRITEBACK_PAGES     1024L
+
+/*
  * Passed into wb_writeback(), essentially a subset of writeback_control
  */
 struct wb_writeback_work {
 	long nr_pages;
 	struct super_block *sb;
+	unsigned long *older_than_this;
 	enum writeback_sync_modes sync_mode;
 	unsigned int tagged_sync:1;
 	unsigned int for_kupdate:1;
@@ -463,7 +473,6 @@ writeback_single_inode(struct inode *ino
 			 * No need to add it back to the LRU.
 			 */
 			list_del_init(&inode->i_wb_list);
-			wbc->inodes_cleaned++;
 		}
 	}
 	inode_sync_complete(inode);
@@ -496,6 +505,31 @@ static bool pin_sb_for_writeback(struct 
 	return false;
 }
 
+static long writeback_chunk_size(struct wb_writeback_work *work)
+{
+	long pages;
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
+		pages = LONG_MAX;
+	else
+		pages = min(MAX_WRITEBACK_PAGES, work->nr_pages);
+
+	return pages;
+}
+
 /*
  * Write a portion of b_io inodes which belong to @sb.
  *
@@ -503,18 +537,29 @@ static bool pin_sb_for_writeback(struct 
  * inodes. Otherwise write only ones which go sequentially
  * in reverse order.
  *
- * Return 1, if the caller writeback routine should be
- * interrupted. Otherwise return 0.
+ * Return the number of pages and/or inodes cleaned.
  */
-static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
-		struct writeback_control *wbc, bool only_this_sb)
+static long writeback_sb_inodes(struct super_block *sb,
+				struct bdi_writeback *wb,
+				struct wb_writeback_work *work)
 {
+	struct writeback_control wbc = {
+		.sync_mode		= work->sync_mode,
+		.tagged_sync		= work->tagged_sync,
+		.for_kupdate		= work->for_kupdate,
+		.for_background		= work->for_background,
+		.range_cyclic		= work->range_cyclic,
+		.range_start		= 0,
+		.range_end		= LLONG_MAX,
+	};
+	long write_chunk;
+	long wrote = 0;  /* count both pages and inodes */
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
@@ -529,7 +574,7 @@ static int writeback_sb_inodes(struct su
 			 * Bounce back to the caller to unpin this and
 			 * pin the next superblock.
 			 */
-			return 0;
+			break;
 		}
 
 		/*
@@ -543,34 +588,40 @@ static int writeback_sb_inodes(struct su
 			requeue_io(inode, wb);
 			continue;
 		}
-
 		__iget(inode);
+		write_chunk = writeback_chunk_size(work);
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
+			wrote++;
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&wb->list_lock);
 		iput(inode);
 		cond_resched();
 		spin_lock(&wb->list_lock);
-		if (wbc->nr_to_write <= 0)
-			return 1;
+		if (wrote >= MAX_WRITEBACK_PAGES)
+			break;
+		if (work->nr_pages <= 0)
+			break;
 	}
-	/* b_io is empty */
-	return 1;
+	return wrote;
 }
 
-static void __writeback_inodes_wb(struct bdi_writeback *wb,
-				  struct writeback_control *wbc)
+static long __writeback_inodes_wb(struct bdi_writeback *wb,
+				  struct wb_writeback_work *work)
 {
-	int ret = 0;
+	long wrote = 0;
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = wb_inode(wb->b_io.prev);
@@ -580,33 +631,35 @@ static void __writeback_inodes_wb(struct
 			requeue_io(inode, wb);
 			continue;
 		}
-		ret = writeback_sb_inodes(sb, wb, wbc, false);
+		wrote += writeback_sb_inodes(sb, wb, work);
 		drop_super(sb);
 
-		if (ret)
+		if (wrote >= MAX_WRITEBACK_PAGES)
+			break;
+		if (work->nr_pages <= 0)
 			break;
 	}
 	/* Leave any unwritten inodes on b_io */
+	return wrote;
 }
 
 void writeback_inodes_wb(struct bdi_writeback *wb,
-		struct writeback_control *wbc)
+			 struct writeback_control *wbc)
 {
+	struct wb_writeback_work work = {
+		.nr_pages	= wbc->nr_to_write,
+		.sync_mode	= wbc->sync_mode,
+		.range_cyclic	= wbc->range_cyclic,
+	};
+
 	spin_lock(&wb->list_lock);
 	if (list_empty(&wb->b_io))
-		queue_io(wb, wbc->older_than_this);
-	__writeback_inodes_wb(wb, wbc);
+		queue_io(wb, NULL);
+	__writeback_inodes_wb(wb, &work);
 	spin_unlock(&wb->list_lock);
-}
 
-/*
- * The maximum number of pages to writeout in a single bdi flush/kupdate
- * operation.  We do this so we don't hold I_SYNC against an inode for
- * enormous amounts of time, which would block a userspace task which has
- * been forced to throttle against that inode.  Also, the code reevaluates
- * the dirty each time it has written this many pages.
- */
-#define MAX_WRITEBACK_PAGES     1024
+	wbc->nr_to_write = work.nr_pages;
+}
 
 static inline bool over_bground_thresh(void)
 {
@@ -636,42 +689,13 @@ static inline bool over_bground_thresh(v
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
+	long nr_pages = work->nr_pages;
 	unsigned long oldest_jif;
-	long wrote = 0;
-	long write_chunk = MAX_WRITEBACK_PAGES;
 	struct inode *inode;
-
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
-	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_sync)
-		write_chunk = LONG_MAX;
+	long progress;
 
 	oldest_jif = jiffies;
-	wbc.older_than_this = &oldest_jif;
+	work->older_than_this = &oldest_jif;
 
 	for (;;) {
 		/*
@@ -700,27 +724,18 @@ static long wb_writeback(struct bdi_writ
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
@@ -730,9 +745,7 @@ retry:
 		 * mean the overall work is done. So we keep looping as long
 		 * as made some progress on cleaning pages or inodes.
 		 */
-		if (wbc.nr_to_write < write_chunk)
-			continue;
-		if (wbc.inodes_cleaned)
+		if (progress)
 			continue;
 		/*
 		 * background writeback will start with expired inodes, and
@@ -741,10 +754,10 @@ retry:
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
@@ -760,7 +773,6 @@ retry:
 		spin_lock(&wb->list_lock);
 		if (!list_empty(&wb->b_more_io))  {
 			inode = wb_inode(wb->b_more_io.prev);
-			trace_wbc_writeback_wait(&wbc, wb->bdi);
 			spin_lock(&inode->i_lock);
 			inode_wait_for_writeback(inode, wb);
 			spin_unlock(&inode->i_lock);
@@ -768,7 +780,7 @@ retry:
 		spin_unlock(&wb->list_lock);
 	}
 
-	return wrote;
+	return nr_pages - work->nr_pages;
 }
 
 /*
--- linux-next.orig/include/linux/writeback.h	2011-05-05 18:24:21.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-05-05 18:24:53.000000000 +0800
@@ -24,12 +24,9 @@ enum writeback_sync_modes {
  */
 struct writeback_control {
 	enum writeback_sync_modes sync_mode;
-	unsigned long *older_than_this;	/* If !NULL, only write back inodes
-					   older than this */
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */
-	long inodes_cleaned;		/* # of inodes cleaned */
 
 	/*
 	 * For a_ops->writepages(): is start or end are non-zero then this is
--- linux-next.orig/mm/backing-dev.c	2011-05-05 18:24:21.000000000 +0800
+++ linux-next/mm/backing-dev.c	2011-05-05 18:24:53.000000000 +0800
@@ -264,7 +264,6 @@ static void bdi_flush_io(struct backing_
 {
 	struct writeback_control wbc = {
 		.sync_mode		= WB_SYNC_NONE,
-		.older_than_this	= NULL,
 		.range_cyclic		= 1,
 		.nr_to_write		= 1024,
 	};
--- linux-next.orig/mm/page-writeback.c	2011-05-05 18:24:21.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-05-05 18:24:53.000000000 +0800
@@ -496,7 +496,6 @@ static void balance_dirty_pages(struct a
 	for (;;) {
 		struct writeback_control wbc = {
 			.sync_mode	= WB_SYNC_NONE,
-			.older_than_this = NULL,
 			.nr_to_write	= write_chunk,
 			.range_cyclic	= 1,
 		};
--- linux-next.orig/include/trace/events/writeback.h	2011-05-05 18:24:21.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-05-05 18:24:53.000000000 +0800
@@ -101,7 +101,6 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__field(int, for_background)
 		__field(int, for_reclaim)
 		__field(int, range_cyclic)
-		__field(unsigned long, older_than_this)
 		__field(long, range_start)
 		__field(long, range_end)
 	),
@@ -115,14 +114,12 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__entry->for_background	= wbc->for_background;
 		__entry->for_reclaim	= wbc->for_reclaim;
 		__entry->range_cyclic	= wbc->range_cyclic;
-		__entry->older_than_this = wbc->older_than_this ?
-						*wbc->older_than_this : 0;
 		__entry->range_start	= (long)wbc->range_start;
 		__entry->range_end	= (long)wbc->range_end;
 	),
 
 	TP_printk("bdi %s: towrt=%ld skip=%ld mode=%d kupd=%d "
-		"bgrd=%d reclm=%d cyclic=%d older=0x%lx "
+		"bgrd=%d reclm=%d cyclic=%d "
 		"start=0x%lx end=0x%lx",
 		__entry->name,
 		__entry->nr_to_write,
@@ -132,7 +129,6 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__entry->for_background,
 		__entry->for_reclaim,
 		__entry->range_cyclic,
-		__entry->older_than_this,
 		__entry->range_start,
 		__entry->range_end)
 )
--- linux-next.orig/fs/btrfs/extent_io.c	2011-05-05 18:24:21.000000000 +0800
+++ linux-next/fs/btrfs/extent_io.c	2011-05-05 18:24:53.000000000 +0800
@@ -2587,7 +2587,6 @@ int extent_write_full_page(struct extent
 	};
 	struct writeback_control wbc_writepages = {
 		.sync_mode	= wbc->sync_mode,
-		.older_than_this = NULL,
 		.nr_to_write	= 64,
 		.range_start	= page_offset(page) + PAGE_CACHE_SIZE,
 		.range_end	= (loff_t)-1,
@@ -2620,7 +2619,6 @@ int extent_write_locked_range(struct ext
 	};
 	struct writeback_control wbc_writepages = {
 		.sync_mode	= mode,
-		.older_than_this = NULL,
 		.nr_to_write	= nr_pages * 2,
 		.range_start	= start,
 		.range_end	= end + 1,
