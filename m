Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab2GZKaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:30:15 -0400
Received: from mx2.parallels.com ([64.131.90.16]:55572 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab2GZKaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:30:10 -0400
Message-ID: <50111B83.2010105@parallels.com>
Date: Thu, 26 Jul 2012 14:27:15 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Greg Thelen <gthelen@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, <devel@openvz.org>,
        <cgroups@vger.kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 02/10] consider a memcg parameter in kmem_create_cache
References: <1343227101-14217-1-git-send-email-glommer@parallels.com> <1343227101-14217-3-git-send-email-glommer@parallels.com> <20120725181018.GA4921@shutemov.name> <501110ED.9030400@parallels.com> <20120726100111.GA7447@shutemov.name>
In-Reply-To: <20120726100111.GA7447@shutemov.name>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 02:01 PM, Kirill A. Shutemov wrote:
> On Thu, Jul 26, 2012 at 01:42:05PM +0400, Glauber Costa wrote:
>> On 07/25/2012 10:10 PM, Kirill A. Shutemov wrote:
>>> On Wed, Jul 25, 2012 at 06:38:13PM +0400, Glauber Costa wrote:
>>>
>>> ...
>>>
>>>> @@ -337,6 +341,12 @@ extern void *__kmalloc_track_caller(size_t, gfp_t, unsigned long);
>>>>  	__kmalloc(size, flags)
>>>>  #endif /* DEBUG_SLAB */
>>>>  
>>>> +#ifdef CONFIG_MEMCG_KMEM
>>>> +#define MAX_KMEM_CACHE_TYPES 400
>>>> +#else
>>>> +#define MAX_KMEM_CACHE_TYPES 0
>>>> +#endif /* CONFIG_MEMCG_KMEM */
>>>> +
>>>>  #ifdef CONFIG_NUMA
>>>>  /*
>>>>   * kmalloc_node_track_caller is a special version of kmalloc_node that
>>>
>>> ...
>>>
>>>> @@ -527,6 +532,24 @@ static inline bool memcg_kmem_enabled(struct mem_cgroup *memcg)
>>>>  		memcg->kmem_accounted;
>>>>  }
>>>>  
>>>> +struct ida cache_types;
>>>> +
>>>> +void memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *cachep)
>>>> +{
>>>> +	int id = -1;
>>>> +
>>>> +	if (!memcg)
>>>> +		id = ida_simple_get(&cache_types, 0, MAX_KMEM_CACHE_TYPES,
>>>> +				    GFP_KERNEL);
>>>
>>> MAX_KMEM_CACHE_TYPES is 0 if CONFIG_MEMCG_KMEM undefined.
>>> If 'end' parameter of ida_simple_get() is 0 it will use default max value
>>> which is 0x80000000.
>>> I guess you want MAX_KMEM_CACHE_TYPES to be 1 for !CONFIG_MEMCG_KMEM.
>>>
>> ida_simple_get will not, and should never be called for !CONFIG_MEMCG_KMEM.
> 
> Okay. Is there an user for MAX_KMEM_CACHE_TYPES if !CONFIG_MEMCG_KMEM?
> 

Actually, not anymore. I will just remove it then, instead of forcing it
to 0.

Thanks!
