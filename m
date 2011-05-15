Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1EOXys (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:54:48 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:24526 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323Ab1EOXyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:54:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoDAJVl0E15LCoegWdsb2JhbACgHweFaxUBARYmJYhwvGYOhgsElzyBIIY8
Date: Mon, 16 May 2011 09:54:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/17] writeback: remove writeback_control.more_io
Message-ID: <20110515235443.GQ19446@dastard>
References: <20110512135706.937596128@intel.com>
 <20110512140032.289087832@intel.com>
 <20110512230432.GL19446@dastard>
 <20110513050356.GD8016@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513050356.GD8016@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 01:03:56PM +0800, Wu Fengguang wrote:
> On Fri, May 13, 2011 at 07:04:32AM +0800, Dave Chinner wrote:
> > On Thu, May 12, 2011 at 09:57:19PM +0800, Wu Fengguang wrote:
> > > When wbc.more_io was first introduced, it indicates whether there are
> > > at least one superblock whose s_more_io contains more IO work. Now with
> > > the per-bdi writeback, it can be replaced with a simple b_more_io test.
> > > 
> > > Acked-by: Jan Kara <jack@suse.cz>
> > > Acked-by: Mel Gorman <mel@csn.ul.ie>
> > > CC: Minchan Kim <minchan.kim@gmail.com>
> > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > > ---
> > >  fs/fs-writeback.c                |    9 ++-------
> > >  include/linux/writeback.h        |    1 -
> > >  include/trace/events/ext4.h      |    6 ++----
> > >  include/trace/events/writeback.h |    5 +----
> > >  4 files changed, 5 insertions(+), 16 deletions(-)
> > > 
> > > --- linux-next.orig/fs/fs-writeback.c	2011-05-05 23:30:30.000000000 +0800
> > > +++ linux-next/fs/fs-writeback.c	2011-05-05 23:30:33.000000000 +0800
> > > @@ -560,12 +560,8 @@ static int writeback_sb_inodes(struct su
> > >  		iput(inode);
> > >  		cond_resched();
> > >  		spin_lock(&wb->list_lock);
> > > -		if (wbc->nr_to_write <= 0) {
> > > -			wbc->more_io = 1;
> > > +		if (wbc->nr_to_write <= 0)
> > >  			return 1;
> > > -		}
> > > -		if (!list_empty(&wb->b_more_io))
> > > -			wbc->more_io = 1;
> > >  	}
> > >  	/* b_io is empty */
> > >  	return 1;
> > > @@ -707,7 +703,6 @@ static long wb_writeback(struct bdi_writ
> > >  			wbc.older_than_this = &oldest_jif;
> > >  		}
> > >  
> > > -		wbc.more_io = 0;
> > >  		wbc.nr_to_write = write_chunk;
> > >  		wbc.pages_skipped = 0;
> > >  		wbc.inodes_cleaned = 0;
> > > @@ -755,7 +750,7 @@ retry:
> > >  		/*
> > >  		 * No more inodes for IO, bail
> > >  		 */
> > > -		if (!wbc.more_io)
> > > +		if (list_empty(&wb->b_more_io))
> > >  			break;
> > 
> > We're not holding the wb->list_lock here, so we need to be careful
> > here. I think this is safe given that there shuold only be one
> > flusher thread operating on the list, but when we expand to multiple
> > flusher threads per-bdi, this coul dbe a nasty landmine. A comment
> > is probably in order explaining why this is safe to check unlocked
> > right now...
> 
> OK, how about this?
> 
>                 /*
>                  * No more inodes for IO, bail. The unlocked check is safe
>                  * because each &wb will be worked by only one flusher thread.
>                  */
>                 if (list_empty(&wb->b_more_io))
>                         break;
> 
> I guess in future multiple flusher threads will be working on
> different bdi_writeback instances, so it will still be safe.

That's making assumptions about something that hasn't been
implemented yet.

> However for now there are possible interactions from the IO-full
> balance_dirty_pages(). So it looks better to just do the tests inside
> the lock:

Agreed, safer that way.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
