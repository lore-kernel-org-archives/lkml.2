Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab1IQMam (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 08:30:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53412 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1IQMak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 08:30:40 -0400
Message-ID: <4E749467.4010309@colorfullife.com>
Date: Sat, 17 Sep 2011 14:36:55 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC][PATCH 3/3] ipc/sem: Rework wakeup scheme
References: <20110914133034.687048806@chello.nl> <20110914133750.916911903@chello.nl> <4E7235F6.1030303@colorfullife.com> <1316115954.4060.23.camel@twins>
In-Reply-To: <1316115954.4060.23.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2011 09:45 PM, Peter Zijlstra wrote:
> On Thu, 2011-09-15 at 21:35 +0200, Peter Zijlstra wrote:
>> On Thu, 2011-09-15 at 21:32 +0200, Peter Zijlstra wrote:
>>>>> +static void wake_up_sem_queue_prepare(struct wake_list_head *wake_list,
>>>>>                              struct sem_queue *q, int error)
>>>>>    {
>>>>> +   struct task_struct *p = ACCESS_ONCE(q->sleeper);
>>>>>
>>>>> +   get_task_struct(p);
>>>>> +   q->status = error;
>>>>> +   /*
>>>>> +    * implies a full barrier
>>>>> +    */
>>>>> +   wake_list_add(wake_list, p);
>>>>> +   put_task_struct(p);
>>>>>    }
>>>> I think the get_task_struct()/put_task_struct is not necessary:
>>>> Just do the wake_list_add() before writing q->status:
>>>> wake_list_add() is identical to list_add_tail(&q->simple_list, pt).
>>>> [except that it contains additional locking, which doesn't matter here]
>> OK, I can't read properly.. so the problem with doing the
>> wake_list_add() before the write is that the wakeup can actually happen
>> before the write in case p already had a wakeup queued.
> Ah, but if the wakeup happens early, we return from schedule with -EINTR
> and re-acquire the sem_lock and re-test. Since we do this update from
> under sem_lock it should serialize and come out all-right,.. right?
Correct. Just think about a timeout of semtimedop().
The code handles early wakeup properly, it will either return -EAGAIN or 0.
(except for -EINTR).

--
     Manfred
