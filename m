Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab2LHAJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:09:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab2LHAJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:09:03 -0500
X-Authority-Analysis: v=2.0 cv=ZNdVaAHb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=u4kN9zTzO2kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=yptpm8wNvhUA:10 a=yY-IUfAz-ee8wHmZXb4A:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121208000900.489002301@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 07 Dec 2012 18:56:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC][PATCH RT 2/4] sched/rt: Try to migrate task if preempting pinned rt task
References: <20121207235615.206108556@goodmis.org>
Content-Disposition: inline; filename=fix-post-sched-push.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a higher priority task is about to preempt a task that has been
pinned to a CPU. Try to first see if the higher priority task can
preempt another task instead.

That is, a high priority process wakes up on a CPU while a currently
running task can still migrate, it will miss pushing that high priority
task to another CPU. If by the time the task schedules, the task
that it's about to preempt could have changed its affinity and
is pinned. At this time, it may be better to move the task to another
CPU if one exists that is currently running a lower priority task
than the one about to be preempted.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/kernel/sched/rt.c
===================================================================
--- linux-rt.git.orig/kernel/sched/rt.c
+++ linux-rt.git/kernel/sched/rt.c
@@ -1804,8 +1804,22 @@ skip:
 
 static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 {
+	struct task_struct *p = prev;
+
+	/*
+	 * If we are preempting a migrate disabled task
+	 * see if we can push the higher tasks first.
+	 */
+	if (prev->on_rq && (prev->nr_cpus_allowed <= 1 || prev->migrate_disable) &&
+	    has_pushable_tasks(rq) && rq->rt.highest_prio.next < prev->prio) {
+		p = _pick_next_task_rt(rq);
+
+		if (p != prev && p->nr_cpus_allowed > 1 && push_rt_task(rq))
+			p = _pick_next_task_rt(rq);
+	}
+
 	/* Try to pull RT tasks here if we lower this rq's prio */
-	if (rq->rt.highest_prio.curr > prev->prio)
+	if (rq->rt.highest_prio.curr > p->prio)
 		pull_rt_task(rq);
 }
 

