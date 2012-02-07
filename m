Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab2BGS56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:57:58 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:52533 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533Ab2BGS54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:57:56 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 4/4] CPU hotplug,
 cpusets: Differentiate the CPU online and CPU offline callbacks
To: paul@paulmenage.org, a.p.zijlstra@chello.nl, mingo@elte.hu, rjw@sisk.pl,
        tj@kernel.org
Cc: frank.rowand@am.sony.com, pjt@google.com, tglx@linutronix.de,
        lizf@cn.fujitsu.com, prashanth@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Wed, 08 Feb 2012 00:27:36 +0530
Message-ID: <20120207185717.7482.45388.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
References: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12020718-5816-0000-0000-0000013321A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call scan_cpusets_during_cpu_online() upon CPU online events and
call scan_for_empty_cpusets() upon CPU offline events.

Reported-by: Prashanth K. Nageshappa <prashanth@linux.vnet.ibm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
---

 include/linux/cpuset.h |    4 ++--
 kernel/cpuset.c        |    9 +++++++--
 kernel/sched/core.c    |   12 ++++++++++--
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index e9eaec5..acfe484 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -20,7 +20,7 @@ extern int number_of_cpusets;	/* How many cpusets are defined in system? */
 
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
-extern void cpuset_update_active_cpus(void);
+extern void cpuset_update_active_cpus(bool cpu_online);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern int cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
@@ -133,7 +133,7 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}
 
-static inline void cpuset_update_active_cpus(void)
+static inline void cpuset_update_active_cpus(bool cpu_online)
 {
 	partition_sched_domains(1, NULL, NULL);
 }
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index c56e705..d863df5 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2223,8 +2223,10 @@ static void scan_for_empty_cpusets(struct cpuset *root)
  *
  * Called within get_online_cpus().  Needs to call cgroup_lock()
  * before calling generate_sched_domains().
+ *
+ * @cpu_online: whether this is a CPU online event or a CPU offline event.
  */
-void cpuset_update_active_cpus(void)
+void cpuset_update_active_cpus(bool cpu_online)
 {
 	struct sched_domain_attr *attr;
 	cpumask_var_t *doms;
@@ -2234,7 +2236,10 @@ void cpuset_update_active_cpus(void)
 	mutex_lock(&callback_mutex);
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
 	mutex_unlock(&callback_mutex);
-	scan_for_empty_cpusets(&top_cpuset);
+	if (cpu_online)
+		scan_cpusets_during_cpu_online(&top_cpuset);
+	else
+		scan_for_empty_cpusets(&top_cpuset);
 	ndoms = generate_sched_domains(&doms, &attr);
 	cgroup_unlock();
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5255c9d..d4dd9ef 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6732,7 +6732,11 @@ static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
-		cpuset_update_active_cpus();
+		/*
+		 * The 'true' value indicates that we are calling the function
+		 * due to a CPU online operation in progress.
+		 */
+		cpuset_update_active_cpus(true);
 		return NOTIFY_OK;
 	default:
 		return NOTIFY_DONE;
@@ -6744,7 +6748,11 @@ static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
-		cpuset_update_active_cpus();
+		/*
+		 * The 'false' value indicates that we are calling the function
+		 * due to a CPU offline operation in progress.
+		 */
+		cpuset_update_active_cpus(false);
 		return NOTIFY_OK;
 	default:
 		return NOTIFY_DONE;

