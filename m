Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2GYSJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:09:24 -0400
Received: from shutemov.name ([176.9.204.213]:44263 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab2GYSJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:09:23 -0400
Date: Wed, 25 Jul 2012 21:10:18 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Greg Thelen <gthelen@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org,
        cgroups@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 02/10] consider a memcg parameter in kmem_create_cache
Message-ID: <20120725181018.GA4921@shutemov.name>
References: <1343227101-14217-1-git-send-email-glommer@parallels.com>
 <1343227101-14217-3-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343227101-14217-3-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 06:38:13PM +0400, Glauber Costa wrote:

...

> @@ -337,6 +341,12 @@ extern void *__kmalloc_track_caller(size_t, gfp_t, unsigned long);
>  	__kmalloc(size, flags)
>  #endif /* DEBUG_SLAB */
>  
> +#ifdef CONFIG_MEMCG_KMEM
> +#define MAX_KMEM_CACHE_TYPES 400
> +#else
> +#define MAX_KMEM_CACHE_TYPES 0
> +#endif /* CONFIG_MEMCG_KMEM */
> +
>  #ifdef CONFIG_NUMA
>  /*
>   * kmalloc_node_track_caller is a special version of kmalloc_node that

...

> @@ -527,6 +532,24 @@ static inline bool memcg_kmem_enabled(struct mem_cgroup *memcg)
>  		memcg->kmem_accounted;
>  }
>  
> +struct ida cache_types;
> +
> +void memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *cachep)
> +{
> +	int id = -1;
> +
> +	if (!memcg)
> +		id = ida_simple_get(&cache_types, 0, MAX_KMEM_CACHE_TYPES,
> +				    GFP_KERNEL);

MAX_KMEM_CACHE_TYPES is 0 if CONFIG_MEMCG_KMEM undefined.
If 'end' parameter of ida_simple_get() is 0 it will use default max value
which is 0x80000000.
I guess you want MAX_KMEM_CACHE_TYPES to be 1 for !CONFIG_MEMCG_KMEM.

-- 
 Kirill A. Shutemov
