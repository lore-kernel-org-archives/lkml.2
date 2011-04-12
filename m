Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab1DLWie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 18:38:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492Ab1DLWid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 18:38:33 -0400
Date: Tue, 12 Apr 2011 15:37:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] genalloc: add support to specify the physical
 address
Message-Id: <20110412153758.c570b09a.akpm@linux-foundation.org>
In-Reply-To: <1302192197-2248-2-git-send-email-plagnioj@jcrosoft.com>
References: <1302192197-2248-1-git-send-email-plagnioj@jcrosoft.com>
	<1302192197-2248-2-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Apr 2011 18:03:17 +0200
Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> wrote:

> so we specify the virtual address as base of the pool chunk and then
> get the physical address for hardware IP
> 
> as example on at91 we will use on spi, uart or macb
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> ---
>  include/linux/genalloc.h |   20 +++++++++++++++++++-
>  lib/genalloc.c           |   39 ++++++++++++++++++++++++++++++++-------
>  2 files changed, 51 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
> index b1c70f1..b44625b 100644
> --- a/include/linux/genalloc.h
> +++ b/include/linux/genalloc.h
> @@ -26,13 +26,31 @@ struct gen_pool {
>  struct gen_pool_chunk {
>  	spinlock_t lock;
>  	struct list_head next_chunk;	/* next chunk in pool */
> +	unsigned long phys_addr;	/* physical starting address of memory chunk */
>  	unsigned long start_addr;	/* starting address of memory chunk */
>  	unsigned long end_addr;		/* ending address of memory chunk */
>  	unsigned long bits[0];		/* bitmap for allocating memory chunk */
>  };
>  
>  extern struct gen_pool *gen_pool_create(int, int);
> -extern int gen_pool_add(struct gen_pool *, unsigned long, size_t, int);
> +extern unsigned long gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long);
> +extern int gen_pool_add_virt(struct gen_pool *, unsigned long, unsigned long,
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
> + */

We should document return values.

> +static inline int gen_pool_add(struct gen_pool *pool, unsigned long addr,
> +			       size_t size, int nid)
> +{
> +	return gen_pool_add_virt(pool, addr, 0, size, nid);
> +}
>  extern void gen_pool_destroy(struct gen_pool *);
>  extern unsigned long gen_pool_alloc(struct gen_pool *, size_t);
>  extern void gen_pool_free(struct gen_pool *, unsigned long, size_t);
> diff --git a/lib/genalloc.c b/lib/genalloc.c
> index 1923f14..83b069b 100644
> --- a/lib/genalloc.c
> +++ b/lib/genalloc.c
> @@ -39,17 +39,18 @@ struct gen_pool *gen_pool_create(int min_alloc_order, int nid)
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
>   */

Ditto.

> -int gen_pool_add(struct gen_pool *pool, unsigned long addr, size_t size,
> -		 int nid)
> +int gen_pool_add_virt(struct gen_pool *pool, unsigned long virt, unsigned long phys,
> +		 size_t size, int nid)
>  {
>  	struct gen_pool_chunk *chunk;
>  	int nbits = size >> pool->min_alloc_order;
> @@ -61,8 +62,9 @@ int gen_pool_add(struct gen_pool *pool, unsigned long addr, size_t size,
>  		return -1;
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
> @@ -70,7 +72,30 @@ int gen_pool_add(struct gen_pool *pool, unsigned long addr, size_t size,
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
> + */

And ditto.

But this documentation is incorrect.  @addr is not "the starting
address of memory".

> +unsigned long gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long addr)
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

It is in fact "some address within one of the chunks".


> +	}
> +	read_unlock(&pool->lock);
> +
> +	return ~0UL;
> +}
> +EXPORT_SYMBOL(gen_pool_virt_to_phys);

Was that intentional?  If so, what is the reasoning?


Please review...

Subject: lib/genpool.c: document return values, fix gen_pool_add_virt() return value
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Jes Sorensen <jes@wildopensource.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Patrice VILCHEZ <patrice.vilchez@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |    2 ++
 lib/genalloc.c           |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/genalloc.h~lib-genpoolc-document-return-values-fix-gen_pool_add_virt-return-value include/linux/genalloc.h
--- a/include/linux/genalloc.h~lib-genpoolc-document-return-values-fix-gen_pool_add_virt-return-value
+++ a/include/linux/genalloc.h
@@ -45,6 +45,8 @@ extern int gen_pool_add_virt(struct gen_
  *       allocated on, or -1
  *
  * Add a new chunk of special memory to the specified pool.
+ *
+ * Returns 0 on success or a -ve errno on failure.
  */
 static inline int gen_pool_add(struct gen_pool *pool, unsigned long addr,
 			       size_t size, int nid)
diff -puN lib/genalloc.c~lib-genpoolc-document-return-values-fix-gen_pool_add_virt-return-value lib/genalloc.c
--- a/lib/genalloc.c~lib-genpoolc-document-return-values-fix-gen_pool_add_virt-return-value
+++ a/lib/genalloc.c
@@ -48,6 +48,8 @@ EXPORT_SYMBOL(gen_pool_create);
  *       allocated on, or -1
  *
  * Add a new chunk of special memory to the specified pool.
+ *
+ * Returns 0 on success or a -ve errno on failure.
  */
 int gen_pool_add_virt(struct gen_pool *pool, unsigned long virt, unsigned long phys,
 		 size_t size, int nid)
@@ -59,7 +61,7 @@ int gen_pool_add_virt(struct gen_pool *p
 
 	chunk = kmalloc_node(nbytes, GFP_KERNEL | __GFP_ZERO, nid);
 	if (unlikely(chunk == NULL))
-		return -1;
+		return -ENOMEM;
 
 	spin_lock_init(&chunk->lock);
 	chunk->phys_addr = phys;
@@ -78,6 +80,8 @@ EXPORT_SYMBOL(gen_pool_add_virt);
  * gen_pool_virt_to_phys - return the physical address of memory
  * @pool: pool to allocate from
  * @addr: starting address of memory
+ *
+ * Returns the physical address on success, or ~0UL on error.
  */
 unsigned long gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long addr)
 {
_

