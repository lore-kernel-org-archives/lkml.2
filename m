Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab0I1VdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:33:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164Ab0I1VdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:33:13 -0400
Date: Tue, 28 Sep 2010 14:32:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: cleanup gfp_zone()
Message-Id: <20100928143239.5fe34e1e.akpm@linux-foundation.org>
In-Reply-To: <1285676624-1300-1-git-send-email-namhyung@gmail.com>
References: <1285676624-1300-1-git-send-email-namhyung@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 21:23:44 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> Use Z[TB]_SHIFT() macro to calculate GFP_ZONE_TABLE and GFP_ZONE_BAD.
> This also removes lots of warnings from sparse like following:
> 
>  warning: restricted gfp_t degrades to integer
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  include/linux/gfp.h |   43 ++++++++++++++++++++++++-------------------
>  1 files changed, 24 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 975609c..cebfee1 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -185,15 +185,16 @@ static inline int allocflags_to_migratetype(gfp_t gfp_flags)
>  #error ZONES_SHIFT too large to create GFP_ZONE_TABLE integer
>  #endif
>  
> +#define ZT_SHIFT(gfp) ((__force int) (gfp) * ZONES_SHIFT)
>  #define GFP_ZONE_TABLE ( \
> -	(ZONE_NORMAL << 0 * ZONES_SHIFT)				\
> -	| (OPT_ZONE_DMA << __GFP_DMA * ZONES_SHIFT)			\
> -	| (OPT_ZONE_HIGHMEM << __GFP_HIGHMEM * ZONES_SHIFT)		\
> -	| (OPT_ZONE_DMA32 << __GFP_DMA32 * ZONES_SHIFT)			\
> -	| (ZONE_NORMAL << __GFP_MOVABLE * ZONES_SHIFT)			\
> -	| (OPT_ZONE_DMA << (__GFP_MOVABLE | __GFP_DMA) * ZONES_SHIFT)	\
> -	| (ZONE_MOVABLE << (__GFP_MOVABLE | __GFP_HIGHMEM) * ZONES_SHIFT)\
> -	| (OPT_ZONE_DMA32 << (__GFP_MOVABLE | __GFP_DMA32) * ZONES_SHIFT)\
> +	(ZONE_NORMAL        << ZT_SHIFT(0))				\
> +	| (OPT_ZONE_DMA     << ZT_SHIFT(__GFP_DMA))			\
> +	| (OPT_ZONE_HIGHMEM << ZT_SHIFT(__GFP_HIGHMEM))			\
> +	| (OPT_ZONE_DMA32   << ZT_SHIFT(__GFP_DMA32))			\
> +	| (ZONE_NORMAL      << ZT_SHIFT(__GFP_MOVABLE))			\
> +	| (OPT_ZONE_DMA     << ZT_SHIFT(__GFP_MOVABLE | __GFP_DMA))	\
> +	| (ZONE_MOVABLE     << ZT_SHIFT(__GFP_MOVABLE | __GFP_HIGHMEM)) \
> +	| (OPT_ZONE_DMA32   << ZT_SHIFT(__GFP_MOVABLE | __GFP_DMA32))	\
>  )

hm.  I hope these sparse warnings are sufficiently useful to justify
all the gunk we're adding to support them.

Is it actually finding any bugs?
