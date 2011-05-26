Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab1EZWQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:16:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32281 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab1EZWQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:16:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type:content-id;
        b=FswYJg8w+67BHEFPg2JGV4QZzAzBXsFJ4kPtV/8zpH14uHXB8bkVQjE8Cly/5ZcMHY
         GwQFii5pjmn/13eRDMvA==
Date: Thu, 26 May 2011 15:15:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv6 07/17] slub: explicit list_lock taking
In-Reply-To: <20110526181505.440015365@linux.com>
Message-ID: <alpine.DEB.2.00.1105261410291.10790@chino.kir.corp.google.com>
References: <20110526181442.789868308@linux.com> <20110526181505.440015365@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531368966-1511913363-1306444279=:10790"
Content-ID: <alpine.DEB.2.00.1105261413040.10790@chino.kir.corp.google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-1511913363-1306444279=:10790
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1105261413041.10790@chino.kir.corp.google.com>

On Thu, 26 May 2011, Christoph Lameter wrote:

> The allocator fastpath rework does change the usage of the list_lock.
> Remove the list_lock processing from the functions that hide them from the
> critical sections and move them into those critical sections.
> 
> This in turn simplifies the support functions (no __ variant needed anymore)
> and simplifies the lock handling on bootstrap.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  mm/slub.c |   74 ++++++++++++++++++++++++++++++--------------------------------
>  1 file changed, 36 insertions(+), 38 deletions(-)
> 
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2011-05-24 09:40:43.764875120 -0500
> +++ linux-2.6/mm/slub.c	2011-05-24 09:40:44.814875113 -0500
> @@ -917,25 +917,21 @@ static inline void slab_free_hook(struct
>  /*
>   * Tracking of fully allocated slabs for debugging purposes.
>   */
> -static void add_full(struct kmem_cache_node *n, struct page *page)
> +static void add_full(struct kmem_cache *s,
> +	struct kmem_cache_node *n, struct page *page)

This also needs an update to the CONFIG_SLUB_DEBUG=n definition, not only 
for number of arguments but also the order:

	mm/slub.c:1781: error: too many arguments to function ‘add_full’

and

	mm/slub.c:1781: warning: passing argument 1 of ‘add_full’ from incompatible pointer type
	mm/slub.c:1187: note: expected ‘struct kmem_cache_node *’ but argument is of type ‘struct kmem_cache *’
	mm/slub.c:1781: warning: passing argument 2 of ‘add_full’ from incompatible pointer type
	mm/slub.c:1187: note: expected ‘struct page *’ but argument is of type ‘struct kmem_cache_node *’

>  {
> -	spin_lock(&n->list_lock);
> +	if (!(s->flags & SLAB_STORE_USER))
> +		return;
> +
>  	list_add(&page->lru, &n->full);
> -	spin_unlock(&n->list_lock);
>  }
>  
>  static void remove_full(struct kmem_cache *s, struct page *page)
>  {
> -	struct kmem_cache_node *n;
> -
>  	if (!(s->flags & SLAB_STORE_USER))
>  		return;
>  
> -	n = get_node(s, page_to_nid(page));
> -
> -	spin_lock(&n->list_lock);
>  	list_del(&page->lru);
> -	spin_unlock(&n->list_lock);
>  }
>  
>  /* Tracking of the number of slabs for debugging purposes */
> @@ -1060,8 +1056,13 @@ static noinline int free_debug_processin
>  	}
>  
>  	/* Special debug activities for freeing objects */
> -	if (!page->frozen && !page->freelist)
> +	if (!page->frozen && !page->freelist) {
> +		struct kmem_cache_node *n = get_node(s, page_to_nid(page));
> +
> +		spin_lock(&n->list_lock);
>  		remove_full(s, page);
> +		spin_unlock(&n->list_lock);
> +	}
>  	if (s->flags & SLAB_STORE_USER)
>  		set_track(s, object, TRACK_FREE, addr);
>  	trace(s, page, object, 0);
> @@ -1420,36 +1421,26 @@ static __always_inline int slab_trylock(
>  /*
>   * Management of partially allocated slabs
>   */
> -static void add_partial(struct kmem_cache_node *n,
> +static inline void add_partial(struct kmem_cache_node *n,
>  				struct page *page, int tail)
>  {
> -	spin_lock(&n->list_lock);
>  	n->nr_partial++;
>  	if (tail)
>  		list_add_tail(&page->lru, &n->partial);
>  	else
>  		list_add(&page->lru, &n->partial);
> -	spin_unlock(&n->list_lock);
>  }
>  
> -static inline void __remove_partial(struct kmem_cache_node *n,
> +static inline void remove_partial(struct kmem_cache_node *n,
>  					struct page *page)
>  {
>  	list_del(&page->lru);
>  	n->nr_partial--;
>  }
>  
> -static void remove_partial(struct kmem_cache *s, struct page *page)
> -{
> -	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
> -
> -	spin_lock(&n->list_lock);
> -	__remove_partial(n, page);
> -	spin_unlock(&n->list_lock);
> -}
> -
>  /*
> - * Lock slab and remove from the partial list.
> + * Lock slab, remove from the partial list and put the object into the
> + * per cpu freelist.
>   *
>   * Must hold list_lock.
>   */
> @@ -1457,7 +1448,7 @@ static inline int lock_and_freeze_slab(s
>  							struct page *page)
>  {
>  	if (slab_trylock(page)) {
> -		__remove_partial(n, page);
> +		remove_partial(n, page);
>  		return 1;
>  	}
>  	return 0;
> @@ -1574,12 +1565,17 @@ static void unfreeze_slab(struct kmem_ca
>  	if (page->inuse) {
>  
>  		if (page->freelist) {
> +			spin_lock(&n->list_lock);
>  			add_partial(n, page, tail);
> +			spin_unlock(&n->list_lock);
>  			stat(s, tail ? DEACTIVATE_TO_TAIL : DEACTIVATE_TO_HEAD);
>  		} else {
>  			stat(s, DEACTIVATE_FULL);
> -			if (kmem_cache_debug(s) && (s->flags & SLAB_STORE_USER))
> -				add_full(n, page);
> +			if (kmem_cache_debug(s) && (s->flags & SLAB_STORE_USER)) {
> +				spin_lock(&n->list_lock);
> +				add_full(s, n, page);
> +				spin_unlock(&n->list_lock);
> +			}
>  		}
>  		slab_unlock(page);
>  	} else {
> @@ -1595,7 +1591,9 @@ static void unfreeze_slab(struct kmem_ca
>  			 * kmem_cache_shrink can reclaim any empty slabs from
>  			 * the partial list.
>  			 */
> +			spin_lock(&n->list_lock);
>  			add_partial(n, page, 1);
> +			spin_unlock(&n->list_lock);
>  			slab_unlock(page);
>  		} else {
>  			slab_unlock(page);
> @@ -2097,7 +2095,11 @@ static void __slab_free(struct kmem_cach
>  	 * then add it.
>  	 */
>  	if (unlikely(!prior)) {
> +		struct kmem_cache_node *n = get_node(s, page_to_nid(page));
> +
> +		spin_lock(&n->list_lock);
>  		add_partial(get_node(s, page_to_nid(page)), page, 1);
> +		spin_unlock(&n->list_lock);
>  		stat(s, FREE_ADD_PARTIAL);
>  	}
>  
> @@ -2111,7 +2113,11 @@ slab_empty:
>  		/*
>  		 * Slab still on the partial list.
>  		 */
> -		remove_partial(s, page);
> +		struct kmem_cache_node *n = get_node(s, page_to_nid(page));
> +
> +		spin_lock(&n->list_lock);
> +		remove_partial(n, page);
> +		spin_unlock(&n->list_lock);
>  		stat(s, FREE_REMOVE_PARTIAL);
>  	}
>  	slab_unlock(page);
> @@ -2393,7 +2399,6 @@ static void early_kmem_cache_node_alloc(
>  {
>  	struct page *page;
>  	struct kmem_cache_node *n;
> -	unsigned long flags;
>  
>  	BUG_ON(kmem_cache_node->size < sizeof(struct kmem_cache_node));
>  
> @@ -2420,14 +2425,7 @@ static void early_kmem_cache_node_alloc(
>  	init_kmem_cache_node(n, kmem_cache_node);
>  	inc_slabs_node(kmem_cache_node, node, page->objects);
>  
> -	/*
> -	 * lockdep requires consistent irq usage for each lock
> -	 * so even though there cannot be a race this early in
> -	 * the boot sequence, we still disable irqs.
> -	 */
> -	local_irq_save(flags);
>  	add_partial(n, page, 0);
> -	local_irq_restore(flags);
>  }
>  
>  static void free_kmem_cache_nodes(struct kmem_cache *s)
> @@ -2711,7 +2709,7 @@ static void free_partial(struct kmem_cac
>  	spin_lock_irqsave(&n->list_lock, flags);
>  	list_for_each_entry_safe(page, h, &n->partial, lru) {
>  		if (!page->inuse) {
> -			__remove_partial(n, page);
> +			remove_partial(n, page);
>  			discard_slab(s, page);
>  		} else {
>  			list_slab_objects(s, page,
> @@ -3049,7 +3047,7 @@ int kmem_cache_shrink(struct kmem_cache
>  				 * may have freed the last object and be
>  				 * waiting to release the slab.
>  				 */
> -				__remove_partial(n, page);
> +				remove_partial(n, page);
>  				slab_unlock(page);
>  				discard_slab(s, page);
>  			} else {
> 
> 
--531368966-1511913363-1306444279=:10790--
