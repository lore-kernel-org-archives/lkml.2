Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab2IUInm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 04:43:42 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60653 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab2IUIni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 04:43:38 -0400
Message-ID: <505C27E4.90509@parallels.com>
Date: Fri, 21 Sep 2012 12:40:04 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: JoonSoo Kim <js1304@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        Tejun Heo <tj@kernel.org>, <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 15/16] memcg/sl[au]b: shrink dead caches
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-16-git-send-email-glommer@parallels.com> <CAAmzW4NyK6gqqXHttUE35=-=h0Eve-smiYJCj3i+mHFFysQE4A@mail.gmail.com>
In-Reply-To: <CAAmzW4NyK6gqqXHttUE35=-=h0Eve-smiYJCj3i+mHFFysQE4A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 08:48 AM, JoonSoo Kim wrote:
> Hi Glauber.
> 
Hi

> 2012/9/18 Glauber Costa <glommer@parallels.com>:
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 0b68d15..9d79216 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2602,6 +2602,7 @@ redo:
>>         } else
>>                 __slab_free(s, page, x, addr);
>>
>> +       kmem_cache_verify_dead(s);
>>  }
> 
> As far as u know, I am not a expert and don't know anything about memcg.
> IMHO, this implementation may hurt system performance in some case.
> 
> In case of memcg is destoried, remained kmem_cache is marked "dead".
> After it is marked,
> every free operation to this "dead" kmem_cache call
> kmem_cache_verify_dead() and finally call kmem_cache_shrink().

As long as it is restricted to that cache, this is a non issue.
dead caches are exactly what they name imply: dead.

Means that we actively want them to go away, and just don't kill them
right away because they have some inflight objects - which we expect not
to be too much.

> kmem_cache_shrink() do invoking kmalloc and flush_all() and taking a
> lock for online node and invoking kfree.
> Especially, flush_all() may hurt performance largely, because it call
> has_cpu_slab() against all the cpus.

Again, this is all right, but being a dead cache, it shouldn't be on any
hot path.

> 
> And, I found one case that destroying memcg's kmem_cache don't works properly.
> If we destroy memcg after all object is freed, current implementation
> doesn't destroy kmem_cache.
> kmem_cache_destroy_work_func() check "cachep->memcg_params.nr_pages == 0",
> but in this case, it return false, because kmem_cache may have
> cpu_slab, and cpu_partials_slabs.
> As we already free all objects, kmem_cache_verify_dead() is not invoked forever.
> I think that we need another kmem_cache_shrink() in
> kmem_cache_destroy_work_func().

I'll take a look here. What you describe makes sense, and can
potentially happen. I tried to handle this case with care in
destroy_all_caches, but I may have always made a mistake...

Did you see this actively happening, or are you just assuming this can
happen from your read of the code?
