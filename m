Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab1EIQPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 12:15:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab1EIQPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 12:15:54 -0400
Date: Mon, 9 May 2011 18:15:47 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 09/17] writeback: elevate queue_io() into wb_writeback()
Message-ID: <20110509161547.GT4122@quack.suse.cz>
References: <20110506030821.523093711@intel.com>
 <20110506031612.914153017@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506031612.914153017@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 06-05-11 11:08:30, Wu Fengguang wrote:
> Code refactor for more logical code layout.
> No behavior change.
> 
> - remove the mis-named __writeback_inodes_sb()
> 
> - wb_writeback()/writeback_inodes_wb() will decide when to queue_io()
>   before calling __writeback_inodes_wb()
> 
  You can add:
Acked-by: Jan Kara <jack@suse.cz>

								Honza

> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/fs-writeback.c |   27 ++++++++++++---------------
>  1 file changed, 12 insertions(+), 15 deletions(-)
> 
> --- linux-next.orig/fs/fs-writeback.c	2011-05-05 23:41:36.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2011-05-05 23:51:59.000000000 +0800
> @@ -580,17 +580,13 @@ static int writeback_sb_inodes(struct su
>  	return 1;
>  }
>  
> -void writeback_inodes_wb(struct bdi_writeback *wb,
> -		struct writeback_control *wbc)
> +static void __writeback_inodes_wb(struct bdi_writeback *wb,
> +				  struct writeback_control *wbc)
>  {
>  	int ret = 0;
>  
>  	if (!wbc->wb_start)
>  		wbc->wb_start = jiffies; /* livelock avoidance */
> -	spin_lock(&wb->list_lock);
> -
> -	if (list_empty(&wb->b_io))
> -		queue_io(wb, wbc->older_than_this);
>  
>  	while (!list_empty(&wb->b_io)) {
>  		struct inode *inode = wb_inode(wb->b_io.prev);
> @@ -606,19 +602,16 @@ void writeback_inodes_wb(struct bdi_writ
>  		if (ret)
>  			break;
>  	}
> -	spin_unlock(&wb->list_lock);
>  	/* Leave any unwritten inodes on b_io */
>  }
>  
> -static void __writeback_inodes_sb(struct super_block *sb,
> -		struct bdi_writeback *wb, struct writeback_control *wbc)
> +void writeback_inodes_wb(struct bdi_writeback *wb,
> +		struct writeback_control *wbc)
>  {
> -	WARN_ON(!rwsem_is_locked(&sb->s_umount));
> -
>  	spin_lock(&wb->list_lock);
>  	if (list_empty(&wb->b_io))
>  		queue_io(wb, wbc->older_than_this);
> -	writeback_sb_inodes(sb, wb, wbc, true);
> +	__writeback_inodes_wb(wb, wbc);
>  	spin_unlock(&wb->list_lock);
>  }
>  
> @@ -685,7 +678,7 @@ static long wb_writeback(struct bdi_writ
>  	 * The intended call sequence for WB_SYNC_ALL writeback is:
>  	 *
>  	 *      wb_writeback()
> -	 *          __writeback_inodes_sb()     <== called only once
> +	 *          writeback_sb_inodes()       <== called only once
>  	 *              write_cache_pages()     <== called once for each inode
>  	 *                   (quickly) tag currently dirty pages
>  	 *                   (maybe slowly) sync all tagged pages
> @@ -731,10 +724,14 @@ static long wb_writeback(struct bdi_writ
>  
>  retry:
>  		trace_wbc_writeback_start(&wbc, wb->bdi);
> +		spin_lock(&wb->list_lock);
> +		if (list_empty(&wb->b_io))
> +			queue_io(wb, wbc.older_than_this);
>  		if (work->sb)
> -			__writeback_inodes_sb(work->sb, wb, &wbc);
> +			writeback_sb_inodes(work->sb, wb, &wbc, true);
>  		else
> -			writeback_inodes_wb(wb, &wbc);
> +			__writeback_inodes_wb(wb, &wbc);
> +		spin_unlock(&wb->list_lock);
>  		trace_wbc_writeback_written(&wbc, wb->bdi);
>  
>  		work->nr_pages -= write_chunk - wbc.nr_to_write;
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
