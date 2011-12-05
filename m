Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1LETCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:02:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37861 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284Ab1LETCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:02:22 -0500
Date: Mon, 5 Dec 2011 20:00:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fixes
Message-ID: <20111205190039.GA29271@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

 Thanks,

	Ingo

------------------>
Arve Hjønnevåg (1):
      rtc: Fix some bugs that allowed accumulating time drift in suspend/resume

Rabin Vincent (1):
      rtc: Disable the alarm in the hardware

Thomas Gleixner (2):
      tick-broadcast: Stop active broadcast device when replacing it
      clockevents: Set noop handler in clockevents_exchange_device()

Yang Honggang (Joseph) (1):
      clocksource: Fix bug with max_deferment margin calculation


 drivers/rtc/class.c          |   10 ++++----
 drivers/rtc/interface.c      |   44 ++++++++++++++++++++++++++++++++---------
 kernel/time/clockevents.c    |    1 +
 kernel/time/clocksource.c    |    4 +-
 kernel/time/tick-broadcast.c |    2 +-
 5 files changed, 43 insertions(+), 18 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 01a7df5..b82a155 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -66,7 +66,7 @@ static int rtc_suspend(struct device *dev, pm_message_t mesg)
 	 */
 	delta = timespec_sub(old_system, old_rtc);
 	delta_delta = timespec_sub(delta, old_delta);
-	if (abs(delta_delta.tv_sec)  >= 2) {
+	if (delta_delta.tv_sec < -2 || delta_delta.tv_sec >= 2) {
 		/*
 		 * if delta_delta is too large, assume time correction
 		 * has occured and set old_delta to the current delta.
@@ -100,9 +100,8 @@ static int rtc_resume(struct device *dev)
 	rtc_tm_to_time(&tm, &new_rtc.tv_sec);
 	new_rtc.tv_nsec = 0;
 
-	if (new_rtc.tv_sec <= old_rtc.tv_sec) {
-		if (new_rtc.tv_sec < old_rtc.tv_sec)
-			pr_debug("%s:  time travel!\n", dev_name(&rtc->dev));
+	if (new_rtc.tv_sec < old_rtc.tv_sec) {
+		pr_debug("%s:  time travel!\n", dev_name(&rtc->dev));
 		return 0;
 	}
 
@@ -119,7 +118,8 @@ static int rtc_resume(struct device *dev)
 	sleep_time = timespec_sub(sleep_time,
 			timespec_sub(new_system, old_system));
 
-	timekeeping_inject_sleeptime(&sleep_time);
+	if (sleep_time.tv_sec >= 0)
+		timekeeping_inject_sleeptime(&sleep_time);
 	return 0;
 }
 
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 3195dbd..e3cf2f5 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -318,6 +318,20 @@ int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
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
@@ -341,14 +355,7 @@ static int __rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
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
@@ -762,6 +769,20 @@ static int rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
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
@@ -783,8 +804,10 @@ static void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer)
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
@@ -846,7 +869,8 @@ again:
 		err = __rtc_set_alarm(rtc, &alarm);
 		if (err == -ETIME)
 			goto again;
-	}
+	} else
+		rtc_alarm_disable(rtc);
 
 	mutex_unlock(&rtc->ops_lock);
 }
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 1ecd6ba..c4eb71c 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -387,6 +387,7 @@ void clockevents_exchange_device(struct clock_event_device *old,
 	 * released list and do a notify add later.
 	 */
 	if (old) {
+		old->event_handler = clockevents_handle_noop;
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
 		list_del(&old->list);
 		list_add(&old->list, &clockevents_released);
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index cfc65e1..da2f760 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -548,7 +548,7 @@ static u64 clocksource_max_deferment(struct clocksource *cs)
 	 * note a margin of 12.5% is used because this can be computed with
 	 * a shift, versus say 10% which would require division.
 	 */
-	return max_nsecs - (max_nsecs >> 5);
+	return max_nsecs - (max_nsecs >> 3);
 }
 
 #ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
@@ -669,7 +669,7 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 	 * ~ 0.06ppm granularity for NTP. We apply the same 12.5%
 	 * margin as we do in clocksource_max_deferment()
 	 */
-	sec = (cs->mask - (cs->mask >> 5));
+	sec = (cs->mask - (cs->mask >> 3));
 	do_div(sec, freq);
 	do_div(sec, scale);
 	if (!sec)
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f954282..fd4a7b1 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -71,7 +71,7 @@ int tick_check_broadcast_device(struct clock_event_device *dev)
 	     (dev->features & CLOCK_EVT_FEAT_C3STOP))
 		return 0;
 
-	clockevents_exchange_device(NULL, dev);
+	clockevents_exchange_device(tick_broadcast_device.evtdev, dev);
 	tick_broadcast_device.evtdev = dev;
 	if (!cpumask_empty(tick_get_broadcast_mask()))
 		tick_broadcast_start_periodic(dev);
