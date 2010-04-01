Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0DAFP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 01:15:59 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46002 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab0DAFPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 01:15:53 -0400
Message-ID: <4BB42C04.7090308@us.ibm.com>
Date: Wed, 31 Mar 2010 22:15:48 -0700
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
References: <4BB3D90C.3030108@us.ibm.com> <1270078689.19685.8040.camel@gandalf.stny.rr.com> <4BB40140.20109@us.ibm.com> <1270088753.19685.8218.camel@gandalf.stny.rr.com>
In-Reply-To: <1270088753.19685.8218.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2010-03-31 at 19:13 -0700, Darren Hart wrote:
>> Steven Rostedt wrote:
>>> On Wed, 2010-03-31 at 16:21 -0700, Darren Hart wrote:
>>>
>>>> o What type of lock hold times do we expect to benefit?
>>> 0 (that's a zero) :-p
>>>
>>> I haven't seen your patches but you are not doing a heuristic approach,
>>> are you? That is, do not "spin" hoping the lock will suddenly become
>>> free. I was against that for -rt and I would be against that for futex
>>> too.
>> I'm not sure what you're getting at here. Adaptive spinning is indeed 
>> hoping the lock will become free while you are spinning and checking 
>> it's owner...
> 
> I'm talking about the original idea people had of "lets spin for 50us
> and hope it is unlocked before then", which I thought was not a good
> idea.
> 
> 
>>>> o How much contention is a good match for adaptive spinning?
>>>>    - this is related to the number of threads to run in the test
>>>> o How many spinners should be allowed?
>>>>
>>>> I can share the kernel patches if people are interested, but they are 
>>>> really early, and I'm not sure they are of much value until I better 
>>>> understand the conditions where this is expected to be useful.
>>> Again, I don't know how you implemented your adaptive spinners, but the
>>> trick to it in -rt was that it would only spin while the owner of the
>>> lock was actually running. If it was not running, it would sleep. No
>>> point waiting for a sleeping task to release its lock.
>> It does exactly this.
> 
> OK, that's good.
> 
>>> Is this what you did? Because, IIRC, this only benefited spinlocks
>>> converted to mutexes. It did not help with semaphores, because
>>> semaphores could be held for a long time. Thus, it was good for short
>>> held locks, but hurt performance on long held locks.
>> Trouble is, I'm still seeing performance penalties even on the shortest 
>> critical section possible (lock();unlock();)
> 
> performance penalties compared to what? not having adaptive at all?

Right. See the data in the original mail:


          futex_lock: Result: 635 Kiter/s
futex_lock_adaptive: Result: 542 Kiter/s

So 15% fewer lock/unlock iterations per second with in kernel adaptive 
spinning enabled for a critical section approaching 0 in length. But If 
we agree I'm taking the right approach, then it's time for me to polish 
things up a bit and send them out for review.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
