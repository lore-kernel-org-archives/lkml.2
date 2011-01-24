Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab1AXNYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 08:24:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45683 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab1AXNYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 08:24:30 -0500
Date: Mon, 24 Jan 2011 14:24:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fixes
Message-ID: <20110124132422.GA791@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
John Stultz (3):
      rtc: Cleanup removed UIE emulation declaration
      RTC: Propagate error handling via rtc_timer_enqueue properly
      RTC: Properly handle rtc_read_alarm error propagation and fix bug

Konrad Rzeszutek Wilk (1):
      acpi_pm: Clear pmtmr_ioport if acpi_pm initialization fails

Stephen Boyd (1):
      hrtimers: Notify hrtimer users of switches to NOHZ mode

Uwe Kleine-König (1):
      RTC: Remove Kconfig symbol for UIE emulation


 drivers/clocksource/acpi_pm.c |    6 +++-
 drivers/rtc/Kconfig           |   12 --------
 drivers/rtc/interface.c       |   61 +++++++++++++++++++++++++----------------
 include/linux/rtc.h           |    4 ---
 kernel/time/tick-sched.c      |    7 +++--
 5 files changed, 46 insertions(+), 44 deletions(-)

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index cfb0f52..effe797 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -202,17 +202,21 @@ static int __init init_acpi_pm_clocksource(void)
 			printk(KERN_INFO "PM-Timer had inconsistent results:"
 			       " 0x%#llx, 0x%#llx - aborting.\n",
 			       value1, value2);
+			pmtmr_ioport = 0;
 			return -EINVAL;
 		}
 		if (i == ACPI_PM_READ_CHECKS) {
 			printk(KERN_INFO "PM-Timer failed consistency check "
 			       " (0x%#llx) - aborting.\n", value1);
+			pmtmr_ioport = 0;
 			return -ENODEV;
 		}
 	}
 
-	if (verify_pmtmr_rate() != 0)
+	if (verify_pmtmr_rate() != 0){
+		pmtmr_ioport = 0;
 		return -ENODEV;
+	}
 
 	return clocksource_register_hz(&clocksource_acpi_pm,
 						PMTMR_TICKS_PER_SEC);
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 4941cad..cdd9719 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -97,18 +97,6 @@ config RTC_INTF_DEV
 
 	  If unsure, say Y.
 
-config RTC_INTF_DEV_UIE_EMUL
-	bool "RTC UIE emulation on dev interface"
-	depends on RTC_INTF_DEV
-	help
-	  Provides an emulation for RTC_UIE if the underlying rtc chip
-	  driver does not expose RTC_UIE ioctls. Those requests generate
-	  once-per-second update interrupts, used for synchronization.
-
-	  The emulation code will read the time from the hardware
-	  clock several times per second, please enable this option
-	  only if you know that you really need it.
-
 config RTC_DRV_TEST
 	tristate "Test driver/device"
 	help
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 90384b9..925006d 100644
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
@@ -120,12 +123,18 @@ int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
 		return err;
-	alarm->enabled = rtc->aie_timer.enabled;
-	if (alarm->enabled)
+	if (rtc->ops == NULL)
+		err = -ENODEV;
+	else if (!rtc->ops->read_alarm)
+		err = -EINVAL;
+	else {
+		memset(alarm, 0, sizeof(struct rtc_wkalrm));
+		alarm->enabled = rtc->aie_timer.enabled;
 		alarm->time = rtc_ktime_to_tm(rtc->aie_timer.node.expires);
+	}
 	mutex_unlock(&rtc->ops_lock);
 
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_read_alarm);
 
@@ -175,16 +184,14 @@ int rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
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
 
@@ -195,15 +202,15 @@ int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled)
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
@@ -235,12 +242,9 @@ int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled)
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
@@ -488,10 +492,13 @@ EXPORT_SYMBOL_GPL(rtc_irq_set_freq);
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
@@ -501,7 +508,13 @@ void rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
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
@@ -512,13 +525,15 @@ void rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
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
@@ -626,8 +641,7 @@ int rtc_timer_start(struct rtc_device *rtc, struct rtc_timer* timer,
 	timer->node.expires = expires;
 	timer->period = period;
 
-	timer->enabled = 1;
-	rtc_timer_enqueue(rtc, timer);
+	ret = rtc_timer_enqueue(rtc, timer);
 
 	mutex_unlock(&rtc->ops_lock);
 	return ret;
@@ -645,7 +659,6 @@ int rtc_timer_cancel(struct rtc_device *rtc, struct rtc_timer* timer)
 	mutex_lock(&rtc->ops_lock);
 	if (timer->enabled)
 		rtc_timer_remove(rtc, timer);
-	timer->enabled = 0;
 	mutex_unlock(&rtc->ops_lock);
 	return ret;
 }
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 3c995b4..a0b639f 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -235,8 +235,6 @@ extern int rtc_irq_set_freq(struct rtc_device *rtc,
 				struct rtc_task *task, int freq);
 extern int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled);
 extern int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled);
-extern int rtc_dev_update_irq_enable_emul(struct rtc_device *rtc,
-						unsigned int enabled);
 
 void rtc_aie_update_irq(void *private);
 void rtc_uie_update_irq(void *private);
@@ -246,8 +244,6 @@ int rtc_register(rtc_task_t *task);
 int rtc_unregister(rtc_task_t *task);
 int rtc_control(rtc_task_t *t, unsigned int cmd, unsigned long arg);
 
-void rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer);
-void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer);
 void rtc_timer_init(struct rtc_timer *timer, void (*f)(void* p), void* data);
 int rtc_timer_start(struct rtc_device *rtc, struct rtc_timer* timer,
 			ktime_t expires, ktime_t period);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3e216e0..c55ea24 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -642,8 +642,7 @@ static void tick_nohz_switch_to_nohz(void)
 	}
 	local_irq_enable();
 
-	printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n",
-	       smp_processor_id());
+	printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n", smp_processor_id());
 }
 
 /*
@@ -795,8 +794,10 @@ void tick_setup_sched_timer(void)
 	}
 
 #ifdef CONFIG_NO_HZ
-	if (tick_nohz_enabled)
+	if (tick_nohz_enabled) {
 		ts->nohz_mode = NOHZ_MODE_HIGHRES;
+		printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n", smp_processor_id());
+	}
 #endif
 }
 #endif /* HIGH_RES_TIMERS */
