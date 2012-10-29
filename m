Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760539Ab2J2S4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:56:36 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:46087 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759092Ab2J2S4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:56:34 -0400
Date: Mon, 29 Oct 2012 12:56:30 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org
Subject: [PATCH] ARM: zynq: move ttc timer code to drivers/clocksource
Message-ID: <20121029185630.GA26149@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/29/2012 01:56:22 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/29/2012 01:56:22 PM,
	Serialize complete at 10/29/2012 01:56:22 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-29_02:2012-10-29,2012-10-29,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested cleanup by Arnd Bergmann.  Move the ttc timer.c code to
drivers/clocksource, and out of the mach-zynq directory.

The common.h (which only held the timer declaration) was renamed to
xilinx_ttc.h and moved into include/linux.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-zynq/Makefile      |   2 +-
 arch/arm/mach-zynq/common.c      |   2 +-
 arch/arm/mach-zynq/common.h      |  24 ----
 arch/arm/mach-zynq/timer.c       | 298 ---------------------------------------
 drivers/clocksource/Makefile     |   1 +
 drivers/clocksource/xilinx_ttc.c | 297 ++++++++++++++++++++++++++++++++++++++
 include/linux/xilinx_ttc.h       |  24 ++++
 7 files changed, 324 insertions(+), 324 deletions(-)
 delete mode 100644 arch/arm/mach-zynq/common.h
 delete mode 100644 arch/arm/mach-zynq/timer.c
 create mode 100644 drivers/clocksource/xilinx_ttc.c
 create mode 100644 include/linux/xilinx_ttc.h

diff --git a/arch/arm/mach-zynq/Makefile b/arch/arm/mach-zynq/Makefile
index 397268c..320faed 100644
--- a/arch/arm/mach-zynq/Makefile
+++ b/arch/arm/mach-zynq/Makefile
@@ -3,4 +3,4 @@
 #
 
 # Common support
-obj-y				:= common.o timer.o
+obj-y				:= common.o
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 93b9105..eecc898 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -22,6 +22,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/of.h>
+#include <linux/xilinx_ttc.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -31,7 +32,6 @@
 #include <asm/hardware/cache-l2x0.h>
 
 #include <mach/zynq_soc.h>
-#include "common.h"
 
 static struct of_device_id zynq_of_bus_ids[] __initdata = {
 	{ .compatible = "simple-bus", },
diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
deleted file mode 100644
index a009644..0000000
--- a/arch/arm/mach-zynq/common.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * This file contains common function prototypes to avoid externs
- * in the c files.
- *
- *  Copyright (C) 2011 Xilinx
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __MACH_ZYNQ_COMMON_H__
-#define __MACH_ZYNQ_COMMON_H__
-
-#include <asm/mach/time.h>
-
-extern struct sys_timer xttcpss_sys_timer;
-
-#endif
diff --git a/arch/arm/mach-zynq/timer.c b/arch/arm/mach-zynq/timer.c
deleted file mode 100644
index c2c96cc..0000000
--- a/arch/arm/mach-zynq/timer.c
+++ /dev/null
@@ -1,298 +0,0 @@
-/*
- * This file contains driver for the Xilinx PS Timer Counter IP.
- *
- *  Copyright (C) 2011 Xilinx
- *
- * based on arch/mips/kernel/time.c timer driver
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/types.h>
-#include <linux/clocksource.h>
-#include <linux/clockchips.h>
-#include <linux/io.h>
-
-#include <asm/mach/time.h>
-#include <mach/zynq_soc.h>
-#include "common.h"
-
-#define IRQ_TIMERCOUNTER0	42
-
-/*
- * This driver configures the 2 16-bit count-up timers as follows:
- *
- * T1: Timer 1, clocksource for generic timekeeping
- * T2: Timer 2, clockevent source for hrtimers
- * T3: Timer 3, <unused>
- *
- * The input frequency to the timer module for emulation is 2.5MHz which is
- * common to all the timer channels (T1, T2, and T3). With a pre-scaler of 32,
- * the timers are clocked at 78.125KHz (12.8 us resolution).
- *
- * The input frequency to the timer module in silicon will be 200MHz. With the
- * pre-scaler of 32, the timers are clocked at 6.25MHz (160ns resolution).
- */
-#define XTTCPSS_CLOCKSOURCE	0	/* Timer 1 as a generic timekeeping */
-#define XTTCPSS_CLOCKEVENT	1	/* Timer 2 as a clock event */
-
-#define XTTCPSS_TIMER_BASE		TTC0_BASE
-#define XTTCPCC_EVENT_TIMER_IRQ		(IRQ_TIMERCOUNTER0 + 1)
-/*
- * Timer Register Offset Definitions of Timer 1, Increment base address by 4
- * and use same offsets for Timer 2
- */
-#define XTTCPSS_CLK_CNTRL_OFFSET	0x00 /* Clock Control Reg, RW */
-#define XTTCPSS_CNT_CNTRL_OFFSET	0x0C /* Counter Control Reg, RW */
-#define XTTCPSS_COUNT_VAL_OFFSET	0x18 /* Counter Value Reg, RO */
-#define XTTCPSS_INTR_VAL_OFFSET		0x24 /* Interval Count Reg, RW */
-#define XTTCPSS_MATCH_1_OFFSET		0x30 /* Match 1 Value Reg, RW */
-#define XTTCPSS_MATCH_2_OFFSET		0x3C /* Match 2 Value Reg, RW */
-#define XTTCPSS_MATCH_3_OFFSET		0x48 /* Match 3 Value Reg, RW */
-#define XTTCPSS_ISR_OFFSET		0x54 /* Interrupt Status Reg, RO */
-#define XTTCPSS_IER_OFFSET		0x60 /* Interrupt Enable Reg, RW */
-
-#define XTTCPSS_CNT_CNTRL_DISABLE_MASK	0x1
-
-/* Setup the timers to use pre-scaling */
-
-#define TIMER_RATE (PERIPHERAL_CLOCK_RATE / 32)
-
-/**
- * struct xttcpss_timer - This definition defines local timer structure
- *
- * @base_addr:	Base address of timer
- **/
-struct xttcpss_timer {
-	void __iomem *base_addr;
-};
-
-static struct xttcpss_timer timers[2];
-static struct clock_event_device xttcpss_clockevent;
-
-/**
- * xttcpss_set_interval - Set the timer interval value
- *
- * @timer:	Pointer to the timer instance
- * @cycles:	Timer interval ticks
- **/
-static void xttcpss_set_interval(struct xttcpss_timer *timer,
-					unsigned long cycles)
-{
-	u32 ctrl_reg;
-
-	/* Disable the counter, set the counter value  and re-enable counter */
-	ctrl_reg = __raw_readl(timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
-	ctrl_reg |= XTTCPSS_CNT_CNTRL_DISABLE_MASK;
-	__raw_writel(ctrl_reg, timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
-
-	__raw_writel(cycles, timer->base_addr + XTTCPSS_INTR_VAL_OFFSET);
-
-	/* Reset the counter (0x10) so that it starts from 0, one-shot
-	   mode makes this needed for timing to be right. */
-	ctrl_reg |= 0x10;
-	ctrl_reg &= ~XTTCPSS_CNT_CNTRL_DISABLE_MASK;
-	__raw_writel(ctrl_reg, timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
-}
-
-/**
- * xttcpss_clock_event_interrupt - Clock event timer interrupt handler
- *
- * @irq:	IRQ number of the Timer
- * @dev_id:	void pointer to the xttcpss_timer instance
- *
- * returns: Always IRQ_HANDLED - success
- **/
-static irqreturn_t xttcpss_clock_event_interrupt(int irq, void *dev_id)
-{
-	struct clock_event_device *evt = &xttcpss_clockevent;
-	struct xttcpss_timer *timer = dev_id;
-
-	/* Acknowledge the interrupt and call event handler */
-	__raw_writel(__raw_readl(timer->base_addr + XTTCPSS_ISR_OFFSET),
-			timer->base_addr + XTTCPSS_ISR_OFFSET);
-
-	evt->event_handler(evt);
-
-	return IRQ_HANDLED;
-}
-
-static struct irqaction event_timer_irq = {
-	.name	= "xttcpss clockevent",
-	.flags	= IRQF_DISABLED | IRQF_TIMER,
-	.handler = xttcpss_clock_event_interrupt,
-};
-
-/**
- * xttcpss_timer_hardware_init - Initialize the timer hardware
- *
- * Initialize the hardware to start the clock source, get the clock
- * event timer ready to use, and hook up the interrupt.
- **/
-static void __init xttcpss_timer_hardware_init(void)
-{
-	/* Setup the clock source counter to be an incrementing counter
-	 * with no interrupt and it rolls over at 0xFFFF. Pre-scale
-	   it by 32 also. Let it start running now.
-	 */
-	timers[XTTCPSS_CLOCKSOURCE].base_addr = XTTCPSS_TIMER_BASE;
-
-	__raw_writel(0x0, timers[XTTCPSS_CLOCKSOURCE].base_addr +
-				XTTCPSS_IER_OFFSET);
-	__raw_writel(0x9, timers[XTTCPSS_CLOCKSOURCE].base_addr +
-				XTTCPSS_CLK_CNTRL_OFFSET);
-	__raw_writel(0x10, timers[XTTCPSS_CLOCKSOURCE].base_addr +
-				XTTCPSS_CNT_CNTRL_OFFSET);
-
-	/* Setup the clock event timer to be an interval timer which
-	 * is prescaled by 32 using the interval interrupt. Leave it
-	 * disabled for now.
-	 */
-
-	timers[XTTCPSS_CLOCKEVENT].base_addr = XTTCPSS_TIMER_BASE + 4;
-
-	__raw_writel(0x23, timers[XTTCPSS_CLOCKEVENT].base_addr +
-			XTTCPSS_CNT_CNTRL_OFFSET);
-	__raw_writel(0x9, timers[XTTCPSS_CLOCKEVENT].base_addr +
-			XTTCPSS_CLK_CNTRL_OFFSET);
-	__raw_writel(0x1, timers[XTTCPSS_CLOCKEVENT].base_addr +
-			XTTCPSS_IER_OFFSET);
-
-	/* Setup IRQ the clock event timer */
-	event_timer_irq.dev_id = &timers[XTTCPSS_CLOCKEVENT];
-	setup_irq(XTTCPCC_EVENT_TIMER_IRQ, &event_timer_irq);
-}
-
-/**
- * __raw_readl_cycles - Reads the timer counter register
- *
- * returns: Current timer counter register value
- **/
-static cycle_t __raw_readl_cycles(struct clocksource *cs)
-{
-	struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKSOURCE];
-
-	return (cycle_t)__raw_readl(timer->base_addr +
-				XTTCPSS_COUNT_VAL_OFFSET);
-}
-
-
-/*
- * Instantiate and initialize the clock source structure
- */
-static struct clocksource clocksource_xttcpss = {
-	.name		= "xttcpss_timer1",
-	.rating		= 200,			/* Reasonable clock source */
-	.read		= __raw_readl_cycles,
-	.mask		= CLOCKSOURCE_MASK(16),
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-};
-
-
-/**
- * xttcpss_set_next_event - Sets the time interval for next event
- *
- * @cycles:	Timer interval ticks
- * @evt:	Address of clock event instance
- *
- * returns: Always 0 - success
- **/
-static int xttcpss_set_next_event(unsigned long cycles,
-					struct clock_event_device *evt)
-{
-	struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKEVENT];
-
-	xttcpss_set_interval(timer, cycles);
-	return 0;
-}
-
-/**
- * xttcpss_set_mode - Sets the mode of timer
- *
- * @mode:	Mode to be set
- * @evt:	Address of clock event instance
- **/
-static void xttcpss_set_mode(enum clock_event_mode mode,
-					struct clock_event_device *evt)
-{
-	struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKEVENT];
-	u32 ctrl_reg;
-
-	switch (mode) {
-	case CLOCK_EVT_MODE_PERIODIC:
-		xttcpss_set_interval(timer, TIMER_RATE / HZ);
-		break;
-	case CLOCK_EVT_MODE_ONESHOT:
-	case CLOCK_EVT_MODE_UNUSED:
-	case CLOCK_EVT_MODE_SHUTDOWN:
-		ctrl_reg = __raw_readl(timer->base_addr +
-					XTTCPSS_CNT_CNTRL_OFFSET);
-		ctrl_reg |= XTTCPSS_CNT_CNTRL_DISABLE_MASK;
-		__raw_writel(ctrl_reg,
-				timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
-		break;
-	case CLOCK_EVT_MODE_RESUME:
-		ctrl_reg = __raw_readl(timer->base_addr +
-					XTTCPSS_CNT_CNTRL_OFFSET);
-		ctrl_reg &= ~XTTCPSS_CNT_CNTRL_DISABLE_MASK;
-		__raw_writel(ctrl_reg,
-				timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
-		break;
-	}
-}
-
-/*
- * Instantiate and initialize the clock event structure
- */
-static struct clock_event_device xttcpss_clockevent = {
-	.name		= "xttcpss_timer2",
-	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.set_next_event	= xttcpss_set_next_event,
-	.set_mode	= xttcpss_set_mode,
-	.rating		= 200,
-};
-
-/**
- * xttcpss_timer_init - Initialize the timer
- *
- * Initializes the timer hardware and register the clock source and clock event
- * timers with Linux kernal timer framework
- **/
-static void __init xttcpss_timer_init(void)
-{
-	xttcpss_timer_hardware_init();
-	clocksource_register_hz(&clocksource_xttcpss, TIMER_RATE);
-
-	/* Calculate the parameters to allow the clockevent to operate using
-	   integer math
-	*/
-	clockevents_calc_mult_shift(&xttcpss_clockevent, TIMER_RATE, 4);
-
-	xttcpss_clockevent.max_delta_ns =
-		clockevent_delta2ns(0xfffe, &xttcpss_clockevent);
-	xttcpss_clockevent.min_delta_ns =
-		clockevent_delta2ns(1, &xttcpss_clockevent);
-
-	/* Indicate that clock event is on 1st CPU as SMP boot needs it */
-
-	xttcpss_clockevent.cpumask = cpumask_of(0);
-	clockevents_register_device(&xttcpss_clockevent);
-}
-
-/*
- * Instantiate and initialize the system timer structure
- */
-struct sys_timer xttcpss_sys_timer = {
-	.init		= xttcpss_timer_init,
-};
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 603be36..f27c7b1 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -14,5 +14,6 @@ obj-$(CONFIG_DW_APB_TIMER_OF)	+= dw_apb_timer_of.o
 obj-$(CONFIG_CLKSRC_DBX500_PRCMU)	+= clksrc-dbx500-prcmu.o
 obj-$(CONFIG_ARMADA_370_XP_TIMER)	+= time-armada-370-xp.o
 obj-$(CONFIG_ARCH_BCM2835)	+= bcm2835_timer.o
+obj-$(CONFIG_ARCH_ZYNQ)		+= xilinx_ttc.o
 
 obj-$(CONFIG_CLKSRC_ARM_GENERIC)	+= arm_generic.o
diff --git a/drivers/clocksource/xilinx_ttc.c b/drivers/clocksource/xilinx_ttc.c
new file mode 100644
index 0000000..3296556
--- /dev/null
+++ b/drivers/clocksource/xilinx_ttc.c
@@ -0,0 +1,297 @@
+/*
+ * This file contains driver for the Xilinx PS Timer Counter IP.
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * based on arch/mips/kernel/time.c timer driver
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/types.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/io.h>
+
+#include <asm/mach/time.h>
+#include <mach/zynq_soc.h>
+
+#define IRQ_TIMERCOUNTER0	42
+
+/*
+ * This driver configures the 2 16-bit count-up timers as follows:
+ *
+ * T1: Timer 1, clocksource for generic timekeeping
+ * T2: Timer 2, clockevent source for hrtimers
+ * T3: Timer 3, <unused>
+ *
+ * The input frequency to the timer module for emulation is 2.5MHz which is
+ * common to all the timer channels (T1, T2, and T3). With a pre-scaler of 32,
+ * the timers are clocked at 78.125KHz (12.8 us resolution).
+ *
+ * The input frequency to the timer module in silicon will be 200MHz. With the
+ * pre-scaler of 32, the timers are clocked at 6.25MHz (160ns resolution).
+ */
+#define XTTCPSS_CLOCKSOURCE	0	/* Timer 1 as a generic timekeeping */
+#define XTTCPSS_CLOCKEVENT	1	/* Timer 2 as a clock event */
+
+#define XTTCPSS_TIMER_BASE		TTC0_BASE
+#define XTTCPCC_EVENT_TIMER_IRQ		(IRQ_TIMERCOUNTER0 + 1)
+/*
+ * Timer Register Offset Definitions of Timer 1, Increment base address by 4
+ * and use same offsets for Timer 2
+ */
+#define XTTCPSS_CLK_CNTRL_OFFSET	0x00 /* Clock Control Reg, RW */
+#define XTTCPSS_CNT_CNTRL_OFFSET	0x0C /* Counter Control Reg, RW */
+#define XTTCPSS_COUNT_VAL_OFFSET	0x18 /* Counter Value Reg, RO */
+#define XTTCPSS_INTR_VAL_OFFSET		0x24 /* Interval Count Reg, RW */
+#define XTTCPSS_MATCH_1_OFFSET		0x30 /* Match 1 Value Reg, RW */
+#define XTTCPSS_MATCH_2_OFFSET		0x3C /* Match 2 Value Reg, RW */
+#define XTTCPSS_MATCH_3_OFFSET		0x48 /* Match 3 Value Reg, RW */
+#define XTTCPSS_ISR_OFFSET		0x54 /* Interrupt Status Reg, RO */
+#define XTTCPSS_IER_OFFSET		0x60 /* Interrupt Enable Reg, RW */
+
+#define XTTCPSS_CNT_CNTRL_DISABLE_MASK	0x1
+
+/* Setup the timers to use pre-scaling */
+
+#define TIMER_RATE (PERIPHERAL_CLOCK_RATE / 32)
+
+/**
+ * struct xttcpss_timer - This definition defines local timer structure
+ *
+ * @base_addr:	Base address of timer
+ **/
+struct xttcpss_timer {
+	void __iomem *base_addr;
+};
+
+static struct xttcpss_timer timers[2];
+static struct clock_event_device xttcpss_clockevent;
+
+/**
+ * xttcpss_set_interval - Set the timer interval value
+ *
+ * @timer:	Pointer to the timer instance
+ * @cycles:	Timer interval ticks
+ **/
+static void xttcpss_set_interval(struct xttcpss_timer *timer,
+					unsigned long cycles)
+{
+	u32 ctrl_reg;
+
+	/* Disable the counter, set the counter value  and re-enable counter */
+	ctrl_reg = __raw_readl(timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
+	ctrl_reg |= XTTCPSS_CNT_CNTRL_DISABLE_MASK;
+	__raw_writel(ctrl_reg, timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
+
+	__raw_writel(cycles, timer->base_addr + XTTCPSS_INTR_VAL_OFFSET);
+
+	/* Reset the counter (0x10) so that it starts from 0, one-shot
+	   mode makes this needed for timing to be right. */
+	ctrl_reg |= 0x10;
+	ctrl_reg &= ~XTTCPSS_CNT_CNTRL_DISABLE_MASK;
+	__raw_writel(ctrl_reg, timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
+}
+
+/**
+ * xttcpss_clock_event_interrupt - Clock event timer interrupt handler
+ *
+ * @irq:	IRQ number of the Timer
+ * @dev_id:	void pointer to the xttcpss_timer instance
+ *
+ * returns: Always IRQ_HANDLED - success
+ **/
+static irqreturn_t xttcpss_clock_event_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = &xttcpss_clockevent;
+	struct xttcpss_timer *timer = dev_id;
+
+	/* Acknowledge the interrupt and call event handler */
+	__raw_writel(__raw_readl(timer->base_addr + XTTCPSS_ISR_OFFSET),
+			timer->base_addr + XTTCPSS_ISR_OFFSET);
+
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction event_timer_irq = {
+	.name	= "xttcpss clockevent",
+	.flags	= IRQF_DISABLED | IRQF_TIMER,
+	.handler = xttcpss_clock_event_interrupt,
+};
+
+/**
+ * xttcpss_timer_hardware_init - Initialize the timer hardware
+ *
+ * Initialize the hardware to start the clock source, get the clock
+ * event timer ready to use, and hook up the interrupt.
+ **/
+static void __init xttcpss_timer_hardware_init(void)
+{
+	/* Setup the clock source counter to be an incrementing counter
+	 * with no interrupt and it rolls over at 0xFFFF. Pre-scale
+	   it by 32 also. Let it start running now.
+	 */
+	timers[XTTCPSS_CLOCKSOURCE].base_addr = XTTCPSS_TIMER_BASE;
+
+	__raw_writel(0x0, timers[XTTCPSS_CLOCKSOURCE].base_addr +
+				XTTCPSS_IER_OFFSET);
+	__raw_writel(0x9, timers[XTTCPSS_CLOCKSOURCE].base_addr +
+				XTTCPSS_CLK_CNTRL_OFFSET);
+	__raw_writel(0x10, timers[XTTCPSS_CLOCKSOURCE].base_addr +
+				XTTCPSS_CNT_CNTRL_OFFSET);
+
+	/* Setup the clock event timer to be an interval timer which
+	 * is prescaled by 32 using the interval interrupt. Leave it
+	 * disabled for now.
+	 */
+
+	timers[XTTCPSS_CLOCKEVENT].base_addr = XTTCPSS_TIMER_BASE + 4;
+
+	__raw_writel(0x23, timers[XTTCPSS_CLOCKEVENT].base_addr +
+			XTTCPSS_CNT_CNTRL_OFFSET);
+	__raw_writel(0x9, timers[XTTCPSS_CLOCKEVENT].base_addr +
+			XTTCPSS_CLK_CNTRL_OFFSET);
+	__raw_writel(0x1, timers[XTTCPSS_CLOCKEVENT].base_addr +
+			XTTCPSS_IER_OFFSET);
+
+	/* Setup IRQ the clock event timer */
+	event_timer_irq.dev_id = &timers[XTTCPSS_CLOCKEVENT];
+	setup_irq(XTTCPCC_EVENT_TIMER_IRQ, &event_timer_irq);
+}
+
+/**
+ * __raw_readl_cycles - Reads the timer counter register
+ *
+ * returns: Current timer counter register value
+ **/
+static cycle_t __raw_readl_cycles(struct clocksource *cs)
+{
+	struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKSOURCE];
+
+	return (cycle_t)__raw_readl(timer->base_addr +
+				XTTCPSS_COUNT_VAL_OFFSET);
+}
+
+
+/*
+ * Instantiate and initialize the clock source structure
+ */
+static struct clocksource clocksource_xttcpss = {
+	.name		= "xttcpss_timer1",
+	.rating		= 200,			/* Reasonable clock source */
+	.read		= __raw_readl_cycles,
+	.mask		= CLOCKSOURCE_MASK(16),
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+
+/**
+ * xttcpss_set_next_event - Sets the time interval for next event
+ *
+ * @cycles:	Timer interval ticks
+ * @evt:	Address of clock event instance
+ *
+ * returns: Always 0 - success
+ **/
+static int xttcpss_set_next_event(unsigned long cycles,
+					struct clock_event_device *evt)
+{
+	struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKEVENT];
+
+	xttcpss_set_interval(timer, cycles);
+	return 0;
+}
+
+/**
+ * xttcpss_set_mode - Sets the mode of timer
+ *
+ * @mode:	Mode to be set
+ * @evt:	Address of clock event instance
+ **/
+static void xttcpss_set_mode(enum clock_event_mode mode,
+					struct clock_event_device *evt)
+{
+	struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKEVENT];
+	u32 ctrl_reg;
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		xttcpss_set_interval(timer, TIMER_RATE / HZ);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		ctrl_reg = __raw_readl(timer->base_addr +
+					XTTCPSS_CNT_CNTRL_OFFSET);
+		ctrl_reg |= XTTCPSS_CNT_CNTRL_DISABLE_MASK;
+		__raw_writel(ctrl_reg,
+				timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
+		break;
+	case CLOCK_EVT_MODE_RESUME:
+		ctrl_reg = __raw_readl(timer->base_addr +
+					XTTCPSS_CNT_CNTRL_OFFSET);
+		ctrl_reg &= ~XTTCPSS_CNT_CNTRL_DISABLE_MASK;
+		__raw_writel(ctrl_reg,
+				timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
+		break;
+	}
+}
+
+/*
+ * Instantiate and initialize the clock event structure
+ */
+static struct clock_event_device xttcpss_clockevent = {
+	.name		= "xttcpss_timer2",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_next_event	= xttcpss_set_next_event,
+	.set_mode	= xttcpss_set_mode,
+	.rating		= 200,
+};
+
+/**
+ * xttcpss_timer_init - Initialize the timer
+ *
+ * Initializes the timer hardware and register the clock source and clock event
+ * timers with Linux kernal timer framework
+ **/
+static void __init xttcpss_timer_init(void)
+{
+	xttcpss_timer_hardware_init();
+	clocksource_register_hz(&clocksource_xttcpss, TIMER_RATE);
+
+	/* Calculate the parameters to allow the clockevent to operate using
+	   integer math
+	*/
+	clockevents_calc_mult_shift(&xttcpss_clockevent, TIMER_RATE, 4);
+
+	xttcpss_clockevent.max_delta_ns =
+		clockevent_delta2ns(0xfffe, &xttcpss_clockevent);
+	xttcpss_clockevent.min_delta_ns =
+		clockevent_delta2ns(1, &xttcpss_clockevent);
+
+	/* Indicate that clock event is on 1st CPU as SMP boot needs it */
+
+	xttcpss_clockevent.cpumask = cpumask_of(0);
+	clockevents_register_device(&xttcpss_clockevent);
+}
+
+/*
+ * Instantiate and initialize the system timer structure
+ */
+struct sys_timer xttcpss_sys_timer = {
+	.init		= xttcpss_timer_init,
+};
diff --git a/include/linux/xilinx_ttc.h b/include/linux/xilinx_ttc.h
new file mode 100644
index 0000000..3606beb
--- /dev/null
+++ b/include/linux/xilinx_ttc.h
@@ -0,0 +1,24 @@
+/*
+ * This file contains common function prototypes to avoid externs
+ * in the c files.
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __XILINX_TTC_H__
+#define __XILINX_TTC_H__
+
+#include <asm/mach/time.h>
+
+extern struct sys_timer xttcpss_sys_timer;
+
+#endif
-- 
1.8.0
