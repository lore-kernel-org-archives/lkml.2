Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1ABIAU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:00:20 -0500
Received: from mail.windriver.com ([147.11.1.11]:35189 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab1ABHW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:57 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 087/260] sched: Make select_fallback_rq() cpuset friendly
Date: Sun,  2 Jan 2011 02:16:23 -0500
Message-Id: <1293952756-15010-88-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:45.0320 (UTC) FILETIME=[B6055E80:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit 9084bb8246ea935b98320554229e2f371f7f52fa upstream.

Introduce cpuset_cpus_allowed_fallback() helper to fix the cpuset problems
with select_fallback_rq(). It can be called from any context and can't use
any cpuset locks including task_lock(). It is called when the task doesn't
have online cpus in ->cpus_allowed but ttwu/etc must be able to find a
suitable cpu.

I am not proud of this patch. Everything which needs such a fat comment
can't be good even if correct. But I'd prefer to not change the locking
rules in the code I hardly understand, and in any case I believe this
simple change make the code much more correct compared to deadlocks we
currently have.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100315091027.GA9155@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/cpuset.h |    7 +++++++
 kernel/cpuset.c        |   42 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched.c         |    4 +---
 3 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index eeaaee7..a73454a 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -21,6 +21,7 @@ extern int number_of_cpusets;	/* How many cpusets are defined in system? */
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
+extern int cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -101,6 +102,12 @@ static inline void cpuset_cpus_allowed(struct task_struct *p,
 	cpumask_copy(mask, cpu_possible_mask);
 }
 
+static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
+{
+	cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
+	return cpumask_any(cpu_active_mask);
+}
+
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
 {
 	return node_possible_map;
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 9a747f5..9a50c5f 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2188,6 +2188,48 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 	mutex_unlock(&callback_mutex);
 }
 
+int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
+{
+	const struct cpuset *cs;
+	int cpu;
+
+	rcu_read_lock();
+	cs = task_cs(tsk);
+	if (cs)
+		cpumask_copy(&tsk->cpus_allowed, cs->cpus_allowed);
+	rcu_read_unlock();
+
+	/*
+	 * We own tsk->cpus_allowed, nobody can change it under us.
+	 *
+	 * But we used cs && cs->cpus_allowed lockless and thus can
+	 * race with cgroup_attach_task() or update_cpumask() and get
+	 * the wrong tsk->cpus_allowed. However, both cases imply the
+	 * subsequent cpuset_change_cpumask()->set_cpus_allowed_ptr()
+	 * which takes task_rq_lock().
+	 *
+	 * If we are called after it dropped the lock we must see all
+	 * changes in tsk_cs()->cpus_allowed. Otherwise we can temporary
+	 * set any mask even if it is not right from task_cs() pov,
+	 * the pending set_cpus_allowed_ptr() will fix things.
+	 */
+
+	cpu = cpumask_any_and(&tsk->cpus_allowed, cpu_active_mask);
+	if (cpu >= nr_cpu_ids) {
+		/*
+		 * Either tsk->cpus_allowed is wrong (see above) or it
+		 * is actually empty. The latter case is only possible
+		 * if we are racing with remove_tasks_in_empty_cpuset().
+		 * Like above we can temporary set any mask and rely on
+		 * set_cpus_allowed_ptr() as synchronization point.
+		 */
+		cpumask_copy(&tsk->cpus_allowed, cpu_possible_mask);
+		cpu = cpumask_any(cpu_active_mask);
+	}
+
+	return cpu;
+}
+
 void cpuset_init_current_mems_allowed(void)
 {
 	nodes_setall(current->mems_allowed);
diff --git a/kernel/sched.c b/kernel/sched.c
index cc1ba47..b969a56 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2306,9 +2306,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 
 	/* No more Mr. Nice Guy. */
 	if (unlikely(dest_cpu >= nr_cpu_ids)) {
-		cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
-		dest_cpu = cpumask_any(cpu_active_mask);
-
+		dest_cpu = cpuset_cpus_allowed_fallback(p);
 		/*
 		 * Don't tell them about moving exiting tasks or
 		 * kernel threads (both mm NULL), since they never
-- 
1.7.3.3

