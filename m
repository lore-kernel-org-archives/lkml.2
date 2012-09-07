Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab2IGV11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 17:27:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab2IGV1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 17:27:24 -0400
Date: Fri, 7 Sep 2012 14:27:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com,
        Benjamin Gaignard <benjamin.gaignard@stericsson.com>
Subject: Re: [PATCH] genalloc: make possible to use a custom allocation
 algorithm
Message-Id: <20120907142723.5766b42d.akpm@linux-foundation.org>
In-Reply-To: <1347009393-8751-1-git-send-email-benjamin.gaignard@stericsson.com>
References: <[PATCH] genalloc: add best fit algorithm>
	<1347009393-8751-1-git-send-email-benjamin.gaignard@stericsson.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Sep 2012 11:16:33 +0200
Benjamin Gaignard <benjamin.gaignard@linaro.org> wrote:

> From: Benjamin Gaignard <benjamin.gaignard@stericsson.com>
> 
> This patch allow to use another algorithm than the default first-fit one.
> For example a custom algorithm could be used to manage alignment requirements.
> 
> Add of best-fit algorithm function:
> most of the time best-fit is slower then first-fit but memory fragmentation is lower.
> Random buffer allocation/free tests don't show any arithmetic relation between
> allocation time and fragmentation but best-fit algorithm is sometime able to perform the allocation when first-fit can't.
> 
> This new algorithm help to solve fragmentation issues on ESRAM shared by multiple
> hardware IP allocating and freeing dynamically memory region of various sizes.

hm, OK.  What kernel subsystem are you referring to here?  Where do I
find this "ESRAM shared by multiple hardware"?

> --- a/include/linux/genalloc.h
> +++ b/include/linux/genalloc.h
> @@ -36,6 +36,10 @@ struct gen_pool {
>  	spinlock_t lock;
>  	struct list_head chunks;	/* list of chunks in this pool */
>  	int min_alloc_order;		/* minimum allocation order */
> +
> +	unsigned long (*algo)(unsigned long *, unsigned long,
> +			unsigned long, unsigned int, void *);
> +	void *data;
>  };
>  
>  /*
> @@ -78,4 +82,15 @@ extern void gen_pool_for_each_chunk(struct gen_pool *,
>  	void (*)(struct gen_pool *, struct gen_pool_chunk *, void *), void *);
>  extern size_t gen_pool_avail(struct gen_pool *);
>  extern size_t gen_pool_size(struct gen_pool *);
> +
> +extern void gen_pool_set_algo(struct gen_pool *,
> +		unsigned long (*)(unsigned long *, unsigned long, unsigned long,
> +		unsigned int, void *), void *);
> +
> +extern unsigned long gen_pool_first_fit(unsigned long *, unsigned long,
> +		unsigned long, unsigned int, void *);
> +
> +extern unsigned long gen_pool_best_fit(unsigned long *, unsigned long,
> +			unsigned long, unsigned int, void *);
> +
>  #endif /* __GENALLOC_H__ */
> diff --git a/lib/genalloc.c b/lib/genalloc.c
> index 6bc04aa..a0d73c8 100644
> --- a/lib/genalloc.c
> +++ b/lib/genalloc.c
> @@ -152,6 +152,8 @@ struct gen_pool *gen_pool_create(int min_alloc_order, int nid)
>  		spin_lock_init(&pool->lock);
>  		INIT_LIST_HEAD(&pool->chunks);
>  		pool->min_alloc_order = min_alloc_order;
> +		pool->algo = gen_pool_first_fit;
> +		pool->data = NULL;
>  	}
>  	return pool;
>  }
> @@ -255,8 +257,9 @@ EXPORT_SYMBOL(gen_pool_destroy);
>   * @size: number of bytes to allocate from the pool
>   *
>   * Allocate the requested number of bytes from the specified pool.
> - * Uses a first-fit algorithm. Can not be used in NMI handler on
> - * architectures without NMI-safe cmpxchg implementation.
> + * Uses the pool allocation function (with first-fit algorithm by default).
> + * Can not be used in NMI handler on architectures without
> + * NMI-safe cmpxchg implementation.
>   */
>  unsigned long gen_pool_alloc(struct gen_pool *pool, size_t size)
>  {
> @@ -280,8 +283,8 @@ unsigned long gen_pool_alloc(struct gen_pool *pool, size_t size)
>  
>  		end_bit = (chunk->end_addr - chunk->start_addr) >> order;
>  retry:
> -		start_bit = bitmap_find_next_zero_area(chunk->bits, end_bit,
> -						       start_bit, nbits, 0);
> +		start_bit = pool->algo(chunk->bits, end_bit, start_bit, nbits,
> +				pool->data);
>  		if (start_bit >= end_bit)
>  			continue;
>  		remain = bitmap_set_ll(chunk->bits, start_bit, nbits);
> @@ -400,3 +403,78 @@ size_t gen_pool_size(struct gen_pool *pool)
>  	return size;
>  }
>  EXPORT_SYMBOL_GPL(gen_pool_size);
> +
> +/**
> + * gen_pool_set_algo - set the allocation algorithm
> + * @pool: pool to change allocation algorithm
> + * @priv: private data to be pass to algorithm function
> + * @algo: custom algorithm function
> + */
> +void gen_pool_set_algo(struct gen_pool *pool,
> +	unsigned long (*algo)(unsigned long *map, unsigned long size,
> +	unsigned long start, unsigned int nr, void *data), void *data)
> +{
> +	rcu_read_lock();
> +
> +	pool->algo = algo;
> +	if (!pool->algo)
> +		pool->algo = gen_pool_first_fit;
> +
> +	pool->data = data;
> +
> +	rcu_read_unlock();
> +}
> +EXPORT_SYMBOL(gen_pool_set_algo);

It's sometimes nice to make such a function return the old value.  But
there's hopefully little point in doing that here, and there are two
"old values" anyway.

And what's up with `data'?  If the caller is passing algo==NULL then
that caller has no business specifying gen_pool_first_fit's "data"!

Presumably, the requirement is that data==NULL if algo==NULL?  If so,
let's document that.

Also the kerneldoc is quite wrong - fields are misnamed and fields are
missing altogether.

> +EXPORT_SYMBOL(gen_pool_first_fit);

Why is gen_pool_first_fit exported?  gen_pool_set_algo() can reference
gen_pool_first_fit() by passing in NULL, hence no need for the export? 
gen_pool_first_fit() can be made static to this file?

> +
> +/**
> + * gen_pool_best_fit - find the best fiting region of memory
> + * macthing the size requirement (no alignment constraint)
> + * @map: The address to base the search on
> + * @size: The bitmap size in bits
> + * @start: The bitnumber to start searching at
> + * @nr: The number of zeroed bits we're looking for
> + * @data: additional data - unused
> + *
> + * Iterate over the bitmap to find the smaller region where
> + * allocate the memory.

"to find the smallest free region from which we can allcoate the memory"

> + */
> +unsigned long gen_pool_best_fit(unsigned long *map, unsigned long size,
> +		unsigned long start, unsigned int nr, void *data)
> +{
> +	unsigned long start_bit = size;
> +	unsigned long len = size + 1;
> +	unsigned long index;
> +
> +	index = bitmap_find_next_zero_area(map, size, start, nr, 0);
> +
> +	while (index < size) {
> +		int next_bit = find_next_bit(map, size, index + nr);
> +		if ((next_bit - index) < len) {
> +			len = next_bit - index;
> +			start_bit = index;
> +			if (len == nr)
> +				return start_bit;
> +		}
> +		index = bitmap_find_next_zero_area(map, size,
> +						   next_bit + 1, nr, 0);
> +	}
> +
> +	return start_bit;
> +}
> +EXPORT_SYMBOL(gen_pool_best_fit);

`data' continues to be unused and it is unobvious what its use is.  Can
we just remove it?


There's a potential reference counting issue here.  Each time a genpool
is created to reference a particular algorithm function, it in effects
takes a reference on that algorithm function.  What this means is that
strictly speaking, gen_pool_set_algo() should do a
module_get()/module_put() to track how many genpools are referring to
that module's text.  So that the module cannot be unloaded while any
genpools are still referring to its algorithm function.

But we can probably get away without this, for now: the module will
keep track of all its genpools and will destroy them all before
permitting itself to be unloaded.

