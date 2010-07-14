Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab0GNA5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:57:50 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:43834 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab0GNA4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:56:31 -0400
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 11/11] Add __clocksource_updatefreq_hz/khz methods
Date: Tue, 13 Jul 2010 17:56:28 -0700
Message-Id: <1279068988-21864-12-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1279068988-21864-11-git-send-email-johnstul@us.ibm.com>
References: <1279068988-21864-1-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-2-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-3-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-4-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-5-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-6-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-7-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-8-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-9-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-10-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-11-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To properly handle clocksources that change frequencies
at the clocksource->enable() point, this patch adds
a method that will update the clocksource's mult/shift and
max_idle_ns values.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/clocksource.h |   11 +++++++++++
 kernel/time/clocksource.c   |   29 ++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 21677d9..edd20e6 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -292,6 +292,8 @@ clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 minsec);
  */
 extern int
 __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq);
+extern void 
+__clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq);
 
 static inline int clocksource_register_hz(struct clocksource *cs, u32 hz)
 {
@@ -303,6 +305,15 @@ static inline int clocksource_register_khz(struct clocksource *cs, u32 khz)
 	return __clocksource_register_scale(cs, 1000, khz);
 }
 
+static inline void __clocksource_updatefreq_hz(struct clocksource *cs, u32 hz)
+{
+	__clocksource_updatefreq_scale(cs, 1, hz);
+}
+
+static inline void __clocksource_updatefreq_khz(struct clocksource *cs, u32 khz)
+{
+	__clocksource_updatefreq_scale(cs, 1000, khz);
+}
 
 static inline void
 clocksource_calc_mult_shift(struct clocksource *cs, u32 freq, u32 minsec)
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c543d21..c18d7ef 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -639,19 +639,18 @@ static void clocksource_enqueue(struct clocksource *cs)
 #define MAX_UPDATE_LENGTH 5 /* Seconds */
 
 /**
- * __clocksource_register_scale - Used to install new clocksources
+ * __clocksource_updatefreq_scale - Used update clocksource with new freq
  * @t:		clocksource to be registered
  * @scale:	Scale factor multiplied against freq to get clocksource hz
  * @freq:	clocksource frequency (cycles per second) divided by scale
  *
- * Returns -EBUSY if registration fails, zero otherwise.
+ * This should only be called from the clocksource->enable() method.
  *
  * This *SHOULD NOT* be called directly! Please use the
- * clocksource_register_hz() or clocksource_register_khz helper functions.
+ * clocksource_updatefreq_hz() or clocksource_updatefreq_khz helper functions.
  */
-int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
+void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 {
-
 	/*
 	 * Ideally we want to use  some of the limits used in
 	 * clocksource_max_deferment, to provide a more informed
@@ -662,7 +661,27 @@ int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
 				      NSEC_PER_SEC/scale,
 				      MAX_UPDATE_LENGTH*scale);
 	cs->max_idle_ns = clocksource_max_deferment(cs);
+}
+EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
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
+	/* Intialize mult/shift and max_idle_ns */
+	__clocksource_updatefreq_scale(cs, scale, freq);
 
+	/* Add clocksource to the clcoksource list */
 	mutex_lock(&clocksource_mutex);
 	clocksource_enqueue(cs);
 	clocksource_select();
-- 
1.6.0.4

