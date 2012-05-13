Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2EMXSO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 19:18:14 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:35291 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab2EMXSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 19:18:10 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 5/5] cpusets,
 suspend: Save and restore cpusets during suspend/resume
To: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org
Cc: rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, tj@kernel.org,
        mschmidt@redhat.com, berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Mon, 14 May 2012 04:47:25 +0530
Message-ID: <20120513231710.3566.45349.stgit@srivatsabhat>
In-Reply-To: <20120513231325.3566.37740.stgit@srivatsabhat>
References: <20120513231325.3566.37740.stgit@srivatsabhat>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12051323-5564-0000-0000-000002A98083
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the event of CPU hotplug, the kernel modifies the cpusets' cpus_allowed
masks as and when necessary to ensure that the tasks belonging to the cpusets
have some place (online CPUs) to run on. And regular CPU hotplug is
destructive in the sense that the kernel doesn't remember the original cpuset
configurations set by the user, across hotplug operations.

However, suspend/resume (which uses CPU hotplug) is a special case in which
the kernel has the responsibility to restore the system (during resume), to
exactly the same state it was in before suspend. And this calls for special
handling of cpusets when CPU hotplug is carried out in the suspend/resume
path.

That special handling for suspend/resume is implemented as follows:
1. Explicitly save all the cpusets' cpus_allowed mask during suspend and
   restore them during resume. Use a new per-cpuset mask to facilitate this.
2. During CPU hotplug, modify the cpusets' cpus_allowed mask as necessary to
   keep them non-empty.
3. Do not move the tasks from one cpuset to another during hotplug.

It is to be noted that all the userspace would have been already frozen
before doing CPU hotplug in the suspend/resume path, and hence, in reality,
nobody (userspace tasks) will actually observe any of this special case
handling (which is good news for the kernel, because this deviates from
true hotplug semantics slightly, so as to resume the system properly).

(Also, while implementing this special case handling for suspend/resume, we
don't modify the existing cpuset handling for regular CPU hotplug, since it
is correct as it is anyway.)

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
---

 kernel/cpuset.c |   84 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 79 insertions(+), 5 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 0723183..671bf26 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -93,6 +93,13 @@ struct cpuset {
 
 	unsigned long flags;		/* "unsigned long" so bitops work */
 	cpumask_var_t cpus_allowed;	/* CPUs allowed to tasks in cpuset */
+
+	/*
+	 * used to save cpuset's cpus_allowed mask during suspend and restore
+	 * it during resume.
+	 */
+	cpumask_var_t suspend_cpus_allowed;
+
 	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
 
 	struct cpuset *parent;		/* my parent */
@@ -1851,10 +1858,12 @@ static struct cgroup_subsys_state *cpuset_create(struct cgroup *cont)
 	cs = kmalloc(sizeof(*cs), GFP_KERNEL);
 	if (!cs)
 		return ERR_PTR(-ENOMEM);
-	if (!alloc_cpumask_var(&cs->cpus_allowed, GFP_KERNEL)) {
-		kfree(cs);
-		return ERR_PTR(-ENOMEM);
-	}
+
+	if (!alloc_cpumask_var(&cs->cpus_allowed, GFP_KERNEL))
+		goto out_cs;
+
+	if (!alloc_cpumask_var(&cs->suspend_cpus_allowed, GFP_KERNEL))
+		goto out_cpus_allowed;
 
 	cs->flags = 0;
 	if (is_spread_page(parent))
@@ -1870,6 +1879,12 @@ static struct cgroup_subsys_state *cpuset_create(struct cgroup *cont)
 	cs->parent = parent;
 	number_of_cpusets++;
 	return &cs->css ;
+
+ out_cpus_allowed:
+	free_cpumask_var(cs->cpus_allowed);
+ out_cs:
+	kfree(cs);
+	return ERR_PTR(-ENOMEM);
 }
 
 /*
@@ -1887,6 +1902,7 @@ static void cpuset_destroy(struct cgroup *cont)
 
 	number_of_cpusets--;
 	free_cpumask_var(cs->cpus_allowed);
+	free_cpumask_var(cs->suspend_cpus_allowed);
 	kfree(cs);
 }
 
@@ -1915,6 +1931,9 @@ int __init cpuset_init(void)
 	if (!alloc_cpumask_var(&top_cpuset.cpus_allowed, GFP_KERNEL))
 		BUG();
 
+	if (!alloc_cpumask_var(&top_cpuset.suspend_cpus_allowed, GFP_KERNEL))
+		BUG();
+
 	cpumask_setall(top_cpuset.cpus_allowed);
 	nodes_setall(top_cpuset.mems_allowed);
 
@@ -2031,6 +2050,12 @@ static struct cpuset *traverse_cpusets(struct list_head *queue)
  * online/offline) and update the cpusets accordingly.
  * For regular CPU/Mem hotplug, look for empty cpusets; the tasks of such
  * cpuset must be moved to a parent cpuset.
+ * For CPU hotplug in the suspend/resume path,
+ *   - save cpusets' cpus_allowed mask during suspend and restore them during
+ *     resume
+ *   - update the cpusets' cpus_allowed mask to keep them non-empty during the
+ *     suspend/resume transition
+ *   - don't move the tasks from one cpuset to another during these updates
  *
  * Called with cgroup_mutex held.  We take callback_mutex to modify
  * cpus_allowed and mems_allowed.
@@ -2049,6 +2074,7 @@ scan_cpusets_upon_hotplug(struct cpuset *root, enum hotplug_event event)
 	LIST_HEAD(queue);
 	struct cpuset *cp;		/* scans cpusets being updated */
 	static nodemask_t oldmems;	/* protected by cgroup_mutex */
+	static int frozen_cpu_count;	/* marks begin/end of suspend/resume */
 
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
@@ -2080,10 +2106,58 @@ scan_cpusets_upon_hotplug(struct cpuset *root, enum hotplug_event event)
 		break;
 
 	case CPUSET_CPU_OFFLINE_FROZEN:
+		while (!list_empty(&queue)) {
+			cp = traverse_cpusets(&queue);
+
+			/*
+			 * Save the cpuset's original cpus_allowed mask,
+			 * so that we can restore it during resume.
+			 *
+			 * frozen_cpu_count == 0 indicates the begin/end of CPU
+			 * hotplug initiated as part of the suspend/resume
+			 * sequence.
+			 */
+			if (unlikely(!frozen_cpu_count))
+				cpumask_copy(cp->suspend_cpus_allowed,
+							cp->cpus_allowed);
+
+			/* Continue past cpusets with all cpus online */
+			if (cpumask_subset(cp->cpus_allowed, cpu_active_mask))
+				continue;
+
+			/*
+			 * The userspace is frozen since we are in the
+			 * suspend path. So to avoid unnecessary overhead,
+			 * just set cpus_allowed to cpu_active_mask and carry
+			 * on, since no one will notice it anyway.
+			 * Moreover, top_cpuset.cpus_allowed must track
+			 * cpu_active_mask, which is taken care of as well.
+			 */
+			mutex_lock(&callback_mutex);
+			cpumask_copy(cp->cpus_allowed, cpu_active_mask);
+			mutex_unlock(&callback_mutex);
+
+			update_tasks_cpumask(cp, NULL);
+		}
+		frozen_cpu_count++;
 		break;
 
 	case CPUSET_CPU_ONLINE_FROZEN:
-		break;
+		frozen_cpu_count--;
+		if (unlikely(!frozen_cpu_count)) {
+			while (!list_empty(&queue)) {
+				cp = traverse_cpusets(&queue);
+
+				mutex_lock(&callback_mutex);
+				cpumask_copy(cp->cpus_allowed,
+						cp->suspend_cpus_allowed);
+				mutex_unlock(&callback_mutex);
+				update_tasks_cpumask(cp, NULL);
+			}
+			break;
+		} else {
+			/* Fall through */
+		}
 
 	case CPUSET_CPU_ONLINE:
 		/*

