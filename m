Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab1CGTn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 14:43:27 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:51938 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab1CGTn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 14:43:26 -0500
X-ASG-Debug-ID: 1299527004-01de284cf81cfc0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D753556.3020800@fusionio.com>
Date: Mon, 7 Mar 2011 20:43:18 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>	 <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>	 <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>	 <20110303221353.GA10366@redhat.com>	 <AANLkTi=MfDzf+-eLbysoP-ZiXX6cV_tVxYE14Vr8FSak@mail.gmail.com>	 <20110304214359.GA18442@redhat.com> <4D715E8A.5070006@fusionio.com>	 <20110304222702.GB18921@redhat.com>  <4D72A302.6060008@fusionio.com> <1299493427.2308.11.camel@twins>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <1299493427.2308.11.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299527004
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57340
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-07 11:23, Peter Zijlstra wrote:
> On Sat, 2011-03-05 at 21:54 +0100, Jens Axboe wrote:
>>
>> Apparently so. Peter/Ingo, please shoot this one down in flames.
>> Summary:
>>
>> - Need a way to trigger this flushing when a task is going to sleep
>> - It's currently done right before calling deactivate_task(). We know
>>   the task is going to sleep here, but it's also under the runqueue
>>   lock. Not good.
>> - In the new location, it's not completely clear to me whether we can
>>   safely deref 'prev' or not. The usage of prev_state would seem to
>>   indicate that we cannot, and as far as I can tell, prev could at this
>>   point already potentially be running on another CPU.
>>
>> Help? Peter, we talked about this in Tokyo in September. Initial
>> suggestion was to use preempt notifiers, which we can't because:
>>
>> - runqueue lock is also held
>> - It's not unconditionally available, depends on config.
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index e806446..8581ad3 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -2826,6 +2826,14 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
>>  #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
>>         finish_lock_switch(rq, prev);
>>  
>> +       /*
>> +        * If this task has IO plugged, make sure it
>> +        * gets flushed out to the devices before we go
>> +        * to sleep
>> +        */
>> +       if (prev_state != TASK_RUNNING)
>> +               blk_flush_plug(prev);
>> +
>>         fire_sched_in_preempt_notifiers(current);
>>         if (mm)
>>                 mmdrop(mm);
>> @@ -3973,14 +3981,6 @@ need_resched_nonpreemptible:
>>                                 if (to_wakeup)
>>                                         try_to_wake_up_local(to_wakeup);
>>                         }
>> -                       /*
>> -                        * If this task has IO plugged, make sure it
>> -                        * gets flushed out to the devices before we go
>> -                        * to sleep
>> -                        */
>> -                       blk_flush_plug(prev);
>> -                       BUG_ON(prev->plug && !list_empty(&prev->plug->list));
>> -
>>                         deactivate_task(rq, prev, DEQUEUE_SLEEP);
>>                 }
>>                 switch_count = &prev->nvcsw;
>>
> 
> Right, so your new location is still under rq->lock for a number of
> architectures (including x86). finish_lock_switch() doesn't actually
> release the lock unless __ARCH_WANT_INTERRUPTS_ON_CTXSW ||
> __ARCH_WANT_UNLOCKED_CTXSW (the former implies the latter since rq->lock
> is IRQ-safe).

Ah, thanks for that.

> If you want a safe place to drop rq->lock (but keep in mind to keep IRQs
> disabled there) and use prev, do something like the below. Both
> pre_schedule() and idle_balance() can already drop the rq->lock do doing
> it once more is quite all-right ;-)
> 
> Note that once you drop rq->lock prev->state can change to TASK_RUNNING
> again so don't re-check that.

So that's a problem. If I end up flushing this structure that sits on
the stack of the process, I cannot have it running on another CPU at
that time.

I need the process to be in such a state that it will not get scheduled
on another CPU before this has completed.

Is that even possible? If not, then I think the best solution is to
flush on preempt as well and hence move it up a bit like Shaohua posted
as well. This is also how it was originally done, but I wanted to avoid
that if at all possible.


-- 
Jens Axboe

