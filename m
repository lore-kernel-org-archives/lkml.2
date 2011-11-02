Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1KBUcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:32:07 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51525 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab1KBUcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:32:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH RFC tip/core/rcu 18/28] nohz: Separate out irq exit and idle loop dyntick logic
Date: Wed,  2 Nov 2011 13:30:39 -0700
Message-Id: <1320265849-5744-18-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-1976-0000-0000-000000ABADB7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

The tick_nohz_stop_sched_tick() function, which tries to delay
the next timer tick as long as possible, can be called from two
places:

- From the idle loop to start the dytick idle mode
- From interrupt exit if we have interrupted the dyntick
idle mode, so that we reprogram the next tick event in
case the irq changed some internal state that requires this
action.

There are only few minor differences between both that
are handled by that function, driven by the ts->inidle
cpu variable and the inidle parameter. The whole guarantees
that we only update the dyntick mode on irq exit if we actually
interrupted the dyntick idle mode, and that we enter in RCU extended
quiescent state from idle loop entry only.

Split this function into:

- tick_nohz_idle_enter(), which sets ts->inidle to 1, enters
dynticks idle mode unconditionally if it can, and enters into RCU
extended quiescent state.

- tick_nohz_irq_exit() which only updates the dynticks idle mode
when ts->inidle is set (ie: if tick_nohz_idle_enter() has been called).

To maintain symmetry, tick_nohz_restart_sched_tick() has been renamed
into tick_nohz_idle_exit().

This simplifies the code and micro-optimize the irq exit path (no need
for local_irq_save there). This also prepares for the split between
dynticks and rcu extended quiescent state logics. We'll need this split to
further fix illegal uses of RCU in extended quiescent states in the idle
loop.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: David Miller <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/arm/kernel/process.c              |    4 +-
 arch/avr32/kernel/process.c            |    4 +-
 arch/blackfin/kernel/process.c         |    4 +-
 arch/microblaze/kernel/process.c       |    4 +-
 arch/mips/kernel/process.c             |    4 +-
 arch/openrisc/kernel/idle.c            |    4 +-
 arch/powerpc/kernel/idle.c             |    4 +-
 arch/powerpc/platforms/iseries/setup.c |    8 ++--
 arch/s390/kernel/process.c             |    4 +-
 arch/sh/kernel/idle.c                  |    4 +-
 arch/sparc/kernel/process_64.c         |    4 +-
 arch/tile/kernel/process.c             |    4 +-
 arch/um/kernel/process.c               |    4 +-
 arch/unicore32/kernel/process.c        |    4 +-
 arch/x86/kernel/process_32.c           |    4 +-
 arch/x86/kernel/process_64.c           |    4 +-
 include/linux/tick.h                   |   13 +++--
 kernel/softirq.c                       |    2 +-
 kernel/time/tick-sched.c               |   93 +++++++++++++++++++------------
 19 files changed, 99 insertions(+), 77 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 1a347f4..f9261d0 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -183,7 +183,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 		leds_event(led_idle_start);
 		while (!need_resched()) {
 #ifdef CONFIG_HOTPLUG_CPU
@@ -210,7 +210,7 @@ void cpu_idle(void)
 			}
 		}
 		leds_event(led_idle_end);
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index ef5a2a0..6ee7952 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -34,10 +34,10 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 		while (!need_resched())
 			cpu_idle_sleep();
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 6a80a9e..7b141b5 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -88,10 +88,10 @@ void cpu_idle(void)
 #endif
 		if (!idle)
 			idle = default_idle;
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 		while (!need_resched())
 			idle();
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index dbb8124..6dc123e 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -103,10 +103,10 @@ void cpu_idle(void)
 		if (!idle)
 			idle = default_idle;
 
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 		while (!need_resched())
 			idle();
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 
 		preempt_enable_no_resched();
 		schedule();
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index b30cb25..d50a005 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -56,7 +56,7 @@ void __noreturn cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 		while (!need_resched() && cpu_online(cpu)) {
 #ifdef CONFIG_MIPS_MT_SMTC
 			extern void smtc_idle_loop_hook(void);
@@ -77,7 +77,7 @@ void __noreturn cpu_idle(void)
 		     system_state == SYSTEM_BOOTING))
 			play_dead();
 #endif
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/openrisc/kernel/idle.c b/arch/openrisc/kernel/idle.c
index d5bc5f8..fb6a9bf 100644
--- a/arch/openrisc/kernel/idle.c
+++ b/arch/openrisc/kernel/idle.c
@@ -51,7 +51,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 
 		while (!need_resched()) {
 			check_pgt_cache();
@@ -69,7 +69,7 @@ void cpu_idle(void)
 			set_thread_flag(TIF_POLLING_NRFLAG);
 		}
 
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 39a2baa..878572f 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -56,7 +56,7 @@ void cpu_idle(void)
 
 	set_thread_flag(TIF_POLLING_NRFLAG);
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 		while (!need_resched() && !cpu_should_die()) {
 			ppc64_runlatch_off();
 
@@ -93,7 +93,7 @@ void cpu_idle(void)
 
 		HMT_medium();
 		ppc64_runlatch_on();
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		if (cpu_should_die())
 			cpu_die();
diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
index c25a081..e2f5fad 100644
--- a/arch/powerpc/platforms/iseries/setup.c
+++ b/arch/powerpc/platforms/iseries/setup.c
@@ -562,7 +562,7 @@ static void yield_shared_processor(void)
 static void iseries_shared_idle(void)
 {
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 		while (!need_resched() && !hvlpevent_is_pending()) {
 			local_irq_disable();
 			ppc64_runlatch_off();
@@ -576,7 +576,7 @@ static void iseries_shared_idle(void)
 		}
 
 		ppc64_runlatch_on();
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 
 		if (hvlpevent_is_pending())
 			process_iSeries_events();
@@ -592,7 +592,7 @@ static void iseries_dedicated_idle(void)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 		if (!need_resched()) {
 			while (!need_resched()) {
 				ppc64_runlatch_off();
@@ -609,7 +609,7 @@ static void iseries_dedicated_idle(void)
 		}
 
 		ppc64_runlatch_on();
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 541a750..db3e930 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -90,10 +90,10 @@ static void default_idle(void)
 void cpu_idle(void)
 {
 	for (;;) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 		while (!need_resched())
 			default_idle();
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index db4ecd7..6015743 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -89,7 +89,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 
 		while (!need_resched()) {
 			check_pgt_cache();
@@ -111,7 +111,7 @@ void cpu_idle(void)
 			start_critical_timings();
 		}
 
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index c158a95..1235f63 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -95,12 +95,12 @@ void cpu_idle(void)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while(1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 
 		while (!need_resched() && !cpu_is_offline(cpu))
 			sparc64_yield(cpu);
 
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 
 		preempt_enable_no_resched();
 
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 9c45d8b..920e674 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -85,7 +85,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 		while (!need_resched()) {
 			if (cpu_is_offline(cpu))
 				BUG();  /* no HOTPLUG_CPU */
@@ -105,7 +105,7 @@ void cpu_idle(void)
 				local_irq_enable();
 			current_thread_info()->status |= TS_POLLING;
 		}
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 21c1ae7..41acf59 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -245,10 +245,10 @@ void default_idle(void)
 		if (need_resched())
 			schedule();
 
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 		nsecs = disable_timer();
 		idle_sleep(nsecs);
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 	}
 }
 
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index ba401df..9999b9a 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -55,7 +55,7 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 		while (!need_resched()) {
 			local_irq_disable();
 			stop_critical_timings();
@@ -63,7 +63,7 @@ void cpu_idle(void)
 			local_irq_enable();
 			start_critical_timings();
 		}
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7a3b651..ad93205 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -98,7 +98,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 		while (!need_resched()) {
 
 			check_pgt_cache();
@@ -114,7 +114,7 @@ void cpu_idle(void)
 				pm_idle();
 			start_critical_timings();
 		}
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index f693e44..9ca714e 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -121,7 +121,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_idle_enter();
 		while (!need_resched()) {
 
 			rmb();
@@ -147,7 +147,7 @@ void cpu_idle(void)
 			__exit_idle();
 		}
 
-		tick_nohz_restart_sched_tick();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/include/linux/tick.h b/include/linux/tick.h
index ca40838..0df1d50 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -121,21 +121,22 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
 # ifdef CONFIG_NO_HZ
-extern void tick_nohz_stop_sched_tick(int inidle);
-extern void tick_nohz_restart_sched_tick(void);
+extern void tick_nohz_idle_enter(void);
+extern void tick_nohz_idle_exit(void);
+extern void tick_nohz_irq_exit(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 # else
-static inline void tick_nohz_stop_sched_tick(int inidle)
+static inline void tick_nohz_idle_enter(void)
 {
-	if (inidle)
-		rcu_idle_enter();
+	rcu_idle_enter();
 }
-static inline void tick_nohz_restart_sched_tick(void)
+static inline void tick_nohz_idle_exit(void)
 {
 	rcu_idle_exit();
 }
+
 static inline ktime_t tick_nohz_get_sleep_length(void)
 {
 	ktime_t len = { .tv64 = NSEC_PER_SEC/HZ };
diff --git a/kernel/softirq.c b/kernel/softirq.c
index fca82c3..d2be0e0 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -351,7 +351,7 @@ void irq_exit(void)
 #ifdef CONFIG_NO_HZ
 	/* Make sure that timer wheel updates are propagated */
 	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
-		tick_nohz_stop_sched_tick(0);
+		tick_nohz_irq_exit();
 #endif
 	preempt_enable_no_resched();
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4692907..52b7ace 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -246,42 +246,17 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 }
 EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
 
-/**
- * tick_nohz_stop_sched_tick - stop the idle tick from the idle task
- *
- * When the next event is more than a tick into the future, stop the idle tick
- * Called either from the idle loop or from irq_exit() when an idle period was
- * just interrupted by an interrupt which did not cause a reschedule.
- */
-void tick_nohz_stop_sched_tick(int inidle)
+static void tick_nohz_stop_sched_tick(struct tick_sched *ts)
 {
-	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
-	struct tick_sched *ts;
+	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies;
 	ktime_t last_update, expires, now;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	u64 time_delta;
 	int cpu;
 
-	local_irq_save(flags);
-
 	cpu = smp_processor_id();
 	ts = &per_cpu(tick_cpu_sched, cpu);
 
-	/*
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
 	now = tick_nohz_start_idle(cpu, ts);
 
 	/*
@@ -297,10 +272,10 @@ void tick_nohz_stop_sched_tick(int inidle)
 	}
 
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
-		goto end;
+		return;
 
 	if (need_resched())
-		goto end;
+		return;
 
 	if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
 		static int ratelimit;
@@ -310,7 +285,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 			       (unsigned int) local_softirq_pending());
 			ratelimit++;
 		}
-		goto end;
+		return;
 	}
 
 	ts->idle_calls++;
@@ -442,10 +417,54 @@ out:
 	ts->next_jiffies = next_jiffies;
 	ts->last_jiffies = last_jiffies;
 	ts->sleep_length = ktime_sub(dev->next_event, now);
-end:
-	if (inidle)
-		rcu_idle_enter();
-	local_irq_restore(flags);
+}
+
+/**
+ * tick_nohz_idle_enter - stop the idle tick from the idle task
+ *
+ * When the next event is more than a tick into the future, stop the idle tick
+ * Called when we start the idle loop.
+ * This also enters into RCU extended quiescent state so that this CPU doesn't
+ * need anymore to be part of any global grace period completion. This way
+ * the tick can be stopped safely as we don't need to report quiescent states.
+ */
+void tick_nohz_idle_enter(void)
+{
+	struct tick_sched *ts;
+
+	WARN_ON_ONCE(irqs_disabled());
+
+	local_irq_disable();
+
+	ts = &__get_cpu_var(tick_cpu_sched);
+	/*
+	 * set ts->inidle unconditionally. even if the system did not
+	 * switch to nohz mode the cpu frequency governers rely on the
+	 * update of the idle time accounting in tick_nohz_start_idle().
+	 */
+	ts->inidle = 1;
+	tick_nohz_stop_sched_tick(ts);
+	rcu_idle_enter();
+
+	local_irq_enable();
+}
+
+/**
+ * tick_nohz_irq_exit - update next tick event from interrupt exit
+ *
+ * When an interrupt fires while we are idle and it doesn't cause
+ * a reschedule, it may still add, modify or delete a timer, enqueue
+ * an RCU callback, etc...
+ * So we need to re-calculate and reprogram the next tick event.
+ */
+void tick_nohz_irq_exit(void)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	if (!ts->inidle)
+		return;
+
+	tick_nohz_stop_sched_tick(ts);
 }
 
 /**
@@ -487,11 +506,13 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
 }
 
 /**
- * tick_nohz_restart_sched_tick - restart the idle tick from the idle task
+ * tick_nohz_idle_exit - restart the idle tick from the idle task
  *
  * Restart the idle tick when the CPU is woken up from idle
+ * This also exit the RCU extended quiescent state. The CPU
+ * can use RCU again after this function is called.
  */
-void tick_nohz_restart_sched_tick(void)
+void tick_nohz_idle_exit(void)
 {
 	int cpu = smp_processor_id();
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-- 
1.7.3.2

