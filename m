Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab1GBO07 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 10:26:59 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:35916 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab1GBO05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 10:26:57 -0400
MIME-Version: 1.0
In-Reply-To: <1309600260.10073.3.camel@twins>
References: <1309545711.4303.2.camel@localhost.localdomain>
	<1309600260.10073.3.camel@twins>
Date: Sat, 2 Jul 2011 20:26:56 +0600
Message-ID: <CADZ9YHhmctoO+AZfjDYNHXJ6VO3VSDPHgYOhdoW9oROFrBgBnQ@mail.gmail.com>
Subject: Re: [PATCH] sched: Check nr_running before calling pick_next_task in schedule().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 2, 2011 at 3:51 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sat, 2011-07-02 at 00:41 +0600, Rakib Mullick wrote:
>> Currently at schedule(), when we call pick_next_task we don't check
>> whether current rq is empty or not. Since idle_balance can fail,
>> its nice to check whether we really have any task on rq or not. If
>> not, we can call idle_sched_class.pick_next_task straight.
>>
>> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
>> ---
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 5925275..a4f4f58 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -4273,7 +4273,14 @@ need_resched:
>>               idle_balance(cpu, rq);
>>
>>       put_prev_task(rq, prev);
>> -     next = pick_next_task(rq);
>> +     /*  Since idle_balance can fail, its better to check rq->nr_running.
>> +      *  Otherwise we can call idle_sched_class.pick_next_task straight,
>> +      *  cause we need to do some accounting.
>> +      */
>> +     if (likely(rq->nr_running))
>> +             next = pick_next_task(rq);
>> +     else
>> +             next = idle_sched_class.pick_next_task(rq);
>>       clear_tsk_need_resched(prev);
>>       rq->skip_clock_update = 0;
>
> Why!?
>
> You're making the fast path -- picking a task -- slower by adding a
> branch, and making the slow path -- going into idle -- faster. That
> seems backwards at best.
>
Well, yes - branching seems definitely have some side effects.
Thinking from UP's perspective, it will only hit slow path -- going
into idle. In that case, that likely branch will just fail. And on an
UP system that slow path -- going into idle -- is the only way, taking
the fast path (trying picking a task) isn't the right thing, isn't it?

> You've completely failed to provide any sort of rationale for the patch
> nor did you provide a use-case with performance numbers. This just isn't
> making much sense at all.
>
Regarding taking branch, it needs performance numbers - I agree. But,
I'm not quite agree that - it's not just making any sense. Will try to
do some performance testing on it.


Thanks,
Rakib
