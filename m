Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab1CBTWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:22:09 -0500
Received: from smtp-out.google.com ([74.125.121.67]:55627 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab1CBTWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:22:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=buC4fqYKQ8txdfAnIPyhK6oIcKpPIR6v2MQbbsqmDPMEeSheuQ8c2PKjRXdBeb1NaA
         CtpV2PkzOg+J26ENw/pQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTinyAyXCH6sh9pOe36dCeTO_C8wbtmZriKanGtt3@mail.gmail.com>
References: <1299022433-17233-1-git-send-email-venki@google.com>
	<AANLkTinyAyXCH6sh9pOe36dCeTO_C8wbtmZriKanGtt3@mail.gmail.com>
Date: Wed, 2 Mar 2011 11:22:04 -0800
Message-ID: <AANLkTim66NfZJSMUwhWOG80A==wEnvVB4ZS4TQT2TpK8@mail.gmail.com>
Subject: Re: [PATCH] sched: next buddy hint on sleep and preempt path
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

On Tue, Mar 1, 2011 at 9:43 PM, Paul Turner <pjt@google.com> wrote:
> On Tue, Mar 1, 2011 at 3:33 PM, Venkatesh Pallipadi <venki@google.com> wrote:
>> When a task in a taskgroup sleeps, pick_next_task starts all the way back at
>> the root and picks the task/taskgroup with the min vruntime across all
>> runnable tasks. But, when there are many frequently sleeping tasks
>> across different taskgroups, it makes better sense to stay with same taskgroup
>> for its slice period (or until all tasks in the taskgroup sleeps) instead of
>> switching cross taskgroup on each sleep after a short runtime.
>> This helps specifically where taskgroups corresponds to a process with
>> multiple threads. The change reduces the number of CR3 switches in this case.

<snip>

>> ---
>>  kernel/sched_fair.c |   20 ++++++++++++++++++--
>>  1 files changed, 18 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> index 3a88dee..36e8f02 100644
>> --- a/kernel/sched_fair.c
>> +++ b/kernel/sched_fair.c
>> @@ -1339,6 +1339,8 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>>        hrtick_update(rq);
>>  }
>>
>> +static void set_next_buddy(struct sched_entity *se);
>> +
>>  /*
>>  * The dequeue_task method is called before nr_running is
>>  * decreased. We remove the task from the rbtree and
>> @@ -1348,14 +1350,22 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>>  {
>>        struct cfs_rq *cfs_rq;
>>        struct sched_entity *se = &p->se;
>> +       int task_flags = flags;
>
> simpler: int voluntary = flags & DEQUEUE_SLEEP;

Agree. This looks cleaner. Will change.

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
>> +                       if (task_flags & DEQUEUE_SLEEP && se->parent)
>> +                               set_next_buddy(se->parent);
>
> re-using the last_buddy would seem like a more natural fit here; also
> doesn't have a clobber race with a wakeup

Yes. Using of next_buddy will be racy. There will be races with
yield_to and preempt as well. But, as long as we use it only as hint,
I thought occasional clobber would be OK.

>
>>                        break;
>> +               }
>>                flags |= DEQUEUE_SLEEP;
>>        }
>>
>> @@ -1887,8 +1897,14 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
>>        update_curr(cfs_rq);
>>        find_matching_se(&se, &pse);
>>        BUG_ON(!pse);
>> -       if (wakeup_preempt_entity(se, pse) == 1)
>> +       if (wakeup_preempt_entity(se, pse) == 1) {
>> +               /*
>> +                * Bias pick_next to pick the sched entity that is
>> +                * triggering this preemption.
>> +                */
>> +               set_next_buddy(pse);
>
> this probably wants some sort of unification with the scale-based next
> buddy above
>

Yes. I can skip this if it is already set by scale based next buddy above.

Thanks,
Venki

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
