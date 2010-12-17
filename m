Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab0LQNCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 08:02:34 -0500
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:60851 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab0LQNCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 08:02:33 -0500
X-AuditID: c1b4fb39-b7cfbae000005c8e-04-4d0b5f67b429
From: Harald Gustafsson <harald.gustafsson@ericsson.com>
To: Dario Faggioli <faggioli@gandalf.sssup.it>,
        Peter Zijlstra <peterz@infradead.org>,
        Harald Gustafsson <hgu1972@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>
Subject: [PATCH 1/3] Added runqueue clock normalized with cpufreq
Date: Fri, 17 Dec 2010 14:02:02 +0100
Message-ID: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a request for comments on additions to sched deadline v3 patches.
Deadline scheduler is the first scheduler (I think) we introduce in Linux that
specifies the runtime in time and not only as a weight or a relation.
I have introduced a normalized runtime clock dependent on the CPU frequency.
This is used, in [PATCH 2/3], to calculate the deadline thread's runtime
so that approximately the same number of cycles are giving to the thread
independent of the CPU frequency. 

I suggest that this is important for users of hard reservation based schedulers
that the intended amount of work can be accomplished independent of the CPU frequency.
The usage of CPU frequency scaling is important on mobile devices and hence 
the combination of deadline scheduler and cpufreq should be solved.

This patch series applies on a backported sched deadline v3 to a 2.6.34 kernel.
That backport can be made available if anyone is interested. It also runs on
my dual core ARM system.

So before I do this for the linux tip I would welcome a discussion about if this
is a good idea and also suggestions on how to improve this.

This first patch introduce the normalized runtime clock, this could be made
lockless instead if requested.

/Harald

Change-Id: Ie0d9b8533cf4e5720eefd3af860d3a8577101907

Signed-off-by: Harald Gustafsson <harald.gustafsson@ericsson.com>
---
 kernel/sched.c |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 103 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c075664..2816371 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -72,6 +72,7 @@
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
 #include <linux/slab.h>
+#include <linux/cpufreq.h>
 #include <linux/cgroup_cpufreq.h>
 
 #include <asm/tlb.h>
@@ -596,6 +597,16 @@ struct rq {
 
 	u64 clock;
 
+        /* Need to keep track of clock cycles since
+	 * dl need to work with cpufreq, is derived based
+	 * on rq clock and cpufreq.
+	 */
+        u64 clock_norm;
+        u64 delta_clock_norm;
+        u64 delta_clock;
+        /* norm factor is in the Q31 format */
+        u64 norm_factor; 
+
 	atomic_t nr_iowait;
 
 #ifdef CONFIG_SMP
@@ -697,7 +708,17 @@ static inline int cpu_of(struct rq *rq)
 
 inline void update_rq_clock(struct rq *rq)
 {
+        u64 delta_clock = rq->delta_clock;
 	rq->clock = sched_clock_cpu(cpu_of(rq));
+#ifndef CONFIG_CPU_FREQ
+	rq->clock_norm = rq->clock;
+#else
+	rq->delta_clock = rq->clock;
+	rq->clock_norm += rq->delta_clock_norm;
+	rq->delta_clock_norm = 0;
+	if(delta_clock !=0)
+	    rq->clock_norm += ((rq->delta_clock - delta_clock) * rq->norm_factor) >> 32;
+#endif /*CONFIG_CPU_FREQ*/
 }
 
 /*
@@ -8115,6 +8136,79 @@ static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 }
 #endif
 
+#ifdef CONFIG_CPU_FREQ
+static int rq_clock_cpufreq_notify(struct notifier_block *nb, unsigned long val,
+				   void *data)
+{
+	struct cpufreq_policy *policy;
+	struct cpufreq_freqs *freq = data;
+	struct rq *rq;
+	u64 delta_clock, temp;
+	int cpu=freq->cpu;
+	unsigned long flags;
+
+	printk(KERN_INFO "rq_clock_cpufreq_notify called for cpu %i\n", cpu);
+
+	if (val != CPUFREQ_POSTCHANGE)
+		return 0;
+
+	if (freq->old == freq->new)
+	        return 0;
+
+	/* Update cpufreq_index with current speed */
+	policy = cpufreq_cpu_get(cpu);
+
+	/* calculate the norm factor in Q31 base */
+	temp = (((u64) freq->new) << 32);
+	temp = div_u64(temp, policy->cpuinfo.max_freq);
+
+	if(policy->shared_type == CPUFREQ_SHARED_TYPE_ALL) {
+	    for_each_cpu(cpu, policy->cpus) {
+		rq = cpu_rq(cpu);
+		raw_spin_lock_irqsave(&rq->lock, flags);
+		delta_clock = rq->delta_clock;
+		rq->delta_clock = sched_clock_cpu(freq->cpu);
+		if(delta_clock != 0)
+		    rq->delta_clock_norm += ((rq->delta_clock - delta_clock) * rq->norm_factor) >> 32; 
+		rq->norm_factor = temp;
+		raw_spin_unlock_irqrestore(&rq->lock, flags);
+		printk(KERN_INFO "cpufreq transition cpu:%i, norm:%llu, cycles:%llu\n", 
+		       freq->cpu, rq->norm_factor, rq->delta_clock_norm);
+	    }
+	}
+	else {
+	    raw_spin_lock_irqsave(&rq->lock, flags);
+	    rq = cpu_rq(cpu);
+	    delta_clock = rq->delta_clock;
+	    rq->delta_clock = sched_clock_cpu(freq->cpu);
+	    if(delta_clock != 0)
+		rq->delta_clock_norm += ((rq->delta_clock - delta_clock) * rq->norm_factor) >> 32; 
+	    rq->norm_factor = temp;
+	    raw_spin_unlock_irqrestore(&rq->lock, flags);
+	    printk(KERN_INFO "cpufreq transition cpu:%i, norm:%llu, cycles:%llu\n", 
+		   freq->cpu, rq->norm_factor, rq->delta_clock_norm);
+	}
+
+	cpufreq_cpu_put(policy);
+	return 0;
+}
+
+static struct notifier_block cpufreq_notifier = {
+	.notifier_call = rq_clock_cpufreq_notify,
+};
+
+static int __init init_rq_clock_cpufreq(void) 
+{
+        int ret=cpufreq_register_notifier(&cpufreq_notifier,
+					  CPUFREQ_TRANSITION_NOTIFIER);
+
+	//FIXME should set norm_factor etc here as well if not max speed
+	printk(KERN_INFO "init_rq_clock_cpufreq called ret:%i\n", ret);
+	return ret;
+}
+late_initcall(init_rq_clock_cpufreq);
+#endif /*CONFIG_CPU_FREQ*/
+
 void __init sched_init(void)
 {
 	int i, j;
@@ -8243,6 +8337,11 @@ void __init sched_init(void)
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
+
+		rq->norm_factor = 1ULL <<32;
+		rq->clock_norm = 0;
+		rq->delta_clock_norm = 0;
+		rq->delta_clock = 0;
 	}
 
 	set_load_weight(&init_task);
@@ -8255,6 +8354,10 @@ void __init sched_init(void)
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
 #endif
 
+#ifdef CONFIG_CPU_FREQ
+	init_rq_clock_cpufreq();
+#endif /*CONFIG_CPU_FREQ*/
+
 	/*
 	 * The boot idle thread does lazy MMU switching as well:
 	 */
-- 
1.7.0.4

