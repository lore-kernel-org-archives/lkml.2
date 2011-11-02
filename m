Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab1KBUeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:34:24 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:32809 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab1KBUeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:34:21 -0400
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
Subject: [PATCH RFC tip/core/rcu 19/28] nohz: Allow rcu extended quiescent state handling seperately from tick stop
Date: Wed,  2 Nov 2011 13:30:40 -0700
Message-Id: <1320265849-5744-19-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-5112-0000-0000-0000019EA4FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

It is assumed that rcu won't be used once we switch to tickless
mode and until we restart the tick. However this is not always
true, as in x86-64 where we dereference the idle notifiers after
the tick is stopped.

To prepare for fixing this, add two new APIs:
tick_nohz_idle_enter_norcu() and tick_nohz_idle_exit_norcu().

If no use of RCU is made in the idle loop between
tick_nohz_enter_idle() and tick_nohz_exit_idle() calls, the arch
must instead call the new *_norcu() version such that the arch doesn't
need to call rcu_idle_enter() and rcu_idle_exit().

Otherwise the arch must call tick_nohz_enter_idle() and
tick_nohz_exit_idle() and also call explicitly:

- rcu_idle_enter() after its last use of RCU before the CPU is put
to sleep.
- rcu_idle_exit() before the first use of RCU after the CPU is woken
up.

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
 arch/powerpc/platforms/iseries/setup.c |    8 +++---
 arch/s390/kernel/process.c             |    4 +-
 arch/sh/kernel/idle.c                  |    4 +-
 arch/sparc/kernel/process_64.c         |    4 +-
 arch/tile/kernel/process.c             |    4 +-
 arch/um/kernel/process.c               |    4 +-
 arch/unicore32/kernel/process.c        |    4 +-
 arch/x86/kernel/process_32.c           |    4 +-
 arch/x86/kernel/process_64.c           |    4 +-
 include/linux/tick.h                   |   46 +++++++++++++++++++++++++++++--
 kernel/time/tick-sched.c               |   25 +++++++++--------
 18 files changed, 90 insertions(+), 49 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index f9261d0..4f83362 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -183,7 +183,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter_norcu();
 		leds_event(led_idle_start);
 		while (!need_resched()) {
 #ifdef CONFIG_HOTPLUG_CPU
@@ -210,7 +210,7 @@ void cpu_idle(void)
 			}
 		}
 		leds_event(led_idle_end);
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit_norcu();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index 6ee7952..34c8c70 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -34,10 +34,10 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter_norcu();
 		while (!need_resched())
 			cpu_idle_sleep();
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit_norcu();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 7b141b5..57e0749 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -88,10 +88,10 @@ void cpu_idle(void)
 #endif
 		if (!idle)
 			idle = default_idle;
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter_norcu();
 		while (!need_resched())
 			idle();
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit_norcu();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 6dc123e..c6ece38 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -103,10 +103,10 @@ void cpu_idle(void)
 		if (!idle)
 			idle = default_idle;
 
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter_norcu();
 		while (!need_resched())
 			idle();
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit_norcu();
 
 		preempt_enable_no_resched();
 		schedule();
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index d50a005..7df2ffc 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -56,7 +56,7 @@ void __noreturn cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter_norcu();
 		while (!need_resched() && cpu_online(cpu)) {
 #ifdef CONFIG_MIPS_MT_SMTC
 			extern void smtc_idle_loop_hook(void);
@@ -77,7 +77,7 @@ void __noreturn cpu_idle(void)
 		     system_state == SYSTEM_BOOTING))
 			play_dead();
 #endif
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit_norcu();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/openrisc/kernel/idle.c b/arch/openrisc/kernel/idle.c
index fb6a9bf..2e82cd0 100644
--- a/arch/openrisc/kernel/idle.c
+++ b/arch/openrisc/kernel/idle.c
@@ -51,7 +51,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter_norcu();
 
 		while (!need_resched()) {
 			check_pgt_cache();
@@ -69,7 +69,7 @@ void cpu_idle(void)
 			set_thread_flag(TIF_POLLING_NRFLAG);
 		}
 
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit_norcu();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 878572f..2e782a3 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -56,7 +56,7 @@ void cpu_idle(void)
 
 	set_thread_flag(TIF_POLLING_NRFLAG);
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter_norcu();
 		while (!need_resched() && !cpu_should_die()) {
 			ppc64_runlatch_off();
 
@@ -93,7 +93,7 @@ void cpu_idle(void)
 
 		HMT_medium();
 		ppc64_runlatch_on();
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit_norcu();
 		preempt_enable_no_resched();
 		if (cpu_should_die())
 			cpu_die();
diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
index e2f5fad..77ff6eb 100644
--- a/arch/powerpc/platforms/iseries/setup.c
+++ b/arch/powerpc/platforms/iseries/setup.c
@@ -562,7 +562,7 @@ static void yield_shared_processor(void)
 static void iseries_shared_idle(void)
 {
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter_norcu();
 		while (!need_resched() && !hvlpevent_is_pending()) {
 			local_irq_disable();
 			ppc64_runlatch_off();
@@ -576,7 +576,7 @@ static void iseries_shared_idle(void)
 		}
 
 		ppc64_runlatch_on();
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit_norcu();
 
 		if (hvlpevent_is_pending())
 			process_iSeries_events();
@@ -592,7 +592,7 @@ static void iseries_dedicated_idle(void)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter_norcu();
 		if (!need_resched()) {
 			while (!need_resched()) {
 				ppc64_runlatch_off();
@@ -609,7 +609,7 @@ static void iseries_dedicated_idle(void)
 		}
 
 		ppc64_runlatch_on();
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit_norcu();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index db3e930..44028ae 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -90,10 +90,10 @@ static void default_idle(void)
 void cpu_idle(void)
 {
 	for (;;) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter_norcu();
 		while (!need_resched())
 			default_idle();
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit_norcu();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 6015743..ad58e75 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -89,7 +89,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter_norcu();
 
 		while (!need_resched()) {
 			check_pgt_cache();
@@ -111,7 +111,7 @@ void cpu_idle(void)
 			start_critical_timings();
 		}
 
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit_norcu();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 1235f63..78b1bc0 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -95,12 +95,12 @@ void cpu_idle(void)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while(1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter_norcu();
 
 		while (!need_resched() && !cpu_is_offline(cpu))
 			sparc64_yield(cpu);
 
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit_norcu();
 
 		preempt_enable_no_resched();
 
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 920e674..53ac895 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -85,7 +85,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter_norcu();
 		while (!need_resched()) {
 			if (cpu_is_offline(cpu))
 				BUG();  /* no HOTPLUG_CPU */
@@ -105,7 +105,7 @@ void cpu_idle(void)
 				local_irq_enable();
 			current_thread_info()->status |= TS_POLLING;
 		}
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit_norcu();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 41acf59..9e7176b 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -245,10 +245,10 @@ void default_idle(void)
 		if (need_resched())
 			schedule();
 
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter_norcu();
 		nsecs = disable_timer();
 		idle_sleep(nsecs);
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit_norcu();
 	}
 }
 
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index 9999b9a..095ff5a 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -55,7 +55,7 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter_norcu();
 		while (!need_resched()) {
 			local_irq_disable();
 			stop_critical_timings();
@@ -63,7 +63,7 @@ void cpu_idle(void)
 			local_irq_enable();
 			start_critical_timings();
 		}
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit_norcu();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index ad93205..f311d096 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -98,7 +98,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter_norcu();
 		while (!need_resched()) {
 
 			check_pgt_cache();
@@ -114,7 +114,7 @@ void cpu_idle(void)
 				pm_idle();
 			start_critical_timings();
 		}
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit_norcu();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 9ca714e..e72daf9 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -121,7 +121,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter_norcu();
 		while (!need_resched()) {
 
 			rmb();
@@ -147,7 +147,7 @@ void cpu_idle(void)
 			__exit_idle();
 		}
 
-		tick_nohz_idle_exit();
+		tick_nohz_idle_exit_norcu();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 0df1d50..327434a 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -7,6 +7,7 @@
 #define _LINUX_TICK_H
 
 #include <linux/clockchips.h>
+#include <linux/irqflags.h>
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 
@@ -121,18 +122,57 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
 # ifdef CONFIG_NO_HZ
-extern void tick_nohz_idle_enter(void);
+extern void __tick_nohz_idle_enter(void);
+static inline void tick_nohz_idle_enter(void)
+{
+	local_irq_disable();
+	__tick_nohz_idle_enter();
+	local_irq_enable();
+}
 extern void tick_nohz_idle_exit(void);
+
+/*
+ * Call this pair of function if the arch doesn't make any use
+ * of RCU in-between. You won't need to call rcu_idle_enter() and
+ * rcu_idle_exit().
+ * Otherwise you need to call tick_nohz_idle_enter() and tick_nohz_idle_exit()
+ * and explicitly tell RCU about the window around the place the CPU enters low
+ * power mode where no RCU use is made. This is done by calling rcu_idle_enter()
+ * after the last use of RCU before the CPU is put to sleep and by calling
+ * rcu_idle_exit() before the first use of RCU after the CPU woke up.
+ */
+static inline void tick_nohz_idle_enter_norcu(void)
+{
+	/*
+	 * Also call rcu_idle_enter() in the irq disabled section even
+	 * if it disables irq itself.
+	 * Just an optimization that prevents from an interrupt happening
+	 * between it and __tick_nohz_idle_enter() to lose time to help
+	 * completing a grace period while we could be in extended grace
+	 * period already.
+	 */
+	local_irq_disable();
+	__tick_nohz_idle_enter();
+	rcu_idle_enter();
+	local_irq_enable();
+}
+static inline void tick_nohz_idle_exit_norcu(void)
+{
+	rcu_idle_exit();
+	tick_nohz_idle_exit();
+}
 extern void tick_nohz_irq_exit(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 # else
-static inline void tick_nohz_idle_enter(void)
+static inline void tick_nohz_idle_enter(void) { }
+static inline void tick_nohz_idle_exit(void) { }
+static inline void tick_nohz_idle_enter_norcu(void)
 {
 	rcu_idle_enter();
 }
-static inline void tick_nohz_idle_exit(void)
+static inline void tick_nohz_idle_exit_norcu(void)
 {
 	rcu_idle_exit();
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 52b7ace..360d028 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -424,18 +424,22 @@ out:
  *
  * When the next event is more than a tick into the future, stop the idle tick
  * Called when we start the idle loop.
- * This also enters into RCU extended quiescent state so that this CPU doesn't
- * need anymore to be part of any global grace period completion. This way
- * the tick can be stopped safely as we don't need to report quiescent states.
+ *
+ * If no use of RCU is made in the idle loop between
+ * tick_nohz_idle_enter() and tick_nohz_idle_exit() calls, then
+ * tick_nohz_idle_enter_norcu() should be called instead and the arch
+ * doesn't need to call rcu_idle_enter() and rcu_idle_exit() explicitly.
+ *
+ * Otherwise the arch is responsible of calling:
+ *
+ * - rcu_idle_enter() after its last use of RCU before the CPU is put
+ *  to sleep.
+ * - rcu_idle_exit() before the first use of RCU after the CPU is woken up.
  */
-void tick_nohz_idle_enter(void)
+void __tick_nohz_idle_enter(void)
 {
 	struct tick_sched *ts;
 
-	WARN_ON_ONCE(irqs_disabled());
-
-	local_irq_disable();
-
 	ts = &__get_cpu_var(tick_cpu_sched);
 	/*
 	 * set ts->inidle unconditionally. even if the system did not
@@ -444,9 +448,6 @@ void tick_nohz_idle_enter(void)
 	 */
 	ts->inidle = 1;
 	tick_nohz_stop_sched_tick(ts);
-	rcu_idle_enter();
-
-	local_irq_enable();
 }
 
 /**
@@ -522,7 +523,7 @@ void tick_nohz_idle_exit(void)
 	ktime_t now;
 
 	local_irq_disable();
-	rcu_idle_exit();
+
 	if (ts->idle_active || (ts->inidle && ts->tick_stopped))
 		now = ktime_get();
 
-- 
1.7.3.2

