Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab2E3AHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 20:07:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:49784 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2E3AHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 20:07:40 -0400
Date: Wed, 30 May 2012 02:07:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
cc: Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@gmail.com>, Clemens Ladisch <clemens@ladisch.de>,
        andymatei@gmail.com, "Huang, Shane" <Shane.Huang@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Unhandled IRQs on AMD E-450
In-Reply-To: <alpine.DEB.2.02.1204301332310.14286@zacate>
Message-ID: <alpine.LFD.2.02.1205300020070.3231@ionos>
References: <fa.CZQqvHf3CBfYWzhSDPNOWxTTD9w@ifi.uio.no> <fa.Vmg5vDod2/oKvwyy9BcalhoT+Lo@ifi.uio.no> <14969994.2790.1335342903511.JavaMail.geo-discussion-forums@vbbfr18> <4F97BA60.4080505@ladisch.de> <20120427082203.GB9233@aftab.osrc.amd.com>
 <CAPRPZsCHAOvemogn7mWnWfykhANeEx5K=OG9Xt+veDjEWOiDYA@mail.gmail.com> <CA+5PVA6e-JaS809t9=4=SoxX4cFEYfxxb9-KAXk68ENGg6Kw8w@mail.gmail.com> <CAPRPZsDDEYUf2a+=ZbwvFw+qJku0UvMLf0+eNDvw+FbinCbysA@mail.gmail.com> <CA+5PVA4NJ4fB-qEVB45sz48E7kCdwZ+O5D9jvk16z4hrXSgCwQ@mail.gmail.com>
 <CAPRPZsB=axM88+fGkghbh3qxDv=vRQtfrKqT0e59EZPrrS0V+A@mail.gmail.com> <20120430102150.GA9303@aftab.osrc.amd.com> <alpine.DEB.2.02.1204301332310.14286@zacate>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2012, Jeroen Van den Keybus wrote:

> (another try at supplying a noncorrupt patch with alpine/Gmail - sorry 
> for the inconvenience)
> 
> 
> ---

This is missing a proper changelog. And a very lenghty one.

> Signed-off-by: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
> 
> diff -upr linux-3.2.16.orig/include/linux/irqdesc.h linux-3.2.16.new/include/linux/irqdesc.h
> --- linux-3.2.16.orig/include/linux/irqdesc.h	2012-04-23 00:31:32.000000000 +0200
> +++ linux-3.2.16.new/include/linux/irqdesc.h	2012-04-29 16:33:48.142332693 +0200
> @@ -14,28 +14,29 @@ struct timer_rand_state;
>  struct module;
>  /**
>   * struct irq_desc - interrupt descriptor
> - * @irq_data:		per irq and chip data passed down to chip functions
> - * @timer_rand_state:	pointer to timer rand state struct
> - * @kstat_irqs:		irq stats per cpu
> - * @handle_irq:		highlevel irq-events handler
> - * @preflow_handler:	handler called before the flow handler (currently used by sparc)
> - * @action:		the irq action chain
> - * @status:		status information
> - * @core_internal_state__do_not_mess_with_it: core internal status information
> - * @depth:		disable-depth, for nested irq_disable() calls
> - * @wake_depth:		enable depth, for multiple irq_set_irq_wake() callers
> - * @irq_count:		stats field to detect stalled irqs
> - * @last_unhandled:	aging timer for unhandled count
> - * @irqs_unhandled:	stats field for spurious unhandled interrupts
> - * @lock:		locking for SMP
> - * @affinity_hint:	hint to user space for preferred irq affinity
> - * @affinity_notify:	context for notification of affinity changes
> - * @pending_mask:	pending rebalanced interrupts
> - * @threads_oneshot:	bitfield to handle shared oneshot threads
> - * @threads_active:	number of irqaction threads currently running
> - * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
> - * @dir:		/proc/irq/ procfs entry
> - * @name:		flow handler name for /proc/interrupts output
> + * @irq_data:			per irq and chip data passed down to chip functions
> + * @timer_rand_state:		pointer to timer rand state struct
> + * @kstat_irqs:			irq stats per cpu
> + * @handle_irq:			highlevel irq-events handler
> + * @preflow_handler:		handler called before the flow handler (currently used by sparc)
> + * @action:			the irq action chain
> + * @status:			status information
> + * @istate:			core internal status information
> + * @depth:			disable-depth, for nested irq_disable() calls
> + * @wake_depth:			enable depth, for multiple irq_set_irq_wake() callers
> + * @irqs_stuck_count:		stuck interrupt occurrence counter
> + * @irqs_stuck_level:		used for stuck interrupt line detection and tracking poll cycle count
> + * @irqs_stuck_level_max:	indicates the maximum irqs_stuck_level since last stuck interrupt occurrence
> + * @irqs_stuck_timeout:		deadline for resetting irqs_stuck_level

I can only guestimate what this is for due to the lack of a proper
changelog which explains how this new mechanism is supposed to work.

> + * @lock:			locking for SMP
> + * @affinity_hint:		hint to user space for preferred irq affinity
> + * @affinity_notify:		context for notification of affinity changes
> + * @pending_mask:		pending rebalanced interrupts
> + * @threads_oneshot:		bitfield to handle shared oneshot threads
> + * @threads_active:		number of irqaction threads currently running
> + * @wait_for_threads:		wait queue for sync_irq to wait for threaded handlers
> + * @dir:			/proc/irq/ procfs entry
> + * @name:			flow handler name for /proc/interrupts output
>   */

If you want to move the column of the comment, then please make this a
separate patch and add your members on top.

>  struct irq_desc {
>  	struct irq_data		irq_data;
> @@ -47,12 +48,13 @@ struct irq_desc {
>  #endif
>  	struct irqaction	*action;	/* IRQ action list */
>  	unsigned int		status_use_accessors;
> -	unsigned int		core_internal_state__do_not_mess_with_it;
> +	unsigned int		istate;

What's the point of this change? How is this related to your problem ?

> diff -upr linux-3.2.16.orig/kernel/irq/internals.h linux-3.2.16.new/kernel/irq/internals.h
> --- linux-3.2.16.orig/kernel/irq/internals.h	2012-04-23 00:31:32.000000000 +0200
> +++ linux-3.2.16.new/kernel/irq/internals.h	2012-04-28 22:01:15.124279391 +0200
> @@ -13,9 +13,7 @@
>  # define IRQ_BITMAP_BITS	NR_IRQS
>  #endif
>  
> -#define istate core_internal_state__do_not_mess_with_it
> -

No. See above.

> -extern int noirqdebug;
> +extern bool noirqdebug;

Unrelated. Please do not mix functional changes with random cleanups.

> @@ -248,9 +248,9 @@ static int irq_spurious_proc_show(struct
>  {
>         struct irq_desc *desc = irq_to_desc((long) m->private);
>  
> -       seq_printf(m, "count %u\n" "unhandled %u\n" "last_unhandled %u ms\n",
> -                  desc->irq_count, desc->irqs_unhandled,
> -                  jiffies_to_msecs(desc->last_unhandled));
> +       seq_printf(m, "irq=%3d stuck_count=%3u stuck_level_max=%3u\n",
> +                  desc->irq_data.irq,
> +                  desc->irqs_stuck_count, desc->irqs_stuck_level_max);

So this changes the output of /proc/irq/*/spurious from:

 count 85
 unhandled 0
 last_unhandled 0 ms

to

 irq= 16 stuck_count= 81 stuck_level_max=  0

I don't know whether we have tools depending on that, but you discard
valuable information:

- The number of handled interrupts vs. the number of unhandled ones
- The last occurence of an unhandled one

And you add redundant information:

- The irq number, which is already part of the file path

Even if no tool depends on that this wants to be documented somewhere.

Aside of that I really can't understand the output:

 irq= 16 stuck_count= 81 stuck_level_max=  0

It got stuck 81 times, and the max level is 0 ?

>         return 0;
>  }

  
> diff -upr linux-3.2.16.orig/kernel/irq/spurious.c linux-3.2.16.new/kernel/irq/spurious.c
> --- linux-3.2.16.orig/kernel/irq/spurious.c	2012-04-23 00:31:32.000000000 +0200
> +++ linux-3.2.16.new/kernel/irq/spurious.c	2012-04-30 13:29:01.107319326 +0200
> @@ -18,7 +18,12 @@
>  
>  static int irqfixup __read_mostly;
>  
> -#define POLL_SPURIOUS_IRQ_INTERVAL (HZ/10)
> +#define SPURIOUS_IRQ_TIMEOUT_INTERVAL (HZ/10)
> +#define SPURIOUS_IRQ_TRIGGER 5
> +#define SPURIOUS_IRQ_REPORT_COUNT 5
> +#define SPURIOUS_IRQ_POLL_CYCLES 100
> +#define SPURIOUS_IRQ_POLL_INTERVAL (HZ/100)
> +
>  static void poll_spurious_irqs(unsigned long dummy);
>  static DEFINE_TIMER(poll_spurious_irq_timer, poll_spurious_irqs, 0, 0);
>  static int irq_poll_cpu;
> @@ -141,14 +146,15 @@ out:
>  static void poll_spurious_irqs(unsigned long dummy)
>  {
>  	struct irq_desc *desc;
> -	int i;
> +	int i, poll_again;
>  
>  	if (atomic_inc_return(&irq_poll_active) != 1)
>  		goto out;
>  	irq_poll_cpu = smp_processor_id();
>  
> +	poll_again = 0; /* Will stay false as long as no polling candidate is found */

Please do not put comments at the end of the code line. That really
makes it hard to read. And this comment is pretty pointless. I wish
the real functionality would have been commented proper.

>  	for_each_irq_desc(i, desc) {
> -		unsigned int state;
> +		unsigned int state, irq;
>  
>  		if (!i)
>  			 continue;
> @@ -158,15 +164,38 @@ static void poll_spurious_irqs(unsigned
>  		barrier();
>  		if (!(state & IRQS_SPURIOUS_DISABLED))
>  			continue;
> -
> -		local_irq_disable();
> -		try_one_irq(i, desc, true);
> -		local_irq_enable();
> +		
> +		/* We end up here with a disabled stuck interrupt.
> +		   desc->irqs_stuck_level now tracks the number of times
> +		   the interrupt has been polled */

Please follow the coding style. Multiline comments are
       /*
        * .....
	*/

> +		irq = desc->irq_data.irq;

Huch? "i" has already the irq number.

> +		if (unlikely(desc->irqs_stuck_level == 1))
> +			if (desc->irqs_stuck_count <= SPURIOUS_IRQ_REPORT_COUNT)
> +				printk(KERN_EMERG "Polling handlers for IRQ %d.\n", irq);

This is definitely not an emergency message. And why do we want to
print that over and over?

> +		if (desc->irqs_stuck_level < SPURIOUS_IRQ_POLL_CYCLES) {
> +			local_irq_disable();
> +			try_one_irq(i, desc, true);
> +			local_irq_enable();
> +			desc->irqs_stuck_level++;
> +			poll_again = 1;

So now we poll 100 times.

> +		} else {
> +			if (unlikely(desc->irqs_stuck_count <= SPURIOUS_IRQ_REPORT_COUNT)) {
> +				printk(KERN_EMERG "Reenabling IRQ %d.\n", irq);
> +				if (desc->irqs_stuck_count >= SPURIOUS_IRQ_REPORT_COUNT)
> +					printk(KERN_EMERG "No more stuck interrupt reports for IRQ %d.\n", irq);

I really can't grok that logic. For the first five rounds where we
polled 100 times and started over we print "Reenabling ..." On the 5th
round we report: "No more stuck interrupt ...."

What's the point of this? Random debugging leftovers?

So the last message in dmesg is: "No more stuck interrupt reports..."
while the interrupt still is in polling mode or happily bouncing back
and forth.

> +			}

And then we unconditionally reenable the interrupts after 100 polls to
start over?

> +			irq_enable(desc); /* Reenable the interrupt line */

So now the interrupt can come in, or other functions can fiddle with
istate / depth. What protects the access to the following two fields ?

> +			desc->depth--;
> +			desc->istate &= (~IRQS_SPURIOUS_DISABLED);

On the disable path we are protected, but not here.

> +			desc->irqs_stuck_level = 0;

And that one is not protected against another interrupt coming in and
setting it to 1.

> +		}
>  	}
> +	if (poll_again)
> +		mod_timer(&poll_spurious_irq_timer,
> +			  jiffies + SPURIOUS_IRQ_POLL_INTERVAL);
>  out:
>  	atomic_dec(&irq_poll_active);
> -	mod_timer(&poll_spurious_irq_timer,
> -		  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);

So in case the above 

        if (atomic_inc_return(&irq_poll_active) != 1)
	   	goto out;

code path is taken, then we don't rearm the timer. This can happen
when one CPU runs misrouted_irq() and the other runs the timer
callback. If the misrouted_irq() call succeeds and there are still
interrupts which depend on polling then nothing rearms the timer.

>  }
>  
>  static inline int bad_action_ret(irqreturn_t action_ret)
> @@ -176,14 +205,6 @@ static inline int bad_action_ret(irqretu
>  	return 1;
>  }
>  
> -/*
> - * If 99,900 of the previous 100,000 interrupts have not been handled
> - * then assume that the IRQ is stuck in some manner. Drop a diagnostic
> - * and try to turn the IRQ off.
> - *
> - * (The other 100-of-100,000 interrupts may have been a correctly
> - *  functioning device sharing an IRQ with the failing one)
> - */

Instead of removing the comment there should be one which is
explaining what the new rules are.

>  static void
>  __report_bad_irq(unsigned int irq, struct irq_desc *desc,
>  		 irqreturn_t action_ret)
> @@ -272,7 +293,6 @@ void note_interrupt(unsigned int irq, st
>  	if (desc->istate & IRQS_POLL_INPROGRESS)
>  		return;
>  
> -	/* we get here again via the threaded handler */

The comment is not brilliant, but removing it in the context of this
change is just wrong.

>  	if (action_ret == IRQ_WAKE_THREAD)
>  		return;
>  
> @@ -281,55 +301,47 @@ void note_interrupt(unsigned int irq, st
>  		return;
>  	}
>  
> -	if (unlikely(action_ret == IRQ_NONE)) {
> -		/*
> -		 * If we are seeing only the odd spurious IRQ caused by
> -		 * bus asynchronicity then don't eventually trigger an error,
> -		 * otherwise the counter becomes a doomsday timer for otherwise
> -		 * working systems
> -		 */

Again, this is useful information. Why are you removing it ?

> -		if (time_after(jiffies, desc->last_unhandled + HZ/10))
> -			desc->irqs_unhandled = 1;
> -		else
> -			desc->irqs_unhandled++;
> -		desc->last_unhandled = jiffies;
> -	}
> -
> -	if (unlikely(try_misrouted_irq(irq, desc, action_ret))) {
> -		int ok = misrouted_irq(irq);
> -		if (action_ret == IRQ_NONE)
> -			desc->irqs_unhandled -= ok;

> +	/* Adjust action_ret if an optional poll was successful.
> +	   (See inlined try_misrouted_irq() for conditions (depending
> +	   on 'irqfixup' and 'irqpoll'), and 'noirqdebug' must not
> +	   be set, since we wouldn't be here (note_interrupt())
> +	   at all in that case.) */

The missing information is _WHY_ we adjust action_ret. The interested
reader will look into try_misrouted_irq() and figure out when it
returns != 0.

> +	if (unlikely(try_misrouted_irq(irq, desc, action_ret)))
> +		if (misrouted_irq(irq))
> +			action_ret = IRQ_HANDLED;
> +

	if (a) {
	       if (b)
			bla;
	}

Please

> +	if (unlikely((action_ret == IRQ_NONE) && time_before(jiffies, desc->irqs_stuck_timeout))) {

All this likely/unlikely making is just wrong. And please keep the
code within 80 chars.

> +		desc->irqs_stuck_level++;

What's level doing ?

> +		if (desc->irqs_stuck_level > desc->irqs_stuck_level_max)
> +			desc->irqs_stuck_level_max = desc->irqs_stuck_level;

That's purely stats, right ?

> +		if (desc->irqs_stuck_level >= SPURIOUS_IRQ_TRIGGER) { /* The interrupt is stuck */

Please don't comment the obvious instead of commenting the interesting
bits.

> +			desc->irqs_stuck_count++; /* TODO: Prevent hypothetical overflow */

Why should this overflow? Because this thing is bouncing back and
forth from poll mode to interrupt mode forever ?

> +			if (desc->irqs_stuck_count <= SPURIOUS_IRQ_REPORT_COUNT) {
> +				__report_bad_irq(irq, desc, action_ret);
> +				printk(KERN_EMERG "Disabling IRQ %d.\n", irq);
> +			}

We report the interrupt as bad 5 times. Then we stop, but what tells
us that we disabled it forever. Or don't we do that anymore?

No we don't, AFAICT. That would mean that on a machine which has a
real poll issue this bounces back and forth for ever. Not a real
improvement.

> +			desc->istate |= IRQS_SPURIOUS_DISABLED;
> +			desc->depth++;
> +			irq_disable(desc);
> +			/* TODO: Do a safe access to the timer. Now we may be extending a deadline
> +			   for a polling system already running for another interrupt. */

And who cares ?

> +			mod_timer(&poll_spurious_irq_timer,
> +			          jiffies + SPURIOUS_IRQ_POLL_INTERVAL); /* Schedule a poll cycle */

We know that we schedule a poll cycle by arming the timer.

> +			desc->irqs_stuck_level = 1;
> +			desc->irqs_stuck_level_max = 0;

I'm confused. What's the rule for this "max" statistics?

> +	else {
> +		desc->irqs_stuck_timeout = jiffies + SPURIOUS_IRQ_TIMEOUT_INTERVAL;
> +		desc->irqs_stuck_level = 0;
>  	}
> -	desc->irqs_unhandled = 0;
>  }
>  
> -int noirqdebug __read_mostly;
> +bool noirqdebug __read_mostly;

See above.

I have no objections to improve the spurious/poll handling but this
has do be done more carefully.

Also I'm very interested to figure out the root cause of this problem
first. You provided quite some information already, but I'm still
waiting for some more.

Aside of that it would be helpful if the AMD folks could try to get
some more information about this issue on the documentation/errata
level. Boris ???

Thanks,

	tglx
