Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab1EMFEC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 01:04:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:49737 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268Ab1EMFEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 01:04:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,362,1301900400"; 
   d="scan'208";a="642118323"
Date: Fri, 13 May 2011 13:03:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/17] writeback: remove writeback_control.more_io
Message-ID: <20110513050356.GD8016@localhost>
References: <20110512135706.937596128@intel.com>
 <20110512140032.289087832@intel.com>
 <20110512230432.GL19446@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512230432.GL19446@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 07:04:32AM +0800, Dave Chinner wrote:
> On Thu, May 12, 2011 at 09:57:19PM +0800, Wu Fengguang wrote:
> > When wbc.more_io was first introduced, it indicates whether there are
> > at least one superblock whose s_more_io contains more IO work. Now with
> > the per-bdi writeback, it can be replaced with a simple b_more_io test.
> > 
> > Acked-by: Jan Kara <jack@suse.cz>
> > Acked-by: Mel Gorman <mel@csn.ul.ie>
> > CC: Minchan Kim <minchan.kim@gmail.com>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  fs/fs-writeback.c                |    9 ++-------
> >  include/linux/writeback.h        |    1 -
> >  include/trace/events/ext4.h      |    6 ++----
> >  include/trace/events/writeback.h |    5 +----
> >  4 files changed, 5 insertions(+), 16 deletions(-)
> > 
> > --- linux-next.orig/fs/fs-writeback.c	2011-05-05 23:30:30.000000000 +0800
> > +++ linux-next/fs/fs-writeback.c	2011-05-05 23:30:33.000000000 +0800
> > @@ -560,12 +560,8 @@ static int writeback_sb_inodes(struct su
> >  		iput(inode);
> >  		cond_resched();
> >  		spin_lock(&wb->list_lock);
> > -		if (wbc->nr_to_write <= 0) {
> > -			wbc->more_io = 1;
> > +		if (wbc->nr_to_write <= 0)
> >  			return 1;
> > -		}
> > -		if (!list_empty(&wb->b_more_io))
> > -			wbc->more_io = 1;
> >  	}
> >  	/* b_io is empty */
> >  	return 1;
> > @@ -707,7 +703,6 @@ static long wb_writeback(struct bdi_writ
> >  			wbc.older_than_this = &oldest_jif;
> >  		}
> >  
> > -		wbc.more_io = 0;
> >  		wbc.nr_to_write = write_chunk;
> >  		wbc.pages_skipped = 0;
> >  		wbc.inodes_cleaned = 0;
> > @@ -755,7 +750,7 @@ retry:
> >  		/*
> >  		 * No more inodes for IO, bail
> >  		 */
> > -		if (!wbc.more_io)
> > +		if (list_empty(&wb->b_more_io))
> >  			break;
> 
> We're not holding the wb->list_lock here, so we need to be careful
> here. I think this is safe given that there shuold only be one
> flusher thread operating on the list, but when we expand to multiple
> flusher threads per-bdi, this coul dbe a nasty landmine. A comment
> is probably in order explaining why this is safe to check unlocked
> right now...

OK, how about this?

                /*
                 * No more inodes for IO, bail. The unlocked check is safe
                 * because each &wb will be worked by only one flusher thread.
                 */
                if (list_empty(&wb->b_more_io))
                        break;

I guess in future multiple flusher threads will be working on
different bdi_writeback instances, so it will still be safe.

However for now there are possible interactions from the IO-full
balance_dirty_pages(). So it looks better to just do the tests inside
the lock:

--- linux-next.orig/fs/fs-writeback.c	2011-05-13 13:02:18.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-13 13:02:52.000000000 +0800
@@ -710,6 +710,7 @@ static long wb_writeback(struct bdi_writ
 	oldest_jif = jiffies;
 	work->older_than_this = &oldest_jif;
 
+	spin_lock(&wb->list_lock);
 	for (;;) {
 		/*
 		 * Stop writeback when nr_pages has been consumed
@@ -742,14 +743,12 @@ static long wb_writeback(struct bdi_writ
 
 retry:
 		trace_writeback_start(wb->bdi, work);
-		spin_lock(&wb->list_lock);
 		if (list_empty(&wb->b_io))
 			queue_io(wb, work->older_than_this);
 		if (work->sb)
 			progress = writeback_sb_inodes(work->sb, wb, work);
 		else
 			progress = __writeback_inodes_wb(wb, work);
-		spin_unlock(&wb->list_lock);
 		trace_writeback_written(wb->bdi, work);
 
 		/*
@@ -785,7 +784,6 @@ retry:
 		 * become available for writeback. Otherwise
 		 * we'll just busyloop.
 		 */
-		spin_lock(&wb->list_lock);
 		if (!list_empty(&wb->b_more_io))  {
 			trace_writeback_wait(wb->bdi, work);
 			inode = wb_inode(wb->b_more_io.prev);
@@ -793,8 +791,8 @@ retry:
 			inode_wait_for_writeback(inode, wb);
 			spin_unlock(&inode->i_lock);
 		}
-		spin_unlock(&wb->list_lock);
 	}
+	spin_unlock(&wb->list_lock);
 
 	return nr_pages - work->nr_pages;
 }
