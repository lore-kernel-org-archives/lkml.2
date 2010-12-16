Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab0LPS62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:58:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:44414 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab0LPS61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:58:27 -0500
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101216184229.GA15889@redhat.com>
References: <20101216145602.899838254@chello.nl>
	 <20101216150920.968046926@chello.nl>  <20101216184229.GA15889@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Dec 2010 19:58:13 +0100
Message-ID: <1292525893.2708.50.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 19:42 +0100, Oleg Nesterov wrote:
> On 12/16, Peter Zijlstra wrote:
> >
> > +static int ttwu_force(struct task_struct *p, int wake_flags)
> > +{
> > +	struct rq *rq;
> > +	int ret = 0;
> > +
> > +	/*
> > +	 * Since we've already set TASK_WAKING this task's CPU cannot
> > +	 * change from under us.
> 
> I think it can. Yes, we've set TASK_WAKING. But, at least the task
> itself can change its state back to TASK_RUNNING without calling
> schedule. Say, __wait_event()-like code.

Oh crud, you're right, that's going to make all this cmpxchg stuff lots
more interesting :/

> > +static int
> > +try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
> >  {
> > -	int cpu, orig_cpu, this_cpu, success = 0;
> > +	int cpu = task_cpu(p);
> >  	unsigned long flags;
> > -	unsigned long en_flags = ENQUEUE_WAKEUP;
> > -	struct rq *rq;
> > +	int success = 0;
> > +	int load;
> >  
> > -	this_cpu = get_cpu();
> > -
> > -	smp_wmb();
> > -	rq = task_rq_lock(p, &flags);
> > -	if (!(p->state & state))
> > -		goto out;
> > +	local_irq_save(flags);
> > +	for (;;) {
> > +		unsigned int task_state = p->state;
> >  
> > -	cpu = task_cpu(p);
> > +		if (!(task_state & state))
> > +			goto out;
> 
> Well, this surely breaks the code like
> 
> 	CONDITION = true;
> 	wake_up_process(p);
> 
> At least we need mb() before we check task_state the first time.

You're right (wmb, at least), I left that out because I had the cmpxchg
in there that provides a mb, but didn't notice I read the state before
that.. /me goes put the smp_wmb() back.
