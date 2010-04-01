Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0DACNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 22:13:25 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44626 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab0DACNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 22:13:24 -0400
Message-ID: <4BB40140.20109@us.ibm.com>
Date: Wed, 31 Mar 2010 19:13:20 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: "lkml," <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Peter Morreale <pmorreale@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: RFC: Ideal Adaptive Spinning Conditions
References: <4BB3D90C.3030108@us.ibm.com> <1270078689.19685.8040.camel@gandalf.stny.rr.com>
In-Reply-To: <1270078689.19685.8040.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2010-03-31 at 16:21 -0700, Darren Hart wrote:
> 
>> o What type of lock hold times do we expect to benefit?
> 
> 0 (that's a zero) :-p
> 
> I haven't seen your patches but you are not doing a heuristic approach,
> are you? That is, do not "spin" hoping the lock will suddenly become
> free. I was against that for -rt and I would be against that for futex
> too.

I'm not sure what you're getting at here. Adaptive spinning is indeed 
hoping the lock will become free while you are spinning and checking 
it's owner...

> 
>> o How much contention is a good match for adaptive spinning?
>>    - this is related to the number of threads to run in the test
>> o How many spinners should be allowed?
>>
>> I can share the kernel patches if people are interested, but they are 
>> really early, and I'm not sure they are of much value until I better 
>> understand the conditions where this is expected to be useful.
> 
> Again, I don't know how you implemented your adaptive spinners, but the
> trick to it in -rt was that it would only spin while the owner of the
> lock was actually running. If it was not running, it would sleep. No
> point waiting for a sleeping task to release its lock.

It does exactly this.

> Is this what you did? Because, IIRC, this only benefited spinlocks
> converted to mutexes. It did not help with semaphores, because
> semaphores could be held for a long time. Thus, it was good for short
> held locks, but hurt performance on long held locks.

Trouble is, I'm still seeing performance penalties even on the shortest 
critical section possible (lock();unlock();)

> If userspace is going to do this, I guess the blocked task would need to
> go into kernel, and spin there (with preempt enabled) if the task is
> still active and holding the lock.

It is currently under preempt_disable() just like mutexes. I asked Peter 
why it was done that way for mutexes, but didn't really get an answer. 
He did point out that since we check need_resched() at every iteration 
that we won't run longer than our timeslice anyway, so it shouldn't be a 
  problem.

> Then the application would need to determine which to use. An adaptive
> spinner for short held locks, and a normal futex for long held locks.

Yes, this was intended to be an optional thing (and certainly not the 
default).


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
