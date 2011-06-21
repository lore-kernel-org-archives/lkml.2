Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab1FUOYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:24:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:55470 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273Ab1FUOYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:24:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,401,1304319600"; 
   d="scan'208";a="20912370"
Date: Tue, 21 Jun 2011 22:24:30 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [PATCH 3/7] writeback: introduce smoothed global dirty limit
Message-ID: <20110621142430.GB4280@localhost>
References: <20110619150108.691351746@intel.com>
 <20110619150510.246140117@intel.com>
 <20110620211810.GH4810@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620211810.GH4810@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 05:18:10AM +0800, Jan Kara wrote:
> On Sun 19-06-11 23:01:11, Wu Fengguang wrote:
> > The start of a heavy weight application (ie. KVM) may instantly knock
> > down determine_dirtyable_memory() and hence the global/bdi dirty
> > thresholds.
> > 
> > So introduce global_dirty_limit for tracking the global dirty threshold
> > with policies
> > 
> > - follow downwards slowly
> > - follow up in one shot
> > 
> > global_dirty_limit can effectively mask out the impact of sudden drop of
> > dirtyable memory. It will be used in the next patch for two new type of
> > dirty limits.
> Looking into the code, this patch is dependent on previously submitted
> patches for estimation of BDI write bandwidth, isn't it?

Right... I'll submit them as one series at next post :)

> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  include/linux/writeback.h |    2 +
> >  mm/page-writeback.c       |   41 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 43 insertions(+)
> > 
> > --- linux-next.orig/include/linux/writeback.h	2011-06-19 22:56:18.000000000 +0800
> > +++ linux-next/include/linux/writeback.h	2011-06-19 22:59:29.000000000 +0800
> > @@ -88,6 +88,8 @@ static inline void laptop_sync_completio
> >  #endif
> >  void throttle_vm_writeout(gfp_t gfp_mask);
> >  
> > +extern unsigned long global_dirty_limit;
> > +
> >  /* These are exported to sysctl. */
> >  extern int dirty_background_ratio;
> >  extern unsigned long dirty_background_bytes;
> > --- linux-next.orig/mm/page-writeback.c	2011-06-19 22:56:18.000000000 +0800
> > +++ linux-next/mm/page-writeback.c	2011-06-19 22:59:29.000000000 +0800
> > @@ -116,6 +116,7 @@ EXPORT_SYMBOL(laptop_mode);
> >  
> >  /* End of sysctl-exported parameters */
> >  
> > +unsigned long global_dirty_limit;
> >  
> >  /*
> >   * Scale the writeback cache size proportional to the relative writeout speeds.
> > @@ -510,6 +511,43 @@ static void bdi_update_write_bandwidth(s
> >  	bdi->avg_write_bandwidth = avg;
> >  }
> >  
> > +static void update_dirty_limit(unsigned long thresh,
> > +				 unsigned long dirty)
> > +{
> > +	unsigned long limit = global_dirty_limit;
> > +
> > +	if (limit < thresh) {
> > +		limit = thresh;
> > +		goto update;
> > +	}
> > +
> > +	if (limit > thresh &&
> > +	    limit > dirty) {
> > +		limit -= (limit - max(thresh, dirty)) >> 5;
> > +		goto update;
> > +	}
> Hmm, but strictly speaking this never really converges to the new limit,
> right? And even in practice it takes 22 steps to converge within 50% and 73

Right, the ">> 5" may introduce 31 pages of steady state tracking error.
And 22/73 steps of 200ms means 4.4/14.6 seconds convergence time.

The tracking error is not more serious than the typical errors in
the dirty threshold checks, where there are per-cpu counter errors
and 8-pages error per CPU even after dirty exceeded.

The convergence time is not a sensitive parameter due to the reasons
detailed below.

> steps to converge withing 10% of the desired threshold. But before we get
> into the discussion about how to update dirty threshold, I'd like to
> discuss what are the properties we require from dirty threshold updates?

Good point. What we need is something optimized for the common case.
The common case is

(1) <= 500 dirtier tasks
(2) >= 80MB/s write bandwidth

Under conditions (1) and (2), it does not really matter whatever
tracking error or speed global_dirty_limit is after the dirtyable
memory is suddenly knocked down. Because the immediately lowered
dirty_thresh and bdi_thresh is enough to throttle each dirty task at
160KB/s and hence knock down the dirty pages fast enough.

So this patch (and the seemingly slow tracking speed) is not a big
change to the current behavior at all, especially for the heavy
dirtiers. It does help the light dirtiers to get out of the throttle
loop within 200ms (unless it's delayed by IO).

> I understand it's kind of unexpected that when some process allocates
> anonymous memory, we suddently stall writers to flush out dirty data. OTOH
> it is a nice behavior from memory management point of view because we
> really try to keep amount of dirty pages in free memory at given
> percentage which is nice for reclaim. When we choose to update dirty limit
> in steps as you propose, we get some kind of compromise between behavior
> for user and behavior for memory management.

We know for sure that "suddenly stall writers" will hurt responsiveness,
and probably never sure the exact dirty threshold will start hurting
page reclaim. So I opt to regard the "rule of thumb" dirty threshold
as some soft suggestion at the times we know for sure that obeying it
strictly will likely hurt.

> But there are also other options - for example it would seem natural to me
> treat allocation of anonymous page the same way as dirtiying the page thus
> the process getting us over dirty threshold due to allocations will wait
> until enough pages are written. Then we wouldn't need any smoothing of
> memory available for caches because allocations would be naturally
> throttled (OK, we still have memory taken by kernel allocations but these
> are order of magnitude smaller problem I'd say). But I'm not sure how
> acceptable this idea would be.

Oh no... It's already a headache how the dirty pages may slow down the
page reclaim, so no way for it to further slow down page allocations! ;)

Thanks,
Fengguang

> > +	return;
> > +update:
> > +	global_dirty_limit = limit;
> > +}
> > +
> > +static void global_update_bandwidth(unsigned long thresh,
> > +				    unsigned long dirty,
> > +				    unsigned long now)
> > +{
> > +	static DEFINE_SPINLOCK(dirty_lock);
> > +
> > +	if (now - default_backing_dev_info.bw_time_stamp < MAX_PAUSE)
> > +		return;
> > +
> > +	spin_lock(&dirty_lock);
> > +	if (now - default_backing_dev_info.bw_time_stamp >= MAX_PAUSE) {
> > +		update_dirty_limit(thresh, dirty);
> > +		default_backing_dev_info.bw_time_stamp = now;
> > +	}
> > +	spin_unlock(&dirty_lock);
> > +}
> > +
> >  void __bdi_update_bandwidth(struct backing_dev_info *bdi,
> >  			    unsigned long thresh,
> >  			    unsigned long dirty,
> > @@ -535,6 +573,9 @@ void __bdi_update_bandwidth(struct backi
> >  	if (elapsed > HZ && time_before(bdi->bw_time_stamp, start_time))
> >  		goto snapshot;
> >  
> > +	if (thresh)
> > +		global_update_bandwidth(thresh, dirty, now);
> > +
> >  	bdi_update_write_bandwidth(bdi, elapsed, written);
> >  
> >  snapshot:
> > 
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
