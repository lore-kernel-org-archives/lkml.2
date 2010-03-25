Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0CYKWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:22:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59444 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab0CYKWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:22:16 -0400
Subject: Re: [PATCH 0/6] sched/cpusets fixes, more changes are needed
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Blum <bblum@google.com>,
       Jiri Slaby <jirislaby@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100324180912.GA21774@redhat.com>
References: <20100315090958.GA9116@redhat.com>
	 <1269452296.5109.508.camel@twins>  <20100324180912.GA21774@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 11:22:11 +0100
Message-ID: <1269512531.12097.67.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 19:09 +0100, Oleg Nesterov wrote:
> On 03/24, Peter Zijlstra wrote:
> >
> > On Mon, 2010-03-15 at 10:09 +0100, Oleg Nesterov wrote:
> > >
> > > 	- do_fork() clears PF_STARTING and then calls wake_up_new_task()
> > > 	  which finally does s/WAKING/RUNNING.
> > >
> > > 	  But. Nobody can take rq->lock in between. This means a signal
> > > 	  from irq (quite possible with CLONE_THREAD) or another rt
> > > 	  thread which preempts us can lockup.
> >
> > Hmm, the signal case might indeed be a problem, however I cannot see how
> > the RT thread can be a problem because until we do wake_up_new_task()
> > the child will not be runnable and can thus not be preempted.
> 
> Indeed, but I meant the _parent_ can be preempted ;)

I still can't see how that would be a problem..

> In short. TASK_WAKING acts as a spinlock in fact. And since ttwu() can
> be called from any context, it should be irq-safe: any owner must disable
> inerrupts and preemption.

Agreed, and I think that's corrected with my patch.

> > The reason we have that TASK_WAKING stuff for fork is because
> > wake_up_new_task() needs p->cpus_allowed to be stable
> 
> Sure! But it is very easy to change wake_up_new_task() to set TASK_WAKING
> like ttwu() does. Of course, this needs raw_spin_lock_irq(rq->lock) for
> a moment, but afaics that is all?

My patch does that.

> > So the below patch makes select_task_rq_fair unlock the rq when needed,
> > and then puts all ->select_task_rq() calls under rq->lock. This should
> > allow us to remove the TASK_WAKING thing from fork which in turn allows
> > us to remove the PF_STARTING check in task_is_waking.
> >
> > How does that look?
> 
> I'll try to read this patch tomorrow. But could you please consider
> the suggestion above?

I think I do all those :-)

I was still looking at removing the TASK_WAKING check from
task_rq_lock() since now we do set_task_cpu() under rq->lock again so it
should be good again.

Hmm, except for sched_fork() that still does set_task_cpu() without
holding rq->lock, but that is before the child gets exposed so there
should not be any concurrency.

