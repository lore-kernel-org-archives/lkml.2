Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab1FINJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:09:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:59803 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698Ab1FINIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:08:30 -0400
Message-Id: <20110609130622.241312122@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 09 Jun 2011 13:08:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>,
        Ingo Molnar <mingo@elte.hu>, John Stultz <john.stultz@linaro.org>
Subject: [patch 4/5] arm: footbridge: Use common i8253 clockevent
References: <20110609130509.346588418@linutronix.de>
Content-Disposition: inline; filename=arm-use-common-i8253-ce.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mach-footbridge/Kconfig     |    1 
 arch/arm/mach-footbridge/isa-timer.c |   51 -----------------------------------
 2 files changed, 2 insertions(+), 50 deletions(-)

Index: linux-2.6-tip/arch/arm/mach-footbridge/Kconfig
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-footbridge/Kconfig
+++ linux-2.6-tip/arch/arm/mach-footbridge/Kconfig
@@ -5,6 +5,7 @@ menu "Footbridge Implementations"
 config ARCH_CATS
 	bool "CATS"
 	select CLKSRC_I8253
+	select CLKEVT_I8253
 	select FOOTBRIDGE_HOST
 	select ISA
 	select ISA_DMA
Index: linux-2.6-tip/arch/arm/mach-footbridge/isa-timer.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-footbridge/isa-timer.c
+++ linux-2.6-tip/arch/arm/mach-footbridge/isa-timer.c
@@ -5,12 +5,10 @@
  *  Copyright (C) 1998 Phil Blundell
  */
 #include <linux/clockchips.h>
-#include <linux/clocksource.h>
 #include <linux/i8253.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/io.h>
 #include <linux/spinlock.h>
 #include <linux/timex.h>
 
@@ -19,48 +17,6 @@
 
 #include "common.h"
 
-static void pit_set_mode(enum clock_event_mode mode,
-	struct clock_event_device *evt)
-{
-	unsigned long flags;
-
-	raw_local_irq_save(flags);
-
-	switch (mode) {
-	case CLOCK_EVT_MODE_PERIODIC:
-		outb_p(0x34, PIT_MODE);
-		outb_p(PIT_LATCH & 0xff, PIT_CH0);
-		outb_p(PIT_LATCH >> 8, PIT_CH0);
-		break;
-
-	case CLOCK_EVT_MODE_SHUTDOWN:
-	case CLOCK_EVT_MODE_UNUSED:
-		outb_p(0x30, PIT_MODE);
-		outb_p(0, PIT_CH0);
-		outb_p(0, PIT_CH0);
-		break;
-
-	case CLOCK_EVT_MODE_ONESHOT:
-	case CLOCK_EVT_MODE_RESUME:
-		break;
-	}
-	local_irq_restore(flags);
-}
-
-static int pit_set_next_event(unsigned long delta,
-	struct clock_event_device *evt)
-{
-	return 0;
-}
-
-static struct clock_event_device pit_ce = {
-	.name		= "pit",
-	.features	= CLOCK_EVT_FEAT_PERIODIC,
-	.set_mode	= pit_set_mode,
-	.set_next_event	= pit_set_next_event,
-	.shift		= 32,
-};
-
 static irqreturn_t pit_timer_interrupt(int irq, void *dev_id)
 {
 	struct clock_event_device *ce = dev_id;
@@ -77,15 +33,10 @@ static struct irqaction pit_timer_irq = 
 
 static void __init isa_timer_init(void)
 {
-	pit_ce.cpumask = cpumask_of(smp_processor_id());
-	pit_ce.mult = div_sc(PIT_TICK_RATE, NSEC_PER_SEC, pit_ce.shift);
-	pit_ce.max_delta_ns = clockevent_delta2ns(0x7fff, &pit_ce);
-	pit_ce.min_delta_ns = clockevent_delta2ns(0x000f, &pit_ce);
-
 	clocksource_i8253_init();
 
 	setup_irq(pit_ce.irq, &pit_timer_irq);
-	clockevents_register_device(&pit_ce);
+	clockevents_i8253_init(false);
 }
 
 struct sys_timer isa_timer = {


