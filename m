Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab2K1Ver (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:34:47 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:32786 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582Ab2K1Ven (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:34:43 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        peterz@infradead.org, mhocko@suse.cz, bsingharora@gmail.com,
        hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/13] cpuset: cleanup cpuset[_can]_attach()
Date: Wed, 28 Nov 2012 13:34:13 -0800
Message-Id: <1354138460-19286-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354138460-19286-1-git-send-email-tj@kernel.org>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuset_can_attach() prepare global variables cpus_attach and
cpuset_attach_nodemask_{to|from} which are used by cpuset_attach().
There is no reason to prepare in cpuset_can_attach().  The same
information can be accessed from cpuset_attach().

Move the prepartion logic from cpuset_can_attach() to cpuset_attach()
and make the global variables static ones inside cpuset_attach().

While at it, convert cpus_attach to cpumask_t from cpumask_var_t.
There's no reason to mess with dynamic allocation on a static buffer.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cpuset.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 5a52ed6..8bdd983 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1395,15 +1395,6 @@ static int fmeter_getrate(struct fmeter *fmp)
 	return val;
 }
 
-/*
- * Protected by cgroup_lock. The nodemasks must be stored globally because
- * dynamically allocating them is not allowed in can_attach, and they must
- * persist until attach.
- */
-static cpumask_var_t cpus_attach;
-static nodemask_t cpuset_attach_nodemask_from;
-static nodemask_t cpuset_attach_nodemask_to;
-
 /* Called by cgroups to determine if a cpuset is usable; cgroup_mutex held */
 static int cpuset_can_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 {
@@ -1430,19 +1421,15 @@ static int cpuset_can_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 			return ret;
 	}
 
-	/* prepare for attach */
-	if (cs == &top_cpuset)
-		cpumask_copy(cpus_attach, cpu_possible_mask);
-	else
-		guarantee_online_cpus(cs, cpus_attach);
-
-	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
-
 	return 0;
 }
 
 static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 {
+	/* static bufs protected by cgroup_mutex */
+	static cpumask_t cpus_attach;
+	static nodemask_t cpuset_attach_nodemask_from;
+	static nodemask_t cpuset_attach_nodemask_to;
 	struct mm_struct *mm;
 	struct task_struct *task;
 	struct task_struct *leader = cgroup_taskset_first(tset);
@@ -1450,12 +1437,20 @@ static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 	struct cpuset *cs = cgroup_cs(cgrp);
 	struct cpuset *oldcs = cgroup_cs(oldcgrp);
 
+	/* prepare for attach */
+	if (cs == &top_cpuset)
+		cpumask_copy(&cpus_attach, cpu_possible_mask);
+	else
+		guarantee_online_cpus(cs, &cpus_attach);
+
+	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
+
 	cgroup_taskset_for_each(task, cgrp, tset) {
 		/*
 		 * can_attach beforehand should guarantee that this doesn't
 		 * fail.  TODO: have a better way to handle failure here
 		 */
-		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
+		WARN_ON_ONCE(set_cpus_allowed_ptr(task, &cpus_attach));
 
 		cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
 		cpuset_update_task_spread_flag(cs, task);
@@ -1958,9 +1953,6 @@ int __init cpuset_init(void)
 	if (err < 0)
 		return err;
 
-	if (!alloc_cpumask_var(&cpus_attach, GFP_KERNEL))
-		BUG();
-
 	number_of_cpusets = 1;
 	return 0;
 }
-- 
1.7.11.7

