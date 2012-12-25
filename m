Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab2LYIU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 03:20:59 -0500
Received: from forward12.mail.yandex.net ([95.108.130.94]:48432 "EHLO
	forward12.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab2LYIU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 03:20:56 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH] sched/rt: Don't pull tasks of throttled rt_rq in pre_schedule_rt() 
MIME-Version: 1.0
Message-Id: <1286111356423652@web16f.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 25 Dec 2012 12:20:52 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch aims not to pull tasks of throttled rt_rqs
in pre_schedule_rt() because thay are not able to be
picked in pick_next_task_rt().

There are three places where pull_rt_task() is used:

1)pre_schedule_rt()
If we pull a task of a throttled rt_rq it won't be picked
by pick_next_task_rt(), because throttled tasks are dequeued
by sched_rt_runtime_exceeded(). So this action is unnecessary.

2)prio_changed_rt()
A pulled task of higher priority leads to reschedule of current
rq's task. The schedule() will occur with the first hw interrupt
so there is possibility the throttled rt_rq will unthrottle and
it will be queued during this time.
(In case of preemptable kernel schedule() occurs during
preempt_enable() in call of __task_rq_unlock(). But its lock is
unlocked so there is no guarantee the rt_rq won't be queued).

3)switched_from_rt()
The same as prio_changed_rt().

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: linux-rt-users
---
 kernel/sched/rt.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 418feb0..567908a 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1708,7 +1708,17 @@ static void push_rt_tasks(struct rq *rq)
 		;
 }
 
-static int pull_rt_task(struct rq *this_rq)
+static inline int remote_rt_rq_throttled(struct task_struct *p, int remote_cpu)
+{
+	struct rt_rq *rt_rq = rt_rq_of_se(&p->rt);
+	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+
+	rt_rq = sched_rt_period_rt_rq(rt_b, remote_cpu);
+
+	return rt_rq_throttled(rt_rq);
+}
+
+static int pull_rt_task(struct rq *this_rq, bool unthrottled)
 {
 	int this_cpu = this_rq->cpu, ret = 0, cpu;
 	struct task_struct *p;
@@ -1768,6 +1778,9 @@ static int pull_rt_task(struct rq *this_rq)
 			if (p->prio < src_rq->curr->prio)
 				goto skip;
 
+			if (unthrottled && remote_rt_rq_throttled(p, this_cpu))
+				goto skip;
+
 			ret = 1;
 
 			deactivate_task(src_rq, p, 0);
@@ -1791,7 +1804,7 @@ static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 {
 	/* Try to pull RT tasks here if we lower this rq's prio */
 	if (rq->rt.highest_prio.curr > prev->prio)
-		pull_rt_task(rq);
+		pull_rt_task(rq, true);
 }
 
 static void post_schedule_rt(struct rq *rq)
@@ -1890,7 +1903,7 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
 	 * now.
 	 */
 	if (p->on_rq && !rq->rt.rt_nr_running)
-		pull_rt_task(rq);
+		pull_rt_task(rq, false);
 }
 
 void init_sched_rt_class(void)
@@ -1949,7 +1962,7 @@ prio_changed_rt(struct rq *rq, struct task_struct *p, int oldprio)
 		 * may need to pull tasks to this runqueue.
 		 */
 		if (oldprio < p->prio)
-			pull_rt_task(rq);
+			pull_rt_task(rq, false);
 		/*
 		 * If there's a higher priority task waiting to run
 		 * then reschedule. Note, the above pull_rt_task
