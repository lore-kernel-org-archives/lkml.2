Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab1BWRLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:11:17 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40706 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab1BWRLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:11:16 -0500
Date: Wed, 23 Feb 2011 17:10:47 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>,
        Clemens Ladisch <cladisch@googlemail.com>,
        alsa-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified -
	5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in
	kswapd for GFP_ATOMIC order > 0
Message-ID: <20110223171047.GL15652@csn.ul.ie>
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net> <4D6367B3.9050306@googlemail.com> <20110222134047.GT13092@random.random> <20110222161513.GC13092@random.random> <4D63F6C0.7060204@internode.on.net> <20110223162432.GL31195@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110223162432.GL31195@random.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 05:24:32PM +0100, Andrea Arcangeli wrote:
> On Wed, Feb 23, 2011 at 04:17:44AM +1030, Arthur Marsh wrote:
> > OK, these patches applied together against upstream didn't cause a crash 
> > but I did observe:
> > 
> > significant slowdowns of MIDI playback (moreso than in previous cases, 
> > and with less than 20 Meg of swap file in use);
> > 
> > kswapd0 sharing equal top place in CPU usage at times (e.g. 20 percent).
> > 
> > If I should try only one of the patches or something else entirely, 
> > please let me know.
> 
> Yes, with irq off, schedule won't run and need_resched won't get set.
> 

Stepping back a little, how did you determine that isolate_migrate was the
major problem? In my initial tests using the irqsoff tracer (sampled for
the duration fo the test every few seconds and resetting the max latency
each time), compaction_alloc() was a far worse source of problems and
isolate_migratepage didn't even register. It might be that I'm not testing
on large enough machines though.

> So let's try this.
> 
> In case this doesn't fix I definitely give it up with compaction in
> kswapd as GFP_ATOMIC will likely not get an huge benefit out of
> compaction anyway because 1) the allocations from GFP_ATOMIC are
> likely short lived, 2) the cost of the compaction scan loop +
> migration may be higher than the benefit we get from jumbo frames
> 

In another mail, I posted a patch that dealt with compaction_alloc after
finding that IRQs were being disabled for millisecond lengths of time.
That length of time for IRQs being disabled could account for the performance
loss on the network load. Can test the network load with it applied?

> <SNIP>

-- 
Mel Gorman
SUSE Labs
