Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab3ADC6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 21:58:50 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35998 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab3ADC6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 21:58:47 -0500
X-IronPort-AV: E=Sophos;i="4.84,406,1355126400"; 
   d="scan'208";a="17669315"
From: Srivatsa Vaddagiri <vatsa@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-s390@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, mhocko@suse.cz, srivatsa.bhat@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>
Subject: [PATCH 1/2] cpuhotplug/nohz: Remove offline cpus from nohz-idle state
Date: Thu,  3 Jan 2013 18:58:38 -0800
Message-Id: <1357268318-7993-1-git-send-email-vatsa@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify idle loop of arm, mips, s390, sh and x86 architectures to exit from nohz
state before dying upon hot-remove. This change is needed to avoid userspace
tools like top command from seeing a rollback in total idle time over some
sampling periods.

Additionaly, modify idle loop on all architectures supporting cpu hotplug to
have idle thread of a dying cpu die immediately after scheduler returns control
to it. There is no point in wasting time via calls to *_enter()/*_exit() before
noticing the need to die and dying.

Additional ARM specific change:
	Revert commit ff081e05 ("ARM: 7457/1: smp: Fix suspicious
RCU originating from cpu_die()"), which added a RCU_NONIDLE() wrapper
around call to complete(). That wrapper is no longer needed as cpu_die() is
now called outside of a rcu_idle_enter()/exit() section. I also think that the
wait_for_completion() based wait in ARM's __cpu_die() can be replaced with a
busy-loop based one, as the wait there in general should be terminated within
few cycles.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: mhocko@suse.cz
Cc: srivatsa.bhat@linux.vnet.ibm.com
Signed-off-by: Srivatsa Vaddagiri <vatsa@codeaurora.org>
---
 arch/arm/kernel/process.c      |    9 ++++-----
 arch/arm/kernel/smp.c          |    2 +-
 arch/blackfin/kernel/process.c |    8 ++++----
 arch/mips/kernel/process.c     |    6 +++---
 arch/powerpc/kernel/idle.c     |    2 +-
 arch/s390/kernel/process.c     |    4 ++--
 arch/sh/kernel/idle.c          |    5 ++---
 arch/sparc/kernel/process_64.c |    3 ++-
 arch/x86/kernel/process.c      |    5 ++---
 9 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index c6dec5f..254099b 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -191,11 +191,6 @@ void cpu_idle(void)
 		rcu_idle_enter();
 		ledtrig_cpu(CPU_LED_IDLE_START);
 		while (!need_resched()) {
-#ifdef CONFIG_HOTPLUG_CPU
-			if (cpu_is_offline(smp_processor_id()))
-				cpu_die();
-#endif
-
 			/*
 			 * We need to disable interrupts here
 			 * to ensure we don't miss a wakeup call.
@@ -224,6 +219,10 @@ void cpu_idle(void)
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
 		schedule_preempt_disabled();
+#ifdef CONFIG_HOTPLUG_CPU
+		if (cpu_is_offline(smp_processor_id()))
+			cpu_die();
+#endif
 	}
 }
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 84f4cbf..a8e3b8a 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -251,7 +251,7 @@ void __ref cpu_die(void)
 	mb();
 
 	/* Tell __cpu_die() that this CPU is now safe to dispose of */
-	RCU_NONIDLE(complete(&cpu_died));
+	complete(&cpu_died);
 
 	/*
 	 * actual CPU shutdown procedure is at least platform (if not
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 3e16ad9..2bee1af 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -83,10 +83,6 @@ void cpu_idle(void)
 	while (1) {
 		void (*idle)(void) = pm_idle;
 
-#ifdef CONFIG_HOTPLUG_CPU
-		if (cpu_is_offline(smp_processor_id()))
-			cpu_die();
-#endif
 		if (!idle)
 			idle = default_idle;
 		tick_nohz_idle_enter();
@@ -98,6 +94,10 @@ void cpu_idle(void)
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
+#ifdef CONFIG_HOTPLUG_CPU
+		if (cpu_is_offline(smp_processor_id()))
+			cpu_die();
+#endif
 	}
 }
 
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index a11c6f9..41102a0 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -71,13 +71,13 @@ void __noreturn cpu_idle(void)
 				start_critical_timings();
 			}
 		}
+		rcu_idle_exit();
+		tick_nohz_idle_exit();
+		schedule_preempt_disabled();
 #ifdef CONFIG_HOTPLUG_CPU
 		if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map))
 			play_dead();
 #endif
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index ea78761..39ad029 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -102,11 +102,11 @@ void cpu_idle(void)
 		ppc64_runlatch_on();
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
+		schedule_preempt_disabled();
 		if (cpu_should_die()) {
 			sched_preempt_enable_no_resched();
 			cpu_die();
 		}
-		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 536d645..5290556 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -66,8 +66,6 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
  */
 static void default_idle(void)
 {
-	if (cpu_is_offline(smp_processor_id()))
-		cpu_die();
 	local_irq_disable();
 	if (need_resched()) {
 		local_irq_enable();
@@ -95,6 +93,8 @@ void cpu_idle(void)
 		if (test_thread_flag(TIF_MCCK_PENDING))
 			s390_handle_mcck();
 		schedule_preempt_disabled();
+		if (cpu_is_offline(smp_processor_id()))
+			cpu_die();
 	}
 }
 
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 0c91016..f8bc2f0 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -96,9 +96,6 @@ void cpu_idle(void)
 			check_pgt_cache();
 			rmb();
 
-			if (cpu_is_offline(cpu))
-				play_dead();
-
 			local_irq_disable();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
@@ -115,6 +112,8 @@ void cpu_idle(void)
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
 		schedule_preempt_disabled();
+		if (cpu_is_offline(cpu))
+			play_dead();
 	}
 }
 
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index cdb80b2..01589e7 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -105,13 +105,14 @@ void cpu_idle(void)
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
 
+		schedule_preempt_disabled();
+
 #ifdef CONFIG_HOTPLUG_CPU
 		if (cpu_is_offline(cpu)) {
 			sched_preempt_enable_no_resched();
 			cpu_play_dead();
 		}
 #endif
-		schedule_preempt_disabled();
 	}
 }
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 2ed787f..3d5f142 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -331,9 +331,6 @@ void cpu_idle(void)
 		while (!need_resched()) {
 			rmb();
 
-			if (cpu_is_offline(smp_processor_id()))
-				play_dead();
-
 			/*
 			 * Idle routines should keep interrupts disabled
 			 * from here on, until they go to idle.
@@ -366,6 +363,8 @@ void cpu_idle(void)
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
+		if (cpu_is_offline(smp_processor_id()))
+			play_dead();
 	}
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

