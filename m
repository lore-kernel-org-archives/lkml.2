Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab0LNDmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 22:42:32 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:48453 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752607Ab0LNDmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 22:42:31 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18WRsM1014WSq+x/IgK8DztgvxZ/5T2Y8srV1QHw2
	IkODSWojI3IaiN
Subject: Re: [PATCH RFC] reduce runqueue lock contention
From: Mike Galbraith <efault@gmx.de>
To: frank.rowand@am.sony.com
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Chris Mason <chris.mason@oracle.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, tglx <tglx@linutronix.de>
In-Reply-To: <4D06D968.9070004@am.sony.com>
References: <20100520204810.GA19188@think>
	 <1277114522.1875.469.camel@laptop>  <1277117647.1875.503.camel@laptop>
	 <1277125479.1875.510.camel@laptop>  <4D06D968.9070004@am.sony.com>
Content-Type: text/plain
Date: Tue, 14 Dec 2010 04:42:25 +0100
Message-Id: <1292298145.7448.38.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 18:41 -0800, Frank Rowand wrote:
> On 06/21/10 06:04, Peter Zijlstra wrote:
> > On Mon, 2010-06-21 at 12:54 +0200, Peter Zijlstra wrote:
> >>> It looses the ttwu task_running() check, as I must admit I'm not quite
> >>> sure what it does.. Ingo?
> > 
> > I think I figured out what its for, its for when p is prev in schedule()
> > after deactivate_task(), we have to call activate_task() it again, but
> > we cannot migrate the task because the CPU its on is still referencing
> > it.
> 
> I have not been able to make sense of the task_running() check in
> try_to_wake_up(), even with that clue.  The try_to_wake_up() code in
> question is:
> 
>         rq = task_rq_lock(p, &flags);
>         if (!(p->state & state))
>                 goto out;
> 
>         if (p->se.on_rq)
>                 goto out_running;
> 
>         cpu = task_cpu(p);
>         orig_cpu = cpu;
> 
> #ifdef CONFIG_SMP
>         if (unlikely(task_running(rq, p)))
>                 goto out_activate;
> 
> 
> The relevent code in schedule() executes with the rq lock held (many
> lines left out to emphasize the key lines):
> 
>         raw_spin_lock_irq(&rq->lock);
> 
>         if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
> 
>                        deactivate_task(rq, prev, DEQUEUE_SLEEP);
> 
>         if (likely(prev != next)) {
>                 rq->curr = next;
>                 context_switch(rq, prev, next); /* unlocks the rq */
>         } else
>                 raw_spin_unlock_irq(&rq->lock);
> 
> 
> If (p->se.on_rq) can becomes false due to deactivate_task()
> then task_running() will also become false while the rq lock is still
> held (either via "rq->curr = next" or via context_switch() updating
> p->oncpu -- which one matters depends on #ifdef __ARCH_WANT_UNLOCKED_CTXSW).
> 
> I  haven't been able to find any case where task_running() can be true
> when (p->se.on_rq) is false, while the rq lock is not being held.  Thus
> I don't think the branch to out_activate will ever be taken.
> 
> What am I missing, or is the task_running() test not needed?

Say the last runnable task passes through schedule(), is deactivated.
We hit idle_balance(), which drops/retakes rq->lock _before_ the task
schedules off.  ttwu() can acquire rq->lock in that window, p->se.on_rq
is false, p->state is true, as is task_current(rq, p).

We have to check whether the task is still current, but not enqueued,
lest the wakeup be a noop, and the wakee possibly then sleep forever.

	-Mike

