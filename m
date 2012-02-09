Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab2BIWrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:47:08 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27180 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758570Ab2BIWrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:47:06 -0500
Date: Thu, 9 Feb 2012 23:47:42 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Xi Wang <xi.wang@gmail.com>
cc: Jens Axboe <axboe@kernel.dk>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
In-Reply-To: <4F33CEAE.60400@gmail.com>
Message-ID: <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net>
References: <20120207141155.GA16184@elgon.mountain> <4F323388.7040902@kernel.dk> <20120208142513.4db2493a.akpm@linux-foundation.org> <4F33BF05.208@gmail.com> <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <4F33C7D7.1060801@kernel.dk>
 <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Feb 2012, Xi Wang wrote:

> This patch introduces a kmalloc_array() wrapper that performs integer
> overflow checking without zeroing the memory.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> ---
> Let's take "kxnalloc" off for now and keep the patch simple.
> ---
>  include/linux/slab.h |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 573c809..a595dce 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -190,7 +190,7 @@ size_t ksize(const void *);
>  #endif
>  
>  /**
> - * kcalloc - allocate memory for an array. The memory is set to zero.
> + * kmalloc_array - allocate memory for an array.
>   * @n: number of elements.
>   * @size: element size.
>   * @flags: the type of memory to allocate.
> @@ -240,11 +240,22 @@ size_t ksize(const void *);
>   * for general use, and so are not documented here. For a full list of
>   * potential flags, always refer to linux/gfp.h.
>   */
> -static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
> +static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
>  {
>  	if (size != 0 && n > ULONG_MAX / size)
>  		return NULL;
> -	return __kmalloc(n * size, flags | __GFP_ZERO);
> +	return __kmalloc(n * size, flags);
> +}
> +
> +/**
> + * kcalloc - allocate memory for an array. The memory is set to zero.
> + * @n: number of elements.
> + * @size: element size.
> + * @flags: the type of memory to allocate (see kmalloc).
> + */
> +static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
> +{
> +	return kmalloc_array(n, size, flags | __GFP_ZERO);
>  }
>  
>  #if !defined(CONFIG_NUMA) && !defined(CONFIG_SLOB)
> 

Does this want adding to Documentation/CodingStyle "Chapter 14: Allocating 
memory" ?

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

