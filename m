Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1IZKTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 06:19:39 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48621 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab1IZKTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 06:19:37 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 4/7] nohz: Allow rcu extended quiescent state handling seperately from tick stop
Date: Mon, 26 Sep 2011 12:19:09 +0200
Message-Id: <1317032352-25571-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
References: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is assumed that rcu won't be used once we switch to tickless
mode and until we restart the tick. However this is not always
true, as in x86-64 where we dereference the idle notifiers after
the tick is stopped.

To prepare for fixing this, add a parameter to tick_nohz_enter_idle()
named "rcu_ext_qs" that tells whether we want to enter RCU extended
quiescent state at the same time we stop the tick.

If no use of RCU is made in the idle loop between
tick_nohz_enter_idle() and tick_nohz_exit_idle() calls, the parameter
must be set to true and the arch doesn't need to call rcu_enter_nohz()
and rcu_exit_nohz() explicitly.

Otherwise the parameter must be set to false and the arch is
responsible of calling:

- rcu_enter_nohz() after its last use of RCU before the CPU is put
to sleep.
- rcu_exit_nohz() before the first use of RCU after the CPU is woken
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
---
 arch/arm/kernel/process.c              |    2 +-
 arch/avr32/kernel/process.c            |    2 +-
 arch/blackfin/kernel/process.c         |    2 +-
 arch/microblaze/kernel/process.c       |    2 +-
 arch/mips/kernel/process.c             |    2 +-
 arch/powerpc/kernel/idle.c             |    2 +-
 arch/powerpc/platforms/iseries/setup.c |    4 ++--
 arch/s390/kernel/process.c             |    2 +-
 arch/sh/kernel/idle.c                  |    2 +-
 arch/sparc/kernel/process_64.c         |    2 +-
 arch/tile/kernel/process.c             |    2 +-
 arch/um/kernel/process.c               |    2 +-
 arch/unicore32/kernel/process.c        |    2 +-
 arch/x86/kernel/process_32.c           |    2 +-
 arch/x86/kernel/process_64.c           |    2 +-
 include/linux/tick.h                   |    7 +++++--
 kernel/time/tick-sched.c               |   28 ++++++++++++++++++++++++----
 17 files changed, 45 insertions(+), 22 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index f570e8f..51b0e39 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -182,7 +182,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter(true);
 		leds_event(led_idle_start);
 		while (!need_resched()) {
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index 6ee7952..5041c84 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -34,7 +34,7 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter(true);
 		while (!need_resched())
 			cpu_idle_sleep();
 		tick_nohz_idle_exit();
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 790b12e..f22a0da 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -88,7 +88,7 @@ void cpu_idle(void)
 #endif
 		if (!idle)
 			idle = default_idle;
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter(true);
 		while (!need_resched())
 			idle();
 		tick_nohz_idle_exit();
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 80c749b..0f5290f 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -103,7 +103,7 @@ void cpu_idle(void)
 		if (!idle)
 			idle = default_idle;
 
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter(true);
 		while (!need_resched())
 			idle();
 		tick_nohz_idle_exit();
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index d72a0e9..20be814 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -56,7 +56,7 @@ void __noreturn cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter(true);
 		while (!need_resched() && cpu_online(cpu)) {
 #ifdef CONFIG_MIPS_MT_SMTC
 			extern void smtc_idle_loop_hook(void);
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 878572f..a0e31a7 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -56,7 +56,7 @@ void cpu_idle(void)
 
 	set_thread_flag(TIF_POLLING_NRFLAG);
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter(true);
 		while (!need_resched() && !cpu_should_die()) {
 			ppc64_runlatch_off();
 
diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
index e2f5fad..f239427 100644
--- a/arch/powerpc/platforms/iseries/setup.c
+++ b/arch/powerpc/platforms/iseries/setup.c
@@ -562,7 +562,7 @@ static void yield_shared_processor(void)
 static void iseries_shared_idle(void)
 {
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter(true);
 		while (!need_resched() && !hvlpevent_is_pending()) {
 			local_irq_disable();
 			ppc64_runlatch_off();
@@ -592,7 +592,7 @@ static void iseries_dedicated_idle(void)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter(true);
 		if (!need_resched()) {
 			while (!need_resched()) {
 				ppc64_runlatch_off();
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index db3e930..3dbaf59 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -90,7 +90,7 @@ static void default_idle(void)
 void cpu_idle(void)
 {
 	for (;;) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter(true);
 		while (!need_resched())
 			default_idle();
 		tick_nohz_idle_exit();
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index a6b9a96..bb0a627 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -88,7 +88,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter(true);
 
 		while (!need_resched()) {
 			check_pgt_cache();
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 1235f63..3c5d363 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -95,7 +95,7 @@ void cpu_idle(void)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while(1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter(true);
 
 		while (!need_resched() && !cpu_is_offline(cpu))
 			sparc64_yield(cpu);
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 920e674..727dc85 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -85,7 +85,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter(true);
 		while (!need_resched()) {
 			if (cpu_is_offline(cpu))
 				BUG();  /* no HOTPLUG_CPU */
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 046abea..5693d6d 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -245,7 +245,7 @@ void default_idle(void)
 		if (need_resched())
 			schedule();
 
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter(true);
 		nsecs = disable_timer();
 		idle_sleep(nsecs);
 		tick_nohz_idle_exit();
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index 9999b9a..afa50d9 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -55,7 +55,7 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter(true);
 		while (!need_resched()) {
 			local_irq_disable();
 			stop_critical_timings();
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 1ab4c58..8c2faa9 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -97,7 +97,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter(true);
 		while (!need_resched()) {
 
 			check_pgt_cache();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index d7a6418..19ca231 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -120,7 +120,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		tick_nohz_idle_enter(true);
 		while (!need_resched()) {
 
 			rmb();
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 3f094d4..375e7d8 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -45,6 +45,8 @@ enum tick_nohz_mode {
  * @iowait_sleeptime:	Sum of the time slept in idle with sched tick stopped, with IO outstanding
  * @sleep_length:	Duration of the current idle sleep
  * @do_timer_lst:	CPU was the last one doing do_timer before going idle
+ * @rcu_ext_qs:		Set if we want to enter RCU extended quiescent state
+ *			when the tick gets stopped.
  */
 struct tick_sched {
 	struct hrtimer			sched_timer;
@@ -67,6 +69,7 @@ struct tick_sched {
 	unsigned long			next_jiffies;
 	ktime_t				idle_expires;
 	int				do_timer_last;
+	int				rcu_ext_qs;
 };
 
 extern void __init tick_init(void);
@@ -121,14 +124,14 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
 # ifdef CONFIG_NO_HZ
-extern void tick_nohz_idle_enter(void);
+extern void tick_nohz_idle_enter(bool rcu_ext_qs);
 extern void tick_nohz_idle_exit(void);
 extern void tick_nohz_irq_exit(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 # else
-static inline void tick_nohz_idle_enter(void) { }
+static inline void tick_nohz_idle_enter(bool rcu_ext_qs) { }
 static inline void tick_nohz_idle_exit(void) { }
 static inline ktime_t tick_nohz_get_sleep_length(void)
 {
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index b0ce515..cd1a54e 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -427,17 +427,30 @@ out:
 
 static void tick_nohz_stop_sched_tick(struct tick_sched *ts)
 {
-	if (__tick_nohz_stop_sched_tick(ts))
+	if (__tick_nohz_stop_sched_tick(ts) && ts->rcu_ext_qs)
 		rcu_enter_nohz();
 }
 
 /**
  * tick_nohz_idle_enter - stop the idle tick from the idle task
+ * @rcu_ext_qs: enter into rcu extended quiescent state
  *
- * When the next event is more than a tick into the future, stop the idle tick
+ * When the next event is more than a tick into the future, stop the idle tick.
  * Called when we start the idle loop.
+ *
+ * If no use of RCU is made in the idle loop between
+ * tick_nohz_enter_idle() and tick_nohz_exit_idle() calls, rcu_ext_qs
+ * must be set to true and the arch doesn't need to call rcu_enter_nohz()
+ * and rcu_exit_nohz() explicitly.
+ *
+ * Otherwise the parameter must be set to false and the arch is
+ * responsible of calling:
+ *
+ * - rcu_enter_nohz() after its last use of RCU before the CPU is put
+ *  to sleep.
+ * - rcu_exit_nohz() before the first use of RCU after the CPU is woken up.
  */
-void tick_nohz_idle_enter(void)
+void tick_nohz_idle_enter(bool rcu_ext_qs)
 {
 	struct tick_sched *ts;
 
@@ -452,6 +465,10 @@ void tick_nohz_idle_enter(void)
 	 * update of the idle time accounting in tick_nohz_start_idle().
 	 */
 	ts->inidle = 1;
+
+	if (rcu_ext_qs)
+		ts->rcu_ext_qs = 1;
+
 	tick_nohz_stop_sched_tick(ts);
 
 	local_irq_enable();
@@ -542,7 +559,10 @@ void tick_nohz_idle_exit(void)
 
 	ts->inidle = 0;
 
-	rcu_exit_nohz();
+	if (ts->rcu_ext_qs) {
+		rcu_exit_nohz();
+		ts->rcu_ext_qs = 0;
+	}
 
 	/* Update jiffies first */
 	select_nohz_load_balancer(0);
-- 
1.7.5.4

