Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab2GYLyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:54:47 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:38558 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab2GYLyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:54:44 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 4/6] sched,
 cpuset: Prepare scheduler and cpuset CPU hotplug callbacks for
 reverse invocation
To: tglx@linutronix.de, mingo@kernel.org, peterz@infradead.org,
        rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, namhyung@kernel.org,
        tj@kernel.org
Cc: rjw@sisk.pl, srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Jul 2012 17:24:34 +0530
Message-ID: <20120725115415.3900.87325.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120725115224.3900.80783.stgit@srivatsabhat.in.ibm.com>
References: <20120725115224.3900.80783.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12072511-4790-0000-0000-000003D9ACC2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the CPU hotplug callbacks of the scheduler and cpuset infrastructure are
intertwined in an interesting way. The scheduler's sched_cpu_[in]active()
callbacks and cpuset's cpuset_cpu_[in]active() callbacks have the following
documented dependency:

The sched_cpu_active() callback must be the first callback to run, and
should be immediately followed by cpuset_cpu_active() to update the
cpusets and the sched domains. This ordering (sched followed by cpuset)
needs to be honored in both the CPU online *and* the CPU offline paths.
Hence its not straightforward to convert these callbacks to the reverse
invocation model, because, a plain conversion would result in the problem
explained below.

In general, if 2 notifiers A and B expect to be -always- called in the order
A followed by B, ie., during both CPU online and CPU offline, then we can't
ensure that easily because, when we do reverse invocation, we get the
following call path:

Event        |     Invocation order
-------------|---------------------
CPU online:  | A (high priority), B (low priority)
CPU offline: | B (low priority), A (high priority)

So this breaks the requirement for A and B. We see this ordering requirement
in the case of the scheduler and cpusets.

So, to solve this, club the 2 callbacks together as a unit, so that they
are always invoked as a unit, which means, forward or reverse, the requirement
is satisfied. In this case, since the 2 callbacks are quite related, it
doesn't break semantics/readability if we club them together, which is a good
thing!

There is a one more aspect that we need to take care of while clubbing the two
callbacks. During boot, the scheduler is initialized in two phases:
sched_init(), which happens before SMP initialization (and hence *before* the
non-boot CPUs are booted up), and sched_init_smp(), which happens after SMP
initialization (and hence *after* the non-boot CPUs are booted).

In the original code, the cpuset callbacks are registered during
sched_init_smp(), which means that while starting the non-boot CPUs, only the
scheduler callbacks are invoked, not the cpuset ones. So in order to keep
this intact even after clubbing the 2 callbacks, we need to be able to find out
if we are running post-SMP init or if we are running pre-SMP early boot code,
to decide whether to pass on control to the cpuset callback or not. So introduce
a flag 'sched_smp_init_complete' that gets set after the scheduler is
initialized for SMP. This would help us in making that decision.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/cpu.h |   16 ++++-----
 kernel/sched/core.c |   89 ++++++++++++++++++++++++++++++---------------------
 2 files changed, 59 insertions(+), 46 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index ce7a074..255b889 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -55,20 +55,18 @@ extern ssize_t arch_print_cpu_modalias(struct device *dev,
  */
 enum {
 	/*
-	 * SCHED_ACTIVE marks a cpu which is coming up active during
-	 * CPU_ONLINE and CPU_DOWN_FAILED and must be the first
-	 * notifier.  CPUSET_ACTIVE adjusts cpuset according to
-	 * cpu_active mask right after SCHED_ACTIVE.  During
-	 * CPU_DOWN_PREPARE, SCHED_INACTIVE and CPUSET_INACTIVE are
-	 * ordered in the similar way.
+	 * SCHED_ACTIVE marks a cpu which is coming up active during CPU_ONLINE
+	 * and CPU_DOWN_FAILED and must be the first notifier.  It then passes
+	 * control to the cpuset_cpu_active() notifier which adjusts cpusets
+	 * according to cpu_active mask. During CPU_DOWN_PREPARE, SCHED_INACTIVE
+	 * marks the cpu as inactive and passes control to the
+	 * cpuset_cpu_inactive() notifier in a similar way.
 	 *
 	 * This ordering guarantees consistent cpu_active mask and
 	 * migration behavior to all cpu notifiers.
 	 */
 	CPU_PRI_SCHED_ACTIVE	= INT_MAX,
-	CPU_PRI_CPUSET_ACTIVE	= INT_MAX - 1,
-	CPU_PRI_SCHED_INACTIVE	= INT_MIN + 1,
-	CPU_PRI_CPUSET_INACTIVE	= INT_MIN,
+	CPU_PRI_SCHED_INACTIVE	= INT_MIN,
 
 	/* migration should happen before other stuff but after perf */
 	CPU_PRI_PERF		= 20,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d5594a4..9ccebdd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -280,6 +280,7 @@ const_debug unsigned int sysctl_sched_time_avg = MSEC_PER_SEC;
 unsigned int sysctl_sched_rt_period = 1000000;
 
 __read_mostly int scheduler_running;
+static bool __read_mostly sched_smp_init_complete;
 
 /*
  * part of the period that we allow rt tasks to run in us.
@@ -5505,29 +5506,75 @@ static struct notifier_block __cpuinitdata migration_notifier = {
 	.priority = CPU_PRI_MIGRATION,
 };
 
+/*
+ * Update cpusets according to cpu_active mask.  If cpusets are
+ * disabled, cpuset_update_active_cpus() becomes a simple wrapper
+ * around partition_sched_domains().
+ */
+static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
+			     void *hcpu)
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
+static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
+			       void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_DOWN_PREPARE:
+		cpuset_update_active_cpus();
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
 static int __cpuinit sched_cpu_active(struct notifier_block *nfb,
 				      unsigned long action, void *hcpu)
 {
+	int ret;
+
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_STARTING:
 	case CPU_DOWN_FAILED:
 		set_cpu_active((long)hcpu, true);
-		return NOTIFY_OK;
+		ret = NOTIFY_OK;
+		break;
 	default:
-		return NOTIFY_DONE;
+		ret = NOTIFY_DONE;
 	}
+
+	if (likely(sched_smp_init_complete))
+		return cpuset_cpu_active(nfb, action, hcpu);
+
+	return ret;
 }
 
 static int __cpuinit sched_cpu_inactive(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
+	int ret;
+
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
 		set_cpu_active((long)hcpu, false);
-		return NOTIFY_OK;
+		ret = NOTIFY_OK;
+		break;
 	default:
-		return NOTIFY_DONE;
+		ret = NOTIFY_DONE;
 	}
+
+	if (likely(sched_smp_init_complete))
+		return cpuset_cpu_inactive(nfb, action, hcpu);
+
+	return ret;
 }
 
 static int __init migration_init(void)
@@ -6967,36 +7014,6 @@ match2:
 	mutex_unlock(&sched_domains_mutex);
 }
 
-/*
- * Update cpusets according to cpu_active mask.  If cpusets are
- * disabled, cpuset_update_active_cpus() becomes a simple wrapper
- * around partition_sched_domains().
- */
-static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
-			     void *hcpu)
-{
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_ONLINE:
-	case CPU_DOWN_FAILED:
-		cpuset_update_active_cpus();
-		return NOTIFY_OK;
-	default:
-		return NOTIFY_DONE;
-	}
-}
-
-static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
-			       void *hcpu)
-{
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_DOWN_PREPARE:
-		cpuset_update_active_cpus();
-		return NOTIFY_OK;
-	default:
-		return NOTIFY_DONE;
-	}
-}
-
 void __init sched_init_smp(void)
 {
 	cpumask_var_t non_isolated_cpus;
@@ -7015,9 +7032,6 @@ void __init sched_init_smp(void)
 	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
 
-	hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
-	hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
-
 	/* RT runtime code needs to handle some hotplug events */
 	hotcpu_notifier(update_runtime, 0);
 
@@ -7030,6 +7044,7 @@ void __init sched_init_smp(void)
 	free_cpumask_var(non_isolated_cpus);
 
 	init_sched_rt_class();
+	sched_smp_init_complete = true;
 }
 #else
 void __init sched_init_smp(void)

