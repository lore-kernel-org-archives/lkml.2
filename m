Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab2DGJ7I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 05:59:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55015 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab2DGJ7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 05:59:06 -0400
MIME-Version: 1.0
Date: Sat, 7 Apr 2012 17:59:05 +0800
Message-ID: <CAJd=RBDnPvr=QLgnc7eXZaqZaxurLAXE9-ftM=Sdkd4x2Thfyg@mail.gmail.com>
Subject: [PATCH] DLS: cleanup pulling task
From: Hillf Danton <dhillf@gmail.com>
To: Dario Faggioli <raistlin@linux.it>, Juri Lelli <juri.lelli@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First add check for CPU online.
Second initialize dmin to be as minimum as possible.
Third dl_time_before is replaced with dl_entity_preempt for easy read.

Due to re-init of dmin, a couple of preempt checks are removed.

With runqueue lock, a couple of caution checks are also removed.

Finally the jump label, skip, is replaced with unlock.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched_dl.c	Sat Apr  7 15:00:28 2012
+++ b/kernel/sched_dl.c	Sat Apr  7 17:33:44 2012
@@ -1287,71 +1287,53 @@ static void push_dl_tasks(struct rq *rq)

 static int pull_dl_task(struct rq *this_rq)
 {
-	int this_cpu = this_rq->cpu, ret = 0, cpu;
-	struct task_struct *p;
-	struct rq *src_rq;
-	u64 dmin = LONG_MAX;
+	int this_cpu = this_rq->cpu;
+	int cpu;
+	u64 dmin;
+	int ret = 0;

 	if (likely(!dl_overloaded(this_rq)))
 		return 0;

-	for_each_cpu(cpu, this_rq->rd->dlo_mask) {
+	if (this_rq->dl.dl_nr_running)
+		dmin = this_rq->dl.earliest_dl.curr;
+	else
+		dmin = -1ULL;
+
+	for_each_cpu_and(cpu, this_rq->rd->dlo_mask, cpu_online_mask) {
+		struct task_struct *p;
+		struct rq *src_rq;
+
 		if (this_cpu == cpu)
 			continue;

 		src_rq = cpu_rq(cpu);

-		/*
-		 * It looks racy, abd it is! However, as in sched_rt.c,
-		 * we are fine with this.
-		 */
-		if (this_rq->dl.dl_nr_running &&
-		    dl_time_before(this_rq->dl.earliest_dl.curr,
-				   src_rq->dl.earliest_dl.next))
+		/* Racy without runqueue lock, but we are fine now */
+		if (!dl_entity_preempt(src_rq->dl.earliest_dl.next, dmin))
 			continue;

-		/* Might drop this_rq->lock */
 		double_lock_balance(this_rq, src_rq);

-		/*
-		 * If there are no more pullable tasks on the
-		 * rq, we're done with it.
-		 */
 		if (src_rq->dl.dl_nr_running <= 1)
-			goto skip;
+			goto unlock;

 		p = pick_next_earliest_dl_task(src_rq, this_cpu);

-		/*
-		 * We found a task to be pulled if:
-		 *  - it preempts our current (if there's one),
-		 *  - it will preempt the last one we pulled (if any).
-		 */
-		if (p && dl_time_before(p->dl.deadline, dmin) &&
-		    (!this_rq->dl.dl_nr_running ||
-		     dl_time_before(p->dl.deadline,
-				    this_rq->dl.earliest_dl.curr))) {
-			WARN_ON(p == src_rq->curr);
-			WARN_ON(!p->on_rq);
-
-			/*
-			 * Then we pull iff p has actually an earlier
-			 * deadline than the current task of its runqueue.
-			 */
-			if (dl_time_before(p->dl.deadline,
-					   src_rq->curr->dl.deadline))
-				goto skip;
+		/* With runqueue lock, recheck preempty */
+		if (p && dl_entity_preempt(p->dl.deadline, dmin)) {

-			ret = 1;
+			/* We dont pull running task */
+			if (p == src_rq->curr)
+				goto unlock;

 			deactivate_task(src_rq, p, 0);
 			set_task_cpu(p, this_cpu);
 			activate_task(this_rq, p, 0);
+			ret++;
 			dmin = p->dl.deadline;
-
-			/* Is there any other task even earlier? */
 		}
-skip:
+unlock:
 		double_unlock_balance(this_rq, src_rq);
 	}

--
