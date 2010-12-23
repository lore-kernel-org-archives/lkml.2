Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab0LWJFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 04:05:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65181 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab0LWJFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 04:05:44 -0500
Message-ID: <4D13114D.5060709@cn.fujitsu.com>
Date: Thu, 23 Dec 2010 17:07:25 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
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
References: <4D07330A.7020600@cn.fujitsu.com>	 <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>	 <4D083900.1050801@cn.fujitsu.com>	 <1292386606.5015.1862.camel@gandalf.stny.rr.com>	 <4D0877D2.10000@cn.fujitsu.com> <1292425462.5015.1895.camel@gandalf.stny.rr.com>
In-Reply-To: <1292425462.5015.1895.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-23 17:05:33,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-23 17:05:33,
	Serialize complete at 2010-12-23 17:05:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 11:04 PM, Steven Rostedt wrote:
> On Wed, 2010-12-15 at 16:09 +0800, Lai Jiangshan wrote:
> 
> Some English updates.

Updated, Thank you very much.

> 
>>

[...]

>> + * owner	bit0
>> + * NULL		0	lock is free (fast acquire possible)
>> + * NULL		1	lock is free and has waiters and the top waiter
>> + *				is going to take the lock*
>> + * taskpointer	0	lock is held (fast release possible)
>> + * taskpointer	1	lock is held and has waiters
> 
>   * taskpointer 1        lock is held and has waiters*
> 
> 
>>   *
>>   * The fast atomic compare exchange based acquire and release is only
>> - * possible when bit 0 and 1 of lock->owner are 0.
>> + * possible when bit 0 of lock->owner are 0.
> 
> 	s/are/is/
> 
>>   *
>> - * (*) There's a small time where the owner can be NULL and the
>> - * "lock has waiters" bit is set.  This can happen when grabbing the lock.
>> - * To prevent a cmpxchg of the owner releasing the lock, we need to set this
>> - * bit before looking at the lock, hence the reason this is a transitional
>> - * state.
>> + * (*) It also can be a transitional state when grabbing the lock
>> + * with ->wait_lock is held. To prevent any fast path cmpxchg to the lock,
>> + * we need to set the bit0 before looking at the lock, and the owner may be
>> + * NULL in this small time, hence this can be a transitional state.
> 
> 
>  * (*) There is a small time when bit 0 is set but there are no
>  * waiters. This can happen when grabbing the lock in the slow path.
>  * To prevent a cmpxchg of the owner releasing the lock, we need to
>  * set this bit before looking at the lock.
> 
> 

Very good! Added.


> 
>> It has called try_to_take_rt_mutex() in __rt_mutex_slowlock(),
>> when timeout or got signal, it returns from __rt_mutex_slowlock()
>> with lock->wait_lock still held, and then calls remove_waiter(),
>>
>> so we don't need to call try_to_take_rt_mutex() in remove_waiter().
>> It is strange that remove_waiter() do some "require lock" work.
> 
> I think you are correct here. It should never get to this path where
> !owner && first is true. If we timed out then we either got the lock or
> we could not. If we could not than owner had to be set or we are not the
> top waiter. Thus we need:
> 
> 	if (!owner) {
> 		BUG_ON(first);
> 		return;
> 	}
> 

The "BUG_ON" is not added, but new comments for this are added.
Because we have just tested it in try_to_take_rt_mutex(), don't need
to check it again.

If prerequisites are passed by complex paths or are
provided by different threads, I will happy to add more checks.

Thanks,
Lai

