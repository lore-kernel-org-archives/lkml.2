Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586Ab2EQMrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:47:48 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38518 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab2EQMrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:47:47 -0400
MIME-Version: 1.0
Date: Thu, 17 May 2012 20:47:45 +0800
Message-ID: <CAJd=RBDRdnBD8vSp9HPRjEnVGQ60BpPCGvz-HRXtwp2Nk_8VoQ@mail.gmail.com>
Subject: BFS 420: cleanup try_preempt
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First the cpumask on stack is removed.

Then before scanning online CPUs, highest_prio and latest_deadline are inited
with values of the given task, for shortening the scan as much as we could.

And if we get highest_prio_rq, its current task is rescheduled without bothering
calling can_preempt, as we already do the checks when finding the
target runqueue.


--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Thu May 17 20:35:46 2012
@@ -1423,7 +1423,6 @@ static void try_preempt(struct task_stru
 	struct rq *highest_prio_rq = NULL;
 	int cpu, highest_prio;
 	u64 latest_deadline;
-	cpumask_t tmp;

 	/*
 	 * We clear the sticky flag here because for a task to have called
@@ -1441,14 +1440,10 @@ static void try_preempt(struct task_stru
 	if (p->policy == SCHED_IDLEPRIO)
 		return;

-	if (likely(online_cpus(p)))
-		cpus_and(tmp, cpu_online_map, p->cpus_allowed);
-	else
-		return;
-
-	highest_prio = latest_deadline = 0;
+	highest_prio = p->prio;
+	latest_deadline = p->deadline;

-	for_each_cpu_mask(cpu, tmp) {
+	for_each_cpu_and(cpu, cpu_online_map, p->cpus_allowed) {
 		struct rq *rq;
 		int rq_prio;

@@ -1465,10 +1460,8 @@ static void try_preempt(struct task_stru
 		}
 	}

-	if (likely(highest_prio_rq)) {
-		if (can_preempt(p, highest_prio, highest_prio_rq->rq_deadline))
-			resched_task(highest_prio_rq->curr);
-	}
+	if (highest_prio_rq)
+		resched_task(highest_prio_rq->curr);
 }
 #else /* CONFIG_SMP */
 static inline bool needs_other_cpu(struct task_struct *p, int cpu)
--
