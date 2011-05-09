Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1EIQRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 12:17:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:53004 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab1EIQRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 12:17:05 -0400
Date: Mon, 9 May 2011 18:16:46 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 10/17] writeback: avoid extra sync work at enqueue time
Message-ID: <20110509161646.GU4122@quack.suse.cz>
References: <20110506030821.523093711@intel.com>
 <20110506031613.070865192@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506031613.070865192@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 06-05-11 11:08:31, Wu Fengguang wrote:
> This removes writeback_control.wb_start and does more straightforward
> sync livelock prevention by setting .older_than_this to prevent extra
> inodes from being enqueued in the first place.
> 
> CC: Jan Kara <jack@suse.cz>
  Acked-by: Jan Kara <jack@suse.cz>

								Honza

> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/fs-writeback.c         |   16 +++-------------
>  include/linux/writeback.h |    3 ---
>  2 files changed, 3 insertions(+), 16 deletions(-)
> 
> --- linux-next.orig/fs/fs-writeback.c	2011-05-05 23:30:29.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2011-05-05 23:30:30.000000000 +0800
> @@ -544,15 +544,6 @@ static int writeback_sb_inodes(struct su
>  			continue;
>  		}
>  
> -		/*
> -		 * Was this inode dirtied after sync_sb_inodes was called?
> -		 * This keeps sync from extra jobs and livelock.
> -		 */
> -		if (inode_dirtied_after(inode, wbc->wb_start)) {
> -			spin_unlock(&inode->i_lock);
> -			return 1;
> -		}
> -
>  		__iget(inode);
>  
>  		pages_skipped = wbc->pages_skipped;
> @@ -585,9 +576,6 @@ static void __writeback_inodes_wb(struct
>  {
>  	int ret = 0;
>  
> -	if (!wbc->wb_start)
> -		wbc->wb_start = jiffies; /* livelock avoidance */
> -
>  	while (!list_empty(&wb->b_io)) {
>  		struct inode *inode = wb_inode(wb->b_io.prev);
>  		struct super_block *sb = inode->i_sb;
> @@ -686,7 +674,9 @@ static long wb_writeback(struct bdi_writ
>  	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_sync)
>  		write_chunk = LONG_MAX;
>  
> -	wbc.wb_start = jiffies; /* livelock avoidance */
> +	oldest_jif = jiffies;
> +	wbc.older_than_this = &oldest_jif;
> +
>  	for (;;) {
>  		/*
>  		 * Stop writeback when nr_pages has been consumed
> --- linux-next.orig/include/linux/writeback.h	2011-05-05 23:30:28.000000000 +0800
> +++ linux-next/include/linux/writeback.h	2011-05-05 23:30:30.000000000 +0800
> @@ -26,9 +26,6 @@ struct writeback_control {
>  	enum writeback_sync_modes sync_mode;
>  	unsigned long *older_than_this;	/* If !NULL, only write back inodes
>  					   older than this */
> -	unsigned long wb_start;         /* Time writeback_inodes_wb was
> -					   called. This is needed to avoid
> -					   extra jobs and livelock */
>  	long nr_to_write;		/* Write this many pages, and decrement
>  					   this for each page written */
>  	long pages_skipped;		/* Pages which were not written */
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
