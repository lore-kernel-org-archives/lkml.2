Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab2GLWca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:32:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34153 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab2GLWc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:32:26 -0400
Date: Thu, 12 Jul 2012 15:32:21 -0700
From: Tejun Heo <tj@kernel.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, joshhunt00@gmail.com, axboe@kernel.dk,
        rni@google.com, vgoyal@redhat.com, vwadekar@nvidia.com,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, swhiteho@redhat.com, bpm@sgi.com,
        elder@kernel.org, xfs@oss.sgi.com, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH 6/6] workqueue: reimplement WQ_HIGHPRI using a separate
 worker_pool
Message-ID: <20120712223221.GF20167@google.com>
References: <1341859315-17759-7-git-send-email-tj@kernel.org>
 <20120712130648.GA19214@localhost>
 <20120712170519.GA20167@google.com>
 <20120712214514.GD20167@google.com>
 <CA+8MBb+ghRpmtrk=t5-6MqrPMZt+a69UoAWaubyKBeptGdBrWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBb+ghRpmtrk=t5-6MqrPMZt+a69UoAWaubyKBeptGdBrWA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tony.

On Thu, Jul 12, 2012 at 03:16:30PM -0700, Tony Luck wrote:
> On Thu, Jul 12, 2012 at 2:45 PM, Tejun Heo <tj@kernel.org> wrote:
> > I was wrong and am now dazed and confused.  That's from
> > init_workqueues() where only cpu0 is running.  How the hell did
> > nr_running manage to become non-zero at that point?  Can you please
> > apply the following patch and report the boot log?  Thank you.
> 
> Patch applied on top of next-20120712 (which still has the same problem).

Can you please try the following debug patch instead?  Yours is
different from Fengguang's.

Thanks a lot!
---
 kernel/workqueue.c |   40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -699,8 +699,10 @@ void wq_worker_waking_up(struct task_str
 {
 	struct worker *worker = kthread_data(task);
 
-	if (!(worker->flags & WORKER_NOT_RUNNING))
+	if (!(worker->flags & WORKER_NOT_RUNNING)) {
+		WARN_ON_ONCE(cpu != worker->pool->gcwq->cpu);
 		atomic_inc(get_pool_nr_running(worker->pool));
+	}
 }
 
 /**
@@ -730,6 +732,7 @@ struct task_struct *wq_worker_sleeping(s
 
 	/* this can only happen on the local cpu */
 	BUG_ON(cpu != raw_smp_processor_id());
+	WARN_ON_ONCE(cpu != worker->pool->gcwq->cpu);
 
 	/*
 	 * The counterpart of the following dec_and_test, implied mb,
@@ -1212,9 +1215,30 @@ static void worker_enter_idle(struct wor
 	 * between setting %WORKER_ROGUE and zapping nr_running, the
 	 * warning may trigger spuriously.  Check iff trustee is idle.
 	 */
-	WARN_ON_ONCE(gcwq->trustee_state == TRUSTEE_DONE &&
-		     pool->nr_workers == pool->nr_idle &&
-		     atomic_read(get_pool_nr_running(pool)));
+	if (WARN_ON_ONCE(gcwq->trustee_state == TRUSTEE_DONE &&
+			 pool->nr_workers == pool->nr_idle &&
+			 atomic_read(get_pool_nr_running(pool)))) {
+		static bool once = false;
+		int cpu;
+
+		if (once)
+			return;
+		once = true;
+
+		printk("XXX nr_running mismatch on gcwq[%d] pool[%ld]\n",
+		       gcwq->cpu, pool - gcwq->pools);
+
+		for_each_gcwq_cpu(cpu) {
+			gcwq = get_gcwq(cpu);
+
+			printk("XXX gcwq[%d] flags=0x%x\n", gcwq->cpu, gcwq->flags);
+			for_each_worker_pool(pool, gcwq)
+				printk("XXX gcwq[%d] pool[%ld] nr_workers=%d nr_idle=%d nr_running=%d\n",
+				       gcwq->cpu, pool - gcwq->pools,
+				       pool->nr_workers, pool->nr_idle,
+				       atomic_read(get_pool_nr_running(pool)));
+		}
+	}
 }
 
 /**
@@ -3855,6 +3879,10 @@ static int __init init_workqueues(void)
 		for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)
 			INIT_HLIST_HEAD(&gcwq->busy_hash[i]);
 
+		if (cpu != WORK_CPU_UNBOUND)
+			printk("XXX cpu=%d gcwq=%p base=%p\n", cpu, gcwq,
+			       per_cpu_ptr(&pool_nr_running, cpu));
+
 		for_each_worker_pool(pool, gcwq) {
 			pool->gcwq = gcwq;
 			INIT_LIST_HEAD(&pool->worklist);
@@ -3868,6 +3896,10 @@ static int __init init_workqueues(void)
 				    (unsigned long)pool);
 
 			ida_init(&pool->worker_ida);
+
+			printk("XXX cpu=%d nr_running=%d @ %p\n", gcwq->cpu,
+			       atomic_read(get_pool_nr_running(pool)),
+			       get_pool_nr_running(pool));
 		}
 
 		gcwq->trustee_state = TRUSTEE_DONE;
