Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab2JRWqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:46:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62936 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432Ab2JRWqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:46:54 -0400
Date: Thu, 18 Oct 2012 15:46:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ezequiel Garcia <elezegarcia@gmail.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tim Bird <tim.bird@am.sony.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 1/3] mm/slob: Drop usage of page->private for storing
 page-sized allocations
In-Reply-To: <1350600107-4558-1-git-send-email-elezegarcia@gmail.com>
Message-ID: <alpine.DEB.2.00.1210181544590.1439@chino.kir.corp.google.com>
References: <1350600107-4558-1-git-send-email-elezegarcia@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Ezequiel Garcia wrote:

> This field was being used to store size allocation so it could be
> retrieved by ksize(). However, it is a bad practice to not mark a page
> as a slab page and then use fields for special purposes.
> There is no need to store the allocated size and
> ksize() can simply return PAGE_SIZE << compound_order(page).
> 
> Cc: Pekka Penberg <penberg@kernel.org>

Is Pekka Penberg the long distant cousin of Pekka Enberg? :)  You should 
probably cc the author of slob, Matt Mackall <mpm@selenic.com>, on slob 
patches.

> Acked-by: Christoph Lameter <cl@linux.com>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
>  mm/slob.c |   24 ++++++++++--------------
>  1 files changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/slob.c b/mm/slob.c
> index a08e468..06a5ec7 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -28,9 +28,8 @@
>   * from kmalloc are prepended with a 4-byte header with the kmalloc size.
>   * If kmalloc is asked for objects of PAGE_SIZE or larger, it calls
>   * alloc_pages() directly, allocating compound pages so the page order
> - * does not have to be separately tracked, and also stores the exact
> - * allocation size in page->private so that it can be used to accurately
> - * provide ksize(). These objects are detected in kfree() because slob_page()
> + * does not have to be separately tracked.
> + * These objects are detected in kfree() because PageSlab()
>   * is false for them.
>   *
>   * SLAB is emulated on top of SLOB by simply calling constructors and
> @@ -455,11 +454,6 @@ __do_kmalloc_node(size_t size, gfp_t gfp, int node, unsigned long caller)
>  		if (likely(order))
>  			gfp |= __GFP_COMP;
>  		ret = slob_new_pages(gfp, order, node);
> -		if (ret) {
> -			struct page *page;
> -			page = virt_to_page(ret);
> -			page->private = size;
> -		}
>  
>  		trace_kmalloc_node(caller, ret,
>  				   size, PAGE_SIZE << order, gfp, node);
> @@ -514,18 +508,20 @@ EXPORT_SYMBOL(kfree);
>  size_t ksize(const void *block)
>  {
>  	struct page *sp;
> +	int align;
> +	unsigned int *m;
>  
>  	BUG_ON(!block);
>  	if (unlikely(block == ZERO_SIZE_PTR))
>  		return 0;
>  
>  	sp = virt_to_page(block);
> -	if (PageSlab(sp)) {
> -		int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
> -		unsigned int *m = (unsigned int *)(block - align);
> -		return SLOB_UNITS(*m) * SLOB_UNIT;
> -	} else
> -		return sp->private;
> +	if (unlikely(!PageSlab(sp)))
> +		return PAGE_SIZE << compound_order(sp);
> +
> +	align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
> +	m = (unsigned int *)(block - align);
> +	return SLOB_UNITS(*m) * SLOB_UNIT;
>  }
>  EXPORT_SYMBOL(ksize);
>  
