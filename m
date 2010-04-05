Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab0DEVyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 17:54:21 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42632 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756450Ab0DEVyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 17:54:15 -0400
Message-ID: <4BBA5C00.4090703@us.ibm.com>
Date: Mon, 05 Apr 2010 14:54:08 -0700
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
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <4BBA5305.7010002@redhat.com>
In-Reply-To: <4BBA5305.7010002@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 04/05/2010 11:23 PM, Darren Hart wrote:
>> In-Reply-To:
>>
>> NOT FOR INCLUSION
>>
>> The following patch series implements a new experimental kernel side 
>> futex mutex
>> via new FUTEX_LOCK and FUTEX_LOCK_ADAPTIVE futex op codes. The 
>> adaptive spin
>> follows the kernel mutex model of allowing one spinner until the lock is
>> released or the owner is descheduled. The patch currently allows the 
>> user to
>> specify if they want no spinning, a single adaptive spinner, or multiple
>> spinners (aggressive adaptive spinning, or aas... which I have 
>> mistyped as "ass"
>> enough times to realize a better term is indeed required :-).
>>    
> 
> An interesting (but perhaps difficult to achieve) optimization would be 
> to spin in userspace.

I couldn't think of a lightweight way to determine when the owner has 
been scheduled out in userspace. Kernel assistance is required. You 
could do this on the schedule() side of things, but I figured I'd get 
some strong pushback if I tried to add a hook into descheduling that 
flipped a bit in the futex value stating the owner was about to 
deschedule(). Still, that might be something to explore.

> 
> How many cores (or hardware threads) does this machine have?  

Sorry, I meant to include that. I tested on an 8 CPU (no hardware 
threads) 2.6 GHz Opteron 2218 (2 QuadCore CPUs) system.

 > At 10%
> duty cycle you have 25 waiters behind the lock on average.  I don't 
> think this is realistic, and it means that spinning is invoked only rarely.

Perhaps some instrumentation is in order, it seems to get invoked enough 
to achieve some 20% increase in lock/unlock iterations. Perhaps another 
metric would be of more value - such as average wait time?

> I'd be interested in seeing runs where the average number of waiters is 
> 0.2, 0.5, 1, and 2, corresponding to moderate-to-bad contention.
> 25 average waiters on compute bound code means the application needs to be 
> rewritten, no amount of mutex tweaking will help it.

Perhaps something NR_CPUS threads would be of more interest? At 10% 
that's about .8 and at 25% the 2 of your upper limit. I could add a few 
more duty-cycle points and make 25% the max. I'll kick that off and post 
the results... probably tomorrow, 10M iterations takes a while, but 
makes the results relatively stable.

> Does the wakeup code select the spinning waiter, or just a random waiter?

The wakeup code selects the highest priority task in fifo order to 
wake-up - however, under contention it is most likely going to go back 
to sleep as another waiter will steal the lock out from under it. This 
locking strategy is unashamedly about as "unfair" as it gets.


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
