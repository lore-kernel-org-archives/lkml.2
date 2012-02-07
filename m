Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab2BGS5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:57:49 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51461 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab2BGS5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:57:47 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 3/4] cpuset: Add function to introduce CPUs to cpusets during
 CPU online
To: paul@paulmenage.org, a.p.zijlstra@chello.nl, mingo@elte.hu, rjw@sisk.pl,
        tj@kernel.org
Cc: frank.rowand@am.sony.com, pjt@google.com, tglx@linutronix.de,
        lizf@cn.fujitsu.com, prashanth@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Wed, 08 Feb 2012 00:27:09 +0530
Message-ID: <20120207185651.7482.18642.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
References: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12020718-2000-0000-0000-0000065532D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During a CPU online operation, at present, that CPU is added only to
top_cpuset.cpus_allowed, but not to any of the other cpusets, which
is a mistake.

So, add a function to go through all the cpusets and add this CPU to
each cpuset which contained this CPU previously. In other words, add this
CPU to those cpusets, whose cpus_allowed_before_hotplug mask contains
this CPU.

Note that this function should not modify cpus_allowed_before_hotplug.
Hence, we move that particular piece of code from do_update_cpumask()
to update_cpumask().

Reported-by: Prashanth K. Nageshappa <prashanth@linux.vnet.ibm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
---

 kernel/cpuset.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 2be71da..c56e705 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -900,7 +900,6 @@ static int do_update_cpumask(struct cpuset *cs, struct cpuset *trialcs)
 
 	mutex_lock(&callback_mutex);
 	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
-	cpumask_copy(cs->cpus_allowed_before_hotplug, cs->cpus_allowed);
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -948,7 +947,10 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 			return -EINVAL;
 	}
 
-	return do_update_cpumask(cs, trialcs);
+	retval = do_update_cpumask(cs, trialcs);
+
+	cpumask_copy(cs->cpus_allowed_before_hotplug, cs->cpus_allowed);
+	return retval;
 }
 
 /*
@@ -2079,6 +2081,71 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
 	move_member_tasks_to_cpuset(cs, parent);
 }
 
+
+/*
+ * Walk the specified cpuset subtree and add the newly onlined CPU to the
+ * cpuset, if that CPU was in this cpuset previously (IOW, if this CPU
+ * is still in the cpuset_allowed_before_hotplug mask of this cpuset).
+ *
+ * Called with cgroup_mutex held.
+ *
+ * This walk processes the tree from top to bottom, completing one layer
+ * before dropping down to the next.  It always processes a node before
+ * any of its children.
+ */
+static void scan_cpusets_during_cpu_online(struct cpuset *root)
+{
+	LIST_HEAD(queue);
+	struct cpuset *cp;	/* scans cpusets being updated */
+	struct cpuset *child;	/* scans child cpusets of cp */
+	struct cgroup *cont;
+	struct cpuset *trialcs;
+
+	trialcs = alloc_trial_cpuset(root);
+	if (!trialcs)
+		return;
+
+	list_add_tail((struct list_head *)&root->stack_list, &queue);
+
+	while (!list_empty(&queue)) {
+		cp = list_first_entry(&queue, struct cpuset, stack_list);
+		list_del(queue.next);
+		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
+			child = cgroup_cs(cont);
+			list_add_tail(&child->stack_list, &queue);
+		}
+
+		/*
+		 * Continue past cpusets which didn't have this CPU previously
+		 * (Note that when this CPU went offline, it had been removed
+		 * from all cpusets.)
+		 */
+		if (cpumask_equal(cp->cpus_allowed,
+					cp->cpus_allowed_before_hotplug))
+			continue;
+
+		/*
+		 * Add newly onlined CPUs to this cpuset if they were part of
+		 * this cpuset previously.
+		 */
+		cpumask_and(trialcs->cpus_allowed,
+				cp->cpus_allowed_before_hotplug,
+				cpu_active_mask);
+
+		/* Update the cpuset */
+		do_update_cpumask(cp, trialcs);
+
+		/*
+		 * Do NOT update cpus_allowed_before_hotplug here. We want it
+		 * to reflect the value of cpus_allowed as seen *before* the
+		 * hotplug event.
+		 */
+	}
+
+	free_trial_cpuset(trialcs);
+}
+
+
 /*
  * Walk the specified cpuset subtree and look for empty cpusets.
  * The tasks of such cpuset must be moved to a parent cpuset.

