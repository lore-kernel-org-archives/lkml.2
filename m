Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab1FROyp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 10:54:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52014 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab1FROyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 10:54:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wQ2FSzwKg2OFo8gwuAZzOZjG+tKUoy0Z0fAN/q8g+5DE/0bF4+ecZu1EjhHmkP3H+M
         JyhAJ2d/p2W6EXW4jKSxLUlUkKqyhdWYn9wd3r/FdPeWqP29sVnCYAK1J0PHqunuICpG
         gYEZ86SKCRYRK3qwcNCjuYRYxzZdyrDNJiOt4=
MIME-Version: 1.0
In-Reply-To: <1308322563.9218.184.camel@gandalf.stny.rr.com>
References: <BANLkTint_00+oHVGpgV4n4E2A9W5O8nJxA@mail.gmail.com>
	<1308275405.9218.156.camel@gandalf.stny.rr.com>
	<BANLkTik8PpdwGgLOE7rAauXqGYdnT53GpQ@mail.gmail.com>
	<1308322563.9218.184.camel@gandalf.stny.rr.com>
Date: Sat, 18 Jun 2011 22:54:42 +0800
Message-ID: <BANLkTimUd3BWFg4hi6OWLjUYsxvWRRBUZg@mail.gmail.com>
Subject: Re: [PATCH] sched: update cpupri for runqueue when its priority changes
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

On Fri, Jun 17, 2011 at 10:56 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2011-06-17 at 20:59 +0800, Hillf Danton wrote:
>> On Fri, Jun 17, 2011 at 9:50 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > On Sun, 2011-06-05 at 17:54 +0800, Hillf Danton wrote:
>> >> When the priority of runqueue changes, lower or higer, the info of cpupri
>> >> should be updated, in cases such as pick_next_task_rt() and switched_to_rt().
>> >
>> > Why?
>> >
>> > We do the calculation on queuing and dequeuing the task, we only care
>> > about the highest priority task that is on the queue, not what is
>> > actually running.
>> >
>>
>> It is to capture the changes in CPU priority caused by re-queued task and
>> throttled RQ.
>

Hi Steven,

Thanks for reviewing the patch.

> OK, I talked a little with Peter about this. We don't throttle an rq, we
> throttle a group. A group consists of tasks, not rqs. When a group is
> throttled, we do not migrate tasks, so the cpupri is not a issue here.
>
> For non throttled groups, tasks are enqueued and when they are, the
> cpupri is updated. We *only* care about tasks that are enqueued.
>
> Thus, lets look again at your patch:
>
>
>> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
>> index 08e9374..9508168 100644
>> --- a/kernel/sched_rt.c
>> +++ b/kernel/sched_rt.c
>> @@ -1158,6 +1158,8 @@ static struct task_struct
>> *pick_next_task_rt(struct rq *rq)
>>          * lock again later if there is no need to push
>>          */
>>         rq->post_schedule = has_pushable_tasks(rq);
>> +
>> +       cpupri_set(&rq->rd->cpupri, rq->cpu, p == NULL ? MAX_RT_PRIO : p->prio);
>
> In pick_next_task_rt(), p is the highes prio that is queued. Thus,
> cpupri is already set to p->prio. If p is NULL, then there is no rt
> tasks queued on this rq, and cpupri is set to MAX_RT_PRIO. Your patch
> here does not change anything.
>

There are two cases that NULL is returned in _pick_next_task_rt(), it is the
second case, after checking rt_rq->rt_nr_running, that is captured, and if
NULL is returned in the second case, the CPU priority does change.

In another scenario that has little with {en, de}queue, as shown by
requeue_task_rt(), the CPU priority will change if other RT tasks exist.


>>  #endif
>>
>>         return p;
>> @@ -1673,6 +1675,8 @@ static void switched_to_rt(struct rq *rq, struct
>> task_struct *p)
>>  {
>>         int check_resched = 1;
>>
>> +       if (!p->on_rq)
>> +               return;
>>         /*
>>          * If we are already running, then there's nothing
>>          * that needs to be done. But if we are not running
>> @@ -1680,7 +1684,7 @@ static void switched_to_rt(struct rq *rq, struct
>> task_struct *p)
>>          * If that current running task is also an RT task
>>          * then see if we can move to another run queue.
>>          */
>> -       if (p->on_rq && rq->curr != p) {
>> +       if (rq->curr != p) {
>>  #ifdef CONFIG_SMP
>>                 if (rq->rt.overloaded && push_rt_task(rq) &&
>>                     /* Don't resched if we changed runqueues */
>> @@ -1690,6 +1694,11 @@ static void switched_to_rt(struct rq *rq,
>> struct task_struct *p)
>>                 if (check_resched && p->prio < rq->curr->prio)
>>                         resched_task(rq->curr);
>>         }
>> +       else {
>> +#ifdef CONFIG_SMP
>> +               cpupri_set(&rq->rd->cpupri, rq->cpu, p->prio);
>> +#endif
>
> switched_to_rt() is called from sched.c's check_class_changed(), which
> is always called after enqueuing the task if p->on_rq was set. Thus, if
> this is running and is the highest priority task, cpupri would have this
> bit set too. Again, your patch does nothing but add more overhead.
>

The patch is overhead at this hunk.

Thanks
	Hillf
