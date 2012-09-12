Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386Ab2ILSr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:47:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab2ILSrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:47:23 -0400
Date: Wed, 12 Sep 2012 11:47:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@stericsson.com>
Subject: Re: [PATCH] genalloc: make possible to use a custom allocation
 algorithm
Message-Id: <20120912114720.a5c14a63.akpm@linux-foundation.org>
In-Reply-To: <CA+M3ks6G1+gYQAEPfEpfLEDUi+ktKtVisF9vU_Kf=kahv-M_fQ@mail.gmail.com>
References: <1347009393-8751-1-git-send-email-benjamin.gaignard@stericsson.com>
	<1347240876.28607.26.camel@yhuang-dev>
	<CA+M3ks7mYF1q3VOgA65V5DOj_1-MFDnqweoM+UMA_YHveOm+rw@mail.gmail.com>
	<CA+M3ks6G1+gYQAEPfEpfLEDUi+ktKtVisF9vU_Kf=kahv-M_fQ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2012 10:46:43 +0200
Benjamin Gaignard <benjamin.gaignard@linaro.org> wrote:

> >From e790af0773193c3c7e5950ab74fa5e1e29204ad5 Mon Sep 17 00:00:00 2001
> From: Benjamin Gaignard <benjamin.gaignard@stericsson.com>
> Date: Mon, 10 Sep 2012 10:11:05 +0200
> Subject: [PATCH] genalloc: make possible to use a custom allocation algorithm
> 
> This patch allow to use another algorithm than the default first-fit one.
> For example a custom algorithm could be used to manage alignment requirements.
> 
> Add of best-fit algorithm function:
> most of the time best-fit is slower then first-fit but memory
> fragmentation is lower.
> Random buffer allocation/free tests don't show any arithmetic relation between
> allocation time and fragmentation but best-fit algorithm is sometime
> able to perform the allocation when first-fit can't.

I still don't understand why this "data" argument is there.  Please
describe this fully in the changelog.  A usage example might help.

> This new algorithm help to solve fragmentation issues on ESRAM shared
> by multiple
> hardware IP allocating and freeing dynamically memory region of various sizes.

I earlier asked what the above meant, and someone provided a useful
reply.  Please get that reply into the changelog so that others don't
wonder the same thing.

Generally, any reviewer question should be taken as a sign that the
changelog or code commenting was inadequate.

> --- a/include/linux/genalloc.h
> +++ b/include/linux/genalloc.h
> @@ -36,6 +36,10 @@ struct gen_pool {
>  	spinlock_t lock;
>  	struct list_head chunks;	/* list of chunks in this pool */
>  	int min_alloc_order;		/* minimum allocation order */
> +
> +	unsigned long (*algo)(unsigned long *, unsigned long,
> +			unsigned long, unsigned int, void *);

I think it is better to include the names of the arguments.  The above
is pretty unreadable without this.

I suggest you create a typedef for this thing:

typedef unsigned long (*genpool_algo_t)(unsigned long *name1,
					unsigned long name2,
					unsigned long name3,
					unsigned int name4,
					void *data);

(with name[1-4] appropriately chosen) and use that throughout the patch.

typedefs are generally frowned upon, but this particular case is an
exception.

> +	void *data;
>  };
> 
>  /*
> @@ -78,4 +82,15 @@ extern void gen_pool_for_each_chunk(struct gen_pool *,
>  	void (*)(struct gen_pool *, struct gen_pool_chunk *, void *), void *);

The patch is wordwrapped.  Please fix up your email client.

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
> +		unsigned long, unsigned int, void *);

Ditto.  Yes, the current code leaves the names out, but that doesn't
mean it's a good thing to do.

>  #endif /* __GENALLOC_H__ */
> diff --git a/lib/genalloc.c b/lib/genalloc.c
> index 6bc04aa..9583dae 100644
> --- a/lib/genalloc.c
> +++ b/lib/genalloc.c
> @@ -152,6 +152,8 @@ struct gen_pool *gen_pool_create(int
> min_alloc_order, int nid)
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
> @@ -280,8 +283,8 @@ unsigned long gen_pool_alloc(struct gen_pool
> *pool, size_t size)
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
> @@ -400,3 +403,82 @@ size_t gen_pool_size(struct gen_pool *pool)
>  	return size;
>  }
>  EXPORT_SYMBOL_GPL(gen_pool_size);
> +
> +/**
> + * gen_pool_set_algo - set the allocation algorithm
> + * @pool: pool to change allocation algorithm
> + * @algo: custom algorithm function
> + * @data: additional data used by @algo
> + *
> + * Call @algo for each memory allocation in the pool.
> + * If @algo is NULL use gen_pool_first_fit as default
> + * memory allocation function.
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
> +
> +/**
> + * gen_pool_first_fit - find the first available region
> + * of memory macthing the size requirement (no alignment constraint)

"matching"

> + * @map: The address to base the search on
> + * @size: The bitmap size in bits
> + * @start: The bitnumber to start searching at
> + * @nr: The number of zeroed bits we're looking for
> + * @data: additional data - unused
> + */
> +unsigned long gen_pool_first_fit(unsigned long *map, unsigned long size,
> +		unsigned long start, unsigned int nr, void *data)
> +{
> +	return bitmap_find_next_zero_area(map, size, start, nr, 0);
> +}
> +EXPORT_SYMBOL(gen_pool_first_fit);
> +
> +/**
> + * gen_pool_best_fit - find the best fiting region of memory

"fitting"

> + * macthing the size requirement (no alignment constraint)

"matching"

> + * @map: The address to base the search on
> + * @size: The bitmap size in bits
> + * @start: The bitnumber to start searching at
> + * @nr: The number of zeroed bits we're looking for
> + * @data: additional data - unused
> + *
> + * Iterate over the bitmap to find the smallest free region
> + * which we can allocate the memory.
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

