Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab0KNRT3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 12:19:29 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:48626 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756418Ab0KNRT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 12:19:28 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19PzHQQqy1PVLq7CxKS1ZNKOHPMoDOPvItuUK65x4
	db+vhI1dH6xjUu
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
In-Reply-To: <1289648524.22764.149.camel@maggy.simson.net>
References: <1287648715.9021.20.camel@marge.simson.net>
	 <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>
	 <20101021162924.GA3225@redhat.com>
	 <1288076838.11930.1.camel@marge.simson.net>
	 <1288078144.7478.9.camel@marge.simson.net>
	 <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
	 <1289489200.11397.21.camel@maggy.simson.net>
	 <20101111202703.GA16282@redhat.com>
	 <1289514000.21413.204.camel@maggy.simson.net>
	 <20101112181240.GB8659@redhat.com>
	 <1289648524.22764.149.camel@maggy.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Nov 2010 10:19:10 -0700
Message-ID: <1289755150.3228.44.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-13 at 04:42 -0700, Mike Galbraith wrote:
> On Fri, 2010-11-12 at 19:12 +0100, Oleg Nesterov wrote:
> > On 11/11, Mike Galbraith wrote:
> > >
> > > On Thu, 2010-11-11 at 21:27 +0100, Oleg Nesterov wrote:
> > >
> > > > But the real problem is that copy_process() can fail after that,
> > > > and in this case we have the unbalanced kref_get().
> > >
> > > Memory leak, will fix.
> > >
> > > > > +++ linux-2.6.36.git/kernel/exit.c
> > > > > @@ -174,6 +174,7 @@ repeat:
> > > > >  	write_lock_irq(&tasklist_lock);
> > > > >  	tracehook_finish_release_task(p);
> > > > >  	__exit_signal(p);
> > > > > +	sched_autogroup_exit(p);
> > > >
> > > > This doesn't look right. Note that "p" can run/sleep after that
> > > > (or in parallel), set_task_rq() can use the freed ->autogroup.
> > >
> > > So avoiding refcounting rcu released task_group backfired.  Crud.
> > 
> > Just in case, the lock order may be wrong. sched_autogroup_exit()
> > takes task_group_lock under write_lock(tasklist), while
> > sched_autogroup_handler() takes them in reverse order.
> 
> Bug self destructs when global classifier goes away.

I didn't nuke the handler, but did hide it under a debug option since it
is useful for testing.  If the user enables it, and turns autogroup off,
imho off should means off NOW, so I stuck with it as is.  I coded up a
lazy (tick time check) move to handle pinned tasks not otherwise being
moved, but that was too much for even my (lack of) taste to handle.

The locking should be fine as it was now, since autogroup_exit() isn't
under the tasklist lock any more.  (surprising i didn't hit any problems
with this or use after free in rt kernel given how hard i beat on it)

Pondering adding some debug bits to identify autogroup tasks, maybe
in /proc/N/cgroup or such.

> > I am not sure, but perhaps this can be simpler?
> > wake_up_new_task() does autogroup_fork(), and do_exit() does
> > sched_autogroup_exit() before the last schedule. Possible?
> 
> That's what I was going to do.  That said, I couldn't have had the
> problem if I'd tied final put directly to life of container, and am
> thinking I should do that instead when I go back to p->signal.

I ended up tying it directly to p->signal's life, and beat on it with
CONFIG_PREEMPT.  I wanted to give it a thrashing in PREEMPT_RT, but
when I snagged your signal patches, I apparently didn't snag quite
enough, as the rt kernel with those patches is early boot doorstop.

> > Very basic question. Currently sched_autogroup_create_attach()
> > has the only caller, __proc_set_tty(). It is a bit strange that
> > signal->tty change is process-wide, but sched_autogroup_create_attach()
> > move the single thread, the caller. What about other threads in
> > this thread group? The same for proc_clear_tty().
> 
> Yeah, I really should (will) move all on the spot...

Did that, and the rest.  This patch will apply to tip or .git.

patchlet:

A recurring complaint from CFS users is that parallel kbuild has a negative
impact on desktop interactivity.  This patch implements an idea from Linus,
to automatically create task groups.  This patch only implements Linus' per
tty task group suggestion, and only for fair class tasks, but leaves the way
open for enhancement.

Implementation: each task's signal struct contains an inherited pointer to a
refcounted autogroup struct containing a task group pointer, the default for
all tasks pointing to the init_task_group.  When a task calls __proc_set_tty(),
the process wide reference to the default group is dropped, a new task group is
created, and the process is moved into the new task group.  Children thereafter
inherit this task group, and increase it's refcount.  On exit, a reference to the
current task group is dropped when the last reference to each signal struct is
dropped.  The task group is destroyed when the last signal struct referencing
it is freed.   At runqueue selection time, IFF a task has no cgroup assignment,
it's current autogroup is used.

The feature is enabled from boot by default if CONFIG_SCHED_AUTOGROUP is
selected, but can be disabled via the boot option noautogroup, and can be
also be turned on/off on the fly if CONFIG_SCHED_AUTOGROUP is enabled via..
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
 drivers/tty/tty_io.c                |    1 
 include/linux/sched.h               |   22 ++++
 init/Kconfig                        |   20 ++++
 kernel/fork.c                       |    5 -
 kernel/sched.c                      |   25 +++--
 kernel/sched_autogroup.c            |  170 ++++++++++++++++++++++++++++++++++++
 kernel/sched_autogroup.h            |   18 +++
 kernel/sysctl.c                     |   11 ++
 9 files changed, 265 insertions(+), 9 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -509,6 +509,8 @@ struct thread_group_cputimer {
 	spinlock_t lock;
 };
 
+struct autogroup;
+
 /*
  * NOTE! "signal_struct" does not have it's own
  * locking, because a shared signal_struct always
@@ -576,6 +578,9 @@ struct signal_struct {
 
 	struct tty_struct *tty; /* NULL if no tty */
 
+#ifdef CONFIG_SCHED_AUTOGROUP
+	struct autogroup *autogroup;
+#endif
 	/*
 	 * Cumulative resource counters for dead threads in the group,
 	 * and for reaped dead child processes forked by this group.
@@ -1931,6 +1936,23 @@ int sched_rt_handler(struct ctl_table *t
 
 extern unsigned int sysctl_sched_compat_yield;
 
+#ifdef CONFIG_SCHED_AUTOGROUP
+#ifdef CONFIG_SCHED_AUTOGROUP_DEBUG
+extern unsigned int sysctl_sched_autogroup_enabled;
+int sched_autogroup_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos);
+#endif
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
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -78,6 +78,7 @@
 
 #include "sched_cpupri.h"
 #include "workqueue_sched.h"
+#include "sched_autogroup.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
@@ -605,11 +606,14 @@ static inline int cpu_of(struct rq *rq)
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
@@ -2006,6 +2010,7 @@ static void sched_irq_time_avg_update(st
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
+#include "sched_autogroup.c"
 #include "sched_stoptask.c"
 #ifdef CONFIG_SCHED_DEBUG
 # include "sched_debug.c"
@@ -7979,7 +7984,7 @@ void __init sched_init(void)
 #ifdef CONFIG_CGROUP_SCHED
 	list_add(&init_task_group.list, &task_groups);
 	INIT_LIST_HEAD(&init_task_group.children);
-
+	autogroup_init(&init_task);
 #endif /* CONFIG_CGROUP_SCHED */
 
 #if defined CONFIG_FAIR_GROUP_SCHED && defined CONFIG_SMP
@@ -8509,15 +8514,11 @@ void sched_destroy_group(struct task_gro
 /* change task's runqueue when it moves between groups.
  *	The caller of this function should have put the task in its new group
  *	by now. This function just updates tsk->se.cfs_rq and tsk->se.parent to
- *	reflect its new group.
+ *	reflect its new group.  Called with the runqueue lock held.
  */
-void sched_move_task(struct task_struct *tsk)
+void __sched_move_task(struct task_struct *tsk, struct rq *rq)
 {
 	int on_rq, running;
-	unsigned long flags;
-	struct rq *rq;
-
-	rq = task_rq_lock(tsk, &flags);
 
 	running = task_current(rq, tsk);
 	on_rq = tsk->se.on_rq;
@@ -8538,7 +8539,15 @@ void sched_move_task(struct task_struct
 		tsk->sched_class->set_curr_task(rq);
 	if (on_rq)
 		enqueue_task(rq, tsk, 0);
+}
 
+void sched_move_task(struct task_struct *tsk)
+{
+	struct rq *rq;
+	unsigned long flags;
+
+	rq = task_rq_lock(tsk, &flags);
+	__sched_move_task(tsk, rq);
 	task_rq_unlock(rq, &flags);
 }
 #endif /* CONFIG_CGROUP_SCHED */
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -174,8 +174,10 @@ static inline void free_signal_struct(st
 
 static inline void put_signal_struct(struct signal_struct *sig)
 {
-	if (atomic_dec_and_test(&sig->sigcnt))
+	if (atomic_dec_and_test(&sig->sigcnt)) {
+		sched_autogroup_exit(sig);
 		free_signal_struct(sig);
+	}
 }
 
 void __put_task_struct(struct task_struct *tsk)
@@ -904,6 +906,7 @@ static int copy_signal(unsigned long clo
 	posix_cpu_timers_init_group(sig);
 
 	tty_audit_fork(sig);
+	sched_autogroup_fork(sig);
 
 	sig->oom_adj = current->signal->oom_adj;
 	sig->oom_score_adj = current->signal->oom_score_adj;
Index: linux-2.6/drivers/tty/tty_io.c
===================================================================
--- linux-2.6.orig/drivers/tty/tty_io.c
+++ linux-2.6/drivers/tty/tty_io.c
@@ -3160,6 +3160,7 @@ static void __proc_set_tty(struct task_s
 	put_pid(tsk->signal->tty_old_pgrp);
 	tsk->signal->tty = tty_kref_get(tty);
 	tsk->signal->tty_old_pgrp = NULL;
+	sched_autogroup_create_attach(tsk);
 }
 
 static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
Index: linux-2.6/kernel/sched_autogroup.h
===================================================================
--- /dev/null
+++ linux-2.6/kernel/sched_autogroup.h
@@ -0,0 +1,18 @@
+#ifdef CONFIG_SCHED_AUTOGROUP
+
+static void __sched_move_task(struct task_struct *tsk, struct rq *rq);
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
+#endif /* CONFIG_SCHED_AUTOGROUP */
Index: linux-2.6/kernel/sched_autogroup.c
===================================================================
--- /dev/null
+++ linux-2.6/kernel/sched_autogroup.c
@@ -0,0 +1,170 @@
+#ifdef CONFIG_SCHED_AUTOGROUP
+
+unsigned int __read_mostly sysctl_sched_autogroup_enabled = 1;
+
+struct autogroup {
+	struct kref		kref;
+	struct task_group	*tg;
+};
+
+static struct autogroup autogroup_default;
+
+static void autogroup_init(struct task_struct *init_task)
+{
+	autogroup_default.tg = &init_task_group;
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
+	kref_init(&ag->kref);
+
+	if (!(IS_ERR(ag->tg)))
+		return ag;
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
+static inline struct task_group *
+autogroup_task_group(struct task_struct *p, struct task_group *tg)
+{
+	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
+
+	enabled &= (tg == &root_task_group);
+	enabled &= (p->sched_class == &fair_sched_class);
+	enabled &= (!(p->flags & PF_EXITING));
+
+	if (enabled)
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
+	struct rq *rq;
+	unsigned long flags;
+
+	rq = task_rq_lock(p, &flags);
+	prev = p->signal->autogroup;
+	if (prev == ag) {
+		task_rq_unlock(rq, &flags);
+		return;
+	}
+
+	p->signal->autogroup = autogroup_kref_get(ag);
+	__sched_move_task(p, rq);
+	task_rq_unlock(rq, &flags);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(t, &p->thread_group, thread_group) {
+		sched_move_task(t);
+	}
+	rcu_read_unlock();
+
+	autogroup_kref_put(prev);
+}
+
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
+/* currently has no users */
+void sched_autogroup_detach(struct task_struct *p)
+{
+	autogroup_move_group(p, &autogroup_default);
+}
+EXPORT_SYMBOL(sched_autogroup_detach);
+
+void sched_autogroup_fork(struct signal_struct *sig)
+{
+	sig->autogroup = autogroup_kref_get(current->signal->autogroup);
+}
+
+void sched_autogroup_exit(struct signal_struct *sig)
+{
+	autogroup_kref_put(sig->autogroup);
+}
+
+#ifdef CONFIG_SCHED_AUTOGROUP_DEBUG
+int sched_autogroup_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct task_struct *p, *t;
+	int ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
+	if (ret || !write)
+		return ret;
+
+	/*
+	 * Exclude cgroup, task group and task create/destroy
+	 * during global classification.
+	 */
+	cgroup_lock();
+	spin_lock(&task_group_lock);
+	read_lock(&tasklist_lock);
+
+	do_each_thread(p, t) {
+		sched_move_task(t);
+	} while_each_thread(p, t);
+
+	spin_unlock(&task_group_lock);
+	cgroup_unlock();
+
+	return 0;
+}
+#endif
+
+static int __init setup_autogroup(char *str)
+{
+	sysctl_sched_autogroup_enabled = 0;
+
+	return 1;
+}
+
+__setup("noautogroup", setup_autogroup);
+#endif
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -382,6 +382,17 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#ifdef CONFIG_SCHED_AUTOGROUP_DEBUG
+	{
+		.procname	= "sched_autogroup_enabled",
+		.data		= &sysctl_sched_autogroup_enabled,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sched_autogroup_handler,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.procname	= "prove_locking",
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -728,6 +728,26 @@ config NET_NS
 
 endif # NAMESPACES
 
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
+	  upon task tty association.
+
+config SCHED_AUTOGROUP_DEBUG
+	bool "Enable Autogroup debugging"
+	depends on SCHED_AUTOGROUP
+	default n
+	help
+	  This option allows the user to enable/disable autogroup on the fly
+	  via echo [10] > /proc/sys/kernel/sched_autogroup_enabled.
+
 config MM_OWNER
 	bool
 
Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -1622,6 +1622,8 @@ and is between 256 and 4096 characters.
 	noapic		[SMP,APIC] Tells the kernel to not make use of any
 			IOAPICs that may be present in the system.
 
+	noautogroup	Disable scheduler automatic task group creation.
+
 	nobats		[PPC] Do not use BATs for mapping kernel lowmem
 			on "Classic" PPC cores.
 




