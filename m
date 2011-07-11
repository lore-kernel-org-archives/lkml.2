Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab1GKTzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:55:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34585 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1GKTzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:55:07 -0400
Subject: Re: [slubllv7 06/17] slub: Add cmpxchg_double_slab()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110601172615.286693377@linux.com>
References: <20110601172543.437240675@linux.com>
	 <20110601172615.286693377@linux.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 21:55:00 +0200
Message-ID: <1310414100.2860.6.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 01 juin 2011 à 12:25 -0500, Christoph Lameter a écrit :
> pièce jointe document texte brut (cmpxchg_double_slab)
> Add a function that operates on the second doubleword in the page struct
> and manipulates the object counters, the freelist and the frozen attribute.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  include/linux/slub_def.h |    1 
>  mm/slub.c                |   65 +++++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 61 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2011-05-31 11:57:59.622937422 -0500
> +++ linux-2.6/mm/slub.c	2011-05-31 12:03:16.652935392 -0500
> @@ -131,6 +131,9 @@ static inline int kmem_cache_debug(struc
>  /* Enable to test recovery from slab corruption on boot */
>  #undef SLUB_RESILIENCY_TEST
>  
> +/* Enable to log cmpxchg failures */
> +#undef SLUB_DEBUG_CMPXCHG
> +
>  /*
>   * Mininum number of partial slabs. These will be left on the partial
>   * lists even if they are empty. kmem_cache_shrink may reclaim them.
> @@ -170,6 +173,7 @@ static inline int kmem_cache_debug(struc
>  
>  /* Internal SLUB flags */
>  #define __OBJECT_POISON		0x80000000UL /* Poison object */
> +#define __CMPXCHG_DOUBLE	0x40000000UL /* Use cmpxchg_double */
>  
>  static int kmem_size = sizeof(struct kmem_cache);
>  
> @@ -338,6 +342,37 @@ static inline int oo_objects(struct kmem
>  	return x.x & OO_MASK;
>  }
>  
> +static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
> +		void *freelist_old, unsigned long counters_old,
> +		void *freelist_new, unsigned long counters_new,
> +		const char *n)
> +{
> +#ifdef CONFIG_CMPXCHG_DOUBLE
> +	if (s->flags & __CMPXCHG_DOUBLE) {
> +		if (cmpxchg_double(&page->freelist,
> +			freelist_old, counters_old,
> +			freelist_new, counters_new))
> +		return 1;
> +	} else
> +#endif
> +	{
> +		if (page->freelist == freelist_old && page->counters == counters_old) {
> +			page->freelist = freelist_new;
> +			page->counters = counters_new;
> +			return 1;
> +		}
> +	}

This works only on 64bit arches, where page->counters get all following
fields combined : inuse, objects, frozen, _count

On 32bit arch, I am afraid you have to disable the cmpxchg_double()
thing ?




