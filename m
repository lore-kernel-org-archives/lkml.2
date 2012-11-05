Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2KEUFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:05:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54806 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2KEUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:05:08 -0500
Date: Mon, 5 Nov 2012 12:05:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: linux-kernel@vger.kernel.org, cl@linux.com
Subject: Re: [PATCH] dmapool : make DMAPOOL_DEBUG detect corruption of free
 marker
Message-Id: <20121105120506.88d46c88.akpm@linux-foundation.org>
In-Reply-To: <1352122805-30099-1-git-send-email-matthieu.castet@parrot.com>
References: <1352122805-30099-1-git-send-email-matthieu.castet@parrot.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Nov 2012 14:40:05 +0100
Matthieu CASTET <matthieu.castet@parrot.com> wrote:

> This can help to catch case where hardware is writting after dma free.
> 
> ...
>
> --- a/mm/dmapool.c
> +++ b/mm/dmapool.c
> @@ -346,6 +346,29 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
>  	retval = offset + page->vaddr;
>  	*handle = offset + page->dma;
>  #ifdef	DMAPOOL_DEBUG
> +	{
> +		int i;
> +		u8 *data = retval;
> +		/* page->offset is stored in first 4 bytes */
> +		for (i = sizeof(int); i < pool->size; i++) {
> +			if (data[i] != POOL_POISON_FREED) {
> +				if (pool->dev)
> +					dev_err(pool->dev,
> +							"dma_pool_alloc %s, %p (corruped)\n",
> +							pool->name, retval);
> +				else
> +					printk(KERN_ERR
> +							"dma_pool_alloc %s, %p (corruped)\n",
> +							pool->name, retval);
> +
> +				/* we dump the first 4 bytes even if there are not
> +				   POOL_POISON_FREED */
> +				print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET, 16, 1,
> +						data, pool->size, 1);
> +				break;
> +			}
> +		}
> +	}
>  	memset(retval, POOL_POISON_ALLOCATED, pool->size);
>  #endif

Seems reasonable.  I fidded wth a few things.

- The code is quite painful to look at in an 80-col display, and
  there's no real reason it has to be that way.

- The comment layout is strange, it misses capitalisation and needed
  a grammatical fix

- Use sizeof(page->offset), not sizeof(int).  Just in case someone
  changes the type of dma_page.offset.

- Use pr_err(), as suggested by checkpatch.  Please use checkpatch.

--- a/mm/dmapool.c~dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix
+++ a/mm/dmapool.c
@@ -350,23 +350,24 @@ void *dma_pool_alloc(struct dma_pool *po
 		int i;
 		u8 *data = retval;
 		/* page->offset is stored in first 4 bytes */
-		for (i = sizeof(int); i < pool->size; i++) {
-			if (data[i] != POOL_POISON_FREED) {
-				if (pool->dev)
-					dev_err(pool->dev,
-							"dma_pool_alloc %s, %p (corruped)\n",
-							pool->name, retval);
-				else
-					printk(KERN_ERR
-							"dma_pool_alloc %s, %p (corruped)\n",
-							pool->name, retval);
-
-				/* we dump the first 4 bytes even if there are not
-				   POOL_POISON_FREED */
-				print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET, 16, 1,
-						data, pool->size, 1);
-				break;
-			}
+		for (i = sizeof(page->offset); i < pool->size; i++) {
+			if (data[i] == POOL_POISON_FREED)
+				continue;
+			if (pool->dev)
+				dev_err(pool->dev,
+					"dma_pool_alloc %s, %p (corruped)\n",
+					pool->name, retval);
+			else
+				pr_err("dma_pool_alloc %s, %p (corruped)\n",
+					pool->name, retval);
+
+			/*
+			 * Dump the first 4 bytes even if they are not
+			 * POOL_POISON_FREED
+			*/
+			print_hex_dump(KERN_ERR, "", DUMP_PREFIX_OFFSET, 16, 1,
+					data, pool->size, 1);
+			break;
 		}
 	}
 	memset(retval, POOL_POISON_ALLOCATED, pool->size);
_

