Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab2LHAJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:09:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16510 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604Ab2LHAJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:09:03 -0500
X-Authority-Analysis: v=2.0 cv=f9bK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=bZ_1bJVlv5MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=A26604eL-yUA:10 a=av0n04IhM7bAGgoq17UA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121208000900.613917378@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 07 Dec 2012 18:56:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC][PATCH RT 3/4] sched/rt: Use IPI to trigger RT task push migration instead of pulling
References: <20121207235615.206108556@goodmis.org>
Content-Disposition: inline; filename=push-rt-task-ipi.patch
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
rq locks. As these locks were blocked, any wakeups on these CPUs
would also block on these locks, and the wait time escalated.

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

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/kernel/sched/core.c
===================================================================
--- linux-rt.git.orig/kernel/sched/core.c
+++ linux-rt.git/kernel/sched/core.c
@@ -1538,6 +1538,8 @@ static void sched_ttwu_pending(void)
 
 void scheduler_ipi(void)
 {
+	sched_rt_push_check();
+
 	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick())
 		return;
 
Index: linux-rt.git/kernel/sched/rt.c
===================================================================
--- linux-rt.git.orig/kernel/sched/rt.c
+++ linux-rt.git/kernel/sched/rt.c
@@ -1425,53 +1425,6 @@ static void put_prev_task_rt(struct rq *
 /* Only try algorithms three times */
 #define RT_MAX_TRIES 3
 
-static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
-{
-	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpumask_test_cpu(cpu, tsk_cpus_allowed(p))) &&
-	    (p->nr_cpus_allowed > 1))
-		return 1;
-	return 0;
-}
-
-/* Return the second highest RT task, NULL otherwise */
-static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
-{
-	struct task_struct *next = NULL;
-	struct sched_rt_entity *rt_se;
-	struct rt_prio_array *array;
-	struct rt_rq *rt_rq;
-	int idx;
-
-	for_each_leaf_rt_rq(rt_rq, rq) {
-		array = &rt_rq->active;
-		idx = sched_find_first_bit(array->bitmap);
-next_idx:
-		if (idx >= MAX_RT_PRIO)
-			continue;
-		if (next && next->prio <= idx)
-			continue;
-		list_for_each_entry(rt_se, array->queue + idx, run_list) {
-			struct task_struct *p;
-
-			if (!rt_entity_is_task(rt_se))
-				continue;
-
-			p = rt_task_of(rt_se);
-			if (pick_rt_task(rq, p, cpu)) {
-				next = p;
-				break;
-			}
-		}
-		if (!next) {
-			idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
-			goto next_idx;
-		}
-	}
-
-	return next;
-}
-
 static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
 
 static int find_lowest_rq(struct task_struct *task)
@@ -1723,10 +1676,24 @@ static void push_rt_tasks(struct rq *rq)
 		;
 }
 
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
-	struct task_struct *p;
 	struct rq *src_rq;
 
 	if (likely(!rt_overloaded(this_rq)))
@@ -1749,54 +1716,7 @@ static int pull_rt_task(struct rq *this_
 		    this_rq->rt.highest_prio.curr)
 			continue;
 
-		/*
-		 * We can potentially drop this_rq's lock in
-		 * double_lock_balance, and another CPU could
-		 * alter this_rq
-		 */
-		double_lock_balance(this_rq, src_rq);
-
-		/*
-		 * Are there still pullable RT tasks?
-		 */
-		if (src_rq->rt.rt_nr_running <= 1)
-			goto skip;
-
-		p = pick_next_highest_task_rt(src_rq, this_cpu);
-
-		/*
-		 * Do we have an RT task that preempts
-		 * the to-be-scheduled task?
-		 */
-		if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
-			WARN_ON(p == src_rq->curr);
-			WARN_ON(!p->on_rq);
-
-			/*
-			 * There's a chance that p is higher in priority
-			 * than what's currently running on its cpu.
-			 * This is just that p is wakeing up and hasn't
-			 * had a chance to schedule. We only pull
-			 * p if it is lower in priority than the
-			 * current task on the run queue
-			 */
-			if (p->prio < src_rq->curr->prio)
-				goto skip;
-
-			ret = 1;
-
-			deactivate_task(src_rq, p, 0);
-			set_task_cpu(p, this_cpu);
-			activate_task(this_rq, p, 0);
-			/*
-			 * We continue with the search, just in
-			 * case there's an even higher prio task
-			 * in another runqueue. (low likelihood
-			 * but possible)
-			 */
-		}
-skip:
-		double_unlock_balance(this_rq, src_rq);
+		smp_send_reschedule(cpu);
 	}
 
 	return ret;
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

