Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab0FHTqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:46:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:54195 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab0FHTqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:46:30 -0400
Message-ID: <4C0E9E03.1010508@kernel.org>
Date: Tue, 08 Jun 2010 21:46:11 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH UPDATED] sched: adjust when cpu_active and cpuset configurations
 are updated during cpu on/offlining
References: <4C08FF36.80806@kernel.org>
In-Reply-To: <4C08FF36.80806@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Jun 2010 19:46:14 +0000 (UTC)
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

* Ingo's test discovered __cpuinit/exit markups were incorrect.
  Fixed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Menage <menage@google.com>
---
The second patch incorrectly labeled sched_cpu_inactive() with
__cpuexit while unnecessarily labeling cpuset notifiers __cpuinit
instead of __cpuexit.  This triggered notifier warnings during
!HOTPLUG_CPU testing by Ingo.  Fixed.  Git tree is updated
accordingly.

Thanks.

 include/linux/cpu.h    |   16 +++++++++++
 include/linux/cpuset.h |    6 ++++
 kernel/cpu.c           |    6 ----
 kernel/cpuset.c        |   21 +-------------
 kernel/sched.c         |   67 +++++++++++++++++++++++++++++++++++------------
 5 files changed, 74 insertions(+), 42 deletions(-)

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
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 457ed76..f20eb8f 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -20,6 +20,7 @@ extern int number_of_cpusets;	/* How many cpusets are defined in system? */

 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
+extern void cpuset_update_active_cpus(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern int cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
@@ -132,6 +133,11 @@ static inline void set_mems_allowed(nodemask_t nodemask)
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
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 97d1b42..f6e726f 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -235,11 +235,8 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		return -EINVAL;

 	cpu_hotplug_begin();
-	set_cpu_active(cpu, false);
 	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (err) {
-		set_cpu_active(cpu, true);
-
 		nr_calls--;
 		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
 		printk("%s: attempt to take down CPU %u failed\n",
@@ -249,7 +246,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)

 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
-		set_cpu_active(cpu, true);
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);

@@ -321,8 +317,6 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));

-	set_cpu_active(cpu, true);
-
 	/* Now call notifier in preparation. */
 	cpu_notify(CPU_ONLINE | mod, hcpu);

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 02b9611..05727dc 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2113,31 +2113,17 @@ static void scan_for_empty_cpusets(struct cpuset *root)
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
+void __cpuexit cpuset_update_active_cpus(void)
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
@@ -2148,8 +2134,6 @@ static int cpuset_track_online_cpus(struct notifier_block *unused_nb,

 	/* Have scheduler rebuild the domains */
 	partition_sched_domains(ndoms, doms, attr);
-
-	return NOTIFY_OK;
 }

 #ifdef CONFIG_MEMORY_HOTPLUG
@@ -2203,7 +2187,6 @@ void __init cpuset_init_smp(void)
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];

-	hotcpu_notifier(cpuset_track_online_cpus, 0);
 	hotplug_memory_notifier(cpuset_track_online_nodes, 10);

 	cpuset_wq = create_singlethread_workqueue("cpuset");
diff --git a/kernel/sched.c b/kernel/sched.c
index 552faf8..2b942e4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5804,17 +5804,46 @@ static struct notifier_block __cpuinitdata migration_notifier = {
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
+static int __cpuinit sched_cpu_inactive(struct notifier_block *nfb,
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
@@ -7273,29 +7302,35 @@ int __init sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
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
+static int __cpuexit cpuset_cpu_active(struct notifier_block *nfb,
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
@@ -7341,10 +7376,8 @@ void __init sched_init_smp(void)
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
-- 
1.6.4.2

