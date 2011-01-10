Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab1AJLhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 06:37:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54189 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab1AJLhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 06:37:10 -0500
Message-ID: <4D2AEF7E.8060901@cn.fujitsu.com>
Date: Mon, 10 Jan 2011 19:37:34 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] rtmutex: ensure only the top waiter or higher priority
 task can take the lock and reduce unrelated boosting
References: <4D07330A.7020600@cn.fujitsu.com>	 <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>	 <4D083900.1050801@cn.fujitsu.com>	 <1292386606.5015.1862.camel@gandalf.stny.rr.com>	 <4D0877D2.10000@cn.fujitsu.com> <1294325428.26623.187.camel@gandalf.stny.rr.com>
In-Reply-To: <1294325428.26623.187.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-10 19:36:44,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-10 19:36:45,
	Serialize complete at 2011-01-10 19:36:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 10:50 PM, Steven Rostedt wrote:
> On Wed, 2010-12-15 at 16:09 +0800, Lai Jiangshan wrote:
> 
>>  kernel/futex.c          |   26 +---
>>  kernel/rtmutex.c        |  306 ++++++++++++++++--------------------------------
>>  kernel/rtmutex_common.h |   16 --
>>  3 files changed, 116 insertions(+), 232 deletions(-)
>>
>> diff --git a/kernel/futex.c b/kernel/futex.c
>> index 6c683b3..5f4ea5f 100644
>> --- a/kernel/futex.c
>> +++ b/kernel/futex.c
>> @@ -775,18 +775,10 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
>>  		return -EINVAL;
>>  
>>  	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
>> +	/* set new owner to the most possible owner(top waiter). */
>>  	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
>>  
>>  	/*
>> -	 * This happens when we have stolen the lock and the original
>> -	 * pending owner did not enqueue itself back on the rt_mutex.
>> -	 * Thats not a tragedy. We know that way, that a lock waiter
>> -	 * is on the fly. We make the futex_q waiter the pending owner.
>> -	 */
>> -	if (!new_owner)
>> -		new_owner = this->task;
> 
> Lai,
> 
> Why did you remove this? I just triggered a bug that was caused by
> rt_mutex_next_owner() returning NULL.
> 
> Hmm, reading the comment it looks like it would only return NULL if the
> next owner woke up and removed itself (which it does not do anymore).
> But, this code is called unconditionally. I'm thinking we can trigger
> this if a timeout occurred too.
> 
> I guess the real change should just be to the comment.
> 
> I can add trace debug to see if that was indeed the case.
> 

After this patch applied, the topwaiter will not be deququed when the lock
is released(any waiter is dequeued only when it really get the lock or give up).
So the wait list will not be empty if someone is still waiting on.

I thought, in this code, this->task is waiting, so rt_mutex_next_owner()
will not return NULL. As you found, my thought is wrong, we should just
change the comment.

Thanks,
Lai

