Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab0E1A41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:56:27 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:47982 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757139Ab0E1A4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:56:24 -0400
Date: Fri, 28 May 2010 10:56:02 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       tytso@mit.edu, jens.axboe@oracle.com
Subject: Re: [PATCH 4/6] writeback: pay attention to wbc->nr_to_write in
 write_cache_pages
Message-ID: <20100528005602.GW12087@dastard>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
 <1274784852-30502-5-git-send-email-david@fromorbit.com>
 <20100527143251.5193842d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527143251.5193842d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 02:32:51PM -0700, Andrew Morton wrote:
> On Tue, 25 May 2010 20:54:10 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > If a filesystem writes more than one page in ->writepage, write_cache_pages
> > fails to notice this and continues to attempt writeback when wbc->nr_to_write
> > has gone negative - this trace was captured from XFS:
> > 
> > 
> >     wbc_writeback_start: towrt=1024
> >     wbc_writepage: towrt=1024
> >     wbc_writepage: towrt=0
> >     wbc_writepage: towrt=-1
> >     wbc_writepage: towrt=-5
> >     wbc_writepage: towrt=-21
> >     wbc_writepage: towrt=-85
> > 
> > This has adverse effects on filesystem writeback behaviour. write_cache_pages()
> > needs to terminate after a certain number of pages are written, not after a
> > certain number of calls to ->writepage are made.  This is a regression
> > introduced by 17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4, but cannot be reverted
> 
> It's conventional to identify commits by their title as well as their
> hash.  So 17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4 ("vfs: Add
> no_nrwrite_index_update writeback control flag").  Because that commit
> might have different hashes in different trees, I think.  A Linus idea.
> 
> I do this ten times a day - It's a PITA.

Will fix.

> 
> > directly due to subsequent bug fixes that have gone in on top of it.
> > 
> > This commit adds a ->writepage tracepoint inside write_cache_pages() (how the
> > above trace was generated) and does the revert manually leaving the subsequent
> > bug fixes in tact. ext4 is not affected by this as a previous commit in the
> 
> "intact".

*nod*

> > series stops ext4 from using the generic function.
> > 
> > -			if (nr_to_write > 0) {
> > -				nr_to_write--;
> > -				if (nr_to_write == 0 &&
> > +			if (wbc->nr_to_write > 0) {
> > +				if (--wbc->nr_to_write == 0 &&
> >  				    wbc->sync_mode == WB_SYNC_NONE) {
> >  					/*
> >  					 * We stop writing back only if we are
> > @@ -974,11 +973,8 @@ continue_unlock:
> >  		end = writeback_index - 1;
> >  		goto retry;
> >  	}
> > -	if (!wbc->no_nrwrite_index_update) {
> > -		if (wbc->range_cyclic || (range_whole && nr_to_write > 0))
> > -			mapping->writeback_index = done_index;
> > -		wbc->nr_to_write = nr_to_write;
> > -	}
> > +	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
> > +		mapping->writeback_index = done_index;
> >  
> >  	return ret;
> 
> 'bout time we fixed that.  I wonder why it took so long to find.

IMO, because without tracing it's almost impossible to see what is
happening inside this code easily. I wasn't looking for this bug
when I added the tracing - I was trying to discover why sync was
locking up for minutes on end.

Also a significant problem is that writeback changes often come in
through a tree that no filesystem developer is actually testing
(e.g. the block git tree) or a single FS tree (e.g. the ext4 tree),
so problems in the generic code that manifest in only one or two
filesystems slip under the radar all too easily. Hence they are
often only discovered when some other, unrelated, obvious problem is
investigated...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
