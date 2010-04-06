Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab0DFN3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 09:29:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab0DFN3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 09:29:06 -0400
Message-ID: <4BBB36FA.4020008@redhat.com>
Date: Tue, 06 Apr 2010 16:28:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Darren Hart <dvhltc@us.ibm.com>
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

On 04/06/2010 01:59 AM, Darren Hart wrote:
>
>
>>>> I'd be interested in seeing runs where the average number of 
>>>> waiters is 0.2, 0.5, 1, and 2, corresponding to moderate-to-bad 
>>>> contention.
>>>> 25 average waiters on compute bound code means the application 
>>>> needs to be rewritten, no amount of mutex tweaking will help it.
>>>
>>> Perhaps something NR_CPUS threads would be of more interest? 
>>
>> That seems artificial.
>
> How so? Several real world applications use one thread per CPU to 
> dispatch work to, wait for events, etc.

Yes, but that's the best case for spinning.  You could simply use a 
userspace spinlock in this case.


>
>>>> Does the wakeup code select the spinning waiter, or just a random 
>>>> waiter?
>>>
>>> The wakeup code selects the highest priority task in fifo order to 
>>> wake-up - however, under contention it is most likely going to go 
>>> back to sleep as another waiter will steal the lock out from under 
>>> it. This locking strategy is unashamedly about as "unfair" as it gets.
>>
>> Best to avoid the wakeup if we notice the lock was stolen.
>
> You really can't do this precisely. You can read the futex value at 
> various points along the wakeup path, but at some point you have to 
> commit to waking a task, and you still have a race between the time 
> you wake_up_task() and when it is scheduled and attempts the cmpxchg 
> itself.
>

The race is not a problem as it's just an optimization.  If you lose it 
you get a spurious wakeup, if you win you save some cpu cycles.


-- 
error compiling committee.c: too many arguments to function

