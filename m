Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab1DVRTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 13:19:13 -0400
Received: from tex.lwn.net ([70.33.254.29]:46553 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090Ab1DVRTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 13:19:12 -0400
Date: Fri, 22 Apr 2011 11:19:10 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Neil Brown <neilb@suse.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] sched: get rid of lock_depth
Message-ID: <20110422111910.456c0e84@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown pointed out that lock_depth somehow escaped the BKL removal
work.  Let's get rid of it now.

Note that the perf scripting utilities still have a bunch of code for
dealing with common_lock_depth in tracepoints; I have left that in place in
case anybody wants to use that code with older kernels.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/trace/kprobetrace.txt             |    1 -
 include/linux/init_task.h                       |    1 -
 include/linux/sched.h                           |    6 ------
 kernel/fork.c                                   |    1 -
 kernel/mutex.c                                  |    7 -------
 kernel/sched.c                                  |   11 +----------
 kernel/sched_debug.c                            |    4 ----
 kernel/trace/trace_kprobe.c                     |    1 -
 tools/perf/Documentation/perf-script-perl.txt   |    1 -
 tools/perf/Documentation/perf-script-python.txt |    1 -
 10 files changed, 1 insertions(+), 33 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 6d27ab8..c83bd6b 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -120,7 +120,6 @@ format:
         field:unsigned char common_flags;       offset:2;       size:1; signed:0;
         field:unsigned char common_preempt_count;       offset:3; size:1;signed:0;
         field:int common_pid;   offset:4;       size:4; signed:1;
-        field:int common_lock_depth;    offset:8;       size:4; signed:1;
 
         field:unsigned long __probe_ip; offset:12;      size:4; signed:0;
         field:int __probe_nargs;        offset:16;      size:4; signed:1;
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index caa151f..689496b 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -134,7 +134,6 @@ extern struct cred init_cred;
 	.stack		= &init_thread_info,				\
 	.usage		= ATOMIC_INIT(2),				\
 	.flags		= PF_KTHREAD,					\
-	.lock_depth	= -1,						\
 	.prio		= MAX_PRIO-20,					\
 	.static_prio	= MAX_PRIO-20,					\
 	.normal_prio	= MAX_PRIO-20,					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 18d63ce..006c31f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -731,10 +731,6 @@ struct sched_info {
 	/* timestamps */
 	unsigned long long last_arrival,/* when we last ran on a cpu */
 			   last_queued;	/* when we were last queued to run */
-#ifdef CONFIG_SCHEDSTATS
-	/* BKL stats */
-	unsigned int bkl_count;
-#endif
 };
 #endif /* defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT) */
 
@@ -1197,8 +1193,6 @@ struct task_struct {
 	unsigned int flags;	/* per process flags, defined below */
 	unsigned int ptrace;
 
-	int lock_depth;		/* BKL lock depth */
-
 #ifdef CONFIG_SMP
 #ifdef __ARCH_WANT_UNLOCKED_CTXSW
 	int oncpu;
diff --git a/kernel/fork.c b/kernel/fork.c
index e7548de..aca6287 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1103,7 +1103,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	posix_cpu_timers_init(p);
 
-	p->lock_depth = -1;		/* -1 = no lock */
 	do_posix_clock_monotonic_gettime(&p->start_time);
 	p->real_start_time = p->start_time;
 	monotonic_to_bootbased(&p->real_start_time);
diff --git a/kernel/mutex.c b/kernel/mutex.c
index c4195fa..62d0a06 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -163,13 +163,6 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		struct thread_info *owner;
 
 		/*
-		 * If we own the BKL, then don't spin. The owner of
-		 * the mutex might be waiting on us to release the BKL.
-		 */
-		if (unlikely(current->lock_depth >= 0))
-			break;
-
-		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
 		 */
diff --git a/kernel/sched.c b/kernel/sched.c
index 312f8b9..f70b2cc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4025,12 +4025,6 @@ static inline void schedule_debug(struct task_struct *prev)
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
 
 	schedstat_inc(this_rq(), sched_count);
-#ifdef CONFIG_SCHEDSTATS
-	if (unlikely(prev->lock_depth >= 0)) {
-		schedstat_inc(this_rq(), rq_sched_info.bkl_count);
-		schedstat_inc(prev, sched_info.bkl_count);
-	}
-#endif
 }
 
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
@@ -5782,11 +5776,8 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
 	/* Set the preempt count _outside_ the spinlocks! */
-#if defined(CONFIG_PREEMPT)
-	task_thread_info(idle)->preempt_count = (idle->lock_depth >= 0);
-#else
 	task_thread_info(idle)->preempt_count = 0;
-#endif
+
 	/*
 	 * The idle tasks have their own, simple scheduling class:
 	 */
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 7bacd83..a8869a2 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -296,9 +296,6 @@ static void print_cpu(struct seq_file *m, int cpu)
 	P(ttwu_count);
 	P(ttwu_local);
 
-	SEQ_printf(m, "  .%-30s: %d\n", "bkl_count",
-				rq->rq_sched_info.bkl_count);
-
 #undef P
 #undef P64
 #endif
@@ -441,7 +438,6 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	P(se.statistics.wait_count);
 	PN(se.statistics.iowait_sum);
 	P(se.statistics.iowait_count);
-	P(sched_info.bkl_count);
 	P(se.nr_migrations);
 	P(se.statistics.nr_migrations_cold);
 	P(se.statistics.nr_failed_migrations_affine);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 35d55a3..f925c45 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -53,7 +53,6 @@ const char *reserved_field_names[] = {
 	"common_preempt_count",
 	"common_pid",
 	"common_tgid",
-	"common_lock_depth",
 	FIELD_STRING_IP,
 	FIELD_STRING_RETIP,
 	FIELD_STRING_FUNC,
diff --git a/tools/perf/Documentation/perf-script-perl.txt b/tools/perf/Documentation/perf-script-perl.txt
index 5bb41e5..3152cca 100644
--- a/tools/perf/Documentation/perf-script-perl.txt
+++ b/tools/perf/Documentation/perf-script-perl.txt
@@ -63,7 +63,6 @@ The format file for the sched_wakep event defines the following fields
         field:unsigned char common_flags;
         field:unsigned char common_preempt_count;
         field:int common_pid;
-        field:int common_lock_depth;
 
         field:char comm[TASK_COMM_LEN];
         field:pid_t pid;
diff --git a/tools/perf/Documentation/perf-script-python.txt b/tools/perf/Documentation/perf-script-python.txt
index 36b3827..4710220 100644
--- a/tools/perf/Documentation/perf-script-python.txt
+++ b/tools/perf/Documentation/perf-script-python.txt
@@ -463,7 +463,6 @@ The format file for the sched_wakep event defines the following fields
         field:unsigned char common_flags;
         field:unsigned char common_preempt_count;
         field:int common_pid;
-        field:int common_lock_depth;
 
         field:char comm[TASK_COMM_LEN];
         field:pid_t pid;
-- 
1.7.4.4

