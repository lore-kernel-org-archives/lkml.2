Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967459Ab2EPL1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:27:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:37568 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967293Ab2EPL1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:27:12 -0400
Date: Wed, 16 May 2012 13:27:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [WARNING] at kernel/irq/manage.c:421 __enable_irq
In-Reply-To: <1337131823.6724.11.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1205161001500.3231@ionos>
References: <1337131823.6724.11.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012, Steven Rostedt wrote:
> The code in ide_probe_port() does the following:

Right, you just forgot to show the most interesting gem of that code:

	/*
	 * We must always disable IRQ, as probe_for_drive will assert IRQ, but
	 * we'll install our IRQ driver much later...
	 */

If there is no handler installed for that interrupt, then it's already
disabled.

So what they possibly try to deal with is a shared interrupt, where
there is already an handler installed. In that case you need to
disable the interrupt to avoid an interrupt storm, when thew IDE probe
asserts the irq.

Though I don't know why the probe code must result in asserting the
interrupt line, except when this IDE crap cannot disable the interrupt
at the device level. I wouldn't be surprised ....

>         irqd = hwif->irq;
>         if (irqd)
>                 disable_irq(hwif->irq);
> 
>         if (ide_port_wait_ready(hwif) == -EBUSY)
>                 printk(KERN_DEBUG "%s: Wait for ready failed before probe !\n", hwif->name);
> 
>         /*
>          * Second drive should only exist if first drive was found,
>          * but a lot of cdrom drives are configured as single slaves.
>          */
>         ide_port_for_each_dev(i, drive, hwif) {
>                 (void) probe_for_drive(drive);
>                 if (drive->dev_flags & IDE_DFLAG_PRESENT)
>                         rc = 0;
>         }
> 
>         /*
>          * Use cached IRQ number. It might be (and is...) changed by probe
>          * code above
>          */

This comment is great. What the heck is changed and why ? And what
happens if it is _NOT_ changed ? Oh, well.....

At least I can't find code which touches hwif->irq in the probe
functions.

>         if (irqd)
>                 enable_irq(irqd);

So this code is wrong and unsafe in various aspects. I wonder why it
didn't blow up before. Maybe init ordering changed ....

> We disable the interrupt for the device (hwif->irq), do the probes, and
> then enable the irq if it existed. The problem is that the probe resets
> the depth count of the irq descriptor. I ran some traces, and added some

probe CANNOT do that. See below.

> trace_printks, to confirm it.
> 
> Coming into this function, the desc->depth is 1. The disable_irq() sets
> the depth to 2. Then the probe calls irq_startup() that resets the depth
> to 0.

probe CANNOT call irq_startup().

There are only two possibilites for irq_startup() calls:

      request_irq() and irq_probe_on()

I can't find irq autoprobing in drivers/ide, so something else is
installing an interrupt handler for irq 16 or autoprobing interrupts.

Can you figure that out with the tracer ?

           <...>-183   [000] ....     0.950828: disable_irq <-ide_probe_port
           <...>-183   [000] ....     0.950830: __disable_irq_nosync <-disable_irq
           <...>-183   [000] d..1     0.950831: __disable_irq <-__disable_irq_nosync
           <...>-183   [000] d..1     0.950832: __disable_irq: irq=16 depth=2

And the trace confirms my theory. ide_probe_port() is run from TID 183

           <...>-193   [002] d..1     1.057579: irq_startup: irq=16 depth=0

irq_startup() is run from TID 193

           <...>-183   [001] ....     1.518815: enable_irq <-ide_probe_port
           <...>-183   [001] d..1     1.518817: __enable_irq <-enable_irq
           <...>-183   [001] d..1     1.518818: __enable_irq: irq=16 depth=0
           <...>-183   [001] d..1     1.518819: __enable_irq: warning irq=16

So you trigger the following case

   CPU0	       	   	     CPU1

   disable_irq(16);
   probe....		     request_irq(16,...); or irq_probe_on();
   enable_irq(16);

And there is nothing the core code can do about that. What's worse is
that when the request_irq() is done right before the probe code
results in asserting the irq line, then an interrupt storm will break
lose and disable irq 16 because the other device returns IRQ_NONE.

That's what you get for doing parallel device probing :)

I have an idea how to fix that proper. Will send out patches later.

Thanks,

	tglx
