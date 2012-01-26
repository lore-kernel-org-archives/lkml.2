Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab2AZUZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 15:25:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39636 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2AZUZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 15:25:57 -0500
Date: Thu, 26 Jan 2012 12:25:33 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-4ca9b72b71f10147bd21969c1805f5b2c4ca7b7b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, kosaki.motohiro@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, kosaki.motohiro@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1327486224.2614.45.camel@laptop>
References: <1327486224.2614.45.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix rq->nr_uninterruptible update race
Git-Commit-ID: 4ca9b72b71f10147bd21969c1805f5b2c4ca7b7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 12:25:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ca9b72b71f10147bd21969c1805f5b2c4ca7b7b
Gitweb:     http://git.kernel.org/tip/4ca9b72b71f10147bd21969c1805f5b2c4ca7b7b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 25 Jan 2012 11:50:51 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Jan 2012 19:38:09 +0100

sched: Fix rq->nr_uninterruptible update race

KOSAKI Motohiro noticed the following race:

 > CPU0                    CPU1
 > --------------------------------------------------------
 > deactivate_task()
 >                         task->state = TASK_UNINTERRUPTIBLE;
 > activate_task()
 >    rq->nr_uninterruptible--;
 >
 >                         schedule()
 >                           deactivate_task()
 >                             rq->nr_uninterruptible++;
 >

Kosaki-San's scenario is possible when CPU0 runs
__sched_setscheduler() against CPU1's current @task.

__sched_setscheduler() does a dequeue/enqueue in order to move
the task to its new queue (position) to reflect the newly provided
scheduling parameters. However it should be completely invariant to
nr_uninterruptible accounting, sched_setscheduler() doesn't affect
readyness to run, merely policy on when to run.

So convert the inappropriate activate/deactivate_task usage to
enqueue/dequeue_task, which avoids the nr_uninterruptible accounting.

Also convert the two other sites: __migrate_task() and
normalize_task() that still use activate/deactivate_task. These sites
aren't really a problem since __migrate_task() will only be called on
non-running task (and therefore are immume to the described problem)
and normalize_task() isn't ever used on regular systems.

Also remove the comments from activate/deactivate_task since they're
misleading at best.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1327486224.2614.45.camel@laptop
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index df00cb0..e067df1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -723,9 +723,6 @@ static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 	p->sched_class->dequeue_task(rq, p, flags);
 }
 
-/*
- * activate_task - move a task to the runqueue.
- */
 void activate_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (task_contributes_to_load(p))
@@ -734,9 +731,6 @@ void activate_task(struct rq *rq, struct task_struct *p, int flags)
 	enqueue_task(rq, p, flags);
 }
 
-/*
- * deactivate_task - remove a task from the runqueue.
- */
 void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (task_contributes_to_load(p))
@@ -4134,7 +4128,7 @@ recheck:
 	on_rq = p->on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
-		deactivate_task(rq, p, 0);
+		dequeue_task(rq, p, 0);
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
@@ -4147,7 +4141,7 @@ recheck:
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq)
-		activate_task(rq, p, 0);
+		enqueue_task(rq, p, 0);
 
 	check_class_changed(rq, p, prev_class, oldprio);
 	task_rq_unlock(rq, p, &flags);
@@ -4998,9 +4992,9 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	 * placed properly.
 	 */
 	if (p->on_rq) {
-		deactivate_task(rq_src, p, 0);
+		dequeue_task(rq_src, p, 0);
 		set_task_cpu(p, dest_cpu);
-		activate_task(rq_dest, p, 0);
+		enqueue_task(rq_dest, p, 0);
 		check_preempt_curr(rq_dest, p, 0);
 	}
 done:
@@ -7032,10 +7026,10 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
 
 	on_rq = p->on_rq;
 	if (on_rq)
-		deactivate_task(rq, p, 0);
+		dequeue_task(rq, p, 0);
 	__setscheduler(rq, p, SCHED_NORMAL, 0);
 	if (on_rq) {
-		activate_task(rq, p, 0);
+		enqueue_task(rq, p, 0);
 		resched_task(rq->curr);
 	}
 
