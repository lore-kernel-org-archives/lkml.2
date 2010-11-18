Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636Ab0KRUBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:01:16 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:51820 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759314Ab0KRUBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:01:15 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+hwQZsh8uhBTYJz/VBeZJi2O2xWxQwrL/pHl79LN
	0WQTYN0QxxlHBl
Subject: Re: Galbraith patch
From: Mike Galbraith <efault@gmx.de>
To: Thomas Backlund <tmb@mandriva.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4CE5731B.20807@mandriva.org>
References: <1290018947.4887.14.camel@note-311a>
	 <AANLkTi=3nDO7QtezcoOyimPvXqLBgxtO18HjjuT_6WKb@mail.gmail.com>
	 <AANLkTinRBvZQmeU-eEeDSd1ELvcxDZAdM6F8-UCROybq@mail.gmail.com>
	 <1290021497.4887.24.camel@note-311a>
	 <1290036097.27521.5.camel@maggy.simson.net>
	 <1290095008.9939.0.camel@note-311a>
	 <1290096365.30211.5.camel@maggy.simson.net>  <4CE5731B.20807@mandriva.org>
Content-Type: multipart/mixed; boundary="=-asPunzF+iVH9lh6zR05z"
Date: Thu, 18 Nov 2010 13:00:56 -0700
Message-ID: <1290110456.10702.12.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-asPunzF+iVH9lh6zR05z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2010-11-18 at 20:40 +0200, Thomas Backlund wrote:

> and more importantly it misses theese:

Heh.  Apply the attached, autogroup last.



--=-asPunzF+iVH9lh6zR05z
Content-Disposition: attachment; filename="cgroup_fixup_broken_cgroup_movement.diff"
Content-Type: text/x-patch; name="cgroup_fixup_broken_cgroup_movement.diff"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Subject: sched, cgroup: Fixup broken cgroup movement
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Oct 15 15:24:15 CEST 2010


Reported-by: Dima Zavin <dima@android.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    2 +-
 kernel/sched.c        |    8 ++++----
 kernel/sched_fair.c   |   25 +++++++++++++++++++------
 3 files changed, 24 insertions(+), 11 deletions(-)

Index: linux-2.6.36.git/kernel/sched.c
===================================================================
--- linux-2.6.36.git.orig/kernel/sched.c
+++ linux-2.6.36.git/kernel/sched.c
@@ -8297,12 +8297,12 @@ void sched_move_task(struct task_struct
 	if (unlikely(running))
 		tsk->sched_class->put_prev_task(rq, tsk);
 
-	set_task_rq(tsk, task_cpu(tsk));
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	if (tsk->sched_class->moved_group)
-		tsk->sched_class->moved_group(tsk, on_rq);
+	if (tsk->sched_class->task_move_group)
+		tsk->sched_class->task_move_group(tsk, on_rq);
+	else
 #endif
+		set_task_rq(tsk, task_cpu(tsk));
 
 	if (unlikely(running))
 		tsk->sched_class->set_curr_task(rq);
Index: linux-2.6.36.git/include/linux/sched.h
===================================================================
--- linux-2.6.36.git.orig/include/linux/sched.h
+++ linux-2.6.36.git/include/linux/sched.h
@@ -1072,7 +1072,7 @@ struct sched_class {
 					 struct task_struct *task);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	void (*moved_group) (struct task_struct *p, int on_rq);
+	void (*task_move_group) (struct task_struct *p, int on_rq);
 #endif
 };
 
Index: linux-2.6.36.git/kernel/sched_fair.c
===================================================================
--- linux-2.6.36.git.orig/kernel/sched_fair.c
+++ linux-2.6.36.git/kernel/sched_fair.c
@@ -3824,13 +3824,26 @@ static void set_curr_task_fair(struct rq
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void moved_group_fair(struct task_struct *p, int on_rq)
+static void task_move_group_fair(struct task_struct *p, int on_rq)
 {
-	struct cfs_rq *cfs_rq = task_cfs_rq(p);
-
-	update_curr(cfs_rq);
+	/*
+	 * If the task was not on the rq at the time of this cgroup movement
+	 * it must have been asleep, sleeping tasks keep their ->vruntime
+	 * absolute on their old rq until wakeup (needed for the fair sleeper
+	 * bonus in place_entity()).
+	 *
+	 * If it was on the rq, we've just 'preempted' it, which does convert
+	 * ->vruntime to a relative base.
+	 *
+	 * Make sure both cases convert their relative position when migrating
+	 * to another cgroup's rq. This does somewhat interfere with the
+	 * fair sleeper stuff for the first placement, but who cares.
+	 */
+	if (!on_rq)
+		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
+	set_task_rq(p, task_cpu(p));
 	if (!on_rq)
-		place_entity(cfs_rq, &p->se, 1);
+		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
 }
 #endif
 
@@ -3882,7 +3895,7 @@ static const struct sched_class fair_sch
 	.get_rr_interval	= get_rr_interval_fair,
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	.moved_group		= moved_group_fair,
+	.task_move_group	= task_move_group_fair,
 #endif
 };
 

--=-asPunzF+iVH9lh6zR05z
Content-Disposition: attachment; filename="sched_autogroup.diff"
Content-Type: text/x-patch; name="sched_autogroup.diff"; charset="UTF-8"
Content-Transfer-Encoding: 8bit

A recurring complaint from CFS users is that parallel kbuild has a negative
impact on desktop interactivity.  This patch implements an idea from Linus,
to automatically create task groups.  This patch only per session autogroups,
but leaves the way open for enhancement.

Implementation: each task's signal struct contains an inherited pointer to a
refcounted autogroup struct containing a task group pointer, the default for
all tasks pointing to the init_task_group.  When a task calls setsid(), the
process wide reference to the default group is dropped, a new task group is
created, and the process is moved into the new task group.  Children thereafter
inherit this task group, and increase it's refcount.  On exit, a reference to the
current task group is dropped when the last reference to each signal struct is
dropped.  The task group is destroyed when the last signal struct referencing
it is freed.   At runqueue selection time, IFF a task has no cgroup assignment,
it's current autogroup is used.

The feature is enabled from boot by default if CONFIG_SCHED_AUTOGROUP is
selected, but can be disabled via the boot option noautogroup, and can be
also be turned on/off on the fly via..
   echo [01] > /proc/sys/kernel/sched_autogroup_enabled.
..which will automatically move tasks to/from the root task group.

Some numbers.

A 100% hog overhead measurement proggy pinned to the same CPU as a make -j10

About measurement proggy:
  pert/sec = perturbations/sec
  min/max/avg = scheduler service latencies in usecs
  sum/s = time accrued by the competition per sample period (1 sec here)
  overhead = %CPU received by the competition per sample period

pert/s:       31 >40475.37us:        3 min:  0.37 max:48103.60 avg:29573.74 sum/s:916786us overhead:90.24%
pert/s:       23 >41237.70us:       12 min:  0.36 max:56010.39 avg:40187.01 sum/s:924301us overhead:91.99%
pert/s:       24 >42150.22us:       12 min:  8.86 max:61265.91 avg:39459.91 sum/s:947038us overhead:92.20%
pert/s:       26 >42344.91us:       11 min:  3.83 max:52029.60 avg:36164.70 sum/s:940282us overhead:91.12%
pert/s:       24 >44262.90us:       14 min:  5.05 max:82735.15 avg:40314.33 sum/s:967544us overhead:92.22%

Same load with this patch applied.

pert/s:      229 >5484.43us:       41 min:  0.15 max:12069.42 avg:2193.81 sum/s:502382us overhead:50.24%
pert/s:      222 >5652.28us:       43 min:  0.46 max:12077.31 avg:2248.56 sum/s:499181us overhead:49.92%
pert/s:      211 >5809.38us:       43 min:  0.16 max:12064.78 avg:2381.70 sum/s:502538us overhead:50.25%
pert/s:      223 >6147.92us:       43 min:  0.15 max:16107.46 avg:2282.17 sum/s:508925us overhead:50.49%
pert/s:      218 >6252.64us:       43 min:  0.16 max:12066.13 avg:2324.11 sum/s:506656us overhead:50.27%

Average service latency is an order of magnitude better with autogroup.
(Imagine that pert were Xorg or whatnot instead)

Using Mathieu Desnoyers' wakeup-latency testcase:

With taskset -c 3 make -j 10 running..

taskset -c 3 ./wakeup-latency& sleep 30;killall wakeup-latency

without:
maximum latency: 42963.2 µs
average latency: 9077.0 µs
missed timer events: 0

with:
maximum latency: 4160.7 µs
average latency: 149.4 µs
missed timer events: 0

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 Documentation/kernel-parameters.txt |    2 
 include/linux/sched.h               |   19 ++++
 init/Kconfig                        |   12 ++
 kernel/fork.c                       |    5 -
 kernel/sched.c                      |   13 ++
 kernel/sched_autogroup.c            |  170 ++++++++++++++++++++++++++++++++++++
 kernel/sched_autogroup.h            |   23 ++++
 kernel/sched_debug.c                |   29 +++---
 kernel/sys.c                        |    4 
 kernel/sysctl.c                     |   11 ++
 10 files changed, 270 insertions(+), 18 deletions(-)

Index: linux-2.6.36/include/linux/sched.h
===================================================================
--- linux-2.6.36.orig/include/linux/sched.h
+++ linux-2.6.36/include/linux/sched.h
@@ -506,6 +506,8 @@ struct thread_group_cputimer {
 	spinlock_t lock;
 };
 
+struct autogroup;
+
 /*
  * NOTE! "signal_struct" does not have it's own
  * locking, because a shared signal_struct always
@@ -573,6 +575,9 @@ struct signal_struct {
 
 	struct tty_struct *tty; /* NULL if no tty */
 
+#ifdef CONFIG_SCHED_AUTOGROUP
+	struct autogroup *autogroup;
+#endif
 	/*
 	 * Cumulative resource counters for dead threads in the group,
 	 * and for reaped dead child processes forked by this group.
@@ -1900,6 +1905,20 @@ int sched_rt_handler(struct ctl_table *t
 
 extern unsigned int sysctl_sched_compat_yield;
 
+#ifdef CONFIG_SCHED_AUTOGROUP
+extern unsigned int sysctl_sched_autogroup_enabled;
+
+extern void sched_autogroup_create_attach(struct task_struct *p);
+extern void sched_autogroup_detach(struct task_struct *p);
+extern void sched_autogroup_fork(struct signal_struct *sig);
+extern void sched_autogroup_exit(struct signal_struct *sig);
+#else
+static inline void sched_autogroup_create_attach(struct task_struct *p) { }
+static inline void sched_autogroup_detach(struct task_struct *p) { }
+static inline void sched_autogroup_fork(struct signal_struct *sig) { }
+static inline void sched_autogroup_exit(struct signal_struct *sig) { }
+#endif
+
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
Index: linux-2.6.36/kernel/sched.c
===================================================================
--- linux-2.6.36.orig/kernel/sched.c
+++ linux-2.6.36/kernel/sched.c
@@ -78,6 +78,7 @@
 
 #include "sched_cpupri.h"
 #include "workqueue_sched.h"
+#include "sched_autogroup.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
@@ -268,6 +269,10 @@ struct task_group {
 	struct task_group *parent;
 	struct list_head siblings;
 	struct list_head children;
+
+#if (defined(CONFIG_SCHED_AUTOGROUP) && defined(CONFIG_SCHED_DEBUG))
+	struct autogroup *autogroup;
+#endif
 };
 
 #define root_task_group init_task_group
@@ -612,11 +617,14 @@ static inline int cpu_of(struct rq *rq)
  */
 static inline struct task_group *task_group(struct task_struct *p)
 {
+	struct task_group *tg;
 	struct cgroup_subsys_state *css;
 
 	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
 			lockdep_is_held(&task_rq(p)->lock));
-	return container_of(css, struct task_group, css);
+	tg = container_of(css, struct task_group, css);
+
+	return autogroup_task_group(p, tg);
 }
 
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
@@ -1920,6 +1928,7 @@ static void deactivate_task(struct rq *r
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
+#include "sched_autogroup.c"
 #ifdef CONFIG_SCHED_DEBUG
 # include "sched_debug.c"
 #endif
@@ -7749,7 +7758,7 @@ void __init sched_init(void)
 #ifdef CONFIG_CGROUP_SCHED
 	list_add(&init_task_group.list, &task_groups);
 	INIT_LIST_HEAD(&init_task_group.children);
-
+	autogroup_init(&init_task);
 #endif /* CONFIG_CGROUP_SCHED */
 
 #if defined CONFIG_FAIR_GROUP_SCHED && defined CONFIG_SMP
Index: linux-2.6.36/kernel/fork.c
===================================================================
--- linux-2.6.36.orig/kernel/fork.c
+++ linux-2.6.36/kernel/fork.c
@@ -173,8 +173,10 @@ static inline void free_signal_struct(st
 
 static inline void put_signal_struct(struct signal_struct *sig)
 {
-	if (atomic_dec_and_test(&sig->sigcnt))
+	if (atomic_dec_and_test(&sig->sigcnt)) {
+		sched_autogroup_exit(sig);
 		free_signal_struct(sig);
+	}
 }
 
 void __put_task_struct(struct task_struct *tsk)
@@ -900,6 +902,7 @@ static int copy_signal(unsigned long clo
 	posix_cpu_timers_init_group(sig);
 
 	tty_audit_fork(sig);
+	sched_autogroup_fork(sig);
 
 	sig->oom_adj = current->signal->oom_adj;
 	sig->oom_score_adj = current->signal->oom_score_adj;
Index: linux-2.6.36/kernel/sys.c
===================================================================
--- linux-2.6.36.orig/kernel/sys.c
+++ linux-2.6.36/kernel/sys.c
@@ -1080,8 +1080,10 @@ SYSCALL_DEFINE0(setsid)
 	err = session;
 out:
 	write_unlock_irq(&tasklist_lock);
-	if (err > 0)
+	if (err > 0) {
 		proc_sid_connector(group_leader);
+		sched_autogroup_create_attach(group_leader);
+	}
 	return err;
 }
 
Index: linux-2.6.36/kernel/sched_debug.c
===================================================================
--- linux-2.6.36.orig/kernel/sched_debug.c
+++ linux-2.6.36/kernel/sched_debug.c
@@ -87,6 +87,20 @@ static void print_cfs_group_stats(struct
 }
 #endif
 
+#if defined(CONFIG_CGROUP_SCHED) && \
+	(defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED))
+static void task_group_path(struct task_group *tg, char *buf, int buflen)
+{
+	/* may be NULL if the underlying cgroup isn't fully-created yet */
+	if (!tg->css.cgroup) {
+		buf[0] = '\0';
+		autogroup_path(tg, buf, buflen);
+		return;
+	}
+	cgroup_path(tg->css.cgroup, buf, buflen);
+}
+#endif
+
 static void
 print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 {
@@ -115,7 +129,7 @@ print_task(struct seq_file *m, struct rq
 		char path[64];
 
 		rcu_read_lock();
-		cgroup_path(task_group(p)->css.cgroup, path, sizeof(path));
+		task_group_path(task_group(p), path, sizeof(path));
 		rcu_read_unlock();
 		SEQ_printf(m, " %s", path);
 	}
@@ -147,19 +161,6 @@ static void print_rq(struct seq_file *m,
 	read_unlock_irqrestore(&tasklist_lock, flags);
 }
 
-#if defined(CONFIG_CGROUP_SCHED) && \
-	(defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED))
-static void task_group_path(struct task_group *tg, char *buf, int buflen)
-{
-	/* may be NULL if the underlying cgroup isn't fully-created yet */
-	if (!tg->css.cgroup) {
-		buf[0] = '\0';
-		return;
-	}
-	cgroup_path(tg->css.cgroup, buf, buflen);
-}
-#endif
-
 void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 {
 	s64 MIN_vruntime = -1, min_vruntime, max_vruntime = -1,
Index: linux-2.6.36/kernel/sched_autogroup.h
===================================================================
--- /dev/null
+++ linux-2.6.36/kernel/sched_autogroup.h
@@ -0,0 +1,23 @@
+#ifdef CONFIG_SCHED_AUTOGROUP
+
+static inline struct task_group *
+autogroup_task_group(struct task_struct *p, struct task_group *tg);
+
+#else /* !CONFIG_SCHED_AUTOGROUP */
+
+static inline void autogroup_init(struct task_struct *init_task) {  }
+
+static inline struct task_group *
+autogroup_task_group(struct task_struct *p, struct task_group *tg)
+{
+	return tg;
+}
+
+#ifdef CONFIG_SCHED_DEBUG
+static inline int autogroup_path(struct task_group *tg, char *buf, int buflen)
+{
+	return 0;
+}
+#endif
+
+#endif /* CONFIG_SCHED_AUTOGROUP */
Index: linux-2.6.36/kernel/sched_autogroup.c
===================================================================
--- /dev/null
+++ linux-2.6.36/kernel/sched_autogroup.c
@@ -0,0 +1,170 @@
+#ifdef CONFIG_SCHED_AUTOGROUP
+
+unsigned int __read_mostly sysctl_sched_autogroup_enabled = 1;
+
+struct autogroup {
+	struct task_group	*tg;
+	struct kref		kref;
+	unsigned long		id;
+};
+
+static struct autogroup autogroup_default;
+static atomic_t autogroup_seq_nr;
+
+static void autogroup_init(struct task_struct *init_task)
+{
+	autogroup_default.tg = &init_task_group;
+	autogroup_default.id = 0;
+	atomic_set(&autogroup_seq_nr, 1);
+	kref_init(&autogroup_default.kref);
+	init_task->signal->autogroup = &autogroup_default;
+}
+
+static inline void autogroup_destroy(struct kref *kref)
+{
+	struct autogroup *ag = container_of(kref, struct autogroup, kref);
+	struct task_group *tg = ag->tg;
+
+	kfree(ag);
+	sched_destroy_group(tg);
+}
+
+static inline void autogroup_kref_put(struct autogroup *ag)
+{
+	kref_put(&ag->kref, autogroup_destroy);
+}
+
+static inline struct autogroup *autogroup_kref_get(struct autogroup *ag)
+{
+	kref_get(&ag->kref);
+	return ag;
+}
+
+static inline struct autogroup *autogroup_create(void)
+{
+	struct autogroup *ag = kmalloc(sizeof(*ag), GFP_KERNEL);
+
+	if (!ag)
+		goto out_fail;
+
+	ag->tg = sched_create_group(&init_task_group);
+
+	if (IS_ERR(ag->tg))
+		goto out_fail;
+
+	kref_init(&ag->kref);
+	ag->tg->autogroup = ag;
+	ag->id = atomic_inc_return(&autogroup_seq_nr);
+
+	return ag;
+
+out_fail:
+	if (ag) {
+		kfree(ag);
+		WARN_ON(1);
+	} else
+		WARN_ON(1);
+
+	return autogroup_kref_get(&autogroup_default);
+}
+
+static inline bool
+task_wants_autogroup(struct task_struct *p, struct task_group *tg)
+{
+	if (tg != &root_task_group)
+		return false;
+
+	if (p->sched_class != &fair_sched_class)
+		return false;
+
+	if (p->flags & PF_EXITING)
+		return false;
+
+	return true;
+}
+
+static inline struct task_group *
+autogroup_task_group(struct task_struct *p, struct task_group *tg)
+{
+	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
+
+	if (enabled && task_wants_autogroup(p, tg))
+		return p->signal->autogroup->tg;
+
+	return tg;
+}
+
+static void
+autogroup_move_group(struct task_struct *p, struct autogroup *ag)
+{
+	struct autogroup *prev;
+	struct task_struct *t;
+
+	spin_lock(&p->sighand->siglock);
+
+	prev = p->signal->autogroup;
+	if (prev == ag) {
+		spin_unlock(&p->sighand->siglock);
+		return;
+	}
+
+	p->signal->autogroup = autogroup_kref_get(ag);
+	t = p;
+
+	do {
+		sched_move_task(p);
+	} while_each_thread(p, t);
+
+	spin_unlock(&p->sighand->siglock);
+
+	autogroup_kref_put(prev);
+}
+
+/* Allocates GFP_KERNEL, cannot be called under any spinlock */
+void sched_autogroup_create_attach(struct task_struct *p)
+{
+	struct autogroup *ag = autogroup_create();
+
+	autogroup_move_group(p, ag);
+	/* drop extra refrence added by autogroup_create() */
+	autogroup_kref_put(ag);
+}
+EXPORT_SYMBOL(sched_autogroup_create_attach);
+
+/* Cannot be called under siglock.  Currently has no users */
+void sched_autogroup_detach(struct task_struct *p)
+{
+	autogroup_move_group(p, &autogroup_default);
+}
+EXPORT_SYMBOL(sched_autogroup_detach);
+
+void sched_autogroup_fork(struct signal_struct *sig)
+{
+	struct sighand_struct *sighand = current->sighand;
+
+	spin_lock(&sighand->siglock);
+	sig->autogroup = autogroup_kref_get(current->signal->autogroup);
+	spin_unlock(&sighand->siglock);
+}
+
+void sched_autogroup_exit(struct signal_struct *sig)
+{
+	autogroup_kref_put(sig->autogroup);
+}
+
+static int __init setup_autogroup(char *str)
+{
+	sysctl_sched_autogroup_enabled = 0;
+
+	return 1;
+}
+
+__setup("noautogroup", setup_autogroup);
+
+#ifdef CONFIG_SCHED_DEBUG
+static inline int autogroup_path(struct task_group *tg, char *buf, int buflen)
+{
+	return snprintf(buf, buflen, "%s-%ld", "autogroup", tg->autogroup->id);
+}
+#endif
+#endif /* CONFIG_SCHED_AUTOGROUP */
Index: linux-2.6.36/kernel/sysctl.c
===================================================================
--- linux-2.6.36.orig/kernel/sysctl.c
+++ linux-2.6.36/kernel/sysctl.c
@@ -384,6 +384,17 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#ifdef CONFIG_SCHED_AUTOGROUP
+	{
+		.procname	= "sched_autogroup_enabled",
+		.data		= &sysctl_sched_autogroup_enabled,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.procname	= "prove_locking",
Index: linux-2.6.36/init/Kconfig
===================================================================
--- linux-2.6.36.orig/init/Kconfig
+++ linux-2.6.36/init/Kconfig
@@ -652,6 +652,18 @@ config DEBUG_BLK_CGROUP
 
 endif # CGROUPS
 
+config SCHED_AUTOGROUP
+	bool "Automatic process group scheduling"
+	select CGROUPS
+	select CGROUP_SCHED
+	select FAIR_GROUP_SCHED
+	help
+	  This option optimizes the scheduler for common desktop workloads by
+	  automatically creating and populating task groups.  This separation
+	  of workloads isolates aggressive CPU burners (like build jobs) from
+	  desktop applications.  Task group autogeneration is currently based
+	  upon task session.
+
 config MM_OWNER
 	bool
 
Index: linux-2.6.36/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.36.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.36/Documentation/kernel-parameters.txt
@@ -1610,6 +1610,8 @@ and is between 256 and 4096 characters.
 	noapic		[SMP,APIC] Tells the kernel to not make use of any
 			IOAPICs that may be present in the system.
 
+	noautogroup	Disable scheduler automatic task group creation.
+
 	nobats		[PPC] Do not use BATs for mapping kernel lowmem
 			on "Classic" PPC cores.
 

--=-asPunzF+iVH9lh6zR05z--

