Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab1FEKpj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 06:45:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39757 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab1FEKph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 06:45:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O2b2IEc09AqbjYj3UO2kf7Og1+UjEstCGfEUk5CyG9o1xeYKGt9PMLeGk4MeoHpiDo
         QjupNbKf9ZSyNOPmeMVxurnuLU0i3/NRsKmdyYtBzUS9hM1Cv0ZnZ7iNkExxskKp1qe3
         q4XRMRY/N1mX+kUBafsjxGPsWCTlU3x6U8OCM=
MIME-Version: 1.0
In-Reply-To: <1306873915.10135.11.camel@gandalf.stny.rr.com>
References: <BANLkTikG4v6xPGcKU6YVTYhXCnxWaWwoKg@mail.gmail.com>
	<1306873915.10135.11.camel@gandalf.stny.rr.com>
Date: Sun, 5 Jun 2011 18:45:36 +0800
Message-ID: <BANLkTi=Xp0UAHm4R=TQPoqJJTwc55ewg0Q@mail.gmail.com>
Subject: Re: [PATCH] sched: check and preempt the current task at right place
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 4:31 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-05-31 at 21:04 +0800, Hillf Danton wrote:
>> When switching a task to RT, it is the right place to preempt the current
>> running task if the task is not running. Same scenario also rises when the
>> priority of task has changed.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>  kernel/sched_rt.c |   19 +++----------------
>>  1 files changed, 3 insertions(+), 16 deletions(-)
>>
>> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
>> index 88725c9..4a9553e 100644
>> --- a/kernel/sched_rt.c
>> +++ b/kernel/sched_rt.c
>> @@ -1671,25 +1671,13 @@ static inline void init_sched_rt_class(void)
>>   */
>>  static void switched_to_rt(struct rq *rq, struct task_struct *p)
>>  {
>> -     int check_resched = 1;
>> -
>>       /*
>>        * If we are already running, then there's nothing
>>        * that needs to be done. But if we are not running
>>        * we may need to preempt the current running task.
>> -      * If that current running task is also an RT task
>> -      * then see if we can move to another run queue.
>>        */
>> -     if (p->on_rq && rq->curr != p) {
>> -#ifdef CONFIG_SMP
>> -             if (rq->rt.overloaded && push_rt_task(rq) &&
>> -                 /* Don't resched if we changed runqueues */
>> -                 rq != task_rq(p))
>> -                     check_resched = 0;
>> -#endif /* CONFIG_SMP */
>> -             if (check_resched && p->prio < rq->curr->prio)
>> -                     resched_task(rq->curr);
>> -     }
>> +     if (p->on_rq && rq->curr != p)
>> +             check_preempt_curr_rt(rq, p, 0);
>
>
> Note, although it works now, there's no guarantee that
> check_preempt_curr_rt() will work with something other than an rt task
> on the runqueue.
>

If check_preempt_curr_rt has solid shortage to do its work, we could do more
for it later.

> Also, this code removes the push_rt_task(rq) entirely, which means that
> if we don't preempt current, and p is an RT task (as it is), we wont
> push it off to another rq even if one is available for it to run on.
>

If it is concerned that we fail to preempt the current task with a RT task, why
is preempt checked after pushing?

If we really fail to preempt, it is not too late to push the starved
tasks, though
starvation is eligible as you taught a while ago.

thanks
          Hillf

>>  }
>>
>>  /*
>> @@ -1729,8 +1717,7 @@ prio_changed_rt(struct rq *rq, struct
>> task_struct *p, int oldprio)
>>                * greater than the current running task
>>                * then reschedule.
>>                */
>> -             if (p->prio < rq->curr->prio)
>> -                     resched_task(rq->curr);
>> +             check_preempt_curr_rt(rq, p, 0);
>>       }
>>  }
>
>
>
