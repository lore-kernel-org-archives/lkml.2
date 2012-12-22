Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab2LVRM0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 12:12:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25559 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2LVRMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 12:12:18 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=rZbusVlU-hoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=8kzRziY1_1cA:10 a=VwQbUJbxAAAA:8 a=tJHY4lP-bUIGcm4lGvsA:9 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121222171217.290120752@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 22 Dec 2012 12:12:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, <stable@vger.kernel.org>,
        <stable-rt@vger.kernel.org>
Subject: [PATCH RT 2/4] sched: Queue RT tasks to head when prio drops
References: <20121222171201.588460638@goodmis.org>
Content-Disposition: inline; filename=0002-sched-Queue-RT-tasks-to-head-when-prio-drops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The following scenario does not work correctly:

Runqueue of CPUx contains two runnable and pinned tasks:
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

We fixed a similar issue already in commit 60db48c (sched: Queue a
deboosted task to the head of the RT prio queue). The same treatment
is necessary for sched_setscheduler(). So enqueue to head of the prio
bucket list if the priority of the task is lowered.

It might be possible that existing user space relies on the current
behaviour, but it can be considered highly unlikely due to the corner
case nature of the application scenario.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Cc: stable-rt@vger.kernel.org
---
 kernel/sched.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 945009e..ad42cb2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5387,8 +5387,13 @@ recheck:
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
-	if (on_rq)
-		activate_task(rq, p, 0);
+	if (on_rq) {
+		/*
+		 * We enqueue to tail when the priority of a task is
+		 * increased (user space view).
+		 */
+		activate_task(rq, p, oldprio <= p->prio ? ENQUEUE_HEAD : 0);
+	}
 
 	check_class_changed(rq, p, prev_class, oldprio);
 	task_rq_unlock(rq, p, &flags);
-- 
1.7.10.4


