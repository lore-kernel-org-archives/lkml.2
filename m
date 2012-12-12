Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab2LLAs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 19:48:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab2LLAsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 19:48:22 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=TPn1MY1Xr0MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=8kzRziY1_1cA:10 a=VwQbUJbxAAAA:8 a=EdPcmqpiAjOiNmVFGQgA:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121212004820.598190405@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 11 Dec 2012 19:45:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, <stable@vger.kernel.org>,
        <stable-rt@vger.kernel.org>
Subject: [PATCH RT 1/2] sched: Queue RT tasks to head when prio drops
References: <20121212004557.110050982@goodmis.org>
Content-Disposition: inline; filename=0001-sched-Queue-RT-tasks-to-head-when-prio-drops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The following scenario does not work correctly:

Runqueue of CPU1 contains two runnable and pinned tasks:
	 T1: SCHED_FIFO, prio 80
	 T2: SCHED_FIFO, prio 80

T1 is on the cpu and executes the following syscalls (classic priority
ceiling scenario):

 sys_sched_setscheduler(pid(T1), SCHED_FIFO, .prio = 90);
 ...
 sys_sched_setscheduler(pid(T1), SCHED_FIFO, .prio = 80);
 ...

Now T1 gets preempted by T3 (SCHED_FIFO, prio 95). After T3 goes back
to sleep the scheduler picks T2. Surprise!

The same happens w/o actual preemption when T1 is forced into the
scheduler due to a sporadic NEED_RESCHED event. The scheduler invokes
pick_next_task() which returns T2. So T1 gets preempted and scheduled
out.

This happens because sched_setscheduler() dequeues T1 from the prio 90
list and then enqueues it on the tail of the prio 80 list behind T2.
This violates the POSIX spec and surprises user space which relies on
the guarantee that SCHED_FIFO tasks are not scheduled out unless they
give the CPU up voluntarily or are preempted by a higher priority
task. In the latter case the preempted task must get back on the CPU
after the preempting task schedules out again.

We fixed a similar issue already in commit 60db48c(sched: Queue a
deboosted task to the head of the RT prio queue). The same treatment
is necessary for sched_setscheduler().

While analyzing the problem I noticed that the fix in
rt_mutex_setprio() is one off. The head queueing depends on old
priority greater than new priority (user space view), but in fact it
needs to have the same treatment for equal priority. Instead of
blindly changing the condition to <= it's better to avoid the whole
dequeue/requeue business for the equal priority case completely.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/core.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1f9d6f5..054e669 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4117,6 +4117,8 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 
 	trace_sched_pi_setprio(p, prio);
 	oldprio = p->prio;
+	if (oldprio == prio)
+		goto out_unlock;
 	prev_class = p->sched_class;
 	on_rq = p->on_rq;
 	running = task_current(rq, p);
@@ -4472,6 +4474,13 @@ recheck:
 		task_rq_unlock(rq, p, &flags);
 		goto recheck;
 	}
+
+	p->sched_reset_on_fork = reset_on_fork;
+
+	oldprio = p->prio;
+	if (oldprio == param->sched_priority)
+		goto out;
+
 	on_rq = p->on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
@@ -4479,18 +4488,17 @@ recheck:
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
-	p->sched_reset_on_fork = reset_on_fork;
-
-	oldprio = p->prio;
 	prev_class = p->sched_class;
 	__setscheduler(rq, p, policy, param->sched_priority);
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq)
-		enqueue_task(rq, p, 0);
+		enqueue_task(rq, p, oldprio < param->sched_priority ?
+			     ENQUEUE_HEAD : 0);
 
 	check_class_changed(rq, p, prev_class, oldprio);
+out:
 	task_rq_unlock(rq, p, &flags);
 
 	rt_mutex_adjust_pi(p);
-- 
1.7.10.4


