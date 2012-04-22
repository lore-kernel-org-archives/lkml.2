Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab2DVJsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 05:48:16 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47759 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab2DVJsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 05:48:14 -0400
Message-ID: <4F93D3DA.5060403@gmail.com>
Date: Sun, 22 Apr 2012 11:48:10 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Dario Faggioli <raistlin@linux.it>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DLS: cleanup pulling task
References: <CAJd=RBDnPvr=QLgnc7eXZaqZaxurLAXE9-ftM=Sdkd4x2Thfyg@mail.gmail.com> <CAJd=RBCvmHpWXLSPe6Wdyd==aKUnQoWzVW=R6CctzMBbR31LSg@mail.gmail.com>
In-Reply-To: <CAJd=RBCvmHpWXLSPe6Wdyd==aKUnQoWzVW=R6CctzMBbR31LSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hillf,
sorry for a so delayed replay, but I was really busy in the last
two weeks.

Before going inline I would anyway stress the point that we tried
to be as much aligned as we could with sched_rt.c. This is a
design choice and the reason behind is simple: -rt is highly
tested and verified. Since conceptually -dl doesn't differ to much
from -rt, beeing based on it allows two things:
    - try to not incur in known design flaws/bugs
    - exploit the community work on -rt for -dl benefit (patches on
      -rt can be quite straightforwardly applied to -dl)

However, this doesn't mean that both codes are immutable, only that
changes in -rt must be well documented to be applied and we would
like to take advantage of this work in an indirect way as much as
we can. At the same time we are also playing with the push/pull
mechanism, so I can understand your interest :-P.

And now to your proposed changes :-)...

On 04/07/2012 12:14 PM, Hillf Danton wrote:
> First add check for CPU online.
> Second initialize dmin to be as min as possible.
> Third, the preempt check is not available yet=(
>
> Due to re-init of dmin, a couple of preempt checks are removed.
>
> With runqueue lock, a couple of caution checks are also removed.
>
> Finally the jumple lable, skip, is replaced with unlock.
>
> Signed-off-by: Hillf Danton<dhillf@gmail.com>
> ---
>
> --- a/kernel/sched_dl.c	Sat Apr  7 15:00:28 2012
> +++ b/kernel/sched_dl.c	Sat Apr  7 17:33:44 2012
> @@ -1287,71 +1287,53 @@ static void push_dl_tasks(struct rq *rq)
>
>   static int pull_dl_task(struct rq *this_rq)
>   {
> -	int this_cpu = this_rq->cpu, ret = 0, cpu;
> -	struct task_struct *p;
> -	struct rq *src_rq;
> -	u64 dmin = LONG_MAX;
> +	int this_cpu = this_rq->cpu;
> +	int cpu;
> +	u64 dmin;
> +	int ret = 0;
>
>   	if (likely(!dl_overloaded(this_rq)))
>   		return 0;
>
> -	for_each_cpu(cpu, this_rq->rd->dlo_mask) {
> +	if (this_rq->dl.dl_nr_running)
> +		dmin = this_rq->dl.earliest_dl.curr;
> +	else
> +		dmin = -1ULL;
> +

Below we potentially drop this_rq->lock. In the original code we
update dmin only with both locks, it is probably more consistent.

> +	for_each_cpu_and(cpu, this_rq->rd->dlo_mask, cpu_online_mask) {

dlo_mask is updated every time a cpu goes on/off, so this check should
be implicit.

> +		struct task_struct *p;
> +		struct rq *src_rq;
> +
>   		if (this_cpu == cpu)
>   			continue;
>
>   		src_rq = cpu_rq(cpu);
>
> -		/*
> -		 * It looks racy, abd it is! However, as in sched_rt.c,
> -		 * we are fine with this.
> -		 */
> -		if (this_rq->dl.dl_nr_running&&
> -		    dl_time_before(this_rq->dl.earliest_dl.curr,
> -				   src_rq->dl.earliest_dl.next))
> +		/* Racy without runqueue lock, but we are fine now */

Doesn't seem this changes much regarding locks. Why you say we are
fine?

> +		if (!dl_time_before(src_rq->dl.earliest_dl.next, dmin))
>   			continue;
>
> -		/* Might drop this_rq->lock */
>   		double_lock_balance(this_rq, src_rq);
>
> -		/*
> -		 * If there are no more pullable tasks on the
> -		 * rq, we're done with it.
> -		 */
>   		if (src_rq->dl.dl_nr_running<= 1)
> -			goto skip;
> +			goto unlock;
>
>   		p = pick_next_earliest_dl_task(src_rq, this_cpu);
>
> -		/*
> -		 * We found a task to be pulled if:
> -		 *  - it preempts our current (if there's one),
> -		 *  - it will preempt the last one we pulled (if any).
> -		 */
> -		if (p&&  dl_time_before(p->dl.deadline, dmin)&&
> -		    (!this_rq->dl.dl_nr_running ||
> -		     dl_time_before(p->dl.deadline,
> -				    this_rq->dl.earliest_dl.curr))) {
> -			WARN_ON(p == src_rq->curr);
> -			WARN_ON(!p->on_rq);
> -
> -			/*
> -			 * Then we pull iff p has actually an earlier
> -			 * deadline than the current task of its runqueue.
> -			 */
> -			if (dl_time_before(p->dl.deadline,
> -					   src_rq->curr->dl.deadline))
> -				goto skip;
> +		/* With runqueue lock, recheck preempty */
> +		if (p&&  dl_time_before(p->dl.deadline, dmin)) {
>
> -			ret = 1;
> +			/* We dont pull running task */
> +			if (p == src_rq->curr)
> +				goto unlock;

This should be the case with pick_next_earliest_dl_task, we in fact check
that this is true with the WARN_ON.

>
>   			deactivate_task(src_rq, p, 0);
>   			set_task_cpu(p, this_cpu);
>   			activate_task(this_rq, p, 0);
> +			ret++;
>   			dmin = p->dl.deadline;
> -
> -			/* Is there any other task even earlier? */
>   		}
> -skip:
> +unlock:
>   		double_unlock_balance(this_rq, src_rq);
>   	}
>
> --

Thanks a lot for your interest in the patchset!

Cheers,

- Juri
