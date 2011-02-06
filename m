Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab1BFBDs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 20:03:48 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51069 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab1BFBDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 20:03:47 -0500
Date: Sun, 6 Feb 2011 01:03:43 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: John Linn <john.linn@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, catalin.marinas@arm.com, glikely@secretlab.ca,
        Kiran Sutariya <kiran.sutariya@einfochips.com>
Subject: Re: [PATCH 3/4] ARM: Xilinx: Adding timer support to the platform
Message-ID: <20110206010343.GB5563@pulham.picochip.com>
References: <1296922637-24662-1-git-send-email-john.linn@xilinx.com>
 <1296922637-24662-2-git-send-email-john.linn@xilinx.com>
 <1296922637-24662-3-git-send-email-john.linn@xilinx.com>
 <66f1ca90-76f5-4571-b10e-8b79f62e5275@VA3EHSMHS020.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66f1ca90-76f5-4571-b10e-8b79f62e5275@VA3EHSMHS020.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

A couple more nitpicks.

Jamie

On Sat, Feb 05, 2011 at 09:17:16AM -0700, John Linn wrote:
> The timer driver supports the Xilinx PS Timer Counter IP.
> 
> Signed-off-by: Kiran Sutariya <kiran.sutariya@einfochips.com>
> Signed-off-by: John Linn <john.linn@xilinx.com>
> ---
>  arch/arm/mach-xilinx/timer.c |  452 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 452 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-xilinx/timer.c
> 
> diff --git a/arch/arm/mach-xilinx/timer.c b/arch/arm/mach-xilinx/timer.c
> new file mode 100644
> index 0000000..c713e3c
> --- /dev/null
> +++ b/arch/arm/mach-xilinx/timer.c
> @@ -0,0 +1,452 @@
> +/* arch/arm/mach-xilinx/timer.c
> + *
> + * This file contains driver for the Xilinx PS Timer Counter IP.
> + *
> + *  Copyright (C) 2011 Xilinx
> + *
> + * based on arch\mips\kernel\time.c timer driver
> + *
> + * This program is free software; you can redistribute it and/or modify it under
> + * the terms of the GNU General Public License version 2 as published by the
> + * Free Software Foundation; either version 2 of the License, or (at your
> + * option) any later version.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
> + * Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/types.h>
> +#include <linux/clocksource.h>
> +#include <linux/clockchips.h>
> +#include <linux/io.h>
> +#include <asm/mach/time.h>
> +#include <mach/hardware.h>
> +
> +/*
> + * This driver configures the 2 16-bit count-up timers as follows:
> + *
> + * T1: Timer 1, clocksource for generic timekeeping
> + * T2: Timer 2, clockevent source for hrtimers
> + * T3: Timer 3, <unused>
> + *
> + * The input frequency to the timer module is 200MHz which is common to all the
> + * timer channel (T1, T2, and T3)
> + * Clocksource timer resolution is 160ns
> + * Clockevent timer resolution is 160ns
> + */
> +#define XTTCPSS_CLOCKSOURCE	0	/* Timer 1 as a generic timekeeping */
> +#define XTTCPSS_CLOCKEVENT	1	/* Timer 2 as a clock event */
> +
> +#define XTTCPSS_TIMER_BASE	TTC0_BASE
> +
> +/*
> + * Timer Register Offset Definitions of Timer 1, Increment base address by 4
> + * and use same offsets for Timer 2
> + */
> +#define XTTCPSS_CLK_CNTRL_OFFSET	0x00 /* Clock Control Reg, RW */
> +#define XTTCPSS_CNT_CNTRL_OFFSET	0x0C /* Counter Control Reg, RW */
> +#define XTTCPSS_COUNT_VAL_OFFSET	0x18 /* Counter Value Reg, RO */
> +#define XTTCPSS_INTR_VAL_OFFSET		0x24 /* Interval Count Reg, RW */
> +#define XTTCPSS_MATCH_1_OFFSET		0x30 /* Match 1 Value Reg, RW */
> +#define XTTCPSS_MATCH_2_OFFSET		0x3C /* Match 2 Value Reg, RW */
> +#define XTTCPSS_MATCH_3_OFFSET		0x48 /* Match 3 Value Reg, RW */
> +#define XTTCPSS_ISR_OFFSET		0x54 /* Interrupt Status Reg, RO */
> +#define XTTCPSS_IER_OFFSET		0x60 /* Interrupt Enable Reg, RW */
> +
> +/*
> + * Bit mask to enable/disable the timer
> + */
> +#define XTTCPSS_CNT_CNTRL_ENABLE_MASK	0xFFFFFFFE

I found this really confusing reading through the code, but that's 
probably just me!  Perhaps if this was called 
XTTCPSS_CNT_CNTRL_DISABLE_MASK and defined to 1 then that might be a 
little easier to follow.

> +
> +/*
> + * Definitions of the timer read/write macro
> + */
> +#define xttcpss_read(addr)	__raw_readl((void __iomem *)addr)
> +#define xttcpss_write(addr, val) __raw_writel(val, (void __iomem *)(addr))
> +
> +
> +/**
> + * struct xttcpss_timer - This definition defines local timer structure
> + *
> + * @name:	Name of Timer
> + * @base_addr:	Base address of timer
> + * @timer_irq:	irqaction structure for the timer device
> + * @mode:       only valid for an clock event, periodic or one-shot
> + **/
> +struct xttcpss_timer {
> +	char *name;
> +	unsigned long base_addr;

Shouldn't this really be a void __iomem pointer?  This could eliminate 
the need for xttcpss_write and xttcpss_read.

> +	struct irqaction timer_irq;
> +	enum clock_event_mode mode;
> +};
> +
> +
> +static struct xttcpss_timer timers[];
> +static struct clock_event_device xttcpss_clockevent;
> +
> +/*
> + * xttcpss_timer_irqs - Timers IRQ number
> + */
> +static int xttcpss_timer_irqs[2] = {
> +	IRQ_TIMERCOUNTER0,	/* Timer 1 IRQ number */
> +	IRQ_TIMERCOUNTER0 + 1,	/* Timer 2 IRQ number */
> +};
> +
> +/**
> + * xttcpss_set_interval - Set the timer interval value
> + *
> + * @timer:	Pointer to the timer instance
> + * @cycles:	Timer interval ticks
> + **/
> +static void xttcpss_set_interval(struct xttcpss_timer *timer,
> +					unsigned long cycles)
> +{
> +	u32 ctrl_reg;
> +
> +	/* Disable the counter, set the counter value  and re-enable counter */
> +	ctrl_reg = xttcpss_read(timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
> +	ctrl_reg |= ~(XTTCPSS_CNT_CNTRL_ENABLE_MASK);
> +	xttcpss_write(timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET, 
> ctrl_reg);
> +
> +	pr_debug("set_interval, name = %s, period = %08X\n",
> +			timer->name, (unsigned int)cycles);
> +
> +	xttcpss_write(timer->base_addr + XTTCPSS_INTR_VAL_OFFSET, cycles);
> +
> +	/* Reset the counter (0x10) so that it starts from 0, one-shot
> +	   mode makes this needed for timing to be right. */
> +	ctrl_reg &= XTTCPSS_CNT_CNTRL_ENABLE_MASK;
> +	ctrl_reg |= 0x10;
> +	xttcpss_write(timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET, 
> ctrl_reg);
> +}
> +
> +/**
> + * xttcpss_clock_source_interrupt - Clock source timer interrupt handler
> + *
> + * @irq:	IRQ number of the Timer
> + * @dev_id:	void pointer to the xttcpss_timer instance
> + *
> + * This will be called when 16-bit clock source counter wraps
> + *
> + * returns: Always IRQ_HANDLED - success
> + **/
> +static irqreturn_t xttcpss_clock_source_interrupt(int irq, void *dev_id)
> +{
> +	struct xttcpss_timer *timer = dev_id;
> +
> +	/* Acknowledge the interrupt */
> +	xttcpss_write(timer->base_addr + XTTCPSS_ISR_OFFSET,
> +		xttcpss_read(timer->base_addr + XTTCPSS_ISR_OFFSET));
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/**
> + * xttcpss_clock_event_interrupt - Clock event timer interrupt handler
> + *
> + * @irq:	IRQ number of the Timer
> + * @dev_id:	void pointer to the xttcpss_timer instance
> + *
> + * returns: Always IRQ_HANDLED - success
> + **/
> +static irqreturn_t xttcpss_clock_event_interrupt(int irq, void *dev_id)
> +{
> +	struct clock_event_device *evt = &xttcpss_clockevent;
> +	struct xttcpss_timer *timer = dev_id;
> +	u32 ctrl_reg;
> +
> +	/* Acknowledge the interrupt and call event handler */
> +	xttcpss_write(timer->base_addr + XTTCPSS_ISR_OFFSET,
> +		xttcpss_read(timer->base_addr + XTTCPSS_ISR_OFFSET));
> +
> +	if (timer->mode == CLOCK_EVT_MODE_ONESHOT) {
> +
> +		/* Disable the counter as it would keep running. */
> +		ctrl_reg = xttcpss_read(timer->base_addr +
> +					XTTCPSS_CNT_CNTRL_OFFSET);
> +		ctrl_reg |= ~(XTTCPSS_CNT_CNTRL_ENABLE_MASK);

The clock events framework should reprogram the next event so you don't 
actually need to disable the timer here.  Once the event handler has 
been called the timer will be reenabled with a new period, and as we're 
running with interrupts disabled here we don't need to stop the timer.

> +		xttcpss_write(timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET,
> +				ctrl_reg);
> +	}
> +
> +	evt->event_handler(evt);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/*
> + * struct xttcpss_timer timers - This definition defines local timers
> + */
> +static struct xttcpss_timer timers[] = {
> +	[XTTCPSS_CLOCKSOURCE] = {
> +		.name = "xttcpss clocksource",
> +		.timer_irq = {
> +			.flags = IRQF_DISABLED | IRQF_TIMER,
> +			.handler = xttcpss_clock_source_interrupt,
> +		}
> +	},
> +	[XTTCPSS_CLOCKEVENT] = {
> +		.name = "xttcpss clockevent",
> +		.timer_irq = {
> +			.flags = IRQF_DISABLED | IRQF_TIMER,
> +			.handler = xttcpss_clock_event_interrupt,
> +		}
> +	},
> +};
> +
> +
> +/**
> + * xttcpss_timer_hardware_init - Initialize the timer hardware
> + *
> + * Initialize the hardware, registers the timer interrupts, set the clock source
> + * timer interval and enable the clock source timer
> + **/
> +static void __init xttcpss_timer_hardware_init(void)
> +{
> +	int timer_id;
> +	struct xttcpss_timer *timer;
> +
> +	for (timer_id = 0; timer_id < ARRAY_SIZE(timers); timer_id++) {
> +		timer = &timers[timer_id];
> +
> +		if (!(timer->name))
> +			continue;
> +
> +		timer->base_addr = XTTCPSS_TIMER_BASE + (4*timer_id);
> +
> +		/* Disable counter, Enable Interval mode, Count up timer,
> +		 * Disable Match mode, Internal Clock source select, set
> +		 * prescalar to 32, and Enable the Interval interrupt */
> +		xttcpss_write(timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET,
> +				0x23);
> +		xttcpss_write(timer->base_addr + XTTCPSS_CLK_CNTRL_OFFSET, 0x9);
> +		xttcpss_write(timer->base_addr + XTTCPSS_IER_OFFSET, 0x1);
> +
> +		/* Setup IRQ */
> +		timer->timer_irq.name = timer->name;
> +		timer->timer_irq.dev_id = (void *)timer;
> +		if (timer->timer_irq.handler != NULL) {
> +			setup_irq(xttcpss_timer_irqs[timer_id],
> +				&timer->timer_irq);
> +		}
> +		if (timer_id == XTTCPSS_CLOCKSOURCE)
> +			xttcpss_set_interval(timer, ~0);
> +	}
> +}
> +
> +/**
> + * xttcpss_read_cycles - Reads the timer counter register
> + *
> + * returns: Current timer counter register value
> + **/
> +static cycle_t xttcpss_read_cycles(struct clocksource *cs)
> +{
> +	struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKSOURCE];
> +
> +	return (cycle_t)xttcpss_read(timer->base_addr +
> +				XTTCPSS_COUNT_VAL_OFFSET);
> +}
> +
> +
> +/*
> + * Instantiate and initialize the clock source structure
> + */
> +static struct clocksource clocksource_xttcpss = {
> +	.name		= "xttcpss_timer1",
> +	.rating		= 200,			/* Reasonable clock source */
> +	.read		= xttcpss_read_cycles,
> +	.mask		= CLOCKSOURCE_MASK(16),
> +	.shift		= 0,			/* Initialized to zero */
> +	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
> +};
> +
> +
> +/**
> + * xttcpss_set_next_event - Sets the time interval for next event
> + *
> + * @cycles:	Timer interval ticks
> + * @evt:	Address of clock event instance
> + *
> + * returns: Always 0 - success
> + **/
> +static int xttcpss_set_next_event(unsigned long cycles,
> +					struct clock_event_device *evt)
> +{
> +	struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKEVENT];
> +
> +	xttcpss_set_interval(timer, cycles);
> +	return 0;
> +}
> +
> +/**
> + * xttcpss_set_mode - Sets the mode of timer
> + *
> + * @mode:	Mode to be set
> + * @evt:	Address of clock event instance
> + **/
> +static void xttcpss_set_mode(enum clock_event_mode mode,
> +					struct clock_event_device *evt)
> +{
> +	struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKEVENT];
> +	u32 ctrl_reg;
> +
> +	timer->mode = mode;
> +
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_PERIODIC:
> +		xttcpss_set_interval(timer, CLOCK_TICK_RATE / HZ);
> +		break;
> +	case CLOCK_EVT_MODE_ONESHOT:
> +	case CLOCK_EVT_MODE_UNUSED:
> +	case CLOCK_EVT_MODE_SHUTDOWN:
> +		ctrl_reg = xttcpss_read(timer->base_addr +
> +					XTTCPSS_CNT_CNTRL_OFFSET);
> +		ctrl_reg |= ~(XTTCPSS_CNT_CNTRL_ENABLE_MASK);
> +		xttcpss_write(timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET,
> +				ctrl_reg);
> +		break;
> +	case CLOCK_EVT_MODE_RESUME:
> +		ctrl_reg = xttcpss_read(timer->base_addr +
> +					XTTCPSS_CNT_CNTRL_OFFSET);
> +		ctrl_reg &= XTTCPSS_CNT_CNTRL_ENABLE_MASK;
> +		xttcpss_write(timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET,
> +				ctrl_reg);
> +		break;
> +	}
> +}
> +
> +/*
> + * Instantiate and initialize the clock event structure
> + */
> +static struct clock_event_device xttcpss_clockevent = {
> +	.name		= "xttcpss_timer2",
> +	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
> +	.shift		= 0,		/* Initialized to zero */
> +	.set_next_event	= xttcpss_set_next_event,
> +	.set_mode	= xttcpss_set_mode,
> +	.rating		= 200,
> +};
> +
> +/**
> + * xttcpss_timer_init - Initialize the timer
> + *
> + * Initializes the timer hardware and registers the clock source and clock event
> + * timers with Linux kernal timer framework
> + **/
> +static void __init xttcpss_timer_init(void)
> +{
> +	u32 shift;
> +	u64 temp;
> +
> +	xttcpss_timer_hardware_init();
> +
> +	/* Calculate the nanoseconds to cycles divisor value for clock source
> +	 * timer */
> +	for (shift = 16; shift > 0; shift--) {
> +		temp = (u64) NSEC_PER_SEC << shift;
> +		do_div(temp, CLOCK_TICK_RATE);
> +		if ((temp >> 32) == 0)
> +			break;
> +	}
> +
> +	/* Setup clocksource */
> +	clocksource_xttcpss.shift = shift;
> +	clocksource_xttcpss.mult =
> +		clocksource_hz2mult(CLOCK_TICK_RATE, clocksource_xttcpss.shift);
> +
> +	if (clocksource_register(&clocksource_xttcpss))
> +		printk(KERN_ERR "xttcpss_timer_init: can't register clocksource"
> +				" for %s\n", clocksource_xttcpss.name);

If you use clocksource_register_hz() then you don't need to worry about 
calculating shift and mult, the generic framework will do that for you.

> +	/* Calculate the nanoseconds to cycles divisor value for clock event
> +	 * timer */
> +	for (shift = 16; shift > 0; shift--) {
> +		temp = (u64) CLOCK_TICK_RATE << shift;
> +		do_div(temp, NSEC_PER_SEC);
> +		if ((temp >> 32) == 0)
> +			break;
> +	}
> +
> +	/* Setup clockevent */
> +	xttcpss_clockevent.shift = shift;
> +	xttcpss_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC,
> +						 xttcpss_clockevent.shift);

clockevents_calc_mult_shift()?

> +
> +	xttcpss_clockevent.max_delta_ns =
> +		clockevent_delta2ns(0xfffe, &xttcpss_clockevent);
> +	xttcpss_clockevent.min_delta_ns =
> +		clockevent_delta2ns(1, &xttcpss_clockevent);
> +
> +	xttcpss_clockevent.cpumask = cpumask_of(0);
> +	clockevents_register_device(&xttcpss_clockevent);
> +}
> +
> +#ifdef CONFIG_PM
> +/**
> + * xttcpss_timer_suspend - Suspend the timer
> + *
> + * Disables all (clock source and clock event) the timers
> + **/
> +static void xttcpss_timer_suspend(void)
> +{
> +	struct xttcpss_timer *source_timer = &timers[XTTCPSS_CLOCKSOURCE];
> +	struct xttcpss_timer *event_timer = &timers[XTTCPSS_CLOCKEVENT];
> +	u32 ctrl_reg;
> +
> +	/* Disable clocksource timer */
> +	ctrl_reg = xttcpss_read(source_timer->base_addr +
> +				XTTCPSS_CNT_CNTRL_OFFSET);
> +	ctrl_reg |= ~(XTTCPSS_CNT_CNTRL_ENABLE_MASK);
> +	xttcpss_write(source_timer->base_addr + 
> XTTCPSS_CNT_CNTRL_OFFSET,
> +				ctrl_reg);
> +
> +	/* Disable clockevent timer */
> +	ctrl_reg = xttcpss_read(event_timer->base_addr +
> +				XTTCPSS_CNT_CNTRL_OFFSET);
> +	ctrl_reg |= ~(XTTCPSS_CNT_CNTRL_ENABLE_MASK);
> +	xttcpss_write(event_timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET,
> +				ctrl_reg);
> +}
> +
> +/**
> + * xttcpss_timer_resume - Resume the timer
> + *
> + * Enables  all (clock source and clock event) the timers
> + **/
> +static void xttcpss_timer_resume(void)
> +{
> +	struct xttcpss_timer *source_timer = &timers[XTTCPSS_CLOCKSOURCE];
> +	struct xttcpss_timer *event_timer = &timers[XTTCPSS_CLOCKEVENT];
> +	u32 ctrl_reg;
> +
> +	/* Enable clocksource timer */
> +	ctrl_reg = xttcpss_read(source_timer->base_addr +
> +				XTTCPSS_CNT_CNTRL_OFFSET);
> +	ctrl_reg &= XTTCPSS_CNT_CNTRL_ENABLE_MASK;
> +	xttcpss_write(source_timer->base_addr + 
> XTTCPSS_CNT_CNTRL_OFFSET,
> +				ctrl_reg);
> +
> +	/* Enable clockevent timer */
> +	ctrl_reg = xttcpss_read(event_timer->base_addr +
> +				XTTCPSS_CNT_CNTRL_OFFSET);
> +	ctrl_reg &= XTTCPSS_CNT_CNTRL_ENABLE_MASK;
> +	xttcpss_write(event_timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET,
> +				ctrl_reg);
> +}
> +#else
> +#define xttcpss_timer_suspend NULL
> +#define xttcpss_timer_resume NULL
> +#endif
> +
> +/*
> + * Instantiate and initialize the system timer structure
> + */
> +struct sys_timer xttcpss_sys_timer = {
> +	.init		= xttcpss_timer_init,
> +	.suspend	= xttcpss_timer_suspend,
> +	.resume		= xttcpss_timer_resume,
> +};
> -- 
> 1.6.2.1
> 
> 
> 
> This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
