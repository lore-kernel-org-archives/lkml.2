Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab1FINIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:08:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:59781 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab1FINI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:08:27 -0400
Message-Id: <20110609130621.921710458@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 09 Jun 2011 13:08:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>,
        Ingo Molnar <mingo@elte.hu>, John Stultz <john.stultz@linaro.org>
Subject: [patch 1/5] i8253: Create common clockevent implementation
References: <20110609130509.346588418@linutronix.de>
Content-Disposition: inline; filename=pit-clockevent-device.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arm, mips and x86 implement i8253 based clockevents. All the same code
copied. Create a common implementation in drivers/clocksource/i8253.c.

About time to rename drivers/clocksource/ to something else.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <linux@arm.linux.org.uk>

---
 drivers/clocksource/Kconfig |    5 +-
 drivers/clocksource/i8253.c |  101 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 98 insertions(+), 8 deletions(-)

Index: linux-2.6-tip/drivers/clocksource/Kconfig
===================================================================
--- linux-2.6-tip.orig/drivers/clocksource/Kconfig
+++ linux-2.6-tip/drivers/clocksource/Kconfig
@@ -1,11 +1,14 @@
 config CLKSRC_I8253
 	bool
 
+config CLKEVT_I8253
+	bool
+
 config I8253_LOCK
 	bool
 
 config CLKBLD_I8253
-	def_bool y if CLKSRC_I8253 || I8253_LOCK
+	def_bool y if CLKSRC_I8253 || CLKEVT_I8253 || I8253_LOCK
 
 config CLKSRC_MMIO
 	bool
Index: linux-2.6-tip/drivers/clocksource/i8253.c
===================================================================
--- linux-2.6-tip.orig/drivers/clocksource/i8253.c
+++ linux-2.6-tip/drivers/clocksource/i8253.c
@@ -1,13 +1,14 @@
 /*
  * i8253 PIT clocksource
  */
-#include <linux/clocksource.h>
+#include <linux/clockchips.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
 #include <linux/timex.h>
 #include <linux/module.h>
 #include <linux/i8253.h>
+#include <linux/smp.h>
 
 /*
  * Protects access to I/O ports
@@ -49,15 +50,15 @@ static cycle_t i8253_read(struct clockso
 	 * count), it cannot be newer.
 	 */
 	jifs = jiffies;
-	outb_pit(0x00, PIT_MODE);	/* latch the count ASAP */
-	count = inb_pit(PIT_CH0);	/* read the latched count */
-	count |= inb_pit(PIT_CH0) << 8;
+	outb_p(0x00, PIT_MODE);	/* latch the count ASAP */
+	count = inb_p(PIT_CH0);	/* read the latched count */
+	count |= inb_p(PIT_CH0) << 8;
 
 	/* VIA686a test code... reset the latch if count > max + 1 */
 	if (count > LATCH) {
-		outb_pit(0x34, PIT_MODE);
-		outb_pit(PIT_LATCH & 0xff, PIT_CH0);
-		outb_pit(PIT_LATCH >> 8, PIT_CH0);
+		outb_p(0x34, PIT_MODE);
+		outb_p(PIT_LATCH & 0xff, PIT_CH0);
+		outb_p(PIT_LATCH >> 8, PIT_CH0);
 		count = PIT_LATCH - 1;
 	}
 
@@ -99,3 +100,89 @@ int __init clocksource_i8253_init(void)
 	return clocksource_register_hz(&i8253_cs, PIT_TICK_RATE);
 }
 #endif
+
+#ifdef CONFIG_CLKEVT_I8253
+/*
+ * Initialize the PIT timer.
+ *
+ * This is also called after resume to bring the PIT into operation again.
+ */
+static void init_pit_timer(enum clock_event_mode mode,
+			   struct clock_event_device *evt)
+{
+	raw_spin_lock(&i8253_lock);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		/* binary, mode 2, LSB/MSB, ch 0 */
+		outb_p(0x34, PIT_MODE);
+		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
+		outb_p(LATCH >> 8 , PIT_CH0);		/* MSB */
+		break;
+
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_UNUSED:
+		if (evt->mode == CLOCK_EVT_MODE_PERIODIC ||
+		    evt->mode == CLOCK_EVT_MODE_ONESHOT) {
+			outb_p(0x30, PIT_MODE);
+			outb_p(0, PIT_CH0);
+			outb_p(0, PIT_CH0);
+		}
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+		/* One shot setup */
+		outb_p(0x38, PIT_MODE);
+		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here */
+		break;
+	}
+	raw_spin_unlock(&i8253_lock);
+}
+
+/*
+ * Program the next event in oneshot mode
+ *
+ * Delta is given in PIT ticks
+ */
+static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
+{
+	raw_spin_lock(&i8253_lock);
+	outb_p(delta & 0xff , PIT_CH0);	/* LSB */
+	outb_p(delta >> 8 , PIT_CH0);		/* MSB */
+	raw_spin_unlock(&i8253_lock);
+
+	return 0;
+}
+
+/*
+ * On UP the PIT can serve all of the possible timer functions. On SMP systems
+ * it can be solely used for the global tick.
+ */
+struct clock_event_device i8253_clockevent = {
+	.name		= "pit",
+	.features	= CLOCK_EVT_FEAT_PERIODIC,
+	.set_mode	= init_pit_timer,
+	.set_next_event = pit_next_event,
+};
+
+/*
+ * Initialize the conversion factor and the min/max deltas of the clock event
+ * structure and register the clock event source with the framework.
+ */
+void __init clockevent_i8253_init(bool oneshot)
+{
+	if (oneshot)
+		i8253_clockevent.features |= CLOCK_EVT_FEAT_ONESHOT;
+	/*
+	 * Start pit with the boot cpu mask. x86 might make it global
+	 * when it is used as broadcast device later.
+	 */
+	i8253_clockevent.cpumask = cpumask_of(smp_processor_id());
+
+	clockevents_config_and_register(&i8253_clockevent, PIT_TICK_RATE,
+					0xF, 0x7FFF);
+}
+#endif


