Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab0DNR4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 13:56:41 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34000 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab0DNR40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 13:56:26 -0400
Message-ID: <4BC601C5.5050404@cs.helsinki.fi>
Date: Wed, 14 Apr 2010 20:56:21 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: ShiYong LI <a22381@motorola.com>
CC: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mpm@selenic.com,
       linux-mm@kvack.org, dwmw2@infradead.org, TAO HU <taohu@motorola.com>
Subject: Re: [PATCH - V2] Fix missing of last user while dumping slab corruption
 	log
References: <w2z4810ea571004112250x855fadd5uecbc813726ae3412@mail.gmail.com>
In-Reply-To: <w2z4810ea571004112250x855fadd5uecbc813726ae3412@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ShiYong LI wrote:
> Hi,
> 
> Compared to previous version, add alignment checking to make sure
> memory space storing redzone2 and last user tags is 8 byte alignment.
> 
> From 949e8c29e8681a2359e23a8fbd8b9d4833f42344 Mon Sep 17 00:00:00 2001
> From: Shiyong Li <shi-yong.li@motorola.com>
> Date: Mon, 12 Apr 2010 13:48:21 +0800
> Subject: [PATCH] Fix missing of last user info while getting
> DEBUG_SLAB config enabled.
> 
> Even with SLAB_RED_ZONE and SLAB_STORE_USER enabled, kernel would NOT
> store redzone and last user data around allocated memory space if arch
> cache line > sizeof(unsigned long long). As a result, last user information
> is unexpectedly MISSED while dumping slab corruption log.
> 
> This fix makes sure that redzone and last user tags get stored unless
> the required alignment breaks redzone's.
> 
> Signed-off-by: Shiyong Li <shi-yong.li@motorola.com>

OK, I added this to linux-next for testing. Thanks!

> ---
>  mm/slab.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index a8a38ca..b97c57e 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2267,8 +2267,8 @@ kmem_cache_create (const char *name, size_t
> size, size_t align,
>  	if (ralign < align) {
>  		ralign = align;
>  	}
> -	/* disable debug if necessary */
> -	if (ralign > __alignof__(unsigned long long))
> +	/* disable debug if not aligning with REDZONE_ALIGN */
> +	if (ralign & (__alignof__(unsigned long long) - 1))
>  		flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
>  	/*
>  	 * 4) Store it.
> @@ -2289,8 +2289,8 @@ kmem_cache_create (const char *name, size_t
> size, size_t align,
>  	 */
>  	if (flags & SLAB_RED_ZONE) {
>  		/* add space for red zone words */
> -		cachep->obj_offset += sizeof(unsigned long long);
> -		size += 2 * sizeof(unsigned long long);
> +		cachep->obj_offset += align;
> +		size += align + sizeof(unsigned long long);
>  	}
>  	if (flags & SLAB_STORE_USER) {
>  		/* user store requires one word storage behind the end of

