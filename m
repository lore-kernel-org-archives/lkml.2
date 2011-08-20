Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab1HTKkT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 06:40:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51126 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1HTKkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 06:40:18 -0400
Date: Sat, 20 Aug 2011 13:40:11 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@localhost6.localdomain6
To: Christoph Lameter <cl@linux.com>
cc: linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [slub p4 6/7] slub: per cpu cache for partial pages
In-Reply-To: <20110809211302.222722588@linux.com>
Message-ID: <alpine.DEB.2.00.1108201339580.3008@localhost6.localdomain6>
References: <20110809211221.831975979@linux.com> <20110809211302.222722588@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -2919,7 +3071,34 @@ static int kmem_cache_open(struct kmem_c
>  	 * The larger the object size is, the more pages we want on the partial
>  	 * list to avoid pounding the page allocator excessively.
>  	 */
> -	set_min_partial(s, ilog2(s->size));
> +	set_min_partial(s, ilog2(s->size) / 2);

Why do we want to make minimum size smaller?

> +
> +	/*
> +	 * cpu_partial determined the maximum number of objects kept in the
> +	 * per cpu partial lists of a processor.
> +	 *
> +	 * Per cpu partial lists mainly contain slabs that just have one
> +	 * object freed. If they are used for allocation then they can be
> +	 * filled up again with minimal effort. The slab will never hit the
> +	 * per node partial lists and therefore no locking will be required.
> +	 *
> +	 * This setting also determines
> +	 *
> +	 * A) The number of objects from per cpu partial slabs dumped to the
> +	 *    per node list when we reach the limit.
> +	 * B) The number of objects in partial partial slabs to extract from the
> +	 *    per node list when we run out of per cpu objects. We only fetch 50%
> +	 *    to keep some capacity around for frees.
> +	 */
> +	if (s->size >= PAGE_SIZE)
> +		s->cpu_partial = 2;
> +	else if (s->size >= 1024)
> +		s->cpu_partial = 6;
> +	else if (s->size >= 256)
> +		s->cpu_partial = 13;
> +	else
> +		s->cpu_partial = 30;

How did you come up with these limits?

> Index: linux-2.6/include/linux/mm_types.h
> ===================================================================
> --- linux-2.6.orig/include/linux/mm_types.h	2011-08-05 12:06:57.571873039 -0500
> +++ linux-2.6/include/linux/mm_types.h	2011-08-09 13:05:13.201582001 -0500
> @@ -79,9 +79,21 @@ struct page {
>  	};
>
>  	/* Third double word block */
> -	struct list_head lru;		/* Pageout list, eg. active_list
> +	union {
> +		struct list_head lru;	/* Pageout list, eg. active_list
>  					 * protected by zone->lru_lock !
>  					 */
> +		struct {		/* slub per cpu partial pages */
> +			struct page *next;	/* Next partial slab */
> +#ifdef CONFIG_64BIT
> +			int pages;	/* Nr of partial slabs left */
> +			int pobjects;	/* Approximate # of objects */
> +#else
> +			short int pages;
> +			short int pobjects;
> +#endif
> +		};
> +	};

Why are the sizes different on 32-bit and 64-bit? Does this change 'struct
page' size?
