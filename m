Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab0LQDsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 22:48:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53051 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab0LQDst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 22:48:49 -0500
Message-ID: <4D0ADDE0.3060002@cn.fujitsu.com>
Date: Fri, 17 Dec 2010 11:49:52 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Darren Hart <dvhart@linux.intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] plist: pass the real plist_head to plist_del()
References: <4D09E897.7090406@cn.fujitsu.com> <4D0A825F.1010408@linux.intel.com>
In-Reply-To: <4D0A825F.1010408@linux.intel.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-17 11:48:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-17 11:48:45,
	Serialize complete at 2010-12-17 11:48:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 05:19 AM, Darren Hart wrote:
> On 12/16/2010 02:23 AM, Lai Jiangshan wrote:
>> These patches shrink the struct plist_head. After it is shrinked
>> plist_del() required a real plist_head passed into.
>>
>> My tests did not cover all paths.
>>
>> Subject: plist: pass the real plist_head to plist_del()
>>
>>
>> Some plist_del()s in kernel/futex.c are passed a faked plist_head.
> 
> Can you explain what you mean by a "faked plist_head"? I'm looking at
> the existing source and q.list.plist is a "struct plist_head". Is it the
> required knowledge of the implementation of a plist_node that the
> current implementation depends on that you object to? Effectively a lack
> of encapsulation?


What I said is "a faked head of a priority list", I am sorry that
"faked plist_head" misled you.

/**
 * plist_del - Remove a @node from plist.
 *
 * @node:	&struct plist_node pointer - entry to be removed
 * @head:	&struct plist_head pointer - list head
 */

The document said that @head is "list head" the head of the priority list.
But the code of plist_del() just uses the head for checking, so it will
not cause bad result even when we use a faked head.

In "plist_del(&q->list, &q->list.plist);", &q->list.plist is indeed a
"struct plist_head", but it is not the real head of the priority list.

I think this is bad code. We should pass the real head OR just remove
this parameter since it is not required real one. But my next patch will use
this "list head", so this patch fixes futex.c and pass the real head
to plist_del().


> 
>>
>> It can work because current code does not require real plist_head
>> in plist_del(). But it is an undocumented usage, it is not good.
> 
> 
> Please compare the results of the futextest performance tests before and
> after your applied patch and report the results with the patch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dvhart/futextest.git
> 

I thought it is a clean up patch. But where are the testcases?
Are they included in LTP?

> 
>>
>> Signed-off-by:  Lai Jiangshan<laijs@cn.fujitsu.com>
>> ---
>> diff --git a/kernel/futex.c b/kernel/futex.c
>> index 6c683b3..6c4f67a 100644
>> --- a/kernel/futex.c
>> +++ b/kernel/futex.c
>> @@ -158,6 +158,15 @@ static inline int match_futex(union futex_key
>> *key1, union futex_key *key2)
>>   }
>>
>>   /*
>> + * find the bucket of a futex entry.
>> + * the same as hash_futex(&q->key) but a little more effcient
> 
> efficient.
> 
> Please capitalize the first word in each sentence.
> 
>> + */
> 
> 
> Please use proper kernel doc formatting for any new functions added to
> futex.c.

Will fix it.


> 
> 
>> +static struct futex_hash_bucket *futex_bucket(struct futex_q *q)
>> +{
>> +    return container_of(q->lock_ptr, struct futex_hash_bucket, lock);
>> +}
> 
> 
> Have you found the jhash2 to be a bottleneck in a particular path? Or
> was it an optimization to reduce the impact of the changes below (I'm
> assuming the latter).
> 

jhash2() need tens of instructions after compiled.
container_of() is just a ADD/SUB operation instruction.

It is OK to use hash_futex(&q->key) instead.

> 
>> +
>> +/*
>>    * Take a reference to the resource addressed by a key.
>>    * Can be called while holding spinlocks.
>>    *
>> @@ -744,7 +753,7 @@ static void wake_futex(struct futex_q *q)
>>        */
>>       get_task_struct(p);
>>
>> -    plist_del(&q->list,&q->list.plist);
>> +    plist_del(&q->list,&futex_bucket(q)->chain);
> 
> 
> Space after the comma while you're at it.
> 

Space is existed in the patch mail I received from LKML. It is strange.

Thanks,
Lai. 
