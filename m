Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab3ABHOC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 02:14:02 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:52436 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3ABHN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 02:13:58 -0500
Message-ID: <50E3DE29.6020403@synopsys.com>
Date: Wed, 2 Jan 2013 12:43:45 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Frederic Weisbecker <fweisbec@gmail.com>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 15/31] ARC: Process/scheduling/clock/Timers/Delay
 Management
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-16-git-send-email-vgupta@synopsys.com> <alpine.LFD.2.02.1211122110230.10000@ionos>
In-Reply-To: <alpine.LFD.2.02.1211122110230.10000@ionos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2012 01:59 AM, Thomas Gleixner wrote:
> On Wed, 7 Nov 2012, Vineet Gupta wrote:
>> +void cpu_idle(void)
>> +{
>> +	/* Since we SLEEP in idle loop, TIF_POLLING_NRFLAG can't be set */
>> +
>> +	/* endless idle loop with no priority at all */
>> +	while (1) {
>> +		tick_nohz_idle_enter();
>> +
>> +		while (!need_resched())
>> +			arch_idle();
>> +
>> +		tick_nohz_idle_exit();
>> +
>> +		preempt_enable_no_resched();
>> +		schedule();
>> +		preempt_disable();
> 
>   		schedule_preempt_disabled() please


OK ! And it seems I was also missing the calls to rcu_idle_enter()/exit() to track
commit 1268fbc746ea  "nohz: Remove tick_nohz_idle_enter_norcu() / ..."


>> +	}
> 
>> diff --git a/arch/arc/kernel/time.c b/arch/arc/kernel/time.c
>>
>> +static void arc_periodic_timer_setup(unsigned int limit)
>> +{
>> +	/* setup start and end markers */
>> +	write_aux_reg(ARC_REG_TIMER0_LIMIT, limit);
>> +	write_aux_reg(ARC_REG_TIMER0_CNT, 0);	/* start from 0 */
>> +
>> +	/* IE: Interrupt on count = limit,
>> +	 * NH: Count cycles only when CPU running (NOT Halted)
>> +	 */
>> +	write_aux_reg(ARC_REG_TIMER0_CTRL, TIMER_CTRL_IE | TIMER_CTRL_NH);
>> +}
>> +
>> +/*
>> + * Acknowledge the interrupt & enable/disable the interrupt
>> + */
>> +static void arc_periodic_timer_ack(unsigned int irq_reenable)
>> +{
>> +	/* 1. Ack the interrupt by writing to CTRL reg.
>> +	 *    Any write will cause intr to be ack, however it has to be one of
>> +	 *    writable bits (NH: Count when not halted)
>> +	 * 2. If required by caller, re-arm timer to Interrupt at the end of
>> +	 *    next cycle.
>> +	 *
>> +	 * Small optimisation:
>> +	 * Normal code would have been
>> +	 *  if (irq_reenable) CTRL_REG = (IE | NH); else CTRL_REG = NH;
>> +	 * However since IE is BIT0 we can fold the branch
>> +	 */
>> +	write_aux_reg(ARC_REG_TIMER0_CTRL, irq_reenable | TIMER_CTRL_NH);
>> +}
> 
> ....
> 
>> +/********** Clock Event Device *********/
>> +
>> +static int arc_clkevent_set_next_event(unsigned long delta,
>> +				    struct clock_event_device *dev)
>> +{
>> +	arc_periodic_timer_setup(delta);
> 
> This is confusing. Is arc_periodic_timer_setup() setting up a periodic
> timer or a oneshot timer? It looks you use it for both and the
> differentiation happens in arc_periodic_timer_ack(). So I assume the
> timer only knows about periodic mode, but you trick it into oneshot
> with the ack function, right ? 

I would think it's the other way round - timer counts upto limit and then
interrupts - which needs to be acknowledged. And as part of ACKing it we can
wiggle an additional bit to re-arm it again (for same limit). Thus it is basically
one-shot which can be made periodic w/o much additional effort.


> So it's just me being confused about
> the function names, but that could do with some explanatory comments.
> 

Function names updated and more comment added to hopefully clarify it for v2 series.


>> +	return 0;
>> +}
>> +
>> +static void arc_clkevent_set_mode(enum clock_event_mode mode,
>> +			       struct clock_event_device *dev)
>> +{
>> +	pr_info("Device [%s] clockevent mode now [%d]\n", dev->name, mode);
> 
> Please remove the debug leftover.

OK !


>> +	switch (mode) {
>> +	case CLOCK_EVT_MODE_PERIODIC:
>> +		arc_periodic_timer_setup(CONFIG_ARC_PLAT_CLK / HZ);
>> +		break;
>> +	case CLOCK_EVT_MODE_ONESHOT:
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return;
>> +}
>> +
>> +static DEFINE_PER_CPU(struct clock_event_device, arc_clockevent_device) = {
>> +	.name		= "ARC Timer0",
>> +	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
>> +	.mode		= CLOCK_EVT_MODE_UNUSED,
>> +	.rating		= 300,
>> +	.irq		= TIMER0_IRQ,	/* hardwired, no need for resources */
>> +	.set_next_event = arc_clkevent_set_next_event,
>> +	.set_mode	= arc_clkevent_set_mode,
>> +};
>> +
>> +irqreturn_t timer_irq_handler(int irq, void *dev_id)
> 
> static please

Done !

> 
>> +static int arc_finished_booting;
>> +
>> +/*
>> + * Scheduler clock - returns current time in nanosec units.
>> + * It's return value must NOT wrap around.
>> + *
>> + * Although the return value is nanosec units based, what's more important
>> + * is whats the "source" of this value. The orig jiffies based computation
>> + * was only as granular as jiffies itself (10ms on ARC).
>> + * We need something that is more granular, so use the same mechanism as
>> + * gettimeofday(), which uses ARC Timer T1 wrapped as a clocksource.
>> + * Unfortunately the first call to sched_clock( ) is way before that subsys
>> + * is initialiased, thus use the jiffies based value in the interim.
>> + */
>> +unsigned long long sched_clock(void)
>> +{
>> +	if (!arc_finished_booting) {
>> +		return (unsigned long long)(jiffies - INITIAL_JIFFIES)
>> +		    * (NSEC_PER_SEC / HZ);
>> +	} else {
>> +		struct timespec ts;
>> +		getrawmonotonic(&ts);
> 
> This can live lock. sched_clock() is used by the tracer. So assume you
> are function tracing and you trace a function called from within the
> timekeeping seqcount write "locked" region. You spin forever in
> getrawmonotonic(). Not what you want, right ?

Correct- so that means we need an equivalent of partially open-code
getrawmonotonic w/o any locks here - read the clocksource directly just as other
arches.

Thx,
-Vineet
