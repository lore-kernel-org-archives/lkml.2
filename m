Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2EMXRo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 19:17:44 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41118 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab2EMXRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 19:17:42 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 4/5] cpusets: Add provisions for distinguishing CPU Hotplug
 in suspend/resume path
To: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org
Cc: rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, tj@kernel.org,
        mschmidt@redhat.com, berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Mon, 14 May 2012 04:46:54 +0530
Message-ID: <20120513231638.3566.30867.stgit@srivatsabhat>
In-Reply-To: <20120513231325.3566.37740.stgit@srivatsabhat>
References: <20120513231325.3566.37740.stgit@srivatsabhat>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12051313-7014-0000-0000-0000011B69F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cpusets needs to distinguish between a regular CPU Hotplug operation and a
CPU Hotplug operation carried out as part of the suspend/resume sequence.
So add provisions to facilitate that, so that the two operations can be
handled differently.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
---

 include/linux/cpuset.h |    2 +-
 kernel/cpuset.c        |   19 ++++++++++++++++---
 kernel/sched/core.c    |   29 +++++++++++++++++++++++------
 3 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 838320f..184cb94 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -20,7 +20,7 @@ extern int number_of_cpusets;	/* How many cpusets are defined in system? */
 
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
-extern void cpuset_update_active_cpus(bool cpu_online);
+extern void cpuset_update_active_cpus(bool cpu_online, bool frozen);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 0fb9bff..0723183 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -151,6 +151,8 @@ typedef enum {
 enum hotplug_event {
 	CPUSET_CPU_OFFLINE,
 	CPUSET_CPU_ONLINE,
+	CPUSET_CPU_OFFLINE_FROZEN,
+	CPUSET_CPU_ONLINE_FROZEN,
 	CPUSET_MEM_OFFLINE,
 };
 
@@ -2077,6 +2079,12 @@ scan_cpusets_upon_hotplug(struct cpuset *root, enum hotplug_event event)
 		}
 		break;
 
+	case CPUSET_CPU_OFFLINE_FROZEN:
+		break;
+
+	case CPUSET_CPU_ONLINE_FROZEN:
+		break;
+
 	case CPUSET_CPU_ONLINE:
 		/*
 		 * Restore only the top_cpuset because it has to track
@@ -2132,19 +2140,24 @@ scan_cpusets_upon_hotplug(struct cpuset *root, enum hotplug_event event)
  *
  * @cpu_online: Indicates whether this is a CPU online event (true) or
  * a CPU offline event (false).
+ * @frozen: Indicates whether the tasks are frozen (true) or not (false)
+ * Frozen tasks indicates a CPU hotplug operation in the suspend/resume path.
  */
-void cpuset_update_active_cpus(bool cpu_online)
+void cpuset_update_active_cpus(bool cpu_online, bool frozen)
 {
 	struct sched_domain_attr *attr;
+	enum hotplug_event event;
 	cpumask_var_t *doms;
 	int ndoms;
 
 	cgroup_lock();
 
 	if (cpu_online)
-		scan_cpusets_upon_hotplug(&top_cpuset, CPUSET_CPU_ONLINE);
+		event = frozen ? CPUSET_CPU_ONLINE_FROZEN : CPUSET_CPU_ONLINE;
 	else
-		scan_cpusets_upon_hotplug(&top_cpuset, CPUSET_CPU_OFFLINE);
+		event = frozen ? CPUSET_CPU_OFFLINE_FROZEN : CPUSET_CPU_OFFLINE;
+
+	scan_cpusets_upon_hotplug(&top_cpuset, event);
 
 	ndoms = generate_sched_domains(&doms, &attr);
 	cgroup_unlock();
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 55cfe8c..08463d5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6809,26 +6809,43 @@ int __init sched_create_sysfs_power_savings_entries(struct device *dev)
 static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
 			     void *hcpu)
 {
-	switch (action & ~CPU_TASKS_FROZEN) {
+	bool frozen;
+
+	switch (action) {
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
-		cpuset_update_active_cpus(true);
-		return NOTIFY_OK;
+		frozen = false;
+		break;
+	case CPU_ONLINE_FROZEN:
+	case CPU_DOWN_FAILED_FROZEN:
+		frozen = true;
+		break;
 	default:
 		return NOTIFY_DONE;
 	}
+
+	cpuset_update_active_cpus(true, frozen);
+	return NOTIFY_OK;
 }
 
 static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
 			       void *hcpu)
 {
-	switch (action & ~CPU_TASKS_FROZEN) {
+	bool frozen;
+
+	switch (action) {
 	case CPU_DOWN_PREPARE:
-		cpuset_update_active_cpus(false);
-		return NOTIFY_OK;
+		frozen = false;
+		break;
+	case CPU_DOWN_PREPARE_FROZEN:
+		frozen = true;
+		break;
 	default:
 		return NOTIFY_DONE;
 	}
+
+	cpuset_update_active_cpus(false, frozen);
+	return NOTIFY_OK;
 }
 
 void __init sched_init_smp(void)

