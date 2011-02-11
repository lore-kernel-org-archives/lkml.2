Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab1BKSVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:21:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab1BKSVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:21:25 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: [PATCH v3 5/6] KVM-GST: adjust scheduler cpu power
Date: Fri, 11 Feb 2011 13:19:23 -0500
Message-Id: <1297448364-14051-6-git-send-email-glommer@redhat.com>
In-Reply-To: <1297448364-14051-1-git-send-email-glommer@redhat.com>
References: <1297448364-14051-1-git-send-email-glommer@redhat.com>
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
---
 arch/x86/Kconfig        |   12 ++++++++++++
 kernel/sched.c          |   30 ++++++++++++++++++++----------
 kernel/sched_features.h |    4 ++--
 3 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d5ed94d..24d07e1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -515,6 +515,18 @@ menuconfig PARAVIRT_GUEST
 
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
index 60b0cf8..80fc47c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -525,6 +525,9 @@ struct rq {
 #endif
 
 	u64 prev_steal_ticks;
+#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
+	u64 prev_steal_time;
+#endif
 
 	/* calc_load related fields */
 	unsigned long calc_load_update;
@@ -1900,10 +1903,13 @@ void account_system_vtime(struct task_struct *curr)
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
@@ -1926,20 +1932,24 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 
 	rq->prev_irq_time += irq_delta;
 	delta -= irq_delta;
-	rq->clock_task += delta;
+#endif
+#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
 
-	if (irq_delta && sched_feat(NONIRQ_POWER))
-		sched_rt_avg_update(rq, irq_delta);
-}
+	steal = steal_time_clock(cpu_of(rq)) - rq->prev_steal_time;
 
-#else /* CONFIG_IRQ_TIME_ACCOUNTING */
+	if (steal > delta)
+		steal = delta;
+
+	rq->prev_steal_time += steal;
+
+	delta -= steal;
+#endif
 
-static void update_rq_clock_task(struct rq *rq, s64 delta)
-{
 	rq->clock_task += delta;
-}
 
-#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
+	if ((irq_delta + steal) && sched_feat(NONTASK_POWER))
+		sched_rt_avg_update(rq, irq_delta + steal);
+}
 
 #include "sched_idletask.c"
 #include "sched_fair.c"
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 68e69ac..194fc6d 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -61,6 +61,6 @@ SCHED_FEAT(LB_BIAS, 1)
 SCHED_FEAT(OWNER_SPIN, 1)
 
 /*
- * Decrement CPU power based on irq activity
+ * Decrement CPU power based on time not spent running tasks
  */
-SCHED_FEAT(NONIRQ_POWER, 1)
+SCHED_FEAT(NONTASK_POWER, 1)
-- 
1.7.2.3

