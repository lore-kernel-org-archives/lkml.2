Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab0DAPzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:55:07 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54407 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219Ab0DAPy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:54:56 -0400
Message-ID: <4BB4C1C4.2090208@us.ibm.com>
Date: Thu, 01 Apr 2010 08:54:44 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "lkml, " <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Peter Morreale <pmorreale@novell.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: RFC: Ideal Adaptive Spinning Conditions
References: <4BB3D90C.3030108@us.ibm.com> <4BB4ABBB.4000909@redhat.com>
In-Reply-To: <4BB4ABBB.4000909@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 04/01/2010 02:21 AM, Darren Hart wrote:
>> I'm looking at some adaptive spinning with futexes as a way to help 
>> reduce the dependence on sched_yield() to implement userspace 
>> spinlocks. Chris, I included you in the CC after reading your comments 
>> regarding sched_yield() at kernel summit and I thought you might be 
>> interested.
>>
>> I have an experimental patchset that implements FUTEX_LOCK and 
>> FUTEX_LOCK_ADAPTIVE in the kernel and use something akin to 
>> mutex_spin_on_owner() for the first waiter to spin. What I'm finding 
>> is that adaptive spinning actually hurts my particular test case, so I 
>> was hoping to poll people for context regarding the existing adaptive 
>> spinning implementations in the kernel as to where we see benefit. 
>> Under which conditions does adaptive spinning help?
>>
>> I presume locks with a short average hold time stand to gain the most 
>> as the longer the lock is held the more likely the spinner will expire 
>> its timeslice or that the scheduling gain becomes noise in the 
>> acquisition time. My test case simple calls "lock();unlock()" for a 
>> fixed number of iterations and reports the iterations per second at 
>> the end of the run. It can run with an arbitrary number of threads as 
>> well. I typically run with 256 threads for 10M iterations.
>>
>>          futex_lock: Result: 635 Kiter/s
>> futex_lock_adaptive: Result: 542 Kiter/s
> 
> A lock(); unlock(); loop spends most of its time with the lock held or 
> contended.  Can you something like this:
> 
> 
>    lock();
>    for (i = 0; i < 1000; ++i)
>         asm volatile ("" : : : "memory");
>    unlock();
>    for (i = 0; i < 10000; ++i)
>         asm volatile ("" : : : "memory");


Great idea. I'll be doing a more rigorous investigation on this of 
course, but I thought I'd share the results of just dumping this into 
the testcase:

# ./futex_lock -i10000000
futex_lock: Measure FUTEX_LOCK operations per second
	Arguments: iterations=10000000 threads=256 adaptive=0
Result: 420 Kiter/s
lock calls:      9999872
lock syscalls:   665824 (6.66%)
unlock calls:    9999872
unlock syscalls: 861240 (8.61%)

# ./futex_lock -a -i10000000
futex_lock: Measure FUTEX_LOCK operations per second
	Arguments: iterations=10000000 threads=256 adaptive=1
Result: 426 Kiter/s
lock calls:      9999872
lock syscalls:   558787 (5.59%)
unlock calls:    9999872
unlock syscalls: 603412 (6.03%)

This is the first time I've seen adaptive locking have an advantage! The 
second set of runs showed a slightly greater advantage. Note that this 
was still with spinners being limited to one.

My thanks to everyone for their insight. I'll be preparing some result 
matrices and will share the patches and testcases here shortly.

--
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
