Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab2HIHhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 03:37:40 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:44717 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab2HIHhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 03:37:37 -0400
From: Todd Poynor <toddpoynor@google.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, arve@android.com,
        Todd Poynor <toddpoynor@google.com>
Subject: [PATCH] alarmtimer: implement minimum alarm interval for allowing suspend
Date: Thu,  9 Aug 2012 00:37:27 -0700
Message-Id: <1344497847-7161-1-git-send-email-toddpoynor@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alarmtimer suspend return -EBUSY if the next alarm will fire in less
than 2 seconds.  This allows one RTC seconds tick to occur subsequent
to this check before the alarm wakeup time is set, ensuring the wakeup
time is still in the future (assuming the RTC does not tick one more
second prior to setting the alarm).

If suspend is rejected due to an imminent alarm, hold a wakeup source
for 2 seconds to process the alarm prior to reattempting suspend.

If setting the alarm incurs an -ETIME for an alarm set in the past,
or any other problem setting the alarm, abort suspend and hold a
wakelock for 1 second while the alarm is allowed to be serviced or
other hopefully transient conditions preventing the alarm clear up.

Signed-off-by: Todd Poynor <toddpoynor@google.com>
---
 kernel/time/alarmtimer.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index aa27d39..f979d85 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -46,6 +46,8 @@ static struct alarm_base {
 static ktime_t freezer_delta;
 static DEFINE_SPINLOCK(freezer_delta_lock);
 
+static struct wakeup_source *ws;
+
 #ifdef CONFIG_RTC_CLASS
 /* rtc timer and device for setting alarm wakeups at suspend */
 static struct rtc_timer		rtctimer;
@@ -250,6 +252,7 @@ static int alarmtimer_suspend(struct device *dev)
 	unsigned long flags;
 	struct rtc_device *rtc;
 	int i;
+	int ret;
 
 	spin_lock_irqsave(&freezer_delta_lock, flags);
 	min = freezer_delta;
@@ -279,8 +282,10 @@ static int alarmtimer_suspend(struct device *dev)
 	if (min.tv64 == 0)
 		return 0;
 
-	/* XXX - Should we enforce a minimum sleep time? */
-	WARN_ON(min.tv64 < NSEC_PER_SEC);
+	if (ktime_to_ns(min) < 2 * NSEC_PER_SEC) {
+		__pm_wakeup_event(ws, 2 * MSEC_PER_SEC);
+		return -EBUSY;
+	}
 
 	/* Setup an rtc timer to fire that far in the future */
 	rtc_timer_cancel(rtc, &rtctimer);
@@ -288,9 +293,11 @@ static int alarmtimer_suspend(struct device *dev)
 	now = rtc_tm_to_ktime(tm);
 	now = ktime_add(now, min);
 
-	rtc_timer_start(rtc, &rtctimer, now, ktime_set(0, 0));
-
-	return 0;
+	/* Set alarm, if in the past reject suspend briefly to handle */
+	ret = rtc_timer_start(rtc, &rtctimer, now, ktime_set(0, 0));
+	if (ret < 0)
+		__pm_wakeup_event(ws, 1 * MSEC_PER_SEC);
+	return ret;
 }
 #else
 static int alarmtimer_suspend(struct device *dev)
@@ -821,6 +828,7 @@ static int __init alarmtimer_init(void)
 		error = PTR_ERR(pdev);
 		goto out_drv;
 	}
+	ws = wakeup_source_register("alarmtimer");
 	return 0;
 
 out_drv:
-- 
1.7.7.3

