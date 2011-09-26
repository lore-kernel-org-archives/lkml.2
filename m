Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1IZTRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 15:17:31 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59683 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab1IZTRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 15:17:30 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: [PATCH 5/6] [RFC] alarmtimer: Add pm_stay_awake /pm_relax calls
Date: Mon, 26 Sep 2011 12:13:53 -0700
Message-Id: <1317064434-1829-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
x-cbid: 11092619-6078-0000-0000-000001362AA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides wakelock like chaining to  protects the
RTC wakeup path to the hrtimer firing of the alarmtimer.

CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: arve@android.com
CC: markgross@thegnar.org
CC: Alan Stern <stern@rowland.harvard.edu>
CC: amit.kucheria@linaro.org
CC: farrowg@sg.ibm.com
CC: Dmitry Fink (Palm GBU) <Dmitry.Fink@palm.com>
CC: linux-pm@lists.linux-foundation.org
CC: khilman@ti.com
CC: Magnus Damm <damm@opensource.se>
CC: mjg@redhat.com 
CC: peterz@infradead.org 
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/alarmtimer.c |   44 ++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index ea5e1a9..00ee80f 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -46,12 +46,17 @@ static struct alarm_base {
 static ktime_t freezer_delta;
 static DEFINE_SPINLOCK(freezer_delta_lock);
 
+
 #ifdef CONFIG_RTC_CLASS
 /* rtc timer and device for setting alarm wakeups at suspend */
 static struct rtc_timer		rtctimer;
 static struct rtc_device	*rtcdev;
 static DEFINE_SPINLOCK(rtcdev_lock);
 
+static struct wakeup_source *alarmtimer_wakelock;
+static int stay_awake;
+static DEFINE_SPINLOCK(stay_awake_lock);
+
 /**
  * has_wakealarm - check rtc device has wakealarm ability
  * @dev: current device
@@ -73,6 +78,19 @@ static int has_wakealarm(struct device *dev, void *name_ptr)
 	return 1;
 }
 
+/* rtctimer function called by first rtc interrupt after suspend */
+void alarmtimer_resume_call(void* p)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&stay_awake_lock, flags);
+	if (stay_awake == 1) {
+		stay_awake = 2;
+		__pm_stay_awake(alarmtimer_wakelock);
+	}
+	spin_unlock_irqrestore(&stay_awake_lock, flags);
+}
+
 /**
  * alarmtimer_get_rtcdev - Return selected rtcdevice
  *
@@ -99,7 +117,7 @@ static struct rtc_device *alarmtimer_get_rtcdev(void)
 			 * rtc_open takes its own.
 			 */
 			put_device(dev);
-			rtc_timer_init(&rtctimer, NULL, NULL);
+			rtc_timer_init(&rtctimer, alarmtimer_resume_call, NULL);
 		}
 	}
 	ret = rtcdev;
@@ -158,6 +176,8 @@ static void alarmtimer_remove(struct alarm_base *base, struct alarm *alarm)
 }
 
 
+
+
 /**
  * alarmtimer_fired - Handles alarm hrtimer being fired.
  * @timer: pointer to hrtimer being run
@@ -175,6 +195,8 @@ static enum hrtimer_restart alarmtimer_fired(struct hrtimer *timer)
 	ktime_t now;
 	int ret = HRTIMER_NORESTART;
 
+
+	__pm_stay_awake(alarmtimer_wakelock);
 	spin_lock_irqsave(&base->lock, flags);
 	now = base->gettime();
 	while ((next = timerqueue_getnext(&base->timerqueue))) {
@@ -206,6 +228,13 @@ static enum hrtimer_restart alarmtimer_fired(struct hrtimer *timer)
 	}
 	spin_unlock_irqrestore(&base->lock, flags);
 
+	spin_lock_irqsave(&stay_awake_lock, flags);
+	if (stay_awake == 2)
+		__pm_relax(alarmtimer_wakelock);
+	stay_awake = 0;
+	spin_unlock_irqrestore(&stay_awake_lock, flags);
+	__pm_relax(alarmtimer_wakelock);
+
 	return ret;
 
 }
@@ -225,12 +254,14 @@ static int alarmtimer_suspend(struct device *dev)
 {
 	struct rtc_time tm;
 	ktime_t min, now;
+	int min_base; 
 	unsigned long flags;
 	struct rtc_device *rtc;
 	int i;
 
 	spin_lock_irqsave(&freezer_delta_lock, flags);
 	min = freezer_delta;
+	min_base = 0;
 	freezer_delta = ktime_set(0, 0);
 	spin_unlock_irqrestore(&freezer_delta_lock, flags);
 
@@ -251,8 +282,10 @@ static int alarmtimer_suspend(struct device *dev)
 		if (!next)
 			continue;
 		delta = ktime_sub(next->expires, base->gettime());
-		if (!min.tv64 || (delta.tv64 < min.tv64))
+		if (!min.tv64 || (delta.tv64 < min.tv64)) {
 			min = delta;
+			min_base = i;
+		}
 	}
 	if (min.tv64 == 0)
 		return 0;
@@ -266,6 +299,10 @@ static int alarmtimer_suspend(struct device *dev)
 	now = rtc_tm_to_ktime(tm);
 	now = ktime_add(now, min);
 
+	spin_lock_irqsave(&stay_awake_lock, flags);
+	stay_awake=1;
+	spin_unlock_irqrestore(&stay_awake_lock, flags);
+
 	rtc_timer_start(rtc, &rtctimer, now, ktime_set(0, 0));
 
 	return 0;
@@ -703,6 +740,9 @@ static int __init alarmtimer_init(void)
 		.nsleep		= alarm_timer_nsleep,
 	};
 
+	alarmtimer_wakelock = wakeup_source_register("alarmtimer");
+	stay_awake=0;
+
 	posix_timers_register_clock(CLOCK_REALTIME_ALARM, &alarm_clock);
 	posix_timers_register_clock(CLOCK_BOOTTIME_ALARM, &alarm_clock);
 
-- 
1.7.3.2.146.gca209

