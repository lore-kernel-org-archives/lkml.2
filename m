Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202Ab2BJVBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 16:01:44 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:20470 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760158Ab2BJVBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 16:01:42 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: vbTD9.8VM1nwbbKa_TUpyKsiXhRt5RuZpfyO.jnKQuRODEe
 YHG3K_fa1GbEMszZIYS3DHWbXgLsSLE6GkRHxTWGl9EwM1XjK67i1KeIJvJC
 e_ZQmG.hB5w1zAamWxkXN3N14AHaTyg19KBWUwjywpointuHZza.QCA.EVDP
 pbgRFD9DRn16Js4r1uvIicpYZXR2alqcz79crIh0QB2E9_P_E19lI8n8yocq
 6NwWT5df2fZlrKQXvU8uJqTgPLC3WlhiJ51o4xa0gsdPKs2YVpKuQOyczKpf
 zYBorEssgt.qa_tCMusxQjfB42T.Op7B8wNHg7Kfo7zSY8wbq3Cxgjlq0rSn
 jRuMiHKHvIqUJQbOOxD.w.WGNMXwAy1uOOQAA7Tgjv5YLTEWVTUHgv2lWVQG
 48ewrNf_kKu0e20xenar0qDN7O2n05rmISQKm
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 10 Feb 2012 15:01:37 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 02/15] mm: sl[au]b: Add knowledge of PFMEMALLOC reserve
 pages
In-Reply-To: <20120210102605.GO5938@suse.de>
Message-ID: <alpine.DEB.2.00.1202101443570.31424@router.home>
References: <1328568978-17553-3-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1202071025050.30652@router.home> <20120208144506.GI5938@suse.de> <alpine.DEB.2.00.1202080907320.30248@router.home> <20120208163421.GL5938@suse.de> <alpine.DEB.2.00.1202081338210.32060@router.home>
 <20120208212323.GM5938@suse.de> <alpine.DEB.2.00.1202081557540.5970@router.home> <20120209125018.GN5938@suse.de> <alpine.DEB.2.00.1202091345540.4413@router.home> <20120210102605.GO5938@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Feb 2012, Mel Gorman wrote:

> I have an updated version of this 02/15 patch below. It passed testing
> and is a lot less invasive than the previous release. As you suggested,
> it uses page flags and the bulk of the complexity is only executed if
> someone is using network-backed storage.

Hmmm.. hmm... Still modifies the hotpaths of the allocators for a
pretty exotic feature.

> > On top of that you want to add
> > special code in various subsystems to also do that over the network.
> > Sigh. I think we agreed a while back that we want to limit the amount of
> > I/O triggered from reclaim paths?
>
> Specifically we wanted to reduce or stop page reclaim calling ->writepage()
> for file-backed pages because it generated awful IO patterns and deep
> call stacks. We still write anonymous pages from page reclaim because we
> do not have a dedicated thread for writing to swap. It is expected that
> the call stack for writing to network storage would be less than a
> filesystem.
>
> > AFAICT many filesystems do not support
> > writeout from reclaim anymore because of all the issues that arise at that
> > level.
> >
>
> NBD is a block device so filesystem restrictions like you mention do not
> apply. In NFS, the direct_IO paths are used to write pages not
> ->writepage so again the restriction does not apply.

Block devices are a little simpler ok. But it is still not a desirable
thing to do (just think about raid and other complex filesystems that may
also have to do allocations).I do not think that block device writers
code with the VM in mind. In the case of network devices as block devices
we have a pretty serious problem since the network subsystem is certainly
not designed to be called from VM reclaim code that may be triggered
arbitrarily from deeply nested other code in the kernel. Implementing
something like this invites breakage all over the place to show up.

> index 8b3b8cf..6a3fa1c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -695,6 +695,7 @@ static bool free_pages_prepare(struct page *page, unsigned int order)
>  	trace_mm_page_free(page, order);
>  	kmemcheck_free_shadow(page, order);
>
> +	page->pfmemalloc = false;
>  	if (PageAnon(page))
>  		page->mapping = NULL;
>  	for (i = 0; i < (1 << order); i++)
> @@ -1221,6 +1222,7 @@ void free_hot_cold_page(struct page *page, int cold)
>
>  	migratetype = get_pageblock_migratetype(page);
>  	set_page_private(page, migratetype);
> +	page->pfmemalloc = false;
>  	local_irq_save(flags);
>  	if (unlikely(wasMlocked))
>  		free_page_mlock(page);

page allocator hotpaths affected.

> diff --git a/mm/slab.c b/mm/slab.c
> index f0bd785..f322dc2 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -123,6 +123,8 @@
>
>  #include <trace/events/kmem.h>
>
> +#include	"internal.h"
> +
>  /*
>   * DEBUG	- 1 for kmem_cache_create() to honour; SLAB_RED_ZONE & SLAB_POISON.
>   *		  0 for faster, smaller code (especially in the critical paths).
> @@ -151,6 +153,12 @@
>  #define ARCH_KMALLOC_FLAGS SLAB_HWCACHE_ALIGN
>  #endif
>
> +/*
> + * true if a page was allocated from pfmemalloc reserves for network-based
> + * swap
> + */
> +static bool pfmemalloc_active;

Implying an additional cacheline use in critical slab paths? Hopefully
grouped with other variables already in cache.

> @@ -3243,23 +3380,35 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
>  {
>  	void *objp;
>  	struct array_cache *ac;
> +	bool force_refill = false;

... hitting the hotpath here.

> @@ -3693,12 +3845,12 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp,
>
>  	if (likely(ac->avail < ac->limit)) {
>  		STATS_INC_FREEHIT(cachep);
> -		ac->entry[ac->avail++] = objp;
> +		ac_put_obj(cachep, ac, objp);
>  		return;
>  	} else {
>  		STATS_INC_FREEMISS(cachep);
>  		cache_flusharray(cachep, ac);
> -		ac->entry[ac->avail++] = objp;
> +		ac_put_obj(cachep, ac, objp);
>  	}
>  }

and here.


> diff --git a/mm/slub.c b/mm/slub.c
> index 4907563..8eed0de 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c

> @@ -2304,8 +2327,8 @@ redo:
>  	barrier();
>
>  	object = c->freelist;
> -	if (unlikely(!object || !node_match(c, node)))
> -
> +	if (unlikely(!object || !node_match(c, node) ||
> +					!pfmemalloc_match(c, gfpflags)))
>  		object = __slab_alloc(s, gfpflags, node, addr, c);
>
>  	else {


Modification to hotpath. That could be fixed here by forcing pfmemalloc
(like debug allocs) to always go to the slow path and checking in there
instead. Just keep c->freelist == NULL.



