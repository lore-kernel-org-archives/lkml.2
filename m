Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab1LVUDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:03:05 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46789 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab1LVUDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:03:03 -0500
MIME-Version: 1.0
In-Reply-To: <20111222172211.C6A8.E1E9C6FF@jp.fujitsu.com>
References: <20111222094241.C691.E1E9C6FF@jp.fujitsu.com> <4EF29276.5050309@gmail.com>
 <20111222172211.C6A8.E1E9C6FF@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 22 Dec 2011 15:02:39 -0500
Message-ID: <CAHGf_=riHJSSsf7Q-G9X3L0etV4n+x4LxdXXGCOuXxn3ih6Nww@mail.gmail.com>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I doubt it is not only TASK_DEAD issue, it is rwsem fundamental issue.
>> Because of, a lot of place assume "current->state = newstate" is safe
>> and don't need any synchronization. So, I'm worry about to lost
>> TASK_UNINTERRUPTIBLE can make catastrophe like TASK_DEAD.
>
> I don't understand why this is catastrophe.
> I suppose it is just waken up from TASK_UNINTERRUPTIBLE
> by try_to_wake_up() in race condition. It seems to be normal situation.....

First, yes, try_to_wake_up() has a race. caller must care for spurious wakeup.
But, mutex, rwsem and other synchronization primitives must hide it and ensure
locking semantics. That's one of the reason why we use lock primitive instead
of bare try_to_wake_up(). I don't think "hey, all drivers code must
know scheduler
race and scheduler internal deeply" is practical solution.


> But TASK_DEAD status is special. It must not return to TASK_RUNNING state.

O.K. agree. but your patch seems just hacky. (1) I'm worry about why
out of scheduler
code know pi_lock and take it (2) all of other task->state changing
place don't take
pi_lock. so, your proposed locking semantics is not clear.

So, to remove TASK_DEAD and to add new member task->is_dead is alternative idea.



>> @@ -208,9 +208,9 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
>>
>>          /* wait to be given the lock */
>>          for (;;) {
>> +               schedule();
>>                  if (!waiter.task)
>>                          break;
>> -               schedule();
>>                  set_task_state(tsk, TASK_UNINTERRUPTIBLE);
>>          }
>>
>
> Hmmmmmmm.
> Are you sure there is no route which TASK_DEAD task is waken up like rwsem?

Not sure. but all of them are a bug if exist, I think.
