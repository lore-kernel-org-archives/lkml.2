Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab1C3KzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:55:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:54670 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab1C3KzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:55:15 -0400
Date: Wed, 30 Mar 2011 12:55:05 +0200
From: Michal Marek <mmarek@suse.cz>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, paulmck@linux.vnet.ibm.com,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
Message-ID: <20110330105505.GA3195@sepie.suse.cz>
References: <4D8FF9BC.7050609@cn.fujitsu.com>
 <4D90647902000078000389CB@vpn.id2.novell.com>
 <4D924BAF.1020906@linux.intel.com>
 <20110329213130.GK2261@linux.vnet.ibm.com>
 <4D924FEE.8040804@linux.intel.com>
 <20110329214704.GM2261@linux.vnet.ibm.com>
 <4D9256AF.5000308@linux.intel.com>
 <20110330004725.GO2261@linux.vnet.ibm.com>
 <4D92BECA.50802@cn.fujitsu.com>
 <4D92DA32.2010809@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D92DA32.2010809@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 03:22:26PM +0800, Lai Jiangshan wrote:
> On 03/30/2011 01:25 PM, Lai Jiangshan wrote:
> > Yes, there are other circular dependencies, <linux/sched.h> includes
> > many files which include or indirectly include <linux/rcupdate.h>
> > for struct rcu_head or RCU apis. There are too many to be split all.
> > 
> 
> <linux/rcupdate.h> is so generic that it is included in many headers.
> <linux/sched.h> is so complex that it includes many headers.
> 
> How many files which include(or indirectly include) <linux/rcupdate.h>
> are included(or indirectly included) by <linux/sched.h>?
> 
> 714 files! So I can guess 100 files at least is needed to be touched if
> we resolve this problem by splitting.

It goes down quickly if you start reducing the dependencies. I wrote a
quick&dirty patch that splits 9 headers and the preprocessed result of
#include <linux/sched_types.h> is about 7800 lines. Most of it is caused
by linux/signal.h which I skipped. What do you think?

Michal

Subject: [PATCH] headers: Allow for lightweight inclusion of task_struct definition

Factor out a couple of type definitions to <header>_types.h to allow
using task_struct without pulling tons of new dependencies via sched.h.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 include/linux/Kbuild               |    1 +
 include/linux/mutex.h              |   18 +--
 include/linux/mutex_types.h        |   22 ++
 include/linux/nodemask.h           |    2 +-
 include/linux/nodemask_types.h     |   11 +
 include/linux/pid.h                |   15 +-
 include/linux/pid_types.h          |   18 ++
 include/linux/proportions.h        |   24 +--
 include/linux/proportions_types.h  |   29 ++
 include/linux/rbtree.h             |    8 +-
 include/linux/rbtree_types.h       |   11 +
 include/linux/rcupdate.h           |   11 +-
 include/linux/rcupdate_types.h     |   14 +
 include/linux/sched.h              |  481 +-----------------------------------
 include/linux/sched_types.h        |  493 ++++++++++++++++++++++++++++++++++++
 include/linux/seccomp.h            |    5 +-
 include/linux/seccomp_types.h      |   12 +
 include/linux/sem.h                |    5 +-
 include/linux/sem_types.h          |   10 +
 include/linux/task_io_accounting.h |    2 +
 20 files changed, 633 insertions(+), 559 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index b0ada6f..779afd63 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -325,6 +325,7 @@ header-y += sdla.h
 header-y += securebits.h
 header-y += selinux_netlink.h
 header-y += sem.h
+header-y += sem_types.h
 header-y += serial.h
 header-y += serial_core.h
 header-y += serial_reg.h
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 94b48bd..3cc7492 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -14,8 +14,8 @@
 #include <linux/spinlock_types.h>
 #include <linux/linkage.h>
 #include <linux/lockdep.h>
-
 #include <asm/atomic.h>
+#include <linux/mutex_types.h>
 
 /*
  * Simple, straightforward mutexes with strict semantics:
@@ -45,22 +45,6 @@
  * - detects multi-task circular deadlocks and prints out all affected
  *   locks and tasks (and only those tasks)
  */
-struct mutex {
-	/* 1: unlocked, 0: locked, negative: locked, possible waiters */
-	atomic_t		count;
-	spinlock_t		wait_lock;
-	struct list_head	wait_list;
-#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
-	struct thread_info	*owner;
-#endif
-#ifdef CONFIG_DEBUG_MUTEXES
-	const char 		*name;
-	void			*magic;
-#endif
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map	dep_map;
-#endif
-};
 
 /*
  * This is the control structure for tasks blocked on mutex,
diff --git a/include/linux/mutex_types.h b/include/linux/mutex_types.h
new file mode 100644
index 0000000..51113ab
--- /dev/null
+++ b/include/linux/mutex_types.h
@@ -0,0 +1,22 @@
+#ifndef _LINUX_MUTEX_TYPES_H
+#define _LINUX_MUTEX_TYPES_H
+
+
+struct mutex {
+	/* 1: unlocked, 0: locked, negative: locked, possible waiters */
+	atomic_t		count;
+	spinlock_t		wait_lock;
+	struct list_head	wait_list;
+#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
+	struct thread_info	*owner;
+#endif
+#ifdef CONFIG_DEBUG_MUTEXES
+	const char		*name;
+	void			*magic;
+#endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	dep_map;
+#endif
+};
+
+#endif
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index dba35e4..ed02421 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -92,8 +92,8 @@
 #include <linux/threads.h>
 #include <linux/bitmap.h>
 #include <linux/numa.h>
+#include <linux/nodemask_types.h>
 
-typedef struct { DECLARE_BITMAP(bits, MAX_NUMNODES); } nodemask_t;
 extern nodemask_t _unused_nodemask_arg_;
 
 #define node_set(node, dst) __node_set((node), &(dst))
diff --git a/include/linux/nodemask_types.h b/include/linux/nodemask_types.h
new file mode 100644
index 0000000..97b6614
--- /dev/null
+++ b/include/linux/nodemask_types.h
@@ -0,0 +1,11 @@
+#ifndef _LINUX_NODEMASK_TYPES_H
+#define _LINUX_NODEMASK_TYPES_H
+
+#include <linux/bitops.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/numa.h>
+
+typedef struct { DECLARE_BITMAP(bits, MAX_NUMNODES); } nodemask_t;
+
+#endif
diff --git a/include/linux/pid.h b/include/linux/pid.h
index 49f1c2f..8b66f2c 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -2,14 +2,7 @@
 #define _LINUX_PID_H
 
 #include <linux/rcupdate.h>
-
-enum pid_type
-{
-	PIDTYPE_PID,
-	PIDTYPE_PGID,
-	PIDTYPE_SID,
-	PIDTYPE_MAX
-};
+#include <linux/pid_types.h>
 
 /*
  * What is struct pid?
@@ -66,12 +59,6 @@ struct pid
 
 extern struct pid init_struct_pid;
 
-struct pid_link
-{
-	struct hlist_node node;
-	struct pid *pid;
-};
-
 static inline struct pid *get_pid(struct pid *pid)
 {
 	if (pid)
diff --git a/include/linux/pid_types.h b/include/linux/pid_types.h
new file mode 100644
index 0000000..85ab12a
--- /dev/null
+++ b/include/linux/pid_types.h
@@ -0,0 +1,18 @@
+#ifndef _LINUX_PID_TYPES_H
+#define _LINUX_PID_TYPES_H
+
+struct pid;
+
+enum pid_type {
+	PIDTYPE_PID,
+	PIDTYPE_PGID,
+	PIDTYPE_SID,
+	PIDTYPE_MAX
+};
+
+struct pid_link {
+	struct hlist_node node;
+	struct pid *pid;
+};
+
+#endif
diff --git a/include/linux/proportions.h b/include/linux/proportions.h
index cf793bb..d332304 100644
--- a/include/linux/proportions.h
+++ b/include/linux/proportions.h
@@ -12,6 +12,7 @@
 #include <linux/percpu_counter.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
+#include <linux/proportions_types.h>
 
 struct prop_global {
 	/*
@@ -90,29 +91,6 @@ void __prop_inc_percpu_max(struct prop_descriptor *pd,
 			   struct prop_local_percpu *pl, long frac);
 
 
-/*
- * ----- SINGLE ------
- */
-
-struct prop_local_single {
-	/*
-	 * the local events counter
-	 */
-	unsigned long events;
-
-	/*
-	 * snapshot of the last seen global state
-	 * and a lock protecting this state
-	 */
-	unsigned long period;
-	int shift;
-	spinlock_t lock;		/* protect the snapshot state */
-};
-
-#define INIT_PROP_LOCAL_SINGLE(name)			\
-{	.lock = __SPIN_LOCK_UNLOCKED(name.lock),	\
-}
-
 int prop_local_init_single(struct prop_local_single *pl);
 void prop_local_destroy_single(struct prop_local_single *pl);
 void __prop_inc_single(struct prop_descriptor *pd, struct prop_local_single *pl);
diff --git a/include/linux/proportions_types.h b/include/linux/proportions_types.h
new file mode 100644
index 0000000..24451fb
--- /dev/null
+++ b/include/linux/proportions_types.h
@@ -0,0 +1,29 @@
+#ifndef _LINUX_PROPORTIONS_TYPES_H
+#define _LINUX_PROPORTIONS_TYPES_H
+
+/*
+ * ----- SINGLE ------
+ */
+
+#include <linux/spinlock_types.h>
+
+struct prop_local_single {
+	/*
+	 * the local events counter
+	 */
+	unsigned long events;
+
+	/*
+	 * snapshot of the last seen global state
+	 * and a lock protecting this state
+	 */
+	unsigned long period;
+	int shift;
+	spinlock_t lock;		/* protect the snapshot state */
+};
+
+#define INIT_PROP_LOCAL_SINGLE(name)			\
+{	.lock = __SPIN_LOCK_UNLOCKED(name.lock),	\
+}
+
+#endif
diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 7066acb..1ca842d 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -96,16 +96,10 @@ static inline struct page * rb_insert_page_cache(struct inode * inode,
 
 #include <linux/kernel.h>
 #include <linux/stddef.h>
+#include <linux/rbtree_types.h>
 
-struct rb_node
-{
-	unsigned long  rb_parent_color;
 #define	RB_RED		0
 #define	RB_BLACK	1
-	struct rb_node *rb_right;
-	struct rb_node *rb_left;
-} __attribute__((aligned(sizeof(long))));
-    /* The alignment might seem pointless, but allegedly CRIS needs it */
 
 struct rb_root
 {
diff --git a/include/linux/rbtree_types.h b/include/linux/rbtree_types.h
new file mode 100644
index 0000000..decfaef
--- /dev/null
+++ b/include/linux/rbtree_types.h
@@ -0,0 +1,11 @@
+#ifndef _LINUX_RBTREE_TYPES_H
+#define _LINUX_RBTREE_TYPES_H
+
+struct rb_node {
+	unsigned long  rb_parent_color;
+	struct rb_node *rb_right;
+	struct rb_node *rb_left;
+} __attribute__((aligned(sizeof(long))));
+    /* The alignment might seem pointless, but allegedly CRIS needs it */
+
+#endif
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index af56148..a901ede 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -42,6 +42,7 @@
 #include <linux/completion.h>
 #include <linux/debugobjects.h>
 #include <linux/compiler.h>
+#include <linux/rcupdate_types.h>
 
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable; /* for sysctl */
@@ -52,16 +53,6 @@ extern int rcutorture_runnable; /* for sysctl */
 #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
 #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
 
-/**
- * struct rcu_head - callback structure for use with RCU
- * @next: next update requests in a list
- * @func: actual update function to call after the grace period.
- */
-struct rcu_head {
-	struct rcu_head *next;
-	void (*func)(struct rcu_head *head);
-};
-
 /* Exported common interfaces */
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));
diff --git a/include/linux/rcupdate_types.h b/include/linux/rcupdate_types.h
new file mode 100644
index 0000000..5ee7b54
--- /dev/null
+++ b/include/linux/rcupdate_types.h
@@ -0,0 +1,14 @@
+#ifndef _LINUX_RCUPDATE_TYPES_H
+#define _LINUX_RCUPDATE_TYPES_H
+
+/**
+ * struct rcu_head - callback structure for use with RCU
+ * @next: next update requests in a list
+ * @func: actual update function to call after the grace period.
+ */
+struct rcu_head {
+	struct rcu_head *next;
+	void (*func)(struct rcu_head *head);
+};
+
+#endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 777d8a5..9aef559 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -87,12 +87,13 @@ struct sched_param {
 #include <linux/resource.h>
 #include <linux/timer.h>
 #include <linux/hrtimer.h>
-#include <linux/task_io_accounting.h>
 #include <linux/latencytop.h>
 #include <linux/cred.h>
 
 #include <asm/processor.h>
 
+#include <linux/sched_types.h>
+
 struct exec_domain;
 struct futex_pi_state;
 struct robust_list_head;
@@ -241,9 +242,6 @@ extern char ___assert_task_state[1 - 2*!!(
 #define set_current_state(state_value)		\
 	set_mb(current->state, (state_value))
 
-/* Task command name length */
-#define TASK_COMM_LEN 16
-
 #include <linux/spinlock.h>
 
 /*
@@ -460,34 +458,6 @@ struct cpu_itimer {
 	u32 incr_error;
 };
 
-/**
- * struct task_cputime - collected CPU time counts
- * @utime:		time spent in user mode, in &cputime_t units
- * @stime:		time spent in kernel mode, in &cputime_t units
- * @sum_exec_runtime:	total time spent on the CPU, in nanoseconds
- *
- * This structure groups together three kinds of CPU time that are
- * tracked for threads and thread groups.  Most things considering
- * CPU time want to group these counts together and treat all three
- * of them in parallel.
- */
-struct task_cputime {
-	cputime_t utime;
-	cputime_t stime;
-	unsigned long long sum_exec_runtime;
-};
-/* Alternate field names when used to cache expirations. */
-#define prof_exp	stime
-#define virt_exp	utime
-#define sched_exp	sum_exec_runtime
-
-#define INIT_CPUTIME	\
-	(struct task_cputime) {					\
-		.utime = cputime_zero,				\
-		.stime = cputime_zero,				\
-		.sum_exec_runtime = 0,				\
-	}
-
 /*
  * Disable preemption until the scheduler is running.
  * Reset by start_kernel()->sched_init()->init_idle().
@@ -721,22 +691,6 @@ extern struct user_struct root_user;
 struct backing_dev_info;
 struct reclaim_state;
 
-#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
-struct sched_info {
-	/* cumulative counters */
-	unsigned long pcount;	      /* # of times run on this cpu */
-	unsigned long long run_delay; /* time spent waiting on a runqueue */
-
-	/* timestamps */
-	unsigned long long last_arrival,/* when we last ran on a cpu */
-			   last_queued;	/* when we were last queued to run */
-#ifdef CONFIG_SCHEDSTATS
-	/* BKL stats */
-	unsigned int bkl_count;
-#endif
-};
-#endif /* defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT) */
-
 #ifdef CONFIG_TASK_DELAY_ACCT
 struct task_delay_info {
 	spinlock_t	lock;
@@ -1099,437 +1053,6 @@ struct sched_class {
 #endif
 };
 
-struct load_weight {
-	unsigned long weight, inv_weight;
-};
-
-#ifdef CONFIG_SCHEDSTATS
-struct sched_statistics {
-	u64			wait_start;
-	u64			wait_max;
-	u64			wait_count;
-	u64			wait_sum;
-	u64			iowait_count;
-	u64			iowait_sum;
-
-	u64			sleep_start;
-	u64			sleep_max;
-	s64			sum_sleep_runtime;
-
-	u64			block_start;
-	u64			block_max;
-	u64			exec_max;
-	u64			slice_max;
-
-	u64			nr_migrations_cold;
-	u64			nr_failed_migrations_affine;
-	u64			nr_failed_migrations_running;
-	u64			nr_failed_migrations_hot;
-	u64			nr_forced_migrations;
-
-	u64			nr_wakeups;
-	u64			nr_wakeups_sync;
-	u64			nr_wakeups_migrate;
-	u64			nr_wakeups_local;
-	u64			nr_wakeups_remote;
-	u64			nr_wakeups_affine;
-	u64			nr_wakeups_affine_attempts;
-	u64			nr_wakeups_passive;
-	u64			nr_wakeups_idle;
-};
-#endif
-
-struct sched_entity {
-	struct load_weight	load;		/* for load-balancing */
-	struct rb_node		run_node;
-	struct list_head	group_node;
-	unsigned int		on_rq;
-
-	u64			exec_start;
-	u64			sum_exec_runtime;
-	u64			vruntime;
-	u64			prev_sum_exec_runtime;
-
-	u64			nr_migrations;
-
-#ifdef CONFIG_SCHEDSTATS
-	struct sched_statistics statistics;
-#endif
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	struct sched_entity	*parent;
-	/* rq on which this entity is (to be) queued: */
-	struct cfs_rq		*cfs_rq;
-	/* rq "owned" by this entity/group: */
-	struct cfs_rq		*my_q;
-#endif
-};
-
-struct sched_rt_entity {
-	struct list_head run_list;
-	unsigned long timeout;
-	unsigned int time_slice;
-	int nr_cpus_allowed;
-
-	struct sched_rt_entity *back;
-#ifdef CONFIG_RT_GROUP_SCHED
-	struct sched_rt_entity	*parent;
-	/* rq on which this entity is (to be) queued: */
-	struct rt_rq		*rt_rq;
-	/* rq "owned" by this entity/group: */
-	struct rt_rq		*my_q;
-#endif
-};
-
-struct rcu_node;
-
-enum perf_event_task_context {
-	perf_invalid_context = -1,
-	perf_hw_context = 0,
-	perf_sw_context,
-	perf_nr_task_contexts,
-};
-
-struct task_struct {
-	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
-	void *stack;
-	atomic_t usage;
-	unsigned int flags;	/* per process flags, defined below */
-	unsigned int ptrace;
-
-	int lock_depth;		/* BKL lock depth */
-
-#ifdef CONFIG_SMP
-#ifdef __ARCH_WANT_UNLOCKED_CTXSW
-	int oncpu;
-#endif
-#endif
-
-	int prio, static_prio, normal_prio;
-	unsigned int rt_priority;
-	const struct sched_class *sched_class;
-	struct sched_entity se;
-	struct sched_rt_entity rt;
-
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-	/* list of struct preempt_notifier: */
-	struct hlist_head preempt_notifiers;
-#endif
-
-	/*
-	 * fpu_counter contains the number of consecutive context switches
-	 * that the FPU is used. If this is over a threshold, the lazy fpu
-	 * saving becomes unlazy to save the trap. This is an unsigned char
-	 * so that after 256 times the counter wraps and the behavior turns
-	 * lazy again; this to deal with bursty apps that only use FPU for
-	 * a short time
-	 */
-	unsigned char fpu_counter;
-#ifdef CONFIG_BLK_DEV_IO_TRACE
-	unsigned int btrace_seq;
-#endif
-
-	unsigned int policy;
-	cpumask_t cpus_allowed;
-
-#ifdef CONFIG_PREEMPT_RCU
-	int rcu_read_lock_nesting;
-	char rcu_read_unlock_special;
-	struct list_head rcu_node_entry;
-#endif /* #ifdef CONFIG_PREEMPT_RCU */
-#ifdef CONFIG_TREE_PREEMPT_RCU
-	struct rcu_node *rcu_blocked_node;
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-#ifdef CONFIG_RCU_BOOST
-	struct rt_mutex *rcu_boost_mutex;
-#endif /* #ifdef CONFIG_RCU_BOOST */
-
-#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
-	struct sched_info sched_info;
-#endif
-
-	struct list_head tasks;
-#ifdef CONFIG_SMP
-	struct plist_node pushable_tasks;
-#endif
-
-	struct mm_struct *mm, *active_mm;
-#if defined(SPLIT_RSS_COUNTING)
-	struct task_rss_stat	rss_stat;
-#endif
-/* task state */
-	int exit_state;
-	int exit_code, exit_signal;
-	int pdeath_signal;  /*  The signal sent when the parent dies  */
-	/* ??? */
-	unsigned int personality;
-	unsigned did_exec:1;
-	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
-				 * execve */
-	unsigned in_iowait:1;
-
-
-	/* Revert to default priority/policy when forking */
-	unsigned sched_reset_on_fork:1;
-
-	pid_t pid;
-	pid_t tgid;
-
-#ifdef CONFIG_CC_STACKPROTECTOR
-	/* Canary value for the -fstack-protector gcc feature */
-	unsigned long stack_canary;
-#endif
-
-	/* 
-	 * pointers to (original) parent process, youngest child, younger sibling,
-	 * older sibling, respectively.  (p->father can be replaced with 
-	 * p->real_parent->pid)
-	 */
-	struct task_struct *real_parent; /* real parent process */
-	struct task_struct *parent; /* recipient of SIGCHLD, wait4() reports */
-	/*
-	 * children/sibling forms the list of my natural children
-	 */
-	struct list_head children;	/* list of my children */
-	struct list_head sibling;	/* linkage in my parent's children list */
-	struct task_struct *group_leader;	/* threadgroup leader */
-
-	/*
-	 * ptraced is the list of tasks this task is using ptrace on.
-	 * This includes both natural children and PTRACE_ATTACH targets.
-	 * p->ptrace_entry is p's link on the p->parent->ptraced list.
-	 */
-	struct list_head ptraced;
-	struct list_head ptrace_entry;
-
-	/* PID/PID hash table linkage. */
-	struct pid_link pids[PIDTYPE_MAX];
-	struct list_head thread_group;
-
-	struct completion *vfork_done;		/* for vfork() */
-	int __user *set_child_tid;		/* CLONE_CHILD_SETTID */
-	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
-
-	cputime_t utime, stime, utimescaled, stimescaled;
-	cputime_t gtime;
-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
-	cputime_t prev_utime, prev_stime;
-#endif
-	unsigned long nvcsw, nivcsw; /* context switch counts */
-	struct timespec start_time; 		/* monotonic time */
-	struct timespec real_start_time;	/* boot based time */
-/* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
-	unsigned long min_flt, maj_flt;
-
-	struct task_cputime cputime_expires;
-	struct list_head cpu_timers[3];
-
-/* process credentials */
-	const struct cred __rcu *real_cred; /* objective and real subjective task
-					 * credentials (COW) */
-	const struct cred __rcu *cred;	/* effective (overridable) subjective task
-					 * credentials (COW) */
-	struct cred *replacement_session_keyring; /* for KEYCTL_SESSION_TO_PARENT */
-
-	char comm[TASK_COMM_LEN]; /* executable name excluding path
-				     - access with [gs]et_task_comm (which lock
-				       it with task_lock())
-				     - initialized normally by setup_new_exec */
-/* file system info */
-	int link_count, total_link_count;
-#ifdef CONFIG_SYSVIPC
-/* ipc stuff */
-	struct sysv_sem sysvsem;
-#endif
-#ifdef CONFIG_DETECT_HUNG_TASK
-/* hung task detection */
-	unsigned long last_switch_count;
-#endif
-/* CPU-specific state of this task */
-	struct thread_struct thread;
-/* filesystem information */
-	struct fs_struct *fs;
-/* open file information */
-	struct files_struct *files;
-/* namespaces */
-	struct nsproxy *nsproxy;
-/* signal handlers */
-	struct signal_struct *signal;
-	struct sighand_struct *sighand;
-
-	sigset_t blocked, real_blocked;
-	sigset_t saved_sigmask;	/* restored if set_restore_sigmask() was used */
-	struct sigpending pending;
-
-	unsigned long sas_ss_sp;
-	size_t sas_ss_size;
-	int (*notifier)(void *priv);
-	void *notifier_data;
-	sigset_t *notifier_mask;
-	struct audit_context *audit_context;
-#ifdef CONFIG_AUDITSYSCALL
-	uid_t loginuid;
-	unsigned int sessionid;
-#endif
-	seccomp_t seccomp;
-
-/* Thread group tracking */
-   	u32 parent_exec_id;
-   	u32 self_exec_id;
-/* Protection of (de-)allocation: mm, files, fs, tty, keyrings, mems_allowed,
- * mempolicy */
-	spinlock_t alloc_lock;
-
-#ifdef CONFIG_GENERIC_HARDIRQS
-	/* IRQ handler threads */
-	struct irqaction *irqaction;
-#endif
-
-	/* Protection of the PI data structures: */
-	raw_spinlock_t pi_lock;
-
-#ifdef CONFIG_RT_MUTEXES
-	/* PI waiters blocked on a rt_mutex held by this task */
-	struct plist_head pi_waiters;
-	/* Deadlock detection and priority inheritance handling */
-	struct rt_mutex_waiter *pi_blocked_on;
-#endif
-
-#ifdef CONFIG_DEBUG_MUTEXES
-	/* mutex deadlock detection */
-	struct mutex_waiter *blocked_on;
-#endif
-#ifdef CONFIG_TRACE_IRQFLAGS
-	unsigned int irq_events;
-	unsigned long hardirq_enable_ip;
-	unsigned long hardirq_disable_ip;
-	unsigned int hardirq_enable_event;
-	unsigned int hardirq_disable_event;
-	int hardirqs_enabled;
-	int hardirq_context;
-	unsigned long softirq_disable_ip;
-	unsigned long softirq_enable_ip;
-	unsigned int softirq_disable_event;
-	unsigned int softirq_enable_event;
-	int softirqs_enabled;
-	int softirq_context;
-#endif
-#ifdef CONFIG_LOCKDEP
-# define MAX_LOCK_DEPTH 48UL
-	u64 curr_chain_key;
-	int lockdep_depth;
-	unsigned int lockdep_recursion;
-	struct held_lock held_locks[MAX_LOCK_DEPTH];
-	gfp_t lockdep_reclaim_gfp;
-#endif
-
-/* journalling filesystem info */
-	void *journal_info;
-
-/* stacked block device info */
-	struct bio_list *bio_list;
-
-/* VM state */
-	struct reclaim_state *reclaim_state;
-
-	struct backing_dev_info *backing_dev_info;
-
-	struct io_context *io_context;
-
-	unsigned long ptrace_message;
-	siginfo_t *last_siginfo; /* For ptrace use.  */
-	struct task_io_accounting ioac;
-#if defined(CONFIG_TASK_XACCT)
-	u64 acct_rss_mem1;	/* accumulated rss usage */
-	u64 acct_vm_mem1;	/* accumulated virtual memory usage */
-	cputime_t acct_timexpd;	/* stime + utime since last update */
-#endif
-#ifdef CONFIG_CPUSETS
-	nodemask_t mems_allowed;	/* Protected by alloc_lock */
-	int mems_allowed_change_disable;
-	int cpuset_mem_spread_rotor;
-	int cpuset_slab_spread_rotor;
-#endif
-#ifdef CONFIG_CGROUPS
-	/* Control Group info protected by css_set_lock */
-	struct css_set __rcu *cgroups;
-	/* cg_list protected by css_set_lock and tsk->alloc_lock */
-	struct list_head cg_list;
-#endif
-#ifdef CONFIG_FUTEX
-	struct robust_list_head __user *robust_list;
-#ifdef CONFIG_COMPAT
-	struct compat_robust_list_head __user *compat_robust_list;
-#endif
-	struct list_head pi_state_list;
-	struct futex_pi_state *pi_state_cache;
-#endif
-#ifdef CONFIG_PERF_EVENTS
-	struct perf_event_context *perf_event_ctxp[perf_nr_task_contexts];
-	struct mutex perf_event_mutex;
-	struct list_head perf_event_list;
-#endif
-#ifdef CONFIG_NUMA
-	struct mempolicy *mempolicy;	/* Protected by alloc_lock */
-	short il_next;
-#endif
-	atomic_t fs_excl;	/* holding fs exclusive resources */
-	struct rcu_head rcu;
-
-	/*
-	 * cache last used pipe for splice
-	 */
-	struct pipe_inode_info *splice_pipe;
-#ifdef	CONFIG_TASK_DELAY_ACCT
-	struct task_delay_info *delays;
-#endif
-#ifdef CONFIG_FAULT_INJECTION
-	int make_it_fail;
-#endif
-	struct prop_local_single dirties;
-#ifdef CONFIG_LATENCYTOP
-	int latency_record_count;
-	struct latency_record latency_record[LT_SAVECOUNT];
-#endif
-	/*
-	 * time slack values; these are used to round up poll() and
-	 * select() etc timeout values. These are in nanoseconds.
-	 */
-	unsigned long timer_slack_ns;
-	unsigned long default_timer_slack_ns;
-
-	struct list_head	*scm_work_list;
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	/* Index of current stored address in ret_stack */
-	int curr_ret_stack;
-	/* Stack of return addresses for return function tracing */
-	struct ftrace_ret_stack	*ret_stack;
-	/* time stamp for last schedule */
-	unsigned long long ftrace_timestamp;
-	/*
-	 * Number of functions that haven't been traced
-	 * because of depth overrun.
-	 */
-	atomic_t trace_overrun;
-	/* Pause for the tracing */
-	atomic_t tracing_graph_pause;
-#endif
-#ifdef CONFIG_TRACING
-	/* state flags for use by tracers */
-	unsigned long trace;
-	/* bitmask of trace recursion */
-	unsigned long trace_recursion;
-#endif /* CONFIG_TRACING */
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR /* memcg uses this to do batch job */
-	struct memcg_batch_info {
-		int do_batch;	/* incremented when batch uncharge started */
-		struct mem_cgroup *memcg; /* target memcg of uncharge */
-		unsigned long bytes; 		/* uncharged usage */
-		unsigned long memsw_bytes; /* uncharged mem+swap usage */
-	} memcg_batch;
-#endif
-};
-
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
 #define tsk_cpus_allowed(tsk) (&(tsk)->cpus_allowed)
 
diff --git a/include/linux/sched_types.h b/include/linux/sched_types.h
new file mode 100644
index 0000000..ab6df1e
--- /dev/null
+++ b/include/linux/sched_types.h
@@ -0,0 +1,493 @@
+#ifndef _LINUX_SCHED_TYPES_H
+#define _LINUX_SCHED_TYPES_H
+
+#include <linux/task_io_accounting.h>
+#include <linux/proportions_types.h>
+#include <linux/nodemask_types.h>
+#include <linux/rcupdate_types.h>
+#include <linux/seccomp_types.h>
+#include <linux/rbtree_types.h>
+#include <linux/mutex_types.h>
+#include <linux/pid_types.h>
+#include <linux/sem_types.h>
+#include <linux/signal.h>
+#include <asm/cputime.h>
+#include <linux/plist.h>
+
+/* Task command name length */
+#define TASK_COMM_LEN 16
+
+struct load_weight {
+	unsigned long weight, inv_weight;
+};
+
+enum perf_event_task_context {
+	perf_invalid_context = -1,
+	perf_hw_context = 0,
+	perf_sw_context,
+	perf_nr_task_contexts,
+};
+
+#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
+struct sched_info {
+	/* cumulative counters */
+	unsigned long pcount;	      /* # of times run on this cpu */
+	unsigned long long run_delay; /* time spent waiting on a runqueue */
+
+	/* timestamps */
+	unsigned long long last_arrival,/* when we last ran on a cpu */
+			   last_queued;	/* when we were last queued to run */
+#ifdef CONFIG_SCHEDSTATS
+	/* BKL stats */
+	unsigned int bkl_count;
+#endif
+};
+#endif /* defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT) */
+
+#ifdef CONFIG_SCHEDSTATS
+struct sched_statistics {
+	u64			wait_start;
+	u64			wait_max;
+	u64			wait_count;
+	u64			wait_sum;
+	u64			iowait_count;
+	u64			iowait_sum;
+
+	u64			sleep_start;
+	u64			sleep_max;
+	s64			sum_sleep_runtime;
+
+	u64			block_start;
+	u64			block_max;
+	u64			exec_max;
+	u64			slice_max;
+
+	u64			nr_migrations_cold;
+	u64			nr_failed_migrations_affine;
+	u64			nr_failed_migrations_running;
+	u64			nr_failed_migrations_hot;
+	u64			nr_forced_migrations;
+
+	u64			nr_wakeups;
+	u64			nr_wakeups_sync;
+	u64			nr_wakeups_migrate;
+	u64			nr_wakeups_local;
+	u64			nr_wakeups_remote;
+	u64			nr_wakeups_affine;
+	u64			nr_wakeups_affine_attempts;
+	u64			nr_wakeups_passive;
+	u64			nr_wakeups_idle;
+};
+#endif
+
+struct sched_entity {
+	struct load_weight	load;		/* for load-balancing */
+	struct rb_node		run_node;
+	struct list_head	group_node;
+	unsigned int		on_rq;
+
+	u64			exec_start;
+	u64			sum_exec_runtime;
+	u64			vruntime;
+	u64			prev_sum_exec_runtime;
+
+	u64			nr_migrations;
+
+#ifdef CONFIG_SCHEDSTATS
+	struct sched_statistics statistics;
+#endif
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	struct sched_entity	*parent;
+	/* rq on which this entity is (to be) queued: */
+	struct cfs_rq		*cfs_rq;
+	/* rq "owned" by this entity/group: */
+	struct cfs_rq		*my_q;
+#endif
+};
+
+struct sched_rt_entity {
+	struct list_head run_list;
+	unsigned long timeout;
+	unsigned int time_slice;
+	int nr_cpus_allowed;
+
+	struct sched_rt_entity *back;
+#ifdef CONFIG_RT_GROUP_SCHED
+	struct sched_rt_entity	*parent;
+	/* rq on which this entity is (to be) queued: */
+	struct rt_rq		*rt_rq;
+	/* rq "owned" by this entity/group: */
+	struct rt_rq		*my_q;
+#endif
+};
+
+/**
+ * struct task_cputime - collected CPU time counts
+ * @utime:		time spent in user mode, in &cputime_t units
+ * @stime:		time spent in kernel mode, in &cputime_t units
+ * @sum_exec_runtime:	total time spent on the CPU, in nanoseconds
+ *
+ * This structure groups together three kinds of CPU time that are
+ * tracked for threads and thread groups.  Most things considering
+ * CPU time want to group these counts together and treat all three
+ * of them in parallel.
+ */
+struct task_cputime {
+	cputime_t utime;
+	cputime_t stime;
+	unsigned long long sum_exec_runtime;
+};
+/* Alternate field names when used to cache expirations. */
+#define prof_exp	stime
+#define virt_exp	utime
+#define sched_exp	sum_exec_runtime
+
+#define INIT_CPUTIME	\
+	(struct task_cputime) {					\
+		.utime = cputime_zero,				\
+		.stime = cputime_zero,				\
+		.sum_exec_runtime = 0,				\
+	}
+
+struct task_struct {
+	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
+	void *stack;
+	atomic_t usage;
+	unsigned int flags;	/* per process flags, defined below */
+	unsigned int ptrace;
+
+	int lock_depth;		/* BKL lock depth */
+
+#ifdef CONFIG_SMP
+#ifdef __ARCH_WANT_UNLOCKED_CTXSW
+	int oncpu;
+#endif
+#endif
+
+	int prio, static_prio, normal_prio;
+	unsigned int rt_priority;
+	const struct sched_class *sched_class;
+	struct sched_entity se;
+	struct sched_rt_entity rt;
+
+#ifdef CONFIG_PREEMPT_NOTIFIERS
+	/* list of struct preempt_notifier: */
+	struct hlist_head preempt_notifiers;
+#endif
+
+	/*
+	 * fpu_counter contains the number of consecutive context switches
+	 * that the FPU is used. If this is over a threshold, the lazy fpu
+	 * saving becomes unlazy to save the trap. This is an unsigned char
+	 * so that after 256 times the counter wraps and the behavior turns
+	 * lazy again; this to deal with bursty apps that only use FPU for
+	 * a short time
+	 */
+	unsigned char fpu_counter;
+#ifdef CONFIG_BLK_DEV_IO_TRACE
+	unsigned int btrace_seq;
+#endif
+
+	unsigned int policy;
+	cpumask_t cpus_allowed;
+
+#ifdef CONFIG_PREEMPT_RCU
+	int rcu_read_lock_nesting;
+	char rcu_read_unlock_special;
+	struct list_head rcu_node_entry;
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	struct rcu_node *rcu_blocked_node;
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#ifdef CONFIG_RCU_BOOST
+	struct rt_mutex *rcu_boost_mutex;
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
+#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
+	struct sched_info sched_info;
+#endif
+
+	struct list_head tasks;
+#ifdef CONFIG_SMP
+	struct plist_node pushable_tasks;
+#endif
+
+	struct mm_struct *mm, *active_mm;
+#if defined(SPLIT_RSS_COUNTING)
+	struct task_rss_stat	rss_stat;
+#endif
+/* task state */
+	int exit_state;
+	int exit_code, exit_signal;
+	int pdeath_signal;  /*  The signal sent when the parent dies  */
+	/* ??? */
+	unsigned int personality;
+	unsigned did_exec:1;
+	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
+				 * execve */
+	unsigned in_iowait:1;
+
+
+	/* Revert to default priority/policy when forking */
+	unsigned sched_reset_on_fork:1;
+
+	pid_t pid;
+	pid_t tgid;
+
+#ifdef CONFIG_CC_STACKPROTECTOR
+	/* Canary value for the -fstack-protector gcc feature */
+	unsigned long stack_canary;
+#endif
+
+	/*
+	 * pointers to (original) parent process, youngest child, younger sibling,
+	 * older sibling, respectively.  (p->father can be replaced with
+	 * p->real_parent->pid)
+	 */
+	struct task_struct *real_parent; /* real parent process */
+	struct task_struct *parent; /* recipient of SIGCHLD, wait4() reports */
+	/*
+	 * children/sibling forms the list of my natural children
+	 */
+	struct list_head children;	/* list of my children */
+	struct list_head sibling;	/* linkage in my parent's children list */
+	struct task_struct *group_leader;	/* threadgroup leader */
+
+	/*
+	 * ptraced is the list of tasks this task is using ptrace on.
+	 * This includes both natural children and PTRACE_ATTACH targets.
+	 * p->ptrace_entry is p's link on the p->parent->ptraced list.
+	 */
+	struct list_head ptraced;
+	struct list_head ptrace_entry;
+
+	/* PID/PID hash table linkage. */
+	struct pid_link pids[PIDTYPE_MAX];
+	struct list_head thread_group;
+
+	struct completion *vfork_done;		/* for vfork() */
+	int __user *set_child_tid;		/* CLONE_CHILD_SETTID */
+	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
+
+	cputime_t utime, stime, utimescaled, stimescaled;
+	cputime_t gtime;
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+	cputime_t prev_utime, prev_stime;
+#endif
+	unsigned long nvcsw, nivcsw; /* context switch counts */
+	struct timespec start_time;		/* monotonic time */
+	struct timespec real_start_time;	/* boot based time */
+/* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
+	unsigned long min_flt, maj_flt;
+
+	struct task_cputime cputime_expires;
+	struct list_head cpu_timers[3];
+
+/* process credentials */
+	const struct cred __rcu *real_cred; /* objective and real subjective task
+					 * credentials (COW) */
+	const struct cred __rcu *cred;	/* effective (overridable) subjective task
+					 * credentials (COW) */
+	struct cred *replacement_session_keyring; /* for KEYCTL_SESSION_TO_PARENT */
+
+	char comm[TASK_COMM_LEN]; /* executable name excluding path
+				     - access with [gs]et_task_comm (which lock
+				       it with task_lock())
+				     - initialized normally by setup_new_exec */
+/* file system info */
+	int link_count, total_link_count;
+#ifdef CONFIG_SYSVIPC
+/* ipc stuff */
+	struct sysv_sem sysvsem;
+#endif
+#ifdef CONFIG_DETECT_HUNG_TASK
+/* hung task detection */
+	unsigned long last_switch_count;
+#endif
+/* CPU-specific state of this task */
+	struct thread_struct thread;
+/* filesystem information */
+	struct fs_struct *fs;
+/* open file information */
+	struct files_struct *files;
+/* namespaces */
+	struct nsproxy *nsproxy;
+/* signal handlers */
+	struct signal_struct *signal;
+	struct sighand_struct *sighand;
+
+	sigset_t blocked, real_blocked;
+	sigset_t saved_sigmask;	/* restored if set_restore_sigmask() was used */
+	struct sigpending pending;
+
+	unsigned long sas_ss_sp;
+	size_t sas_ss_size;
+	int (*notifier)(void *priv);
+	void *notifier_data;
+	sigset_t *notifier_mask;
+	struct audit_context *audit_context;
+#ifdef CONFIG_AUDITSYSCALL
+	uid_t loginuid;
+	unsigned int sessionid;
+#endif
+	seccomp_t seccomp;
+
+/* Thread group tracking */
+	u32 parent_exec_id;
+	u32 self_exec_id;
+/* Protection of (de-)allocation: mm, files, fs, tty, keyrings, mems_allowed,
+ * mempolicy */
+	spinlock_t alloc_lock;
+
+#ifdef CONFIG_GENERIC_HARDIRQS
+	/* IRQ handler threads */
+	struct irqaction *irqaction;
+#endif
+
+	/* Protection of the PI data structures: */
+	raw_spinlock_t pi_lock;
+
+#ifdef CONFIG_RT_MUTEXES
+	/* PI waiters blocked on a rt_mutex held by this task */
+	struct plist_head pi_waiters;
+	/* Deadlock detection and priority inheritance handling */
+	struct rt_mutex_waiter *pi_blocked_on;
+#endif
+
+#ifdef CONFIG_DEBUG_MUTEXES
+	/* mutex deadlock detection */
+	struct mutex_waiter *blocked_on;
+#endif
+#ifdef CONFIG_TRACE_IRQFLAGS
+	unsigned int irq_events;
+	unsigned long hardirq_enable_ip;
+	unsigned long hardirq_disable_ip;
+	unsigned int hardirq_enable_event;
+	unsigned int hardirq_disable_event;
+	int hardirqs_enabled;
+	int hardirq_context;
+	unsigned long softirq_disable_ip;
+	unsigned long softirq_enable_ip;
+	unsigned int softirq_disable_event;
+	unsigned int softirq_enable_event;
+	int softirqs_enabled;
+	int softirq_context;
+#endif
+#ifdef CONFIG_LOCKDEP
+# define MAX_LOCK_DEPTH 48UL
+	u64 curr_chain_key;
+	int lockdep_depth;
+	unsigned int lockdep_recursion;
+	struct held_lock held_locks[MAX_LOCK_DEPTH];
+	gfp_t lockdep_reclaim_gfp;
+#endif
+
+/* journalling filesystem info */
+	void *journal_info;
+
+/* stacked block device info */
+	struct bio_list *bio_list;
+
+/* VM state */
+	struct reclaim_state *reclaim_state;
+
+	struct backing_dev_info *backing_dev_info;
+
+	struct io_context *io_context;
+
+	unsigned long ptrace_message;
+	siginfo_t *last_siginfo; /* For ptrace use.  */
+	struct task_io_accounting ioac;
+#if defined(CONFIG_TASK_XACCT)
+	u64 acct_rss_mem1;	/* accumulated rss usage */
+	u64 acct_vm_mem1;	/* accumulated virtual memory usage */
+	cputime_t acct_timexpd;	/* stime + utime since last update */
+#endif
+#ifdef CONFIG_CPUSETS
+	nodemask_t mems_allowed;	/* Protected by alloc_lock */
+	int mems_allowed_change_disable;
+	int cpuset_mem_spread_rotor;
+	int cpuset_slab_spread_rotor;
+#endif
+#ifdef CONFIG_CGROUPS
+	/* Control Group info protected by css_set_lock */
+	struct css_set __rcu *cgroups;
+	/* cg_list protected by css_set_lock and tsk->alloc_lock */
+	struct list_head cg_list;
+#endif
+#ifdef CONFIG_FUTEX
+	struct robust_list_head __user *robust_list;
+#ifdef CONFIG_COMPAT
+	struct compat_robust_list_head __user *compat_robust_list;
+#endif
+	struct list_head pi_state_list;
+	struct futex_pi_state *pi_state_cache;
+#endif
+#ifdef CONFIG_PERF_EVENTS
+	struct perf_event_context *perf_event_ctxp[perf_nr_task_contexts];
+	struct mutex perf_event_mutex;
+	struct list_head perf_event_list;
+#endif
+#ifdef CONFIG_NUMA
+	struct mempolicy *mempolicy;	/* Protected by alloc_lock */
+	short il_next;
+#endif
+	atomic_t fs_excl;	/* holding fs exclusive resources */
+	struct rcu_head rcu;
+
+	/*
+	 * cache last used pipe for splice
+	 */
+	struct pipe_inode_info *splice_pipe;
+#ifdef	CONFIG_TASK_DELAY_ACCT
+	struct task_delay_info *delays;
+#endif
+#ifdef CONFIG_FAULT_INJECTION
+	int make_it_fail;
+#endif
+	struct prop_local_single dirties;
+#ifdef CONFIG_LATENCYTOP
+	int latency_record_count;
+	struct latency_record latency_record[LT_SAVECOUNT];
+#endif
+	/*
+	 * time slack values; these are used to round up poll() and
+	 * select() etc timeout values. These are in nanoseconds.
+	 */
+	unsigned long timer_slack_ns;
+	unsigned long default_timer_slack_ns;
+
+	struct list_head	*scm_work_list;
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	/* Index of current stored address in ret_stack */
+	int curr_ret_stack;
+	/* Stack of return addresses for return function tracing */
+	struct ftrace_ret_stack	*ret_stack;
+	/* time stamp for last schedule */
+	unsigned long long ftrace_timestamp;
+	/*
+	 * Number of functions that haven't been traced
+	 * because of depth overrun.
+	 */
+	atomic_t trace_overrun;
+	/* Pause for the tracing */
+	atomic_t tracing_graph_pause;
+#endif
+#ifdef CONFIG_TRACING
+	/* state flags for use by tracers */
+	unsigned long trace;
+	/* bitmask of trace recursion */
+	unsigned long trace_recursion;
+#endif /* CONFIG_TRACING */
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR /* memcg uses this to do batch job */
+	struct memcg_batch_info {
+		int do_batch;	/* incremented when batch uncharge started */
+		struct mem_cgroup *memcg; /* target memcg of uncharge */
+		unsigned long bytes;		/* uncharged usage */
+		unsigned long memsw_bytes; /* uncharged mem+swap usage */
+	} memcg_batch;
+#endif
+};
+
+#endif
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 167c333..160860f 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -1,14 +1,13 @@
 #ifndef _LINUX_SECCOMP_H
 #define _LINUX_SECCOMP_H
 
+#include <linux/seccomp_types.h>
 
 #ifdef CONFIG_SECCOMP
 
 #include <linux/thread_info.h>
 #include <asm/seccomp.h>
 
-typedef struct { int mode; } seccomp_t;
-
 extern void __secure_computing(int);
 static inline void secure_computing(int this_syscall)
 {
@@ -23,8 +22,6 @@ extern long prctl_set_seccomp(unsigned long);
 
 #include <linux/errno.h>
 
-typedef struct { } seccomp_t;
-
 #define secure_computing(x) do { } while (0)
 
 static inline long prctl_get_seccomp(void)
diff --git a/include/linux/seccomp_types.h b/include/linux/seccomp_types.h
new file mode 100644
index 0000000..6ccb36f
--- /dev/null
+++ b/include/linux/seccomp_types.h
@@ -0,0 +1,12 @@
+#ifndef _LINUX_SECCOMP_TYPES_H
+#define _LINUX_SECCOMP_TYPES_H
+
+
+#ifdef CONFIG_SECCOMP
+typedef struct { int mode; } seccomp_t;
+#else
+typedef struct { } seccomp_t;
+#endif
+
+#endif
+
diff --git a/include/linux/sem.h b/include/linux/sem.h
index f2961af..e109ed2 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -2,6 +2,7 @@
 #define _LINUX_SEM_H
 
 #include <linux/ipc.h>
+#include <linux/sem_types.h>
 
 /* semop flags */
 #define SEM_UNDO        0x1000  /* undo the operation on exit */
@@ -138,10 +139,6 @@ struct sem_undo_list {
 	struct list_head	list_proc;
 };
 
-struct sysv_sem {
-	struct sem_undo_list *undo_list;
-};
-
 #ifdef CONFIG_SYSVIPC
 
 extern int copy_semundo(unsigned long clone_flags, struct task_struct *tsk);
diff --git a/include/linux/sem_types.h b/include/linux/sem_types.h
new file mode 100644
index 0000000..4b938c3
--- /dev/null
+++ b/include/linux/sem_types.h
@@ -0,0 +1,10 @@
+#ifndef _LINUX_SEM_TYPES_H
+#define _LINUX_SEM_TYPES_H
+
+struct sem_undo_list;
+
+struct sysv_sem {
+	struct sem_undo_list *undo_list;
+};
+
+#endif
diff --git a/include/linux/task_io_accounting.h b/include/linux/task_io_accounting.h
index bdf855c..777cdef 100644
--- a/include/linux/task_io_accounting.h
+++ b/include/linux/task_io_accounting.h
@@ -8,6 +8,8 @@
  * Blame Andrew Morton for all this.
  */
 
+#include <linux/types.h>
+
 struct task_io_accounting {
 #ifdef CONFIG_TASK_XACCT
 	/* bytes read */
