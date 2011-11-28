Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab1K1Xdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:33:46 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53645 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab1K1Xdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:33:43 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 02/13] nohz: Remove tick_nohz_idle_enter_norcu() / tick_nohz_idle_exit_norcu()
Date: Mon, 28 Nov 2011 15:32:54 -0800
Message-Id: <1322523185-456-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111128233212.GA32279@linux.vnet.ibm.com>
References: <20111128233212.GA32279@linux.vnet.ibm.com>
x-cbid: 11112823-5806-0000-0000-00000E8602A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Those two APIs were provided to optimize the calls of
tick_nohz_idle_enter() and rcu_idle_enter() into a single
irq disabled section. This way no interrupt happening in-between would
needlessly process any RCU job.

Now we are talking about an optimization for which benefits
have yet to be measured. Let's start simple and completely decouple
idle rcu and dyntick idle logics to simplify.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/arm/kernel/process.c              |    6 +++-
 arch/avr32/kernel/process.c            |    6 +++-
 arch/blackfin/kernel/process.c         |    6 +++-
 arch/microblaze/kernel/process.c       |    6 +++-
 arch/mips/kernel/process.c             |    6 +++-
 arch/openrisc/kernel/idle.c            |    6 +++-
 arch/powerpc/kernel/idle.c             |   15 +++++-----
 arch/powerpc/platforms/iseries/setup.c |   12 +++++---
 arch/s390/kernel/process.c             |    6 +++-
 arch/sh/kernel/idle.c                  |    6 +++-
 arch/sparc/kernel/process_64.c         |    6 +++-
 arch/tile/kernel/process.c             |    6 +++-
 arch/um/kernel/process.c               |    6 +++-
 arch/unicore32/kernel/process.c        |    6 +++-
 arch/x86/kernel/process_32.c           |    6 +++-
 include/linux/tick.h                   |   47 +-------------------------------
 kernel/time/tick-sched.c               |   15 +++++-----
 17 files changed, 76 insertions(+), 91 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index b874d28..ddb0a87 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -183,7 +183,8 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter_norcu();
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		leds_event(led_idle_start);
 		while (!need_resched()) {
 #ifdef CONFIG_HOTPLUG_CPU
@@ -210,7 +211,8 @@ void cpu_idle(void)
 			}
 		}
 		leds_event(led_idle_end);
-		tick_nohz_idle_exit_norcu();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index 34c8c70..ea33957 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -34,10 +34,12 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter_norcu();
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched())
 			cpu_idle_sleep();
-		tick_nohz_idle_exit_norcu();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 57e0749..8dd0416 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -88,10 +88,12 @@ void cpu_idle(void)
 #endif
 		if (!idle)
 			idle = default_idle;
-		tick_nohz_idle_enter_norcu();
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched())
 			idle();
-		tick_nohz_idle_exit_norcu();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 13d59f3..7dcb5bf 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -103,10 +103,12 @@ void cpu_idle(void)
 		if (!idle)
 			idle = default_idle;
 
-		tick_nohz_idle_enter_norcu();
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched())
 			idle();
-		tick_nohz_idle_exit_norcu();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 
 		preempt_enable_no_resched();
 		schedule();
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 17fb3a2..7955409 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -56,7 +56,8 @@ void __noreturn cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter_norcu();
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched() && cpu_online(cpu)) {
 #ifdef CONFIG_MIPS_MT_SMTC
 			extern void smtc_idle_loop_hook(void);
@@ -77,7 +78,8 @@ void __noreturn cpu_idle(void)
 		     system_state == SYSTEM_BOOTING))
 			play_dead();
 #endif
-		tick_nohz_idle_exit_norcu();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/openrisc/kernel/idle.c b/arch/openrisc/kernel/idle.c
index 2e82cd0..e5fc7887 100644
--- a/arch/openrisc/kernel/idle.c
+++ b/arch/openrisc/kernel/idle.c
@@ -51,7 +51,8 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter_norcu();
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 
 		while (!need_resched()) {
 			check_pgt_cache();
@@ -69,7 +70,8 @@ void cpu_idle(void)
 			set_thread_flag(TIF_POLLING_NRFLAG);
 		}
 
-		tick_nohz_idle_exit_norcu();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 3cd73d1..9c3cd49 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -62,10 +62,10 @@ void cpu_idle(void)
 
 	set_thread_flag(TIF_POLLING_NRFLAG);
 	while (1) {
-		if (idle_uses_rcu)
-			tick_nohz_idle_enter();
-		else
-			tick_nohz_idle_enter_norcu();
+		tick_nohz_idle_enter();
+		if (!idle_uses_rcu)
+			rcu_idle_enter();
+
 		while (!need_resched() && !cpu_should_die()) {
 			ppc64_runlatch_off();
 
@@ -102,10 +102,9 @@ void cpu_idle(void)
 
 		HMT_medium();
 		ppc64_runlatch_on();
-		if (idle_uses_rcu)
-			tick_nohz_idle_exit();
-		else
-			tick_nohz_idle_exit_norcu();
+		if (!idle_uses_rcu)
+			rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		if (cpu_should_die())
 			cpu_die();
diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
index d69d3d1..8fc6258 100644
--- a/arch/powerpc/platforms/iseries/setup.c
+++ b/arch/powerpc/platforms/iseries/setup.c
@@ -563,7 +563,8 @@ static void yield_shared_processor(void)
 static void iseries_shared_idle(void)
 {
 	while (1) {
-		tick_nohz_idle_enter_norcu();
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched() && !hvlpevent_is_pending()) {
 			local_irq_disable();
 			ppc64_runlatch_off();
@@ -577,7 +578,8 @@ static void iseries_shared_idle(void)
 		}
 
 		ppc64_runlatch_on();
-		tick_nohz_idle_exit_norcu();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 
 		if (hvlpevent_is_pending())
 			process_iSeries_events();
@@ -593,7 +595,8 @@ static void iseries_dedicated_idle(void)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while (1) {
-		tick_nohz_idle_enter_norcu();
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		if (!need_resched()) {
 			while (!need_resched()) {
 				ppc64_runlatch_off();
@@ -610,7 +613,8 @@ static void iseries_dedicated_idle(void)
 		}
 
 		ppc64_runlatch_on();
-		tick_nohz_idle_exit_norcu();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 6fa9873..3201ae4 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -91,10 +91,12 @@ static void default_idle(void)
 void cpu_idle(void)
 {
 	for (;;) {
-		tick_nohz_idle_enter_norcu();
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched())
 			default_idle();
-		tick_nohz_idle_exit_norcu();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index ad58e75..406508d 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -89,7 +89,8 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter_norcu();
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 
 		while (!need_resched()) {
 			check_pgt_cache();
@@ -111,7 +112,8 @@ void cpu_idle(void)
 			start_critical_timings();
 		}
 
-		tick_nohz_idle_exit_norcu();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 4a0e7d7..39d8b05 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -95,12 +95,14 @@ void cpu_idle(void)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while(1) {
-		tick_nohz_idle_enter_norcu();
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 
 		while (!need_resched() && !cpu_is_offline(cpu))
 			sparc64_yield(cpu);
 
-		tick_nohz_idle_exit_norcu();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 
 		preempt_enable_no_resched();
 
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 53ac895..4c1ac6e 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -85,7 +85,8 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter_norcu();
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched()) {
 			if (cpu_is_offline(cpu))
 				BUG();  /* no HOTPLUG_CPU */
@@ -105,7 +106,8 @@ void cpu_idle(void)
 				local_irq_enable();
 			current_thread_info()->status |= TS_POLLING;
 		}
-		tick_nohz_idle_exit_norcu();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 55d2cf4..69f2490 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -246,10 +246,12 @@ void default_idle(void)
 		if (need_resched())
 			schedule();
 
-		tick_nohz_idle_enter_norcu();
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		nsecs = disable_timer();
 		idle_sleep(nsecs);
-		tick_nohz_idle_exit_norcu();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 	}
 }
 
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index 095ff5a..52edc2b 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -55,7 +55,8 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter_norcu();
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched()) {
 			local_irq_disable();
 			stop_critical_timings();
@@ -63,7 +64,8 @@ void cpu_idle(void)
 			local_irq_enable();
 			start_critical_timings();
 		}
-		tick_nohz_idle_exit_norcu();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index f94da39..485204f 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -99,7 +99,8 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter_norcu();
+		tick_nohz_idle_enter();
+		rcu_idle_enter();
 		while (!need_resched()) {
 
 			check_pgt_cache();
@@ -116,7 +117,8 @@ void cpu_idle(void)
 				pm_idle();
 			start_critical_timings();
 		}
-		tick_nohz_idle_exit_norcu();
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 327434a..ab8be90 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -122,45 +122,8 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
 # ifdef CONFIG_NO_HZ
-extern void __tick_nohz_idle_enter(void);
-static inline void tick_nohz_idle_enter(void)
-{
-	local_irq_disable();
-	__tick_nohz_idle_enter();
-	local_irq_enable();
-}
+extern void tick_nohz_idle_enter(void);
 extern void tick_nohz_idle_exit(void);
-
-/*
- * Call this pair of function if the arch doesn't make any use
- * of RCU in-between. You won't need to call rcu_idle_enter() and
- * rcu_idle_exit().
- * Otherwise you need to call tick_nohz_idle_enter() and tick_nohz_idle_exit()
- * and explicitly tell RCU about the window around the place the CPU enters low
- * power mode where no RCU use is made. This is done by calling rcu_idle_enter()
- * after the last use of RCU before the CPU is put to sleep and by calling
- * rcu_idle_exit() before the first use of RCU after the CPU woke up.
- */
-static inline void tick_nohz_idle_enter_norcu(void)
-{
-	/*
-	 * Also call rcu_idle_enter() in the irq disabled section even
-	 * if it disables irq itself.
-	 * Just an optimization that prevents from an interrupt happening
-	 * between it and __tick_nohz_idle_enter() to lose time to help
-	 * completing a grace period while we could be in extended grace
-	 * period already.
-	 */
-	local_irq_disable();
-	__tick_nohz_idle_enter();
-	rcu_idle_enter();
-	local_irq_enable();
-}
-static inline void tick_nohz_idle_exit_norcu(void)
-{
-	rcu_idle_exit();
-	tick_nohz_idle_exit();
-}
 extern void tick_nohz_irq_exit(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
@@ -168,14 +131,6 @@ extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 # else
 static inline void tick_nohz_idle_enter(void) { }
 static inline void tick_nohz_idle_exit(void) { }
-static inline void tick_nohz_idle_enter_norcu(void)
-{
-	rcu_idle_enter();
-}
-static inline void tick_nohz_idle_exit_norcu(void)
-{
-	rcu_idle_exit();
-}
 
 static inline ktime_t tick_nohz_get_sleep_length(void)
 {
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index c76aefe..0ec8b83 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -454,21 +454,20 @@ out:
  * When the next event is more than a tick into the future, stop the idle tick
  * Called when we start the idle loop.
  *
- * If no use of RCU is made in the idle loop between
- * tick_nohz_idle_enter() and tick_nohz_idle_exit() calls, then
- * tick_nohz_idle_enter_norcu() should be called instead and the arch
- * doesn't need to call rcu_idle_enter() and rcu_idle_exit() explicitly.
- *
- * Otherwise the arch is responsible of calling:
+ * The arch is responsible of calling:
  *
  * - rcu_idle_enter() after its last use of RCU before the CPU is put
  *  to sleep.
  * - rcu_idle_exit() before the first use of RCU after the CPU is woken up.
  */
-void __tick_nohz_idle_enter(void)
+void tick_nohz_idle_enter(void)
 {
 	struct tick_sched *ts;
 
+	WARN_ON_ONCE(irqs_disabled());
+
+	local_irq_disable();
+
 	ts = &__get_cpu_var(tick_cpu_sched);
 	/*
 	 * set ts->inidle unconditionally. even if the system did not
@@ -477,6 +476,8 @@ void __tick_nohz_idle_enter(void)
 	 */
 	ts->inidle = 1;
 	tick_nohz_stop_sched_tick(ts);
+
+	local_irq_enable();
 }
 
 /**
-- 
1.7.3.2

