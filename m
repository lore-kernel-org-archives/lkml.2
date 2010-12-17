Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab0LQSZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 13:25:17 -0500
Received: from canuck.infradead.org ([134.117.69.58]:35911 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab0LQSZP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 13:25:15 -0500
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101217175013.GB8997@redhat.com>
References: <20101216145602.899838254@chello.nl>
	 <20101216150920.968046926@chello.nl> <20101216184229.GA15889@redhat.com>
	 <1292525893.2708.50.camel@laptop> <1292526220.2708.55.camel@laptop>
	 <1292528874.2708.85.camel@laptop> <1292531553.2708.89.camel@laptop>
	 <20101217165414.GA8997@redhat.com>  <20101217175013.GB8997@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Dec 2010 19:24:57 +0100
Message-ID: <1292610297.2266.334.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 18:50 +0100, Oleg Nesterov wrote:
> On 12/17, Oleg Nesterov wrote:
> >
> > On 12/16, Peter Zijlstra wrote:
> > >
> > > +	if (p->se.on_rq && ttwu_force(p, state, wake_flags))
> > > +		return 1;
> >
> > 	----- WINDOW -----
> >
> > > +	for (;;) {
> > > +		unsigned int task_state = p->state;
> > > +
> > > +		if (!(task_state & state))
> > > +			goto out;
> > > +
> > > +		load = task_contributes_to_load(p);
> > > +
> > > +		if (cmpxchg(&p->state, task_state, TASK_WAKING) == task_state)
> > > +			break;
> >
> > Suppose that we have a task T sleeping in TASK_INTERRUPTIBLE state,
> > and this cpu does try_to_wake_up(TASK_INTERRUPTIBLE). on_rq == false.
> > try_to_wake_up() starts the "for (;;)" loop.
> >
> > However, in the WINDOW above, it is possible that somebody else wakes
> > it up, and then this task changes its state to TASK_INTERRUPTIBLE again.
> >
> > Then we set ->state = TASK_WAKING, but this (still running) T restores
> > TASK_RUNNING after us.
> 
> Even simpler. This can race with, say, __migrate_task() which does
> deactivate_task + activate_task and temporary clears on_rq. Although
> this is simple to fix, I think.

Yes, another hole..

> Also. Afaics, without rq->lock, we can't trust "while (p->oncpu)", at
> least we need rmb() after that.

I think Linus once argued that loops like that should be fine without a
rmb(), at worst they'll have to spin a few more times to observe the
1->0 switch (we don't care about the 0->1 switch in this case because
that's ruled out by the ->state test).

> Interestingly, I can't really understand the current meaning of smp_wmb()
> in finish_lock_switch(). Do you know what exactly is buys? 

I _think_ its meant to ensure the full contest switch happened and we've
stored all changes to the rq structure (destroying all references to
prev), in particular, we've finished writing the new value of current.

> In any case,
> task_running() (or its callers) do not have the corresponding rmb().
> Say, currently try_to_wake_up()->task_waking() can miss all changes
> starting from prepare_lock_switch(). Hopefully this is OK, but I am
> confused ;)

So I thought I saw how we are OK there, but then I got myself confused
too :-)

My argument was something along the lines of there must be some
serialization between the task going to sleep and another task waking it
(the task setting TASK_UNINTERRUPTIBLE and enqueuing it on a waitqueue,
and the waker finding it on the waitqueue), this should be sufficient to
make ->state visible to the waker.

If the waker observes a !TASK_RUNNING ->state, then by definition it
must see all the changes previous to it (including the ->oncpu 0->1
transition).

But like said, got my brain in a twist too.
