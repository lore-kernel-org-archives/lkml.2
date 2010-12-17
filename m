Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab0LQRnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 12:43:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:36282 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab0LQRnR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 12:43:17 -0500
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101217165414.GA8997@redhat.com>
References: <20101216145602.899838254@chello.nl>
	 <20101216150920.968046926@chello.nl> <20101216184229.GA15889@redhat.com>
	 <1292525893.2708.50.camel@laptop> <1292526220.2708.55.camel@laptop>
	 <1292528874.2708.85.camel@laptop> <1292531553.2708.89.camel@laptop>
	 <20101217165414.GA8997@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Dec 2010 18:43:01 +0100
Message-ID: <1292607781.2266.295.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 17:54 +0100, Oleg Nesterov wrote:
> On 12/16, Peter Zijlstra wrote:
> >
> > It does the state and on_rq checks first, if we find on_rq,
> 
> The problem is, somehow we should check both on_rq and state
> at the same time,
> 
> > +try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
> >  {
> > -	int cpu, orig_cpu, this_cpu, success = 0;
> > +	int cpu, load, ret = 0;
> >  	unsigned long flags;
> > -	unsigned long en_flags = ENQUEUE_WAKEUP;
> > -	struct rq *rq;
> >
> > -	this_cpu = get_cpu();
> > +	smp_mb();
> 
> Yes, we need the full mb(). without subsequent spin_lock(), wmb()
> can't act as a smp_store_load_barrier() (which we don't have).
> 
> > +	if (p->se.on_rq && ttwu_force(p, state, wake_flags))
> > +		return 1;
> 
> 	----- WINDOW -----
> 
> > +	for (;;) {
> > +		unsigned int task_state = p->state;
> > +
> > +		if (!(task_state & state))
> > +			goto out;
> > +
> > +		load = task_contributes_to_load(p);
> > +
> > +		if (cmpxchg(&p->state, task_state, TASK_WAKING) == task_state)
> > +			break;
> 
> Suppose that we have a task T sleeping in TASK_INTERRUPTIBLE state,
> and this cpu does try_to_wake_up(TASK_INTERRUPTIBLE). on_rq == false.
> try_to_wake_up() starts the "for (;;)" loop.
> 
> However, in the WINDOW above, it is possible that somebody else wakes
> it up, and then this task changes its state to TASK_INTERRUPTIBLE again.
> 
> Then we set ->state = TASK_WAKING, but this (still running) T restores
> TASK_RUNNING after us.

See, there's a reason I CC'ed you ;-)

Hrmph, so is it only about serializing concurrent wakeups? If so, we
could possibly hold p->pi_lock over the wakeup.
