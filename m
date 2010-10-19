Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab0JSJQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:16:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:43839 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751366Ab0JSJQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:16:15 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18zfb5Ja+gzxQPDjcNQRTg0Ru21I5wtctmvOR7iGk
	A1TYCvIsxOzPJb
Subject: [RFC/RFT PATCH] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 19 Oct 2010 11:16:04 +0200
Message-Id: <1287479765.9920.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Comments, suggestions etc highly welcome.

This patch implements an idea from Linus, to automatically create task groups
per tty, to improve desktop interactivity under hefty load such as kbuild.  The
feature is enabled from boot by default,  The default setting can be changed via
the boot option ttysched=0, and can be can be turned on or off on the fly via
echo [01] > /proc/sys/kernel/sched_tty_sched_enabled.

A 100% hog overhead measurement proggy pinned to the same CPU as a make -j10

pert/s:      229 >5484.43us:       41 min:  0.15 max:12069.42 avg:2193.81 sum/s:502382us overhead:50.24%
pert/s:      222 >5652.28us:       43 min:  0.46 max:12077.31 avg:2248.56 sum/s:499181us overhead:49.92%
pert/s:      211 >5809.38us:       43 min:  0.16 max:12064.78 avg:2381.70 sum/s:502538us overhead:50.25%
pert/s:      223 >6147.92us:       43 min:  0.15 max:16107.46 avg:2282.17 sum/s:508925us overhead:50.49%
pert/s:      218 >6252.64us:       43 min:  0.16 max:12066.13 avg:2324.11 sum/s:506656us overhead:50.27%

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 drivers/char/tty_io.c |    2 
 include/linux/sched.h |   14 +++++
 include/linux/tty.h   |    3 +
 init/Kconfig          |   13 +++++
 kernel/sched.c        |    9 +++
 kernel/sched_tty.c    |  128 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_tty.h    |    7 ++
 kernel/sysctl.c       |   11 ++++
 8 files changed, 186 insertions(+), 1 deletion(-)

Index: linux-2.6.36.git/include/linux/sched.h
===================================================================
--- linux-2.6.36.git.orig/include/linux/sched.h
+++ linux-2.6.36.git/include/linux/sched.h
@@ -1900,6 +1900,20 @@ int sched_rt_handler(struct ctl_table *t
 
 extern unsigned int sysctl_sched_compat_yield;
 
+#ifdef CONFIG_SCHED_DESKTOP
+int sched_tty_sched_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+
+extern unsigned int sysctl_sched_tty_sched_enabled;
+
+void tty_sched_create_group(struct tty_struct *tty);
+void tty_sched_destroy_group(struct tty_struct *tty);
+#else
+static inline void tty_sched_create_group(struct tty_struct *tty) { }
+static inline void tty_sched_destroy_group(struct tty_struct *tty) { }
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
+#ifdef CONFIG_SCHED_DESKTOP
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
+#include "sched_tty.h"
 
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
+	tty_sched_check_attach(p, &tg);
+
+	return tg;
 }
 
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
@@ -1920,6 +1926,7 @@ static void deactivate_task(struct rq *r
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
+#include "sched_tty.c"
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
+	tty_sched_destroy_group(tty);
 	kfree(tty);
 }
 
@@ -2823,6 +2824,7 @@ void initialize_tty_struct(struct tty_st
 	tty->ops = driver->ops;
 	tty->index = idx;
 	tty_line_name(driver, idx, tty->name);
+	tty_sched_create_group(tty);
 }
 
 /**
Index: linux-2.6.36.git/kernel/sched_tty.h
===================================================================
--- /dev/null
+++ linux-2.6.36.git/kernel/sched_tty.h
@@ -0,0 +1,7 @@
+#ifdef CONFIG_SCHED_DESKTOP
+static inline void
+tty_sched_check_attach(struct task_struct *p, struct task_group **tg);
+#else
+static inline void
+tty_sched_check_attach(struct task_struct *p, struct task_group **tg) { }
+#endif
Index: linux-2.6.36.git/kernel/sched_tty.c
===================================================================
--- /dev/null
+++ linux-2.6.36.git/kernel/sched_tty.c
@@ -0,0 +1,128 @@
+#ifdef CONFIG_SCHED_DESKTOP
+#include <linux/tty.h>
+
+unsigned int __read_mostly sysctl_sched_tty_sched_enabled = 1;
+
+void tty_sched_create_group(struct tty_struct *tty)
+{
+	tty->tg = sched_create_group(&init_task_group);
+	if (IS_ERR(tty->tg)) {
+		tty->tg = &init_task_group;
+		 WARN_ON(1);
+	}
+}
+EXPORT_SYMBOL(tty_sched_create_group);
+
+void tty_sched_destroy_group(struct tty_struct *tty)
+{
+	if (tty->tg && tty->tg != &init_task_group)
+		sched_destroy_group(tty->tg);
+}
+EXPORT_SYMBOL(tty_sched_destroy_group);
+
+static inline void
+tty_sched_check_attach(struct task_struct *p, struct task_group **tg)
+{
+	struct tty_struct *tty;
+	int attach = 0, enabled = sysctl_sched_tty_sched_enabled;
+
+	rcu_read_lock();
+	tty = p->signal->tty;
+	if (!tty)
+		goto out_unlock;
+
+	if (enabled && *tg == &root_task_group) {
+		*tg = p->signal->tty->tg;
+		attach = 1;
+	} else if (!enabled && *tg == tty->tg) {
+		*tg = &root_task_group;
+		attach = 1;
+	}
+
+	if (attach && !p->se.on_rq) {
+		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
+		p->se.vruntime += (*tg)->cfs_rq[task_cpu(p)]->min_vruntime;
+	}
+
+out_unlock:
+	rcu_read_unlock();
+}
+
+void tty_sched_move_task(struct task_struct *p, struct task_group *tg)
+{
+	struct sched_entity *se = &p->se;
+	struct rq *rq;
+	unsigned long flags;
+	int on_rq, running, cpu;
+
+	rq = task_rq_lock(p, &flags);
+
+	running = task_current(rq, p);
+	on_rq = se->on_rq;
+	cpu = rq->cpu;
+
+	if (on_rq)
+		dequeue_task(rq, p, 0);
+	if (unlikely(running))
+		p->sched_class->put_prev_task(rq, p);
+
+	if (!on_rq)
+		se->vruntime -= cfs_rq_of(se)->min_vruntime;
+
+	se->cfs_rq = tg->cfs_rq[cpu];
+	se->parent = tg->se[cpu];
+
+	p->rt.rt_rq  = tg->rt_rq[cpu];
+	p->rt.parent = tg->rt_se[cpu];
+
+	if (!on_rq)
+		se->vruntime += cfs_rq_of(se)->min_vruntime;
+
+	if (unlikely(running))
+		p->sched_class->set_curr_task(rq);
+	if (on_rq)
+		enqueue_task(rq, p, 0);
+
+	task_rq_unlock(rq, &flags);
+}
+
+int sched_tty_sched_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	struct task_struct *p, *t;
+	struct task_group *tg;
+	unsigned long flags;
+	int ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
+	if (ret || !write)
+		return ret;
+
+	read_lock_irqsave(&tasklist_lock, flags);
+
+	rcu_read_lock();
+	for_each_process(p) {
+		tg = task_group(p);
+		tty_sched_move_task(p, tg);
+		list_for_each_entry_rcu(t, &p->thread_group, thread_group) {
+			tty_sched_move_task(t, tg);
+		}
+	}
+	rcu_read_unlock();
+
+	read_unlock_irqrestore(&tasklist_lock, flags);
+
+	return 0;
+}
+
+static int __init setup_tty_sched(char *str)
+{
+	unsigned long val;
+
+	val = simple_strtoul(str, NULL, 0);
+	sysctl_sched_tty_sched_enabled = val ? 1 : 0;
+
+	return 1;
+}
+__setup("ttysched=", setup_tty_sched);
+#endif
Index: linux-2.6.36.git/kernel/sysctl.c
===================================================================
--- linux-2.6.36.git.orig/kernel/sysctl.c
+++ linux-2.6.36.git/kernel/sysctl.c
@@ -384,6 +384,17 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#ifdef CONFIG_SCHED_DESKTOP
+	{
+		.procname	= "sched_tty_sched_enabled",
+		.data		= &sysctl_sched_tty_sched_enabled,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sched_tty_sched_handler,
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
 
+config SCHED_DESKTOP
+	bool "Desktop centric group scheduling"
+	depends on EXPERIMENTAL
+	select CGROUPS
+	select CGROUP_SCHED
+	select FAIR_GROUP_SCHED
+	select RT_GROUP_SCHED
+	select BLK_CGROUP
+	help
+	  This option optimizes the group scheduler for common desktop workloads,
+	  by creating separate per tty groups. This separation of workloads isolates
+	  aggressive CPU burners (like build jobs) from desktop applications.
+
 config MM_OWNER
 	bool
 


