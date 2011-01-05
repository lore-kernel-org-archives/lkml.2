Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab1AEVPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 16:15:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab1AEVPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 16:15:39 -0500
Date: Wed, 5 Jan 2011 22:07:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 17/18] sched: Move the second half of ttwu() to
	the remote cpu
Message-ID: <20110105210754.GA2579@redhat.com>
References: <20110104145929.772813816@chello.nl> <20110104150103.164045216@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104150103.164045216@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04, Peter Zijlstra wrote:
>
> Now that we've removed the rq->lock requirement from the first part of
> ttwu() and can compute placement without holding any rq->lock, ensure
> we execute the second half of ttwu() on the actual cpu we want the
> task to run on.

Damn. I am reading this patch back and forth, many times, and
I am not able to find any problem. So sad!

I'll try to read it once again with the fresh head, though ;)
I also have a couple of very minor nits... In particular, perhaps
TASK_WAKING can die...

Just one question for today,

>  try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>  {
> -	int cpu, this_cpu, success = 0;
>  	unsigned long flags;
> -	struct rq *rq;
> -
> -	this_cpu = get_cpu();
> +	int cpu, success = 0;
>
>  	smp_wmb();
>  	raw_spin_lock_irqsave(&p->pi_lock, flags);
>  	if (!(p->state & state))
>  		goto out;
>
> +	success = 1; /* we're going to change ->state */
>  	cpu = task_cpu(p);
>
> -	if (p->on_rq) {
> -		rq = __task_rq_lock(p);
> -		if (p->on_rq)
> -			goto out_running;
> -		__task_rq_unlock(rq);
> -	}
> +	if (p->on_rq && ttwu_remote(p, wake_flags))
> +		goto stat;
> +
> +	p->sched_contributes_to_load = !!task_contributes_to_load(p);
> +	p->state = TASK_WAKING;
>
>  #ifdef CONFIG_SMP
> +	/*
> +	 * If the owning (remote) cpu is still in the middle of schedule() with
> +	 * this task as prev, wait until its done referencing the task.
> +	 */
>  	while (p->on_cpu)
>  		cpu_relax();

Don't we need rmb() after that?

No, I am not saying it _is_ needed. I am asking.

(but need_migrate_task() can avoid on_cpu+rmb afaics)

Oleg.

