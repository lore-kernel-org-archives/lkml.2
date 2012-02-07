Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab2BGS42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:56:28 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:48878 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab2BGS40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:56:26 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 1/4] CPU hotplug,
 cpuset: Maintain a copy of the cpus_allowed mask before CPU hotplug
To: paul@paulmenage.org, a.p.zijlstra@chello.nl, mingo@elte.hu, rjw@sisk.pl,
        tj@kernel.org
Cc: frank.rowand@am.sony.com, pjt@google.com, tglx@linutronix.de,
        lizf@cn.fujitsu.com, prashanth@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Wed, 08 Feb 2012 00:26:11 +0530
Message-ID: <20120207185550.7482.72699.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
References: <20120207185411.7482.43576.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12020718-4790-0000-0000-00000138CDD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maintain a new per-cpuset mask 'cpus_allowed_before_hotplug', that closely
reflects the value of 'cpus_allowed' of a cpuset, in order to decide how to
react upon a CPU offline followed by CPU online.

Whenever 'cpus_allowed' of the cpuset changes, 'cpus_allowed_before_hotplug'
is updated. The only exception is: when 'cpus_allowed' changes due to a CPU
hotplug event (either offline or online) we don't update
'cpus_allowed_before_hotplug', so that it still reflects the state of
'cpus_allowed' as seen *before* the hotplug event.

This is to handle cases like:

* cpus_allowed has 0-15, cpus_allowed_before_hotplug is also 0-15

* CPU 15 was taken offline
  So now cpus_allowed = 0-14
  No changes to cpus_allowed_before_hotplug.

* CPU 14 was taken offline
  So now cpus_allowed = 0-13
  But we still remember that the original cpuset was 0-15, because
  cpus_allowed_before_hotplug was never changed.

* cpuset was changed to 0-10 from userspace.
  So now cpus_allowed = 0-10, and cpus_allowed_before_hotplug is also updated
  to 0-10.

So, essentially cpus_allowed_before_hotplug is maintained in such a way that
if a CPU comes back online, we know whether it was in the cpuset earlier (and
hence we need to add that CPU back into the cpuset) or whether it was
originally absent from that cpuset.

Reported-by: Prashanth K. Nageshappa <prashanth@linux.vnet.ibm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
---

 kernel/cpuset.c |   40 +++++++++++++++++++++++++++++++++++-----
 1 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index a09ac2b..5e2323b 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -93,6 +93,15 @@ struct cpuset {
 
 	unsigned long flags;		/* "unsigned long" so bitops work */
 	cpumask_var_t cpus_allowed;	/* CPUs allowed to tasks in cpuset */
+
+	/*
+	 * Copy of 'cpus_allowed'. This is updated whenever 'cpus_allowed' is
+	 * updated, except during CPU hotplug operations (in which case, only
+	 * 'cpus_allowed' is updated). This is used to decide whether to add a
+	 * CPU to this cpuset when that offline CPU comes back online.
+	 */
+	cpumask_var_t cpus_allowed_before_hotplug;
+
 	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
 
 	struct cpuset *parent;		/* my parent */
@@ -903,6 +912,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 
 	mutex_lock(&callback_mutex);
 	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
+	cpumask_copy(cs->cpus_allowed_before_hotplug, cs->cpus_allowed);
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -1851,6 +1861,7 @@ static void cpuset_post_clone(struct cgroup_subsys *ss,
 	mutex_lock(&callback_mutex);
 	cs->mems_allowed = parent_cs->mems_allowed;
 	cpumask_copy(cs->cpus_allowed, parent_cs->cpus_allowed);
+	cpumask_copy(cs->cpus_allowed_before_hotplug, cs->cpus_allowed);
 	mutex_unlock(&callback_mutex);
 	return;
 }
@@ -1875,10 +1886,12 @@ static struct cgroup_subsys_state *cpuset_create(
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
+	if (!alloc_cpumask_var(&cs->cpus_allowed_before_hotplug, GFP_KERNEL))
+		goto out_cpus_allowed;
 
 	cs->flags = 0;
 	if (is_spread_page(parent))
@@ -1887,6 +1900,7 @@ static struct cgroup_subsys_state *cpuset_create(
 		set_bit(CS_SPREAD_SLAB, &cs->flags);
 	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 	cpumask_clear(cs->cpus_allowed);
+	cpumask_clear(cs->cpus_allowed_before_hotplug);
 	nodes_clear(cs->mems_allowed);
 	fmeter_init(&cs->fmeter);
 	cs->relax_domain_level = -1;
@@ -1894,6 +1908,12 @@ static struct cgroup_subsys_state *cpuset_create(
 	cs->parent = parent;
 	number_of_cpusets++;
 	return &cs->css ;
+
+out_cpus_allowed:
+	kfree(cs->cpus_allowed);
+out_cs:
+	kfree(cs);
+	return ERR_PTR(-ENOMEM);
 }
 
 /*
@@ -1911,6 +1931,7 @@ static void cpuset_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
 
 	number_of_cpusets--;
 	free_cpumask_var(cs->cpus_allowed);
+	free_cpumask_var(cs->cpus_allowed_before_hotplug);
 	kfree(cs);
 }
 
@@ -1936,7 +1957,9 @@ int __init cpuset_init(void)
 {
 	int err = 0;
 
-	if (!alloc_cpumask_var(&top_cpuset.cpus_allowed, GFP_KERNEL))
+	if (!alloc_cpumask_var(&top_cpuset.cpus_allowed, GFP_KERNEL) ||
+		!alloc_cpumask_var(&top_cpuset.cpus_allowed_before_hotplug,
+				GFP_KERNEL))
 		BUG();
 
 	cpumask_setall(top_cpuset.cpus_allowed);
@@ -2077,6 +2100,13 @@ static void scan_for_empty_cpusets(struct cpuset *root)
 		mutex_lock(&callback_mutex);
 		cpumask_and(cp->cpus_allowed, cp->cpus_allowed,
 			    cpu_active_mask);
+
+		/*
+		 * Do NOT update cpus_allowed_before_hotplug here. We want it
+		 * to reflect the value of cpus_allowed as seen *before* the
+		 * hotplug event.
+		 */
+
 		nodes_and(cp->mems_allowed, cp->mems_allowed,
 						node_states[N_HIGH_MEMORY]);
 		mutex_unlock(&callback_mutex);

