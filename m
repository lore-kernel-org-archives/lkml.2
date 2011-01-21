Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab1AUQk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:40:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:50503 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab1AUQk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:40:56 -0500
Date: Fri, 21 Jan 2011 16:40:39 GMT
From: tip-bot for John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        john.stultz@linaro.org, geert@linux-m68k.org,
        ddaney@caviumnetworks.com, tglx@linutronix.de, schwab@linux-m68k.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, geert@linux-m68k.org,
        ddaney@caviumnetworks.com, tglx@linutronix.de, schwab@linux-m68k.org
In-Reply-To: <1295565973-14358-1-git-send-email-john.stultz@linaro.org>
References: <1295565973-14358-1-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] RTC: Propagate error handling via rtc_timer_enqueue properly
Message-ID: <tip-aa0be0f4659f91f31e45adc422b1788cb36ffddc@git.kernel.org>
Git-Commit-ID: aa0be0f4659f91f31e45adc422b1788cb36ffddc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 Jan 2011 16:40:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa0be0f4659f91f31e45adc422b1788cb36ffddc
Gitweb:     http://git.kernel.org/tip/aa0be0f4659f91f31e45adc422b1788cb36ffddc
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Thu, 20 Jan 2011 15:26:12 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Jan 2011 17:38:19 +0100

RTC: Propagate error handling via rtc_timer_enqueue properly

In cases where RTC hardware does not support alarms, the virtualized
RTC interfaces did not have a way to propagate the error up to userland.

This patch extends rtc_timer_enqueue so it catches errors from the hardware
and returns them upwards to the virtualized interfaces. To simplify error
handling, it also internalizes the management of the timer->enabled bit
into rtc_timer_enqueue and rtc_timer_remove.

Also makes rtc_timer_enqueue and rtc_timer_remove static.

Reported-by: David Daney <ddaney@caviumnetworks.com>
Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Diagnosed-by: David Daney <ddaney@caviumnetworks.com>
Tested-by: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
LKML-Reference: <1295565973-14358-1-git-send-email-john.stultz@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/rtc/interface.c |   49 ++++++++++++++++++++++++++--------------------
 include/linux/rtc.h     |    2 -
 2 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 90384b9..f1ba2c6 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -16,6 +16,9 @@
 #include <linux/log2.h>
 #include <linux/workqueue.h>
 
+static int rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer);
+static void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer);
+
 static int __rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm)
 {
 	int err;
@@ -175,16 +178,14 @@ int rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 		return err;
 	if (rtc->aie_timer.enabled) {
 		rtc_timer_remove(rtc, &rtc->aie_timer);
-		rtc->aie_timer.enabled = 0;
 	}
 	rtc->aie_timer.node.expires = rtc_tm_to_ktime(alarm->time);
 	rtc->aie_timer.period = ktime_set(0, 0);
 	if (alarm->enabled) {
-		rtc->aie_timer.enabled = 1;
-		rtc_timer_enqueue(rtc, &rtc->aie_timer);
+		err = rtc_timer_enqueue(rtc, &rtc->aie_timer);
 	}
 	mutex_unlock(&rtc->ops_lock);
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_set_alarm);
 
@@ -195,15 +196,15 @@ int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 		return err;
 
 	if (rtc->aie_timer.enabled != enabled) {
-		if (enabled) {
-			rtc->aie_timer.enabled = 1;
-			rtc_timer_enqueue(rtc, &rtc->aie_timer);
-		} else {
+		if (enabled)
+			err = rtc_timer_enqueue(rtc, &rtc->aie_timer);
+		else
 			rtc_timer_remove(rtc, &rtc->aie_timer);
-			rtc->aie_timer.enabled = 0;
-		}
 	}
 
+	if (err)
+		return err;
+
 	if (!rtc->ops)
 		err = -ENODEV;
 	else if (!rtc->ops->alarm_irq_enable)
@@ -235,12 +236,9 @@ int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 		now = rtc_tm_to_ktime(tm);
 		rtc->uie_rtctimer.node.expires = ktime_add(now, onesec);
 		rtc->uie_rtctimer.period = ktime_set(1, 0);
-		rtc->uie_rtctimer.enabled = 1;
-		rtc_timer_enqueue(rtc, &rtc->uie_rtctimer);
-	} else {
+		err = rtc_timer_enqueue(rtc, &rtc->uie_rtctimer);
+	} else
 		rtc_timer_remove(rtc, &rtc->uie_rtctimer);
-		rtc->uie_rtctimer.enabled = 0;
-	}
 
 out:
 	mutex_unlock(&rtc->ops_lock);
@@ -488,10 +486,13 @@ EXPORT_SYMBOL_GPL(rtc_irq_set_freq);
  * Enqueues a timer onto the rtc devices timerqueue and sets
  * the next alarm event appropriately.
  *
+ * Sets the enabled bit on the added timer.
+ *
  * Must hold ops_lock for proper serialization of timerqueue
  */
-void rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
+static int rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
 {
+	timer->enabled = 1;
 	timerqueue_add(&rtc->timerqueue, &timer->node);
 	if (&timer->node == timerqueue_getnext(&rtc->timerqueue)) {
 		struct rtc_wkalrm alarm;
@@ -501,7 +502,13 @@ void rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
 		err = __rtc_set_alarm(rtc, &alarm);
 		if (err == -ETIME)
 			schedule_work(&rtc->irqwork);
+		else if (err) {
+			timerqueue_del(&rtc->timerqueue, &timer->node);
+			timer->enabled = 0;
+			return err;
+		}
 	}
+	return 0;
 }
 
 /**
@@ -512,13 +519,15 @@ void rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
  * Removes a timer onto the rtc devices timerqueue and sets
  * the next alarm event appropriately.
  *
+ * Clears the enabled bit on the removed timer.
+ *
  * Must hold ops_lock for proper serialization of timerqueue
  */
-void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer)
+static void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer)
 {
 	struct timerqueue_node *next = timerqueue_getnext(&rtc->timerqueue);
 	timerqueue_del(&rtc->timerqueue, &timer->node);
-
+	timer->enabled = 0;
 	if (next == &timer->node) {
 		struct rtc_wkalrm alarm;
 		int err;
@@ -626,8 +635,7 @@ int rtc_timer_start(struct rtc_device *rtc, struct rtc_timer* timer,
 	timer->node.expires = expires;
 	timer->period = period;
 
-	timer->enabled = 1;
-	rtc_timer_enqueue(rtc, timer);
+	ret = rtc_timer_enqueue(rtc, timer);
 
 	mutex_unlock(&rtc->ops_lock);
 	return ret;
@@ -645,7 +653,6 @@ int rtc_timer_cancel(struct rtc_device *rtc, struct rtc_timer* timer)
 	mutex_lock(&rtc->ops_lock);
 	if (timer->enabled)
 		rtc_timer_remove(rtc, timer);
-	timer->enabled = 0;
 	mutex_unlock(&rtc->ops_lock);
 	return ret;
 }
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index ea76069..a0b639f 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -244,8 +244,6 @@ int rtc_register(rtc_task_t *task);
 int rtc_unregister(rtc_task_t *task);
 int rtc_control(rtc_task_t *t, unsigned int cmd, unsigned long arg);
 
-void rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer);
-void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer);
 void rtc_timer_init(struct rtc_timer *timer, void (*f)(void* p), void* data);
 int rtc_timer_start(struct rtc_device *rtc, struct rtc_timer* timer,
 			ktime_t expires, ktime_t period);
