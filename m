Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1EEMdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:33:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:37924 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab1EEMdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:33:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,319,1301900400"; 
   d="scan'208";a="638444726"
Date: Thu, 5 May 2011 20:33:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 6/6] writeback: convert to relative older_than_this in
 trace events
Message-ID: <20110505123303.GD1294@localhost>
References: <20110504091707.910929441@intel.com>
 <20110504091909.904141006@intel.com>
 <20110504222333.GL6968@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504222333.GL6968@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 06:23:33AM +0800, Jan Kara wrote:
> On Wed 04-05-11 17:17:13, Wu Fengguang wrote:
> > This is a format change that could break established scripts.
> > 
> > But hopefully it's more human friendly to show the relative values like
> > "30000" (30s old) or "0" (all fresh ones) than long absolute jiffy
> > numbers.
>   It's possibly more human friendly but probably also harder to handle in
> scripts. I especially don't like the fact that the number will be changing
> at different tracepoints - you'll then have to do some comparisons to find
> out whether just the timestamp has been changed or whether just the time
> passes by. It's not that hard to write a script doing absolute->relative
> conversion (since you have time stamps in the traces) for those cases where
> relative time is really what interests you.

OK.

> So do you have any particular usecase in mind for the relative
> value?

I normally just look at the raw traces in which case the raw jiffies
mean nothing to me. Or sometimes plot the relative dirty ages with
scripts.

Thanks,
Fengguang

> > Note that the initial 30000 or 0 may increase over time as they are now
> > relative numbers.
> > 
> > CC: Jan Kara <jack@suse.cz>
> > CC: Dave Chinner <david@fromorbit.com> 
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  include/trace/events/writeback.h |   11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > --- linux-next.orig/include/trace/events/writeback.h	2011-05-04 16:09:59.000000000 +0800
> > +++ linux-next/include/trace/events/writeback.h	2011-05-04 16:10:57.000000000 +0800
> > @@ -115,7 +115,7 @@ DECLARE_EVENT_CLASS(wbc_class,
> >  		__field(int, for_reclaim)
> >  		__field(int, range_cyclic)
> >  		__field(int, more_io)
> > -		__field(unsigned long, older_than_this)
> > +		__field(int, older)
> >  		__field(long, range_start)
> >  		__field(long, range_end)
> >  	),
> > @@ -130,14 +130,15 @@ DECLARE_EVENT_CLASS(wbc_class,
> >  		__entry->for_reclaim	= wbc->for_reclaim;
> >  		__entry->range_cyclic	= wbc->range_cyclic;
> >  		__entry->more_io	= wbc->more_io;
> > -		__entry->older_than_this = wbc->older_than_this ?
> > -						*wbc->older_than_this : 0;
> > +		__entry->older		= wbc->older_than_this ?
> > +				(jiffies - *wbc->older_than_this) * 1000 / HZ
> > +				: -1;
> >  		__entry->range_start	= (long)wbc->range_start;
> >  		__entry->range_end	= (long)wbc->range_end;
> >  	),
> >  
> >  	TP_printk("bdi %s: towrt=%ld skip=%ld mode=%d kupd=%d "
> > -		"bgrd=%d reclm=%d cyclic=%d more=%d older=0x%lx "
> > +		"bgrd=%d reclm=%d cyclic=%d more=%d older=%d "
> >  		"start=0x%lx end=0x%lx",
> >  		__entry->name,
> >  		__entry->nr_to_write,
> > @@ -148,7 +149,7 @@ DECLARE_EVENT_CLASS(wbc_class,
> >  		__entry->for_reclaim,
> >  		__entry->range_cyclic,
> >  		__entry->more_io,
> > -		__entry->older_than_this,
> > +		__entry->older,
> >  		__entry->range_start,
> >  		__entry->range_end)
> >  )
> > 
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
