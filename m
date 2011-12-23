Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab1LWPr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 10:47:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab1LWPrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 10:47:25 -0500
Date: Fri, 23 Dec 2011 16:41:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special
	condition
Message-ID: <20111223154137.GA27901@redhat.com>
References: <20111222094241.C691.E1E9C6FF@jp.fujitsu.com> <1324633794.24803.48.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324633794.24803.48.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23, Peter Zijlstra wrote:
>
> On Thu, 2011-12-22 at 09:42 +0900, Yasunori Goto wrote:
> >
> > ----------------------------------+-----------------------------
> >                                   |
> >            CPU A                  |             CPU B
> > ----------------------------------+-----------------------------
> > TASK A calls exit()....
> >
> > do_exit()
> >
> >   exit_mm()
> >     down_read(mm->mmap_sem);
> >
> >     rwsem_down_failed_common()
> >
> >       set TASK_UNINTERRUPTIBLE
> >       set waiter.task <= task A
> >       list_add to sem->wait_list
> >            :
> >       raw_spin_unlock_irq()
> >       (I/O interruption occured)
> >
> >                                       __rwsem_do_wake(mmap_sem)
> >
> >                                         list_del(&waiter->list);
> >                                         waiter->task = NULL
> >                                         wake_up_process(task A)
> >                                           try_to_wake_up()
> >                                              (task is still
> >                                                TASK_UNINTERRUPTIBLE)
> >                                               p->on_rq is still 1.)
> >
> >                                               ttwu_do_wakeup()
> >                                                  (*A)
> >                                                    :
> >      (I/O interruption handler finished)
> >
> >       if (!waiter.task)
> >           schedule() is not called
> >           due to waiter.task is NULL.
> >
> >       tsk->state = TASK_RUNNING
> >
> >           :
> >                                               check_preempt_curr();
> >                                                   :
> >   task->state = TASK_DEAD
> >                                               (*B)
> >                                         <---    set TASK_RUNNING (*C)
> >
> >
> >
> >      schedule()
> >      (exit task is running again)
> >      BUG_ON() is called!
> > --------------------------------------------------------
>
> <snip>
>
> > This is very bad senario.
> > But, I suppose this phenomenon is able to occur on a guest system of
> > virtual machine too.
> >
> > Please fix it.
> >
> > I suppose task->pi_lock should be held when task->state is changed to
> > TASK_DEAD like the following patch (not tested yet).
> > Because try_to_wake_up() hold it before checking task state.
>
> I don't think this can actually happen, note the raw_spin_unlock_wait()
> in do_exit() long before setting TASK_DEAD, that should synchronize
> against the in-progress wakeup and ensure its finished and has set
> TASK_RUNNING.

How? raw_spin_unlock_wait() is calles before exit_mm(), then the exiting
task plays with its ->state.

IIRC, this was already discussed a bit. Say, try_to_wake_up(TASK_INTERRUPTIBLE)
can wakeup a TASK_UNINTERRUPTIBLE task if it temporary sets INTERRUPTIBLE but
doesn't call schedule() in this state.

May be ttwu_do_wakeup() should do cmpxchg(old_state, RUNNING) ?

Oleg.

