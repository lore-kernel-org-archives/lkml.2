Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab1F2PiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:38:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806Ab1F2PiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:38:00 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH v3 8/9] KVM-GST: adjust scheduler cpu power
Date: Wed, 29 Jun 2011 11:29:47 -0400
Message-Id: <1309361388-30163-9-git-send-email-glommer@redhat.com>
In-Reply-To: <1309361388-30163-1-git-send-email-glommer@redhat.com>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
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
 kernel/sched.c          |   44 ++++++++++++++++++++++++++++++++++----------
 kernel/sched_features.h |    4 ++--
 3 files changed, 48 insertions(+), 12 deletions(-)

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
index c166863..3ef0de9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1975,7 +1975,7 @@ static inline u64 steal_ticks(u64 steal)
  * tell the underlying hypervisor that we grabbed the data, but skip steal time
  * accounting
  */
-static noinline bool touch_steal_time(int is_idle)
+static noinline bool __touch_steal_time(int is_idle, u64 max_steal, u64 *ticks)
 {
 	u64 steal, st = 0;
 
@@ -1985,8 +1985,13 @@ static noinline bool touch_steal_time(int is_idle)
 
 		steal -= this_rq()->prev_steal_time;
 
+		if (steal > max_steal)
+			steal = max_steal;
+
 		st = steal_ticks(steal);
 		this_rq()->prev_steal_time += st * TICK_NSEC;
+		if (ticks)
+			*ticks = st;
 
 		if (is_idle || st == 0)
 			return false;
@@ -1997,10 +2002,16 @@ static noinline bool touch_steal_time(int is_idle)
 	return false;
 }
 
+static inline bool touch_steal_time(int is_idle)
+{
+	return __touch_steal_time(is_idle, UINT_MAX, NULL);
+}
+
 static void update_rq_clock_task(struct rq *rq, s64 delta)
 {
-	s64 irq_delta;
+	s64 irq_delta = 0, steal = 0;
 
+#ifdef CONFIG_IRQ_TIME_ACCOUNTING
 	irq_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;
 
 	/*
@@ -2023,12 +2034,30 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 
 	rq->prev_irq_time += irq_delta;
 	delta -= irq_delta;
+#endif
+#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
+	if (static_branch((&paravirt_steal_rq_enabled))) {
+		int is_idle;
+		u64 st;
+
+		is_idle = ((rq->curr != rq->idle) ||
+				irq_count() != HARDIRQ_OFFSET);
+
+		__touch_steal_time(is_idle, delta, &st);
+
+		steal = st * TICK_NSEC;
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
@@ -2063,12 +2092,7 @@ static int irqtime_account_si_update(void)
 
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

