Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab1LVIW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:22:26 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47055 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab1LVIWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:22:24 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Date: Thu, 22 Dec 2011 17:22:11 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <4EF29276.5050309@gmail.com>
References: <20111222094241.C691.E1E9C6FF@jp.fujitsu.com> <4EF29276.5050309@gmail.com>
Message-Id: <20111222172211.C6A8.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your response.


> > ----
> > Signed-off-by: Yasunori Goto<y-goto@jp.fujitsu.com>
> >
> > ---
> >   kernel/exit.c |    3 +++
> >   1 file changed, 3 insertions(+)
> >
> > Index: linux-3.2-rc4/kernel/exit.c
> > ===================================================================
> > --- linux-3.2-rc4.orig/kernel/exit.c
> > +++ linux-3.2-rc4/kernel/exit.c
> > @@ -1038,8 +1038,11 @@ NORET_TYPE void do_exit(long code)
> >
> >   	preempt_disable();
> >   	exit_rcu();
> > +
> > +	spin_lock(&tsk->pi_lock, flags);
> >   	/* causes final put_task_struct in finish_task_switch(). */
> >   	tsk->state = TASK_DEAD;
> > +	spin_unlock(&tsk->pi_lock, flags);
> >   	schedule();
> >   	BUG();
> >   	/* Avoid "noreturn function does return".  */
> 
> I doubt it is not only TASK_DEAD issue, it is rwsem fundamental issue.
> Because of, a lot of place assume "current->state = newstate" is safe
> and don't need any synchronization. So, I'm worry about to lost 
> TASK_UNINTERRUPTIBLE can make catastrophe like TASK_DEAD.

I don't understand why this is catastrophe.
I suppose it is just waken up from TASK_UNINTERRUPTIBLE
by try_to_wake_up() in race condition. It seems to be normal situation.....

But TASK_DEAD status is special. It must not return to TASK_RUNNING state.

> 
> How about following patch? anyway, rwsem_down_failed_common() is 
> definitely slowpath. so killing micro optimization is not so much
> problem, I guess.
> 
> 
> 
> diff --git a/lib/rwsem.c b/lib/rwsem.c
> index 410aa11..e2a0c9a 100644
> --- a/lib/rwsem.c
> +++ b/lib/rwsem.c
> @@ -208,9 +208,9 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
> 
>          /* wait to be given the lock */
>          for (;;) {
> +               schedule();
>                  if (!waiter.task)
>                          break;
> -               schedule();
>                  set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>          }
> 

Hmmmmmmm.
Are you sure there is no route which TASK_DEAD task is waken up like rwsem?


Thanks.
-- 
Yasunori Goto 


