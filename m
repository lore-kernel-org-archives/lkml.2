Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0DFNbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 09:31:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908Ab0DFNbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 09:31:07 -0400
Message-ID: <4BBB377B.2020204@redhat.com>
Date: Tue, 06 Apr 2010 16:30:35 +0300
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
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <4BBA5305.7010002@redhat.com> <4BBA5C00.4090703@us.ibm.com> <4BBA6279.20802@redhat.com> <4BBA6F0B.2060008@us.ibm.com>
In-Reply-To: <4BBA6F0B.2060008@us.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 02:15 AM, Darren Hart wrote:
> Avi Kivity wrote:
>
>>>> An interesting (but perhaps difficult to achieve) optimization 
>>>> would be to spin in userspace.
>>>
>>> I couldn't think of a lightweight way to determine when the owner 
>>> has been scheduled out in userspace. Kernel assistance is required. 
>>> You could do this on the schedule() side of things, but I figured 
>>> I'd get some strong pushback if I tried to add a hook into 
>>> descheduling that flipped a bit in the futex value stating the owner 
>>> was about to deschedule(). Still, that might be something to explore.
>>
>> In the futex value it's hopeless (since a thread can hold many locks), 
>
> It can, but there is a futex value per lock. If the task_struct had a 
> list of held futex locks (as it does for pi futex locks) the 
> deschedule() path could walk that and mark the FUTEX_OWNER_SLEEPING bit.
>

You don't want the context switch path to walk a list whose length is 
user controlled.

>> but I don't think it's unreasonable to set a bit in the thread local 
>> storage area.  The futex format would then need to be extended to 
>> contain a pointer to this bit.
>
> This appears to be 1 bit per task instead of 1 bit per lock. 

Yes.  O(1) on context switch instead of O(n).

> Also, the value is thread-specific... so how would a potential waiter 
> be able to determine if the owner of a particular lock was running or 
> not with this method?  ... maybe I'm missing some core bit about 
> TLS... are you talking about pthread_key_create() and 
> pthread_getspecific() ?

The lock would need to contain a pointer to the owning task.  Could be 
set with cmpxchg{8,16}b on x86.

-- 
error compiling committee.c: too many arguments to function

