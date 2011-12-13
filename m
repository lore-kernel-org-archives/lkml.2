Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab1LMMW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 07:22:59 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48363 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab1LMMW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 07:22:56 -0500
MIME-Version: 1.0
In-Reply-To: <20111213155856.aebd6cd0.nishimura@mxp.nes.nec.co.jp>
References: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp> <20111213155856.aebd6cd0.nishimura@mxp.nes.nec.co.jp>
From: Paul Turner <pjt@google.com>
Date: Tue, 13 Dec 2011 04:22:24 -0800
Message-ID: <CAPM31R+fpQYJQo54RQ27HT6_OiYTeka86aX-37QyKxryidWLYA@mail.gmail.com>
Subject: Re: [PATCH 2/3] sched: fix cgroup movement of forking process
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 10:58 PM, Daisuke Nishimura
<nishimura@mxp.nes.nec.co.jp> wrote:
> There is a small race between task_fork_fair() and sched_move_task(),
> which is trying to move the parent.
>
>        task_fork_fair()                 sched_move_task()
> --------------------------------+---------------------------------
>  cfs_rq = task_cfs_rq(current)
>    -> cfs_rq is the "old" one.
>  curr = cfs_rq->curr
>    -> curr is set to the parent.
>                                    task_rq_lock()
>                                    dequeue_task()
>                                      ->parent.se.vruntime -= (old)cfs_rq->min_vruntime
>                                    enqueue_task()
>                                      ->parent.se.vruntime += (new)cfs_rq->min_vruntime
>                                    task_rq_unlock()
>  raw_spin_lock_irqsave(rq->lock)
>  se->vruntime = curr->vruntime
>    -> vruntime of the child is set to that of the parent
>       which has already been updated by sched_move_task().
>  se->vruntime -= (old)cfs_rq->min_vruntime.
>  raw_spin_unlock_irqrestore(rq->lock)
>
> As a result, vruntime of the child becomes far bigger than expected,
> if (new)cfs_rq->min_vruntime >> (old)cfs_rq->min_vruntime.
>
> This patch fixes this problem by setting "cfs_rq" and "curr" after holding
> the rq->lock.
>
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> ---
>  kernel/sched_fair.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index df145a9..bdaa4ab 100644
> --- a/kernel/sched_fair.cthis
> +++ b/kernel/sched_fair.c
> @@ -4787,14 +4787,17 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
>  */this
>  static void task_fork_fair(struct task_struct *p)
>  {
> -       struct cfs_rq *cfs_rq = task_cfs_rq(current);
> -       struct sched_entity *se = &p->se, *curr = cfs_rq->curr;

Strictly speaking we're calling
current->sched_class-(*)->task_fork_fair() so we know current is in
sched_fair, which means it has to be cfs_rq->curr.

Because of that this could become be *curr = &current->se and then
cfs_rq_of(curr) below.

But the current healthy paranoia is ok too.

> +       struct cfs_rq *cfs_rq;
> +       struct sched_entity *se = &p->se, *curr;
>        int this_cpu = smp_processor_id();
>        struct rq *rq = this_rq();
>        unsigned long flags;
>
>        raw_spin_lock_irqsave(&rq->lock, flags);
>
> +       cfs_rq = task_cfs_rq(current);
> +       curr = cfs_rq->curr;
> +
>        update_rq_clock(rq);
>
>        if (unlikely(task_cpu(p) != this_cpu)) {
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Paul Turner <pjt@google.com>
