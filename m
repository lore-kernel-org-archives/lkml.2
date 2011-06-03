Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab1FCPLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:11:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50122 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab1FCPLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ad0UrKq9uzCs+dgno1W7eJ36uQIc58wEZhkBHQ91+8Vji2xHV/xZfF691gEe7lJ0hv
         5Gpfhe47OLYx52+It5jMk1ga+/sWhflINpPKNKbnmJ153ptYR9jtWuRHYlpqRjZubMX/
         OTZm7rPIeNq4fLNg2ZJDnsTremo3uyWnIjKa8=
MIME-Version: 1.0
In-Reply-To: <1306854022.11899.27.camel@gandalf.stny.rr.com>
References: <BANLkTi=+bcTDTOWEOGcmgNHYrvpnEFqEjA@mail.gmail.com>
	<1306854022.11899.27.camel@gandalf.stny.rr.com>
Date: Fri, 3 Jun 2011 23:11:32 +0800
Message-ID: <BANLkTimpQasMVijw=OWov88jr6Cmfo6rkw@mail.gmail.com>
Subject: Re: [PATCH] sched: change pulling RT task to be pulling the
 highest-prio run-queue first
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 11:00 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sat, 2011-05-28 at 22:34 +0800, Hillf Danton wrote:
>> When pulling, RT tasks are pulled from one overloaded run-queue after another,
>> which is changed to be pulling tasks from the highest-prio run-queue first.
>
> First off, a change like this requires rational. Preferably, in the
> showing of benchmarks, and test cases that demonstrate the problems of
> the current scheduler and explains to us that these changes improve the
> situation.
>
> There is no rational nor any benchmarks that explain why this is better
> than the current method.
>

Hi Steven

Thanks for your review, which shows the shortage of the patch, test case.


>>
>> A new function, cpupri_find_prio(), is added to easy pulling in prio sequence.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- tip-git/kernel/sched_rt.c Sun May 22 20:12:01 2011
>> +++ sched_rt.c        Sat May 28 21:24:13 2011
>> @@ -1434,18 +1434,33 @@ static void push_rt_tasks(struct rq *rq)
>>               ;
>>  }
>>
>> +static DEFINE_PER_CPU(cpumask_var_t, high_cpu_mask);
>> +
>>  static int pull_rt_task(struct rq *this_rq)
>>  {
>>       int this_cpu = this_rq->cpu, ret = 0, cpu;
>>       struct task_struct *p;
>>       struct rq *src_rq;
>> +     struct cpumask *high_mask = __get_cpu_var(high_cpu_mask);
>> +     int prio = 0;
>>
>>       if (likely(!rt_overloaded(this_rq)))
>>               return 0;
>> +loop:
>> +     if (! (prio < this_rq->rt.highest_prio.curr))
>> +             return ret;
>> +
>> +     if (! cpupri_find_prio(&this_rq->rd->cpupri, prio,
>> +                             this_rq->rd->rto_mask, high_mask)) {
>> +             prio++;
>> +             goto loop;
>> +     }
>
> This loop looks to be expensive in the hot path.
>

You are right, the introduced overhead in worse cases is
this_rq->rt.highest_prio.curr times bit-test like

        if (cp->pri_active[task_prio / BITS_PER_LONG] &
             (1UL << ((BITS_PER_LONG - 1) - (task_prio % BITS_PER_LONG)))) {

which I think slowdowns the hot patch a lot:/

> Note, in practice, not many RT tasks are running at the same time. If
> this is not the case, then please explain what situation has multiple RT
> tasks contending for more than one CPU where RT tasks are forced to
> migrate continuously, and this patch fixes the situation.
>

The situation is hard to be constructed, I guess it is only captured by
rt_overloaded()


> I understand that the current code looks a bit expensive, as it loops
> through the CPUs that are overloaded, and pulls over the RT tasks
> waiting to run that are of higher priority than the one currently on
> this task. If it picks wrong, it could potentially pull over more than
> one task.
>
> But in practice (and I've traced this a while back), it seldom ever
> happens.
>
> But if you see that this code is hitting the slow path constantly, and
> your code shows better performance, and you can demonstrate this via a
> benchmark that I could use to reproduce, then I will consider taking
> these changes.
>

Since you already traced, the hitting could not happen, I believe.

thanks
           Hillf
