Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934233Ab1IOQ6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 12:58:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62665 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934142Ab1IOQ6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 12:58:23 -0400
Message-ID: <4E723023.5080406@colorfullife.com>
Date: Thu, 15 Sep 2011 19:04:35 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH -rt] ipc/sem: Rework semaphore wakeups
References: <alpine.LFD.2.02.1109101052340.2723@ionos> <1315737307.6544.1.camel@marge.simson.net> <1315817948.26517.16.camel@twins> <1315835562.6758.3.camel@marge.simson.net> <1315839187.6758.8.camel@marge.simson.net> <1315926499.5977.19.camel@twins> <1315927699.6445.6.camel@marge.simson.net> <1315994224.5040.1.camel@twins> <4E70F6FD.2060709@colorfullife.com> <1316028213.5040.41.camel@twins>
In-Reply-To: <1316028213.5040.41.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2011 09:23 PM, Peter Zijlstra wrote:
> On Wed, 2011-09-14 at 20:48 +0200, Manfred Spraul wrote:
>> The code does:
>>
>>       spin_lock()
>>       preempt_disable();
>>       usually_very_simple_but_worstcase_O_2
>>       spin_unlock()
>>       usually_very_simple_but_worstcase_O_1
>>       preempt_enable();
>>
>> with your change, it becomes:
>>
>>       spin_lock()
>>       usually_very_simple_but_worstcase_O_2
>>       usually_very_simple_but_worstcase_O_1
>>       spin_unlock()
>>
>> The complex ops remain unchanged, they are still under a lock.
> preemptible lock (aka pi-mutex) on -rt, so no weird latencies.
But the change means that more operations are under spin_lock().
Acutally for a large SMP system with a simple semaphore operation, the 
wake_up_process() takes longer than the semaphore operation.
And for some databases, contention on the spin_lock() is an issue.


>> What about removing the preempt_disable?
>> It's only there to cover a rare race on uniprocessor preempt systems.
>> (a task is woken up simultaneously due to timeout of semtimedop() and a
>> true wakeup)
>>
>> Then fix the that race - something like the attached patch [obviously
>> buggy - see the fixme]
> sched_yield() is always a bug, as is it here. Its an life-lock if the
> woken task is of higher priority than the waking task. A higher prio
> FIFO task calling sched_yield() in a loop is just that, a loop, starving
> the lower prio waker.
>
> If you've got enough medium prio tasks around to occupy all other cpus,
> you're got indefinite priority inversion, so even on smp its a problem.
>
> But yeah its not the prettiest of solutions but it works.. see that
> other patch with the wake-list stuff for something that ought to work
> for both rt and mainline (except of course it doesn't actually work).
Wake lists are definitively the better approach.
[let's continue in that thread]

--
     Manfred
