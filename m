Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab1ELWzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 18:55:40 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:39509 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757315Ab1ELWzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 18:55:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAANjzE15LCoe/2dsb2JhbACleHjIOw6GBwSedw
Date: Fri, 13 May 2011 08:55:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/17] writeback: sync expired inodes first in
 background writeback
Message-ID: <20110512225525.GK19446@dastard>
References: <20110512135706.937596128@intel.com>
 <20110512140031.390955672@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512140031.390955672@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 09:57:12PM +0800, Wu Fengguang wrote:
> A background flush work may run for ever. So it's reasonable for it to
> mimic the kupdate behavior of syncing old/expired inodes first.
> 
> At each queue_io() time, first try enqueuing only newly expired inodes.
> If there are zero expired inodes to work with, then relax the rule and
> enqueue all dirty inodes.
> 
> It at least makes sense from the data integrity point of view.
> 
> This may also reduce the number of dirty pages encountered by page
> reclaim, eg. the pageout() calls. Normally older inodes contain older
> dirty pages, which are more close to the end of the LRU lists. So
> syncing older inodes first helps reducing the dirty pages reached by the
> page reclaim code.
> 
> More background: as Mel put it, "it makes sense to write old pages first
> to reduce the chances page reclaim is initiating IO."
> 
> Rik also presented the situation with a graph:
> 
> LRU head                                 [*] dirty page
> [                          *              *      * *  *  * * * * * *]
> 
> Ideally, most dirty pages should lie close to the LRU tail instead of
> LRU head. That requires the flusher thread to sync old/expired inodes
> first (as there are obvious correlations between inode age and page
> age), and to give fair opportunities to newly expired inodes rather
> than sticking with some large eldest inodes (as larger inodes have
> weaker correlations in the inode<=>page ages).
> 
> This patch helps the flusher to meet both the above requirements.
> 
> Side effects: it might reduce the batch size and hence reduce
> inode_wb_list_lock hold time, but in turn make the cluster-by-partition
> logic in the same function less effective on reducing disk seeks.
> 
> v2: keep policy changes inside wb_writeback() and keep the
> wbc.older_than_this visibility as suggested by Dave.
> 
> CC: Dave Chinner <david@fromorbit.com>
> Acked-by: Jan Kara <jack@suse.cz>
> Acked-by: Rik van Riel<riel@redhat.com>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/fs-writeback.c |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> --- linux-next.orig/fs/fs-writeback.c	2011-05-05 23:30:25.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2011-05-05 23:30:26.000000000 +0800
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

I have to say that I dislike this implicit nested looping structure
using a goto. It would seem better to me to make it explicit that we
can do multiple writeback calls by using a do/while loop here and
moving the logic of setting/resetting wbc.older_than_this to one
place inside the nested loop...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
