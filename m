Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1GAIka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:40:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:59780 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881Ab1GAIk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:40:28 -0400
Date: Fri, 1 Jul 2011 08:40:00 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-e6220bdc9485c5ea972f9e0e6d062a05934bb74b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@redhat.com, ralf@linux-mips.org, linux@arm.linux.org.uk,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <20110609130621.921710458@linutronix.de>
References: <20110609130621.921710458@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] i8253: Create common clockevent implementation
Git-Commit-ID: e6220bdc9485c5ea972f9e0e6d062a05934bb74b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 08:40:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6220bdc9485c5ea972f9e0e6d062a05934bb74b
Gitweb:     http://git.kernel.org/tip/e6220bdc9485c5ea972f9e0e6d062a05934bb74b
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 9 Jun 2011 13:08:25 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 1 Jul 2011 10:37:14 +0200

i8253: Create common clockevent implementation

arm, mips and x86 implement i8253 based clockevents. All the same code
copied. Create a common implementation in drivers/clocksource/i8253.c.

About time to rename drivers/clocksource/ to something else.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/20110609130621.921710458@linutronix.de

---
 drivers/clocksource/Kconfig |    5 ++-
 drivers/clocksource/i8253.c |  101 ++++++++++++++++++++++++++++++++++++++++---
 include/linux/i8253.h       |    2 +
 3 files changed, 100 insertions(+), 8 deletions(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 330343b..d8d3e02 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
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
diff --git a/drivers/clocksource/i8253.c b/drivers/clocksource/i8253.c
index e594f52..27c49e6 100644
--- a/drivers/clocksource/i8253.c
+++ b/drivers/clocksource/i8253.c
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
@@ -47,15 +48,15 @@ static cycle_t i8253_read(struct clocksource *cs)
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
 
@@ -97,3 +98,89 @@ int __init clocksource_i8253_init(void)
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
diff --git a/include/linux/i8253.h b/include/linux/i8253.h
index 76039c8..487d50c 100644
--- a/include/linux/i8253.h
+++ b/include/linux/i8253.h
@@ -24,6 +24,8 @@
 #define outb_pit        outb_p
 
 extern raw_spinlock_t i8253_lock;
+extern struct clock_event_device i8253_clockevent;
+extern void clockevent_i8253_init(bool oneshot);
 
 extern void setup_pit_timer(void);
 
