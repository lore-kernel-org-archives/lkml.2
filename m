Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab0KKP04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:26:56 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:44353 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753064Ab0KKP0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:26:54 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18kW1MYSykkE9cgrssYpV6A8xVCpak6ktx8ShEAhl
	z5tbuERhZG8UqZ
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
In-Reply-To: <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287487757.24189.40.camel@marge.simson.net>
	 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
	 <1287511983.7417.45.camel@marge.simson.net>
	 <1287514410.7368.10.camel@marge.simson.net>
	 <20101020025652.GB26822@elte.hu>
	 <1287648715.9021.20.camel@marge.simson.net>
	 <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>
	 <20101021162924.GA3225@redhat.com>
	 <1288076838.11930.1.camel@marge.simson.net>
	 <1288078144.7478.9.camel@marge.simson.net>
	 <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 08:26:40 -0700
Message-ID: <1289489200.11397.21.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings from sunny Arizona!

On Tue, 2010-10-26 at 08:47 -0700, Linus Torvalds wrote:

> So I have a suggestion that may not be popular with you, because it
> does end up changing the approach of your patch a lot.
> 
> And I have to say, I like how your last patch looked. It was
> surprisingly small, simple, and clean. So I hate saying "I think it
> should perhaps do things a bit differently". That said, I would
> suggest:
> 
>  - don't depend on "tsk->signal->tty" at all.
> 
>  - INSTEAD, introduce a "tsk->signal->sched_group" pointer that points
> to whatever the current auto-task_group is. Remember, long-term, we'd
> want to maybe have other heuristics than just the tty groups, so we'd
> want this separate from the tty logic _anyway_
> 
>  - at fork time, just copy the task_group pointer in copy_signal() if
> it is non-NULL, and increment the refcount (I don't think struct
> task_group is refcounted now, but this would require it).
> 
>  - at free_signal_struct(), just do a
> "put_task_group(sig->task_group);" before freeing it.
> 
>  - make the scheduler use the "tsk->signal->sched_group" as the
> default group if nothing else exists.
> 
> Now, all the basic logic is _entirely_ unaware of any tty logic, and
> it's generic. And none of it has any races with some odd tty release
> logic or anything like that.
> 
> Now, after this, the only thing you'd need to do is hook into
> __proc_set_tty(), which already holds the sighand lock, and _there_
> you would attach the task_group to the process. Notice how it would
> never be attached to a tty at all, so tty_release etc would never be
> involved in any taskgroup thing - it's not really the tty that owns
> the taskgroup, it's simply the act of becoming a tty task group leader
> that attaches the task to a new scheduling group.
> 
> It also means, for example, that if a process loses its tty (and
> doesn't get a new one - think hangup), it still remains in whatever
> scheduling group it started out with. The tty really is immaterial.
> 
> And the nice thing about this is that it should be trivial to make
> other things than tty's trigger this same thing, if we find a pattern
> (or create some new interface to let people ask for it) for something
> that should create a new group (like perhaps spawning a graphical
> application from the window manager rather than from a tty).
> 
> Comments?

I _finally_ got back to this yesterday, and implemented your suggestion,
though with a couple minor variations.  Putting the autogroup pointer in
the signal struct didn't look right to me, so I plugged it into the task
struct instead.  I also didn't refcount taskgroups, wanted the patchlet
to be as self-contained as possible, so refcounted the autogroup struct
instead.  I also left group movement on tty disassociation in place, but
may nuke it.

The below has withstood an all night thrashing in my laptop with a
PREEMPT_RT kernel, and looks kinda presentable to me, so...

A recurring complaint from CFS users is that parallel kbuild has a negative
impact on desktop interactivity.  This patch implements an idea from Linus,
to automatically create task groups.  This patch only implements Linus' per
tty task group suggestion, and only for fair class tasks, but leaves the way
open for enhancement.

Implementation: each task struct contains an inherited pointer to a refcounted
autogroup struct containing a task group pointer, the default for all tasks
pointing to the init_task_group.  When a task calls __proc_set_tty(), the
task's reference to the default group is dropped, a new task group is created,
and the task is moved out of the old group and into the new.  Children thereafter
inherit this task group, and increase it's refcount.  Calls to __tty_hangup()
and proc_clear_tty() move the caller back to the init_task_group, and possibly
destroy the task group.  On exit, reference to the current task group is dropped,
and the task group is potentially destroyed.  At runqueue selection time, iff
a task has no cgroup assignment, it's current autogroup is used.

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
 drivers/char/tty_io.c               |    4 
 include/linux/sched.h               |   20 ++++
 init/Kconfig                        |   12 ++
 kernel/exit.c                       |    1 
 kernel/sched.c                      |   28 ++++--
 kernel/sched_autogroup.c            |  161 ++++++++++++++++++++++++++++++++++++
 kernel/sched_autogroup.h            |   10 ++
 kernel/sysctl.c                     |   11 ++
 9 files changed, 241 insertions(+), 8 deletions(-)

Index: linux-2.6.36.git/include/linux/sched.h
===================================================================
--- linux-2.6.36.git.orig/include/linux/sched.h
+++ linux-2.6.36.git/include/linux/sched.h
@@ -1159,6 +1159,7 @@ struct sched_rt_entity {
 };
 
 struct rcu_node;
+struct autogroup;
 
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
@@ -1181,6 +1182,10 @@ struct task_struct {
 	struct sched_entity se;
 	struct sched_rt_entity rt;
 
+#ifdef CONFIG_SCHED_AUTOGROUP
+	struct autogroup *autogroup;
+#endif
+
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* list of struct preempt_notifier: */
 	struct hlist_head preempt_notifiers;
@@ -1900,6 +1905,21 @@ int sched_rt_handler(struct ctl_table *t
 
 extern unsigned int sysctl_sched_compat_yield;
 
+#ifdef CONFIG_SCHED_AUTOGROUP
+extern unsigned int sysctl_sched_autogroup_enabled;
+
+int sched_autogroup_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos);
+
+extern void sched_autogroup_create_attach(struct task_struct *p);
+extern void sched_autogroup_detatch(struct task_struct *p);
+extern void sched_autogroup_exit(struct task_struct *p);
+#else
+static inline void sched_autogroup_create_attach(struct task_struct *p) { }
+static inline void sched_autogroup_detatch(struct task_struct *p) { }
+static inline void sched_autogroup_exit(struct task_struct *p) { }
+#endif
+
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
Index: linux-2.6.36.git/kernel/sched.c
===================================================================
--- linux-2.6.36.git.orig/kernel/sched.c
+++ linux-2.6.36.git/kernel/sched.c
@@ -78,6 +78,7 @@
 
 #include "sched_cpupri.h"
 #include "workqueue_sched.h"
+#include "sched_autogroup.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
@@ -612,11 +613,16 @@ static inline int cpu_of(struct rq *rq)
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
+	autogroup_task_group(p, &tg);
+
+	return tg;
 }
 
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
@@ -1920,6 +1926,7 @@ static void deactivate_task(struct rq *r
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
+#include "sched_autogroup.c"
 #ifdef CONFIG_SCHED_DEBUG
 # include "sched_debug.c"
 #endif
@@ -2569,6 +2576,7 @@ void sched_fork(struct task_struct *p, i
 	 * Silence PROVE_RCU.
 	 */
 	rcu_read_lock();
+	autogroup_fork(p);
 	set_task_cpu(p, cpu);
 	rcu_read_unlock();
 
@@ -7749,7 +7757,7 @@ void __init sched_init(void)
 #ifdef CONFIG_CGROUP_SCHED
 	list_add(&init_task_group.list, &task_groups);
 	INIT_LIST_HEAD(&init_task_group.children);
-
+	autogroup_init(&init_task);
 #endif /* CONFIG_CGROUP_SCHED */
 
 #if defined CONFIG_FAIR_GROUP_SCHED && defined CONFIG_SMP
@@ -8279,15 +8287,11 @@ void sched_destroy_group(struct task_gro
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
@@ -8308,7 +8312,15 @@ void sched_move_task(struct task_struct
 		tsk->sched_class->set_curr_task(rq);
 	if (on_rq)
 		enqueue_task(rq, tsk, 0);
+}
+
+void sched_move_task(struct task_struct *tsk)
+{
+	struct rq *rq;
+	unsigned long flags;
 
+	rq = task_rq_lock(tsk, &flags);
+	__sched_move_task(tsk, rq);
 	task_rq_unlock(rq, &flags);
 }
 #endif /* CONFIG_CGROUP_SCHED */
Index: linux-2.6.36.git/drivers/char/tty_io.c
===================================================================
--- linux-2.6.36.git.orig/drivers/char/tty_io.c
+++ linux-2.6.36.git/drivers/char/tty_io.c
@@ -580,6 +580,7 @@ void __tty_hangup(struct tty_struct *tty
 			spin_lock_irq(&p->sighand->siglock);
 			if (p->signal->tty == tty) {
 				p->signal->tty = NULL;
+				sched_autogroup_detatch(p);
 				/* We defer the dereferences outside fo
 				   the tasklist lock */
 				refs++;
@@ -3070,6 +3071,7 @@ void proc_clear_tty(struct task_struct *
 	spin_lock_irqsave(&p->sighand->siglock, flags);
 	tty = p->signal->tty;
 	p->signal->tty = NULL;
+	sched_autogroup_detatch(p);
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
 	tty_kref_put(tty);
 }
@@ -3089,12 +3091,14 @@ static void __proc_set_tty(struct task_s
 		tty->session = get_pid(task_session(tsk));
 		if (tsk->signal->tty) {
 			printk(KERN_DEBUG "tty not NULL!!\n");
+			sched_autogroup_detatch(tsk);
 			tty_kref_put(tsk->signal->tty);
 		}
 	}
 	put_pid(tsk->signal->tty_old_pgrp);
 	tsk->signal->tty = tty_kref_get(tty);
 	tsk->signal->tty_old_pgrp = NULL;
+	sched_autogroup_create_attach(tsk);
 }
 
 static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
Index: linux-2.6.36.git/kernel/exit.c
===================================================================
--- linux-2.6.36.git.orig/kernel/exit.c
+++ linux-2.6.36.git/kernel/exit.c
@@ -174,6 +174,7 @@ repeat:
 	write_lock_irq(&tasklist_lock);
 	tracehook_finish_release_task(p);
 	__exit_signal(p);
+	sched_autogroup_exit(p);
 
 	/*
 	 * If we are the last non-leader member of the thread
Index: linux-2.6.36.git/kernel/sched_autogroup.h
===================================================================
--- /dev/null
+++ linux-2.6.36.git/kernel/sched_autogroup.h
@@ -0,0 +1,10 @@
+#ifdef CONFIG_SCHED_AUTOGROUP
+static inline void
+autogroup_task_group(struct task_struct *p, struct task_group **tg);
+static void __sched_move_task(struct task_struct *tsk, struct rq *rq);
+#else /* !CONFIG_SCHED_AUTOGROUP */
+static inline void autogroup_init(struct task_struct *init_task) {  }
+static inline void autogroup_fork(struct task_struct *p) { }
+static inline void
+autogroup_task_group(struct task_struct *p, struct task_group **tg) { }
+#endif /* CONFIG_SCHED_AUTOGROUP */
Index: linux-2.6.36.git/kernel/sched_autogroup.c
===================================================================
--- /dev/null
+++ linux-2.6.36.git/kernel/sched_autogroup.c
@@ -0,0 +1,161 @@
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
+	init_task->autogroup = &autogroup_default;
+}
+
+static inline void autogroup_destroy(struct kref *kref)
+{
+	struct autogroup *ag = container_of(kref, struct autogroup, kref);
+
+	sched_destroy_group(ag->tg);
+	kfree(ag);
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
+static void autogroup_fork(struct task_struct *p)
+{
+	p->autogroup = autogroup_kref_get(current->autogroup);
+}
+
+static inline void
+autogroup_task_group(struct task_struct *p, struct task_group **tg)
+{
+	int enabled = sysctl_sched_autogroup_enabled;
+
+	enabled &= (*tg == &root_task_group);
+	enabled &= (p->sched_class == &fair_sched_class);
+	enabled &= (!(p->flags & PF_EXITING));
+
+	if (enabled)
+		*tg = p->autogroup->tg;
+}
+
+static void
+autogroup_move_task(struct task_struct *p, struct autogroup *ag)
+{
+	struct autogroup *prev;
+	struct rq *rq;
+	unsigned long flags;
+
+	rq = task_rq_lock(p, &flags);
+	prev = p->autogroup;
+	if (prev == ag) {
+		task_rq_unlock(rq, &flags);
+		return;
+	}
+
+	p->autogroup = autogroup_kref_get(ag);
+	__sched_move_task(p, rq);
+	task_rq_unlock(rq, &flags);
+
+	autogroup_kref_put(prev);
+}
+
+void sched_autogroup_create_attach(struct task_struct *p)
+{
+	autogroup_move_task(p, autogroup_create());
+
+	/*
+	 * Correct freshly allocated group's refcount.
+	 * Move takes a reference on destination, but
+	 * create already initialized refcount to 1.
+	 */
+	if (p->autogroup != &autogroup_default)
+		autogroup_kref_put(p->autogroup);
+}
+EXPORT_SYMBOL(sched_autogroup_create_attach);
+
+void sched_autogroup_detatch(struct task_struct *p)
+{
+	autogroup_move_task(p, &autogroup_default);
+}
+EXPORT_SYMBOL(sched_autogroup_detatch);
+
+void sched_autogroup_exit(struct task_struct *p)
+{
+	autogroup_kref_put(p->autogroup);
+}
+
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
+	read_unlock(&tasklist_lock);
+	spin_unlock(&task_group_lock);
+	cgroup_unlock();
+
+	return 0;
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
Index: linux-2.6.36.git/kernel/sysctl.c
===================================================================
--- linux-2.6.36.git.orig/kernel/sysctl.c
+++ linux-2.6.36.git/kernel/sysctl.c
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
+		.proc_handler	= sched_autogroup_handler,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.procname	= "prove_locking",
Index: linux-2.6.36.git/init/Kconfig
===================================================================
--- linux-2.6.36.git.orig/init/Kconfig
+++ linux-2.6.36.git/init/Kconfig
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
+	  upon task tty association.
+
 config MM_OWNER
 	bool
 
Index: linux-2.6.36.git/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.36.git.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.36.git/Documentation/kernel-parameters.txt
@@ -1610,6 +1610,8 @@ and is between 256 and 4096 characters.
 	noapic		[SMP,APIC] Tells the kernel to not make use of any
 			IOAPICs that may be present in the system.
 
+	noautogroup	Disable scheduler automatic task group creation.
+
 	nobats		[PPC] Do not use BATs for mapping kernel lowmem
 			on "Classic" PPC cores.
 


