Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1DSKHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 06:07:47 -0400
Received: from relay.parallels.com ([195.214.232.42]:49013 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab1DSKHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 06:07:45 -0400
Subject: [PATCH] cpuset: allow empty cpu/node masks
To: Paul Menage <menage@google.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: <linux-kernel@vger.kernel.org>
Date: Tue, 19 Apr 2011 14:07:39 +0400
Message-ID: <20110419100739.8464.80475.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to attach tasks to cpusets with empty cpu/node masks.
Handle empty masks with help guarantee_online_cpus() and guarantee_online_mems()

This aimed to fix attaching tasks to the newly created cgroups in hierarchies with
cpuset subsystem. Cpuset always require initializing cpuset.cpus and cpuset.mems,
because they are empty by default, this fact block task attaching with -ENOSPC.

After this patch empty masks are always handled by waking up the cpuset hierarchy
and searching valid masks on parents. cpuset_attach() already handle it corretly.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 kernel/cpuset.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 33eee16..e32453a 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -226,6 +226,9 @@ static char cpuset_name[CPUSET_NAME_LEN];
 static char cpuset_nodelist[CPUSET_NODELIST_LEN];
 static DEFINE_SPINLOCK(cpuset_buffer_lock);
 
+/* Protected by cgroup_lock */
+static cpumask_var_t cpus_attach;
+
 /*
  * This is ugly, but preserves the userspace API for existing cpuset
  * users. If someone tries to mount the "cpuset" filesystem, we
@@ -428,8 +431,10 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 
 	/* Cpusets with tasks can't have empty cpus_allowed or mems_allowed */
 	if (cgroup_task_count(cur->css.cgroup)) {
-		if (cpumask_empty(trial->cpus_allowed) ||
-		    nodes_empty(trial->mems_allowed)) {
+		if ((!cpumask_empty(cur->cpus_allowed) &&
+		      cpumask_empty(trial->cpus_allowed)) ||
+		     (!nodes_empty(cur->mems_allowed) &&
+		       nodes_empty(trial->mems_allowed))) {
 			return -ENOSPC;
 		}
 	}
@@ -797,8 +802,7 @@ void rebuild_sched_domains(void)
 static int cpuset_test_cpumask(struct task_struct *tsk,
 			       struct cgroup_scanner *scan)
 {
-	return !cpumask_equal(&tsk->cpus_allowed,
-			(cgroup_cs(scan->cg))->cpus_allowed);
+	return !cpumask_equal(&tsk->cpus_allowed, cpus_attach);
 }
 
 /**
@@ -815,7 +819,7 @@ static int cpuset_test_cpumask(struct task_struct *tsk,
 static void cpuset_change_cpumask(struct task_struct *tsk,
 				  struct cgroup_scanner *scan)
 {
-	set_cpus_allowed_ptr(tsk, ((cgroup_cs(scan->cg))->cpus_allowed));
+	set_cpus_allowed_ptr(tsk, cpus_attach);
 }
 
 /**
@@ -835,6 +839,7 @@ static void update_tasks_cpumask(struct cpuset *cs, struct ptr_heap *heap)
 {
 	struct cgroup_scanner scan;
 
+	guarantee_online_cpus(cs, cpus_attach);
 	scan.cg = cs->css.cgroup;
 	scan.test_task = cpuset_test_cpumask;
 	scan.process_task = cpuset_change_cpumask;
@@ -1367,18 +1372,11 @@ static int fmeter_getrate(struct fmeter *fmp)
 	return val;
 }
 
-/* Protected by cgroup_lock */
-static cpumask_var_t cpus_attach;
-
 /* Called by cgroups to determine if a cpuset is usable; cgroup_mutex held */
 static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 			     struct task_struct *tsk, bool threadgroup)
 {
 	int ret;
-	struct cpuset *cs = cgroup_cs(cont);
-
-	if (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
-		return -ENOSPC;
 
 	/*
 	 * Kthreads bound to specific cpus cannot be moved to a new cpuset; we

