Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab0GBJYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:24:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39494 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab0GBJYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:24:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=k0/8knxIFNPmSl8uiAIkVCqIFaO5ckSZA2Jvwcmmp0WO4PKFI4C6U/ntTRJJC53skB
         CRCpWlnyc5dSN7qYKT8WkzqWEP9S1Rj8NRcLha+MoiRv0TXJjiWtvZ6jnWoIdUpfvyMC
         4RY3Zrf9ibdVKMW+6hsfLiiSd0plLx/cw1NBg=
Message-ID: <4C2DB037.3010106@gmail.com>
Date: Fri, 02 Jul 2010 11:24:07 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 3/4] workqueue: remove WQ_SINGLE_CPU and use WQ_UNBOUND instead
References: <4C2A2688.1020206@kernel.org> <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> <25085.1277847455@redhat.com> <4C2DAEBB.7090607@kernel.org>
In-Reply-To: <4C2DAEBB.7090607@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WQ_SINGLE_CPU combined with @max_active of 1 is used to achieve full
ordering among works queued to a workqueue.  The same can be achieved
using WQ_UNBOUND as unbound workqueues always use the gcwq for
WORK_CPU_UNBOUND.  As @max_active is always one and benefits from cpu
locality isn't accessible anyway, serving them with unbound workqueues
should be fine.

Drop WQ_SINGLE_CPU support and use WQ_UNBOUND instead.  Note that most
single thread workqueue users will be converted to use multithread or
non-reentrant instead and only the ones which require strict ordering
will keep using WQ_UNBOUND + @max_active of 1.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    7 +--
 kernel/workqueue.c        |  100 ++++++++-------------------------------------
 2 files changed, 21 insertions(+), 86 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 67ce734..d74a529 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -233,12 +233,11 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }

 enum {
 	WQ_NON_REENTRANT	= 1 << 0, /* guarantee non-reentrance */
-	WQ_SINGLE_CPU		= 1 << 1, /* only single cpu at a time */
+	WQ_UNBOUND		= 1 << 1, /* not bound to any cpu */
 	WQ_FREEZEABLE		= 1 << 2, /* freeze during suspend */
 	WQ_RESCUER		= 1 << 3, /* has an rescue worker */
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
-	WQ_UNBOUND		= 1 << 6, /* not bound to any cpu */

 	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
 	WQ_MAX_UNBOUND_PER_CPU	= 4,	  /* 4 * #cpus for unbound wq */
@@ -300,9 +299,9 @@ __alloc_workqueue_key(const char *name, unsigned int flags, int max_active,
 #define create_workqueue(name)					\
 	alloc_workqueue((name), WQ_RESCUER, 1)
 #define create_freezeable_workqueue(name)			\
-	alloc_workqueue((name), WQ_FREEZEABLE | WQ_SINGLE_CPU | WQ_RESCUER, 1)
+	alloc_workqueue((name), WQ_FREEZEABLE | WQ_UNBOUND | WQ_RESCUER, 1)
 #define create_singlethread_workqueue(name)			\
-	alloc_workqueue((name), WQ_SINGLE_CPU | WQ_RESCUER, 1)
+	alloc_workqueue((name), WQ_UNBOUND | WQ_RESCUER, 1)

 extern void destroy_workqueue(struct workqueue_struct *wq);

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4608563..20d6237 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -206,8 +206,6 @@ struct workqueue_struct {
 	struct list_head	flusher_queue;	/* F: flush waiters */
 	struct list_head	flusher_overflow; /* F: flush overflow list */

-	unsigned long		single_cpu;	/* cpu for single cpu wq */
-
 	cpumask_var_t		mayday_mask;	/* cpus requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */

@@ -889,34 +887,6 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 		wake_up_worker(gcwq);
 }

-/**
- * cwq_unbind_single_cpu - unbind cwq from single cpu workqueue processing
- * @cwq: cwq to unbind
- *
- * Try to unbind @cwq from single cpu workqueue processing.  If
- * @cwq->wq is frozen, unbind is delayed till the workqueue is thawed.
- *
- * CONTEXT:
- * spin_lock_irq(gcwq->lock).
- */
-static void cwq_unbind_single_cpu(struct cpu_workqueue_struct *cwq)
-{
-	struct workqueue_struct *wq = cwq->wq;
-	struct global_cwq *gcwq = cwq->gcwq;
-
-	BUG_ON(wq->single_cpu != gcwq->cpu);
-	/*
-	 * Unbind from workqueue if @cwq is not frozen.  If frozen,
-	 * thaw_workqueues() will either restart processing on this
-	 * cpu or unbind if empty.  This keeps works queued while
-	 * frozen fully ordered and flushable.
-	 */
-	if (likely(!(gcwq->flags & GCWQ_FREEZING))) {
-		smp_wmb();	/* paired with cmpxchg() in __queue_work() */
-		wq->single_cpu = WORK_CPU_NONE;
-	}
-}
-
 static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
@@ -924,20 +894,16 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	struct cpu_workqueue_struct *cwq;
 	struct list_head *worklist;
 	unsigned long flags;
-	bool arbitrate;

 	debug_work_activate(work);

-	if (unlikely(cpu == WORK_CPU_UNBOUND))
-		cpu = raw_smp_processor_id();
-
-	/*
-	 * Determine gcwq to use.  SINGLE_CPU is inherently
-	 * NON_REENTRANT, so test it first.
-	 */
-	if (!(wq->flags & (WQ_SINGLE_CPU | WQ_UNBOUND))) {
+	/* determine gcwq to use */
+	if (!(wq->flags & WQ_UNBOUND)) {
 		struct global_cwq *last_gcwq;

+		if (unlikely(cpu == WORK_CPU_UNBOUND))
+			cpu = raw_smp_processor_id();
+
 		/*
 		 * It's multi cpu.  If @wq is non-reentrant and @work
 		 * was previously on a different cpu, it might still
@@ -962,38 +928,6 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			}
 		} else
 			spin_lock_irqsave(&gcwq->lock, flags);
-	} else if (!(wq->flags & WQ_UNBOUND)) {
-		unsigned int req_cpu = cpu;
-
-		/*
-		 * It's a bit more complex for single cpu workqueues.
-		 * We first need to determine which cpu is going to be
-		 * used.  If no cpu is currently serving this
-		 * workqueue, arbitrate using atomic accesses to
-		 * wq->single_cpu; otherwise, use the current one.
-		 */
-	retry:
-		cpu = wq->single_cpu;
-		arbitrate = cpu == WORK_CPU_NONE;
-		if (arbitrate)
-			cpu = req_cpu;
-
-		gcwq = get_gcwq(cpu);
-		spin_lock_irqsave(&gcwq->lock, flags);
-
-		/*
-		 * The following cmpxchg() is a full barrier paired
-		 * with smp_wmb() in cwq_unbind_single_cpu() and
-		 * guarantees that all changes to wq->st_* fields are
-		 * visible on the new cpu after this point.
-		 */
-		if (arbitrate)
-			cmpxchg(&wq->single_cpu, WORK_CPU_NONE, cpu);
-
-		if (unlikely(wq->single_cpu != cpu)) {
-			spin_unlock_irqrestore(&gcwq->lock, flags);
-			goto retry;
-		}
 	} else {
 		gcwq = get_gcwq(WORK_CPU_UNBOUND);
 		spin_lock_irqsave(&gcwq->lock, flags);
@@ -1105,19 +1039,30 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	struct work_struct *work = &dwork->work;

 	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
-		struct global_cwq *gcwq = get_work_gcwq(work);
-		unsigned int lcpu = gcwq ? gcwq->cpu : raw_smp_processor_id();
+		unsigned int lcpu;

 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));

 		timer_stats_timer_set_start_info(&dwork->timer);
+
 		/*
 		 * This stores cwq for the moment, for the timer_fn.
 		 * Note that the work's gcwq is preserved to allow
 		 * reentrance detection for delayed works.
 		 */
+		if (!(wq->flags & WQ_UNBOUND)) {
+			struct global_cwq *gcwq = get_work_gcwq(work);
+
+			if (gcwq && gcwq->cpu != WORK_CPU_UNBOUND)
+				lcpu = gcwq->cpu;
+			else
+				lcpu = raw_smp_processor_id();
+		} else
+			lcpu = WORK_CPU_UNBOUND;
+
 		set_work_cwq(work, get_cwq(lcpu, wq), 0);
+
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
@@ -1696,9 +1641,6 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
 		/* one down, submit a delayed one */
 		if (cwq->nr_active < cwq->max_active)
 			cwq_activate_first_delayed(cwq);
-	} else if (!cwq->nr_active && cwq->wq->flags & WQ_SINGLE_CPU) {
-		/* this was the last work, unbind from single cpu */
-		cwq_unbind_single_cpu(cwq);
 	}

 	/* is flush in progress and are we at the flushing tip? */
@@ -2751,7 +2693,6 @@ struct workqueue_struct *__alloc_workqueue_key(const char *name,
 	atomic_set(&wq->nr_cwqs_to_flush, 0);
 	INIT_LIST_HEAD(&wq->flusher_queue);
 	INIT_LIST_HEAD(&wq->flusher_overflow);
-	wq->single_cpu = WORK_CPU_NONE;

 	wq->name = name;
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
@@ -3513,11 +3454,6 @@ void thaw_workqueues(void)
 			while (!list_empty(&cwq->delayed_works) &&
 			       cwq->nr_active < cwq->max_active)
 				cwq_activate_first_delayed(cwq);
-
-			/* perform delayed unbind from single cpu if empty */
-			if (wq->single_cpu == gcwq->cpu &&
-			    !cwq->nr_active && list_empty(&cwq->delayed_works))
-				cwq_unbind_single_cpu(cwq);
 		}

 		wake_up_worker(gcwq);
-- 
1.6.4.2

