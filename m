Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab2FZNss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 09:48:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41844 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781Ab2FZNsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 09:48:47 -0400
Message-ID: <1340718515.21991.83.camel@twins>
Subject: Re: [RFC][PATCH] sched: Fix race in task_group()
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: mingo@kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Vagin <avagin@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Date: Tue, 26 Jun 2012 15:48:35 +0200
In-Reply-To: <4FE48A09.7050305@canonical.com>
References: <1340364965.18025.71.camel@twins>
	 <4FE48A09.7050305@canonical.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's one that's actually compile tested (with the right CONFIG_foo
enabled) and I fixed the autogroup lockdep splat.

---
Subject: sched: Fix race in task_group()
From: Peter Zijlstra <peterz@infradead.org>
Date: Fri, 22 Jun 2012 13:36:05 +0200

Stefan reported a crash on a kernel before a3e5d1091c1 ("sched: Don't
call task_group() too many times in set_task_rq()"), he found the reason
to be that the multiple task_group() invocations in set_task_rq()
returned different values.

Looking at all that I found a lack of serialization and plain wrong
comments.

The below tries to fix it using an extra pointer which is updated under
the appropriate scheduler locks. Its not pretty, but I can't really see
another way given how all the cgroup stuff works.

Reported-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/init_task.h |   12 +++++++++++-
 include/linux/sched.h     |    5 ++++-
 kernel/sched/core.c       |    9 ++++++++-
 kernel/sched/sched.h      |   23 ++++++++++-------------
 4 files changed, 33 insertions(+), 16 deletions(-)

--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -123,8 +123,17 @@ extern struct group_info init_groups;
 
 extern struct cred init_cred;
 
+extern struct task_group root_task_group;
+
+#ifdef CONFIG_CGROUP_SCHED
+# define INIT_CGROUP_SCHED(tsk)						\
+	.sched_task_group = &root_task_group,
+#else
+# define INIT_CGROUP_SCHED(tsk)
+#endif
+
 #ifdef CONFIG_PERF_EVENTS
-# define INIT_PERF_EVENTS(tsk)					\
+# define INIT_PERF_EVENTS(tsk)						\
 	.perf_event_mutex = 						\
 		 __MUTEX_INITIALIZER(tsk.perf_event_mutex),		\
 	.perf_event_list = LIST_HEAD_INIT(tsk.perf_event_list),
@@ -168,6 +177,7 @@ extern struct cred init_cred;
 	},								\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
 	INIT_PUSHABLE_TASKS(tsk)					\
+	INIT_CGROUP_SCHED(tsk)						\
 	.ptraced	= LIST_HEAD_INIT(tsk.ptraced),			\
 	.ptrace_entry	= LIST_HEAD_INIT(tsk.ptrace_entry),		\
 	.real_parent	= &tsk,						\
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1246,6 +1246,9 @@ struct task_struct {
 	const struct sched_class *sched_class;
 	struct sched_entity se;
 	struct sched_rt_entity rt;
+#ifdef CONFIG_CGROUP_SCHED
+	struct task_group *sched_task_group;
+#endif
 
 #ifdef CONFIG_NUMA
 	unsigned long	 numa_contrib;
@@ -2749,7 +2752,7 @@ extern int sched_group_set_rt_period(str
 extern long sched_group_rt_period(struct task_group *tg);
 extern int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk);
 #endif
-#endif
+#endif /* CONFIG_CGROUP_SCHED */
 
 extern int task_can_switch_user(struct user_struct *up,
 					struct task_struct *tsk);
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1096,7 +1096,7 @@ void set_task_cpu(struct task_struct *p,
 	 * a task's CPU. ->pi_lock for waking tasks, rq->lock for runnable tasks.
 	 *
 	 * sched_move_task() holds both and thus holding either pins the cgroup,
-	 * see set_task_rq().
+	 * see task_group().
 	 *
 	 * Furthermore, all task_rq users should acquire both locks, see
 	 * task_rq_lock().
@@ -7712,6 +7712,7 @@ void sched_destroy_group(struct task_gro
  */
 void sched_move_task(struct task_struct *tsk)
 {
+	struct task_group *tg;
 	int on_rq, running;
 	unsigned long flags;
 	struct rq *rq;
@@ -7726,6 +7727,12 @@ void sched_move_task(struct task_struct
 	if (unlikely(running))
 		tsk->sched_class->put_prev_task(rq, tsk);
 
+	tg = container_of(task_subsys_state_check(tsk, cpu_cgroup_subsys_id,
+				lockdep_is_held(&tsk->sighand->siglock)),
+			  struct task_group, css);
+	tg = autogroup_task_group(tsk, tg);
+	tsk->sched_task_group = tg;
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	if (tsk->sched_class->task_move_group)
 		tsk->sched_class->task_move_group(tsk, on_rq);
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -554,22 +554,19 @@ extern int group_balance_cpu(struct sche
 /*
  * Return the group to which this tasks belongs.
  *
- * We use task_subsys_state_check() and extend the RCU verification with
- * pi->lock and rq->lock because cpu_cgroup_attach() holds those locks for each
- * task it moves into the cgroup. Therefore by holding either of those locks,
- * we pin the task to the current cgroup.
+ * We cannot use task_subsys_state() and friends because the cgroup
+ * subsystem changes that value before the cgroup_subsys::attach() method
+ * is called, therefore we cannot pin it and might observe the wrong value.
+ *
+ * The same is true for autogroup's p->signal->autogroup->tg, the autogroup
+ * core changes this before calling sched_move_task().
+ *
+ * Instead we use a 'copy' which is updated from sched_move_task() while
+ * holding both task_struct::pi_lock and rq::lock.
  */
 static inline struct task_group *task_group(struct task_struct *p)
 {
-	struct task_group *tg;
-	struct cgroup_subsys_state *css;
-
-	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
-			lockdep_is_held(&p->pi_lock) ||
-			lockdep_is_held(&task_rq(p)->lock));
-	tg = container_of(css, struct task_group, css);
-
-	return autogroup_task_group(p, tg);
+	return p->sched_task_group;
 }
 
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */

