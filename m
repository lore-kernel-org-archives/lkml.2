Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0EFC1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 22:27:12 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35164 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab0EFC1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 22:27:09 -0400
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Add clocksource_register_hz/khz interface
Date: Wed,  5 May 2010 19:27:04 -0700
Message-Id: <1273112824-5112-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	I updated the patch docs and made the calls EXPORT_SYMBOL_GPL.
However the need for both khz and hz is due to high freq clocksources
like the TSC who's cycles/sec are close to the upper bound of a u32.

Let me know if you (or anyone else) have any further thoughts on the 
interface, as again, it would be nice to have it ready for 2.6.35
so the per-arch conversions can be pushed.

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
 include/linux/clocksource.h |    3 ++
 kernel/time/clocksource.c   |   72 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 4bca8b6..1b0a5e0 100644
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
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 1f5dde6..9f43b88 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -625,6 +625,78 @@ static void clocksource_enqueue(struct clocksource *cs)
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
+ * clocksource_register_hz - Used to install new clocksources
+ * @t:		clocksource to be registered
+ * @hz:		clocksource frequency (cycles per second)
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
+EXPORT_SYMBOL_GPL(clocksource_register_hz);
+
+/**
+ * clocksource_register_khz - Used to install new clocksources
+ * @t:		clocksource to be registered
+ * @khz:	clocksource frequency (kilicycles per second)
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
+EXPORT_SYMBOL_GPL(clocksource_register_khz);
+
 /**
  * clocksource_register - Used to install new clocksources
  * @t:		clocksource to be registered
-- 
1.6.0.4

