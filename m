Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1AFJIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:08:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52429 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab1AFJIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:08:35 -0500
Date: Thu, 6 Jan 2011 10:08:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v2.6.38
Message-ID: <20110106090808.GA15170@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-rcu-for-linus

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (2):
      rcu: Stop chasing QS if another CPU did it for us
      rcu: Keep gpnum and completed fields synchronized

Lai Jiangshan (2):
      rcu,cleanup: move synchronize_sched_expedited() out of sched.c
      rcu,cleanup: simplify the code when cpu is dying

Mariusz Kozlowski (1):
      rculist: fix borked __list_for_each_rcu() macro

Paul E. McKenney (14):
      rcu: add priority-inversion testing to rcutorture
      rcu: move TINY_RCU from softirq to kthread
      rcu: priority boosting for TINY_PREEMPT_RCU
      rcu: add tracing for TINY_RCU and TINY_PREEMPT_RCU
      rcu: document TINY_RCU and TINY_PREEMPT_RCU tracing.
      rcu: Distinguish between boosting and boosted
      rcu: get rid of obsolete "classic" names in TREE_RCU tracing
      rcu: update documentation/comments for Lai's adoption patch
      rcu: fix race condition in synchronize_sched_expedited()
      rcu: Make synchronize_srcu_expedited() fast if running readers
      rcu: fine-tune grace-period begin/end checks
      rcu: limit rcu_node leaf-level fanout
      rcu: reduce __call_rcu()-induced contention on rcu_node structures
      rcu: remove unused __list_for_each_rcu() macro

Tejun Heo (1):
      rcu: increase synchronize_sched_expedited() batching


 Documentation/RCU/trace.txt |  144 +++++++++++++--
 include/linux/init_task.h   |    9 +-
 include/linux/rculist.h     |    5 -
 include/linux/rcupdate.h    |    4 +-
 include/linux/rcutiny.h     |   13 +-
 include/linux/rcutree.h     |    2 +
 include/linux/sched.h       |   11 +-
 init/Kconfig                |   55 ++++++-
 kernel/rcutiny.c            |  105 +++++++----
 kernel/rcutiny_plugin.h     |  433 +++++++++++++++++++++++++++++++++++++++++--
 kernel/rcutorture.c         |  270 ++++++++++++++++++++++++++-
 kernel/rcutree.c            |  156 ++++++++--------
 kernel/rcutree.h            |   61 +++----
 kernel/rcutree_plugin.h     |  135 +++++++++++++-
 kernel/rcutree_trace.c      |   12 +-
 kernel/sched.c              |   69 -------
 kernel/srcu.c               |    8 +-
 17 files changed, 1207 insertions(+), 285 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index a851118..6a8c73f 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -1,18 +1,22 @@
 CONFIG_RCU_TRACE debugfs Files and Formats
 
 
-The rcutree implementation of RCU provides debugfs trace output that
-summarizes counters and state.  This information is useful for debugging
-RCU itself, and can sometimes also help to debug abuses of RCU.
-The following sections describe the debugfs files and formats.
+The rcutree and rcutiny implementations of RCU provide debugfs trace
+output that summarizes counters and state.  This information is useful for
+debugging RCU itself, and can sometimes also help to debug abuses of RCU.
+The following sections describe the debugfs files and formats, first
+for rcutree and next for rcutiny.
 
 
-Hierarchical RCU debugfs Files and Formats
+CONFIG_TREE_RCU and CONFIG_TREE_PREEMPT_RCU debugfs Files and Formats
 
-This implementation of RCU provides three debugfs files under the
+These implementations of RCU provides five debugfs files under the
 top-level directory RCU: rcu/rcudata (which displays fields in struct
-rcu_data), rcu/rcugp (which displays grace-period counters), and
-rcu/rcuhier (which displays the struct rcu_node hierarchy).
+rcu_data), rcu/rcudata.csv (which is a .csv spreadsheet version of
+rcu/rcudata), rcu/rcugp (which displays grace-period counters),
+rcu/rcuhier (which displays the struct rcu_node hierarchy), and
+rcu/rcu_pending (which displays counts of the reasons that the
+rcu_pending() function decided that there was core RCU work to do).
 
 The output of "cat rcu/rcudata" looks as follows:
 
@@ -130,7 +134,8 @@ o	"ci" is the number of RCU callbacks that have been invoked for
 	been registered in absence of CPU-hotplug activity.
 
 o	"co" is the number of RCU callbacks that have been orphaned due to
-	this CPU going offline.
+	this CPU going offline.  These orphaned callbacks have been moved
+	to an arbitrarily chosen online CPU.
 
 o	"ca" is the number of RCU callbacks that have been adopted due to
 	other CPUs going offline.  Note that ci+co-ca+ql is the number of
@@ -168,12 +173,12 @@ o	"gpnum" is the number of grace periods that have started.  It is
 
 The output of "cat rcu/rcuhier" looks as follows, with very long lines:
 
-c=6902 g=6903 s=2 jfq=3 j=72c7 nfqs=13142/nfqsng=0(13142) fqlh=6 oqlen=0
+c=6902 g=6903 s=2 jfq=3 j=72c7 nfqs=13142/nfqsng=0(13142) fqlh=6
 1/1 .>. 0:127 ^0    
 3/3 .>. 0:35 ^0    0/0 .>. 36:71 ^1    0/0 .>. 72:107 ^2    0/0 .>. 108:127 ^3    
 3/3f .>. 0:5 ^0    2/3 .>. 6:11 ^1    0/0 .>. 12:17 ^2    0/0 .>. 18:23 ^3    0/0 .>. 24:29 ^4    0/0 .>. 30:35 ^5    0/0 .>. 36:41 ^0    0/0 .>. 42:47 ^1    0/0 .>. 48:53 ^2    0/0 .>. 54:59 ^3    0/0 .>. 60:65 ^4    0/0 .>. 66:71 ^5    0/0 .>. 72:77 ^0    0/0 .>. 78:83 ^1    0/0 .>. 84:89 ^2    0/0 .>. 90:95 ^3    0/0 .>. 96:101 ^4    0/0 .>. 102:107 ^5    0/0 .>. 108:113 ^0    0/0 .>. 114:119 ^1    0/0 .>. 120:125 ^2    0/0 .>. 126:127 ^3    
 rcu_bh:
-c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0 oqlen=0
+c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0
 0/1 .>. 0:127 ^0    
 0/3 .>. 0:35 ^0    0/0 .>. 36:71 ^1    0/0 .>. 72:107 ^2    0/0 .>. 108:127 ^3    
 0/3f .>. 0:5 ^0    0/3 .>. 6:11 ^1    0/0 .>. 12:17 ^2    0/0 .>. 18:23 ^3    0/0 .>. 24:29 ^4    0/0 .>. 30:35 ^5    0/0 .>. 36:41 ^0    0/0 .>. 42:47 ^1    0/0 .>. 48:53 ^2    0/0 .>. 54:59 ^3    0/0 .>. 60:65 ^4    0/0 .>. 66:71 ^5    0/0 .>. 72:77 ^0    0/0 .>. 78:83 ^1    0/0 .>. 84:89 ^2    0/0 .>. 90:95 ^3    0/0 .>. 96:101 ^4    0/0 .>. 102:107 ^5    0/0 .>. 108:113 ^0    0/0 .>. 114:119 ^1    0/0 .>. 120:125 ^2    0/0 .>. 126:127 ^3
@@ -212,11 +217,6 @@ o	"fqlh" is the number of calls to force_quiescent_state() that
 	exited immediately (without even being counted in nfqs above)
 	due to contention on ->fqslock.
 
-o	"oqlen" is the number of callbacks on the "orphan" callback
-	list.  RCU callbacks are placed on this list by CPUs going
-	offline, and are "adopted" either by the CPU helping the outgoing
-	CPU or by the next rcu_barrier*() call, whichever comes first.
-
 o	Each element of the form "1/1 0:127 ^0" represents one struct
 	rcu_node.  Each line represents one level of the hierarchy, from
 	root to leaves.  It is best to think of the rcu_data structures
@@ -326,3 +326,115 @@ o	"nn" is the number of times that this CPU needed nothing.  Alert
 	readers will note that the rcu "nn" number for a given CPU very
 	closely matches the rcu_bh "np" number for that same CPU.  This
 	is due to short-circuit evaluation in rcu_pending().
+
+
+CONFIG_TINY_RCU and CONFIG_TINY_PREEMPT_RCU debugfs Files and Formats
+
+These implementations of RCU provides a single debugfs file under the
+top-level directory RCU, namely rcu/rcudata, which displays fields in
+rcu_bh_ctrlblk, rcu_sched_ctrlblk and, for CONFIG_TINY_PREEMPT_RCU,
+rcu_preempt_ctrlblk.
+
+The output of "cat rcu/rcudata" is as follows:
+
+rcu_preempt: qlen=24 gp=1097669 g197/p197/c197 tasks=...
+             ttb=. btg=no ntb=184 neb=0 nnb=183 j=01f7 bt=0274
+             normal balk: nt=1097669 gt=0 bt=371 b=0 ny=25073378 nos=0
+             exp balk: bt=0 nos=0
+rcu_sched: qlen: 0
+rcu_bh: qlen: 0
+
+This is split into rcu_preempt, rcu_sched, and rcu_bh sections, with the
+rcu_preempt section appearing only in CONFIG_TINY_PREEMPT_RCU builds.
+The last three lines of the rcu_preempt section appear only in
+CONFIG_RCU_BOOST kernel builds.  The fields are as follows:
+
+o	"qlen" is the number of RCU callbacks currently waiting either
+	for an RCU grace period or waiting to be invoked.  This is the
+	only field present for rcu_sched and rcu_bh, due to the
+	short-circuiting of grace period in those two cases.
+
+o	"gp" is the number of grace periods that have completed.
+
+o	"g197/p197/c197" displays the grace-period state, with the
+	"g" number being the number of grace periods that have started
+	(mod 256), the "p" number being the number of grace periods
+	that the CPU has responded to (also mod 256), and the "c"
+	number being the number of grace periods that have completed
+	(once again mode 256).
+
+	Why have both "gp" and "g"?  Because the data flowing into
+	"gp" is only present in a CONFIG_RCU_TRACE kernel.
+
+o	"tasks" is a set of bits.  The first bit is "T" if there are
+	currently tasks that have recently blocked within an RCU
+	read-side critical section, the second bit is "N" if any of the
+	aforementioned tasks are blocking the current RCU grace period,
+	and the third bit is "E" if any of the aforementioned tasks are
+	blocking the current expedited grace period.  Each bit is "."
+	if the corresponding condition does not hold.
+
+o	"ttb" is a single bit.  It is "B" if any of the blocked tasks
+	need to be priority boosted and "." otherwise.
+
+o	"btg" indicates whether boosting has been carried out during
+	the current grace period, with "exp" indicating that boosting
+	is in progress for an expedited grace period, "no" indicating
+	that boosting has not yet started for a normal grace period,
+	"begun" indicating that boosting has bebug for a normal grace
+	period, and "done" indicating that boosting has completed for
+	a normal grace period.
+
+o	"ntb" is the total number of tasks subjected to RCU priority boosting
+	periods since boot.
+
+o	"neb" is the number of expedited grace periods that have had
+	to resort to RCU priority boosting since boot.
+
+o	"nnb" is the number of normal grace periods that have had
+	to resort to RCU priority boosting since boot.
+
+o	"j" is the low-order 12 bits of the jiffies counter in hexadecimal.
+
+o	"bt" is the low-order 12 bits of the value that the jiffies counter
+	will have at the next time that boosting is scheduled to begin.
+
+o	In the line beginning with "normal balk", the fields are as follows:
+
+	o	"nt" is the number of times that the system balked from
+		boosting because there were no blocked tasks to boost.
+		Note that the system will balk from boosting even if the
+		grace period is overdue when the currently running task
+		is looping within an RCU read-side critical section.
+		There is no point in boosting in this case, because
+		boosting a running task won't make it run any faster.
+
+	o	"gt" is the number of times that the system balked
+		from boosting because, although there were blocked tasks,
+		none of them were preventing the current grace period
+		from completing.
+
+	o	"bt" is the number of times that the system balked
+		from boosting because boosting was already in progress.
+
+	o	"b" is the number of times that the system balked from
+		boosting because boosting had already completed for
+		the grace period in question.
+
+	o	"ny" is the number of times that the system balked from
+		boosting because it was not yet time to start boosting
+		the grace period in question.
+
+	o	"nos" is the number of times that the system balked from
+		boosting for inexplicable ("not otherwise specified")
+		reasons.  This can actually happen due to races involving
+		increments of the jiffies counter.
+
+o	In the line beginning with "exp balk", the fields are as follows:
+
+	o	"bt" is the number of times that the system balked from
+		boosting because there were no blocked tasks to boost.
+
+	o	"nos" is the number of times that the system balked from
+		 boosting for inexplicable ("not otherwise specified")
+		 reasons.
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 1f8c06c..6b281fa 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -83,6 +83,12 @@ extern struct group_info init_groups;
  */
 # define CAP_INIT_BSET  CAP_FULL_SET
 
+#ifdef CONFIG_RCU_BOOST
+#define INIT_TASK_RCU_BOOST()						\
+	.rcu_boost_mutex = NULL,
+#else
+#define INIT_TASK_RCU_BOOST()
+#endif
 #ifdef CONFIG_TREE_PREEMPT_RCU
 #define INIT_TASK_RCU_TREE_PREEMPT()					\
 	.rcu_blocked_node = NULL,
@@ -94,7 +100,8 @@ extern struct group_info init_groups;
 	.rcu_read_lock_nesting = 0,					\
 	.rcu_read_unlock_special = 0,					\
 	.rcu_node_entry = LIST_HEAD_INIT(tsk.rcu_node_entry),		\
-	INIT_TASK_RCU_TREE_PREEMPT()
+	INIT_TASK_RCU_TREE_PREEMPT()					\
+	INIT_TASK_RCU_BOOST()
 #else
 #define INIT_TASK_RCU_PREEMPT(tsk)
 #endif
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index f31ef61..2dea94f 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -241,11 +241,6 @@ static inline void list_splice_init_rcu(struct list_head *list,
 #define list_first_entry_rcu(ptr, type, member) \
 	list_entry_rcu((ptr)->next, type, member)
 
-#define __list_for_each_rcu(pos, head) \
-	for (pos = rcu_dereference_raw(list_next_rcu(head)); \
-		pos != (head); \
-		pos = rcu_dereference_raw(list_next_rcu((pos)))
-
 /**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
  * @pos:	the type * to use as a loop cursor.
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 03cda7b..af56148 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -47,6 +47,8 @@
 extern int rcutorture_runnable; /* for sysctl */
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
+#define UINT_CMP_GE(a, b)	(UINT_MAX / 2 >= (a) - (b))
+#define UINT_CMP_LT(a, b)	(UINT_MAX / 2 < (a) - (b))
 #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
 #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
 
@@ -66,7 +68,6 @@ extern void call_rcu_sched(struct rcu_head *head,
 extern void synchronize_sched(void);
 extern void rcu_barrier_bh(void);
 extern void rcu_barrier_sched(void);
-extern void synchronize_sched_expedited(void);
 extern int sched_expedited_torture_stats(char *page);
 
 static inline void __rcu_read_lock_bh(void)
@@ -118,7 +119,6 @@ static inline int rcu_preempt_depth(void)
 #endif /* #else #ifdef CONFIG_PREEMPT_RCU */
 
 /* Internal to kernel */
-extern void rcu_init(void);
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern void rcu_check_callbacks(int cpu, int user);
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 13877cb..30ebd7c 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -27,7 +27,9 @@
 
 #include <linux/cache.h>
 
-#define rcu_init_sched()	do { } while (0)
+static inline void rcu_init(void)
+{
+}
 
 #ifdef CONFIG_TINY_RCU
 
@@ -58,6 +60,11 @@ static inline void synchronize_rcu_bh_expedited(void)
 	synchronize_sched();
 }
 
+static inline void synchronize_sched_expedited(void)
+{
+	synchronize_sched();
+}
+
 #ifdef CONFIG_TINY_RCU
 
 static inline void rcu_preempt_note_context_switch(void)
@@ -125,16 +132,12 @@ static inline void rcu_cpu_stall_reset(void)
 }
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-
 extern int rcu_scheduler_active __read_mostly;
 extern void rcu_scheduler_starting(void);
-
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
-
 static inline void rcu_scheduler_starting(void)
 {
 }
-
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 #endif /* __LINUX_RCUTINY_H */
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 95518e6..3a93348 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -30,6 +30,7 @@
 #ifndef __LINUX_RCUTREE_H
 #define __LINUX_RCUTREE_H
 
+extern void rcu_init(void);
 extern void rcu_note_context_switch(int cpu);
 extern int rcu_needs_cpu(int cpu);
 extern void rcu_cpu_stall_reset(void);
@@ -47,6 +48,7 @@ static inline void exit_rcu(void)
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 extern void synchronize_rcu_bh(void);
+extern void synchronize_sched_expedited(void);
 extern void synchronize_rcu_expedited(void);
 
 static inline void synchronize_rcu_bh_expedited(void)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2238745..d800550 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1229,6 +1229,9 @@ struct task_struct {
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	struct rcu_node *rcu_blocked_node;
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#ifdef CONFIG_RCU_BOOST
+	struct rt_mutex *rcu_boost_mutex;
+#endif /* #ifdef CONFIG_RCU_BOOST */
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
@@ -1759,7 +1762,8 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #ifdef CONFIG_PREEMPT_RCU
 
 #define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
-#define RCU_READ_UNLOCK_NEED_QS (1 << 1) /* RCU core needs CPU response. */
+#define RCU_READ_UNLOCK_BOOSTED (1 << 1) /* boosted while in RCU read-side. */
+#define RCU_READ_UNLOCK_NEED_QS (1 << 2) /* RCU core needs CPU response. */
 
 static inline void rcu_copy_process(struct task_struct *p)
 {
@@ -1767,7 +1771,10 @@ static inline void rcu_copy_process(struct task_struct *p)
 	p->rcu_read_unlock_special = 0;
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	p->rcu_blocked_node = NULL;
-#endif
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#ifdef CONFIG_RCU_BOOST
+	p->rcu_boost_mutex = NULL;
+#endif /* #ifdef CONFIG_RCU_BOOST */
 	INIT_LIST_HEAD(&p->rcu_node_entry);
 }
 
diff --git a/init/Kconfig b/init/Kconfig
index c972899..526ec1c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -393,7 +393,6 @@ config PREEMPT_RCU
 
 config RCU_TRACE
 	bool "Enable tracing for RCU"
-	depends on TREE_RCU || TREE_PREEMPT_RCU
 	help
 	  This option provides tracing in RCU which presents stats
 	  in debugfs for debugging RCU implementation.
@@ -459,6 +458,60 @@ config TREE_RCU_TRACE
 	  TREE_PREEMPT_RCU implementations, permitting Makefile to
 	  trivially select kernel/rcutree_trace.c.
 
+config RCU_BOOST
+	bool "Enable RCU priority boosting"
+	depends on RT_MUTEXES && TINY_PREEMPT_RCU
+	default n
+	help
+	  This option boosts the priority of preempted RCU readers that
+	  block the current preemptible RCU grace period for too long.
+	  This option also prevents heavy loads from blocking RCU
+	  callback invocation for all flavors of RCU.
+
+	  Say Y here if you are working with real-time apps or heavy loads
+	  Say N here if you are unsure.
+
+config RCU_BOOST_PRIO
+	int "Real-time priority to boost RCU readers to"
+	range 1 99
+	depends on RCU_BOOST
+	default 1
+	help
+	  This option specifies the real-time priority to which preempted
+	  RCU readers are to be boosted.  If you are working with CPU-bound
+	  real-time applications, you should specify a priority higher then
+	  the highest-priority CPU-bound application.
+
+	  Specify the real-time priority, or take the default if unsure.
+
+config RCU_BOOST_DELAY
+	int "Milliseconds to delay boosting after RCU grace-period start"
+	range 0 3000
+	depends on RCU_BOOST
+	default 500
+	help
+	  This option specifies the time to wait after the beginning of
+	  a given grace period before priority-boosting preempted RCU
+	  readers blocking that grace period.  Note that any RCU reader
+	  blocking an expedited RCU grace period is boosted immediately.
+
+	  Accept the default if unsure.
+
+config SRCU_SYNCHRONIZE_DELAY
+	int "Microseconds to delay before waiting for readers"
+	range 0 20
+	default 10
+	help
+	  This option controls how long SRCU delays before entering its
+	  loop waiting on SRCU readers.  The purpose of this loop is
+	  to avoid the unconditional context-switch penalty that would
+	  otherwise be incurred if there was an active SRCU reader,
+	  in a manner similar to adaptive locking schemes.  This should
+	  be set to be a bit longer than the common-case SRCU read-side
+	  critical-section overhead.
+
+	  Accept the default if unsure.
+
 endmenu # "RCU Subsystem"
 
 config IKCONFIG
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index d806735..0344937 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -36,31 +36,16 @@
 #include <linux/time.h>
 #include <linux/cpu.h>
 
-/* Global control variables for rcupdate callback mechanism. */
-struct rcu_ctrlblk {
-	struct rcu_head *rcucblist;	/* List of pending callbacks (CBs). */
-	struct rcu_head **donetail;	/* ->next pointer of last "done" CB. */
-	struct rcu_head **curtail;	/* ->next pointer of last CB. */
-};
-
-/* Definition for rcupdate control block. */
-static struct rcu_ctrlblk rcu_sched_ctrlblk = {
-	.donetail	= &rcu_sched_ctrlblk.rcucblist,
-	.curtail	= &rcu_sched_ctrlblk.rcucblist,
-};
-
-static struct rcu_ctrlblk rcu_bh_ctrlblk = {
-	.donetail	= &rcu_bh_ctrlblk.rcucblist,
-	.curtail	= &rcu_bh_ctrlblk.rcucblist,
-};
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-int rcu_scheduler_active __read_mostly;
-EXPORT_SYMBOL_GPL(rcu_scheduler_active);
-#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+/* Controls for rcu_kthread() kthread, replacing RCU_SOFTIRQ used previously. */
+static struct task_struct *rcu_kthread_task;
+static DECLARE_WAIT_QUEUE_HEAD(rcu_kthread_wq);
+static unsigned long have_rcu_kthread_work;
+static void invoke_rcu_kthread(void);
 
 /* Forward declarations for rcutiny_plugin.h. */
-static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp);
+struct rcu_ctrlblk;
+static void rcu_process_callbacks(struct rcu_ctrlblk *rcp);
+static int rcu_kthread(void *arg);
 static void __call_rcu(struct rcu_head *head,
 		       void (*func)(struct rcu_head *rcu),
 		       struct rcu_ctrlblk *rcp);
@@ -123,7 +108,7 @@ void rcu_sched_qs(int cpu)
 {
 	if (rcu_qsctr_help(&rcu_sched_ctrlblk) +
 	    rcu_qsctr_help(&rcu_bh_ctrlblk))
-		raise_softirq(RCU_SOFTIRQ);
+		invoke_rcu_kthread();
 }
 
 /*
@@ -132,7 +117,7 @@ void rcu_sched_qs(int cpu)
 void rcu_bh_qs(int cpu)
 {
 	if (rcu_qsctr_help(&rcu_bh_ctrlblk))
-		raise_softirq(RCU_SOFTIRQ);
+		invoke_rcu_kthread();
 }
 
 /*
@@ -152,13 +137,14 @@ void rcu_check_callbacks(int cpu, int user)
 }
 
 /*
- * Helper function for rcu_process_callbacks() that operates on the
- * specified rcu_ctrlkblk structure.
+ * Invoke the RCU callbacks on the specified rcu_ctrlkblk structure
+ * whose grace period has elapsed.
  */
-static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
+static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 {
 	struct rcu_head *next, *list;
 	unsigned long flags;
+	RCU_TRACE(int cb_count = 0);
 
 	/* If no RCU callbacks ready to invoke, just return. */
 	if (&rcp->rcucblist == rcp->donetail)
@@ -180,19 +166,58 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 		next = list->next;
 		prefetch(next);
 		debug_rcu_head_unqueue(list);
+		local_bh_disable();
 		list->func(list);
+		local_bh_enable();
 		list = next;
+		RCU_TRACE(cb_count++);
 	}
+	RCU_TRACE(rcu_trace_sub_qlen(rcp, cb_count));
 }
 
 /*
- * Invoke any callbacks whose grace period has completed.
+ * This kthread invokes RCU callbacks whose grace periods have
+ * elapsed.  It is awakened as needed, and takes the place of the
+ * RCU_SOFTIRQ that was used previously for this purpose.
+ * This is a kthread, but it is never stopped, at least not until
+ * the system goes down.
  */
-static void rcu_process_callbacks(struct softirq_action *unused)
+static int rcu_kthread(void *arg)
 {
-	__rcu_process_callbacks(&rcu_sched_ctrlblk);
-	__rcu_process_callbacks(&rcu_bh_ctrlblk);
-	rcu_preempt_process_callbacks();
+	unsigned long work;
+	unsigned long morework;
+	unsigned long flags;
+
+	for (;;) {
+		wait_event(rcu_kthread_wq, have_rcu_kthread_work != 0);
+		morework = rcu_boost();
+		local_irq_save(flags);
+		work = have_rcu_kthread_work;
+		have_rcu_kthread_work = morework;
+		local_irq_restore(flags);
+		if (work) {
+			rcu_process_callbacks(&rcu_sched_ctrlblk);
+			rcu_process_callbacks(&rcu_bh_ctrlblk);
+			rcu_preempt_process_callbacks();
+		}
+		schedule_timeout_interruptible(1); /* Leave CPU for others. */
+	}
+
+	return 0;  /* Not reached, but needed to shut gcc up. */
+}
+
+/*
+ * Wake up rcu_kthread() to process callbacks now eligible for invocation
+ * or to boost readers.
+ */
+static void invoke_rcu_kthread(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	have_rcu_kthread_work = 1;
+	wake_up(&rcu_kthread_wq);
+	local_irq_restore(flags);
 }
 
 /*
@@ -230,6 +255,7 @@ static void __call_rcu(struct rcu_head *head,
 	local_irq_save(flags);
 	*rcp->curtail = head;
 	rcp->curtail = &head->next;
+	RCU_TRACE(rcp->qlen++);
 	local_irq_restore(flags);
 }
 
@@ -282,7 +308,16 @@ void rcu_barrier_sched(void)
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_sched);
 
-void __init rcu_init(void)
+/*
+ * Spawn the kthread that invokes RCU callbacks.
+ */
+static int __init rcu_spawn_kthreads(void)
 {
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+	struct sched_param sp;
+
+	rcu_kthread_task = kthread_run(rcu_kthread, NULL, "rcu_kthread");
+	sp.sched_priority = RCU_BOOST_PRIO;
+	sched_setscheduler_nocheck(rcu_kthread_task, SCHED_FIFO, &sp);
+	return 0;
 }
+early_initcall(rcu_spawn_kthreads);
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 6ceca4f..015abae 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -22,6 +22,40 @@
  * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
  */
 
+#include <linux/kthread.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#ifdef CONFIG_RCU_TRACE
+#define RCU_TRACE(stmt)	stmt
+#else /* #ifdef CONFIG_RCU_TRACE */
+#define RCU_TRACE(stmt)
+#endif /* #else #ifdef CONFIG_RCU_TRACE */
+
+/* Global control variables for rcupdate callback mechanism. */
+struct rcu_ctrlblk {
+	struct rcu_head *rcucblist;	/* List of pending callbacks (CBs). */
+	struct rcu_head **donetail;	/* ->next pointer of last "done" CB. */
+	struct rcu_head **curtail;	/* ->next pointer of last CB. */
+	RCU_TRACE(long qlen);		/* Number of pending CBs. */
+};
+
+/* Definition for rcupdate control block. */
+static struct rcu_ctrlblk rcu_sched_ctrlblk = {
+	.donetail	= &rcu_sched_ctrlblk.rcucblist,
+	.curtail	= &rcu_sched_ctrlblk.rcucblist,
+};
+
+static struct rcu_ctrlblk rcu_bh_ctrlblk = {
+	.donetail	= &rcu_bh_ctrlblk.rcucblist,
+	.curtail	= &rcu_bh_ctrlblk.rcucblist,
+};
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+int rcu_scheduler_active __read_mostly;
+EXPORT_SYMBOL_GPL(rcu_scheduler_active);
+#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 #ifdef CONFIG_TINY_PREEMPT_RCU
 
 #include <linux/delay.h>
@@ -46,17 +80,45 @@ struct rcu_preempt_ctrlblk {
 	struct list_head *gp_tasks;
 				/* Pointer to the first task blocking the */
 				/*  current grace period, or NULL if there */
-				/*  is not such task. */
+				/*  is no such task. */
 	struct list_head *exp_tasks;
 				/* Pointer to first task blocking the */
 				/*  current expedited grace period, or NULL */
 				/*  if there is no such task.  If there */
 				/*  is no current expedited grace period, */
 				/*  then there cannot be any such task. */
+#ifdef CONFIG_RCU_BOOST
+	struct list_head *boost_tasks;
+				/* Pointer to first task that needs to be */
+				/*  priority-boosted, or NULL if no priority */
+				/*  boosting is needed.  If there is no */
+				/*  current or expedited grace period, there */
+				/*  can be no such task. */
+#endif /* #ifdef CONFIG_RCU_BOOST */
 	u8 gpnum;		/* Current grace period. */
 	u8 gpcpu;		/* Last grace period blocked by the CPU. */
 	u8 completed;		/* Last grace period completed. */
 				/*  If all three are equal, RCU is idle. */
+#ifdef CONFIG_RCU_BOOST
+	s8 boosted_this_gp;	/* Has boosting already happened? */
+	unsigned long boost_time; /* When to start boosting (jiffies) */
+#endif /* #ifdef CONFIG_RCU_BOOST */
+#ifdef CONFIG_RCU_TRACE
+	unsigned long n_grace_periods;
+#ifdef CONFIG_RCU_BOOST
+	unsigned long n_tasks_boosted;
+	unsigned long n_exp_boosts;
+	unsigned long n_normal_boosts;
+	unsigned long n_normal_balk_blkd_tasks;
+	unsigned long n_normal_balk_gp_tasks;
+	unsigned long n_normal_balk_boost_tasks;
+	unsigned long n_normal_balk_boosted;
+	unsigned long n_normal_balk_notyet;
+	unsigned long n_normal_balk_nos;
+	unsigned long n_exp_balk_blkd_tasks;
+	unsigned long n_exp_balk_nos;
+#endif /* #ifdef CONFIG_RCU_BOOST */
+#endif /* #ifdef CONFIG_RCU_TRACE */
 };
 
 static struct rcu_preempt_ctrlblk rcu_preempt_ctrlblk = {
@@ -122,6 +184,210 @@ static int rcu_preempt_gp_in_progress(void)
 }
 
 /*
+ * Advance a ->blkd_tasks-list pointer to the next entry, instead
+ * returning NULL if at the end of the list.
+ */
+static struct list_head *rcu_next_node_entry(struct task_struct *t)
+{
+	struct list_head *np;
+
+	np = t->rcu_node_entry.next;
+	if (np == &rcu_preempt_ctrlblk.blkd_tasks)
+		np = NULL;
+	return np;
+}
+
+#ifdef CONFIG_RCU_TRACE
+
+#ifdef CONFIG_RCU_BOOST
+static void rcu_initiate_boost_trace(void);
+static void rcu_initiate_exp_boost_trace(void);
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
+/*
+ * Dump additional statistice for TINY_PREEMPT_RCU.
+ */
+static void show_tiny_preempt_stats(struct seq_file *m)
+{
+	seq_printf(m, "rcu_preempt: qlen=%ld gp=%lu g%u/p%u/c%u tasks=%c%c%c\n",
+		   rcu_preempt_ctrlblk.rcb.qlen,
+		   rcu_preempt_ctrlblk.n_grace_periods,
+		   rcu_preempt_ctrlblk.gpnum,
+		   rcu_preempt_ctrlblk.gpcpu,
+		   rcu_preempt_ctrlblk.completed,
+		   "T."[list_empty(&rcu_preempt_ctrlblk.blkd_tasks)],
+		   "N."[!rcu_preempt_ctrlblk.gp_tasks],
+		   "E."[!rcu_preempt_ctrlblk.exp_tasks]);
+#ifdef CONFIG_RCU_BOOST
+	seq_printf(m, "             ttb=%c btg=",
+		   "B."[!rcu_preempt_ctrlblk.boost_tasks]);
+	switch (rcu_preempt_ctrlblk.boosted_this_gp) {
+	case -1:
+		seq_puts(m, "exp");
+		break;
+	case 0:
+		seq_puts(m, "no");
+		break;
+	case 1:
+		seq_puts(m, "begun");
+		break;
+	case 2:
+		seq_puts(m, "done");
+		break;
+	default:
+		seq_printf(m, "?%d?", rcu_preempt_ctrlblk.boosted_this_gp);
+	}
+	seq_printf(m, " ntb=%lu neb=%lu nnb=%lu j=%04x bt=%04x\n",
+		   rcu_preempt_ctrlblk.n_tasks_boosted,
+		   rcu_preempt_ctrlblk.n_exp_boosts,
+		   rcu_preempt_ctrlblk.n_normal_boosts,
+		   (int)(jiffies & 0xffff),
+		   (int)(rcu_preempt_ctrlblk.boost_time & 0xffff));
+	seq_printf(m, "             %s: nt=%lu gt=%lu bt=%lu b=%lu ny=%lu nos=%lu\n",
+		   "normal balk",
+		   rcu_preempt_ctrlblk.n_normal_balk_blkd_tasks,
+		   rcu_preempt_ctrlblk.n_normal_balk_gp_tasks,
+		   rcu_preempt_ctrlblk.n_normal_balk_boost_tasks,
+		   rcu_preempt_ctrlblk.n_normal_balk_boosted,
+		   rcu_preempt_ctrlblk.n_normal_balk_notyet,
+		   rcu_preempt_ctrlblk.n_normal_balk_nos);
+	seq_printf(m, "             exp balk: bt=%lu nos=%lu\n",
+		   rcu_preempt_ctrlblk.n_exp_balk_blkd_tasks,
+		   rcu_preempt_ctrlblk.n_exp_balk_nos);
+#endif /* #ifdef CONFIG_RCU_BOOST */
+}
+
+#endif /* #ifdef CONFIG_RCU_TRACE */
+
+#ifdef CONFIG_RCU_BOOST
+
+#include "rtmutex_common.h"
+
+/*
+ * Carry out RCU priority boosting on the task indicated by ->boost_tasks,
+ * and advance ->boost_tasks to the next task in the ->blkd_tasks list.
+ */
+static int rcu_boost(void)
+{
+	unsigned long flags;
+	struct rt_mutex mtx;
+	struct list_head *np;
+	struct task_struct *t;
+
+	if (rcu_preempt_ctrlblk.boost_tasks == NULL)
+		return 0;  /* Nothing to boost. */
+	raw_local_irq_save(flags);
+	rcu_preempt_ctrlblk.boosted_this_gp++;
+	t = container_of(rcu_preempt_ctrlblk.boost_tasks, struct task_struct,
+			 rcu_node_entry);
+	np = rcu_next_node_entry(t);
+	rt_mutex_init_proxy_locked(&mtx, t);
+	t->rcu_boost_mutex = &mtx;
+	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
+	raw_local_irq_restore(flags);
+	rt_mutex_lock(&mtx);
+	RCU_TRACE(rcu_preempt_ctrlblk.n_tasks_boosted++);
+	rcu_preempt_ctrlblk.boosted_this_gp++;
+	rt_mutex_unlock(&mtx);
+	return rcu_preempt_ctrlblk.boost_tasks != NULL;
+}
+
+/*
+ * Check to see if it is now time to start boosting RCU readers blocking
+ * the current grace period, and, if so, tell the rcu_kthread_task to
+ * start boosting them.  If there is an expedited boost in progress,
+ * we wait for it to complete.
+ *
+ * If there are no blocked readers blocking the current grace period,
+ * return 0 to let the caller know, otherwise return 1.  Note that this
+ * return value is independent of whether or not boosting was done.
+ */
+static int rcu_initiate_boost(void)
+{
+	if (!rcu_preempt_blocked_readers_cgp()) {
+		RCU_TRACE(rcu_preempt_ctrlblk.n_normal_balk_blkd_tasks++);
+		return 0;
+	}
+	if (rcu_preempt_ctrlblk.gp_tasks != NULL &&
+	    rcu_preempt_ctrlblk.boost_tasks == NULL &&
+	    rcu_preempt_ctrlblk.boosted_this_gp == 0 &&
+	    ULONG_CMP_GE(jiffies, rcu_preempt_ctrlblk.boost_time)) {
+		rcu_preempt_ctrlblk.boost_tasks = rcu_preempt_ctrlblk.gp_tasks;
+		invoke_rcu_kthread();
+		RCU_TRACE(rcu_preempt_ctrlblk.n_normal_boosts++);
+	} else
+		RCU_TRACE(rcu_initiate_boost_trace());
+	return 1;
+}
+
+/*
+ * Initiate boosting for an expedited grace period.
+ */
+static void rcu_initiate_expedited_boost(void)
+{
+	unsigned long flags;
+
+	raw_local_irq_save(flags);
+	if (!list_empty(&rcu_preempt_ctrlblk.blkd_tasks)) {
+		rcu_preempt_ctrlblk.boost_tasks =
+			rcu_preempt_ctrlblk.blkd_tasks.next;
+		rcu_preempt_ctrlblk.boosted_this_gp = -1;
+		invoke_rcu_kthread();
+		RCU_TRACE(rcu_preempt_ctrlblk.n_exp_boosts++);
+	} else
+		RCU_TRACE(rcu_initiate_exp_boost_trace());
+	raw_local_irq_restore(flags);
+}
+
+#define RCU_BOOST_DELAY_JIFFIES DIV_ROUND_UP(CONFIG_RCU_BOOST_DELAY * HZ, 1000);
+
+/*
+ * Do priority-boost accounting for the start of a new grace period.
+ */
+static void rcu_preempt_boost_start_gp(void)
+{
+	rcu_preempt_ctrlblk.boost_time = jiffies + RCU_BOOST_DELAY_JIFFIES;
+	if (rcu_preempt_ctrlblk.boosted_this_gp > 0)
+		rcu_preempt_ctrlblk.boosted_this_gp = 0;
+}
+
+#else /* #ifdef CONFIG_RCU_BOOST */
+
+/*
+ * If there is no RCU priority boosting, we don't boost.
+ */
+static int rcu_boost(void)
+{
+	return 0;
+}
+
+/*
+ * If there is no RCU priority boosting, we don't initiate boosting,
+ * but we do indicate whether there are blocked readers blocking the
+ * current grace period.
+ */
+static int rcu_initiate_boost(void)
+{
+	return rcu_preempt_blocked_readers_cgp();
+}
+
+/*
+ * If there is no RCU priority boosting, we don't initiate expedited boosting.
+ */
+static void rcu_initiate_expedited_boost(void)
+{
+}
+
+/*
+ * If there is no RCU priority boosting, nothing to do at grace-period start.
+ */
+static void rcu_preempt_boost_start_gp(void)
+{
+}
+
+#endif /* else #ifdef CONFIG_RCU_BOOST */
+
+/*
  * Record a preemptible-RCU quiescent state for the specified CPU.  Note
  * that this just means that the task currently running on the CPU is
  * in a quiescent state.  There might be any number of tasks blocked
@@ -148,11 +414,14 @@ static void rcu_preempt_cpu_qs(void)
 	rcu_preempt_ctrlblk.gpcpu = rcu_preempt_ctrlblk.gpnum;
 	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
 
+	/* If there is no GP then there is nothing more to do.  */
+	if (!rcu_preempt_gp_in_progress())
+		return;
 	/*
-	 * If there is no GP, or if blocked readers are still blocking GP,
-	 * then there is nothing more to do.
+	 * Check up on boosting.  If there are no readers blocking the
+	 * current grace period, leave.
 	 */
-	if (!rcu_preempt_gp_in_progress() || rcu_preempt_blocked_readers_cgp())
+	if (rcu_initiate_boost())
 		return;
 
 	/* Advance callbacks. */
@@ -164,9 +433,9 @@ static void rcu_preempt_cpu_qs(void)
 	if (!rcu_preempt_blocked_readers_any())
 		rcu_preempt_ctrlblk.rcb.donetail = rcu_preempt_ctrlblk.nexttail;
 
-	/* If there are done callbacks, make RCU_SOFTIRQ process them. */
+	/* If there are done callbacks, cause them to be invoked. */
 	if (*rcu_preempt_ctrlblk.rcb.donetail != NULL)
-		raise_softirq(RCU_SOFTIRQ);
+		invoke_rcu_kthread();
 }
 
 /*
@@ -178,12 +447,16 @@ static void rcu_preempt_start_gp(void)
 
 		/* Official start of GP. */
 		rcu_preempt_ctrlblk.gpnum++;
+		RCU_TRACE(rcu_preempt_ctrlblk.n_grace_periods++);
 
 		/* Any blocked RCU readers block new GP. */
 		if (rcu_preempt_blocked_readers_any())
 			rcu_preempt_ctrlblk.gp_tasks =
 				rcu_preempt_ctrlblk.blkd_tasks.next;
 
+		/* Set up for RCU priority boosting. */
+		rcu_preempt_boost_start_gp();
+
 		/* If there is no running reader, CPU is done with GP. */
 		if (!rcu_preempt_running_reader())
 			rcu_preempt_cpu_qs();
@@ -304,14 +577,16 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		 */
 		empty = !rcu_preempt_blocked_readers_cgp();
 		empty_exp = rcu_preempt_ctrlblk.exp_tasks == NULL;
-		np = t->rcu_node_entry.next;
-		if (np == &rcu_preempt_ctrlblk.blkd_tasks)
-			np = NULL;
+		np = rcu_next_node_entry(t);
 		list_del(&t->rcu_node_entry);
 		if (&t->rcu_node_entry == rcu_preempt_ctrlblk.gp_tasks)
 			rcu_preempt_ctrlblk.gp_tasks = np;
 		if (&t->rcu_node_entry == rcu_preempt_ctrlblk.exp_tasks)
 			rcu_preempt_ctrlblk.exp_tasks = np;
+#ifdef CONFIG_RCU_BOOST
+		if (&t->rcu_node_entry == rcu_preempt_ctrlblk.boost_tasks)
+			rcu_preempt_ctrlblk.boost_tasks = np;
+#endif /* #ifdef CONFIG_RCU_BOOST */
 		INIT_LIST_HEAD(&t->rcu_node_entry);
 
 		/*
@@ -331,6 +606,14 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		if (!empty_exp && rcu_preempt_ctrlblk.exp_tasks == NULL)
 			rcu_report_exp_done();
 	}
+#ifdef CONFIG_RCU_BOOST
+	/* Unboost self if was boosted. */
+	if (special & RCU_READ_UNLOCK_BOOSTED) {
+		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BOOSTED;
+		rt_mutex_unlock(t->rcu_boost_mutex);
+		t->rcu_boost_mutex = NULL;
+	}
+#endif /* #ifdef CONFIG_RCU_BOOST */
 	local_irq_restore(flags);
 }
 
@@ -374,7 +657,7 @@ static void rcu_preempt_check_callbacks(void)
 		rcu_preempt_cpu_qs();
 	if (&rcu_preempt_ctrlblk.rcb.rcucblist !=
 	    rcu_preempt_ctrlblk.rcb.donetail)
-		raise_softirq(RCU_SOFTIRQ);
+		invoke_rcu_kthread();
 	if (rcu_preempt_gp_in_progress() &&
 	    rcu_cpu_blocking_cur_gp() &&
 	    rcu_preempt_running_reader())
@@ -383,7 +666,7 @@ static void rcu_preempt_check_callbacks(void)
 
 /*
  * TINY_PREEMPT_RCU has an extra callback-list tail pointer to
- * update, so this is invoked from __rcu_process_callbacks() to
+ * update, so this is invoked from rcu_process_callbacks() to
  * handle that case.  Of course, it is invoked for all flavors of
  * RCU, but RCU callbacks can appear only on one of the lists, and
  * neither ->nexttail nor ->donetail can possibly be NULL, so there
@@ -400,7 +683,7 @@ static void rcu_preempt_remove_callbacks(struct rcu_ctrlblk *rcp)
  */
 static void rcu_preempt_process_callbacks(void)
 {
-	__rcu_process_callbacks(&rcu_preempt_ctrlblk.rcb);
+	rcu_process_callbacks(&rcu_preempt_ctrlblk.rcb);
 }
 
 /*
@@ -417,6 +700,7 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 	local_irq_save(flags);
 	*rcu_preempt_ctrlblk.nexttail = head;
 	rcu_preempt_ctrlblk.nexttail = &head->next;
+	RCU_TRACE(rcu_preempt_ctrlblk.rcb.qlen++);
 	rcu_preempt_start_gp();  /* checks to see if GP needed. */
 	local_irq_restore(flags);
 }
@@ -532,6 +816,7 @@ void synchronize_rcu_expedited(void)
 
 	/* Wait for tail of ->blkd_tasks list to drain. */
 	if (rcu_preempted_readers_exp())
+		rcu_initiate_expedited_boost();
 		wait_event(sync_rcu_preempt_exp_wq,
 			   !rcu_preempted_readers_exp());
 
@@ -572,6 +857,27 @@ void exit_rcu(void)
 
 #else /* #ifdef CONFIG_TINY_PREEMPT_RCU */
 
+#ifdef CONFIG_RCU_TRACE
+
+/*
+ * Because preemptible RCU does not exist, it is not necessary to
+ * dump out its statistics.
+ */
+static void show_tiny_preempt_stats(struct seq_file *m)
+{
+}
+
+#endif /* #ifdef CONFIG_RCU_TRACE */
+
+/*
+ * Because preemptible RCU does not exist, it is never necessary to
+ * boost preempted RCU readers.
+ */
+static int rcu_boost(void)
+{
+	return 0;
+}
+
 /*
  * Because preemptible RCU does not exist, it never has any callbacks
  * to check.
@@ -599,17 +905,116 @@ static void rcu_preempt_process_callbacks(void)
 #endif /* #else #ifdef CONFIG_TINY_PREEMPT_RCU */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-
 #include <linux/kernel_stat.h>
 
 /*
  * During boot, we forgive RCU lockdep issues.  After this function is
  * invoked, we start taking RCU lockdep issues seriously.
  */
-void rcu_scheduler_starting(void)
+void __init rcu_scheduler_starting(void)
 {
 	WARN_ON(nr_context_switches() > 0);
 	rcu_scheduler_active = 1;
 }
 
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
+#ifdef CONFIG_RCU_BOOST
+#define RCU_BOOST_PRIO CONFIG_RCU_BOOST_PRIO
+#else /* #ifdef CONFIG_RCU_BOOST */
+#define RCU_BOOST_PRIO 1
+#endif /* #else #ifdef CONFIG_RCU_BOOST */
+
+#ifdef CONFIG_RCU_TRACE
+
+#ifdef CONFIG_RCU_BOOST
+
+static void rcu_initiate_boost_trace(void)
+{
+	if (rcu_preempt_ctrlblk.gp_tasks == NULL)
+		rcu_preempt_ctrlblk.n_normal_balk_gp_tasks++;
+	else if (rcu_preempt_ctrlblk.boost_tasks != NULL)
+		rcu_preempt_ctrlblk.n_normal_balk_boost_tasks++;
+	else if (rcu_preempt_ctrlblk.boosted_this_gp != 0)
+		rcu_preempt_ctrlblk.n_normal_balk_boosted++;
+	else if (!ULONG_CMP_GE(jiffies, rcu_preempt_ctrlblk.boost_time))
+		rcu_preempt_ctrlblk.n_normal_balk_notyet++;
+	else
+		rcu_preempt_ctrlblk.n_normal_balk_nos++;
+}
+
+static void rcu_initiate_exp_boost_trace(void)
+{
+	if (list_empty(&rcu_preempt_ctrlblk.blkd_tasks))
+		rcu_preempt_ctrlblk.n_exp_balk_blkd_tasks++;
+	else
+		rcu_preempt_ctrlblk.n_exp_balk_nos++;
+}
+
+#endif /* #ifdef CONFIG_RCU_BOOST */
+
+static void rcu_trace_sub_qlen(struct rcu_ctrlblk *rcp, int n)
+{
+	unsigned long flags;
+
+	raw_local_irq_save(flags);
+	rcp->qlen -= n;
+	raw_local_irq_restore(flags);
+}
+
+/*
+ * Dump statistics for TINY_RCU, such as they are.
+ */
+static int show_tiny_stats(struct seq_file *m, void *unused)
+{
+	show_tiny_preempt_stats(m);
+	seq_printf(m, "rcu_sched: qlen: %ld\n", rcu_sched_ctrlblk.qlen);
+	seq_printf(m, "rcu_bh: qlen: %ld\n", rcu_bh_ctrlblk.qlen);
+	return 0;
+}
+
+static int show_tiny_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_tiny_stats, NULL);
+}
+
+static const struct file_operations show_tiny_stats_fops = {
+	.owner = THIS_MODULE,
+	.open = show_tiny_stats_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static struct dentry *rcudir;
+
+static int __init rcutiny_trace_init(void)
+{
+	struct dentry *retval;
+
+	rcudir = debugfs_create_dir("rcu", NULL);
+	if (!rcudir)
+		goto free_out;
+	retval = debugfs_create_file("rcudata", 0444, rcudir,
+				     NULL, &show_tiny_stats_fops);
+	if (!retval)
+		goto free_out;
+	return 0;
+free_out:
+	debugfs_remove_recursive(rcudir);
+	return 1;
+}
+
+static void __exit rcutiny_trace_cleanup(void)
+{
+	debugfs_remove_recursive(rcudir);
+}
+
+module_init(rcutiny_trace_init);
+module_exit(rcutiny_trace_cleanup);
+
+MODULE_AUTHOR("Paul E. McKenney");
+MODULE_DESCRIPTION("Read-Copy Update tracing for tiny implementation");
+MODULE_LICENSE("GPL");
+
+#endif /* #ifdef CONFIG_RCU_TRACE */
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 9d8e8fb..89613f9 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -47,6 +47,7 @@
 #include <linux/srcu.h>
 #include <linux/slab.h>
 #include <asm/byteorder.h>
+#include <linux/sched.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
@@ -64,6 +65,9 @@ static int irqreader = 1;	/* RCU readers from irq (timers). */
 static int fqs_duration = 0;	/* Duration of bursts (us), 0 to disable. */
 static int fqs_holdoff = 0;	/* Hold time within burst (us). */
 static int fqs_stutter = 3;	/* Wait time between bursts (s). */
+static int test_boost = 1;	/* Test RCU prio boost: 0=no, 1=maybe, 2=yes. */
+static int test_boost_interval = 7; /* Interval between boost tests, seconds. */
+static int test_boost_duration = 4; /* Duration of each boost test, seconds. */
 static char *torture_type = "rcu"; /* What RCU implementation to torture. */
 
 module_param(nreaders, int, 0444);
@@ -88,6 +92,12 @@ module_param(fqs_holdoff, int, 0444);
 MODULE_PARM_DESC(fqs_holdoff, "Holdoff time within fqs bursts (us)");
 module_param(fqs_stutter, int, 0444);
 MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
+module_param(test_boost, int, 0444);
+MODULE_PARM_DESC(test_boost, "Test RCU prio boost: 0=no, 1=maybe, 2=yes.");
+module_param(test_boost_interval, int, 0444);
+MODULE_PARM_DESC(test_boost_interval, "Interval between boost tests, seconds.");
+module_param(test_boost_duration, int, 0444);
+MODULE_PARM_DESC(test_boost_duration, "Duration of each boost test, seconds.");
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, srcu)");
 
@@ -109,6 +119,7 @@ static struct task_struct *stats_task;
 static struct task_struct *shuffler_task;
 static struct task_struct *stutter_task;
 static struct task_struct *fqs_task;
+static struct task_struct *boost_tasks[NR_CPUS];
 
 #define RCU_TORTURE_PIPE_LEN 10
 
@@ -134,6 +145,12 @@ static atomic_t n_rcu_torture_alloc_fail;
 static atomic_t n_rcu_torture_free;
 static atomic_t n_rcu_torture_mberror;
 static atomic_t n_rcu_torture_error;
+static long n_rcu_torture_boost_ktrerror;
+static long n_rcu_torture_boost_rterror;
+static long n_rcu_torture_boost_allocerror;
+static long n_rcu_torture_boost_afferror;
+static long n_rcu_torture_boost_failure;
+static long n_rcu_torture_boosts;
 static long n_rcu_torture_timers;
 static struct list_head rcu_torture_removed;
 static cpumask_var_t shuffle_tmp_mask;
@@ -147,6 +164,16 @@ static int stutter_pause_test;
 #endif
 int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
 
+#ifdef CONFIG_RCU_BOOST
+#define rcu_can_boost() 1
+#else /* #ifdef CONFIG_RCU_BOOST */
+#define rcu_can_boost() 0
+#endif /* #else #ifdef CONFIG_RCU_BOOST */
+
+static unsigned long boost_starttime;	/* jiffies of next boost test start. */
+DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
+					/*  and boost task create/destroy. */
+
 /* Mediate rmmod and system shutdown.  Concurrent rmmod & shutdown illegal! */
 
 #define FULLSTOP_DONTSTOP 0	/* Normal operation. */
@@ -277,6 +304,7 @@ struct rcu_torture_ops {
 	void (*fqs)(void);
 	int (*stats)(char *page);
 	int irq_capable;
+	int can_boost;
 	char *name;
 };
 
@@ -366,6 +394,7 @@ static struct rcu_torture_ops rcu_ops = {
 	.fqs		= rcu_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
+	.can_boost	= rcu_can_boost(),
 	.name		= "rcu"
 };
 
@@ -408,6 +437,7 @@ static struct rcu_torture_ops rcu_sync_ops = {
 	.fqs		= rcu_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
+	.can_boost	= rcu_can_boost(),
 	.name		= "rcu_sync"
 };
 
@@ -424,6 +454,7 @@ static struct rcu_torture_ops rcu_expedited_ops = {
 	.fqs		= rcu_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
+	.can_boost	= rcu_can_boost(),
 	.name		= "rcu_expedited"
 };
 
@@ -684,6 +715,110 @@ static struct rcu_torture_ops sched_expedited_ops = {
 };
 
 /*
+ * RCU torture priority-boost testing.  Runs one real-time thread per
+ * CPU for moderate bursts, repeatedly registering RCU callbacks and
+ * spinning waiting for them to be invoked.  If a given callback takes
+ * too long to be invoked, we assume that priority inversion has occurred.
+ */
+
+struct rcu_boost_inflight {
+	struct rcu_head rcu;
+	int inflight;
+};
+
+static void rcu_torture_boost_cb(struct rcu_head *head)
+{
+	struct rcu_boost_inflight *rbip =
+		container_of(head, struct rcu_boost_inflight, rcu);
+
+	smp_mb(); /* Ensure RCU-core accesses precede clearing ->inflight */
+	rbip->inflight = 0;
+}
+
+static int rcu_torture_boost(void *arg)
+{
+	unsigned long call_rcu_time;
+	unsigned long endtime;
+	unsigned long oldstarttime;
+	struct rcu_boost_inflight rbi = { .inflight = 0 };
+	struct sched_param sp;
+
+	VERBOSE_PRINTK_STRING("rcu_torture_boost started");
+
+	/* Set real-time priority. */
+	sp.sched_priority = 1;
+	if (sched_setscheduler(current, SCHED_FIFO, &sp) < 0) {
+		VERBOSE_PRINTK_STRING("rcu_torture_boost RT prio failed!");
+		n_rcu_torture_boost_rterror++;
+	}
+
+	/* Each pass through the following loop does one boost-test cycle. */
+	do {
+		/* Wait for the next test interval. */
+		oldstarttime = boost_starttime;
+		while (jiffies - oldstarttime > ULONG_MAX / 2) {
+			schedule_timeout_uninterruptible(1);
+			rcu_stutter_wait("rcu_torture_boost");
+			if (kthread_should_stop() ||
+			    fullstop != FULLSTOP_DONTSTOP)
+				goto checkwait;
+		}
+
+		/* Do one boost-test interval. */
+		endtime = oldstarttime + test_boost_duration * HZ;
+		call_rcu_time = jiffies;
+		while (jiffies - endtime > ULONG_MAX / 2) {
+			/* If we don't have a callback in flight, post one. */
+			if (!rbi.inflight) {
+				smp_mb(); /* RCU core before ->inflight = 1. */
+				rbi.inflight = 1;
+				call_rcu(&rbi.rcu, rcu_torture_boost_cb);
+				if (jiffies - call_rcu_time >
+					 test_boost_duration * HZ - HZ / 2) {
+					VERBOSE_PRINTK_STRING("rcu_torture_boost boosting failed");
+					n_rcu_torture_boost_failure++;
+				}
+				call_rcu_time = jiffies;
+			}
+			cond_resched();
+			rcu_stutter_wait("rcu_torture_boost");
+			if (kthread_should_stop() ||
+			    fullstop != FULLSTOP_DONTSTOP)
+				goto checkwait;
+		}
+
+		/*
+		 * Set the start time of the next test interval.
+		 * Yes, this is vulnerable to long delays, but such
+		 * delays simply cause a false negative for the next
+		 * interval.  Besides, we are running at RT priority,
+		 * so delays should be relatively rare.
+		 */
+		while (oldstarttime == boost_starttime) {
+			if (mutex_trylock(&boost_mutex)) {
+				boost_starttime = jiffies +
+						  test_boost_interval * HZ;
+				n_rcu_torture_boosts++;
+				mutex_unlock(&boost_mutex);
+				break;
+			}
+			schedule_timeout_uninterruptible(1);
+		}
+
+		/* Go do the stutter. */
+checkwait:	rcu_stutter_wait("rcu_torture_boost");
+	} while (!kthread_should_stop() && fullstop  == FULLSTOP_DONTSTOP);
+
+	/* Clean up and exit. */
+	VERBOSE_PRINTK_STRING("rcu_torture_boost task stopping");
+	rcutorture_shutdown_absorb("rcu_torture_boost");
+	while (!kthread_should_stop() || rbi.inflight)
+		schedule_timeout_uninterruptible(1);
+	smp_mb(); /* order accesses to ->inflight before stack-frame death. */
+	return 0;
+}
+
+/*
  * RCU torture force-quiescent-state kthread.  Repeatedly induces
  * bursts of calls to force_quiescent_state(), increasing the probability
  * of occurrence of some important types of race conditions.
@@ -933,7 +1068,8 @@ rcu_torture_printk(char *page)
 	cnt += sprintf(&page[cnt], "%s%s ", torture_type, TORTURE_FLAG);
 	cnt += sprintf(&page[cnt],
 		       "rtc: %p ver: %ld tfle: %d rta: %d rtaf: %d rtf: %d "
-		       "rtmbe: %d nt: %ld",
+		       "rtmbe: %d rtbke: %ld rtbre: %ld rtbae: %ld rtbafe: %ld "
+		       "rtbf: %ld rtb: %ld nt: %ld",
 		       rcu_torture_current,
 		       rcu_torture_current_version,
 		       list_empty(&rcu_torture_freelist),
@@ -941,8 +1077,19 @@ rcu_torture_printk(char *page)
 		       atomic_read(&n_rcu_torture_alloc_fail),
 		       atomic_read(&n_rcu_torture_free),
 		       atomic_read(&n_rcu_torture_mberror),
+		       n_rcu_torture_boost_ktrerror,
+		       n_rcu_torture_boost_rterror,
+		       n_rcu_torture_boost_allocerror,
+		       n_rcu_torture_boost_afferror,
+		       n_rcu_torture_boost_failure,
+		       n_rcu_torture_boosts,
 		       n_rcu_torture_timers);
-	if (atomic_read(&n_rcu_torture_mberror) != 0)
+	if (atomic_read(&n_rcu_torture_mberror) != 0 ||
+	    n_rcu_torture_boost_ktrerror != 0 ||
+	    n_rcu_torture_boost_rterror != 0 ||
+	    n_rcu_torture_boost_allocerror != 0 ||
+	    n_rcu_torture_boost_afferror != 0 ||
+	    n_rcu_torture_boost_failure != 0)
 		cnt += sprintf(&page[cnt], " !!!");
 	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
 	if (i > 1) {
@@ -1094,22 +1241,91 @@ rcu_torture_stutter(void *arg)
 }
 
 static inline void
-rcu_torture_print_module_parms(char *tag)
+rcu_torture_print_module_parms(struct rcu_torture_ops *cur_ops, char *tag)
 {
 	printk(KERN_ALERT "%s" TORTURE_FLAG
 		"--- %s: nreaders=%d nfakewriters=%d "
 		"stat_interval=%d verbose=%d test_no_idle_hz=%d "
 		"shuffle_interval=%d stutter=%d irqreader=%d "
-		"fqs_duration=%d fqs_holdoff=%d fqs_stutter=%d\n",
+		"fqs_duration=%d fqs_holdoff=%d fqs_stutter=%d "
+		"test_boost=%d/%d test_boost_interval=%d "
+		"test_boost_duration=%d\n",
 		torture_type, tag, nrealreaders, nfakewriters,
 		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
-		stutter, irqreader, fqs_duration, fqs_holdoff, fqs_stutter);
+		stutter, irqreader, fqs_duration, fqs_holdoff, fqs_stutter,
+		test_boost, cur_ops->can_boost,
+		test_boost_interval, test_boost_duration);
 }
 
-static struct notifier_block rcutorture_nb = {
+static struct notifier_block rcutorture_shutdown_nb = {
 	.notifier_call = rcutorture_shutdown_notify,
 };
 
+static void rcutorture_booster_cleanup(int cpu)
+{
+	struct task_struct *t;
+
+	if (boost_tasks[cpu] == NULL)
+		return;
+	mutex_lock(&boost_mutex);
+	VERBOSE_PRINTK_STRING("Stopping rcu_torture_boost task");
+	t = boost_tasks[cpu];
+	boost_tasks[cpu] = NULL;
+	mutex_unlock(&boost_mutex);
+
+	/* This must be outside of the mutex, otherwise deadlock! */
+	kthread_stop(t);
+}
+
+static int rcutorture_booster_init(int cpu)
+{
+	int retval;
+
+	if (boost_tasks[cpu] != NULL)
+		return 0;  /* Already created, nothing more to do. */
+
+	/* Don't allow time recalculation while creating a new task. */
+	mutex_lock(&boost_mutex);
+	VERBOSE_PRINTK_STRING("Creating rcu_torture_boost task");
+	boost_tasks[cpu] = kthread_create(rcu_torture_boost, NULL,
+					  "rcu_torture_boost");
+	if (IS_ERR(boost_tasks[cpu])) {
+		retval = PTR_ERR(boost_tasks[cpu]);
+		VERBOSE_PRINTK_STRING("rcu_torture_boost task create failed");
+		n_rcu_torture_boost_ktrerror++;
+		boost_tasks[cpu] = NULL;
+		mutex_unlock(&boost_mutex);
+		return retval;
+	}
+	kthread_bind(boost_tasks[cpu], cpu);
+	wake_up_process(boost_tasks[cpu]);
+	mutex_unlock(&boost_mutex);
+	return 0;
+}
+
+static int rcutorture_cpu_notify(struct notifier_block *self,
+				 unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_DOWN_FAILED:
+		(void)rcutorture_booster_init(cpu);
+		break;
+	case CPU_DOWN_PREPARE:
+		rcutorture_booster_cleanup(cpu);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block rcutorture_cpu_nb = {
+	.notifier_call = rcutorture_cpu_notify,
+};
+
 static void
 rcu_torture_cleanup(void)
 {
@@ -1127,7 +1343,7 @@ rcu_torture_cleanup(void)
 	}
 	fullstop = FULLSTOP_RMMOD;
 	mutex_unlock(&fullstop_mutex);
-	unregister_reboot_notifier(&rcutorture_nb);
+	unregister_reboot_notifier(&rcutorture_shutdown_nb);
 	if (stutter_task) {
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_stutter task");
 		kthread_stop(stutter_task);
@@ -1184,6 +1400,12 @@ rcu_torture_cleanup(void)
 		kthread_stop(fqs_task);
 	}
 	fqs_task = NULL;
+	if ((test_boost == 1 && cur_ops->can_boost) ||
+	    test_boost == 2) {
+		unregister_cpu_notifier(&rcutorture_cpu_nb);
+		for_each_possible_cpu(i)
+			rcutorture_booster_cleanup(i);
+	}
 
 	/* Wait for all RCU callbacks to fire.  */
 
@@ -1195,9 +1417,9 @@ rcu_torture_cleanup(void)
 	if (cur_ops->cleanup)
 		cur_ops->cleanup();
 	if (atomic_read(&n_rcu_torture_error))
-		rcu_torture_print_module_parms("End of test: FAILURE");
+		rcu_torture_print_module_parms(cur_ops, "End of test: FAILURE");
 	else
-		rcu_torture_print_module_parms("End of test: SUCCESS");
+		rcu_torture_print_module_parms(cur_ops, "End of test: SUCCESS");
 }
 
 static int __init
@@ -1242,7 +1464,7 @@ rcu_torture_init(void)
 		nrealreaders = nreaders;
 	else
 		nrealreaders = 2 * num_online_cpus();
-	rcu_torture_print_module_parms("Start of test");
+	rcu_torture_print_module_parms(cur_ops, "Start of test");
 	fullstop = FULLSTOP_DONTSTOP;
 
 	/* Set up the freelist. */
@@ -1263,6 +1485,12 @@ rcu_torture_init(void)
 	atomic_set(&n_rcu_torture_free, 0);
 	atomic_set(&n_rcu_torture_mberror, 0);
 	atomic_set(&n_rcu_torture_error, 0);
+	n_rcu_torture_boost_ktrerror = 0;
+	n_rcu_torture_boost_rterror = 0;
+	n_rcu_torture_boost_allocerror = 0;
+	n_rcu_torture_boost_afferror = 0;
+	n_rcu_torture_boost_failure = 0;
+	n_rcu_torture_boosts = 0;
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
 		atomic_set(&rcu_torture_wcount[i], 0);
 	for_each_possible_cpu(cpu) {
@@ -1376,7 +1604,27 @@ rcu_torture_init(void)
 			goto unwind;
 		}
 	}
-	register_reboot_notifier(&rcutorture_nb);
+	if (test_boost_interval < 1)
+		test_boost_interval = 1;
+	if (test_boost_duration < 2)
+		test_boost_duration = 2;
+	if ((test_boost == 1 && cur_ops->can_boost) ||
+	    test_boost == 2) {
+		int retval;
+
+		boost_starttime = jiffies + test_boost_interval * HZ;
+		register_cpu_notifier(&rcutorture_cpu_nb);
+		for_each_possible_cpu(i) {
+			if (cpu_is_offline(i))
+				continue;  /* Heuristic: CPU can go offline. */
+			retval = rcutorture_booster_init(i);
+			if (retval < 0) {
+				firsterr = retval;
+				goto unwind;
+			}
+		}
+	}
+	register_reboot_notifier(&rcutorture_shutdown_nb);
 	mutex_unlock(&fullstop_mutex);
 	return 0;
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ccdc04c..d0ddfea 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -67,9 +67,6 @@ static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
 	.gpnum = -300, \
 	.completed = -300, \
 	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&structname.onofflock), \
-	.orphan_cbs_list = NULL, \
-	.orphan_cbs_tail = &structname.orphan_cbs_list, \
-	.orphan_qlen = 0, \
 	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&structname.fqslock), \
 	.n_force_qs = 0, \
 	.n_force_qs_ngp = 0, \
@@ -620,9 +617,17 @@ static void __init check_cpu_stall_init(void)
 static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
 {
 	if (rdp->gpnum != rnp->gpnum) {
-		rdp->qs_pending = 1;
-		rdp->passed_quiesc = 0;
+		/*
+		 * If the current grace period is waiting for this CPU,
+		 * set up to detect a quiescent state, otherwise don't
+		 * go looking for one.
+		 */
 		rdp->gpnum = rnp->gpnum;
+		if (rnp->qsmask & rdp->grpmask) {
+			rdp->qs_pending = 1;
+			rdp->passed_quiesc = 0;
+		} else
+			rdp->qs_pending = 0;
 	}
 }
 
@@ -681,6 +686,24 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 
 		/* Remember that we saw this grace-period completion. */
 		rdp->completed = rnp->completed;
+
+		/*
+		 * If we were in an extended quiescent state, we may have
+		 * missed some grace periods that others CPUs handled on
+		 * our behalf. Catch up with this state to avoid noting
+		 * spurious new grace periods.  If another grace period
+		 * has started, then rnp->gpnum will have advanced, so
+		 * we will detect this later on.
+		 */
+		if (ULONG_CMP_LT(rdp->gpnum, rdp->completed))
+			rdp->gpnum = rdp->completed;
+
+		/*
+		 * If RCU does not need a quiescent state from this CPU,
+		 * then make sure that this CPU doesn't go looking for one.
+		 */
+		if ((rnp->qsmask & rdp->grpmask) == 0)
+			rdp->qs_pending = 0;
 	}
 }
 
@@ -984,53 +1007,31 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 #ifdef CONFIG_HOTPLUG_CPU
 
 /*
- * Move a dying CPU's RCU callbacks to the ->orphan_cbs_list for the
- * specified flavor of RCU.  The callbacks will be adopted by the next
- * _rcu_barrier() invocation or by the CPU_DEAD notifier, whichever
- * comes first.  Because this is invoked from the CPU_DYING notifier,
- * irqs are already disabled.
+ * Move a dying CPU's RCU callbacks to online CPU's callback list.
+ * Synchronization is not required because this function executes
+ * in stop_machine() context.
  */
-static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
+static void rcu_send_cbs_to_online(struct rcu_state *rsp)
 {
 	int i;
+	/* current DYING CPU is cleared in the cpu_online_mask */
+	int receive_cpu = cpumask_any(cpu_online_mask);
 	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
+	struct rcu_data *receive_rdp = per_cpu_ptr(rsp->rda, receive_cpu);
 
 	if (rdp->nxtlist == NULL)
 		return;  /* irqs disabled, so comparison is stable. */
-	raw_spin_lock(&rsp->onofflock);  /* irqs already disabled. */
-	*rsp->orphan_cbs_tail = rdp->nxtlist;
-	rsp->orphan_cbs_tail = rdp->nxttail[RCU_NEXT_TAIL];
+
+	*receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
+	receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+	receive_rdp->qlen += rdp->qlen;
+	receive_rdp->n_cbs_adopted += rdp->qlen;
+	rdp->n_cbs_orphaned += rdp->qlen;
+
 	rdp->nxtlist = NULL;
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
 		rdp->nxttail[i] = &rdp->nxtlist;
-	rsp->orphan_qlen += rdp->qlen;
-	rdp->n_cbs_orphaned += rdp->qlen;
 	rdp->qlen = 0;
-	raw_spin_unlock(&rsp->onofflock);  /* irqs remain disabled. */
-}
-
-/*
- * Adopt previously orphaned RCU callbacks.
- */
-static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
-{
-	unsigned long flags;
-	struct rcu_data *rdp;
-
-	raw_spin_lock_irqsave(&rsp->onofflock, flags);
-	rdp = this_cpu_ptr(rsp->rda);
-	if (rsp->orphan_cbs_list == NULL) {
-		raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
-		return;
-	}
-	*rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_list;
-	rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_tail;
-	rdp->qlen += rsp->orphan_qlen;
-	rdp->n_cbs_adopted += rsp->orphan_qlen;
-	rsp->orphan_cbs_list = NULL;
-	rsp->orphan_cbs_tail = &rsp->orphan_cbs_list;
-	rsp->orphan_qlen = 0;
-	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 }
 
 /*
@@ -1081,8 +1082,6 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	if (need_report & RCU_OFL_TASKS_EXP_GP)
 		rcu_report_exp_rnp(rsp, rnp);
-
-	rcu_adopt_orphan_cbs(rsp);
 }
 
 /*
@@ -1100,11 +1099,7 @@ static void rcu_offline_cpu(int cpu)
 
 #else /* #ifdef CONFIG_HOTPLUG_CPU */
 
-static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
-{
-}
-
-static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
+static void rcu_send_cbs_to_online(struct rcu_state *rsp)
 {
 }
 
@@ -1440,22 +1435,11 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	 */
 	local_irq_save(flags);
 	rdp = this_cpu_ptr(rsp->rda);
-	rcu_process_gp_end(rsp, rdp);
-	check_for_new_grace_period(rsp, rdp);
 
 	/* Add the callback to our list. */
 	*rdp->nxttail[RCU_NEXT_TAIL] = head;
 	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
 
-	/* Start a new grace period if one not already started. */
-	if (!rcu_gp_in_progress(rsp)) {
-		unsigned long nestflag;
-		struct rcu_node *rnp_root = rcu_get_root(rsp);
-
-		raw_spin_lock_irqsave(&rnp_root->lock, nestflag);
-		rcu_start_gp(rsp, nestflag);  /* releases rnp_root->lock. */
-	}
-
 	/*
 	 * Force the grace period if too many callbacks or too long waiting.
 	 * Enforce hysteresis, and don't invoke force_quiescent_state()
@@ -1464,12 +1448,27 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	 * is the only one waiting for a grace period to complete.
 	 */
 	if (unlikely(++rdp->qlen > rdp->qlen_last_fqs_check + qhimark)) {
-		rdp->blimit = LONG_MAX;
-		if (rsp->n_force_qs == rdp->n_force_qs_snap &&
-		    *rdp->nxttail[RCU_DONE_TAIL] != head)
-			force_quiescent_state(rsp, 0);
-		rdp->n_force_qs_snap = rsp->n_force_qs;
-		rdp->qlen_last_fqs_check = rdp->qlen;
+
+		/* Are we ignoring a completed grace period? */
+		rcu_process_gp_end(rsp, rdp);
+		check_for_new_grace_period(rsp, rdp);
+
+		/* Start a new grace period if one not already started. */
+		if (!rcu_gp_in_progress(rsp)) {
+			unsigned long nestflag;
+			struct rcu_node *rnp_root = rcu_get_root(rsp);
+
+			raw_spin_lock_irqsave(&rnp_root->lock, nestflag);
+			rcu_start_gp(rsp, nestflag);  /* rlses rnp_root->lock */
+		} else {
+			/* Give the grace period a kick. */
+			rdp->blimit = LONG_MAX;
+			if (rsp->n_force_qs == rdp->n_force_qs_snap &&
+			    *rdp->nxttail[RCU_DONE_TAIL] != head)
+				force_quiescent_state(rsp, 0);
+			rdp->n_force_qs_snap = rsp->n_force_qs;
+			rdp->qlen_last_fqs_check = rdp->qlen;
+		}
 	} else if (ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs), jiffies))
 		force_quiescent_state(rsp, 1);
 	local_irq_restore(flags);
@@ -1699,13 +1698,12 @@ static void _rcu_barrier(struct rcu_state *rsp,
 	 * decrement rcu_barrier_cpu_count -- otherwise the first CPU
 	 * might complete its grace period before all of the other CPUs
 	 * did their increment, causing this function to return too
-	 * early.
+	 * early.  Note that on_each_cpu() disables irqs, which prevents
+	 * any CPUs from coming online or going offline until each online
+	 * CPU has queued its RCU-barrier callback.
 	 */
 	atomic_set(&rcu_barrier_cpu_count, 1);
-	preempt_disable(); /* stop CPU_DYING from filling orphan_cbs_list */
-	rcu_adopt_orphan_cbs(rsp);
 	on_each_cpu(rcu_barrier_func, (void *)call_rcu_func, 1);
-	preempt_enable(); /* CPU_DYING can again fill orphan_cbs_list */
 	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
 		complete(&rcu_barrier_completion);
 	wait_for_completion(&rcu_barrier_completion);
@@ -1831,18 +1829,13 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
 		/*
-		 * preempt_disable() in _rcu_barrier() prevents stop_machine(),
-		 * so when "on_each_cpu(rcu_barrier_func, (void *)type, 1);"
-		 * returns, all online cpus have queued rcu_barrier_func().
-		 * The dying CPU clears its cpu_online_mask bit and
-		 * moves all of its RCU callbacks to ->orphan_cbs_list
-		 * in the context of stop_machine(), so subsequent calls
-		 * to _rcu_barrier() will adopt these callbacks and only
-		 * then queue rcu_barrier_func() on all remaining CPUs.
+		 * The whole machine is "stopped" except this CPU, so we can
+		 * touch any data without introducing corruption. We send the
+		 * dying CPU's callbacks to an arbitrarily chosen online CPU.
 		 */
-		rcu_send_cbs_to_orphanage(&rcu_bh_state);
-		rcu_send_cbs_to_orphanage(&rcu_sched_state);
-		rcu_preempt_send_cbs_to_orphanage();
+		rcu_send_cbs_to_online(&rcu_bh_state);
+		rcu_send_cbs_to_online(&rcu_sched_state);
+		rcu_preempt_send_cbs_to_online();
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
@@ -1880,8 +1873,9 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
 {
 	int i;
 
-	for (i = NUM_RCU_LVLS - 1; i >= 0; i--)
+	for (i = NUM_RCU_LVLS - 1; i > 0; i--)
 		rsp->levelspread[i] = CONFIG_RCU_FANOUT;
+	rsp->levelspread[0] = RCU_FANOUT_LEAF;
 }
 #else /* #ifdef CONFIG_RCU_FANOUT_EXACT */
 static void __init rcu_init_levelspread(struct rcu_state *rsp)
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 91d4170..e8f057e 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -31,46 +31,51 @@
 /*
  * Define shape of hierarchy based on NR_CPUS and CONFIG_RCU_FANOUT.
  * In theory, it should be possible to add more levels straightforwardly.
- * In practice, this has not been tested, so there is probably some
- * bug somewhere.
+ * In practice, this did work well going from three levels to four.
+ * Of course, your mileage may vary.
  */
 #define MAX_RCU_LVLS 4
-#define RCU_FANOUT	      (CONFIG_RCU_FANOUT)
-#define RCU_FANOUT_SQ	      (RCU_FANOUT * RCU_FANOUT)
-#define RCU_FANOUT_CUBE	      (RCU_FANOUT_SQ * RCU_FANOUT)
-#define RCU_FANOUT_FOURTH     (RCU_FANOUT_CUBE * RCU_FANOUT)
-
-#if NR_CPUS <= RCU_FANOUT
+#if CONFIG_RCU_FANOUT > 16
+#define RCU_FANOUT_LEAF       16
+#else /* #if CONFIG_RCU_FANOUT > 16 */
+#define RCU_FANOUT_LEAF       (CONFIG_RCU_FANOUT)
+#endif /* #else #if CONFIG_RCU_FANOUT > 16 */
+#define RCU_FANOUT_1	      (RCU_FANOUT_LEAF)
+#define RCU_FANOUT_2	      (RCU_FANOUT_1 * CONFIG_RCU_FANOUT)
+#define RCU_FANOUT_3	      (RCU_FANOUT_2 * CONFIG_RCU_FANOUT)
+#define RCU_FANOUT_4	      (RCU_FANOUT_3 * CONFIG_RCU_FANOUT)
+
+#if NR_CPUS <= RCU_FANOUT_1
 #  define NUM_RCU_LVLS	      1
 #  define NUM_RCU_LVL_0	      1
 #  define NUM_RCU_LVL_1	      (NR_CPUS)
 #  define NUM_RCU_LVL_2	      0
 #  define NUM_RCU_LVL_3	      0
 #  define NUM_RCU_LVL_4	      0
-#elif NR_CPUS <= RCU_FANOUT_SQ
+#elif NR_CPUS <= RCU_FANOUT_2
 #  define NUM_RCU_LVLS	      2
 #  define NUM_RCU_LVL_0	      1
-#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT)
+#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_1)
 #  define NUM_RCU_LVL_2	      (NR_CPUS)
 #  define NUM_RCU_LVL_3	      0
 #  define NUM_RCU_LVL_4	      0
-#elif NR_CPUS <= RCU_FANOUT_CUBE
+#elif NR_CPUS <= RCU_FANOUT_3
 #  define NUM_RCU_LVLS	      3
 #  define NUM_RCU_LVL_0	      1
-#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_SQ)
-#  define NUM_RCU_LVL_2	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT)
-#  define NUM_RCU_LVL_3	      NR_CPUS
+#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_2)
+#  define NUM_RCU_LVL_2	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_1)
+#  define NUM_RCU_LVL_3	      (NR_CPUS)
 #  define NUM_RCU_LVL_4	      0
-#elif NR_CPUS <= RCU_FANOUT_FOURTH
+#elif NR_CPUS <= RCU_FANOUT_4
 #  define NUM_RCU_LVLS	      4
 #  define NUM_RCU_LVL_0	      1
-#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_CUBE)
-#  define NUM_RCU_LVL_2	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_SQ)
-#  define NUM_RCU_LVL_3	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT)
-#  define NUM_RCU_LVL_4	      NR_CPUS
+#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_3)
+#  define NUM_RCU_LVL_2	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_2)
+#  define NUM_RCU_LVL_3	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_1)
+#  define NUM_RCU_LVL_4	      (NR_CPUS)
 #else
 # error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
-#endif /* #if (NR_CPUS) <= RCU_FANOUT */
+#endif /* #if (NR_CPUS) <= RCU_FANOUT_1 */
 
 #define RCU_SUM (NUM_RCU_LVL_0 + NUM_RCU_LVL_1 + NUM_RCU_LVL_2 + NUM_RCU_LVL_3 + NUM_RCU_LVL_4)
 #define NUM_RCU_NODES (RCU_SUM - NR_CPUS)
@@ -203,8 +208,8 @@ struct rcu_data {
 	long		qlen_last_fqs_check;
 					/* qlen at last check for QS forcing */
 	unsigned long	n_cbs_invoked;	/* count of RCU cbs invoked. */
-	unsigned long	n_cbs_orphaned;	/* RCU cbs sent to orphanage. */
-	unsigned long	n_cbs_adopted;	/* RCU cbs adopted from orphanage. */
+	unsigned long   n_cbs_orphaned; /* RCU cbs orphaned by dying CPU */
+	unsigned long   n_cbs_adopted;  /* RCU cbs adopted from dying CPU */
 	unsigned long	n_force_qs_snap;
 					/* did other CPU force QS recently? */
 	long		blimit;		/* Upper limit on a processed batch */
@@ -309,15 +314,7 @@ struct rcu_state {
 	/* End of fields guarded by root rcu_node's lock. */
 
 	raw_spinlock_t onofflock;		/* exclude on/offline and */
-						/*  starting new GP.  Also */
-						/*  protects the following */
-						/*  orphan_cbs fields. */
-	struct rcu_head *orphan_cbs_list;	/* list of rcu_head structs */
-						/*  orphaned by all CPUs in */
-						/*  a given leaf rcu_node */
-						/*  going offline. */
-	struct rcu_head **orphan_cbs_tail;	/* And tail pointer. */
-	long orphan_qlen;			/* Number of orphaned cbs. */
+						/*  starting new GP. */
 	raw_spinlock_t fqslock;			/* Only one task forcing */
 						/*  quiescent states. */
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
@@ -390,7 +387,7 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp);
 static int rcu_preempt_pending(int cpu);
 static int rcu_preempt_needs_cpu(int cpu);
 static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
-static void rcu_preempt_send_cbs_to_orphanage(void);
+static void rcu_preempt_send_cbs_to_online(void);
 static void __init __rcu_init_preempt(void);
 static void rcu_needs_cpu_flush(void);
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 71a4147..a363871 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -25,6 +25,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/stop_machine.h>
 
 /*
  * Check the RCU kernel configuration parameters and print informative
@@ -773,11 +774,11 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 }
 
 /*
- * Move preemptable RCU's callbacks to ->orphan_cbs_list.
+ * Move preemptable RCU's callbacks from dying CPU to other online CPU.
  */
-static void rcu_preempt_send_cbs_to_orphanage(void)
+static void rcu_preempt_send_cbs_to_online(void)
 {
-	rcu_send_cbs_to_orphanage(&rcu_preempt_state);
+	rcu_send_cbs_to_online(&rcu_preempt_state);
 }
 
 /*
@@ -1001,7 +1002,7 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 /*
  * Because there is no preemptable RCU, there are no callbacks to move.
  */
-static void rcu_preempt_send_cbs_to_orphanage(void)
+static void rcu_preempt_send_cbs_to_online(void)
 {
 }
 
@@ -1014,6 +1015,132 @@ static void __init __rcu_init_preempt(void)
 
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
+#ifndef CONFIG_SMP
+
+void synchronize_sched_expedited(void)
+{
+	cond_resched();
+}
+EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
+
+#else /* #ifndef CONFIG_SMP */
+
+static atomic_t sync_sched_expedited_started = ATOMIC_INIT(0);
+static atomic_t sync_sched_expedited_done = ATOMIC_INIT(0);
+
+static int synchronize_sched_expedited_cpu_stop(void *data)
+{
+	/*
+	 * There must be a full memory barrier on each affected CPU
+	 * between the time that try_stop_cpus() is called and the
+	 * time that it returns.
+	 *
+	 * In the current initial implementation of cpu_stop, the
+	 * above condition is already met when the control reaches
+	 * this point and the following smp_mb() is not strictly
+	 * necessary.  Do smp_mb() anyway for documentation and
+	 * robustness against future implementation changes.
+	 */
+	smp_mb(); /* See above comment block. */
+	return 0;
+}
+
+/*
+ * Wait for an rcu-sched grace period to elapse, but use "big hammer"
+ * approach to force grace period to end quickly.  This consumes
+ * significant time on all CPUs, and is thus not recommended for
+ * any sort of common-case code.
+ *
+ * Note that it is illegal to call this function while holding any
+ * lock that is acquired by a CPU-hotplug notifier.  Failing to
+ * observe this restriction will result in deadlock.
+ *
+ * This implementation can be thought of as an application of ticket
+ * locking to RCU, with sync_sched_expedited_started and
+ * sync_sched_expedited_done taking on the roles of the halves
+ * of the ticket-lock word.  Each task atomically increments
+ * sync_sched_expedited_started upon entry, snapshotting the old value,
+ * then attempts to stop all the CPUs.  If this succeeds, then each
+ * CPU will have executed a context switch, resulting in an RCU-sched
+ * grace period.  We are then done, so we use atomic_cmpxchg() to
+ * update sync_sched_expedited_done to match our snapshot -- but
+ * only if someone else has not already advanced past our snapshot.
+ *
+ * On the other hand, if try_stop_cpus() fails, we check the value
+ * of sync_sched_expedited_done.  If it has advanced past our
+ * initial snapshot, then someone else must have forced a grace period
+ * some time after we took our snapshot.  In this case, our work is
+ * done for us, and we can simply return.  Otherwise, we try again,
+ * but keep our initial snapshot for purposes of checking for someone
+ * doing our work for us.
+ *
+ * If we fail too many times in a row, we fall back to synchronize_sched().
+ */
+void synchronize_sched_expedited(void)
+{
+	int firstsnap, s, snap, trycount = 0;
+
+	/* Note that atomic_inc_return() implies full memory barrier. */
+	firstsnap = snap = atomic_inc_return(&sync_sched_expedited_started);
+	get_online_cpus();
+
+	/*
+	 * Each pass through the following loop attempts to force a
+	 * context switch on each CPU.
+	 */
+	while (try_stop_cpus(cpu_online_mask,
+			     synchronize_sched_expedited_cpu_stop,
+			     NULL) == -EAGAIN) {
+		put_online_cpus();
+
+		/* No joy, try again later.  Or just synchronize_sched(). */
+		if (trycount++ < 10)
+			udelay(trycount * num_online_cpus());
+		else {
+			synchronize_sched();
+			return;
+		}
+
+		/* Check to see if someone else did our work for us. */
+		s = atomic_read(&sync_sched_expedited_done);
+		if (UINT_CMP_GE((unsigned)s, (unsigned)firstsnap)) {
+			smp_mb(); /* ensure test happens before caller kfree */
+			return;
+		}
+
+		/*
+		 * Refetching sync_sched_expedited_started allows later
+		 * callers to piggyback on our grace period.  We subtract
+		 * 1 to get the same token that the last incrementer got.
+		 * We retry after they started, so our grace period works
+		 * for them, and they started after our first try, so their
+		 * grace period works for us.
+		 */
+		get_online_cpus();
+		snap = atomic_read(&sync_sched_expedited_started) - 1;
+		smp_mb(); /* ensure read is before try_stop_cpus(). */
+	}
+
+	/*
+	 * Everyone up to our most recent fetch is covered by our grace
+	 * period.  Update the counter, but only if our work is still
+	 * relevant -- which it won't be if someone who started later
+	 * than we did beat us to the punch.
+	 */
+	do {
+		s = atomic_read(&sync_sched_expedited_done);
+		if (UINT_CMP_GE((unsigned)s, (unsigned)snap)) {
+			smp_mb(); /* ensure test happens before caller kfree */
+			break;
+		}
+	} while (atomic_cmpxchg(&sync_sched_expedited_done, s, snap) != s);
+
+	put_online_cpus();
+}
+EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
+
+#endif /* #else #ifndef CONFIG_SMP */
+
 #if !defined(CONFIG_RCU_FAST_NO_HZ)
 
 /*
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index d15430b..c8e9785 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -166,13 +166,13 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 
 	gpnum = rsp->gpnum;
 	seq_printf(m, "c=%lu g=%lu s=%d jfq=%ld j=%x "
-		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld\n",
+		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu\n",
 		   rsp->completed, gpnum, rsp->signaled,
 		   (long)(rsp->jiffies_force_qs - jiffies),
 		   (int)(jiffies & 0xffff),
 		   rsp->n_force_qs, rsp->n_force_qs_ngp,
 		   rsp->n_force_qs - rsp->n_force_qs_ngp,
-		   rsp->n_force_qs_lh, rsp->orphan_qlen);
+		   rsp->n_force_qs_lh);
 	for (rnp = &rsp->node[0]; rnp - &rsp->node[0] < NUM_RCU_NODES; rnp++) {
 		if (rnp->level != level) {
 			seq_puts(m, "\n");
@@ -300,7 +300,7 @@ static const struct file_operations rcu_pending_fops = {
 
 static struct dentry *rcudir;
 
-static int __init rcuclassic_trace_init(void)
+static int __init rcutree_trace_init(void)
 {
 	struct dentry *retval;
 
@@ -337,14 +337,14 @@ free_out:
 	return 1;
 }
 
-static void __exit rcuclassic_trace_cleanup(void)
+static void __exit rcutree_trace_cleanup(void)
 {
 	debugfs_remove_recursive(rcudir);
 }
 
 
-module_init(rcuclassic_trace_init);
-module_exit(rcuclassic_trace_cleanup);
+module_init(rcutree_trace_init);
+module_exit(rcutree_trace_cleanup);
 
 MODULE_AUTHOR("Paul E. McKenney");
 MODULE_DESCRIPTION("Read-Copy Update tracing for hierarchical implementation");
diff --git a/kernel/sched.c b/kernel/sched.c
index 297d1a0..e6f8f12 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9534,72 +9534,3 @@ struct cgroup_subsys cpuacct_subsys = {
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
 
-#ifndef CONFIG_SMP
-
-void synchronize_sched_expedited(void)
-{
-	barrier();
-}
-EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
-
-#else /* #ifndef CONFIG_SMP */
-
-static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
-
-static int synchronize_sched_expedited_cpu_stop(void *data)
-{
-	/*
-	 * There must be a full memory barrier on each affected CPU
-	 * between the time that try_stop_cpus() is called and the
-	 * time that it returns.
-	 *
-	 * In the current initial implementation of cpu_stop, the
-	 * above condition is already met when the control reaches
-	 * this point and the following smp_mb() is not strictly
-	 * necessary.  Do smp_mb() anyway for documentation and
-	 * robustness against future implementation changes.
-	 */
-	smp_mb(); /* See above comment block. */
-	return 0;
-}
-
-/*
- * Wait for an rcu-sched grace period to elapse, but use "big hammer"
- * approach to force grace period to end quickly.  This consumes
- * significant time on all CPUs, and is thus not recommended for
- * any sort of common-case code.
- *
- * Note that it is illegal to call this function while holding any
- * lock that is acquired by a CPU-hotplug notifier.  Failing to
- * observe this restriction will result in deadlock.
- */
-void synchronize_sched_expedited(void)
-{
-	int snap, trycount = 0;
-
-	smp_mb();  /* ensure prior mod happens before capturing snap. */
-	snap = atomic_read(&synchronize_sched_expedited_count) + 1;
-	get_online_cpus();
-	while (try_stop_cpus(cpu_online_mask,
-			     synchronize_sched_expedited_cpu_stop,
-			     NULL) == -EAGAIN) {
-		put_online_cpus();
-		if (trycount++ < 10)
-			udelay(trycount * num_online_cpus());
-		else {
-			synchronize_sched();
-			return;
-		}
-		if (atomic_read(&synchronize_sched_expedited_count) - snap > 0) {
-			smp_mb(); /* ensure test happens before caller kfree */
-			return;
-		}
-		get_online_cpus();
-	}
-	atomic_inc(&synchronize_sched_expedited_count);
-	smp_mb__after_atomic_inc(); /* ensure post-GP actions seen after GP. */
-	put_online_cpus();
-}
-EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
-
-#endif /* #else #ifndef CONFIG_SMP */
diff --git a/kernel/srcu.c b/kernel/srcu.c
index c71e075..98d8c1e 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -31,6 +31,7 @@
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
+#include <linux/delay.h>
 #include <linux/srcu.h>
 
 static int init_srcu_struct_fields(struct srcu_struct *sp)
@@ -203,9 +204,14 @@ static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
 	 * all srcu_read_lock() calls using the old counters have completed.
 	 * Their corresponding critical sections might well be still
 	 * executing, but the srcu_read_lock() primitives themselves
-	 * will have finished executing.
+	 * will have finished executing.  We initially give readers
+	 * an arbitrarily chosen 10 microseconds to get out of their
+	 * SRCU read-side critical sections, then loop waiting 1/HZ
+	 * seconds per iteration.
 	 */
 
+	if (srcu_readers_active_idx(sp, idx))
+		udelay(CONFIG_SRCU_SYNCHRONIZE_DELAY);
 	while (srcu_readers_active_idx(sp, idx))
 		schedule_timeout_interruptible(1);
 
