Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2KAHLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 03:11:16 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:44467 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2KAHLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 03:11:13 -0400
Message-ID: <50922087.6080300@linux.vnet.ibm.com>
Date: Thu, 01 Nov 2012 15:11:03 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>, JoonSoo Kim <js1304@gmail.com>
Subject: Re: [PATCH] slab: annotate on-slab caches nodelist locks
References: <1351507779-26847-1-git-send-email-glommer@parallels.com>
In-Reply-To: <1351507779-26847-1-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12110107-5140-0000-0000-000002496299
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 06:49 PM, Glauber Costa wrote:
> We currently provide lockdep annotation for kmalloc caches, and also
> caches that have SLAB_DEBUG_OBJECTS enabled. The reason for this is that
> we can quite frequently nest in the l3->list_lock lock, which is not
> something trivial to avoid.
> 
> My proposal with this patch, is to extend this to caches whose slab
> management object lives within the slab as well ("on_slab"). The need
> for this arose in the context of testing kmemcg-slab patches. With such
> patchset, we can have per-memcg kmalloc caches. So the same path that
> led to nesting between kmalloc caches will could then lead to in-memcg
> nesting. Because they are not annotated, lockdep will trigger.

Hi, Glauber

I'm trying to understand what's the issue we are trying to solve, but
looks like I need some help...

So allow me to ask few questions:

1. what's scene will cause the fake dead lock?
2. what's the conflict caches?
3. how does their lock operation nested?

And I think it will be better if we have the bug log in patch comment,
so folks will easily know what's the reason we need this patch ;-)

Regards,
Michael Wang

> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Christoph Lameter <cl@linux.com>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> CC: David Rientjes <rientjes@google.com>
> CC: JoonSoo Kim <js1304@gmail.com>
> 
> ---
> Instead of "on_slab", I considered checking the memcg cache's root
> cache, and annotating that only in case this is a kmalloc cache.
> I ended up annotating on_slab caches, because given how frequently
> those locks can nest, it seemed like a safe choice to go. I was
> a little bit inspired by the key's name as well, that indicated
> this could work for all on_slab caches. Let me know if you guys
> want a different test condition for this.
> ---
>  mm/slab.c | 30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index 9b7f6b63..ef1c8b3 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -654,6 +654,26 @@ static void init_node_lock_keys(int q)
>  	}
>  }
> 
> +static void on_slab_lock_classes_node(struct kmem_cache *cachep, int q)
> +{
> +	struct kmem_list3 *l3;
> +	l3 = cachep->nodelists[q];
> +	if (!l3)
> +		return;
> +
> +	slab_set_lock_classes(cachep, &on_slab_l3_key,
> +			&on_slab_alc_key, q);
> +}
> +
> +static inline void on_slab_lock_classes(struct kmem_cache *cachep)
> +{
> +	int node;
> +
> +	VM_BUG_ON(OFF_SLAB(cachep));
> +	for_each_node(node)
> +		on_slab_lock_classes_node(cachep, node);
> +}
> +
>  static inline void init_lock_keys(void)
>  {
>  	int node;
> @@ -670,6 +690,10 @@ static inline void init_lock_keys(void)
>  {
>  }
> 
> +static inline void on_slab_lock_classes(struct kmem_cache *cachep)
> +{
> +}
> +
>  static void slab_set_debugobj_lock_classes_node(struct kmem_cache *cachep, int node)
>  {
>  }
> @@ -1397,6 +1421,9 @@ static int __cpuinit cpuup_prepare(long cpu)
>  		free_alien_cache(alien);
>  		if (cachep->flags & SLAB_DEBUG_OBJECTS)
>  			slab_set_debugobj_lock_classes_node(cachep, node);
> +		else if (!OFF_SLAB(cachep) &&
> +			 !(cachep->flags & SLAB_DESTROY_BY_RCU))
> +			on_slab_lock_classes_node(cachep, node);
>  	}
>  	init_node_lock_keys(node);
> 
> @@ -2554,7 +2581,8 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
>  		WARN_ON_ONCE(flags & SLAB_DESTROY_BY_RCU);
> 
>  		slab_set_debugobj_lock_classes(cachep);
> -	}
> +	} else if (!OFF_SLAB(cachep) && !(flags & SLAB_DESTROY_BY_RCU))
> +		on_slab_lock_classes(cachep);
> 
>  	return 0;
>  }
> 

