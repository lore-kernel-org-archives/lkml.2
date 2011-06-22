Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab1FVJYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:24:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33806 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab1FVJYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:24:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TdAjjVb7RQcI8fir9qHoamywREkHMA9ZeyvoQ2o30jVUjgO40O8DQAg8RrEXaaPF96
         z8fjjUmLhamjiLEQSVVlZsTPDF1jQMp3wWKvanCyhxpyMXeGQaw7o8QH00ISQUG6W2Y2
         RF6ga/8dVzOEv0mZOZKbMgvlC1pZL217pNJX0=
Date: Wed, 22 Jun 2011 11:24:30 +0200
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [RFC][PATCH 2/3] sched, workqueue: Move WQ-sleeper wakeup
Message-ID: <20110622092430.GA30101@htj.dyndns.org>
References: <20110621233444.094372367@chello.nl>
 <20110621233648.861571721@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621233648.861571721@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Wed, Jun 22, 2011 at 01:34:46AM +0200, Peter Zijlstra wrote:
> -/**
>   * wake_up_process - Wake up a specific process
>   * @p: The process to be woken up.
>   *
> @@ -4215,6 +4181,19 @@ static inline void sched_submit_work(voi
>  
>  	if (tsk->state && !(preempt_count() & PREEMPT_ACTIVE)) {
>  		/*
> +		 * If a worker went to sleep, notify and ask workqueue
> +		 * whether it wants to wake up a task to maintain
> +		 * concurrency.
> +		 */
> +		if (tsk->flags & PF_WQ_WORKER) {
> +			struct task_struct *to_wakeup;
> +
> +			to_wakeup = wq_worker_sleeping(tsk, smp_processor_id());
> +			if (to_wakeup)
> +				wake_up_process(to_wakeup);
> +		}
> +
> +		/*

Preemption could still be enabled here, right?  What prevents
preemtion kicking after wq_worker_sleeping() and do it again thus
breaking nr_running tracking.

>  		 * If we are going to sleep and we have plugged IO
>  		 * queued, make sure to submit it to avoid deadlocks.
>  		 */
> @@ -4256,19 +4235,6 @@ asmlinkage void __sched schedule(void)
>  		} else {
>  			deactivate_task(rq, prev, DEQUEUE_SLEEP);
>  			prev->on_rq = 0;
> -
> -			/*
> -			 * If a worker went to sleep, notify and ask workqueue
> -			 * whether it wants to wake up a task to maintain
> -			 * concurrency.
> -			 */
> -			if (prev->flags & PF_WQ_WORKER) {
> -				struct task_struct *to_wakeup;
> -
> -				to_wakeup = wq_worker_sleeping(prev, cpu);
> -				if (to_wakeup)
> -					try_to_wake_up_local(to_wakeup);
> -			}

Similarly, the if the 'if {}' part of the above if/else is taken, the
task never goes to sleep and nr_running will again be broken.

-- 
tejun
