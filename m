Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab1D1IQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:16:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60089 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab1D1IQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:16:04 -0400
Date: Thu, 28 Apr 2011 09:15:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] genalloc: add support to specify the physical
	address
Message-ID: <20110428081535.GI17290@n2100.arm.linux.org.uk>
References: <1303282455-26649-1-git-send-email-plagnioj@jcrosoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303282455-26649-1-git-send-email-plagnioj@jcrosoft.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 08:54:15AM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> so we specify the virtual address as base of the pool chunk and then
> get the physical address for hardware IP
> 
> as example on at91 we will use on spi, uart or macb
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Patrice VILCHEZ <patrice.vilchez@atmel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
> Hi Andrew,
> 	I integrate the documentation fix
> 	could replace the previous one with this one
> 
> V2:
> 	update documentation
> 	use phys_addr_t for physical addr
> Best Regards,

I notice no comments on this - maybe it needs to be Cc'd to linux-mm too?

Andrew - do you have any views on this?

> J.
>  include/linux/genalloc.h |   22 +++++++++++++++++++++-
>  lib/genalloc.c           |   45 +++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 58 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
> index b1c70f1..5bbebda 100644
> --- a/include/linux/genalloc.h
> +++ b/include/linux/genalloc.h
> @@ -26,13 +26,33 @@ struct gen_pool {
>  struct gen_pool_chunk {
>  	spinlock_t lock;
>  	struct list_head next_chunk;	/* next chunk in pool */
> +	phys_addr_t phys_addr;		/* physical starting address of memory chunk */
>  	unsigned long start_addr;	/* starting address of memory chunk */
>  	unsigned long end_addr;		/* ending address of memory chunk */
>  	unsigned long bits[0];		/* bitmap for allocating memory chunk */
>  };
>  
>  extern struct gen_pool *gen_pool_create(int, int);
> -extern int gen_pool_add(struct gen_pool *, unsigned long, size_t, int);
> +extern phys_addr_t gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long);
> +extern int gen_pool_add_virt(struct gen_pool *, unsigned long, phys_addr_t,
> +			     size_t, int);
> +/**
> + * gen_pool_add - add a new chunk of special memory to the pool
> + * @pool: pool to add new memory chunk to
> + * @addr: starting address of memory chunk to add to pool
> + * @size: size in bytes of the memory chunk to add to pool
> + * @nid: node id of the node the chunk structure and bitmap should be
> + *       allocated on, or -1
> + *
> + * Add a new chunk of special memory to the specified pool.
> + *
> + * Returns 0 on success or a -ve errno on failure.
> + */
> +static inline int gen_pool_add(struct gen_pool *pool, unsigned long addr,
> +			       size_t size, int nid)
> +{
> +	return gen_pool_add_virt(pool, addr, -1, size, nid);
> +}
>  extern void gen_pool_destroy(struct gen_pool *);
>  extern unsigned long gen_pool_alloc(struct gen_pool *, size_t);
>  extern void gen_pool_free(struct gen_pool *, unsigned long, size_t);
> diff --git a/lib/genalloc.c b/lib/genalloc.c
> index 1923f14..577ddf8 100644
> --- a/lib/genalloc.c
> +++ b/lib/genalloc.c
> @@ -39,17 +39,20 @@ struct gen_pool *gen_pool_create(int min_alloc_order, int nid)
>  EXPORT_SYMBOL(gen_pool_create);
>  
>  /**
> - * gen_pool_add - add a new chunk of special memory to the pool
> + * gen_pool_add_virt - add a new chunk of special memory to the pool
>   * @pool: pool to add new memory chunk to
> - * @addr: starting address of memory chunk to add to pool
> + * @virt: virtual starting address of memory chunk to add to pool
> + * @phys: physical starting address of memory chunk to add to pool
>   * @size: size in bytes of the memory chunk to add to pool
>   * @nid: node id of the node the chunk structure and bitmap should be
>   *       allocated on, or -1
>   *
>   * Add a new chunk of special memory to the specified pool.
> + *
> + * Returns 0 on success or a -ve errno on failure.
>   */
> -int gen_pool_add(struct gen_pool *pool, unsigned long addr, size_t size,
> -		 int nid)
> +int gen_pool_add_virt(struct gen_pool *pool, unsigned long virt, phys_addr_t phys,
> +		 size_t size, int nid)
>  {
>  	struct gen_pool_chunk *chunk;
>  	int nbits = size >> pool->min_alloc_order;
> @@ -58,11 +61,12 @@ int gen_pool_add(struct gen_pool *pool, unsigned long addr, size_t size,
>  
>  	chunk = kmalloc_node(nbytes, GFP_KERNEL | __GFP_ZERO, nid);
>  	if (unlikely(chunk == NULL))
> -		return -1;
> +		return -ENOMEM;
>  
>  	spin_lock_init(&chunk->lock);
> -	chunk->start_addr = addr;
> -	chunk->end_addr = addr + size;
> +	chunk->phys_addr = phys;
> +	chunk->start_addr = virt;
> +	chunk->end_addr = virt + size;
>  
>  	write_lock(&pool->lock);
>  	list_add(&chunk->next_chunk, &pool->chunks);
> @@ -70,7 +74,32 @@ int gen_pool_add(struct gen_pool *pool, unsigned long addr, size_t size,
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL(gen_pool_add);
> +EXPORT_SYMBOL(gen_pool_add_virt);
> +
> +/**
> + * gen_pool_virt_to_phys - return the physical address of memory
> + * @pool: pool to allocate from
> + * @addr: starting address of memory
> + *
> + * Returns the physical address on success, or -1 on error.
> + */
> +phys_addr_t gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long addr)
> +{
> +	struct list_head *_chunk;
> +	struct gen_pool_chunk *chunk;
> +
> +	read_lock(&pool->lock);
> +	list_for_each(_chunk, &pool->chunks) {
> +		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
> +
> +		if (addr >= chunk->start_addr && addr < chunk->end_addr)
> +			return chunk->phys_addr + addr - chunk->start_addr;
> +	}
> +	read_unlock(&pool->lock);
> +
> +	return -1;
> +}
> +EXPORT_SYMBOL(gen_pool_virt_to_phys);
>  
>  /**
>   * gen_pool_destroy - destroy a special memory pool
> -- 
> 1.7.4.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
