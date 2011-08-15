Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab1HOPw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:52:58 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51689 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab1HOPwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:52:55 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [PATCH 04/32] nohz: Separate idle sleeping time accounting from nohz switching
Date: Mon, 15 Aug 2011 17:52:01 +0200
Message-Id: <1313423549-27093-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prepare for having nohz mode switching independant from idle,
pull the idle sleeping time accounting out of the tick stop API.

This implies to implement some new API to call when we
enter/exit idle.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 arch/arm/kernel/process.c              |    4 +-
 arch/avr32/kernel/process.c            |    4 +-
 arch/blackfin/kernel/process.c         |    4 +-
 arch/microblaze/kernel/process.c       |    4 +-
 arch/mips/kernel/process.c             |    4 +-
 arch/powerpc/kernel/idle.c             |    4 +-
 arch/powerpc/platforms/iseries/setup.c |    8 +-
 arch/s390/kernel/process.c             |    4 +-
 arch/sh/kernel/idle.c                  |    4 +-
 arch/sparc/kernel/process_64.c         |    4 +-
 arch/tile/kernel/process.c             |    4 +-
 arch/um/kernel/process.c               |    4 +-
 arch/unicore32/kernel/process.c        |    4 +-
 arch/x86/kernel/process_32.c           |    4 +-
 arch/x86/kernel/process_64.c           |    5 +-
 include/linux/tick.h                   |   10 ++-
 kernel/softirq.c                       |    2 +-
 kernel/time/tick-sched.c               |  102 ++++++++++++++++++-------------
 18 files changed, 98 insertions(+), 81 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 5e1e541..27b68b0 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -182,7 +182,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 		leds_event(led_idle_start);
 		while (!need_resched()) {
 #ifdef CONFIG_HOTPLUG_CPU
@@ -208,7 +208,7 @@ void cpu_idle(void)
 			}
 		}
 		leds_event(led_idle_end);
-		tick_nohz_restart_sched_tick();
+		tick_nohz_exit_idle();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index ef5a2a0..e683a34 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -34,10 +34,10 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 		while (!need_resched())
 			cpu_idle_sleep();
-		tick_nohz_restart_sched_tick();
+		tick_nohz_exit_idle();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 6a660fa..8082a8f 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -88,10 +88,10 @@ void cpu_idle(void)
 #endif
 		if (!idle)
 			idle = default_idle;
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 		while (!need_resched())
 			idle();
-		tick_nohz_restart_sched_tick();
+		tick_nohz_exit_idle();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 968648a..1b295b2 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -103,10 +103,10 @@ void cpu_idle(void)
 		if (!idle)
 			idle = default_idle;
 
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 		while (!need_resched())
 			idle();
-		tick_nohz_restart_sched_tick();
+		tick_nohz_exit_idle();
 
 		preempt_enable_no_resched();
 		schedule();
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index c28fbe6..3aa4020 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -56,7 +56,7 @@ void __noreturn cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 		while (!need_resched() && cpu_online(cpu)) {
 #ifdef CONFIG_MIPS_MT_SMTC
 			extern void smtc_idle_loop_hook(void);
@@ -77,7 +77,7 @@ void __noreturn cpu_idle(void)
 		     system_state == SYSTEM_BOOTING))
 			play_dead();
 #endif
-		tick_nohz_restart_sched_tick();
+		tick_nohz_exit_idle();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 39a2baa..1108260 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -56,7 +56,7 @@ void cpu_idle(void)
 
 	set_thread_flag(TIF_POLLING_NRFLAG);
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 		while (!need_resched() && !cpu_should_die()) {
 			ppc64_runlatch_off();
 
@@ -93,7 +93,7 @@ void cpu_idle(void)
 
 		HMT_medium();
 		ppc64_runlatch_on();
-		tick_nohz_restart_sched_tick();
+		tick_nohz_exit_idle();
 		preempt_enable_no_resched();
 		if (cpu_should_die())
 			cpu_die();
diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
index c25a081..d40dcd9 100644
--- a/arch/powerpc/platforms/iseries/setup.c
+++ b/arch/powerpc/platforms/iseries/setup.c
@@ -562,7 +562,7 @@ static void yield_shared_processor(void)
 static void iseries_shared_idle(void)
 {
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 		while (!need_resched() && !hvlpevent_is_pending()) {
 			local_irq_disable();
 			ppc64_runlatch_off();
@@ -576,7 +576,7 @@ static void iseries_shared_idle(void)
 		}
 
 		ppc64_runlatch_on();
-		tick_nohz_restart_sched_tick();
+		tick_nohz_exit_idle();
 
 		if (hvlpevent_is_pending())
 			process_iSeries_events();
@@ -592,7 +592,7 @@ static void iseries_dedicated_idle(void)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 		if (!need_resched()) {
 			while (!need_resched()) {
 				ppc64_runlatch_off();
@@ -609,7 +609,7 @@ static void iseries_dedicated_idle(void)
 		}
 
 		ppc64_runlatch_on();
-		tick_nohz_restart_sched_tick();
+		tick_nohz_exit_idle();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 541a750..560cd94 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -90,10 +90,10 @@ static void default_idle(void)
 void cpu_idle(void)
 {
 	for (;;) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 		while (!need_resched())
 			default_idle();
-		tick_nohz_restart_sched_tick();
+		tick_nohz_exit_idle();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 425d604..b7ea6ff 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -88,7 +88,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 
 		while (!need_resched()) {
 			check_pgt_cache();
@@ -109,7 +109,7 @@ void cpu_idle(void)
 			start_critical_timings();
 		}
 
-		tick_nohz_restart_sched_tick();
+		tick_nohz_exit_idle();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index c158a95..5c36632 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -95,12 +95,12 @@ void cpu_idle(void)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while(1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 
 		while (!need_resched() && !cpu_is_offline(cpu))
 			sparc64_yield(cpu);
 
-		tick_nohz_restart_sched_tick();
+		tick_nohz_exit_idle();
 
 		preempt_enable_no_resched();
 
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 9c45d8b..cc1bd4f 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -85,7 +85,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 		while (!need_resched()) {
 			if (cpu_is_offline(cpu))
 				BUG();  /* no HOTPLUG_CPU */
@@ -105,7 +105,7 @@ void cpu_idle(void)
 				local_irq_enable();
 			current_thread_info()->status |= TS_POLLING;
 		}
-		tick_nohz_restart_sched_tick();
+		tick_nohz_exit_idle();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index fab4371..f1b3864 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -245,10 +245,10 @@ void default_idle(void)
 		if (need_resched())
 			schedule();
 
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 		nsecs = disable_timer();
 		idle_sleep(nsecs);
-		tick_nohz_restart_sched_tick();
+		tick_nohz_exit_idle();
 	}
 }
 
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index ba401df..e2df91a 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -55,7 +55,7 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 		while (!need_resched()) {
 			local_irq_disable();
 			stop_critical_timings();
@@ -63,7 +63,7 @@ void cpu_idle(void)
 			local_irq_enable();
 			start_critical_timings();
 		}
-		tick_nohz_restart_sched_tick();
+		tick_nohz_exit_idle();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index a3d0dc5..1d7e26c 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -97,7 +97,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 		while (!need_resched()) {
 
 			check_pgt_cache();
@@ -112,7 +112,7 @@ void cpu_idle(void)
 			pm_idle();
 			start_critical_timings();
 		}
-		tick_nohz_restart_sched_tick();
+		tick_nohz_exit_idle();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ca6f7ab..5fce49b 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -120,7 +120,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 		while (!need_resched()) {
 
 			rmb();
@@ -144,8 +144,7 @@ void cpu_idle(void)
 			   loops can be woken up without interrupt. */
 			__exit_idle();
 		}
-
-		tick_nohz_restart_sched_tick();
+		tick_nohz_exit_idle();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 532e650..04f6418 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -120,14 +120,16 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
 # ifdef CONFIG_NO_HZ
-extern void tick_nohz_stop_sched_tick(int inidle);
-extern void tick_nohz_restart_sched_tick(void);
+extern void tick_nohz_enter_idle(void);
+extern void tick_nohz_exit_idle(void);
+extern void tick_nohz_irq_exit(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 # else
-static inline void tick_nohz_stop_sched_tick(int inidle) { }
-static inline void tick_nohz_restart_sched_tick(void) { }
+static inline void tick_nohz_enter_idle(void) { }
+static inline void tick_nohz_exit_idle(void) { }
+
 static inline ktime_t tick_nohz_get_sleep_length(void)
 {
 	ktime_t len = { .tv64 = NSEC_PER_SEC/HZ };
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 40cf63d..67a1401 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -343,7 +343,7 @@ void irq_exit(void)
 #ifdef CONFIG_NO_HZ
 	/* Make sure that timer wheel updates are propagated */
 	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
-		tick_nohz_stop_sched_tick(0);
+		tick_nohz_irq_exit();
 #endif
 	preempt_enable_no_resched();
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 5934aee..df6bb4c 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -249,38 +249,19 @@ EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
  * Called either from the idle loop or from irq_exit() when an idle period was
  * just interrupted by an interrupt which did not cause a reschedule.
  */
-void tick_nohz_stop_sched_tick(int inidle)
+static void tick_nohz_stop_sched_tick(ktime_t now)
 {
-	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
+	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies;
 	struct tick_sched *ts;
-	ktime_t last_update, expires, now;
+	ktime_t last_update, expires;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	u64 time_delta;
 	int cpu;
 
-	local_irq_save(flags);
-
 	cpu = smp_processor_id();
 	ts = &per_cpu(tick_cpu_sched, cpu);
 
 	/*
-	 * Call to tick_nohz_start_idle stops the last_update_time from being
-	 * updated. Thus, it must not be called in the event we are called from
-	 * irq_exit() with the prior state different than idle.
-	 */
-	if (!inidle && !ts->inidle)
-		goto end;
-
-	/*
-	 * Set ts->inidle unconditionally. Even if the system did not
-	 * switch to NOHZ mode the cpu frequency governers rely on the
-	 * update of the idle time accounting in tick_nohz_start_idle().
-	 */
-	ts->inidle = 1;
-
-	now = tick_nohz_start_idle(cpu, ts);
-
-	/*
 	 * If this cpu is offline and it is the one which updates
 	 * jiffies, then give up the assignment and let it be taken by
 	 * the cpu which runs the tick timer next. If we don't drop
@@ -293,10 +274,10 @@ void tick_nohz_stop_sched_tick(int inidle)
 	}
 
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
-		goto end;
+		return;
 
 	if (need_resched())
-		goto end;
+		return;
 
 	if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
 		static int ratelimit;
@@ -306,7 +287,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 			       (unsigned int) local_softirq_pending());
 			ratelimit++;
 		}
-		goto end;
+		return;
 	}
 
 	ts->idle_calls++;
@@ -443,10 +424,31 @@ out:
 	ts->next_jiffies = next_jiffies;
 	ts->last_jiffies = last_jiffies;
 	ts->sleep_length = ktime_sub(dev->next_event, now);
-end:
-	local_irq_restore(flags);
 }
 
+static void __tick_nohz_enter_idle(struct tick_sched *ts, int cpu)
+{
+	ktime_t now;
+
+	now = tick_nohz_start_idle(cpu, ts);
+	tick_nohz_stop_sched_tick(now);
+}
+
+void tick_nohz_enter_idle(void)
+{
+	struct tick_sched *ts;
+	int cpu;
+
+	local_irq_disable();
+
+	ts = &__get_cpu_var(tick_cpu_sched);
+	ts->inidle = 1;
+	cpu = smp_processor_id();
+	__tick_nohz_enter_idle(ts, cpu);
+
+	local_irq_enable();
+ }
+
 /**
  * tick_nohz_get_sleep_length - return the length of the current sleep
  *
@@ -490,27 +492,12 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
  *
  * Restart the idle tick when the CPU is woken up from idle
  */
-void tick_nohz_restart_sched_tick(void)
+static void tick_nohz_restart_sched_tick(ktime_t now, struct tick_sched *ts)
 {
 	int cpu = smp_processor_id();
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	unsigned long ticks;
 #endif
-	ktime_t now;
-
-	local_irq_disable();
-
-	if (ts->inidle) {
-		now = ktime_get();
-		tick_nohz_stop_idle(cpu, now);
-		ts->inidle = 0;
-	}
-
-	if (!ts->tick_stopped) {
-		local_irq_enable();
-		return;
-	}
 
 	rcu_exit_nohz();
 
@@ -541,10 +528,39 @@ void tick_nohz_restart_sched_tick(void)
 	ts->idle_exittime = now;
 
 	tick_nohz_restart(ts, now);
+}
+
+void tick_nohz_exit_idle(void)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	ktime_t now;
+
+	local_irq_disable();
+
+	if (!ts->inidle) {
+		local_irq_enable();
+		return;
+	}
+
+	now = ktime_get();
+
+	tick_nohz_stop_idle(smp_processor_id(), now);
+	ts->inidle = 0;
+
+	if (ts->tick_stopped)
+		tick_nohz_restart_sched_tick(now, ts);
 
 	local_irq_enable();
 }
 
+void tick_nohz_irq_exit(void)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	if (ts->inidle)
+		__tick_nohz_enter_idle(ts, smp_processor_id());
+}
+
 static int tick_nohz_reprogram(struct tick_sched *ts, ktime_t now)
 {
 	hrtimer_forward(&ts->sched_timer, now, tick_period);
-- 
1.7.5.4

