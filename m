Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab0DACZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 22:25:42 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42485 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386Ab0DACZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 22:25:39 -0400
Message-ID: <4BB4041C.6020302@us.ibm.com>
Date: Wed, 31 Mar 2010 19:25:32 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: "Peter W. Morreale" <pmorreale@novell.com>
CC: rostedt@goodmis.org, "lkml," <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: RFC: Ideal Adaptive Spinning Conditions
References: <4BB3D90C.3030108@us.ibm.com> <1270078689.19685.8040.camel@gandalf.stny.rr.com> <1270081066.2997.22.camel@hermosa.site>
In-Reply-To: <1270081066.2997.22.camel@hermosa.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter W. Morreale wrote:
> On Wed, 2010-03-31 at 19:38 -0400, Steven Rostedt wrote:
>> On Wed, 2010-03-31 at 16:21 -0700, Darren Hart wrote:
>>
>>> o What type of lock hold times do we expect to benefit?
>> 0 (that's a zero) :-p
>>
>> I haven't seen your patches but you are not doing a heuristic approach,
>> are you? That is, do not "spin" hoping the lock will suddenly become
>> free. I was against that for -rt and I would be against that for futex
>> too.
>>
>>> o How much contention is a good match for adaptive spinning?
>>>    - this is related to the number of threads to run in the test
>>> o How many spinners should be allowed?
>>>
>>> I can share the kernel patches if people are interested, but they are 
>>> really early, and I'm not sure they are of much value until I better 
>>> understand the conditions where this is expected to be useful.
>> Again, I don't know how you implemented your adaptive spinners, but the
>> trick to it in -rt was that it would only spin while the owner of the
>> lock was actually running. If it was not running, it would sleep. No
>> point waiting for a sleeping task to release its lock.
> 
> Right.  This was *critical* for the adaptive rtmutex.   Note in the RT
> patch, everybody spins as long as the current owner is on CPU.

Everybody spins? Really? For RT Tasks I suppose that makes sense as they 
will sort out the priority for themselves and if they preempt the owner 
they will all immediately schedule out and boost the priority of the 
owner.... but then we lose the benefit of spinning since we just put 
everyone to sleep. I'll have to take a look at that and see what I'm 
missing.


> FWIW, IIRC, Solaris has a heuristic approach where incoming tasks spin
> for a period of time before going to sleep.  (Cray UINCOS did the same) 

I suppose a heuristic approach could still be used so long as continued 
spinning was conditional on the owner continuing to run on a CPU.


>> Is this what you did? Because, IIRC, this only benefited spinlocks
>> converted to mutexes. It did not help with semaphores, because
>> semaphores could be held for a long time. Thus, it was good for short
>> held locks, but hurt performance on long held locks.
>>
> 
> nod.  The entire premise was based on the fact that we were converting
> spinlocks, which by definition were short held locks.  What I found
> during early development was that the sleep/wakeup cycle was more
> intrusive for RT than spinning.  

Right, and I'm looking to provide some kernel assistance for userspace 
spinlocks here, and am targeting short lived critical sections as well.

> 
> IIRC, I measured something like 380k context switches/second prior to
> the adaptive patches for a dbench test and we cut this down to somewhere
> around 50k, with a corresponding increase in throughput.  (I can't
> remember specific numbers any more, it was a while ago... ;-)
> 
> When applied to semaphores, the benefit was in the noise range as I
> recall..
> 
> (dbench was chosen due to the heavy contention on the dcache spinlock) 

Interesting, thanks for the input.

--
Darren

> 
> 
> Best,
> -PWM
> 
> 
>> If userspace is going to do this, I guess the blocked task would need to
>> go into kernel, and spin there (with preempt enabled) if the task is
>> still active and holding the lock.
>>
>> Then the application would need to determine which to use. An adaptive
>> spinner for short held locks, and a normal futex for long held locks.
>>
>> -- Steve
>>
>>
> 
> 


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
