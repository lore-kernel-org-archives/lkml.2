Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270Ab1D0EHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 00:07:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56349 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab1D0EHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 00:07:03 -0400
Message-ID: <4DB793F7.9080300@cn.fujitsu.com>
Date: Wed, 27 Apr 2011 11:56:39 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -rcu 1/1] rcu: fix rcu CONFIG logic
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-27 11:54:25,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-27 12:07:25,
	Serialize complete at 2011-04-27 12:07:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In human logic, TREE_PREEMPT_RCU should be a special type of TREE_RCU.
In the code implementation, TREE_PREEMPT_RCU is implemented based on TREE_RCU
with preemptible feature.

But in CPP logic, TREE_PREEMPT_RCU and TREE_RCU are in opposing positions,
Some code uses defined(CONFIG_TREE_RCU) for !TREE_PREEMPT_RCU code or vise versa.
It confuses. Sometimes, "#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)"
makes me sad: why TREE_PREEMPT_RCU is not a TREE_RCU since it is based on TREE_RCU?
(Why pretty girls are not girls?)

(The same with TINY_RCU)

After this fix applied, we *only* have 2 RCU implementations, TINY_RCU and TREE_RCU.
Preemptibility is *just* the most important *feature* of them and CONFIG_PREEMPT_RCU
can enable this feature. It makes CONFIGs reasonable, see the diffs of
include/linux/rcupdate.h, kernel/Makefile, init/Kconfig.

TREE_PREEMPT_RCU can be defined as an alias of "TREE_RCU && PREEMPT_RCU" now,
but after I reviewed the code, comments and documents, I found TREE_PREEMPT_RCU
is only used under TREE_RCU context, so I can simply convert TREE_PREEMPT_RCU
to PREEMPT_RCU without any ambiguity. (The same with TINY_RCU).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 Documentation/RCU/rcu.txt       |    4 +-
 Documentation/RCU/stallwarn.txt |   10 ++++----
 Documentation/RCU/trace.txt     |   16 ++++++------
 Documentation/RCU/whatisRCU.txt |    2 +-
 include/linux/hardirq.h         |    2 +-
 include/linux/init_task.h       |    4 +-
 include/linux/rcupdate.h        |   10 ++++----
 include/linux/rcutiny.h         |   12 ++++----
 include/linux/rcutree.h         |    6 ++--
 include/linux/sched.h           |   10 ++++----
 init/Kconfig                    |   51 +++++++++++++++++---------------------
 kernel/Makefile                 |    2 -
 kernel/rcutiny_plugin.h         |   10 ++++----
 kernel/rcutree.h                |   10 ++++----
 kernel/rcutree_plugin.h         |    8 +++---
 kernel/rcutree_trace.c          |   20 +++++++-------
 16 files changed, 85 insertions(+), 92 deletions(-)

diff --git a/Documentation/RCU/rcu.txt b/Documentation/RCU/rcu.txt
index 3185270..71525ae 100644
--- a/Documentation/RCU/rcu.txt
+++ b/Documentation/RCU/rcu.txt
@@ -36,7 +36,7 @@ o	How can the updater tell when a grace period has completed
 	executed in user mode, or executed in the idle loop, we can
 	safely free up that item.
 
-	Preemptible variants of RCU (CONFIG_TREE_PREEMPT_RCU) get the
+	Preemptible variants of RCU (CONFIG_PREEMPT_RCU) get the
 	same effect, but require that the readers manipulate CPU-local
 	counters.  These counters allow limited types of blocking
 	within RCU read-side critical sections.  SRCU also uses
@@ -81,7 +81,7 @@ o	I hear that RCU is patented?  What is with that?
 o	I hear that RCU needs work in order to support realtime kernels?
 
 	This work is largely completed.  Realtime-friendly RCU can be
-	enabled via the CONFIG_TREE_PREEMPT_RCU kernel configuration
+	enabled via the CONFIG_PREEMPT_RCU kernel configuration
 	parameter.  However, work is in progress for enabling priority
 	boosting of preempted RCU read-side critical sections.	This is
 	needed if you have CPU-bound realtime threads.
diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 4e95920..e29cb3f 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -37,9 +37,9 @@ INFO: rcu_sched_state detected stall on CPU 5 (t=2500 jiffies)
 
 This message indicates that CPU 5 detected that it was causing a stall,
 and that the stall was affecting RCU-sched.  This message will normally be
-followed by a stack dump of the offending CPU.  On TREE_RCU kernel builds,
+followed by a stack dump of the offending CPU.  On !PREEMPT_RCU kernel builds,
 RCU and RCU-sched are implemented by the same underlying mechanism,
-while on TREE_PREEMPT_RCU kernel builds, RCU is instead implemented
+while on PREEMPT_RCU kernel builds, RCU is instead implemented
 by rcu_preempt_state.
 
 On the other hand, if the offending CPU fails to print out a stall-warning
@@ -51,7 +51,7 @@ INFO: rcu_bh_state detected stalls on CPUs/tasks: { 3 5 } (detected by 2, 2502 j
 This message indicates that CPU 2 detected that CPUs 3 and 5 were both
 causing stalls, and that the stall was affecting RCU-bh.  This message
 will normally be followed by stack dumps for each CPU.  Please note that
-TREE_PREEMPT_RCU builds can be stalled by tasks as well as by CPUs,
+PREEMPT_RCU builds can be stalled by tasks as well as by CPUs,
 and that the tasks will be indicated by PID, for example, "P3421".
 It is even possible for a rcu_preempt_state stall to be caused by both
 CPUs -and- tasks, in which case the offending CPUs and tasks will all
@@ -95,10 +95,10 @@ o	A CPU-bound real-time task in a CONFIG_PREEMPT kernel, which might
 o	A CPU-bound real-time task in a CONFIG_PREEMPT_RT kernel that
 	is running at a higher priority than the RCU softirq threads.
 	This will prevent RCU callbacks from ever being invoked,
-	and in a CONFIG_TREE_PREEMPT_RCU kernel will further prevent
+	and in a CONFIG_PREEMPT_RCU kernel will further prevent
 	RCU grace periods from ever completing.  Either way, the
 	system will eventually run out of memory and hang.  In the
-	CONFIG_TREE_PREEMPT_RCU case, you might see stall-warning
+	CONFIG_PREEMPT_RCU case, you might see stall-warning
 	messages.
 
 o	A bug in the RCU implementation.
diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 0346d3c..f604e35 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -8,7 +8,7 @@ The following sections describe the debugfs files and formats, first
 for rcutree and next for rcutiny.
 
 
-CONFIG_TREE_RCU and CONFIG_TREE_PREEMPT_RCU debugfs Files and Formats
+CONFIG_TREE_RCU debugfs Files and Formats
 
 These implementations of RCU provides seven debugfs files under the
 top-level directory RCU: rcu/rcudata (which displays fields in struct
@@ -43,7 +43,7 @@ rcu_bh:
   7 c=182 g=182 pq=1 pqc=181 qp=0 dt=937087/1/0 df=14 of=0 ri=1 ql=0 qs=....  kt=0/W b=10 ci=627 co=0 ca=0
 
 The first section lists the rcu_data structures for rcu_sched, the second
-for rcu_bh.  Note that CONFIG_TREE_PREEMPT_RCU kernels will have an
+for rcu_bh.  Note that CONFIG_PREEMPT_RCU kernels will have an
 additional section for rcu_preempt.  Each section has one line per CPU,
 or eight for this 8-CPU system.  The fields are as follows:
 
@@ -192,7 +192,7 @@ rcu_sched: completed=33062  gpnum=33063
 rcu_bh: completed=464  gpnum=464
 
 Again, this output is for both "rcu_sched" and "rcu_bh".  Note that
-kernels built with CONFIG_TREE_PREEMPT_RCU will have an additional
+kernels built with CONFIG_PREEMPT_RCU will have an additional
 "rcu_preempt" line.  The fields are taken from the rcu_state structure,
 and are as follows:
 
@@ -225,7 +225,7 @@ c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0
 0/3f ..>. 0:5 ^0    0/3 ..>. 6:11 ^1    0/0 ..>. 12:17 ^2    0/0 ..>. 18:23 ^3    0/0 ..>. 24:29 ^4    0/0 ..>. 30:35 ^5    0/0 ..>. 36:41 ^0    0/0 ..>. 42:47 ^1    0/0 ..>. 48:53 ^2    0/0 ..>. 54:59 ^3    0/0 ..>. 60:65 ^4    0/0 ..>. 66:71 ^5    0/0 ..>. 72:77 ^0    0/0 ..>. 78:83 ^1    0/0 ..>. 84:89 ^2    0/0 ..>. 90:95 ^3    0/0 ..>. 96:101 ^4    0/0 ..>. 102:107 ^5    0/0 ..>. 108:113 ^0    0/0 ..>. 114:119 ^1    0/0 ..>. 120:125 ^2    0/0 ..>. 126:127 ^3
 
 This is once again split into "rcu_sched" and "rcu_bh" portions,
-and CONFIG_TREE_PREEMPT_RCU kernels will again have an additional
+and CONFIG_PREEMPT_RCU kernels will again have an additional
 "rcu_preempt" section.  The fields are as follows:
 
 o	"c" is exactly the same as "completed" under rcu/rcugp.
@@ -334,7 +334,7 @@ rcu_bh:
   7 np=144888 qsp=26336 rpq=0 cbr=0 cng=0 gpc=8 gps=2 nf=0 nn=118542
 
 As always, this is once again split into "rcu_sched" and "rcu_bh"
-portions, with CONFIG_TREE_PREEMPT_RCU kernels having an additional
+portions, with CONFIG_PREEMPT_RCU kernels having an additional
 "rcu_preempt" section.  The fields are as follows:
 
 o	"np" is the number of times that __rcu_pending() has been invoked
@@ -483,11 +483,11 @@ o	"nos" counts the number of times we balked for other
 	reasons, e.g., the grace period ended first.
 
 
-CONFIG_TINY_RCU and CONFIG_TINY_PREEMPT_RCU debugfs Files and Formats
+CONFIG_TINY_RCU debugfs Files and Formats
 
 These implementations of RCU provides a single debugfs file under the
 top-level directory RCU, namely rcu/rcudata, which displays fields in
-rcu_bh_ctrlblk, rcu_sched_ctrlblk and, for CONFIG_TINY_PREEMPT_RCU,
+rcu_bh_ctrlblk, rcu_sched_ctrlblk and, for CONFIG_PREEMPT_RCU,
 rcu_preempt_ctrlblk.
 
 The output of "cat rcu/rcudata" is as follows:
@@ -500,7 +500,7 @@ rcu_sched: qlen: 0
 rcu_bh: qlen: 0
 
 This is split into rcu_preempt, rcu_sched, and rcu_bh sections, with the
-rcu_preempt section appearing only in CONFIG_TINY_PREEMPT_RCU builds.
+rcu_preempt section appearing only in CONFIG_PREEMPT_RCU builds.
 The last three lines of the rcu_preempt section appear only in
 CONFIG_RCU_BOOST kernel builds.  The fields are as follows:
 
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 6ef6926..da4615f 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -136,7 +136,7 @@ rcu_read_lock()
 	Used by a reader to inform the reclaimer that the reader is
 	entering an RCU read-side critical section.  It is illegal
 	to block while in an RCU read-side critical section, though
-	kernels built with CONFIG_TREE_PREEMPT_RCU can preempt RCU
+	kernels built with CONFIG_PREEMPT_RCU can preempt RCU
 	read-side critical sections.  Any RCU-protected data structure
 	accessed during an RCU read-side critical section is guaranteed to
 	remain unreclaimed for the full duration of that critical section.
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index ba36217..dbe0073 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -140,7 +140,7 @@ extern void account_system_vtime(struct task_struct *tsk);
 #endif
 
 #if defined(CONFIG_NO_HZ)
-#if defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
+#if defined(CONFIG_TINY_RCU)
 extern void rcu_enter_nohz(void);
 extern void rcu_exit_nohz(void);
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index caa151f..c238f59 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -90,19 +90,19 @@ extern struct group_info init_groups;
  */
 # define CAP_INIT_BSET  CAP_FULL_SET
 
+#ifdef CONFIG_PREEMPT_RCU
 #ifdef CONFIG_RCU_BOOST
 #define INIT_TASK_RCU_BOOST()						\
 	.rcu_boost_mutex = NULL,
 #else
 #define INIT_TASK_RCU_BOOST()
 #endif
-#ifdef CONFIG_TREE_PREEMPT_RCU
+#ifdef CONFIG_TREE_RCU
 #define INIT_TASK_RCU_TREE_PREEMPT()					\
 	.rcu_blocked_node = NULL,
 #else
 #define INIT_TASK_RCU_TREE_PREEMPT(tsk)
 #endif
-#ifdef CONFIG_PREEMPT_RCU
 #define INIT_TASK_RCU_PREEMPT(tsk)					\
 	.rcu_read_lock_nesting = 0,					\
 	.rcu_read_unlock_special = 0,					\
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 99f9aa7..6a83e186 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -47,7 +47,7 @@
 extern int rcutorture_runnable; /* for sysctl */
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
-#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
+#if defined(CONFIG_TREE_RCU)
 extern void rcutorture_record_test_transition(void);
 extern void rcutorture_record_progress(unsigned long vernum);
 #else
@@ -152,9 +152,9 @@ static inline void rcu_exit_nohz(void)
 
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
-#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
+#if defined(CONFIG_TREE_RCU)
 #include <linux/rcutree.h>
-#elif defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
+#elif defined(CONFIG_TINY_RCU)
 #include <linux/rcutiny.h>
 #else
 #error "Unknown RCU implementation specified to kernel configuration"
@@ -577,9 +577,9 @@ extern int rcu_my_thread_group_empty(void);
  * read-side critical section that would block in a !PREEMPT kernel.
  * But if you want the full story, read on!
  *
- * In non-preemptible RCU implementations (TREE_RCU and TINY_RCU), it
+ * In non-preemptible RCU implementations (PREEMPT_RCU = n), it
  * is illegal to block while in an RCU read-side critical section.  In
- * preemptible RCU implementations (TREE_PREEMPT_RCU and TINY_PREEMPT_RCU)
+ * preemptible RCU implementations (PREEMPT_RCU = y)
  * in CONFIG_PREEMPT kernel builds, RCU read-side critical sections may
  * be preempted, but explicit blocking is illegal.  Finally, in preemptible
  * RCU implementations in real-time (CONFIG_PREEMPT_RT) kernel builds,
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 30ebd7c..e580444 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -31,7 +31,7 @@ static inline void rcu_init(void)
 {
 }
 
-#ifdef CONFIG_TINY_RCU
+#if !defined(CONFIG_PREEMPT_RCU)
 
 static inline void synchronize_rcu_expedited(void)
 {
@@ -43,12 +43,12 @@ static inline void rcu_barrier(void)
 	rcu_barrier_sched();  /* Only one CPU, so only one list of callbacks! */
 }
 
-#else /* #ifdef CONFIG_TINY_RCU */
+#else /* #if !defined(CONFIG_PREEMPT_RCU) */
 
 void rcu_barrier(void);
 void synchronize_rcu_expedited(void);
 
-#endif /* #else #ifdef CONFIG_TINY_RCU */
+#endif /* #else if !defined(CONFIG_PREEMPT_RCU) */
 
 static inline void synchronize_rcu_bh(void)
 {
@@ -65,7 +65,7 @@ static inline void synchronize_sched_expedited(void)
 	synchronize_sched();
 }
 
-#ifdef CONFIG_TINY_RCU
+#if !defined(CONFIG_PREEMPT_RCU)
 
 static inline void rcu_preempt_note_context_switch(void)
 {
@@ -80,7 +80,7 @@ static inline int rcu_needs_cpu(int cpu)
 	return 0;
 }
 
-#else /* #ifdef CONFIG_TINY_RCU */
+#else /* #if !defined(CONFIG_PREEMPT_RCU) */
 
 void rcu_preempt_note_context_switch(void);
 extern void exit_rcu(void);
@@ -91,7 +91,7 @@ static inline int rcu_needs_cpu(int cpu)
 	return rcu_preempt_needs_cpu();
 }
 
-#endif /* #else #ifdef CONFIG_TINY_RCU */
+#endif /* #else if !defined(CONFIG_PREEMPT_RCU) */
 
 static inline void rcu_note_context_switch(int cpu)
 {
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 284dad1..3550ddf 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -35,17 +35,17 @@ extern void rcu_note_context_switch(int cpu);
 extern int rcu_needs_cpu(int cpu);
 extern void rcu_cpu_stall_reset(void);
 
-#ifdef CONFIG_TREE_PREEMPT_RCU
+#ifdef CONFIG_PREEMPT_RCU
 
 extern void exit_rcu(void);
 
-#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#else /* #ifdef CONFIG_PREEMPT_RCU */
 
 static inline void exit_rcu(void)
 {
 }
 
-#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
 
 extern void synchronize_rcu_bh(void);
 extern void synchronize_sched_expedited(void);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ec2c02..2599f31 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1236,13 +1236,13 @@ struct task_struct {
 	int rcu_read_lock_nesting;
 	char rcu_read_unlock_special;
 	struct list_head rcu_node_entry;
-#endif /* #ifdef CONFIG_PREEMPT_RCU */
-#ifdef CONFIG_TREE_PREEMPT_RCU
+#ifdef CONFIG_TREE_RCU
 	struct rcu_node *rcu_blocked_node;
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#endif /* #ifdef CONFIG_TREE_RCU */
 #ifdef CONFIG_RCU_BOOST
 	struct rt_mutex *rcu_boost_mutex;
 #endif /* #ifdef CONFIG_RCU_BOOST */
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
@@ -1787,9 +1787,9 @@ static inline void rcu_copy_process(struct task_struct *p)
 {
 	p->rcu_read_lock_nesting = 0;
 	p->rcu_read_unlock_special = 0;
-#ifdef CONFIG_TREE_PREEMPT_RCU
+#ifdef CONFIG_TREE_RCU
 	p->rcu_blocked_node = NULL;
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#endif /* #ifdef CONFIG_TREE_RCU */
 #ifdef CONFIG_RCU_BOOST
 	p->rcu_boost_mutex = NULL;
 #endif /* #ifdef CONFIG_RCU_BOOST */
diff --git a/init/Kconfig b/init/Kconfig
index 8fc00ef..d5d8c8e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -374,47 +374,42 @@ choice
 
 config TREE_RCU
 	bool "Tree-based hierarchical RCU"
-	depends on !PREEMPT && SMP
+	depends on SMP
+	select HAVE_PREEMPT_RCU
 	help
 	  This option selects the RCU implementation that is
 	  designed for very large SMP system with hundreds or
 	  thousands of CPUs.  It also scales down nicely to
 	  smaller systems.
 
-config TREE_PREEMPT_RCU
-	bool "Preemptible tree-based hierarchical RCU"
-	depends on PREEMPT
-	help
-	  This option selects the RCU implementation that is
-	  designed for very large SMP systems with hundreds or
-	  thousands of CPUs, but for which real-time response
-	  is also required.  It also scales down nicely to
-	  smaller systems.
-
 config TINY_RCU
 	bool "UP-only small-memory-footprint RCU"
 	depends on !SMP
+	select HAVE_PREEMPT_RCU
 	help
 	  This option selects the RCU implementation that is
 	  designed for UP systems from which real-time response
 	  is not required.  This option greatly reduces the
 	  memory footprint of RCU.
 
-config TINY_PREEMPT_RCU
-	bool "Preemptible UP-only small-memory-footprint RCU"
-	depends on !SMP && PREEMPT
-	help
-	  This option selects the RCU implementation that is designed
-	  for real-time UP systems.  This option greatly reduces the
-	  memory footprint of RCU.
-
 endchoice
 
+config HAVE_PREEMPT_RCU
+	bool
+
 config PREEMPT_RCU
-	def_bool ( TREE_PREEMPT_RCU || TINY_PREEMPT_RCU )
+	bool "Preemptible RCU based on core RCU"
+	depends on PREEMPT && HAVE_PREEMPT_RCU
+	default y
 	help
-	  This option enables preemptible-RCU code that is common between
-	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
+	  This option makes the core RCU implementation(TREE_RCU or TINY_RCU)
+	  preemptible for real-time response. If PREEMPT_RCU=n, RCU and
+	  RCU-sched are implemented by sharing the same state, and all RCU
+	  primitives are mapped to the corresponding RCU-sched primitives.
+	  If PREEMPT_RCU=y, RCU uses its own state and per-task-local state
+	  is added to task_struct including a counter for the task's unclosed
+	  rcu_read_lock() which is used for protecting preempted RCU read-side
+	  critical sections.
 
 config RCU_TRACE
 	bool "Enable tracing for RCU"
@@ -429,7 +424,7 @@ config RCU_FANOUT
 	int "Tree-based hierarchical RCU fanout value"
 	range 2 64 if 64BIT
 	range 2 32 if !64BIT
-	depends on TREE_RCU || TREE_PREEMPT_RCU
+	depends on TREE_RCU
 	default 64 if 64BIT
 	default 32 if !64BIT
 	help
@@ -447,7 +442,7 @@ config RCU_FANOUT
 
 config RCU_FANOUT_EXACT
 	bool "Disable tree-based hierarchical RCU auto-balancing"
-	depends on TREE_RCU || TREE_PREEMPT_RCU
+	depends on TREE_RCU
 	default n
 	help
 	  This option forces use of the exact RCU_FANOUT value specified,
@@ -461,7 +456,7 @@ config RCU_FANOUT_EXACT
 
 config RCU_FAST_NO_HZ
 	bool "Accelerate last non-dyntick-idle CPU's grace periods"
-	depends on TREE_RCU && NO_HZ && SMP
+	depends on TREE_RCU && !PREEMPT_RCU && NO_HZ && SMP
 	default n
 	help
 	  This option causes RCU to attempt to accelerate grace periods
@@ -476,11 +471,11 @@ config RCU_FAST_NO_HZ
 	  Say N if you are unsure.
 
 config TREE_RCU_TRACE
-	def_bool RCU_TRACE && ( TREE_RCU || TREE_PREEMPT_RCU )
+	def_bool RCU_TRACE && TREE_RCU
 	select DEBUG_FS
 	help
-	  This option provides tracing for the TREE_RCU and
-	  TREE_PREEMPT_RCU implementations, permitting Makefile to
+	  This option provides tracing for the TREE_RCU
+	  implementation, permitting Makefile to
 	  trivially select kernel/rcutree_trace.c.
 
 config RCU_BOOST
diff --git a/kernel/Makefile b/kernel/Makefile
index 85cbfb3..0a8c381 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -83,10 +83,8 @@ obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_TREE_RCU) += rcutree.o
-obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
 obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
 obj-$(CONFIG_TINY_RCU) += rcutiny.o
-obj-$(CONFIG_TINY_PREEMPT_RCU) += rcutiny.o
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index f259c67..2ed22cf 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -56,7 +56,7 @@ int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
-#ifdef CONFIG_TINY_PREEMPT_RCU
+#ifdef CONFIG_PREEMPT_RCU
 
 #include <linux/delay.h>
 
@@ -209,7 +209,7 @@ static void rcu_initiate_boost_trace(void);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
 /*
- * Dump additional statistice for TINY_PREEMPT_RCU.
+ * Dump additional statistice for PREEMPT_RCU.
  */
 static void show_tiny_preempt_stats(struct seq_file *m)
 {
@@ -656,7 +656,7 @@ static void rcu_preempt_check_callbacks(void)
 }
 
 /*
- * TINY_PREEMPT_RCU has an extra callback-list tail pointer to
+ * PREEMPT_RCU has an extra callback-list tail pointer to
  * update, so this is invoked from rcu_process_callbacks() to
  * handle that case.  Of course, it is invoked for all flavors of
  * RCU, but RCU callbacks can appear only on one of the lists, and
@@ -849,7 +849,7 @@ void exit_rcu(void)
 	__rcu_read_unlock();
 }
 
-#else /* #ifdef CONFIG_TINY_PREEMPT_RCU */
+#else /* #ifdef CONFIG_PREEMPT_RCU */
 
 #ifdef CONFIG_RCU_TRACE
 
@@ -896,7 +896,7 @@ static void rcu_preempt_process_callbacks(void)
 {
 }
 
-#endif /* #else #ifdef CONFIG_TINY_PREEMPT_RCU */
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #include <linux/kernel_stat.h>
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 714b3ab..0030ad8 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -117,7 +117,7 @@ struct rcu_node {
 	unsigned long expmask;	/* Groups that have ->blkd_tasks */
 				/*  elements that need to drain to allow the */
 				/*  current expedited grace period to */
-				/*  complete (only for TREE_PREEMPT_RCU). */
+				/*  complete (only for PREEMPT_RCU). */
 	unsigned long wakemask; /* CPUs whose kthread needs to be awakened. */
 	unsigned long qsmaskinit;
 				/* Per-GP initial value for qsmask & expmask. */
@@ -404,10 +404,10 @@ DECLARE_PER_CPU(struct rcu_data, rcu_sched_data);
 extern struct rcu_state rcu_bh_state;
 DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
 
-#ifdef CONFIG_TREE_PREEMPT_RCU
+#ifdef CONFIG_PREEMPT_RCU
 extern struct rcu_state rcu_preempt_state;
 DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
 
 #ifndef RCU_TREE_NONCORE
 
@@ -433,9 +433,9 @@ static void rcu_preempt_offline_cpu(int cpu);
 static void rcu_preempt_check_callbacks(int cpu);
 static void rcu_preempt_process_callbacks(void);
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
-#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU)
+#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_PREEMPT_RCU)
 static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp);
-#endif /* #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU) */
+#endif /* #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_PREEMPT_RCU) */
 static int rcu_preempt_pending(int cpu);
 static int rcu_preempt_needs_cpu(int cpu);
 static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f629479..6841bcc 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -54,7 +54,7 @@ static void __init rcu_bootup_announce_oddness(void)
 #ifdef CONFIG_RCU_TORTURE_TEST_RUNNABLE
 	printk(KERN_INFO "\tRCU torture testing starts during boot.\n");
 #endif
-#if defined(CONFIG_TREE_PREEMPT_RCU) && !defined(CONFIG_RCU_CPU_STALL_VERBOSE)
+#if defined(CONFIG_PREEMPT_RCU) && !defined(CONFIG_RCU_CPU_STALL_VERBOSE)
 	printk(KERN_INFO "\tVerbose stalled-CPUs detection is disabled.\n");
 #endif
 #if NUM_RCU_LVL_4 != 0
@@ -62,7 +62,7 @@ static void __init rcu_bootup_announce_oddness(void)
 #endif
 }
 
-#ifdef CONFIG_TREE_PREEMPT_RCU
+#ifdef CONFIG_PREEMPT_RCU
 
 struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
@@ -861,7 +861,7 @@ void exit_rcu(void)
 	__rcu_read_unlock();
 }
 
-#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#else /* #ifdef CONFIG_PREEMPT_RCU */
 
 static struct rcu_state *rcu_state = &rcu_sched_state;
 
@@ -1067,7 +1067,7 @@ static void __init __rcu_init_preempt(void)
 {
 }
 
-#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
 
 #ifdef CONFIG_RCU_BOOST
 
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index f629dd4..c266880 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -101,10 +101,10 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 
 static int show_rcudata(struct seq_file *m, void *unused)
 {
-#ifdef CONFIG_TREE_PREEMPT_RCU
+#ifdef CONFIG_PREEMPT_RCU
 	seq_puts(m, "rcu_preempt:\n");
 	PRINT_RCU_DATA(rcu_preempt_data, print_one_rcu_data, m);
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
 	seq_puts(m, "rcu_sched:\n");
 	PRINT_RCU_DATA(rcu_sched_data, print_one_rcu_data, m);
 	seq_puts(m, "rcu_bh:\n");
@@ -166,10 +166,10 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_puts(m, "\"of\",\"ri\",\"ql\",\"b\",\"ci\",\"co\",\"ca\"\n");
-#ifdef CONFIG_TREE_PREEMPT_RCU
+#ifdef CONFIG_PREEMPT_RCU
 	seq_puts(m, "\"rcu_preempt:\"\n");
 	PRINT_RCU_DATA(rcu_preempt_data, print_one_rcu_data_csv, m);
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
 	seq_puts(m, "\"rcu_sched:\"\n");
 	PRINT_RCU_DATA(rcu_sched_data, print_one_rcu_data_csv, m);
 	seq_puts(m, "\"rcu_bh:\"\n");
@@ -288,10 +288,10 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 
 static int show_rcuhier(struct seq_file *m, void *unused)
 {
-#ifdef CONFIG_TREE_PREEMPT_RCU
+#ifdef CONFIG_PREEMPT_RCU
 	seq_puts(m, "rcu_preempt:\n");
 	print_one_rcu_state(m, &rcu_preempt_state);
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
 	seq_puts(m, "rcu_sched:\n");
 	print_one_rcu_state(m, &rcu_sched_state);
 	seq_puts(m, "rcu_bh:\n");
@@ -336,9 +336,9 @@ static void show_one_rcugp(struct seq_file *m, struct rcu_state *rsp)
 
 static int show_rcugp(struct seq_file *m, void *unused)
 {
-#ifdef CONFIG_TREE_PREEMPT_RCU
+#ifdef CONFIG_PREEMPT_RCU
 	show_one_rcugp(m, &rcu_preempt_state);
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
 	show_one_rcugp(m, &rcu_sched_state);
 	show_one_rcugp(m, &rcu_bh_state);
 	return 0;
@@ -389,10 +389,10 @@ static void print_rcu_pendings(struct seq_file *m, struct rcu_state *rsp)
 
 static int show_rcu_pending(struct seq_file *m, void *unused)
 {
-#ifdef CONFIG_TREE_PREEMPT_RCU
+#ifdef CONFIG_PREEMPT_RCU
 	seq_puts(m, "rcu_preempt:\n");
 	print_rcu_pendings(m, &rcu_preempt_state);
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
 	seq_puts(m, "rcu_sched:\n");
 	print_rcu_pendings(m, &rcu_sched_state);
 	seq_puts(m, "rcu_bh:\n");
