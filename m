Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab2GMVJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:09:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:46586 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757825Ab2GMVJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:09:36 -0400
Date: Fri, 13 Jul 2012 23:09:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Prarit Bhargava <prarit@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [GIT pull] leap second fixes for 3.5
Message-ID: <alpine.LFD.2.02.1207132132120.32033@ionos>
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

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

It's a rather large series, but well discussed, refined and
reviewed. It got a massive testing by John, Prarit and tip.

In theory we could split it into two parts. The first two patches

  5baefd6: hrtimer: Update hrtimer base offsets each hrtimer_interrupt
  f6c06ab: timekeeping: Provide hrtimer update function

are merily preventing the stuff loops forever issues, which people
have observed.

But there is no point in delaying the other 4 commits which achieve
full correctness into 3.6 as they are tagged for stable anyway. And I
rather prefer to have the full fixes merged in bulk than a "prevent
the observable wreckage and deal with the hidden fallout later"
approach.

Thanks,

	tglx

------------------>
John Stultz (3):
      hrtimer: Provide clock_was_set_delayed()
      timekeeping: Fix leapsecond triggered load spike issue
      hrtimer: Update hrtimer base offsets each hrtimer_interrupt

Thomas Gleixner (3):
      timekeeping: Maintain ktime_t based offsets for hrtimers
      hrtimers: Move lock held region in hrtimer_interrupt()
      timekeeping: Provide hrtimer update function


 include/linux/hrtimer.h   |   10 ++++++-
 kernel/hrtimer.c          |   53 ++++++++++++++++++++++++++-----------
 kernel/time/timekeeping.c |   63 +++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 107 insertions(+), 19 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index fd0dc30..cc07d27 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -165,6 +165,7 @@ enum  hrtimer_base_type {
  * @lock:		lock protecting the base and associated clock bases
  *			and timers
  * @active_bases:	Bitfield to mark bases with active timers
+ * @clock_was_set:	Indicates that clock was set from irq context.
  * @expires_next:	absolute time of the next event which was scheduled
  *			via clock_set_next_event()
  * @hres_active:	State of high resolution mode
@@ -177,7 +178,8 @@ enum  hrtimer_base_type {
  */
 struct hrtimer_cpu_base {
 	raw_spinlock_t			lock;
-	unsigned long			active_bases;
+	unsigned int			active_bases;
+	unsigned int			clock_was_set;
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t				expires_next;
 	int				hres_active;
@@ -286,6 +288,8 @@ extern void hrtimer_peek_ahead_timers(void);
 # define MONOTONIC_RES_NSEC	HIGH_RES_NSEC
 # define KTIME_MONOTONIC_RES	KTIME_HIGH_RES
 
+extern void clock_was_set_delayed(void);
+
 #else
 
 # define MONOTONIC_RES_NSEC	LOW_RES_NSEC
@@ -306,6 +310,9 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 {
 	return 0;
 }
+
+static inline void clock_was_set_delayed(void) { }
+
 #endif
 
 extern void clock_was_set(void);
@@ -320,6 +327,7 @@ extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_real(void);
 extern ktime_t ktime_get_boottime(void);
 extern ktime_t ktime_get_monotonic_offset(void);
+extern ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot);
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ae34bf5..6db7a5e 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -657,6 +657,14 @@ static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 	return 0;
 }
 
+static inline ktime_t hrtimer_update_base(struct hrtimer_cpu_base *base)
+{
+	ktime_t *offs_real = &base->clock_base[HRTIMER_BASE_REALTIME].offset;
+	ktime_t *offs_boot = &base->clock_base[HRTIMER_BASE_BOOTTIME].offset;
+
+	return ktime_get_update_offsets(offs_real, offs_boot);
+}
+
 /*
  * Retrigger next event is called after clock was set
  *
@@ -665,22 +673,12 @@ static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 static void retrigger_next_event(void *arg)
 {
 	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
-	struct timespec realtime_offset, xtim, wtm, sleep;
 
 	if (!hrtimer_hres_active())
 		return;
 
-	/* Optimized out for !HIGH_RES */
-	get_xtime_and_monotonic_and_sleep_offset(&xtim, &wtm, &sleep);
-	set_normalized_timespec(&realtime_offset, -wtm.tv_sec, -wtm.tv_nsec);
-
-	/* Adjust CLOCK_REALTIME offset */
 	raw_spin_lock(&base->lock);
-	base->clock_base[HRTIMER_BASE_REALTIME].offset =
-		timespec_to_ktime(realtime_offset);
-	base->clock_base[HRTIMER_BASE_BOOTTIME].offset =
-		timespec_to_ktime(sleep);
-
+	hrtimer_update_base(base);
 	hrtimer_force_reprogram(base, 0);
 	raw_spin_unlock(&base->lock);
 }
@@ -710,13 +708,25 @@ static int hrtimer_switch_to_hres(void)
 		base->clock_base[i].resolution = KTIME_HIGH_RES;
 
 	tick_setup_sched_timer();
-
 	/* "Retrigger" the interrupt to get things going */
 	retrigger_next_event(NULL);
 	local_irq_restore(flags);
 	return 1;
 }
 
+/*
+ * Called from timekeeping code to reprogramm the hrtimer interrupt
+ * device. If called from the timer interrupt context we defer it to
+ * softirq context.
+ */
+void clock_was_set_delayed(void)
+{
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+
+	cpu_base->clock_was_set = 1;
+	__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
+}
+
 #else
 
 static inline int hrtimer_hres_active(void) { return 0; }
@@ -1250,11 +1260,10 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	cpu_base->nr_events++;
 	dev->next_event.tv64 = KTIME_MAX;
 
-	entry_time = now = ktime_get();
+	raw_spin_lock(&cpu_base->lock);
+	entry_time = now = hrtimer_update_base(cpu_base);
 retry:
 	expires_next.tv64 = KTIME_MAX;
-
-	raw_spin_lock(&cpu_base->lock);
 	/*
 	 * We set expires_next to KTIME_MAX here with cpu_base->lock
 	 * held to prevent that a timer is enqueued in our queue via
@@ -1330,8 +1339,12 @@ retry:
 	 * We need to prevent that we loop forever in the hrtimer
 	 * interrupt routine. We give it 3 attempts to avoid
 	 * overreacting on some spurious event.
+	 *
+	 * Acquire base lock for updating the offsets and retrieving
+	 * the current time.
 	 */
-	now = ktime_get();
+	raw_spin_lock(&cpu_base->lock);
+	now = hrtimer_update_base(cpu_base);
 	cpu_base->nr_retries++;
 	if (++retries < 3)
 		goto retry;
@@ -1343,6 +1356,7 @@ retry:
 	 */
 	cpu_base->nr_hangs++;
 	cpu_base->hang_detected = 1;
+	raw_spin_unlock(&cpu_base->lock);
 	delta = ktime_sub(now, entry_time);
 	if (delta.tv64 > cpu_base->max_hang_time.tv64)
 		cpu_base->max_hang_time = delta;
@@ -1395,6 +1409,13 @@ void hrtimer_peek_ahead_timers(void)
 
 static void run_hrtimer_softirq(struct softirq_action *h)
 {
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+
+	if (cpu_base->clock_was_set) {
+		cpu_base->clock_was_set = 0;
+		clock_was_set();
+	}
+
 	hrtimer_peek_ahead_timers();
 }
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6f46a00..269b1fe 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -70,6 +70,12 @@ struct timekeeper {
 	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
 	struct timespec raw_time;
 
+	/* Offset clock monotonic -> clock realtime */
+	ktime_t offs_real;
+
+	/* Offset clock monotonic -> clock boottime */
+	ktime_t offs_boot;
+
 	/* Seqlock for all timekeeper values */
 	seqlock_t lock;
 };
@@ -172,6 +178,14 @@ static inline s64 timekeeping_get_ns_raw(void)
 	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 }
 
+static void update_rt_offset(void)
+{
+	struct timespec tmp, *wtm = &timekeeper.wall_to_monotonic;
+
+	set_normalized_timespec(&tmp, -wtm->tv_sec, -wtm->tv_nsec);
+	timekeeper.offs_real = timespec_to_ktime(tmp);
+}
+
 /* must hold write on timekeeper.lock */
 static void timekeeping_update(bool clearntp)
 {
@@ -179,6 +193,7 @@ static void timekeeping_update(bool clearntp)
 		timekeeper.ntp_error = 0;
 		ntp_clear();
 	}
+	update_rt_offset();
 	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
 			 timekeeper.clock, timekeeper.mult);
 }
@@ -604,6 +619,7 @@ void __init timekeeping_init(void)
 	}
 	set_normalized_timespec(&timekeeper.wall_to_monotonic,
 				-boot.tv_sec, -boot.tv_nsec);
+	update_rt_offset();
 	timekeeper.total_sleep_time.tv_sec = 0;
 	timekeeper.total_sleep_time.tv_nsec = 0;
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
@@ -612,6 +628,12 @@ void __init timekeeping_init(void)
 /* time in seconds when suspend began */
 static struct timespec timekeeping_suspend_time;
 
+static void update_sleep_time(struct timespec t)
+{
+	timekeeper.total_sleep_time = t;
+	timekeeper.offs_boot = timespec_to_ktime(t);
+}
+
 /**
  * __timekeeping_inject_sleeptime - Internal function to add sleep interval
  * @delta: pointer to a timespec delta value
@@ -630,8 +652,7 @@ static void __timekeeping_inject_sleeptime(struct timespec *delta)
 	timekeeper.xtime = timespec_add(timekeeper.xtime, *delta);
 	timekeeper.wall_to_monotonic =
 			timespec_sub(timekeeper.wall_to_monotonic, *delta);
-	timekeeper.total_sleep_time = timespec_add(
-					timekeeper.total_sleep_time, *delta);
+	update_sleep_time(timespec_add(timekeeper.total_sleep_time, *delta));
 }
 
 
@@ -963,6 +984,8 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
 		timekeeper.wall_to_monotonic.tv_sec -= leap;
+		if (leap)
+			clock_was_set_delayed();
 	}
 
 	/* Accumulate raw time */
@@ -1079,6 +1102,8 @@ static void update_wall_time(void)
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
 		timekeeper.wall_to_monotonic.tv_sec -= leap;
+		if (leap)
+			clock_was_set_delayed();
 	}
 
 	timekeeping_update(false);
@@ -1246,6 +1271,40 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 	} while (read_seqretry(&timekeeper.lock, seq));
 }
 
+#ifdef CONFIG_HIGH_RES_TIMERS
+/**
+ * ktime_get_update_offsets - hrtimer helper
+ * @offs_real:	pointer to storage for monotonic -> realtime offset
+ * @offs_boot:	pointer to storage for monotonic -> boottime offset
+ *
+ * Returns current monotonic time and updates the offsets
+ * Called from hrtimer_interupt() or retrigger_next_event()
+ */
+ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot)
+{
+	ktime_t now;
+	unsigned int seq;
+	u64 secs, nsecs;
+
+	do {
+		seq = read_seqbegin(&timekeeper.lock);
+
+		secs = timekeeper.xtime.tv_sec;
+		nsecs = timekeeper.xtime.tv_nsec;
+		nsecs += timekeeping_get_ns();
+		/* If arch requires, add in gettimeoffset() */
+		nsecs += arch_gettimeoffset();
+
+		*offs_real = timekeeper.offs_real;
+		*offs_boot = timekeeper.offs_boot;
+	} while (read_seqretry(&timekeeper.lock, seq));
+
+	now = ktime_add_ns(ktime_set(secs, 0), nsecs);
+	now = ktime_sub(now, *offs_real);
+	return now;
+}
+#endif
+
 /**
  * ktime_get_monotonic_offset() - get wall_to_monotonic in ktime_t format
  */
