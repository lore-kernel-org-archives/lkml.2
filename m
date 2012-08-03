Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab2HCNml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:42:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab2HCNmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:42:40 -0400
Message-ID: <1344001354.17084.28.camel@marge.simpson.net>
Subject: [patch] sched: fix migration thread runtime bogosity
From: Mike Galbraith <mgalbraith@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 03 Aug 2012 15:42:34 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I have two bug reports of absurd migration thread CPU usage, one of them
with a link to a bisection..

     https://bugs.gentoo.org/show_bug.cgi?id=394487

..fingering d670ec13 - posix-cpu-timers: Cure SMP wobbles

I reproduced with my -rt kernel and 3.4, but didn't manage to reproduce
with the 3.0 NOPREEMPT kernel it was reported against.

Three options below, two tested in my -rt kernel.

A [ ] stop class doesn't do bean counting
B [ ] stop class counts beans like everybody else
C [ ] none of the above (not appended for brevity:)

I prefer B, elite class tasks eat beans.

A: sched: fix migration thread runtime bogosity

stop class threads don't do bean counting.  Wipe the evidence of their
lowly birth, and don't try to use exec_start which is never updated.

vogelweide:/:[0]# ps l 824
F   UID    PID   PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY        TIME COMMAND
1     0    824      2 -100  -      0     0 cpu_st S    ?        2799:06 [migration/57]

Signed-off-by: Mike Galbraith <efault@gmx.de>
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 82ad284..82a78a6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -974,6 +974,13 @@ void sched_set_stop_task(int cpu, struct task_struct *stop)
 		sched_setscheduler_nocheck(stop, SCHED_FIFO, &param);
 
 		stop->sched_class = &stop_sched_class;
+
+		/* Zero stale values for our non-accountable thread. */
+		stop->se.exec_start = 0;
+		stop->se.sum_exec_runtime = 0;
+		stop->se.prev_sum_exec_runtime = 0;
+		stop->stime = stop->stimescaled = 0;
+		stop->nvcsw = stop->nivcsw = 0;
 	}
 
 	cpu_rq(cpu)->stop = stop;
@@ -2803,7 +2810,8 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 	u64 ns = 0;
 
 	rq = task_rq_lock(p, &flags);
-	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
+	if (likely(p != rq->stop)
+		ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
 	task_rq_unlock(rq, p, &flags);
 
 	return ns;


B: sched: fix migration thread runtime bogosity

stop class threads need to do bean counting lest the below happen.

vogelweide:/:[0]# ps l 824
F   UID    PID   PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY        TIME COMMAND
1     0    824      2 -100  -      0     0 cpu_st S    ?        2799:06 [migration/57]

Signed-off-by: Mike Galbraith <efault@gmx.de>

diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index 7b386e8..da5eb5b 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -27,8 +27,10 @@ static struct task_struct *pick_next_task_stop(struct rq *rq)
 {
 	struct task_struct *stop = rq->stop;
 
-	if (stop && stop->on_rq)
+	if (stop && stop->on_rq) {
+		stop->se.exec_start = rq->clock_task;
 		return stop;
+	}
 
 	return NULL;
 }
@@ -52,6 +54,21 @@ static void yield_task_stop(struct rq *rq)
 
 static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
 {
+	struct task_struct *curr = rq->curr;
+	u64 delta_exec;
+
+	delta_exec = rq->clock_task - curr->se.exec_start;
+	if (unlikely((s64)delta_exec < 0))
+		delta_exec = 0;
+
+	schedstat_set(curr->se.statistics.exec_max,
+			max(curr->se.statistics.exec_max, delta_exec));
+
+	curr->se.sum_exec_runtime += delta_exec;
+	account_group_exec_runtime(curr, delta_exec);
+
+	curr->se.exec_start = rq->clock_task;
+	cpuacct_charge(curr, delta_exec);
 }
 
 static void task_tick_stop(struct rq *rq, struct task_struct *curr, int queued)
@@ -60,6 +77,9 @@ static void task_tick_stop(struct rq *rq, struct task_struct *curr, int queued)
 
 static void set_curr_task_stop(struct rq *rq)
 {
+	struct task_struct *stop = rq->stop;
+
+	stop->se.exec_start = rq->clock_task;
 }
 
 static void switched_to_stop(struct rq *rq, struct task_struct *p)


