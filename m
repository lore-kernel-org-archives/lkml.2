Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab1CHBrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 20:47:09 -0500
Received: from smtp-out.google.com ([216.239.44.51]:22169 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab1CHBrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 20:47:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZmXiaa7ax/thpIqWaitowz0hoJbh25+xPGULvIn78M53otDdrvezzXADxbqekRgYkA
         VpebgPeF8gywVUajejdw==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=dSdnn0p8973C5-URTLbTkJ2XROV9XePrQezJ3@mail.gmail.com>
References: <AANLkTi=hy8mHp=RLkKbfc2nw0VGX65ZCmk89r3U-rb4-@mail.gmail.com>
	<1299545997-26304-1-git-send-email-venki@google.com>
	<AANLkTi=dSdnn0p8973C5-URTLbTkJ2XROV9XePrQezJ3@mail.gmail.com>
Date: Mon, 7 Mar 2011 17:47:01 -0800
Message-ID: <AANLkTi=ao5dci3gb=+UmegZx_ag_X6gAFZ5mBb+8=9hR@mail.gmail.com>
Subject: Re: [PATCH] sched: next buddy hint on sleep and preempt path - v1
From: Venkatesh Pallipadi <venki@google.com>
To: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 5:29 PM, Paul Turner <pjt@google.com> wrote:
> On Mon, Mar 7, 2011 at 4:59 PM, Venkatesh Pallipadi <venki@google.com> wrote:
>> When a task in a taskgroup sleeps, pick_next_task starts all the way back at
>> the root and picks the task/taskgroup with the min vruntime across all
>> runnable tasks. But, when there are many frequently sleeping tasks
>> across different taskgroups, it makes better sense to stay with same taskgroup
>> for its slice period (or until all tasks in the taskgroup sleeps) instead of
>> switching cross taskgroup on each sleep after a short runtime.
>> This helps specifically where taskgroups corresponds to a process with
>> multiple threads. The change reduces the number of CR3 switches in this case.
>>
>> Example:
>> Two taskgroups with 2 threads each which are running for 2ms and
>> sleeping for 1ms. Looking at sched:sched_switch shows -
>>
>> BEFORE: taskgroup_1 threads [5004, 5005], taskgroup_2 threads [5016, 5017]
>>      cpu-soaker-5004  [003]  3683.391089
>>      cpu-soaker-5016  [003]  3683.393106
>>      cpu-soaker-5005  [003]  3683.395119
>>      cpu-soaker-5017  [003]  3683.397130
>>      cpu-soaker-5004  [003]  3683.399143
>>      cpu-soaker-5016  [003]  3683.401155
>>      cpu-soaker-5005  [003]  3683.403168
>>      cpu-soaker-5017  [003]  3683.405170
>>
>> AFTER: taskgroup_1 threads [21890, 21891], taskgroup_2 threads [21934, 21935]
>>      cpu-soaker-21890 [003]   865.895494
>>      cpu-soaker-21935 [003]   865.897506
>>      cpu-soaker-21934 [003]   865.899520
>>      cpu-soaker-21935 [003]   865.901532
>>      cpu-soaker-21934 [003]   865.903543
>>      cpu-soaker-21935 [003]   865.905546
>>      cpu-soaker-21891 [003]   865.907548
>>      cpu-soaker-21890 [003]   865.909560
>>      cpu-soaker-21891 [003]   865.911571
>>      cpu-soaker-21890 [003]   865.913582
>>      cpu-soaker-21891 [003]   865.915594
>>      cpu-soaker-21934 [003]   865.917606
>>
>> Similar problem is there when there are multiple taskgroups and say a task A
>> preempts currently running task B of taskgroup_1. On schedule, pick_next_task
>> can pick an unrelated task on taskgroup_2. Here it would be better to give some
>> preference to task B on pick_next_task.
>>
>> A simple (may be extreme case) benchmark I tried was tbench with 2 tbench
>> client processes with 2 threads each running on a single CPU. Avg throughput
>> across 5 50 sec runs was -
>> BEFORE: 105.84 MB/sec
>> AFTER: 112.42 MB/sec
>>
>> Changes from v0:
>> * Always pass task se to set_next_buddy
>> * Avoid repeated set_next_buddy in check_preempt_wakeup
>> * Minor flag cleanup in dequeue_task_fair
>>
>> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
>> ---
>>  kernel/sched_fair.c |   41 ++++++++++++++++++++++++++++++++++++++---
>>  1 files changed, 38 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> index 3a88dee..cbe442e 100644
>> --- a/kernel/sched_fair.c
>> +++ b/kernel/sched_fair.c
>> @@ -1339,6 +1339,20 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>>        hrtick_update(rq);
>>  }
>>
>> +static struct sched_entity *pick_next_taskse_on_cfsrq(struct cfs_rq *cfs_rq)
>> +{
>> +       struct sched_entity *se;
>> +
>> +       do {
>> +               se = pick_next_entity(cfs_rq);
>> +               cfs_rq = group_cfs_rq(se);
>> +       } while (cfs_rq);
>> +
>> +       return se;
>> +}
>> +
>
> I think the original approach was much cleaner; the notion of a
> SCHED_IDLE task is only relative versus siblings in group scheduling
>
> Generalizing the buddies to work on entities, e.g.:
>
> @@ -2137,10 +2180,11 @@ static void set_last_buddy(struct sched_entity *se)
>
>  static void set_next_buddy(struct sched_entity *se)
>  {
> -       if (likely(task_of(se)->policy != SCHED_IDLE)) {
> -               for_each_sched_entity(se)
> -                       cfs_rq_of(se)->next = se;
> -       }
> +       if (entity_is_task(se) && unlikely(task_of(se)->policy == SCHED_IDLE))
> +               return;
> +
> +       for_each_sched_entity(se)
> +               cfs_rq_of(se)->next = se;
>  }
>
> Avoids all the picking descent and gets us back there.
>

The reason I did not go with some thing like above was for the case
where: a task (SCHED_IDLE or otherwise) is going to sleep and there is
another runnable SCHED_IDLE task in the same group, and there is a non
SCHED_IDLE task in some other group. In this case I thought we should
not be giving next_buddy privilege ingroup and potentially pick non
SCHED_IDLE task from other group based on vruntime.

I agree that someting like above is simpler and if we do not really
care about buddy privilege picking SCHED_IDLE task ahead of non
SCHED_IDLE task from different group, then above approach seems
simpler.

>> +static void set_next_buddy(struct sched_entity *se);
>> +
>>  /*
>>  * The dequeue_task method is called before nr_running is
>>  * decreased. We remove the task from the rbtree and
>> @@ -1348,14 +1362,25 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>>  {
>>        struct cfs_rq *cfs_rq;
>>        struct sched_entity *se = &p->se;
>> +       int task_sleep = flags & DEQUEUE_SLEEP;
>>
>>        for_each_sched_entity(se) {
>>                cfs_rq = cfs_rq_of(se);
>>                dequeue_entity(cfs_rq, se, flags);
>>
>>                /* Don't dequeue parent if it has other entities besides us */
>> -               if (cfs_rq->load.weight)
>> +               if (cfs_rq->load.weight) {
>> +                       /*
>> +                        * Bias pick_next to pick a task from this cfs_rq, as
>> +                        * p is sleeping when it is within its sched_slice.
>> +                        */
>> +                       if (task_sleep) {
>> +                               struct sched_entity *next_se;
>> +                               next_se = pick_next_taskse_on_cfsrq(cfs_rq);
>> +                               set_next_buddy(next_se);
>> +                       }
>>                        break;
>> +               }
>>                flags |= DEQUEUE_SLEEP;
>>        }
>>
>> @@ -1856,12 +1881,15 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
>>        struct sched_entity *se = &curr->se, *pse = &p->se;
>>        struct cfs_rq *cfs_rq = task_cfs_rq(curr);
>>        int scale = cfs_rq->nr_running >= sched_nr_latency;
>> +       int next_buddy_marked = 0;
>>
>>        if (unlikely(se == pse))
>>                return;
>>
>> -       if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags & WF_FORK))
>> +       if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags & WF_FORK)) {
>>                set_next_buddy(pse);
>> +               next_buddy_marked = 1;
>> +       }
>>
>>        /*
>>         * We can come here with TIF_NEED_RESCHED already set from new task
>> @@ -1887,8 +1915,15 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
>>        update_curr(cfs_rq);
>>        find_matching_se(&se, &pse);
>>        BUG_ON(!pse);
>> -       if (wakeup_preempt_entity(se, pse) == 1)
>> +       if (wakeup_preempt_entity(se, pse) == 1) {
>
> Can't this just be:
>
> if ((wakeup_preempt_entity(se, pse) == 1) || (scale && !fork))
>
> Or even:
>
> ( wakeup || scale ) && !fork
>
> Storing the state seems messy just for the
> prempt-with-resched-already-set case (effective behavioral difference.
>  With this the other case can be deleted.

Removing other case is not straight-forward as there are couple of
non-preempt returns before this point which all wants the next_buddy
set with (scale && !fork).
I cannot move this case ahead as we have to do matching se before
doing preempt check. Hence I ended up with stored state.
Also NEXT_BUDDY feature is off by default. So, this change should be a
compiler optimized to nop by default.


Thanks,
Venki
>
>> +               /*
>> +                * Bias pick_next to pick the task that is
>> +                * triggering this preemption.
>> +                */
>> +               if (!next_buddy_marked)
>> +                       set_next_buddy(&p->se);
>>                goto preempt;
>> +       }
>>
>>        return;
>>
>> --
>> 1.7.3.1
>>
>>
>
