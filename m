Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab1FUXxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:53:18 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:52729 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab1FUXxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:53:12 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Meelis Roos <mroos@ut.ee>
Subject: [PATCH 1/2] alarmtimers: Handle late rtc module loading
Date: Tue, 21 Jun 2011 16:52:52 -0700
Message-Id: <1308700373-18415-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1308700373-18415-1-git-send-email-john.stultz@linaro.org>
References: <1308700373-18415-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The alarmtimers code currently picks a rtc device to use at
late init time. However, if your rtc driver is loaded as a module,
it may be registered after the alarmtimers late init code, leaving
the alarmtimers nonfunctional.

This patch moves the the rtcdevice selection to when we actually try
to use it, allowing us to make use of rtc modules that may have been
loaded at any point since bootup.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Meelis Roos <mroos@ut.ee>
Reported-by: Meelis Roos <mroos@ut.ee>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/alarmtimer.c |  137 ++++++++++++++++++++++-----------------------
 1 files changed, 67 insertions(+), 70 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 2d96624..98ecf4e 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -42,15 +42,72 @@ static struct alarm_base {
 	clockid_t		base_clockid;
 } alarm_bases[ALARM_NUMTYPE];
 
+/* freezer delta & lock used to handle clock_nanosleep triggered wakeups */
+static ktime_t freezer_delta;
+static DEFINE_SPINLOCK(freezer_delta_lock);
+
 #ifdef CONFIG_RTC_CLASS
 /* rtc timer and device for setting alarm wakeups at suspend */
 static struct rtc_timer		rtctimer;
 static struct rtc_device	*rtcdev;
-#endif
+static DEFINE_SPINLOCK(rtcdev_lock);
 
-/* freezer delta & lock used to handle clock_nanosleep triggered wakeups */
-static ktime_t freezer_delta;
-static DEFINE_SPINLOCK(freezer_delta_lock);
+/**
+ * has_wakealarm - check rtc device has wakealarm ability
+ * @dev: current device
+ * @name_ptr: name to be returned
+ *
+ * This helper function checks to see if the rtc device can wake
+ * from suspend.
+ */
+static int has_wakealarm(struct device *dev, void *name_ptr)
+{
+	struct rtc_device *candidate = to_rtc_device(dev);
+
+	if (!candidate->ops->set_alarm)
+		return 0;
+	if (!device_may_wakeup(candidate->dev.parent))
+		return 0;
+
+	*(const char **)name_ptr = dev_name(dev);
+	return 1;
+}
+
+/**
+ * alarmtimer_get_rtcdev - Return selected rtcdevice
+ *
+ * This function returns the rtc device to use for wakealarms.
+ * If one has not already been chosen, it checks to see if a
+ * functional rtc device is available.
+ */
+static struct rtc_device *alarmtimer_get_rtcdev(void)
+{
+	struct device *dev;
+	char *str;
+	unsigned long flags;
+	struct rtc_device *ret;
+
+	spin_lock_irqsave(&rtcdev_lock, flags);
+	if (!rtcdev) {
+		/* Find an rtc device and init the rtc_timer */
+		dev = class_find_device(rtc_class, NULL, &str, has_wakealarm);
+		/* If we have a device then str is valid. See has_wakealarm() */
+		if (dev) {
+			rtcdev = rtc_class_open(str);
+			/*
+			 * Drop the reference we got in class_find_device,
+			 * rtc_open takes its own.
+			 */
+			put_device(dev);
+			rtc_timer_init(&rtctimer, NULL, NULL);
+		}
+	}
+	ret = rtcdev;
+	spin_unlock_irqrestore(&rtcdev_lock, flags);
+
+	return ret;
+}
+#endif
 
 
 /**
@@ -166,6 +223,7 @@ static int alarmtimer_suspend(struct device *dev)
 	struct rtc_time tm;
 	ktime_t min, now;
 	unsigned long flags;
+	struct rtc_device *rtc;
 	int i;
 
 	spin_lock_irqsave(&freezer_delta_lock, flags);
@@ -173,8 +231,9 @@ static int alarmtimer_suspend(struct device *dev)
 	freezer_delta = ktime_set(0, 0);
 	spin_unlock_irqrestore(&freezer_delta_lock, flags);
 
+	rtc = alarmtimer_get_rtcdev();
 	/* If we have no rtcdev, just return */
-	if (!rtcdev)
+	if (!rtc)
 		return 0;
 
 	/* Find the soonest timer to expire*/
@@ -199,12 +258,12 @@ static int alarmtimer_suspend(struct device *dev)
 	WARN_ON(min.tv64 < NSEC_PER_SEC);
 
 	/* Setup an rtc timer to fire that far in the future */
-	rtc_timer_cancel(rtcdev, &rtctimer);
-	rtc_read_time(rtcdev, &tm);
+	rtc_timer_cancel(rtc, &rtctimer);
+	rtc_read_time(rtc, &tm);
 	now = rtc_tm_to_ktime(tm);
 	now = ktime_add(now, min);
 
-	rtc_timer_start(rtcdev, &rtctimer, now, ktime_set(0, 0));
+	rtc_timer_start(rtc, &rtctimer, now, ktime_set(0, 0));
 
 	return 0;
 }
@@ -638,65 +697,3 @@ static int __init alarmtimer_init(void)
 }
 device_initcall(alarmtimer_init);
 
-#ifdef CONFIG_RTC_CLASS
-/**
- * has_wakealarm - check rtc device has wakealarm ability
- * @dev: current device
- * @name_ptr: name to be returned
- *
- * This helper function checks to see if the rtc device can wake
- * from suspend.
- */
-static int __init has_wakealarm(struct device *dev, void *name_ptr)
-{
-	struct rtc_device *candidate = to_rtc_device(dev);
-
-	if (!candidate->ops->set_alarm)
-		return 0;
-	if (!device_may_wakeup(candidate->dev.parent))
-		return 0;
-
-	*(const char **)name_ptr = dev_name(dev);
-	return 1;
-}
-
-/**
- * alarmtimer_init_late - Late initializing of alarmtimer code
- *
- * This function locates a rtc device to use for wakealarms.
- * Run as late_initcall to make sure rtc devices have been
- * registered.
- */
-static int __init alarmtimer_init_late(void)
-{
-	struct device *dev;
-	char *str;
-
-	/* Find an rtc device and init the rtc_timer */
-	dev = class_find_device(rtc_class, NULL, &str, has_wakealarm);
-	/* If we have a device then str is valid. See has_wakealarm() */
-	if (dev) {
-		rtcdev = rtc_class_open(str);
-		/*
-		 * Drop the reference we got in class_find_device,
-		 * rtc_open takes its own.
-		 */
-		put_device(dev);
-	}
-	if (!rtcdev) {
-		printk(KERN_WARNING "No RTC device found, ALARM timers will"
-			" not wake from suspend");
-	}
-	rtc_timer_init(&rtctimer, NULL, NULL);
-
-	return 0;
-}
-#else
-static int __init alarmtimer_init_late(void)
-{
-	printk(KERN_WARNING "Kernel not built with RTC support, ALARM timers"
-		" will not wake from suspend");
-	return 0;
-}
-#endif
-late_initcall(alarmtimer_init_late);
-- 
1.7.3.2.146.gca209

