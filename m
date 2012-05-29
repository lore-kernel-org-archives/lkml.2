Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab2E2Qia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:38:30 -0400
Received: from mx2.parallels.com ([64.131.90.16]:41508 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906Ab2E2Qi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:38:29 -0400
Message-ID: <4FC4FAF6.8060900@parallels.com>
Date: Tue, 29 May 2012 20:36:06 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 12/28] slab: pass memcg parameter to kmem_cache_create
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-13-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290922340.4666@router.home> <4FC4F04F.1070401@parallels.com> <alpine.DEB.2.00.1205291131590.6723@router.home>
In-Reply-To: <alpine.DEB.2.00.1205291131590.6723@router.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 08:33 PM, Christoph Lameter wrote:
> On Tue, 29 May 2012, Glauber Costa wrote:
>
>>> Ok this only duplicates the kmalloc arrays. Why not the others?
>>
>> It does duplicate the others.
>>
>> First it does a while look on the kmalloc caches, then a list_for_each_entry
>> in the rest. You probably missed it.
>
> There is no need to separately duplicate the kmalloc_caches. Those are
> included on the cache_chain.
>
>>>> @@ -2543,7 +2564,12 @@ kmem_cache_create (const char *name, size_t size,
>>>> size_t align,
>>>>    	cachep->ctor = ctor;
>>>>    	cachep->name = name;
>>>>
>>>> +	if (g_cpucache_up>= FULL)
>>>> +		mem_cgroup_register_cache(memcg, cachep);
>>>
>>> What happens if a cgroup was active during creation of slab xxy but
>>> then a process running in a different cgroup uses that slab to allocate
>>> memory? Is it charged to the first cgroup?
>>
>> I don't see this situation ever happening. kmem_cache_create, when called
>> directly, will always create a global cache. It doesn't matter which cgroups
>> are or aren't active at this time or any other. We create copies per-cgroup,
>> but we create it lazily, when someone will touch it.
>
> How do you detect that someone is touching it?

kmem_alloc_cache will create mem_cgroup_get_kmem_cache.
(protected by static_branches, so won't happen if you don't have at 
least non-root memcg using it)

* Then it detects which memcg the calling process belongs to,
* if it is the root memcg, go back to the allocation as quickly as we
   can
* otherwise, in the creation process, you will notice that each cache
   has an index. memcg will store pointers to the copies and find them by
   the index.

 From this point on, all the code of the caches is reused (except for 
accounting the page)

