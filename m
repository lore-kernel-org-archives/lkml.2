Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab1LZGw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 01:52:29 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37672 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1LZGwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 01:52:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Date: Mon, 26 Dec 2011 15:52:04 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
Cc: Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1324633794.24803.48.camel@twins>
References: <20111222094241.C691.E1E9C6FF@jp.fujitsu.com> <1324633794.24803.48.camel@twins>
Message-Id: <20111226155204.CE44.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2011-12-22 at 09:42 +0900, Yasunori Goto wrote:
> > I found TASK_DEAD task is able to be woken up in special condition.
> > I would like to report this bug. Please check it.
> 
> How did you find it? Manual inspection? Inspection of a core-dump?

Original trouble occurred on a distributor's kernel which is based on 2.6.32.
Kernel called BUG() because TASK_DEAD task was scheduled again.
I chased it with trace in crash dump, and I confirmed this sequence.

In my code review, current 3.2-rc6 seems to have same problem, so I posted 
this report.


> 
> > Here is the sequence how it occurs.
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
> TASK_RUNNING. Spurious wakeups after that won't see a state to act on
> and will terminate immediately without touching state.

As Oleg-san said, raw_spin_unlock_wait() is called before exit_mm().
This race condition occurred after using rwsem of mmap_sem in exit_mm().

Thanks.

> 
> 
> > ---
> >  kernel/exit.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > Index: linux-3.2-rc4/kernel/exit.c
> > ===================================================================
> > --- linux-3.2-rc4.orig/kernel/exit.c
> > +++ linux-3.2-rc4/kernel/exit.c
> > @@ -1038,8 +1038,11 @@ NORET_TYPE void do_exit(long code)
> >  
> >         preempt_disable();
> >         exit_rcu();
> > +
> > +       spin_lock(&tsk->pi_lock, flags);
> >         /* causes final put_task_struct in finish_task_switch(). */
> >         tsk->state = TASK_DEAD;
> > +       spin_unlock(&tsk->pi_lock, flags);
> >         schedule();
> >         BUG();
> >         /* Avoid "noreturn function does return".  */ 
> 
> Note, ->pi_lock is a raw_spinlock_t, those should've been raw_spin_*().




-- 
Yasunori Goto 


