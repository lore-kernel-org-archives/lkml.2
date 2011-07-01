Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1GAIlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:41:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:59842 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988Ab1GAIlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:41:44 -0400
Date: Fri, 1 Jul 2011 08:41:20 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-8560a6cfc9818edde1fd8677961714b264ffa03d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@redhat.com, ralf@linux-mips.org, linux@arm.linux.org.uk,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <20110609130622.241312122@linutronix.de>
References: <20110609130622.241312122@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] arm: Footbridge: Use common i8253 clockevent
Git-Commit-ID: 8560a6cfc9818edde1fd8677961714b264ffa03d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 08:41:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8560a6cfc9818edde1fd8677961714b264ffa03d
Gitweb:     http://git.kernel.org/tip/8560a6cfc9818edde1fd8677961714b264ffa03d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 9 Jun 2011 13:08:28 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 1 Jul 2011 10:37:14 +0200

arm: Footbridge: Use common i8253 clockevent

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/20110609130622.241312122@linutronix.de
---
 arch/arm/mach-footbridge/Kconfig     |    1 +
 arch/arm/mach-footbridge/isa-timer.c |   55 ++--------------------------------
 2 files changed, 4 insertions(+), 52 deletions(-)

diff --git a/arch/arm/mach-footbridge/Kconfig b/arch/arm/mach-footbridge/Kconfig
index 46adca0..dc26fff 100644
--- a/arch/arm/mach-footbridge/Kconfig
+++ b/arch/arm/mach-footbridge/Kconfig
@@ -5,6 +5,7 @@ menu "Footbridge Implementations"
 config ARCH_CATS
 	bool "CATS"
 	select CLKSRC_I8253
+	select CLKEVT_I8253
 	select FOOTBRIDGE_HOST
 	select ISA
 	select ISA_DMA
diff --git a/arch/arm/mach-footbridge/isa-timer.c b/arch/arm/mach-footbridge/isa-timer.c
index 71fd96d..c40bb41 100644
--- a/arch/arm/mach-footbridge/isa-timer.c
+++ b/arch/arm/mach-footbridge/isa-timer.c
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
@@ -72,20 +28,15 @@ static struct irqaction pit_timer_irq = {
 	.name		= "pit",
 	.handler	= pit_timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
-	.dev_id		= &pit_ce,
+	.dev_id		= &i8253_clockevent,
 };
 
 static void __init isa_timer_init(void)
 {
-	pit_ce.cpumask = cpumask_of(smp_processor_id());
-	pit_ce.mult = div_sc(PIT_TICK_RATE, NSEC_PER_SEC, pit_ce.shift);
-	pit_ce.max_delta_ns = clockevent_delta2ns(0x7fff, &pit_ce);
-	pit_ce.min_delta_ns = clockevent_delta2ns(0x000f, &pit_ce);
-
 	clocksource_i8253_init();
 
-	setup_irq(pit_ce.irq, &pit_timer_irq);
-	clockevents_register_device(&pit_ce);
+	setup_irq(i8253_clockevent.irq, &pit_timer_irq);
+	clockevent_i8253_init(false);
 }
 
 struct sys_timer isa_timer = {
