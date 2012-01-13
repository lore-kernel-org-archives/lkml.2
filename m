Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468Ab2AMQVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 11:21:39 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60575 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857Ab2AMQVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 11:21:37 -0500
Date: Fri, 13 Jan 2012 16:21:33 +0000
From: Will Deacon <will.deacon@arm.com>
To: john.stultz@linaro.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: Unexpected clocksource overflow in nsec conversion
Message-ID: <20120113162132.GH4176@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas, John,

I'm having some problems with sched_clock where I experience unexpected
overflow due to clocksource->mult being set too high for the width of my
clocksource.

My clocksource parameters are:

	Frequency:	100Mhz
	Width:		56 bits (i.e. mask of (1 << 56) - 1)

	[ following calculated by clocks_calc_mult_shift ]
	Shift:		24
	Mult:		0x0a000000 (167772160)

The reason for the huge multiplier seems to be this code in
__clocksource_updatefreq_scale:


void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
{
	u64 sec;

	/*
	 * Calc the maximum number of seconds which we can run before
	 * wrapping around. For clocksources which have a mask > 32bit
	 * we need to limit the max sleep time to have a good
	 * conversion precision. 10 minutes is still a reasonable
	 * amount. That results in a shift value of 24 for a
	 * clocksource with mask >= 40bit and f >= 4GHz. That maps to
	 * ~ 0.06ppm granularity for NTP. We apply the same 12.5%
	 * margin as we do in clocksource_max_deferment()
	 */
	sec = (cs->mask - (cs->mask >> 3));
	do_div(sec, freq);
	do_div(sec, scale);
	if (!sec)
		sec = 1;
	else if (sec > 600 && cs->mask > UINT_MAX)
		sec = 600;


where we truncate the maximum period to 10 minutes in order to improve
the precision. Since we don't update cs->mask, doesn't this leave us in
a situation where the clocksource can overflow in the ns domain without
overflowing in terms of ticks? I can certainly trigger this situation
with my counter, which results in negative exec_runtimes for tasks, leading
to nasty scheduling issues. When the clocksource passes from 0x199997b3cd
to 0x1999a6e97c, the time (ns) unexpectedly wraps from 0xffffed0602 to
0x851ed8.

So, should we update the clocksource mask when forcing the maximum period
to 600 seconds, or am I missing something?

Cheers,

Will
