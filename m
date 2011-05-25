Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab1EYOjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:39:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:43477 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757292Ab1EYOjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:39:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,267,1304319600"; 
   d="scan'208";a="4615060"
Date: Wed, 25 May 2011 22:38:57 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/18] writeback: sync expired inodes first in
 background writeback
Message-ID: <20110525143857.GA25536@localhost>
References: <20110524051411.924582719@intel.com>
 <20110524051858.972440561@intel.com>
 <20110524155205.GC5390@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110524155205.GC5390@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kara,

On Tue, May 24, 2011 at 11:52:05PM +0800, Jan Kara wrote:
> On Tue 24-05-11 13:14:17, Wu Fengguang wrote:
> > A background flush work may run for ever. So it's reasonable for it to
> > mimic the kupdate behavior of syncing old/expired inodes first.
> > 
> > At each queue_io() time, first try enqueuing only newly expired inodes.
> > If there are zero expired inodes to work with, then relax the rule and
> > enqueue all dirty inodes.
>   Fengguang, I've been thinking about this change again (since the code is
> now easier to read - good work! - and so I realized some new consequences)

Thank you.

> and I was wondering: Assume there is one continuously redirtied file and
> untar starts in parallel. With the new logic, background writeback will
> never consider inodes that are not expired in this situation (we never
> switch to "all dirty inodes" phase - or even if we switched, we would just
> queue all inodes and then return back to queueing only expired inodes). So
> the net effect is that for 30 seconds we will be only continuously writing
> pages of the continuously dirtied file instead of (possibly older) pages of
> other files that are written. Is this really desirable? Wasn't the old
> behavior simpler and not worse than the new one?

Good question! Yes sadly in this case the new behavior could be worse
than the old one.

In fact this patch do not improve the small files (< 4MB) case at all,
except for the side effect that less unexpired inodes will leave in
s_io when the background work quit and the later kupdate work will
write less unexpired inodes.

And for the mixed small/large files case, it actually results in worse
behavior on your mentioned case.

However the root cause here is the file being _actively_ written to,
somehow a livelock scheme. We could add a simple livelock prevention
scheme that works for the common case of file appending:

- save i_size when the range_cyclic writeback starts from 0, for
  limiting the writeback scope
  
- when range_cyclic writeback hits the saved i_size, quit the current
  inode instead of immediately restarting from 0. This will not only
  avoid a possible extra seek, but also redirty_tail() the inode and
  hence get out of possible livelock.

The livelock prevention scheme may not only eliminate the undesirable
behavior you observed for this patch, but also prevent the "some old
pages may not get the chance to get written to disk in an actively
dirtied file" data security issue discussed in an old email. What do
you think?

Thanks,
Fengguang

> > --- linux-next.orig/fs/fs-writeback.c	2011-05-24 11:17:18.000000000 +0800
> > +++ linux-next/fs/fs-writeback.c	2011-05-24 11:17:18.000000000 +0800
> > @@ -718,7 +718,7 @@ static long wb_writeback(struct bdi_writ
> >  		if (work->for_background && !over_bground_thresh())
> >  			break;
> >  
> > -		if (work->for_kupdate) {
> > +		if (work->for_kupdate || work->for_background) {
> >  			oldest_jif = jiffies -
> >  				msecs_to_jiffies(dirty_expire_interval * 10);
> >  			wbc.older_than_this = &oldest_jif;
> > @@ -729,6 +729,7 @@ static long wb_writeback(struct bdi_writ
> >  		wbc.pages_skipped = 0;
> >  		wbc.inodes_cleaned = 0;
> >  
> > +retry:
> >  		trace_wbc_writeback_start(&wbc, wb->bdi);
> >  		if (work->sb)
> >  			__writeback_inodes_sb(work->sb, wb, &wbc);
> > @@ -752,6 +753,19 @@ static long wb_writeback(struct bdi_writ
> >  		if (wbc.inodes_cleaned)
> >  			continue;
> >  		/*
> > +		 * background writeback will start with expired inodes, and
> > +		 * if none is found, fallback to all inodes. This order helps
> > +		 * reduce the number of dirty pages reaching the end of LRU
> > +		 * lists and cause trouble to the page reclaim.
> > +		 */
> > +		if (work->for_background &&
> > +		    wbc.older_than_this &&
> > +		    list_empty(&wb->b_io) &&
> > +		    list_empty(&wb->b_more_io)) {
> > +			wbc.older_than_this = NULL;
> > +			goto retry;
> > +		}
> > +		/*
> >  		 * No more inodes for IO, bail
> >  		 */
> >  		if (!wbc.more_io)
> > 
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
