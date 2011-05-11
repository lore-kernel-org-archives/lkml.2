Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab1EKVNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:13:20 -0400
Received: from smtp-out.google.com ([74.125.121.67]:16556 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab1EKVNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=GOjQstjhUi5+miVT3FuJgrBsdn1aQbh3jc8M6NAlA/IkwM3SysYittYZngKQ+L1F6y
         FIQ/+hL0ClOS7tYAnBEw==
Date: Wed, 11 May 2011 14:13:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] slub: Per object NUMA support
In-Reply-To: <alpine.DEB.2.00.1104151449370.12627@router.home>
Message-ID: <alpine.DEB.2.00.1105111407530.9346@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104151449370.12627@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011, Christoph Lameter wrote:

> I am not sure if such a feature is needed/wanted/desired. It would make
> the object allocation method similar to SLAB instead of relying on page
> based policy application (which IMHO was the intend of the memory policy
> system before Paul Jackson got that changed in SLAB).
> 
> Anyways the implementation is rather simple.
> 

The implementation may be simple, but it seems like this would absolutely 
kill performance for MPOL_INTERLEAVE if slub is required for every 
kmalloc() or kmem_cache_alloc() to take the alternate slab node's 
list_lock to scan the partial list or, worse yet, allocate a new slab on 
that node when there are objects available on the freelist.

That, to me, would always nullify the performance benefit of using the 
mempolicy in the first place and end up making MPOL_INTERLEAVE worse than 
no mempolicy.  Do you have any benchmarks that suggest this has no 
negative impact?  I'd be very surprised.

> Currently slub applies NUMA policies per allocated slab page. Change
> that to apply memory policies for each individual object allocated.
> 
> F.e. before this patch MPOL_INTERLEAVE would return objects from the
> same slab page until a new slab page was allocated. Now an object
> from a different page is taken for each allocation.
> 
> This increases the overhead of the fastpath under NUMA.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  mm/slub.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2011-04-15 12:54:42.000000000 -0500
> +++ linux-2.6/mm/slub.c	2011-04-15 13:11:25.000000000 -0500
> @@ -1887,6 +1887,21 @@ debug:
>  	goto unlock_out;
>  }
> 
> +static __always_inline int alternate_slab_node(struct kmem_cache *s,
> +						gfp_t flags, int node)
> +{
> +#ifdef CONFIG_NUMA
> +	if (unlikely(node == NUMA_NO_NODE &&
> +			!(flags & __GFP_THISNODE) &&
> +			!in_interrupt())) {
> +		if ((s->flags & SLAB_MEM_SPREAD) && cpuset_do_slab_mem_spread())
> +			node = cpuset_slab_spread_node();
> +		else if (current->mempolicy)
> +		node = slab_node(current->mempolicy);
> +	}
> +#endif
> +	return node;
> +}
>  /*
>   * Inlined fastpath so that allocation functions (kmalloc, kmem_cache_alloc)
>   * have the fastpath folded into their functions. So no function call
> @@ -1911,6 +1926,7 @@ static __always_inline void *slab_alloc(
>  	if (slab_pre_alloc_hook(s, gfpflags))
>  		return NULL;
> 
> +	node = alternate_slab_node(s, gfpflags, node);
>  #ifndef CONFIG_CMPXCHG_LOCAL
>  	local_irq_save(flags);
>  #else
> 
