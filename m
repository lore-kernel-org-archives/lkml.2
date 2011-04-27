Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab1D0Kow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:44:52 -0400
Received: from smtp.nokia.com ([147.243.128.26]:64121 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757879Ab1D0Kou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:44:50 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 2/4] hrtimer: add cancellation when clock is set
Date: Wed, 27 Apr 2011 13:43:41 +0300
Message-Id: <1303901023-11568-2-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303901023-11568-1-git-send-email-virtuoso@slind.org>
References: <alpine.LFD.2.00.1103102040190.2787@localhost6.localdomain6>
 <1303901023-11568-1-git-send-email-virtuoso@slind.org>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a mechanism for hrtimers to be cancelled in
the event of system time changing. This is needed for users who want
to keep track of system time changes.

Users must provide the offset of CLOCK_REALTIME vs CLOCK_MONOTONIC
that they have obtained with clock_rtoffset() call, then, if it
matches the current value of wall_to_monotonic, the timer will be put
on the cancellation list. When the system time is changed, all the
timers on this list will be cancelled.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: John Stultz <johnstul@us.ibm.com>
CC: Chris Friesen <chris.friesen@genband.com>
CC: Kay Sievers <kay.sievers@vrfy.org>
CC: Kirill A. Shutemov <kirill@shutemov.name>
CC: linux-kernel@vger.kernel.org
---
 include/linux/hrtimer.h   |   22 ++++++++++++++
 include/linux/time.h      |    3 ++
 kernel/hrtimer.c          |   68 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/time/ntp.c         |    6 ++++
 kernel/time/timekeeping.c |   27 ++++++++++++++++++
 5 files changed, 126 insertions(+), 0 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 62f500c..a34b8c6 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -46,6 +46,19 @@ enum hrtimer_restart {
 	HRTIMER_RESTART,	/* Timer must be restarted */
 };
 
+/**
+ * struct hrtimer_cancel_block - timer cancellation control structure
+ * @list:	link to the list of timers to be cancelled when a certain
+ *		event is triggered.
+ * @function:	cancellation callback
+ * @cancelled:	flag to indicate that the timer has been cancelled
+ */
+struct hrtimer_cancel_block {
+	struct list_head	list;
+	void			(*function)(struct hrtimer *);
+	unsigned int		cancelled:1;
+};
+
 /*
  * Values to track state of the timer
  *
@@ -96,6 +109,7 @@ enum hrtimer_restart {
  * @function:	timer expiry callback function
  * @base:	pointer to the timer base (per cpu and per clock)
  * @state:	state information (See bit values above)
+ * @cancel:	cancellation-related fields
  * @start_site:	timer statistics field to store the site where the timer
  *		was started
  * @start_comm: timer statistics field to store the name of the process which
@@ -111,6 +125,7 @@ struct hrtimer {
 	enum hrtimer_restart		(*function)(struct hrtimer *);
 	struct hrtimer_clock_base	*base;
 	unsigned long			state;
+	struct hrtimer_cancel_block	cancel;
 #ifdef CONFIG_TIMER_STATS
 	int				start_pid;
 	void				*start_site;
@@ -260,6 +275,8 @@ extern void clock_was_set(void);
 extern void hres_timers_resume(void);
 extern void hrtimer_interrupt(struct clock_event_device *dev);
 
+extern void hrtimer_clock_was_set(void);
+
 /*
  * In high resolution mode the time reference must be read accurate
  */
@@ -301,6 +318,7 @@ static inline void hrtimer_peek_ahead_timers(void) { }
 
 static inline void hres_timers_resume(void) { }
 
+static inline void hrtimer_clock_was_set(void) { }
 /*
  * In non high resolution mode the time reference is taken from
  * the base softirq time variable.
@@ -330,6 +348,10 @@ DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 extern void hrtimer_init(struct hrtimer *timer, clockid_t which_clock,
 			 enum hrtimer_mode mode);
 
+extern int hrtimer_set_cancel_on_clock_set(struct hrtimer *timer,
+					   struct timespec *offset,
+					   void (*function)(struct hrtimer *));
+
 #ifdef CONFIG_DEBUG_OBJECTS_TIMERS
 extern void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t which_clock,
 				  enum hrtimer_mode mode);
diff --git a/include/linux/time.h b/include/linux/time.h
index 454a262..8994853 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -120,6 +120,9 @@ extern int no_sync_cmos_clock __read_mostly;
 void timekeeping_init(void);
 extern int timekeeping_suspended;
 
+int call_if_monotonic_offset_is(struct timespec *offset,
+				void (*function)(void *), void *data);
+
 unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
 struct timespec __current_kernel_time(void); /* does not take xtime_lock */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 9017478..1463164 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -649,6 +649,65 @@ static void retrigger_next_event(void *arg)
 }
 
 /*
+ * Every time wall_to_monotonic changes, we cancel all the sleepers
+ * on this list.
+ */
+static LIST_HEAD(cancellation_list);
+static DEFINE_RAW_SPINLOCK(cancellation_lock);
+
+static void cancel_list_add(void *data)
+{
+	struct hrtimer *timer = data;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&cancellation_lock, flags);
+	list_add(&timer->cancel.list, &cancellation_list);
+	raw_spin_unlock_irqrestore(&cancellation_lock, flags);
+}
+
+/*
+ * Add hrtimer to the list of timers that should be cancelled
+ * on monotonic offset change
+ */
+int hrtimer_set_cancel_on_clock_set(struct hrtimer *timer,
+				    struct timespec *offset,
+				    void (*canceller)(struct hrtimer *))
+{
+	int ret = 0;
+
+	if (call_if_monotonic_offset_is(offset, cancel_list_add, timer))
+		ret = -ECANCELED;
+	else
+		timer->cancel.function = canceller;
+
+	return ret;
+}
+
+/*
+ * Cancel the timers on the cancellation list; call when
+ * wall_to_monotonic has been changed.
+ */
+void hrtimer_clock_was_set(void)
+{
+	struct hrtimer *timer, *iter;
+	unsigned long flags;
+	struct list_head new_head;
+
+	raw_spin_lock_irqsave(&cancellation_lock, flags);
+	list_replace_init(&cancellation_list, &new_head);
+	raw_spin_unlock_irqrestore(&cancellation_lock, flags);
+
+	list_for_each_entry_safe(timer, iter, &new_head, cancel.list) {
+		list_del_init(&timer->cancel.list);
+		hrtimer_cancel(timer);
+		timer->cancel.cancelled = 1;
+
+		BUG_ON(!timer->cancel.function);
+		timer->cancel.function(timer);
+	}
+}
+
+/*
  * Clock realtime was set
  *
  * Change the offset of the realtime clock vs. the monotonic
@@ -876,6 +935,8 @@ static void __remove_hrtimer(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base,
 			     unsigned long newstate, int reprogram)
 {
+	unsigned long flags;
+
 	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
 		goto out;
 
@@ -895,6 +956,11 @@ static void __remove_hrtimer(struct hrtimer *timer,
 	timerqueue_del(&base->active, &timer->node);
 out:
 	timer->state = newstate;
+
+	raw_spin_lock_irqsave(&cancellation_lock, flags);
+	if (!list_empty(&timer->cancel.list))
+		list_del(&timer->cancel.list);
+	raw_spin_unlock_irqrestore(&cancellation_lock, flags);
 }
 
 /*
@@ -1140,6 +1206,8 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 	timer->base = &cpu_base->clock_base[base];
 	timerqueue_init(&timer->node);
 
+	INIT_LIST_HEAD(&timer->cancel.list);
+
 #ifdef CONFIG_TIMER_STATS
 	timer->start_site = NULL;
 	timer->start_pid = -1;
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index f6117a4..0963061 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -357,6 +357,7 @@ void ntp_clear(void)
 static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 {
 	enum hrtimer_restart res = HRTIMER_NORESTART;
+	int wtm_changed = 0;
 
 	write_seqlock(&xtime_lock);
 
@@ -365,6 +366,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 		break;
 	case TIME_INS:
 		timekeeping_leap_insert(-1);
+		wtm_changed++;
 		time_state = TIME_OOP;
 		printk(KERN_NOTICE
 			"Clock: inserting leap second 23:59:60 UTC\n");
@@ -373,6 +375,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 		break;
 	case TIME_DEL:
 		timekeeping_leap_insert(1);
+		wtm_changed++;
 		time_tai--;
 		time_state = TIME_WAIT;
 		printk(KERN_NOTICE
@@ -390,6 +393,9 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 
 	write_sequnlock(&xtime_lock);
 
+	if (wtm_changed)
+		hrtimer_clock_was_set();
+
 	return res;
 }
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 8ad5d57..130c19e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -169,6 +169,24 @@ static struct timespec raw_time;
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
+/*
+ * call a function if offset matches current value of wall_to_monotonic
+ */
+int call_if_monotonic_offset_is(struct timespec *offset,
+				void (*function)(void *), void *data)
+{
+	unsigned long flags;
+	int ret;
+
+	write_seqlock_irqsave(&xtime_lock, flags);
+	ret = timespec_compare(&wall_to_monotonic, offset);
+	if (!ret)
+		function(data);
+	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	return ret;
+}
+
 /* must hold xtime_lock */
 void timekeeping_leap_insert(int leapsecond)
 {
@@ -379,6 +397,8 @@ int do_settimeofday(const struct timespec *tv)
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
+	hrtimer_clock_was_set();
+
 	/* signal hrtimers about time change */
 	clock_was_set();
 
@@ -416,6 +436,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
+	hrtimer_clock_was_set();
+
 	/* signal hrtimers about time change */
 	clock_was_set();
 
@@ -606,6 +628,7 @@ static void timekeeping_resume(void)
 {
 	unsigned long flags;
 	struct timespec ts;
+	int wtm_changed = 0;
 
 	read_persistent_clock(&ts);
 
@@ -617,6 +640,7 @@ static void timekeeping_resume(void)
 		ts = timespec_sub(ts, timekeeping_suspend_time);
 		xtime = timespec_add(xtime, ts);
 		wall_to_monotonic = timespec_sub(wall_to_monotonic, ts);
+		wtm_changed++;
 		total_sleep_time = timespec_add(total_sleep_time, ts);
 	}
 	/* re-base the last cycle value */
@@ -625,6 +649,9 @@ static void timekeeping_resume(void)
 	timekeeping_suspended = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
+	if (wtm_changed)
+		hrtimer_clock_was_set();
+
 	touch_softlockup_watchdog();
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
-- 
1.7.4.1

