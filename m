Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab1EEOKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 10:10:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:5393 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755236Ab1EEOKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 10:10:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,319,1301900400"; 
   d="scan'208";a="638485495"
Date: Thu, 5 May 2011 22:10:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/3] writeback: avoid extra sync work at enqueue time
Message-ID: <20110505141039.GC9409@localhost>
References: <20110502031750.135798606@intel.com>
 <20110502033035.789279347@intel.com>
 <20110504212427.GI6968@quack.suse.cz>
 <20110505122732.GC1294@localhost>
 <20110505140134.GF5323@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505140134.GF5323@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 10:01:34PM +0800, Jan Kara wrote:
> On Thu 05-05-11 20:27:32, Wu Fengguang wrote:
> > On Thu, May 05, 2011 at 05:24:27AM +0800, Jan Kara wrote:
> > > On Mon 02-05-11 11:17:53, Wu Fengguang wrote:
> > > > This removes writeback_control.wb_start and does more straightforward
> > > > sync livelock prevention by setting .older_than_this to prevent extra
> > > > inodes from being enqueued in the first place.
> > > > 
> > > > --- linux-next.orig/fs/fs-writeback.c	2011-05-02 11:17:24.000000000 +0800
> > > > +++ linux-next/fs/fs-writeback.c	2011-05-02 11:17:27.000000000 +0800
> > > > @@ -683,10 +672,12 @@ static long wb_writeback(struct bdi_writ
> > > >  	 *                   (quickly) tag currently dirty pages
> > > >  	 *                   (maybe slowly) sync all tagged pages
> > > >  	 */
> > > > -	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_sync)
> > > > +	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_sync) {
> > > >  		write_chunk = LONG_MAX;
> > > > +		oldest_jif = jiffies;
> > > > +		wbc.older_than_this = &oldest_jif;
> > > > +	}
> > >   What are the implications of not doing dirty-time livelock avoidance for
> > > other types of writeback? Is that a mistake? I'd prefer to have in
> > > wb_writeback():
> > > if (wbc.for_kupdate)
> > > 	oldest_jif = jiffies - msecs_to_jiffies(dirty_expire_interval * 10);
> > > else
> > > 	oldest_jif = jiffies;
> > > wbc.older_than_this = &oldest_jif;
> > > 
> > > And when you have this, you can make wbc.older_than_this just a plain
> > > number and remove all those checks for wbc.older_than_this == NULL.
> > 
> > Good point. Here is the fixed patch. Will you send the patch to change
> > the type when the current patches are settled down?
>   OK, I will do that.

Thank you.

> > @@ -686,7 +674,9 @@ static long wb_writeback(struct bdi_writ
> >  	if (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_sync)
> >  		write_chunk = LONG_MAX;
> >  
> > -	wbc.wb_start = jiffies; /* livelock avoidance */
> > +	oldest_jif = jiffies;
> > +	wbc.older_than_this = &oldest_jif;
> > +
>   I might be already confused with all the code moving around but won't
> this overwrite the value set for the for_kupdate case?

It's the opposite -- it will be overwritten inside the loop by
for_kupdate, which may run for long time and hence need to update
oldest_jif from time to time.

Thanks,
Fengguang
