Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934817Ab2JXNjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:39:54 -0400
Received: from mx2.parallels.com ([64.131.90.16]:37017 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab2JXNjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:39:53 -0400
Message-ID: <5087EFA2.6030607@parallels.com>
Date: Wed, 24 Oct 2012 17:39:46 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: JoonSoo Kim <js1304@gmail.com>
CC: Christoph Lameter <cl@linux.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/2] slab: move kmem_cache_free to common code
References: <1350914737-4097-1-git-send-email-glommer@parallels.com> <1350914737-4097-3-git-send-email-glommer@parallels.com> <0000013a88eff593-50da3bb8-3294-41db-9c32-4e890ef6940a-000000@email.amazonses.com> <508561E0.5000406@parallels.com> <CAAmzW4PJkDbLJBKZ1zPNDw+dHPcgzX_25tMw3rWoX0ybpXACSQ@mail.gmail.com> <50865024.60309@parallels.com> <508676FA.4000107@parallels.com> <CAAmzW4M9Casm+b4TOe7MOuZMYf7PKmzOHs1wZOXvybhRxCqZRA@mail.gmail.com>
In-Reply-To: <CAAmzW4M9Casm+b4TOe7MOuZMYf7PKmzOHs1wZOXvybhRxCqZRA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 07:43 PM, JoonSoo Kim wrote:
> 2012/10/23 Glauber Costa <glommer@parallels.com>:
>> On 10/23/2012 12:07 PM, Glauber Costa wrote:
>>> On 10/23/2012 04:48 AM, JoonSoo Kim wrote:
>>>> Hello, Glauber.
>>>>
>>>> 2012/10/23 Glauber Costa <glommer@parallels.com>:
>>>>> On 10/22/2012 06:45 PM, Christoph Lameter wrote:
>>>>>> On Mon, 22 Oct 2012, Glauber Costa wrote:
>>>>>>
>>>>>>> + * kmem_cache_free - Deallocate an object
>>>>>>> + * @cachep: The cache the allocation was from.
>>>>>>> + * @objp: The previously allocated object.
>>>>>>> + *
>>>>>>> + * Free an object which was previously allocated from this
>>>>>>> + * cache.
>>>>>>> + */
>>>>>>> +void kmem_cache_free(struct kmem_cache *s, void *x)
>>>>>>> +{
>>>>>>> +    __kmem_cache_free(s, x);
>>>>>>> +    trace_kmem_cache_free(_RET_IP_, x);
>>>>>>> +}
>>>>>>> +EXPORT_SYMBOL(kmem_cache_free);
>>>>>>> +
>>>>>>
>>>>>> This results in an additional indirection if tracing is off. Wonder if
>>>>>> there is a performance impact?
>>>>>>
>>>>> if tracing is on, you mean?
>>>>>
>>>>> Tracing already incurs overhead, not sure how much a function call would
>>>>> add to the tracing overhead.
>>>>>
>>>>> I would not be concerned with this, but I can measure, if you have any
>>>>> specific workload in mind.
>>>>
>>>> With this patch, kmem_cache_free() invokes __kmem_cache_free(),
>>>> that is, it add one more "call instruction" than before.
>>>>
>>>> I think that Christoph's comment means above fact.
>>>
>>> Ah, this. Ok, I got fooled by his mention to tracing.
>>>
>>> I do agree, but since freeing is ultimately dependent on the allocator
>>> layout, I don't see a clean way of doing this without dropping tears of
>>> sorrow around. The calls in slub/slab/slob would have to be somehow
>>> inlined. Hum... maybe it is possible to do it from
>>> include/linux/sl*b_def.h...
>>>
>>> Let me give it a try and see what I can come up with.
>>>
>>
>> Ok.
>>
>> I am attaching a PoC for this for your appreciation. This gets quite
>> ugly, but it's the way I found without including sl{a,u,o}b.c directly -
>> which would be even worse.
> 
> Hmm...
> This is important issue for sl[aou]b common allocators.
> Because there are similar functions like as kmem_cache_alloc, ksize, kfree, ...
> So it is good time to resolve this issue.
> 
> As far as I know, now, we have 3 solutions.
> 
> 1. include/linux/slab.h
> __always_inline kmem_cache_free()
> {
> __kmem_cache_free();
> blablabla...
> }
> 
> 2. define macro like as Glauber's solution
> 3. include sl[aou]b.c directly.
> 
> Is there other good solution?
> Among them, I prefer "solution 3", because future developing cost may
> be minimum among them.
> 
> "Solution 2" may be error-prone for future developing.
> "Solution 1" may make compile-time longer and larger code.
> 
> Is my understanding right?
> Is "Solution 3" really ugly?
> 

I just gave it a try. Turns out the result is not *that* bad for my eyes.

I'll post soon.



