Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab0CYPs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:48:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab0CYPs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:48:26 -0400
Date: Thu, 25 Mar 2010 16:46:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Blum <bblum@google.com>,
       Jiri Slaby <jirislaby@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] sched/cpusets fixes, more changes are needed
Message-ID: <20100325154616.GA9773@redhat.com>
References: <20100315090958.GA9116@redhat.com> <1269452296.5109.508.camel@twins> <20100324180912.GA21774@redhat.com> <1269512531.12097.67.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269512531.12097.67.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25, Peter Zijlstra wrote:
>
> On Wed, 2010-03-24 at 19:09 +0100, Oleg Nesterov wrote:
> > On 03/24, Peter Zijlstra wrote:
> > >
> > > On Mon, 2010-03-15 at 10:09 +0100, Oleg Nesterov wrote:
> > > >
> > > > 	- do_fork() clears PF_STARTING and then calls wake_up_new_task()
> > > > 	  which finally does s/WAKING/RUNNING.
> > > >
> > > > 	  But. Nobody can take rq->lock in between. This means a signal
> > > > 	  from irq (quite possible with CLONE_THREAD) or another rt
> > > > 	  thread which preempts us can lockup.
> > >
> > > Hmm, the signal case might indeed be a problem, however I cannot see how
> > > the RT thread can be a problem because until we do wake_up_new_task()
> > > the child will not be runnable and can thus not be preempted.
> >
> > Indeed, but I meant the _parent_ can be preempted ;)
>
> I still can't see how that would be a problem..


The parent P does do_fork(), copy_process returns the new child C with
TASK_WAKING at PF_STARTING set.

do_fork() clears PF_STARTING, but TASK_WAKING is still set, and C is
already visible to the user-space

An rt-thread X preempts P and calls ttwu() (say, it sends a signal to C)

ttwu() loops in task_rq_lock() "forever", because TASK_WAKING is still
set.

> > > The reason we have that TASK_WAKING stuff for fork is because
> > > wake_up_new_task() needs p->cpus_allowed to be stable
> >
> > Sure! But it is very easy to change wake_up_new_task() to set TASK_WAKING
> > like ttwu() does. Of course, this needs raw_spin_lock_irq(rq->lock) for
> > a moment, but afaics that is all?
>
> My patch does that.

OK, that is what I meant. Now, why sched_fork() can't just set TASK_RUNNING ?
This way the "spurious" wakeup can do nothing with the new child, and we
do not have problems with cpuset which needs rq->lock for set_cpus_allowed().

> > > So the below patch makes select_task_rq_fair unlock the rq when needed,
> > > and then puts all ->select_task_rq() calls under rq->lock.

Yes, I thought about this too. I tried to preserve the current
"->select_task_rq() is called without rq->lock" logic.

> This should
> > > allow us to remove the TASK_WAKING thing from fork

Confused. Why can't we simply remove TASK_WAKING from fork without any
changes except in wake_up_new_task() ?

> which in turn allows
> > > us to remove the PF_STARTING check in task_is_waking.

Even if I do not think I understand sched.c above, I'd say we must do
this in any case ;)

> I was still looking at removing the TASK_WAKING check from
> task_rq_lock()

Peter, I can't apply your patch due to rejects (will try again later)
but at first glance, it makes TASK_WAKING unneeded? Since we do not
drop the lock after we set TASK_WAKING, why do we need this state at
all ?

Aha... select_task_rq_fair() can drop the lock, yes? Well, in this
case probably select_task_rq_fair() can set TASK_WAKING before unlock?


I like the current idea to call select_task_rq() without rq->lock, but
of course this is up to you.

However, once again, can't we make a simpler patch?

	- remove PF_STARTING from task_waking()
	
	- change sched_fork() to set RUNNING instead of WAKING

	- change wake_up_new_task() to set WAKING under rq->lock

This looks simpler to me, and allows to drop rq->lock in ttwu() right
after it sets WAKING.

Another change which seems reasonable is to allow ttwu() to take rq->lock
even if WAKING is set, it can do nothing but check task->state in this case.

What do you think?

Oleg.

