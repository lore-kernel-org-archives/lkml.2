Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab1ADUhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:37:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005Ab1ADUhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:37:47 -0500
Date: Tue, 4 Jan 2011 12:37:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Take lock only once in dma_pool_free()
Message-Id: <20110104123736.5ff6643e.akpm@linux-foundation.org>
In-Reply-To: <201012201803.06873.eike-kernel@sf-tec.de>
References: <201012201803.06873.eike-kernel@sf-tec.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Dec 2010 18:03:06 +0100
Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:

> >From 0db01c2ea9476609c399de3e9fdf7861df07d2f1 Mon Sep 17 00:00:00 2001
> From: Rolf Eike Beer <eike-kernel@sf-tec.de>
> Date: Mon, 20 Dec 2010 17:29:33 +0100
> Subject: [PATCH] Speed up dma_pool_free()
> 
> dma_pool_free() scans for the page to free in the pool list holding the pool
> lock. Then it releases the lock basically to acquire it immediately again.
> Modify the code to only take the lock once.
> 
> This will do some additional loops and computations with the lock held in if 
> memory debugging is activated. If it is not activated the only new operations 
> with this lock is one if and one substraction.
> 

Fair enough, I guess.

> 
> diff --git a/mm/dmapool.c b/mm/dmapool.c
> index 4df2de7..a2f6295 100644
> --- a/mm/dmapool.c
> +++ b/mm/dmapool.c
> @@ -355,20 +355,15 @@ EXPORT_SYMBOL(dma_pool_alloc);
>  
>  static struct dma_page *pool_find_page(struct dma_pool *pool, dma_addr_t dma)
>  {
> -	unsigned long flags;
>  	struct dma_page *page;
>  
> -	spin_lock_irqsave(&pool->lock, flags);
>  	list_for_each_entry(page, &pool->page_list, page_list) {
>  		if (dma < page->dma)
>  			continue;
>  		if (dma < (page->dma + pool->allocation))
> -			goto done;
> +			return page;
>  	}
> -	page = NULL;
> - done:
> -	spin_unlock_irqrestore(&pool->lock, flags);
> -	return page;
> +	return NULL;
>  }
>  
>  /**
> @@ -386,8 +381,10 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, 
> dma_addr_t dma)

You have some wordwrapping there.

>  	unsigned long flags;
>  	unsigned int offset;
>  
> +	spin_lock_irqsave(&pool->lock, flags);
>  	page = pool_find_page(pool, dma);
>  	if (!page) {
> +		spin_unlock_irqrestore(&pool->lock, flags);
>  		if (pool->dev)
>  			dev_err(pool->dev,
>  				"dma_pool_free %s, %p/%lx (bad dma)\n",
> @@ -401,6 +398,7 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, 
> dma_addr_t dma)
>  	offset = vaddr - page->vaddr;
>  #ifdef	DMAPOOL_DEBUG
>  	if ((dma - page->dma) != offset) {
> +		spin_unlock_irqrestore(&pool->lock, flags);
>  		if (pool->dev)
>  			dev_err(pool->dev,
>  				"dma_pool_free %s, %p (bad vaddr)/%Lx\n",
> @@ -418,6 +416,7 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, 
> dma_addr_t dma)
>  				chain = *(int *)(page->vaddr + chain);
>  				continue;
>  			}
> +			spin_unlock_irqrestore(&pool->lock, flags);
>  			if (pool->dev)
>  				dev_err(pool->dev, "dma_pool_free %s, dma %Lx "
>  					"already free\n", pool->name,
> @@ -432,7 +431,6 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, 
> dma_addr_t dma)
>  	memset(vaddr, POOL_POISON_FREED, pool->size);
>  #endif
>  
> -	spin_lock_irqsave(&pool->lock, flags);
>  	page->in_use--;
>  	*(int *)vaddr = page->offset;
>  	page->offset = offset;

It's a bit scary that the code is playing with the dma_page outside the
lock, but I guess the refcounting takes care of that.  As does the
apparently-intentional leakiness of leaving a cache of pages around.

The use of TASK_INTERRUPTIBLE in dma_pool_alloc() looks like a bug -
the code will busywait if signal_pending().

--- a/mm/dmapool.c~a
+++ a/mm/dmapool.c
@@ -324,7 +324,7 @@ void *dma_pool_alloc(struct dma_pool *po
 		if (mem_flags & __GFP_WAIT) {
 			DECLARE_WAITQUEUE(wait, current);
 
-			__set_current_state(TASK_INTERRUPTIBLE);
+			__set_current_state(TASK_UNINTERRUPTIBLE);
 			__add_wait_queue(&pool->waitq, &wait);
 			spin_unlock_irqrestore(&pool->lock, flags);
 
_


