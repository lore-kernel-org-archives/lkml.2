Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab1AFJ3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:29:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58236 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab1AFJ2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:28:51 -0500
Date: Thu, 6 Jan 2011 10:28:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v2.6.38
Message-ID: <20110106092833.GA16125@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-core-for-linus

The biggest user-visible change is the new auto-group scheduling feature - it can be 
enabled via CONFIG_SCHED_AUTOGROUP=y (disabled by default).

With this feature enabled the scheduler protects tasks in different terminals/ttys 
from each other.

I tried a few typical workloads like make -j20 kernel builds, hackbench or lots of 
CPU-intense loops - Firefox interactivity was not impacted in any measurable way 
while the runqueues were permanently overloaded with 100 or more tasks per CPU. (!)

So it's unconditional goodness on the desktop and it is perhaps one of the biggest 
and most visible interactivity improvements achieved by the Linux scheduler, ever. 
Group scheduling is a league of its own in terms of interactivity and all the group 
scheduling integration pain of the past two years seems to have paid off for the 
Linux desktop, finally.

 Thanks,

	Ingo

------------------>
Dario Faggioli (1):
      sched: Make pushable_tasks CONFIG_SMP dependant

Dhaval Giani (1):
      cpu: Remove unused variable

Eric Dumazet (1):
      printk: Use this_cpu_{read|write} api on printk_pending

Erik Gilling (1):
      sched: Make task dump print all 15 chars of proc comm

Gerald Schaefer (1):
      mutexes, sched: Introduce arch_mutex_cpu_relax()

KOSAKI Motohiro (1):
      sched: Make sched_param argument static in sched_setscheduler() callers

Mike Galbraith (3):
      sched: Add 'autogroup' scheduling feature: automated per session task groups
      sched, autogroup: Fix potential access to freed memory
      sched, autogroup: Fix reference leak

NeilBrown (1):
      sched: Change wait_for_completion_*_timeout() to return a signed long

Nikanth Karthikesan (1):
      sched: Remove unused argument dest_cpu to migrate_task()

Paul Turner (11):
      sched: Fix load corruption from update_cfs_shares()
      sched: Fix update_cfs_load() synchronization
      sched: Introduce hierarchal order on shares update list
      sched: Add sysctl_sched_shares_window
      sched: Update shares on idle_balance
      sched: Implement demand based update_cfs_load()
      sched: Allow update_cfs_load() to update global load
      sched: Update tg->shares after cpu.shares write
      sched: Fix unregister_fair_sched_group()
      sched: Move periodic share updates to entity_tick()
      sched: Fix interactivity bug by charging unaccounted run-time on entity re-weight

Peter Zijlstra (7):
      sched: Simplify cpu-hot-unplug task migration
      sched: Rewrite tg_shares_up)
      sched: Implement on-demand (active) cfs_rq list
      sched: Make tg_shares_up() walk on-demand
      sched: Fix UP build breakage
      cpu: Remove incorrect BUG_ON
      sched: Add some clock info to sched_debug

Yong Zhang (1):
      sched: Remove redundant CONFIG_CGROUP_SCHED ifdef


 Documentation/kernel-parameters.txt |    2 +
 arch/Kconfig                        |    3 +
 arch/s390/Kconfig                   |    1 +
 arch/s390/include/asm/mutex.h       |    2 +
 fs/proc/base.c                      |   79 +++++
 include/linux/completion.h          |    8 +-
 include/linux/init_task.h           |    9 +-
 include/linux/mutex.h               |    4 +
 include/linux/sched.h               |   36 ++-
 init/Kconfig                        |   13 +
 kernel/cpu.c                        |   18 +-
 kernel/fork.c                       |    7 +-
 kernel/irq/manage.c                 |    4 +-
 kernel/kthread.c                    |    2 +-
 kernel/mutex.c                      |    2 +-
 kernel/printk.c                     |    8 +-
 kernel/sched.c                      |  569 +++++++++--------------------------
 kernel/sched_autogroup.c            |  238 +++++++++++++++
 kernel/sched_autogroup.h            |   32 ++
 kernel/sched_clock.c                |    2 +-
 kernel/sched_debug.c                |   91 +++----
 kernel/sched_fair.c                 |  322 ++++++++++++++++----
 kernel/sched_features.h             |    2 -
 kernel/sched_rt.c                   |   24 ++
 kernel/softirq.c                    |    4 +-
 kernel/sys.c                        |    4 +-
 kernel/sysctl.c                     |   37 ++--
 kernel/trace/trace_selftest.c       |    2 +-
 kernel/watchdog.c                   |    2 +-
 29 files changed, 930 insertions(+), 597 deletions(-)
 create mode 100644 kernel/sched_autogroup.c
 create mode 100644 kernel/sched_autogroup.h

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 01ece1b..1031923 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1622,6 +1622,8 @@ and is between 256 and 4096 characters. It is defined in the file
 	noapic		[SMP,APIC] Tells the kernel to not make use of any
 			IOAPICs that may be present in the system.
 
+	noautogroup	Disable scheduler automatic task group creation.
+
 	nobats		[PPC] Do not use BATs for mapping kernel lowmem
 			on "Classic" PPC cores.
 
diff --git a/arch/Kconfig b/arch/Kconfig
index 8bf0fa65..f78c2be 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -175,4 +175,7 @@ config HAVE_PERF_EVENTS_NMI
 config HAVE_ARCH_JUMP_LABEL
 	bool
 
+config HAVE_ARCH_MUTEX_CPU_RELAX
+	bool
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index e0b98e7..6c6d7b3 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -99,6 +99,7 @@ config S390
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_LZO
 	select HAVE_GET_USER_PAGES_FAST
+	select HAVE_ARCH_MUTEX_CPU_RELAX
 	select ARCH_INLINE_SPIN_TRYLOCK
 	select ARCH_INLINE_SPIN_TRYLOCK_BH
 	select ARCH_INLINE_SPIN_LOCK
diff --git a/arch/s390/include/asm/mutex.h b/arch/s390/include/asm/mutex.h
index 458c1f7..688271f 100644
--- a/arch/s390/include/asm/mutex.h
+++ b/arch/s390/include/asm/mutex.h
@@ -7,3 +7,5 @@
  */
 
 #include <asm-generic/mutex-dec.h>
+
+#define arch_mutex_cpu_relax()	barrier()
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1828451..08cba2c 100644
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
diff --git a/include/linux/completion.h b/include/linux/completion.h
index 36d57f7..51494e6 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -81,10 +81,10 @@ extern int wait_for_completion_interruptible(struct completion *x);
 extern int wait_for_completion_killable(struct completion *x);
 extern unsigned long wait_for_completion_timeout(struct completion *x,
 						   unsigned long timeout);
-extern unsigned long wait_for_completion_interruptible_timeout(
-			struct completion *x, unsigned long timeout);
-extern unsigned long wait_for_completion_killable_timeout(
-			struct completion *x, unsigned long timeout);
+extern long wait_for_completion_interruptible_timeout(
+	struct completion *x, unsigned long timeout);
+extern long wait_for_completion_killable_timeout(
+	struct completion *x, unsigned long timeout);
 extern bool try_wait_for_completion(struct completion *x);
 extern bool completion_done(struct completion *x);
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 1f8c06c..6ed8812 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -12,6 +12,13 @@
 #include <linux/securebits.h>
 #include <net/net_namespace.h>
 
+#ifdef CONFIG_SMP
+# define INIT_PUSHABLE_TASKS(tsk)					\
+	.pushable_tasks = PLIST_NODE_INIT(tsk.pushable_tasks, MAX_PRIO),
+#else
+# define INIT_PUSHABLE_TASKS(tsk)
+#endif
+
 extern struct files_struct init_files;
 extern struct fs_struct init_fs;
 
@@ -137,7 +144,7 @@ extern struct cred init_cred;
 		.nr_cpus_allowed = NR_CPUS,				\
 	},								\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
-	.pushable_tasks = PLIST_NODE_INIT(tsk.pushable_tasks, MAX_PRIO), \
+	INIT_PUSHABLE_TASKS(tsk)					\
 	.ptraced	= LIST_HEAD_INIT(tsk.ptraced),			\
 	.ptrace_entry	= LIST_HEAD_INIT(tsk.ptrace_entry),		\
 	.real_parent	= &tsk,						\
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index f363bc8..94b48bd 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -160,4 +160,8 @@ extern int mutex_trylock(struct mutex *lock);
 extern void mutex_unlock(struct mutex *lock);
 extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 
+#ifndef CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX
+#define arch_mutex_cpu_relax()	cpu_relax()
+#endif
+
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2238745..883ad10 100644
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
@@ -1235,7 +1240,9 @@ struct task_struct {
 #endif
 
 	struct list_head tasks;
+#ifdef CONFIG_SMP
 	struct plist_node pushable_tasks;
+#endif
 
 	struct mm_struct *mm, *active_mm;
 #if defined(SPLIT_RSS_COUNTING)
@@ -1872,14 +1879,11 @@ extern void sched_clock_idle_sleep_event(void);
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
 
 #ifdef CONFIG_HOTPLUG_CPU
-extern void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p);
 extern void idle_task_exit(void);
 #else
 static inline void idle_task_exit(void) {}
 #endif
 
-extern void sched_idle_next(void);
-
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
 extern void wake_up_idle_cpu(int cpu);
 #else
@@ -1889,8 +1893,6 @@ static inline void wake_up_idle_cpu(int cpu) { }
 extern unsigned int sysctl_sched_latency;
 extern unsigned int sysctl_sched_min_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
-extern unsigned int sysctl_sched_shares_ratelimit;
-extern unsigned int sysctl_sched_shares_thresh;
 extern unsigned int sysctl_sched_child_runs_first;
 
 enum sched_tunable_scaling {
@@ -1906,6 +1908,7 @@ extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
 extern unsigned int sysctl_sched_time_avg;
 extern unsigned int sysctl_timer_migration;
+extern unsigned int sysctl_sched_shares_window;
 
 int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length,
@@ -1931,6 +1934,24 @@ int sched_rt_handler(struct ctl_table *table, int write,
 
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
@@ -1949,9 +1970,10 @@ extern int task_nice(const struct task_struct *p);
 extern int can_nice(const struct task_struct *p, const int nice);
 extern int task_curr(const struct task_struct *p);
 extern int idle_cpu(int cpu);
-extern int sched_setscheduler(struct task_struct *, int, struct sched_param *);
+extern int sched_setscheduler(struct task_struct *, int,
+			      const struct sched_param *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int,
-				      struct sched_param *);
+				      const struct sched_param *);
 extern struct task_struct *idle_task(int cpu);
 extern struct task_struct *curr_task(int cpu);
 extern void set_curr_task(int cpu, struct task_struct *p);
diff --git a/init/Kconfig b/init/Kconfig
index c972899..62b7149 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -741,6 +741,19 @@ config NET_NS
 
 endif # NAMESPACES
 
+config SCHED_AUTOGROUP
+	bool "Automatic process group scheduling"
+	select EVENTFD
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
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index f6e726f..cb7a1ef 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -189,7 +189,6 @@ static inline void check_for_tasks(int cpu)
 }
 
 struct take_cpu_down_param {
-	struct task_struct *caller;
 	unsigned long mod;
 	void *hcpu;
 };
@@ -198,7 +197,6 @@ struct take_cpu_down_param {
 static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
-	unsigned int cpu = (unsigned long)param->hcpu;
 	int err;
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
@@ -208,11 +206,6 @@ static int __ref take_cpu_down(void *_param)
 
 	cpu_notify(CPU_DYING | param->mod, param->hcpu);
 
-	if (task_cpu(param->caller) == cpu)
-		move_task_off_dead_cpu(cpu, param->caller);
-	/* Force idle task to run as soon as we yield: it should
-	   immediately notice cpu is offline and die quickly. */
-	sched_idle_next();
 	return 0;
 }
 
@@ -223,7 +216,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct take_cpu_down_param tcd_param = {
-		.caller = current,
 		.mod = mod,
 		.hcpu = hcpu,
 	};
@@ -253,9 +245,15 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	}
 	BUG_ON(cpu_online(cpu));
 
-	/* Wait for it to sleep (leaving idle task). */
+	/*
+	 * The migration_call() CPU_DYING callback will have removed all
+	 * runnable tasks from the cpu, there's only the idle task left now
+	 * that the migration thread is done doing the stop_machine thing.
+	 *
+	 * Wait for the stop thread to go away.
+	 */
 	while (!idle_cpu(cpu))
-		yield();
+		cpu_relax();
 
 	/* This actually kills the CPU. */
 	__cpu_die(cpu);
diff --git a/kernel/fork.c b/kernel/fork.c
index 5447dc7..7d164e2 100644
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
@@ -905,6 +907,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	posix_cpu_timers_init_group(sig);
 
 	tty_audit_fork(sig);
+	sched_autogroup_fork(sig);
 
 	sig->oom_adj = current->signal->oom_adj;
 	sig->oom_score_adj = current->signal->oom_score_adj;
@@ -1315,7 +1318,7 @@ bad_fork_cleanup_mm:
 	}
 bad_fork_cleanup_signal:
 	if (!(clone_flags & CLONE_THREAD))
-		free_signal_struct(p->signal);
+		put_signal_struct(p->signal);
 bad_fork_cleanup_sighand:
 	__cleanup_sighand(p->sighand);
 bad_fork_cleanup_fs:
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 5f92acc..91a5fa2 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -577,7 +577,9 @@ irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action) { }
  */
 static int irq_thread(void *data)
 {
-	struct sched_param param = { .sched_priority = MAX_USER_RT_PRIO/2, };
+	static struct sched_param param = {
+		.sched_priority = MAX_USER_RT_PRIO/2,
+	};
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
 	int wake, oneshot = desc->status & IRQ_ONESHOT;
diff --git a/kernel/kthread.c b/kernel/kthread.c
index ca61bbd..5355cfd 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -148,7 +148,7 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
 	wait_for_completion(&create.done);
 
 	if (!IS_ERR(create.result)) {
-		struct sched_param param = { .sched_priority = 0 };
+		static struct sched_param param = { .sched_priority = 0 };
 		va_list args;
 
 		va_start(args, namefmt);
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 200407c..a5889fb 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -199,7 +199,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * memory barriers as we'll eventually observe the right
 		 * values at the cost of a few extra spins.
 		 */
-		cpu_relax();
+		arch_mutex_cpu_relax();
 	}
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
diff --git a/kernel/printk.c b/kernel/printk.c
index a23315d..ab3ffc5 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1074,17 +1074,17 @@ static DEFINE_PER_CPU(int, printk_pending);
 
 void printk_tick(void)
 {
-	if (__get_cpu_var(printk_pending)) {
-		__get_cpu_var(printk_pending) = 0;
+	if (__this_cpu_read(printk_pending)) {
+		__this_cpu_write(printk_pending, 0);
 		wake_up_interruptible(&log_wait);
 	}
 }
 
 int printk_needs_cpu(int cpu)
 {
-	if (unlikely(cpu_is_offline(cpu)))
+	if (cpu_is_offline(cpu))
 		printk_tick();
-	return per_cpu(printk_pending, cpu);
+	return __this_cpu_read(printk_pending);
 }
 
 void wake_up_klogd(void)
diff --git a/kernel/sched.c b/kernel/sched.c
index 297d1a0..114a0de 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -75,9 +75,11 @@
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
+#include <asm/mutex.h>
 
 #include "sched_cpupri.h"
 #include "workqueue_sched.h"
+#include "sched_autogroup.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
@@ -253,6 +255,8 @@ struct task_group {
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
 	unsigned long shares;
+
+	atomic_t load_weight;
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -268,24 +272,19 @@ struct task_group {
 	struct task_group *parent;
 	struct list_head siblings;
 	struct list_head children;
+
+#ifdef CONFIG_SCHED_AUTOGROUP
+	struct autogroup *autogroup;
+#endif
 };
 
 #define root_task_group init_task_group
 
-/* task_group_lock serializes add/remove of task groups and also changes to
- * a task group's cpu shares.
- */
+/* task_group_lock serializes the addition/removal of task groups */
 static DEFINE_SPINLOCK(task_group_lock);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
-#ifdef CONFIG_SMP
-static int root_task_group_empty(void)
-{
-	return list_empty(&root_task_group.children);
-}
-#endif
-
 # define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
 
 /*
@@ -342,6 +341,7 @@ struct cfs_rq {
 	 * leaf_cfs_rq_list ties together list of leaf cfs_rq's in a cpu. This
 	 * list is used during load balance.
 	 */
+	int on_list;
 	struct list_head leaf_cfs_rq_list;
 	struct task_group *tg;	/* group that "owns" this runqueue */
 
@@ -360,14 +360,17 @@ struct cfs_rq {
 	unsigned long h_load;
 
 	/*
-	 * this cpu's part of tg->shares
+	 * Maintaining per-cpu shares distribution for group scheduling
+	 *
+	 * load_stamp is the last time we updated the load average
+	 * load_last is the last time we updated the load average and saw load
+	 * load_unacc_exec_time is currently unaccounted execution time
 	 */
-	unsigned long shares;
+	u64 load_avg;
+	u64 load_period;
+	u64 load_stamp, load_last, load_unacc_exec_time;
 
-	/*
-	 * load.weight at the time we set shares
-	 */
-	unsigned long rq_weight;
+	unsigned long load_contribution;
 #endif
 #endif
 };
@@ -605,11 +608,14 @@ static inline int cpu_of(struct rq *rq)
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
@@ -793,20 +799,6 @@ late_initcall(sched_init_debug);
 const_debug unsigned int sysctl_sched_nr_migrate = 32;
 
 /*
- * ratelimit for updating the group shares.
- * default: 0.25ms
- */
-unsigned int sysctl_sched_shares_ratelimit = 250000;
-unsigned int normalized_sysctl_sched_shares_ratelimit = 250000;
-
-/*
- * Inject some fuzzyness into changing the per-cpu group shares
- * this avoids remote rq-locks at the expense of fairness.
- * default: 4
- */
-unsigned int sysctl_sched_shares_thresh = 4;
-
-/*
  * period over which we average the RT time consumption, measured
  * in ms.
  *
@@ -1355,6 +1347,12 @@ static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
 	lw->inv_weight = 0;
 }
 
+static inline void update_load_set(struct load_weight *lw, unsigned long w)
+{
+	lw->weight = w;
+	lw->inv_weight = 0;
+}
+
 /*
  * To aid in avoiding the subversion of "niceness" due to uneven distribution
  * of tasks with abnormal "nice" values across CPUs the contribution that
@@ -1543,101 +1541,6 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
-static __read_mostly unsigned long __percpu *update_shares_data;
-
-static void __set_se_shares(struct sched_entity *se, unsigned long shares);
-
-/*
- * Calculate and set the cpu's group shares.
- */
-static void update_group_shares_cpu(struct task_group *tg, int cpu,
-				    unsigned long sd_shares,
-				    unsigned long sd_rq_weight,
-				    unsigned long *usd_rq_weight)
-{
-	unsigned long shares, rq_weight;
-	int boost = 0;
-
-	rq_weight = usd_rq_weight[cpu];
-	if (!rq_weight) {
-		boost = 1;
-		rq_weight = NICE_0_LOAD;
-	}
-
-	/*
-	 *             \Sum_j shares_j * rq_weight_i
-	 * shares_i =  -----------------------------
-	 *                  \Sum_j rq_weight_j
-	 */
-	shares = (sd_shares * rq_weight) / sd_rq_weight;
-	shares = clamp_t(unsigned long, shares, MIN_SHARES, MAX_SHARES);
-
-	if (abs(shares - tg->se[cpu]->load.weight) >
-			sysctl_sched_shares_thresh) {
-		struct rq *rq = cpu_rq(cpu);
-		unsigned long flags;
-
-		raw_spin_lock_irqsave(&rq->lock, flags);
-		tg->cfs_rq[cpu]->rq_weight = boost ? 0 : rq_weight;
-		tg->cfs_rq[cpu]->shares = boost ? 0 : shares;
-		__set_se_shares(tg->se[cpu], shares);
-		raw_spin_unlock_irqrestore(&rq->lock, flags);
-	}
-}
-
-/*
- * Re-compute the task group their per cpu shares over the given domain.
- * This needs to be done in a bottom-up fashion because the rq weight of a
- * parent group depends on the shares of its child groups.
- */
-static int tg_shares_up(struct task_group *tg, void *data)
-{
-	unsigned long weight, rq_weight = 0, sum_weight = 0, shares = 0;
-	unsigned long *usd_rq_weight;
-	struct sched_domain *sd = data;
-	unsigned long flags;
-	int i;
-
-	if (!tg->se[0])
-		return 0;
-
-	local_irq_save(flags);
-	usd_rq_weight = per_cpu_ptr(update_shares_data, smp_processor_id());
-
-	for_each_cpu(i, sched_domain_span(sd)) {
-		weight = tg->cfs_rq[i]->load.weight;
-		usd_rq_weight[i] = weight;
-
-		rq_weight += weight;
-		/*
-		 * If there are currently no tasks on the cpu pretend there
-		 * is one of average load so that when a new task gets to
-		 * run here it will not get delayed by group starvation.
-		 */
-		if (!weight)
-			weight = NICE_0_LOAD;
-
-		sum_weight += weight;
-		shares += tg->cfs_rq[i]->shares;
-	}
-
-	if (!rq_weight)
-		rq_weight = sum_weight;
-
-	if ((!shares && rq_weight) || shares > tg->shares)
-		shares = tg->shares;
-
-	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
-		shares = tg->shares;
-
-	for_each_cpu(i, sched_domain_span(sd))
-		update_group_shares_cpu(tg, i, shares, rq_weight, usd_rq_weight);
-
-	local_irq_restore(flags);
-
-	return 0;
-}
-
 /*
  * Compute the cpu's hierarchical load factor for each task group.
  * This needs to be done in a top-down fashion because the load of a child
@@ -1652,7 +1555,7 @@ static int tg_load_down(struct task_group *tg, void *data)
 		load = cpu_rq(cpu)->load.weight;
 	} else {
 		load = tg->parent->cfs_rq[cpu]->h_load;
-		load *= tg->cfs_rq[cpu]->shares;
+		load *= tg->se[cpu]->load.weight;
 		load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
 	}
 
@@ -1661,34 +1564,11 @@ static int tg_load_down(struct task_group *tg, void *data)
 	return 0;
 }
 
-static void update_shares(struct sched_domain *sd)
-{
-	s64 elapsed;
-	u64 now;
-
-	if (root_task_group_empty())
-		return;
-
-	now = local_clock();
-	elapsed = now - sd->last_update;
-
-	if (elapsed >= (s64)(u64)sysctl_sched_shares_ratelimit) {
-		sd->last_update = now;
-		walk_tg_tree(tg_nop, tg_shares_up, sd);
-	}
-}
-
 static void update_h_load(long cpu)
 {
 	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
 }
 
-#else
-
-static inline void update_shares(struct sched_domain *sd)
-{
-}
-
 #endif
 
 #ifdef CONFIG_PREEMPT
@@ -1810,15 +1690,6 @@ static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
 
 #endif
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
-{
-#ifdef CONFIG_SMP
-	cfs_rq->shares = shares;
-#endif
-}
-#endif
-
 static void calc_load_account_idle(struct rq *this_rq);
 static void update_sysctl(void);
 static int get_update_sysctl_factor(void);
@@ -2063,6 +1934,7 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
+#include "sched_autogroup.c"
 #include "sched_stoptask.c"
 #ifdef CONFIG_SCHED_DEBUG
 # include "sched_debug.c"
@@ -2255,10 +2127,8 @@ static int migration_cpu_stop(void *data);
  * The task's runqueue lock must be held.
  * Returns true if you have to wait for migration thread.
  */
-static bool migrate_task(struct task_struct *p, int dest_cpu)
+static bool migrate_task(struct task_struct *p, struct rq *rq)
 {
-	struct rq *rq = task_rq(p);
-
 	/*
 	 * If the task is not on a runqueue (and not running), then
 	 * the next wake-up will properly place the task.
@@ -2438,18 +2308,15 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 		return dest_cpu;
 
 	/* No more Mr. Nice Guy. */
-	if (unlikely(dest_cpu >= nr_cpu_ids)) {
-		dest_cpu = cpuset_cpus_allowed_fallback(p);
-		/*
-		 * Don't tell them about moving exiting tasks or
-		 * kernel threads (both mm NULL), since they never
-		 * leave kernel.
-		 */
-		if (p->mm && printk_ratelimit()) {
-			printk(KERN_INFO "process %d (%s) no "
-			       "longer affine to cpu%d\n",
-			       task_pid_nr(p), p->comm, cpu);
-		}
+	dest_cpu = cpuset_cpus_allowed_fallback(p);
+	/*
+	 * Don't tell them about moving exiting tasks or
+	 * kernel threads (both mm NULL), since they never
+	 * leave kernel.
+	 */
+	if (p->mm && printk_ratelimit()) {
+		printk(KERN_INFO "process %d (%s) no longer affine to cpu%d\n",
+				task_pid_nr(p), p->comm, cpu);
 	}
 
 	return dest_cpu;
@@ -2785,7 +2652,9 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	/* Want to start with kernel preemption disabled. */
 	task_thread_info(p)->preempt_count = 1;
 #endif
+#ifdef CONFIG_SMP
 	plist_node_init(&p->pushable_tasks, MAX_PRIO);
+#endif
 
 	put_cpu();
 }
@@ -3549,7 +3418,7 @@ void sched_exec(void)
 	 * select_task_rq() can race against ->cpus_allowed
 	 */
 	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
-	    likely(cpu_active(dest_cpu)) && migrate_task(p, dest_cpu)) {
+	    likely(cpu_active(dest_cpu)) && migrate_task(p, rq)) {
 		struct migration_arg arg = { p, dest_cpu };
 
 		task_rq_unlock(rq, &flags);
@@ -4214,7 +4083,7 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 		if (task_thread_info(rq->curr) != owner || need_resched())
 			return 0;
 
-		cpu_relax();
+		arch_mutex_cpu_relax();
 	}
 
 	return 1;
@@ -4526,7 +4395,7 @@ EXPORT_SYMBOL(wait_for_completion_interruptible);
  * This waits for either a completion of a specific task to be signaled or for a
  * specified timeout to expire. It is interruptible. The timeout is in jiffies.
  */
-unsigned long __sched
+long __sched
 wait_for_completion_interruptible_timeout(struct completion *x,
 					  unsigned long timeout)
 {
@@ -4559,7 +4428,7 @@ EXPORT_SYMBOL(wait_for_completion_killable);
  * signaled or for a specified timeout to expire. It can be
  * interrupted by a kill signal. The timeout is in jiffies.
  */
-unsigned long __sched
+long __sched
 wait_for_completion_killable_timeout(struct completion *x,
 				     unsigned long timeout)
 {
@@ -4901,7 +4770,7 @@ static bool check_same_owner(struct task_struct *p)
 }
 
 static int __sched_setscheduler(struct task_struct *p, int policy,
-				struct sched_param *param, bool user)
+				const struct sched_param *param, bool user)
 {
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
 	unsigned long flags;
@@ -5056,7 +4925,7 @@ recheck:
  * NOTE that the task may be already dead.
  */
 int sched_setscheduler(struct task_struct *p, int policy,
-		       struct sched_param *param)
+		       const struct sched_param *param)
 {
 	return __sched_setscheduler(p, policy, param, true);
 }
@@ -5074,7 +4943,7 @@ EXPORT_SYMBOL_GPL(sched_setscheduler);
  * but our caller might not have that capability.
  */
 int sched_setscheduler_nocheck(struct task_struct *p, int policy,
-			       struct sched_param *param)
+			       const struct sched_param *param)
 {
 	return __sched_setscheduler(p, policy, param, false);
 }
@@ -5590,7 +5459,7 @@ void sched_show_task(struct task_struct *p)
 	unsigned state;
 
 	state = p->state ? __ffs(p->state) + 1 : 0;
-	printk(KERN_INFO "%-13.13s %c", p->comm,
+	printk(KERN_INFO "%-15.15s %c", p->comm,
 		state < sizeof(stat_nam) - 1 ? stat_nam[state] : '?');
 #if BITS_PER_LONG == 32
 	if (state == TASK_RUNNING)
@@ -5754,7 +5623,6 @@ static void update_sysctl(void)
 	SET_SYSCTL(sched_min_granularity);
 	SET_SYSCTL(sched_latency);
 	SET_SYSCTL(sched_wakeup_granularity);
-	SET_SYSCTL(sched_shares_ratelimit);
 #undef SET_SYSCTL
 }
 
@@ -5830,7 +5698,7 @@ again:
 		goto out;
 
 	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
-	if (migrate_task(p, dest_cpu)) {
+	if (migrate_task(p, rq)) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, &flags);
@@ -5912,29 +5780,20 @@ static int migration_cpu_stop(void *data)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
+
 /*
- * Figure out where task on dead CPU should go, use force if necessary.
+ * Ensures that the idle task is using init_mm right before its cpu goes
+ * offline.
  */
-void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
+void idle_task_exit(void)
 {
-	struct rq *rq = cpu_rq(dead_cpu);
-	int needs_cpu, uninitialized_var(dest_cpu);
-	unsigned long flags;
+	struct mm_struct *mm = current->active_mm;
 
-	local_irq_save(flags);
+	BUG_ON(cpu_online(smp_processor_id()));
 
-	raw_spin_lock(&rq->lock);
-	needs_cpu = (task_cpu(p) == dead_cpu) && (p->state != TASK_WAKING);
-	if (needs_cpu)
-		dest_cpu = select_fallback_rq(dead_cpu, p);
-	raw_spin_unlock(&rq->lock);
-	/*
-	 * It can only fail if we race with set_cpus_allowed(),
-	 * in the racer should migrate the task anyway.
-	 */
-	if (needs_cpu)
-		__migrate_task(p, dead_cpu, dest_cpu);
-	local_irq_restore(flags);
+	if (mm != &init_mm)
+		switch_mm(mm, &init_mm, current);
+	mmdrop(mm);
 }
 
 /*
@@ -5947,128 +5806,69 @@ void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 static void migrate_nr_uninterruptible(struct rq *rq_src)
 {
 	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
-	unsigned long flags;
 
-	local_irq_save(flags);
-	double_rq_lock(rq_src, rq_dest);
 	rq_dest->nr_uninterruptible += rq_src->nr_uninterruptible;
 	rq_src->nr_uninterruptible = 0;
-	double_rq_unlock(rq_src, rq_dest);
-	local_irq_restore(flags);
-}
-
-/* Run through task list and migrate tasks from the dead cpu. */
-static void migrate_live_tasks(int src_cpu)
-{
-	struct task_struct *p, *t;
-
-	read_lock(&tasklist_lock);
-
-	do_each_thread(t, p) {
-		if (p == current)
-			continue;
-
-		if (task_cpu(p) == src_cpu)
-			move_task_off_dead_cpu(src_cpu, p);
-	} while_each_thread(t, p);
-
-	read_unlock(&tasklist_lock);
 }
 
 /*
- * Schedules idle task to be the next runnable task on current CPU.
- * It does so by boosting its priority to highest possible.
- * Used by CPU offline code.
+ * remove the tasks which were accounted by rq from calc_load_tasks.
  */
-void sched_idle_next(void)
+static void calc_global_load_remove(struct rq *rq)
 {
-	int this_cpu = smp_processor_id();
-	struct rq *rq = cpu_rq(this_cpu);
-	struct task_struct *p = rq->idle;
-	unsigned long flags;
-
-	/* cpu has to be offline */
-	BUG_ON(cpu_online(this_cpu));
-
-	/*
-	 * Strictly not necessary since rest of the CPUs are stopped by now
-	 * and interrupts disabled on the current cpu.
-	 */
-	raw_spin_lock_irqsave(&rq->lock, flags);
-
-	__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
-
-	activate_task(rq, p, 0);
-
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	atomic_long_sub(rq->calc_load_active, &calc_load_tasks);
+	rq->calc_load_active = 0;
 }
 
 /*
- * Ensures that the idle task is using init_mm right before its cpu goes
- * offline.
+ * Migrate all tasks from the rq, sleeping tasks will be migrated by
+ * try_to_wake_up()->select_task_rq().
+ *
+ * Called with rq->lock held even though we'er in stop_machine() and
+ * there's no concurrency possible, we hold the required locks anyway
+ * because of lock validation efforts.
  */
-void idle_task_exit(void)
-{
-	struct mm_struct *mm = current->active_mm;
-
-	BUG_ON(cpu_online(smp_processor_id()));
-
-	if (mm != &init_mm)
-		switch_mm(mm, &init_mm, current);
-	mmdrop(mm);
-}
-
-/* called under rq->lock with disabled interrupts */
-static void migrate_dead(unsigned int dead_cpu, struct task_struct *p)
+static void migrate_tasks(unsigned int dead_cpu)
 {
 	struct rq *rq = cpu_rq(dead_cpu);
-
-	/* Must be exiting, otherwise would be on tasklist. */
-	BUG_ON(!p->exit_state);
-
-	/* Cannot have done final schedule yet: would have vanished. */
-	BUG_ON(p->state == TASK_DEAD);
-
-	get_task_struct(p);
+	struct task_struct *next, *stop = rq->stop;
+	int dest_cpu;
 
 	/*
-	 * Drop lock around migration; if someone else moves it,
-	 * that's OK. No task can be added to this CPU, so iteration is
-	 * fine.
+	 * Fudge the rq selection such that the below task selection loop
+	 * doesn't get stuck on the currently eligible stop task.
+	 *
+	 * We're currently inside stop_machine() and the rq is either stuck
+	 * in the stop_machine_cpu_stop() loop, or we're executing this code,
+	 * either way we should never end up calling schedule() until we're
+	 * done here.
 	 */
-	raw_spin_unlock_irq(&rq->lock);
-	move_task_off_dead_cpu(dead_cpu, p);
-	raw_spin_lock_irq(&rq->lock);
-
-	put_task_struct(p);
-}
-
-/* release_task() removes task from tasklist, so we won't find dead tasks. */
-static void migrate_dead_tasks(unsigned int dead_cpu)
-{
-	struct rq *rq = cpu_rq(dead_cpu);
-	struct task_struct *next;
+	rq->stop = NULL;
 
 	for ( ; ; ) {
-		if (!rq->nr_running)
+		/*
+		 * There's this thread running, bail when that's the only
+		 * remaining thread.
+		 */
+		if (rq->nr_running == 1)
 			break;
+
 		next = pick_next_task(rq);
-		if (!next)
-			break;
+		BUG_ON(!next);
 		next->sched_class->put_prev_task(rq, next);
-		migrate_dead(dead_cpu, next);
 
+		/* Find suitable destination for @next, with force if needed. */
+		dest_cpu = select_fallback_rq(dead_cpu, next);
+		raw_spin_unlock(&rq->lock);
+
+		__migrate_task(next, dead_cpu, dest_cpu);
+
+		raw_spin_lock(&rq->lock);
 	}
-}
 
-/*
- * remove the tasks which were accounted by rq from calc_load_tasks.
- */
-static void calc_global_load_remove(struct rq *rq)
-{
-	atomic_long_sub(rq->calc_load_active, &calc_load_tasks);
-	rq->calc_load_active = 0;
+	rq->stop = stop;
 }
+
 #endif /* CONFIG_HOTPLUG_CPU */
 
 #if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_SYSCTL)
@@ -6278,15 +6078,13 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	unsigned long flags;
 	struct rq *rq = cpu_rq(cpu);
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		rq->calc_load_update = calc_load_update;
 		break;
 
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		/* Update our root-domain */
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
@@ -6298,30 +6096,19 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		migrate_live_tasks(cpu);
-		/* Idle task back to normal (off runqueue, low prio) */
-		raw_spin_lock_irq(&rq->lock);
-		deactivate_task(rq, rq->idle, 0);
-		__setscheduler(rq, rq->idle, SCHED_NORMAL, 0);
-		rq->idle->sched_class = &idle_sched_class;
-		migrate_dead_tasks(cpu);
-		raw_spin_unlock_irq(&rq->lock);
-		migrate_nr_uninterruptible(rq);
-		BUG_ON(rq->nr_running != 0);
-		calc_global_load_remove(rq);
-		break;
-
 	case CPU_DYING:
-	case CPU_DYING_FROZEN:
 		/* Update our root-domain */
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
 			set_rq_offline(rq);
 		}
+		migrate_tasks(cpu);
+		BUG_ON(rq->nr_running != 1); /* the migration thread */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
+
+		migrate_nr_uninterruptible(rq);
+		calc_global_load_remove(rq);
 		break;
 #endif
 	}
@@ -8052,15 +7839,13 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
-				struct sched_entity *se, int cpu, int add,
+				struct sched_entity *se, int cpu,
 				struct sched_entity *parent)
 {
 	struct rq *rq = cpu_rq(cpu);
 	tg->cfs_rq[cpu] = cfs_rq;
 	init_cfs_rq(cfs_rq, rq);
 	cfs_rq->tg = tg;
-	if (add)
-		list_add(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
 
 	tg->se[cpu] = se;
 	/* se could be NULL for init_task_group */
@@ -8073,15 +7858,14 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 		se->cfs_rq = parent->my_q;
 
 	se->my_q = cfs_rq;
-	se->load.weight = tg->shares;
-	se->load.inv_weight = 0;
+	update_load_set(&se->load, 0);
 	se->parent = parent;
 }
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
-		struct sched_rt_entity *rt_se, int cpu, int add,
+		struct sched_rt_entity *rt_se, int cpu,
 		struct sched_rt_entity *parent)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -8090,8 +7874,6 @@ static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 	init_rt_rq(rt_rq, rq);
 	rt_rq->tg = tg;
 	rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
-	if (add)
-		list_add(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
 
 	tg->rt_se[cpu] = rt_se;
 	if (!rt_se)
@@ -8164,13 +7946,9 @@ void __init sched_init(void)
 #ifdef CONFIG_CGROUP_SCHED
 	list_add(&init_task_group.list, &task_groups);
 	INIT_LIST_HEAD(&init_task_group.children);
-
+	autogroup_init(&init_task);
 #endif /* CONFIG_CGROUP_SCHED */
 
-#if defined CONFIG_FAIR_GROUP_SCHED && defined CONFIG_SMP
-	update_shares_data = __alloc_percpu(nr_cpu_ids * sizeof(unsigned long),
-					    __alignof__(unsigned long));
-#endif
 	for_each_possible_cpu(i) {
 		struct rq *rq;
 
@@ -8184,7 +7962,6 @@ void __init sched_init(void)
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.shares = init_task_group_load;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
-#ifdef CONFIG_CGROUP_SCHED
 		/*
 		 * How much cpu bandwidth does init_task_group get?
 		 *
@@ -8204,16 +7981,13 @@ void __init sched_init(void)
 		 * We achieve this by letting init_task_group's tasks sit
 		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
 		 */
-		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, 1, NULL);
-#endif
+		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, NULL);
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 		rq->rt.rt_runtime = def_rt_bandwidth.rt_runtime;
 #ifdef CONFIG_RT_GROUP_SCHED
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
-#ifdef CONFIG_CGROUP_SCHED
-		init_tg_rt_entry(&init_task_group, &rq->rt, NULL, i, 1, NULL);
-#endif
+		init_tg_rt_entry(&init_task_group, &rq->rt, NULL, i, NULL);
 #endif
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
@@ -8488,7 +8262,7 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 		if (!se)
 			goto err_free_rq;
 
-		init_tg_cfs_entry(tg, cfs_rq, se, i, 0, parent->se[i]);
+		init_tg_cfs_entry(tg, cfs_rq, se, i, parent->se[i]);
 	}
 
 	return 1;
@@ -8499,15 +8273,21 @@ err:
 	return 0;
 }
 
-static inline void register_fair_sched_group(struct task_group *tg, int cpu)
-{
-	list_add_rcu(&tg->cfs_rq[cpu]->leaf_cfs_rq_list,
-			&cpu_rq(cpu)->leaf_cfs_rq_list);
-}
-
 static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
 {
-	list_del_rcu(&tg->cfs_rq[cpu]->leaf_cfs_rq_list);
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+
+	/*
+	* Only empty task groups can be destroyed; so we can speculatively
+	* check on_list without danger of it being re-added.
+	*/
+	if (!tg->cfs_rq[cpu]->on_list)
+		return;
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	list_del_leaf_cfs_rq(tg->cfs_rq[cpu]);
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 #else /* !CONFG_FAIR_GROUP_SCHED */
 static inline void free_fair_sched_group(struct task_group *tg)
@@ -8520,10 +8300,6 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 	return 1;
 }
 
-static inline void register_fair_sched_group(struct task_group *tg, int cpu)
-{
-}
-
 static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
 {
 }
@@ -8578,7 +8354,7 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 		if (!rt_se)
 			goto err_free_rq;
 
-		init_tg_rt_entry(tg, rt_rq, rt_se, i, 0, parent->rt_se[i]);
+		init_tg_rt_entry(tg, rt_rq, rt_se, i, parent->rt_se[i]);
 	}
 
 	return 1;
@@ -8588,17 +8364,6 @@ err_free_rq:
 err:
 	return 0;
 }
-
-static inline void register_rt_sched_group(struct task_group *tg, int cpu)
-{
-	list_add_rcu(&tg->rt_rq[cpu]->leaf_rt_rq_list,
-			&cpu_rq(cpu)->leaf_rt_rq_list);
-}
-
-static inline void unregister_rt_sched_group(struct task_group *tg, int cpu)
-{
-	list_del_rcu(&tg->rt_rq[cpu]->leaf_rt_rq_list);
-}
 #else /* !CONFIG_RT_GROUP_SCHED */
 static inline void free_rt_sched_group(struct task_group *tg)
 {
@@ -8609,14 +8374,6 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	return 1;
 }
-
-static inline void register_rt_sched_group(struct task_group *tg, int cpu)
-{
-}
-
-static inline void unregister_rt_sched_group(struct task_group *tg, int cpu)
-{
-}
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_CGROUP_SCHED
@@ -8632,7 +8389,6 @@ struct task_group *sched_create_group(struct task_group *parent)
 {
 	struct task_group *tg;
 	unsigned long flags;
-	int i;
 
 	tg = kzalloc(sizeof(*tg), GFP_KERNEL);
 	if (!tg)
@@ -8645,10 +8401,6 @@ struct task_group *sched_create_group(struct task_group *parent)
 		goto err;
 
 	spin_lock_irqsave(&task_group_lock, flags);
-	for_each_possible_cpu(i) {
-		register_fair_sched_group(tg, i);
-		register_rt_sched_group(tg, i);
-	}
 	list_add_rcu(&tg->list, &task_groups);
 
 	WARN_ON(!parent); /* root should already exist */
@@ -8678,11 +8430,11 @@ void sched_destroy_group(struct task_group *tg)
 	unsigned long flags;
 	int i;
 
-	spin_lock_irqsave(&task_group_lock, flags);
-	for_each_possible_cpu(i) {
+	/* end participation in shares distribution */
+	for_each_possible_cpu(i)
 		unregister_fair_sched_group(tg, i);
-		unregister_rt_sched_group(tg, i);
-	}
+
+	spin_lock_irqsave(&task_group_lock, flags);
 	list_del_rcu(&tg->list);
 	list_del_rcu(&tg->siblings);
 	spin_unlock_irqrestore(&task_group_lock, flags);
@@ -8729,33 +8481,6 @@ void sched_move_task(struct task_struct *tsk)
 #endif /* CONFIG_CGROUP_SCHED */
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void __set_se_shares(struct sched_entity *se, unsigned long shares)
-{
-	struct cfs_rq *cfs_rq = se->cfs_rq;
-	int on_rq;
-
-	on_rq = se->on_rq;
-	if (on_rq)
-		dequeue_entity(cfs_rq, se, 0);
-
-	se->load.weight = shares;
-	se->load.inv_weight = 0;
-
-	if (on_rq)
-		enqueue_entity(cfs_rq, se, 0);
-}
-
-static void set_se_shares(struct sched_entity *se, unsigned long shares)
-{
-	struct cfs_rq *cfs_rq = se->cfs_rq;
-	struct rq *rq = cfs_rq->rq;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	__set_se_shares(se, shares);
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-}
-
 static DEFINE_MUTEX(shares_mutex);
 
 int sched_group_set_shares(struct task_group *tg, unsigned long shares)
@@ -8778,37 +8503,19 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 	if (tg->shares == shares)
 		goto done;
 
-	spin_lock_irqsave(&task_group_lock, flags);
-	for_each_possible_cpu(i)
-		unregister_fair_sched_group(tg, i);
-	list_del_rcu(&tg->siblings);
-	spin_unlock_irqrestore(&task_group_lock, flags);
-
-	/* wait for any ongoing reference to this group to finish */
-	synchronize_sched();
-
-	/*
-	 * Now we are free to modify the group's share on each cpu
-	 * w/o tripping rebalance_share or load_balance_fair.
-	 */
 	tg->shares = shares;
 	for_each_possible_cpu(i) {
-		/*
-		 * force a rebalance
-		 */
-		cfs_rq_set_shares(tg->cfs_rq[i], 0);
-		set_se_shares(tg->se[i], shares);
+		struct rq *rq = cpu_rq(i);
+		struct sched_entity *se;
+
+		se = tg->se[i];
+		/* Propagate contribution to hierarchy */
+		raw_spin_lock_irqsave(&rq->lock, flags);
+		for_each_sched_entity(se)
+			update_cfs_shares(group_cfs_rq(se), 0);
+		raw_spin_unlock_irqrestore(&rq->lock, flags);
 	}
 
-	/*
-	 * Enable load balance activity on this group, by inserting it back on
-	 * each cpu's rq->leaf_cfs_rq_list.
-	 */
-	spin_lock_irqsave(&task_group_lock, flags);
-	for_each_possible_cpu(i)
-		register_fair_sched_group(tg, i);
-	list_add_rcu(&tg->siblings, &tg->parent->children);
-	spin_unlock_irqrestore(&task_group_lock, flags);
 done:
 	mutex_unlock(&shares_mutex);
 	return 0;
diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
new file mode 100644
index 0000000..c80fedc
--- /dev/null
+++ b/kernel/sched_autogroup.c
@@ -0,0 +1,238 @@
+#ifdef CONFIG_SCHED_AUTOGROUP
+
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/kallsyms.h>
+#include <linux/utsname.h>
+
+unsigned int __read_mostly sysctl_sched_autogroup_enabled = 1;
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
+static inline void autogroup_free(struct task_group *tg)
+{
+	kfree(tg->autogroup);
+}
+
+static inline void autogroup_destroy(struct kref *kref)
+{
+	struct autogroup *ag = container_of(kref, struct autogroup, kref);
+
+	sched_destroy_group(ag->tg);
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
+static inline struct autogroup *autogroup_task_get(struct task_struct *p)
+{
+	struct autogroup *ag;
+	unsigned long flags;
+
+	if (!lock_task_sighand(p, &flags))
+		return autogroup_kref_get(&autogroup_default);
+
+	ag = autogroup_kref_get(p->signal->autogroup);
+	unlock_task_sighand(p, &flags);
+
+	return ag;
+}
+
+static inline struct autogroup *autogroup_create(void)
+{
+	struct autogroup *ag = kzalloc(sizeof(*ag), GFP_KERNEL);
+	struct task_group *tg;
+
+	if (!ag)
+		goto out_fail;
+
+	tg = sched_create_group(&init_task_group);
+
+	if (IS_ERR(tg))
+		goto out_free;
+
+	kref_init(&ag->kref);
+	init_rwsem(&ag->lock);
+	ag->id = atomic_inc_return(&autogroup_seq_nr);
+	ag->tg = tg;
+	tg->autogroup = ag;
+
+	return ag;
+
+out_free:
+	kfree(ag);
+out_fail:
+	if (printk_ratelimit()) {
+		printk(KERN_WARNING "autogroup_create: %s failure.\n",
+			ag ? "sched_create_group()" : "kmalloc()");
+	}
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
+	unsigned long flags;
+
+	BUG_ON(!lock_task_sighand(p, &flags));
+
+	prev = p->signal->autogroup;
+	if (prev == ag) {
+		unlock_task_sighand(p, &flags);
+		return;
+	}
+
+	p->signal->autogroup = autogroup_kref_get(ag);
+
+	t = p;
+	do {
+		sched_move_task(t);
+	} while_each_thread(p, t);
+
+	unlock_task_sighand(p, &flags);
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
+	sig->autogroup = autogroup_task_get(current);
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
+	next = HZ / 10 + jiffies;
+	ag = autogroup_task_get(p);
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
+	struct autogroup *ag = autogroup_task_get(p);
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
index 0000000..5358e24
--- /dev/null
+++ b/kernel/sched_autogroup.h
@@ -0,0 +1,32 @@
+#ifdef CONFIG_SCHED_AUTOGROUP
+
+struct autogroup {
+	struct kref		kref;
+	struct task_group	*tg;
+	struct rw_semaphore	lock;
+	unsigned long		id;
+	int			nice;
+};
+
+static inline struct task_group *
+autogroup_task_group(struct task_struct *p, struct task_group *tg);
+
+#else /* !CONFIG_SCHED_AUTOGROUP */
+
+static inline void autogroup_init(struct task_struct *init_task) {  }
+static inline void autogroup_free(struct task_group *tg) { }
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
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 52f1a14..9d8af0b 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -79,7 +79,7 @@ unsigned long long __attribute__((weak)) sched_clock(void)
 }
 EXPORT_SYMBOL_GPL(sched_clock);
 
-static __read_mostly int sched_clock_running;
+__read_mostly int sched_clock_running;
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 __read_mostly int sched_clock_stable;
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 2e1b0d1..1dfae3d 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -54,8 +54,7 @@ static unsigned long nsec_low(unsigned long long nsec)
 #define SPLIT_NS(x) nsec_high(x), nsec_low(x)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void print_cfs_group_stats(struct seq_file *m, int cpu,
-		struct task_group *tg)
+static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group *tg)
 {
 	struct sched_entity *se = tg->se[cpu];
 	if (!se)
@@ -110,16 +109,6 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 		0LL, 0LL, 0LL, 0L, 0LL, 0L, 0LL, 0L);
 #endif
 
-#ifdef CONFIG_CGROUP_SCHED
-	{
-		char path[64];
-
-		rcu_read_lock();
-		cgroup_path(task_group(p)->css.cgroup, path, sizeof(path));
-		rcu_read_unlock();
-		SEQ_printf(m, " %s", path);
-	}
-#endif
 	SEQ_printf(m, "\n");
 }
 
@@ -147,19 +136,6 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
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
@@ -168,16 +144,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	struct sched_entity *last;
 	unsigned long flags;
 
-#if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
-	char path[128];
-	struct task_group *tg = cfs_rq->tg;
-
-	task_group_path(tg, path, sizeof(path));
-
-	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
-#else
 	SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
-#endif
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "exec_clock",
 			SPLIT_NS(cfs_rq->exec_clock));
 
@@ -202,32 +169,29 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	spread0 = min_vruntime - rq0_min_vruntime;
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread0",
 			SPLIT_NS(spread0));
-	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
-	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
-
 	SEQ_printf(m, "  .%-30s: %d\n", "nr_spread_over",
 			cfs_rq->nr_spread_over);
+	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
+	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
-	SEQ_printf(m, "  .%-30s: %lu\n", "shares", cfs_rq->shares);
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "load_avg",
+			SPLIT_NS(cfs_rq->load_avg));
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "load_period",
+			SPLIT_NS(cfs_rq->load_period));
+	SEQ_printf(m, "  .%-30s: %ld\n", "load_contrib",
+			cfs_rq->load_contribution);
+	SEQ_printf(m, "  .%-30s: %d\n", "load_tg",
+			atomic_read(&cfs_rq->tg->load_weight));
 #endif
+
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
 #endif
 }
 
 void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 {
-#if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_RT_GROUP_SCHED)
-	char path[128];
-	struct task_group *tg = rt_rq->tg;
-
-	task_group_path(tg, path, sizeof(path));
-
-	SEQ_printf(m, "\nrt_rq[%d]:%s\n", cpu, path);
-#else
 	SEQ_printf(m, "\nrt_rq[%d]:\n", cpu);
-#endif
-
 
 #define P(x) \
 	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rt_rq->x))
@@ -243,6 +207,8 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 #undef P
 }
 
+extern __read_mostly int sched_clock_running;
+
 static void print_cpu(struct seq_file *m, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -314,21 +280,42 @@ static const char *sched_tunable_scaling_names[] = {
 
 static int sched_debug_show(struct seq_file *m, void *v)
 {
-	u64 now = ktime_to_ns(ktime_get());
+	u64 ktime, sched_clk, cpu_clk;
+	unsigned long flags;
 	int cpu;
 
-	SEQ_printf(m, "Sched Debug Version: v0.09, %s %.*s\n",
+	local_irq_save(flags);
+	ktime = ktime_to_ns(ktime_get());
+	sched_clk = sched_clock();
+	cpu_clk = local_clock();
+	local_irq_restore(flags);
+
+	SEQ_printf(m, "Sched Debug Version: v0.10, %s %.*s\n",
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
 
-	SEQ_printf(m, "now at %Lu.%06ld msecs\n", SPLIT_NS(now));
+#define P(x) \
+	SEQ_printf(m, "%-40s: %Ld\n", #x, (long long)(x))
+#define PN(x) \
+	SEQ_printf(m, "%-40s: %Ld.%06ld\n", #x, SPLIT_NS(x))
+	PN(ktime);
+	PN(sched_clk);
+	PN(cpu_clk);
+	P(jiffies);
+#ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
+	P(sched_clock_stable);
+#endif
+#undef PN
+#undef P
+
+	SEQ_printf(m, "\n");
+	SEQ_printf(m, "sysctl_sched\n");
 
 #define P(x) \
 	SEQ_printf(m, "  .%-40s: %Ld\n", #x, (long long)(x))
 #define PN(x) \
 	SEQ_printf(m, "  .%-40s: %Ld.%06ld\n", #x, SPLIT_NS(x))
-	P(jiffies);
 	PN(sysctl_sched_latency);
 	PN(sysctl_sched_min_granularity);
 	PN(sysctl_sched_wakeup_granularity);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 00ebd76..c62ebae 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -89,6 +89,13 @@ unsigned int normalized_sysctl_sched_wakeup_granularity = 1000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
+/*
+ * The exponential sliding  window over which load is averaged for shares
+ * distribution.
+ * (default: 10msec)
+ */
+unsigned int __read_mostly sysctl_sched_shares_window = 10000000UL;
+
 static const struct sched_class fair_sched_class;
 
 /**************************************************************
@@ -143,6 +150,36 @@ static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
 	return cfs_rq->tg->cfs_rq[this_cpu];
 }
 
+static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	if (!cfs_rq->on_list) {
+		/*
+		 * Ensure we either appear before our parent (if already
+		 * enqueued) or force our parent to appear after us when it is
+		 * enqueued.  The fact that we always enqueue bottom-up
+		 * reduces this to two cases.
+		 */
+		if (cfs_rq->tg->parent &&
+		    cfs_rq->tg->parent->cfs_rq[cpu_of(rq_of(cfs_rq))]->on_list) {
+			list_add_rcu(&cfs_rq->leaf_cfs_rq_list,
+				&rq_of(cfs_rq)->leaf_cfs_rq_list);
+		} else {
+			list_add_tail_rcu(&cfs_rq->leaf_cfs_rq_list,
+				&rq_of(cfs_rq)->leaf_cfs_rq_list);
+		}
+
+		cfs_rq->on_list = 1;
+	}
+}
+
+static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+{
+	if (cfs_rq->on_list) {
+		list_del_rcu(&cfs_rq->leaf_cfs_rq_list);
+		cfs_rq->on_list = 0;
+	}
+}
+
 /* Iterate thr' all leaf cfs_rq's on a runqueue */
 #define for_each_leaf_cfs_rq(rq, cfs_rq) \
 	list_for_each_entry_rcu(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
@@ -246,6 +283,14 @@ static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
 	return &cpu_rq(this_cpu)->cfs;
 }
 
+static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+{
+}
+
+static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+{
+}
+
 #define for_each_leaf_cfs_rq(rq, cfs_rq) \
 		for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)
 
@@ -417,7 +462,6 @@ int sched_proc_update_handler(struct ctl_table *table, int write,
 	WRT_SYSCTL(sched_min_granularity);
 	WRT_SYSCTL(sched_latency);
 	WRT_SYSCTL(sched_wakeup_granularity);
-	WRT_SYSCTL(sched_shares_ratelimit);
 #undef WRT_SYSCTL
 
 	return 0;
@@ -495,6 +539,9 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
+static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update);
+static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta);
+
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -514,6 +561,10 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 
 	curr->vruntime += delta_exec_weighted;
 	update_min_vruntime(cfs_rq);
+
+#if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
+	cfs_rq->load_unacc_exec_time += delta_exec;
+#endif
 }
 
 static void update_curr(struct cfs_rq *cfs_rq)
@@ -633,7 +684,6 @@ account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		list_add(&se->group_node, &cfs_rq->tasks);
 	}
 	cfs_rq->nr_running++;
-	se->on_rq = 1;
 }
 
 static void
@@ -647,9 +697,140 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		list_del_init(&se->group_node);
 	}
 	cfs_rq->nr_running--;
-	se->on_rq = 0;
 }
 
+#if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
+static void update_cfs_rq_load_contribution(struct cfs_rq *cfs_rq,
+					    int global_update)
+{
+	struct task_group *tg = cfs_rq->tg;
+	long load_avg;
+
+	load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
+	load_avg -= cfs_rq->load_contribution;
+
+	if (global_update || abs(load_avg) > cfs_rq->load_contribution / 8) {
+		atomic_add(load_avg, &tg->load_weight);
+		cfs_rq->load_contribution += load_avg;
+	}
+}
+
+static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
+{
+	u64 period = sysctl_sched_shares_window;
+	u64 now, delta;
+	unsigned long load = cfs_rq->load.weight;
+
+	if (!cfs_rq)
+		return;
+
+	now = rq_of(cfs_rq)->clock;
+	delta = now - cfs_rq->load_stamp;
+
+	/* truncate load history at 4 idle periods */
+	if (cfs_rq->load_stamp > cfs_rq->load_last &&
+	    now - cfs_rq->load_last > 4 * period) {
+		cfs_rq->load_period = 0;
+		cfs_rq->load_avg = 0;
+	}
+
+	cfs_rq->load_stamp = now;
+	cfs_rq->load_unacc_exec_time = 0;
+	cfs_rq->load_period += delta;
+	if (load) {
+		cfs_rq->load_last = now;
+		cfs_rq->load_avg += delta * load;
+	}
+
+	/* consider updating load contribution on each fold or truncate */
+	if (global_update || cfs_rq->load_period > period
+	    || !cfs_rq->load_period)
+		update_cfs_rq_load_contribution(cfs_rq, global_update);
+
+	while (cfs_rq->load_period > period) {
+		/*
+		 * Inline assembly required to prevent the compiler
+		 * optimising this loop into a divmod call.
+		 * See __iter_div_u64_rem() for another example of this.
+		 */
+		asm("" : "+rm" (cfs_rq->load_period));
+		cfs_rq->load_period /= 2;
+		cfs_rq->load_avg /= 2;
+	}
+
+	if (!cfs_rq->curr && !cfs_rq->nr_running && !cfs_rq->load_avg)
+		list_del_leaf_cfs_rq(cfs_rq);
+}
+
+static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
+			    unsigned long weight)
+{
+	if (se->on_rq) {
+		/* commit outstanding execution time */
+		if (cfs_rq->curr == se)
+			update_curr(cfs_rq);
+		account_entity_dequeue(cfs_rq, se);
+	}
+
+	update_load_set(&se->load, weight);
+
+	if (se->on_rq)
+		account_entity_enqueue(cfs_rq, se);
+}
+
+static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
+{
+	struct task_group *tg;
+	struct sched_entity *se;
+	long load_weight, load, shares;
+
+	if (!cfs_rq)
+		return;
+
+	tg = cfs_rq->tg;
+	se = tg->se[cpu_of(rq_of(cfs_rq))];
+	if (!se)
+		return;
+
+	load = cfs_rq->load.weight + weight_delta;
+
+	load_weight = atomic_read(&tg->load_weight);
+	load_weight -= cfs_rq->load_contribution;
+	load_weight += load;
+
+	shares = (tg->shares * load);
+	if (load_weight)
+		shares /= load_weight;
+
+	if (shares < MIN_SHARES)
+		shares = MIN_SHARES;
+	if (shares > tg->shares)
+		shares = tg->shares;
+
+	reweight_entity(cfs_rq_of(se), se, shares);
+}
+
+static void update_entity_shares_tick(struct cfs_rq *cfs_rq)
+{
+	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
+		update_cfs_load(cfs_rq, 0);
+		update_cfs_shares(cfs_rq, 0);
+	}
+}
+#else /* CONFIG_FAIR_GROUP_SCHED */
+static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
+{
+}
+
+static inline void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
+{
+}
+
+static inline void update_entity_shares_tick(struct cfs_rq *cfs_rq)
+{
+}
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 #ifdef CONFIG_SCHEDSTATS
@@ -771,6 +952,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
+	update_cfs_load(cfs_rq, 0);
+	update_cfs_shares(cfs_rq, se->load.weight);
 	account_entity_enqueue(cfs_rq, se);
 
 	if (flags & ENQUEUE_WAKEUP) {
@@ -782,6 +965,10 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	check_spread(cfs_rq, se);
 	if (se != cfs_rq->curr)
 		__enqueue_entity(cfs_rq, se);
+	se->on_rq = 1;
+
+	if (cfs_rq->nr_running == 1)
+		list_add_leaf_cfs_rq(cfs_rq);
 }
 
 static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -825,8 +1012,11 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
+	se->on_rq = 0;
+	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
 	update_min_vruntime(cfs_rq);
+	update_cfs_shares(cfs_rq, 0);
 
 	/*
 	 * Normalize the entity after updating the min_vruntime because the
@@ -955,6 +1145,11 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	 */
 	update_curr(cfs_rq);
 
+	/*
+	 * Update share accounting for long-running entities.
+	 */
+	update_entity_shares_tick(cfs_rq);
+
 #ifdef CONFIG_SCHED_HRTICK
 	/*
 	 * queued ticks are scheduled to match the slice, so don't bother
@@ -1055,6 +1250,13 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		flags = ENQUEUE_WAKEUP;
 	}
 
+	for_each_sched_entity(se) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+		update_cfs_load(cfs_rq, 0);
+		update_cfs_shares(cfs_rq, 0);
+	}
+
 	hrtick_update(rq);
 }
 
@@ -1071,12 +1273,20 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, flags);
+
 		/* Don't dequeue parent if it has other entities besides us */
 		if (cfs_rq->load.weight)
 			break;
 		flags |= DEQUEUE_SLEEP;
 	}
 
+	for_each_sched_entity(se) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+		update_cfs_load(cfs_rq, 0);
+		update_cfs_shares(cfs_rq, 0);
+	}
+
 	hrtick_update(rq);
 }
 
@@ -1143,51 +1353,20 @@ static void task_waking_fair(struct rq *rq, struct task_struct *p)
  * Adding load to a group doesn't make a group heavier, but can cause movement
  * of group shares between cpus. Assuming the shares were perfectly aligned one
  * can calculate the shift in shares.
- *
- * The problem is that perfectly aligning the shares is rather expensive, hence
- * we try to avoid doing that too often - see update_shares(), which ratelimits
- * this change.
- *
- * We compensate this by not only taking the current delta into account, but
- * also considering the delta between when the shares were last adjusted and
- * now.
- *
- * We still saw a performance dip, some tracing learned us that between
- * cgroup:/ and cgroup:/foo balancing the number of affine wakeups increased
- * significantly. Therefore try to bias the error in direction of failing
- * the affine wakeup.
- *
  */
-static long effective_load(struct task_group *tg, int cpu,
-		long wl, long wg)
+static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 {
 	struct sched_entity *se = tg->se[cpu];
 
 	if (!tg->parent)
 		return wl;
 
-	/*
-	 * By not taking the decrease of shares on the other cpu into
-	 * account our error leans towards reducing the affine wakeups.
-	 */
-	if (!wl && sched_feat(ASYM_EFF_LOAD))
-		return wl;
-
 	for_each_sched_entity(se) {
 		long S, rw, s, a, b;
-		long more_w;
-
-		/*
-		 * Instead of using this increment, also add the difference
-		 * between when the shares were last updated and now.
-		 */
-		more_w = se->my_q->load.weight - se->my_q->rq_weight;
-		wl += more_w;
-		wg += more_w;
 
 		S = se->my_q->tg->shares;
-		s = se->my_q->shares;
-		rw = se->my_q->rq_weight;
+		s = se->load.weight;
+		rw = se->my_q->load.weight;
 
 		a = S*(rw + wl);
 		b = S*rw + s*wg;
@@ -1508,23 +1687,6 @@ select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_
 			sd = tmp;
 	}
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	if (sched_feat(LB_SHARES_UPDATE)) {
-		/*
-		 * Pick the largest domain to update shares over
-		 */
-		tmp = sd;
-		if (affine_sd && (!tmp || affine_sd->span_weight > sd->span_weight))
-			tmp = affine_sd;
-
-		if (tmp) {
-			raw_spin_unlock(&rq->lock);
-			update_shares(tmp);
-			raw_spin_lock(&rq->lock);
-		}
-	}
-#endif
-
 	if (affine_sd) {
 		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
 			return select_idle_sibling(p, cpu);
@@ -1909,6 +2071,48 @@ out:
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+/*
+ * update tg->load_weight by folding this cpu's load_avg
+ */
+static int update_shares_cpu(struct task_group *tg, int cpu)
+{
+	struct cfs_rq *cfs_rq;
+	unsigned long flags;
+	struct rq *rq;
+
+	if (!tg->se[cpu])
+		return 0;
+
+	rq = cpu_rq(cpu);
+	cfs_rq = tg->cfs_rq[cpu];
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
+
+	update_rq_clock(rq);
+	update_cfs_load(cfs_rq, 1);
+
+	/*
+	 * We need to update shares after updating tg->load_weight in
+	 * order to adjust the weight of groups with long running tasks.
+	 */
+	update_cfs_shares(cfs_rq, 0);
+
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
+
+	return 0;
+}
+
+static void update_shares(int cpu)
+{
+	struct cfs_rq *cfs_rq;
+	struct rq *rq = cpu_rq(cpu);
+
+	rcu_read_lock();
+	for_each_leaf_cfs_rq(rq, cfs_rq)
+		update_shares_cpu(cfs_rq->tg, cpu);
+	rcu_read_unlock();
+}
+
 static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
@@ -1956,6 +2160,10 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	return max_load_move - rem_load_move;
 }
 #else
+static inline void update_shares(int cpu)
+{
+}
+
 static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
@@ -3032,7 +3240,6 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	schedstat_inc(sd, lb_count[idle]);
 
 redo:
-	update_shares(sd);
 	group = find_busiest_group(sd, this_cpu, &imbalance, idle, &sd_idle,
 				   cpus, balance);
 
@@ -3174,8 +3381,6 @@ out_one_pinned:
 	else
 		ld_moved = 0;
 out:
-	if (ld_moved)
-		update_shares(sd);
 	return ld_moved;
 }
 
@@ -3199,6 +3404,7 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 	 */
 	raw_spin_unlock(&this_rq->lock);
 
+	update_shares(this_cpu);
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 		int balance = 1;
@@ -3569,6 +3775,8 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 	int update_next_balance = 0;
 	int need_serialize;
 
+	update_shares(cpu);
+
 	for_each_domain(cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 185f920..68e69ac 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -52,8 +52,6 @@ SCHED_FEAT(ARCH_POWER, 0)
 SCHED_FEAT(HRTICK, 0)
 SCHED_FEAT(DOUBLE_TICK, 0)
 SCHED_FEAT(LB_BIAS, 1)
-SCHED_FEAT(LB_SHARES_UPDATE, 1)
-SCHED_FEAT(ASYM_EFF_LOAD, 1)
 
 /*
  * Spin-wait on mutex acquisition when the mutex owner is running on
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index bea7d79..c914ec7 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -183,6 +183,17 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 	return ktime_to_ns(rt_rq->tg->rt_bandwidth.rt_period);
 }
 
+static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
+{
+	list_add_rcu(&rt_rq->leaf_rt_rq_list,
+			&rq_of_rt_rq(rt_rq)->leaf_rt_rq_list);
+}
+
+static inline void list_del_leaf_rt_rq(struct rt_rq *rt_rq)
+{
+	list_del_rcu(&rt_rq->leaf_rt_rq_list);
+}
+
 #define for_each_leaf_rt_rq(rt_rq, rq) \
 	list_for_each_entry_rcu(rt_rq, &rq->leaf_rt_rq_list, leaf_rt_rq_list)
 
@@ -276,6 +287,14 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 	return ktime_to_ns(def_rt_bandwidth.rt_period);
 }
 
+static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
+{
+}
+
+static inline void list_del_leaf_rt_rq(struct rt_rq *rt_rq)
+{
+}
+
 #define for_each_leaf_rt_rq(rt_rq, rq) \
 	for (rt_rq = &rq->rt; rt_rq; rt_rq = NULL)
 
@@ -825,6 +844,9 @@ static void __enqueue_rt_entity(struct sched_rt_entity *rt_se, bool head)
 	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
 		return;
 
+	if (!rt_rq->rt_nr_running)
+		list_add_leaf_rt_rq(rt_rq);
+
 	if (head)
 		list_add(&rt_se->run_list, queue);
 	else
@@ -844,6 +866,8 @@ static void __dequeue_rt_entity(struct sched_rt_entity *rt_se)
 		__clear_bit(rt_se_prio(rt_se), array->bitmap);
 
 	dec_rt_tasks(rt_se, rt_rq);
+	if (!rt_rq->rt_nr_running)
+		list_del_leaf_rt_rq(rt_rq);
 }
 
 /*
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 18f4be0..d4d918a 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -853,7 +853,9 @@ static int __cpuinit cpu_callback(struct notifier_block *nfb,
 			     cpumask_any(cpu_online_mask));
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN: {
-		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+		static struct sched_param param = {
+			.sched_priority = MAX_RT_PRIO-1
+		};
 
 		p = per_cpu(ksoftirqd, hotcpu);
 		per_cpu(ksoftirqd, hotcpu) = NULL;
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
index 5abfa15..121e4ff 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -259,8 +259,6 @@ static int min_wakeup_granularity_ns;			/* 0 usecs */
 static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 static int min_sched_tunable_scaling = SCHED_TUNABLESCALING_NONE;
 static int max_sched_tunable_scaling = SCHED_TUNABLESCALING_END-1;
-static int min_sched_shares_ratelimit = 100000; /* 100 usec */
-static int max_sched_shares_ratelimit = NSEC_PER_SEC; /* 1 second */
 #endif
 
 #ifdef CONFIG_COMPACTION
@@ -305,15 +303,6 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &max_wakeup_granularity_ns,
 	},
 	{
-		.procname	= "sched_shares_ratelimit",
-		.data		= &sysctl_sched_shares_ratelimit,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= sched_proc_update_handler,
-		.extra1		= &min_sched_shares_ratelimit,
-		.extra2		= &max_sched_shares_ratelimit,
-	},
-	{
 		.procname	= "sched_tunable_scaling",
 		.data		= &sysctl_sched_tunable_scaling,
 		.maxlen		= sizeof(enum sched_tunable_scaling),
@@ -323,14 +312,6 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &max_sched_tunable_scaling,
 	},
 	{
-		.procname	= "sched_shares_thresh",
-		.data		= &sysctl_sched_shares_thresh,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
-	},
-	{
 		.procname	= "sched_migration_cost",
 		.data		= &sysctl_sched_migration_cost,
 		.maxlen		= sizeof(unsigned int),
@@ -352,6 +333,13 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "sched_shares_window",
+		.data		= &sysctl_sched_shares_window,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
 		.procname	= "timer_migration",
 		.data		= &sysctl_timer_migration,
 		.maxlen		= sizeof(unsigned int),
@@ -382,6 +370,17 @@ static struct ctl_table kern_table[] = {
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
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 155a415..562c56e 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -558,7 +558,7 @@ trace_selftest_startup_nop(struct tracer *trace, struct trace_array *tr)
 static int trace_wakeup_test_thread(void *data)
 {
 	/* Make this a RT thread, doesn't need to be too high */
-	struct sched_param param = { .sched_priority = 5 };
+	static struct sched_param param = { .sched_priority = 5 };
 	struct completion *x = data;
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 5b08215..c812c49 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -307,7 +307,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
  */
 static int watchdog(void *unused)
 {
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+	static struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
