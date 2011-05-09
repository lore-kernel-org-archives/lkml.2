Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1EIQzC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 12:55:02 -0400
Received: from cantor.suse.de ([195.135.220.2]:54132 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab1EIQzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 12:55:00 -0400
Date: Mon, 9 May 2011 18:54:58 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 14/17] writeback: make writeback_control.nr_to_write
 straight
Message-ID: <20110509165458.GV4122@quack.suse.cz>
References: <20110506030821.523093711@intel.com>
 <20110506031613.556854231@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506031613.556854231@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 06-05-11 11:08:35, Wu Fengguang wrote:
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
...
> @@ -543,34 +588,40 @@ static int writeback_sb_inodes(struct su
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
> +		if (wrote >= MAX_WRITEBACK_PAGES)
> +			break;
  This definitely deserves a comment (as well as a similar check in
__writeback_inodes_wb()). I guess you bail out here so that we perform the
background limit check and livelocking of for_kupdate/for_background check
often enough. I'm undecided whether it's good to bail out like this. It's
not necessary in some cases (like WB_SYNC_ALL or for_sync writeback) but
OTOH moving the necessary checks here does not look ideal either...

>  void writeback_inodes_wb(struct bdi_writeback *wb,
> -		struct writeback_control *wbc)
> +			 struct writeback_control *wbc)
>  {
> +	struct wb_writeback_work work = {
> +		.nr_pages	= wbc->nr_to_write,
> +		.sync_mode	= wbc->sync_mode,
> +		.range_cyclic	= wbc->range_cyclic,
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
  Hmm, maybe we should just pass in number of pages (similarly as in
writeback_inodes_sb_nr())? It would look like a cleaner interface than
passing whole writeback_control and then ignoring parts of it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
