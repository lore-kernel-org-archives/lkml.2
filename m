Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab0LFJ4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 04:56:47 -0500
Received: from www.tglx.de ([62.245.132.106]:53595 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab0LFJ4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 04:56:45 -0500
Date: Mon, 6 Dec 2010 10:56:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeff Ohlstein <johlstei@codeaurora.org>
cc: Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        arve@android.com, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>
Subject: Re: [PATCH 3/5] msm: timer: SMP timer support for msm
In-Reply-To: <1291619778-30289-4-git-send-email-johlstei@codeaurora.org>
Message-ID: <alpine.LFD.2.00.1012061025240.2653@localhost6.localdomain6>
References: <1291619778-30289-1-git-send-email-johlstei@codeaurora.org> <1291619778-30289-4-git-send-email-johlstei@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Dec 2010, Jeff Ohlstein wrote:
> +
> +static struct msm_clock msm_clocks[];
> +static struct clock_event_device *local_clock_event;
> +
>  static irqreturn_t msm_timer_interrupt(int irq, void *dev_id)
>  {
>  	struct clock_event_device *evt = dev_id;
> +	if (smp_processor_id() != 0)
> +		evt = local_clock_event;

Why is dev_id not pointing to the correct device in the first place?

> +	if (evt->event_handler == NULL)
> +		return IRQ_HANDLED;
>  	evt->event_handler(evt);
>  	return IRQ_HANDLED;
>  }
>  
> +static uint32_t msm_read_timer_count(struct msm_clock *clock,
> +				     enum timer_location global)
> +{
> +	uint32_t t1;
> +
> +	if (global)
> +		t1 = readl(clock->regbase + TIMER_COUNT_VAL + MSM_TMR_GLOBAL);
> +	else
> +		t1 = readl(clock->regbase + TIMER_COUNT_VAL);
> +
> +	return t1;

Adding such conditionals into a fast path is brilliant. Granted, gcc
might optimize it out, but I'm not sure given the number of call sites.

What's the point of this exercise ?

> +}
> +
>  static cycle_t msm_gpt_read(struct clocksource *cs)
>  {
> -	return readl(MSM_GPT_BASE + TIMER_COUNT_VAL);
> +	struct msm_clock *clock = &msm_clocks[MSM_CLOCK_GPT];
> +	return msm_read_timer_count(clock, GLOBAL_TIMER);

Why don't you store the address of the read register including the
shift value into the msm_clock structure ?

      clock->counter_reg
      clock->counter_shift

And then embedd the clocksource struct there as well, so you can
dereference msm_clock with container_of() and reduce the 3 read
functions to a single one.

>  }
>  
>  static cycle_t msm_dgt_read(struct clocksource *cs)
>  {
> -	return readl(MSM_DGT_BASE + TIMER_COUNT_VAL) >> MSM_DGT_SHIFT;
> +	struct msm_clock *clock = &msm_clocks[MSM_CLOCK_DGT];
> +
> +	return msm_read_timer_count(clock, GLOBAL_TIMER) >> MSM_DGT_SHIFT;
> +}
> +
> +static struct msm_clock *clockevent_to_clock(struct clock_event_device *evt)
> +{
> +#ifdef CONFIG_SMP
> +	int i;
> +	for (i = 0; i < NR_TIMERS; i++)
> +		if (evt == &(msm_clocks[i].clockevent))
> +			return &msm_clocks[i];

Why don't you use container_of here as well ?

> +	return &msm_clocks[MSM_GLOBAL_TIMER];
> +#else
> +	return container_of(evt, struct msm_clock, clockevent);
> +#endif
>  }
>  
>  static int msm_timer_set_next_event(unsigned long cycles,
>  				    struct clock_event_device *evt)
>  {
> -	struct msm_clock *clock = container_of(evt, struct msm_clock, clockevent);
> -	uint32_t now = readl(clock->regbase + TIMER_COUNT_VAL);
> +	struct msm_clock *clock = clockevent_to_clock(evt);
> +	uint32_t now = msm_read_timer_count(clock, LOCAL_TIMER);
>  	uint32_t alarm = now + (cycles << clock->shift);
>  	int late;
>  
>  	writel(alarm, clock->regbase + TIMER_MATCH_VAL);
> -	now = readl(clock->regbase + TIMER_COUNT_VAL);
> +
> +	now = msm_read_timer_count(clock, LOCAL_TIMER);
>  	late = now - alarm;
>  	if (late >= (-2 << clock->shift) && late < DGT_HZ*5) {
> -		printk(KERN_NOTICE "msm_timer_set_next_event(%lu) clock %s, "
> -		       "alarm already expired, now %x, alarm %x, late %d\n",
> -		       cycles, clock->clockevent.name, now, alarm, late);
> +		static int print_limit = 10;
> +		if (print_limit > 0) {
> +			print_limit--;
> +			printk(KERN_NOTICE "msm_timer_set_next_event(%lu) "
> +			       "clock %s, alarm already expired, now %x, "
> +			       "alarm %x, late %d%s\n",
> +			       cycles, clock->clockevent.name, now, alarm, late,
> +			       print_limit ? "" : " stop printing");
> +		}

The generic clockevents layer has already a check for this. No need
for extra printk spam.

>  		return -ETIME;
>  	}
>  	return 0;
> @@ -107,7 +171,11 @@ static int msm_timer_set_next_event(unsigned long cycles,
>  static void msm_timer_set_mode(enum clock_event_mode mode,
>  			      struct clock_event_device *evt)
>  {
> -	struct msm_clock *clock = container_of(evt, struct msm_clock, clockevent);
> +	struct msm_clock *clock = clockevent_to_clock(evt);
> +	unsigned long irq_flags;
> +
> +	local_irq_save(irq_flags);

Always called with interrupts disabled.

> +
>  	switch (mode) {
>  	case CLOCK_EVT_MODE_RESUME:
>  	case CLOCK_EVT_MODE_PERIODIC:
> @@ -120,6 +188,7 @@ static void msm_timer_set_mode(enum clock_event_mode mode,
>  		writel(0, clock->regbase + TIMER_ENABLE);
>  		break;
>  	}
> +	local_irq_restore(irq_flags);
>  }
>  
>  static struct msm_clock msm_clocks[] = {
> @@ -220,6 +289,58 @@ static void __init msm_timer_init(void)
>  	}
>  }
>  
> +#ifdef CONFIG_SMP
> +void local_timer_setup(struct clock_event_device *evt)
> +{
> +	unsigned long flags;
> +	struct msm_clock *clock = &msm_clocks[MSM_GLOBAL_TIMER];
> +
> +#ifdef CONFIG_ARCH_MSM8X60
> +	writel(DGT_CLK_CTL_DIV_4, MSM_TMR_BASE + DGT_CLK_CTL);
> +#endif
> +
> +	if (!local_clock_event) {
> +		writel(0, clock->regbase  + TIMER_ENABLE);
> +		writel(0, clock->regbase + TIMER_CLEAR);
> +		writel(~0, clock->regbase + TIMER_MATCH_VAL);
> +	}
> +	evt->irq = clock->irq.irq;
> +	evt->name = "local_timer";
> +	evt->features = CLOCK_EVT_FEAT_ONESHOT;
> +	evt->rating = clock->clockevent.rating;
> +	evt->set_mode = msm_timer_set_mode;
> +	evt->set_next_event = msm_timer_set_next_event;
> +	evt->shift = clock->clockevent.shift;
> +	evt->mult = div_sc(clock->freq, NSEC_PER_SEC, evt->shift);
> +	evt->max_delta_ns =
> +		clockevent_delta2ns(0xf0000000 >> clock->shift, evt);
> +	evt->min_delta_ns = clockevent_delta2ns(4, evt);
> +	evt->cpumask = cpumask_of(smp_processor_id());
> +
> +	local_clock_event = evt;
> +
> +	local_irq_save(flags);
> +	get_irq_chip(clock->irq.irq)->unmask(clock->irq.irq);

Why are you fiddling wiht the irqchip functions directly ? Please use
disable_irq/enable_irq if at all.

> +	local_irq_restore(flags);
> +
> +	clockevents_register_device(evt);
> +}
> +
> +int local_timer_ack(void)
> +{
> +	return 1;

Shouldn't that be an inline ? Why calling code which the compiler
could optimize out.

> +}
> +
> +#ifdef CONFIG_HOTPLUG_CPU
> +void __cpuexit local_timer_stop(void)
> +{
> +	local_clock_event->set_mode(CLOCK_EVT_MODE_SHUTDOWN, local_clock_event);

Aarg. No. The generic code already handles cpu hotplug. 

Thanks,

	tglx
