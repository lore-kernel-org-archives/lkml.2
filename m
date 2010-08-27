Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab0H0JUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:20:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48285 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab0H0JUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:20:19 -0400
Date: Fri, 27 Aug 2010 10:20:04 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] writeback: Record if the congestion was unnecessary
Message-ID: <20100827092003.GA19556@csn.ul.ie>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie> <1282835656-5638-3-git-send-email-mel@csn.ul.ie> <20100826182904.GC6805@cmpxchg.org> <20100826203130.GL20944@csn.ul.ie> <1282875130.17594.2.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1282875130.17594.2.camel@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 10:12:10AM +0800, Shaohua Li wrote:
> On Fri, 2010-08-27 at 04:31 +0800, Mel Gorman wrote:
> > On Thu, Aug 26, 2010 at 08:29:04PM +0200, Johannes Weiner wrote:
> > > On Thu, Aug 26, 2010 at 04:14:15PM +0100, Mel Gorman wrote:
> > > > If congestion_wait() is called when there is no congestion, the caller
> > > > will wait for the full timeout. This can cause unreasonable and
> > > > unnecessary stalls. There are a number of potential modifications that
> > > > could be made to wake sleepers but this patch measures how serious the
> > > > problem is. It keeps count of how many congested BDIs there are. If
> > > > congestion_wait() is called with no BDIs congested, the tracepoint will
> > > > record that the wait was unnecessary.
> > > 
> > > I am not convinced that unnecessary is the right word.  On a workload
> > > without any IO (i.e. no congestion_wait() necessary, ever), I noticed
> > > the VM regressing both in time and in reclaiming the right pages when
> > > simply removing congestion_wait() from the direct reclaim paths (the
> > > one in __alloc_pages_slowpath and the other one in
> > > do_try_to_free_pages).
> > > 
> > > So just being stupid and waiting for the timeout in direct reclaim
> > > while kswapd can make progress seemed to do a better job for that
> > > load.
> > > 
> > > I can not exactly pinpoint the reason for that behaviour, it would be
> > > nice if somebody had an idea.
> > > 
> > 
> > There is a possibility that the behaviour in that case was due to flusher
> > threads doing the writes rather than direct reclaim queueing pages for IO
> > in an inefficient manner. So the stall is stupid but happens to work out
> > well because flusher threads get the chance to do work.
>
> If this is the case, we already have queue congested.

Not necessarily. The fact that with the full series we sometimes call
cond_sched() indicating that there was no congestion when congestion_wait()
was called proves that. We might have some IO on the queue but it's not
congested. Also, there is no guarantee that the congested queue is one we
care about. If we are reclaiming main memory and the congested queue is a
USB stick, we do not necessarily need to stall.

> removing
> congestion_wait() might cause regression but either your change or the
> congestion_wait_check() should not have the regression, as we do check
> if the bdi is congested.
> 

What congestion_wait_check()? If there is no congestion and no writes,
congestion is the wrong event to sleep on.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
