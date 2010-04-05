Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab0DEXAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:00:24 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55013 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab0DEXAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:00:17 -0400
Message-ID: <4BBA6B6F.7040201@us.ibm.com>
Date: Mon, 05 Apr 2010 15:59:59 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive
 spinning
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <4BBA5305.7010002@redhat.com> <4BBA5C00.4090703@us.ibm.com> <4BBA6279.20802@redhat.com>
In-Reply-To: <4BBA6279.20802@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:

>> > At 10%
>>> duty cycle you have 25 waiters behind the lock on average.  I don't 
>>> think this is realistic, and it means that spinning is invoked only 
>>> rarely.
>>
>> Perhaps some instrumentation is in order, it seems to get invoked 
>> enough to achieve some 20% increase in lock/unlock iterations. Perhaps 
>> another metric would be of more value - such as average wait time?
> 
> Why measure an unrealistic workload?

No argument there, thus my proposal for an alternate configuration below.

>>> I'd be interested in seeing runs where the average number of waiters 
>>> is 0.2, 0.5, 1, and 2, corresponding to moderate-to-bad contention.
>>> 25 average waiters on compute bound code means the application needs 
>>> to be rewritten, no amount of mutex tweaking will help it.
>>
>> Perhaps something NR_CPUS threads would be of more interest? 
> 
> That seems artificial.

How so? Several real world applications use one thread per CPU to 
dispatch work to, wait for events, etc.

> 
>> At 10% that's about .8 and at 25% the 2 of your upper limit. I could 
>> add a few more duty-cycle points and make 25% the max. I'll kick that 
>> off and post the results... probably tomorrow, 10M iterations takes a 
>> while, but makes the results relatively stable.
> 
> Thanks.  But why not vary the number of threads as well?

Absolutely, I don't disagree that all the variables should vary in order 
to get a complete picture. I'm starting with 8 - it takes several hours 
to collect the data.

>>> Does the wakeup code select the spinning waiter, or just a random 
>>> waiter?
>>
>> The wakeup code selects the highest priority task in fifo order to 
>> wake-up - however, under contention it is most likely going to go back 
>> to sleep as another waiter will steal the lock out from under it. This 
>> locking strategy is unashamedly about as "unfair" as it gets.
> 
> Best to avoid the wakeup if we notice the lock was stolen.

You really can't do this precisely. You can read the futex value at 
various points along the wakeup path, but at some point you have to 
commit to waking a task, and you still have a race between the time you 
wake_up_task() and when it is scheduled and attempts the cmpxchg itself.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
