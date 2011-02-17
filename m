Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab1BQO1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:27:16 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:26602
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751768Ab1BQO1O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 09:27:14 -0500
X-SpamScore: -32
X-BigFish: VPS-32(zz1803M542N1432N98dN4015L9371Pc8kzz1202hzz8275bh8275dhz2dh95h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V3 2/4] ARM: Xilinx: Adding timer support to the platform
Date: Thu, 17 Feb 2011 07:27:02 -0700
In-Reply-To: <20110217094801.GC22961@pulham.picochip.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V3 2/4] ARM: Xilinx: Adding timer support to the platform
Thread-Index: AcvOh8x+4bxj04caTs6bX0ttZ7pJhwAJplHA
References: <1297872716-13353-1-git-send-email-john.linn@xilinx.com> <1297872716-13353-2-git-send-email-john.linn@xilinx.com> <28346a1e-ec89-4c09-8fda-f020b58d1fa4@VA3EHSMHS024.ehs.local> <20110217094801.GC22961@pulham.picochip.com>
From: John Linn <John.Linn@xilinx.com>
To: Jamie Iles <jamie@jamieiles.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <arnd@arndb.de>,
        Kiran Sutariya <kiran.sutariya@einfochips.com>
X-OriginalArrivalTime: 17 Feb 2011 14:27:06.0246 (UTC) FILETIME=[C0AE2260:01CBCEAE]
X-RCIS-Action: ALLOW
Message-ID: <c4876a19-558c-4ac3-9984-aeedb9c313ca@VA3EHSMHS033.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jamie Iles [mailto:jamie@jamieiles.com]
> Sent: Thursday, February 17, 2011 2:48 AM
> To: John Linn
> Cc: linux-arm-kernel@lists.infradead.org;
linux-kernel@vger.kernel.org; linux@arm.linux.org.uk;
> catalin.marinas@arm.com; glikely@secretlab.ca; arnd@arndb.de; Kiran
Sutariya
> Subject: Re: [PATCH V3 2/4] ARM: Xilinx: Adding timer support to the
platform
> 
> Hi John,
> 
> A couple more nitpicks.
> 
> Jamie
> 
> On Wed, Feb 16, 2011 at 09:11:54AM -0700, John Linn wrote:
> > The timer driver supports the Xilinx PS Timer Counter IP.
> >
> > Signed-off-by: Kiran Sutariya <kiran.sutariya@einfochips.com>
> > Signed-off-by: John Linn <john.linn@xilinx.com>
> > ---
> >
> > V3 Changes
> >
> > Updates based on Russell Kings' comments
> > 	Changed headers to update the license info and remove
> > 	the address
> >
> > V2 Changes
> >
> > The timer code was changed quite a bit based on review inputs. It
> > got much smaller and cleaner I think.
> >
> > Updates based on Russell King's comments
> > 	minor cleanups for documentation comments
> > 	removed the name from the timer structure
> > 	removed interrupt for clock source
> > 	moved to using clock functions provided in the kernel
> > 		for calculating shift/mult values
> > 	removed PM code as generic handles it
> >
> > Updated based on Jamie Iles's comment
> > 	cleaned up ENABLE_MASK which was confusing
> > 	now using platform_add_devices() from platform code
> > 	moved base_addr to void __iomem pointer
> > 	removed stop of the event timer in one shot mode
> >
> >  arch/arm/mach-xilinx/Makefile |    2 +-
> >  arch/arm/mach-xilinx/timer.c  |  301
+++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 302 insertions(+), 1 deletions(-)
> >  create mode 100644 arch/arm/mach-xilinx/timer.c
> >
> > diff --git a/arch/arm/mach-xilinx/Makefile
b/arch/arm/mach-xilinx/Makefile
> > index 76e9e55..660fb19 100644
> > --- a/arch/arm/mach-xilinx/Makefile
> > +++ b/arch/arm/mach-xilinx/Makefile
> > @@ -3,5 +3,5 @@
> >  #
> >
> >  # Common support
> > -obj-y 				:= common.o
> > +obj-y 				:= common.o timer.o
> >  obj-$(CONFIG_MACH_XILINX)	+= board_ep107.o
> > diff --git a/arch/arm/mach-xilinx/timer.c
b/arch/arm/mach-xilinx/timer.c
> > new file mode 100644
> > index 0000000..f08a2f1
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/timer.c
> > @@ -0,0 +1,301 @@
> > +/* arch/arm/mach-xilinx/timer.c
> > + *
> > + * This file contains driver for the Xilinx PS Timer Counter IP.
> > + *
> > + *  Copyright (C) 2011 Xilinx
> > + *
> > + * based on arch/mips/kernel/time.c timer driver
> > + *
> > + * This software is licensed under the terms of the GNU General
Public
> > + * License version 2, as published by the Free Software Foundation,
and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/init.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/irq.h>
> > +#include <linux/types.h>
> > +#include <linux/clocksource.h>
> > +#include <linux/clockchips.h>
> > +#include <linux/io.h>
> > +
> > +#include <asm/mach/time.h>
> > +#include <mach/xilinx_soc.h>
> > +
> > +/*
> > + * This driver configures the 2 16-bit count-up timers as follows:
> > + *
> > + * T1: Timer 1, clocksource for generic timekeeping
> > + * T2: Timer 2, clockevent source for hrtimers
> > + * T3: Timer 3, <unused>
> > + *
> > + * The input frequency to the timer module for emulation is 2.5MHz
which is
> > + * common to all the timer channels (T1, T2, and T3). With a
pre-scaler of 32,
> > + * the timers are clocked at 78.125KHz (12.8 us resolution).
> > + *
> > + * The input frequency to the timer module in silicon will be
200MHz. With the
> > + * pre-scaler of 32, the timers are clocked at 6.25MHz (160ns
resolution).
> > + */
> > +#define XTTCPSS_CLOCKSOURCE	0	/* Timer 1 as a generic
timekeeping */
> > +#define XTTCPSS_CLOCKEVENT	1	/* Timer 2 as a clock event */
> > +
> > +#define XTTCPSS_TIMER_BASE		TTC0_BASE
> > +#define XTTCPCC_EVENT_TIMER_IRQ		(IRQ_TIMERCOUNTER0 + 1)
> > +/*
> > + * Timer Register Offset Definitions of Timer 1, Increment base
address by 4
> > + * and use same offsets for Timer 2
> > + */
> > +#define XTTCPSS_CLK_CNTRL_OFFSET	0x00 /* Clock Control Reg, RW */
> > +#define XTTCPSS_CNT_CNTRL_OFFSET	0x0C /* Counter Control Reg, RW
*/
> > +#define XTTCPSS_COUNT_VAL_OFFSET	0x18 /* Counter Value Reg, RO */
> > +#define XTTCPSS_INTR_VAL_OFFSET		0x24 /* Interval Count
Reg, RW */
> > +#define XTTCPSS_MATCH_1_OFFSET		0x30 /* Match 1 Value
Reg, RW */
> > +#define XTTCPSS_MATCH_2_OFFSET		0x3C /* Match 2 Value
Reg, RW */
> > +#define XTTCPSS_MATCH_3_OFFSET		0x48 /* Match 3 Value
Reg, RW */
> > +#define XTTCPSS_ISR_OFFSET		0x54 /* Interrupt Status Reg, RO
*/
> > +#define XTTCPSS_IER_OFFSET		0x60 /* Interrupt Enable Reg, RW
*/
> > +
> > +#define XTTCPSS_CNT_CNTRL_DISABLE_MASK	0x1
> > +
> > +/**
> > + * struct xttcpss_timer - This definition defines local timer
structure
> > + *
> > + * @base_addr:	Base address of timer
> > + * @timer_irq:	irqaction structure for the timer device
> > + * @mode:       only valid for an clock event, periodic or one-shot
> > + **/
> > +struct xttcpss_timer {
> > +	void __iomem *base_addr;
> > +	enum clock_event_mode mode;
> 
> I can't see .mode being used anywhere in this file so this could
> probably be simplified a bit to just two base address pointers.

Yep, got removed in the cleanup.  Obviously the cleanup didn't get quite
everything.

Will do.

> 
> > +};
> > +
> > +static struct xttcpss_timer timers[2];
> > +static struct clock_event_device xttcpss_clockevent;
> > +
> > +/**
> > + * xttcpss_set_interval - Set the timer interval value
> > + *
> > + * @timer:	Pointer to the timer instance
> > + * @cycles:	Timer interval ticks
> > + **/
> > +static void xttcpss_set_interval(struct xttcpss_timer *timer,
> > +					unsigned long cycles)
> > +{
> > +	u32 ctrl_reg;
> > +
> > +	/* Disable the counter, set the counter value  and re-enable
counter */
> > +	ctrl_reg = __raw_readl(timer->base_addr +
XTTCPSS_CNT_CNTRL_OFFSET);
> > +	ctrl_reg |= XTTCPSS_CNT_CNTRL_DISABLE_MASK;
> > +	__raw_writel(ctrl_reg, timer->base_addr +
XTTCPSS_CNT_CNTRL_OFFSET);
> > +
> > +	__raw_writel(cycles, timer->base_addr +
XTTCPSS_INTR_VAL_OFFSET);
> > +
> > +	/* Reset the counter (0x10) so that it starts from 0, one-shot
> > +	   mode makes this needed for timing to be right. */
> > +	ctrl_reg |= 0x10;
> > +	ctrl_reg &= ~XTTCPSS_CNT_CNTRL_DISABLE_MASK;
> > +	__raw_writel(ctrl_reg, timer->base_addr +
XTTCPSS_CNT_CNTRL_OFFSET);
> > +}
> > +
> > +/**
> > + * xttcpss_clock_event_interrupt - Clock event timer interrupt
handler
> > + *
> > + * @irq:	IRQ number of the Timer
> > + * @dev_id:	void pointer to the xttcpss_timer instance
> > + *
> > + * returns: Always IRQ_HANDLED - success
> > + **/
> > +static irqreturn_t xttcpss_clock_event_interrupt(int irq, void
*dev_id)
> > +{
> > +	struct clock_event_device *evt = &xttcpss_clockevent;
> > +	struct xttcpss_timer *timer = dev_id;
> > +
> > +	/* Acknowledge the interrupt and call event handler */
> > +	__raw_writel(__raw_readl(timer->base_addr + XTTCPSS_ISR_OFFSET),
> > +			timer->base_addr + XTTCPSS_ISR_OFFSET);
> > +
> > +	evt->event_handler(evt);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static struct irqaction event_timer_irq = {
> > +	.name	= "xttcpss clockevent",
> > +	.flags	= IRQF_DISABLED | IRQF_TIMER,
> > +	.handler = xttcpss_clock_event_interrupt,
> > +};
> > +
> > +/**
> > + * xttcpss_timer_hardware_init - Initialize the timer hardware
> > + *
> > + * Initialize the hardware to start the clock source, get the clock
> > + * event timer ready to use, and hook up the interrupt.
> > + **/
> > +static void __init xttcpss_timer_hardware_init(void)
> > +{
> > +	/* Setup the clock source counter to be an incrementing counter
> > +	 * with no interrupt and it rolls over at 0xFFFF. Pre-scale
> > +	   it by 32 also. Let it start running now.
> > +	 */
> > +	timers[XTTCPSS_CLOCKSOURCE].base_addr = XTTCPSS_TIMER_BASE;
> > +
> > +	__raw_writel(0x0, timers[XTTCPSS_CLOCKSOURCE].base_addr +
> > +				XTTCPSS_IER_OFFSET);
> > +	__raw_writel(0x9, timers[XTTCPSS_CLOCKSOURCE].base_addr +
> > +				XTTCPSS_CLK_CNTRL_OFFSET);
> > +	__raw_writel(0x10, timers[XTTCPSS_CLOCKSOURCE].base_addr +
> > +				XTTCPSS_CNT_CNTRL_OFFSET);
> > +
> > +	/* Setup the clock event timer to be an interval timer which
> > +	 * is prescaled by 32 using the interval interrupt. Leave it
> > +	 * disabled for now.
> > +	 */
> > +
> > +	timers[XTTCPSS_CLOCKEVENT].base_addr = XTTCPSS_TIMER_BASE + 4;
> > +
> > +	__raw_writel(0x23, timers[XTTCPSS_CLOCKEVENT].base_addr +
> > +			XTTCPSS_CNT_CNTRL_OFFSET);
> > +	__raw_writel(0x9, timers[XTTCPSS_CLOCKEVENT].base_addr +
> > +			XTTCPSS_CLK_CNTRL_OFFSET);
> > +	__raw_writel(0x1, timers[XTTCPSS_CLOCKEVENT].base_addr +
> > +			XTTCPSS_IER_OFFSET);
> > +
> > +	/* Setup IRQ the clock event timer */
> > +	event_timer_irq.dev_id = &timers[XTTCPSS_CLOCKEVENT];
> > +
> > +	if (event_timer_irq.handler != NULL)
> > +		setup_irq(XTTCPCC_EVENT_TIMER_IRQ, &event_timer_irq);
> 
> You've explicitly initialized event_timer_irq.handler above so I don't
> think you need to check against NULL, and just always call
setup_irq().

Makes sense.

> 
> > +}
> > +
> > +/**
> > + * __raw_readl_cycles - Reads the timer counter register
> > + *
> > + * returns: Current timer counter register value
> > + **/
> > +static cycle_t __raw_readl_cycles(struct clocksource *cs)
> > +{
> > +	struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKSOURCE];
> > +
> > +	return (cycle_t)__raw_readl(timer->base_addr +
> > +				XTTCPSS_COUNT_VAL_OFFSET);
> > +}
> > +
> > +
> > +/*
> > + * Instantiate and initialize the clock source structure
> > + */
> > +static struct clocksource clocksource_xttcpss = {
> > +	.name		= "xttcpss_timer1",
> > +	.rating		= 200,			/* Reasonable clock
source */
> > +	.read		= __raw_readl_cycles,
> > +	.mask		= CLOCKSOURCE_MASK(16),
> > +	.shift		= 0,			/* Initialized to zero
*/
> 
> This is static data so you don't need to explicitly initialize shift
to
> 0.  It doesn't hurt anything though.
> 

Yes, agreed.

> > +	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
> > +};
> > +
> > +
> > +/**
> > + * xttcpss_set_next_event - Sets the time interval for next event
> > + *
> > + * @cycles:	Timer interval ticks
> > + * @evt:	Address of clock event instance
> > + *
> > + * returns: Always 0 - success
> > + **/
> > +static int xttcpss_set_next_event(unsigned long cycles,
> > +					struct clock_event_device *evt)
> > +{
> > +	struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKEVENT];
> > +
> > +	xttcpss_set_interval(timer, cycles);
> > +	return 0;
> > +}
> > +
> > +/**
> > + * xttcpss_set_mode - Sets the mode of timer
> > + *
> > + * @mode:	Mode to be set
> > + * @evt:	Address of clock event instance
> > + **/
> > +static void xttcpss_set_mode(enum clock_event_mode mode,
> > +					struct clock_event_device *evt)
> > +{
> > +	struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKEVENT];
> > +	u32 ctrl_reg;
> > +
> > +	timer->mode = mode;
> > +
> > +	switch (mode) {
> > +	case CLOCK_EVT_MODE_PERIODIC:
> > +		xttcpss_set_interval(timer, CLOCK_TICK_RATE / HZ);
> > +		break;
> > +	case CLOCK_EVT_MODE_ONESHOT:
> > +	case CLOCK_EVT_MODE_UNUSED:
> > +	case CLOCK_EVT_MODE_SHUTDOWN:
> > +		ctrl_reg = __raw_readl(timer->base_addr +
> > +					XTTCPSS_CNT_CNTRL_OFFSET);
> > +		ctrl_reg |= XTTCPSS_CNT_CNTRL_DISABLE_MASK;
> > +		__raw_writel(ctrl_reg,
> > +				timer->base_addr +
XTTCPSS_CNT_CNTRL_OFFSET);
> > +		break;
> > +	case CLOCK_EVT_MODE_RESUME:
> > +		ctrl_reg = __raw_readl(timer->base_addr +
> > +					XTTCPSS_CNT_CNTRL_OFFSET);
> > +		ctrl_reg &= ~XTTCPSS_CNT_CNTRL_DISABLE_MASK;
> > +		__raw_writel(ctrl_reg,
> > +				timer->base_addr +
XTTCPSS_CNT_CNTRL_OFFSET);
> > +		break;
> > +	}
> > +}
> > +
> > +/*
> > + * Instantiate and initialize the clock event structure
> > + */
> > +static struct clock_event_device xttcpss_clockevent = {
> > +	.name		= "xttcpss_timer2",
> > +	.features	= CLOCK_EVT_FEAT_PERIODIC |
CLOCK_EVT_FEAT_ONESHOT,
> > +	.shift		= 0,		/* Initialized to zero */
> 
> Same here, that .shift = 0 isn't really needed (but doesn't hurt).

OK.

Thanks,
John

> 
> > +	.set_next_event	= xttcpss_set_next_event,
> > +	.set_mode	= xttcpss_set_mode,
> > +	.rating		= 200,
> > +};
> > +
> > +/**
> > + * xttcpss_timer_init - Initialize the timer
> > + *
> > + * Initializes the timer hardware and register the clock source and
clock event
> > + * timers with Linux kernal timer framework
> > + **/
> > +static void __init xttcpss_timer_init(void)
> > +{
> > +	xttcpss_timer_hardware_init();
> > +	clocksource_register_hz(&clocksource_xttcpss, CLOCK_TICK_RATE);
> > +
> > +	/* Calculate the parameters to allow the clockevent to operate
using
> > +	   integer math
> > +	*/
> > +	clockevents_calc_mult_shift(&xttcpss_clockevent,
CLOCK_TICK_RATE, 4);
> > +
> > +	xttcpss_clockevent.max_delta_ns =
> > +		clockevent_delta2ns(0xfffe, &xttcpss_clockevent);
> > +	xttcpss_clockevent.min_delta_ns =
> > +		clockevent_delta2ns(1, &xttcpss_clockevent);
> > +
> > +	/* Indicate that clock event can be used on any of the CPUs */
> > +
> > +	xttcpss_clockevent.cpumask = cpu_all_mask;
> > +	clockevents_register_device(&xttcpss_clockevent);
> > +}
> > +
> > +/*
> > + * Instantiate and initialize the system timer structure
> > + */
> > +struct sys_timer xttcpss_sys_timer = {
> > +	.init		= xttcpss_timer_init,
> > +};
> > --
> > 1.6.2.1
> >
> >
> >
> > This email and any attachments are intended for the sole use of the
named recipient(s) and
> contain(s) confidential information that may be proprietary,
privileged or copyrighted under
> applicable law. If you are not the intended recipient, do not read,
copy, or forward this email
> message or any attachments. Delete this email message and any
attachments immediately.
> >
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


