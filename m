Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab1EZWOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:14:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61917 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab1EZWOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:14:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type:content-id;
        b=OvHeQsLTmpf64DeWjPXVZU7ceey44YO6N863tSaDrgI1wgB+/Ig1jj1pVc/zE3YSy8
         lGe+ZYzzHvPwPb6S2y9Q==
Date: Thu, 26 May 2011 15:14:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv6 06/17] slub: Add cmpxchg_double_slab()
In-Reply-To: <20110526181504.863758450@linux.com>
Message-ID: <alpine.DEB.2.00.1105261401160.10790@chino.kir.corp.google.com>
References: <20110526181442.789868308@linux.com> <20110526181504.863758450@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531368966-1358618695-1306443737=:10790"
Content-ID: <alpine.DEB.2.00.1105261509030.10790@chino.kir.corp.google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-1358618695-1306443737=:10790
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1105261509031.10790@chino.kir.corp.google.com>

On Thu, 26 May 2011, Christoph Lameter wrote:

> Add a function that operates on the second doubleword in the page struct
> and manipulates the object counters, the freelist and the frozen attribute.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  include/linux/slub_def.h |    1 +
>  mm/slub.c                |   45 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 46 insertions(+)
> 
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2011-05-16 11:46:33.591463082 -0500
> +++ linux-2.6/mm/slub.c	2011-05-16 11:46:51.181463060 -0500
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
> @@ -354,6 +358,37 @@ static void get_map(struct kmem_cache *s
>  		set_bit(slab_index(p, s, addr), map);
>  }
>  
> +static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
> +		void *freelist_old, unsigned long counters_old,
> +		void *freelist_new, unsigned long counters_new,
> +		const char *n)

This is defined only under CONFIG_SLUB_DEBUG, which is surely a mistake:

	mm/slub.c: In function ‘acquire_slab’:
	mm/slub.c:1460: error: implicit declaration of function ‘cmpxchg_double_slab’

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
> +
> +	cpu_relax();
> +	stat(s, CMPXCHG_DOUBLE_FAIL);
> +
> +#ifdef SLUB_DEBUG_CMPXCHG
> +	printk(KERN_INFO "%s %s: cmpxchg double redo ", n, s->name);
> +#endif
> +
> +	return 0;
> +}
> +
>  /*
>   * Debug settings:
>   */
> @@ -2596,6 +2631,12 @@ static int kmem_cache_open(struct kmem_c
>  		}
>  	}
>  
> +#ifdef CONFIG_CMPXCHG_DOUBLE
> +	if (system_has_cmpxchg_double() && (s->flags & SLAB_DEBUG_FLAGS) == 0)
> +		/* Enable fast mode */
> +		s->flags |= __CMPXCHG_DOUBLE;
> +#endif
> +

Not sure why this is excluded for SLAB_DEBUG_FLAGS?  If it really should 
be, then we should clear __CMPXCHG_DOUBLE if debugging features are 
enabled through sysfs as well.
--531368966-1358618695-1306443737=:10790--
