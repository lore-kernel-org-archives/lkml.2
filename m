Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483Ab1FWPH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:07:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54918 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947Ab1FWPHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:07:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=I+t95lPpgVRsJ75OiO7PXJIV97Dtq/ZCZ8qK4vpDjv5afhmJN8IVYWsP25bxBeJwVv
         vcl7SiFcvOOHM3lQuZ5PNeOc8Ex7eYSV9lNBqw1CEL8Timbvm2/7HKREND2ckK8uDrSC
         Yt8AXB3k8I9svEiJDwEvtPc1LF+LmpUqwEWFA=
Date: Thu, 23 Jun 2011 17:07:20 +0200
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] sched: Distangle worker accounting from rq->lock
Message-ID: <20110623150720.GR30101@htj.dyndns.org>
References: <20110622174659.496793734@linutronix.de>
 <20110622174919.135236139@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622174919.135236139@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

So, let's get it correct first.

On Wed, Jun 22, 2011 at 05:52:15PM -0000, Thomas Gleixner wrote:
> The worker accounting for cpu bound workers is plugged into the core
> scheduler code and the wakeup code. This is not a hard requirement and
> can be avoided by keeping track of the state in the workqueue code
> itself.
> 
> Keep track of the sleeping state in the worker itself and call the
> notifier before entering the core scheduler. There might be false
> positives when the task is woken between that call and actually
> scheduling, but that's not really different from scheduling and being
> woken immediately after switching away. There is also no harm from
> updating nr_running when the task returns from scheduling instead of
> accounting it in the wakeup code.

I think false positives on schedule() should be safe.  As said
earlier, the gap between ttwu and actually running is a bit worrisome
but it might be nothing, but please at least describe the behavior
change.

> Index: linux-2.6/kernel/workqueue.c
> ===================================================================
> --- linux-2.6.orig/kernel/workqueue.c
> +++ linux-2.6/kernel/workqueue.c
> @@ -137,6 +137,7 @@ struct worker {
>  	unsigned int		flags;		/* X: flags */
>  	int			id;		/* I: worker id */
>  	struct work_struct	rebind_work;	/* L: rebind worker to cpu */
> +	int			sleeping;	/* None */

bool?

> -struct task_struct *wq_worker_sleeping(struct task_struct *task,
> -				       unsigned int cpu)
> +void wq_worker_sleeping(struct task_struct *task)
>  {
> -	struct worker *worker = kthread_data(task), *to_wakeup = NULL;
> -	struct global_cwq *gcwq = get_gcwq(cpu);
> -	atomic_t *nr_running = get_gcwq_nr_running(cpu);
> +	struct worker *worker = kthread_data(task);
> +	struct global_cwq *gcwq;
> +	int cpu;
>  
>  	if (worker->flags & WORKER_NOT_RUNNING)
> -		return NULL;
> +		return;

This doesn't look safe.  It can race with trustee_thread() setting
WORKER_ROGUE.  Let's just grab gcwq->lock on entry to
wq_worker_sleeping() for now; then, the schedule() trickery in
trustee_thread() can go away too.  This also means we can remove the
weird sync rules from ->flags and ->idle_list and just use simple
gcwq->lock for those, which is pretty nice.

> -	/* this can only happen on the local cpu */
> -	BUG_ON(cpu != raw_smp_processor_id());
> +	if (WARN_ON_ONCE(worker->sleeping))
> +		return;

Re-entrance is prevented by the scheduler hook being called only for
non-premption schedule().  Maybe it's better to explain that in the
function comment?

Hmmm... Also, I think worker->sleeping should be cleared by
trustee_thread() when WORKER_ROGUE is set for the worker; otherwise,
it can get out of sync and the above WARN_ON_ONCE() will trigger.

Thanks.

-- 
tejun
