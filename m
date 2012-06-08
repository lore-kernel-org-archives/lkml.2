Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab2FHNpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:45:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56591 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2FHNpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:45:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBDWg9Wa_4s7NBeyXy23wh4CFyKzoF83EBEm1a6w=v+KUw@mail.gmail.com>
References: <CAJd=RBDWg9Wa_4s7NBeyXy23wh4CFyKzoF83EBEm1a6w=v+KUw@mail.gmail.com>
Date: Fri, 8 Jun 2012 21:45:43 +0800
Message-ID: <CANQmPXhJEDwO97RBRb-XC+s_FMF6WSJjajj9CO4+wr8UqL5=Rg@mail.gmail.com>
Subject: Re: [patch] BFS 421: remove global runqueue lock in running tick
From: Chen <hi3766691@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still, you haven't produced any usable patch. LOL

On Fri, Jun 8, 2012 at 9:37 PM, Hillf Danton <dhillf@gmail.com> wrote:
> We simply deschedule current, with no bother grabbing global lock, since IPI,
> if triggered by preempt, could not change our result, like no schedule when
> preempt enabled.
>
>        preempt_enable_no_resched();
>        if (unlikely(need_resched()))
>                goto need_resched;
>
>
> --- a/kernel/sched/bfs.c        Wed Jun  6 21:02:50 2012
> +++ b/kernel/sched/bfs.c        Fri Jun  8 21:17:24 2012
> @@ -2784,11 +2784,13 @@ static void task_running_tick(struct rq
>        } else if (rq->rq_time_slice >= RESCHED_US)
>                        return;
>
> -       /* p->time_slice < RESCHED_US. We only modify task_struct under grq lock */
> +       /*
> +        * With irq disabled, current is descheduled without global lock
> +        * held and IPI cared.
> +        */
>        p = rq->curr;
> -       grq_lock();
> -       set_tsk_need_resched(p);
> -       grq_unlock();
> +       if (!test_tsk_need_resched(p))
> +               set_tsk_need_resched(p);
>  }
>
>
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
