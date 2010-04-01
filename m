Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab0DAMq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 08:46:59 -0400
Received: from soto.provo.novell.com ([137.65.250.214]:59010 "EHLO
	soto.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab0DAMqw convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com:9:1>);
	Thu, 1 Apr 2010 08:46:52 -0400
Message-Id: <4BB45D790200005A00063620@soto.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 01 Apr 2010 06:46:49 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: <rostedt@goodmis.org>, "Darren Hart" <dvhltc@us.ibm.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Eric Dumazet" <eric.dumazet@gmail.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Morreale" <PMorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>,
       "Chris Mason" <chris.mason@oracle.com>,
       "lkml" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Ideal Adaptive Spinning Conditions
References: <4BB3D90C.3030108@us.ibm.com>
 <1270078689.19685.8040.camel@gandalf.stny.rr.com>
 <4BB40140.20109@us.ibm.com>
 <1270088753.19685.8218.camel@gandalf.stny.rr.com>
 <4BB42C04.7090308@us.ibm.com>
In-Reply-To: <4BB42C04.7090308@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 4/1/2010 at 01:15 AM, in message <4BB42C04.7090308@us.ibm.com>, Darren Hart
<dvhltc@us.ibm.com> wrote: 
> Steven Rostedt wrote:
>> On Wed, 2010-03-31 at 19:13 -0700, Darren Hart wrote:
>>> Steven Rostedt wrote:
>>>> On Wed, 2010-03-31 at 16:21 -0700, Darren Hart wrote:
>>>>
>>>>> o What type of lock hold times do we expect to benefit?
>>>> 0 (that's a zero) :-p
>>>>
>>>> I haven't seen your patches but you are not doing a heuristic approach,
>>>> are you? That is, do not "spin" hoping the lock will suddenly become
>>>> free. I was against that for -rt and I would be against that for futex
>>>> too.
>>> I'm not sure what you're getting at here. Adaptive spinning is indeed 
>>> hoping the lock will become free while you are spinning and checking 
>>> it's owner...
>> 
>> I'm talking about the original idea people had of "lets spin for 50us
>> and hope it is unlocked before then", which I thought was not a good
>> idea.
>> 
>> 
>>>>> o How much contention is a good match for adaptive spinning?
>>>>>    - this is related to the number of threads to run in the test
>>>>> o How many spinners should be allowed?
>>>>>
>>>>> I can share the kernel patches if people are interested, but they are 
>>>>> really early, and I'm not sure they are of much value until I better 
>>>>> understand the conditions where this is expected to be useful.
>>>> Again, I don't know how you implemented your adaptive spinners, but the
>>>> trick to it in -rt was that it would only spin while the owner of the
>>>> lock was actually running. If it was not running, it would sleep. No
>>>> point waiting for a sleeping task to release its lock.
>>> It does exactly this.
>> 
>> OK, that's good.
>> 
>>>> Is this what you did? Because, IIRC, this only benefited spinlocks
>>>> converted to mutexes. It did not help with semaphores, because
>>>> semaphores could be held for a long time. Thus, it was good for short
>>>> held locks, but hurt performance on long held locks.
>>> Trouble is, I'm still seeing performance penalties even on the shortest 
>>> critical section possible (lock();unlock();)
>> 
>> performance penalties compared to what? not having adaptive at all?
> 
> Right. See the data in the original mail:
> 
> 
>           futex_lock: Result: 635 Kiter/s
> futex_lock_adaptive: Result: 542 Kiter/s
> 
> So 15% fewer lock/unlock iterations per second with in kernel adaptive 
> spinning enabled for a critical section approaching 0 in length. But If 
> we agree I'm taking the right approach, then it's time for me to polish 
> things up a bit and send them out for review.

Hi Darren,

Part of the magic of adaptive locks is the avoidance of the sleep path, and part of it is using the SMP resources in what is effectively a distributed search (e.g. having N cpus actively looking for when they can acquire verses going to sleep and having the scheduler wake them up later).

I haven't seen your algorithm, but if its not simply trading the sleep path for searching for acquisition+lockowner changes, that may perhaps be a reason for an observed regression.  For instance, if you have to do substantial work to get to the adaptive part of the algorithm, there could be an unbalanced amount of overhead in selecting this path. 

The whole premise is predicated on the following sequence chart:

non-adaptive:

time   |   threadA            |          threadB
----------------------------------------
         | lock(X)  (granted) |
  t0    |                           | lock(X) (contended)
         |                           | add_wait_list(X, B)
         | unlock(X)             |
         | grant(X, B)           |
         | wake_up(B)          | 
         |                           | schedule()
         |                           |         |
         |                           |         |
         |                           |         V
  t1    |                           | schedule() returns
         |                           | (returns from lock())

adaptive:

time   |   threadA            |          threadB
----------------------------------------
         | lock(X)  (granted) |
  t0    |                           | lock(X) (contended)
         | unlock(X)             |
         | grant(X, B)           |
         |                           | while(!is_granted(X, B) && is_running(lock_owner(X))
  t1    |                           | (returns from lock()

The idea is that the time interval t0-t1 is shorter in the adaptive case (at least most of the time), and is why the spinning doesn't end up hurting us (the cpu is also busy in the schedule() code otherwise).  This is the win-win scenario for adaptive.  This is the case generally with short-hold locks (like the spinlocks that were converted to mutexes in -rt tend to be). 

For cases where the lock is held longer than the scheduling overhead, we will undoubtedly see more cpu utilization than the non-adaptive case.  However, we may _still_ see performance improvements in some scenarios due to the fact that the "grant" operation still has less overhead (thead A can skip the "wakeup" and therefore thread B still comes out of the loop with less latency that it could otherwise.  In this scenario you are trading cpu cycles for reduced latency, though the performance gains (if any) are not as profound in the ideal case. 

..and then of course there are cpu-bound workloads with long(er) held locks.   They don't like adaptive-locks much at all ;)

Long story short, I would try to quantify what your "t1-t0" delta actually is for the workload you are observing to start.  That will give you a ballpark of whether you should expect any gains or not. 

-Greg 

