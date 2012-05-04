Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454Ab2EDTUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:20:12 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51380 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab2EDTUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:20:10 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 4/7] CPU hotplug,
 cpusets: Workout hotplug handling for cpusets
To: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org
Cc: rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Sat, 05 May 2012 00:49:23 +0530
Message-ID: <20120504191900.4603.42981.stgit@srivatsabhat>
In-Reply-To: <20120504191535.4603.83236.stgit@srivatsabhat>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12050419-2000-0000-0000-0000075AD37D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have 2 per-cpuset masks, namely user_cpus_allowed and
cpus_allowed, implement the CPU Hotplug handling for cpusets.

The cpuset update upon hotplug simplifies to:

For any CPU hotplug event (online/offline), traverse the cpuset hierarchy
top-down, doing:

1. cpus_allowed mask = (user_cpus_allowed mask) & (cpu_active_mask)
2. If the resulting cpus_allowed mask is empty,
   cpus_allowed mask = parent cpuset's cpus_allowed mask
   (Because of the top-down traversal, and the guarantee that the root cpuset
    will always have online cpus, it is enough to copy the parent's
    cpus_allowed mask.)
3. No need to move tasks from one cpuset to another, during any CPU Hotplug
   operation.

This ensures that we are as close to the user's preference as possible,
within the constraints imposed by CPU hotplug.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
---

 kernel/cpuset.c |   78 +++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 58 insertions(+), 20 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4bafbc4..c501a90 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -167,6 +167,7 @@ typedef enum {
 
 /* the type of hotplug event */
 enum hotplug_event {
+	CPUSET_CPU_ONLINE,
 	CPUSET_CPU_OFFLINE,
 	CPUSET_MEM_OFFLINE,
 };
@@ -2056,11 +2057,10 @@ static void move_member_tasks_to_cpuset(struct cpuset *from, struct cpuset *to)
 }
 
 /*
- * If CPU and/or memory hotplug handlers, below, unplug any CPUs
- * or memory nodes, we need to walk over the cpuset hierarchy,
- * removing that CPU or node from all cpusets.  If this removes the
- * last CPU or node from a cpuset, then move the tasks in the empty
- * cpuset to its next-highest non-empty parent.
+ * If memory hotplug handlers, below, unplug any memory nodes, we need
+ * to walk over the cpuset hierarchy, removing that node from all cpusets.
+ * If this removes the last node from a cpuset, then move the tasks in
+ * the empty cpuset to its next-highest non-empty parent.
  *
  * Called with cgroup_mutex held
  * callback_mutex must not be held, as cpuset_attach() will take it.
@@ -2079,11 +2079,10 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
 
 	/*
 	 * Find its next-highest non-empty parent, (top cpuset
-	 * has online cpus, so can't be empty).
+	 * has online cpus and memory node, so can't be empty).
 	 */
 	parent = cs->parent;
-	while (cpumask_empty(parent->cpus_allowed) ||
-			nodes_empty(parent->mems_allowed))
+	while (nodes_empty(parent->mems_allowed))
 		parent = parent->parent;
 
 	move_member_tasks_to_cpuset(cs, parent);
@@ -2107,8 +2106,12 @@ static struct cpuset *traverse_cpusets(struct list_head *queue)
 
 
 /*
- * Walk the specified cpuset subtree and look for empty cpusets.
- * The tasks of such cpuset must be moved to a parent cpuset.
+ * Walk the specified cpuset subtree upon a hotplug operation (CPU/Memory
+ * online/offline) and update the cpusets accordingly.
+ *
+ * For CPU Hotplug, update the cpus_allowed mask of the cpuset such that
+ * it has online cpus for the tasks in the cpuset to run on, without
+ * deviating much from the user set preference for the cpuset.
  *
  * Called with cgroup_mutex held.  We take callback_mutex to modify
  * cpus_allowed and mems_allowed.
@@ -2119,7 +2122,8 @@ static struct cpuset *traverse_cpusets(struct list_head *queue)
  *
  * For now, since we lack memory hot unplug, we'll never see a cpuset
  * that has tasks along with an empty 'mems'.  But if we did see such
- * a cpuset, we'd handle it just like we do if its 'cpus' was empty.
+ * a cpuset, we would move the tasks of such cpuset to a non-empty parent
+ * cpuset.
  */
 static void
 scan_cpusets_upon_hotplug(struct cpuset *root, enum hotplug_event event)
@@ -2131,6 +2135,30 @@ scan_cpusets_upon_hotplug(struct cpuset *root, enum hotplug_event event)
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
 	switch (event) {
+	case CPUSET_CPU_ONLINE:
+		while (!list_empty(&queue)) {
+			cp = traverse_cpusets(&queue);
+
+			/*
+			 * Continue past cpusets which don't need to be
+			 * updated.
+			 */
+			if (cpumask_equal(cp->user_cpus_allowed,
+							cp->cpus_allowed))
+				continue;
+
+			/*
+			 * Restore new CPU to this cpuset if it was
+			 * originally present in this cpuset.
+			 */
+			mutex_lock(&callback_mutex);
+			cpumask_and(cp->cpus_allowed,
+				cp->user_cpus_allowed, cpu_active_mask);
+			mutex_unlock(&callback_mutex);
+
+			update_tasks_cpumask(cp, NULL);
+		}
+		break;
 	case CPUSET_CPU_OFFLINE:
 		while (!list_empty(&queue)) {
 			cp = traverse_cpusets(&queue);
@@ -2141,15 +2169,22 @@ scan_cpusets_upon_hotplug(struct cpuset *root, enum hotplug_event event)
 
 			/* Remove offline cpus from this cpuset. */
 			mutex_lock(&callback_mutex);
-			cpumask_and(cp->cpus_allowed, cp->cpus_allowed,
-							cpu_active_mask);
+			cpumask_and(cp->cpus_allowed,
+				cp->user_cpus_allowed, cpu_active_mask);
 			mutex_unlock(&callback_mutex);
 
-			/* Move tasks from the empty cpuset to a parent */
+			/*
+			 * If cpuset is empty, copy parent cpuset's
+			 * cpus_allowed mask. Because our traversal is
+			 * top-down, and because the root cpuset will always
+			 * have online cpus, it is sufficient to copy the
+			 * parent cpuset's mask here.
+			 */
 			if (cpumask_empty(cp->cpus_allowed))
-				remove_tasks_in_empty_cpuset(cp);
-			else
-				update_tasks_cpumask(cp, NULL);
+				cpumask_copy(cp->cpus_allowed,
+						cp->parent->cpus_allowed);
+
+			update_tasks_cpumask(cp, NULL);
 		}
 		break;
 
@@ -2185,8 +2220,9 @@ scan_cpusets_upon_hotplug(struct cpuset *root, enum hotplug_event event)
  * (of no affect) on systems that are actively using CPU hotplug
  * but making no active use of cpusets.
  *
- * This routine ensures that top_cpuset.cpus_allowed tracks
- * cpu_active_mask on each CPU hotplug (cpuhp) event.
+ * This routine ensures that top_cpuset.user_cpus_allowed and
+ * top_cpuset.cpus_allowed tracks cpu_active_mask on each CPU hotplug
+ * (cpuhp) event.
  *
  * Called within get_online_cpus().  Needs to call cgroup_lock()
  * before calling generate_sched_domains().
@@ -2202,9 +2238,11 @@ void cpuset_update_active_cpus(bool cpu_online)
 
 	cgroup_lock();
 	mutex_lock(&callback_mutex);
+	cpumask_copy(top_cpuset.user_cpus_allowed, cpu_active_mask);
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
 	mutex_unlock(&callback_mutex);
-	scan_cpusets_upon_hotplug(&top_cpuset, CPUSET_CPU_OFFLINE);
+	scan_cpusets_upon_hotplug(&top_cpuset,
+			cpu_online ? CPUSET_CPU_ONLINE : CPUSET_CPU_OFFLINE);
 	ndoms = generate_sched_domains(&doms, &attr);
 	cgroup_unlock();
 

