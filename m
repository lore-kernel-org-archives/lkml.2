Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab1EXPwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:52:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:50898 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab1EXPwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:52:08 -0400
Date: Tue, 24 May 2011 17:52:05 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/18] writeback: sync expired inodes first in
 background writeback
Message-ID: <20110524155205.GC5390@quack.suse.cz>
References: <20110524051411.924582719@intel.com>
 <20110524051858.972440561@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110524051858.972440561@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 24-05-11 13:14:17, Wu Fengguang wrote:
> A background flush work may run for ever. So it's reasonable for it to
> mimic the kupdate behavior of syncing old/expired inodes first.
> 
> At each queue_io() time, first try enqueuing only newly expired inodes.
> If there are zero expired inodes to work with, then relax the rule and
> enqueue all dirty inodes.
  Fengguang, I've been thinking about this change again (since the code is
now easier to read - good work! - and so I realized some new consequences)
and I was wondering: Assume there is one continuously redirtied file and
untar starts in parallel. With the new logic, background writeback will
never consider inodes that are not expired in this situation (we never
switch to "all dirty inodes" phase - or even if we switched, we would just
queue all inodes and then return back to queueing only expired inodes). So
the net effect is that for 30 seconds we will be only continuously writing
pages of the continuously dirtied file instead of (possibly older) pages of
other files that are written. Is this really desirable? Wasn't the old
behavior simpler and not worse than the new one?

								Honza

> --- linux-next.orig/fs/fs-writeback.c	2011-05-24 11:17:18.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2011-05-24 11:17:18.000000000 +0800
> @@ -718,7 +718,7 @@ static long wb_writeback(struct bdi_writ
>  		if (work->for_background && !over_bground_thresh())
>  			break;
>  
> -		if (work->for_kupdate) {
> +		if (work->for_kupdate || work->for_background) {
>  			oldest_jif = jiffies -
>  				msecs_to_jiffies(dirty_expire_interval * 10);
>  			wbc.older_than_this = &oldest_jif;
> @@ -729,6 +729,7 @@ static long wb_writeback(struct bdi_writ
>  		wbc.pages_skipped = 0;
>  		wbc.inodes_cleaned = 0;
>  
> +retry:
>  		trace_wbc_writeback_start(&wbc, wb->bdi);
>  		if (work->sb)
>  			__writeback_inodes_sb(work->sb, wb, &wbc);
> @@ -752,6 +753,19 @@ static long wb_writeback(struct bdi_writ
>  		if (wbc.inodes_cleaned)
>  			continue;
>  		/*
> +		 * background writeback will start with expired inodes, and
> +		 * if none is found, fallback to all inodes. This order helps
> +		 * reduce the number of dirty pages reaching the end of LRU
> +		 * lists and cause trouble to the page reclaim.
> +		 */
> +		if (work->for_background &&
> +		    wbc.older_than_this &&
> +		    list_empty(&wb->b_io) &&
> +		    list_empty(&wb->b_more_io)) {
> +			wbc.older_than_this = NULL;
> +			goto retry;
> +		}
> +		/*
>  		 * No more inodes for IO, bail
>  		 */
>  		if (!wbc.more_io)
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
