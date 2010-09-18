Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab0IRTL4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:11:56 -0400
Received: from kroah.org ([198.145.64.141]:51761 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023Ab0IRTCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:15 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:01 2010
Message-Id: <20100918190001.216454704@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Oleg Nesterov <oleg@redhat.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [098/123] sched: Make select_fallback_rq() cpuset friendly
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-make-select_fallback_rq-cpuset-friendly.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit 9084bb8246ea935b98320554229e2f371f7f52fa upstream

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
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/cpuset.h |    7 +++++++
 kernel/cpuset.c        |   42 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched.c         |    4 +---
 3 files changed, 50 insertions(+), 3 deletions(-)

--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -21,6 +21,7 @@ extern int number_of_cpusets;	/* How man
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
+extern int cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -101,6 +102,12 @@ static inline void cpuset_cpus_allowed(s
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
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2151,6 +2151,48 @@ void cpuset_cpus_allowed(struct task_str
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
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2353,9 +2353,7 @@ static int select_fallback_rq(int cpu, s
 
 	/* No more Mr. Nice Guy. */
 	if (unlikely(dest_cpu >= nr_cpu_ids)) {
-		cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
-		dest_cpu = cpumask_any(cpu_active_mask);
-
+		dest_cpu = cpuset_cpus_allowed_fallback(p);
 		/*
 		 * Don't tell them about moving exiting tasks or
 		 * kernel threads (both mm NULL), since they never


