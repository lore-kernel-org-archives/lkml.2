Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab1EFQIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 12:08:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab1EFQIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 12:08:53 -0400
Date: Fri, 6 May 2011 18:08:47 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/17] writeback: introduce wbc.tagged_sync for the
 WB_SYNC_NONE sync stage
Message-ID: <20110506160847.GG18982@quack.suse.cz>
References: <20110506030821.523093711@intel.com>
 <20110506031611.917773937@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506031611.917773937@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 06-05-11 11:08:22, Wu Fengguang wrote:
> sync(2) is performed in two stages: the WB_SYNC_NONE sync and the
> WB_SYNC_ALL sync. Tag the first stage with wbc.tagged_sync and do
> livelock prevention for it, too.
> 
> Note that writeback_inodes_sb() is called by not only sync(), they are
> treated the same because the other callers also need livelock prevention.
> 
> Impact:  It changes the order in which pages/inodes are synced to disk.
> Now in the WB_SYNC_NONE stage, it won't proceed to write the next inode
> until finished with the current inode.
  You can add:
Acked-by: Jan Kara <jack@suse.cz>

> CC: Jan Kara <jack@suse.cz>
> CC: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/ext4/inode.c           |    4 ++--
>  fs/fs-writeback.c         |    9 +++++----
>  include/linux/writeback.h |    1 +
>  mm/page-writeback.c       |    4 ++--
>  4 files changed, 10 insertions(+), 8 deletions(-)
> 
> --- linux-next.orig/fs/fs-writeback.c	2011-05-05 23:29:51.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2011-05-05 23:30:22.000000000 +0800
> @@ -36,6 +36,7 @@ struct wb_writeback_work {
>  	long nr_pages;
>  	struct super_block *sb;
>  	enum writeback_sync_modes sync_mode;
> +	unsigned int tagged_sync:1;
>  	unsigned int for_kupdate:1;
>  	unsigned int range_cyclic:1;
>  	unsigned int for_background:1;
> @@ -650,6 +651,7 @@ static long wb_writeback(struct bdi_writ
>  {
>  	struct writeback_control wbc = {
>  		.sync_mode		= work->sync_mode,
> +		.tagged_sync		= work->tagged_sync,
>  		.older_than_this	= NULL,
>  		.for_kupdate		= work->for_kupdate,
>  		.for_background		= work->for_background,
> @@ -657,7 +659,7 @@ static long wb_writeback(struct bdi_writ
>  	};
>  	unsigned long oldest_jif;
>  	long wrote = 0;
> -	long write_chunk;
> +	long write_chunk = MAX_WRITEBACK_PAGES;
>  	struct inode *inode;
>  
>  	if (wbc.for_kupdate) {
> @@ -683,9 +685,7 @@ static long wb_writeback(struct bdi_writ
>  	 *                   (quickly) tag currently dirty pages
>  	 *                   (maybe slowly) sync all tagged pages
>  	 */
> -	if (wbc.sync_mode == WB_SYNC_NONE)
> -		write_chunk = MAX_WRITEBACK_PAGES;
> -	else
> +	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_sync)
>  		write_chunk = LONG_MAX;
>  
>  	wbc.wb_start = jiffies; /* livelock avoidance */
> @@ -1193,6 +1193,7 @@ void writeback_inodes_sb_nr(struct super
>  	struct wb_writeback_work work = {
>  		.sb		= sb,
>  		.sync_mode	= WB_SYNC_NONE,
> +		.tagged_sync	= 1,
>  		.done		= &done,
>  		.nr_pages	= nr,
>  	};
> --- linux-next.orig/include/linux/writeback.h	2011-05-05 23:29:51.000000000 +0800
> +++ linux-next/include/linux/writeback.h	2011-05-05 23:30:22.000000000 +0800
> @@ -47,6 +47,7 @@ struct writeback_control {
>  	unsigned encountered_congestion:1; /* An output: a queue is full */
>  	unsigned for_kupdate:1;		/* A kupdate writeback */
>  	unsigned for_background:1;	/* A background writeback */
> +	unsigned tagged_sync:1;		/* do livelock prevention for sync */
>  	unsigned for_reclaim:1;		/* Invoked from the page allocator */
>  	unsigned range_cyclic:1;	/* range_start is cyclic */
>  	unsigned more_io:1;		/* more io to be dispatched */
> --- linux-next.orig/mm/page-writeback.c	2011-05-05 23:29:51.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-05-05 23:30:22.000000000 +0800
> @@ -892,12 +892,12 @@ int write_cache_pages(struct address_spa
>  			range_whole = 1;
>  		cycled = 1; /* ignore range_cyclic tests */
>  	}
> -	if (wbc->sync_mode == WB_SYNC_ALL)
> +	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_sync)
>  		tag = PAGECACHE_TAG_TOWRITE;
>  	else
>  		tag = PAGECACHE_TAG_DIRTY;
>  retry:
> -	if (wbc->sync_mode == WB_SYNC_ALL)
> +	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_sync)
>  		tag_pages_for_writeback(mapping, index, end);
>  	done_index = index;
>  	while (!done && (index <= end)) {
> --- linux-next.orig/fs/ext4/inode.c	2011-05-05 23:29:51.000000000 +0800
> +++ linux-next/fs/ext4/inode.c	2011-05-05 23:30:22.000000000 +0800
> @@ -2741,7 +2741,7 @@ static int write_cache_pages_da(struct a
>  	index = wbc->range_start >> PAGE_CACHE_SHIFT;
>  	end = wbc->range_end >> PAGE_CACHE_SHIFT;
>  
> -	if (wbc->sync_mode == WB_SYNC_ALL)
> +	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_sync)
>  		tag = PAGECACHE_TAG_TOWRITE;
>  	else
>  		tag = PAGECACHE_TAG_DIRTY;
> @@ -2975,7 +2975,7 @@ static int ext4_da_writepages(struct add
>  	}
>  
>  retry:
> -	if (wbc->sync_mode == WB_SYNC_ALL)
> +	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_sync)
>  		tag_pages_for_writeback(mapping, index, end);
>  
>  	while (!ret && wbc->nr_to_write > 0) {
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
