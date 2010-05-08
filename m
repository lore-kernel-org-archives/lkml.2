Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab0EHBHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 21:07:43 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56304 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab0EHBHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 21:07:42 -0400
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Add clocksource_register_hz/khz interface (take3)
Date: Fri,  7 May 2010 18:07:38 -0700
Message-Id: <1273280858-30143-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, 

Ok, got rid of the code duplication. Let me know if you see any
other issues with the interface.

thanks
-john


How to pick good mult/shif pairs has always been difficult to describe
to folks writing clocksource drivers, since it requires careful tradeoffs
in adjustment accuracy vs overflow limits.

Now, with the clocks_calc_mult_shift function, its much easier. However,
not many clocksources have converted to using that function, and there is
still the issue of the max interval length assumption being made by
each clocksource driver independently.

So this patch simplifies the registration process by having clocksources
be registered with a hz/khz value and the the registration function taking
care of setting mult/shift.

This should take most of the confusion out of writing a clocksource driver.

Additionally it also keeps the shift size tradeoff (more accuracy vs longer
possible nohz times) centralized so the timekeeping core can keep track of the
assumptions being made.

CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 include/linux/clocksource.h |   17 ++++++++++++++-
 kernel/time/clocksource.c   |   49 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 1 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 4bca8b6..b6d80f0 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -273,7 +273,6 @@ static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
 }
 
 
-/* used to install a new clocksource */
 extern int clocksource_register(struct clocksource*);
 extern void clocksource_unregister(struct clocksource*);
 extern void clocksource_touch_watchdog(void);
@@ -287,6 +286,22 @@ extern void clocksource_mark_unstable(struct clocksource *cs);
 extern void
 clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec);
 
+/*
+ * Don't call __clocksource_register_scale directly, use
+ * clocksource_register_hz/khz
+ */
+extern int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq);
+static inline int clocksource_register_hz(struct clocksource* cs, u32 hz)
+{
+	return __clocksource_register_scale(cs, 1, hz);
+}
+
+static inline int clocksource_register_khz(struct clocksource* cs, u32 khz)
+{
+	return __clocksource_register_scale(cs, 1000, khz);
+}
+
+
 static inline void
 clocksource_calc_mult_shift(struct clocksource *cs, u32 freq, u32 minsec)
 {
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 1f5dde6..13c6fef 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -625,6 +625,55 @@ static void clocksource_enqueue(struct clocksource *cs)
 	list_add(&cs->list, entry);
 }
 
+
+/*
+ * Maximum time we expect to go between ticks.
+ * This is includes idle tickless time. It provides
+ * the trade off between selecting a mult/shift pair 
+ * that is very precise but can only handle a short period 
+ * of time, vs. a mult/shift pair that can handle long 
+ * periods of time but isn't as precise. 
+ *
+ * This is a subsystem constant, and actual hardware limitations
+ * may override it (ie: clocksources that wrap every 3 seconds).
+ */
+#define MAX_UPDATE_LENGTH 5 /* Seconds */
+
+
+/**
+ * __clocksource_register_scale - Used to install new clocksources
+ * @t:		clocksource to be registered
+ * @scale:	Scale factor multiplied against freq to get clocksuorce hz
+ * @freq:	clocksource frequency (cycles per second) divided by scale
+ *
+ * Returns -EBUSY if registration fails, zero otherwise.
+ *
+ * This *SHOULD NOT* be called directly! Please use the 
+ * clocksource_register_hz() or clocksource_register_khz helper functions.
+ */
+int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
+{
+	
+	/* Ideally we want to use  some of the limits used in 
+	 * clocksource_max_deferment, to provide a more informed
+	 * MAX_UPDATE_LENGTH. But for now this just gets the
+	 * regiseter interface working properly.
+	 */
+	clocks_calc_mult_shift(&cs->mult, &cs->shift, freq,
+				      NSEC_PER_SEC/scale,
+				      MAX_UPDATE_LENGTH*scale);
+	cs->max_idle_ns = clocksource_max_deferment(cs);
+
+	mutex_lock(&clocksource_mutex);
+	clocksource_enqueue(cs);
+	clocksource_select();
+	clocksource_enqueue_watchdog(cs);
+	mutex_unlock(&clocksource_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__clocksource_register_scale);
+
+
 /**
  * clocksource_register - Used to install new clocksources
  * @t:		clocksource to be registered
-- 
1.6.0.4

