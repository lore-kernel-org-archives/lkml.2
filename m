Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab0LPSto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:49:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab0LPStn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:49:43 -0500
Date: Thu, 16 Dec 2010 19:42:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
Message-ID: <20101216184229.GA15889@redhat.com>
References: <20101216145602.899838254@chello.nl> <20101216150920.968046926@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101216150920.968046926@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16, Peter Zijlstra wrote:
>
> +static int ttwu_force(struct task_struct *p, int wake_flags)
> +{
> +	struct rq *rq;
> +	int ret = 0;
> +
> +	/*
> +	 * Since we've already set TASK_WAKING this task's CPU cannot
> +	 * change from under us.

I think it can. Yes, we've set TASK_WAKING. But, at least the task
itself can change its state back to TASK_RUNNING without calling
schedule. Say, __wait_event()-like code.

> +static int
> +try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>  {
> -	int cpu, orig_cpu, this_cpu, success = 0;
> +	int cpu = task_cpu(p);
>  	unsigned long flags;
> -	unsigned long en_flags = ENQUEUE_WAKEUP;
> -	struct rq *rq;
> +	int success = 0;
> +	int load;
>  
> -	this_cpu = get_cpu();
> -
> -	smp_wmb();
> -	rq = task_rq_lock(p, &flags);
> -	if (!(p->state & state))
> -		goto out;
> +	local_irq_save(flags);
> +	for (;;) {
> +		unsigned int task_state = p->state;
>  
> -	cpu = task_cpu(p);
> +		if (!(task_state & state))
> +			goto out;

Well, this surely breaks the code like

	CONDITION = true;
	wake_up_process(p);

At least we need mb() before we check task_state the first time.

Oleg.

