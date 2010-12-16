Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab0LPUdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:33:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:19906 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab0LPUdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:33:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,356,1288594800"; 
   d="scan'208";a="687909712"
Message-ID: <4D0A77B5.3040900@linux.intel.com>
Date: Thu, 16 Dec 2010 12:33:57 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Lai Jiangshan <eag0628@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] rtmutex: ensure only the top waiter or higher priority
 task can take the lock and reduce unrelated boosting
References: <4D07330A.7020600@cn.fujitsu.com>	<alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>	<4D083900.1050801@cn.fujitsu.com>	<1292386606.5015.1862.camel@gandalf.stny.rr.com>	<4D0877D2.10000@cn.fujitsu.com>	<alpine.LFD.2.00.1012151029090.12146@localhost6.localdomain6> <AANLkTi=x-_ffBnFL4TMtjGBBpbu9aBvSHKiQ7BgNy7J0@mail.gmail.com>
In-Reply-To: <AANLkTi=x-_ffBnFL4TMtjGBBpbu9aBvSHKiQ7BgNy7J0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 06:24 AM, Lai Jiangshan wrote:
> On Wed, Dec 15, 2010 at 8:07 PM, Thomas Gleixner<tglx@linutronix.de>  wrote:
>> On Wed, 15 Dec 2010, Lai Jiangshan wrote:
>>> +     if (waiter || rt_mutex_has_waiters(lock)) {
>>> +             unsigned long flags;
>>> +             struct rt_mutex_waiter *top;
>>> +
>>> +             raw_spin_lock_irqsave(&task->pi_lock, flags);
>>> +
>>> +             /* remove the queued waiter. */
>>> +             if (waiter) {
>>> +                     plist_del(&waiter->list_entry,&lock->wait_list);
>>> +                     task->pi_blocked_on = NULL;
>>> +             }
>>> +
>>> +             /*
>>> +              * We have to enqueue the top waiter(if have) into
>>> +              * task->pi_waiters list and would get boost from it.
>>
>> No, we don't get boosted from it. We just have to enqueue it into
>> pi_waiters list. There is no boosting happening at this point. Please
>> be very careful with the comments in this code.
>>
>> Otherwise this looks really interesting. Still this wants to be ported
>> to -rt and stress tested there.
>>
>
> Hi, Thomas,
>
> Where can I find the code of stress testcases?

See http://rt.wiki.kernel.org, There are several benchmarks available 
for RT there.

I believe there are some built-int rt-mutex testers as well:\
CONFIG_RT_MUTEX_TESTER

-- 
Darren Hart
Yocto Linux Kernel
