Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab0DARKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:10:20 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40894 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab0DARKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:10:12 -0400
Message-ID: <4BB4D36A.5080204@us.ibm.com>
Date: Thu, 01 Apr 2010 10:10:02 -0700
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
References: <4BB3D90C.3030108@us.ibm.com> <4BB4ABBB.4000909@redhat.com> <4BB4C1C4.2090208@us.ibm.com> <4BB4C566.8060308@redhat.com>
In-Reply-To: <4BB4C566.8060308@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 04/01/2010 06:54 PM, Darren Hart wrote:
>>> A lock(); unlock(); loop spends most of its time with the lock held 
>>> or contended.  Can you something like this:
>>>
>>>
>>>    lock();
>>>    for (i = 0; i < 1000; ++i)
>>>         asm volatile ("" : : : "memory");
>>>    unlock();
>>>    for (i = 0; i < 10000; ++i)
>>>         asm volatile ("" : : : "memory");
>>
>>
>>
>> Great idea. I'll be doing a more rigorous investigation on this of 
>> course, but I thought I'd share the results of just dumping this into 
>> the testcase:
>>
>> # ./futex_lock -i10000000
>> futex_lock: Measure FUTEX_LOCK operations per second
>>     Arguments: iterations=10000000 threads=256 adaptive=0
>> Result: 420 Kiter/s
>> lock calls:      9999872
>> lock syscalls:   665824 (6.66%)
>> unlock calls:    9999872
>> unlock syscalls: 861240 (8.61%)
>>
>> # ./futex_lock -a -i10000000
>> futex_lock: Measure FUTEX_LOCK operations per second
>>     Arguments: iterations=10000000 threads=256 adaptive=1
>> Result: 426 Kiter/s
>> lock calls:      9999872
>> lock syscalls:   558787 (5.59%)
>> unlock calls:    9999872
>> unlock syscalls: 603412 (6.03%)
>>
>> This is the first time I've seen adaptive locking have an advantage! 
>> The second set of runs showed a slightly greater advantage. Note that 
>> this was still with spinners being limited to one.
> 
> Question - do all threads finish at the same time, or wildly different 
> times?

I'm not sure, I can add some fairness metrics to the test that will help 
characterize how that's working. My suspicion is that there will be 
several threads that don't make any progress until the very end - since 
adaptive spinning is an "unfair" locking technique.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
