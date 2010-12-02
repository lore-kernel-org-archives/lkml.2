Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab0LBStH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 13:49:07 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60588 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162Ab0LBStE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 13:49:04 -0500
Date: Thu, 2 Dec 2010 10:16:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-11-23 + autogroups -> inconsistent lock state
Message-ID: <20101202181658.GG2085@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <201011240045.oAO0jYQ5016010@imap1.linux-foundation.org>
 <6003.1290574869@localhost>
 <1290630325.4050.12.camel@maggy.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290630325.4050.12.camel@maggy.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 01:25:25PM -0700, Mike Galbraith wrote:
> On Wed, 2010-11-24 at 00:01 -0500, Valdis.Kletnieks@vt.edu wrote:
> > On Tue, 23 Nov 2010 16:13:06 PST, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2010-11-23-16-12 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > (I appear to be on a roll tonight - 3 splats before I even had a chance to login. :)
> > 
> > mmotm + Ingo's cleanup of Mike's autogroups patch.
> ...
> 
> Sorry for slow response, been trying to use some of my last few vacation
> days on vacation stuff ;-)
> 
> The below should run gripe free.  Suppose I should learn to turn on
> lockdep and whatnot when tinkering/testing.
> 
> Unfortunately, tip's update_shares() changes are still being difficult.
> 
> static void update_shares(int cpu)
> {
>         struct cfs_rq *cfs_rq;
>         struct rq *rq = cpu_rq(cpu);
> 
>         rcu_read_lock();
>         for_each_leaf_cfs_rq(rq, cfs_rq)
>                 update_shares_cpu(cfs_rq->tg, cpu);
>         rcu_read_unlock();
> }
> 
> Despite task groups being freed via rcu, update_shares_cup() hits freed
> memory and explodes, and nothing I've tried has been able to stop it.
> The only thing I haven't tried (aside from the right thing;) is to take
> rcu out of the picture entirely.

Is your new autogroup structure retaining a pointer to memory that
is freed by RCU?

If so, you will need to NULL out that pointer before the memory
in question is passed to call_rcu().  (Or before the call to
synchronize_rcu(), as the case may be.)

							Thanx, Paul

> From: Mike Galbraith <efault@gmx.de>
> Date: Sat, 20 Nov 2010 12:35:00 -0700
> Subject: [PATCH] sched: Improve desktop interactivity: Implement automated per session task groups
> 
> A recurring complaint from CFS users is that parallel kbuild has a negative
> impact on desktop interactivity.  This patch implements an idea from Linus,
> to automatically create task groups.  Currently, only per session autogroups
> are implemented, but the patch leaves the way open for enhancement.
> 
> Implementation: each task's signal struct contains an inherited pointer to
> a refcounted autogroup struct containing a task group pointer, the default
> for all tasks pointing to the init_task_group.  When a task calls setsid(),
> a new task group is created, the process is moved into the new task group,
> and a reference to the preveious task group is dropped.  Child processes
> inherit this task group thereafter, and increase it's refcount.  When the
> last thread of a process exits, the process's reference is dropped, such
> that when the last process referencing an autogroup exits, the autogroup
> is destroyed.
> 
> At runqueue selection time, IFF a task has no cgroup assignment, its current
> autogroup is used.
> 
> Autogroup bandwidth is controllable via setting it's nice level through the
> proc filesystem.  cat /proc/<pid>/autogroup displays the task's group and the
> group's nice level.  echo <nice level> > /proc/<pid>/autogroup Sets the task
> group's shares to the weight of nice <level> task.  Setting nice level is rate
> limited for !admin users due to the abuse risk of task group locking.
> 
> The feature is enabled from boot by default if CONFIG_SCHED_AUTOGROUP=y is
> selected, but can be disabled via the boot option noautogroup, and can also
> be turned on/off on the fly via..
> 	echo [01] > /proc/sys/kernel/sched_autogroup_enabled.
> ..which will automatically move tasks to/from the root task group.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> LKML-Reference: <1290281700.28711.9.camel@maggy.simson.net>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  Documentation/kernel-parameters.txt |    2 
>  fs/proc/base.c                      |   79 +++++++++++
>  include/linux/sched.h               |   23 +++
>  init/Kconfig                        |   12 +
>  kernel/fork.c                       |    5 
>  kernel/sched.c                      |   13 +
>  kernel/sched_autogroup.c            |  240 ++++++++++++++++++++++++++++++++++++
>  kernel/sched_autogroup.h            |   23 +++
>  kernel/sched_debug.c                |   29 ++--
>  kernel/sys.c                        |    4 
>  kernel/sysctl.c                     |   11 +
>  11 files changed, 423 insertions(+), 18 deletions(-)
> 
> Index: linux-2.6.37.git/include/linux/sched.h
> ===================================================================
> --- linux-2.6.37.git.orig/include/linux/sched.h
> +++ linux-2.6.37.git/include/linux/sched.h
> @@ -509,6 +509,8 @@ struct thread_group_cputimer {
>  	spinlock_t lock;
>  };
> 
> +struct autogroup;
> +
>  /*
>   * NOTE! "signal_struct" does not have it's own
>   * locking, because a shared signal_struct always
> @@ -576,6 +578,9 @@ struct signal_struct {
> 
>  	struct tty_struct *tty; /* NULL if no tty */
> 
> +#ifdef CONFIG_SCHED_AUTOGROUP
> +	struct autogroup *autogroup;
> +#endif
>  	/*
>  	 * Cumulative resource counters for dead threads in the group,
>  	 * and for reaped dead child processes forked by this group.
> @@ -1931,6 +1936,24 @@ int sched_rt_handler(struct ctl_table *t
> 
>  extern unsigned int sysctl_sched_compat_yield;
> 
> +#ifdef CONFIG_SCHED_AUTOGROUP
> +extern unsigned int sysctl_sched_autogroup_enabled;
> +
> +extern void sched_autogroup_create_attach(struct task_struct *p);
> +extern void sched_autogroup_detach(struct task_struct *p);
> +extern void sched_autogroup_fork(struct signal_struct *sig);
> +extern void sched_autogroup_exit(struct signal_struct *sig);
> +#ifdef CONFIG_PROC_FS
> +extern void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m);
> +extern int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice);
> +#endif
> +#else
> +static inline void sched_autogroup_create_attach(struct task_struct *p) { }
> +static inline void sched_autogroup_detach(struct task_struct *p) { }
> +static inline void sched_autogroup_fork(struct signal_struct *sig) { }
> +static inline void sched_autogroup_exit(struct signal_struct *sig) { }
> +#endif
> +
>  #ifdef CONFIG_RT_MUTEXES
>  extern int rt_mutex_getprio(struct task_struct *p);
>  extern void rt_mutex_setprio(struct task_struct *p, int prio);
> Index: linux-2.6.37.git/kernel/sched.c
> ===================================================================
> --- linux-2.6.37.git.orig/kernel/sched.c
> +++ linux-2.6.37.git/kernel/sched.c
> @@ -78,6 +78,7 @@
> 
>  #include "sched_cpupri.h"
>  #include "workqueue_sched.h"
> +#include "sched_autogroup.h"
> 
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/sched.h>
> @@ -268,6 +269,10 @@ struct task_group {
>  	struct task_group *parent;
>  	struct list_head siblings;
>  	struct list_head children;
> +
> +#ifdef CONFIG_SCHED_AUTOGROUP
> +	struct autogroup *autogroup;
> +#endif
>  };
> 
>  #define root_task_group init_task_group
> @@ -605,11 +610,14 @@ static inline int cpu_of(struct rq *rq)
>   */
>  static inline struct task_group *task_group(struct task_struct *p)
>  {
> +	struct task_group *tg;
>  	struct cgroup_subsys_state *css;
> 
>  	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
>  			lockdep_is_held(&task_rq(p)->lock));
> -	return container_of(css, struct task_group, css);
> +	tg = container_of(css, struct task_group, css);
> +
> +	return autogroup_task_group(p, tg);
>  }
> 
>  /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
> @@ -2006,6 +2014,7 @@ static void sched_irq_time_avg_update(st
>  #include "sched_idletask.c"
>  #include "sched_fair.c"
>  #include "sched_rt.c"
> +#include "sched_autogroup.c"
>  #include "sched_stoptask.c"
>  #ifdef CONFIG_SCHED_DEBUG
>  # include "sched_debug.c"
> @@ -7979,7 +7988,7 @@ void __init sched_init(void)
>  #ifdef CONFIG_CGROUP_SCHED
>  	list_add(&init_task_group.list, &task_groups);
>  	INIT_LIST_HEAD(&init_task_group.children);
> -
> +	autogroup_init(&init_task);
>  #endif /* CONFIG_CGROUP_SCHED */
> 
>  #if defined CONFIG_FAIR_GROUP_SCHED && defined CONFIG_SMP
> Index: linux-2.6.37.git/kernel/fork.c
> ===================================================================
> --- linux-2.6.37.git.orig/kernel/fork.c
> +++ linux-2.6.37.git/kernel/fork.c
> @@ -174,8 +174,10 @@ static inline void free_signal_struct(st
> 
>  static inline void put_signal_struct(struct signal_struct *sig)
>  {
> -	if (atomic_dec_and_test(&sig->sigcnt))
> +	if (atomic_dec_and_test(&sig->sigcnt)) {
> +		sched_autogroup_exit(sig);
>  		free_signal_struct(sig);
> +	}
>  }
> 
>  void __put_task_struct(struct task_struct *tsk)
> @@ -904,6 +906,7 @@ static int copy_signal(unsigned long clo
>  	posix_cpu_timers_init_group(sig);
> 
>  	tty_audit_fork(sig);
> +	sched_autogroup_fork(sig);
> 
>  	sig->oom_adj = current->signal->oom_adj;
>  	sig->oom_score_adj = current->signal->oom_score_adj;
> Index: linux-2.6.37.git/kernel/sys.c
> ===================================================================
> --- linux-2.6.37.git.orig/kernel/sys.c
> +++ linux-2.6.37.git/kernel/sys.c
> @@ -1080,8 +1080,10 @@ SYSCALL_DEFINE0(setsid)
>  	err = session;
>  out:
>  	write_unlock_irq(&tasklist_lock);
> -	if (err > 0)
> +	if (err > 0) {
>  		proc_sid_connector(group_leader);
> +		sched_autogroup_create_attach(group_leader);
> +	}
>  	return err;
>  }
> 
> Index: linux-2.6.37.git/kernel/sched_debug.c
> ===================================================================
> --- linux-2.6.37.git.orig/kernel/sched_debug.c
> +++ linux-2.6.37.git/kernel/sched_debug.c
> @@ -87,6 +87,20 @@ static void print_cfs_group_stats(struct
>  }
>  #endif
> 
> +#if defined(CONFIG_CGROUP_SCHED) && \
> +	(defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED))
> +static void task_group_path(struct task_group *tg, char *buf, int buflen)
> +{
> +	/* may be NULL if the underlying cgroup isn't fully-created yet */
> +	if (!tg->css.cgroup) {
> +		if (!autogroup_path(tg, buf, buflen))
> +			buf[0] = '\0';
> +		return;
> +	}
> +	cgroup_path(tg->css.cgroup, buf, buflen);
> +}
> +#endif
> +
>  static void
>  print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
>  {
> @@ -115,7 +129,7 @@ print_task(struct seq_file *m, struct rq
>  		char path[64];
> 
>  		rcu_read_lock();
> -		cgroup_path(task_group(p)->css.cgroup, path, sizeof(path));
> +		task_group_path(task_group(p), path, sizeof(path));
>  		rcu_read_unlock();
>  		SEQ_printf(m, " %s", path);
>  	}
> @@ -147,19 +161,6 @@ static void print_rq(struct seq_file *m,
>  	read_unlock_irqrestore(&tasklist_lock, flags);
>  }
> 
> -#if defined(CONFIG_CGROUP_SCHED) && \
> -	(defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED))
> -static void task_group_path(struct task_group *tg, char *buf, int buflen)
> -{
> -	/* may be NULL if the underlying cgroup isn't fully-created yet */
> -	if (!tg->css.cgroup) {
> -		buf[0] = '\0';
> -		return;
> -	}
> -	cgroup_path(tg->css.cgroup, buf, buflen);
> -}
> -#endif
> -
>  void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>  {
>  	s64 MIN_vruntime = -1, min_vruntime, max_vruntime = -1,
> Index: linux-2.6.37.git/fs/proc/base.c
> ===================================================================
> --- linux-2.6.37.git.orig/fs/proc/base.c
> +++ linux-2.6.37.git/fs/proc/base.c
> @@ -1407,6 +1407,82 @@ static const struct file_operations proc
> 
>  #endif
> 
> +#ifdef CONFIG_SCHED_AUTOGROUP
> +/*
> + * Print out autogroup related information:
> + */
> +static int sched_autogroup_show(struct seq_file *m, void *v)
> +{
> +	struct inode *inode = m->private;
> +	struct task_struct *p;
> +
> +	p = get_proc_task(inode);
> +	if (!p)
> +		return -ESRCH;
> +	proc_sched_autogroup_show_task(p, m);
> +
> +	put_task_struct(p);
> +
> +	return 0;
> +}
> +
> +static ssize_t
> +sched_autogroup_write(struct file *file, const char __user *buf,
> +	    size_t count, loff_t *offset)
> +{
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +	struct task_struct *p;
> +	char buffer[PROC_NUMBUF];
> +	long nice;
> +	int err;
> +
> +	memset(buffer, 0, sizeof(buffer));
> +	if (count > sizeof(buffer) - 1)
> +		count = sizeof(buffer) - 1;
> +	if (copy_from_user(buffer, buf, count))
> +		return -EFAULT;
> +
> +	err = strict_strtol(strstrip(buffer), 0, &nice);
> +	if (err)
> +		return -EINVAL;
> +
> +	p = get_proc_task(inode);
> +	if (!p)
> +		return -ESRCH;
> +
> +	err = nice;
> +	err = proc_sched_autogroup_set_nice(p, &err);
> +	if (err)
> +		count = err;
> +
> +	put_task_struct(p);
> +
> +	return count;
> +}
> +
> +static int sched_autogroup_open(struct inode *inode, struct file *filp)
> +{
> +	int ret;
> +
> +	ret = single_open(filp, sched_autogroup_show, NULL);
> +	if (!ret) {
> +		struct seq_file *m = filp->private_data;
> +
> +		m->private = inode;
> +	}
> +	return ret;
> +}
> +
> +static const struct file_operations proc_pid_sched_autogroup_operations = {
> +	.open		= sched_autogroup_open,
> +	.read		= seq_read,
> +	.write		= sched_autogroup_write,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
> +
> +#endif /* CONFIG_SCHED_AUTOGROUP */
> +
>  static ssize_t comm_write(struct file *file, const char __user *buf,
>  				size_t count, loff_t *offset)
>  {
> @@ -2733,6 +2809,9 @@ static const struct pid_entry tgid_base_
>  #ifdef CONFIG_SCHED_DEBUG
>  	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
>  #endif
> +#ifdef CONFIG_SCHED_AUTOGROUP
> +	REG("autogroup",  S_IRUGO|S_IWUSR, proc_pid_sched_autogroup_operations),
> +#endif
>  	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
>  #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
>  	INF("syscall",    S_IRUSR, proc_pid_syscall),
> Index: linux-2.6.37.git/kernel/sched_autogroup.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6.37.git/kernel/sched_autogroup.h
> @@ -0,0 +1,23 @@
> +#ifdef CONFIG_SCHED_AUTOGROUP
> +
> +static inline struct task_group *
> +autogroup_task_group(struct task_struct *p, struct task_group *tg);
> +
> +#else /* !CONFIG_SCHED_AUTOGROUP */
> +
> +static inline void autogroup_init(struct task_struct *init_task) {  }
> +
> +static inline struct task_group *
> +autogroup_task_group(struct task_struct *p, struct task_group *tg)
> +{
> +	return tg;
> +}
> +
> +#ifdef CONFIG_SCHED_DEBUG
> +static inline int autogroup_path(struct task_group *tg, char *buf, int buflen)
> +{
> +	return 0;
> +}
> +#endif
> +
> +#endif /* CONFIG_SCHED_AUTOGROUP */
> Index: linux-2.6.37.git/kernel/sched_autogroup.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.37.git/kernel/sched_autogroup.c
> @@ -0,0 +1,240 @@
> +#ifdef CONFIG_SCHED_AUTOGROUP
> +
> +#include <linux/proc_fs.h>
> +#include <linux/seq_file.h>
> +#include <linux/kallsyms.h>
> +#include <linux/utsname.h>
> +
> +unsigned int __read_mostly sysctl_sched_autogroup_enabled = 1;
> +
> +struct autogroup {
> +	struct kref		kref;
> +	struct task_group	*tg;
> +	struct rw_semaphore	lock;
> +	unsigned long		id;
> +	int			nice;
> +};
> +
> +static struct autogroup autogroup_default;
> +static atomic_t autogroup_seq_nr;
> +
> +static void autogroup_init(struct task_struct *init_task)
> +{
> +	autogroup_default.tg = &init_task_group;
> +	init_task_group.autogroup = &autogroup_default;
> +	kref_init(&autogroup_default.kref);
> +	init_rwsem(&autogroup_default.lock);
> +	init_task->signal->autogroup = &autogroup_default;
> +}
> +
> +static inline void autogroup_free(struct task_group *tg)
> +{
> +	kfree(tg->autogroup);
> +}
> +
> +static inline void autogroup_destroy(struct kref *kref)
> +{
> +	struct autogroup *ag = container_of(kref, struct autogroup, kref);
> +
> +	sched_destroy_group(ag->tg);
> +}
> +
> +static inline void autogroup_kref_put(struct autogroup *ag)
> +{
> +	kref_put(&ag->kref, autogroup_destroy);
> +}
> +
> +static inline struct autogroup *autogroup_kref_get(struct autogroup *ag)
> +{
> +	kref_get(&ag->kref);
> +	return ag;
> +}
> +
> +static inline struct autogroup *autogroup_create(void)
> +{
> +	struct autogroup *ag = kzalloc(sizeof(*ag), GFP_KERNEL);
> +	struct task_group *tg;
> +
> +	if (!ag)
> +		goto out_fail;
> +
> +	tg = sched_create_group(&init_task_group);
> +
> +	if (IS_ERR(tg))
> +		goto out_free;
> +
> +	kref_init(&ag->kref);
> +	init_rwsem(&ag->lock);
> +	ag->id = atomic_inc_return(&autogroup_seq_nr);
> +	ag->tg = tg;
> +	tg->autogroup = ag;
> +
> +	return ag;
> +
> +out_free:
> +	kfree(ag);
> +out_fail:
> +	if (printk_ratelimit())
> +		printk(KERN_WARNING "autogroup_create: %s failure.\n",
> +			ag ? "sched_create_group()" : "kmalloc()");
> +
> +	return autogroup_kref_get(&autogroup_default);
> +}
> +
> +static inline bool
> +task_wants_autogroup(struct task_struct *p, struct task_group *tg)
> +{
> +	if (tg != &root_task_group)
> +		return false;
> +
> +	if (p->sched_class != &fair_sched_class)
> +		return false;
> +
> +	/*
> +	 * We can only assume the task group can't go away on us if
> +	 * autogroup_move_group() can see us on ->thread_group list.
> +	 */
> +	if (p->flags & PF_EXITING)
> +		return false;
> +
> +	return true;
> +}
> +
> +static inline struct task_group *
> +autogroup_task_group(struct task_struct *p, struct task_group *tg)
> +{
> +	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
> +
> +	if (enabled && task_wants_autogroup(p, tg))
> +		return p->signal->autogroup->tg;
> +
> +	return tg;
> +}
> +
> +static void
> +autogroup_move_group(struct task_struct *p, struct autogroup *ag)
> +{
> +	struct autogroup *prev;
> +	struct task_struct *t;
> +	unsigned long flags;
> +
> +	if (!lock_task_sighand(p, &flags)) {
> +		WARN_ON(1);
> +		return;
> +	}
> +
> +	prev = p->signal->autogroup;
> +	if (prev == ag) {
> +		unlock_task_sighand(p, &flags);
> +		return;
> +	}
> +
> +	p->signal->autogroup = autogroup_kref_get(ag);
> +	t = p;
> +
> +	do {
> +		sched_move_task(t);
> +	} while_each_thread(p, t);
> +
> +	unlock_task_sighand(p, &flags);
> +	autogroup_kref_put(prev);
> +}
> +
> +/* Allocates GFP_KERNEL, cannot be called under any spinlock */
> +void sched_autogroup_create_attach(struct task_struct *p)
> +{
> +	struct autogroup *ag = autogroup_create();
> +
> +	autogroup_move_group(p, ag);
> +	/* drop extra refrence added by autogroup_create() */
> +	autogroup_kref_put(ag);
> +}
> +EXPORT_SYMBOL(sched_autogroup_create_attach);
> +
> +/* Cannot be called under siglock.  Currently has no users */
> +void sched_autogroup_detach(struct task_struct *p)
> +{
> +	autogroup_move_group(p, &autogroup_default);
> +}
> +EXPORT_SYMBOL(sched_autogroup_detach);
> +
> +void sched_autogroup_fork(struct signal_struct *sig)
> +{
> +	struct task_struct *p = current;
> +
> +	spin_lock_irq(&p->sighand->siglock);
> +	sig->autogroup = autogroup_kref_get(p->signal->autogroup);
> +	spin_unlock_irq(&p->sighand->siglock);
> +}
> +
> +void sched_autogroup_exit(struct signal_struct *sig)
> +{
> +	autogroup_kref_put(sig->autogroup);
> +}
> +
> +static int __init setup_autogroup(char *str)
> +{
> +	sysctl_sched_autogroup_enabled = 0;
> +
> +	return 1;
> +}
> +
> +__setup("noautogroup", setup_autogroup);
> +
> +#ifdef CONFIG_PROC_FS
> +
> +/* Called with siglock held. */
> +int proc_sched_autogroup_set_nice(struct task_struct *p, int *nice)
> +{
> +	static unsigned long next = INITIAL_JIFFIES;
> +	struct autogroup *ag;
> +	int err;
> +
> +	if (*nice < -20 || *nice > 19)
> +		return -EINVAL;
> +
> +	err = security_task_setnice(current, *nice);
> +	if (err)
> +		return err;
> +
> +	if (*nice < 0 && !can_nice(current, *nice))
> +		return -EPERM;
> +
> +	/* this is a heavy operation taking global locks.. */
> +	if (!capable(CAP_SYS_ADMIN) && time_before(jiffies, next))
> +		return -EAGAIN;
> +
> +	next = HZ / 10 + jiffies;
> +	ag = autogroup_kref_get(p->signal->autogroup);
> +
> +	down_write(&ag->lock);
> +	err = sched_group_set_shares(ag->tg, prio_to_weight[*nice + 20]);
> +	if (!err)
> +		ag->nice = *nice;
> +	up_write(&ag->lock);
> +
> +	autogroup_kref_put(ag);
> +
> +	return err;
> +}
> +
> +void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m)
> +{
> +	struct autogroup *ag = autogroup_kref_get(p->signal->autogroup);
> +
> +	down_read(&ag->lock);
> +	seq_printf(m, "/autogroup-%ld nice %d\n", ag->id, ag->nice);
> +	up_read(&ag->lock);
> +
> +	autogroup_kref_put(ag);
> +}
> +#endif /* CONFIG_PROC_FS */
> +
> +#ifdef CONFIG_SCHED_DEBUG
> +static inline int autogroup_path(struct task_group *tg, char *buf, int buflen)
> +{
> +	return snprintf(buf, buflen, "%s-%ld", "/autogroup", tg->autogroup->id);
> +}
> +#endif /* CONFIG_SCHED_DEBUG */
> +
> +#endif /* CONFIG_SCHED_AUTOGROUP */
> Index: linux-2.6.37.git/kernel/sysctl.c
> ===================================================================
> --- linux-2.6.37.git.orig/kernel/sysctl.c
> +++ linux-2.6.37.git/kernel/sysctl.c
> @@ -382,6 +382,17 @@ static struct ctl_table kern_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec,
>  	},
> +#ifdef CONFIG_SCHED_AUTOGROUP
> +	{
> +		.procname	= "sched_autogroup_enabled",
> +		.data		= &sysctl_sched_autogroup_enabled,
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,
> +		.extra1		= &zero,
> +		.extra2		= &one,
> +	},
> +#endif
>  #ifdef CONFIG_PROVE_LOCKING
>  	{
>  		.procname	= "prove_locking",
> Index: linux-2.6.37.git/init/Kconfig
> ===================================================================
> --- linux-2.6.37.git.orig/init/Kconfig
> +++ linux-2.6.37.git/init/Kconfig
> @@ -728,6 +728,18 @@ config NET_NS
> 
>  endif # NAMESPACES
> 
> +config SCHED_AUTOGROUP
> +	bool "Automatic process group scheduling"
> +	select CGROUPS
> +	select CGROUP_SCHED
> +	select FAIR_GROUP_SCHED
> +	help
> +	  This option optimizes the scheduler for common desktop workloads by
> +	  automatically creating and populating task groups.  This separation
> +	  of workloads isolates aggressive CPU burners (like build jobs) from
> +	  desktop applications.  Task group autogeneration is currently based
> +	  upon task session.
> +
>  config MM_OWNER
>  	bool
> 
> Index: linux-2.6.37.git/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.37.git.orig/Documentation/kernel-parameters.txt
> +++ linux-2.6.37.git/Documentation/kernel-parameters.txt
> @@ -1622,6 +1622,8 @@ and is between 256 and 4096 characters.
>  	noapic		[SMP,APIC] Tells the kernel to not make use of any
>  			IOAPICs that may be present in the system.
> 
> +	noautogroup	Disable scheduler automatic task group creation.
> +
>  	nobats		[PPC] Do not use BATs for mapping kernel lowmem
>  			on "Classic" PPC cores.
> 
> 
>         
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
