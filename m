Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab2FRWFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 18:05:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42585 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2FRWFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 18:05:24 -0400
Date: Mon, 18 Jun 2012 15:05:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] memblock: Make sure reserved.regions is freed really
Message-ID: <20120618220519.GD32733@google.com>
References: <1339816331-23284-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339816331-23284-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Yinghai.

On Fri, Jun 15, 2012 at 08:12:11PM -0700, Yinghai Lu wrote:
> memblock_free() would double reserved.regions too, so we could free
> old range for reserved.regions.
> 
> So need to check that regions get doubled. If it is doubled, we need to
> free it.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  mm/memblock.c |   23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/mm/memblock.c
> ===================================================================
> --- linux-2.6.orig/mm/memblock.c
> +++ linux-2.6/mm/memblock.c
> @@ -148,11 +148,26 @@ phys_addr_t __init_memblock memblock_fin
>   */
>  int __init_memblock memblock_free_reserved_regions(void)
>  {
> +	struct memblock_region *r;
> +	int ret;
> +
>  	if (memblock.reserved.regions == memblock_reserved_init_regions)
>  		return 0;
>  
> -	return memblock_free(__pa(memblock.reserved.regions),
> -		 sizeof(struct memblock_region) * memblock.reserved.max);
> +	/*
> +	 * During memblock_free, reserved.regions could be doubled,
> +	 * try to check with old one for checking, and need to free the new one.
> +	 */
> +	do {
> +		r = memblock.reserved.regions;
> +		ret = memblock_free(__pa(memblock.reserved.regions),
> +			sizeof(struct memblock_region) * memblock.reserved.max);
> +
> +		if (ret)
> +			break;
> +	} while (memblock.reserved.regions != r);
> +
> +	return ret;
>  }

Hmmm... nice catch but I think it's a bit complex and ugly.  In this
case, we *know* that the region isn't gonna be split.  Maybe a better
option is to add something like the following?

void memblock_remove_region_by_ptr(struct memblock_type *type,
				   struct memblock_region *r)
{
	WARN_ON(/* make sure @r is inside @type->regions */);
	memblock_remove_region(type, r - type->regions);
}

Thanks.

-- 
tejun
