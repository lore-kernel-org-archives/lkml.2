Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab1EZWNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:13:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28735 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab1EZWNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:13:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=l8JszhGyAAp01qKM7c6D0eslIMw3YGAZMtD1wxGUl4IgPXs+aeoGfw3sw29m7I7cVg
         cg0I5WeHzk3Oj2/qJ6aA==
Date: Thu, 26 May 2011 15:13:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv6 01/17] slub: Push irq disable into allocate_slab()
In-Reply-To: <20110526181501.946180879@linux.com>
Message-ID: <alpine.DEB.2.00.1105261348490.26952@chino.kir.corp.google.com>
References: <20110526181442.789868308@linux.com> <20110526181501.946180879@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011, Christoph Lameter wrote:

> Do the irq handling in allocate_slab() instead of __slab_alloc().
> 
> __slab_alloc() is already cluttered and allocate_slab() is already
> fiddling around with gfp flags.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  mm/slub.c |   21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2011-05-19 13:59:24.271151647 -0500
> +++ linux-2.6/mm/slub.c	2011-05-19 13:59:24.981151647 -0500
> @@ -1187,6 +1187,11 @@ static struct page *allocate_slab(struct
>  	struct kmem_cache_order_objects oo = s->oo;
>  	gfp_t alloc_gfp;
>  
> +	flags &= gfp_allowed_mask;
> +
> +	if (flags & __GFP_WAIT)
> +		local_irq_enable();
> +
>  	flags |= s->allocflags;
>  
>  	/*
> @@ -1203,12 +1208,15 @@ static struct page *allocate_slab(struct
>  		 * Try a lower order alloc if possible
>  		 */
>  		page = alloc_slab_page(flags, node, oo);
> -		if (!page)
> -			return NULL;
> -
>  		stat(s, ORDER_FALLBACK);
>  	}
>  
> +	if (flags & __GFP_WAIT)
> +		local_irq_disable();
> +
> +	if (!page)
> +		return NULL;
> +

This changes the meaning of ORDER_FALLBACK from its previous meaning, 
which was "number of times the preferred order could not be allocated and 
then minimum order could be allocated" to "number of times the preferred 
order could not be allocated, regardless of whether the minimum order 
allocation was successful."  The former is the true meaning of the word 
"fallback," so is this semantics change avoidable?  Otherwise it seems 
like the statistic should be renamed (NEW_SLAB_FAIL?)

>  	if (kmemcheck_enabled
>  		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
>  		int pages = 1 << oo_order(oo);
> @@ -1849,15 +1857,8 @@ new_slab:
>  		goto load_freelist;
>  	}
>  
> -	gfpflags &= gfp_allowed_mask;
> -	if (gfpflags & __GFP_WAIT)
> -		local_irq_enable();
> -
>  	page = new_slab(s, gfpflags, node);
>  
> -	if (gfpflags & __GFP_WAIT)
> -		local_irq_disable();
> -
>  	if (page) {
>  		c = __this_cpu_ptr(s->cpu_slab);
>  		stat(s, ALLOC_SLAB);
> 
> 
