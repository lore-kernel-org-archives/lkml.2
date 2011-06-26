Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab1FZJuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 05:50:17 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35980 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab1FZJuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 05:50:12 -0400
MIME-Version: 1.0
In-Reply-To: <1308921701.17580.9.camel@gandalf.stny.rr.com>
References: <BANLkTi=qf7Dm6U+3B9qL+gYThe4oQXp3tg@mail.gmail.com>
	<1308921701.17580.9.camel@gandalf.stny.rr.com>
Date: Sun, 26 Jun 2011 17:50:10 +0800
Message-ID: <BANLkTimQRtQ9F7w+dEL+PQPDQWRLaSkimA@mail.gmail.com>
Subject: Re: [RFC] sched: use plist in pulling RT task
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Haskins <ghaskins@novell.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven

It is reprepared according to your comments, difference from the last version
is the following,
1, pulled_prio is dropped since it is no more than the highest curr,
2, test p->prio < src_rq->curr->prio is kept as it was,
3, cleanup of a few typo.

Thanks

Hillf
---
 kernel/sched_rt.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index b03cd89..b5aca9c 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1502,18 +1502,17 @@ static int pull_rt_task(struct rq *this_rq)
 		/*
 		 * Are there still pullable RT tasks?
 		 */
-		if (src_rq->rt.rt_nr_running <= 1)
+		if (!has_pushable_tasks(src_rq))
 			goto skip;

-		p = pick_next_highest_task_rt(src_rq, this_cpu);
-
 		/*
 		 * Do we have an RT task that preempts
 		 * the to-be-scheduled task?
 		 */
-		if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
-			WARN_ON(p == src_rq->curr);
-			WARN_ON(!p->on_rq);
+		plist_for_each_entry(p, &src_rq->rt.pushable_tasks,
+						    pushable_tasks) {
+			if (p->prio >= this_rq->rt.highest_prio.curr)
+				break;

 			/*
 			 * There's a chance that p is higher in priority
@@ -1526,17 +1525,15 @@ static int pull_rt_task(struct rq *this_rq)
 			if (p->prio < src_rq->curr->prio)
 				goto skip;

+			if (!cpumask_test_cpu(this_cpu, &p->cpus_allowed))
+				continue;
+
 			ret = 1;

 			deactivate_task(src_rq, p, 0);
 			set_task_cpu(p, this_cpu);
 			activate_task(this_rq, p, 0);
-			/*
-			 * We continue with the search, just in
-			 * case there's an even higher prio task
-			 * in another runqueue. (low likelihood
-			 * but possible)
-			 */
+			break;
 		}
 skip:
 		double_unlock_balance(this_rq, src_rq);
