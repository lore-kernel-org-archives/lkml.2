Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab2JaHYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:24:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:1355 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab2JaHYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:24:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,685,1344236400"; 
   d="scan'208";a="211617074"
Subject: [PATCH 3/3] alarmtimer: cleanup the POSIX clock interface without
 CONFIG_RTC_CLASS
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: john.stultz@linaro.org, tglx@linutronix.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1351700455.15558.1571.camel@cliu38-desktop-build>
References: <1351700455.15558.1571.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Nov 2012 00:25:04 +0800
Message-ID: <1351700704.15558.1575.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When CONFIG_RTC_CLASS is not defined, implementing the POSIX clock
interface with null function is enough.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/time/alarmtimer.c |   78 ++++++++++++++++++++++++++++++++++-----------
 1 files changed, 59 insertions(+), 19 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 5490fa8..12c17a4 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -41,10 +41,6 @@ static struct alarm_base {
 	clockid_t		base_clockid;
 } alarm_bases[ALARM_NUMTYPE];
 
-/* freezer delta & lock used to handle clock_nanosleep triggered wakeups */
-static ktime_t freezer_delta;
-static DEFINE_SPINLOCK(freezer_delta_lock);
-
 static struct wakeup_source *ws;
 
 #ifdef CONFIG_RTC_CLASS
@@ -53,6 +49,10 @@ static struct rtc_timer		rtctimer;
 static struct rtc_device	*rtcdev;
 static DEFINE_MUTEX(rtcdev_mutex);
 
+/* freezer delta & lock used to handle clock_nanosleep triggered wakeups */
+static ktime_t freezer_delta;
+static DEFINE_SPINLOCK(freezer_delta_lock);
+
 /**
  * alarmtimer_get_rtcdev - Return selected rtcdevice
  *
@@ -268,21 +268,6 @@ static int alarmtimer_suspend(struct device *dev)
 }
 #endif
 
-static void alarmtimer_freezerset(ktime_t absexp, enum alarmtimer_type type)
-{
-	ktime_t delta;
-	unsigned long flags;
-	struct alarm_base *base = &alarm_bases[type];
-
-	delta = ktime_sub(absexp, base->gettime());
-
-	spin_lock_irqsave(&freezer_delta_lock, flags);
-	if (!freezer_delta.tv64 || (delta.tv64 < freezer_delta.tv64))
-		freezer_delta = delta;
-	spin_unlock_irqrestore(&freezer_delta_lock, flags);
-}
-
-
 /**
  * alarm_init - Initialize an alarm structure
  * @alarm: ptr to alarm to be initialized
@@ -393,6 +378,21 @@ u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval)
 
 
 
+#ifdef CONFIG_RTC_CLASS
+static void alarmtimer_freezerset(ktime_t absexp, enum alarmtimer_type type)
+{
+	ktime_t delta;
+	unsigned long flags;
+	struct alarm_base *base = &alarm_bases[type];
+
+	delta = ktime_sub(absexp, base->gettime());
+
+	spin_lock_irqsave(&freezer_delta_lock, flags);
+	if (!freezer_delta.tv64 || (delta.tv64 < freezer_delta.tv64))
+		freezer_delta = delta;
+	spin_unlock_irqrestore(&freezer_delta_lock, flags);
+}
+
 
 /**
  * clock2alarm - helper that converts from clockid to alarmtypes
@@ -722,7 +722,47 @@ static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
 out:
 	return ret;
 }
+#else
+static inline int alarm_clock_getres(const clockid_t which_clock,
+						struct timespec *tp)
+{
+	return 0;
+}
+
+static inline int alarm_clock_get(clockid_t which_clock, struct timespec *tp)
+{
+	return 0;
+}
 
+static inline int alarm_timer_create(struct k_itimer *new_timer)
+{
+	return 0;
+}
+
+static inline int alarm_timer_set(struct k_itimer *timr, int flags,
+				struct itimerspec *new_setting,
+				struct itimerspec *old_setting)
+{
+	return 0;
+}
+
+static inline int alarm_timer_del(struct k_itimer *timr)
+{
+	return 0;
+}
+
+static inline void alarm_timer_get(struct k_itimer *timr,
+				struct itimerspec *cur_setting)
+{
+	return;
+}
+
+static inline int alarm_timer_nsleep(const clockid_t which_clock, int flags,
+		     struct timespec *tsreq, struct timespec __user *rmtp)
+{
+	return 0;
+}
+#endif
 
 /* Suspend hook structures */
 static const struct dev_pm_ops alarmtimer_pm_ops = {
-- 
1.7.0.4



