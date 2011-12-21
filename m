Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab1LUFbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 00:31:24 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57413 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750698Ab1LUFbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 00:31:22 -0500
Message-ID: <1324445481.20505.7.camel@joe2Laptop>
Subject: Re: [PATCH] vmalloc: remove #ifdef in function body
From: Joe Perches <joe@perches.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 20 Dec 2011 21:31:21 -0800
In-Reply-To: <1324444679-9247-1-git-send-email-minchan@kernel.org>
References: <1324444679-9247-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 14:17 +0900, Minchan Kim wrote:
> We don't like function body which include #ifdef.
[]
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
[]
> @@ -505,6 +505,7 @@ static void unmap_vmap_area(struct vmap_area *va)
>  	vunmap_page_range(va->va_start, va->va_end);
>  }
>  
> +#ifdef CONFIG_DEBUG_PAGEALLOC
>  static void vmap_debug_free_range(unsigned long start, unsigned long end)
>  {
>  	/*
> @@ -520,11 +521,15 @@ static void vmap_debug_free_range(unsigned long start, unsigned long end)
>  	 * debugging doesn't do a broadcast TLB flush so it is a lot
>  	 * faster).
>  	 */
> -#ifdef CONFIG_DEBUG_PAGEALLOC
>  	vunmap_page_range(start, end);
>  	flush_tlb_kernel_range(start, end);
> -#endif
>  }
> +#else
> +static inline void vmap_debug_free_range(unsigned long start,
> +					unsigned long end)
> +{
> +}
> +#endif

I don't like this change.
I think it's perfectly good style to use:

1	void foo(args...)
2	{
3	#ifdef CONFIG_FOO
4		...
5	#endif
6	}

instead of

1	#ifdef CONFIG_FOO
2	void foo(args...)
3	{
4		...
5	}
6	#else
7	void foo(args...)
8	{
9	}
10	#endif

The first version is shorter and gcc optimizes
away the void func just fine.  It also means
that 2 function prototypes don't need to be
kept in agreement when someone changes one
without testing CONFIG_FOO=y and CONFIG_FOO=n.


