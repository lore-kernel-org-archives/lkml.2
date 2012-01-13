Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986Ab2AMTuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 14:50:17 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:49927 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758973Ab2AMTuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 14:50:10 -0500
Message-ID: <1326484191.4416.16.camel@work-vm>
Subject: Re: Unexpected clocksource overflow in nsec conversion
From: John Stultz <john.stultz@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Date: Fri, 13 Jan 2012 11:49:51 -0800
In-Reply-To: <20120113162132.GH4176@mudshark.cambridge.arm.com>
References: <20120113162132.GH4176@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12011319-5518-0000-0000-000001858D60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-13 at 16:21 +0000, Will Deacon wrote:
> Hi Thomas, John,
> 
> I'm having some problems with sched_clock where I experience unexpected
> overflow due to clocksource->mult being set too high for the width of my
> clocksource.
> 
> My clocksource parameters are:
> 
> 	Frequency:	100Mhz
> 	Width:		56 bits (i.e. mask of (1 << 56) - 1)
> 
> 	[ following calculated by clocks_calc_mult_shift ]
> 	Shift:		24
> 	Mult:		0x0a000000 (167772160)


Sigh. Yea. In the past, occasional sched_clock rollovers weren't an
issue, the idea was it was an potentially unreliable clock, but really
fast, and any errors would be fleeting. But over time sched_clock's
requirement have grown.

I think you probably need to split the sched clock mult/shift pair from
the clocksource, as they really have different requirements.  The
clocksource needs to have a larger shift value, so we can make fine
grained adjustments to keep accurate time, where as sched_clock should
have a low shift value to avoid frequent overflows.

Even so, the sched clock code doesn't do any sort of periodic
accumulation, so overflows either at the counter level or at the
multiply level when the counter gets large enough (see recent 208 day
bugs on x86) will crop up eventually.

The hard part is that the locking required to do periodic accumulation
goes contrary to what sched_clock is all about.


> The reason for the huge multiplier seems to be this code in
> __clocksource_updatefreq_scale:
> 
> 
> void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
> {
> 	u64 sec;
> 
> 	/*
> 	 * Calc the maximum number of seconds which we can run before
> 	 * wrapping around. For clocksources which have a mask > 32bit
> 	 * we need to limit the max sleep time to have a good
> 	 * conversion precision. 10 minutes is still a reasonable
> 	 * amount. That results in a shift value of 24 for a
> 	 * clocksource with mask >= 40bit and f >= 4GHz. That maps to
> 	 * ~ 0.06ppm granularity for NTP. We apply the same 12.5%
> 	 * margin as we do in clocksource_max_deferment()
> 	 */
> 	sec = (cs->mask - (cs->mask >> 3));
> 	do_div(sec, freq);
> 	do_div(sec, scale);
> 	if (!sec)
> 		sec = 1;
> 	else if (sec > 600 && cs->mask > UINT_MAX)
> 		sec = 600;
> 
> 
> where we truncate the maximum period to 10 minutes in order to improve
> the precision. Since we don't update cs->mask, doesn't this leave us in
> a situation where the clocksource can overflow in the ns domain without
> overflowing in terms of ticks? I can certainly trigger this situation
> with my counter, which results in negative exec_runtimes for tasks, leading
> to nasty scheduling issues. When the clocksource passes from 0x199997b3cd
> to 0x1999a6e97c, the time (ns) unexpectedly wraps from 0xffffed0602 to
> 0x851ed8.
> 
> So, should we update the clocksource mask when forcing the maximum period
> to 600 seconds, or am I missing something?

No. The logic about is really focused around timekeeping requirements,
not sched_clock. With timekeeping we periodicially accumulate time,
creating a new cycle_last base from which we generate cycle deltas with.
This keeps the cycle portion that is multiplied small.

Again, sched_clock doesn't accumulate, so when the counter gets large
enough, the multiply can overflow. On x86 we've split the multiply to
avoid this for now, but this doesn't help on other architectures where
the counter overflows.

So this area definitely needs work, and unfortunately I've not had much
time to work on it.

For a short-term solution, you can maybe look at enabling
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK and setting sched_clock_stable to 0.
This will probably be necessary on any arch using clocksources logic for
sched_clock.

thanks
-john

