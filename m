Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab1LMMY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 07:24:58 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46087 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab1LMMYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 07:24:54 -0500
MIME-Version: 1.0
In-Reply-To: <20111213155933.36cd824a.nishimura@mxp.nes.nec.co.jp>
References: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp> <20111213155933.36cd824a.nishimura@mxp.nes.nec.co.jp>
From: Paul Turner <pjt@google.com>
Date: Tue, 13 Dec 2011 04:24:23 -0800
Message-ID: <CAPM31R+Q2x2Mv+RGW+Yp11p=aB3aX8=jVT1OvSwHT2NFRcakqA@mail.gmail.com>
Subject: Re: [PATCH 3/3] sched: fix cgroup movement of waking process
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 10:59 PM, Daisuke Nishimura
<nishimura@mxp.nes.nec.co.jp> wrote:
> There is a small race between try_to_wake_up() and sched_move_task(), which is trying
> to move the process being woken up.
>
>    try_to_wake_up() on CPU0       sched_move_task() on CPU1
> --------------------------------+---------------------------------
>  raw_spin_lock_irqsave(p->pi_lock)
>  task_waking_fair()
>    ->p.se.vruntime -= cfs_rq->min_vruntime
>  ttwu_queue()
>    ->send reschedule IPI to another CPU1
>  raw_spin_unlock_irqsave(p->pi_lock)
>                                   task_rq_lock()
>                                     -> tring to aquire both p->pi_lock and rq->lock
>                                        with IRQ disabled
>                                   task_move_group_fair()
>                                     ->p.se.vruntime -= (old)cfs_rq->min_vruntime
>                                     ->p.se.vruntime += (new)cfs_rq->min_vruntime
>                                   task_rq_unlock()
>
>                                   (via IPI)
>                                   sched_ttwu_pending()
>                                     raw_spin_lock(rq->lock)
>                                     ttwu_do_activate()
>                                       ...
>                                       enqueue_entity()
>                                         child.se->vruntime += cfs_rq->min_vruntime
>                                     raw_spin_unlock(rq->lock)
>
> As a result, vruntime of the process becomes far bigger than min_vruntime,
> if (new)cfs_rq->min_vruntime >> (old)cfs_rq->min_vruntime.
>
> This patch fixes this problem by just ignoring such process in task_move_group_fair(),
> because the vruntime has already been normalized in task_waking_fair().
>
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> ---
>  kernel/sched_fair.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index bdaa4ab..3feb3a2 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -4925,10 +4925,10 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
>         * to another cgroup's rq. This does somewhat interfere with the
>         * fair sleeper stuff for the first placement, but who cares.
>         */
> -       if (!on_rq && p->state != TASK_RUNNING)
> +       if (!on_rq && p->state != TASK_RUNNING && p->state != TASK_WAKING)

!p->se.sum_exec_runtime is starting to look more attractive here...

>                p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
>        set_task_rq(p, task_cpu(p));
> -       if (!on_rq && p->state != TASK_RUNNING)
> +       if (!on_rq && p->state != TASK_RUNNING && p->state != TASK_WAKING)
>                p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
>  }
>  #endif
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
