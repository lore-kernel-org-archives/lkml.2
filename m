Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0DAG3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 02:29:55 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53581 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab0DAG3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 02:29:46 -0400
Message-ID: <4BB43D58.5030801@cs.helsinki.fi>
Date: Thu, 01 Apr 2010 09:29:44 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: ShiYong LI <a22381@motorola.com>
CC: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mpm@selenic.com,
       linux-mm@kvack.org
Subject: Re: [PATCH] Fix missing of last user info while getting DEBUG_SLAB
 config 	enabled
References: <l2g4810ea571003312024jb883f2eet5b48a7fbb9ec340f@mail.gmail.com>
In-Reply-To: <l2g4810ea571003312024jb883f2eet5b48a7fbb9ec340f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ShiYong LI kirjoitti:
> Hi all,
>  
> For OMAP3430 chip, while getting DEBUG_SLAB config enabled, found a bug 
> that last user information is missed in slab corruption log dumped by 
> kernel. Actually, It's caused by ignorance of redzone and last user tag 
> while calling kmem_cache_create() function if cache alignment > 16 bytes 
> (unsigned long long). 
>  
> Here is a patch to fix this problem. Already verified it on kernel 2.6.29.

The patch is badly whitespace damaged.

>  From 26a5a8ad2a1d7612929a91f6866cea9d1bea6077 Mon Sep 17 00:00:00 2001
> From: Shiyong Li <shi-yong.li@motorola.com 
> <mailto:shi-yong.li@motorola.com>>
> Date: Wed, 31 Mar 2010 10:09:35 +0800
> Subject: [PATCH] Fix missing of last user info while getting DEBUG_SLAB 
> config enabled.
> As OMAP3 cache line is 64 byte long, while calling kmem_cache_create()
> funtion, some cases need 64 byte alignment of requested memory space.
> But, if cache line > 16 bytes, current kernel ignore redzone
> and last user debug head/trail tag to make sure this alignment is not
> broken.
> This fix removes codes that ignorance of redzone and last user tag.
> Instead, use "align" argument value as object offset to guarantee the
> alignment.
> Signed-off-by: Shiyong Li <shi-yong.li@motorola.com 
> <mailto:shi-yong.li@motorola.com>>
> ---
>  mm/slab.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> diff --git a/mm/slab.c b/mm/slab.c
> index a8a38ca..84af997 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2267,9 +2267,6 @@ kmem_cache_create (const char *name, size_t size, 
> size_t align,
>   if (ralign < align) {
>    ralign = align;
>   }
> - /* disable debug if necessary */
> - if (ralign > __alignof__(unsigned long long))
> -  flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
>   /*
>    * 4) Store it.
>    */
> @@ -2289,8 +2286,8 @@ kmem_cache_create (const char *name, size_t size, 
> size_t align,
>    */
>   if (flags & SLAB_RED_ZONE) {
>    /* add space for red zone words */
> -  cachep->obj_offset += sizeof(unsigned long long);
> -  size += 2 * sizeof(unsigned long long);
> +  cachep->obj_offset += align;
> +  size += align + sizeof(unsigned long long);
>   }

I don't understand what you're trying to do here. What if align is less 
han sizeof(unsigned long long)? What if SLAB_RED_ZONE is not enabled but 
  SLAB_STORE_USER is?

			Pekka
