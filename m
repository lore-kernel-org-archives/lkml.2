Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab2EMXQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 19:16:44 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:40752 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab2EMXQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 19:16:42 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 2/5] cpusets,
 hotplug: Restructure functions that are invoked during hotplug
To: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org
Cc: rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, tj@kernel.org,
        mschmidt@redhat.com, berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Mon, 14 May 2012 04:45:53 +0530
Message-ID: <20120513231531.3566.75965.stgit@srivatsabhat>
In-Reply-To: <20120513231325.3566.37740.stgit@srivatsabhat>
References: <20120513231325.3566.37740.stgit@srivatsabhat>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12051313-0260-0000-0000-0000011614B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out the cpuset related handling for CPU/Memory online/offline.
This also helps us exploit the most obvious and basic level of optimization
that any notification mechanism (CPU/Mem online/offline) has to offer us:
"We *know* why we have been invoked. So stop pretending that we are lost,
and do only the necessary amount of processing!".

And while at it, rename scan_for_empty_cpusets() to
scan_cpusets_upon_hotplug(), which will be more appropriate, considering
the upcoming changes.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
---

 include/linux/cpuset.h |    4 +-
 kernel/cpuset.c        |   91 +++++++++++++++++++++++++++++++++---------------
 kernel/sched/core.c    |    4 +-
 3 files changed, 67 insertions(+), 32 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 668f66b..838320f 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -20,7 +20,7 @@ extern int number_of_cpusets;	/* How many cpusets are defined in system? */
 
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
-extern void cpuset_update_active_cpus(void);
+extern void cpuset_update_active_cpus(bool cpu_online);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
@@ -124,7 +124,7 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}
 
-static inline void cpuset_update_active_cpus(void)
+static inline void cpuset_update_active_cpus(bool cpu_online)
 {
 	partition_sched_domains(1, NULL, NULL);
 }
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 23e5da6..87b0048 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -147,6 +147,12 @@ typedef enum {
 	CS_SPREAD_SLAB,
 } cpuset_flagbits_t;
 
+/* the type of hotplug event */
+enum hotplug_event {
+	CPUSET_CPU_OFFLINE,
+	CPUSET_MEM_OFFLINE,
+};
+
 /* convenient tests for these bits */
 static inline int is_cpu_exclusive(const struct cpuset *cs)
 {
@@ -2018,8 +2024,10 @@ static struct cpuset *traverse_cpusets(struct list_head *queue)
 
 
 /*
- * Walk the specified cpuset subtree and look for empty cpusets.
- * The tasks of such cpuset must be moved to a parent cpuset.
+ * Walk the specified cpuset subtree upon a hotplug operation (CPU/Memory
+ * online/offline) and update the cpusets accordingly.
+ * For regular CPU/Mem hotplug, look for empty cpusets; the tasks of such
+ * cpuset must be moved to a parent cpuset.
  *
  * Called with cgroup_mutex held.  We take callback_mutex to modify
  * cpus_allowed and mems_allowed.
@@ -2032,39 +2040,60 @@ static struct cpuset *traverse_cpusets(struct list_head *queue)
  * that has tasks along with an empty 'mems'.  But if we did see such
  * a cpuset, we'd handle it just like we do if its 'cpus' was empty.
  */
-static void scan_for_empty_cpusets(struct cpuset *root)
+static void
+scan_cpusets_upon_hotplug(struct cpuset *root, enum hotplug_event event)
 {
 	LIST_HEAD(queue);
-	struct cpuset *cp;	/* scans cpusets being updated */
+	struct cpuset *cp;		/* scans cpusets being updated */
 	static nodemask_t oldmems;	/* protected by cgroup_mutex */
 
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
-	while (!list_empty(&queue)) {
-		cp = traverse_cpusets(&queue);
+	switch (event) {
+	case CPUSET_CPU_OFFLINE:
+		while (!list_empty(&queue)) {
+			cp = traverse_cpusets(&queue);
 
-		/* Continue past cpusets with all cpus, mems online */
-		if (cpumask_subset(cp->cpus_allowed, cpu_active_mask) &&
-		    nodes_subset(cp->mems_allowed, node_states[N_HIGH_MEMORY]))
-			continue;
+			/* Continue past cpusets with all cpus online */
+			if (cpumask_subset(cp->cpus_allowed, cpu_active_mask))
+				continue;
 
-		oldmems = cp->mems_allowed;
+			/* Remove offline cpus from this cpuset. */
+			mutex_lock(&callback_mutex);
+			cpumask_and(cp->cpus_allowed, cp->cpus_allowed,
+							cpu_active_mask);
+			mutex_unlock(&callback_mutex);
 
-		/* Remove offline cpus and mems from this cpuset. */
-		mutex_lock(&callback_mutex);
-		cpumask_and(cp->cpus_allowed, cp->cpus_allowed,
-			    cpu_active_mask);
-		nodes_and(cp->mems_allowed, cp->mems_allowed,
+			/* Move tasks from the empty cpuset to a parent */
+			if (cpumask_empty(cp->cpus_allowed))
+				remove_tasks_in_empty_cpuset(cp);
+			else
+				update_tasks_cpumask(cp, NULL);
+		}
+		break;
+
+	case CPUSET_MEM_OFFLINE:
+		while (!list_empty(&queue)) {
+			cp = traverse_cpusets(&queue);
+
+			/* Continue past cpusets with all mems online */
+			if (nodes_subset(cp->mems_allowed,
+					node_states[N_HIGH_MEMORY]))
+				continue;
+
+			oldmems = cp->mems_allowed;
+
+			/* Remove offline mems from this cpuset. */
+			mutex_lock(&callback_mutex);
+			nodes_and(cp->mems_allowed, cp->mems_allowed,
 						node_states[N_HIGH_MEMORY]);
-		mutex_unlock(&callback_mutex);
+			mutex_unlock(&callback_mutex);
 
-		/* Move tasks from the empty cpuset to a parent */
-		if (cpumask_empty(cp->cpus_allowed) ||
-		     nodes_empty(cp->mems_allowed))
-			remove_tasks_in_empty_cpuset(cp);
-		else {
-			update_tasks_cpumask(cp, NULL);
-			update_tasks_nodemask(cp, &oldmems, NULL);
+			/* Move tasks from the empty cpuset to a parent */
+			if (nodes_empty(cp->mems_allowed))
+				remove_tasks_in_empty_cpuset(cp);
+			else
+				update_tasks_nodemask(cp, &oldmems, NULL);
 		}
 	}
 }
@@ -2080,8 +2109,11 @@ static void scan_for_empty_cpusets(struct cpuset *root)
  *
  * Called within get_online_cpus().  Needs to call cgroup_lock()
  * before calling generate_sched_domains().
+ *
+ * @cpu_online: Indicates whether this is a CPU online event (true) or
+ * a CPU offline event (false).
  */
-void cpuset_update_active_cpus(void)
+void cpuset_update_active_cpus(bool cpu_online)
 {
 	struct sched_domain_attr *attr;
 	cpumask_var_t *doms;
@@ -2091,7 +2123,10 @@ void cpuset_update_active_cpus(void)
 	mutex_lock(&callback_mutex);
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
 	mutex_unlock(&callback_mutex);
-	scan_for_empty_cpusets(&top_cpuset);
+
+	if (!cpu_online)
+		scan_cpusets_upon_hotplug(&top_cpuset, CPUSET_CPU_OFFLINE);
+
 	ndoms = generate_sched_domains(&doms, &attr);
 	cgroup_unlock();
 
@@ -2122,9 +2157,9 @@ static int cpuset_track_online_nodes(struct notifier_block *self,
 	case MEM_OFFLINE:
 		/*
 		 * needn't update top_cpuset.mems_allowed explicitly because
-		 * scan_for_empty_cpusets() will update it.
+		 * scan_cpusets_upon_hotplug() will update it.
 		 */
-		scan_for_empty_cpusets(&top_cpuset);
+		scan_cpusets_upon_hotplug(&top_cpuset, CPUSET_MEM_OFFLINE);
 		break;
 	default:
 		break;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0533a68..55cfe8c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6812,7 +6812,7 @@ static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
-		cpuset_update_active_cpus();
+		cpuset_update_active_cpus(true);
 		return NOTIFY_OK;
 	default:
 		return NOTIFY_DONE;
@@ -6824,7 +6824,7 @@ static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
-		cpuset_update_active_cpus();
+		cpuset_update_active_cpus(false);
 		return NOTIFY_OK;
 	default:
 		return NOTIFY_DONE;

