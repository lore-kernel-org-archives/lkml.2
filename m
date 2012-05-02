Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2EBPm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 11:42:59 -0400
Received: from mx2.parallels.com ([64.131.90.16]:43388 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab2EBPm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 11:42:58 -0400
Message-ID: <4FA15575.6020209@parallels.com>
Date: Wed, 2 May 2012 12:40:37 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Suleiman Souhlal <suleiman@google.com>
CC: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>,
        "Johannes Weiner" <hannes@cmpxchg.org>, <fweisbec@gmail.com>,
        Greg Thelen <gthelen@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 19/23] slab: per-memcg accounting of slab caches
References: <1334959051-18203-1-git-send-email-glommer@parallels.com> <1335138820-26590-8-git-send-email-glommer@parallels.com> <CABCjUKCX6MvOaS5s_n6tYcmfyDCgW60aXTG8ZbznmZOAfS=joA@mail.gmail.com>
In-Reply-To: <CABCjUKCX6MvOaS5s_n6tYcmfyDCgW60aXTG8ZbznmZOAfS=joA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.19.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> @@ -3834,11 +3866,15 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp,
>>   */
>>   void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
>>   {
>> -       void *ret = __cache_alloc(cachep, flags, __builtin_return_address(0));
>> +       void *ret;
>> +
>> +       rcu_read_lock();
>> +       cachep = mem_cgroup_get_kmem_cache(cachep, flags);
>> +       rcu_read_unlock();
>
> Don't we need to check in_interrupt(), current, __GFP_NOFAIL every
> time we call mem_cgroup_cgroup_get_kmem_cache()?
>
> I would personally prefer if those checks were put inside
> mem_cgroup_get_kmem_cache() instead of having to check for every
> caller.
>

in_interrupt() yes, __GFP_NOFAIL I don't think so.

__GFP_NOFAIL should lead to a res_counter_charge_nofail() in the end. 
The name similarity is no coincidence...

 From a code style PoV, it makes sense to bundle an in_interrupt() check 
here, but from a performance PoV, putting it in the callers can help us 
avoid the price of a function call.

But well, looking at the code, I see it is not there as well... =(

I plan to change memcontrol.h to look like this:

static __always_inline struct kmem_cache *
mem_cgroup_get_kmem_cache(struct kmem_cache *cachep, gfp_t gfp)
{
         if (mem_cgroup_kmem_on && current->mm && !in_interrupt())
                 return __mem_cgroup_get_kmem_cache(cachep, gfp);
         return cachep;
}



