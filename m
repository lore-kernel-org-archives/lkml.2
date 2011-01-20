Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab1ATWXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 17:23:34 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:54406 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1ATWXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:23:33 -0500
Subject: Re: RTC seems broken on 2.6.38-rc1 for RTCs lacking alarms.
From: John Stultz <john.stultz@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Daney <ddaney@caviumnetworks.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <AANLkTinJfQCEcqHy8oc8+F+yrmY_AkhPLCdZ7R95tk6H@mail.gmail.com>
References: <4D38A051.2010301@caviumnetworks.com>
	 <1295558196.2998.85.camel@work-vm>
	 <AANLkTinJfQCEcqHy8oc8+F+yrmY_AkhPLCdZ7R95tk6H@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 14:23:23 -0800
Message-ID: <1295562203.2998.105.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 22:24 +0100, Geert Uytterhoeven wrote:
> On Thu, Jan 20, 2011 at 22:16, John Stultz <john.stultz@linaro.org> wrote:
> > On Thu, 2011-01-20 at 12:51 -0800, David Daney wrote:
> >> open("/dev/rtc0", O_RDONLY|O_LARGEFILE) = 3
> >> ioctl(3, PRESTO_GETMOUNT or RTC_UIE_ON, 0) = 0
> >> _newselect(4, [3], NULL, NULL, {5, 0})  = 0 (Timeout)
> >> write(2, "select() to /dev/rtc0 to wait for"..., 55select() to /dev/rtc0
> >> to wait for clock tick timed out
> >> ) = 55
> >> ioctl(3, PRESTO_SETPID or RTC_UIE_OFF, 0) = 0
> >> close(3)                                = 0
> >> exit_group(1)                           = ?
> >>
> >>
> >> The hwclock program is asking to put the clock in UIE mode and then
> >> does a select() on it.  Since the alarm doesn't work, the select times out.
> >>
> >> Previously the ioctl(RTC_UIE_ON) would return EINVAL:
> >
> > Ah. Good diagnosis! Let me try to get a patch for you and Andreas to
> > test.
> 
> I'm also seeing this on m68k (ARAnyM, rtc-generic).

Geert, David, Andreas,
	Could you try the following? Its a bit messy of a patch doing a couple
of things:

1) Simplify the timer->enabled management by pushing it into
rtc_timer_enqueue/remove (needed cleanup for #2).

2) Properly propagating errors from __rtc_set_alarm back through
rtc_timer_enqueue and users.

3) Trivial clenaup making rtc_timer_enqueue/remove static.

4) Fixup virtualized rtc_read_alarm to check hardware capabilities and
return errors (also restores zeroing of the rtc_wkalrm stucture).

I'll be cleaning these up and breaking them into commits I can send
upward, but I wanted to make sure it resolves the issue for you.

Let me know if it fixes things.

thanks
-john

NOT FOR INCLUSION! NOT FOR INCLUSION! NOT FOR INCLUSION!
Signed-off-by: John Stultz <john.stultz@linaro.org>

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 90384b9..db816cd 100644
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
@@ -120,12 +123,20 @@ int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
 		return err;
-	alarm->enabled = rtc->aie_timer.enabled;
-	if (alarm->enabled)
-		alarm->time = rtc_ktime_to_tm(rtc->aie_timer.node.expires);
+	if (rtc->ops == NULL)
+		err = -ENODEV;
+	else if (!rtc->ops->read_alarm)
+		err = -EINVAL;
+	else {
+		memset(alarm, 0, sizeof(struct rtc_wkalrm));
+		alarm->enabled = rtc->aie_timer.enabled;
+		if (alarm->enabled)
+			alarm->time =
+				rtc_ktime_to_tm(rtc->aie_timer.node.expires);
+	}
 	mutex_unlock(&rtc->ops_lock);
 
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_read_alarm);
 
@@ -175,16 +186,14 @@ int rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
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
 
@@ -195,15 +204,15 @@ int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled)
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
@@ -235,12 +244,9 @@ int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled)
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
@@ -488,10 +494,13 @@ EXPORT_SYMBOL_GPL(rtc_irq_set_freq);
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
@@ -501,7 +510,13 @@ void rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
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
@@ -512,13 +527,15 @@ void rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
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
@@ -626,8 +643,7 @@ int rtc_timer_start(struct rtc_device *rtc, struct rtc_timer* timer,
 	timer->node.expires = expires;
 	timer->period = period;
 
-	timer->enabled = 1;
-	rtc_timer_enqueue(rtc, timer);
+	ret = rtc_timer_enqueue(rtc, timer);
 
 	mutex_unlock(&rtc->ops_lock);
 	return ret;
@@ -645,7 +661,6 @@ int rtc_timer_cancel(struct rtc_device *rtc, struct rtc_timer* timer)
 	mutex_lock(&rtc->ops_lock);
 	if (timer->enabled)
 		rtc_timer_remove(rtc, timer);
-	timer->enabled = 0;
 	mutex_unlock(&rtc->ops_lock);
 	return ret;
 }
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 3c995b4..bd4fbc3 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -246,8 +246,6 @@ int rtc_register(rtc_task_t *task);
 int rtc_unregister(rtc_task_t *task);
 int rtc_control(rtc_task_t *t, unsigned int cmd, unsigned long arg);
 
-void rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer);
-void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer);
 void rtc_timer_init(struct rtc_timer *timer, void (*f)(void* p), void* data);
 int rtc_timer_start(struct rtc_device *rtc, struct rtc_timer* timer,
 			ktime_t expires, ktime_t period);


