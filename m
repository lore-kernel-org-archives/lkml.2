Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab0KKWGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:06:43 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50629 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756236Ab0KKWGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:06:42 -0500
Subject: Re: [PATCH 04/10] tile: convert to use clocksource_register_hz
From: john stultz <johnstul@us.ibm.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4CDC5E70.90102@tilera.com>
References: <1288642350-1599-1-git-send-email-johnstul@us.ibm.com>
	 <1288642350-1599-5-git-send-email-johnstul@us.ibm.com>
	 <4CDC5E70.90102@tilera.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 14:06:16 -0800
Message-ID: <1289513176.2742.56.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 16:21 -0500, Chris Metcalf wrote:
> On 11/1/2010 4:12 PM, John Stultz wrote:
> > Convert tile to use clocksource_register_hz.
> >
> > Untested. Help from maintainers would be appreciated.
> >
> > CC: Chris Metcalf <cmetcalf@tilera.com>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: John Stultz <johnstul@us.ibm.com>
> > ---
> >  arch/tile/kernel/time.c |    5 +----
> >  1 files changed, 1 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
> > index 6bed820..8c06cb2 100644
> > --- a/arch/tile/kernel/time.c
> > +++ b/arch/tile/kernel/time.c
> > @@ -76,7 +76,6 @@ static struct clocksource cycle_counter_cs = {
> >  	.rating = 300,
> >  	.read = clocksource_get_cycles,
> >  	.mask = CLOCKSOURCE_MASK(64),
> > -	.shift = 22,   /* typical value, e.g. x86 tsc uses this */
> >  	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
> >  };
> 
> We were using clocksource_calc_mult_shift() for a while to compute both
> this value and our sched_clock() value, and, like
> clocksource_register_hz(), it suggested that a shift value of 31 was best.
> 
> Perhaps unsurprisingly, we saw wraparound with sched_clock(), which is why
> we use a fixed shift value of "10" to avoid problems.  This is clearly
> required since sched_clock() values are fairly long-lived.

Heh. This is the third case *today* of issues cropping up due to
sched_clock utilizing the timekeeping clocksource. Interesting
confluence of events.

Obviously the interactions here need some clarification and cleanup. :)

> I admit that I don't really understand what the wraparound implications of
> using a shift of "31" for the clocksource is, but since it will cause the
> clocksource to wrap around fairly quickly, I wanted to make sure this shift
> value was OK for whatever uses that clocksource is put to.  (The underlying
> clock in question is a 64-bit cycle counter, so with "<< 31" at e.g. 1 GHz
> it will wrap negative after about four seconds.)

Its not so much an issue of wraparound of the clocksource, but
multiplication overflow when we are using long cycle deltas.

The shift calculation works backwards from an software defined max time
delta, converts it to a cycle delta, then reduces it if the cycle
counter's own wrap limit is smaller. It then calculates the largest
shift value possible where the resulting mult for the given freq won't
cause an overflow from that max cycle delta.

This gives us the best freq estimate, and finest grained adjustment
ability for that defined max time delta. That the max time delta needs
to be centrally managed, as it provides the trade-off between fine
grained ntp adjustments and the maximum NOHZ time, so we don't want to
chase issues surrounding these tradeoffs all over different
architectures.

Now, almost all of the clocksource shift calculation code has been done
with concern around how frequently we call update_wall_time, which
accumulates cycles from the clocksource (allowing the clocksource to
wrap safely without losing time). 

Not much thought on my part has gone into the sched_clock usage of the
clocksource. Folks saw a good way to access a counter and a way to
convert it to ns, so it seemed reasonable, but I don't think the proper
consideration was given to the requirements of the sched_clock behavior.

In many cases sched_clock used its own counter-extension hacks, or
per-cpu offset calculations to allow faster-non-timekeeping acceptable
clocksources (like the TSC on some machines) to be used. Its a bit more
of an arch specific thing, so there's more chances for it to go wrong
somewhere.

So some quick questions for Peter and Ingo to help clarify this:

1) How often is sched_clock guaranteed to be called? Once each tick, (so
the maximum time in nohz mode would be reasonable?)

2) What considerations for sched_clock wrapping is there in generic
code? I see some considerations in kernel/sched_clock.c, but its not
obvious the limits. On x86, the 64-bit TSC won't wrap (but might jump on
non-synced systems, or halt in idle modes). Do architectures that have
faster-wrapping counters need to handle the cycle accumulation
internally?

3) If there is generic code to handle counter wrapping, what is the
limit of the length of time that a old sched_clock value might be around
for before being updated? In other words, if there was a second granular
counter that wrapped every minute, you wouldn't want to compare two
values that were longer then a minute apart. So if that was scaled down
to counter frequencies, how long might it be between storing a
sched_clock reference and using it?


Chris: Thanks for pointing out this issue!

thanks
-john

