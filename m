Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab2AYRuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 12:50:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756429Ab2AYRuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 12:50:08 -0500
Date: Wed, 25 Jan 2012 18:43:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yasunori Goto <y-goto@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special
	condition
Message-ID: <20120125174330.GA23303@redhat.com>
References: <1326721082.2442.234.camel@twins> <20120117174031.3118.E1E9C6FF@jp.fujitsu.com> <20120117090605.GD7612@elte.hu> <20120117151242.GA13290@redhat.com> <20120118094219.GE5842@elte.hu> <20120118142005.GB10105@redhat.com> <1327400349.2614.10.camel@laptop> <1327402527.2614.17.camel@laptop> <20120125154547.GA6671@redhat.com> <1327510290.2614.95.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327510290.2614.95.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25, Peter Zijlstra wrote:
>
> On Wed, 2012-01-25 at 16:45 +0100, Oleg Nesterov wrote:
> > > > >
> > > > >                 for (;;) {
> > > > >                         tsk->state = TASK_DEAD;
> > > > >                         schedule();
> > > > >                 }
> > > > >
> > > > > __schedule() can't race with ttwu() once it takes rq->lock. If the
> > > > > exiting task is deactivated, finish_task_switch() will see EXIT_DEAD.
> > > >
> > > > TASK_DEAD, right?
> >
> > Yes, but... I simply can't understand what I was thinking about.
> > And probably I missed something again, but I think this can't work.
>
> Oh man, total confusion. :-) Every time I look at this bug I see
> different shadows on the wall.

Same here ;)

And this time I do not understand your reply.

> > Afaics, this can only help to prevent the race with ttwu_remote()
> > doing ttwu_do_wakeup() under rq->lock.
>
> ttwu_do_wakeup() must always be called with rq->lock held.

Yes sure. I meant the code above can't race with p->on_rq == T case.

> > But we still can race with the !p->on_rq case which sets TASK_WAKING.
> > It can do this after finish_task_switch() observes TASK_DEAD and does
> > put_task_struct().
>
> <random scribbling that got erased>
>
> No, see below !p->on_rq isn't possible and thus pi_lock is indeed
> sufficient.

Which pi_lock? __schedule() doesn't take it. Hmm, see below...

> > > I think Yasunori-San's patch isn't
> > > sufficient, note how the p->state = TASK_RUNNING in ttwu_do_wakeup() can
> > > happen outside of p->pi_lock when the task gets queued on a remote cpu.
> >
> > Hmm, really? I am not sure, but I do not trust myself.
> >
> > To simplify, you mean that
> >
> > 	mb();
> > 	unlock_wait(pi_lock);
> >
> > 	tsk->state = TASK_DEAD;
> >
> > can change ->state from TASK_WAKING to TASK_DEAD, right? Is this really
> > possible? ttwu() ensures p->on_rq == F in this case.
>
> Ahhh.. hold on, p->on_rq must be true, since we disabled preemption
> before setting TASK_DEAD, so the thing cannot be scheduled out.

Why? __schedule() checks "preempt_count() & PREEMPT_ACTIVE". And it
should be scheduled out, in general this task struct will be freed soon.

> Does this mean that both Yasunori-San's solution and yours work again?

I think that Yasunori-San's solution should work.

But,

> /me goes in search of a fresh mind.. shees!

Yes! I need the fresh head too. Probably just to realize I was completely
wrong again.

Oleg.

