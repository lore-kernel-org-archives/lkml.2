Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1AFCR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 21:17:27 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:53099 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab1AFCQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:16:14 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 08/12] rtc: Namespace fixup
Date: Wed,  5 Jan 2011 18:15:55 -0800
Message-Id: <1294280159-2513-9-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1294280159-2513-1-git-send-email-john.stultz@linaro.org>
References: <1294280159-2513-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

rtctimer_* is already occupied by sound/core/rtctimer.c. Instead of
fiddling with that, rename the new functions to rtc_timer_* which
reads nicer anyway.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <johnstul@us.ibm.com>
---
 drivers/rtc/class.c     |    6 +++---
 drivers/rtc/interface.c |   42 +++++++++++++++++++++---------------------
 include/linux/rtc.h     |   12 ++++++------
 3 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 8347c4b..9583cbc 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -155,11 +155,11 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 
 	/* Init timerqueue */
 	timerqueue_init_head(&rtc->timerqueue);
-	INIT_WORK(&rtc->irqwork, rtctimer_do_work);
+	INIT_WORK(&rtc->irqwork, rtc_timer_do_work);
 	/* Init aie timer */
-	rtctimer_init(&rtc->aie_timer, rtc_aie_update_irq, (void *)rtc);
+	rtc_timer_init(&rtc->aie_timer, rtc_aie_update_irq, (void *)rtc);
 	/* Init uie timer */
-	rtctimer_init(&rtc->uie_rtctimer, rtc_uie_update_irq, (void *)rtc);
+	rtc_timer_init(&rtc->uie_rtctimer, rtc_uie_update_irq, (void *)rtc);
 	/* Init pie timer */
 	hrtimer_init(&rtc->pie_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	rtc->pie_timer.function = rtc_pie_update_irq;
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index c81c50b..90384b9 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -174,14 +174,14 @@ int rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	if (err)
 		return err;
 	if (rtc->aie_timer.enabled) {
-		rtctimer_remove(rtc, &rtc->aie_timer);
+		rtc_timer_remove(rtc, &rtc->aie_timer);
 		rtc->aie_timer.enabled = 0;
 	}
 	rtc->aie_timer.node.expires = rtc_tm_to_ktime(alarm->time);
 	rtc->aie_timer.period = ktime_set(0, 0);
 	if (alarm->enabled) {
 		rtc->aie_timer.enabled = 1;
-		rtctimer_enqueue(rtc, &rtc->aie_timer);
+		rtc_timer_enqueue(rtc, &rtc->aie_timer);
 	}
 	mutex_unlock(&rtc->ops_lock);
 	return 0;
@@ -197,9 +197,9 @@ int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 	if (rtc->aie_timer.enabled != enabled) {
 		if (enabled) {
 			rtc->aie_timer.enabled = 1;
-			rtctimer_enqueue(rtc, &rtc->aie_timer);
+			rtc_timer_enqueue(rtc, &rtc->aie_timer);
 		} else {
-			rtctimer_remove(rtc, &rtc->aie_timer);
+			rtc_timer_remove(rtc, &rtc->aie_timer);
 			rtc->aie_timer.enabled = 0;
 		}
 	}
@@ -236,9 +236,9 @@ int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 		rtc->uie_rtctimer.node.expires = ktime_add(now, onesec);
 		rtc->uie_rtctimer.period = ktime_set(1, 0);
 		rtc->uie_rtctimer.enabled = 1;
-		rtctimer_enqueue(rtc, &rtc->uie_rtctimer);
+		rtc_timer_enqueue(rtc, &rtc->uie_rtctimer);
 	} else {
-		rtctimer_remove(rtc, &rtc->uie_rtctimer);
+		rtc_timer_remove(rtc, &rtc->uie_rtctimer);
 		rtc->uie_rtctimer.enabled = 0;
 	}
 
@@ -481,7 +481,7 @@ int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
 EXPORT_SYMBOL_GPL(rtc_irq_set_freq);
 
 /**
- * rtctimer_enqueue - Adds a rtc_timer to the rtc_device timerqueue
+ * rtc_timer_enqueue - Adds a rtc_timer to the rtc_device timerqueue
  * @rtc rtc device
  * @timer timer being added.
  *
@@ -490,7 +490,7 @@ EXPORT_SYMBOL_GPL(rtc_irq_set_freq);
  *
  * Must hold ops_lock for proper serialization of timerqueue
  */
-void rtctimer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
+void rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
 {
 	timerqueue_add(&rtc->timerqueue, &timer->node);
 	if (&timer->node == timerqueue_getnext(&rtc->timerqueue)) {
@@ -505,7 +505,7 @@ void rtctimer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
 }
 
 /**
- * rtctimer_remove - Removes a rtc_timer from the rtc_device timerqueue
+ * rtc_timer_remove - Removes a rtc_timer from the rtc_device timerqueue
  * @rtc rtc device
  * @timer timer being removed.
  *
@@ -514,7 +514,7 @@ void rtctimer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
  *
  * Must hold ops_lock for proper serialization of timerqueue
  */
-void rtctimer_remove(struct rtc_device *rtc, struct rtc_timer *timer)
+void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer)
 {
 	struct timerqueue_node *next = timerqueue_getnext(&rtc->timerqueue);
 	timerqueue_del(&rtc->timerqueue, &timer->node);
@@ -534,7 +534,7 @@ void rtctimer_remove(struct rtc_device *rtc, struct rtc_timer *timer)
 }
 
 /**
- * rtctimer_do_work - Expires rtc timers
+ * rtc_timer_do_work - Expires rtc timers
  * @rtc rtc device
  * @timer timer being removed.
  *
@@ -543,7 +543,7 @@ void rtctimer_remove(struct rtc_device *rtc, struct rtc_timer *timer)
  *
  * Serializes access to timerqueue via ops_lock mutex
  */
-void rtctimer_do_work(struct work_struct *work)
+void rtc_timer_do_work(struct work_struct *work)
 {
 	struct rtc_timer *timer;
 	struct timerqueue_node *next;
@@ -592,14 +592,14 @@ again:
 }
 
 
-/* rtctimer_init - Initializes an rtc_timer
+/* rtc_timer_init - Initializes an rtc_timer
  * @timer: timer to be intiialized
  * @f: function pointer to be called when timer fires
  * @data: private data passed to function pointer
  *
  * Kernel interface to initializing an rtc_timer.
  */
-void rtctimer_init(struct rtc_timer *timer, void (*f)(void* p), void* data)
+void rtc_timer_init(struct rtc_timer *timer, void (*f)(void* p), void* data)
 {
 	timerqueue_init(&timer->node);
 	timer->enabled = 0;
@@ -607,7 +607,7 @@ void rtctimer_init(struct rtc_timer *timer, void (*f)(void* p), void* data)
 	timer->task.private_data = data;
 }
 
-/* rtctimer_start - Sets an rtc_timer to fire in the future
+/* rtc_timer_start - Sets an rtc_timer to fire in the future
  * @ rtc: rtc device to be used
  * @ timer: timer being set
  * @ expires: time at which to expire the timer
@@ -615,36 +615,36 @@ void rtctimer_init(struct rtc_timer *timer, void (*f)(void* p), void* data)
  *
  * Kernel interface to set an rtc_timer
  */
-int rtctimer_start(struct rtc_device *rtc, struct rtc_timer* timer,
+int rtc_timer_start(struct rtc_device *rtc, struct rtc_timer* timer,
 			ktime_t expires, ktime_t period)
 {
 	int ret = 0;
 	mutex_lock(&rtc->ops_lock);
 	if (timer->enabled)
-		rtctimer_remove(rtc, timer);
+		rtc_timer_remove(rtc, timer);
 
 	timer->node.expires = expires;
 	timer->period = period;
 
 	timer->enabled = 1;
-	rtctimer_enqueue(rtc, timer);
+	rtc_timer_enqueue(rtc, timer);
 
 	mutex_unlock(&rtc->ops_lock);
 	return ret;
 }
 
-/* rtctimer_cancel - Stops an rtc_timer
+/* rtc_timer_cancel - Stops an rtc_timer
  * @ rtc: rtc device to be used
  * @ timer: timer being set
  *
  * Kernel interface to cancel an rtc_timer
  */
-int rtctimer_cancel(struct rtc_device *rtc, struct rtc_timer* timer)
+int rtc_timer_cancel(struct rtc_device *rtc, struct rtc_timer* timer)
 {
 	int ret = 0;
 	mutex_lock(&rtc->ops_lock);
 	if (timer->enabled)
-		rtctimer_remove(rtc, timer);
+		rtc_timer_remove(rtc, timer);
 	timer->enabled = 0;
 	mutex_unlock(&rtc->ops_lock);
 	return ret;
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 44e18a2..3c995b4 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -246,13 +246,13 @@ int rtc_register(rtc_task_t *task);
 int rtc_unregister(rtc_task_t *task);
 int rtc_control(rtc_task_t *t, unsigned int cmd, unsigned long arg);
 
-void rtctimer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer);
-void rtctimer_remove(struct rtc_device *rtc, struct rtc_timer *timer);
-void rtctimer_init(struct rtc_timer *timer, void (*f)(void* p), void* data);
-int rtctimer_start(struct rtc_device *rtc, struct rtc_timer* timer,
+void rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer);
+void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer);
+void rtc_timer_init(struct rtc_timer *timer, void (*f)(void* p), void* data);
+int rtc_timer_start(struct rtc_device *rtc, struct rtc_timer* timer,
 			ktime_t expires, ktime_t period);
-int rtctimer_cancel(struct rtc_device *rtc, struct rtc_timer* timer);
-void rtctimer_do_work(struct work_struct *work);
+int rtc_timer_cancel(struct rtc_device *rtc, struct rtc_timer* timer);
+void rtc_timer_do_work(struct work_struct *work);
 
 static inline bool is_leap_year(unsigned int year)
 {
-- 
1.7.3.2.146.gca209

