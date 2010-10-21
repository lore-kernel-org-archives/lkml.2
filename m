Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab0JUIMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:12:07 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:46436 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752116Ab0JUIMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:12:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19YvOhC0H1YaFyXQjM8u/mbyEedZF+BXcT+DWo6T/
	pJnPtsD2q72zZN
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
In-Reply-To: <20101020025652.GB26822@elte.hu>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287487757.24189.40.camel@marge.simson.net>
	 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
	 <1287511983.7417.45.camel@marge.simson.net>
	 <1287514410.7368.10.camel@marge.simson.net>
	 <20101020025652.GB26822@elte.hu>
Content-Type: multipart/mixed; boundary="=-ldWmSac5xbA5WA4oFf2e"
Date: Thu, 21 Oct 2010 10:11:55 +0200
Message-Id: <1287648715.9021.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ldWmSac5xbA5WA4oFf2e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On Wed, 2010-10-20 at 04:56 +0200, Ingo Molnar wrote:

> Mind doing more of the tty->desktop renames/generalizations as Linus suggested, and 
> resend the patch?

Here she comes.  Better/Worse?

Changes:
- tty->autogroup.
- only autogroup fair class tasks.
- removed dainbramaged sleeper vruntime twiddling.
- removed paranoid locking.
- removed noop detatch code.

> I'd also suggest to move it out of EXPERIMENTAL - we dont really do that for core 
> kernel features as most distros enable CONFIG_EXPERIMENTAL so it's a rather 
> meaningless distinction. Since the feature is default-n, people will get the old 
> scheduler by default but can also choose this desktop-centric scheduling mode.
> 
> I'd even argue to make it default-y, because this patch clearly cures a form of 
> kbuild cancer.

You top dogs can make the default call.. it it's accepted that is ;-)

Marcus:  care to try the below?  Works fine for me (but so did first
cut).  It depends on the attached patch, and applied to virgin shiny new
2.6.36.

A recurring complaint from CFS users is that parallel kbuild has a negative
impact on desktop interactivity.  This patch implements an idea from Linus,
to automatically create task groups.  This patch only implements Linus' per
tty task group suggestion, and only for fair class tasks, but leaves the way
open for enhancement.

How it works: at tty alloc/dealloc time, a task group is created/destroyed,
so there is always a task group active per tty.  When we select a runqueue,
if the task has a has a tty association, and no task group, attach it to a
per tty autogroup on the fly.

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
 drivers/char/tty_io.c    |    2 +
 include/linux/sched.h    |   14 ++++++++
 include/linux/tty.h      |    3 +
 init/Kconfig             |   13 ++++++++
 kernel/sched.c           |    9 ++++-
 kernel/sched_autogroup.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_autogroup.h |    7 ++++
 kernel/sysctl.c          |   11 ++++++
 8 files changed, 134 insertions(+), 1 deletion(-)

Index: linux-2.6.36.git/include/linux/sched.h
===================================================================
--- linux-2.6.36.git.orig/include/linux/sched.h
+++ linux-2.6.36.git/include/linux/sched.h
@@ -1900,6 +1900,20 @@ int sched_rt_handler(struct ctl_table *t
 
 extern unsigned int sysctl_sched_compat_yield;
 
+#ifdef CONFIG_SCHED_AUTOGROUP
+int sched_autogroup_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+
+extern unsigned int sysctl_sched_autogroup_enabled;
+
+void sched_autogroup_create_tty(struct tty_struct *tty);
+void sched_autogroup_destroy_tty(struct tty_struct *tty);
+#else
+static inline void sched_autogroup_create_tty(struct tty_struct *tty) { }
+static inline void sched_autogroup_destroy_tty(struct tty_struct *tty) { }
+#endif
+
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
Index: linux-2.6.36.git/include/linux/tty.h
===================================================================
--- linux-2.6.36.git.orig/include/linux/tty.h
+++ linux-2.6.36.git/include/linux/tty.h
@@ -327,6 +327,9 @@ struct tty_struct {
 	/* If the tty has a pending do_SAK, queue it here - akpm */
 	struct work_struct SAK_work;
 	struct tty_port *port;
+#ifdef CONFIG_SCHED_AUTOGROUP
+	struct task_group *tg;
+#endif
 };
 
 /* Each of a tty's open files has private_data pointing to tty_file_private */
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
+	autogroup_check_attach(p, &tg);
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
Index: linux-2.6.36.git/drivers/char/tty_io.c
===================================================================
--- linux-2.6.36.git.orig/drivers/char/tty_io.c
+++ linux-2.6.36.git/drivers/char/tty_io.c
@@ -185,6 +185,7 @@ void free_tty_struct(struct tty_struct *
 {
 	kfree(tty->write_buf);
 	tty_buffer_free_all(tty);
+	sched_autogroup_destroy_tty(tty);
 	kfree(tty);
 }
 
@@ -2823,6 +2824,7 @@ void initialize_tty_struct(struct tty_st
 	tty->ops = driver->ops;
 	tty->index = idx;
 	tty_line_name(driver, idx, tty->name);
+	sched_autogroup_create_tty(tty);
 }
 
 /**
Index: linux-2.6.36.git/kernel/sched_autogroup.h
===================================================================
--- /dev/null
+++ linux-2.6.36.git/kernel/sched_autogroup.h
@@ -0,0 +1,7 @@
+#ifdef CONFIG_SCHED_AUTOGROUP
+static inline void
+autogroup_check_attach(struct task_struct *p, struct task_group **tg);
+#else
+static inline void
+autogroup_check_attach(struct task_struct *p, struct task_group **tg) { }
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
@@ -652,6 +652,19 @@ config DEBUG_BLK_CGROUP
 
 endif # CGROUPS
 
+config SCHED_AUTOGROUP
+	bool "Automatic process group scheduling"
+	select CGROUPS
+	select CGROUP_SCHED
+	select FAIR_GROUP_SCHED
+	select BLK_CGROUP
+	help
+	  This option optimizes the scheduler for common desktop workloads by
+	  automatically creating and populating task groups.  This separation
+	  of workloads isolates aggressive CPU burners (like build jobs) from
+	  desktop applications.  Task group autogeneration is currently based
+	  upon task tty association.
+
 config MM_OWNER
 	bool
 
Index: linux-2.6.36.git/kernel/sched_autogroup.c
===================================================================
--- /dev/null
+++ linux-2.6.36.git/kernel/sched_autogroup.c
@@ -0,0 +1,76 @@
+#ifdef CONFIG_SCHED_AUTOGROUP
+#include <linux/tty.h>
+
+unsigned int __read_mostly sysctl_sched_autogroup_enabled = 1;
+
+void sched_autogroup_create_tty(struct tty_struct *tty)
+{
+	tty->tg = sched_create_group(&init_task_group);
+	if (IS_ERR(tty->tg)) {
+		tty->tg = &init_task_group;
+		 WARN_ON(1);
+	}
+}
+EXPORT_SYMBOL(sched_autogroup_create_tty);
+
+void sched_autogroup_destroy_tty(struct tty_struct *tty)
+{
+	if (tty->tg && tty->tg != &init_task_group)
+		sched_destroy_group(tty->tg);
+}
+EXPORT_SYMBOL(sched_autogroup_destroy_tty);
+
+static void
+autogroup_attach_tty(struct task_struct *p, struct task_group **tg)
+{
+	struct tty_struct *tty = p->signal->tty;
+
+	if (!tty)
+		return;
+
+	*tg = p->signal->tty->tg;
+}
+
+static inline void
+autogroup_check_attach(struct task_struct *p, struct task_group **tg)
+{
+	if (!sysctl_sched_autogroup_enabled || *tg != &root_task_group ||
+			p->sched_class != &fair_sched_class)
+		return;
+
+	rcu_read_lock();
+
+	autogroup_attach_tty(p, tg);
+
+	rcu_read_unlock();
+}
+
+int sched_autogroup_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct task_struct *p, *t;
+	struct task_group *tg;
+	int ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
+	if (ret || !write)
+		return ret;
+
+	for_each_process(p) {
+		tg = task_group(p);
+		sched_move_task(p);
+		list_for_each_entry_rcu(t, &p->thread_group, thread_group) {
+			sched_move_task(t);
+		}
+	}
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
+__setup("noautogroup", setup_autogroup);
+#endif


--=-ldWmSac5xbA5WA4oFf2e
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
 

--=-ldWmSac5xbA5WA4oFf2e--

