Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab0DXUuX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 16:50:23 -0400
Received: from bar.sig21.net ([80.81.252.164]:36928 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab0DXUuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 16:50:20 -0400
Date: Sat, 24 Apr 2010 22:50:11 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Magnus Damm <damm@opensource.se>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Q: sched_clock() vs. clocksource, how to implement correctly
Message-ID: <20100424205011.GA21632@sig21.net>
References: <20100423150917.GA25714@sig21.net>
 <20100423182933.0df45b53@mschwide.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423182933.0df45b53@mschwide.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.783,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 06:29:33PM +0200, Martin Schwidefsky wrote:
> On Fri, 23 Apr 2010 17:09:17 +0200 > Johannes Stezenbach <js@sig21.net> wrote:
> > 
> > - Isn't sched_clock() supposed to be extended to 64bit so
> >   that it practically never wraps?
> >   (old implementations use cnt32_to_63())
> 
> Yes, sched_clock() is supposed to return a monotonic timestamp.

OK, searching LXR for sched_clock, I think serveral
sched_clock() implementations across architectures
have the wrapping issue.

BTW, wrapping sched_clock() also causes printk() timestamps to
wrap, so the problem should be easy to spot.

> > - What would be the effect on scheduling when sched_clock() wraps?
> 
> It would confuse the process accounting and the scheduling I guess.

That's a bit vague ;-/
Let's try that: Could it cause processes calling e.g. nanosleep()
to sleep much longer than intended (e.g. until sched_clock() wraps
again)?   Or can it only cause a momentary scheduler hickup,
i.e. the scheduler might make one wrong scheduling decision
per sched_clock() wrap?  Given that there are serveral platforms
with wrapping sched_clock() I guess the latter.

> > - Is struct timecounter + struct cyclecounter + timecounter_read()
> >   designated way to implement sched_clock() with a 32bit hw counter?
> > 
> >   arch/microblaze/kernel/timer.c seems to be the only user
> >   of timecounter/cyclecounter in arch/, but I don't get what it does.
> > 
> >   Or is it better to stick with cnt32_to_63()?
> 
> cnt32_to_63() is a way to extend the 32 bit clocksource to a useable
> sched_clock() provider. One way or the other you have to extend the 32
> bits of the 1MHz counter to something bigger. The obvious way is to
> count the number of wraps and use this number as the upper 32 bits
> just like cnt32_to_63() does. You just have to make sure that the
> clocksource is read frequently enough to get all the wraps. A non-idle
> cpu will tick with HZ frequency and the clock will be read often
> enough, for an idle cpu the maximum sleep time needs to be limited.

Somehow I got the impression that cnt32_to_63() is old-style,
and using clocksource_cyc2ns() is new-style.  Essentially I wanted to
avoid the do_div() in sched_clock() (like e.g. in
arm/mach-versatile/core.c), and just using clocksource_cyc2ns()
looked simple and elegant.  Bummer that it's wrong.

It seems that arch/arm/plat-orion/time.c is about the only
one which gets it completely right according to your description.
I'll quote it here for discussion:

/*
 * Orion's sched_clock implementation. It has a resolution of
 * at least 7.5ns (133MHz TCLK) and a maximum value of 834 days.
 *
 * Because the hardware timer period is quite short (21 secs if
 * 200MHz TCLK) and because cnt32_to_63() needs to be called at
 * least once per half period to work properly, a kernel timer is
 * set up to ensure this requirement is always met.
 */
#define TCLK2NS_SCALE_FACTOR 8

static unsigned long tclk2ns_scale;

unsigned long long sched_clock(void)
{
	unsigned long long v = cnt32_to_63(0xffffffff - readl(TIMER0_VAL));
	return (v * tclk2ns_scale) >> TCLK2NS_SCALE_FACTOR;
}

static struct timer_list cnt32_to_63_keepwarm_timer;

static void cnt32_to_63_keepwarm(unsigned long data)
{
	mod_timer(&cnt32_to_63_keepwarm_timer, round_jiffies(jiffies + data));
	(void) sched_clock();
}

static void __init setup_sched_clock(unsigned long tclk)
{
	unsigned long long v;
	unsigned long data;

	v = NSEC_PER_SEC;
	v <<= TCLK2NS_SCALE_FACTOR;
	v += tclk/2;
	do_div(v, tclk);
	/*
	 * We want an even value to automatically clear the top bit
	 * returned by cnt32_to_63() without an additional run time
	 * instruction. So if the LSB is 1 then round it up.
	 */
	if (v & 1)
		v++;
	tclk2ns_scale = v;

	data = (0xffffffffUL / tclk / 2 - 2) * HZ;
	setup_timer(&cnt32_to_63_keepwarm_timer, cnt32_to_63_keepwarm, data);
	mod_timer(&cnt32_to_63_keepwarm_timer, round_jiffies(jiffies + data));
}


BTW, even though this uses TCLK2NS_SCALE_FACTOR of 8, the same file
uses a shift vaue of 20 for the orion_clksrc...


Thanks,
Johannes
