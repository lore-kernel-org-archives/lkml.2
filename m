Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1E1OZu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 10:25:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55963 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab1E1OZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 10:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=fLGTQuSzAG9jiJm/OjldEUM/XhtRTRIzpeZEqnOUWi0riuiyVm3yOFB42rIcvIYn4b
         6tt1tewtif1SZeHuU1e/llwBesj0Lc3i0EH261nQGhnI0LvqDKv5bQn5nf+Trfpj2dW2
         lE3KW7bTjQTNQmSz6VJmFv3gTxpzKD3LYbChk=
MIME-Version: 1.0
Date: Sat, 28 May 2011 22:25:48 +0800
Message-ID: <BANLkTimQ67180HxCx5vgMqumqw1EkFh3qg@mail.gmail.com>
Subject: [PATCH] sched: remove the next highest_prio in RT scheduling
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next highest_prio element in rt_rq structure, is only used when pulling
RT task. As shown by the following snippet (in diff format for clearity),

-		if (src_rq->rt.highest_prio.next >=
+		if (src_rq->rt.highest_prio.curr >=
 		    this_rq->rt.highest_prio.curr)
 			continue;

the "next" could be replaced with "curr" in the above comparison, since
the next is no less than curr by definition.

Then operations for updating the element are deleted accordingly.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- tip-git/kernel/sched.c	Sun May 22 18:21:46 2011
+++ sched.c	Sat May 28 20:53:24 2011
@@ -384,9 +384,6 @@ struct rt_rq {
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	struct {
 		int curr; /* highest queued rt task prio */
-#ifdef CONFIG_SMP
-		int next; /* next highest */
-#endif
 	} highest_prio;
 #endif
 #ifdef CONFIG_SMP
@@ -7718,9 +7715,6 @@ static void init_rt_rq(struct rt_rq *rt_

 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	rt_rq->highest_prio.curr = MAX_RT_PRIO;
-#ifdef CONFIG_SMP
-	rt_rq->highest_prio.next = MAX_RT_PRIO;
-#endif
 #endif
 #ifdef CONFIG_SMP
 	rt_rq->rt_nr_migratory = 0;
--- tip-git/kernel/sched_rt.c	Sun May 22 20:12:01 2011
+++ sched_rt.c	Sat May 28 21:00:04 2011
@@ -664,67 +664,19 @@ static void update_curr_rt(struct rq *rq

 #if defined CONFIG_SMP

-static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu);
-
-static inline int next_prio(struct rq *rq)
-{
-	struct task_struct *next = pick_next_highest_task_rt(rq, rq->cpu);
-
-	if (next && rt_prio(next->prio))
-		return next->prio;
-	else
-		return MAX_RT_PRIO;
-}
-
-static void
-inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
-{
-	struct rq *rq = rq_of_rt_rq(rt_rq);
-
-	if (prio < prev_prio) {
-
-		/*
-		 * If the new task is higher in priority than anything on the
-		 * run-queue, we know that the previous high becomes our
-		 * next-highest.
-		 */
-		rt_rq->highest_prio.next = prev_prio;
-
-		if (rq->online)
-			cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
-
-	} else if (prio == rt_rq->highest_prio.curr)
-		/*
-		 * If the next task is equal in priority to the highest on
-		 * the run-queue, then we implicitly know that the next highest
-		 * task cannot be any lower than current
-		 */
-		rt_rq->highest_prio.next = prio;
-	else if (prio < rt_rq->highest_prio.next)
-		/*
-		 * Otherwise, we need to recompute next-highest
-		 */
-		rt_rq->highest_prio.next = next_prio(rq);
-}
-
 static void
-dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
+update_rt_prio_smp(struct rt_rq *rt_rq, int prev_prio)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);

-	if (rt_rq->rt_nr_running && (prio <= rt_rq->highest_prio.next))
-		rt_rq->highest_prio.next = next_prio(rq);
-
 	if (rq->online && rt_rq->highest_prio.curr != prev_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
 }

 #else /* CONFIG_SMP */

-static inline
-void inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio) {}
-static inline
-void dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio) {}
+static inline void
+update_rt_prio_smp(struct rt_rq *rt_rq, int prev_prio) {}

 #endif /* CONFIG_SMP */

@@ -737,7 +689,7 @@ inc_rt_prio(struct rt_rq *rt_rq, int pri
 	if (prio < prev_prio)
 		rt_rq->highest_prio.curr = prio;

-	inc_rt_prio_smp(rt_rq, prio, prev_prio);
+	update_rt_prio_smp(rt_rq, prev_prio);
 }

 static void
@@ -763,7 +715,7 @@ dec_rt_prio(struct rt_rq *rt_rq, int pri
 	} else
 		rt_rq->highest_prio.curr = MAX_RT_PRIO;

-	dec_rt_prio_smp(rt_rq, prio, prev_prio);
+	update_rt_prio_smp(rt_rq, prev_prio);
 }

 #else
@@ -1456,7 +1408,7 @@ static int pull_rt_task(struct rq *this_
 		 * logically higher, the src_rq will push this task away.
 		 * And if its going logically lower, we do not care
 		 */
-		if (src_rq->rt.highest_prio.next >=
+		if (src_rq->rt.highest_prio.curr >=
 		    this_rq->rt.highest_prio.curr)
 			continue;
