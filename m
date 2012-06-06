Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab2FFNUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:20:20 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54573 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab2FFNUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:20:18 -0400
MIME-Version: 1.0
Date: Wed, 6 Jun 2012 21:20:17 +0800
Message-ID: <CAJd=RBCyZAYkP4O=QpbgdTJtJGxZteYp-MCrDhBht4jaWjGofA@mail.gmail.com>
Subject: [patch] BFS 421: fix try_preempt
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have to keep deadline latest, so no update if not checked.

Alternatively we could try preempt in the following way,

	rcu_read_lock();
	for_each_domain(task_cpu(q), sd) {
		for_each_cpu_and(cpu, tsk_cpus_allowed(p),
						sched_domain_span(sd)) {
			if (!cpu_online(cpu))
				continue;
			if (can_preempt(p, cpu_rq(cpu)->rq_prio,
						cpu_rq(cpu)->rq_deadline)) {
				resched_task(cpu_rq(cpu)->curr);
				goto out;
			}
		}
	}
out:
	rcu_read_unlock();


where the upside is that the LLC is invovled, and the downside is that we are
not sure the preempted task has the highest priority and the latest deadline.

What to do next?


--- a/kernel/sched/bfs.c	Wed Jun  6 20:14:36 2012
+++ b/kernel/sched/bfs.c	Wed Jun  6 20:16:48 2012
@@ -1452,10 +1452,11 @@ static void try_preempt(struct task_stru
 		if (rq_prio < highest_prio)
 			continue;

-		if (rq_prio > highest_prio ||
-		    deadline_after(rq->rq_deadline, latest_deadline)) {
+		if (rq_prio > highest_prio)
+			goto set;
+		if (deadline_after(rq->rq_deadline, latest_deadline)) {
 			latest_deadline = rq->rq_deadline;
-			highest_prio = rq_prio;
+set:			highest_prio = rq_prio;
 			highest_prio_rq = rq;
 		}
 	}
--
