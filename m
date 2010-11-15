Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402Ab0KOV0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 16:26:10 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45534 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752867Ab0KOV0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 16:26:08 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Dmos88ClD/iQLs+qhld2Rgjrni9bQ80mnCtePI1
	f/KqC+XbjwiLCv
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101115125716.GA22422@redhat.com>
References: <AANLkTikjSCbcRnKOU=nd4os1sdW-GJkD6QVj=U5zPyu8@mail.gmail.com>
	 <20101114202734.GA1627@arch.trippelsdorf.de>
	 <AANLkTimHtjH3YvtX6i542_XjfFeuvG-AnU8i224a1R4j@mail.gmail.com>
	 <1289778189.5154.10.camel@maggy.simson.net>
	 <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
	 <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com>
	 <1289783580.495.58.camel@maggy.simson.net>
	 <1289811438.2109.474.camel@laptop>
	 <1289820766.16406.45.camel@maggy.simson.net>
	 <1289821590.16406.47.camel@maggy.simson.net>
	 <20101115125716.GA22422@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 14:25:50 -0700
Message-ID: <1289856350.14719.135.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 13:57 +0100, Oleg Nesterov wrote:
> I continue to play the advocatus diaboli ;)

Much appreciated.

> On 11/15, Mike Galbraith wrote:
> >
> > +static inline bool
> > +task_wants_autogroup(struct task_struct *p, struct task_group *tg)
> > +{
> > +	if (tg != &root_task_group)
> > +		return false;
> > +
> > +	if (p->sched_class != &fair_sched_class)
> > +		return false;
> > +
> > +	if (p->flags & PF_EXITING)
> > +		return false;
> 
> Hmm, why? Perhaps PF_EXITING was needed in the previous version to
> avoid the race with release_task(). But now it is always safe to
> use signal->autogroup.

That came into existence when I stress tested previous version in
PREEMPT_RT (boom).  I see no good reason to bother an exiting task
though, so would prefer to leave it as is.

> And the exiting task can do a lot before it disappears, probably
> we shouldn't ignore ->autogroup.

I doubt it would add value.

> Not sure I understand why do we need rq->lock...

Indeed, should have been whacked.  Now gone.

> It can't protect the change of signal->autogroup, multiple callers
> can use different rq's.

Guaranteed live ->autogroup should be good enough for heuristic use, and
had better be so.  Having to take ->siglock in the fast path would kill
using ->signal.

> However. Currently the only callers holds ->siglock, so we are safe.
> Perhaps we should just document that autogroup_move_group() needs
> ->siglock.

Done.

> This also mean the patch can be simplified even more, __sched_move_task()
> is not needed.

(shrinkage:)

> > +void sched_autogroup_fork(struct signal_struct *sig)
> > +{
> > +	sig->autogroup = autogroup_kref_get(current->signal->autogroup);
> > +}
> 
> Well, in theory this can race with another thread doing autogroup_move_group().
> We can read the old ->autogroup, and then use it after it was already freed.
> 
> Probably this needs ->siglock too.

Another landmine.  Done.

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
 drivers/tty/tty_io.c                |    1 
 include/linux/sched.h               |   19 ++++
 init/Kconfig                        |   12 ++
 kernel/fork.c                       |    5 -
 kernel/sched.c                      |    9 +-
 kernel/sched_autogroup.c            |  150 ++++++++++++++++++++++++++++++++++++
 kernel/sched_autogroup.h            |   16 +++
 kernel/sysctl.c                     |   11 ++
 9 files changed, 222 insertions(+), 3 deletions(-)

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
@@ -1931,6 +1936,20 @@ int sched_rt_handler(struct ctl_table *t
 
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
@@ -0,0 +1,16 @@
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
+#endif /* CONFIG_SCHED_AUTOGROUP */
Index: linux-2.6/kernel/sched_autogroup.c
===================================================================
--- /dev/null
+++ linux-2.6/kernel/sched_autogroup.c
@@ -0,0 +1,150 @@
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
+	prev = p->signal->autogroup;
+	if (prev == ag)
+		return;
+
+	p->signal->autogroup = autogroup_kref_get(ag);
+	sched_move_task(p);
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
+/* Must be called with siglock held */
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
+/* Must be called with siglock held.  Currently has no users */
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
+#endif
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -382,6 +382,17 @@ static struct ctl_table kern_table[] = {
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
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -728,6 +728,18 @@ config NET_NS
 
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
 


