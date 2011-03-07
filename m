Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab1CGKYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 05:24:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59020 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab1CGKYM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 05:24:12 -0500
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4D72A302.6060008@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	 <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
	 <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
	 <20110303221353.GA10366@redhat.com>
	 <AANLkTi=MfDzf+-eLbysoP-ZiXX6cV_tVxYE14Vr8FSak@mail.gmail.com>
	 <20110304214359.GA18442@redhat.com> <4D715E8A.5070006@fusionio.com>
	 <20110304222702.GB18921@redhat.com>  <4D72A302.6060008@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 07 Mar 2011 11:23:47 +0100
Message-ID: <1299493427.2308.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-05 at 21:54 +0100, Jens Axboe wrote:
> 
> Apparently so. Peter/Ingo, please shoot this one down in flames.
> Summary:
> 
> - Need a way to trigger this flushing when a task is going to sleep
> - It's currently done right before calling deactivate_task(). We know
>   the task is going to sleep here, but it's also under the runqueue
>   lock. Not good.
> - In the new location, it's not completely clear to me whether we can
>   safely deref 'prev' or not. The usage of prev_state would seem to
>   indicate that we cannot, and as far as I can tell, prev could at this
>   point already potentially be running on another CPU.
> 
> Help? Peter, we talked about this in Tokyo in September. Initial
> suggestion was to use preempt notifiers, which we can't because:
> 
> - runqueue lock is also held
> - It's not unconditionally available, depends on config.
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index e806446..8581ad3 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2826,6 +2826,14 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
>  #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
>         finish_lock_switch(rq, prev);
>  
> +       /*
> +        * If this task has IO plugged, make sure it
> +        * gets flushed out to the devices before we go
> +        * to sleep
> +        */
> +       if (prev_state != TASK_RUNNING)
> +               blk_flush_plug(prev);
> +
>         fire_sched_in_preempt_notifiers(current);
>         if (mm)
>                 mmdrop(mm);
> @@ -3973,14 +3981,6 @@ need_resched_nonpreemptible:
>                                 if (to_wakeup)
>                                         try_to_wake_up_local(to_wakeup);
>                         }
> -                       /*
> -                        * If this task has IO plugged, make sure it
> -                        * gets flushed out to the devices before we go
> -                        * to sleep
> -                        */
> -                       blk_flush_plug(prev);
> -                       BUG_ON(prev->plug && !list_empty(&prev->plug->list));
> -
>                         deactivate_task(rq, prev, DEQUEUE_SLEEP);
>                 }
>                 switch_count = &prev->nvcsw;
> 

Right, so your new location is still under rq->lock for a number of
architectures (including x86). finish_lock_switch() doesn't actually
release the lock unless __ARCH_WANT_INTERRUPTS_ON_CTXSW ||
__ARCH_WANT_UNLOCKED_CTXSW (the former implies the latter since rq->lock
is IRQ-safe).

If you want a safe place to drop rq->lock (but keep in mind to keep IRQs
disabled there) and use prev, do something like the below. Both
pre_schedule() and idle_balance() can already drop the rq->lock do doing
it once more is quite all-right ;-)

Note that once you drop rq->lock prev->state can change to TASK_RUNNING
again so don't re-check that.

---
 kernel/sched.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 655164e..99c5637 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4120,8 +4120,12 @@ need_resched_nonpreemptible:
 		switch_count = &prev->nvcsw;
 	}
 
+	if (prev->state != TASK_RUNNING) {
+		raw_spin_unlock(&rq->lock);
+		blk_flush_plug(prev);
+		raw_spin_lock(&rq->lock);
+	}
 	pre_schedule(rq, prev);
-
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
 

