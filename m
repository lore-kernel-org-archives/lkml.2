Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab1INUFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:05:53 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:45798 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140Ab1INUFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:05:50 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: xemul@parallels.com, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, mingo@elte.hu, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH 2/9] Make cpuacct fields per cpu variables
Date: Wed, 14 Sep 2011 17:04:48 -0300
Message-Id: <1316030695-19826-3-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316030695-19826-1-git-send-email-glommer@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn them from percpu counters to normal per cpu variables.
It will be useful in later patches

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/sched.c |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4cde3eb..8fd3f8b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9095,7 +9095,7 @@ struct cpuacct {
 	struct cgroup_subsys_state css;
 	/* cpuusage holds pointer to a u64-type object on every cpu */
 	u64 __percpu *cpuusage;
-	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
+	u64 __percpu *cpustat;
 };
 
 struct cgroup_subsys cpuacct_subsys;
@@ -9129,7 +9129,6 @@ static struct cgroup_subsys_state *cpuacct_create(
 	struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	struct cpuacct *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
-	int i;
 
 	if (!ca)
 		goto out;
@@ -9138,15 +9137,13 @@ static struct cgroup_subsys_state *cpuacct_create(
 	if (!ca->cpuusage)
 		goto out_free_ca;
 
-	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
-		if (percpu_counter_init(&ca->cpustat[i], 0))
-			goto out_free_counters;
+	ca->cpustat = __alloc_percpu(sizeof(u64) * CPUACCT_STAT_NSTATS, __alignof__(u64));
+	if (!ca->cpustat)
+		goto out_free_usage;
 
 	return &ca->css;
 
-out_free_counters:
-	while (--i >= 0)
-		percpu_counter_destroy(&ca->cpustat[i]);
+out_free_usage:
 	free_percpu(ca->cpuusage);
 out_free_ca:
 	kfree(ca);
@@ -9159,10 +9156,8 @@ static void
 cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	struct cpuacct *ca = cgroup_ca(cgrp);
-	int i;
 
-	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
-		percpu_counter_destroy(&ca->cpustat[i]);
+	free_percpu(ca->cpustat);
 	free_percpu(ca->cpuusage);
 	kfree(ca);
 }
@@ -9258,11 +9253,17 @@ static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
 		struct cgroup_map_cb *cb)
 {
 	struct cpuacct *ca = cgroup_ca(cgrp);
-	int i;
+	int i, cpu;
+	u64 acc[CPUACCT_STAT_NSTATS] = { 0, };
+
+	for_each_present_cpu(cpu) {
+		u64 *vec = per_cpu_ptr(ca->cpustat, cpu);
+		for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
+			acc[i] += vec[i];
+	}
 
 	for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
-		s64 val = percpu_counter_read(&ca->cpustat[i]);
-		val = cputime64_to_clock_t(val);
+		s64 val = cputime64_to_clock_t(acc[i]);
 		cb->fill(cb, cpuacct_stat_desc[i], val);
 	}
 	return 0;
@@ -9340,7 +9341,7 @@ static void cpuacct_update_stats(struct task_struct *tsk,
 		enum cpuacct_stat_index idx, cputime_t val)
 {
 	struct cpuacct *ca;
-	int batch = CPUACCT_BATCH;
+	u64 *cpustat;
 
 	if (unlikely(!cpuacct_subsys.active))
 		return;
@@ -9349,7 +9350,8 @@ static void cpuacct_update_stats(struct task_struct *tsk,
 	ca = task_ca(tsk);
 
 	do {
-		__percpu_counter_add(&ca->cpustat[idx], val, batch);
+		cpustat = per_cpu_ptr(ca->cpustat, smp_processor_id());
+		cpustat[idx] +=  val;
 		ca = parent_ca(ca);
 	} while (ca);
 	rcu_read_unlock();
-- 
1.7.6

