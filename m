Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab1EZWNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:13:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28897 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab1EZWNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:13:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=OKF0/hWluXDkM9v5Nb9CqJ15di34HoZPGClZaYpjiEWkRU+Uj7PwIsjYp5d7d4TJUR
         U+Ie2MK3ilF7z5T6MssA==
Date: Thu, 26 May 2011 15:13:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv6 02/17] slub: Do not use frozen page flag but a bit in
 the page counters
In-Reply-To: <20110526181502.558602037@linux.com>
Message-ID: <alpine.DEB.2.00.1105261417550.10790@chino.kir.corp.google.com>
References: <20110526181442.789868308@linux.com> <20110526181502.558602037@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011, Christoph Lameter wrote:

> Do not use a page flag for the frozen bit. It needs to be part
> of the state that is handled with cmpxchg_double(). So use a bit
> in the counter struct in the page struct for that purpose.
> 

I don't think the new limit on the number of objects per page, 32767, 
should cause a problem in practice.

> Also all page start out as frozen pages so set the bit
> when the page is allocated.
> 

This comment is probably intended for the next patch in the series, which 
modifies new_slab() to set the bit on allocation.  There's no new behavior 
introduced by this patch.

> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> 
> ---
>  include/linux/mm_types.h   |    5 +++--
>  include/linux/page-flags.h |    2 --
>  mm/slub.c                  |   12 ++++++------
>  3 files changed, 9 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6/include/linux/mm_types.h
> ===================================================================
> --- linux-2.6.orig/include/linux/mm_types.h	2011-05-19 13:54:29.271151992 -0500
> +++ linux-2.6/include/linux/mm_types.h	2011-05-19 13:59:28.551151643 -0500
> @@ -41,8 +41,9 @@ struct page {
>  					 * & limit reverse map searches.
>  					 */
>  		struct {		/* SLUB */
> -			u16 inuse;
> -			u16 objects;
> +			unsigned inuse:16;
> +			unsigned objects:15;
> +			unsigned frozen:1;
>  		};
>  	};
>  	union {
> Index: linux-2.6/include/linux/page-flags.h
> ===================================================================
> --- linux-2.6.orig/include/linux/page-flags.h	2011-05-19 13:54:29.281151992 -0500
> +++ linux-2.6/include/linux/page-flags.h	2011-05-19 13:59:28.551151643 -0500
> @@ -212,8 +212,6 @@ PAGEFLAG(SwapBacked, swapbacked) __CLEAR
>  
>  __PAGEFLAG(SlobFree, slob_free)
>  
> -__PAGEFLAG(SlubFrozen, slub_frozen)
> -

The PG_slub_frozen entry in enum pageflags also needs to be removed.

>  /*
>   * Private page markings that may be used by the filesystem that owns the page
>   * for its own purposes.
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2011-05-19 13:59:24.981151647 -0500
> +++ linux-2.6/mm/slub.c	2011-05-19 13:59:28.561151643 -0500
> @@ -166,7 +166,7 @@ static inline int kmem_cache_debug(struc
>  
>  #define OO_SHIFT	16
>  #define OO_MASK		((1 << OO_SHIFT) - 1)
> -#define MAX_OBJS_PER_PAGE	65535 /* since page.objects is u16 */
> +#define MAX_OBJS_PER_PAGE	32767 /* since page.objects is u15 */
>  
>  /* Internal SLUB flags */
>  #define __OBJECT_POISON		0x80000000UL /* Poison object */
> @@ -1025,7 +1025,7 @@ static noinline int free_debug_processin
>  	}
>  
>  	/* Special debug activities for freeing objects */
> -	if (!PageSlubFrozen(page) && !page->freelist)
> +	if (!page->frozen && !page->freelist)
>  		remove_full(s, page);
>  	if (s->flags & SLAB_STORE_USER)
>  		set_track(s, object, TRACK_FREE, addr);
> @@ -1421,7 +1421,7 @@ static inline int lock_and_freeze_slab(s
>  {
>  	if (slab_trylock(page)) {
>  		__remove_partial(n, page);
> -		__SetPageSlubFrozen(page);
> +		page->frozen = 1;
>  		return 1;
>  	}
>  	return 0;
> @@ -1535,7 +1535,7 @@ static void unfreeze_slab(struct kmem_ca
>  {
>  	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
>  
> -	__ClearPageSlubFrozen(page);
> +	page->frozen = 0;
>  	if (page->inuse) {
>  
>  		if (page->freelist) {
> @@ -1866,7 +1866,7 @@ new_slab:
>  			flush_slab(s, c);
>  
>  		slab_lock(page);
> -		__SetPageSlubFrozen(page);
> +		page->frozen = 1;
>  		c->node = page_to_nid(page);
>  		c->page = page;
>  		goto load_freelist;
> @@ -2048,7 +2048,7 @@ static void __slab_free(struct kmem_cach
>  	page->freelist = object;
>  	page->inuse--;
>  
> -	if (unlikely(PageSlubFrozen(page))) {
> +	if (unlikely(page->frozen)) {
>  		stat(s, FREE_FROZEN);
>  		goto out_unlock;
>  	}
> 
> 
