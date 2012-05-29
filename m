Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab2E2Pw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 11:52:59 -0400
Received: from mx2.parallels.com ([64.131.90.16]:55837 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab2E2Pw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 11:52:58 -0400
Message-ID: <4FC4F04F.1070401@parallels.com>
Date: Tue, 29 May 2012 19:50:39 +0400
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
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-13-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290922340.4666@router.home>
In-Reply-To: <alpine.DEB.2.00.1205290922340.4666@router.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.255.67.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 06:27 PM, Christoph Lameter wrote:
> On Fri, 25 May 2012, Glauber Costa wrote:
>
>> index 06e4a3e..7c0cdd6 100644
>> --- a/include/linux/slab_def.h
>> +++ b/include/linux/slab_def.h
>> @@ -102,6 +102,13 @@ struct kmem_cache {
>>   	 */
>>   };
>>
>> +static inline void store_orig_align(struct kmem_cache *cachep, int orig_align)
>> +{
>> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
>> +	cachep->memcg_params.orig_align = orig_align;
>> +#endif
>> +}
>> +
>
> Why do you need to store the original alignment? Is the calculated
> alignment not enough?

I think this one can go. You are right.

>> +++ b/mm/slab.c
>> @@ -1729,6 +1729,31 @@ void __init kmem_cache_init_late(void)
>>   	 */
>>   }
>>
>> +static int __init memcg_slab_register_all(void)
>> +{
>> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
>> +	struct kmem_cache *cachep;
>> +	struct cache_sizes *sizes;
>> +
>> +	sizes = malloc_sizes;
>> +
>> +	while (sizes->cs_size != ULONG_MAX) {
>> +		if (sizes->cs_cachep)
>> +			mem_cgroup_register_cache(NULL, sizes->cs_cachep);
>> +		if (sizes->cs_dmacachep)
>> +			mem_cgroup_register_cache(NULL, sizes->cs_dmacachep);
>> +		sizes++;
>> +	}
>> +
>> +	mutex_lock(&cache_chain_mutex);
>> +	list_for_each_entry(cachep,&cache_chain, next)
>> +		mem_cgroup_register_cache(NULL, cachep);
>> +
>> +	mutex_unlock(&cache_chain_mutex);
>> +#endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
>> +	return 0;
>> +}
>
> Ok this only duplicates the kmalloc arrays. Why not the others?

It does duplicate the others.

First it does a while look on the kmalloc caches, then a 
list_for_each_entry in the rest. You probably missed it.

>> @@ -2331,7 +2350,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
>>   			continue;
>>   		}
>>
>> -		if (!strcmp(pc->name, name)) {
>> +		if (!memcg&&  !strcmp(pc->name, name)) {
>>   			printk(KERN_ERR
>>   			       "kmem_cache_create: duplicate cache %s\n", name);
>>   			dump_stack();
>
> This implementation means that duplicate cache detection will no longer
> work within a cgroup?

For the slab, yes. For the slub, I check to see if they belong to the 
same memcg.

That said, this can and should be fixed here too, thanks for spotting.

>> @@ -2543,7 +2564,12 @@ kmem_cache_create (const char *name, size_t size, size_t align,
>>   	cachep->ctor = ctor;
>>   	cachep->name = name;
>>
>> +	if (g_cpucache_up>= FULL)
>> +		mem_cgroup_register_cache(memcg, cachep);
>
> What happens if a cgroup was active during creation of slab xxy but
> then a process running in a different cgroup uses that slab to allocate
> memory? Is it charged to the first cgroup?

I don't see this situation ever happening. kmem_cache_create, when 
called directly, will always create a global cache. It doesn't matter 
which cgroups are or aren't active at this time or any other. We create 
copies per-cgroup, but we create it lazily, when someone will touch it.

At that point, which cache will be used depend on which process is using 
it.

