Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab0G0KtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 06:49:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:34813 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab0G0KtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 06:49:20 -0400
Date: Tue, 27 Jul 2010 10:49:03 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de
In-Reply-To: <1279068988-21864-12-git-send-email-johnstul@us.ibm.com>
References: <1279068988-21864-12-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/clocksource] clocksource: Add __clocksource_updatefreq_hz/khz methods
Message-ID: <tip-852db46d55e85b475a72e665ca08d3317769ceef@git.kernel.org>
Git-Commit-ID: 852db46d55e85b475a72e665ca08d3317769ceef
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Jul 2010 10:49:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  852db46d55e85b475a72e665ca08d3317769ceef
Gitweb:     http://git.kernel.org/tip/852db46d55e85b475a72e665ca08d3317769ceef
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Tue, 13 Jul 2010 17:56:28 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 27 Jul 2010 12:40:55 +0200

clocksource: Add __clocksource_updatefreq_hz/khz methods

To properly handle clocksources that change frequencies
at the clocksource->enable() point, this patch adds
a method that will update the clocksource's mult/shift and
max_idle_ns values.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <1279068988-21864-12-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/clocksource.h |   11 +++++++++++
 kernel/time/clocksource.c   |   29 ++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 21677d9..c37b21a 100644
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
