Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab0EABgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 21:36:35 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47264 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758925Ab0EABg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 21:36:27 -0400
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/3] Add clocksource_register_hz/khz interface
Date: Fri, 30 Apr 2010 18:36:23 -0700
Message-Id: <1272677785-23881-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,

It would be great to get this into 2.6.35, so I can push on getting the per-arch
clocksource conversions queued and tested for 2.6.36-37.

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
 include/linux/clocksource.h |    5 +++
 kernel/time/clocksource.c   |   71 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 4bca8b6..1ef1c36 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -274,6 +274,9 @@ static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
 
 
 /* used to install a new clocksource */
+
+extern int clocksource_register_hz(struct clocksource*, u32);
+extern int clocksource_register_khz(struct clocksource*, u32);
 extern int clocksource_register(struct clocksource*);
 extern void clocksource_unregister(struct clocksource*);
 extern void clocksource_touch_watchdog(void);
@@ -294,6 +297,8 @@ clocksource_calc_mult_shift(struct clocksource *cs, u32 freq, u32 minsec)
 				      NSEC_PER_SEC, minsec);
 }
 
+
+
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void
 update_vsyscall(struct timespec *ts, struct clocksource *c, u32 mult);
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 1f5dde6..73b9aeb 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -625,6 +625,77 @@ static void clocksource_enqueue(struct clocksource *cs)
 	list_add(&cs->list, entry);
 }
 
+
+
+
+/* Maximum time we expect to go between ticks.
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
+ * clocksource_register - Used to install new clocksources
+ * @t:		clocksource to be registered
+ *
+ * Returns -EBUSY if registration fails, zero otherwise.
+ */
+int clocksource_register_hz(struct clocksource *cs, u32 hz)
+{
+	
+	/* Ideally we want to use  some of the limits used in 
+	 * clocksource_max_deferment, to provide a more informed
+	 * MAX_UPDATE_LENGTH. But for now this just gets the
+	 * regiseter interface working properly.
+	 */
+	clocks_calc_mult_shift(&cs->mult, &cs->shift, hz,
+				      NSEC_PER_SEC, MAX_UPDATE_LENGTH);
+	cs->max_idle_ns = clocksource_max_deferment(cs);
+
+	mutex_lock(&clocksource_mutex);
+	clocksource_enqueue(cs);
+	clocksource_select();
+	clocksource_enqueue_watchdog(cs);
+	mutex_unlock(&clocksource_mutex);
+	return 0;
+}
+EXPORT_SYMBOL(clocksource_register_hz);
+
+/**
+ * clocksource_register - Used to install new clocksources
+ * @t:		clocksource to be registered
+ *
+ * Returns -EBUSY if registration fails, zero otherwise.
+ */
+int clocksource_register_khz(struct clocksource *cs, u32 khz)
+{
+	
+	/* Ideally we want to use  some of the limits used in 
+	 * clocksource_max_deferment, to provide a more informed
+	 * MAX_UPDATE_LENGTH. But for now this just gets the
+	 * regiseter interface working properly.
+	 */
+	clocks_calc_mult_shift(&cs->mult, &cs->shift, khz,
+				      NSEC_PER_SEC/1000,
+				      MAX_UPDATE_LENGTH*1000);
+	cs->max_idle_ns = clocksource_max_deferment(cs);
+
+	mutex_lock(&clocksource_mutex);
+	clocksource_enqueue(cs);
+	clocksource_select();
+	clocksource_enqueue_watchdog(cs);
+	mutex_unlock(&clocksource_mutex);
+	return 0;
+}
+EXPORT_SYMBOL(clocksource_register_hz);
+
 /**
  * clocksource_register - Used to install new clocksources
  * @t:		clocksource to be registered
-- 
1.6.0.4

