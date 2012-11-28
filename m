Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945923Ab2K1W11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 17:27:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44075 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030180Ab2K1W1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 17:27:19 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, mhocko@suse.cz, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3] cpuset: remove cpuset->parent
Date: Wed, 28 Nov 2012 14:27:01 -0800
Message-Id: <1354141621-11906-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354141621-11906-1-git-send-email-tj@kernel.org>
References: <1354141621-11906-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup already tracks the hierarchy.  Follow cgroup->parent to find
the parent and drop cpuset->parent.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cpuset.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3a01730..d804415 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -87,8 +87,6 @@ struct cpuset {
 	cpumask_var_t cpus_allowed;	/* CPUs allowed to tasks in cpuset */
 	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
 
-	struct cpuset *parent;		/* my parent */
-
 	struct fmeter fmeter;		/* memory_pressure filter */
 
 	/*
@@ -120,6 +118,15 @@ static inline struct cpuset *task_cs(struct task_struct *task)
 			    struct cpuset, css);
 }
 
+static inline struct cpuset *parent_cs(const struct cpuset *cs)
+{
+	struct cgroup *pcgrp = cs->css.cgroup->parent;
+
+	if (pcgrp)
+		return cgroup_cs(pcgrp);
+	return NULL;
+}
+
 #ifdef CONFIG_NUMA
 static inline bool task_has_mempolicy(struct task_struct *task)
 {
@@ -323,7 +330,7 @@ static void guarantee_online_cpus(const struct cpuset *cs,
 				  struct cpumask *pmask)
 {
 	while (cs && !cpumask_intersects(cs->cpus_allowed, cpu_online_mask))
-		cs = cs->parent;
+		cs = parent_cs(cs);
 	if (cs)
 		cpumask_and(pmask, cs->cpus_allowed, cpu_online_mask);
 	else
@@ -348,7 +355,7 @@ static void guarantee_online_mems(const struct cpuset *cs, nodemask_t *pmask)
 {
 	while (cs && !nodes_intersects(cs->mems_allowed,
 					node_states[N_HIGH_MEMORY]))
-		cs = cs->parent;
+		cs = parent_cs(cs);
 	if (cs)
 		nodes_and(*pmask, cs->mems_allowed,
 					node_states[N_HIGH_MEMORY]);
@@ -461,7 +468,7 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 	if (cur == &top_cpuset)
 		goto out;
 
-	par = cur->parent;
+	par = parent_cs(cur);
 
 	/* We must be a subset of our parent cpuset */
 	ret = -EACCES;
@@ -1860,7 +1867,6 @@ static struct cgroup_subsys_state *cpuset_css_alloc(struct cgroup *cont)
 	fmeter_init(&cs->fmeter);
 	INIT_WORK(&cs->hotplug_work, cpuset_propagate_hotplug_workfn);
 	cs->relax_domain_level = -1;
-	cs->parent = cgroup_cs(cont->parent);
 
 	return &cs->css;
 }
@@ -1868,7 +1874,7 @@ static struct cgroup_subsys_state *cpuset_css_alloc(struct cgroup *cont)
 static int cpuset_css_online(struct cgroup *cgrp)
 {
 	struct cpuset *cs = cgroup_cs(cgrp);
-	struct cpuset *parent = cs->parent;
+	struct cpuset *parent = parent_cs(cs);
 	struct cpuset *tmp_cs;
 	struct cgroup *pos_cg;
 
@@ -2049,10 +2055,10 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
 	 * Find its next-highest non-empty parent, (top cpuset
 	 * has online cpus, so can't be empty).
 	 */
-	parent = cs->parent;
+	parent = parent_cs(cs);
 	while (cpumask_empty(parent->cpus_allowed) ||
 			nodes_empty(parent->mems_allowed))
-		parent = parent->parent;
+		parent = parent_cs(parent);
 
 	move_member_tasks_to_cpuset(cs, parent);
 }
@@ -2353,8 +2359,8 @@ int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
  */
 static const struct cpuset *nearest_hardwall_ancestor(const struct cpuset *cs)
 {
-	while (!(is_mem_exclusive(cs) || is_mem_hardwall(cs)) && cs->parent)
-		cs = cs->parent;
+	while (!(is_mem_exclusive(cs) || is_mem_hardwall(cs)) && parent_cs(cs))
+		cs = parent_cs(cs);
 	return cs;
 }
 
-- 
1.7.11.7

