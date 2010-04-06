Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab0DFVWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:22:35 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51945 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756438Ab0DFVWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:22:30 -0400
Message-ID: <4BBBA610.3090200@us.ibm.com>
Date: Tue, 06 Apr 2010 14:22:24 -0700
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
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <4BBA5305.7010002@redhat.com> <4BBA5C00.4090703@us.ibm.com> <4BBA6279.20802@redhat.com> <4BBA6B6F.7040201@us.ibm.com>
In-Reply-To: <4BBA6B6F.7040201@us.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart wrote:
> Avi Kivity wrote:
> 
>>> > At 10%
>>>> duty cycle you have 25 waiters behind the lock on average.  I don't 
>>>> think this is realistic, and it means that spinning is invoked only 
>>>> rarely.
>>>
>>> Perhaps some instrumentation is in order, it seems to get invoked 
>>> enough to achieve some 20% increase in lock/unlock iterations. 
>>> Perhaps another metric would be of more value - such as average wait 
>>> time?
>>
>> Why measure an unrealistic workload?
> 
> No argument there, thus my proposal for an alternate configuration below.
> 
>>>> I'd be interested in seeing runs where the average number of waiters 
>>>> is 0.2, 0.5, 1, and 2, corresponding to moderate-to-bad contention.
>>>> 25 average waiters on compute bound code means the application needs 
>>>> to be rewritten, no amount of mutex tweaking will help it.
>>>
>>> Perhaps something NR_CPUS threads would be of more interest? 
>>
>> That seems artificial.
> 
> How so? Several real world applications use one thread per CPU to 
> dispatch work to, wait for events, etc.
> 
>>
>>> At 10% that's about .8 and at 25% the 2 of your upper limit. I could 
>>> add a few more duty-cycle points and make 25% the max. I'll kick that 
>>> off and post the results... probably tomorrow, 10M iterations takes a 
>>> while, but makes the results relatively stable.
>>
>> Thanks.  But why not vary the number of threads as well?
> 
> Absolutely, I don't disagree that all the variables should vary in order 
> to get a complete picture. I'm starting with 8 - it takes several hours 
> to collect the data.

While this might be of less interest after today's discussion, I 
promised to share the results of a run with 8 threads with a wider 
selection of lower duty-cycles. The results are very poor for adaptive 
and worse for aas (multiple spinners) compared to normal FUTEX_LOCK. As 
Thomas and Peter have pointed out, the implementation is sub-optimal. 
Before abandoning this approach I will see if I can find the bottlenecks 
and simplify the kernel side of things. My impression is that I am doing 
a lot more work in the kernel, especially in the adaptive loop, than is 
really necessary.

Both the 8 and 256 Thread plots can be viewed here:

http://www.kernel.org/pub/linux/kernel/people/dvhart/adaptive_futex/v4/

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
