Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164Ab1IVPNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 11:13:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53699 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab1IVPNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 11:13:33 -0400
Subject: Re: rt14: strace ->  migrate_disable_atomic imbalance
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, mingo <mingo@redhat.com>
Date: Thu, 22 Sep 2011 17:13:08 +0200
In-Reply-To: <20110922145257.GA13960@redhat.com>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
	 <1315835562.6758.3.camel@marge.simson.net>
	 <1315839187.6758.8.camel@marge.simson.net> <1315926499.5977.19.camel@twins>
	 <1315927699.6445.6.camel@marge.simson.net> <1315930430.5977.21.camel@twins>
	 <1316600230.6628.6.camel@marge.simson.net> <1316691967.31429.9.camel@twins>
	 <20110922145257.GA13960@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316704389.31429.24.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 16:52 +0200, Oleg Nesterov wrote:
> On 09/22, Peter Zijlstra wrote:
> >
> > +static void wait_task_inactive_sched_in(struct preempt_notifier *n, int cpu)
> > +{
> > +	struct task_struct *p;
> > +	struct wait_task_inactive_blocked *blocked =
> > +		container_of(n, struct wait_task_inactive_blocked, notifier);
> > +
> > +	hlist_del(&n->link);
> > +
> > +	p = ACCESS_ONCE(blocked->waiter);
> > +	blocked->waiter = NULL;
> > +	wake_up_process(p);
> > +}
> > ...
> > +static void
> > +wait_task_inactive_sched_out(struct preempt_notifier *n, struct task_struct *next)
> > +{
> > +	if (current->on_rq) /* we're not inactive yet */
> > +		return;
> > +
> > +	hlist_del(&n->link);
> > +	n->ops = &wait_task_inactive_ops_post;
> > +	hlist_add_head(&n->link, &next->preempt_notifiers);
> > +}
> 
> Tricky ;) Yes, the first ->sched_out() is not enough.

Not enough isn't the problem, its ran with rq->lock held and irqs
disabled, you simply cannot do ttwu() from there.

If we could, the subsequent task_rq_lock() in wait_task_inactive() would
be enough to serialize against the still in-flight context switch.

One of the problems with doing it from the next sched_in notifier, is
that next can be idle, and then we do a A -> idle -> B switch, which is
of course sub-optimal.

> >  unsigned long wait_task_inactive(struct task_struct *p, long match_state)
> >  {
> > ...
> > +	rq = task_rq_lock(p, &flags);
> > +	trace_sched_wait_task(p);
> > +	if (!p->on_rq) /* we're already blocked */
> > +		goto done;
> 
> This doesn't look right. schedule() clears ->on_rq a long before
> __switch_to/etc.

Oh, bugger, yes its before we can drop the rq for idle balance and
nonsense like that. (!p->on_rq && !p->on_cpu) should suffice I think.

> And it seems that we check ->on_cpu above, this is not UP friendly.

True, but its what the old code did.. and I was seeing performance
suckage compared to the unpatched kernel (not that the p->on_cpu busy
wait fixed it)...

> >
> > -			set_current_state(TASK_UNINTERRUPTIBLE);
> > -			schedule_hrtimeout(&to, HRTIMER_MODE_REL);
> > -			continue;
> > -		}
> > +	hlist_add_head(&blocked.notifier.link, &p->preempt_notifiers);
> > +	task_rq_unlock(rq, p, &flags);
> 
> I thought about reimplementing wait_task_inactive() too, but afaics there
> is a problem: why we can't race with p doing register_preempt_notifier() ?
> I guess register_ needs rq->lock too.

We can actually, now you mention it.. ->pi_lock would be sufficient and
less expensive to acquire.

