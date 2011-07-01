Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab1GAMDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:03:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:55780 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842Ab1GAMDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:03:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,457,1304319600"; 
   d="scan'208";a="21452964"
Date: Fri, 1 Jul 2011 20:03:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] writeback: make writeback_control.nr_to_write
 straight
Message-ID: <20110701120339.GA8475@localhost>
References: <20110629145245.835998321@intel.com>
 <20110629145553.642570515@intel.com>
 <20110630162457.GH28475@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110630162457.GH28475@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   Just one minor nit:
> 
> > @@ -570,17 +622,25 @@ static int writeback_sb_inodes(struct su
> >  		iput(inode);
> >  		cond_resched();
> >  		spin_lock(&wb->list_lock);
> > -		if (wbc->nr_to_write <= 0)
> > -			return 1;
> > +		/*
> > +		 * bail out to wb_writeback() often enough to check
> > +		 * background threshold and other termination conditions.
> > +		 */
> > +		if (wrote) {
> > +			if (jiffies - start_time > HZ / 10UL)
> > +				break;
>   I guess this comparison should use time_before() macro - or maybe even
> time_is_before_jiffies().

Fair enough. Changed to:

        if (time_is_before_jiffies(start_time + HZ / 10UL))

> > +			if (work->nr_pages <= 0)
> > +				break;
> > +		}
> >  	}
> > -	/* b_io is empty */
> > -	return 1;
> > +	return wrote;
> >  }
> >  
> > -static void __writeback_inodes_wb(struct bdi_writeback *wb,
> > -				  struct writeback_control *wbc)
> > +static long __writeback_inodes_wb(struct bdi_writeback *wb,
> > +				  struct wb_writeback_work *work)
> >  {
> > -	int ret = 0;
> > +	unsigned long start_time = jiffies;
> > +	long wrote = 0;
> >  
> >  	while (!list_empty(&wb->b_io)) {
> >  		struct inode *inode = wb_inode(wb->b_io.prev);
> > @@ -590,33 +650,37 @@ static void __writeback_inodes_wb(struct
> >  			requeue_io(inode, wb);
> >  			continue;
> >  		}
> > -		ret = writeback_sb_inodes(sb, wb, wbc, false);
> > +		wrote += writeback_sb_inodes(sb, wb, work);
> >  		drop_super(sb);
> >  
> > -		if (ret)
> > -			break;
> > +		/* refer to the same tests at the end of writeback_sb_inodes */
> > +		if (wrote) {
> > +			if (jiffies - start_time > HZ / 10UL)
> > +				break;
>   And the same here.

Changed together. Thanks for the review!

Fengguang
