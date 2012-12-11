Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab2LKJrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:47:08 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52737 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2LKJrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:47:03 -0500
Date: Tue, 11 Dec 2012 10:46:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: [GIT PULL] timers/core changes for v3.8
Message-ID: <20121211094657.GA24639@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

   HEAD: 9c3f9e281697d02889c3b08922f3b30be75f56c2 Merge branch 'fortglx/3.8/time' of git://git.linaro.org/people/jstultz/linux into timers/core

It contains continued generic-NOHZ work by Frederic and smaller 
cleanups.

 Thanks,

	Ingo

------------------>
Chuansheng Liu (1):
      tick: Correct the comments for tick_sched_timer()

Dan Carpenter (1):
      clocksource: clean up parse_pmtmr()

Frederic Weisbecker (3):
      tick: Consolidate timekeeping handling code
      tick: Consolidate tick handling for high and low res handlers
      tick: Conditionally build nohz specific code in tick handler

John Stultz (1):
      time: Kill xtime_lock, replacing it with jiffies_lock

Lars-Peter Clausen (1):
      time/jiffies: Make clocksource_jiffies static

Linus Walleij (1):
      clocksource: arm_generic: use integer math helpers

Shan Wei (1):
      clocksource: arm_generic: use this_cpu_ptr per-cpu helper


 drivers/clocksource/acpi_pm.c     |  17 +++--
 drivers/clocksource/arm_generic.c |   6 +-
 drivers/clocksource/i8253.c       |   2 +-
 include/linux/jiffies.h           |   3 +-
 kernel/time/jiffies.c             |   8 ++-
 kernel/time/tick-common.c         |   8 +--
 kernel/time/tick-internal.h       |   1 -
 kernel/time/tick-sched.c          | 133 +++++++++++++++++---------------------
 kernel/time/timekeeping.c         |  14 +---
 9 files changed, 85 insertions(+), 107 deletions(-)

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 6b5cf02..5d1b926 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -233,16 +233,15 @@ fs_initcall(init_acpi_pm_clocksource);
  */
 static int __init parse_pmtmr(char *arg)
 {
-	unsigned long base;
+	unsigned int base;
+	int ret;
 
-	if (strict_strtoul(arg, 16, &base))
-		return -EINVAL;
-#ifdef CONFIG_X86_64
-	if (base > UINT_MAX)
-		return -ERANGE;
-#endif
-	printk(KERN_INFO "PMTMR IOPort override: 0x%04x -> 0x%04lx\n",
-	       pmtmr_ioport, base);
+	ret = kstrtouint(arg, 16, &base);
+	if (ret)
+		return ret;
+
+	pr_info("PMTMR IOPort override: 0x%04x -> 0x%04x\n", pmtmr_ioport,
+		base);
 	pmtmr_ioport = base;
 
 	return 1;
diff --git a/drivers/clocksource/arm_generic.c b/drivers/clocksource/arm_generic.c
index c4d9f95..c210f4f 100644
--- a/drivers/clocksource/arm_generic.c
+++ b/drivers/clocksource/arm_generic.c
@@ -127,7 +127,7 @@ static void __init arch_timer_calibrate(void)
 
 	/* Cache the sched_clock multiplier to save a divide in the hot path. */
 
-	sched_clock_mult = NSEC_PER_SEC / arch_timer_rate;
+	sched_clock_mult = DIV_ROUND_CLOSEST(NSEC_PER_SEC, arch_timer_rate);
 
 	pr_info("Architected local timer running at %u.%02uMHz.\n",
 		 arch_timer_rate / 1000000, (arch_timer_rate / 10000) % 100);
@@ -221,10 +221,10 @@ int __init arm_generic_timer_init(void)
 	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
 
 	/* Calibrate the delay loop directly */
-	lpj_fine = arch_timer_rate / HZ;
+	lpj_fine = DIV_ROUND_CLOSEST(arch_timer_rate, HZ);
 
 	/* Immediately configure the timer on the boot CPU */
-	arch_timer_setup(per_cpu_ptr(&arch_timer_evt, smp_processor_id()));
+	arch_timer_setup(this_cpu_ptr(&arch_timer_evt));
 
 	register_cpu_notifier(&arch_timer_cpu_nb);
 
diff --git a/drivers/clocksource/i8253.c b/drivers/clocksource/i8253.c
index e7cab2d..14ee3ef 100644
--- a/drivers/clocksource/i8253.c
+++ b/drivers/clocksource/i8253.c
@@ -35,7 +35,7 @@ static cycle_t i8253_read(struct clocksource *cs)
 
 	raw_spin_lock_irqsave(&i8253_lock, flags);
 	/*
-	 * Although our caller may have the read side of xtime_lock,
+	 * Although our caller may have the read side of jiffies_lock,
 	 * this is now a seqlock, and we are cheating in this routine
 	 * by having side effects on state that we cannot undo if
 	 * there is a collision on the seqlock and our caller has to
diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 6b87413..82ed068 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -70,11 +70,12 @@ extern int register_refined_jiffies(long clock_tick_rate);
 
 /*
  * The 64-bit value is not atomic - you MUST NOT read it
- * without sampling the sequence number in xtime_lock.
+ * without sampling the sequence number in jiffies_lock.
  * get_jiffies_64() will do this for you as appropriate.
  */
 extern u64 __jiffy_data jiffies_64;
 extern unsigned long volatile __jiffy_data jiffies;
+extern seqlock_t jiffies_lock;
 
 #if (BITS_PER_LONG < 64)
 u64 get_jiffies_64(void);
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 6629bf7..7a925ba 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -58,7 +58,7 @@ static cycle_t jiffies_read(struct clocksource *cs)
 	return (cycle_t) jiffies;
 }
 
-struct clocksource clocksource_jiffies = {
+static struct clocksource clocksource_jiffies = {
 	.name		= "jiffies",
 	.rating		= 1, /* lowest valid rating*/
 	.read		= jiffies_read,
@@ -67,6 +67,8 @@ struct clocksource clocksource_jiffies = {
 	.shift		= JIFFIES_SHIFT,
 };
 
+__cacheline_aligned_in_smp DEFINE_SEQLOCK(jiffies_lock);
+
 #if (BITS_PER_LONG < 64)
 u64 get_jiffies_64(void)
 {
@@ -74,9 +76,9 @@ u64 get_jiffies_64(void)
 	u64 ret;
 
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&jiffies_lock);
 		ret = jiffies_64;
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&jiffies_lock, seq));
 	return ret;
 }
 EXPORT_SYMBOL(get_jiffies_64);
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index da6c9ec..b1600a6 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -63,13 +63,13 @@ int tick_is_oneshot_available(void)
 static void tick_periodic(int cpu)
 {
 	if (tick_do_timer_cpu == cpu) {
-		write_seqlock(&xtime_lock);
+		write_seqlock(&jiffies_lock);
 
 		/* Keep track of the next tick event */
 		tick_next_period = ktime_add(tick_next_period, tick_period);
 
 		do_timer(1);
-		write_sequnlock(&xtime_lock);
+		write_sequnlock(&jiffies_lock);
 	}
 
 	update_process_times(user_mode(get_irq_regs()));
@@ -130,9 +130,9 @@ void tick_setup_periodic(struct clock_event_device *dev, int broadcast)
 		ktime_t next;
 
 		do {
-			seq = read_seqbegin(&xtime_lock);
+			seq = read_seqbegin(&jiffies_lock);
 			next = tick_next_period;
-		} while (read_seqretry(&xtime_lock, seq));
+		} while (read_seqretry(&jiffies_lock, seq));
 
 		clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
 
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 4e265b9..cf3e59e 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -141,4 +141,3 @@ static inline int tick_device_is_functional(struct clock_event_device *dev)
 #endif
 
 extern void do_timer(unsigned long ticks);
-extern seqlock_t xtime_lock;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a402608..c96fd6a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -31,7 +31,7 @@
 static DEFINE_PER_CPU(struct tick_sched, tick_cpu_sched);
 
 /*
- * The time, when the last jiffy update happened. Protected by xtime_lock.
+ * The time, when the last jiffy update happened. Protected by jiffies_lock.
  */
 static ktime_t last_jiffies_update;
 
@@ -49,14 +49,14 @@ static void tick_do_update_jiffies64(ktime_t now)
 	ktime_t delta;
 
 	/*
-	 * Do a quick check without holding xtime_lock:
+	 * Do a quick check without holding jiffies_lock:
 	 */
 	delta = ktime_sub(now, last_jiffies_update);
 	if (delta.tv64 < tick_period.tv64)
 		return;
 
-	/* Reevalute with xtime_lock held */
-	write_seqlock(&xtime_lock);
+	/* Reevalute with jiffies_lock held */
+	write_seqlock(&jiffies_lock);
 
 	delta = ktime_sub(now, last_jiffies_update);
 	if (delta.tv64 >= tick_period.tv64) {
@@ -79,7 +79,7 @@ static void tick_do_update_jiffies64(ktime_t now)
 		/* Keep the tick_next_period variable up to date */
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
 	}
-	write_sequnlock(&xtime_lock);
+	write_sequnlock(&jiffies_lock);
 }
 
 /*
@@ -89,15 +89,58 @@ static ktime_t tick_init_jiffy_update(void)
 {
 	ktime_t period;
 
-	write_seqlock(&xtime_lock);
+	write_seqlock(&jiffies_lock);
 	/* Did we start the jiffies update yet ? */
 	if (last_jiffies_update.tv64 == 0)
 		last_jiffies_update = tick_next_period;
 	period = last_jiffies_update;
-	write_sequnlock(&xtime_lock);
+	write_sequnlock(&jiffies_lock);
 	return period;
 }
 
+
+static void tick_sched_do_timer(ktime_t now)
+{
+	int cpu = smp_processor_id();
+
+#ifdef CONFIG_NO_HZ
+	/*
+	 * Check if the do_timer duty was dropped. We don't care about
+	 * concurrency: This happens only when the cpu in charge went
+	 * into a long sleep. If two cpus happen to assign themself to
+	 * this duty, then the jiffies update is still serialized by
+	 * jiffies_lock.
+	 */
+	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
+		tick_do_timer_cpu = cpu;
+#endif
+
+	/* Check, if the jiffies need an update */
+	if (tick_do_timer_cpu == cpu)
+		tick_do_update_jiffies64(now);
+}
+
+static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
+{
+#ifdef CONFIG_NO_HZ
+	/*
+	 * When we are idle and the tick is stopped, we have to touch
+	 * the watchdog as we might not schedule for a really long
+	 * time. This happens on complete idle SMP systems while
+	 * waiting on the login prompt. We also increment the "start of
+	 * idle" jiffy stamp so the idle accounting adjustment we do
+	 * when we go busy again does not account too much ticks.
+	 */
+	if (ts->tick_stopped) {
+		touch_softlockup_watchdog();
+		if (is_idle_task(current))
+			ts->idle_jiffies++;
+	}
+#endif
+	update_process_times(user_mode(regs));
+	profile_tick(CPU_PROFILING);
+}
+
 /*
  * NOHZ - aka dynamic tick functionality
  */
@@ -282,11 +325,11 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 
 	/* Read jiffies and the time when jiffies were updated last */
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = read_seqbegin(&jiffies_lock);
 		last_update = last_jiffies_update;
 		last_jiffies = jiffies;
 		time_delta = timekeeping_max_deferment();
-	} while (read_seqretry(&xtime_lock, seq));
+	} while (read_seqretry(&jiffies_lock, seq));
 
 	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) || printk_needs_cpu(cpu) ||
 	    arch_needs_cpu(cpu)) {
@@ -648,40 +691,12 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	struct pt_regs *regs = get_irq_regs();
-	int cpu = smp_processor_id();
 	ktime_t now = ktime_get();
 
 	dev->next_event.tv64 = KTIME_MAX;
 
-	/*
-	 * Check if the do_timer duty was dropped. We don't care about
-	 * concurrency: This happens only when the cpu in charge went
-	 * into a long sleep. If two cpus happen to assign themself to
-	 * this duty, then the jiffies update is still serialized by
-	 * xtime_lock.
-	 */
-	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
-		tick_do_timer_cpu = cpu;
-
-	/* Check, if the jiffies need an update */
-	if (tick_do_timer_cpu == cpu)
-		tick_do_update_jiffies64(now);
-
-	/*
-	 * When we are idle and the tick is stopped, we have to touch
-	 * the watchdog as we might not schedule for a really long
-	 * time. This happens on complete idle SMP systems while
-	 * waiting on the login prompt. We also increment the "start
-	 * of idle" jiffy stamp so the idle accounting adjustment we
-	 * do when we go busy again does not account too much ticks.
-	 */
-	if (ts->tick_stopped) {
-		touch_softlockup_watchdog();
-		ts->idle_jiffies++;
-	}
-
-	update_process_times(user_mode(regs));
-	profile_tick(CPU_PROFILING);
+	tick_sched_do_timer(now);
+	tick_sched_handle(ts, regs);
 
 	while (tick_nohz_reprogram(ts, now)) {
 		now = ktime_get();
@@ -794,7 +809,7 @@ void tick_check_idle(int cpu)
 #ifdef CONFIG_HIGH_RES_TIMERS
 /*
  * We rearm the timer until we get disabled by the idle code.
- * Called with interrupts disabled and timer->base->cpu_base->lock held.
+ * Called with interrupts disabled.
  */
 static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 {
@@ -802,45 +817,15 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 		container_of(timer, struct tick_sched, sched_timer);
 	struct pt_regs *regs = get_irq_regs();
 	ktime_t now = ktime_get();
-	int cpu = smp_processor_id();
 
-#ifdef CONFIG_NO_HZ
-	/*
-	 * Check if the do_timer duty was dropped. We don't care about
-	 * concurrency: This happens only when the cpu in charge went
-	 * into a long sleep. If two cpus happen to assign themself to
-	 * this duty, then the jiffies update is still serialized by
-	 * xtime_lock.
-	 */
-	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
-		tick_do_timer_cpu = cpu;
-#endif
-
-	/* Check, if the jiffies need an update */
-	if (tick_do_timer_cpu == cpu)
-		tick_do_update_jiffies64(now);
+	tick_sched_do_timer(now);
 
 	/*
 	 * Do not call, when we are not in irq context and have
 	 * no valid regs pointer
 	 */
-	if (regs) {
-		/*
-		 * When we are idle and the tick is stopped, we have to touch
-		 * the watchdog as we might not schedule for a really long
-		 * time. This happens on complete idle SMP systems while
-		 * waiting on the login prompt. We also increment the "start of
-		 * idle" jiffy stamp so the idle accounting adjustment we do
-		 * when we go busy again does not account too much ticks.
-		 */
-		if (ts->tick_stopped) {
-			touch_softlockup_watchdog();
-			if (is_idle_task(current))
-				ts->idle_jiffies++;
-		}
-		update_process_times(user_mode(regs));
-		profile_tick(CPU_PROFILING);
-	}
+	if (regs)
+		tick_sched_handle(ts, regs);
 
 	hrtimer_forward(timer, now, tick_period);
 
@@ -874,7 +859,7 @@ void tick_setup_sched_timer(void)
 	/* Get the next period (per cpu) */
 	hrtimer_set_expires(&ts->sched_timer, tick_init_jiffy_update());
 
-	/* Offset the tick to avert xtime_lock contention. */
+	/* Offset the tick to avert jiffies_lock contention. */
 	if (sched_skew_tick) {
 		u64 offset = ktime_to_ns(tick_period) >> 1;
 		do_div(offset, num_possible_cpus());
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e424970..4c7de02 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -25,12 +25,6 @@
 
 static struct timekeeper timekeeper;
 
-/*
- * This read-write spinlock protects us from races in SMP while
- * playing with xtime.
- */
-__cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
-
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
@@ -1299,9 +1293,7 @@ struct timespec get_monotonic_coarse(void)
 }
 
 /*
- * The 64-bit jiffies value is not atomic - you MUST NOT read it
- * without sampling the sequence number in xtime_lock.
- * jiffies is defined in the linker script...
+ * Must hold jiffies_lock
  */
 void do_timer(unsigned long ticks)
 {
@@ -1389,7 +1381,7 @@ EXPORT_SYMBOL_GPL(ktime_get_monotonic_offset);
  */
 void xtime_update(unsigned long ticks)
 {
-	write_seqlock(&xtime_lock);
+	write_seqlock(&jiffies_lock);
 	do_timer(ticks);
-	write_sequnlock(&xtime_lock);
+	write_sequnlock(&jiffies_lock);
 }
