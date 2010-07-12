Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab0GLTLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 15:11:11 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:56287 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab0GLTLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 15:11:09 -0400
Message-ID: <4C3B68B9.5060404@us.ibm.com>
Date: Mon, 12 Jul 2010 12:10:49 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 4/4] futex: convert hash_bucket locks to raw_spinlock_t
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com> <1278714780-788-5-git-send-email-dvhltc@us.ibm.com> <1278790882.7352.101.camel@marge.simson.net>
In-Reply-To: <1278790882.7352.101.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2010 12:41 PM, Mike Galbraith wrote:
> On Fri, 2010-07-09 at 15:33 -0700, Darren Hart wrote:
>> The requeue_pi mechanism introduced proxy locking of the rtmutex.  This creates
>> a scenario where a task can wake-up, not knowing it has been enqueued on an
>> rtmutex. In order to detect this, the task would have to be able to take either
>> task->pi_blocked_on->lock->wait_lock and/or the hb->lock.  Unfortunately,
>> without already holding one of these, the pi_blocked_on variable can change
>> from NULL to valid or from valid to NULL. Therefor, the task cannot be allowed
>> to take a sleeping lock after wakeup or it could end up trying to block on two
>> locks, the second overwriting a valid pi_blocked_on value. This obviously
>> breaks the pi mechanism.
>
> copy/paste offline query/reply at Darren's request..
>
> On Sat, 2010-07-10 at 10:26 -0700, Darren Hart wrote:
> On 07/09/2010 09:32 PM, Mike Galbraith wrote:
>>> On Fri, 2010-07-09 at 13:05 -0700, Darren Hart wrote:
>>>
>>>> The core of the problem is that the proxy_lock blocks a task on a lock
>>>> the task knows nothing about. So when it wakes up inside of
>>>> futex_wait_requeue_pi, it immediately tries to block on hb->lock to
>>>> check why it woke up. This has the potential to block the task on two
>>>> locks (thus overwriting the pi_blocked_on). Any attempt preventing this
>>>> involves a lock, and ultimiately the hb->lock. The only solution I see
>>>> is to make the hb->locks raw locks (thanks to Steven Rostedt for
>>>> original idea and batting this around with me in IRC).
>>>
>>> Hm, so wakee _was_ munging his own state after all.
>>>
>>> Out of curiosity, what's wrong with holding his pi_lock across the
>>> wakeup?  He can _try_ to block, but can't until pi state is stable.
>>>
>>> I presume there's a big fat gotcha that's just not obvious to futex
>>> locking newbie :)

Nor to some of us that have been engrossed in futexes for the last 
couple years! I discussed the pi_lock across the wakeup issue with 
Thomas. While this fixes the problem for this particular failure case, 
it doesn't protect against:

<tglx> assume the following:
<tglx> t1 is on the condvar
<tglx> t2 does the requeue dance and t1 is now blocked on the outer futex
<tglx> t3 takes hb->lock for a futex in the same bucket
<tglx> t2 wakes due to signal/timeout
<tglx> t2 blocks on hb->lock

You are likely to have not hit the above scenario because you only had 
one condvar, so the hash_buckets were not heavily shared and you weren't 
likely to hit:

<tglx> t3 takes hb->lock for a futex in the same bucket


I'm going to roll up a patchset with your (Mike) spin_trylock patch and 
run it through some tests. I'd still prefer a way to detect early wakeup 
without having to grab the hb->lock(), but I haven't found it yet.

+	while(!spin_trylock(&hb->lock))
+		cpu_relax();
  	ret = handle_early_requeue_pi_wakeup(hb, &q, &key2, to);
  	spin_unlock(&hb->lock);

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
