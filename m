Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab2JaXNC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 19:13:02 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:57361 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760828Ab2JaXM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 19:12:56 -0400
Message-Id: <0ea1ba71afb3f4551ac27a6dfa41bd97b63cef48.1351721190.git.josh.cartwright@ni.com>
In-Reply-To: <cover.1351721190.git.josh.cartwright@ni.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
From: Josh Cartwright <josh.cartwright@ni.com>
Date: Wed, 31 Oct 2012 13:56:14 -0600
Subject: [PATCH 8/8] clocksource: xilinx_ttc: add OF_CLK support
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Linn <John.Linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 06:12:27 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 06:12:27 PM,
	Serialize complete at 10/31/2012 06:12:27 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-31_03:2012-10-31,2012-10-31,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for retrieving TTC configuration from device tree.  This
includes the ability to pull information about the driving clocks from
the of_clk bindings.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
---
 arch/arm/boot/dts/zynq-7000.dtsi |  53 ++++++++
 arch/arm/boot/dts/zynq-zc702.dts |  10 ++
 drivers/clocksource/xilinx_ttc.c | 273 ++++++++++++++++++++++-----------------
 3 files changed, 218 insertions(+), 118 deletions(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 5fb763f..9a2442c 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -109,5 +109,58 @@
 				};
 			};
 		};
+
+		ttc0: ttc0@f8001000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "xlnx,ttc";
+			reg = <0xF8001000 0x1000>;
+			clocks = <&cpu_clk 3>;
+			clock-names = "cpu_1x";
+			clock-ranges;
+
+			ttc0_0: ttc0.0 {
+				status = "disabled";
+				reg = <0>;
+				interrupts = <0 10 4>;
+			};
+			ttc0_1: ttc0.1 {
+				status = "disabled";
+				reg = <1>;
+				interrupts = <0 11 4>;
+			};
+			ttc0_2: ttc0.2 {
+				status = "disabled";
+				reg = <2>;
+				interrupts = <0 12 4>;
+			};
+		};
+
+		ttc1: ttc0@f8002000 {
+			#interrupt-parent = <&intc>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "xlnx,ttc";
+			reg = <0xF8002000 0x1000>;
+			clocks = <&cpu_clk 3>;
+			clock-names = "cpu_1x";
+			clock-ranges;
+
+			ttc1_0: ttc1.0 {
+				status = "disabled";
+				reg = <0>;
+				interrupts = <0 37 4>;
+			};
+			ttc1_1: ttc1.1 {
+				status = "disabled";
+				reg = <1>;
+				interrupts = <0 38 4>;
+			};
+			ttc1_2: ttc1.2 {
+				status = "disabled";
+				reg = <2>;
+				interrupts = <0 39 4>;
+			};
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index 86f44d5..c772942 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -32,3 +32,13 @@
 &ps_clk {
 	clock-frequency = <33333330>;
 };
+
+&ttc0_0 {
+	status = "ok";
+	compatible = "xlnx,ttc-counter-clocksource";
+};
+
+&ttc0_1 {
+	status = "ok";
+	compatible = "xlnx,ttc-counter-clockevent";
+};
diff --git a/drivers/clocksource/xilinx_ttc.c b/drivers/clocksource/xilinx_ttc.c
index ff38b3e..a4718f7 100644
--- a/drivers/clocksource/xilinx_ttc.c
+++ b/drivers/clocksource/xilinx_ttc.c
@@ -23,30 +23,14 @@
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/slab.h>
+#include <linux/clk-provider.h>
 
 #include <mach/zynq_soc.h>
 
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
 /*
  * Timer Register Offset Definitions of Timer 1, Increment base address by 4
  * and use same offsets for Timer 2
@@ -63,9 +47,14 @@
 
 #define XTTCPSS_CNT_CNTRL_DISABLE_MASK	0x1
 
-/* Setup the timers to use pre-scaling */
-
-#define TIMER_RATE (PERIPHERAL_CLOCK_RATE / 32)
+/* Setup the timers to use pre-scaling, using a fixed value for now that will
+ * work across most input frequency, but it may need to be more dynamic
+ */
+#define PRESCALE_EXPONENT	11	/* 2 ^ PRESCALE_EXPONENT = PRESCALE */
+#define PRESCALE		2048	/* The exponent must match this */
+#define CLK_CNTRL_PRESCALE	((PRESCALE_EXPONENT - 1) << 1)
+#define CLK_CNTRL_PRESCALE_EN	1
+#define CNT_CNTRL_RESET		(1<<4)
 
 /**
  * struct xttcpss_timer - This definition defines local timer structure
@@ -73,11 +62,25 @@
  * @base_addr:	Base address of timer
  **/
 struct xttcpss_timer {
-	void __iomem *base_addr;
+	void __iomem	*base_addr;
+};
+
+struct xttcpss_timer_clocksource {
+	struct xttcpss_timer	xttc;
+	struct clocksource	cs;
 };
 
-static struct xttcpss_timer timers[2];
-static struct clock_event_device xttcpss_clockevent;
+#define to_xttcpss_timer_clksrc(x) \
+		container_of(x, struct xttcpss_timer_clocksource, cs)
+
+struct xttcpss_timer_clockevent {
+	struct xttcpss_timer		xttc;
+	struct clock_event_device	ce;
+	struct clk			*clk;
+};
+
+#define to_xttcpss_timer_clkevent(x) \
+		container_of(x, struct xttcpss_timer_clockevent, ce)
 
 /**
  * xttcpss_set_interval - Set the timer interval value
@@ -99,7 +102,7 @@ static void xttcpss_set_interval(struct xttcpss_timer *timer,
 
 	/* Reset the counter (0x10) so that it starts from 0, one-shot
 	   mode makes this needed for timing to be right. */
-	ctrl_reg |= 0x10;
+	ctrl_reg |= CNT_CNTRL_RESET;
 	ctrl_reg &= ~XTTCPSS_CNT_CNTRL_DISABLE_MASK;
 	__raw_writel(ctrl_reg, timer->base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
 }
@@ -114,90 +117,31 @@ static void xttcpss_set_interval(struct xttcpss_timer *timer,
  **/
 static irqreturn_t xttcpss_clock_event_interrupt(int irq, void *dev_id)
 {
-	struct clock_event_device *evt = &xttcpss_clockevent;
-	struct xttcpss_timer *timer = dev_id;
+	struct xttcpss_timer_clockevent *xttce = dev_id;
+	struct xttcpss_timer *timer = &xttce->xttc;
 
 	/* Acknowledge the interrupt and call event handler */
 	__raw_writel(__raw_readl(timer->base_addr + XTTCPSS_ISR_OFFSET),
 			timer->base_addr + XTTCPSS_ISR_OFFSET);
 
-	evt->event_handler(evt);
+	xttce->ce.event_handler(&xttce->ce);
 
 	return IRQ_HANDLED;
 }
 
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
 /**
- * __raw_readl_cycles - Reads the timer counter register
+ * __xttc_clocksource_read - Reads the timer counter register
  *
  * returns: Current timer counter register value
  **/
-static cycle_t __raw_readl_cycles(struct clocksource *cs)
+static cycle_t __xttc_clocksource_read(struct clocksource *cs)
 {
-	struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKSOURCE];
+	struct xttcpss_timer *timer = &to_xttcpss_timer_clksrc(cs)->xttc;
 
 	return (cycle_t)__raw_readl(timer->base_addr +
 				XTTCPSS_COUNT_VAL_OFFSET);
 }
 
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
 /**
  * xttcpss_set_next_event - Sets the time interval for next event
  *
@@ -209,7 +153,8 @@ static struct clocksource clocksource_xttcpss = {
 static int xttcpss_set_next_event(unsigned long cycles,
 					struct clock_event_device *evt)
 {
-	struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKEVENT];
+	struct xttcpss_timer_clockevent *xttce = to_xttcpss_timer_clkevent(evt);
+	struct xttcpss_timer *timer = &xttce->xttc;
 
 	xttcpss_set_interval(timer, cycles);
 	return 0;
@@ -224,12 +169,14 @@ static int xttcpss_set_next_event(unsigned long cycles,
 static void xttcpss_set_mode(enum clock_event_mode mode,
 					struct clock_event_device *evt)
 {
-	struct xttcpss_timer *timer = &timers[XTTCPSS_CLOCKEVENT];
+	struct xttcpss_timer_clockevent *xttce = to_xttcpss_timer_clkevent(evt);
+	struct xttcpss_timer *timer = &xttce->xttc;
 	u32 ctrl_reg;
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
-		xttcpss_set_interval(timer, TIMER_RATE / HZ);
+		xttcpss_set_interval(timer,
+				     clk_get_rate(xttce->clk) / PRESCALE);
 		break;
 	case CLOCK_EVT_MODE_ONESHOT:
 	case CLOCK_EVT_MODE_UNUSED:
@@ -250,15 +197,99 @@ static void xttcpss_set_mode(enum clock_event_mode mode,
 	}
 }
 
-/*
- * Instantiate and initialize the clock event structure
- */
-static struct clock_event_device xttcpss_clockevent = {
-	.name		= "xttcpss_timer2",
-	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.set_next_event	= xttcpss_set_next_event,
-	.set_mode	= xttcpss_set_mode,
-	.rating		= 200,
+static int __init zynq_ttc_setup_clocksource(struct device_node *np,
+					     void __iomem *base)
+{
+	struct xttcpss_timer_clocksource *ttccs;
+	struct clk *clk;
+	int err;
+	u32 reg;
+
+	ttccs = kzalloc(sizeof(*ttccs), GFP_KERNEL);
+	WARN_ON(!ttccs);
+
+	err = of_property_read_u32(np, "reg", &reg);
+	WARN_ON(err);
+
+	clk = of_clk_get_by_name(np, "cpu_1x");
+	WARN_ON(IS_ERR(clk));
+
+	err = clk_prepare_enable(clk);
+	WARN_ON(err);
+
+	ttccs->xttc.base_addr = base + reg * 4;
+
+	ttccs->cs.name = np->name;
+	ttccs->cs.rating = 200;
+	ttccs->cs.read = __xttc_clocksource_read;
+	ttccs->cs.mask = CLOCKSOURCE_MASK(16);
+	ttccs->cs.flags = CLOCK_SOURCE_IS_CONTINUOUS;
+
+	__raw_writel(0x0,  ttccs->xttc.base_addr + XTTCPSS_IER_OFFSET);
+	__raw_writel(CLK_CNTRL_PRESCALE | CLK_CNTRL_PRESCALE_EN,
+		     ttccs->xttc.base_addr + XTTCPSS_CLK_CNTRL_OFFSET);
+	__raw_writel(CNT_CNTRL_RESET,
+		     ttccs->xttc.base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
+
+	err = clocksource_register_hz(&ttccs->cs, clk_get_rate(clk) / PRESCALE);
+	WARN_ON(err);
+
+	return 0;
+}
+
+static int __init zynq_ttc_setup_clockevent(struct device_node *np,
+					    void __iomem *base)
+{
+	struct xttcpss_timer_clockevent *ttcce;
+	int err, irq;
+	u32 reg;
+
+	ttcce = kzalloc(sizeof(*ttcce), GFP_KERNEL);
+	WARN_ON(!ttcce);
+
+	err = of_property_read_u32(np, "reg", &reg);
+	WARN_ON(err);
+
+	ttcce->xttc.base_addr = base + reg * 4;
+
+	ttcce->clk = of_clk_get_by_name(np, "cpu_1x");
+	WARN_ON(IS_ERR(ttcce->clk));
+
+	err = clk_prepare_enable(ttcce->clk);
+	WARN_ON(err);
+
+	irq = irq_of_parse_and_map(np, 0);
+	WARN_ON(!irq);
+
+	ttcce->ce.name = np->name;
+	ttcce->ce.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
+	ttcce->ce.set_next_event = xttcpss_set_next_event;
+	ttcce->ce.set_mode = xttcpss_set_mode;
+	ttcce->ce.rating = 200;
+	ttcce->ce.irq = irq;
+
+	__raw_writel(0x23, ttcce->xttc.base_addr + XTTCPSS_CNT_CNTRL_OFFSET);
+	__raw_writel(CLK_CNTRL_PRESCALE | CLK_CNTRL_PRESCALE_EN,
+		     ttcce->xttc.base_addr + XTTCPSS_CLK_CNTRL_OFFSET);
+	__raw_writel(0x1,  ttcce->xttc.base_addr + XTTCPSS_IER_OFFSET);
+
+	err = request_irq(irq, xttcpss_clock_event_interrupt, IRQF_TIMER,
+			  np->name, ttcce);
+	WARN_ON(err);
+
+	clockevents_config_and_register(&ttcce->ce,
+					clk_get_rate(ttcce->clk) / PRESCALE,
+					1, 0xfffe);
+
+	return 0;
+}
+
+static const __initconst struct of_device_id zynq_ttc_match[] = {
+	{ .compatible = "xlnx,ttc-counter-clocksource",
+		.data = zynq_ttc_setup_clocksource, },
+	{ .compatible = "xlnx,ttc-counter-clockevent",
+		.data = zynq_ttc_setup_clockevent, },
+	{}
 };
 
 /**
@@ -269,21 +300,27 @@ static struct clock_event_device xttcpss_clockevent = {
  **/
 void __init xttcpss_timer_init(void)
 {
-	xttcpss_timer_hardware_init();
-	clocksource_register_hz(&clocksource_xttcpss, TIMER_RATE);
+	struct device_node *np;
+
+	for_each_compatible_node(np, NULL, "xlnx,ttc") {
+		struct device_node *np_chld;
+		void __iomem *base;
 
-	/* Calculate the parameters to allow the clockevent to operate using
-	   integer math
-	*/
-	clockevents_calc_mult_shift(&xttcpss_clockevent, TIMER_RATE, 4);
+		base = of_iomap(np, 0);
+		WARN_ON(!base);
 
-	xttcpss_clockevent.max_delta_ns =
-		clockevent_delta2ns(0xfffe, &xttcpss_clockevent);
-	xttcpss_clockevent.min_delta_ns =
-		clockevent_delta2ns(1, &xttcpss_clockevent);
+		for_each_available_child_of_node(np, np_chld) {
+			int (*cb)(struct device_node *np, void __iomem *base);
+			const struct of_device_id *match;
 
-	/* Indicate that clock event is on 1st CPU as SMP boot needs it */
+			match = of_match_node(zynq_ttc_match, np_chld);
+			if (match) {
+				int err;
 
-	xttcpss_clockevent.cpumask = cpumask_of(0);
-	clockevents_register_device(&xttcpss_clockevent);
+				cb = match->data;
+				err = cb(np_chld, base);
+				WARN_ON(err);
+			}
+		}
+	}
 }
-- 
1.8.0

