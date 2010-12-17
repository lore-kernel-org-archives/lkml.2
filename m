Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0LQRBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 12:01:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463Ab0LQRBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 12:01:42 -0500
Date: Fri, 17 Dec 2010 17:54:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
Message-ID: <20101217165414.GA8997@redhat.com>
References: <20101216145602.899838254@chello.nl> <20101216150920.968046926@chello.nl> <20101216184229.GA15889@redhat.com> <1292525893.2708.50.camel@laptop> <1292526220.2708.55.camel@laptop> <1292528874.2708.85.camel@laptop> <1292531553.2708.89.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292531553.2708.89.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16, Peter Zijlstra wrote:
>
> It does the state and on_rq checks first, if we find on_rq,

The problem is, somehow we should check both on_rq and state
at the same time,

> +try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>  {
> -	int cpu, orig_cpu, this_cpu, success = 0;
> +	int cpu, load, ret = 0;
>  	unsigned long flags;
> -	unsigned long en_flags = ENQUEUE_WAKEUP;
> -	struct rq *rq;
>
> -	this_cpu = get_cpu();
> +	smp_mb();

Yes, we need the full mb(). without subsequent spin_lock(), wmb()
can't act as a smp_store_load_barrier() (which we don't have).

> +	if (p->se.on_rq && ttwu_force(p, state, wake_flags))
> +		return 1;

	----- WINDOW -----

> +	for (;;) {
> +		unsigned int task_state = p->state;
> +
> +		if (!(task_state & state))
> +			goto out;
> +
> +		load = task_contributes_to_load(p);
> +
> +		if (cmpxchg(&p->state, task_state, TASK_WAKING) == task_state)
> +			break;

Suppose that we have a task T sleeping in TASK_INTERRUPTIBLE state,
and this cpu does try_to_wake_up(TASK_INTERRUPTIBLE). on_rq == false.
try_to_wake_up() starts the "for (;;)" loop.

However, in the WINDOW above, it is possible that somebody else wakes
it up, and then this task changes its state to TASK_INTERRUPTIBLE again.

Then we set ->state = TASK_WAKING, but this (still running) T restores
TASK_RUNNING after us.

Oleg.

