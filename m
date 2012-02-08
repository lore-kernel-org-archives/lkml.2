Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab2BHBnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 20:43:46 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60491 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab2BHBno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 20:43:44 -0500
Date: Wed, 8 Feb 2012 05:43:40 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dave Jones <davej@redhat.com>, Russell King <linux@arm.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Mike Chan <mike@android.com>,
        Todd Poynor <toddpoynor@google.com>, cpufreq@vger.kernel.org,
        kernel-team@android.com, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] sched: Wire up idle notifiers
Message-ID: <20120208014340.GB459@panacea>
References: <20120208013959.GA24535@panacea>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120208013959.GA24535@panacea>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tweak arch files to wire up sched_idle routines.

The changes are trivial except for powerpc and x86, for these
architectures we have to use _condrcu variants.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/arm/kernel/process.c              |    6 ++----
 arch/avr32/kernel/process.c            |    6 ++----
 arch/blackfin/kernel/process.c         |    6 ++----
 arch/c6x/kernel/process.c              |    6 ++----
 arch/microblaze/kernel/process.c       |    6 ++----
 arch/mips/kernel/process.c             |    6 ++----
 arch/openrisc/kernel/idle.c            |    6 ++----
 arch/powerpc/kernel/idle.c             |    8 ++------
 arch/powerpc/platforms/iseries/setup.c |   12 ++++--------
 arch/s390/kernel/process.c             |    6 ++----
 arch/sh/kernel/idle.c                  |    6 ++----
 arch/sparc/kernel/process_64.c         |    6 ++----
 arch/tile/kernel/process.c             |    6 ++----
 arch/um/kernel/process.c               |    6 ++----
 arch/unicore32/kernel/process.c        |    6 ++----
 arch/x86/kernel/process_32.c           |    6 ++----
 arch/x86/kernel/process_64.c           |    4 ++--
 17 files changed, 36 insertions(+), 72 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 971d65c..f2bac2d 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -206,8 +206,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
+		sched_idle_enter();
 		leds_event(led_idle_start);
 		while (!need_resched()) {
 #ifdef CONFIG_HOTPLUG_CPU
@@ -237,8 +236,7 @@ void cpu_idle(void)
 			}
 		}
 		leds_event(led_idle_end);
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
+		sched_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index ea33957..a993186 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -34,12 +34,10 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
+		sched_idle_enter();
 		while (!need_resched())
 			cpu_idle_sleep();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
+		sched_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 8dd0416..91fd39b8 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -88,12 +88,10 @@ void cpu_idle(void)
 #endif
 		if (!idle)
 			idle = default_idle;
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
+		sched_idle_enter();
 		while (!need_resched())
 			idle();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
+		sched_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/c6x/kernel/process.c b/arch/c6x/kernel/process.c
index 7ca8c41..64eefc4 100644
--- a/arch/c6x/kernel/process.c
+++ b/arch/c6x/kernel/process.c
@@ -71,8 +71,7 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
+		sched_idle_enter();
 		while (1) {
 			local_irq_disable();
 			if (need_resched()) {
@@ -81,8 +80,7 @@ void cpu_idle(void)
 			}
 			c6x_idle(); /* enables local irqs */
 		}
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
+		sched_idle_exit();
 
 		preempt_enable_no_resched();
 		schedule();
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 7dcb5bf..ac0ddd0 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -103,12 +103,10 @@ void cpu_idle(void)
 		if (!idle)
 			idle = default_idle;
 
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
+		sched_idle_enter();
 		while (!need_resched())
 			idle();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
+		sched_idle_exit();
 
 		preempt_enable_no_resched();
 		schedule();
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 7955409..72ed62b8 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -56,8 +56,7 @@ void __noreturn cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
+		sched_idle_enter();
 		while (!need_resched() && cpu_online(cpu)) {
 #ifdef CONFIG_MIPS_MT_SMTC
 			extern void smtc_idle_loop_hook(void);
@@ -78,8 +77,7 @@ void __noreturn cpu_idle(void)
 		     system_state == SYSTEM_BOOTING))
 			play_dead();
 #endif
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
+		sched_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/openrisc/kernel/idle.c b/arch/openrisc/kernel/idle.c
index e5fc7887..ab5dd49 100644
--- a/arch/openrisc/kernel/idle.c
+++ b/arch/openrisc/kernel/idle.c
@@ -51,8 +51,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
+		sched_idle_enter();
 
 		while (!need_resched()) {
 			check_pgt_cache();
@@ -70,8 +69,7 @@ void cpu_idle(void)
 			set_thread_flag(TIF_POLLING_NRFLAG);
 		}
 
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
+		sched_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 7c66ce1..c89172d 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -66,9 +66,7 @@ void cpu_idle(void)
 
 	set_thread_flag(TIF_POLLING_NRFLAG);
 	while (1) {
-		tick_nohz_idle_enter();
-		if (!idle_uses_rcu)
-			rcu_idle_enter();
+		sched_idle_enter_condrcu(idle_uses_rcu);
 
 		while (!need_resched() && !cpu_should_die()) {
 			ppc64_runlatch_off();
@@ -106,9 +104,7 @@ void cpu_idle(void)
 
 		HMT_medium();
 		ppc64_runlatch_on();
-		if (!idle_uses_rcu)
-			rcu_idle_exit();
-		tick_nohz_idle_exit();
+		sched_idle_exit_condrcu(idle_uses_rcu);
 		preempt_enable_no_resched();
 		if (cpu_should_die())
 			cpu_die();
diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
index 8fc6258..496bd5e 100644
--- a/arch/powerpc/platforms/iseries/setup.c
+++ b/arch/powerpc/platforms/iseries/setup.c
@@ -563,8 +563,7 @@ static void yield_shared_processor(void)
 static void iseries_shared_idle(void)
 {
 	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
+		sched_idle_enter();
 		while (!need_resched() && !hvlpevent_is_pending()) {
 			local_irq_disable();
 			ppc64_runlatch_off();
@@ -578,8 +577,7 @@ static void iseries_shared_idle(void)
 		}
 
 		ppc64_runlatch_on();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
+		sched_idle_exit();
 
 		if (hvlpevent_is_pending())
 			process_iSeries_events();
@@ -595,8 +593,7 @@ static void iseries_dedicated_idle(void)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
+		sched_idle_enter();
 		if (!need_resched()) {
 			while (!need_resched()) {
 				ppc64_runlatch_off();
@@ -613,8 +610,7 @@ static void iseries_dedicated_idle(void)
 		}
 
 		ppc64_runlatch_on();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
+		sched_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 3201ae4..1446fdf 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -91,12 +91,10 @@ static void default_idle(void)
 void cpu_idle(void)
 {
 	for (;;) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
+		sched_idle_enter();
 		while (!need_resched())
 			default_idle();
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
+		sched_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 406508d..5d8acc2 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -89,8 +89,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
+		sched_idle_enter();
 
 		while (!need_resched()) {
 			check_pgt_cache();
@@ -112,8 +111,7 @@ void cpu_idle(void)
 			start_critical_timings();
 		}
 
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
+		sched_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 39d8b05..a5d0062 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -95,14 +95,12 @@ void cpu_idle(void)
 	set_thread_flag(TIF_POLLING_NRFLAG);
 
 	while(1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
+		sched_idle_enter();
 
 		while (!need_resched() && !cpu_is_offline(cpu))
 			sparc64_yield(cpu);
 
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
+		sched_idle_exit();
 
 		preempt_enable_no_resched();
 
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 4c1ac6e..436f366 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -85,8 +85,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
+		sched_idle_enter();
 		while (!need_resched()) {
 			if (cpu_is_offline(cpu))
 				BUG();  /* no HOTPLUG_CPU */
@@ -106,8 +105,7 @@ void cpu_idle(void)
 				local_irq_enable();
 			current_thread_info()->status |= TS_POLLING;
 		}
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
+		sched_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 69f2490..20b1a39 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -246,12 +246,10 @@ void default_idle(void)
 		if (need_resched())
 			schedule();
 
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
+		sched_idle_enter();
 		nsecs = disable_timer();
 		idle_sleep(nsecs);
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
+		sched_idle_exit();
 	}
 }
 
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index 52edc2b..ec540dc 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -55,8 +55,7 @@ void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
+		sched_idle_enter();
 		while (!need_resched()) {
 			local_irq_disable();
 			stop_critical_timings();
@@ -64,8 +63,7 @@ void cpu_idle(void)
 			local_irq_enable();
 			start_critical_timings();
 		}
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
+		sched_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 485204f..0e5a4c3 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -99,8 +99,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
+		sched_idle_enter();
 		while (!need_resched()) {
 
 			check_pgt_cache();
@@ -117,8 +116,7 @@ void cpu_idle(void)
 				pm_idle();
 			start_critical_timings();
 		}
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
+		sched_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 9b9fe4a..4d8bc3d 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -122,7 +122,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_idle_enter();
+		sched_idle_enter_condrcu(1);
 		while (!need_resched()) {
 
 			rmb();
@@ -155,7 +155,7 @@ void cpu_idle(void)
 			__exit_idle();
 		}
 
-		tick_nohz_idle_exit();
+		sched_idle_exit_condrcu(1);
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
-- 
1.7.7.6

