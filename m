Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab2E2Xgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 19:36:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60558 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966Ab2E2Xgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 19:36:36 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: Unhandled IRQs on AMD E-450
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>,
        Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Josh Boyer <jwboyer@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>, andymatei@gmail.com,
        "Huang, Shane" <Shane.Huang@amd.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.02.1204301332310.14286@zacate>
References: <fa.CZQqvHf3CBfYWzhSDPNOWxTTD9w@ifi.uio.no> <fa.Vmg5vDod2/oKvwyy9BcalhoT+Lo@ifi.uio.no> <14969994.2790.1335342903511.JavaMail.geo-discussion-forums@vbbfr18> <4F97BA60.4080505@ladisch.de> <20120427082203.GB9233@aftab.osrc.amd.com> <CAPRPZsCHAOvemogn7mWnWfykhANeEx5K=OG9Xt+veDjEWOiDYA@mail.gmail.com> <CA+5PVA6e-JaS809t9=4=SoxX4cFEYfxxb9-KAXk68ENGg6Kw8w@mail.gmail.com> <CAPRPZsDDEYUf2a+=ZbwvFw+qJku0UvMLf0+eNDvw+FbinCbysA@mail.gmail.com> <CA+5PVA4NJ4fB-qEVB45sz48E7kCdwZ+O5D9jvk16z4hrXSgCwQ@mail.gmail.com> <CAPRPZsB=axM88+fGkghbh3qxDv=vRQtfrKqT0e59EZPrrS0V+A@mail.gmail.com> <20120430102150.GA9303@aftab.osrc.amd.com> <alpine.DEB.2.02.1204301332310.14286@zacate>
Date: Wed, 30 May 2012 07:36:33 +0800
Message-Id: <20120529233633.C4D223E0658@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeroen,

Comments below.  I've written a lot of things below, some of which are
trivial.  The trivial stuff won't prevent me from acking a patch, but
sorting those issues out also smooths the path for getting a change
merged.

On Mon, 30 Apr 2012 13:35:47 +0200 (CEST), Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com> wrote:
> (another try at supplying a noncorrupt patch with alpine/Gmail - sorry 
> for the inconvenience)
> 
> 
> ---

First and foremost; every patch needs a description of the changes.
What is the problem?  How is it solved?  What testing has been done?
Are there any details about this change that a reader should be
looking out for?  etc.  All of those details help me to understand
what the patch is supposed to be doing, and if the code matches what
you describe it to be.

> Signed-off-by: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>

S-o-b line must appear above the '---' line so that that patch apply
tools pick it up.

It also helps to have a diffstat below the '---' line so that I've got
an at-a-glance view of the size of the change. (git send-email will do
this for you automatically)

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
> + * @lock:			locking for SMP
> + * @affinity_hint:		hint to user space for preferred irq affinity
> + * @affinity_notify:		context for notification of affinity changes
> + * @pending_mask:		pending rebalanced interrupts
> + * @threads_oneshot:		bitfield to handle shared oneshot threads
> + * @threads_active:		number of irqaction threads currently running
> + * @wait_for_threads:		wait queue for sync_irq to wait for threaded handlers
> + * @dir:			/proc/irq/ procfs entry
> + * @name:			flow handler name for /proc/interrupts output

As commented on in my previous email, this hunk adds a lot of noise.
By changing the whitespace on every line I have no idea what has
actually been changed in this block without doing extra work.  I did
notice the rename of core_internal_state__do_not_mess_with_it, mostly
because it is a really long line, but I cannot tell at a glance if
anything else has changed, been added or been removed.

>   */
>  struct irq_desc {
>  	struct irq_data		irq_data;
> @@ -47,12 +48,13 @@ struct irq_desc {
>  #endif
>  	struct irqaction	*action;	/* IRQ action list */
>  	unsigned int		status_use_accessors;
> -	unsigned int		core_internal_state__do_not_mess_with_it;
> +	unsigned int		istate;

As already commented by tglx; don't do this.  It was named like this
on purpose.

>  	unsigned int		depth;		/* nested irq disables */
>  	unsigned int		wake_depth;	/* nested wake enables */
> -	unsigned int		irq_count;	/* For detecting broken IRQs */

I think irq_count is useful on it's own apart from detecting broken
irqs, and including it's removal adds a bit of collateral damage to
this patch. If you do think it needs to be dropped, then split this
change into another patch.

> -	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
> -	unsigned int		irqs_unhandled;
> +	unsigned int		irqs_stuck_count;
> +	unsigned int		irqs_stuck_level;
> +	unsigned int		irqs_stuck_level_max;
> +	unsigned long		irqs_stuck_timeout;
>  	raw_spinlock_t		lock;
>  	struct cpumask		*percpu_enabled;
>  #ifdef CONFIG_SMP
> diff -upr linux-3.2.16.orig/kernel/irq/debug.h linux-3.2.16.new/kernel/irq/debug.h
> --- linux-3.2.16.orig/kernel/irq/debug.h	2012-04-23 00:31:32.000000000 +0200
> +++ linux-3.2.16.new/kernel/irq/debug.h	2012-04-29 16:35:33.782919592 +0200
> @@ -11,8 +11,9 @@
>  
>  static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
>  {
> -	printk("irq %d, desc: %p, depth: %d, count: %d, unhandled: %d\n",
> -		irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
> +	printk("irq %d, desc: %p, depth: %d, stuck_count: %d, stuck_level: %d, stuck_level_max: %d, stuck_timeout: %lu\n",
> +		irq, desc, desc->depth, desc->irqs_stuck_count, desc->irqs_stuck_level, desc->irqs_stuck_level_max,
> +	        desc->irqs_stuck_timeout);
>  	printk("->handle_irq():  %p, ", desc->handle_irq);
>  	print_symbol("%s\n", (unsigned long)desc->handle_irq);
>  	printk("->irq_data.chip(): %p, ", desc->irq_data.chip);
> diff -upr linux-3.2.16.orig/kernel/irq/internals.h linux-3.2.16.new/kernel/irq/internals.h
> --- linux-3.2.16.orig/kernel/irq/internals.h	2012-04-23 00:31:32.000000000 +0200
> +++ linux-3.2.16.new/kernel/irq/internals.h	2012-04-28 22:01:15.124279391 +0200
> @@ -13,9 +13,7 @@
>  # define IRQ_BITMAP_BITS	NR_IRQS
>  #endif
>  
> -#define istate core_internal_state__do_not_mess_with_it
> -
> -extern int noirqdebug;
> +extern bool noirqdebug;

This is a discrete change; split into a separate patch with the
associated fixups.

>  
>  /*
>   * Bits used by threaded handlers:
> diff -upr linux-3.2.16.orig/kernel/irq/irqdesc.c linux-3.2.16.new/kernel/irq/irqdesc.c
> --- linux-3.2.16.orig/kernel/irq/irqdesc.c	2012-04-23 00:31:32.000000000 +0200
> +++ linux-3.2.16.new/kernel/irq/irqdesc.c	2012-04-29 16:00:01.792104426 +0200
> @@ -84,8 +84,10 @@ static void desc_set_defaults(unsigned i
>  	irqd_set(&desc->irq_data, IRQD_IRQ_DISABLED);
>  	desc->handle_irq = handle_bad_irq;
>  	desc->depth = 1;
> -	desc->irq_count = 0;
> -	desc->irqs_unhandled = 0;
> +	desc->irqs_stuck_count = 0;
> +	desc->irqs_stuck_level = 0;
> +	desc->irqs_stuck_level_max = 0;
> +	desc->irqs_stuck_timeout = jiffies;
>  	desc->name = NULL;
>  	desc->owner = owner;
>  	for_each_possible_cpu(cpu)
> diff -upr linux-3.2.16.orig/kernel/irq/manage.c linux-3.2.16.new/kernel/irq/manage.c
> --- linux-3.2.16.orig/kernel/irq/manage.c	2012-04-23 00:31:32.000000000 +0200
> +++ linux-3.2.16.new/kernel/irq/manage.c	2012-04-30 09:26:26.395627416 +0200
> @@ -1087,8 +1087,10 @@ __setup_irq(unsigned int irq, struct irq
>  	*old_ptr = new;
>  
>  	/* Reset broken irq detection when installing new handler */
> -	desc->irq_count = 0;
> -	desc->irqs_unhandled = 0;
> +	desc->irqs_stuck_count = 0;
> +	desc->irqs_stuck_level = 0;
> +	desc->irqs_stuck_level_max = 0;
> +	desc->irqs_stuck_timeout = jiffies;
>  
>  	/*
>  	 * Check whether we disabled the irq via the spurious handler
> diff -upr linux-3.2.16.orig/kernel/irq/proc.c linux-3.2.16.new/kernel/irq/proc.c
> --- linux-3.2.16.orig/kernel/irq/proc.c	2012-04-23 00:31:32.000000000 +0200
> +++ linux-3.2.16.new/kernel/irq/proc.c	2012-04-29 16:34:17.642434577 +0200
> @@ -248,9 +248,9 @@ static int irq_spurious_proc_show(struct
>  {
>  	struct irq_desc *desc = irq_to_desc((long) m->private);
>  
> -	seq_printf(m, "count %u\n" "unhandled %u\n" "last_unhandled %u ms\n",
> -		   desc->irq_count, desc->irqs_unhandled,
> -		   jiffies_to_msecs(desc->last_unhandled));
> +	seq_printf(m, "irq=%3d stuck_count=%3u stuck_level_max=%3u\n",
> +		   desc->irq_data.irq,
> +	           desc->irqs_stuck_count, desc->irqs_stuck_level_max);
>  	return 0;
>  }
>  
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
>  	for_each_irq_desc(i, desc) {
> -		unsigned int state;
> +		unsigned int state, irq;

Don't need to do this; the irq number is already stored in 'i' by
for_each_irq_desc.

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

"... now tracks ..."?  Does it track something different elsewhere in the
code?

> +
> +		irq = desc->irq_data.irq;
> +		if (unlikely(desc->irqs_stuck_level == 1))
> +			if (desc->irqs_stuck_count <= SPURIOUS_IRQ_REPORT_COUNT)

It isn't obvious how the irqs_stuck_* values work together.  Can you
add a comment blurb to the code describing it?  I believe you
described how it works in a previous email, but future readers
probably won't see that.  It needs to be documented here.

> +				printk(KERN_EMERG "Polling handlers for IRQ %d.\n", irq);

Nit: pr_emerg()

> +		if (desc->irqs_stuck_level < SPURIOUS_IRQ_POLL_CYCLES) {
> +			local_irq_disable();
> +			try_one_irq(i, desc, true);
> +			local_irq_enable();
> +			desc->irqs_stuck_level++;
> +			poll_again = 1;
> +		} else {
> +			if (unlikely(desc->irqs_stuck_count <= SPURIOUS_IRQ_REPORT_COUNT)) {
> +				printk(KERN_EMERG "Reenabling IRQ %d.\n", irq);
> +				if (desc->irqs_stuck_count >= SPURIOUS_IRQ_REPORT_COUNT)
> +					printk(KERN_EMERG "No more stuck interrupt reports for IRQ %d.\n", irq);
> +			}
> +			irq_enable(desc); /* Reenable the interrupt line */
> +			desc->depth--;
> +			desc->istate &= (~IRQS_SPURIOUS_DISABLED);
> +			desc->irqs_stuck_level = 0;
> +		}
>  	}
> +	if (poll_again)
> +		mod_timer(&poll_spurious_irq_timer,
> +			  jiffies + SPURIOUS_IRQ_POLL_INTERVAL);

Is there a reason that the mod_timer is moved out of the out: path?
Won't this mean that if other code already has irq_poll_active
incremented (misrouted_irq()) that the timer won't get reset and
poll_spurious_irqs() will stall?

>  out:
>  	atomic_dec(&irq_poll_active);
> -	mod_timer(&poll_spurious_irq_timer,
> -		  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
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
>  static void
>  __report_bad_irq(unsigned int irq, struct irq_desc *desc,
>  		 irqreturn_t action_ret)
> @@ -272,7 +293,6 @@ void note_interrupt(unsigned int irq, st
>  	if (desc->istate & IRQS_POLL_INPROGRESS)
>  		return;
>  
> -	/* we get here again via the threaded handler */
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

Nit: kernel style for multiline blocks is:

/*
 * ...
 * ...
 */

> +	if (unlikely(try_misrouted_irq(irq, desc, action_ret)))
> +		if (misrouted_irq(irq))
> +			action_ret = IRQ_HANDLED;

Tip: if the braces around this block had been left as-is, then then
diff would have kept the related lines of code together.

> +
> +	if (unlikely((action_ret == IRQ_NONE) && time_before(jiffies, desc->irqs_stuck_timeout))) {
> +		desc->irqs_stuck_level++;
> +		if (desc->irqs_stuck_level > desc->irqs_stuck_level_max)
> +			desc->irqs_stuck_level_max = desc->irqs_stuck_level;
> +		if (desc->irqs_stuck_level >= SPURIOUS_IRQ_TRIGGER) { /* The interrupt is stuck */
> +			desc->irqs_stuck_count++; /* TODO: Prevent hypothetical overflow */
> +			if (desc->irqs_stuck_count <= SPURIOUS_IRQ_REPORT_COUNT) {
> +				__report_bad_irq(irq, desc, action_ret);
> +				printk(KERN_EMERG "Disabling IRQ %d.\n", irq);
> +			}
> +			desc->istate |= IRQS_SPURIOUS_DISABLED;
> +			desc->depth++;
> +			irq_disable(desc);
> +			/* TODO: Do a safe access to the timer. Now we may be extending a deadline
> +			   for a polling system already running for another interrupt. */
> +			mod_timer(&poll_spurious_irq_timer,
> +			          jiffies + SPURIOUS_IRQ_POLL_INTERVAL); /* Schedule a poll cycle */

This isn't any different from where the existing code sets up the
timer.  What is your concern here about extending the deadline?  Is it
just because the bad irq condition gets hit much earlier with this
code (5 instead of 99900)?

> +			desc->irqs_stuck_level = 1;
> +			desc->irqs_stuck_level_max = 0;
> +		}
>  	}
> -
> -	desc->irq_count++;
> -	if (likely(desc->irq_count < 100000))
> -		return;
> -
> -	desc->irq_count = 0;
> -	if (unlikely(desc->irqs_unhandled > 99900)) {
> -		/*
> -		 * The interrupt is stuck
> -		 */
> -		__report_bad_irq(irq, desc, action_ret);
> -		/*
> -		 * Now kill the IRQ
> -		 */
> -		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
> -		desc->istate |= IRQS_SPURIOUS_DISABLED;
> -		desc->depth++;
> -		irq_disable(desc);
> -
> -		mod_timer(&poll_spurious_irq_timer,
> -			  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
> +	else {
> +		desc->irqs_stuck_timeout = jiffies + SPURIOUS_IRQ_TIMEOUT_INTERVAL;
> +		desc->irqs_stuck_level = 0;
>  	}
> -	desc->irqs_unhandled = 0;
>  }
>  
> -int noirqdebug __read_mostly;
> +bool noirqdebug __read_mostly;
>  
>  int noirqdebug_setup(char *str)
>  {
> -	noirqdebug = 1;
> +	noirqdebug = true;
>  	printk(KERN_INFO "IRQ lockup detection disabled\n");
>  
>  	return 1;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
