Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1ELO4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:56:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab1ELO4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:56:52 -0400
Date: Thu, 12 May 2011 16:56:47 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/17] writeback: make writeback_control.nr_to_write
 straight
Message-ID: <20110512145647.GC4690@quack.suse.cz>
References: <20110512135706.937596128@intel.com>
 <20110512140032.418803138@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512140032.418803138@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 12-05-11 21:57:20, Wu Fengguang wrote:
> Pass struct wb_writeback_work all the way down to writeback_sb_inodes(),
> and initialize the struct writeback_control there.
> 
> struct writeback_control is basically designed to control writeback of a
> single file, but we keep abuse it for writing multiple files in
> writeback_sb_inodes() and its callers.
> 
> It immediately clean things up, e.g. suddenly wbc.nr_to_write vs
> work->nr_pages starts to make sense, and instead of saving and restoring
> pages_skipped in writeback_sb_inodes it can always start with a clean
> zero value.
> 
> It also makes a neat IO pattern change: large dirty files are now
> written in the full 4MB writeback chunk size, rather than whatever
> remained quota in wbc->nr_to_write.
> 
> Proposed-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
  Acked-by: Jan Kara <jack@suse.cz>

									Honza
> ---
>  fs/btrfs/extent_io.c             |    2 
>  fs/fs-writeback.c                |  192 +++++++++++++++--------------
>  include/linux/writeback.h        |    6 
>  include/trace/events/writeback.h |   39 ++++-
>  mm/backing-dev.c                 |    9 -
>  mm/page-writeback.c              |   17 --
>  6 files changed, 140 insertions(+), 125 deletions(-)
> 
> change set:
> - move writeback_control from wb_writeback() down to writeback_sb_inodes()
> - change return value of writeback_sb_inodes()/__writeback_inodes_wb()
>   to the number of pages and/or inodes written
> - move writeback_control.older_than_this to struct wb_writeback_work
> - remove writeback_control.inodes_cleaned
> - remove wbc_writeback_* trace events for now
> 
> --- linux-next.orig/fs/fs-writeback.c	2011-05-11 22:37:15.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2011-05-12 11:46:27.000000000 +0800
> @@ -30,11 +30,21 @@
>  #include "internal.h"
>  
>  /*
> + * The maximum number of pages to writeout in a single bdi flush/kupdate
> + * operation.  We do this so we don't hold I_SYNC against an inode for
> + * enormous amounts of time, which would block a userspace task which has
> + * been forced to throttle against that inode.  Also, the code reevaluates
> + * the dirty each time it has written this many pages.
> + */
> +#define MAX_WRITEBACK_PAGES     1024L
> +
> +/*
>   * Passed into wb_writeback(), essentially a subset of writeback_control
>   */
>  struct wb_writeback_work {
>  	long nr_pages;
>  	struct super_block *sb;
> +	unsigned long *older_than_this;
>  	enum writeback_sync_modes sync_mode;
>  	unsigned int tagged_sync:1;
>  	unsigned int for_kupdate:1;
> @@ -463,7 +473,6 @@ writeback_single_inode(struct inode *ino
>  			 * No need to add it back to the LRU.
>  			 */
>  			list_del_init(&inode->i_wb_list);
> -			wbc->inodes_cleaned++;
>  		}
>  	}
>  	inode_sync_complete(inode);
> @@ -496,6 +505,31 @@ static bool pin_sb_for_writeback(struct 
>  	return false;
>  }
>  
> +static long writeback_chunk_size(struct wb_writeback_work *work)
> +{
> +	long pages;
> +
> +	/*
> +	 * WB_SYNC_ALL mode does livelock avoidance by syncing dirty
> +	 * inodes/pages in one big loop. Setting wbc.nr_to_write=LONG_MAX
> +	 * here avoids calling into writeback_inodes_wb() more than once.
> +	 *
> +	 * The intended call sequence for WB_SYNC_ALL writeback is:
> +	 *
> +	 *      wb_writeback()
> +	 *          writeback_sb_inodes()       <== called only once
> +	 *              write_cache_pages()     <== called once for each inode
> +	 *                   (quickly) tag currently dirty pages
> +	 *                   (maybe slowly) sync all tagged pages
> +	 */
> +	if (work->sync_mode == WB_SYNC_ALL || work->tagged_sync)
> +		pages = LONG_MAX;
> +	else
> +		pages = min(MAX_WRITEBACK_PAGES, work->nr_pages);
> +
> +	return pages;
> +}
> +
>  /*
>   * Write a portion of b_io inodes which belong to @sb.
>   *
> @@ -503,18 +537,29 @@ static bool pin_sb_for_writeback(struct 
>   * inodes. Otherwise write only ones which go sequentially
>   * in reverse order.
>   *
> - * Return 1, if the caller writeback routine should be
> - * interrupted. Otherwise return 0.
> + * Return the number of pages and/or inodes cleaned.
>   */
> -static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
> -		struct writeback_control *wbc, bool only_this_sb)
> +static long writeback_sb_inodes(struct super_block *sb,
> +				struct bdi_writeback *wb,
> +				struct wb_writeback_work *work)
>  {
> +	struct writeback_control wbc = {
> +		.sync_mode		= work->sync_mode,
> +		.tagged_sync		= work->tagged_sync,
> +		.for_kupdate		= work->for_kupdate,
> +		.for_background		= work->for_background,
> +		.range_cyclic		= work->range_cyclic,
> +		.range_start		= 0,
> +		.range_end		= LLONG_MAX,
> +	};
> +	long write_chunk;
> +	long wrote = 0;  /* count both pages and inodes */
> +
>  	while (!list_empty(&wb->b_io)) {
> -		long pages_skipped;
>  		struct inode *inode = wb_inode(wb->b_io.prev);
>  
>  		if (inode->i_sb != sb) {
> -			if (only_this_sb) {
> +			if (work->sb) {
>  				/*
>  				 * We only want to write back data for this
>  				 * superblock, move all inodes not belonging
> @@ -529,7 +574,7 @@ static int writeback_sb_inodes(struct su
>  			 * Bounce back to the caller to unpin this and
>  			 * pin the next superblock.
>  			 */
> -			return 0;
> +			break;
>  		}
>  
>  		/*
> @@ -543,34 +588,44 @@ static int writeback_sb_inodes(struct su
>  			requeue_io(inode, wb);
>  			continue;
>  		}
> -
>  		__iget(inode);
> +		write_chunk = writeback_chunk_size(work);
> +		wbc.nr_to_write = write_chunk;
> +		wbc.pages_skipped = 0;
> +
> +		writeback_single_inode(inode, wb, &wbc);
>  
> -		pages_skipped = wbc->pages_skipped;
> -		writeback_single_inode(inode, wb, wbc);
> -		if (wbc->pages_skipped != pages_skipped) {
> +		work->nr_pages -= write_chunk - wbc.nr_to_write;
> +		wrote += write_chunk - wbc.nr_to_write;
> +		if (wbc.pages_skipped) {
>  			/*
>  			 * writeback is not making progress due to locked
>  			 * buffers.  Skip this inode for now.
>  			 */
>  			redirty_tail(inode, wb);
> -		}
> +		} else if (!(inode->i_state & I_DIRTY))
> +			wrote++;
>  		spin_unlock(&inode->i_lock);
>  		spin_unlock(&wb->list_lock);
>  		iput(inode);
>  		cond_resched();
>  		spin_lock(&wb->list_lock);
> -		if (wbc->nr_to_write <= 0)
> -			return 1;
> +		/*
> +		 * bail out to wb_writeback() often enough to check
> +		 * background threshold and other termination conditions.
> +		 */
> +		if (wrote >= MAX_WRITEBACK_PAGES)
> +			break;
> +		if (work->nr_pages <= 0)
> +			break;
>  	}
> -	/* b_io is empty */
> -	return 1;
> +	return wrote;
>  }
>  
> -static void __writeback_inodes_wb(struct bdi_writeback *wb,
> -				  struct writeback_control *wbc)
> +static long __writeback_inodes_wb(struct bdi_writeback *wb,
> +				  struct wb_writeback_work *work)
>  {
> -	int ret = 0;
> +	long wrote = 0;
>  
>  	while (!list_empty(&wb->b_io)) {
>  		struct inode *inode = wb_inode(wb->b_io.prev);
> @@ -580,33 +635,34 @@ static void __writeback_inodes_wb(struct
>  			requeue_io(inode, wb);
>  			continue;
>  		}
> -		ret = writeback_sb_inodes(sb, wb, wbc, false);
> +		wrote += writeback_sb_inodes(sb, wb, work);
>  		drop_super(sb);
>  
> -		if (ret)
> +		if (wrote >= MAX_WRITEBACK_PAGES)
> +			break;
> +		if (work->nr_pages <= 0)
>  			break;
>  	}
>  	/* Leave any unwritten inodes on b_io */
> +	return wrote;
>  }
>  
> -void writeback_inodes_wb(struct bdi_writeback *wb,
> -		struct writeback_control *wbc)
> +long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages)
>  {
> +	struct wb_writeback_work work = {
> +		.nr_pages	= nr_pages,
> +		.sync_mode	= WB_SYNC_NONE,
> +		.range_cyclic	= 1,
> +	};
> +
>  	spin_lock(&wb->list_lock);
>  	if (list_empty(&wb->b_io))
> -		queue_io(wb, wbc->older_than_this);
> -	__writeback_inodes_wb(wb, wbc);
> +		queue_io(wb, NULL);
> +	__writeback_inodes_wb(wb, &work);
>  	spin_unlock(&wb->list_lock);
> -}
>  
> -/*
> - * The maximum number of pages to writeout in a single bdi flush/kupdate
> - * operation.  We do this so we don't hold I_SYNC against an inode for
> - * enormous amounts of time, which would block a userspace task which has
> - * been forced to throttle against that inode.  Also, the code reevaluates
> - * the dirty each time it has written this many pages.
> - */
> -#define MAX_WRITEBACK_PAGES     1024
> +	return nr_pages - work.nr_pages;
> +}
>  
>  static inline bool over_bground_thresh(void)
>  {
> @@ -636,42 +692,13 @@ static inline bool over_bground_thresh(v
>  static long wb_writeback(struct bdi_writeback *wb,
>  			 struct wb_writeback_work *work)
>  {
> -	struct writeback_control wbc = {
> -		.sync_mode		= work->sync_mode,
> -		.tagged_sync		= work->tagged_sync,
> -		.older_than_this	= NULL,
> -		.for_kupdate		= work->for_kupdate,
> -		.for_background		= work->for_background,
> -		.range_cyclic		= work->range_cyclic,
> -	};
> +	long nr_pages = work->nr_pages;
>  	unsigned long oldest_jif;
> -	long wrote = 0;
> -	long write_chunk = MAX_WRITEBACK_PAGES;
>  	struct inode *inode;
> -
> -	if (!wbc.range_cyclic) {
> -		wbc.range_start = 0;
> -		wbc.range_end = LLONG_MAX;
> -	}
> -
> -	/*
> -	 * WB_SYNC_ALL mode does livelock avoidance by syncing dirty
> -	 * inodes/pages in one big loop. Setting wbc.nr_to_write=LONG_MAX
> -	 * here avoids calling into writeback_inodes_wb() more than once.
> -	 *
> -	 * The intended call sequence for WB_SYNC_ALL writeback is:
> -	 *
> -	 *      wb_writeback()
> -	 *          writeback_sb_inodes()       <== called only once
> -	 *              write_cache_pages()     <== called once for each inode
> -	 *                   (quickly) tag currently dirty pages
> -	 *                   (maybe slowly) sync all tagged pages
> -	 */
> -	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_sync)
> -		write_chunk = LONG_MAX;
> +	long progress;
>  
>  	oldest_jif = jiffies;
> -	wbc.older_than_this = &oldest_jif;
> +	work->older_than_this = &oldest_jif;
>  
>  	for (;;) {
>  		/*
> @@ -700,27 +727,20 @@ static long wb_writeback(struct bdi_writ
>  		if (work->for_kupdate || work->for_background) {
>  			oldest_jif = jiffies -
>  				msecs_to_jiffies(dirty_expire_interval * 10);
> -			wbc.older_than_this = &oldest_jif;
> +			work->older_than_this = &oldest_jif;
>  		}
>  
> -		wbc.nr_to_write = write_chunk;
> -		wbc.pages_skipped = 0;
> -		wbc.inodes_cleaned = 0;
> -
>  retry:
> -		trace_wbc_writeback_start(&wbc, wb->bdi);
> +		trace_writeback_start(wb->bdi, work);
>  		spin_lock(&wb->list_lock);
>  		if (list_empty(&wb->b_io))
> -			queue_io(wb, wbc.older_than_this);
> +			queue_io(wb, work->older_than_this);
>  		if (work->sb)
> -			writeback_sb_inodes(work->sb, wb, &wbc, true);
> +			progress = writeback_sb_inodes(work->sb, wb, work);
>  		else
> -			__writeback_inodes_wb(wb, &wbc);
> +			progress = __writeback_inodes_wb(wb, work);
>  		spin_unlock(&wb->list_lock);
> -		trace_wbc_writeback_written(&wbc, wb->bdi);
> -
> -		work->nr_pages -= write_chunk - wbc.nr_to_write;
> -		wrote += write_chunk - wbc.nr_to_write;
> +		trace_writeback_written(wb->bdi, work);
>  
>  		/*
>  		 * Did we write something? Try for more
> @@ -730,9 +750,7 @@ retry:
>  		 * mean the overall work is done. So we keep looping as long
>  		 * as made some progress on cleaning pages or inodes.
>  		 */
> -		if (wbc.nr_to_write < write_chunk)
> -			continue;
> -		if (wbc.inodes_cleaned)
> +		if (progress)
>  			continue;
>  		/*
>  		 * background writeback will start with expired inodes, and
> @@ -741,10 +759,10 @@ retry:
>  		 * lists and cause trouble to the page reclaim.
>  		 */
>  		if (work->for_background &&
> -		    wbc.older_than_this &&
> +		    work->older_than_this &&
>  		    list_empty(&wb->b_io) &&
>  		    list_empty(&wb->b_more_io)) {
> -			wbc.older_than_this = NULL;
> +			work->older_than_this = NULL;
>  			goto retry;
>  		}
>  		/*
> @@ -759,8 +777,8 @@ retry:
>  		 */
>  		spin_lock(&wb->list_lock);
>  		if (!list_empty(&wb->b_more_io))  {
> +			trace_writeback_wait(wb->bdi, work);
>  			inode = wb_inode(wb->b_more_io.prev);
> -			trace_wbc_writeback_wait(&wbc, wb->bdi);
>  			spin_lock(&inode->i_lock);
>  			inode_wait_for_writeback(inode, wb);
>  			spin_unlock(&inode->i_lock);
> @@ -768,7 +786,7 @@ retry:
>  		spin_unlock(&wb->list_lock);
>  	}
>  
> -	return wrote;
> +	return nr_pages - work->nr_pages;
>  }
>  
>  /*
> --- linux-next.orig/include/linux/writeback.h	2011-05-11 22:37:15.000000000 +0800
> +++ linux-next/include/linux/writeback.h	2011-05-12 11:45:08.000000000 +0800
> @@ -24,12 +24,9 @@ enum writeback_sync_modes {
>   */
>  struct writeback_control {
>  	enum writeback_sync_modes sync_mode;
> -	unsigned long *older_than_this;	/* If !NULL, only write back inodes
> -					   older than this */
>  	long nr_to_write;		/* Write this many pages, and decrement
>  					   this for each page written */
>  	long pages_skipped;		/* Pages which were not written */
> -	long inodes_cleaned;		/* # of inodes cleaned */
>  
>  	/*
>  	 * For a_ops->writepages(): is start or end are non-zero then this is
> @@ -58,8 +55,7 @@ void writeback_inodes_sb_nr(struct super
>  int writeback_inodes_sb_if_idle(struct super_block *);
>  int writeback_inodes_sb_nr_if_idle(struct super_block *, unsigned long nr);
>  void sync_inodes_sb(struct super_block *);
> -void writeback_inodes_wb(struct bdi_writeback *wb,
> -		struct writeback_control *wbc);
> +long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages);
>  long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
>  void wakeup_flusher_threads(long nr_pages);
>  
> --- linux-next.orig/mm/backing-dev.c	2011-05-11 22:37:15.000000000 +0800
> +++ linux-next/mm/backing-dev.c	2011-05-12 11:45:08.000000000 +0800
> @@ -262,14 +262,7 @@ int bdi_has_dirty_io(struct backing_dev_
>  
>  static void bdi_flush_io(struct backing_dev_info *bdi)
>  {
> -	struct writeback_control wbc = {
> -		.sync_mode		= WB_SYNC_NONE,
> -		.older_than_this	= NULL,
> -		.range_cyclic		= 1,
> -		.nr_to_write		= 1024,
> -	};
> -
> -	writeback_inodes_wb(&bdi->wb, &wbc);
> +	writeback_inodes_wb(&bdi->wb, 1024);
>  }
>  
>  /*
> --- linux-next.orig/mm/page-writeback.c	2011-05-11 22:37:15.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-05-12 11:46:27.000000000 +0800
> @@ -494,13 +494,6 @@ static void balance_dirty_pages(struct a
>  		return;
>  
>  	for (;;) {
> -		struct writeback_control wbc = {
> -			.sync_mode	= WB_SYNC_NONE,
> -			.older_than_this = NULL,
> -			.nr_to_write	= write_chunk,
> -			.range_cyclic	= 1,
> -		};
> -
>  		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
>  					global_page_state(NR_UNSTABLE_NFS);
>  		nr_writeback = global_page_state(NR_WRITEBACK);
> @@ -562,17 +555,17 @@ static void balance_dirty_pages(struct a
>  		 * threshold otherwise wait until the disk writes catch
>  		 * up.
>  		 */
> -		trace_wbc_balance_dirty_start(&wbc, bdi);
> +		trace_balance_dirty_start(bdi);
>  		if (bdi_nr_reclaimable > bdi_thresh) {
> -			writeback_inodes_wb(&bdi->wb, &wbc);
> -			pages_written += write_chunk - wbc.nr_to_write;
> -			trace_wbc_balance_dirty_written(&wbc, bdi);
> +			pages_written += writeback_inodes_wb(&bdi->wb,
> +							     write_chunk);
> +			trace_balance_dirty_written(bdi, pages_written);
>  			if (pages_written >= write_chunk)
>  				break;		/* We've done our duty */
>  		}
> -		trace_wbc_balance_dirty_wait(&wbc, bdi);
>  		__set_current_state(TASK_UNINTERRUPTIBLE);
>  		io_schedule_timeout(pause);
> +		trace_balance_dirty_wait(bdi);
>  
>  		/*
>  		 * Increase the delay for each loop, up to our previous
> --- linux-next.orig/include/trace/events/writeback.h	2011-05-11 22:37:15.000000000 +0800
> +++ linux-next/include/trace/events/writeback.h	2011-05-12 11:46:27.000000000 +0800
> @@ -49,6 +49,9 @@ DEFINE_EVENT(writeback_work_class, name,
>  DEFINE_WRITEBACK_WORK_EVENT(writeback_nothread);
>  DEFINE_WRITEBACK_WORK_EVENT(writeback_queue);
>  DEFINE_WRITEBACK_WORK_EVENT(writeback_exec);
> +DEFINE_WRITEBACK_WORK_EVENT(writeback_start);
> +DEFINE_WRITEBACK_WORK_EVENT(writeback_written);
> +DEFINE_WRITEBACK_WORK_EVENT(writeback_wait);
>  
>  TRACE_EVENT(writeback_pages_written,
>  	TP_PROTO(long pages_written),
> @@ -88,6 +91,30 @@ DEFINE_WRITEBACK_EVENT(writeback_bdi_reg
>  DEFINE_WRITEBACK_EVENT(writeback_bdi_unregister);
>  DEFINE_WRITEBACK_EVENT(writeback_thread_start);
>  DEFINE_WRITEBACK_EVENT(writeback_thread_stop);
> +DEFINE_WRITEBACK_EVENT(balance_dirty_start);
> +DEFINE_WRITEBACK_EVENT(balance_dirty_wait);
> +
> +TRACE_EVENT(balance_dirty_written,
> +
> +	TP_PROTO(struct backing_dev_info *bdi, int written),
> +
> +	TP_ARGS(bdi, written),
> +
> +	TP_STRUCT__entry(
> +		__array(char,	name, 32)
> +		__field(int,	written)
> +	),
> +
> +	TP_fast_assign(
> +		strncpy(__entry->name, dev_name(bdi->dev), 32);
> +		__entry->written = written;
> +	),
> +
> +	TP_printk("bdi %s written %d",
> +		  __entry->name,
> +		  __entry->written
> +	)
> +);
>  
>  DECLARE_EVENT_CLASS(wbc_class,
>  	TP_PROTO(struct writeback_control *wbc, struct backing_dev_info *bdi),
> @@ -101,7 +128,6 @@ DECLARE_EVENT_CLASS(wbc_class,
>  		__field(int, for_background)
>  		__field(int, for_reclaim)
>  		__field(int, range_cyclic)
> -		__field(unsigned long, older_than_this)
>  		__field(long, range_start)
>  		__field(long, range_end)
>  	),
> @@ -115,14 +141,12 @@ DECLARE_EVENT_CLASS(wbc_class,
>  		__entry->for_background	= wbc->for_background;
>  		__entry->for_reclaim	= wbc->for_reclaim;
>  		__entry->range_cyclic	= wbc->range_cyclic;
> -		__entry->older_than_this = wbc->older_than_this ?
> -						*wbc->older_than_this : 0;
>  		__entry->range_start	= (long)wbc->range_start;
>  		__entry->range_end	= (long)wbc->range_end;
>  	),
>  
>  	TP_printk("bdi %s: towrt=%ld skip=%ld mode=%d kupd=%d "
> -		"bgrd=%d reclm=%d cyclic=%d older=0x%lx "
> +		"bgrd=%d reclm=%d cyclic=%d "
>  		"start=0x%lx end=0x%lx",
>  		__entry->name,
>  		__entry->nr_to_write,
> @@ -132,7 +156,6 @@ DECLARE_EVENT_CLASS(wbc_class,
>  		__entry->for_background,
>  		__entry->for_reclaim,
>  		__entry->range_cyclic,
> -		__entry->older_than_this,
>  		__entry->range_start,
>  		__entry->range_end)
>  )
> @@ -141,12 +164,6 @@ DECLARE_EVENT_CLASS(wbc_class,
>  DEFINE_EVENT(wbc_class, name, \
>  	TP_PROTO(struct writeback_control *wbc, struct backing_dev_info *bdi), \
>  	TP_ARGS(wbc, bdi))
> -DEFINE_WBC_EVENT(wbc_writeback_start);
> -DEFINE_WBC_EVENT(wbc_writeback_written);
> -DEFINE_WBC_EVENT(wbc_writeback_wait);
> -DEFINE_WBC_EVENT(wbc_balance_dirty_start);
> -DEFINE_WBC_EVENT(wbc_balance_dirty_written);
> -DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
>  DEFINE_WBC_EVENT(wbc_writepage);
>  
>  DECLARE_EVENT_CLASS(writeback_congest_waited_template,
> --- linux-next.orig/fs/btrfs/extent_io.c	2011-05-11 22:37:15.000000000 +0800
> +++ linux-next/fs/btrfs/extent_io.c	2011-05-12 11:45:08.000000000 +0800
> @@ -2596,7 +2596,6 @@ int extent_write_full_page(struct extent
>  	};
>  	struct writeback_control wbc_writepages = {
>  		.sync_mode	= wbc->sync_mode,
> -		.older_than_this = NULL,
>  		.nr_to_write	= 64,
>  		.range_start	= page_offset(page) + PAGE_CACHE_SIZE,
>  		.range_end	= (loff_t)-1,
> @@ -2629,7 +2628,6 @@ int extent_write_locked_range(struct ext
>  	};
>  	struct writeback_control wbc_writepages = {
>  		.sync_mode	= mode,
> -		.older_than_this = NULL,
>  		.nr_to_write	= nr_pages * 2,
>  		.range_start	= start,
>  		.range_end	= end + 1,
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
