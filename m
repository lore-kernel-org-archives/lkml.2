Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab1LVCOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 21:14:21 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:51383 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab1LVCOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 21:14:18 -0500
Message-ID: <4EF29276.5050309@gmail.com>
Date: Wed, 21 Dec 2011 21:14:14 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
References: <20111222094241.C691.E1E9C6FF@jp.fujitsu.com>
In-Reply-To: <20111222094241.C691.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/21/11 7:42 PM), Yasunori Goto wrote:
>
> Hello
>
> I found TASK_DEAD task is able to be woken up in special condition.
> I would like to report this bug. Please check it.
>
> Here is the sequence how it occurs.
>
> ----------------------------------+-----------------------------
>                                    |
>             CPU A                  |             CPU B
> ----------------------------------+-----------------------------
> TASK A calls exit()....
>
> do_exit()
>
>    exit_mm()
>      down_read(mm->mmap_sem);
>
>      rwsem_down_failed_common()
>
>        set TASK_UNINTERRUPTIBLE
>        set waiter.task<= task A
>        list_add to sem->wait_list
>             :
>        raw_spin_unlock_irq()
>        (I/O interruption occured)
>
>                                        __rwsem_do_wake(mmap_sem)
>
>                                          list_del(&waiter->list);
>                                          waiter->task = NULL
>                                          wake_up_process(task A)
>                                            try_to_wake_up()
>                                               (task is still
>                                                 TASK_UNINTERRUPTIBLE)
>                                                p->on_rq is still 1.)
>
>                                                ttwu_do_wakeup()
>                                                   (*A)
>                                                     :
>       (I/O interruption handler finished)
>
>        if (!waiter.task)
>            schedule() is not called
>            due to waiter.task is NULL.
>
>        tsk->state = TASK_RUNNING
>
>            :
>                                                check_preempt_curr();
>                                                    :
>    task->state = TASK_DEAD
>                                                (*B)
>                                          <---    set TASK_RUNNING (*C)
>
>
>
>       schedule()
>       (exit task is running again)
>       BUG_ON() is called!
> --------------------------------------------------------
>
>
> You probably think that execution time between (*A) and (*B) is very short,
> because the interruption is disabled, and setting TASK_RUNNING at (*C)
> must be executed before setting TASK_DEAD.
>
>
> HOWEVER, if SMI is interrupted between (*A) and (*B),
> (*C) is able to execute AFTER setting TASK_DEAD!
> Then, exited task is scheduled again, and BUG_ON() is called....
>
> This is very bad senario.
> But, I suppose this phenomenon is able to occur on a guest system of
> virtual machine too.
>
> Please fix it.
>
> I suppose task->pi_lock should be held when task->state is changed to
> TASK_DEAD like the following patch (not tested yet).
> Because try_to_wake_up() hold it before checking task state.
>
>
> Thanks,
>
> ----
> Signed-off-by: Yasunori Goto<y-goto@jp.fujitsu.com>
>
> ---
>   kernel/exit.c |    3 +++
>   1 file changed, 3 insertions(+)
>
> Index: linux-3.2-rc4/kernel/exit.c
> ===================================================================
> --- linux-3.2-rc4.orig/kernel/exit.c
> +++ linux-3.2-rc4/kernel/exit.c
> @@ -1038,8 +1038,11 @@ NORET_TYPE void do_exit(long code)
>
>   	preempt_disable();
>   	exit_rcu();
> +
> +	spin_lock(&tsk->pi_lock, flags);
>   	/* causes final put_task_struct in finish_task_switch(). */
>   	tsk->state = TASK_DEAD;
> +	spin_unlock(&tsk->pi_lock, flags);
>   	schedule();
>   	BUG();
>   	/* Avoid "noreturn function does return".  */

I doubt it is not only TASK_DEAD issue, it is rwsem fundamental issue.
Because of, a lot of place assume "current->state = newstate" is safe
and don't need any synchronization. So, I'm worry about to lost 
TASK_UNINTERRUPTIBLE can make catastrophe like TASK_DEAD.

How about following patch? anyway, rwsem_down_failed_common() is 
definitely slowpath. so killing micro optimization is not so much
problem, I guess.



diff --git a/lib/rwsem.c b/lib/rwsem.c
index 410aa11..e2a0c9a 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -208,9 +208,9 @@ rwsem_down_failed_common(struct rw_semaphore *sem,

         /* wait to be given the lock */
         for (;;) {
+               schedule();
                 if (!waiter.task)
                         break;
-               schedule();
                 set_task_state(tsk, TASK_UNINTERRUPTIBLE);
         }




