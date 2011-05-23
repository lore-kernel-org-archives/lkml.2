Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab1EWSY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:24:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:56998 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab1EWSYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:24:54 -0400
Date: Mon, 23 May 2011 20:24:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] timers for 2.6.40
Message-ID: <alpine.LFD.2.02.1105232022550.3078@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus

Thanks,

	tglx

------------------>
Andi Kleen (1):
      clockevents: Move C3 stop test outside lock

Thomas Gleixner (10):
      hrtimers: Prepare for cancel on clock was set timers
      timerfd: Allow timers to be cancelled when clock was set
      alarmtimer: Check return value of class_find_device()
      alarmtimer: Drop device refcount after rtc_open()
      clockevents/source: Use u64 to make 32bit happy
      MAINTAINERS: Add drivers/clocksource to TIMEKEEPING
      timerfd: Manage cancelable timers in timerfd
      hrtimers: Make struct hrtimer_cpu_base layout less stupid
      hrtimers: Avoid touching inactive timer bases
      hrtimers: Reorder clock bases


 MAINTAINERS                  |    1 +
 fs/timerfd.c                 |  102 ++++++++++++++++++++++++--
 include/linux/hrtimer.h      |   33 ++++-----
 include/linux/thread_info.h  |    2 +-
 include/linux/timerfd.h      |    3 +-
 kernel/hrtimer.c             |  162 ++++++++++++++++++++++--------------------
 kernel/posix-cpu-timers.c    |    4 +-
 kernel/posix-timers.c        |    2 +-
 kernel/time/alarmtimer.c     |   16 +++-
 kernel/time/clockevents.c    |    2 +-
 kernel/time/clocksource.c    |    2 +-
 kernel/time/tick-broadcast.c |   16 +++--
 kernel/time/timekeeping.c    |   17 ++++-
 13 files changed, 242 insertions(+), 120 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8df8d2d..e20c974 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5431,6 +5431,7 @@ F:	include/linux/timex.h
 F:	kernel/time/clocksource.c
 F:	kernel/time/time*.c
 F:	kernel/time/ntp.c
+F:	drivers/clocksource
 
 TLG2300 VIDEO4LINUX-2 DRIVER
 M:	Huang Shijie <shijie8@gmail.com>
diff --git a/fs/timerfd.c b/fs/timerfd.c
index 8c4fc14..f67acbd 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -22,16 +22,24 @@
 #include <linux/anon_inodes.h>
 #include <linux/timerfd.h>
 #include <linux/syscalls.h>
+#include <linux/rcupdate.h>
 
 struct timerfd_ctx {
 	struct hrtimer tmr;
 	ktime_t tintv;
+	ktime_t moffs;
 	wait_queue_head_t wqh;
 	u64 ticks;
 	int expired;
 	int clockid;
+	struct rcu_head rcu;
+	struct list_head clist;
+	bool might_cancel;
 };
 
+static LIST_HEAD(cancel_list);
+static DEFINE_SPINLOCK(cancel_lock);
+
 /*
  * This gets called when the timer event triggers. We set the "expired"
  * flag, but we do not re-arm the timer (in case it's necessary,
@@ -51,6 +59,63 @@ static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
 	return HRTIMER_NORESTART;
 }
 
+/*
+ * Called when the clock was set to cancel the timers in the cancel
+ * list.
+ */
+void timerfd_clock_was_set(void)
+{
+	ktime_t moffs = ktime_get_monotonic_offset();
+	struct timerfd_ctx *ctx;
+	unsigned long flags;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ctx, &cancel_list, clist) {
+		if (!ctx->might_cancel)
+			continue;
+		spin_lock_irqsave(&ctx->wqh.lock, flags);
+		if (ctx->moffs.tv64 != moffs.tv64) {
+			ctx->moffs.tv64 = KTIME_MAX;
+			wake_up_locked(&ctx->wqh);
+		}
+		spin_unlock_irqrestore(&ctx->wqh.lock, flags);
+	}
+	rcu_read_unlock();
+}
+
+static void timerfd_remove_cancel(struct timerfd_ctx *ctx)
+{
+	if (ctx->might_cancel) {
+		ctx->might_cancel = false;
+		spin_lock(&cancel_lock);
+		list_del_rcu(&ctx->clist);
+		spin_unlock(&cancel_lock);
+	}
+}
+
+static bool timerfd_canceled(struct timerfd_ctx *ctx)
+{
+	if (!ctx->might_cancel || ctx->moffs.tv64 != KTIME_MAX)
+		return false;
+	ctx->moffs = ktime_get_monotonic_offset();
+	return true;
+}
+
+static void timerfd_setup_cancel(struct timerfd_ctx *ctx, int flags)
+{
+	if (ctx->clockid == CLOCK_REALTIME && (flags & TFD_TIMER_ABSTIME) &&
+	    (flags & TFD_TIMER_CANCEL_ON_SET)) {
+		if (!ctx->might_cancel) {
+			ctx->might_cancel = true;
+			spin_lock(&cancel_lock);
+			list_add_rcu(&ctx->clist, &cancel_list);
+			spin_unlock(&cancel_lock);
+		}
+	} else if (ctx->might_cancel) {
+		timerfd_remove_cancel(ctx);
+	}
+}
+
 static ktime_t timerfd_get_remaining(struct timerfd_ctx *ctx)
 {
 	ktime_t remaining;
@@ -59,11 +124,12 @@ static ktime_t timerfd_get_remaining(struct timerfd_ctx *ctx)
 	return remaining.tv64 < 0 ? ktime_set(0, 0): remaining;
 }
 
-static void timerfd_setup(struct timerfd_ctx *ctx, int flags,
-			  const struct itimerspec *ktmr)
+static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
+			 const struct itimerspec *ktmr)
 {
 	enum hrtimer_mode htmode;
 	ktime_t texp;
+	int clockid = ctx->clockid;
 
 	htmode = (flags & TFD_TIMER_ABSTIME) ?
 		HRTIMER_MODE_ABS: HRTIMER_MODE_REL;
@@ -72,19 +138,24 @@ static void timerfd_setup(struct timerfd_ctx *ctx, int flags,
 	ctx->expired = 0;
 	ctx->ticks = 0;
 	ctx->tintv = timespec_to_ktime(ktmr->it_interval);
-	hrtimer_init(&ctx->tmr, ctx->clockid, htmode);
+	hrtimer_init(&ctx->tmr, clockid, htmode);
 	hrtimer_set_expires(&ctx->tmr, texp);
 	ctx->tmr.function = timerfd_tmrproc;
-	if (texp.tv64 != 0)
+	if (texp.tv64 != 0) {
 		hrtimer_start(&ctx->tmr, texp, htmode);
+		if (timerfd_canceled(ctx))
+			return -ECANCELED;
+	}
+	return 0;
 }
 
 static int timerfd_release(struct inode *inode, struct file *file)
 {
 	struct timerfd_ctx *ctx = file->private_data;
 
+	timerfd_remove_cancel(ctx);
 	hrtimer_cancel(&ctx->tmr);
-	kfree(ctx);
+	kfree_rcu(ctx, rcu);
 	return 0;
 }
 
@@ -118,8 +189,21 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 		res = -EAGAIN;
 	else
 		res = wait_event_interruptible_locked_irq(ctx->wqh, ctx->ticks);
+
+	/*
+	 * If clock has changed, we do not care about the
+	 * ticks and we do not rearm the timer. Userspace must
+	 * reevaluate anyway.
+	 */
+	if (timerfd_canceled(ctx)) {
+		ctx->ticks = 0;
+		ctx->expired = 0;
+		res = -ECANCELED;
+	}
+
 	if (ctx->ticks) {
 		ticks = ctx->ticks;
+
 		if (ctx->expired && ctx->tintv.tv64) {
 			/*
 			 * If tintv.tv64 != 0, this is a periodic timer that
@@ -183,6 +267,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 	init_waitqueue_head(&ctx->wqh);
 	ctx->clockid = clockid;
 	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
+	ctx->moffs = ktime_get_monotonic_offset();
 
 	ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx,
 			       O_RDWR | (flags & TFD_SHARED_FCNTL_FLAGS));
@@ -199,6 +284,7 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
 	struct file *file;
 	struct timerfd_ctx *ctx;
 	struct itimerspec ktmr, kotmr;
+	int ret;
 
 	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
 		return -EFAULT;
@@ -213,6 +299,8 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
 		return PTR_ERR(file);
 	ctx = file->private_data;
 
+	timerfd_setup_cancel(ctx, flags);
+
 	/*
 	 * We need to stop the existing timer before reprogramming
 	 * it to the new values.
@@ -240,14 +328,14 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
 	/*
 	 * Re-program the timer to the new value ...
 	 */
-	timerfd_setup(ctx, flags, &ktmr);
+	ret = timerfd_setup(ctx, flags, &ktmr);
 
 	spin_unlock_irq(&ctx->wqh.lock);
 	fput(file);
 	if (otmr && copy_to_user(otmr, &kotmr, sizeof(kotmr)))
 		return -EFAULT;
 
-	return 0;
+	return ret;
 }
 
 SYSCALL_DEFINE2(timerfd_gettime, int, ufd, struct itimerspec __user *, otmr)
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 62f500c..51932e5 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -143,19 +143,18 @@ struct hrtimer_sleeper {
  */
 struct hrtimer_clock_base {
 	struct hrtimer_cpu_base	*cpu_base;
-	clockid_t		index;
+	int			index;
+	clockid_t		clockid;
 	struct timerqueue_head	active;
 	ktime_t			resolution;
 	ktime_t			(*get_time)(void);
 	ktime_t			softirq_time;
-#ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t			offset;
-#endif
 };
 
 enum  hrtimer_base_type {
-	HRTIMER_BASE_REALTIME,
 	HRTIMER_BASE_MONOTONIC,
+	HRTIMER_BASE_REALTIME,
 	HRTIMER_BASE_BOOTTIME,
 	HRTIMER_MAX_CLOCK_BASES,
 };
@@ -164,7 +163,7 @@ enum  hrtimer_base_type {
  * struct hrtimer_cpu_base - the per cpu clock bases
  * @lock:		lock protecting the base and associated clock bases
  *			and timers
- * @clock_base:		array of clock bases for this cpu
+ * @active_bases:	Bitfield to mark bases with active timers
  * @expires_next:	absolute time of the next event which was scheduled
  *			via clock_set_next_event()
  * @hres_active:	State of high resolution mode
@@ -173,10 +172,11 @@ enum  hrtimer_base_type {
  * @nr_retries:		Total number of hrtimer interrupt retries
  * @nr_hangs:		Total number of hrtimer interrupt hangs
  * @max_hang_time:	Maximum time spent in hrtimer_interrupt
+ * @clock_base:		array of clock bases for this cpu
  */
 struct hrtimer_cpu_base {
 	raw_spinlock_t			lock;
-	struct hrtimer_clock_base	clock_base[HRTIMER_MAX_CLOCK_BASES];
+	unsigned long			active_bases;
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t				expires_next;
 	int				hres_active;
@@ -186,6 +186,7 @@ struct hrtimer_cpu_base {
 	unsigned long			nr_hangs;
 	ktime_t				max_hang_time;
 #endif
+	struct hrtimer_clock_base	clock_base[HRTIMER_MAX_CLOCK_BASES];
 };
 
 static inline void hrtimer_set_expires(struct hrtimer *timer, ktime_t time)
@@ -256,8 +257,6 @@ static inline ktime_t hrtimer_expires_remaining(const struct hrtimer *timer)
 #ifdef CONFIG_HIGH_RES_TIMERS
 struct clock_event_device;
 
-extern void clock_was_set(void);
-extern void hres_timers_resume(void);
 extern void hrtimer_interrupt(struct clock_event_device *dev);
 
 /*
@@ -291,16 +290,8 @@ extern void hrtimer_peek_ahead_timers(void);
 # define MONOTONIC_RES_NSEC	LOW_RES_NSEC
 # define KTIME_MONOTONIC_RES	KTIME_LOW_RES
 
-/*
- * clock_was_set() is a NOP for non- high-resolution systems. The
- * time-sorted order guarantees that a timer does not expire early and
- * is expired in the next softirq when the clock was advanced.
- */
-static inline void clock_was_set(void) { }
 static inline void hrtimer_peek_ahead_timers(void) { }
 
-static inline void hres_timers_resume(void) { }
-
 /*
  * In non high resolution mode the time reference is taken from
  * the base softirq time variable.
@@ -316,10 +307,18 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 }
 #endif
 
+extern void clock_was_set(void);
+#ifdef CONFIG_TIMERFD
+extern void timerfd_clock_was_set(void);
+#else
+static inline void timerfd_clock_was_set(void) { }
+#endif
+extern void hrtimers_resume(void);
+
 extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_real(void);
 extern ktime_t ktime_get_boottime(void);
-
+extern ktime_t ktime_get_monotonic_offset(void);
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 20fc303..8d03f07 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -29,7 +29,7 @@ struct restart_block {
 		} futex;
 		/* For nanosleep */
 		struct {
-			clockid_t index;
+			clockid_t clockid;
 			struct timespec __user *rmtp;
 #ifdef CONFIG_COMPAT
 			struct compat_timespec __user *compat_rmtp;
diff --git a/include/linux/timerfd.h b/include/linux/timerfd.h
index 2d07929..d3b57fa 100644
--- a/include/linux/timerfd.h
+++ b/include/linux/timerfd.h
@@ -19,6 +19,7 @@
  * shared O_* flags.
  */
 #define TFD_TIMER_ABSTIME (1 << 0)
+#define TFD_TIMER_CANCEL_ON_SET (1 << 1)
 #define TFD_CLOEXEC O_CLOEXEC
 #define TFD_NONBLOCK O_NONBLOCK
 
@@ -26,6 +27,6 @@
 /* Flags for timerfd_create.  */
 #define TFD_CREATE_FLAGS TFD_SHARED_FCNTL_FLAGS
 /* Flags for timerfd_settime.  */
-#define TFD_SETTIME_FLAGS TFD_TIMER_ABSTIME
+#define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_TIMER_CANCEL_ON_SET)
 
 #endif /* _LINUX_TIMERFD_H */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index dbbbf7d..c541ee5 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -64,17 +64,20 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 	.clock_base =
 	{
 		{
-			.index = CLOCK_REALTIME,
-			.get_time = &ktime_get_real,
+			.index = HRTIMER_BASE_MONOTONIC,
+			.clockid = CLOCK_MONOTONIC,
+			.get_time = &ktime_get,
 			.resolution = KTIME_LOW_RES,
 		},
 		{
-			.index = CLOCK_MONOTONIC,
-			.get_time = &ktime_get,
+			.index = HRTIMER_BASE_REALTIME,
+			.clockid = CLOCK_REALTIME,
+			.get_time = &ktime_get_real,
 			.resolution = KTIME_LOW_RES,
 		},
 		{
-			.index = CLOCK_BOOTTIME,
+			.index = HRTIMER_BASE_BOOTTIME,
+			.clockid = CLOCK_BOOTTIME,
 			.get_time = &ktime_get_boottime,
 			.resolution = KTIME_LOW_RES,
 		},
@@ -196,7 +199,7 @@ switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
 	struct hrtimer_cpu_base *new_cpu_base;
 	int this_cpu = smp_processor_id();
 	int cpu = hrtimer_get_target(this_cpu, pinned);
-	int basenum = hrtimer_clockid_to_base(base->index);
+	int basenum = base->index;
 
 again:
 	new_cpu_base = &per_cpu(hrtimer_bases, cpu);
@@ -621,66 +624,6 @@ static int hrtimer_reprogram(struct hrtimer *timer,
 	return res;
 }
 
-
-/*
- * Retrigger next event is called after clock was set
- *
- * Called with interrupts disabled via on_each_cpu()
- */
-static void retrigger_next_event(void *arg)
-{
-	struct hrtimer_cpu_base *base;
-	struct timespec realtime_offset, wtm, sleep;
-
-	if (!hrtimer_hres_active())
-		return;
-
-	get_xtime_and_monotonic_and_sleep_offset(&realtime_offset, &wtm,
-							&sleep);
-	set_normalized_timespec(&realtime_offset, -wtm.tv_sec, -wtm.tv_nsec);
-
-	base = &__get_cpu_var(hrtimer_bases);
-
-	/* Adjust CLOCK_REALTIME offset */
-	raw_spin_lock(&base->lock);
-	base->clock_base[HRTIMER_BASE_REALTIME].offset =
-		timespec_to_ktime(realtime_offset);
-	base->clock_base[HRTIMER_BASE_BOOTTIME].offset =
-		timespec_to_ktime(sleep);
-
-	hrtimer_force_reprogram(base, 0);
-	raw_spin_unlock(&base->lock);
-}
-
-/*
- * Clock realtime was set
- *
- * Change the offset of the realtime clock vs. the monotonic
- * clock.
- *
- * We might have to reprogram the high resolution timer interrupt. On
- * SMP we call the architecture specific code to retrigger _all_ high
- * resolution timer interrupts. On UP we just disable interrupts and
- * call the high resolution interrupt code.
- */
-void clock_was_set(void)
-{
-	/* Retrigger the CPU local events everywhere */
-	on_each_cpu(retrigger_next_event, NULL, 1);
-}
-
-/*
- * During resume we might have to reprogram the high resolution timer
- * interrupt (on the local CPU):
- */
-void hres_timers_resume(void)
-{
-	WARN_ONCE(!irqs_disabled(),
-		  KERN_INFO "hres_timers_resume() called with IRQs enabled!");
-
-	retrigger_next_event(NULL);
-}
-
 /*
  * Initialize the high resolution related parts of cpu_base
  */
@@ -715,11 +658,39 @@ static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 }
 
 /*
+ * Retrigger next event is called after clock was set
+ *
+ * Called with interrupts disabled via on_each_cpu()
+ */
+static void retrigger_next_event(void *arg)
+{
+	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
+	struct timespec realtime_offset, xtim, wtm, sleep;
+
+	if (!hrtimer_hres_active())
+		return;
+
+	/* Optimized out for !HIGH_RES */
+	get_xtime_and_monotonic_and_sleep_offset(&xtim, &wtm, &sleep);
+	set_normalized_timespec(&realtime_offset, -wtm.tv_sec, -wtm.tv_nsec);
+
+	/* Adjust CLOCK_REALTIME offset */
+	raw_spin_lock(&base->lock);
+	base->clock_base[HRTIMER_BASE_REALTIME].offset =
+		timespec_to_ktime(realtime_offset);
+	base->clock_base[HRTIMER_BASE_BOOTTIME].offset =
+		timespec_to_ktime(sleep);
+
+	hrtimer_force_reprogram(base, 0);
+	raw_spin_unlock(&base->lock);
+}
+
+/*
  * Switch to high resolution mode
  */
 static int hrtimer_switch_to_hres(void)
 {
-	int cpu = smp_processor_id();
+	int i, cpu = smp_processor_id();
 	struct hrtimer_cpu_base *base = &per_cpu(hrtimer_bases, cpu);
 	unsigned long flags;
 
@@ -735,9 +706,8 @@ static int hrtimer_switch_to_hres(void)
 		return 0;
 	}
 	base->hres_active = 1;
-	base->clock_base[HRTIMER_BASE_REALTIME].resolution = KTIME_HIGH_RES;
-	base->clock_base[HRTIMER_BASE_MONOTONIC].resolution = KTIME_HIGH_RES;
-	base->clock_base[HRTIMER_BASE_BOOTTIME].resolution = KTIME_HIGH_RES;
+	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
+		base->clock_base[i].resolution = KTIME_HIGH_RES;
 
 	tick_setup_sched_timer();
 
@@ -761,9 +731,43 @@ static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 	return 0;
 }
 static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base) { }
+static inline void retrigger_next_event(void *arg) { }
 
 #endif /* CONFIG_HIGH_RES_TIMERS */
 
+/*
+ * Clock realtime was set
+ *
+ * Change the offset of the realtime clock vs. the monotonic
+ * clock.
+ *
+ * We might have to reprogram the high resolution timer interrupt. On
+ * SMP we call the architecture specific code to retrigger _all_ high
+ * resolution timer interrupts. On UP we just disable interrupts and
+ * call the high resolution interrupt code.
+ */
+void clock_was_set(void)
+{
+#ifdef CONFIG_HIGHRES_TIMERS
+	/* Retrigger the CPU local events everywhere */
+	on_each_cpu(retrigger_next_event, NULL, 1);
+#endif
+	timerfd_clock_was_set();
+}
+
+/*
+ * During resume we might have to reprogram the high resolution timer
+ * interrupt (on the local CPU):
+ */
+void hrtimers_resume(void)
+{
+	WARN_ONCE(!irqs_disabled(),
+		  KERN_INFO "hrtimers_resume() called with IRQs enabled!");
+
+	retrigger_next_event(NULL);
+	timerfd_clock_was_set();
+}
+
 static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
 {
 #ifdef CONFIG_TIMER_STATS
@@ -856,6 +860,7 @@ static int enqueue_hrtimer(struct hrtimer *timer,
 	debug_activate(timer);
 
 	timerqueue_add(&base->active, &timer->node);
+	base->cpu_base->active_bases |= 1 << base->index;
 
 	/*
 	 * HRTIMER_STATE_ENQUEUED is or'ed to the current state to preserve the
@@ -897,6 +902,8 @@ static void __remove_hrtimer(struct hrtimer *timer,
 #endif
 	}
 	timerqueue_del(&base->active, &timer->node);
+	if (!timerqueue_getnext(&base->active))
+		base->cpu_base->active_bases &= ~(1 << base->index);
 out:
 	timer->state = newstate;
 }
@@ -1234,7 +1241,6 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 void hrtimer_interrupt(struct clock_event_device *dev)
 {
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-	struct hrtimer_clock_base *base;
 	ktime_t expires_next, now, entry_time, delta;
 	int i, retries = 0;
 
@@ -1256,12 +1262,15 @@ retry:
 	 */
 	cpu_base->expires_next.tv64 = KTIME_MAX;
 
-	base = cpu_base->clock_base;
-
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
-		ktime_t basenow;
+		struct hrtimer_clock_base *base;
 		struct timerqueue_node *node;
+		ktime_t basenow;
+
+		if (!(cpu_base->active_bases & (1 << i)))
+			continue;
 
+		base = cpu_base->clock_base + i;
 		basenow = ktime_add(now, base->offset);
 
 		while ((node = timerqueue_getnext(&base->active))) {
@@ -1294,7 +1303,6 @@ retry:
 
 			__run_hrtimer(timer, &basenow);
 		}
-		base++;
 	}
 
 	/*
@@ -1525,7 +1533,7 @@ long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
 	struct timespec __user  *rmtp;
 	int ret = 0;
 
-	hrtimer_init_on_stack(&t.timer, restart->nanosleep.index,
+	hrtimer_init_on_stack(&t.timer, restart->nanosleep.clockid,
 				HRTIMER_MODE_ABS);
 	hrtimer_set_expires_tv64(&t.timer, restart->nanosleep.expires);
 
@@ -1577,7 +1585,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 
 	restart = &current_thread_info()->restart_block;
 	restart->fn = hrtimer_nanosleep_restart;
-	restart->nanosleep.index = t.timer.base->index;
+	restart->nanosleep.clockid = t.timer.base->clockid;
 	restart->nanosleep.rmtp = rmtp;
 	restart->nanosleep.expires = hrtimer_get_expires_tv64(&t.timer);
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 0791b13..58f405b 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1514,7 +1514,7 @@ static int posix_cpu_nsleep(const clockid_t which_clock, int flags,
 			return -EFAULT;
 
 		restart_block->fn = posix_cpu_nsleep_restart;
-		restart_block->nanosleep.index = which_clock;
+		restart_block->nanosleep.clockid = which_clock;
 		restart_block->nanosleep.rmtp = rmtp;
 		restart_block->nanosleep.expires = timespec_to_ns(rqtp);
 	}
@@ -1523,7 +1523,7 @@ static int posix_cpu_nsleep(const clockid_t which_clock, int flags,
 
 static long posix_cpu_nsleep_restart(struct restart_block *restart_block)
 {
-	clockid_t which_clock = restart_block->nanosleep.index;
+	clockid_t which_clock = restart_block->nanosleep.clockid;
 	struct timespec t;
 	struct itimerspec it;
 	int error;
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index e5498d7..a1b5edf 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -1056,7 +1056,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
  */
 long clock_nanosleep_restart(struct restart_block *restart_block)
 {
-	clockid_t which_clock = restart_block->nanosleep.index;
+	clockid_t which_clock = restart_block->nanosleep.clockid;
 	struct k_clock *kc = clockid_to_kclock(which_clock);
 
 	if (WARN_ON_ONCE(!kc || !kc->nsleep_restart))
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 9265014..2d96624 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -494,7 +494,7 @@ static int update_rmtp(ktime_t exp, enum  alarmtimer_type type,
  */
 static long __sched alarm_timer_nsleep_restart(struct restart_block *restart)
 {
-	enum  alarmtimer_type type = restart->nanosleep.index;
+	enum  alarmtimer_type type = restart->nanosleep.clockid;
 	ktime_t exp;
 	struct timespec __user  *rmtp;
 	struct alarm alarm;
@@ -573,7 +573,7 @@ static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
 
 	restart = &current_thread_info()->restart_block;
 	restart->fn = alarm_timer_nsleep_restart;
-	restart->nanosleep.index = type;
+	restart->nanosleep.clockid = type;
 	restart->nanosleep.expires = exp.tv64;
 	restart->nanosleep.rmtp = rmtp;
 	ret = -ERESTART_RESTARTBLOCK;
@@ -669,12 +669,20 @@ static int __init has_wakealarm(struct device *dev, void *name_ptr)
  */
 static int __init alarmtimer_init_late(void)
 {
+	struct device *dev;
 	char *str;
 
 	/* Find an rtc device and init the rtc_timer */
-	class_find_device(rtc_class, NULL, &str, has_wakealarm);
-	if (str)
+	dev = class_find_device(rtc_class, NULL, &str, has_wakealarm);
+	/* If we have a device then str is valid. See has_wakealarm() */
+	if (dev) {
 		rtcdev = rtc_class_open(str);
+		/*
+		 * Drop the reference we got in class_find_device,
+		 * rtc_open takes its own.
+		 */
+		put_device(dev);
+	}
 	if (!rtcdev) {
 		printk(KERN_WARNING "No RTC device found, ALARM timers will"
 			" not wake from suspend");
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 22a9da9..c027d4f 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -197,7 +197,7 @@ EXPORT_SYMBOL_GPL(clockevents_register_device);
 static void clockevents_config(struct clock_event_device *dev,
 			       u32 freq)
 {
-	unsigned long sec;
+	u64 sec;
 
 	if (!(dev->features & CLOCK_EVT_FEAT_ONESHOT))
 		return;
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index d9d5f8c..1c95fd6 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -639,7 +639,7 @@ static void clocksource_enqueue(struct clocksource *cs)
  */
 void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 {
-	unsigned long sec;
+	u64 sec;
 
 	/*
 	 * Calc the maximum number of seconds which we can run before
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 723c763..c7218d1 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -456,23 +456,27 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 	unsigned long flags;
 	int cpu;
 
-	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
-
 	/*
 	 * Periodic mode does not care about the enter/exit of power
 	 * states
 	 */
 	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
-		goto out;
+		return;
 
-	bc = tick_broadcast_device.evtdev;
+	/*
+	 * We are called with preemtion disabled from the depth of the
+	 * idle code, so we can't be moved away.
+	 */
 	cpu = smp_processor_id();
 	td = &per_cpu(tick_cpu_device, cpu);
 	dev = td->evtdev;
 
 	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
-		goto out;
+		return;
+
+	bc = tick_broadcast_device.evtdev;
 
+	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
 		if (!cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
 			cpumask_set_cpu(cpu, tick_get_broadcast_oneshot_mask());
@@ -489,8 +493,6 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 				tick_program_event(dev->next_event, 1);
 		}
 	}
-
-out:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 8e6a05a..342408c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -680,7 +680,7 @@ static void timekeeping_resume(void)
 	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
 
 	/* Resume hrtimers */
-	hres_timers_resume();
+	hrtimers_resume();
 }
 
 static int timekeeping_suspend(void)
@@ -1099,6 +1099,21 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 }
 
 /**
+ * ktime_get_monotonic_offset() - get wall_to_monotonic in ktime_t format
+ */
+ktime_t ktime_get_monotonic_offset(void)
+{
+	unsigned long seq;
+	struct timespec wtom;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		wtom = wall_to_monotonic;
+	} while (read_seqretry(&xtime_lock, seq));
+	return timespec_to_ktime(wtom);
+}
+
+/**
  * xtime_update() - advances the timekeeping infrastructure
  * @ticks:	number of ticks, that have elapsed since the last call.
  *
