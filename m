Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab0LQTfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:35:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab0LQTfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:35:36 -0500
Date: Fri, 17 Dec 2010 20:28:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
Message-ID: <20101217192814.GA16133@redhat.com>
References: <20101216145602.899838254@chello.nl> <20101216150920.968046926@chello.nl> <20101216184229.GA15889@redhat.com> <1292525893.2708.50.camel@laptop> <1292526220.2708.55.camel@laptop> <1292528874.2708.85.camel@laptop> <1292531553.2708.89.camel@laptop> <20101217165414.GA8997@redhat.com> <1292607781.2266.295.camel@twins> <1292609740.2266.323.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292609740.2266.323.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17, Peter Zijlstra wrote:
>
> By fully serializing all wakeups using ->pi_lock it becomes a lot
> simpler

Hmm, yes. Contrary to my expectations ;)

> static int
> try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
> {
>         unsigned long flags;
>         int cpu, ret = 0;
>
>         smp_wmb();
>         raw_spin_lock_irqsave(&p->pi_lock, flags);
>
>         if (!(p->state & state))
>                 goto unlock;
>
>         ret = 1; /* we qualify as a proper wakeup now */
>
>         if (p->se.on_rq && ttwu_force(p, state, wake_flags))
>                 goto unlock;

Well. All I can say, I'll try to re-read this code with the fresh head ;)
We should ensure that on_rq == 0 can not be racy.

>         p->state = TASK_WAKING;
>         smp_wmb();
>         raw_spin_unlock_wait(&task_rq(p)->lock);

This needs smp_mb(), unlock_wait() reads the memory.

Oleg.

