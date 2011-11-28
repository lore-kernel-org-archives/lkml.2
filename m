Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab1K1Xdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:33:51 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57720 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab1K1Xdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:33:49 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 07/13] rcu: Avoid needlessly IPIing CPUs at GP end
Date: Mon, 28 Nov 2011 15:32:59 -0800
Message-Id: <1322523185-456-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111128233212.GA32279@linux.vnet.ibm.com>
References: <20111128233212.GA32279@linux.vnet.ibm.com>
x-cbid: 11112823-9360-0000-0000-0000010C269A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

If a CPU enters dyntick-idle mode with callbacks pending, it will need
an IPI at the end of the grace period.  However, if it exits dyntick-idle
mode before the grace period ends, it will be needlessly IPIed at the
end of the grace period.

Therefore, this commit clears the per-CPU rcu_awake_at_gp_end flag
when a CPU determines that it does not need it.  This in turn requires
disabling interrupts across much of rcu_prepare_for_idle() in order to
avoid having nested interrupts clearing this state out from under us.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 45790bf..c4daf1e 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2027,6 +2027,9 @@ int rcu_needs_cpu(int cpu)
 static void rcu_prepare_for_idle(int cpu)
 {
 	int c = 0;
+	unsigned long flags;
+
+	local_irq_save(flags);
 
 	/*
 	 * If there are no callbacks on this CPU or if RCU has no further
@@ -2036,14 +2039,17 @@ static void rcu_prepare_for_idle(int cpu)
 	if (!rcu_cpu_has_callbacks(cpu)) {
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
 		per_cpu(rcu_dyntick_drain, cpu) = 0;
+		per_cpu(rcu_awake_at_gp_end, cpu) = 0;
+		local_irq_restore(flags);
 		trace_rcu_prep_idle("No callbacks");
 		return;
 	}
 	if (!rcu_pending(cpu)) {
-		trace_rcu_prep_idle("Dyntick with callbacks");
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
 		per_cpu(rcu_dyntick_drain, cpu) = 0;
 		per_cpu(rcu_awake_at_gp_end, cpu) = 1;
+		local_irq_restore(flags);
+		trace_rcu_prep_idle("Dyntick with callbacks");
 		return;  /* Nothing to do immediately. */
 	}
 
@@ -2052,6 +2058,7 @@ static void rcu_prepare_for_idle(int cpu)
 	 * refrained from disabling the scheduling-clock tick.
 	 */
 	if (per_cpu(rcu_dyntick_holdoff, cpu) == jiffies) {
+		local_irq_restore(flags);
 		trace_rcu_prep_idle("In holdoff");
 		return;
 	}
@@ -2060,9 +2067,11 @@ static void rcu_prepare_for_idle(int cpu)
 	if (per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* First time through, initialize the counter. */
 		per_cpu(rcu_dyntick_drain, cpu) = RCU_NEEDS_CPU_FLUSHES;
+		per_cpu(rcu_awake_at_gp_end, cpu) = 0;
 	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* We have hit the limit, so time to give up. */
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
+		local_irq_restore(flags);
 		trace_rcu_prep_idle("Begin holdoff");
 		invoke_rcu_core();  /* Force the CPU out of dyntick-idle. */
 		return;
@@ -2095,10 +2104,13 @@ static void rcu_prepare_for_idle(int cpu)
 	 * So try forcing the callbacks through the grace period.
 	 */
 	if (c) {
+		local_irq_restore(flags);
 		trace_rcu_prep_idle("More callbacks");
 		invoke_rcu_core();
-	} else
+	} else {
+		local_irq_restore(flags);
 		trace_rcu_prep_idle("Callbacks drained");
+	}
 }
 
 /*
-- 
1.7.3.2

