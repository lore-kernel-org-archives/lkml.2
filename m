Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab1GAVbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 17:31:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757843Ab1GAVbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 17:31:04 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH v4 8/9] KVM-GST: adjust scheduler cpu power
Date: Fri,  1 Jul 2011 17:22:48 -0400
Message-Id: <1309555369-16867-9-git-send-email-glommer@redhat.com>
In-Reply-To: <1309555369-16867-1-git-send-email-glommer@redhat.com>
References: <1309555369-16867-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes update_rq_clock() aware of steal time.
The mechanism of operation is not different from irq_time,
and follows the same principles. This lives in a CONFIG
option itself, and can be compiled out independently of
the rest of steal time reporting. The effect of disabling it
is that the scheduler will still report steal time (that cannot be
disabled), but won't use this information for cpu power adjustments.

Everytime update_rq_clock_task() is invoked, we query information
about how much time was stolen since last call, and feed it into
sched_rt_avg_update().

Although steal time reporting in account_process_tick() keeps
track of the last time we read the steal clock, in prev_steal_time,
this patch do it independently using another field,
prev_steal_time_rq. This is because otherwise, information about time
accounted in update_process_tick() would never reach us in update_rq_clock().

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <aliguori@us.ibm.com>
CC: Eric B Munson <emunson@mgebm.net>
---
 arch/x86/Kconfig        |   12 ++++++++++++
 kernel/sched.c          |   47 +++++++++++++++++++++++++++++++++++++----------
 kernel/sched_features.h |    4 ++--
 3 files changed, 51 insertions(+), 12 deletions(-)

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
index 247dd51..c40b118 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -532,6 +532,9 @@ struct rq {
 #ifdef CONFIG_PARAVIRT
 	u64 prev_steal_time;
 #endif
+#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
+	u64 prev_steal_time_rq;
+#endif
 
 	/* calc_load related fields */
 	unsigned long calc_load_update;
@@ -1971,8 +1974,14 @@ static inline u64 steal_ticks(u64 steal)
 
 static void update_rq_clock_task(struct rq *rq, s64 delta)
 {
-	s64 irq_delta;
-
+/*
+ * In theory, the compile should just see 0 here, and optimize out the call
+ * to sched_rt_avg_update. But I don't trust it...
+ */
+#if defined(CONFIG_IRQ_TIME_ACCOUNTING) || defined(CONFIG_PARAVIRT_TIME_ACCOUNTING)
+	s64 steal = 0, irq_delta = 0;
+#endif
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
 	irq_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;
 
 	/*
@@ -1995,12 +2004,35 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 
 	rq->prev_irq_time += irq_delta;
 	delta -= irq_delta;
+#endif
+#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
+	if (static_branch((&paravirt_steal_rq_enabled))) {
+		u64 st;
+
+		steal = paravirt_steal_clock(cpu_of(rq));
+		steal -= rq->prev_steal_time_rq;
+
+		if (unlikely(steal > delta))
+			steal = delta;
+
+		st = steal_ticks(steal);
+		steal = st * TICK_NSEC;
+
+		rq->prev_steal_time_rq += steal;
+
+		delta -= steal;
+	}
+#endif
+
 	rq->clock_task += delta;
 
-	if (irq_delta && sched_feat(NONIRQ_POWER))
-		sched_rt_avg_update(rq, irq_delta);
+#if defined(CONFIG_IRQ_TIME_ACCOUNTING) || defined(CONFIG_PARAVIRT_TIME_ACCOUNTING)
+	if ((irq_delta + steal) && sched_feat(NONTASK_POWER))
+		sched_rt_avg_update(rq, irq_delta + steal);
+#endif
 }
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
 static int irqtime_account_hi_update(void)
 {
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
@@ -2035,12 +2067,7 @@ static int irqtime_account_si_update(void)
 
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

