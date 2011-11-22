Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab1KVKDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:03:38 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:50860 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830Ab1KVKDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:03:36 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        John Stultz <john.stultz@linaro.org>, <linux-kernel@vger.kernel.org>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>, <stable@kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] rtc: disable the alarm in the hardware
Date: Tue, 22 Nov 2011 11:03:14 +0100
Message-ID: <1321956194-8382-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Currently, the RTC code does not disable the alarm in the hardware.

This means that after a sequence such as the one below (the files are in the
RTC sysfs), the box will boot up after 2 minutes even though we've
asked for the alarm to be turned off.

	# echo $((`cat since_epoch`)+120) > wakealarm
	# echo 0 > wakealarm
	# poweroff

Fix this by disabling the alarm when there are no timers to run.

Cc: stable@kernel.org
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
---
 drivers/rtc/interface.c |   44 ++++++++++++++++++++++++++++++++++----------
 1 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 8e28625..fa4d9f3 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -319,6 +319,20 @@ int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 }
 EXPORT_SYMBOL_GPL(rtc_read_alarm);
 
+static int ___rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
+{
+	int err;
+
+	if (!rtc->ops)
+		err = -ENODEV;
+	else if (!rtc->ops->set_alarm)
+		err = -EINVAL;
+	else
+		err = rtc->ops->set_alarm(rtc->dev.parent, alarm);
+
+	return err;
+}
+
 static int __rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 {
 	struct rtc_time tm;
@@ -342,14 +356,7 @@ static int __rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	 * over right here, before we set the alarm.
 	 */
 
-	if (!rtc->ops)
-		err = -ENODEV;
-	else if (!rtc->ops->set_alarm)
-		err = -EINVAL;
-	else
-		err = rtc->ops->set_alarm(rtc->dev.parent, alarm);
-
-	return err;
+	return ___rtc_set_alarm(rtc, alarm);
 }
 
 int rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
@@ -763,6 +770,20 @@ static int rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
 	return 0;
 }
 
+static void rtc_alarm_disable(struct rtc_device *rtc)
+{
+	struct rtc_wkalrm alarm;
+	struct rtc_time tm;
+
+	__rtc_read_time(rtc, &tm);
+
+	alarm.time = rtc_ktime_to_tm(ktime_add(rtc_tm_to_ktime(tm),
+				     ktime_set(300, 0)));
+	alarm.enabled = 0;
+
+	___rtc_set_alarm(rtc, &alarm);
+}
+
 /**
  * rtc_timer_remove - Removes a rtc_timer from the rtc_device timerqueue
  * @rtc rtc device
@@ -784,8 +805,10 @@ static void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer)
 		struct rtc_wkalrm alarm;
 		int err;
 		next = timerqueue_getnext(&rtc->timerqueue);
-		if (!next)
+		if (!next) {
+			rtc_alarm_disable(rtc);
 			return;
+		}
 		alarm.time = rtc_ktime_to_tm(next->expires);
 		alarm.enabled = 1;
 		err = __rtc_set_alarm(rtc, &alarm);
@@ -847,7 +870,8 @@ again:
 		err = __rtc_set_alarm(rtc, &alarm);
 		if (err == -ETIME)
 			goto again;
-	}
+	} else
+		rtc_alarm_disable(rtc);
 
 	mutex_unlock(&rtc->ops_lock);
 }
-- 
1.7.3.2

