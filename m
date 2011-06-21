Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab1FUPIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:08:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:22310 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab1FUPH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:07:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,401,1304319600"; 
   d="scan'208";a="16211430"
Date: Tue, 21 Jun 2011 23:07:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] writeback: timestamp based bdi dirty_exceeded state
Message-ID: <20110621150752.GC4280@localhost>
References: <20110619150108.691351746@intel.com>
 <20110619150510.717948499@intel.com>
 <20110620213818.GI4810@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620213818.GI4810@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 05:38:18AM +0800, Jan Kara wrote:
> On Sun 19-06-11 23:01:15, Wu Fengguang wrote:
> > When there are only one (or several) dirtiers, dirty_exceeded is always
> > (or mostly) off. Converting to timestamp avoids this problem. It helps
> > to use smaller write_chunk for smoother throttling.
>   Hmm, what do you mean by "dirty_exceeded is always (or mostly) off"? I
> agree that dirty_exceeded handling is broken in current kernel when there
> are more dirtiers because of tasks having different dirty limits. Is this
> the problem you are speaking about?

For the 1-dirty case, it will quit on either of the two conditions

(1) no longer dirty exceeded, or
(2) write 1.5 times what it has dirtied

Note that (2) implies (1) because there is only 1 dirtier: if it takes
4MB pages to make it dirty exceeded, it will sure drop out of the dirty
exceeded state after cleaned 6MB.

So the 1 dirtier will mostly see dirty_exceeded=0 inside
balance_dirty_pages_ratelimited_nr().

However that looks not a big problem. Since there is only 1 dirtier,
it will at most get dirty exceeded by 4MB, which is fairly acceptable.

> If yes, I think I have a cleaner fix for that - setting dirty_exceeded
> when bdi_dirty enters the range where per-task dirty limits can be and
> resetting it only when we leave that range. I can refresh the fix and
> send it to you...

Yes there is the per-task dynamic thresholds. However given that the
current scheme looks not too bad, maybe we can just do nothing for now
and skip this patch?

Thanks,
Fengguang

> > Before patch, the wait time in balance_dirty_pages() are ~200ms:
> > 
> > [ 1093.397700] write_bandwidth: comm=swapper pages=1536 time=204ms
> > [ 1093.594319] write_bandwidth: comm=swapper pages=1536 time=196ms
> > [ 1093.796642] write_bandwidth: comm=swapper pages=1536 time=200ms
> > 
> > After patch, ~25ms:
> > 
> > [   90.261339] write_bandwidth: comm=swapper pages=192 time=20ms
> > [   90.293168] write_bandwidth: comm=swapper pages=192 time=24ms
> > [   90.323853] write_bandwidth: comm=swapper pages=192 time=24ms
> > [   90.354510] write_bandwidth: comm=swapper pages=192 time=28ms
> > [   90.389890] write_bandwidth: comm=swapper pages=192 time=28ms
> > [   90.421787] write_bandwidth: comm=swapper pages=192 time=24ms
> > 
> >  include/linux/backing-dev.h |    2 +-
> >  mm/backing-dev.c            |    2 --
> >  mm/page-writeback.c         |   24 ++++++++++++------------
> >  3 files changed, 13 insertions(+), 15 deletions(-)
> > 
> > --- linux-next.orig/mm/page-writeback.c	2011-06-19 22:59:49.000000000 +0800
> > +++ linux-next/mm/page-writeback.c	2011-06-19 22:59:53.000000000 +0800
> > @@ -483,6 +483,15 @@ unsigned long bdi_dirty_limit(struct bac
> >  	return bdi_dirty;
> >  }
> >  
> > +/*
> > + * last time exceeded (limit - limit/DIRTY_BRAKE)
> > + */
> > +static bool dirty_exceeded_recently(struct backing_dev_info *bdi,
> > +				    unsigned long time_window)
> > +{
> > +	return jiffies - bdi->dirty_exceed_time <= time_window;
> > +}
> > +
> >  static void bdi_update_write_bandwidth(struct backing_dev_info *bdi,
> >  				       unsigned long elapsed,
> >  				       unsigned long written)
> > @@ -621,7 +630,6 @@ static void balance_dirty_pages(struct a
> >  	unsigned long bdi_thresh;
> >  	unsigned long pages_written = 0;
> >  	unsigned long pause = 1;
> > -	bool dirty_exceeded = false;
> >  	struct backing_dev_info *bdi = mapping->backing_dev_info;
> >  	unsigned long start_time = jiffies;
> >  
> > @@ -669,14 +677,9 @@ static void balance_dirty_pages(struct a
> >  		 * bdi or process from holding back light ones; The latter is
> >  		 * the last resort safeguard.
> >  		 */
> > -		dirty_exceeded = (bdi_dirty > bdi_thresh) ||
> > -				  (nr_dirty > dirty_thresh);
> > -
> > -		if (!dirty_exceeded)
> > +		if (bdi_dirty <= bdi_thresh && nr_dirty <= dirty_thresh)
> >  			break;
> > -
> > -		if (!bdi->dirty_exceeded)
> > -			bdi->dirty_exceeded = 1;
> > +		bdi->dirty_exceed_time = jiffies;
> >  
> >  		bdi_update_bandwidth(bdi, dirty_thresh, nr_dirty, bdi_dirty,
> >  				     start_time);
> > @@ -719,9 +722,6 @@ static void balance_dirty_pages(struct a
> >  			pause = HZ / 10;
> >  	}
> >  
> > -	if (!dirty_exceeded && bdi->dirty_exceeded)
> > -		bdi->dirty_exceeded = 0;
> > -
> >  	if (writeback_in_progress(bdi))
> >  		return;
> >  
> > @@ -775,7 +775,7 @@ void balance_dirty_pages_ratelimited_nr(
> >  		return;
> >  
> >  	ratelimit = ratelimit_pages;
> > -	if (mapping->backing_dev_info->dirty_exceeded)
> > +	if (dirty_exceeded_recently(bdi, MAX_PAUSE))
> >  		ratelimit = 8;
> >  
> >  	/*
> > --- linux-next.orig/include/linux/backing-dev.h	2011-06-19 22:54:58.000000000 +0800
> > +++ linux-next/include/linux/backing-dev.h	2011-06-19 22:59:53.000000000 +0800
> > @@ -79,7 +79,7 @@ struct backing_dev_info {
> >  	unsigned long avg_write_bandwidth;
> >  
> >  	struct prop_local_percpu completions;
> > -	int dirty_exceeded;
> > +	unsigned long dirty_exceed_time;
> >  
> >  	unsigned int min_ratio;
> >  	unsigned int max_ratio, max_prop_frac;
> > --- linux-next.orig/mm/backing-dev.c	2011-06-19 22:59:49.000000000 +0800
> > +++ linux-next/mm/backing-dev.c	2011-06-19 22:59:53.000000000 +0800
> > @@ -670,8 +670,6 @@ int bdi_init(struct backing_dev_info *bd
> >  			goto err;
> >  	}
> >  
> > -	bdi->dirty_exceeded = 0;
> > -
> >  	bdi->bw_time_stamp = jiffies;
> >  	bdi->written_stamp = 0;
> >  
> > 
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
