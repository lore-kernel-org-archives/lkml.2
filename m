Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751058Ab2AOPON (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 10:14:13 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47799 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750732Ab2AOPOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 10:14:12 -0500
Date: Sun, 15 Jan 2012 15:14:03 +0000
From: Will Deacon <will.deacon@arm.com>
To: John Stultz <john.stultz@linaro.org>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Unexpected clocksource overflow in nsec conversion
Message-ID: <20120115151403.GB7474@mudshark.cambridge.arm.com>
References: <20120113162132.GH4176@mudshark.cambridge.arm.com>
 <1326484191.4416.16.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326484191.4416.16.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 07:49:51PM +0000, John Stultz wrote:
> On Fri, 2012-01-13 at 16:21 +0000, Will Deacon wrote:
> > I'm having some problems with sched_clock where I experience unexpected
> > overflow due to clocksource->mult being set too high for the width of my
> > clocksource.
> > 
> > My clocksource parameters are:
> > 
> > 	Frequency:	100Mhz
> > 	Width:		56 bits (i.e. mask of (1 << 56) - 1)
> > 
> > 	[ following calculated by clocks_calc_mult_shift ]
> > 	Shift:		24
> > 	Mult:		0x0a000000 (167772160)
> 
> 
> Sigh. Yea. In the past, occasional sched_clock rollovers weren't an
> issue, the idea was it was an potentially unreliable clock, but really
> fast, and any errors would be fleeting. But over time sched_clock's
> requirement have grown.
> 
> I think you probably need to split the sched clock mult/shift pair from
> the clocksource, as they really have different requirements.  The
> clocksource needs to have a larger shift value, so we can make fine
> grained adjustments to keep accurate time, where as sched_clock should
> have a low shift value to avoid frequent overflows.

Ah, ok then. The hardware counter I'm using is guaranteed not to roll over
within 40 years, so I'm happy to ignore hardware overflow at the moment. So
if I avoid using clocksource_cyc2ns from sched_clock then I can also avoid
the large multiplier.

> > So, should we update the clocksource mask when forcing the maximum period
> > to 600 seconds, or am I missing something?
> 
> No. The logic about is really focused around timekeeping requirements,
> not sched_clock. With timekeeping we periodicially accumulate time,
> creating a new cycle_last base from which we generate cycle deltas with.
> This keeps the cycle portion that is multiplied small.

Right - as long as the timekeeping stuff only uses periods of up to 10
minutes then we're safe (rather than looking at the clocksource mask,
for example).

> Again, sched_clock doesn't accumulate, so when the counter gets large
> enough, the multiply can overflow. On x86 we've split the multiply to
> avoid this for now, but this doesn't help on other architectures where
> the counter overflows.

Given that the CPU I'm working with has hardware integer division, I guess I
could just return ticks * (NSEC_PER_SEC / freq) in my sched clock and forget
about the scaling maths?

Cheers,

Will
