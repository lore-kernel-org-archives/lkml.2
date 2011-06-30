Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab1F3QZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 12:25:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab1F3QZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 12:25:00 -0400
Date: Thu, 30 Jun 2011 18:24:57 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] writeback: make writeback_control.nr_to_write
 straight
Message-ID: <20110630162457.GH28475@quack.suse.cz>
References: <20110629145245.835998321@intel.com>
 <20110629145553.642570515@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629145553.642570515@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 29-06-11 22:52:46, Wu Fengguang wrote:
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
> Acked-by: Jan Kara <jack@suse.cz>
> Proposed-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
  Just one minor nit:

> @@ -570,17 +622,25 @@ static int writeback_sb_inodes(struct su
>  		iput(inode);
>  		cond_resched();
>  		spin_lock(&wb->list_lock);
> -		if (wbc->nr_to_write <= 0)
> -			return 1;
> +		/*
> +		 * bail out to wb_writeback() often enough to check
> +		 * background threshold and other termination conditions.
> +		 */
> +		if (wrote) {
> +			if (jiffies - start_time > HZ / 10UL)
> +				break;
  I guess this comparison should use time_before() macro - or maybe even
time_is_before_jiffies().

> +			if (work->nr_pages <= 0)
> +				break;
> +		}
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
> +	unsigned long start_time = jiffies;
> +	long wrote = 0;
>  
>  	while (!list_empty(&wb->b_io)) {
>  		struct inode *inode = wb_inode(wb->b_io.prev);
> @@ -590,33 +650,37 @@ static void __writeback_inodes_wb(struct
>  			requeue_io(inode, wb);
>  			continue;
>  		}
> -		ret = writeback_sb_inodes(sb, wb, wbc, false);
> +		wrote += writeback_sb_inodes(sb, wb, work);
>  		drop_super(sb);
>  
> -		if (ret)
> -			break;
> +		/* refer to the same tests at the end of writeback_sb_inodes */
> +		if (wrote) {
> +			if (jiffies - start_time > HZ / 10UL)
> +				break;
  And the same here.

> +			if (work->nr_pages <= 0)
> +				break;
> +		}
>  	}
>  	/* Leave any unwritten inodes on b_io */
> +	return wrote;
>  }
>  

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
