Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab0DWQ3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:29:39 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:47507 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab0DWQ3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:29:37 -0400
Date: Fri, 23 Apr 2010 18:29:33 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Magnus Damm <damm@opensource.se>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Q: sched_clock() vs. clocksource, how to implement correctly
Message-ID: <20100423182933.0df45b53@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100423150917.GA25714@sig21.net>
References: <20100423150917.GA25714@sig21.net>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 17:09:17 +0200
Johannes Stezenbach <js@sig21.net> wrote:

> I'm trying to figure out how to correctly implement sched_clock()
> for an ARM board.  However, looking at existing implementations
> leaves me rather confused.
> 
> E.g. arch/arm/mach-u300/timer.c has
> 
> static cycle_t u300_get_cycles(struct clocksource *cs)
> {
> 	return (cycles_t) readl(U300_TIMER_APP_VBASE + U300_TIMER_APP_GPT2CC);
> }
> 
> static struct clocksource clocksource_u300_1mhz = {
> 	.name           = "GPT2",
> 	.rating         = 300, /* Reasonably fast and accurate clock source */
> 	.read           = u300_get_cycles,
> 	.mask           = CLOCKSOURCE_MASK(32), /* 32 bits */
> 	/* 22 calculated using the algorithm in arch/mips/kernel/time.c */
> 	.shift          = 22,
> 	.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
> };
> 
> unsigned long long notrace sched_clock(void)
> {
> 	return clocksource_cyc2ns(clocksource_u300_1mhz.read(
> 				  &clocksource_u300_1mhz),
> 				  clocksource_u300_1mhz.mult,
> 				  clocksource_u300_1mhz.shift);
> }
> 
> Thus, sched_clock() is based on a 1MHz 32bit counter which wraps
> after about 71 minutes.  There are a few similar sched_clock()
> implementations in the tree.

Not good.
 
> Questions:
> 
> - Isn't sched_clock() supposed to be extended to 64bit so
>   that it practically never wraps?
>   (old implementations use cnt32_to_63())

Yes, sched_clock() is supposed to return a monotonic timestamp.
 
> - What would be the effect on scheduling when sched_clock() wraps?

It would confuse the process accounting and the scheduling I guess.

> - What is the effect of the sched_clock() frequency on scheduling?
>   Is there a benefit from setting the freq as high as possible?

With a higher frequency the precision of the accounting increases and
the scheduling fairness increases.

> - Is struct timecounter + struct cyclecounter + timecounter_read()
>   designated way to implement sched_clock() with a 32bit hw counter?
> 
>   arch/microblaze/kernel/timer.c seems to be the only user
>   of timecounter/cyclecounter in arch/, but I don't get what it does.
> 
>   Or is it better to stick with cnt32_to_63()?

cnt32_to_63() is a way to extend the 32 bit clocksource to a useable
sched_clock() provider. One way or the other you have to extend the 32
bits of the 1MHz counter to something bigger. The obvious way is to
count the number of wraps and use this number as the upper 32 bits
just like cnt32_to_63() does. You just have to make sure that the
clocksource is read frequently enough to get all the wraps. A non-idle
cpu will tick with HZ frequency and the clock will be read often
enough, for an idle cpu the maximum sleep time needs to be limited.

> - Also regarding the clocksource.shift value, I found
>   http://lkml.org/lkml/2008/5/8/270 and it seems to suggest
>   to use a low shift value, whereas arch/mips/kernel/time.c
>   seems to result in a large one. Is the posting correct?

Low shift values have the advantage that the 64-bit calculations do not
overflow so easily. But there are fairly large shift values in use
(20, 24, even 32 bit) in the current kernel tree, so I wouldn't worry
about bigger shift values.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

