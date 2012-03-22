Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab2CVBOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 21:14:53 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44622 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab2CVBOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 21:14:52 -0400
Message-ID: <4F6A7D04.6080906@us.ibm.com>
Date: Wed, 21 Mar 2012 18:14:44 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Milton Miller <miltonm@bga.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] nohz: fix race allowing use of stale jiffies when waking
References: <nohz-jiffies-update64-race@mdm.bga.com> <1326361755.2950.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <nohz-jiffies-race-reply1@mdm.bga.com>
In-Reply-To: <nohz-jiffies-race-reply1@mdm.bga.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032201-6148-0000-0000-000004722E91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2012 09:02 PM, Milton Miller wrote:
> On Thu, 12 Jan 2012 about 10:49:15 +0100 Eric Dumazet wrote:
>> Le jeudi 12 janvier 2012 Ã  02:55 -0600, Milton Miller a Ã©crit :
>>> When waking up from nohz mode, all cpus call tick_do_update_jiffies64
>>> regardless of tick_do_timer_cpu as it could be no cpu was assigned.
>>>
>>> At the start of the function there is a quick lockless check to
>>> determine if jiffies is current.  The check uses last_jiffies_update,
>>> which is used to calculate when to perform the next increment.
>>> Unfortunately it is updated when how many jiffies to advance the
>>> clock is calculated, before the call to do_timer which actually
>>> updates jiffies.  A second cpu waking up could use the (potentially
>>> very) stale jiffies value during this window.
>>>
>>> This patch changes the check to be against tick_next_period, which
>>> is updated after the call to do_timer completes.  It compares the
>>> result of subtraction to zero, but this is safe as ktime_sub returns
>>> ktime_t which is s64, as signed type.
>>>
>>> I found this race while trying to track down reports of network adapter
>>> hangs on a large system.  I suspected premature false detection so
>>> I added logging when the locked region determined a multiple jiffie
>>> update would be required.  I noticed that it happened frequently when
>>> tick_do_timer_cpu was NONE (-1), and realized the large update was
>>> when all cpus were previously in nohz.  I then thought about what
>>> would happen if multiple cpus woke up near close to each other in
>>> time and decided the stale jiffies would be used.  (I later found at
>>> least part of the hung adapter reports were due to faulty detection
>>> logic that has since changed upstream.)
>>>
>>> Signed-off-by: Milton Miller<miltonm@bga.com>
>>> Cc: stable@vger.kernel.org
>>> ---
>>> Patch was generated and tested against 2.6.36; I verified it applies
>>> with offset -1 line to next-20120111.
>>>
>>> Index: src/kernel/time/tick-sched.c
>>> ===================================================================
>>> --- src.orig/kernel/time/tick-sched.c	2011-10-13 17:42:16.000000000 -0500
>>> +++ src/kernel/time/tick-sched.c	2011-10-13 17:45:31.000000000 -0500
>>> @@ -52,8 +52,8 @@ static void tick_do_update_jiffies64(kti
>>>   	/*
>>>   	 * Do a quick check without holding xtime_lock:
>>>   	 */
>>> -	delta = ktime_sub(now, last_jiffies_update);
>>> -	if (delta.tv64<  tick_period.tv64)
>>> +	delta = ktime_sub(now, tick_next_period);
>>> +	if (delta.tv64<  0)
>>>   		return;
>>>
>> Given ktime_t on 32bit arches is not an atomic type, I wonder how safe
>> is this anyway...
>>
> Ok I admit I hadn't thought about it, and initially I was going to
> think of something involving comparing the two timestamps, and
> waiting if next_period<= next_jiffies_update (with approprate
> subtract and compare).
>
> But then I thought some more and comparing the timestamp after the
> update is safe:
[snipped]


> There are a couple additional points to consider in this scenerio.
> One is that the cpu still has xtime lock so any attempt to read a
> high precision time will stall.  The second is if the cpu updating
> the jiffies is stalled by the hypervisor, then it is not unique to
> when it is waking from nohz and is likely happing when it owns
> timer duty, so time will be subject to bunching and jumping jiffies
> on a regular baasis.  About the most we could do is detect it, either
> by taking periodic helath checks of jiffie by other cpus or noticing
> that our tick update is constantly behind.
>
> So I think the updated racy check is fine, but will expand on the
> racy check comment why it is safe if that is desired.
>
So,  what happened with this patch?   Is there a updated version with 
the improved documentation covered in this mail?

thanks
-john

