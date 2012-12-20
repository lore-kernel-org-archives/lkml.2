Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab2LTB60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:58:26 -0500
Received: from mout.gmx.net ([212.227.15.18]:54513 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab2LTB4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:56:47 -0500
X-Authenticated: #48310644
X-Provags-ID: V01U2FsdGVkX1+6e0pMoOW6s1GpbA5+t71ihMFGEZhn+T60SDcsaA
	NmuOz8AZYuxuPw
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Date: Thu, 20 Dec 2012 02:56:43 +0100
From: "Andrey Isakov" <andy51@gmx.ru>
Message-ID: <20121220015643.238490@gmx.com>
MIME-Version: 1.0
Subject: Re: [PATCH] workqueue: consider work function when searching for busy
 work items
To: "Tejun Heo" <tj@kernel.org>
X-Flags: 0001
X-Mailer: GMX.com Web Mailer
x-registered: 0
Content-Transfer-Encoding: 8bit
X-GMX-UID: DBWgcE08eSEqJxVKinYh96F+IGRvb0AM
X-Y-GMX-Trusted: 3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've merged the patch on my kernel version and did the same test, just to make sure. I confirm that the problem with deadlock is gone, thanks!
Well, actually, in my case I just did a kind of workaround by moving kfree to the very end of work functions and it worked. That still leaves some space for race conditions though.

Anyway, I know the driver code I am supporting overuses workqueues a bit, but it initially relied on the fact that there was a separate thread for each wq before, so it used both blocking and works allocating.
I had a hard time finding the cause of a workqueue suddenly stalling in one module apparently because of the blocked work in another one, and it is stated in the docs that both operations are supposed to be a valid use of wq.

It is nice to know that there is now a solution for the people who could step on the same rake as me.
Thanks.


  ----- Original Message -----
  From: Tejun Heo
  Sent: 12/19/12 04:04 AM
  To: andy51@gmx.ru
  Subject: [PATCH] workqueue: consider work function when searching for busy work items
 
   
>From a2c1c57be8d9fd5b716113c8991d3d702eeacf77 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 18 Dec 2012 10:35:02 -0800

To avoid executing the same work item concurrenlty, workqueue hashes
currently busy workers according to their current work items and looks
up the the table when it wants to execute a new work item. If there
already is a worker which is executing the new work item, the new item
is queued to the found worker so that it gets executed only after the
current execution finishes.

Unfortunately, a work item may be freed while being executed and thus
recycled for different purposes. If it gets recycled for a different
work item and queued while the previous execution is still in
progress, workqueue may make the new work item wait for the old one
although the two aren't really related in any way.

In extreme cases, this false dependency may lead to deadlock although
it's extremely unlikely given that there aren't too many self-freeing
work item users and they usually don't wait for other work items.

To alleviate the problem, record the current work function in each
busy worker and match it together with the work item address in
find_worker_executing_work(). While this isn't complete, it ensures
that unrelated work items don't interact with each other and in the
very unlikely case where a twisted wq user triggers it, it's always
onto itself making the culprit easy to spot.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Andrey Isakov <andy51@gmx.ru>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=51701
Cc: stable@vger.kernel.org
---
While this bug is theoretically possible, I haven't seen any evidence
that it's happening at all and cmwq has been in the wild for quite a
while. I'm queueing this for wq/for-3.9 and will route it back
through -stable later.

Thanks.

 kernel/workqueue.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index acd417b..d24a411 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -137,6 +137,7 @@ struct worker {
 };
 
 struct work_struct *current_work; /* L: work being processed */
+ work_func_t current_func; /* L: current_work's fn */
 struct cpu_workqueue_struct *current_cwq; /* L: current_work's cwq */
 struct list_head scheduled; /* L: scheduled works */
 struct task_struct *task; /* I: worker task */
@@ -861,9 +862,27 @@ static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
 * @gcwq: gcwq of interest
 * @work: work to find worker for
 *
- * Find a worker which is executing @work on @gcwq. This function is
- * identical to __find_worker_executing_work() except that this
- * function calculates @bwh itself.
+ * Find a worker which is executing @work on @gcwq by searching
+ * @gcwq->busy_hash which is keyed by the address of @work. For a worker
+ * to match, its current execution should match the address of @work and
+ * its work function. This is to avoid unwanted dependency between
+ * unrelated work executions through a work item being recycled while still
+ * being executed.
+ *
+ * This is a bit tricky. A work item may be freed once its execution
+ * starts and nothing prevents the freed area from being recycled for
+ * another work item. If the same work item address ends up being reused
+ * before the original execution finishes, workqueue will identify the
+ * recycled work item as currently executing and make it wait until the
+ * current execution finishes, introducing an unwanted dependency.
+ *
+ * This function checks the work item address, work function and workqueue
+ * to avoid false positives. Note that this isn't complete as one may
+ * construct a work function which can introduce dependency onto itself
+ * through a recycled work item. Well, if somebody wants to shoot oneself
+ * in the foot that badly, there's only so much we can do, and if such
+ * deadlock actually occurs, it should be easy to locate the culprit work
+ * function.
 *
 * CONTEXT:
 * spin_lock_irq(gcwq->lock).
@@ -878,8 +897,10 @@ static struct worker *find_worker_executing_work(struct global_cwq *gcwq,
 struct worker *worker;
 struct hlist_node *tmp;
 
- hash_for_each_possible(gcwq->busy_hash, worker, tmp, hentry, (unsigned long)work)
- if (worker->current_work == work)
+ hash_for_each_possible(gcwq->busy_hash, worker, tmp, hentry,
+ (unsigned long)work)
+ if (worker->current_work == work &&
+ worker->current_func == work->func)
 return worker;
 
 return NULL;
@@ -2114,7 +2135,6 @@ __acquires(&gcwq->lock)
 struct worker_pool *pool = worker->pool;
 struct global_cwq *gcwq = pool->gcwq;
 bool cpu_intensive = cwq->wq->flags & WQ_CPU_INTENSIVE;
- work_func_t f = work->func;
 int work_color;
 struct worker *collision;
 #ifdef CONFIG_LOCKDEP
@@ -2154,6 +2174,7 @@ __acquires(&gcwq->lock)
 debug_work_deactivate(work);
 hash_add(gcwq->busy_hash, &worker->hentry, (unsigned long)worker);
 worker->current_work = work;
+ worker->current_func = work->func;
 worker->current_cwq = cwq;
 work_color = get_work_color(work);
 
@@ -2186,7 +2207,7 @@ __acquires(&gcwq->lock)
 lock_map_acquire_read(&cwq->wq->lockdep_map);
 lock_map_acquire(&lockdep_map);
 trace_workqueue_execute_start(work);
- f(work);
+ worker->current_func(work);
 /*
 * While we must be careful to not use "work" after this, the trace
 * point will only record its address.
@@ -2198,7 +2219,8 @@ __acquires(&gcwq->lock)
 if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
 pr_err("BUG: workqueue leaked lock or atomic: %s/0x%08x/%d\n"
 " last function: %pf\n",
- current->comm, preempt_count(), task_pid_nr(current), f);
+ current->comm, preempt_count(), task_pid_nr(current),
+ worker->current_func);
 debug_show_held_locks(current);
 dump_stack();
 }
@@ -2212,6 +2234,7 @@ __acquires(&gcwq->lock)
 /* we're done with it, release */
 hash_del(&worker->hentry);
 worker->current_work = NULL;
+ worker->current_func = NULL;
 worker->current_cwq = NULL;
 cwq_dec_nr_in_flight(cwq, work_color);
 }
-- 
1.8.0.2   


