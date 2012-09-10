Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab2IJBek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 21:34:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:26996 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898Ab2IJBei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 21:34:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,396,1344236400"; 
   d="scan'208";a="190696615"
Message-ID: <1347240876.28607.26.camel@yhuang-dev>
Subject: Re: [PATCH] genalloc: make possible to use a custom allocation
 algorithm
From: Huang Ying <ying.huang@intel.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Benjamin Gaignard <benjamin.gaignard@stericsson.com>
Date: Mon, 10 Sep 2012 09:34:36 +0800
In-Reply-To: <1347009393-8751-1-git-send-email-benjamin.gaignard@stericsson.com>
References: <[PATCH] genalloc: add best fit algorithm>
	 <1347009393-8751-1-git-send-email-benjamin.gaignard@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 11:16 +0200, Benjamin Gaignard wrote:
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
> 
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@stericsson.com>
> ---
>  include/linux/genalloc.h |   15 ++++++++
>  lib/genalloc.c           |   86 +++++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 97 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
> index 5e98eeb..b8570a7 100644
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

IMHO, you can use pool->lock here.  _set_algo need not to be lock-less.

> +
> +	pool->algo = algo;
> +	if (!pool->algo)
> +		pool->algo = gen_pool_first_fit;

Why not check input parameter algo?

> +
> +	pool->data = data;
> +
> +	rcu_read_unlock();
> +}
> +EXPORT_SYMBOL(gen_pool_set_algo);

[snip]

Best Regards,
Huang Ying

