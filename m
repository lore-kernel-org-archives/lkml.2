Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab0EaS5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 14:57:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:34830 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757047Ab0EaS5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 14:57:41 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, paulus@samba.org, acme@redhat.com
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Menage <menage@google.com>
Subject: [PATCH 2/4] sched: adjust when cpu_active and cpuset configurations are updated during cpu on/offlining
Date: Mon, 31 May 2010 20:56:37 +0200
Message-Id: <1275332199-28082-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1275332199-28082-1-git-send-email-tj@kernel.org>
References: <1275332199-28082-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 18:56:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when a cpu goes down, cpu_active is cleared before
CPU_DOWN_PREPARE starts and cpuset configuration is updated from a
default priority cpu notifier.  When a cpu is coming up, it's set
before CPU_ONLINE but cpuset configuration again is updated from the
same cpu notifier.

For cpu notifiers, this presents an inconsistent state.  Threads which
a CPU_DOWN_PREPARE notifier expects to be bound to the CPU can be
migrated to other cpus because the cpu is no more inactive.

Fix it by updating cpu_active in the highest priority cpu notifier and
cpuset configuration in the second highest when a cpu is coming up.
Down path is updated similarly.  This guarantees that all other cpu
notifiers see consistent cpu_active and cpuset configuration.

This problem is triggered by cmwq.  During CPU_DOWN_PREPARE, hotplug
callback creates a kthread and kthread_bind()s it to the target cpu,
and the thread is expected to run on that cpu.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Menage <menage@google.com>
---
 include/linux/cpu.h |   16 ++++++++++++++++
 kernel/cpu.c        |    6 ------
 kernel/cpuset.c     |   46 ++++++++++++++++++++++++++++------------------
 kernel/sched.c      |   31 ++++++++++++++++++++++++++++++-
 4 files changed, 74 insertions(+), 25 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 2d90738..de6b172 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -52,6 +52,22 @@ struct notifier_block;
  * CPU notifier priorities.
  */
 enum {
+	/*
+	 * SCHED_ACTIVE marks a cpu which is coming up active during
+	 * CPU_ONLINE and CPU_DOWN_FAILED and must be the first
+	 * notifier.  CPUSET_ACTIVE adjusts cpuset according to
+	 * cpu_active mask right after SCHED_ACTIVE.  During
+	 * CPU_DOWN_PREPARE, SCHED_INACTIVE and CPUSET_INACTIVE are
+	 * ordered in the similar way.
+	 *
+	 * This ordering guarantees consistent cpu_active mask and
+	 * migration behavior to all cpu notifiers.
+	 */
+	CPU_PRI_SCHED_ACTIVE	= INT_MAX,
+	CPU_PRI_CPUSET_ACTIVE	= INT_MAX - 1,
+	CPU_PRI_SCHED_INACTIVE	= INT_MIN + 1,
+	CPU_PRI_CPUSET_INACTIVE	= INT_MIN,
+
 	/* migration should happen before other stuff but after perf */
 	CPU_PRI_PERF		= 20,
 	CPU_PRI_MIGRATION	= 10,
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 5457775..69d25a7 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -211,12 +211,9 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		return -EINVAL;
 
 	cpu_hotplug_begin();
-	set_cpu_active(cpu, false);
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
-		set_cpu_active(cpu, true);
-
 		nr_calls--;
 		__raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					  hcpu, nr_calls, NULL);
@@ -228,7 +225,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
-		set_cpu_active(cpu, true);
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					    hcpu) == NOTIFY_BAD)
@@ -309,8 +305,6 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
 
-	set_cpu_active(cpu, true);
-
 	/* Now call notifier in preparation. */
 	raw_notifier_call_chain(&cpu_chain, CPU_ONLINE | mod, hcpu);
 
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 9a50c5f..2ad660c 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2071,31 +2071,17 @@ static void scan_for_empty_cpusets(struct cpuset *root)
  * but making no active use of cpusets.
  *
  * This routine ensures that top_cpuset.cpus_allowed tracks
- * cpu_online_map on each CPU hotplug (cpuhp) event.
+ * cpu_active_mask on each CPU hotplug (cpuhp) event.
  *
  * Called within get_online_cpus().  Needs to call cgroup_lock()
  * before calling generate_sched_domains().
  */
-static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
-				unsigned long phase, void *unused_cpu)
+static void cpuset_update_active_cpus(void)
 {
 	struct sched_domain_attr *attr;
 	cpumask_var_t *doms;
 	int ndoms;
 
-	switch (phase) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
-		break;
-
-	default:
-		return NOTIFY_DONE;
-	}
-
 	cgroup_lock();
 	mutex_lock(&callback_mutex);
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
@@ -2106,8 +2092,31 @@ static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
 
 	/* Have scheduler rebuild the domains */
 	partition_sched_domains(ndoms, doms, attr);
+}
 
-	return NOTIFY_OK;
+static int __cpuinit cpuset_cpu_active(struct notifier_block *nfb,
+				       unsigned long action, void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_ONLINE:
+	case CPU_DOWN_FAILED:
+		cpuset_update_active_cpus();
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
+static int __cpuexit cpuset_cpu_inactive(struct notifier_block *nfb,
+					 unsigned long action, void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_DOWN_PREPARE:
+		cpuset_update_active_cpus();
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
@@ -2161,7 +2170,8 @@ void __init cpuset_init_smp(void)
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 
-	hotcpu_notifier(cpuset_track_online_cpus, 0);
+	hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
+	hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
 	hotplug_memory_notifier(cpuset_track_online_nodes, 10);
 
 	cpuset_wq = create_singlethread_workqueue("cpuset");
diff --git a/kernel/sched.c b/kernel/sched.c
index 7f07048..80a806e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5840,17 +5840,46 @@ static struct notifier_block __cpuinitdata migration_notifier = {
 	.priority = CPU_PRI_MIGRATION,
 };
 
+static int __cpuinit sched_cpu_active(struct notifier_block *nfb,
+				      unsigned long action, void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_ONLINE:
+	case CPU_DOWN_FAILED:
+		set_cpu_active((long)hcpu, true);
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
+static int __cpuexit sched_cpu_inactive(struct notifier_block *nfb,
+					unsigned long action, void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_DOWN_PREPARE:
+		set_cpu_active((long)hcpu, false);
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
 static int __init migration_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
 	int err;
 
-	/* Start one for the boot CPU: */
+	/* Initialize migration for the boot CPU */
 	err = migration_call(&migration_notifier, CPU_UP_PREPARE, cpu);
 	BUG_ON(err == NOTIFY_BAD);
 	migration_call(&migration_notifier, CPU_ONLINE, cpu);
 	register_cpu_notifier(&migration_notifier);
 
+	/* Register cpu active notifiers */
+	cpu_notifier(sched_cpu_active, CPU_PRI_SCHED_ACTIVE);
+	cpu_notifier(sched_cpu_inactive, CPU_PRI_SCHED_INACTIVE);
+
 	return 0;
 }
 early_initcall(migration_init);
-- 
1.6.4.2

