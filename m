Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab0FYVk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 17:40:26 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:33402 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751895Ab0FYVkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 17:40:25 -0400
Date: Fri, 25 Jun 2010 17:40:22 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
To: linux-kernel@vger.kernel.org, npiggin@suse.de
Message-ID: <1731662946.966291277502022446.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <118879818.966271277501902144.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH] cache last free vmap_area to avoid restarting beginning
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-05-25 8:43:23, Nick Piggin wrote:
> On Wed, May 19, 2010 at 02:54:54PM +0100, Steven Whitehouse wrote:
> > so that seems to pinpoint the line on which the problem occurred. Let us
> > know if you'd like us to do some more testing. I think we have the
> > console access issue fixed now. Many thanks for all you help in this
> > so far,
> 
> Sorry for the delay. Ended up requiring a bit of surgery and several bug
> fixes. I added a lot more test cases to my userspace tester, and found
> several bugs including the one you hit.
> 
> Most of them were due to changing vstart,vend or changing requested
> alignment.
> 
> I can't guarantee it's going to work for you (it boots here, but the
> last version booted as well). But I think it's in much better shape.
> 
> It is very careful to reproduce exactly the same allocation behaviour,
> so the effectiveness of the cache can be reduced if sizes, alignments,
> or start,end ranges are very frequently changing. But I'd hope that
> for most vmap heavy workloads, they should cache quite well. We could
> look at doing smarter things if it isn't effective enough.
> 
> --
> Provide a free area cache for the vmalloc virtual address allocator, based
> on the approach taken in the user virtual memory allocator.
> 
> This reduces the number of rbtree operations and linear traversals over
> the vmap extents to find a free area. The lazy vmap flushing makes this problem
> worse because because freed but not yet flushed vmaps tend to build up in
> the address space between flushes.
> 
> Steven noticed a performance problem with GFS2. Results are as follows...
> 
> 
> 
>  mm/vmalloc.c |   49 +++++++++++++++++++++++++++++++++++--------------
>  1 files changed, 35 insertions(+), 14 deletions(-)
> 
> Index: linux-2.6/mm/vmalloc.c
> ===================================================================
> --- linux-2.6.orig/mm/vmalloc.c
> +++ linux-2.6/mm/vmalloc.c
> @@ -262,8 +262,14 @@ struct vmap_area {
>  };
>  
>  static DEFINE_SPINLOCK(vmap_area_lock);
> -static struct rb_root vmap_area_root = RB_ROOT;
>  static LIST_HEAD(vmap_area_list);
> +static struct rb_root vmap_area_root = RB_ROOT;
> +
> +static struct rb_node *free_vmap_cache;
> +static unsigned long cached_hole_size;
> +static unsigned long cached_start;
> +static unsigned long cached_align;
> +
>  static unsigned long vmap_area_pcpu_hole;
>  
>  static struct vmap_area *__find_vmap_area(unsigned long addr)
> @@ -332,27 +338,52 @@ static struct vmap_area *alloc_vmap_area
>  	struct rb_node *n;
>  	unsigned long addr;
>  	int purged = 0;
> +	struct vmap_area *first;
>  
>  	BUG_ON(!size);
>  	BUG_ON(size & ~PAGE_MASK);
> +	BUG_ON(!is_power_of_2(align));
>  
>  	va = kmalloc_node(sizeof(struct vmap_area),
>  			gfp_mask & GFP_RECLAIM_MASK, node);
>  	if (unlikely(!va))
>  		return ERR_PTR(-ENOMEM);
>  
> +	spin_lock(&vmap_area_lock);
>  retry:
> -	addr = ALIGN(vstart, align);
> +	/* invalidate cache if we have more permissive parameters */
> +	if (!free_vmap_cache ||
> +			size <= cached_hole_size ||
> +			vstart < cached_start ||
> +			align < cached_align) {
> +		cached_hole_size = 0;
> +		free_vmap_cache = NULL;
> +	}
> +	/* record if we encounter less permissive parameters */
> +	cached_start = vstart;
> +	cached_align = align;
> +
> +	/* find starting point for our search */
> +	if (free_vmap_cache) {
> +		first = rb_entry(free_vmap_cache, struct vmap_area, rb_node);
> +		addr = ALIGN(first->va_end + PAGE_SIZE, align);
> +		if (addr < vstart) {
> +			free_vmap_cache = NULL;
> +			goto retry;
> +		}
> +		if (addr + size - 1 < addr)
> +			goto overflow;
>  
> -	spin_lock(&vmap_area_lock);
> -	if (addr + size - 1 < addr)
> -		goto overflow;
> +	} else {
> +		addr = ALIGN(vstart, align);
> +		if (addr + size - 1 < addr)
> +			goto overflow;
>  
> -	/* XXX: could have a last_hole cache */
> -	n = vmap_area_root.rb_node;
> -	if (n) {
> -		struct vmap_area *first = NULL;
> +		n = vmap_area_root.rb_node;
> +		if (!n)
> +			goto found;
>  
> +		first = NULL;
>  		do {
>  			struct vmap_area *tmp;
>  			tmp = rb_entry(n, struct vmap_area, rb_node);
> @@ -369,26 +400,37 @@ retry:
>  		if (!first)
>  			goto found;
>  
> -		if (first->va_end < addr) {
> -			n = rb_next(&first->rb_node);
> -			if (n)
> -				first = rb_entry(n, struct vmap_area, rb_node);
> -			else
> -				goto found;
> -		}
> -
> -		while (addr + size > first->va_start && addr + size <= vend) {
> -			addr = ALIGN(first->va_end + PAGE_SIZE, align);
> +		if (first->va_start < addr) {
> +			addr = ALIGN(max(first->va_end + PAGE_SIZE, addr), align);
>  			if (addr + size - 1 < addr)
>  				goto overflow;
> -
>  			n = rb_next(&first->rb_node);
>  			if (n)
>  				first = rb_entry(n, struct vmap_area, rb_node);
>  			else
>  				goto found;
>  		}
> +		BUG_ON(first->va_start < addr);
> +		if (addr + cached_hole_size < first->va_start)
> +			cached_hole_size = first->va_start - addr;
> +	}
> +
> +	/* from the starting point, walk areas until a suitable hole is found */
> +
> +	while (addr + size > first->va_start && addr + size <= vend) {
> +		if (addr + cached_hole_size < first->va_start)
> +			cached_hole_size = first->va_start - addr;
> +		addr = ALIGN(first->va_end + PAGE_SIZE, align);
> +		if (addr + size - 1 < addr)
> +			goto overflow;
> +
> +		n = rb_next(&first->rb_node);
> +		if (n)
> +			first = rb_entry(n, struct vmap_area, rb_node);
> +		else
> +			goto found;
>  	}
> +
>  found:
>  	if (addr + size > vend) {
>  overflow:
> @@ -406,14 +448,17 @@ overflow:
>  		return ERR_PTR(-EBUSY);
>  	}
>  
> -	BUG_ON(addr & (align-1));
> -
>  	va->va_start = addr;
>  	va->va_end = addr + size;
>  	va->flags = 0;
>  	__insert_vmap_area(va);
> +	free_vmap_cache = &va->rb_node;
>  	spin_unlock(&vmap_area_lock);
>  
> +	BUG_ON(va->va_start & (align-1));
> +	BUG_ON(va->va_start < vstart);
> +	BUG_ON(va->va_end > vend);
> +
>  	return va;
>  }
>  
> @@ -427,6 +472,19 @@ static void rcu_free_va(struct rcu_head
>  static void __free_vmap_area(struct vmap_area *va)
>  {
>  	BUG_ON(RB_EMPTY_NODE(&va->rb_node));
> +
> +	if (free_vmap_cache) {
> +		if (va->va_end < cached_start) {
> +			free_vmap_cache = NULL;
> +		} else {
> +			struct vmap_area *cache;
> +			cache = rb_entry(free_vmap_cache, struct vmap_area, rb_node);
> +			if (va->va_start <= cache->va_start) {
> +				free_vmap_cache = rb_prev(&va->rb_node);
> +				cache = rb_entry(free_vmap_cache, struct vmap_area, rb_node);
> +			}
> +		}
> +	}
>  	rb_erase(&va->rb_node, &vmap_area_root);
>  	RB_CLEAR_NODE(&va->rb_node);
>  	list_del_rcu(&va->list);

Hey Nick,

I spotted what seems to be a regression in this patch.
The spin_lock was moved before the try loop:

	spin_lock(&vmap_area_lock);
retry:

But later, after the overflow label, it can unlock the spin_lock and
loop back to retry without the spin_lock locked.  See:

overflow:
		spin_unlock(&vmap_area_lock);
		if (!purged) {
			purge_vmap_area_lazy();
			purged = 1;
			goto retry;

If I'm not mistaken we should either put the spin_lock back below the
retry label or move the spin_unlock after the if (!purged) to prevent
accesses without the spin_lock held.

Regards,

Bob Peterson
Red Hat File Systems
