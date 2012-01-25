Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab2AYKKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 05:10:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57695 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab2AYKKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 05:10:38 -0500
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special
 condition
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Yasunori Goto <y-goto@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <4EFB8523.6080708@gmail.com>
References: <1324633794.24803.48.camel@twins>
	 <20111223154137.GA27901@redhat.com>
	 <20111226172357.CE4D.E1E9C6FF@jp.fujitsu.com>
	 <20111226171151.GA4472@redhat.com>  <4EFB8523.6080708@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Jan 2012 11:10:24 +0100
Message-ID: <1327486224.2614.45.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-28 at 16:07 -0500, KOSAKI Motohiro wrote:
> 
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
> 

Hmm, I think you're right, when CPU0 does __sched_setscheduler() on the
task running on CPU1 and CPU1's @task is current.

I think only __sched_setscheduler() is really a problem, the other
activate/deactivate users not schedule or wakeup are __migrate_task()
and normalize_task().

__migrate_task() will only run on tasks that aren't actually running
anywhere so the above scenario can't happen, normalize_task() is never
used on normal systems (sysrq-n).

So I guess the below cures things and cleans up a bit.. no?

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
@@ -4134,7 +4128,7 @@ static int __sched_setscheduler(struct task_struct *p, int policy,
 	on_rq = p->on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
-		deactivate_task(rq, p, 0);
+		dequeue_task(rq, p, 0);
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
@@ -4147,7 +4141,7 @@ static int __sched_setscheduler(struct task_struct *p, int policy,
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
 


