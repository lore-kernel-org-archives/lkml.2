Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab1LWJuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 04:50:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:43315 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab1LWJuQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 04:50:16 -0500
Message-ID: <1324633794.24803.48.camel@twins>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
From: Peter Zijlstra <peterz@infradead.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 23 Dec 2011 10:49:54 +0100
In-Reply-To: <20111222094241.C691.E1E9C6FF@jp.fujitsu.com>
References: <20111222094241.C691.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-22 at 09:42 +0900, Yasunori Goto wrote:
> I found TASK_DEAD task is able to be woken up in special condition.
> I would like to report this bug. Please check it.

How did you find it? Manual inspection? Inspection of a core-dump?

> Here is the sequence how it occurs.
> 
> ----------------------------------+-----------------------------
>                                   |
>            CPU A                  |             CPU B
> ----------------------------------+-----------------------------
> TASK A calls exit()....
> 
> do_exit()
> 
>   exit_mm()
>     down_read(mm->mmap_sem);
>     
>     rwsem_down_failed_common()
> 
>       set TASK_UNINTERRUPTIBLE
>       set waiter.task <= task A
>       list_add to sem->wait_list
>            :
>       raw_spin_unlock_irq()
>       (I/O interruption occured)
> 
>                                       __rwsem_do_wake(mmap_sem)
> 
>                                         list_del(&waiter->list);
>                                         waiter->task = NULL
>                                         wake_up_process(task A)
>                                           try_to_wake_up()
>                                              (task is still
>                                                TASK_UNINTERRUPTIBLE)
>                                               p->on_rq is still 1.)
> 
>                                               ttwu_do_wakeup()
>                                                  (*A)
>                                                    :
>      (I/O interruption handler finished)
> 
>       if (!waiter.task) 
>           schedule() is not called
>           due to waiter.task is NULL.
>       
>       tsk->state = TASK_RUNNING
> 
>           :
>                                               check_preempt_curr();
>                                                   :
>   task->state = TASK_DEAD
>                                               (*B)
>                                         <---    set TASK_RUNNING (*C)
> 
> 
> 
>      schedule()
>      (exit task is running again)
>      BUG_ON() is called!
> --------------------------------------------------------

<snip>

> This is very bad senario.
> But, I suppose this phenomenon is able to occur on a guest system of
> virtual machine too.
> 
> Please fix it.
> 
> I suppose task->pi_lock should be held when task->state is changed to 
> TASK_DEAD like the following patch (not tested yet).
> Because try_to_wake_up() hold it before checking task state.

I don't think this can actually happen, note the raw_spin_unlock_wait()
in do_exit() long before setting TASK_DEAD, that should synchronize
against the in-progress wakeup and ensure its finished and has set
TASK_RUNNING. Spurious wakeups after that won't see a state to act on
and will terminate immediately without touching state.


> ---
>  kernel/exit.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-3.2-rc4/kernel/exit.c
> ===================================================================
> --- linux-3.2-rc4.orig/kernel/exit.c
> +++ linux-3.2-rc4/kernel/exit.c
> @@ -1038,8 +1038,11 @@ NORET_TYPE void do_exit(long code)
>  
>         preempt_disable();
>         exit_rcu();
> +
> +       spin_lock(&tsk->pi_lock, flags);
>         /* causes final put_task_struct in finish_task_switch(). */
>         tsk->state = TASK_DEAD;
> +       spin_unlock(&tsk->pi_lock, flags);
>         schedule();
>         BUG();
>         /* Avoid "noreturn function does return".  */ 

Note, ->pi_lock is a raw_spinlock_t, those should've been raw_spin_*().
