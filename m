Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab0EJMh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 08:37:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:40125 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202Ab0EJMhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 08:37:23 -0400
Date: Mon, 10 May 2010 12:36:57 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de
In-Reply-To: <1273280858-30143-1-git-send-email-johnstul@us.ibm.com>
References: <1273280858-30143-1-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: Add clocksource_register_hz/khz interface
Message-ID: <tip-d7e81c269db899b800e0963dc4aceece1f82a680@git.kernel.org>
Git-Commit-ID: d7e81c269db899b800e0963dc4aceece1f82a680
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 10 May 2010 12:36:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7e81c269db899b800e0963dc4aceece1f82a680
Gitweb:     http://git.kernel.org/tip/d7e81c269db899b800e0963dc4aceece1f82a680
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Fri, 7 May 2010 18:07:38 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 10 May 2010 14:24:26 +0200

clocksource: Add clocksource_register_hz/khz interface

How to pick good mult/shift pairs has always been difficult to
describe to folks writing clocksource drivers, since it requires
careful tradeoffs in adjustment accuracy vs overflow limits.

Now, with the clocks_calc_mult_shift function, its much
easier. However, not many clocksources have converted to using that
function, and there is still the issue of the max interval length
assumption being made by each clocksource driver independently.

So this patch simplifies the registration process by having
clocksources be registered with a hz/khz value and the registration
function taking care of setting mult/shift.

This should take most of the confusion out of writing a clocksource
driver.

Additionally it also keeps the shift size tradeoff (more accuracy vs
longer possible nohz times) centralized so the timekeeping core can
keep track of the assumptions being made.

[ tglx: Coding style and comments fixed ]

Signed-off-by: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <1273280858-30143-1-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clocksource.h |   19 ++++++++++++++++-
 kernel/time/clocksource.c   |   48 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 1 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 4bca8b6..5ea3c60 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -273,7 +273,6 @@ static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
 }
 
 
-/* used to install a new clocksource */
 extern int clocksource_register(struct clocksource*);
 extern void clocksource_unregister(struct clocksource*);
 extern void clocksource_touch_watchdog(void);
@@ -287,6 +286,24 @@ extern void clocksource_mark_unstable(struct clocksource *cs);
 extern void
 clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec);
 
+/*
+ * Don't call __clocksource_register_scale directly, use
+ * clocksource_register_hz/khz
+ */
+extern int
+__clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq);
+
+static inline int clocksource_register_hz(struct clocksource *cs, u32 hz)
+{
+	return __clocksource_register_scale(cs, 1, hz);
+}
+
+static inline int clocksource_register_khz(struct clocksource *cs, u32 khz)
+{
+	return __clocksource_register_scale(cs, 1000, khz);
+}
+
+
 static inline void
 clocksource_calc_mult_shift(struct clocksource *cs, u32 freq, u32 minsec)
 {
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 1f5dde6..f08e99c 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -625,6 +625,54 @@ static void clocksource_enqueue(struct clocksource *cs)
 	list_add(&cs->list, entry);
 }
 
+
+/*
+ * Maximum time we expect to go between ticks. This includes idle
+ * tickless time. It provides the trade off between selecting a
+ * mult/shift pair that is very precise but can only handle a short
+ * period of time, vs. a mult/shift pair that can handle long periods
+ * of time but isn't as precise.
+ *
+ * This is a subsystem constant, and actual hardware limitations
+ * may override it (ie: clocksources that wrap every 3 seconds).
+ */
+#define MAX_UPDATE_LENGTH 5 /* Seconds */
+
+/**
+ * __clocksource_register_scale - Used to install new clocksources
+ * @t:		clocksource to be registered
+ * @scale:	Scale factor multiplied against freq to get clocksource hz
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
+	/*
+	 * Ideally we want to use  some of the limits used in
+	 * clocksource_max_deferment, to provide a more informed
+	 * MAX_UPDATE_LENGTH. But for now this just gets the
+	 * register interface working properly.
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
