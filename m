Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab0JQEur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 00:50:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56751 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab0JQEuq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 00:50:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jjh3t9BYeF6yv4EZhwXrU+SmsWF0WvKL5MilD86yCO38qWZwFzdZfXKFuhLVRxMNui
         hKxa9Wo5OdgmkmPP2978V4dAKJpurmotM4bNJ35SZTEP96ZePJmwpslZAAEeuD2OHxp4
         rgDqg4Wq3HDymzP3NCcQsdhIhlAgqYRdluyr4=
MIME-Version: 1.0
In-Reply-To: <20101016043331.GA3177@darkstar>
References: <20101016043331.GA3177@darkstar>
Date: Sun, 17 Oct 2010 13:50:45 +0900
Message-ID: <AANLkTik8Sn9Pr+C32Wd6-XgXu=21NQ56C8D+WqsqoK5j@mail.gmail.com>
Subject: Re: [PATCH 1/2] Add vzalloc shortcut
From: Minchan Kim <minchan.kim@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 1:33 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> Add vzalloc for convinience of vmalloc-then-memset-zero case
>
> Use __GFP_ZERO in vzalloc to zero fill the allocated memory.
Looks good to me.

There are many place we need this.
Although it affects meta pages for vmalloc as well as data pages, it's
not a big.
In this case, Maintaining code simple is better than little bit
performance overhead.

>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Isn't it useful in nommu, either?


> ---
>  include/linux/vmalloc.h |    1 +
>  mm/vmalloc.c            |   13 +++++++++++++
>  2 files changed, 14 insertions(+)
>
> --- linux-2.6.orig/include/linux/vmalloc.h      2010-08-22 15:31:38.000000000 +0800
> +++ linux-2.6/include/linux/vmalloc.h   2010-10-16 10:50:54.739996121 +0800
> @@ -53,6 +53,7 @@ static inline void vmalloc_init(void)
>  #endif
>
>  extern void *vmalloc(unsigned long size);
> +extern void *vzalloc(unsigned long size);
>  extern void *vmalloc_user(unsigned long size);
>  extern void *vmalloc_node(unsigned long size, int node);
>  extern void *vmalloc_exec(unsigned long size);
> --- linux-2.6.orig/mm/vmalloc.c 2010-08-22 15:31:39.000000000 +0800
> +++ linux-2.6/mm/vmalloc.c      2010-10-16 10:51:57.126665918 +0800
> @@ -1604,6 +1604,19 @@ void *vmalloc(unsigned long size)
>  EXPORT_SYMBOL(vmalloc);
>
>  /**
> + *     vzalloc  -  allocate virtually contiguous memory with zero filled
> + *     @size:          allocation size
> + *     Allocate enough pages to cover @size from the page level
> + *     allocator and map them into contiguous kernel virtual space.
> + */
> +void *vzalloc(unsigned long size)
> +{
> +       return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
> +                               PAGE_KERNEL, -1, __builtin_return_address(0));
> +}
> +EXPORT_SYMBOL(vzalloc);
> +
> +/**
>  * vmalloc_user - allocate zeroed virtually contiguous memory for userspace
>  * @size: allocation size
>  *
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
>



-- 
Kind regards,
Minchan Kim
