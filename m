Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0KUNju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 08:39:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59441 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab0KUNjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 08:39:49 -0500
Date: Sun, 21 Nov 2010 14:39:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] sched: automated per session task groups
Message-ID: <20101121133919.GA10976@elte.hu>
References: <20101121133744.GA10765@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101121133744.GA10765@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,FUZZY_VPILL autolearn=no SpamAssassin version=3.2.5
	0.7 FUZZY_VPILL            BODY: Attempt to obfuscate words in spam
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Btw., there's a small cleanup in the patch that i picked up (see below), and i also 
edited the commit log a bit - so you might want to pick up the version below.

	Ingo

--------------->
>From 741430a6af2bdefe3d017226bbcfe96f9ed46b58 Mon Sep 17 00:00:00 2001
From: Mike Galbraith <efault@gmx.de>
Date: Sat, 20 Nov 2010 12:35:00 -0700
Subject: [PATCH] sched: Improve desktop interactivity: Implement automated per session task groups

A recurring complaint from CFS users is that parallel kbuild has
a negative impact on desktop interactivity.  This patch
implements an idea from Linus, to automatically create task
groups.  This patch only per session autogroups, but leaves the
way open for enhancement.

Implementation: each task's signal struct contains an inherited
pointer to a refcounted autogroup struct containing a task group
pointer, the default for all tasks pointing to the
init_task_group.  When a task calls setsid(), the process wide
reference to the default group is dropped, a new task group is
created, and the process is moved into the new task group.
Children thereafter inherit this task group, and increase it's
refcount.  On exit, a reference to the current task group is
dropped when the last reference to each signal struct is
dropped.  The task group is destroyed when the last signal
struct referencing it is freed.

At runqueue selection time, IFF a task has no cgroup assignment, its
current autogroup is used.

Autogroup bandwidth is controllable via setting it's nice level
through the proc filesystem.  cat /proc/<pid>/autogroup displays
the task's group and the group's nice level.

 echo <nice level> > /proc/<pid>/autogroup

Sets the task group's shares to the weight of nice <level> task.
Setting nice level is rate limited for !admin users due to the abuse
risk of task group locking.

The feature is enabled from boot by default if
CONFIG_SCHED_AUTOGROUP=y is selected, but can be disabled via the
boot option noautogroup, and can be also be turned on/off on the
fly via..    echo [01] > /proc/sys/kernel/sched_autogroup_enabled.
..which will automatically move tasks to/from the root task
group.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
LKML-Reference: <1290281700.28711.9.camel@maggy.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kernel-parameters.txt |    2 +
 fs/proc/base.c                      |   79 ++++++++++++
 include/linux/sched.h               |   23 ++++
 init/Kconfig                        |   12 ++
 kernel/fork.c                       |    5 +-
 kernel/sched.c                      |   13 ++-
 kernel/sched_autogroup.c            |  240 +++++++++++++++++++++++++++++++++++
 kernel/sched_autogroup.h            |   23 ++++
 kernel/sched_debug.c                |   29 ++--
 kernel/sys.c                        |    4 +-
 kernel/sysctl.c                     |   11 ++
 11 files changed, 423 insertions(+), 18 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 92e83e5..86820a7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1622,6 +1622,8 @@ and is between 256 and 4096 characters. It is defined in the file
 	noapic		[SMP,APIC] Tells the kernel to not make use of any
 			IOAPICs that may be present in the system.
 
+	noautogroup	Disable scheduler automatic task group creation.
+
 	nobats		[PPC] Do not use BATs for mapping kernel lowmem
 			on "Classic" PPC cores.
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index f3d02ca..2fa0ce2 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1407,6 +1407,82 @@ static const struct file_operations proc_pid_sched_operations = {
 
 #endif
 
+#ifdef CONFIG_SCHED_AUTOGROUP
+/*
+ * Print out autogroup related information:
+ */
+static int sched_autogroup_show(struct seq_file *m, void *v)
+{
+	struct inode *inode = m->private;
+	struct task_struct *p;
+
+	p = get_proc_task(inode);
+	if (!p)
+		return -ESRCH;
+	proc_sched_autogroup_show_task(p, m);
+
+	put_task_struct(p);
+
+	return 0;
+}
+
+static ssize_t
+sched_autogroup_write(struct file *file, const char __user *buf,
+	    size_t count, loff_t *offset)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct task_struct *p;
+	char buffer[PROC_NUMBUF];
+	long nice;
+	int err;
+
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count))
+		return -EFAULT;
+
+	err = strict_strtol(strstrip(buffer), 0, &nice);
+	if (err)
+		return -EINVAL;
+
+	p = get_proc_task(inode);
+	if (!p)
+		return -ESRCH;
+
+	err = nice;
+	err = proc_sched_autogroup_set_nice(p, &err);
+	if (err)
+		count = err;
+
+	put_task_struct(p);
+
+	return count;
+}
+
+static int sched_autogroup_open(struct inode *inode, struct file *filp)
+{
+	int ret;
+
+	ret = single_open(filp, sched_autogroup_show, NULL);
+	if (!ret) {
+		struct seq_file *m = filp->private_data;
+
+		m->private = inode;
+	}
+	return ret;
+}
+
+static const struct file_operations proc_pid_sched_autogroup_operations = {
+	.open		= sched_autogroup_open,
+	.read		= seq_read,
+	.write		= sched_autogroup_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+#endif /* CONFIG_SCHED_AUTOGROUP */
+
 static ssize_t comm_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *offset)
 {
@@ -2733,6 +2809,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
+#ifdef CONFIG_SCHED_AUTOGROUP
+	REG("autogroup",  S_IRUGO|S_IWUSR, proc_pid_sched_autogroup_operations),
+#endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",    S_IRUSR, proc_pid_syscall),
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 840f127..bc6dca5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
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
@@ -1926,6 +1931,24 @@ int sched_rt_handler(struct ctl_table *table, int write,
 
 extern unsigned int sysctl_sched_compat_yield;
 
+#ifdef CONFIG_SCHED_AUTOGROUP
+extern unsigned int sysctl_sched_autogroup_enabled;
+
+extern void sched_autogroup_create_attach(struct task_struct *p);
+extern void sched_autogroup_detach(struct task_struct *p);
+extern void sched_autogroup_fork(struct signal_struct *sig);
+extern void sched_autogroup_exit(struct signal_struct *sig);
+#ifdef CONFIG_PROC_FS
+extern void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m);
+extern int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice);
+#endif
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
diff --git a/init/Kconfig b/init/Kconfig
index 88c1046..f6f44d0 100644
--- a/init/Kconfig
+++ b/init/Kconfig
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
+	  upon task session.
+
 config MM_OWNER
 	bool
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 3b159c5..b6f2475 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -174,8 +174,10 @@ static inline void free_signal_struct(struct signal_struct *sig)
 
 static inline void put_signal_struct(struct signal_struct *sig)
 {
-	if (atomic_dec_and_test(&sig->sigcnt))
+	if (atomic_dec_and_test(&sig->sigcnt)) {
+		sched_autogroup_exit(sig);
 		free_signal_struct(sig);
+	}
 }
 
 void __put_task_struct(struct task_struct *tsk)
@@ -904,6 +906,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	posix_cpu_timers_init_group(sig);
 
 	tty_audit_fork(sig);
+	sched_autogroup_fork(sig);
 
 	sig->oom_adj = current->signal->oom_adj;
 	sig->oom_score_adj = current->signal->oom_score_adj;
diff --git a/kernel/sched.c b/kernel/sched.c
index 550cf3a..2bc19cb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -78,6 +78,7 @@
 
 #include "sched_cpupri.h"
 #include "workqueue_sched.h"
+#include "sched_autogroup.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
@@ -270,6 +271,10 @@ struct task_group {
 	struct task_group *parent;
 	struct list_head siblings;
 	struct list_head children;
+
+#ifdef CONFIG_SCHED_AUTOGROUP
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
@@ -1878,6 +1886,7 @@ static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time) { }
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
+#include "sched_autogroup.c"
 #include "sched_stoptask.c"
 #ifdef CONFIG_SCHED_DEBUG
 # include "sched_debug.c"
@@ -7734,7 +7743,7 @@ void __init sched_init(void)
 #ifdef CONFIG_CGROUP_SCHED
 	list_add(&init_task_group.list, &task_groups);
 	INIT_LIST_HEAD(&init_task_group.children);
-
+	autogroup_init(&init_task);
 #endif /* CONFIG_CGROUP_SCHED */
 
 	for_each_possible_cpu(i) {
diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
new file mode 100644
index 0000000..2bd4020
--- /dev/null
+++ b/kernel/sched_autogroup.c
@@ -0,0 +1,240 @@
+#ifdef CONFIG_SCHED_AUTOGROUP
+
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/kallsyms.h>
+#include <linux/utsname.h>
+
+unsigned int __read_mostly sysctl_sched_autogroup_enabled = 1;
+
+struct autogroup {
+	struct task_group	*tg;
+	struct kref		kref;
+	struct rw_semaphore	lock;
+	unsigned long		id;
+	int			nice;
+};
+
+static struct autogroup autogroup_default;
+static atomic_t autogroup_seq_nr;
+
+static void autogroup_init(struct task_struct *init_task)
+{
+	autogroup_default.tg = &init_task_group;
+	init_task_group.autogroup = &autogroup_default;
+	kref_init(&autogroup_default.kref);
+	init_rwsem(&autogroup_default.lock);
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
+	struct autogroup *ag = kzalloc(sizeof(*ag), GFP_KERNEL);
+
+	if (!ag)
+		goto out_fail;
+
+	ag->tg = sched_create_group(&init_task_group);
+
+	if (IS_ERR(ag->tg))
+		goto out_fail;
+
+	ag->tg->autogroup = ag;
+	kref_init(&ag->kref);
+	init_rwsem(&ag->lock);
+	ag->id = atomic_inc_return(&autogroup_seq_nr);
+
+	return ag;
+
+out_fail:
+	kfree(ag);
+	WARN_ON_ONCE(1);
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
+	/*
+	 * We can only assume the task group can't go away on us if
+	 * autogroup_move_group() can see us on ->thread_group list.
+	 */
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
+#ifdef CONFIG_PROC_FS
+
+static inline struct autogroup *autogroup_get(struct task_struct *p)
+{
+	struct autogroup *ag;
+
+	/* task may be moved after we unlock.. tough */
+	spin_lock(&p->sighand->siglock);
+	ag = autogroup_kref_get(p->signal->autogroup);
+	spin_unlock(&p->sighand->siglock);
+
+	return ag;
+}
+
+int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
+{
+	static unsigned long next = INITIAL_JIFFIES;
+	struct autogroup *ag;
+	int err;
+
+	if (*nice < -20 || *nice > 19)
+		return -EINVAL;
+
+	err = security_task_setnice(current, *nice);
+	if (err)
+		return err;
+
+	if (*nice < 0 && !can_nice(current, *nice))
+		return -EPERM;
+
+	/* this is a heavy operation taking global locks.. */
+	if (!capable(CAP_SYS_ADMIN) && time_before(jiffies, next))
+		return -EAGAIN;
+
+	next = HZ / 10 + jiffies;;
+	ag = autogroup_get(p);
+
+	down_write(&ag->lock);
+	err = sched_group_set_shares(ag->tg, prio_to_weight[*nice + 20]);
+	if (!err)
+		ag->nice = *nice;
+	up_write(&ag->lock);
+
+	autogroup_kref_put(ag);
+
+	return err;
+}
+
+void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m)
+{
+	struct autogroup *ag = autogroup_get(p);
+
+	down_read(&ag->lock);
+	seq_printf(m, "/autogroup-%ld nice %d\n", ag->id, ag->nice);
+	up_read(&ag->lock);
+
+	autogroup_kref_put(ag);
+}
+#endif /* CONFIG_PROC_FS */
+
+#ifdef CONFIG_SCHED_DEBUG
+static inline int autogroup_path(struct task_group *tg, char *buf, int buflen)
+{
+	return snprintf(buf, buflen, "%s-%ld", "/autogroup", tg->autogroup->id);
+}
+#endif /* CONFIG_SCHED_DEBUG */
+
+#endif /* CONFIG_SCHED_AUTOGROUP */
diff --git a/kernel/sched_autogroup.h b/kernel/sched_autogroup.h
new file mode 100644
index 0000000..40deaef
--- /dev/null
+++ b/kernel/sched_autogroup.h
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
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index e6590e7..3e5b067 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -87,6 +87,20 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu,
 }
 #endif
 
+#if defined(CONFIG_CGROUP_SCHED) && \
+	(defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED))
+static void task_group_path(struct task_group *tg, char *buf, int buflen)
+{
+	/* may be NULL if the underlying cgroup isn't fully-created yet */
+	if (!tg->css.cgroup) {
+		if (!autogroup_path(tg, buf, buflen))
+			buf[0] = '\0';
+		return;
+	}
+	cgroup_path(tg->css.cgroup, buf, buflen);
+}
+#endif
+
 static void
 print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 {
@@ -115,7 +129,7 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 		char path[64];
 
 		rcu_read_lock();
-		cgroup_path(task_group(p)->css.cgroup, path, sizeof(path));
+		task_group_path(task_group(p), path, sizeof(path));
 		rcu_read_unlock();
 		SEQ_printf(m, " %s", path);
 	}
@@ -147,19 +161,6 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
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
diff --git a/kernel/sys.c b/kernel/sys.c
index 7f5a0cd..2745dcd 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
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
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9b520d7..eb4b493 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -370,6 +370,17 @@ static struct ctl_table kern_table[] = {
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
