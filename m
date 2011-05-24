Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab1EXOMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:12:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33103 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab1EXOL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oH0bxMAQm7L4l4WlzyITqFGK/i7m6TEmXOABrXeTSQ+xNdsCH0rQxU+M/BnvO4w5sg
         +80a3dymM1UBHIlkEqOUkmi5xjha6Imlv9v4To8moXPsvkiMn8w5JUtj1JoI57lz4r5L
         MVip6kutQF1dG1uz9QK0/1OxY34B3X+x7aPfs=
MIME-Version: 1.0
In-Reply-To: <1306244745.1465.62.camel@gandalf.stny.rr.com>
References: <BANLkTinrHfVT43Evto3GqN8venDrLXoMbg@mail.gmail.com>
	<1306244745.1465.62.camel@gandalf.stny.rr.com>
Date: Tue, 24 May 2011 22:11:58 +0800
Message-ID: <BANLkTim0RtCjefq5Z2qbJFbBhrCHFfeGxg@mail.gmail.com>
Subject: Re: [PATCH] sched: remove starvation in check_preempt_equal_prio()
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 9:45 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-05-24 at 21:34 +0800, Hillf Danton wrote:
>> If there are pushable tasks and they are high enough in priority, in which
>> case task p is covered, the current could keep holding its CPU.
>>
>> Even if current task has to release its CPU, requeuing task p could result in
>> starvation of tasks that are of same priority and have been waiting on RQ for
>> a couple of hours:/
>
> Can you explain this better? Sounds like you are describing the
> definition of FIFO. You are *not* suppose to preempt a FIFO task just

I dont want to redefine FIFO, but starvation needs attention, since
the woken task is already off RQ, and its position on RQ is reshuffled.

thanks
          Hillf
> because another task of equal priority woke up on its run queue.
>
> Yes, if you queue two FIFO tasks of the same priority on the same run
> queue, and one runs for hours without calling schedule. The other one
> will have to wait.
>
> -- Steve
>
>
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- tip-git/kernel/sched_rt.c Sun May 22 20:12:01 2011
>> +++ sched_rt.c        Tue May 24 21:01:51 2011
>> @@ -1028,24 +1028,23 @@ select_task_rq_rt(struct task_struct *p,
>>       return cpu;
>>  }
>>
>> +static struct task_struct *pick_next_pushable_task(struct rq *);
>> +
>>  static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
>>  {
>> -     if (rq->curr->rt.nr_cpus_allowed == 1)
>> -             return;
>> -
>> -     if (p->rt.nr_cpus_allowed != 1
>> -         && cpupri_find(&rq->rd->cpupri, p, NULL))
>> +     if (rq->curr->rt.nr_cpus_allowed > 1) {
>> +             struct task_struct *push = pick_next_pushable_task(rq);
>> +             /*
>> +              * Though curr is pushable, if there are other pushable tasks,
>> +              * we keep curr busy.
>> +              */
>> +             if (push && !(push->prio > p->prio))
>> +                     return;
>> +     } else
>>               return;
>>
>> -     if (!cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
>> -             return;
>> -
>> -     /*
>> -      * There appears to be other cpus that can accept
>> -      * current and none to run 'p', so lets reschedule
>> -      * to try and push current away:
>> -      */
>> -     requeue_task_rt(rq, p, 1);
>> +     /* yield curr */
>> +     requeue_task_rt(rq, rq->curr, 0);
>>       resched_task(rq->curr);
>>  }
>>
>> @@ -1091,7 +1090,7 @@ static struct sched_rt_entity *pick_next
>>       BUG_ON(idx >= MAX_RT_PRIO);
>>
>>       queue = array->queue + idx;
>> -     next = list_entry(queue->next, struct sched_rt_entity, run_list);
>> +     next = list_first_entry(queue, struct sched_rt_entity, run_list);
>>
>>       return next;
>>  }
>
>
>
