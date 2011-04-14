Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab1DNDOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 23:14:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46295 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758639Ab1DNDOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 23:14:47 -0400
Date: Thu, 14 Apr 2011 13:14:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20110414131440.fb8dc3ad.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in kernel/sched.c
between commit 6631e635c65d ("block: don't flush plugged IO on forced
preemtion scheduling") from Linus' tree and commits 098247b90a9e ("sched:
Provide p->on_rq") and a3380736e4b3 ("sched: Also serialize ttwu_local()
with p->pi_lock") from the tip tree.

I fixed them up (hopefully - see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/sched.c
index a187c3f,3e99c42..0000000
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@@ -4103,30 -4184,31 +4184,31 @@@ need_resched
  			 * task to maintain concurrency.  If so, wake
  			 * up the task.
  			 */
- 			if (prev->flags & PF_WQ_WORKER) {
- 				struct task_struct *to_wakeup;
- 
+ 			if (prev->flags & PF_WQ_WORKER)
  				to_wakeup = wq_worker_sleeping(prev, cpu);
- 				if (to_wakeup)
- 					try_to_wake_up_local(to_wakeup);
- 			}
  			deactivate_task(rq, prev, DEQUEUE_SLEEP);
+ 			prev->on_rq = 0;
 +
 +			/*
 +			 * If we are going to sleep and we have plugged IO queued, make
 +			 * sure to submit it to avoid deadlocks.
 +			 */
 +			if (blk_needs_flush_plug(prev)) {
 +				raw_spin_unlock(&rq->lock);
 +				blk_flush_plug(prev);
 +				raw_spin_lock(&rq->lock);
 +			}
  		}
  		switch_count = &prev->nvcsw;
  	}
  
+ 	/*
 -	 * If we are going to sleep and we have plugged IO queued, make
 -	 * sure to submit it to avoid deadlocks.
 -	 */
 -	if (prev->state != TASK_RUNNING && blk_needs_flush_plug(prev)) {
 -		raw_spin_unlock(&rq->lock);
 -		blk_flush_plug(prev);
 -		raw_spin_lock(&rq->lock);
 -	}
 -
 -	/*
+ 	 * All three: try_to_wake_up_local(), pre_schedule() and idle_balance()
+ 	 * can drop rq->lock.
+ 	 */
+ 	if (to_wakeup)
+ 		try_to_wake_up_local(to_wakeup);
  	pre_schedule(rq, prev);
- 
  	if (unlikely(!rq->nr_running))
  		idle_balance(cpu, rq);
  
