Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab1FIXsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:48:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36965 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757396Ab1FIXr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xaBMVtNceMu0W34YOLxcxtCWsWH8lZMUw3MXGSr/+WJ+/+9Kej2Nn2XPNCmSijOAUv
         fv3npFeUAcvr1iWWiCekS+Sv0bLh5L5EI3LML/4/CsJ8GDnQRPc6fHHAOawDHydFjnXL
         4zeENfuAFjawWmgWMYDdsXLyfGc5NtkthZR5c=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Mike Frysinger <vapier@gentoo.org>, Ralf Baechle <ralf@linux-mips.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 2/4] nohz: Split extended quiescent state handling from nohz switch
Date: Fri, 10 Jun 2011 01:47:25 +0200
Message-Id: <1307663247-5397-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1307663247-5397-1-git-send-email-fweisbec@gmail.com>
References: <1307663247-5397-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is assumed that rcu won't be used once we switch to tickless
mode and until we restart the tick. However this is not always
true, as in x86-64 where we dereference the idle notifiers after
the tick is stopped.

To prepare for fixing this, split the tickless mode switching and
RCU extended quiescent state logics.
Make tick_nohz_stop/restart_sched_tick() RCU agnostic but provide
a new pair of APIs tick_nohz_enter/exit_idle() that keep the
old behaviour by handling both the nohz mode and RCU extended
quiescent states, then convert every archs to use these.

Archs that want to switch to extended QS to some custom points
can do it later by using tick_nohz_stop_sched_tick() and
rcu_enter_nohz() seperately.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: David Miller <davem@davemloft.net>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/arm/kernel/process.c              |    4 +-
 arch/avr32/kernel/process.c            |    4 +-
 arch/blackfin/kernel/process.c         |    4 +-
 arch/microblaze/kernel/process.c       |    4 +-
 arch/mips/kernel/process.c             |    4 +-
 arch/powerpc/kernel/idle.c             |    4 +-
 arch/powerpc/platforms/iseries/setup.c |    8 +++---
 arch/s390/kernel/process.c             |    4 +-
 arch/sh/kernel/idle.c                  |    2 +-
 arch/sparc/kernel/process_64.c         |    4 +-
 arch/tile/kernel/process.c             |    4 +-
 arch/um/kernel/process.c               |    4 +-
 arch/unicore32/kernel/process.c        |    4 +-
 arch/x86/kernel/process_32.c           |    4 +-
 arch/x86/kernel/process_64.c           |    4 +-
 include/linux/tick.h                   |   10 ++++++--
 kernel/time/tick-sched.c               |   36 ++++++++++++++++++++++++++++---
 17 files changed, 70 insertions(+), 38 deletions(-)

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
index b407bc8..fd78345 100644
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
index d2112d3..cdbfa52 100644
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
index 2946ae1..50b5810 100644
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
index a895e69..8c53c46 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -105,10 +105,10 @@ static void default_idle(void)
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
index 425d604..3957972 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -88,7 +88,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 
 		while (!need_resched()) {
 			check_pgt_cache();
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
index d006510..1fc9578 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -82,7 +82,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 		while (!need_resched()) {
 			if (cpu_is_offline(cpu))
 				BUG();  /* no HOTPLUG_CPU */
@@ -102,7 +102,7 @@ void cpu_idle(void)
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
index 8d12878..41e7d1b 100644
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
index 6c9dd92..3fe0883 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -120,7 +120,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick(1);
+		tick_nohz_enter_idle();
 		while (!need_resched()) {
 
 			rmb();
@@ -145,7 +145,7 @@ void cpu_idle(void)
 			__exit_idle();
 		}
 
-		tick_nohz_restart_sched_tick();
+		tick_nohz_exit_idle();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/include/linux/tick.h b/include/linux/tick.h
index b232ccc..ff31a71 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -121,14 +121,18 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
 # ifdef CONFIG_NO_HZ
-extern void tick_nohz_stop_sched_tick(int inidle);
+extern bool tick_nohz_stop_sched_tick(int inidle);
 extern void tick_nohz_restart_sched_tick(void);
+extern void tick_nohz_enter_idle(void);
+extern void tick_nohz_exit_idle(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 # else
-static inline void tick_nohz_stop_sched_tick(int inidle) { }
-static inline void tick_nohz_restart_sched_tick(void) { }
+static inline bool tick_nohz_stop_sched_tick(int inidle) { return false; }
+static inline void tick_nohz_restart_sched_tick(void) { return false; }
+static inline void tick_nohz_enter_idle(void) { }
+static inline void tick_nohz_exit_idle(void) { }
 static inline ktime_t tick_nohz_get_sleep_length(void)
 {
 	ktime_t len = { .tv64 = NSEC_PER_SEC/HZ };
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d5097c4..8e81e9f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -254,12 +254,13 @@ EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
  * Called either from the idle loop or from irq_exit() when an idle period was
  * just interrupted by an interrupt which did not cause a reschedule.
  */
-void tick_nohz_stop_sched_tick(int inidle)
+bool tick_nohz_stop_sched_tick(int inidle)
 {
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
 	struct tick_sched *ts;
 	ktime_t last_update, expires, now;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
+	int stopped = false;
 	u64 time_delta;
 	int cpu;
 
@@ -409,7 +410,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
-			rcu_enter_nohz();
+			stopped = true;
 		}
 
 		ts->idle_sleeps++;
@@ -450,6 +451,22 @@ out:
 	ts->sleep_length = ktime_sub(dev->next_event, now);
 end:
 	local_irq_restore(flags);
+
+	return stopped;
+}
+
+
+/**
+ * tick_nohz_enter_idle - stop the tick and enter extended quiescent state
+ *
+ * Most arch may want to enter RCU extended state right after they switched
+ * to nohz mode. Beware though, no read side use of RCU can be done until we
+ * call tick_nohz_exit_idle().
+ */
+void tick_nohz_enter_idle(void)
+{
+	if (tick_nohz_stop_sched_tick(1))
+		rcu_enter_nohz();
 }
 
 /**
@@ -519,8 +536,6 @@ void tick_nohz_restart_sched_tick(void)
 
 	ts->inidle = 0;
 
-	rcu_exit_nohz();
-
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
 	tick_do_update_jiffies64(now);
@@ -552,6 +567,19 @@ void tick_nohz_restart_sched_tick(void)
 	local_irq_enable();
 }
 
+/**
+ * tick_nohz_exit_idle - restart the tick and exit extended quiescent state
+ */
+void tick_nohz_exit_idle(void)
+{
+	struct tick_sched *ts = &__raw_get_cpu_var(tick_cpu_sched);
+
+	if (ts->tick_stopped)
+		rcu_exit_nohz();
+
+	tick_nohz_restart_sched_tick();
+}
+
 static int tick_nohz_reprogram(struct tick_sched *ts, ktime_t now)
 {
 	hrtimer_forward(&ts->sched_timer, now, tick_period);
-- 
1.7.5.4

