Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab0LJCHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 21:07:55 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63811 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0LJCHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 21:07:53 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6192"; a="66027186"
Message-ID: <4D018B78.4010901@codeaurora.org>
Date: Thu, 09 Dec 2010 18:07:52 -0800
From: Jeff Ohlstein <johlstei@codeaurora.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100623)
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Brian Swetland <swetland@google.com>,
        Dima Zavin <dima@android.com>,
        =?windows-1252?Q?=3F?= <arve@android.com>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>
Subject: Re: [PATCH v2 4/6] msm: timer: SMP timer support for msm
References: <1291782501-3909-1-git-send-email-johlstei@codeaurora.org> <1291782501-3909-5-git-send-email-johlstei@codeaurora.org>
In-Reply-To: <1291782501-3909-5-git-send-email-johlstei@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Ohlstein wrote:
> Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
> ---
>  arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    6 +-
>  arch/arm/mach-msm/io.c                          |    1 +
>  arch/arm/mach-msm/timer.c                       |  130 +++++++++++++++++++----
>  3 files changed, 115 insertions(+), 22 deletions(-)
>
> diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
> index 45bab50..873e0b7 100644
> --- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
> +++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
> @@ -60,7 +60,11 @@
>  
>  #define MSM_TMR_BASE		IOMEM(0xF0200000)
>  #define MSM_TMR_PHYS		0x02000000
> -#define MSM_TMR_SIZE		(SZ_1M)
> +#define MSM_TMR_SIZE		SZ_4K
> +
> +#define MSM_TMR0_BASE		IOMEM(0xF0201000)
> +#define MSM_TMR0_PHYS		0x02040000
> +#define MSM_TMR0_SIZE		SZ_4K
>  
>  #define MSM_GPT_BASE		(MSM_TMR_BASE + 0x4)
>  #define MSM_DGT_BASE		(MSM_TMR_BASE + 0x24)
> diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
> index d36b610..b826b6b 100644
> --- a/arch/arm/mach-msm/io.c
> +++ b/arch/arm/mach-msm/io.c
> @@ -105,6 +105,7 @@ static struct map_desc msm8x60_io_desc[] __initdata = {
>  	MSM_DEVICE(QGIC_DIST),
>  	MSM_DEVICE(QGIC_CPU),
>  	MSM_DEVICE(TMR),
> +	MSM_DEVICE(TMR0),
>  	MSM_DEVICE(ACC),
>  	MSM_DEVICE(GCC),
>  };
> diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
> index 950100f..92ac220 100644
> --- a/arch/arm/mach-msm/timer.c
> +++ b/arch/arm/mach-msm/timer.c
> @@ -47,6 +47,19 @@ enum {
>  
>  #define GPT_HZ 32768
>  
> +enum timer_location {
> +	LOCAL_TIMER = 0,
> +	GLOBAL_TIMER = 1,
> +};
> +
> +#ifdef MSM_TMR0_BASE
> +#define MSM_TMR_GLOBAL		(MSM_TMR0_BASE - MSM_TMR_BASE)
> +#else
> +#define MSM_TMR_GLOBAL		0
> +#endif
> +
> +#define MSM_GLOBAL_TIMER MSM_CLOCK_DGT
> +
>  #if defined(CONFIG_ARCH_QSD8X50)
>  #define DGT_HZ (19200000 / 4) /* 19.2 MHz / 4 by default */
>  #define MSM_DGT_SHIFT (0)
> @@ -65,49 +78,67 @@ struct msm_clock {
>  	void __iomem                *regbase;
>  	uint32_t                    freq;
>  	uint32_t                    shift;
> +	void                        *global_counter;
> +	void                        *local_counter;
>  };
>  
> +enum {
> +	MSM_CLOCK_GPT,
> +	MSM_CLOCK_DGT,
> +	NR_TIMERS,
> +};
> +
> +
> +static struct msm_clock msm_clocks[];
> +static struct clock_event_device *local_clock_event;
> +
>  static irqreturn_t msm_timer_interrupt(int irq, void *dev_id)
>  {
>  	struct clock_event_device *evt = dev_id;
> +	if (smp_processor_id() != 0)
> +		evt = local_clock_event;
> +	if (evt->event_handler == NULL)
> +		return IRQ_HANDLED;
>  	evt->event_handler(evt);
>  	return IRQ_HANDLED;
>  }
>  
> -static cycle_t msm_gpt_read(struct clocksource *cs)
> +static cycle_t msm_read_timer_count(struct clocksource *cs)
>  {
> -	return readl(MSM_GPT_BASE + TIMER_COUNT_VAL);
> +	struct msm_clock *clk = container_of(cs, struct msm_clock, clocksource);
> +
> +	return readl(clk->global_counter) >> clk->shift;
>  }
>  
> -static cycle_t msm_dgt_read(struct clocksource *cs)
> +static struct msm_clock *clockevent_to_clock(struct clock_event_device *evt)
>  {
> -	return readl(MSM_DGT_BASE + TIMER_COUNT_VAL) >> MSM_DGT_SHIFT;
> +#ifdef CONFIG_SMP
> +	int i;
> +	for (i = 0; i < NR_TIMERS; i++)
> +		if (evt == &(msm_clocks[i].clockevent))
> +			return &msm_clocks[i];
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
> +	uint32_t now = readl(clock->local_counter);
>  	uint32_t alarm = now + (cycles << clock->shift);
> -	int late;
>  
>  	writel(alarm, clock->regbase + TIMER_MATCH_VAL);
> -	now = readl(clock->regbase + TIMER_COUNT_VAL);
> -	late = now - alarm;
> -	if (late >= (-2 << clock->shift) && late < DGT_HZ*5) {
> -		printk(KERN_NOTICE "msm_timer_set_next_event(%lu) clock %s, "
> -		       "alarm already expired, now %x, alarm %x, late %d\n",
> -		       cycles, clock->clockevent.name, now, alarm, late);
> -		return -ETIME;
> -	}
>  	return 0;
>  }
>  
>  static void msm_timer_set_mode(enum clock_event_mode mode,
>  			      struct clock_event_device *evt)
>  {
> -	struct msm_clock *clock = container_of(evt, struct msm_clock, clockevent);
> +	struct msm_clock *clock = clockevent_to_clock(evt);
> +
>  	switch (mode) {
>  	case CLOCK_EVT_MODE_RESUME:
>  	case CLOCK_EVT_MODE_PERIODIC:
> @@ -135,7 +166,7 @@ static struct msm_clock msm_clocks[] = {
>  		.clocksource = {
>  			.name           = "gp_timer",
>  			.rating         = 200,
> -			.read           = msm_gpt_read,
> +			.read           = msm_read_timer_count,
>  			.mask           = CLOCKSOURCE_MASK(32),
>  			.shift          = 17,
>  			.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
> @@ -148,7 +179,10 @@ static struct msm_clock msm_clocks[] = {
>  			.irq     = INT_GP_TIMER_EXP
>  		},
>  		.regbase = MSM_GPT_BASE,
> -		.freq = GPT_HZ
> +		.freq = GPT_HZ,
> +		.local_counter = MSM_GPT_BASE + TIMER_COUNT_VAL,
> +		.global_counter = MSM_GPT_BASE + TIMER_COUNT_VAL +
> +			MSM_TMR_GLOBAL,
>  	},
>  	{
>  		.clockevent = {
> @@ -162,7 +196,7 @@ static struct msm_clock msm_clocks[] = {
>  		.clocksource = {
>  			.name           = "dg_timer",
>  			.rating         = 300,
> -			.read           = msm_dgt_read,
> +			.read           = msm_read_timer_count,
>  			.mask           = CLOCKSOURCE_MASK((32 - MSM_DGT_SHIFT)),
>  			.shift          = 24 - MSM_DGT_SHIFT,
>  			.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
> @@ -176,7 +210,10 @@ static struct msm_clock msm_clocks[] = {
>  		},
>  		.regbase = MSM_DGT_BASE,
>  		.freq = DGT_HZ >> MSM_DGT_SHIFT,
> -		.shift = MSM_DGT_SHIFT
> +		.shift = MSM_DGT_SHIFT,
> +		.local_counter = MSM_DGT_BASE + TIMER_COUNT_VAL,
> +		.global_counter = MSM_DGT_BASE + TIMER_COUNT_VAL +
> +			MSM_TMR_GLOBAL,
>  	}
>  };
>  
> @@ -185,7 +222,7 @@ static void __init msm_timer_init(void)
>  	int i;
>  	int res;
>  
> -#ifdef CONFIG_ARCH_MSM8X60
> +#ifdef CONFIG_ARCH_MSM_SCORPIONMP
>  	writel(DGT_CLK_CTL_DIV_4, MSM_TMR_BASE + DGT_CLK_CTL);
>  #endif
>  
> @@ -220,6 +257,57 @@ static void __init msm_timer_init(void)
>  	}
>  }
>  
> +#ifdef CONFIG_SMP
> +void local_timer_setup(struct clock_event_device *evt)
> +{
> +	unsigned long flags;
> +	struct msm_clock *clock = &msm_clocks[MSM_GLOBAL_TIMER];
> +
> +	writel(DGT_CLK_CTL_DIV_4, MSM_TMR_BASE + DGT_CLK_CTL);
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
> +	local_irq_restore(flags);
> +
> +	clockevents_register_device(evt);
> +}
> +
> +inline int local_timer_ack(void)
> +{
> +	return 1;
> +}
> +
> +#ifdef CONFIG_HOTPLUG_CPU
> +void __cpuexit local_timer_stop(void)
> +{
> +	struct msm_clock *clock = clockevent_to_clock(local_clock_event);
> +	writel(0, clock->regbase + TIMER_MATCH_VAL);
> +	writel(0, clock->regbase + TIMER_ENABLE);
> +	get_irq_chip(local_clock_event->irq)->mask(local_clock_event->irq);
> +}
> +#endif
> +#endif
> +
>  struct sys_timer msm_timer = {
>  	.init = msm_timer_init
>  };
>   
Thomas, do you have any additional thoughts on this? Did I answer your 
questions
sufficiently in the other thread?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

