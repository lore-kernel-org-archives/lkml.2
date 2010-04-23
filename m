Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab0DWPJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:09:29 -0400
Received: from bar.sig21.net ([80.81.252.164]:49831 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab0DWPJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:09:26 -0400
Date: Fri, 23 Apr 2010 17:09:17 +0200
From: Johannes Stezenbach <js@sig21.net>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       John Stultz <johnstul@us.ibm.com>, Magnus Damm <damm@opensource.se>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Q: sched_clock() vs. clocksource, how to implement correctly
Message-ID: <20100423150917.GA25714@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.777,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to figure out how to correctly implement sched_clock()
for an ARM board.  However, looking at existing implementations
leaves me rather confused.

E.g. arch/arm/mach-u300/timer.c has

static cycle_t u300_get_cycles(struct clocksource *cs)
{
	return (cycles_t) readl(U300_TIMER_APP_VBASE + U300_TIMER_APP_GPT2CC);
}

static struct clocksource clocksource_u300_1mhz = {
	.name           = "GPT2",
	.rating         = 300, /* Reasonably fast and accurate clock source */
	.read           = u300_get_cycles,
	.mask           = CLOCKSOURCE_MASK(32), /* 32 bits */
	/* 22 calculated using the algorithm in arch/mips/kernel/time.c */
	.shift          = 22,
	.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
};

unsigned long long notrace sched_clock(void)
{
	return clocksource_cyc2ns(clocksource_u300_1mhz.read(
				  &clocksource_u300_1mhz),
				  clocksource_u300_1mhz.mult,
				  clocksource_u300_1mhz.shift);
}

Thus, sched_clock() is based on a 1MHz 32bit counter which wraps
after about 71 minutes.  There are a few similar sched_clock()
implementations in the tree.

Questions:

- Isn't sched_clock() supposed to be extended to 64bit so
  that it practically never wraps?
  (old implementations use cnt32_to_63())

- What would be the effect on scheduling when sched_clock() wraps?

- What is the effect of the sched_clock() frequency on scheduling?
  Is there a benefit from setting the freq as high as possible?

- Is struct timecounter + struct cyclecounter + timecounter_read()
  designated way to implement sched_clock() with a 32bit hw counter?

  arch/microblaze/kernel/timer.c seems to be the only user
  of timecounter/cyclecounter in arch/, but I don't get what it does.

  Or is it better to stick with cnt32_to_63()?

- Also regarding the clocksource.shift value, I found
  http://lkml.org/lkml/2008/5/8/270 and it seems to suggest
  to use a low shift value, whereas arch/mips/kernel/time.c
  seems to result in a large one. Is the posting correct?


Thanks,
Johannes
