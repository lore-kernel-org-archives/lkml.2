Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab0GSX5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 19:57:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25470 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870Ab0GSX5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:57:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=vNIh0kZhM92XtSIVFHunKMwAHbZFaEcjSREeExRpC57SCwVk7p8QwrNliQtcTP2PM
	JUFda2wgRKHneY9r+B2Hg==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Venkatesh Pallipadi <venki@google.com>, Paul Menage <menage@google.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 3/4] sched: Generalize cpuacct usage tracking making it simpler to add new stats
Date: Mon, 19 Jul 2010 16:57:14 -0700
Message-Id: <1279583835-22854-4-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1279583835-22854-1-git-send-email-venki@google.com>
References: <1279583835-22854-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generalize cpuacct usage, making it easier to add new stats in the following
patch.

Also adds alloc_percpu_array() interface in percpu.h

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 include/linux/percpu.h |    4 ++++
 kernel/sched.c         |   39 ++++++++++++++++++++++++++-------------
 kernel/sched_fair.c    |    2 +-
 kernel/sched_rt.c      |    2 +-
 4 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index d3a38d6..216f96a 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -167,6 +167,10 @@ extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
 #define alloc_percpu(type)	\
 	(typeof(type) __percpu *)__alloc_percpu(sizeof(type), __alignof__(type))
 
+#define alloc_percpu_array(type, size)	\
+	(typeof(type) __percpu *)__alloc_percpu(sizeof(type) * size, \
+						__alignof__(type))
+
 /*
  * Optional methods for optimized non-lvalue per-cpu variable access.
  *
diff --git a/kernel/sched.c b/kernel/sched.c
index f167fbb..c12c8ea 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1396,12 +1396,20 @@ enum cpuacct_stat_index {
 	CPUACCT_STAT_NSTATS,
 };
 
+enum cpuacct_charge_index {
+	CPUACCT_CHARGE_USAGE,	/* ... execution time */
+
+	CPUACCT_CHARGE_NCHARGES,
+};
+
 #ifdef CONFIG_CGROUP_CPUACCT
-static void cpuacct_charge(struct task_struct *tsk, u64 cputime);
+static void cpuacct_charge(struct task_struct *tsk,
+		enum cpuacct_charge_index idx, u64 cputime);
 static void cpuacct_update_stats(struct task_struct *tsk,
 		enum cpuacct_stat_index idx, cputime_t val);
 #else
-static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
+static inline void cpuacct_charge(struct task_struct *tsk,
+		enum cpuacct_charge_index idx, u64 cputime) {}
 static inline void cpuacct_update_stats(struct task_struct *tsk,
 		enum cpuacct_stat_index idx, cputime_t val) {}
 #endif
@@ -8661,7 +8669,7 @@ struct cgroup_subsys cpu_cgroup_subsys = {
 /* track cpu usage of a group of tasks and its child groups */
 struct cpuacct {
 	struct cgroup_subsys_state css;
-	/* cpuusage holds pointer to a u64-type object on every cpu */
+	/* cpuusage holds pointer to a u64-type array object on every cpu */
 	u64 __percpu *cpuusage;
 	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
 	struct cpuacct *parent;
@@ -8693,7 +8701,7 @@ static struct cgroup_subsys_state *cpuacct_create(
 	if (!ca)
 		goto out;
 
-	ca->cpuusage = alloc_percpu(u64);
+	ca->cpuusage = alloc_percpu_array(u64, CPUACCT_CHARGE_NCHARGES);
 	if (!ca->cpuusage)
 		goto out_free_ca;
 
@@ -8729,9 +8737,10 @@ cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 	kfree(ca);
 }
 
-static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu)
+static u64 cpuacct_cpuusage_read(struct cpuacct *ca,
+		enum cpuacct_charge_index idx, int cpu)
 {
-	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu) + idx;
 	u64 data;
 
 #ifndef CONFIG_64BIT
@@ -8748,9 +8757,10 @@ static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu)
 	return data;
 }
 
-static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu, u64 val)
+static void cpuacct_cpuusage_write(struct cpuacct *ca,
+		enum cpuacct_charge_index idx, int cpu, u64 val)
 {
-	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu) + idx;
 
 #ifndef CONFIG_64BIT
 	/*
@@ -8772,7 +8782,7 @@ static u64 cpuusage_read(struct cgroup *cgrp, struct cftype *cft)
 	int i;
 
 	for_each_present_cpu(i)
-		totalcpuusage += cpuacct_cpuusage_read(ca, i);
+		totalcpuusage += cpuacct_cpuusage_read(ca, cft->private, i);
 
 	return totalcpuusage;
 }
@@ -8790,7 +8800,7 @@ static int cpuusage_write(struct cgroup *cgrp, struct cftype *cftype,
 	}
 
 	for_each_present_cpu(i)
-		cpuacct_cpuusage_write(ca, i, 0);
+		cpuacct_cpuusage_write(ca, cftype->private, i, 0);
 
 out:
 	return err;
@@ -8804,7 +8814,7 @@ static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
 	int i;
 
 	for_each_present_cpu(i) {
-		percpu = cpuacct_cpuusage_read(ca, i);
+		percpu = cpuacct_cpuusage_read(ca, cft->private, i);
 		seq_printf(m, "%llu ", (unsigned long long) percpu);
 	}
 	seq_printf(m, "\n");
@@ -8835,10 +8845,12 @@ static struct cftype files[] = {
 		.name = "usage",
 		.read_u64 = cpuusage_read,
 		.write_u64 = cpuusage_write,
+		.private = CPUACCT_CHARGE_USAGE,
 	},
 	{
 		.name = "usage_percpu",
 		.read_seq_string = cpuacct_percpu_seq_read,
+		.private = CPUACCT_CHARGE_USAGE,
 	},
 	{
 		.name = "stat",
@@ -8856,7 +8868,8 @@ static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
  *
  * called with rq->lock held.
  */
-static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
+static void cpuacct_charge(struct task_struct *tsk,
+		enum cpuacct_charge_index idx, u64 cputime)
 {
 	struct cpuacct *ca;
 	int cpu;
@@ -8871,7 +8884,7 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 	ca = task_ca(tsk);
 
 	for (; ca; ca = ca->parent) {
-		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu) + idx;
 		*cpuusage += cputime;
 	}
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index eed35ed..6177253 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -541,7 +541,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 		struct task_struct *curtask = task_of(curr);
 
 		trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
-		cpuacct_charge(curtask, delta_exec);
+		cpuacct_charge(curtask, CPUACCT_CHARGE_USAGE, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
 	}
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 8afb953..12adcfe 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -619,7 +619,7 @@ static void update_curr_rt(struct rq *rq)
 	account_group_exec_runtime(curr, delta_exec);
 
 	curr->se.exec_start = rq->clock;
-	cpuacct_charge(curr, delta_exec);
+	cpuacct_charge(curr, CPUACCT_CHARGE_USAGE, delta_exec);
 
 	sched_rt_avg_update(rq, delta_exec);
 
-- 
1.7.1

