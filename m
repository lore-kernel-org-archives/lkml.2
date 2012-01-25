Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab2AYQvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 11:51:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44959 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab2AYQve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 11:51:34 -0500
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special
 condition
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yasunori Goto <y-goto@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120125154547.GA6671@redhat.com>
References: <20120116205140.6120.E1E9C6FF@jp.fujitsu.com>
	 <1326721082.2442.234.camel@twins>
	 <20120117174031.3118.E1E9C6FF@jp.fujitsu.com>
	 <20120117090605.GD7612@elte.hu> <20120117151242.GA13290@redhat.com>
	 <20120118094219.GE5842@elte.hu> <20120118142005.GB10105@redhat.com>
	 <1327400349.2614.10.camel@laptop> <1327402527.2614.17.camel@laptop>
	 <20120125154547.GA6671@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Jan 2012 17:51:30 +0100
Message-ID: <1327510290.2614.95.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-25 at 16:45 +0100, Oleg Nesterov wrote:
> On 01/24, Peter Zijlstra wrote:
> >
> > On Tue, 2012-01-24 at 11:19 +0100, Peter Zijlstra wrote:
> > > On Wed, 2012-01-18 at 15:20 +0100, Oleg Nesterov wrote:
> > > > do_exit() is different because it can not handle the spurious wakeup.
> > > > Well, may be we can? we can simply do
> > > >
> > > >                 for (;;) {
> > > >                         tsk->state = TASK_DEAD;
> > > >                         schedule();
> > > >                 }
> > > >
> > > > __schedule() can't race with ttwu() once it takes rq->lock. If the
> > > > exiting task is deactivated, finish_task_switch() will see EXIT_DEAD.
> > >
> > > TASK_DEAD, right?
> 
> Yes, but... I simply can't understand what I was thinking about.
> And probably I missed something again, but I think this can't work.

Oh man, total confusion. :-) Every time I look at this bug I see
different shadows on the wall.

> Afaics, this can only help to prevent the race with ttwu_remote()
> doing ttwu_do_wakeup() under rq->lock.

ttwu_do_wakeup() must always be called with rq->lock held.

> But we still can race with the !p->on_rq case which sets TASK_WAKING.
> It can do this after finish_task_switch() observes TASK_DEAD and does
> put_task_struct().

<random scribbling that got erased>

No, see below !p->on_rq isn't possible and thus pi_lock is indeed
sufficient.

> > I think Yasunori-San's patch isn't
> > sufficient, note how the p->state = TASK_RUNNING in ttwu_do_wakeup() can
> > happen outside of p->pi_lock when the task gets queued on a remote cpu.
> 
> Hmm, really? I am not sure, but I do not trust myself.
> 
> To simplify, you mean that
> 
> 	mb();
> 	unlock_wait(pi_lock);
> 
> 	tsk->state = TASK_DEAD;
> 
> can change ->state from TASK_WAKING to TASK_DEAD, right? Is this really
> possible? ttwu() ensures p->on_rq == F in this case.

Ahhh.. hold on, p->on_rq must be true, since we disabled preemption
before setting TASK_DEAD, so the thing cannot be scheduled out.

Does this mean that both Yasunori-San's solution and yours work again?

/me goes in search of a fresh mind.. shees!




