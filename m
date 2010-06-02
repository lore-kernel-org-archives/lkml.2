Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab0FBQEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 12:04:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:46794 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757971Ab0FBQEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 12:04:07 -0400
Message-ID: <4C0680DB.9010503@kernel.org>
Date: Wed, 02 Jun 2010 18:03:39 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       paulus@samba.org, acme@redhat.com, Paul Menage <menage@google.com>
Subject: [PATCH UPDATED 2/4] sched: adjust when cpu_active and cpuset configurations
 are updated during cpu on/offlining
References: <1275332199-28082-1-git-send-email-tj@kernel.org>	 <1275332199-28082-3-git-send-email-tj@kernel.org>	 <1275407846.27810.27627.camel@twins>  <4C053C39.9070405@kernel.org> <1275412835.27810.27887.camel@twins>
In-Reply-To: <1275412835.27810.27887.camel@twins>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Jun 2010 16:03:42 +0000 (UTC)
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

cpuset_track_online_cpus() notifier is converted to
cpuset_update_active_cpus() which just updates the configuration and
now called from cpuset_cpu_[in]active() notifiers registered from
sched_init_smp().  If cpuset is disabled, cpuset_update_active_cpus()
degenerates into partition_sched_domains() making separate notifier
for !CONFIG_CPUSETS unnecessary.

This problem is triggered by cmwq.  During CPU_DOWN_PREPARE, hotplug
callback creates a kthread and kthread_bind()s it to the target cpu,
and the thread is expected to run on that cpu.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Menage <menage@google.com>
---
Okay, how about this one?  Using notifiers seems better for the
following reasons.

* Rollback on failure.

* cpuset/sched_domain don't expect to be called before smp
  configuration is complete.  If hardcoded into cpu_up/down(),
  condition checks need to be added so that they're skipped if the
  system is bringing up the cpus for the first time.

Works fine here w/ CPUSET enabled and disabled.

Thanks.

 include/linux/cpu.h    |   16 +++++++++++
 include/linux/cpuset.h |    6 ++++
 kernel/cpu.c           |    6 ----
 kernel/cpuset.c        |   21 +--------------
 kernel/sched.c         |   67 ++++++++++++++++++++++++++++++++++++-------------
 5 files changed, 74 insertions(+), 42 deletions(-)

Index: work/include/linux/cpu.h
===================================================================
--- work.orig/include/linux/cpu.h
+++ work/include/linux/cpu.h
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
Index: work/kernel/cpu.c
===================================================================
--- work.orig/kernel/cpu.c
+++ work/kernel/cpu.c
@@ -211,12 +211,9 @@ static int __ref _cpu_down(unsigned int
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
@@ -228,7 +225,6 @@ static int __ref _cpu_down(unsigned int

 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
-		set_cpu_active(cpu, true);
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					    hcpu) == NOTIFY_BAD)
@@ -309,8 +305,6 @@ static int __cpuinit _cpu_up(unsigned in
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));

-	set_cpu_active(cpu, true);
-
 	/* Now call notifier in preparation. */
 	raw_notifier_call_chain(&cpu_chain, CPU_ONLINE | mod, hcpu);

Index: work/kernel/cpuset.c
===================================================================
--- work.orig/kernel/cpuset.c
+++ work/kernel/cpuset.c
@@ -2071,31 +2071,17 @@ static void scan_for_empty_cpusets(struc
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
+void cpuset_update_active_cpus(void)
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
@@ -2106,8 +2092,6 @@ static int cpuset_track_online_cpus(stru

 	/* Have scheduler rebuild the domains */
 	partition_sched_domains(ndoms, doms, attr);
-
-	return NOTIFY_OK;
 }

 #ifdef CONFIG_MEMORY_HOTPLUG
@@ -2161,7 +2145,6 @@ void __init cpuset_init_smp(void)
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];

-	hotcpu_notifier(cpuset_track_online_cpus, 0);
 	hotplug_memory_notifier(cpuset_track_online_nodes, 10);

 	cpuset_wq = create_singlethread_workqueue("cpuset");
Index: work/kernel/sched.c
===================================================================
--- work.orig/kernel/sched.c
+++ work/kernel/sched.c
@@ -5840,17 +5840,46 @@ static struct notifier_block __cpuinitda
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
@@ -7309,29 +7338,35 @@ int __init sched_create_sysfs_power_savi
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */

-#ifndef CONFIG_CPUSETS
 /*
- * Add online and remove offline CPUs from the scheduler domains.
- * When cpusets are enabled they take over this function.
+ * Update cpusets according to cpu_active mask.  If cpusets are
+ * disabled, cpuset_update_active_cpus() becomes a simple wrapper
+ * around partition_sched_domains().
  */
-static int update_sched_domains(struct notifier_block *nfb,
-				unsigned long action, void *hcpu)
+static int __cpuinit cpuset_cpu_active(struct notifier_block *nfb,
+				       unsigned long action, void *hcpu)
 {
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
 	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
-		partition_sched_domains(1, NULL, NULL);
+		cpuset_update_active_cpus();
 		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}

+static int __cpuexit cpuset_cpu_inactive(struct notifier_block *nfb,
+					 unsigned long action, void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_DOWN_PREPARE:
+		cpuset_update_active_cpus();
+		return NOTIFY_OK;
 	default:
 		return NOTIFY_DONE;
 	}
 }
-#endif

 static int update_runtime(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
@@ -7377,10 +7412,8 @@ void __init sched_init_smp(void)
 	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();

-#ifndef CONFIG_CPUSETS
-	/* XXX: Theoretical race here - CPU may be hotplugged now */
-	hotcpu_notifier(update_sched_domains, 0);
-#endif
+	hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
+	hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);

 	/* RT runtime code needs to handle some hotplug events */
 	hotcpu_notifier(update_runtime, 0);
Index: work/include/linux/cpuset.h
===================================================================
--- work.orig/include/linux/cpuset.h
+++ work/include/linux/cpuset.h
@@ -20,6 +20,7 @@ extern int number_of_cpusets;	/* How man

 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
+extern void cpuset_update_active_cpus(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern int cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
@@ -96,6 +97,11 @@ static inline void set_mems_allowed(node
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}

+static inline void cpuset_update_active_cpus(void)
+{
+	partition_sched_domains(1, NULL, NULL);
+}
+
 static inline void cpuset_cpus_allowed(struct task_struct *p,
 				       struct cpumask *mask)
 {
