Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030458Ab2CUC5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 22:57:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48569 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab2CUC5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 22:57:44 -0400
X-IronPort-AV: E=Sophos;i="4.73,621,1325433600"; 
   d="scan'208";a="4584993"
Message-ID: <4F6944D9.5090002@cn.fujitsu.com>
Date: Wed, 21 Mar 2012 11:02:49 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>
CC: Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 6/6] workqueue: use kmalloc_align() instead of hacking
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com> <1332238884-6237-7-git-send-email-laijs@cn.fujitsu.com> <20120320154619.GA5684@google.com>
In-Reply-To: <20120320154619.GA5684@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-21 10:55:31,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-21 10:55:34,
	Serialize complete at 2012-03-21 10:55:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 11:46 PM, Tejun Heo wrote:
> On Tue, Mar 20, 2012 at 06:21:24PM +0800, Lai Jiangshan wrote:
>> kmalloc_align() makes the code simpler.
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>>  kernel/workqueue.c |   23 +++++------------------
>>  1 files changed, 5 insertions(+), 18 deletions(-)
>>
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index 5abf42f..beec5fd 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -2897,20 +2897,9 @@ static int alloc_cwqs(struct workqueue_struct *wq)
>>  
>>  	if (!(wq->flags & WQ_UNBOUND))
>>  		wq->cpu_wq.pcpu = __alloc_percpu(size, align);
>> -	else {
>> -		void *ptr;
>> -
>> -		/*
>> -		 * Allocate enough room to align cwq and put an extra
>> -		 * pointer at the end pointing back to the originally
>> -		 * allocated pointer which will be used for free.
>> -		 */
>> -		ptr = kzalloc(size + align + sizeof(void *), GFP_KERNEL);
>> -		if (ptr) {
>> -			wq->cpu_wq.single = PTR_ALIGN(ptr, align);
>> -			*(void **)(wq->cpu_wq.single + 1) = ptr;
>> -		}
>> -	}
>> +	else
>> +		wq->cpu_wq.single = kmalloc_align(size,
>> +				GFP_KERNEL | __GFP_ZERO, align);
>>  
>>  	/* just in case, make sure it's actually aligned */
>>  	BUG_ON(!IS_ALIGNED(wq->cpu_wq.v, align));
>> @@ -2921,10 +2910,8 @@ static void free_cwqs(struct workqueue_struct *wq)
>>  {
>>  	if (!(wq->flags & WQ_UNBOUND))
>>  		free_percpu(wq->cpu_wq.pcpu);
>> -	else if (wq->cpu_wq.single) {
>> -		/* the pointer to free is stored right after the cwq */
>> -		kfree(*(void **)(wq->cpu_wq.single + 1));
>> -	}
>> +	else if (wq->cpu_wq.single)
>> +		kfree(wq->cpu_wq.single);
> 
> Yes, this is hacky but I don't think building the whole
> kmalloc_align() for only this is a good idea.  If the open coded hack
> bothers you just write a simplistic wrapper somewhere.  We can make
> that better integrated / more efficient when there are multiple users
> of the interface, which I kinda doubt would happen.  The reason why
> cwq requiring larger alignment is more historic than anything else
> after all.
> 

Yes, I don't want to build a complex kmalloc_align(). But after I found
that SLAB/SLUB's kmalloc-objects are natural/automatic aligned to
a proper big power of two. I will do nothing if I introduce kmalloc_align()
except just care the debugging.

o	SLAB/SLUB's kmalloc-objects are natural/automatic aligned.
o	70LOC in total, and about 90% are just renaming or wrapping.

I think it is a worth trade-off, it give us convenience and we pay
zero overhead(when runtime) and 70LOC(when coding, pay in a lump sum).

And kmalloc_align() can be used in the following case:
o	a type object need to be aligned with cache-line for it contains a frequent
	update-part and a frequent read-part.
o	The total number of these objects in a given type is not much, creating
	a new slab cache for a given type will be overkill.

This is a RFC patch and it seems mm gurus don't like it. I'm sorry I bother all of you.

Thanks,
Lai



