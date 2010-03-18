Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320Ab0CRCBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 22:01:51 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:54120 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab0CRCBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 22:01:50 -0400
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>
Subject: [RFC][PATCH] Convert alpha to use clocksource
Date: Wed, 17 Mar 2010 19:01:42 -0700
Message-Id: <1268877702-2236-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alpha has a tsc like rpcc counter that it uses to manage time.
This can be converted to an actual clocksource instead of utilizing
the arch_gettimeoffset method that is really only there for legacy
systems with no continuous counter.

Further cleanups could be made if alpha converted to the clockevent model.

I've not tested or compiled this code. Any help or feedback from the 
maintainers would be greatly appreciated

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Richard Henderson <rth@twiddle.net>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Matt Turner <mattst88@gmail.com>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/alpha/Kconfig       |    4 --
 arch/alpha/kernel/time.c |   71 +++++++++++++++++++++------------------------
 2 files changed, 33 insertions(+), 42 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 75291fd..793c269 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -51,10 +51,6 @@ config GENERIC_TIME
 	bool
 	default y
 
-config ARCH_USES_GETTIMEOFFSET
-	bool
-	default y
-
 config ZONE_DMA
 	bool
 	default y
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index 5d08266..b245144 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -51,6 +51,7 @@
 #include <linux/mc146818rtc.h>
 #include <linux/time.h>
 #include <linux/timex.h>
+#include <linux/clocksource.h>
 
 #include "proto.h"
 #include "irq_impl.h"
@@ -301,6 +302,36 @@ rpcc_after_update_in_progress(void)
 	return rpcc();
 }
 
+#ifndef CONFIG_SMP
+/* Until and unless we figure out how to get cpu cycle counters
+   in sync and keep them there, we can't use the rpcc.  */
+static cycle_t read_rpcc(struct clocksource *cs)
+{
+	cycle_t ret = (cycle_t)rpcc();
+	return ret;
+}
+
+static struct clocksource clocksource_rpcc = {
+	.name                   = "rpcc",
+	.rating                 = 300,
+	.read                   = read_rpcc,
+	.mask                   = CLOCKSOURCE_MASK(32),
+	.shift                  = 22,
+	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS
+};
+
+static inline void register_rpcc_clocksource(long cycle_freq)
+{
+	clocksource_rpcc.mult = clocksource_hz2mult(cycle_freq,
+						clocksource_rpcc.shift);
+	clocksource_register(&clocksource_rpcc);
+}
+#else /* !CONFIG_SMP */
+static inline void register_rpcc_clocksource(long cycle_freq)
+{
+}
+#endif /* !CONFIG_SMP */
+
 void __init
 time_init(void)
 {
@@ -391,6 +422,8 @@ time_init(void)
 		__you_loose();
 	}
 
+	register_rpcc_clocksource(cycle_freq);
+
 	state.last_time = cc1;
 	state.scaled_ticks_per_cycle
 		= ((unsigned long) HZ << FIX_SHIFT) / cycle_freq;
@@ -402,44 +435,6 @@ time_init(void)
 }
 
 /*
- * Use the cycle counter to estimate an displacement from the last time
- * tick.  Unfortunately the Alpha designers made only the low 32-bits of
- * the cycle counter active, so we overflow on 8.2 seconds on a 500MHz
- * part.  So we can't do the "find absolute time in terms of cycles" thing
- * that the other ports do.
- */
-u32 arch_gettimeoffset(void)
-{
-#ifdef CONFIG_SMP
-	/* Until and unless we figure out how to get cpu cycle counters
-	   in sync and keep them there, we can't use the rpcc tricks.  */
-	return 0;
-#else
-	unsigned long delta_cycles, delta_usec, partial_tick;
-
-	delta_cycles = rpcc() - state.last_time;
-	partial_tick = state.partial_tick;
-	/*
-	 * usec = cycles * ticks_per_cycle * 2**48 * 1e6 / (2**48 * ticks)
-	 *	= cycles * (s_t_p_c) * 1e6 / (2**48 * ticks)
-	 *	= cycles * (s_t_p_c) * 15625 / (2**42 * ticks)
-	 *
-	 * which, given a 600MHz cycle and a 1024Hz tick, has a
-	 * dynamic range of about 1.7e17, which is less than the
-	 * 1.8e19 in an unsigned long, so we are safe from overflow.
-	 *
-	 * Round, but with .5 up always, since .5 to even is harder
-	 * with no clear gain.
-	 */
-
-	delta_usec = (delta_cycles * state.scaled_ticks_per_cycle 
-		      + partial_tick) * 15625;
-	delta_usec = ((delta_usec / ((1UL << (FIX_SHIFT-6-1)) * HZ)) + 1) / 2;
-	return delta_usec * 1000;
-#endif
-}
-
-/*
  * In order to set the CMOS clock precisely, set_rtc_mmss has to be
  * called 500 ms after the second nowtime has started, because when
  * nowtime is written into the registers of the CMOS clock, it will
-- 
1.6.0.4

