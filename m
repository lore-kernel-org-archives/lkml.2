Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab0KOKsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:48:19 -0500
Received: from canuck.infradead.org ([134.117.69.58]:60366 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab0KOKsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:48:18 -0500
Subject: Re: [PATCH] clocksource: document some basic concepts
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nico@fluxnic.net>, Colin Cross <ccross@google.com>,
        John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>
In-Reply-To: <1289817228-14838-1-git-send-email-linus.walleij@stericsson.com>
References: <1289817228-14838-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 15 Nov 2010 11:48:14 +0100
Message-ID: <1289818094.2109.487.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 11:33 +0100, Linus Walleij wrote:
> +sched_clock()
> +-------------
> +
> +In addition to the clock sources and clock events there is a special weak
> +function in the kernel called sched_clock(). This function shall return the
> +number of nanoseconds since the system was started. An architecture may or
> +may not provide an implementation of sched_clock() on its own.
> +
> +As the name suggests, sched_clock() is used for scheduling the system,
> +determining the absolute timeslice for a certain process in the CFS scheduler
> +for example. It is also used for printk timestamps when you have selected to
> +include time information in printk for things like bootcharts.
> +
> +Compared to clock sources, sched_clock() has to be very fast: it is called
> +much more often, especially by the scheduler. If you have to do trade-offs
> +between accuracy compared to the clock source, you may sacrifice accuracy
> +for speed in sched_clock(). It however require the same basic characteristics
> +as the clock source, i.e. it has to be monotonic.

Not so, we prefer it be synchronized and monotonic, but we don't require
so, see below.

> +The sched_clock() function may wrap only on unsigned long long boundaries,
> +i.e. after 64 bits. Since this is a nanosecond value this will mean it wraps
> +after circa 585 years. (For most practical systems this means "never".)

Currently true, John Stultz was going to look into ammending this by
teaching the kernel/sched_clock.c bits about early wraps (and a way for
architectures to specify this)

#define SCHED_CLOCK_WRAP_BITS 48

...

#ifdef SCHED_CLOCK_WRAP_BITS
  /* handle short wraps */
#endif

foo for wrap_min/wrap_max and "delta = now - scd->tick_raw" like things
might work.

> +If an architecture does not provide its own implementation of this function,
> +it will fall back to using jiffies, making its maximum resolution 1/HZ of the
> +jiffy frequency for the architecture. This will affect scheduling accuracy
> +and will likely show up in system benchmarks. 

sched_clock() need not be synchronized between CPUs, nor even be
monotonic, we prefer a fast high res clock over a slow one,
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK provides infrastructure to sanitize the
output of sched_clock().

[ of course we prefer a fast and synchronized clock, but we take fast
over synchronized ]

sched_clock() requires local IRQs to be disabled.

Therefore, sched_clock() shall not be used, see kernel/sched_clock.c for
detail and alternative interfaces.
