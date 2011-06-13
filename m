Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1FMXjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:39:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392Ab1FMXjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:39:17 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH 6/7] KVM-GST: adjust scheduler cpu power
Date: Mon, 13 Jun 2011 19:31:36 -0400
Message-Id: <1308007897-17013-7-git-send-email-glommer@redhat.com>
In-Reply-To: <1308007897-17013-1-git-send-email-glommer@redhat.com>
References: <1308007897-17013-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a first proposal for using steal time information
to influence the scheduler. There are a lot of optimizations
and fine grained adjustments to be done, but it is working reasonably
so far for me (mostly)

With this patch (and some host pinnings to demonstrate the situation),
two vcpus with very different steal time (Say 80 % vs 1 %) will not get
an even distribution of processes. This is a situation that can naturally
arise, specially in overcommited scenarios. Previosly, the guest scheduler
would wrongly think that all cpus have the same ability to run processes,
lowering the overall throughput.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <aliguori@us.ibm.com>
CC: Eric B Munson <emunson@mgebm.net>
---
 arch/x86/Kconfig        |   12 ++++++++++++
 kernel/sched.c          |   36 +++++++++++++++++++++++++++---------
 kernel/sched_features.h |    4 ++--
 3 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..b26f312 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -512,6 +512,18 @@ menuconfig PARAVIRT_GUEST
 
 if PARAVIRT_GUEST
 
+config PARAVIRT_TIME_ACCOUNTING
+	bool "Paravirtual steal time accounting"
+	select PARAVIRT
+	default n
+	---help---
+	  Select this option to enable fine granularity task steal time 
+	  accounting. Time spent executing other tasks in parallel with
+	  the current vCPU is discounted from the vCPU power. To account for
+	  that, there can be a small performance impact.
+
+	  If in doubt, say N here.
+
 source "arch/x86/xen/Kconfig"
 
 config KVM_CLOCK
diff --git a/kernel/sched.c b/kernel/sched.c
index 154cb14..d6b2749 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -530,6 +530,9 @@ struct rq {
 	u64 prev_irq_time;
 #endif
 	u64 prev_steal_time;
+#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
+	u64 prev_steal_time_acc;
+#endif
 
 	/* calc_load related fields */
 	unsigned long calc_load_update;
@@ -1955,10 +1958,13 @@ void account_system_vtime(struct task_struct *curr)
 }
 EXPORT_SYMBOL_GPL(account_system_vtime);
 
+#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
+
 static void update_rq_clock_task(struct rq *rq, s64 delta)
 {
-	s64 irq_delta;
+	s64 irq_delta = 0, steal = 0;
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
 	irq_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;
 
 	/*
@@ -1981,12 +1987,29 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 
 	rq->prev_irq_time += irq_delta;
 	delta -= irq_delta;
+#endif
+#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
+	if (static_branch((&paravirt_steal_rq_enabled))) {
+
+		steal = paravirt_steal_clock(cpu_of(rq));
+		steal -= rq->prev_steal_time_acc;
+
+		rq->prev_steal_time_acc += steal;
+
+		if (steal > delta)
+			steal = delta;
+
+		delta -= steal;
+	}
+#endif
+
 	rq->clock_task += delta;
 
-	if (irq_delta && sched_feat(NONIRQ_POWER))
-		sched_rt_avg_update(rq, irq_delta);
+	if ((irq_delta + steal) && sched_feat(NONTASK_POWER))
+		sched_rt_avg_update(rq, irq_delta + steal);
 }
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
 static int irqtime_account_hi_update(void)
 {
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
@@ -2021,12 +2044,7 @@ static int irqtime_account_si_update(void)
 
 #define sched_clock_irqtime	(0)
 
-static void update_rq_clock_task(struct rq *rq, s64 delta)
-{
-	rq->clock_task += delta;
-}
-
-#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
+#endif
 
 #include "sched_idletask.c"
 #include "sched_fair.c"
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index be40f73..ca3b025 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -61,9 +61,9 @@ SCHED_FEAT(LB_BIAS, 1)
 SCHED_FEAT(OWNER_SPIN, 1)
 
 /*
- * Decrement CPU power based on irq activity
+ * Decrement CPU power based on time not spent running tasks
  */
-SCHED_FEAT(NONIRQ_POWER, 1)
+SCHED_FEAT(NONTASK_POWER, 1)
 
 /*
  * Queue remote wakeups on the target CPU and process them
-- 
1.7.3.4

