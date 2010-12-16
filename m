Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab0LPWcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 17:32:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:61903 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab0LPWcN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 17:32:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AjK8S9kEDrF0KlFwJby1IJJexIQl9LFtvfBHlBraLjCu4YN395GHx3lZ4Ys+EHGwBo
         SHBLPgts37o2+9EDbGaQ==
MIME-Version: 1.0
In-Reply-To: <1292497424.6803.4573.camel@twins>
References: <20101216031016.186364650@google.com> <20101216031038.159704378@google.com>
 <1292497424.6803.4573.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Thu, 16 Dec 2010 14:31:40 -0800
Message-ID: <AANLkTi=h9vZm4nTnwq7+CeQjFpVV2QaovUP8KOi-gcXy@mail.gmail.com>
Subject: Re: [patch 2/2] sched: charge unaccounted run-time on entity re-weight
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 3:03 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2010-12-15 at 19:10 -0800, Paul Turner wrote:
>> plain text document attachment (update_on_reweight.patch)
>> Mike Galbraith reported poor interactivity[*] when the new shares distribution
>> code was combined with autogroups.
>>
>> The root cause turns out to be a mis-ordering of accounting accrued execution
>> time and shares updates.  Since update_curr() is issued hierarchically,
>> updating the parent entity weights to reflect child enqueue/dequeue results in
>> the parent's unaccounted execution time then being accrued (vs vruntime) at the
>> new weight as opposed to the weight present at accumulation.
>>
>> While this doesn't have much effect on processes with timeslices that cross a
>> tick, it is particularly problematic for an interactive process (e.g. Xorg)
>> which incurs many (tiny) timeslices.  In this scenario almost all updates are
>> at dequeue which can result in significant fairness perturbation (especially if
>> it is the only thread, resulting in potential {tg->shares, MIN_SHARES}
>> transitions).
>>
>> Correct this by ensuring unaccounted time is accumulated prior to manipulating
>> an entity's weight.
>>
>> [*] http://xkcd.com/619/ is perversely Nostradamian here.
>>
>> Signed-off-by: Paul Turner <pjt@google.com>
>>
>> ---
>>  kernel/sched_fair.c |    6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> Index: tip3/kernel/sched_fair.c
>> ===================================================================
>> --- tip3.orig/kernel/sched_fair.c
>> +++ tip3/kernel/sched_fair.c
>> @@ -767,8 +767,12 @@ static void update_cfs_load(struct cfs_r
>>  static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
>>                           unsigned long weight)
>>  {
>> -     if (se->on_rq)
>> +     if (se->on_rq) {
>> +             /* commit outstanding execution time */
>> +             if (cfs_rq->curr == se)
>> +                     update_curr(cfs_rq);
>>               account_entity_dequeue(cfs_rq, se);
>> +     }
>>
>>       update_load_set(&se->load, weight);
>>
>
> Hrmm,. so we have:
>
> entity_tick()
>  update_curr()
>  update_entity_shares_tick()
>    update_cfs_shares()
>      reweight_entity()
>
>
> {en,de}queue_entity()
>  update_curr()
>  update_cfs_shares()
>    reweight_entity()
>
> {en,de}queue_task_fair()
>  update_cfs_shares() (the other branch)
>
> update_shares_cpu()
>  update_cfs_shares()
>
> So wouldn't something like the below be nicer?
>

That doesn't quite work.

The problem stems from:

- update_curr() accues time against current cfs_rq's timeline
  - We always need to do this for entity placement
  - Manipulation of the current cfs_rq's load affects its weights

However the current cfs_rq in the problem case is a group entity which
happens to be the current entity on the parenting se's group_cfs_rq
(say that 10 times fast).

When we update that entity's (call it X) weight to reflect the
interactions on its owned cfs_rq, the update isout of order with the
subsequent update_curr() on the parent which is what actually accounts
the accrued vruntime versus X (which was accumulated at old weight)

We need to either:

A) Get all of the update_currs() done up front, e.g. at the start of
enqueue_task_fair add another for_each
- I don't like this approach because it it becomes a concern that has
to be implemented by all callers
- There's also no point in issuing these if the entity in question
isnt cfs_rq->curr since there's no time to account in that case

B) Change the reweights in enqueue/dequeue/etc to occur against the
owned cfs_rq as opposed to the queueing cfs_rq.
- This is not really clean in my mind since it steps outside of the
semantic of we are "enqueuing E to T".  Instead of only really
manipulating T we're adding "oh and we'll finish manipulations
resulting from prior enqeues against E if it was a tree".

C) Charge unaccounted time versus an entity before re-weighting it
- I think this ends up being the nicest, we only end up issuing the
extra update_currs when we need them, and the second becomes a nop
since rq->clock doesn't move.  Not to mention it also blocks up this
hole completely since it becomes always safe to reweight_entity().



> ---
>
> Index: linux-2.6/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_fair.c
> +++ linux-2.6/kernel/sched_fair.c
> @@ -1249,6 +1249,7 @@ enqueue_task_fair(struct rq *rq, struct
>        for_each_sched_entity(se) {
>                struct cfs_rq *cfs_rq = cfs_rq_of(se);
>
> +               update_curr(cfs_rq);
>                update_cfs_load(cfs_rq, 0);
>                update_cfs_shares(cfs_rq, 0);
>        }
> @@ -1279,6 +1280,7 @@ static void dequeue_task_fair(struct rq
>        for_each_sched_entity(se) {
>                struct cfs_rq *cfs_rq = cfs_rq_of(se);
>
> +               update_curr(cfs_rq);

This would be out of order with the updated weights below

>                update_cfs_load(cfs_rq, 0);
>                update_cfs_shares(cfs_rq, 0);
>        }
> @@ -2085,6 +2087,7 @@ static int update_shares_cpu(struct task
>        raw_spin_lock_irqsave(&rq->lock, flags);
>
>        update_rq_clock(rq);
> +       update_curr(cfs_rq);

Likewise

>        update_cfs_load(cfs_rq, 1);
>
>        /*
>
>
>
