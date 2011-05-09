Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab1EIN3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 09:29:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39357 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1EIN3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 09:29:07 -0400
Date: Mon, 09 May 2011 14:29:01 +0100
Message-Id: <E1QJQWD-0000Lz-Ou@rmk-PC.arm.linux.org.uk>
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 2/4] clocksource: convert footbridge to generic i8253
 clocksource
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the footbridge isa-timer code to use generic i8253 clocksource.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/include/asm/i8253.h         |   15 +++++++++++
 arch/arm/mach-footbridge/Kconfig     |    2 +
 arch/arm/mach-footbridge/isa-timer.c |   45 +++-------------------------------
 include/linux/clocksource.h          |    2 +
 4 files changed, 23 insertions(+), 41 deletions(-)
 create mode 100644 arch/arm/include/asm/i8253.h

diff --git a/arch/arm/include/asm/i8253.h b/arch/arm/include/asm/i8253.h
new file mode 100644
index 0000000..70656b6
--- /dev/null
+++ b/arch/arm/include/asm/i8253.h
@@ -0,0 +1,15 @@
+#ifndef __ASMARM_I8253_H
+#define __ASMARM_I8253_H
+
+/* i8253A PIT registers */
+#define PIT_MODE	0x43
+#define PIT_CH0		0x40
+
+#define PIT_LATCH	((PIT_TICK_RATE + HZ / 2) / HZ)
+
+extern raw_spinlock_t i8253_lock;
+
+#define outb_pit	outb_p
+#define inb_pit		inb_p
+
+#endif
diff --git a/arch/arm/mach-footbridge/Kconfig b/arch/arm/mach-footbridge/Kconfig
index bdd2579..46adca0 100644
--- a/arch/arm/mach-footbridge/Kconfig
+++ b/arch/arm/mach-footbridge/Kconfig
@@ -4,6 +4,7 @@ menu "Footbridge Implementations"
 
 config ARCH_CATS
 	bool "CATS"
+	select CLKSRC_I8253
 	select FOOTBRIDGE_HOST
 	select ISA
 	select ISA_DMA
@@ -59,6 +60,7 @@ config ARCH_EBSA285_HOST
 
 config ARCH_NETWINDER
 	bool "NetWinder"
+	select CLKSRC_I8253
 	select FOOTBRIDGE_HOST
 	select ISA
 	select ISA_DMA
diff --git a/arch/arm/mach-footbridge/isa-timer.c b/arch/arm/mach-footbridge/isa-timer.c
index 441c6ce..7020f1a 100644
--- a/arch/arm/mach-footbridge/isa-timer.c
+++ b/arch/arm/mach-footbridge/isa-timer.c
@@ -10,53 +10,16 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/spinlock.h>
 #include <linux/timex.h>
 
 #include <asm/irq.h>
-
+#include <asm/i8253.h>
 #include <asm/mach/time.h>
 
 #include "common.h"
 
-#define PIT_MODE	0x43
-#define PIT_CH0		0x40
-
-#define PIT_LATCH	((PIT_TICK_RATE + HZ / 2) / HZ)
-
-static cycle_t pit_read(struct clocksource *cs)
-{
-	unsigned long flags;
-	static int old_count;
-	static u32 old_jifs;
-	int count;
-	u32 jifs;
-
-	raw_local_irq_save(flags);
-
-	jifs = jiffies;
-	outb_p(0x00, PIT_MODE);		/* latch the count */
-	count = inb_p(PIT_CH0);		/* read the latched count */
-	count |= inb_p(PIT_CH0) << 8;
-
-	if (count > old_count && jifs == old_jifs)
-		count = old_count;
-
-	old_count = count;
-	old_jifs = jifs;
-
-	raw_local_irq_restore(flags);
-
-	count = (PIT_LATCH - 1) - count;
-
-	return (cycle_t)(jifs * PIT_LATCH) + count;
-}
-
-static struct clocksource pit_cs = {
-	.name		= "pit",
-	.rating		= 110,
-	.read		= pit_read,
-	.mask		= CLOCKSOURCE_MASK(32),
-};
+DEFINE_RAW_SPINLOCK(i8253_lock);
 
 static void pit_set_mode(enum clock_event_mode mode,
 	struct clock_event_device *evt)
@@ -121,7 +84,7 @@ static void __init isa_timer_init(void)
 	pit_ce.max_delta_ns = clockevent_delta2ns(0x7fff, &pit_ce);
 	pit_ce.min_delta_ns = clockevent_delta2ns(0x000f, &pit_ce);
 
-	clocksource_register_hz(&pit_cs, PIT_TICK_RATE);
+	clocksource_i8253_init();
 
 	setup_irq(pit_ce.irq, &pit_timer_irq);
 	clockevents_register_device(&pit_ce);
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index c37b21a..f13469b 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -341,4 +341,6 @@ static inline void update_vsyscall_tz(void)
 
 extern void timekeeping_notify(struct clocksource *clock);
 
+extern int clocksource_i8253_init(void);
+
 #endif /* _LINUX_CLOCKSOURCE_H */
-- 
1.7.4.4

