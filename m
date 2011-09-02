Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab1IBIJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 04:09:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43831 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172Ab1IBIJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 04:09:02 -0400
Message-ID: <4E608F10.3000107@gmail.com>
Date: Fri, 02 Sep 2011 16:08:48 +0800
From: Shan Hai <haishan.bai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
CC: Yong Zhang <yong.zhang0@gmail.com>, sifram rajas <sifram.rajas@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: General question about TASK_INTERRUPTIBLE and schedule_timeout()
References: <CA+OjSzzrYggQjDrgd6m+oF1sZkJFzf-3vSedAT3DAD9V2jTC3A@mail.gmail.com>	<20110901020947.GA9096@zhy>	<4E607523.30907@gmail.com>	<4E608081.5000107@gmail.com> <CAFPAmTT_kCjKvZ5rjq20f-dZN8uxd-x62k+qTkYV7=8Y8tyZ3g@mail.gmail.com>
In-Reply-To: <CAFPAmTT_kCjKvZ5rjq20f-dZN8uxd-x62k+qTkYV7=8Y8tyZ3g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 03:31 PM, kautuk.c @samsung.com wrote:
> On Fri, Sep 2, 2011 at 12:36 PM, Shan Hai<haishan.bai@gmail.com>  wrote:
>> On 09/02/2011 02:18 PM, Shan Hai wrote:
>>> On 09/01/2011 10:09 AM, Yong Zhang wrote:
>>>> On Wed, Aug 31, 2011 at 06:18:19PM +0530, sifram rajas wrote:
>>>>> Hi,
>>>>>
>>>>> I have a general question about the following 2 lines of code I see
>>>>> all over the kernel:
>>>>> 1         set_current_state(TASK_INTERRUPTIBLE) ;
>>>>> 2         schedule_timeout(<some value>);
>>>>>
>>>>> In the above code, if we encounter an interrupt after executing line
>>>>> 1, we will end up
>>>>> call schedule() from the architecture specific code for CONFIG_PREEMPT
>>>>> kernels, after
>>>>> the interrupt handler has been invokled.
>>>> Yes.
>>>>
>>>>> This will cause the current task to sleep interruptibly forever
>>> Actually, sleeping forever in the TASK_INTERRUPTIBLE state is not correct,
>>> because even though the task is preempted by higher priority one
>>> it will finally get a chance to run, but you will get time out value
>>> of<some value>  + preemption latency.
>>>
>>>>> instead of for a certain timeout interval.
>>>> No.
>>>>
>>>> schedule() will not put an preempted task to sleep, see:
>>> This might be problematic, because on the IRQ to preemption check path
>>> the PREEMPT_ACTIVE was already set and the following 'if' statement
>>> could not hold because of
>>> !(preempt_count()&  PREEMPT_ACTIVE) == false
> Yes.
>
>>> and the pick_next_task() might put the preempted task to sleep.
>>>
> pick_next_task() will simply select the next task for scheduling.
> After all running tasks have been scheduled then this preempted task
> will also be rescheduled
> as it is still on this runqueue.
>
> I do not think that this will put this preempted it to sleep.
> Reason: Although the state is still set to TASK_INTERRUPTIBLE, the
> task is not removed
> from the runqueue as !(preempt_count()&  PREEMPT_ACTIVE) == false.
>
>

Yep, that's right,  call 'sleep' here is improper, the right way
to put it should be 'the current task is deprived of its CPU' OR
'the current lost the CPU', we call sleep when a task is
removed from the run queue anyway :-)

>> I mean when the state of task is TASK_INTERRUPTIBLE the preempted task will
>> be put to sleep, its true in sifram's case.
> I disagree.Yong is still right in this scenario as the task will
> remain on the runqueue due to
> the !(preempt_count()&  PREEMPT_ACTIVE) == false.
>

As stated above.

Cheers
Shan Hai

>> Yong is right on stating "schedule() will not put an preempted task to
>> sleep",
>> its true for the task state of which is TASK_RUNNING.
> Since TASK_RUNNING is defined as 0, the task remains on the runqueue here also.
>
>> Cheers
>> Shan Hai
>>
>>> Correct me on any misunderstanding :-)
>>>
>>> Cheers
>>> Shan Hai
>>>
>>>> asmlinkage void __sched schduule(void)
>>>> {
>>>> ...
>>>>          if (prev->state&&    !(preempt_count()&    PREEMPT_ACTIVE)) {
>>>>                  if (unlikely(signal_pending_state(prev->state, prev))) {
>>>>                          prev->state = TASK_RUNNING;
>>>>                  } else {
>>>>         ...
>>>>         }
>>>>          }
>>>> ...
>>>> }
>>>>
>>>> Thanks,
>>>> Yong
>>>>
>>>>> Won't this defeat the purpose of the above code to schedule out or
>>>>> sleep for a certain finite timeout ?
>>>>> If yes, then what are the techniques to solve this problem ?
>>>>>
>>>>>
>>>>> Thanks,
>>>>> Sifram.
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>>>>> in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>> Please read the FAQ at  http://www.tux.org/lkml/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>

