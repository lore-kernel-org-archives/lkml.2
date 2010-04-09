Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab0DIFli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 01:41:38 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57070 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab0DIFlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 01:41:37 -0400
Message-ID: <4BBEBE0C.7050602@us.ibm.com>
Date: Thu, 08 Apr 2010 22:41:32 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: "Peter W. Morreale" <pmorreale@novell.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>, Rik van Riel <riel@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/6] futex: Add FUTEX_LOCK with optional adaptive spinning
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <1270499039-23728-5-git-send-email-dvhltc@us.ibm.com> <alpine.LFD.2.00.1004061818250.32352@localhost.localdomain> <4BBCC02C.5090000@us.ibm.com> <alpine.LFD.2.00.1004072124250.32352@localhost.localdomain> <4BBD4C92.8010701@us.ibm.com> <1270768233.6318.45.camel@hermosa.site>
In-Reply-To: <1270768233.6318.45.camel@hermosa.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter W. Morreale wrote:
> On Wed, 2010-04-07 at 20:25 -0700, Darren Hart wrote:
>> Thomas Gleixner wrote:
>>> On Wed, 7 Apr 2010, Darren Hart wrote:
>>>> Thomas Gleixner wrote:

>>>>> 	   if ((curval & FUTEX_TID_MASK) != ownertid) {
>>>>> 	      ownertid = curval & FUTEX_TID_MASK;
>>>>> 	      owner = update_owner(ownertid);
>>>>> 	   }
>>>> Hrm... at this point the owner has changed... so we should break and go
>>>> to sleep, not update the owner and start spinning again. The
>>>> futex_spin_on_owner() will detect this and abort, so I'm not seeing the
>>>> purpose of the above if() block.
>>> Why ? If the owner has changed and the new owner is running on another
>>> cpu then why not spin further ?
>> That's an interesting question, and I'm not sure what the right answer 
>> is. The current approach of the adaptive spinning in the kernel is to 
>> spin until the owner changes or deschedules, then stop and block. The 
>> idea is that if you didn't get the lock before the owner changed, you 
>> aren't going to get it in a very short period of time (you have at least 
>> an entire critical section to wait through plus whatever time you've 
>> already spent spinning). However, blocking just so another task can spin 
>> doesn't really make sense either, and makes the lock less fair than it 
>> could otherwise be.
> 
> Not only less fair, but potentially could cause starvation, no?  Perhaps
> you could see this if you changed your model to allow all contended
> tasks to spin instead of just one.  

Agreed, and V5 (just posted) does just that.

> 
> If a spinning task blocks because of an owner change, and a new task
> enters and starts spinning directly after the owner change, at what
> point does the original task get woken up?

At the time of unlock the owner will have to call FUTEX_WAKE. This task 
will wake and attempt to acquire the lock - it will lose races with 
aclready running contenders. Lock stealing, adaptive spinning, etc are 
all going to lead to less fair locks in exchange for throughput.

>  Its likely that the new
> spinner will get the resource next, no?  Rinse/repeat with another task
> and the original spinner is starved.  
> 
> (Or am I missing something?  My understanding was that unfairness was
> built-in to this algo... If so, then the above is a possibility, right?)

Yes it is. These locks are typically used in situations where it is more 
important that some work gets completed than _which_ work gets completed.

Thanks,

--
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
