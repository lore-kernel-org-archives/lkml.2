Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab2EVHZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 03:25:56 -0400
Received: from mx2.parallels.com ([64.131.90.16]:39755 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab2EVHZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 03:25:54 -0400
Message-ID: <4FBB3F04.7040207@parallels.com>
Date: Tue, 22 May 2012 11:23:48 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab+slob: dup name string
References: <1337613539-29108-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 07:22 AM, David Rientjes wrote:
> On Mon, 21 May 2012, Glauber Costa wrote:
>
>> diff --git a/mm/slab.c b/mm/slab.c
>> index e901a36..cabd217 100644
>> --- a/mm/slab.c
>> +++ b/mm/slab.c
>> @@ -2118,6 +2118,7 @@ static void __kmem_cache_destroy(struct kmem_cache *cachep)
>>   			kfree(l3);
>>   		}
>>   	}
>> +	kfree(cachep->name);
>>   	kmem_cache_free(&cache_cache, cachep);
>>   }
>>
>> @@ -2526,9 +2527,14 @@ kmem_cache_create (const char *name, size_t size, size_t align,
>>   		BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
>>   	}
>>   	cachep->ctor = ctor;
>> -	cachep->name = name;
>>
>> -	if (setup_cpu_cache(cachep, gfp)) {
>> +	/* Can't do strdup while kmalloc is not up */
>> +	if (g_cpucache_up>  EARLY)
>> +		cachep->name = kstrdup(name, GFP_KERNEL);
>> +	else
>> +		cachep->name = name;
>> +
>> +	if (!cachep->name || setup_cpu_cache(cachep, gfp)) {
>>   		__kmem_cache_destroy(cachep);
>>   		cachep = NULL;
>>   		goto oops;
>
> This doesn't work if you kmem_cache_destroy() a cache that was created
> when g_cpucache_cpu<= EARLY, the kfree() will explode.  That never
> happens for any existing cache created in kmem_cache_init(), but this
> would introduce the first roadblock in doing so.  So you'll need some
> magic to determine whether the cache was allocated statically and suppress
> the kfree() in such a case.

Suggestions on how to do it other than using a flag?

