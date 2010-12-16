Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab0LPBNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 20:13:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56168 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab0LPBNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 20:13:50 -0500
Message-ID: <4D096806.7000807@cn.fujitsu.com>
Date: Thu, 16 Dec 2010 09:14:46 +0800
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
References: <4D07330A.7020600@cn.fujitsu.com>	 <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>	 <4D083900.1050801@cn.fujitsu.com>	 <1292386606.5015.1862.camel@gandalf.stny.rr.com>	 <4D0877D2.10000@cn.fujitsu.com> <1292450002.5015.1903.camel@gandalf.stny.rr.com>
In-Reply-To: <1292450002.5015.1903.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-16 09:13:42,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-16 09:13:48,
	Serialize complete at 2010-12-16 09:13:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 05:53 AM, Steven Rostedt wrote:
> On Wed, 2010-12-15 at 16:09 +0800, Lai Jiangshan wrote:
> 
> 
>>  /*
>> @@ -543,11 +491,13 @@ static void remove_waiter(struct rt_mutex *lock,
>>  
>>  	raw_spin_lock_irqsave(&current->pi_lock, flags);
>>  	plist_del(&waiter->list_entry, &lock->wait_list);
>> -	waiter->task = NULL;
>>  	current->pi_blocked_on = NULL;
>>  	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
>>  
>> -	if (first && owner != current) {
>> +	if (!owner)
>> +		return;
>> +
>> +	if (first) {
> 
> This is a bug. There's a small chance that the mutex timed out, and at
> that same time, the owner gave up the lock and woke this task up. Which
> means this task is the new owner of the lock iff it was the
> rt_mutex_top_waiter().
> 
> The fix is to do this:
> 
> 
> 	if (!owner) {
> 		if (first) {
> 			ret = try_to_take_rt_mutex();
> 			BUG_ON(!ret);
> 		}
> 		return first;
> 	}
> 
> 	if (first) {
> 
> We need to make remove_waiter return 1 if it took the lock and 0 if it
> did not, so it can pass this information back to the caller.
> 
> 	if (unlikely(ret)) {
> 		if (remove_waiter(...))
> 			ret = 0;
> 	}
> 

It has called try_to_take_rt_mutex() in __rt_mutex_slowlock(),
when timeout or got signal, it returns from __rt_mutex_slowlock()
with lock->wait_lock still held, and then calls remove_waiter(),

so we don't need to call try_to_take_rt_mutex() in remove_waiter().
It is strange that remove_waiter() do some "require lock" work.

Thanks,
Lai

