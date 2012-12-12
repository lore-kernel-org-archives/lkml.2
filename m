Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab2LLTk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 14:40:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22352 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab2LLTjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 14:39:22 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=IwJWyEIs8VYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VVcu60EqAswA:10 a=ayC55rCoAAAA:8 a=xN6QLzKF1QGGklgj5-EA:9 a=E6k37eg1NvgA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121212193920.803917953@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 12 Dec 2012 14:27:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Mike Galbraith <bitbucket@online.de>
Subject: [RFC][PATCH RT 4/4 v2] sched/rt: Use IPI to trigger RT task push migration instead of pulling
References: <20121212192733.221810086@goodmis.org>
Content-Disposition: inline; filename=push-rt-task-ipi-v2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When debugging the latencies on a 40 core box, where we hit 300 to
500 microsecond latencies, I found there was a huge contention on the
runqueue locks.

Investigating it further, running ftrace, I found that it was due to
the pulling of RT tasks.

The test that was run was the following:

 cyclictest --numa -p95 -m -d0 -i100

This created a thread on each CPU, that would set its wakeup in interations
of 100 microseconds. The -d0 means that all the threads had the same
interval (100us). Each thread sleeps for 100us and wakes up and measures
its latencies.

What happened was another RT task would be scheduled on one of the CPUs
that was running our test, when the other CPUS test went to sleep and
scheduled idle. This cause the "pull" operation to execute on all
these CPUs. Each one of these saw the RT task that was overloaded on
the CPU of the test that was still running, and each one tried
to grab that task in a thundering herd way.

To grab the task, each thread would do a double rq lock grab, grabbing
its own lock as well as the rq of the overloaded CPU. As the sched
domains on this box was rather flat for its size, I saw up to 12 CPUs
block on this lock at once. This caused a ripple affect with the
rq locks. As these locks were blocked, any wakeups or load balanceing
on these CPUs would also block on these locks, and the wait time escalated.

I've tried various methods to lesson the load, but things like an
atomic counter to only let one CPU grab the task wont work, because
the task may have a limited affinity, and we may pick the wrong
CPU to take that lock and do the pull, to only find out that the
CPU we picked isn't in the task's affinity.

Instead of doing the PULL, I now have the CPUs that want the pull to
send over an IPI to the overloaded CPU, and let that CPU pick what
CPU to push the task to. No more need to grab the rq lock, and the
push/pull algorithm still works fine.

With this patch, the latency dropped to just 150us over a 20 hour run.
Without the patch, the huge latencies would trigger in seconds.

Now, this issue only seems to apply to boxes with greater than 16 CPUs.
We noticed this on a 24 CPU box, and things got much worse on 40 (and
presumably more CPUs would get even worse yet). But running with 16
CPUs and below, the lock contention caused by the pulling of RT tasks
is not noticable.

I've created a new sched feature called RT_PUSH_IPI, which by default
on 16 and less core CPUs is disabled, and on 17 or more CPUs it is
enabled. That seems to be heuristic limit where the pulling logic
causes higher latencies than IPIs. Of course with all heuristics, things
could be different with different architectures.

When RT_PUSH_IPI is not enabled, the old method of grabbing the rq locks
and having the pulling CPU do the work is implemented. When RT_PUSH_IPI
is enabled, the IPI is sent to the overloaded CPU to do a push.

To enabled or disable this at run time:

 # mount -t debugfs nodev /sys/kernel/debug
 # echo RT_PUSH_IPI > /sys/kernel/debug/sched_features
or
 # echo NO_RT_PUSH_IPI > /sys/kernel/debug/sched_features

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/kernel/sched/core.c
===================================================================
--- linux-rt.git.orig/kernel/sched/core.c
+++ linux-rt.git/kernel/sched/core.c
@@ -1538,6 +1538,9 @@ static void sched_ttwu_pending(void)
 
 void scheduler_ipi(void)
 {
+	if (sched_feat(RT_PULL_IPI))
+		sched_rt_push_check();
+
 	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick())
 		return;
 
@@ -7533,6 +7536,19 @@ void __init sched_init_smp(void)
 	free_cpumask_var(non_isolated_cpus);
 
 	init_sched_rt_class();
+
+	/*
+	 * To avoid heavy contention on large CPU boxes,
+	 * when there is an RT overloaded CPU (two or more RT tasks
+	 * queued to run on a CPU and one of the waiting RT tasks
+	 * can migrate) and another CPU lowers its priority, instead
+	 * of grabbing both rq locks of the CPUS (as many CPUs lowering
+	 * their priority at the same time may create large latencies)
+	 * send an IPI to the CPU that is overloaded so that it can
+	 * do an efficent push.
+	 */
+	if (num_possible_cpus() > 16)
+		sched_feat_enable(__SCHED_FEAT_RT_PUSH_IPI);
 }
 #else
 void __init sched_init_smp(void)
Index: linux-rt.git/kernel/sched/rt.c
===================================================================
--- linux-rt.git.orig/kernel/sched/rt.c
+++ linux-rt.git/kernel/sched/rt.c
@@ -1729,6 +1729,31 @@ static void push_rt_tasks(struct rq *rq)
 		;
 }
 
+/**
+ * sched_rt_push_check - check if we can push waiting RT tasks
+ *
+ * Called from sched IPI when sched feature RT_PUSH_IPI is enabled.
+ *
+ * Checks if there is an RT task that can migrate and there exists
+ * a CPU in its affinity that only has tasks lower in priority than
+ * the waiting RT task. If so, then it will push the task off to that
+ * CPU.
+ */
+void sched_rt_push_check(void)
+{
+	struct rq *rq = cpu_rq(smp_processor_id());
+
+	if (WARN_ON_ONCE(!irqs_disabled()))
+		return;
+
+	if (!has_pushable_tasks(rq))
+		return;
+
+	raw_spin_lock(&rq->lock);
+	push_rt_tasks(rq);
+	raw_spin_unlock(&rq->lock);
+}
+
 static int pull_rt_task(struct rq *this_rq)
 {
 	int this_cpu = this_rq->cpu, ret = 0, cpu;
@@ -1756,6 +1781,18 @@ static int pull_rt_task(struct rq *this_
 			continue;
 
 		/*
+		 * When the RT_PUSH_IPI sched feature is enabled, instead
+		 * of trying to grab the rq lock of the RT overloaded CPU
+		 * send an IPI to that CPU instead. This prevents heavy
+		 * contention from several CPUs lowering its priority
+		 * and all trying to grab the rq lock of that overloaded CPU.
+		 */
+		if (sched_feat(RT_PUSH_IPI)) {
+			smp_send_reschedule(cpu);
+			continue;
+		}
+
+		/*
 		 * We can potentially drop this_rq's lock in
 		 * double_lock_balance, and another CPU could
 		 * alter this_rq
Index: linux-rt.git/kernel/sched/sched.h
===================================================================
--- linux-rt.git.orig/kernel/sched/sched.h
+++ linux-rt.git/kernel/sched/sched.h
@@ -1111,6 +1111,8 @@ static inline void double_rq_unlock(stru
 		__release(rq2->lock);
 }
 
+void sched_rt_push_check(void);
+
 #else /* CONFIG_SMP */
 
 /*
@@ -1144,6 +1146,9 @@ static inline void double_rq_unlock(stru
 	__release(rq2->lock);
 }
 
+void sched_rt_push_check(void)
+{
+}
 #endif
 
 extern struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq);
Index: linux-rt.git/kernel/sched/features.h
===================================================================
--- linux-rt.git.orig/kernel/sched/features.h
+++ linux-rt.git/kernel/sched/features.h
@@ -73,6 +73,20 @@ SCHED_FEAT(PREEMPT_LAZY, true)
 # endif
 #endif
 
+/*
+ * In order to avoid a thundering herd attack of CPUS that are
+ * lowering their priorities at the same time, and there being
+ * a single CPU that has an RT task that can migrate and is waiting
+ * to run, where the other CPUs will try to take that CPUs
+ * rq lock and possibly create a large contention, sending an
+ * IPI to that CPU and let that CPU push the RT task to where
+ * it should go may be a better scenario.
+ *
+ * This is default off for machines with <= 16 CPUs, and will
+ * be turned on at boot up for machines with > 16 CPUs.
+ */
+SCHED_FEAT(RT_PUSH_IPI, false)
+
 SCHED_FEAT(FORCE_SD_OVERLAP, false)
 SCHED_FEAT(RT_RUNTIME_SHARE, true)
 SCHED_FEAT(LB_MIN, false)

