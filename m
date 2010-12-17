Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab0LQWv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 17:51:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:56259 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083Ab0LQWvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 17:51:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,190,1291622400"; 
   d="scan'208";a="584840243"
Message-ID: <4D0BE96E.5060104@linux.intel.com>
Date: Fri, 17 Dec 2010 14:51:26 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] plist: pass the real plist_head to plist_del()
References: <4D09E897.7090406@cn.fujitsu.com> <4D0A825F.1010408@linux.intel.com> <4D0ADDE0.3060002@cn.fujitsu.com>
In-Reply-To: <4D0ADDE0.3060002@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 07:49 PM, Lai Jiangshan wrote:
> On 12/17/2010 05:19 AM, Darren Hart wrote:
>> On 12/16/2010 02:23 AM, Lai Jiangshan wrote:
>>> These patches shrink the struct plist_head. After it is shrinked
>>> plist_del() required a real plist_head passed into.
>>>
>>> My tests did not cover all paths.
>>>
>>> Subject: plist: pass the real plist_head to plist_del()
>>>
>>>
>>> Some plist_del()s in kernel/futex.c are passed a faked plist_head.
>>
>> Can you explain what you mean by a "faked plist_head"? I'm looking at
>> the existing source and q.list.plist is a "struct plist_head". Is it the
>> required knowledge of the implementation of a plist_node that the
>> current implementation depends on that you object to? Effectively a lack
>> of encapsulation?
>
>
> What I said is "a faked head of a priority list", I am sorry that
> "faked plist_head" misled you.
>
> /**
>   * plist_del - Remove a @node from plist.
>   *
>   * @node:	&struct plist_node pointer - entry to be removed
>   * @head:	&struct plist_head pointer - list head
>   */
>
> The document said that @head is "list head" the head of the priority list.
> But the code of plist_del() just uses the head for checking, so it will
> not cause bad result even when we use a faked head.

Looks OK to me - I recall having issues with the PLIST_DEBUG stuff, this 
might have been why.

>
> In "plist_del(&q->list,&q->list.plist);",&q->list.plist is indeed a
> "struct plist_head", but it is not the real head of the priority list.
>
> I think this is bad code. We should pass the real head OR just remove
> this parameter since it is not required real one. But my next patch will use
> this "list head", so this patch fixes futex.c and pass the real head
> to plist_del().
>
>
>>
>>>
>>> It can work because current code does not require real plist_head
>>> in plist_del(). But it is an undocumented usage, it is not good.
>>
>>
>> Please compare the results of the futextest performance tests before and
>> after your applied patch and report the results with the patch:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/dvhart/futextest.git
>>
>
> I thought it is a clean up patch. But where are the testcases?
> Are they included in LTP?


These testcases are hosted at the git URL above, they are not included 
in LTP. Just clone the repo and build and run the tests.


>>> Signed-off-by:  Lai Jiangshan<laijs@cn.fujitsu.com>
>>> ---
>>> diff --git a/kernel/futex.c b/kernel/futex.c
>>> index 6c683b3..6c4f67a 100644
>>> --- a/kernel/futex.c
>>> +++ b/kernel/futex.c
>>> @@ -158,6 +158,15 @@ static inline int match_futex(union futex_key
>>> *key1, union futex_key *key2)
>>>    }
>>>
>>>    /*
>>> + * find the bucket of a futex entry.
>>> + * the same as hash_futex(&q->key) but a little more effcient
>>
>> efficient.
>>
>> Please capitalize the first word in each sentence.
>>
>>> + */
>>
>>
>> Please use proper kernel doc formatting for any new functions added to
>> futex.c.
>
> Will fix it.
>

Be sure to state any assumptions you're making about the arguments. For 
example, q->lock_ptr != NULL.

>>
>>
>>> +static struct futex_hash_bucket *futex_bucket(struct futex_q *q)
>>> +{
>>> +    return container_of(q->lock_ptr, struct futex_hash_bucket, lock);
>>> +}
>>
>>
>> Have you found the jhash2 to be a bottleneck in a particular path? Or
>> was it an optimization to reduce the impact of the changes below (I'm
>> assuming the latter).
>>
>
> jhash2() need tens of instructions after compiled.
> container_of() is just a ADD/SUB operation instruction.
>
> It is OK to use hash_futex(&q->key) instead.

I think your new routine makes sense in light of the changes to 
plist_del usage below. Rather than "bucket" which we don't use in the 
source, let's go with the following which is closer in keeping with the 
futex function and type naming conventions:

lookup_futex_hb()

>
>>
>>> +
>>> +/*
>>>     * Take a reference to the resource addressed by a key.
>>>     * Can be called while holding spinlocks.
>>>     *
>>> @@ -744,7 +753,7 @@ static void wake_futex(struct futex_q *q)
>>>         */
>>>        get_task_struct(p);
>>>
>>> -    plist_del(&q->list,&q->list.plist);
>>> +    plist_del(&q->list,&futex_bucket(q)->chain);


Hrm, in some places around uses of plist_del, we do a 
WARN_ON(q0>lock_ptr && ...) which means there is some concern that 
lock_ptr is NULL, if it is, your call here will dereference NULL and panic.


>>
>>
>> Space after the comma while you're at it.
>>
>
> Space is existed in the patch mail I received from LKML. It is strange.

Ugh... perhaps something on my end...

Thanks,

-- 
Darren Hart
Yocto Linux Kernel
