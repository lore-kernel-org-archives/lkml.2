Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2KZNbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:31:43 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54822 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab2KZNbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:31:42 -0500
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: John Stultz <johnstul@us.ibm.com>, Shawn Guo <shawn.guo@linaro.org>,
        Andres Salomon <dilinger@queued.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] clocksource: use clockevents_config_and_register() where possible
Date: Mon, 26 Nov 2012 21:31:40 +0800
Message-Id: <1353936700-15255-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clockevent core is able to figure out the best mult and shift,
calculate min_delta_ns and max_delta_ns, with the necessary info passed
into clockevents_config_and_register().  Use this combined configure
and register function where possible to make the codes less error prone
and gain some positive diff stat.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/clocksource/cs5535-clockevt.c |   11 ++---------
 drivers/clocksource/sunxi_timer.c     |   11 ++---------
 drivers/clocksource/tcb_clksrc.c      |    7 +------
 3 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/clocksource/cs5535-clockevt.c b/drivers/clocksource/cs5535-clockevt.c
index d927938..ea21048 100644
--- a/drivers/clocksource/cs5535-clockevt.c
+++ b/drivers/clocksource/cs5535-clockevt.c
@@ -100,7 +100,6 @@ static struct clock_event_device cs5535_clockevent = {
 	.set_mode = mfgpt_set_mode,
 	.set_next_event = mfgpt_next_event,
 	.rating = 250,
-	.shift = 32
 };
 
 static irqreturn_t mfgpt_tick(int irq, void *dev_id)
@@ -169,17 +168,11 @@ static int __init cs5535_mfgpt_init(void)
 	cs5535_mfgpt_write(cs5535_event_clock, MFGPT_REG_SETUP, val);
 
 	/* Set up the clock event */
-	cs5535_clockevent.mult = div_sc(MFGPT_HZ, NSEC_PER_SEC,
-			cs5535_clockevent.shift);
-	cs5535_clockevent.min_delta_ns = clockevent_delta2ns(0xF,
-			&cs5535_clockevent);
-	cs5535_clockevent.max_delta_ns = clockevent_delta2ns(0xFFFE,
-			&cs5535_clockevent);
-
 	printk(KERN_INFO DRV_NAME
 		": Registering MFGPT timer as a clock event, using IRQ %d\n",
 		timer_irq);
-	clockevents_register_device(&cs5535_clockevent);
+	clockevents_config_and_register(&cs5535_clockevent, MFGPT_HZ,
+					0xF, 0xFFFE);
 
 	return 0;
 
diff --git a/drivers/clocksource/sunxi_timer.c b/drivers/clocksource/sunxi_timer.c
index 3c46434..5026b78 100644
--- a/drivers/clocksource/sunxi_timer.c
+++ b/drivers/clocksource/sunxi_timer.c
@@ -74,7 +74,6 @@ static int sunxi_clkevt_next_event(unsigned long evt,
 
 static struct clock_event_device sunxi_clockevent = {
 	.name = "sunxi_tick",
-	.shift = 32,
 	.rating = 300,
 	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_mode = sunxi_clkevt_mode,
@@ -153,16 +152,10 @@ static void __init sunxi_timer_init(void)
 	val = readl(timer_base + TIMER_CTL_REG);
 	writel(val | TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG);
 
-	sunxi_clockevent.mult = div_sc(rate / TIMER_SCAL,
-				NSEC_PER_SEC,
-				sunxi_clockevent.shift);
-	sunxi_clockevent.max_delta_ns = clockevent_delta2ns(0xff,
-							    &sunxi_clockevent);
-	sunxi_clockevent.min_delta_ns = clockevent_delta2ns(0x1,
-							    &sunxi_clockevent);
 	sunxi_clockevent.cpumask = cpumask_of(0);
 
-	clockevents_register_device(&sunxi_clockevent);
+	clockevents_config_and_register(&sunxi_clockevent, rate / TIMER_SCAL,
+					0x1, 0xff);
 }
 
 struct sys_timer sunxi_timer = {
diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index 32cb929..8a61872 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -157,7 +157,6 @@ static struct tc_clkevt_device clkevt = {
 		.name		= "tc_clkevt",
 		.features	= CLOCK_EVT_FEAT_PERIODIC
 					| CLOCK_EVT_FEAT_ONESHOT,
-		.shift		= 32,
 		/* Should be lower than at91rm9200's system timer */
 		.rating		= 125,
 		.set_next_event	= tc_next_event,
@@ -196,13 +195,9 @@ static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 
 	timer_clock = clk32k_divisor_idx;
 
-	clkevt.clkevt.mult = div_sc(32768, NSEC_PER_SEC, clkevt.clkevt.shift);
-	clkevt.clkevt.max_delta_ns
-		= clockevent_delta2ns(0xffff, &clkevt.clkevt);
-	clkevt.clkevt.min_delta_ns = clockevent_delta2ns(1, &clkevt.clkevt) + 1;
 	clkevt.clkevt.cpumask = cpumask_of(0);
 
-	clockevents_register_device(&clkevt.clkevt);
+	clockevents_config_and_register(&clkevt.clkevt, 32768, 1, 0xffff);
 
 	setup_irq(irq, &tc_irqaction);
 }
-- 
1.7.9.5

