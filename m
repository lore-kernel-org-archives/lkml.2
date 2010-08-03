Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab0HCPLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:11:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:57461 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756521Ab0HCPLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:11:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,309,1278313200"; 
   d="scan'208";a="307666630"
Date: Tue, 3 Aug 2010 23:10:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] writeback: avoid unnecessary calculation of bdi
 dirty thresholds
Message-ID: <20100803151051.GA842@localhost>
References: <20100711020656.340075560@intel.com>
 <20100711021748.879183413@intel.com>
 <1280847822.1923.597.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280847822.1923.597.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 11:03:42PM +0800, Peter Zijlstra wrote:
> On Sun, 2010-07-11 at 10:06 +0800, Wu Fengguang wrote:
> > plain text document attachment (writeback-less-bdi-calc.patch)
> > Split get_dirty_limits() into global_dirty_limits()+bdi_dirty_limit(),
> > so that the latter can be avoided when under global dirty background
> > threshold (which is the normal state for most systems).
> 
> The patch looks OK, although esp with the proposed comments in the
> follow up email, bdi_dirty_limit() gets a bit confusing wrt to how and
> what the limit is.
> 
> Maybe its clearer to not call task_dirty_limit() from bdi_dirty_limit(),
> that way the comment can focus on the device write request completion
> proportion thing.
> 
> > +unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
> > +			       unsigned long dirty)
> > +{
> > +	u64 bdi_dirty;
> > +	long numerator, denominator;
> >  
> > +	/*
> > +	 * Calculate this BDI's share of the dirty ratio.
> > +	 */
> > +	bdi_writeout_fraction(bdi, &numerator, &denominator);
> >  
> > +	bdi_dirty = (dirty * (100 - bdi_min_ratio)) / 100;
> > +	bdi_dirty *= numerator;
> > +	do_div(bdi_dirty, denominator);
> >  
> > +	bdi_dirty += (dirty * bdi->min_ratio) / 100;
> > +	if (bdi_dirty > (dirty * bdi->max_ratio) / 100)
> > +		bdi_dirty = dirty * bdi->max_ratio / 100;
> > +
>   +       return bdi_dirty;
> >  }
> 
> And then add the call to task_dirty_limit() here:
> 
> > +++ linux-next/mm/backing-dev.c	2010-07-11 08:53:44.000000000 +0800
> > @@ -83,7 +83,8 @@ static int bdi_debug_stats_show(struct s
> >  		nr_more_io++;
> >  	spin_unlock(&inode_lock);
> >  
> > -	get_dirty_limits(&background_thresh, &dirty_thresh, &bdi_thresh, bdi);
> > +	global_dirty_limits(&background_thresh, &dirty_thresh);
> > +	bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
>   +       bdi_thresh = task_dirty_limit(current, bdi_thresh);
> 
> And add a comment to task_dirty_limit() as well, explaining its reason
> for existence (protecting light/slow dirtying tasks from heavier/fast
> ones).

Good suggestions, that would be much less confusing. Will post updated
patches tomorrow.

Thanks,
Fengguang
