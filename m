Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab0KUEWa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 23:22:30 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36510 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab0KUEW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 23:22:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=p1ozsCXZ+OP7dVKWl/W7+Es/0vqzZsvfFQegt0Y+XimUNyQd8QPfKXEYBbh+vJkaO1
         iH0RjgEFv1bPKdKcRoGfrUpJSE2I30EHOe5rMuJI4CGJ1XOODrRdM6Px617omCY3dZPm
         1+21aGkqmpvkV3mNEhzkrUz+TjHv9IZeJHV/I=
Date: Sat, 20 Nov 2010 23:22:24 -0500 (EST)
From: "Bjoern B. Brandenburg" <bbb.lst@gmail.com>
X-X-Sender: bbb@jupiter-cs.cs.unc.edu
To: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>
cc: Andrea Bastoni <bastoni@sprg.uniroma2.it>,
        "James H. Anderson" <anderson@cs.unc.edu>,
        linux-kernel@vger.kernel.org
Subject: Scheduler bug related to rq->skip_clock_update?
Message-ID: <alpine.LNX.2.00.1011202315290.8927@jupiter-cs.cs.unc.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Peter, hi Mike, hi Ingo,

we have observed some strangeness regarding the runqueue clock updates when
porting the LITMUS^RT patches (http://www.cs.unc.edu/~anderson/litmus-rt)
from .34 to .36. Specifically, it seems that the flag rq->skip_clock_update
remains set for prolonged times in some circumstances. Not updating the
runqueue clock while a task is scheduled obviously causes the scheduler to
make badly misguided decisions.

I was also able to reproduce this on the latest pre-.37 _without_ LITMUS^RT
patches (see below), so I don't think that the problem was introduced by us.
First, here's a debug trace that illustrates the problem. (The trace is from
LITMUS^RT applied to .36 on a four-CPU host with copious amounts of extra
debug info. The first number in the trace is a sequence number and can be
ignored.)

> 613953 P3: SCHED_STATE [P3] 0x1 (TASK_SCHEDULED) -> 0x4 (WILL_SCHEDULE)
> 613954 P3: (kworker/u:0/5) clear_tsk_need_resched

The workload consisted of tmux, a couple of top instances, and compiling a
library (liblitmus). On CPU 3, kworker invoked schedule() because it blocks.
Its TIF_NEED_RESCHED is cleared. The idle load balancer is activated because
kworker blocks and there is nothing else pending.

> 613955 P3: (kworker/u:0/5) XXXX calling resched_task() during schedule()
> from ret:0xc0045400 [rt:0 nr_running:1]
> 613957 P3: (kworker/u:0/5) set_tsk_need_resched() ret:c004495c task_cpu:3

The idle load balancer marked kworker with set_tsk_need_resched(), even
though kworker was on its way out anyway. CPU 3 continues to schedule and
picks 'ld'. So far so good.

> 613960 P3: SCHED_STATE [P3] 0x4 (WILL_SCHEDULE) -> 0x8 (TASK_PICKED)
> 613961 P3: SCHED_STATE [P3] 0x8 (TASK_PICKED) -> 0x1 (TASK_SCHEDULED)
> 613962 P3: SCHED_STATE [P3] 0x1 (TASK_SCHEDULED) -> 0x4 (WILL_SCHEDULE)
> 613963 P3: (ld/1107) set_tsk_need_resched() ret:c004495c task_cpu:3
> 613964 P3: SCHED_STATE [P3] 0x4 (WILL_SCHEDULE) -> 0x4 (WILL_SCHEDULE)
> 613965 P3: (ld/1107) clear_tsk_need_resched
> 613966 P3: SCHED_STATE [P3] 0x4 (WILL_SCHEDULE) -> 0x8 (TASK_PICKED)
> 613967 P3: SCHED_STATE [P3] 0x8 (TASK_PICKED) -> 0x1 (TASK_SCHEDULED)
> 613968 P3: SCHED_STATE [P3] 0x1 (TASK_SCHEDULED) -> 0x4 (WILL_SCHEDULE)
> 613969 P3: (kworker/3:1/411) clear_tsk_need_resched
> 613970 P3: SCHED_STATE [P3] 0x4 (WILL_SCHEDULE) -> 0x8 (TASK_PICKED)
> 613971 P3: SCHED_STATE [P3] 0x8 (TASK_PICKED) -> 0x1 (TASK_SCHEDULED)

Some time passed and CPU 3 was active servicing ld and a different kworker.
Now something bad happens.

> 613972 P0: (kworker/u:0/5) already need_resched when resuming
> 613973 P0: (kworker/u:0/5) rq->skip_clock_update <- 1 (flags=0; cpu=3;
> is-cur?=0)

The kworker that was marked with set_tsk_need_resched() resumes on CPU 0.
Because the flag was already set, check_preempt_curr() sets
rq->skip_clock_update() *on CPU 3*.

CPU 3 never knows that anything happened and continues to schedule its
currently assigned task (ld). Because skip_clock_update is set, the reference
time for the scheduler does not advance anymore. Hence ld seems to be
consuming no execution time and CFS schedules it until it blocks by itself
(or until a SCHED_FIFO or SCHED_RT task becomes active).

The scheduler tick on P3 reports for some time after that nothing changes.

> 613974 P3: (ld/1107) rq->skip_clock_update [CFS] =>
> sum_exec_runtime=569265250  delta=0
> 613975 P3: (ld/1107) rq->skip_clock_update [CFS] =>
> sum_exec_runtime=569265250  delta=0
> 613976 P3: (ld/1107) rq->skip_clock_update [CFS] =>
> sum_exec_runtime=569265250  delta=0
> 613977 P3: (ld/1107) rq->skip_clock_update [CFS] =>
> sum_exec_runtime=569265250  delta=0
> 613992 P3: (ld/1107) rq->skip_clock_update [CFS] =>
> sum_exec_runtime=569265250  delta=0
> 613993 P3: (ld/1107) rq->skip_clock_update [CFS] =>
> sum_exec_runtime=569265250  delta=0
> 613994 P3: (ld/1107) rq->skip_clock_update [CFS] =>
> sum_exec_runtime=569265250  delta=0
> 614002 P3: (ld/1107) rq->skip_clock_update [CFS] =>
> sum_exec_runtime=569265250  delta=0
> 614005 P2: (ld/1107) rq->skip_clock_update [CFS] =>
> sum_exec_runtime=569265250  delta=0
> 614025 P3: (ld/1107) rq->skip_clock_update [CFS] =>
> sum_exec_runtime=569265250  delta=0
> 614080 P3: (ld/1107) rq->skip_clock_update [CFS] =>
> sum_exec_runtime=569265250  delta=0
> 614117 P3: (ld/1107) rq->skip_clock_update [CFS] =>
> sum_exec_runtime=569265250  delta=0
> 614146 P3: (ld/1107) rq->skip_clock_update [CFS] =>
> sum_exec_runtime=569265250  delta=0
> 614186 P3: (ld/1107) rq->skip_clock_update [CFS] =>
> sum_exec_runtime=569265250  delta=0
> 614233 P3: (ld/1107) rq->skip_clock_update [CFS] =>
> sum_exec_runtime=569265250  delta=0
> 614235 P3: (ld/1107) rq->skip_clock_update [CFS] =>
> sum_exec_runtime=569265250  delta=0

And so on...

This seems very wrong and it causes massive problems for LITMUS^RT. As a
workaround, never setting skip_clock_update in check_preempt_curr() gets rid
of all symptoms.

I was under the impression that, as an invariant, tasks should not have
TIF_NEED_RESCHED set after they've blocked. In this case, the idle load
balancer should not mark the task that's on its way out with
set_tsk_need_resched().

In any case, check_preempt_curr() seems to assume that a resuming task cannot
have TIF_NEED_RESCHED already set. Setting skip_clock_update on a remote CPU
that hasn't even been notified via IPI seems wrong.

Since AFAIK printk() can't be called while holding a runqueue lock, I am not
sure what the best way is to reproduce a trace like the above on a vanilla
kernel. As a first approximation, the patch below simply tracks how much time
passes between setting and clearing skip_clock_update.

With the patch applied on top of b86db4744230c94e480de56f1b7f31117edbf193
(the current master), I got the following numbers on a four-CPU ARM11 MPCore.

> bbb@district10:/proc$ egrep 'cpu#|skip' /proc/sched_debug
> cpu#0
>   .skip_clock_max                : 139310500
> cpu#1
>   .skip_clock_max                : 1831250
> cpu#2
>   .skip_clock_max                : 1112750
> cpu#3
>   .skip_clock_max                : 1243375

On CPU 0, the flag was set at some point for over 139 milliseconds! Even on
CPU 2, the flag was set for over one millisecond.

I believe this shows that the problem persists in the latest kernel and that
it is not LITMUS^RT-related. It seems the load balancer should not mark the
currently-scheduled task with set_tsk_need_resched() when invoked from within
schedule().

Comments? Advice?

Thanks,
Bjoern

---
diff --git a/kernel/sched.c b/kernel/sched.c
index dc91a4d..ccc88cc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -541,6 +541,9 @@ struct rq {
 	unsigned long long rq_cpu_time;
 	/* could above be rq->cfs_rq.exec_clock + rq->rt_rq.rt_runtime ? */

+	u64 skip_clock_max;
+	u64 skip_clock_set;
+
 	/* sys_sched_yield() stats */
 	unsigned int yld_count;

@@ -2129,8 +2132,11 @@ static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 	 * A queue event has occurred, and we're going to schedule.  In
 	 * this case, we can save a useless back to back clock update.
 	 */
-	if (test_tsk_need_resched(rq->curr))
+	if (test_tsk_need_resched(rq->curr)) {
+		schedstat_set(rq->skip_clock_set,
+			      sched_clock_cpu(cpu_of(rq)));
 		rq->skip_clock_update = 1;
+	}
 }

 #ifdef CONFIG_SMP
@@ -3845,7 +3851,12 @@ static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
 	if (prev->se.on_rq)
 		update_rq_clock(rq);
-	rq->skip_clock_update = 0;
+	if (unlikely(rq->skip_clock_update)) {
+		schedstat_set(rq->skip_clock_max,
+			      max(rq->skip_clock_max,
+				  sched_clock_cpu(cpu_of(rq)) - rq->skip_clock_set));
+		rq->skip_clock_update = 0;
+	}
 	prev->sched_class->put_prev_task(rq, prev);
 }

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 2e1b0d1..63ce99d 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -298,6 +298,8 @@ static void print_cpu(struct seq_file *m, int cpu)

 	P(bkl_count);

+	P64(skip_clock_max);
+
 #undef P
 #endif
 	print_cfs_stats(m, cpu);
