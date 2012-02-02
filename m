Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab2BBAn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 19:43:59 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:46852 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab2BBAn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 19:43:57 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>, linux-pm@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH RFC idle 1/3] x86: Avoid invoking RCU when CPU is idle
Date: Wed,  1 Feb 2012 16:43:22 -0800
Message-Id: <1328143404-11038-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20120202004253.GA10946@linux.vnet.ibm.com>
References: <20120202004253.GA10946@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020200-7282-0000-0000-00000620E220
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The idle loop is a quiscent state for RCU, which means that RCU ignores
CPUs that have told RCU that they are idle via rcu_idle_enter().  There
are nevertheless quite a few places where idle CPUs use RCU, most commonly
indirectly via tracing.  This patch fixes these problems for x86.

Many of these bugs have been in the kernel for quite some time, but
Frederic's recent change now gives warnings.

This patch takes the straightforward approach of pushing the
rcu_idle_enter()/rcu_idle_exit() pair further down into the core
of the idle loop.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Wilson <wilsons@start.ca>
Cc: linux-pm@vger.kernel.org
Cc: x86@kernel.org
---
 arch/x86/kernel/process.c    |   13 ++++++++++++-
 arch/x86/kernel/process_32.c |    2 --
 arch/x86/kernel/process_64.c |    4 ----
 drivers/idle/intel_idle.c    |    2 ++
 4 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 15763af..f6978b0 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -386,17 +386,21 @@ void default_idle(void)
 		 */
 		smp_mb();
 
+		rcu_idle_enter();
 		if (!need_resched())
 			safe_halt();	/* enables interrupts racelessly */
 		else
 			local_irq_enable();
+		rcu_idle_exit();
 		current_thread_info()->status |= TS_POLLING;
 		trace_power_end(smp_processor_id());
 		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
 	} else {
 		local_irq_enable();
 		/* loop is done by the caller */
+		rcu_idle_enter();
 		cpu_relax();
+		rcu_idle_exit();
 	}
 }
 #ifdef CONFIG_APM_MODULE
@@ -457,14 +461,19 @@ static void mwait_idle(void)
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
+		rcu_idle_enter();
 		if (!need_resched())
 			__sti_mwait(0, 0);
 		else
 			local_irq_enable();
+		rcu_idle_exit();
 		trace_power_end(smp_processor_id());
 		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
-	} else
+	} else {
 		local_irq_enable();
+		rcu_idle_enter();
+		rcu_idle_exit();
+	}
 }
 
 /*
@@ -477,8 +486,10 @@ static void poll_idle(void)
 	trace_power_start(POWER_CSTATE, 0, smp_processor_id());
 	trace_cpu_idle(0, smp_processor_id());
 	local_irq_enable();
+	rcu_idle_enter();
 	while (!need_resched())
 		cpu_relax();
+	rcu_idle_exit();
 	trace_power_end(smp_processor_id());
 	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
 }
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 485204f..6d9d4d5 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -100,7 +100,6 @@ void cpu_idle(void)
 	/* endless idle loop with no priority at all */
 	while (1) {
 		tick_nohz_idle_enter();
-		rcu_idle_enter();
 		while (!need_resched()) {
 
 			check_pgt_cache();
@@ -117,7 +116,6 @@ void cpu_idle(void)
 				pm_idle();
 			start_critical_timings();
 		}
-		rcu_idle_exit();
 		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 9b9fe4a..55a1a35 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -140,13 +140,9 @@ void cpu_idle(void)
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
 
-			/* enter_idle() needs rcu for notifiers */
-			rcu_idle_enter();
-
 			if (cpuidle_idle_call())
 				pm_idle();
 
-			rcu_idle_exit();
 			start_critical_timings();
 
 			/* In many cases the interrupt that ended idle
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 20bce51..a9ddab8 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -261,6 +261,7 @@ static int intel_idle(struct cpuidle_device *dev,
 	kt_before = ktime_get_real();
 
 	stop_critical_timings();
+	rcu_idle_enter();
 	if (!need_resched()) {
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
@@ -268,6 +269,7 @@ static int intel_idle(struct cpuidle_device *dev,
 		if (!need_resched())
 			__mwait(eax, ecx);
 	}
+	rcu_idle_exit();
 
 	start_critical_timings();
 
-- 
1.7.8

