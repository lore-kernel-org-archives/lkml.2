Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab1BWRpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:45:07 -0500
Received: from gir.skynet.ie ([193.1.99.77]:43657 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab1BWRpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:45:05 -0500
Date: Wed, 23 Feb 2011 17:44:37 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>,
        Clemens Ladisch <cladisch@googlemail.com>,
        alsa-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified -
	5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in
	kswapd for GFP_ATOMIC order > 0
Message-ID: <20110223174436.GM15652@csn.ul.ie>
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net> <4D6367B3.9050306@googlemail.com> <20110222134047.GT13092@random.random> <20110222161513.GC13092@random.random> <4D63F6C0.7060204@internode.on.net> <20110223162432.GL31195@random.random> <20110223171047.GL15652@csn.ul.ie> <20110223172734.GR31195@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110223172734.GR31195@random.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 06:27:34PM +0100, Andrea Arcangeli wrote:
> On Wed, Feb 23, 2011 at 05:10:47PM +0000, Mel Gorman wrote:
> > On Wed, Feb 23, 2011 at 05:24:32PM +0100, Andrea Arcangeli wrote:
> > > On Wed, Feb 23, 2011 at 04:17:44AM +1030, Arthur Marsh wrote:
> > > > OK, these patches applied together against upstream didn't cause a crash 
> > > > but I did observe:
> > > > 
> > > > significant slowdowns of MIDI playback (moreso than in previous cases, 
> > > > and with less than 20 Meg of swap file in use);
> > > > 
> > > > kswapd0 sharing equal top place in CPU usage at times (e.g. 20 percent).
> > > > 
> > > > If I should try only one of the patches or something else entirely, 
> > > > please let me know.
> > > 
> > > Yes, with irq off, schedule won't run and need_resched won't get set.
> > > 
> > 
> > Stepping back a little, how did you determine that isolate_migrate was the
> > major problem? In my initial tests using the irqsoff tracer (sampled for
> > the duration fo the test every few seconds and resetting the max latency
> > each time), compaction_alloc() was a far worse source of problems and
> > isolate_migratepage didn't even register. It might be that I'm not testing
> > on large enough machines though.
> 
> I think you're right compaction_alloc is a bigger problem. Your patch
> to isolate_freepages is a must have and in the right direction.
> 

Nice one.

> However I think having large areas set as PageBuddy may be common too,
> the irq latency source in isolated_migratepages I think needs fixing
> too. We must be guaranteed to release irqs after max N pages (where N
> is SWAP_CLUSTER_MAX in my last two patches).
> 

Your logic makes sense and I can see why it might not necessarily show
up in my tests. I was simply wondering if you spotted the problem
directly or from looking at teh source.

> > In another mail, I posted a patch that dealt with compaction_alloc after
> > finding that IRQs were being disabled for millisecond lengths of time.
> > That length of time for IRQs being disabled could account for the performance
> > loss on the network load. Can test the network load with it applied?
> 
> kswapd was also running at 100% on all CPUs in that test.
> 

On the plus side, the patch I posted also reduces kswapd CPU time.
Graphing CPU usage over time, I saw the following;

http://www.csn.ul.ie/~mel/postings/compaction-20110223/kswapdcpu-smooth-hydra.ps

i.e. CPU usage of kswapd is also reduced. The graph is smoothened because
the raw figures are so jagged as to be almost impossible to read. The z1
patches and others could also further reduce it (I haven't measured it yet)
but I thought it was interesting that IRQs being disabled for long periods
also contribed so heavily to kswapd CPU usage.

> The z1 that doesn't fix the latency source in compaction but that
> removes compaction from kswapd (a light/hackish version of
> compaction-no-kswapd-3 that I just posted) fixes the problem
> completely for the network load too.
> 

Ok. If necessary we can disable it entirely for this cycle but as I'm
seeing large sources of IRQ disabled latency in compaction and
shrink_inactive_list, it'd be nice to get that ironed out while the
problem is obvious too.

> So clearly it's not only a problem we can fix in compaction, the irq
> latency will improve for sure, but we still get an overload from
> kswapd which is not ok I think.
> 

Indeed not. 

> What I am planning to test on the network load is
> high-wmark+compaction_alloc_lowlat+compaction-kswapd-3 vs
> high-wmark+compaction_alloc_lowlat+compaction-no-kswapd-2.
> 
> Is this ok?

Sure to see what the results are. I'm still hoping we can prove the high-wmark
unnecessary due to Rik's naks. His reasoning about the corner cases it
potentially introduces is hard, if not impossible, to disprove.

> If you want I can test also
> high-wmark+compaction_alloc_lowlat without
> compaction-kswapd-3/compaction-no-kswapd-2 but I think the irq-latency
> source in isolate_migratepages in presence of large PageBuddy regions
> (after any large application started at boot quits) isn't ok.

Can you ditch all these patches in a directory somewhere because I'm
getting confused as to which patch is which exactly :)

> Also I
> think having kswapd at 100% cpu load isn't ok. So I doubt we should
> stop at compaction_alloc_lowlat.
> 

kswapd at 100% CPU is certainly unsuitable but would like to be sure we
are getting it down the right way without reintroducing the problems
this 8*high_wmark check fixed.

-- 
Mel Gorman
SUSE Labs
