Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2D3KWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 06:22:01 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39567 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab2D3KWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 06:22:00 -0400
Date: Mon, 30 Apr 2012 12:21:50 +0200
From: Borislav Petkov <bp@amd64.org>
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Josh Boyer <jwboyer@gmail.com>, Clemens Ladisch <clemens@ladisch.de>,
        andymatei@gmail.com, "Huang, Shane" <Shane.Huang@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Unhandled IRQs on AMD E-450
Message-ID: <20120430102150.GA9303@aftab.osrc.amd.com>
References: <fa.CZQqvHf3CBfYWzhSDPNOWxTTD9w@ifi.uio.no>
 <fa.Vmg5vDod2/oKvwyy9BcalhoT+Lo@ifi.uio.no>
 <14969994.2790.1335342903511.JavaMail.geo-discussion-forums@vbbfr18>
 <4F97BA60.4080505@ladisch.de>
 <20120427082203.GB9233@aftab.osrc.amd.com>
 <CAPRPZsCHAOvemogn7mWnWfykhANeEx5K=OG9Xt+veDjEWOiDYA@mail.gmail.com>
 <CA+5PVA6e-JaS809t9=4=SoxX4cFEYfxxb9-KAXk68ENGg6Kw8w@mail.gmail.com>
 <CAPRPZsDDEYUf2a+=ZbwvFw+qJku0UvMLf0+eNDvw+FbinCbysA@mail.gmail.com>
 <CA+5PVA4NJ4fB-qEVB45sz48E7kCdwZ+O5D9jvk16z4hrXSgCwQ@mail.gmail.com>
 <CAPRPZsB=axM88+fGkghbh3qxDv=vRQtfrKqT0e59EZPrrS0V+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPRPZsB=axM88+fGkghbh3qxDv=vRQtfrKqT0e59EZPrrS0V+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before you guys get more involved in this, it would be probably prudent
to run this approach by tglx and Linus to check its general sanity :-).

Added.

On Mon, Apr 30, 2012 at 10:29:19AM +0200, Jeroen Van den Keybus wrote:
> > I'd have to go back and look through all the bug reports.  Essentially,
> > it wound up being "this used to work fine, now I get stuck in polling
> > mode".  When we dropped the patch in those cases, it went back to
> > working fine.
> 
> >>> +       int unhandled_thresh = 999000;
> 
> >>> +       if (!irq_poll_and_retry)
> >>> +               if (likely(desc->irq_count < 100000))
> >>> +                       return;
> >>> +       else
> >>> +               if (likely(desc->irq_count < 10))
> >>> +                       return;
> 
> Given these 2 bugs I wouldn't rule out that this code would have
> malfunctioned, causing the problematic behaviour you describe. Are
> these problematic machines still available ?
> 
> I have attached a patch for 3.2.16. It is essential that it is also
> tested by people NOT having any problems. What the patch does:
> 
> - Detect stuck interrupts after a number (5) of consecutive unhandled
> IRQs within a specified time frame (100ms).
> - Start polling the handler for this interrupt at a preset (100Hz)
> rate for a preset number of cycles (100).
> - Retry and enable the interrupt line and start the cycle over.
> - Report the first occurrences of this process for a preset number of times (5).
> - Expose the state of stuck_count in /proc/irq/<irq>/spurious. It is
> the number of times an interrupt was deemed stuck.
> - Expose the state of stuck_level_max in /proc/irq/<irq>/spurious. It
> indicates how many consecutive unhandled interrupts were detected
> since the last reset (system startup or reenabling of the interrupt
> line). It is intended for interrupt system diagnostics.
> 
> Using '$ cat /proc/irq/*/spurious' one can get a quick overview of the
> operating state of the patch:
> 
> - Normal interrupts will have count=0 and level_max=0. Under some
> circumstances, a driver may have already performed work belonging to a
> later occurrence of an interrupt. In this case it may return reporting
> an unhandled event so level_max = 1.
> - The interrupts suffering from the problem allegedly caused by the
> ASM1083 PCI bridge will have a count > 0, but not increasing more
> rapidly than 1 / sec.
> - The interrupts which are genuinely stuck will show a steady (1 /
> sec) increase of count.
> 
> This patch does not include modifications to drivers/pci/quirks.c to
> set the SATA interrupt mode of the Asus E450-M1 PRO to MSI. See
> earlier patches for that.
> 
> Please test and/or comment.
> 
> 
> Signed-off-by: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
> ---
> diff -upr linux-3.2.16.orig/include/linux/irqdesc.h
> linux-3.2.16.new/include/linux/irqdesc.h
> --- linux-3.2.16.orig/include/linux/irqdesc.h	2012-04-23
> 00:31:32.000000000 +0200
> +++ linux-3.2.16.new/include/linux/irqdesc.h	2012-04-29 16:33:48.142332693 +0200
> @@ -14,28 +14,29 @@ struct timer_rand_state;
>  struct module;
>  /**
>   * struct irq_desc - interrupt descriptor
> - * @irq_data:		per irq and chip data passed down to chip functions
> - * @timer_rand_state:	pointer to timer rand state struct
> - * @kstat_irqs:		irq stats per cpu
> - * @handle_irq:		highlevel irq-events handler
> - * @preflow_handler:	handler called before the flow handler
> (currently used by sparc)
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
> + * @preflow_handler:		handler called before the flow handler
> (currently used by sparc)
> + * @action:			the irq action chain
> + * @status:			status information
> + * @istate:			core internal status information
> + * @depth:			disable-depth, for nested irq_disable() calls
> + * @wake_depth:			enable depth, for multiple irq_set_irq_wake() callers
> + * @irqs_stuck_count:		stuck interrupt occurrence counter
> + * @irqs_stuck_level:		used for stuck interrupt line detection and
> tracking poll cycle count
> + * @irqs_stuck_level_max:	indicates the maximum irqs_stuck_level
> since last stuck interrupt occurrence
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
>   */
>  struct irq_desc {
>  	struct irq_data		irq_data;
> @@ -47,12 +48,13 @@ struct irq_desc {
>  #endif
>  	struct irqaction	*action;	/* IRQ action list */
>  	unsigned int		status_use_accessors;
> -	unsigned int		core_internal_state__do_not_mess_with_it;
> +	unsigned int		istate;
>  	unsigned int		depth;		/* nested irq disables */
>  	unsigned int		wake_depth;	/* nested wake enables */
> -	unsigned int		irq_count;	/* For detecting broken IRQs */
> -	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
> -	unsigned int		irqs_unhandled;
> +	unsigned int		irqs_stuck_count;
> +	unsigned int		irqs_stuck_level;
> +	unsigned int		irqs_stuck_level_max;
> +	unsigned long		irqs_stuck_timeout;
>  	raw_spinlock_t		lock;
>  	struct cpumask		*percpu_enabled;
>  #ifdef CONFIG_SMP
> diff -upr linux-3.2.16.orig/kernel/irq/debug.h
> linux-3.2.16.new/kernel/irq/debug.h
> --- linux-3.2.16.orig/kernel/irq/debug.h	2012-04-23 00:31:32.000000000 +0200
> +++ linux-3.2.16.new/kernel/irq/debug.h	2012-04-29 16:35:33.782919592 +0200
> @@ -11,8 +11,9 @@
> 
>  static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
>  {
> -	printk("irq %d, desc: %p, depth: %d, count: %d, unhandled: %d\n",
> -		irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
> +	printk("irq %d, desc: %p, depth: %d, stuck_count: %d, stuck_level:
> %d, stuck_level_max: %d, stuck_timeout: %lu\n",
> +		irq, desc, desc->depth, desc->irqs_stuck_count,
> desc->irqs_stuck_level, desc->irqs_stuck_level_max,
> +	        desc->irqs_stuck_timeout);
>  	printk("->handle_irq():  %p, ", desc->handle_irq);
>  	print_symbol("%s\n", (unsigned long)desc->handle_irq);
>  	printk("->irq_data.chip(): %p, ", desc->irq_data.chip);
> diff -upr linux-3.2.16.orig/kernel/irq/internals.h
> linux-3.2.16.new/kernel/irq/internals.h
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
> 
>  /*
>   * Bits used by threaded handlers:
> diff -upr linux-3.2.16.orig/kernel/irq/irqdesc.c
> linux-3.2.16.new/kernel/irq/irqdesc.c
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
> diff -upr linux-3.2.16.orig/kernel/irq/manage.c
> linux-3.2.16.new/kernel/irq/manage.c
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
> diff -upr linux-3.2.16.orig/kernel/irq/spurious.c
> linux-3.2.16.new/kernel/irq/spurious.c
> --- linux-3.2.16.orig/kernel/irq/spurious.c	2012-04-23 00:31:32.000000000 +0200
> +++ linux-3.2.16.new/kernel/irq/spurious.c	2012-04-29 18:26:59.848127250 +0200
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
> +
> +		irq = desc->irq_data.irq;
> +		if (unlikely(desc->irqs_stuck_level == 1))
> +			if (desc->irqs_stuck_count <= SPURIOUS_IRQ_REPORT_COUNT)
> +				printk(KERN_EMERG "Polling handlers for IRQ %d.\n", irq);
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
> +	if (unlikely(try_misrouted_irq(irq, desc, action_ret)))
> +		if (misrouted_irq(irq))
> +			action_ret = IRQ_HANDLED;
> +
> +	if (unlikely(action_ret == IRQ_NONE) && time_before(jiffies,
> desc->irqs_stuck_timeout)) {
> +		desc->irqs_stuck_level++;
> +		if (desc->irqs_stuck_level > desc->irqs_stuck_level_max)
> +			desc->irqs_stuck_level_max = desc->irqs_stuck_level;
> +		if (desc->irqs_stuck_level >= SPURIOUS_IRQ_TRIGGER) { /* The
> interrupt is stuck */
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
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
