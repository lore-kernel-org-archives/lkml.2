Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1EUP2Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 11:28:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55491 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1EUP2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 11:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=UzUWT/vv//5f5aQDjsSPLJu9Of7KEPgUg+jLLQbBpQ9ZreNpaNZjDi+61WBr1LafRq
         WssAjWyJJweiWOj7NM08EpKvrCM3S/popS+4BsEKauIbsJcIpb0WDdN/nV7DI8Z9+3q0
         HpzMxwVPIoOPBx25WWs0xeWYGyTnM5/QwiQaM=
MIME-Version: 1.0
Date: Sat, 21 May 2011 23:28:19 +0800
Message-ID: <BANLkTimF2d93VVGKHDdFTn=V-1h9nWrs_w@mail.gmail.com>
Subject: [PATCH v0] sched: change how run-queue is selected for RT task
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When selecting run-queue for a given RT task, we have to take a few
factors, such as task priority and CPU cache affinity, into
consideration. In this work, a simpler method is proposed, which is
focusing on the relation between the current run-queue of the given
task and the given run-queue.

If the current run-queue of task is the given run-queue, the run-queue
of task keeps unchanged, so the CPU cache affinities of both task and
the current task of run-queue remain unchanged. Then there are at
least two tasks competing one CPU, and in the worst case that both
competitors are RT tasks the victim will be selected and processed by
pusher later.

On other hand, if the current run-queue of task is different from the
given run-queue, task is simply delivered to its current run-queue,
since pusher is always willing to do hard works.

In summary, the burden of RT task is always processed first by the
pusher of its current run-queue.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched_rt.c	2011-04-27 11:48:50.000000000 +0800
+++ b/kernel/sched_rt.c	2011-05-21 22:19:52.000000000 +0800
@@ -998,14 +998,12 @@ select_task_rq_rt(struct rq *rq, struct
 	 *
 	 * For equal prio tasks, we just let the scheduler sort it out.
 	 */
-	if (unlikely(rt_task(rq->curr)) &&
-	    (rq->curr->rt.nr_cpus_allowed < 2 ||
-	     rq->curr->prio < p->prio) &&
-	    (p->rt.nr_cpus_allowed > 1)) {
-		int cpu = find_lowest_rq(p);

-		return (cpu == -1) ? task_cpu(p) : cpu;
-	}
+	if (task_cpu(p) == rq->cpu)
+		return rq->cpu;
+
+	if (likely(!rt_task(rq->curr)))
+		return rq->cpu;

 	/*
 	 * Otherwise, just let it ride on the affined RQ and the
