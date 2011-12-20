Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab1LTT1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:27:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44674 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab1LTT1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:27:32 -0500
Date: Tue, 20 Dec 2011 20:25:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fixes
Message-ID: <20111220192543.GA16145@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

 Thanks,

	Ingo

------------------>
John Stultz (1):
      rtc: m41t80: Workaround broken alarm functionality

Kusanagi Kouichi (1):
      time/clocksource: Fix kernel-doc warnings

NeilBrown (1):
      rtc: Expire alarms after the time is set.


 drivers/rtc/interface.c     |    6 ++++++
 drivers/rtc/rtc-m41t80.c    |    9 +++++++++
 include/linux/clocksource.h |   11 ++++++++---
 kernel/time/clocksource.c   |   12 +++++++++---
 4 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index fa4d9f3..3bcc7cf 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -73,6 +73,8 @@ int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm)
 		err = -EINVAL;
 
 	mutex_unlock(&rtc->ops_lock);
+	/* A timer might have just expired */
+	schedule_work(&rtc->irqwork);
 	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_set_time);
@@ -112,6 +114,8 @@ int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs)
 		err = -EINVAL;
 
 	mutex_unlock(&rtc->ops_lock);
+	/* A timer might have just expired */
+	schedule_work(&rtc->irqwork);
 
 	return err;
 }
@@ -403,6 +407,8 @@ int rtc_initialize_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 		timerqueue_add(&rtc->timerqueue, &rtc->aie_timer.node);
 	}
 	mutex_unlock(&rtc->ops_lock);
+	/* maybe that was in the past.*/
+	schedule_work(&rtc->irqwork);
 	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_initialize_alarm);
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index eda128f..64aedd8 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -357,10 +357,19 @@ static int m41t80_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 static struct rtc_class_ops m41t80_rtc_ops = {
 	.read_time = m41t80_rtc_read_time,
 	.set_time = m41t80_rtc_set_time,
+	/*
+	 * XXX - m41t80 alarm functionality is reported broken.
+	 * until it is fixed, don't register alarm functions.
+	 *
 	.read_alarm = m41t80_rtc_read_alarm,
 	.set_alarm = m41t80_rtc_set_alarm,
+	*/
 	.proc = m41t80_rtc_proc,
+	/*
+	 * See above comment on broken alarm
+	 *
 	.alarm_irq_enable = m41t80_rtc_alarm_irq_enable,
+	*/
 };
 
 #if defined(CONFIG_RTC_INTF_SYSFS) || defined(CONFIG_RTC_INTF_SYSFS_MODULE)
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index c86c940..081147d 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -71,7 +71,7 @@ struct timecounter {
 
 /**
  * cyclecounter_cyc2ns - converts cycle counter cycles to nanoseconds
- * @tc:		Pointer to cycle counter.
+ * @cc:		Pointer to cycle counter.
  * @cycles:	Cycles
  *
  * XXX - This could use some mult_lxl_ll() asm optimization. Same code
@@ -114,7 +114,7 @@ extern u64 timecounter_read(struct timecounter *tc);
  *                        time base as values returned by
  *                        timecounter_read()
  * @tc:		Pointer to time counter.
- * @cycle:	a value returned by tc->cc->read()
+ * @cycle_tstamp:	a value returned by tc->cc->read()
  *
  * Cycle counts that are converted correctly as long as they
  * fall into the interval [-1/2 max cycle count, +1/2 max cycle count],
@@ -156,11 +156,12 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
  * @mult:		cycle to nanosecond multiplier
  * @shift:		cycle to nanosecond divisor (power of two)
  * @max_idle_ns:	max idle time permitted by the clocksource (nsecs)
- * @maxadj		maximum adjustment value to mult (~11%)
+ * @maxadj:		maximum adjustment value to mult (~11%)
  * @flags:		flags describing special properties
  * @archdata:		arch-specific data
  * @suspend:		suspend function for the clocksource, if necessary
  * @resume:		resume function for the clocksource, if necessary
+ * @cycle_last:		most recent cycle counter value seen by ::read()
  */
 struct clocksource {
 	/*
@@ -187,6 +188,7 @@ struct clocksource {
 	void (*suspend)(struct clocksource *cs);
 	void (*resume)(struct clocksource *cs);
 
+	/* private: */
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 	/* Watchdog related data, used by the framework */
 	struct list_head wd_list;
@@ -261,6 +263,9 @@ static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
 
 /**
  * clocksource_cyc2ns - converts clocksource cycles to nanoseconds
+ * @cycles:	cycles
+ * @mult:	cycle to nanosecond multiplier
+ * @shift:	cycle to nanosecond divisor (power of two)
  *
  * Converts cycles to nanoseconds, using the given mult and shift.
  *
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index da2f760..d3ad022 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -647,7 +647,7 @@ static void clocksource_enqueue(struct clocksource *cs)
 
 /**
  * __clocksource_updatefreq_scale - Used update clocksource with new freq
- * @t:		clocksource to be registered
+ * @cs:		clocksource to be registered
  * @scale:	Scale factor multiplied against freq to get clocksource hz
  * @freq:	clocksource frequency (cycles per second) divided by scale
  *
@@ -699,7 +699,7 @@ EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
 
 /**
  * __clocksource_register_scale - Used to install new clocksources
- * @t:		clocksource to be registered
+ * @cs:		clocksource to be registered
  * @scale:	Scale factor multiplied against freq to get clocksource hz
  * @freq:	clocksource frequency (cycles per second) divided by scale
  *
@@ -727,7 +727,7 @@ EXPORT_SYMBOL_GPL(__clocksource_register_scale);
 
 /**
  * clocksource_register - Used to install new clocksources
- * @t:		clocksource to be registered
+ * @cs:		clocksource to be registered
  *
  * Returns -EBUSY if registration fails, zero otherwise.
  */
@@ -761,6 +761,8 @@ static void __clocksource_change_rating(struct clocksource *cs, int rating)
 
 /**
  * clocksource_change_rating - Change the rating of a registered clocksource
+ * @cs:		clocksource to be changed
+ * @rating:	new rating
  */
 void clocksource_change_rating(struct clocksource *cs, int rating)
 {
@@ -772,6 +774,7 @@ EXPORT_SYMBOL(clocksource_change_rating);
 
 /**
  * clocksource_unregister - remove a registered clocksource
+ * @cs:	clocksource to be unregistered
  */
 void clocksource_unregister(struct clocksource *cs)
 {
@@ -787,6 +790,7 @@ EXPORT_SYMBOL(clocksource_unregister);
 /**
  * sysfs_show_current_clocksources - sysfs interface for current clocksource
  * @dev:	unused
+ * @attr:	unused
  * @buf:	char buffer to be filled with clocksource list
  *
  * Provides sysfs interface for listing current clocksource.
@@ -807,6 +811,7 @@ sysfs_show_current_clocksources(struct sys_device *dev,
 /**
  * sysfs_override_clocksource - interface for manually overriding clocksource
  * @dev:	unused
+ * @attr:	unused
  * @buf:	name of override clocksource
  * @count:	length of buffer
  *
@@ -842,6 +847,7 @@ static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 /**
  * sysfs_show_available_clocksources - sysfs interface for listing clocksource
  * @dev:	unused
+ * @attr:	unused
  * @buf:	char buffer to be filled with clocksource list
  *
  * Provides sysfs interface for listing registered clocksources
