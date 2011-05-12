Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454Ab1ELXSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 19:18:07 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:22556 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757747Ab1ELXSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 19:18:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABZqzE15LCoe/2dsb2JhbACleHiIcL9RDoMFAYMBBJcgh1c
Date: Fri, 13 May 2011 09:18:00 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/17] writeback: make writeback_control.nr_to_write
 straight
Message-ID: <20110512231759.GM19446@dastard>
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

On Thu, May 12, 2011 at 09:57:20PM +0800, Wu Fengguang wrote:
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
> ---
.....
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

Oh, that's just ugly. Do that accounting via nr_to_write in
writeback_single_inode() as I suggested earlier, please.

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

Why do this so often? If you are writing large files, it will be
once every writeback_single_inode() call that you bail. Seems rather
inefficient to me to go back to the top level loop just to check for
more work when we already know we have more work to do because
there's still inodes on b_io....

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

Same here.

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

And this change means we'll only ever write 1024 pages maximum per
call to writeback_inodes_wb() when large files are present. that
means:

....
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

We're going to get different throttling behaviour dependent on
whether there are large dirty files present or not in cache....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
