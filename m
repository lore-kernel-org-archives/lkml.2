Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab2EUU13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:27:29 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41542 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab2EUU1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:27:25 -0400
Date: Mon, 21 May 2012 22:27:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v3.5
Message-ID: <20120521202719.GA11178@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus

   HEAD: 2d84e023cb5ec00403ff5d447533c6fd58fcc7ff Merge branch 'rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu

This is the v3.5 RCU tree from Paul E. McKenney:

 1)	A set of improvements and fixes to the RCU_FAST_NO_HZ feature
	(with more on the way for 3.6).  Posted to LKML:
	https://lkml.org/lkml/2012/4/23/324 (commits 1-3 and 5),
	https://lkml.org/lkml/2012/4/16/611 (commit 4),
	https://lkml.org/lkml/2012/4/30/390 (commit 6), and
	https://lkml.org/lkml/2012/5/4/410 (commit 7, combined with
	the other commits for the convenience of the tester).

 2)	Changes to make rcu_barrier() avoid disrupting execution of CPUs
	that have no RCU callbacks.  Posted to LKML:
	https://lkml.org/lkml/2012/4/23/322.

 3)	A couple of commits that improve the efficiency of the interaction
	between preemptible RCU and the scheduler, these two being all
	that survived an abortive attempt to allow preemptible RCU's
	__rcu_read_lock() to be inlined.  The full set was posted to
	LKML at https://lkml.org/lkml/2012/4/14/143, and the first and
	third patches of that set remain.

 4)	Lai Jiangshan's algorithmic implementation of SRCU, which includes
	call_srcu() and srcu_barrier().  A major feature of this new
	implementation is that synchronize_srcu() no longer disturbs
	the execution of other CPUs.  This work is based on earlier
	implementations by Peter Zijlstra and Paul E. McKenney.  Posted to
	LKML: https://lkml.org/lkml/2012/2/22/82.

 5)	A number of miscellaneous bug fixes and improvements which were
	posted to LKML at: https://lkml.org/lkml/2012/4/23/353 with
	subsequent updates posted to LKML.

 Thanks,

	Ingo

------------------>
Dave Jones (1):
      rcu: List-debug variants of rcu list routines.

Jan Engelhardt (1):
      rcu: Make __kfree_rcu() less dependent on compiler choices

Lai Jiangshan (10):
      rcu: Remove fast check path from __synchronize_srcu()
      rcu: Increment upper bit only for srcu_read_lock()
      rcu: Flip ->completed only once per SRCU grace period
      rcu: Improve SRCU's wait_idx() comments
      rcu: Implement a variant of Peter's SRCU algorithm
      rcu: Remove unused srcu_barrier()
      rcu: Improve srcu_readers_active_idx()'s cache locality
      rcu: Use single value to handle expedited SRCU grace periods
      rcu: Implement per-domain single-threaded call_srcu() state machine
      rcu: Add rcutorture test for call_srcu()

Michel Machado (1):
      rcu: Replace list_first_entry_rcu() with list_first_or_null_rcu()

Paul E. McKenney (19):
      rcu: Clarify help text for RCU_BOOST_PRIO
      rcu: Reduce cache-miss initialization latencies for large systems
      rcu: Document kernel command-line parameters
      rcu: Document why rcu_blocking_is_gp() is safe
      rcu: Add RCU_FAST_NO_HZ tracing for idle exit
      rcu: Make RCU_FAST_NO_HZ use timer rather than hrtimer
      rcu: Make RCU_FAST_NO_HZ account for pauses out of idle
      rcu: Fixes to rcutorture error handling and cleanup
      rcu: Add warning for RCU_FAST_NO_HZ timer firing
      timer: Fix mod_timer_pinned() header comment
      rcu: Introduce rcutorture testing for rcu_barrier()
      rcu: Direct algorithmic SRCU implementation
      rcu: Ensure that RCU_FAST_NO_HZ timers expire on correct CPU
      rcu: Move PREEMPT_RCU preemption to switch_to() invocation
      rcu: Make exit_rcu() more precise and consolidate
      rcu: Update RCU maintainership
      rcu: Make RCU_FAST_NO_HZ handle timer migration
      rcu: Explicitly initialize RCU_FAST_NO_HZ per-CPU variables
      rcu: Make rcu_barrier() less disruptive


 Documentation/RCU/torture.txt       |   15 +-
 Documentation/kernel-parameters.txt |   88 ++++++-
 MAINTAINERS                         |   14 +-
 arch/um/drivers/mconsole_kern.c     |    1 +
 include/linux/rculist.h             |   40 +++-
 include/linux/rcupdate.h            |   20 ++
 include/linux/rcutiny.h             |   11 -
 include/linux/rcutree.h             |   19 --
 include/linux/sched.h               |   10 +
 include/linux/srcu.h                |   48 +++-
 include/trace/events/rcu.h          |    2 +
 init/Kconfig                        |   50 +++-
 kernel/rcupdate.c                   |   28 ++
 kernel/rcutiny_plugin.h             |   16 -
 kernel/rcutorture.c                 |  257 +++++++++++++++-
 kernel/rcutree.c                    |  332 ++++++++++++++++------
 kernel/rcutree.h                    |   23 +-
 kernel/rcutree_plugin.h             |  154 +++++++----
 kernel/rcutree_trace.c              |    4 +-
 kernel/sched/core.c                 |    1 +
 kernel/srcu.c                       |  548 +++++++++++++++++++++++++++-------
 kernel/timer.c                      |    8 +-
 lib/list_debug.c                    |   22 ++
 23 files changed, 1358 insertions(+), 353 deletions(-)

diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index 375d3fb..4ddf391 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -47,6 +47,16 @@ irqreader	Says to invoke RCU readers from irq level.  This is currently
 		permit this.  (Or, more accurately, variants of RCU that do
 		-not- permit this know to ignore this variable.)
 
+n_barrier_cbs	If this is nonzero, RCU barrier testing will be conducted,
+		in which case n_barrier_cbs specifies the number of
+		RCU callbacks (and corresponding kthreads) to use for
+		this testing.  The value cannot be negative.  If you
+		specify this to be non-zero when torture_type indicates a
+		synchronous RCU implementation (one for which a member of
+		the synchronize_rcu() rather than the call_rcu() family is
+		used -- see the documentation for torture_type below), an
+		error will be reported and no testing will be carried out.
+
 nfakewriters	This is the number of RCU fake writer threads to run.  Fake
 		writer threads repeatedly use the synchronous "wait for
 		current readers" function of the interface selected by
@@ -188,7 +198,7 @@ OUTPUT
 The statistics output is as follows:
 
 	rcu-torture:--- Start of test: nreaders=16 nfakewriters=4 stat_interval=30 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4
-	rcu-torture: rtc:           (null) ver: 155441 tfle: 0 rta: 155441 rtaf: 8884 rtf: 155440 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 3055767
+	rcu-torture: rtc:           (null) ver: 155441 tfle: 0 rta: 155441 rtaf: 8884 rtf: 155440 rtmbe: 0 rtbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 3055767
 	rcu-torture: Reader Pipe:  727860534 34213 0 0 0 0 0 0 0 0 0
 	rcu-torture: Reader Batch:  727877838 17003 0 0 0 0 0 0 0 0 0
 	rcu-torture: Free-Block Circulation:  155440 155440 155440 155440 155440 155440 155440 155440 155440 155440 0
@@ -230,6 +240,9 @@ o	"rtmbe": A non-zero value indicates that rcutorture believes that
 	rcu_assign_pointer() and rcu_dereference() are not working
 	correctly.  This value should be zero.
 
+o	"rtbe": A non-zero value indicates that one of the rcu_barrier()
+	family of functions is not working correctly.
+
 o	"rtbke": rcutorture was unable to create the real-time kthreads
 	used to force RCU priority inversion.  This value should be zero.
 
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c1601e5..ab84a01 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2330,18 +2330,100 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	ramdisk_size=	[RAM] Sizes of RAM disks in kilobytes
 			See Documentation/blockdev/ramdisk.txt.
 
-	rcupdate.blimit=	[KNL,BOOT]
+	rcutree.blimit=	[KNL,BOOT]
 			Set maximum number of finished RCU callbacks to process
 			in one batch.
 
-	rcupdate.qhimark=	[KNL,BOOT]
+	rcutree.qhimark=	[KNL,BOOT]
 			Set threshold of queued
 			RCU callbacks over which batch limiting is disabled.
 
-	rcupdate.qlowmark=	[KNL,BOOT]
+	rcutree.qlowmark=	[KNL,BOOT]
 			Set threshold of queued RCU callbacks below which
 			batch limiting is re-enabled.
 
+	rcutree.rcu_cpu_stall_suppress=	[KNL,BOOT]
+			Suppress RCU CPU stall warning messages.
+
+	rcutree.rcu_cpu_stall_timeout= [KNL,BOOT]
+			Set timeout for RCU CPU stall warning messages.
+
+	rcutorture.fqs_duration= [KNL,BOOT]
+			Set duration of force_quiescent_state bursts.
+
+	rcutorture.fqs_holdoff= [KNL,BOOT]
+			Set holdoff time within force_quiescent_state bursts.
+
+	rcutorture.fqs_stutter= [KNL,BOOT]
+			Set wait time between force_quiescent_state bursts.
+
+	rcutorture.irqreader= [KNL,BOOT]
+			Test RCU readers from irq handlers.
+
+	rcutorture.n_barrier_cbs= [KNL,BOOT]
+			Set callbacks/threads for rcu_barrier() testing.
+
+	rcutorture.nfakewriters= [KNL,BOOT]
+			Set number of concurrent RCU writers.  These just
+			stress RCU, they don't participate in the actual
+			test, hence the "fake".
+
+	rcutorture.nreaders= [KNL,BOOT]
+			Set number of RCU readers.
+
+	rcutorture.onoff_holdoff= [KNL,BOOT]
+			Set time (s) after boot for CPU-hotplug testing.
+
+	rcutorture.onoff_interval= [KNL,BOOT]
+			Set time (s) between CPU-hotplug operations, or
+			zero to disable CPU-hotplug testing.
+
+	rcutorture.shuffle_interval= [KNL,BOOT]
+			Set task-shuffle interval (s).  Shuffling tasks
+			allows some CPUs to go into dyntick-idle mode
+			during the rcutorture test.
+
+	rcutorture.shutdown_secs= [KNL,BOOT]
+			Set time (s) after boot system shutdown.  This
+			is useful for hands-off automated testing.
+
+	rcutorture.stall_cpu= [KNL,BOOT]
+			Duration of CPU stall (s) to test RCU CPU stall
+			warnings, zero to disable.
+
+	rcutorture.stall_cpu_holdoff= [KNL,BOOT]
+			Time to wait (s) after boot before inducing stall.
+
+	rcutorture.stat_interval= [KNL,BOOT]
+			Time (s) between statistics printk()s.
+
+	rcutorture.stutter= [KNL,BOOT]
+			Time (s) to stutter testing, for example, specifying
+			five seconds causes the test to run for five seconds,
+			wait for five seconds, and so on.  This tests RCU's
+			ability to transition abruptly to and from idle.
+
+	rcutorture.test_boost= [KNL,BOOT]
+			Test RCU priority boosting?  0=no, 1=maybe, 2=yes.
+			"Maybe" means test if the RCU implementation
+			under test support RCU priority boosting.
+
+	rcutorture.test_boost_duration= [KNL,BOOT]
+			Duration (s) of each individual boost test.
+
+	rcutorture.test_boost_interval= [KNL,BOOT]
+			Interval (s) between each boost test.
+
+	rcutorture.test_no_idle_hz= [KNL,BOOT]
+			Test RCU's dyntick-idle handling.  See also the
+			rcutorture.shuffle_interval parameter.
+
+	rcutorture.torture_type= [KNL,BOOT]
+			Specify the RCU implementation to test.
+
+	rcutorture.verbose= [KNL,BOOT]
+			Enable additional printk() statements.
+
 	rdinit=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /init from the ramdisk,
diff --git a/MAINTAINERS b/MAINTAINERS
index b362709..dff2450 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5608,14 +5608,13 @@ F:	net/rds/
 READ-COPY UPDATE (RCU)
 M:	Dipankar Sarma <dipankar@in.ibm.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
-W:	http://www.rdrop.com/users/paulmck/rclock/
+W:	http://www.rdrop.com/users/paulmck/RCU/
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
 F:	Documentation/RCU/
+X:	Documentation/RCU/torture.txt
 F:	include/linux/rcu*
-F:	include/linux/srcu*
 F:	kernel/rcu*
-F:	kernel/srcu*
 X:	kernel/rcutorture.c
 
 REAL TIME CLOCK (RTC) SUBSYSTEM
@@ -6132,6 +6131,15 @@ S:	Maintained
 F:	include/linux/sl?b*.h
 F:	mm/sl?b.c
 
+SLEEPABLE READ-COPY UPDATE (SRCU)
+M:	Lai Jiangshan <laijs@cn.fujitsu.com>
+M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+W:	http://www.rdrop.com/users/paulmck/RCU/
+S:	Supported
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
+F:	include/linux/srcu*
+F:	kernel/srcu*
+
 SMC91x ETHERNET DRIVER
 M:	Nicolas Pitre <nico@fluxnic.net>
 S:	Odd Fixes
diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 43b39d6..88e466b 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -705,6 +705,7 @@ static void stack_proc(void *arg)
 	struct task_struct *from = current, *to = arg;
 
 	to->thread.saved_task = from;
+	rcu_switch_from(from);
 	switch_to(from, to, from);
 }
 
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index d079290..e0f0fab 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -30,6 +30,7 @@
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
  */
+#ifndef CONFIG_DEBUG_LIST
 static inline void __list_add_rcu(struct list_head *new,
 		struct list_head *prev, struct list_head *next)
 {
@@ -38,6 +39,10 @@ static inline void __list_add_rcu(struct list_head *new,
 	rcu_assign_pointer(list_next_rcu(prev), new);
 	next->prev = new;
 }
+#else
+extern void __list_add_rcu(struct list_head *new,
+		struct list_head *prev, struct list_head *next);
+#endif
 
 /**
  * list_add_rcu - add a new entry to rcu-protected list
@@ -108,7 +113,7 @@ static inline void list_add_tail_rcu(struct list_head *new,
  */
 static inline void list_del_rcu(struct list_head *entry)
 {
-	__list_del(entry->prev, entry->next);
+	__list_del_entry(entry);
 	entry->prev = LIST_POISON2;
 }
 
@@ -228,18 +233,43 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	})
 
 /**
- * list_first_entry_rcu - get the first element from a list
+ * Where are list_empty_rcu() and list_first_entry_rcu()?
+ *
+ * Implementing those functions following their counterparts list_empty() and
+ * list_first_entry() is not advisable because they lead to subtle race
+ * conditions as the following snippet shows:
+ *
+ * if (!list_empty_rcu(mylist)) {
+ *	struct foo *bar = list_first_entry_rcu(mylist, struct foo, list_member);
+ *	do_something(bar);
+ * }
+ *
+ * The list may not be empty when list_empty_rcu checks it, but it may be when
+ * list_first_entry_rcu rereads the ->next pointer.
+ *
+ * Rereading the ->next pointer is not a problem for list_empty() and
+ * list_first_entry() because they would be protected by a lock that blocks
+ * writers.
+ *
+ * See list_first_or_null_rcu for an alternative.
+ */
+
+/**
+ * list_first_or_null_rcu - get the first element from a list
  * @ptr:        the list head to take the element from.
  * @type:       the type of the struct this is embedded in.
  * @member:     the name of the list_struct within the struct.
  *
- * Note, that list is expected to be not empty.
+ * Note that if the list is empty, it returns NULL.
  *
  * This primitive may safely run concurrently with the _rcu list-mutation
  * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
  */
-#define list_first_entry_rcu(ptr, type, member) \
-	list_entry_rcu((ptr)->next, type, member)
+#define list_first_or_null_rcu(ptr, type, member) \
+	({struct list_head *__ptr = (ptr); \
+	  struct list_head __rcu *__next = list_next_rcu(__ptr); \
+	  likely(__ptr != __next) ? container_of(__next, type, member) : NULL; \
+	})
 
 /**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 20fb776..26d1a47 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -184,12 +184,14 @@ static inline int rcu_preempt_depth(void)
 /* Internal to kernel */
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
+extern void rcu_preempt_note_context_switch(void);
 extern void rcu_check_callbacks(int cpu, int user);
 struct notifier_block;
 extern void rcu_idle_enter(void);
 extern void rcu_idle_exit(void);
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
+extern void exit_rcu(void);
 
 /**
  * RCU_NONIDLE - Indicate idle-loop code that needs RCU readers
@@ -922,6 +924,21 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
 	kfree_call_rcu(head, (rcu_callback)offset);
 }
 
+/*
+ * Does the specified offset indicate that the corresponding rcu_head
+ * structure can be handled by kfree_rcu()?
+ */
+#define __is_kfree_rcu_offset(offset) ((offset) < 4096)
+
+/*
+ * Helper macro for kfree_rcu() to prevent argument-expansion eyestrain.
+ */
+#define __kfree_rcu(head, offset) \
+	do { \
+		BUILD_BUG_ON(!__is_kfree_rcu_offset(offset)); \
+		call_rcu(head, (void (*)(struct rcu_head *))(unsigned long)(offset)); \
+	} while (0)
+
 /**
  * kfree_rcu() - kfree an object after a grace period.
  * @ptr:	pointer to kfree
@@ -944,6 +961,9 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
  *
  * Note that the allowable offset might decrease in the future, for example,
  * to allow something like kmem_cache_free_rcu().
+ *
+ * The BUILD_BUG_ON check must not involve any function calls, hence the
+ * checks are done in macros here.
  */
 #define kfree_rcu(ptr, rcu_head)					\
 	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index e93df77..adb5e5a 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -87,14 +87,6 @@ static inline void kfree_call_rcu(struct rcu_head *head,
 
 #ifdef CONFIG_TINY_RCU
 
-static inline void rcu_preempt_note_context_switch(void)
-{
-}
-
-static inline void exit_rcu(void)
-{
-}
-
 static inline int rcu_needs_cpu(int cpu)
 {
 	return 0;
@@ -102,8 +94,6 @@ static inline int rcu_needs_cpu(int cpu)
 
 #else /* #ifdef CONFIG_TINY_RCU */
 
-void rcu_preempt_note_context_switch(void);
-extern void exit_rcu(void);
 int rcu_preempt_needs_cpu(void);
 
 static inline int rcu_needs_cpu(int cpu)
@@ -116,7 +106,6 @@ static inline int rcu_needs_cpu(int cpu)
 static inline void rcu_note_context_switch(int cpu)
 {
 	rcu_sched_qs(cpu);
-	rcu_preempt_note_context_switch();
 }
 
 /*
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index e8ee5dd..3c6083c 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -45,18 +45,6 @@ static inline void rcu_virt_note_context_switch(int cpu)
 	rcu_note_context_switch(cpu);
 }
 
-#ifdef CONFIG_TREE_PREEMPT_RCU
-
-extern void exit_rcu(void);
-
-#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-
-static inline void exit_rcu(void)
-{
-}
-
-#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
-
 extern void synchronize_rcu_bh(void);
 extern void synchronize_sched_expedited(void);
 extern void synchronize_rcu_expedited(void);
@@ -98,13 +86,6 @@ extern void rcu_force_quiescent_state(void);
 extern void rcu_bh_force_quiescent_state(void);
 extern void rcu_sched_force_quiescent_state(void);
 
-/* A context switch is a grace period for RCU-sched and RCU-bh. */
-static inline int rcu_blocking_is_gp(void)
-{
-	might_sleep();  /* Check for RCU read-side critical section. */
-	return num_online_cpus() == 1;
-}
-
 extern void rcu_scheduler_starting(void);
 extern int rcu_scheduler_active __read_mostly;
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 81a173c..8f3fd94 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1905,12 +1905,22 @@ static inline void rcu_copy_process(struct task_struct *p)
 	INIT_LIST_HEAD(&p->rcu_node_entry);
 }
 
+static inline void rcu_switch_from(struct task_struct *prev)
+{
+	if (prev->rcu_read_lock_nesting != 0)
+		rcu_preempt_note_context_switch();
+}
+
 #else
 
 static inline void rcu_copy_process(struct task_struct *p)
 {
 }
 
+static inline void rcu_switch_from(struct task_struct *prev)
+{
+}
+
 #endif
 
 #ifdef CONFIG_SMP
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index d3d5fa5..55a5c52 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -29,26 +29,35 @@
 
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
+#include <linux/workqueue.h>
 
 struct srcu_struct_array {
-	int c[2];
+	unsigned long c[2];
+	unsigned long seq[2];
+};
+
+struct rcu_batch {
+	struct rcu_head *head, **tail;
 };
 
 struct srcu_struct {
-	int completed;
+	unsigned completed;
 	struct srcu_struct_array __percpu *per_cpu_ref;
-	struct mutex mutex;
+	spinlock_t queue_lock; /* protect ->batch_queue, ->running */
+	bool running;
+	/* callbacks just queued */
+	struct rcu_batch batch_queue;
+	/* callbacks try to do the first check_zero */
+	struct rcu_batch batch_check0;
+	/* callbacks done with the first check_zero and the flip */
+	struct rcu_batch batch_check1;
+	struct rcu_batch batch_done;
+	struct delayed_work work;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 };
 
-#ifndef CONFIG_PREEMPT
-#define srcu_barrier() barrier()
-#else /* #ifndef CONFIG_PREEMPT */
-#define srcu_barrier()
-#endif /* #else #ifndef CONFIG_PREEMPT */
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 int __init_srcu_struct(struct srcu_struct *sp, const char *name,
@@ -67,12 +76,33 @@ int init_srcu_struct(struct srcu_struct *sp);
 
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+/**
+ * call_srcu() - Queue a callback for invocation after an SRCU grace period
+ * @sp: srcu_struct in queue the callback
+ * @head: structure to be used for queueing the SRCU callback.
+ * @func: function to be invoked after the SRCU grace period
+ *
+ * The callback function will be invoked some time after a full SRCU
+ * grace period elapses, in other words after all pre-existing SRCU
+ * read-side critical sections have completed.  However, the callback
+ * function might well execute concurrently with other SRCU read-side
+ * critical sections that started after call_srcu() was invoked.  SRCU
+ * read-side critical sections are delimited by srcu_read_lock() and
+ * srcu_read_unlock(), and may be nested.
+ *
+ * The callback will be invoked from process context, but must nevertheless
+ * be fast and must not block.
+ */
+void call_srcu(struct srcu_struct *sp, struct rcu_head *head,
+		void (*func)(struct rcu_head *head));
+
 void cleanup_srcu_struct(struct srcu_struct *sp);
 int __srcu_read_lock(struct srcu_struct *sp) __acquires(sp);
 void __srcu_read_unlock(struct srcu_struct *sp, int idx) __releases(sp);
 void synchronize_srcu(struct srcu_struct *sp);
 void synchronize_srcu_expedited(struct srcu_struct *sp);
 long srcu_batches_completed(struct srcu_struct *sp);
+void srcu_barrier(struct srcu_struct *sp);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 3370997..1480900 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -292,6 +292,8 @@ TRACE_EVENT(rcu_dyntick,
  *	"More callbacks": Still more callbacks, try again to clear them out.
  *	"Callbacks drained": All callbacks processed, off to dyntick idle!
  *	"Timer": Timer fired to cause CPU to continue processing callbacks.
+ *	"Demigrate": Timer fired on wrong CPU, woke up correct CPU.
+ *	"Cleanup after idle": Idle exited, timer canceled.
  */
 TRACE_EVENT(rcu_prep_idle,
 
diff --git a/init/Kconfig b/init/Kconfig
index 6cfd71d..6d18ef8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -458,6 +458,33 @@ config RCU_FANOUT
 	  Select a specific number if testing RCU itself.
 	  Take the default if unsure.
 
+config RCU_FANOUT_LEAF
+	int "Tree-based hierarchical RCU leaf-level fanout value"
+	range 2 RCU_FANOUT if 64BIT
+	range 2 RCU_FANOUT if !64BIT
+	depends on TREE_RCU || TREE_PREEMPT_RCU
+	default 16
+	help
+	  This option controls the leaf-level fanout of hierarchical
+	  implementations of RCU, and allows trading off cache misses
+	  against lock contention.  Systems that synchronize their
+	  scheduling-clock interrupts for energy-efficiency reasons will
+	  want the default because the smaller leaf-level fanout keeps
+	  lock contention levels acceptably low.  Very large systems
+	  (hundreds or thousands of CPUs) will instead want to set this
+	  value to the maximum value possible in order to reduce the
+	  number of cache misses incurred during RCU's grace-period
+	  initialization.  These systems tend to run CPU-bound, and thus
+	  are not helped by synchronized interrupts, and thus tend to
+	  skew them, which reduces lock contention enough that large
+	  leaf-level fanouts work well.
+
+	  Select a specific number if testing RCU itself.
+
+	  Select the maximum permissible value for large systems.
+
+	  Take the default if unsure.
+
 config RCU_FANOUT_EXACT
 	bool "Disable tree-based hierarchical RCU auto-balancing"
 	depends on TREE_RCU || TREE_PREEMPT_RCU
@@ -515,10 +542,25 @@ config RCU_BOOST_PRIO
 	depends on RCU_BOOST
 	default 1
 	help
-	  This option specifies the real-time priority to which preempted
-	  RCU readers are to be boosted.  If you are working with CPU-bound
-	  real-time applications, you should specify a priority higher then
-	  the highest-priority CPU-bound application.
+	  This option specifies the real-time priority to which long-term
+	  preempted RCU readers are to be boosted.  If you are working
+	  with a real-time application that has one or more CPU-bound
+	  threads running at a real-time priority level, you should set
+	  RCU_BOOST_PRIO to a priority higher then the highest-priority
+	  real-time CPU-bound thread.  The default RCU_BOOST_PRIO value
+	  of 1 is appropriate in the common case, which is real-time
+	  applications that do not have any CPU-bound threads.
+
+	  Some real-time applications might not have a single real-time
+	  thread that saturates a given CPU, but instead might have
+	  multiple real-time threads that, taken together, fully utilize
+	  that CPU.  In this case, you should set RCU_BOOST_PRIO to
+	  a priority higher than the lowest-priority thread that is
+	  conspiring to prevent the CPU from running any non-real-time
+	  tasks.  For example, if one thread at priority 10 and another
+	  thread at priority 5 are between themselves fully consuming
+	  the CPU time on a given CPU, then RCU_BOOST_PRIO should be
+	  set to priority 6 or higher.
 
 	  Specify the real-time priority, or take the default if unsure.
 
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index a86f174..95cba41 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -51,6 +51,34 @@
 
 #include "rcu.h"
 
+#ifdef CONFIG_PREEMPT_RCU
+
+/*
+ * Check for a task exiting while in a preemptible-RCU read-side
+ * critical section, clean up if so.  No need to issue warnings,
+ * as debug_check_no_locks_held() already does this if lockdep
+ * is enabled.
+ */
+void exit_rcu(void)
+{
+	struct task_struct *t = current;
+
+	if (likely(list_empty(&current->rcu_node_entry)))
+		return;
+	t->rcu_read_lock_nesting = 1;
+	barrier();
+	t->rcu_read_unlock_special = RCU_READ_UNLOCK_BLOCKED;
+	__rcu_read_unlock();
+}
+
+#else /* #ifdef CONFIG_PREEMPT_RCU */
+
+void exit_rcu(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
 struct lockdep_map rcu_lock_map =
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 22ecea0..fc31a2d 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -851,22 +851,6 @@ int rcu_preempt_needs_cpu(void)
 	return rcu_preempt_ctrlblk.rcb.rcucblist != NULL;
 }
 
-/*
- * Check for a task exiting while in a preemptible -RCU read-side
- * critical section, clean up if so.  No need to issue warnings,
- * as debug_check_no_locks_held() already does this if lockdep
- * is enabled.
- */
-void exit_rcu(void)
-{
-	struct task_struct *t = current;
-
-	if (t->rcu_read_lock_nesting == 0)
-		return;
-	t->rcu_read_lock_nesting = 1;
-	__rcu_read_unlock();
-}
-
 #else /* #ifdef CONFIG_TINY_PREEMPT_RCU */
 
 #ifdef CONFIG_RCU_TRACE
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index a89b381..e66b34a 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -64,6 +64,7 @@ static int irqreader = 1;	/* RCU readers from irq (timers). */
 static int fqs_duration;	/* Duration of bursts (us), 0 to disable. */
 static int fqs_holdoff;		/* Hold time within burst (us). */
 static int fqs_stutter = 3;	/* Wait time between bursts (s). */
+static int n_barrier_cbs;	/* Number of callbacks to test RCU barriers. */
 static int onoff_interval;	/* Wait time between CPU hotplugs, 0=disable. */
 static int onoff_holdoff;	/* Seconds after boot before CPU hotplugs. */
 static int shutdown_secs;	/* Shutdown time (s).  <=0 for no shutdown. */
@@ -96,6 +97,8 @@ module_param(fqs_holdoff, int, 0444);
 MODULE_PARM_DESC(fqs_holdoff, "Holdoff time within fqs bursts (us)");
 module_param(fqs_stutter, int, 0444);
 MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
+module_param(n_barrier_cbs, int, 0444);
+MODULE_PARM_DESC(n_barrier_cbs, "# of callbacks/kthreads for barrier testing");
 module_param(onoff_interval, int, 0444);
 MODULE_PARM_DESC(onoff_interval, "Time between CPU hotplugs (s), 0=disable");
 module_param(onoff_holdoff, int, 0444);
@@ -139,6 +142,8 @@ static struct task_struct *shutdown_task;
 static struct task_struct *onoff_task;
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 static struct task_struct *stall_task;
+static struct task_struct **barrier_cbs_tasks;
+static struct task_struct *barrier_task;
 
 #define RCU_TORTURE_PIPE_LEN 10
 
@@ -164,6 +169,7 @@ static atomic_t n_rcu_torture_alloc_fail;
 static atomic_t n_rcu_torture_free;
 static atomic_t n_rcu_torture_mberror;
 static atomic_t n_rcu_torture_error;
+static long n_rcu_torture_barrier_error;
 static long n_rcu_torture_boost_ktrerror;
 static long n_rcu_torture_boost_rterror;
 static long n_rcu_torture_boost_failure;
@@ -173,6 +179,8 @@ static long n_offline_attempts;
 static long n_offline_successes;
 static long n_online_attempts;
 static long n_online_successes;
+static long n_barrier_attempts;
+static long n_barrier_successes;
 static struct list_head rcu_torture_removed;
 static cpumask_var_t shuffle_tmp_mask;
 
@@ -197,6 +205,10 @@ static unsigned long shutdown_time;	/* jiffies to system shutdown. */
 static unsigned long boost_starttime;	/* jiffies of next boost test start. */
 DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
 					/*  and boost task create/destroy. */
+static atomic_t barrier_cbs_count;	/* Barrier callbacks registered. */
+static atomic_t barrier_cbs_invoked;	/* Barrier callbacks invoked. */
+static wait_queue_head_t *barrier_cbs_wq; /* Coordinate barrier testing. */
+static DECLARE_WAIT_QUEUE_HEAD(barrier_wq);
 
 /* Mediate rmmod and system shutdown.  Concurrent rmmod & shutdown illegal! */
 
@@ -327,6 +339,7 @@ struct rcu_torture_ops {
 	int (*completed)(void);
 	void (*deferred_free)(struct rcu_torture *p);
 	void (*sync)(void);
+	void (*call)(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 	void (*cb_barrier)(void);
 	void (*fqs)(void);
 	int (*stats)(char *page);
@@ -417,6 +430,7 @@ static struct rcu_torture_ops rcu_ops = {
 	.completed	= rcu_torture_completed,
 	.deferred_free	= rcu_torture_deferred_free,
 	.sync		= synchronize_rcu,
+	.call		= call_rcu,
 	.cb_barrier	= rcu_barrier,
 	.fqs		= rcu_force_quiescent_state,
 	.stats		= NULL,
@@ -460,6 +474,7 @@ static struct rcu_torture_ops rcu_sync_ops = {
 	.completed	= rcu_torture_completed,
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= synchronize_rcu,
+	.call		= NULL,
 	.cb_barrier	= NULL,
 	.fqs		= rcu_force_quiescent_state,
 	.stats		= NULL,
@@ -477,6 +492,7 @@ static struct rcu_torture_ops rcu_expedited_ops = {
 	.completed	= rcu_no_completed,
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= synchronize_rcu_expedited,
+	.call		= NULL,
 	.cb_barrier	= NULL,
 	.fqs		= rcu_force_quiescent_state,
 	.stats		= NULL,
@@ -519,6 +535,7 @@ static struct rcu_torture_ops rcu_bh_ops = {
 	.completed	= rcu_bh_torture_completed,
 	.deferred_free	= rcu_bh_torture_deferred_free,
 	.sync		= synchronize_rcu_bh,
+	.call		= call_rcu_bh,
 	.cb_barrier	= rcu_barrier_bh,
 	.fqs		= rcu_bh_force_quiescent_state,
 	.stats		= NULL,
@@ -535,6 +552,7 @@ static struct rcu_torture_ops rcu_bh_sync_ops = {
 	.completed	= rcu_bh_torture_completed,
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= synchronize_rcu_bh,
+	.call		= NULL,
 	.cb_barrier	= NULL,
 	.fqs		= rcu_bh_force_quiescent_state,
 	.stats		= NULL,
@@ -551,6 +569,7 @@ static struct rcu_torture_ops rcu_bh_expedited_ops = {
 	.completed	= rcu_bh_torture_completed,
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= synchronize_rcu_bh_expedited,
+	.call		= NULL,
 	.cb_barrier	= NULL,
 	.fqs		= rcu_bh_force_quiescent_state,
 	.stats		= NULL,
@@ -606,6 +625,11 @@ static int srcu_torture_completed(void)
 	return srcu_batches_completed(&srcu_ctl);
 }
 
+static void srcu_torture_deferred_free(struct rcu_torture *rp)
+{
+	call_srcu(&srcu_ctl, &rp->rtort_rcu, rcu_torture_cb);
+}
+
 static void srcu_torture_synchronize(void)
 {
 	synchronize_srcu(&srcu_ctl);
@@ -620,7 +644,7 @@ static int srcu_torture_stats(char *page)
 	cnt += sprintf(&page[cnt], "%s%s per-CPU(idx=%d):",
 		       torture_type, TORTURE_FLAG, idx);
 	for_each_possible_cpu(cpu) {
-		cnt += sprintf(&page[cnt], " %d(%d,%d)", cpu,
+		cnt += sprintf(&page[cnt], " %d(%lu,%lu)", cpu,
 			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx],
 			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx]);
 	}
@@ -635,13 +659,29 @@ static struct rcu_torture_ops srcu_ops = {
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock,
 	.completed	= srcu_torture_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
+	.deferred_free	= srcu_torture_deferred_free,
 	.sync		= srcu_torture_synchronize,
+	.call		= NULL,
 	.cb_barrier	= NULL,
 	.stats		= srcu_torture_stats,
 	.name		= "srcu"
 };
 
+static struct rcu_torture_ops srcu_sync_ops = {
+	.init		= srcu_torture_init,
+	.cleanup	= srcu_torture_cleanup,
+	.readlock	= srcu_torture_read_lock,
+	.read_delay	= srcu_read_delay,
+	.readunlock	= srcu_torture_read_unlock,
+	.completed	= srcu_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= srcu_torture_synchronize,
+	.call		= NULL,
+	.cb_barrier	= NULL,
+	.stats		= srcu_torture_stats,
+	.name		= "srcu_sync"
+};
+
 static int srcu_torture_read_lock_raw(void) __acquires(&srcu_ctl)
 {
 	return srcu_read_lock_raw(&srcu_ctl);
@@ -659,13 +699,29 @@ static struct rcu_torture_ops srcu_raw_ops = {
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock_raw,
 	.completed	= srcu_torture_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
+	.deferred_free	= srcu_torture_deferred_free,
 	.sync		= srcu_torture_synchronize,
+	.call		= NULL,
 	.cb_barrier	= NULL,
 	.stats		= srcu_torture_stats,
 	.name		= "srcu_raw"
 };
 
+static struct rcu_torture_ops srcu_raw_sync_ops = {
+	.init		= srcu_torture_init,
+	.cleanup	= srcu_torture_cleanup,
+	.readlock	= srcu_torture_read_lock_raw,
+	.read_delay	= srcu_read_delay,
+	.readunlock	= srcu_torture_read_unlock_raw,
+	.completed	= srcu_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= srcu_torture_synchronize,
+	.call		= NULL,
+	.cb_barrier	= NULL,
+	.stats		= srcu_torture_stats,
+	.name		= "srcu_raw_sync"
+};
+
 static void srcu_torture_synchronize_expedited(void)
 {
 	synchronize_srcu_expedited(&srcu_ctl);
@@ -680,6 +736,7 @@ static struct rcu_torture_ops srcu_expedited_ops = {
 	.completed	= srcu_torture_completed,
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= srcu_torture_synchronize_expedited,
+	.call		= NULL,
 	.cb_barrier	= NULL,
 	.stats		= srcu_torture_stats,
 	.name		= "srcu_expedited"
@@ -1129,7 +1186,8 @@ rcu_torture_printk(char *page)
 		       "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d "
 		       "rtmbe: %d rtbke: %ld rtbre: %ld "
 		       "rtbf: %ld rtb: %ld nt: %ld "
-		       "onoff: %ld/%ld:%ld/%ld",
+		       "onoff: %ld/%ld:%ld/%ld "
+		       "barrier: %ld/%ld:%ld",
 		       rcu_torture_current,
 		       rcu_torture_current_version,
 		       list_empty(&rcu_torture_freelist),
@@ -1145,14 +1203,17 @@ rcu_torture_printk(char *page)
 		       n_online_successes,
 		       n_online_attempts,
 		       n_offline_successes,
-		       n_offline_attempts);
+		       n_offline_attempts,
+		       n_barrier_successes,
+		       n_barrier_attempts,
+		       n_rcu_torture_barrier_error);
+	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
 	if (atomic_read(&n_rcu_torture_mberror) != 0 ||
+	    n_rcu_torture_barrier_error != 0 ||
 	    n_rcu_torture_boost_ktrerror != 0 ||
 	    n_rcu_torture_boost_rterror != 0 ||
-	    n_rcu_torture_boost_failure != 0)
-		cnt += sprintf(&page[cnt], " !!!");
-	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
-	if (i > 1) {
+	    n_rcu_torture_boost_failure != 0 ||
+	    i > 1) {
 		cnt += sprintf(&page[cnt], "!!! ");
 		atomic_inc(&n_rcu_torture_error);
 		WARN_ON_ONCE(1);
@@ -1337,6 +1398,7 @@ static void rcutorture_booster_cleanup(int cpu)
 
 	/* This must be outside of the mutex, otherwise deadlock! */
 	kthread_stop(t);
+	boost_tasks[cpu] = NULL;
 }
 
 static int rcutorture_booster_init(int cpu)
@@ -1484,13 +1546,15 @@ static void rcu_torture_onoff_cleanup(void)
 		return;
 	VERBOSE_PRINTK_STRING("Stopping rcu_torture_onoff task");
 	kthread_stop(onoff_task);
+	onoff_task = NULL;
 }
 
 #else /* #ifdef CONFIG_HOTPLUG_CPU */
 
-static void
+static int
 rcu_torture_onoff_init(void)
 {
+	return 0;
 }
 
 static void rcu_torture_onoff_cleanup(void)
@@ -1554,6 +1618,152 @@ static void rcu_torture_stall_cleanup(void)
 		return;
 	VERBOSE_PRINTK_STRING("Stopping rcu_torture_stall_task.");
 	kthread_stop(stall_task);
+	stall_task = NULL;
+}
+
+/* Callback function for RCU barrier testing. */
+void rcu_torture_barrier_cbf(struct rcu_head *rcu)
+{
+	atomic_inc(&barrier_cbs_invoked);
+}
+
+/* kthread function to register callbacks used to test RCU barriers. */
+static int rcu_torture_barrier_cbs(void *arg)
+{
+	long myid = (long)arg;
+	struct rcu_head rcu;
+
+	init_rcu_head_on_stack(&rcu);
+	VERBOSE_PRINTK_STRING("rcu_torture_barrier_cbs task started");
+	set_user_nice(current, 19);
+	do {
+		wait_event(barrier_cbs_wq[myid],
+			   atomic_read(&barrier_cbs_count) == n_barrier_cbs ||
+			   kthread_should_stop() ||
+			   fullstop != FULLSTOP_DONTSTOP);
+		if (kthread_should_stop() || fullstop != FULLSTOP_DONTSTOP)
+			break;
+		cur_ops->call(&rcu, rcu_torture_barrier_cbf);
+		if (atomic_dec_and_test(&barrier_cbs_count))
+			wake_up(&barrier_wq);
+	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
+	VERBOSE_PRINTK_STRING("rcu_torture_barrier_cbs task stopping");
+	rcutorture_shutdown_absorb("rcu_torture_barrier_cbs");
+	while (!kthread_should_stop())
+		schedule_timeout_interruptible(1);
+	cur_ops->cb_barrier();
+	destroy_rcu_head_on_stack(&rcu);
+	return 0;
+}
+
+/* kthread function to drive and coordinate RCU barrier testing. */
+static int rcu_torture_barrier(void *arg)
+{
+	int i;
+
+	VERBOSE_PRINTK_STRING("rcu_torture_barrier task starting");
+	do {
+		atomic_set(&barrier_cbs_invoked, 0);
+		atomic_set(&barrier_cbs_count, n_barrier_cbs);
+		/* wake_up() path contains the required barriers. */
+		for (i = 0; i < n_barrier_cbs; i++)
+			wake_up(&barrier_cbs_wq[i]);
+		wait_event(barrier_wq,
+			   atomic_read(&barrier_cbs_count) == 0 ||
+			   kthread_should_stop() ||
+			   fullstop != FULLSTOP_DONTSTOP);
+		if (kthread_should_stop() || fullstop != FULLSTOP_DONTSTOP)
+			break;
+		n_barrier_attempts++;
+		cur_ops->cb_barrier();
+		if (atomic_read(&barrier_cbs_invoked) != n_barrier_cbs) {
+			n_rcu_torture_barrier_error++;
+			WARN_ON_ONCE(1);
+		}
+		n_barrier_successes++;
+		schedule_timeout_interruptible(HZ / 10);
+	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
+	VERBOSE_PRINTK_STRING("rcu_torture_barrier task stopping");
+	rcutorture_shutdown_absorb("rcu_torture_barrier_cbs");
+	while (!kthread_should_stop())
+		schedule_timeout_interruptible(1);
+	return 0;
+}
+
+/* Initialize RCU barrier testing. */
+static int rcu_torture_barrier_init(void)
+{
+	int i;
+	int ret;
+
+	if (n_barrier_cbs == 0)
+		return 0;
+	if (cur_ops->call == NULL || cur_ops->cb_barrier == NULL) {
+		printk(KERN_ALERT "%s" TORTURE_FLAG
+		       " Call or barrier ops missing for %s,\n",
+		       torture_type, cur_ops->name);
+		printk(KERN_ALERT "%s" TORTURE_FLAG
+		       " RCU barrier testing omitted from run.\n",
+		       torture_type);
+		return 0;
+	}
+	atomic_set(&barrier_cbs_count, 0);
+	atomic_set(&barrier_cbs_invoked, 0);
+	barrier_cbs_tasks =
+		kzalloc(n_barrier_cbs * sizeof(barrier_cbs_tasks[0]),
+			GFP_KERNEL);
+	barrier_cbs_wq =
+		kzalloc(n_barrier_cbs * sizeof(barrier_cbs_wq[0]),
+			GFP_KERNEL);
+	if (barrier_cbs_tasks == NULL || barrier_cbs_wq == 0)
+		return -ENOMEM;
+	for (i = 0; i < n_barrier_cbs; i++) {
+		init_waitqueue_head(&barrier_cbs_wq[i]);
+		barrier_cbs_tasks[i] = kthread_run(rcu_torture_barrier_cbs,
+						   (void *)(long)i,
+						   "rcu_torture_barrier_cbs");
+		if (IS_ERR(barrier_cbs_tasks[i])) {
+			ret = PTR_ERR(barrier_cbs_tasks[i]);
+			VERBOSE_PRINTK_ERRSTRING("Failed to create rcu_torture_barrier_cbs");
+			barrier_cbs_tasks[i] = NULL;
+			return ret;
+		}
+	}
+	barrier_task = kthread_run(rcu_torture_barrier, NULL,
+				   "rcu_torture_barrier");
+	if (IS_ERR(barrier_task)) {
+		ret = PTR_ERR(barrier_task);
+		VERBOSE_PRINTK_ERRSTRING("Failed to create rcu_torture_barrier");
+		barrier_task = NULL;
+	}
+	return 0;
+}
+
+/* Clean up after RCU barrier testing. */
+static void rcu_torture_barrier_cleanup(void)
+{
+	int i;
+
+	if (barrier_task != NULL) {
+		VERBOSE_PRINTK_STRING("Stopping rcu_torture_barrier task");
+		kthread_stop(barrier_task);
+		barrier_task = NULL;
+	}
+	if (barrier_cbs_tasks != NULL) {
+		for (i = 0; i < n_barrier_cbs; i++) {
+			if (barrier_cbs_tasks[i] != NULL) {
+				VERBOSE_PRINTK_STRING("Stopping rcu_torture_barrier_cbs task");
+				kthread_stop(barrier_cbs_tasks[i]);
+				barrier_cbs_tasks[i] = NULL;
+			}
+		}
+		kfree(barrier_cbs_tasks);
+		barrier_cbs_tasks = NULL;
+	}
+	if (barrier_cbs_wq != NULL) {
+		kfree(barrier_cbs_wq);
+		barrier_cbs_wq = NULL;
+	}
 }
 
 static int rcutorture_cpu_notify(struct notifier_block *self,
@@ -1598,6 +1808,7 @@ rcu_torture_cleanup(void)
 	fullstop = FULLSTOP_RMMOD;
 	mutex_unlock(&fullstop_mutex);
 	unregister_reboot_notifier(&rcutorture_shutdown_nb);
+	rcu_torture_barrier_cleanup();
 	rcu_torture_stall_cleanup();
 	if (stutter_task) {
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_stutter task");
@@ -1665,6 +1876,7 @@ rcu_torture_cleanup(void)
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_shutdown task");
 		kthread_stop(shutdown_task);
 	}
+	shutdown_task = NULL;
 	rcu_torture_onoff_cleanup();
 
 	/* Wait for all RCU callbacks to fire.  */
@@ -1676,7 +1888,7 @@ rcu_torture_cleanup(void)
 
 	if (cur_ops->cleanup)
 		cur_ops->cleanup();
-	if (atomic_read(&n_rcu_torture_error))
+	if (atomic_read(&n_rcu_torture_error) || n_rcu_torture_barrier_error)
 		rcu_torture_print_module_parms(cur_ops, "End of test: FAILURE");
 	else if (n_online_successes != n_online_attempts ||
 		 n_offline_successes != n_offline_attempts)
@@ -1692,10 +1904,12 @@ rcu_torture_init(void)
 	int i;
 	int cpu;
 	int firsterr = 0;
+	int retval;
 	static struct rcu_torture_ops *torture_ops[] =
 		{ &rcu_ops, &rcu_sync_ops, &rcu_expedited_ops,
 		  &rcu_bh_ops, &rcu_bh_sync_ops, &rcu_bh_expedited_ops,
-		  &srcu_ops, &srcu_raw_ops, &srcu_expedited_ops,
+		  &srcu_ops, &srcu_sync_ops, &srcu_raw_ops,
+		  &srcu_raw_sync_ops, &srcu_expedited_ops,
 		  &sched_ops, &sched_sync_ops, &sched_expedited_ops, };
 
 	mutex_lock(&fullstop_mutex);
@@ -1749,6 +1963,7 @@ rcu_torture_init(void)
 	atomic_set(&n_rcu_torture_free, 0);
 	atomic_set(&n_rcu_torture_mberror, 0);
 	atomic_set(&n_rcu_torture_error, 0);
+	n_rcu_torture_barrier_error = 0;
 	n_rcu_torture_boost_ktrerror = 0;
 	n_rcu_torture_boost_rterror = 0;
 	n_rcu_torture_boost_failure = 0;
@@ -1872,7 +2087,6 @@ rcu_torture_init(void)
 		test_boost_duration = 2;
 	if ((test_boost == 1 && cur_ops->can_boost) ||
 	    test_boost == 2) {
-		int retval;
 
 		boost_starttime = jiffies + test_boost_interval * HZ;
 		register_cpu_notifier(&rcutorture_cpu_nb);
@@ -1897,9 +2111,22 @@ rcu_torture_init(void)
 			goto unwind;
 		}
 	}
-	rcu_torture_onoff_init();
+	i = rcu_torture_onoff_init();
+	if (i != 0) {
+		firsterr = i;
+		goto unwind;
+	}
 	register_reboot_notifier(&rcutorture_shutdown_nb);
-	rcu_torture_stall_init();
+	i = rcu_torture_stall_init();
+	if (i != 0) {
+		firsterr = i;
+		goto unwind;
+	}
+	retval = rcu_torture_barrier_init();
+	if (retval != 0) {
+		firsterr = retval;
+		goto unwind;
+	}
 	rcutorture_record_test_transition();
 	mutex_unlock(&fullstop_mutex);
 	return 0;
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d0c5baf..0da7b88 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -75,6 +75,8 @@ static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
 	.gpnum = -300, \
 	.completed = -300, \
 	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&structname##_state.onofflock), \
+	.orphan_nxttail = &structname##_state.orphan_nxtlist, \
+	.orphan_donetail = &structname##_state.orphan_donelist, \
 	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&structname##_state.fqslock), \
 	.n_force_qs = 0, \
 	.n_force_qs_ngp = 0, \
@@ -145,6 +147,13 @@ static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
 unsigned long rcutorture_testseq;
 unsigned long rcutorture_vernum;
 
+/* State information for rcu_barrier() and friends. */
+
+static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
+static atomic_t rcu_barrier_cpu_count;
+static DEFINE_MUTEX(rcu_barrier_mutex);
+static struct completion rcu_barrier_completion;
+
 /*
  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
  * permit this function to be invoked without holding the root rcu_node
@@ -192,7 +201,6 @@ void rcu_note_context_switch(int cpu)
 {
 	trace_rcu_utilization("Start context switch");
 	rcu_sched_qs(cpu);
-	rcu_preempt_note_context_switch(cpu);
 	trace_rcu_utilization("End context switch");
 }
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
@@ -1311,95 +1319,133 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 #ifdef CONFIG_HOTPLUG_CPU
 
 /*
- * Move a dying CPU's RCU callbacks to online CPU's callback list.
- * Also record a quiescent state for this CPU for the current grace period.
- * Synchronization and interrupt disabling are not required because
- * this function executes in stop_machine() context.  Therefore, cleanup
- * operations that might block must be done later from the CPU_DEAD
- * notifier.
- *
- * Note that the outgoing CPU's bit has already been cleared in the
- * cpu_online_mask.  This allows us to randomly pick a callback
- * destination from the bits set in that mask.
+ * Send the specified CPU's RCU callbacks to the orphanage.  The
+ * specified CPU must be offline, and the caller must hold the
+ * ->onofflock.
  */
-static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
+static void
+rcu_send_cbs_to_orphanage(int cpu, struct rcu_state *rsp,
+			  struct rcu_node *rnp, struct rcu_data *rdp)
 {
 	int i;
-	unsigned long mask;
-	int receive_cpu = cpumask_any(cpu_online_mask);
-	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
-	struct rcu_data *receive_rdp = per_cpu_ptr(rsp->rda, receive_cpu);
-	RCU_TRACE(struct rcu_node *rnp = rdp->mynode); /* For dying CPU. */
 
-	/* First, adjust the counts. */
+	/*
+	 * Orphan the callbacks.  First adjust the counts.  This is safe
+	 * because ->onofflock excludes _rcu_barrier()'s adoption of
+	 * the callbacks, thus no memory barrier is required.
+	 */
 	if (rdp->nxtlist != NULL) {
-		receive_rdp->qlen_lazy += rdp->qlen_lazy;
-		receive_rdp->qlen += rdp->qlen;
+		rsp->qlen_lazy += rdp->qlen_lazy;
+		rsp->qlen += rdp->qlen;
+		rdp->n_cbs_orphaned += rdp->qlen;
 		rdp->qlen_lazy = 0;
 		rdp->qlen = 0;
 	}
 
 	/*
-	 * Next, move ready-to-invoke callbacks to be invoked on some
-	 * other CPU.  These will not be required to pass through another
-	 * grace period:  They are done, regardless of CPU.
+	 * Next, move those callbacks still needing a grace period to
+	 * the orphanage, where some other CPU will pick them up.
+	 * Some of the callbacks might have gone partway through a grace
+	 * period, but that is too bad.  They get to start over because we
+	 * cannot assume that grace periods are synchronized across CPUs.
+	 * We don't bother updating the ->nxttail[] array yet, instead
+	 * we just reset the whole thing later on.
 	 */
-	if (rdp->nxtlist != NULL &&
-	    rdp->nxttail[RCU_DONE_TAIL] != &rdp->nxtlist) {
-		struct rcu_head *oldhead;
-		struct rcu_head **oldtail;
-		struct rcu_head **newtail;
-
-		oldhead = rdp->nxtlist;
-		oldtail = receive_rdp->nxttail[RCU_DONE_TAIL];
-		rdp->nxtlist = *rdp->nxttail[RCU_DONE_TAIL];
-		*rdp->nxttail[RCU_DONE_TAIL] = *oldtail;
-		*receive_rdp->nxttail[RCU_DONE_TAIL] = oldhead;
-		newtail = rdp->nxttail[RCU_DONE_TAIL];
-		for (i = RCU_DONE_TAIL; i < RCU_NEXT_SIZE; i++) {
-			if (receive_rdp->nxttail[i] == oldtail)
-				receive_rdp->nxttail[i] = newtail;
-			if (rdp->nxttail[i] == newtail)
-				rdp->nxttail[i] = &rdp->nxtlist;
-		}
+	if (*rdp->nxttail[RCU_DONE_TAIL] != NULL) {
+		*rsp->orphan_nxttail = *rdp->nxttail[RCU_DONE_TAIL];
+		rsp->orphan_nxttail = rdp->nxttail[RCU_NEXT_TAIL];
+		*rdp->nxttail[RCU_DONE_TAIL] = NULL;
 	}
 
 	/*
-	 * Finally, put the rest of the callbacks at the end of the list.
-	 * The ones that made it partway through get to start over:  We
-	 * cannot assume that grace periods are synchronized across CPUs.
-	 * (We could splice RCU_WAIT_TAIL into RCU_NEXT_READY_TAIL, but
-	 * this does not seem compelling.  Not yet, anyway.)
+	 * Then move the ready-to-invoke callbacks to the orphanage,
+	 * where some other CPU will pick them up.  These will not be
+	 * required to pass though another grace period: They are done.
 	 */
 	if (rdp->nxtlist != NULL) {
-		*receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
-		receive_rdp->nxttail[RCU_NEXT_TAIL] =
-				rdp->nxttail[RCU_NEXT_TAIL];
-		receive_rdp->n_cbs_adopted += rdp->qlen;
-		rdp->n_cbs_orphaned += rdp->qlen;
-
-		rdp->nxtlist = NULL;
-		for (i = 0; i < RCU_NEXT_SIZE; i++)
-			rdp->nxttail[i] = &rdp->nxtlist;
+		*rsp->orphan_donetail = rdp->nxtlist;
+		rsp->orphan_donetail = rdp->nxttail[RCU_DONE_TAIL];
 	}
 
+	/* Finally, initialize the rcu_data structure's list to empty.  */
+	rdp->nxtlist = NULL;
+	for (i = 0; i < RCU_NEXT_SIZE; i++)
+		rdp->nxttail[i] = &rdp->nxtlist;
+}
+
+/*
+ * Adopt the RCU callbacks from the specified rcu_state structure's
+ * orphanage.  The caller must hold the ->onofflock.
+ */
+static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
+{
+	int i;
+	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
+
 	/*
-	 * Record a quiescent state for the dying CPU.  This is safe
-	 * only because we have already cleared out the callbacks.
-	 * (Otherwise, the RCU core might try to schedule the invocation
-	 * of callbacks on this now-offline CPU, which would be bad.)
+	 * If there is an rcu_barrier() operation in progress, then
+	 * only the task doing that operation is permitted to adopt
+	 * callbacks.  To do otherwise breaks rcu_barrier() and friends
+	 * by causing them to fail to wait for the callbacks in the
+	 * orphanage.
 	 */
-	mask = rdp->grpmask;	/* rnp->grplo is constant. */
+	if (rsp->rcu_barrier_in_progress &&
+	    rsp->rcu_barrier_in_progress != current)
+		return;
+
+	/* Do the accounting first. */
+	rdp->qlen_lazy += rsp->qlen_lazy;
+	rdp->qlen += rsp->qlen;
+	rdp->n_cbs_adopted += rsp->qlen;
+	rsp->qlen_lazy = 0;
+	rsp->qlen = 0;
+
+	/*
+	 * We do not need a memory barrier here because the only way we
+	 * can get here if there is an rcu_barrier() in flight is if
+	 * we are the task doing the rcu_barrier().
+	 */
+
+	/* First adopt the ready-to-invoke callbacks. */
+	if (rsp->orphan_donelist != NULL) {
+		*rsp->orphan_donetail = *rdp->nxttail[RCU_DONE_TAIL];
+		*rdp->nxttail[RCU_DONE_TAIL] = rsp->orphan_donelist;
+		for (i = RCU_NEXT_SIZE - 1; i >= RCU_DONE_TAIL; i--)
+			if (rdp->nxttail[i] == rdp->nxttail[RCU_DONE_TAIL])
+				rdp->nxttail[i] = rsp->orphan_donetail;
+		rsp->orphan_donelist = NULL;
+		rsp->orphan_donetail = &rsp->orphan_donelist;
+	}
+
+	/* And then adopt the callbacks that still need a grace period. */
+	if (rsp->orphan_nxtlist != NULL) {
+		*rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_nxtlist;
+		rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_nxttail;
+		rsp->orphan_nxtlist = NULL;
+		rsp->orphan_nxttail = &rsp->orphan_nxtlist;
+	}
+}
+
+/*
+ * Trace the fact that this CPU is going offline.
+ */
+static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
+{
+	RCU_TRACE(unsigned long mask);
+	RCU_TRACE(struct rcu_data *rdp = this_cpu_ptr(rsp->rda));
+	RCU_TRACE(struct rcu_node *rnp = rdp->mynode);
+
+	RCU_TRACE(mask = rdp->grpmask);
 	trace_rcu_grace_period(rsp->name,
 			       rnp->gpnum + 1 - !!(rnp->qsmask & mask),
 			       "cpuofl");
-	rcu_report_qs_rdp(smp_processor_id(), rsp, rdp, rsp->gpnum);
-	/* Note that rcu_report_qs_rdp() might call trace_rcu_grace_period(). */
 }
 
 /*
  * The CPU has been completely removed, and some other CPU is reporting
- * this fact from process context.  Do the remainder of the cleanup.
+ * this fact from process context.  Do the remainder of the cleanup,
+ * including orphaning the outgoing CPU's RCU callbacks, and also
+ * adopting them, if there is no _rcu_barrier() instance running.
  * There can only be one CPU hotplug operation at a time, so no other
  * CPU can be attempting to update rcu_cpu_kthread_task.
  */
@@ -1409,17 +1455,21 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	unsigned long mask;
 	int need_report = 0;
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
-	struct rcu_node *rnp = rdp->mynode;  /* Outgoing CPU's rnp. */
+	struct rcu_node *rnp = rdp->mynode;  /* Outgoing CPU's rdp & rnp. */
 
 	/* Adjust any no-longer-needed kthreads. */
 	rcu_stop_cpu_kthread(cpu);
 	rcu_node_kthread_setaffinity(rnp, -1);
 
-	/* Remove the dying CPU from the bitmasks in the rcu_node hierarchy. */
+	/* Remove the dead CPU from the bitmasks in the rcu_node hierarchy. */
 
 	/* Exclude any attempts to start a new grace period. */
 	raw_spin_lock_irqsave(&rsp->onofflock, flags);
 
+	/* Orphan the dead CPU's callbacks, and adopt them if appropriate. */
+	rcu_send_cbs_to_orphanage(cpu, rsp, rnp, rdp);
+	rcu_adopt_orphan_cbs(rsp);
+
 	/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
 	mask = rdp->grpmask;	/* rnp->grplo is constant. */
 	do {
@@ -1456,6 +1506,10 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 
 #else /* #ifdef CONFIG_HOTPLUG_CPU */
 
+static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
+{
+}
+
 static void rcu_cleanup_dying_cpu(struct rcu_state *rsp)
 {
 }
@@ -1524,9 +1578,6 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 			    rcu_is_callbacks_kthread());
 
 	/* Update count, and requeue any remaining callbacks. */
-	rdp->qlen_lazy -= count_lazy;
-	rdp->qlen -= count;
-	rdp->n_cbs_invoked += count;
 	if (list != NULL) {
 		*tail = rdp->nxtlist;
 		rdp->nxtlist = list;
@@ -1536,6 +1587,10 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 			else
 				break;
 	}
+	smp_mb(); /* List handling before counting for rcu_barrier(). */
+	rdp->qlen_lazy -= count_lazy;
+	rdp->qlen -= count;
+	rdp->n_cbs_invoked += count;
 
 	/* Reinstate batch limit if we have worked down the excess. */
 	if (rdp->blimit == LONG_MAX && rdp->qlen <= qlowmark)
@@ -1823,11 +1878,14 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	rdp = this_cpu_ptr(rsp->rda);
 
 	/* Add the callback to our list. */
-	*rdp->nxttail[RCU_NEXT_TAIL] = head;
-	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
 	rdp->qlen++;
 	if (lazy)
 		rdp->qlen_lazy++;
+	else
+		rcu_idle_count_callbacks_posted();
+	smp_mb();  /* Count before adding callback for rcu_barrier(). */
+	*rdp->nxttail[RCU_NEXT_TAIL] = head;
+	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
 
 	if (__is_kfree_rcu_offset((unsigned long)func))
 		trace_rcu_kfree_callback(rsp->name, head, (unsigned long)func,
@@ -1893,6 +1951,38 @@ void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
+/*
+ * Because a context switch is a grace period for RCU-sched and RCU-bh,
+ * any blocking grace-period wait automatically implies a grace period
+ * if there is only one CPU online at any point time during execution
+ * of either synchronize_sched() or synchronize_rcu_bh().  It is OK to
+ * occasionally incorrectly indicate that there are multiple CPUs online
+ * when there was in fact only one the whole time, as this just adds
+ * some overhead: RCU still operates correctly.
+ *
+ * Of course, sampling num_online_cpus() with preemption enabled can
+ * give erroneous results if there are concurrent CPU-hotplug operations.
+ * For example, given a demonic sequence of preemptions in num_online_cpus()
+ * and CPU-hotplug operations, there could be two or more CPUs online at
+ * all times, but num_online_cpus() might well return one (or even zero).
+ *
+ * However, all such demonic sequences require at least one CPU-offline
+ * operation.  Furthermore, rcu_blocking_is_gp() giving the wrong answer
+ * is only a problem if there is an RCU read-side critical section executing
+ * throughout.  But RCU-sched and RCU-bh read-side critical sections
+ * disable either preemption or bh, which prevents a CPU from going offline.
+ * Therefore, the only way that rcu_blocking_is_gp() can incorrectly return
+ * that there is only one CPU when in fact there was more than one throughout
+ * is when there were no RCU readers in the system.  If there are no
+ * RCU readers, the grace period by definition can be of zero length,
+ * regardless of the number of online CPUs.
+ */
+static inline int rcu_blocking_is_gp(void)
+{
+	might_sleep();  /* Check for RCU read-side critical section. */
+	return num_online_cpus() <= 1;
+}
+
 /**
  * synchronize_sched - wait until an rcu-sched grace period has elapsed.
  *
@@ -2166,11 +2256,10 @@ static int rcu_cpu_has_callbacks(int cpu)
 	       rcu_preempt_cpu_has_callbacks(cpu);
 }
 
-static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
-static atomic_t rcu_barrier_cpu_count;
-static DEFINE_MUTEX(rcu_barrier_mutex);
-static struct completion rcu_barrier_completion;
-
+/*
+ * RCU callback function for _rcu_barrier().  If we are last, wake
+ * up the task executing _rcu_barrier().
+ */
 static void rcu_barrier_callback(struct rcu_head *notused)
 {
 	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
@@ -2200,27 +2289,94 @@ static void _rcu_barrier(struct rcu_state *rsp,
 			 void (*call_rcu_func)(struct rcu_head *head,
 					       void (*func)(struct rcu_head *head)))
 {
-	BUG_ON(in_interrupt());
+	int cpu;
+	unsigned long flags;
+	struct rcu_data *rdp;
+	struct rcu_head rh;
+
+	init_rcu_head_on_stack(&rh);
+
 	/* Take mutex to serialize concurrent rcu_barrier() requests. */
 	mutex_lock(&rcu_barrier_mutex);
-	init_completion(&rcu_barrier_completion);
+
+	smp_mb();  /* Prevent any prior operations from leaking in. */
+
 	/*
-	 * Initialize rcu_barrier_cpu_count to 1, then invoke
-	 * rcu_barrier_func() on each CPU, so that each CPU also has
-	 * incremented rcu_barrier_cpu_count.  Only then is it safe to
-	 * decrement rcu_barrier_cpu_count -- otherwise the first CPU
-	 * might complete its grace period before all of the other CPUs
-	 * did their increment, causing this function to return too
-	 * early.  Note that on_each_cpu() disables irqs, which prevents
-	 * any CPUs from coming online or going offline until each online
-	 * CPU has queued its RCU-barrier callback.
+	 * Initialize the count to one rather than to zero in order to
+	 * avoid a too-soon return to zero in case of a short grace period
+	 * (or preemption of this task).  Also flag this task as doing
+	 * an rcu_barrier().  This will prevent anyone else from adopting
+	 * orphaned callbacks, which could cause otherwise failure if a
+	 * CPU went offline and quickly came back online.  To see this,
+	 * consider the following sequence of events:
+	 *
+	 * 1.	We cause CPU 0 to post an rcu_barrier_callback() callback.
+	 * 2.	CPU 1 goes offline, orphaning its callbacks.
+	 * 3.	CPU 0 adopts CPU 1's orphaned callbacks.
+	 * 4.	CPU 1 comes back online.
+	 * 5.	We cause CPU 1 to post an rcu_barrier_callback() callback.
+	 * 6.	Both rcu_barrier_callback() callbacks are invoked, awakening
+	 *	us -- but before CPU 1's orphaned callbacks are invoked!!!
 	 */
+	init_completion(&rcu_barrier_completion);
 	atomic_set(&rcu_barrier_cpu_count, 1);
-	on_each_cpu(rcu_barrier_func, (void *)call_rcu_func, 1);
+	raw_spin_lock_irqsave(&rsp->onofflock, flags);
+	rsp->rcu_barrier_in_progress = current;
+	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
+
+	/*
+	 * Force every CPU with callbacks to register a new callback
+	 * that will tell us when all the preceding callbacks have
+	 * been invoked.  If an offline CPU has callbacks, wait for
+	 * it to either come back online or to finish orphaning those
+	 * callbacks.
+	 */
+	for_each_possible_cpu(cpu) {
+		preempt_disable();
+		rdp = per_cpu_ptr(rsp->rda, cpu);
+		if (cpu_is_offline(cpu)) {
+			preempt_enable();
+			while (cpu_is_offline(cpu) && ACCESS_ONCE(rdp->qlen))
+				schedule_timeout_interruptible(1);
+		} else if (ACCESS_ONCE(rdp->qlen)) {
+			smp_call_function_single(cpu, rcu_barrier_func,
+						 (void *)call_rcu_func, 1);
+			preempt_enable();
+		} else {
+			preempt_enable();
+		}
+	}
+
+	/*
+	 * Now that all online CPUs have rcu_barrier_callback() callbacks
+	 * posted, we can adopt all of the orphaned callbacks and place
+	 * an rcu_barrier_callback() callback after them.  When that is done,
+	 * we are guaranteed to have an rcu_barrier_callback() callback
+	 * following every callback that could possibly have been
+	 * registered before _rcu_barrier() was called.
+	 */
+	raw_spin_lock_irqsave(&rsp->onofflock, flags);
+	rcu_adopt_orphan_cbs(rsp);
+	rsp->rcu_barrier_in_progress = NULL;
+	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
+	atomic_inc(&rcu_barrier_cpu_count);
+	smp_mb__after_atomic_inc(); /* Ensure atomic_inc() before callback. */
+	call_rcu_func(&rh, rcu_barrier_callback);
+
+	/*
+	 * Now that we have an rcu_barrier_callback() callback on each
+	 * CPU, and thus each counted, remove the initial count.
+	 */
 	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
 		complete(&rcu_barrier_completion);
+
+	/* Wait for all rcu_barrier_callback() callbacks to be invoked. */
 	wait_for_completion(&rcu_barrier_completion);
+
+	/* Other rcu_barrier() invocations can now safely proceed. */
 	mutex_unlock(&rcu_barrier_mutex);
+
+	destroy_rcu_head_on_stack(&rh);
 }
 
 /**
@@ -2417,7 +2573,7 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
 
 	for (i = NUM_RCU_LVLS - 1; i > 0; i--)
 		rsp->levelspread[i] = CONFIG_RCU_FANOUT;
-	rsp->levelspread[0] = RCU_FANOUT_LEAF;
+	rsp->levelspread[0] = CONFIG_RCU_FANOUT_LEAF;
 }
 #else /* #ifdef CONFIG_RCU_FANOUT_EXACT */
 static void __init rcu_init_levelspread(struct rcu_state *rsp)
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index cdd1be0..7f5d138 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -29,18 +29,14 @@
 #include <linux/seqlock.h>
 
 /*
- * Define shape of hierarchy based on NR_CPUS and CONFIG_RCU_FANOUT.
+ * Define shape of hierarchy based on NR_CPUS, CONFIG_RCU_FANOUT, and
+ * CONFIG_RCU_FANOUT_LEAF.
  * In theory, it should be possible to add more levels straightforwardly.
  * In practice, this did work well going from three levels to four.
  * Of course, your mileage may vary.
  */
 #define MAX_RCU_LVLS 4
-#if CONFIG_RCU_FANOUT > 16
-#define RCU_FANOUT_LEAF       16
-#else /* #if CONFIG_RCU_FANOUT > 16 */
-#define RCU_FANOUT_LEAF       (CONFIG_RCU_FANOUT)
-#endif /* #else #if CONFIG_RCU_FANOUT > 16 */
-#define RCU_FANOUT_1	      (RCU_FANOUT_LEAF)
+#define RCU_FANOUT_1	      (CONFIG_RCU_FANOUT_LEAF)
 #define RCU_FANOUT_2	      (RCU_FANOUT_1 * CONFIG_RCU_FANOUT)
 #define RCU_FANOUT_3	      (RCU_FANOUT_2 * CONFIG_RCU_FANOUT)
 #define RCU_FANOUT_4	      (RCU_FANOUT_3 * CONFIG_RCU_FANOUT)
@@ -371,6 +367,17 @@ struct rcu_state {
 
 	raw_spinlock_t onofflock;		/* exclude on/offline and */
 						/*  starting new GP. */
+	struct rcu_head *orphan_nxtlist;	/* Orphaned callbacks that */
+						/*  need a grace period. */
+	struct rcu_head **orphan_nxttail;	/* Tail of above. */
+	struct rcu_head *orphan_donelist;	/* Orphaned callbacks that */
+						/*  are ready to invoke. */
+	struct rcu_head **orphan_donetail;	/* Tail of above. */
+	long qlen_lazy;				/* Number of lazy callbacks. */
+	long qlen;				/* Total number of callbacks. */
+	struct task_struct *rcu_barrier_in_progress;
+						/* Task doing rcu_barrier(), */
+						/*  or NULL if no barrier. */
 	raw_spinlock_t fqslock;			/* Only one task forcing */
 						/*  quiescent states. */
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
@@ -423,7 +430,6 @@ DECLARE_PER_CPU(char, rcu_cpu_has_work);
 /* Forward declarations for rcutree_plugin.h */
 static void rcu_bootup_announce(void);
 long rcu_batches_completed(void);
-static void rcu_preempt_note_context_switch(int cpu);
 static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
@@ -471,6 +477,7 @@ static void __cpuinit rcu_prepare_kthreads(int cpu);
 static void rcu_prepare_for_idle_init(int cpu);
 static void rcu_cleanup_after_idle(int cpu);
 static void rcu_prepare_for_idle(int cpu);
+static void rcu_idle_count_callbacks_posted(void);
 static void print_cpu_stall_info_begin(void);
 static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
 static void print_cpu_stall_info_end(void);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c023464..2411000 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -153,7 +153,7 @@ static void rcu_preempt_qs(int cpu)
  *
  * Caller must disable preemption.
  */
-static void rcu_preempt_note_context_switch(int cpu)
+void rcu_preempt_note_context_switch(void)
 {
 	struct task_struct *t = current;
 	unsigned long flags;
@@ -164,7 +164,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
-		rdp = per_cpu_ptr(rcu_preempt_state.rda, cpu);
+		rdp = __this_cpu_ptr(rcu_preempt_state.rda);
 		rnp = rdp->mynode;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
@@ -228,7 +228,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 	 * means that we continue to block the current grace period.
 	 */
 	local_irq_save(flags);
-	rcu_preempt_qs(cpu);
+	rcu_preempt_qs(smp_processor_id());
 	local_irq_restore(flags);
 }
 
@@ -969,22 +969,6 @@ static void __init __rcu_init_preempt(void)
 	rcu_init_one(&rcu_preempt_state, &rcu_preempt_data);
 }
 
-/*
- * Check for a task exiting while in a preemptible-RCU read-side
- * critical section, clean up if so.  No need to issue warnings,
- * as debug_check_no_locks_held() already does this if lockdep
- * is enabled.
- */
-void exit_rcu(void)
-{
-	struct task_struct *t = current;
-
-	if (t->rcu_read_lock_nesting == 0)
-		return;
-	t->rcu_read_lock_nesting = 1;
-	__rcu_read_unlock();
-}
-
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 static struct rcu_state *rcu_state = &rcu_sched_state;
@@ -1018,14 +1002,6 @@ void rcu_force_quiescent_state(void)
 EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
 
 /*
- * Because preemptible RCU does not exist, we never have to check for
- * CPUs being in quiescent states.
- */
-static void rcu_preempt_note_context_switch(int cpu)
-{
-}
-
-/*
  * Because preemptible RCU does not exist, there are never any preempted
  * RCU readers.
  */
@@ -1938,6 +1914,14 @@ static void rcu_prepare_for_idle(int cpu)
 {
 }
 
+/*
+ * Don't bother keeping a running count of the number of RCU callbacks
+ * posted because CONFIG_RCU_FAST_NO_HZ=n.
+ */
+static void rcu_idle_count_callbacks_posted(void)
+{
+}
+
 #else /* #if !defined(CONFIG_RCU_FAST_NO_HZ) */
 
 /*
@@ -1978,11 +1962,20 @@ static void rcu_prepare_for_idle(int cpu)
 #define RCU_IDLE_GP_DELAY 6		/* Roughly one grace period. */
 #define RCU_IDLE_LAZY_GP_DELAY (6 * HZ)	/* Roughly six seconds. */
 
+/* Loop counter for rcu_prepare_for_idle(). */
 static DEFINE_PER_CPU(int, rcu_dyntick_drain);
+/* If rcu_dyntick_holdoff==jiffies, don't try to enter dyntick-idle mode. */
 static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
-static DEFINE_PER_CPU(struct hrtimer, rcu_idle_gp_timer);
-static ktime_t rcu_idle_gp_wait;	/* If some non-lazy callbacks. */
-static ktime_t rcu_idle_lazy_gp_wait;	/* If only lazy callbacks. */
+/* Timer to awaken the CPU if it enters dyntick-idle mode with callbacks. */
+static DEFINE_PER_CPU(struct timer_list, rcu_idle_gp_timer);
+/* Scheduled expiry time for rcu_idle_gp_timer to allow reposting. */
+static DEFINE_PER_CPU(unsigned long, rcu_idle_gp_timer_expires);
+/* Enable special processing on first attempt to enter dyntick-idle mode. */
+static DEFINE_PER_CPU(bool, rcu_idle_first_pass);
+/* Running count of non-lazy callbacks posted, never decremented. */
+static DEFINE_PER_CPU(unsigned long, rcu_nonlazy_posted);
+/* Snapshot of rcu_nonlazy_posted to detect meaningful exits from idle. */
+static DEFINE_PER_CPU(unsigned long, rcu_nonlazy_posted_snap);
 
 /*
  * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
@@ -1995,6 +1988,8 @@ static ktime_t rcu_idle_lazy_gp_wait;	/* If only lazy callbacks. */
  */
 int rcu_needs_cpu(int cpu)
 {
+	/* Flag a new idle sojourn to the idle-entry state machine. */
+	per_cpu(rcu_idle_first_pass, cpu) = 1;
 	/* If no callbacks, RCU doesn't need the CPU. */
 	if (!rcu_cpu_has_callbacks(cpu))
 		return 0;
@@ -2045,16 +2040,34 @@ static bool rcu_cpu_has_nonlazy_callbacks(int cpu)
 }
 
 /*
+ * Handler for smp_call_function_single().  The only point of this
+ * handler is to wake the CPU up, so the handler does only tracing.
+ */
+void rcu_idle_demigrate(void *unused)
+{
+	trace_rcu_prep_idle("Demigrate");
+}
+
+/*
  * Timer handler used to force CPU to start pushing its remaining RCU
  * callbacks in the case where it entered dyntick-idle mode with callbacks
  * pending.  The hander doesn't really need to do anything because the
  * real work is done upon re-entry to idle, or by the next scheduling-clock
  * interrupt should idle not be re-entered.
+ *
+ * One special case: the timer gets migrated without awakening the CPU
+ * on which the timer was scheduled on.  In this case, we must wake up
+ * that CPU.  We do so with smp_call_function_single().
  */
-static enum hrtimer_restart rcu_idle_gp_timer_func(struct hrtimer *hrtp)
+static void rcu_idle_gp_timer_func(unsigned long cpu_in)
 {
+	int cpu = (int)cpu_in;
+
 	trace_rcu_prep_idle("Timer");
-	return HRTIMER_NORESTART;
+	if (cpu != smp_processor_id())
+		smp_call_function_single(cpu, rcu_idle_demigrate, NULL, 0);
+	else
+		WARN_ON_ONCE(1); /* Getting here can hang the system... */
 }
 
 /*
@@ -2062,19 +2075,11 @@ static enum hrtimer_restart rcu_idle_gp_timer_func(struct hrtimer *hrtp)
  */
 static void rcu_prepare_for_idle_init(int cpu)
 {
-	static int firsttime = 1;
-	struct hrtimer *hrtp = &per_cpu(rcu_idle_gp_timer, cpu);
-
-	hrtimer_init(hrtp, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hrtp->function = rcu_idle_gp_timer_func;
-	if (firsttime) {
-		unsigned int upj = jiffies_to_usecs(RCU_IDLE_GP_DELAY);
-
-		rcu_idle_gp_wait = ns_to_ktime(upj * (u64)1000);
-		upj = jiffies_to_usecs(RCU_IDLE_LAZY_GP_DELAY);
-		rcu_idle_lazy_gp_wait = ns_to_ktime(upj * (u64)1000);
-		firsttime = 0;
-	}
+	per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
+	setup_timer(&per_cpu(rcu_idle_gp_timer, cpu),
+		    rcu_idle_gp_timer_func, cpu);
+	per_cpu(rcu_idle_gp_timer_expires, cpu) = jiffies - 1;
+	per_cpu(rcu_idle_first_pass, cpu) = 1;
 }
 
 /*
@@ -2084,7 +2089,8 @@ static void rcu_prepare_for_idle_init(int cpu)
  */
 static void rcu_cleanup_after_idle(int cpu)
 {
-	hrtimer_cancel(&per_cpu(rcu_idle_gp_timer, cpu));
+	del_timer(&per_cpu(rcu_idle_gp_timer, cpu));
+	trace_rcu_prep_idle("Cleanup after idle");
 }
 
 /*
@@ -2108,6 +2114,29 @@ static void rcu_cleanup_after_idle(int cpu)
  */
 static void rcu_prepare_for_idle(int cpu)
 {
+	struct timer_list *tp;
+
+	/*
+	 * If this is an idle re-entry, for example, due to use of
+	 * RCU_NONIDLE() or the new idle-loop tracing API within the idle
+	 * loop, then don't take any state-machine actions, unless the
+	 * momentary exit from idle queued additional non-lazy callbacks.
+	 * Instead, repost the rcu_idle_gp_timer if this CPU has callbacks
+	 * pending.
+	 */
+	if (!per_cpu(rcu_idle_first_pass, cpu) &&
+	    (per_cpu(rcu_nonlazy_posted, cpu) ==
+	     per_cpu(rcu_nonlazy_posted_snap, cpu))) {
+		if (rcu_cpu_has_callbacks(cpu)) {
+			tp = &per_cpu(rcu_idle_gp_timer, cpu);
+			mod_timer_pinned(tp, per_cpu(rcu_idle_gp_timer_expires, cpu));
+		}
+		return;
+	}
+	per_cpu(rcu_idle_first_pass, cpu) = 0;
+	per_cpu(rcu_nonlazy_posted_snap, cpu) =
+		per_cpu(rcu_nonlazy_posted, cpu) - 1;
+
 	/*
 	 * If there are no callbacks on this CPU, enter dyntick-idle mode.
 	 * Also reset state to avoid prejudicing later attempts.
@@ -2140,11 +2169,15 @@ static void rcu_prepare_for_idle(int cpu)
 		per_cpu(rcu_dyntick_drain, cpu) = 0;
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
 		if (rcu_cpu_has_nonlazy_callbacks(cpu))
-			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
-				      rcu_idle_gp_wait, HRTIMER_MODE_REL);
+			per_cpu(rcu_idle_gp_timer_expires, cpu) =
+					   jiffies + RCU_IDLE_GP_DELAY;
 		else
-			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
-				      rcu_idle_lazy_gp_wait, HRTIMER_MODE_REL);
+			per_cpu(rcu_idle_gp_timer_expires, cpu) =
+					   jiffies + RCU_IDLE_LAZY_GP_DELAY;
+		tp = &per_cpu(rcu_idle_gp_timer, cpu);
+		mod_timer_pinned(tp, per_cpu(rcu_idle_gp_timer_expires, cpu));
+		per_cpu(rcu_nonlazy_posted_snap, cpu) =
+			per_cpu(rcu_nonlazy_posted, cpu);
 		return; /* Nothing more to do immediately. */
 	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* We have hit the limit, so time to give up. */
@@ -2184,6 +2217,19 @@ static void rcu_prepare_for_idle(int cpu)
 		trace_rcu_prep_idle("Callbacks drained");
 }
 
+/*
+ * Keep a running count of the number of non-lazy callbacks posted
+ * on this CPU.  This running counter (which is never decremented) allows
+ * rcu_prepare_for_idle() to detect when something out of the idle loop
+ * posts a callback, even if an equal number of callbacks are invoked.
+ * Of course, callbacks should only be posted from within a trace event
+ * designed to be called from idle or from within RCU_NONIDLE().
+ */
+static void rcu_idle_count_callbacks_posted(void)
+{
+	__this_cpu_add(rcu_nonlazy_posted, 1);
+}
+
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
 
 #ifdef CONFIG_RCU_CPU_STALL_INFO
@@ -2192,14 +2238,12 @@ static void rcu_prepare_for_idle(int cpu)
 
 static void print_cpu_stall_fast_no_hz(char *cp, int cpu)
 {
-	struct hrtimer *hrtp = &per_cpu(rcu_idle_gp_timer, cpu);
+	struct timer_list *tltp = &per_cpu(rcu_idle_gp_timer, cpu);
 
-	sprintf(cp, "drain=%d %c timer=%lld",
+	sprintf(cp, "drain=%d %c timer=%lu",
 		per_cpu(rcu_dyntick_drain, cpu),
 		per_cpu(rcu_dyntick_holdoff, cpu) == jiffies ? 'H' : '.',
-		hrtimer_active(hrtp)
-			? ktime_to_us(hrtimer_get_remaining(hrtp))
-			: -1);
+		timer_pending(tltp) ? tltp->expires - jiffies : -1);
 }
 
 #else /* #ifdef CONFIG_RCU_FAST_NO_HZ */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index ed459ed..d4bc16d 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -271,13 +271,13 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 
 	gpnum = rsp->gpnum;
 	seq_printf(m, "c=%lu g=%lu s=%d jfq=%ld j=%x "
-		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu\n",
+		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld/%ld\n",
 		   rsp->completed, gpnum, rsp->fqs_state,
 		   (long)(rsp->jiffies_force_qs - jiffies),
 		   (int)(jiffies & 0xffff),
 		   rsp->n_force_qs, rsp->n_force_qs_ngp,
 		   rsp->n_force_qs - rsp->n_force_qs_ngp,
-		   rsp->n_force_qs_lh);
+		   rsp->n_force_qs_lh, rsp->qlen_lazy, rsp->qlen);
 	for (rnp = &rsp->node[0]; rnp - &rsp->node[0] < NUM_RCU_NODES; rnp++) {
 		if (rnp->level != level) {
 			seq_puts(m, "\n");
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0533a68..8bedcc4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2083,6 +2083,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 #endif
 
 	/* Here we just switch the register state and the stack. */
+	rcu_switch_from(prev);
 	switch_to(prev, next, prev);
 
 	barrier();
diff --git a/kernel/srcu.c b/kernel/srcu.c
index ba35f3a..2095be3 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -34,10 +34,77 @@
 #include <linux/delay.h>
 #include <linux/srcu.h>
 
+/*
+ * Initialize an rcu_batch structure to empty.
+ */
+static inline void rcu_batch_init(struct rcu_batch *b)
+{
+	b->head = NULL;
+	b->tail = &b->head;
+}
+
+/*
+ * Enqueue a callback onto the tail of the specified rcu_batch structure.
+ */
+static inline void rcu_batch_queue(struct rcu_batch *b, struct rcu_head *head)
+{
+	*b->tail = head;
+	b->tail = &head->next;
+}
+
+/*
+ * Is the specified rcu_batch structure empty?
+ */
+static inline bool rcu_batch_empty(struct rcu_batch *b)
+{
+	return b->tail == &b->head;
+}
+
+/*
+ * Remove the callback at the head of the specified rcu_batch structure
+ * and return a pointer to it, or return NULL if the structure is empty.
+ */
+static inline struct rcu_head *rcu_batch_dequeue(struct rcu_batch *b)
+{
+	struct rcu_head *head;
+
+	if (rcu_batch_empty(b))
+		return NULL;
+
+	head = b->head;
+	b->head = head->next;
+	if (b->tail == &head->next)
+		rcu_batch_init(b);
+
+	return head;
+}
+
+/*
+ * Move all callbacks from the rcu_batch structure specified by "from" to
+ * the structure specified by "to".
+ */
+static inline void rcu_batch_move(struct rcu_batch *to, struct rcu_batch *from)
+{
+	if (!rcu_batch_empty(from)) {
+		*to->tail = from->head;
+		to->tail = from->tail;
+		rcu_batch_init(from);
+	}
+}
+
+/* single-thread state-machine */
+static void process_srcu(struct work_struct *work);
+
 static int init_srcu_struct_fields(struct srcu_struct *sp)
 {
 	sp->completed = 0;
-	mutex_init(&sp->mutex);
+	spin_lock_init(&sp->queue_lock);
+	sp->running = false;
+	rcu_batch_init(&sp->batch_queue);
+	rcu_batch_init(&sp->batch_check0);
+	rcu_batch_init(&sp->batch_check1);
+	rcu_batch_init(&sp->batch_done);
+	INIT_DELAYED_WORK(&sp->work, process_srcu);
 	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
 	return sp->per_cpu_ref ? 0 : -ENOMEM;
 }
@@ -73,21 +140,116 @@ EXPORT_SYMBOL_GPL(init_srcu_struct);
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 /*
- * srcu_readers_active_idx -- returns approximate number of readers
- *	active on the specified rank of per-CPU counters.
+ * Returns approximate total of the readers' ->seq[] values for the
+ * rank of per-CPU counters specified by idx.
  */
+static unsigned long srcu_readers_seq_idx(struct srcu_struct *sp, int idx)
+{
+	int cpu;
+	unsigned long sum = 0;
+	unsigned long t;
 
-static int srcu_readers_active_idx(struct srcu_struct *sp, int idx)
+	for_each_possible_cpu(cpu) {
+		t = ACCESS_ONCE(per_cpu_ptr(sp->per_cpu_ref, cpu)->seq[idx]);
+		sum += t;
+	}
+	return sum;
+}
+
+/*
+ * Returns approximate number of readers active on the specified rank
+ * of the per-CPU ->c[] counters.
+ */
+static unsigned long srcu_readers_active_idx(struct srcu_struct *sp, int idx)
 {
 	int cpu;
-	int sum;
+	unsigned long sum = 0;
+	unsigned long t;
 
-	sum = 0;
-	for_each_possible_cpu(cpu)
-		sum += per_cpu_ptr(sp->per_cpu_ref, cpu)->c[idx];
+	for_each_possible_cpu(cpu) {
+		t = ACCESS_ONCE(per_cpu_ptr(sp->per_cpu_ref, cpu)->c[idx]);
+		sum += t;
+	}
 	return sum;
 }
 
+/*
+ * Return true if the number of pre-existing readers is determined to
+ * be stably zero.  An example unstable zero can occur if the call
+ * to srcu_readers_active_idx() misses an __srcu_read_lock() increment,
+ * but due to task migration, sees the corresponding __srcu_read_unlock()
+ * decrement.  This can happen because srcu_readers_active_idx() takes
+ * time to sum the array, and might in fact be interrupted or preempted
+ * partway through the summation.
+ */
+static bool srcu_readers_active_idx_check(struct srcu_struct *sp, int idx)
+{
+	unsigned long seq;
+
+	seq = srcu_readers_seq_idx(sp, idx);
+
+	/*
+	 * The following smp_mb() A pairs with the smp_mb() B located in
+	 * __srcu_read_lock().  This pairing ensures that if an
+	 * __srcu_read_lock() increments its counter after the summation
+	 * in srcu_readers_active_idx(), then the corresponding SRCU read-side
+	 * critical section will see any changes made prior to the start
+	 * of the current SRCU grace period.
+	 *
+	 * Also, if the above call to srcu_readers_seq_idx() saw the
+	 * increment of ->seq[], then the call to srcu_readers_active_idx()
+	 * must see the increment of ->c[].
+	 */
+	smp_mb(); /* A */
+
+	/*
+	 * Note that srcu_readers_active_idx() can incorrectly return
+	 * zero even though there is a pre-existing reader throughout.
+	 * To see this, suppose that task A is in a very long SRCU
+	 * read-side critical section that started on CPU 0, and that
+	 * no other reader exists, so that the sum of the counters
+	 * is equal to one.  Then suppose that task B starts executing
+	 * srcu_readers_active_idx(), summing up to CPU 1, and then that
+	 * task C starts reading on CPU 0, so that its increment is not
+	 * summed, but finishes reading on CPU 2, so that its decrement
+	 * -is- summed.  Then when task B completes its sum, it will
+	 * incorrectly get zero, despite the fact that task A has been
+	 * in its SRCU read-side critical section the whole time.
+	 *
+	 * We therefore do a validation step should srcu_readers_active_idx()
+	 * return zero.
+	 */
+	if (srcu_readers_active_idx(sp, idx) != 0)
+		return false;
+
+	/*
+	 * The remainder of this function is the validation step.
+	 * The following smp_mb() D pairs with the smp_mb() C in
+	 * __srcu_read_unlock().  If the __srcu_read_unlock() was seen
+	 * by srcu_readers_active_idx() above, then any destructive
+	 * operation performed after the grace period will happen after
+	 * the corresponding SRCU read-side critical section.
+	 *
+	 * Note that there can be at most NR_CPUS worth of readers using
+	 * the old index, which is not enough to overflow even a 32-bit
+	 * integer.  (Yes, this does mean that systems having more than
+	 * a billion or so CPUs need to be 64-bit systems.)  Therefore,
+	 * the sum of the ->seq[] counters cannot possibly overflow.
+	 * Therefore, the only way that the return values of the two
+	 * calls to srcu_readers_seq_idx() can be equal is if there were
+	 * no increments of the corresponding rank of ->seq[] counts
+	 * in the interim.  But the missed-increment scenario laid out
+	 * above includes an increment of the ->seq[] counter by
+	 * the corresponding __srcu_read_lock().  Therefore, if this
+	 * scenario occurs, the return values from the two calls to
+	 * srcu_readers_seq_idx() will differ, and thus the validation
+	 * step below suffices.
+	 */
+	smp_mb(); /* D */
+
+	return srcu_readers_seq_idx(sp, idx) == seq;
+}
+
 /**
  * srcu_readers_active - returns approximate number of readers.
  * @sp: which srcu_struct to count active readers (holding srcu_read_lock).
@@ -98,7 +260,14 @@ static int srcu_readers_active_idx(struct srcu_struct *sp, int idx)
  */
 static int srcu_readers_active(struct srcu_struct *sp)
 {
-	return srcu_readers_active_idx(sp, 0) + srcu_readers_active_idx(sp, 1);
+	int cpu;
+	unsigned long sum = 0;
+
+	for_each_possible_cpu(cpu) {
+		sum += ACCESS_ONCE(per_cpu_ptr(sp->per_cpu_ref, cpu)->c[0]);
+		sum += ACCESS_ONCE(per_cpu_ptr(sp->per_cpu_ref, cpu)->c[1]);
+	}
+	return sum;
 }
 
 /**
@@ -131,10 +300,11 @@ int __srcu_read_lock(struct srcu_struct *sp)
 	int idx;
 
 	preempt_disable();
-	idx = sp->completed & 0x1;
-	barrier();  /* ensure compiler looks -once- at sp->completed. */
-	per_cpu_ptr(sp->per_cpu_ref, smp_processor_id())->c[idx]++;
-	srcu_barrier();  /* ensure compiler won't misorder critical section. */
+	idx = rcu_dereference_index_check(sp->completed,
+					  rcu_read_lock_sched_held()) & 0x1;
+	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += 1;
+	smp_mb(); /* B */  /* Avoid leaking the critical section. */
+	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->seq[idx]) += 1;
 	preempt_enable();
 	return idx;
 }
@@ -149,8 +319,8 @@ EXPORT_SYMBOL_GPL(__srcu_read_lock);
 void __srcu_read_unlock(struct srcu_struct *sp, int idx)
 {
 	preempt_disable();
-	srcu_barrier();  /* ensure compiler won't misorder critical section. */
-	per_cpu_ptr(sp->per_cpu_ref, smp_processor_id())->c[idx]--;
+	smp_mb(); /* C */  /* Avoid leaking the critical section. */
+	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) -= 1;
 	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(__srcu_read_unlock);
@@ -163,106 +333,119 @@ EXPORT_SYMBOL_GPL(__srcu_read_unlock);
  * we repeatedly block for 1-millisecond time periods.  This approach
  * has done well in testing, so there is no need for a config parameter.
  */
-#define SYNCHRONIZE_SRCU_READER_DELAY 10
+#define SRCU_RETRY_CHECK_DELAY		5
+#define SYNCHRONIZE_SRCU_TRYCOUNT	2
+#define SYNCHRONIZE_SRCU_EXP_TRYCOUNT	12
 
 /*
- * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
+ * @@@ Wait until all pre-existing readers complete.  Such readers
+ * will have used the index specified by "idx".
+ * the caller should ensures the ->completed is not changed while checking
+ * and idx = (->completed & 1) ^ 1
  */
-static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
+static bool try_check_zero(struct srcu_struct *sp, int idx, int trycount)
 {
-	int idx;
-
-	rcu_lockdep_assert(!lock_is_held(&sp->dep_map) &&
-			   !lock_is_held(&rcu_bh_lock_map) &&
-			   !lock_is_held(&rcu_lock_map) &&
-			   !lock_is_held(&rcu_sched_lock_map),
-			   "Illegal synchronize_srcu() in same-type SRCU (or RCU) read-side critical section");
-
-	idx = sp->completed;
-	mutex_lock(&sp->mutex);
+	for (;;) {
+		if (srcu_readers_active_idx_check(sp, idx))
+			return true;
+		if (--trycount <= 0)
+			return false;
+		udelay(SRCU_RETRY_CHECK_DELAY);
+	}
+}
 
-	/*
-	 * Check to see if someone else did the work for us while we were
-	 * waiting to acquire the lock.  We need -two- advances of
-	 * the counter, not just one.  If there was but one, we might have
-	 * shown up -after- our helper's first synchronize_sched(), thus
-	 * having failed to prevent CPU-reordering races with concurrent
-	 * srcu_read_unlock()s on other CPUs (see comment below).  So we
-	 * either (1) wait for two or (2) supply the second ourselves.
-	 */
+/*
+ * Increment the ->completed counter so that future SRCU readers will
+ * use the other rank of the ->c[] and ->seq[] arrays.  This allows
+ * us to wait for pre-existing readers in a starvation-free manner.
+ */
+static void srcu_flip(struct srcu_struct *sp)
+{
+	sp->completed++;
+}
 
-	if ((sp->completed - idx) >= 2) {
-		mutex_unlock(&sp->mutex);
-		return;
+/*
+ * Enqueue an SRCU callback on the specified srcu_struct structure,
+ * initiating grace-period processing if it is not already running.
+ */
+void call_srcu(struct srcu_struct *sp, struct rcu_head *head,
+		void (*func)(struct rcu_head *head))
+{
+	unsigned long flags;
+
+	head->next = NULL;
+	head->func = func;
+	spin_lock_irqsave(&sp->queue_lock, flags);
+	rcu_batch_queue(&sp->batch_queue, head);
+	if (!sp->running) {
+		sp->running = true;
+		queue_delayed_work(system_nrt_wq, &sp->work, 0);
 	}
+	spin_unlock_irqrestore(&sp->queue_lock, flags);
+}
+EXPORT_SYMBOL_GPL(call_srcu);
 
-	sync_func();  /* Force memory barrier on all CPUs. */
+struct rcu_synchronize {
+	struct rcu_head head;
+	struct completion completion;
+};
 
-	/*
-	 * The preceding synchronize_sched() ensures that any CPU that
-	 * sees the new value of sp->completed will also see any preceding
-	 * changes to data structures made by this CPU.  This prevents
-	 * some other CPU from reordering the accesses in its SRCU
-	 * read-side critical section to precede the corresponding
-	 * srcu_read_lock() -- ensuring that such references will in
-	 * fact be protected.
-	 *
-	 * So it is now safe to do the flip.
-	 */
+/*
+ * Awaken the corresponding synchronize_srcu() instance now that a
+ * grace period has elapsed.
+ */
+static void wakeme_after_rcu(struct rcu_head *head)
+{
+	struct rcu_synchronize *rcu;
 
-	idx = sp->completed & 0x1;
-	sp->completed++;
+	rcu = container_of(head, struct rcu_synchronize, head);
+	complete(&rcu->completion);
+}
 
-	sync_func();  /* Force memory barrier on all CPUs. */
+static void srcu_advance_batches(struct srcu_struct *sp, int trycount);
+static void srcu_reschedule(struct srcu_struct *sp);
 
-	/*
-	 * At this point, because of the preceding synchronize_sched(),
-	 * all srcu_read_lock() calls using the old counters have completed.
-	 * Their corresponding critical sections might well be still
-	 * executing, but the srcu_read_lock() primitives themselves
-	 * will have finished executing.  We initially give readers
-	 * an arbitrarily chosen 10 microseconds to get out of their
-	 * SRCU read-side critical sections, then loop waiting 1/HZ
-	 * seconds per iteration.  The 10-microsecond value has done
-	 * very well in testing.
-	 */
-
-	if (srcu_readers_active_idx(sp, idx))
-		udelay(SYNCHRONIZE_SRCU_READER_DELAY);
-	while (srcu_readers_active_idx(sp, idx))
-		schedule_timeout_interruptible(1);
+/*
+ * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
+ */
+static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
+{
+	struct rcu_synchronize rcu;
+	struct rcu_head *head = &rcu.head;
+	bool done = false;
 
-	sync_func();  /* Force memory barrier on all CPUs. */
+	rcu_lockdep_assert(!lock_is_held(&sp->dep_map) &&
+			   !lock_is_held(&rcu_bh_lock_map) &&
+			   !lock_is_held(&rcu_lock_map) &&
+			   !lock_is_held(&rcu_sched_lock_map),
+			   "Illegal synchronize_srcu() in same-type SRCU (or RCU) read-side critical section");
 
-	/*
-	 * The preceding synchronize_sched() forces all srcu_read_unlock()
-	 * primitives that were executing concurrently with the preceding
-	 * for_each_possible_cpu() loop to have completed by this point.
-	 * More importantly, it also forces the corresponding SRCU read-side
-	 * critical sections to have also completed, and the corresponding
-	 * references to SRCU-protected data items to be dropped.
-	 *
-	 * Note:
-	 *
-	 *	Despite what you might think at first glance, the
-	 *	preceding synchronize_sched() -must- be within the
-	 *	critical section ended by the following mutex_unlock().
-	 *	Otherwise, a task taking the early exit can race
-	 *	with a srcu_read_unlock(), which might have executed
-	 *	just before the preceding srcu_readers_active() check,
-	 *	and whose CPU might have reordered the srcu_read_unlock()
-	 *	with the preceding critical section.  In this case, there
-	 *	is nothing preventing the synchronize_sched() task that is
-	 *	taking the early exit from freeing a data structure that
-	 *	is still being referenced (out of order) by the task
-	 *	doing the srcu_read_unlock().
-	 *
-	 *	Alternatively, the comparison with "2" on the early exit
-	 *	could be changed to "3", but this increases synchronize_srcu()
-	 *	latency for bulk loads.  So the current code is preferred.
-	 */
+	init_completion(&rcu.completion);
+
+	head->next = NULL;
+	head->func = wakeme_after_rcu;
+	spin_lock_irq(&sp->queue_lock);
+	if (!sp->running) {
+		/* steal the processing owner */
+		sp->running = true;
+		rcu_batch_queue(&sp->batch_check0, head);
+		spin_unlock_irq(&sp->queue_lock);
+
+		srcu_advance_batches(sp, trycount);
+		if (!rcu_batch_empty(&sp->batch_done)) {
+			BUG_ON(sp->batch_done.head != head);
+			rcu_batch_dequeue(&sp->batch_done);
+			done = true;
+		}
+		/* give the processing owner to work_struct */
+		srcu_reschedule(sp);
+	} else {
+		rcu_batch_queue(&sp->batch_queue, head);
+		spin_unlock_irq(&sp->queue_lock);
+	}
 
-	mutex_unlock(&sp->mutex);
+	if (!done)
+		wait_for_completion(&rcu.completion);
 }
 
 /**
@@ -281,7 +464,7 @@ static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
  */
 void synchronize_srcu(struct srcu_struct *sp)
 {
-	__synchronize_srcu(sp, synchronize_sched);
+	__synchronize_srcu(sp, SYNCHRONIZE_SRCU_TRYCOUNT);
 }
 EXPORT_SYMBOL_GPL(synchronize_srcu);
 
@@ -289,18 +472,11 @@ EXPORT_SYMBOL_GPL(synchronize_srcu);
  * synchronize_srcu_expedited - Brute-force SRCU grace period
  * @sp: srcu_struct with which to synchronize.
  *
- * Wait for an SRCU grace period to elapse, but use a "big hammer"
- * approach to force the grace period to end quickly.  This consumes
- * significant time on all CPUs and is unfriendly to real-time workloads,
- * so is thus not recommended for any sort of common-case code.  In fact,
- * if you are using synchronize_srcu_expedited() in a loop, please
- * restructure your code to batch your updates, and then use a single
- * synchronize_srcu() instead.
+ * Wait for an SRCU grace period to elapse, but be more aggressive about
+ * spinning rather than blocking when waiting.
  *
  * Note that it is illegal to call this function while holding any lock
- * that is acquired by a CPU-hotplug notifier.  And yes, it is also illegal
- * to call this function from a CPU-hotplug notifier.  Failing to observe
- * these restriction will result in deadlock.  It is also illegal to call
+ * that is acquired by a CPU-hotplug notifier.  It is also illegal to call
  * synchronize_srcu_expedited() from the corresponding SRCU read-side
  * critical section; doing so will result in deadlock.  However, it is
  * perfectly legal to call synchronize_srcu_expedited() on one srcu_struct
@@ -309,20 +485,166 @@ EXPORT_SYMBOL_GPL(synchronize_srcu);
  */
 void synchronize_srcu_expedited(struct srcu_struct *sp)
 {
-	__synchronize_srcu(sp, synchronize_sched_expedited);
+	__synchronize_srcu(sp, SYNCHRONIZE_SRCU_EXP_TRYCOUNT);
 }
 EXPORT_SYMBOL_GPL(synchronize_srcu_expedited);
 
 /**
+ * srcu_barrier - Wait until all in-flight call_srcu() callbacks complete.
+ */
+void srcu_barrier(struct srcu_struct *sp)
+{
+	synchronize_srcu(sp);
+}
+EXPORT_SYMBOL_GPL(srcu_barrier);
+
+/**
  * srcu_batches_completed - return batches completed.
  * @sp: srcu_struct on which to report batch completion.
  *
  * Report the number of batches, correlated with, but not necessarily
  * precisely the same as, the number of grace periods that have elapsed.
  */
-
 long srcu_batches_completed(struct srcu_struct *sp)
 {
 	return sp->completed;
 }
 EXPORT_SYMBOL_GPL(srcu_batches_completed);
+
+#define SRCU_CALLBACK_BATCH	10
+#define SRCU_INTERVAL		1
+
+/*
+ * Move any new SRCU callbacks to the first stage of the SRCU grace
+ * period pipeline.
+ */
+static void srcu_collect_new(struct srcu_struct *sp)
+{
+	if (!rcu_batch_empty(&sp->batch_queue)) {
+		spin_lock_irq(&sp->queue_lock);
+		rcu_batch_move(&sp->batch_check0, &sp->batch_queue);
+		spin_unlock_irq(&sp->queue_lock);
+	}
+}
+
+/*
+ * Core SRCU state machine.  Advance callbacks from ->batch_check0 to
+ * ->batch_check1 and then to ->batch_done as readers drain.
+ */
+static void srcu_advance_batches(struct srcu_struct *sp, int trycount)
+{
+	int idx = 1 ^ (sp->completed & 1);
+
+	/*
+	 * Because readers might be delayed for an extended period after
+	 * fetching ->completed for their index, at any point in time there
+	 * might well be readers using both idx=0 and idx=1.  We therefore
+	 * need to wait for readers to clear from both index values before
+	 * invoking a callback.
+	 */
+
+	if (rcu_batch_empty(&sp->batch_check0) &&
+	    rcu_batch_empty(&sp->batch_check1))
+		return; /* no callbacks need to be advanced */
+
+	if (!try_check_zero(sp, idx, trycount))
+		return; /* failed to advance, will try after SRCU_INTERVAL */
+
+	/*
+	 * The callbacks in ->batch_check1 have already done with their
+	 * first zero check and flip back when they were enqueued on
+	 * ->batch_check0 in a previous invocation of srcu_advance_batches().
+	 * (Presumably try_check_zero() returned false during that
+	 * invocation, leaving the callbacks stranded on ->batch_check1.)
+	 * They are therefore ready to invoke, so move them to ->batch_done.
+	 */
+	rcu_batch_move(&sp->batch_done, &sp->batch_check1);
+
+	if (rcu_batch_empty(&sp->batch_check0))
+		return; /* no callbacks need to be advanced */
+	srcu_flip(sp);
+
+	/*
+	 * The callbacks in ->batch_check0 just finished their
+	 * first check zero and flip, so move them to ->batch_check1
+	 * for future checking on the other idx.
+	 */
+	rcu_batch_move(&sp->batch_check1, &sp->batch_check0);
+
+	/*
+	 * SRCU read-side critical sections are normally short, so check
+	 * at least twice in quick succession after a flip.
+	 */
+	trycount = trycount < 2 ? 2 : trycount;
+	if (!try_check_zero(sp, idx^1, trycount))
+		return; /* failed to advance, will try after SRCU_INTERVAL */
+
+	/*
+	 * The callbacks in ->batch_check1 have now waited for all
+	 * pre-existing readers using both idx values.  They are therefore
+	 * ready to invoke, so move them to ->batch_done.
+	 */
+	rcu_batch_move(&sp->batch_done, &sp->batch_check1);
+}
+
+/*
+ * Invoke a limited number of SRCU callbacks that have passed through
+ * their grace period.  If there are more to do, SRCU will reschedule
+ * the workqueue.
+ */
+static void srcu_invoke_callbacks(struct srcu_struct *sp)
+{
+	int i;
+	struct rcu_head *head;
+
+	for (i = 0; i < SRCU_CALLBACK_BATCH; i++) {
+		head = rcu_batch_dequeue(&sp->batch_done);
+		if (!head)
+			break;
+		local_bh_disable();
+		head->func(head);
+		local_bh_enable();
+	}
+}
+
+/*
+ * Finished one round of SRCU grace period.  Start another if there are
+ * more SRCU callbacks queued, otherwise put SRCU into not-running state.
+ */
+static void srcu_reschedule(struct srcu_struct *sp)
+{
+	bool pending = true;
+
+	if (rcu_batch_empty(&sp->batch_done) &&
+	    rcu_batch_empty(&sp->batch_check1) &&
+	    rcu_batch_empty(&sp->batch_check0) &&
+	    rcu_batch_empty(&sp->batch_queue)) {
+		spin_lock_irq(&sp->queue_lock);
+		if (rcu_batch_empty(&sp->batch_done) &&
+		    rcu_batch_empty(&sp->batch_check1) &&
+		    rcu_batch_empty(&sp->batch_check0) &&
+		    rcu_batch_empty(&sp->batch_queue)) {
+			sp->running = false;
+			pending = false;
+		}
+		spin_unlock_irq(&sp->queue_lock);
+	}
+
+	if (pending)
+		queue_delayed_work(system_nrt_wq, &sp->work, SRCU_INTERVAL);
+}
+
+/*
+ * This is the work-queue function that handles SRCU grace periods.
+ */
+static void process_srcu(struct work_struct *work)
+{
+	struct srcu_struct *sp;
+
+	sp = container_of(work, struct srcu_struct, work.work);
+
+	srcu_collect_new(sp);
+	srcu_advance_batches(sp, 1);
+	srcu_invoke_callbacks(sp);
+	srcu_reschedule(sp);
+}
diff --git a/kernel/timer.c b/kernel/timer.c
index a297ffc..837c552 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -861,7 +861,13 @@ EXPORT_SYMBOL(mod_timer);
  *
  * mod_timer_pinned() is a way to update the expire field of an
  * active timer (if the timer is inactive it will be activated)
- * and not allow the timer to be migrated to a different CPU.
+ * and to ensure that the timer is scheduled on the current CPU.
+ *
+ * Note that this does not prevent the timer from being migrated
+ * when the current CPU goes offline.  If this is a problem for
+ * you, use CPU-hotplug notifiers to handle it correctly, for
+ * example, cancelling the timer when the corresponding CPU goes
+ * offline.
  *
  * mod_timer_pinned(timer, expires) is equivalent to:
  *
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 982b850..3810b48 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -10,6 +10,7 @@
 #include <linux/list.h>
 #include <linux/bug.h>
 #include <linux/kernel.h>
+#include <linux/rculist.h>
 
 /*
  * Insert a new entry between two known consecutive entries.
@@ -75,3 +76,24 @@ void list_del(struct list_head *entry)
 	entry->prev = LIST_POISON2;
 }
 EXPORT_SYMBOL(list_del);
+
+/*
+ * RCU variants.
+ */
+void __list_add_rcu(struct list_head *new,
+		    struct list_head *prev, struct list_head *next)
+{
+	WARN(next->prev != prev,
+		"list_add_rcu corruption. next->prev should be "
+		"prev (%p), but was %p. (next=%p).\n",
+		prev, next->prev, next);
+	WARN(prev->next != next,
+		"list_add_rcu corruption. prev->next should be "
+		"next (%p), but was %p. (prev=%p).\n",
+		next, prev->next, prev);
+	new->next = next;
+	new->prev = prev;
+	rcu_assign_pointer(list_next_rcu(prev), new);
+	next->prev = new;
+}
+EXPORT_SYMBOL(__list_add_rcu);
