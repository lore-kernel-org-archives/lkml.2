Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab2EDTTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:19:30 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:43207 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759391Ab2EDTT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:19:28 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 3/7] cpusets: Introduce 'user_cpus_allowed' and rework the
 semantics of 'cpus_allowed'
To: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org
Cc: rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Sat, 05 May 2012 00:48:43 +0530
Message-ID: <20120504191825.4603.55302.stgit@srivatsabhat>
In-Reply-To: <20120504191535.4603.83236.stgit@srivatsabhat>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12050409-1396-0000-0000-00000118734C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel doesn't do a good job of differentiating the following 2 events:
   a. altering a cpuset's cpus_allowed mask, as per user request
   b. a CPU hotplug operation.

As a result, we have the following painpoints:
1. The cpuset configurations set by the user goes haywire after CPU Hotplug,
   most noticeably after a suspend/resume or hibernation/restore.
   This is because the kernel tries to accommodate its workload on available
   hardware resources (online cpus) upon a CPU hotplug event, and in the
   meantime, forgets about the user's original preferences for the cpuset.

2. It gets worse than that. The kernel chooses to *move* tasks from one cpuset
   to another in case of unfavourable CPU Hotplug operations. This is even
   more irksome from the user's point of view.

Of course, in doing all this, the kernel was only trying to help the user,
but it turns out that it is more of a pain than anything useful. However,
luckily, this problem _can_ be solved properly, while still being "correct"
in both the user's as well as the kernel's point of view.

That solution follows, which can be logically summarized as:-
1. The kernel will remember the cpuset's cpus_allowed mask set by the user
   and will not alter it. (It can be altered only by an explicit request
   by the user, by writing to the cpuset.cpus file.)

2. When CPU Hotplug events occur, the kernel will try to run the tasks on
   the remaining online cpus in that cpuset.

   ie., mask = (cpus_allowed mask set by user) & (cpu_active_mask)

   However, when the last online cpu in that cpuset is taken offline, the
   kernel will run these tasks on the set of online cpus pertaining to some
   parent cpuset. So here, the change from existing behaviour is only this:
   instead of *moving* the tasks to a parent cpuset, we retain them in their
   cpusets, and run them on the parent cpuset's cpu mask. This solves
   painpoint #2.

3. However, we don't want to keep the user in the dark, as to what cpus
   the tasks in the cpuset are actually running on. So, the kernel exposes
   a new per-cpuset file that indicates the true internal state of affairs -
   the set of cpus that the tasks in the cpuset are actually running on.
   (This is nothing but 'mask' mentioned in the equation above).

4. Because of the mask calculation shown above, cpu offline + cpu online,
   or suspend/resume etc are automatically handled: if a cpu goes offline
   it is removed from the cpuset; if it comes back online, it is added to
   the cpuset. No surprises! All in all, this solves painpoint #1.


Implementation details:
----------------------

To properly handle updates to cpusets during CPU Hotplug, introduce a new
per-cpuset mask called user_cpus_allowed, and also expose a new per-cpuset
file in userspace called cpuset.actual_cpus with the following semantics:

Userspace file				             Kernel variable/mask
==============				             ====================
cpuset.cpus         	   <= will map to =>	     user_cpus_allowed(new)
cpuset.actual_cpus(new)    <= will map to =>	     cpus_allowed

The user_cpus_allowed mask will be used to track the user's preferences for
the cpuset. That is, the kernel will update it upon writes to the .cpus file,
but not during CPU hotplug events. That way, the mask will always represent
the user set preferences for the cpuset.

The cpus_allowed mask will begin by reflecting the user_cpus_allowed mask.
However, during CPU hotplug events, the kernel is free to update this mask
suitably to ensure that the tasks in the cpuset have atleast one online CPU
to run on.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
---

 kernel/cpuset.c |  140 ++++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 112 insertions(+), 28 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index f1de35b..4bafbc4 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -92,7 +92,25 @@ struct cpuset {
 	struct cgroup_subsys_state css;
 
 	unsigned long flags;		/* "unsigned long" so bitops work */
-	cpumask_var_t cpus_allowed;	/* CPUs allowed to tasks in cpuset */
+
+	/*
+	 * CPUs allowed to tasks in this cpuset, as per user preference. The
+	 * kernel doesn't modify this inspite of CPU hotplug events. Modified
+	 * only upon explicit user request (ie., upon writes to the cpuset's
+	 * .cpus file).
+	 * Reflected in userspace as (r/w) cpuset.cpus file.
+	 */
+	cpumask_var_t user_cpus_allowed;
+
+	/*
+	 * CPUs that the tasks in this cpuset can actually run on. To begin
+	 * with, it is the same as user_cpus_allowed. But in the case of CPU
+	 * hotplug events, the kernel is free to modify this mask, to ensure
+	 * that the tasks run on *some* CPU.
+	 * Reflected in userspace as the (read-only) cpuset.actual_cpus file.
+	 */
+	cpumask_var_t cpus_allowed;
+
 	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
 
 	struct cpuset *parent;		/* my parent */
@@ -272,7 +290,7 @@ static struct file_system_type cpuset_fs_type = {
 };
 
 /*
- * Return in pmask the portion of a cpusets's cpus_allowed that
+ * Return in pmask the portion of a cpusets's user_cpus_allowed that
  * are online.  If none are online, walk up the cpuset hierarchy
  * until we find one that does have some online cpus.  If we get
  * all the way to the top and still haven't found any online cpus,
@@ -288,10 +306,12 @@ static struct file_system_type cpuset_fs_type = {
 static void guarantee_online_cpus(const struct cpuset *cs,
 				  struct cpumask *pmask)
 {
-	while (cs && !cpumask_intersects(cs->cpus_allowed, cpu_online_mask))
+	while (cs && !cpumask_intersects(cs->user_cpus_allowed,
+							cpu_online_mask))
 		cs = cs->parent;
+
 	if (cs)
-		cpumask_and(pmask, cs->cpus_allowed, cpu_online_mask);
+		cpumask_and(pmask, cs->user_cpus_allowed, cpu_online_mask);
 	else
 		cpumask_copy(pmask, cpu_online_mask);
 	BUG_ON(!cpumask_intersects(pmask, cpu_online_mask));
@@ -351,7 +371,7 @@ static void cpuset_update_task_spread_flag(struct cpuset *cs,
 
 static int is_cpuset_subset(const struct cpuset *p, const struct cpuset *q)
 {
-	return	cpumask_subset(p->cpus_allowed, q->cpus_allowed) &&
+	return	cpumask_subset(p->user_cpus_allowed, q->user_cpus_allowed) &&
 		nodes_subset(p->mems_allowed, q->mems_allowed) &&
 		is_cpu_exclusive(p) <= is_cpu_exclusive(q) &&
 		is_mem_exclusive(p) <= is_mem_exclusive(q);
@@ -369,13 +389,23 @@ static struct cpuset *alloc_trial_cpuset(const struct cpuset *cs)
 	if (!trial)
 		return NULL;
 
-	if (!alloc_cpumask_var(&trial->cpus_allowed, GFP_KERNEL)) {
-		kfree(trial);
-		return NULL;
-	}
+	if (!alloc_cpumask_var(&trial->user_cpus_allowed, GFP_KERNEL))
+		goto out_trial;
+
+	if (!alloc_cpumask_var(&trial->cpus_allowed, GFP_KERNEL))
+		goto out_user_cpus_allowed;
+
+	cpumask_copy(trial->user_cpus_allowed, cs->user_cpus_allowed);
 	cpumask_copy(trial->cpus_allowed, cs->cpus_allowed);
 
 	return trial;
+
+ out_user_cpus_allowed:
+	free_cpumask_var(trial->user_cpus_allowed);
+
+ out_trial:
+	kfree(trial);
+	return NULL;
 }
 
 /**
@@ -384,6 +414,7 @@ static struct cpuset *alloc_trial_cpuset(const struct cpuset *cs)
  */
 static void free_trial_cpuset(struct cpuset *trial)
 {
+	free_cpumask_var(trial->user_cpus_allowed);
 	free_cpumask_var(trial->cpus_allowed);
 	kfree(trial);
 }
@@ -402,7 +433,7 @@ static void free_trial_cpuset(struct cpuset *trial)
  * cpuset in the list must use cur below, not trial.
  *
  * 'trial' is the address of bulk structure copy of cur, with
- * perhaps one or more of the fields cpus_allowed, mems_allowed,
+ * perhaps one or more of the fields user_cpus_allowed, mems_allowed,
  * or flags changed to new, trial values.
  *
  * Return 0 if valid, -errno if not.
@@ -437,7 +468,8 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 		c = cgroup_cs(cont);
 		if ((is_cpu_exclusive(trial) || is_cpu_exclusive(c)) &&
 		    c != cur &&
-		    cpumask_intersects(trial->cpus_allowed, c->cpus_allowed))
+		    cpumask_intersects(trial->user_cpus_allowed,
+							c->user_cpus_allowed))
 			return -EINVAL;
 		if ((is_mem_exclusive(trial) || is_mem_exclusive(c)) &&
 		    c != cur &&
@@ -445,9 +477,12 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 			return -EINVAL;
 	}
 
-	/* Cpusets with tasks can't have empty cpus_allowed or mems_allowed */
+	/*
+	 * Cpusets with tasks can't have empty user_cpus_allowed or
+	 * mems_allowed
+	 */
 	if (cgroup_task_count(cur->css.cgroup)) {
-		if (cpumask_empty(trial->cpus_allowed) ||
+		if (cpumask_empty(trial->user_cpus_allowed) ||
 		    nodes_empty(trial->mems_allowed)) {
 			return -ENOSPC;
 		}
@@ -554,6 +589,10 @@ update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *c)
  *	all cpusets having the same 'pn' value then form the one
  *	element of the partition (one sched domain) to be passed to
  *	partition_sched_domains().
+ *
+ * Note: We use the cpuset's cpus_allowed mask and *not* the
+ * user_cpus_allowed mask, because cpus_allowed is the cpu mask on which
+ * we actually want to run the tasks on.
  */
 static int generate_sched_domains(cpumask_var_t **domains,
 			struct sched_domain_attr **attributes)
@@ -862,7 +901,8 @@ static void update_tasks_cpumask(struct cpuset *cs, struct ptr_heap *heap)
 }
 
 /**
- * update_cpumask - update the cpus_allowed mask of a cpuset and all tasks in it
+ * update_cpumask - update the user_cpus_allowed mask of a cpuset and all
+ * tasks in it. Note that this is a user request.
  * @cs: the cpuset to consider
  * @buf: buffer of cpu numbers written to this cpuset
  */
@@ -873,24 +913,28 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	int retval;
 	int is_load_balanced;
 
-	/* top_cpuset.cpus_allowed tracks cpu_online_mask; it's read-only */
+	/*
+	 * top_cpuset.user_cpus_allowed tracks cpu_online_mask;
+	 * it's read-only
+	 */
 	if (cs == &top_cpuset)
 		return -EACCES;
 
 	/*
-	 * An empty cpus_allowed is ok only if the cpuset has no tasks.
+	 * An empty user_cpus_allowed is ok only if the cpuset has no tasks.
 	 * Since cpulist_parse() fails on an empty mask, we special case
 	 * that parsing.  The validate_change() call ensures that cpusets
 	 * with tasks have cpus.
 	 */
 	if (!*buf) {
-		cpumask_clear(trialcs->cpus_allowed);
+		cpumask_clear(trialcs->user_cpus_allowed);
 	} else {
-		retval = cpulist_parse(buf, trialcs->cpus_allowed);
+		retval = cpulist_parse(buf, trialcs->user_cpus_allowed);
 		if (retval < 0)
 			return retval;
 
-		if (!cpumask_subset(trialcs->cpus_allowed, cpu_active_mask))
+		if (!cpumask_subset(trialcs->user_cpus_allowed,
+							cpu_active_mask))
 			return -EINVAL;
 	}
 	retval = validate_change(cs, trialcs);
@@ -898,7 +942,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		return retval;
 
 	/* Nothing to do if the cpus didn't change */
-	if (cpumask_equal(cs->cpus_allowed, trialcs->cpus_allowed))
+	if (cpumask_equal(cs->user_cpus_allowed, trialcs->user_cpus_allowed))
 		return 0;
 
 	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
@@ -908,7 +952,9 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	is_load_balanced = is_sched_load_balance(trialcs);
 
 	mutex_lock(&callback_mutex);
-	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
+	cpumask_copy(cs->user_cpus_allowed, trialcs->user_cpus_allowed);
+	/* Initialize the cpus_allowed mask too. */
+	cpumask_copy(cs->cpus_allowed, cs->user_cpus_allowed);
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -1395,7 +1441,7 @@ static int cpuset_can_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 		 * unnecessary.  Thus, cpusets are not applicable for such
 		 * threads.  This prevents checking for success of
 		 * set_cpus_allowed_ptr() on all attached tasks before
-		 * cpus_allowed may be changed.
+		 * user_cpus_allowed may be changed.
 		 */
 		if (task->flags & PF_THREAD_BOUND)
 			return -EINVAL;
@@ -1454,6 +1500,7 @@ static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 
 typedef enum {
 	FILE_MEMORY_MIGRATE,
+	FILE_USERCPULIST,
 	FILE_CPULIST,
 	FILE_MEMLIST,
 	FILE_CPU_EXCLUSIVE,
@@ -1553,7 +1600,7 @@ static int cpuset_write_resmask(struct cgroup *cgrp, struct cftype *cft,
 	}
 
 	switch (cft->private) {
-	case FILE_CPULIST:
+	case FILE_USERCPULIST:
 		retval = update_cpumask(cs, trialcs, buf);
 		break;
 	case FILE_MEMLIST:
@@ -1582,6 +1629,17 @@ out:
  * across a page fault.
  */
 
+static size_t cpuset_sprintf_usercpulist(char *page, struct cpuset *cs)
+{
+	size_t count;
+
+	mutex_lock(&callback_mutex);
+	count = cpulist_scnprintf(page, PAGE_SIZE, cs->user_cpus_allowed);
+	mutex_unlock(&callback_mutex);
+
+	return count;
+}
+
 static size_t cpuset_sprintf_cpulist(char *page, struct cpuset *cs)
 {
 	size_t count;
@@ -1622,6 +1680,9 @@ static ssize_t cpuset_common_file_read(struct cgroup *cont,
 	s = page;
 
 	switch (type) {
+	case FILE_USERCPULIST:
+		s += cpuset_sprintf_usercpulist(s, cs);
+		break;
 	case FILE_CPULIST:
 		s += cpuset_sprintf_cpulist(s, cs);
 		break;
@@ -1697,7 +1758,14 @@ static struct cftype files[] = {
 		.read = cpuset_common_file_read,
 		.write_string = cpuset_write_resmask,
 		.max_write_len = (100U + 6 * NR_CPUS),
+		.private = FILE_USERCPULIST,
+	},
+
+	{
+		.name = "actual_cpus",
+		.read = cpuset_common_file_read,
 		.private = FILE_CPULIST,
+		.mode = S_IRUGO,
 	},
 
 	{
@@ -1826,6 +1894,7 @@ static void cpuset_post_clone(struct cgroup *cgroup)
 
 	mutex_lock(&callback_mutex);
 	cs->mems_allowed = parent_cs->mems_allowed;
+	cpumask_copy(cs->user_cpus_allowed, parent_cs->user_cpus_allowed);
 	cpumask_copy(cs->cpus_allowed, parent_cs->cpus_allowed);
 	mutex_unlock(&callback_mutex);
 	return;
@@ -1848,10 +1917,12 @@ static struct cgroup_subsys_state *cpuset_create(struct cgroup *cont)
 	cs = kmalloc(sizeof(*cs), GFP_KERNEL);
 	if (!cs)
 		return ERR_PTR(-ENOMEM);
-	if (!alloc_cpumask_var(&cs->cpus_allowed, GFP_KERNEL)) {
-		kfree(cs);
-		return ERR_PTR(-ENOMEM);
-	}
+
+	if (!alloc_cpumask_var(&cs->user_cpus_allowed, GFP_KERNEL))
+		goto out_cs;
+
+	if (!alloc_cpumask_var(&cs->cpus_allowed, GFP_KERNEL))
+		goto out_user_cpus_allowed;
 
 	cs->flags = 0;
 	if (is_spread_page(parent))
@@ -1859,6 +1930,7 @@ static struct cgroup_subsys_state *cpuset_create(struct cgroup *cont)
 	if (is_spread_slab(parent))
 		set_bit(CS_SPREAD_SLAB, &cs->flags);
 	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
+	cpumask_clear(cs->user_cpus_allowed);
 	cpumask_clear(cs->cpus_allowed);
 	nodes_clear(cs->mems_allowed);
 	fmeter_init(&cs->fmeter);
@@ -1867,6 +1939,12 @@ static struct cgroup_subsys_state *cpuset_create(struct cgroup *cont)
 	cs->parent = parent;
 	number_of_cpusets++;
 	return &cs->css ;
+
+ out_user_cpus_allowed:
+	free_cpumask_var(cs->user_cpus_allowed);
+ out_cs:
+	kfree(cs);
+	return ERR_PTR(-ENOMEM);
 }
 
 /*
@@ -1883,6 +1961,7 @@ static void cpuset_destroy(struct cgroup *cont)
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
 	number_of_cpusets--;
+	free_cpumask_var(cs->user_cpus_allowed);
 	free_cpumask_var(cs->cpus_allowed);
 	kfree(cs);
 }
@@ -1909,9 +1988,13 @@ int __init cpuset_init(void)
 {
 	int err = 0;
 
+	if (!alloc_cpumask_var(&top_cpuset.user_cpus_allowed, GFP_KERNEL))
+		BUG();
+
 	if (!alloc_cpumask_var(&top_cpuset.cpus_allowed, GFP_KERNEL))
 		BUG();
 
+	cpumask_setall(top_cpuset.user_cpus_allowed);
 	cpumask_setall(top_cpuset.cpus_allowed);
 	nodes_setall(top_cpuset.mems_allowed);
 
@@ -2166,13 +2249,14 @@ static int cpuset_track_online_nodes(struct notifier_block *self,
 #endif
 
 /**
- * cpuset_init_smp - initialize cpus_allowed
+ * cpuset_init_smp - initialize user_cpus_allowed and cpus_allowed
  *
  * Description: Finish top cpuset after cpu, node maps are initialized
  **/
 
 void __init cpuset_init_smp(void)
 {
+	cpumask_copy(top_cpuset.user_cpus_allowed, cpu_active_mask);
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 

