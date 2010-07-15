Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933902Ab0GORVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 13:21:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61081 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933892Ab0GORVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 13:21:48 -0400
Message-ID: <4C3F4286.3070503@kernel.org>
Date: Thu, 15 Jul 2010 10:16:54 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        "H. Peter Anvin" <hpa@zytor.com>, stable <stable@kernel.org>
Subject: Re: [PATCH] kmemleak: Add support for NO_BOOTMEM configurations
References: <20100715145834.20885.20341.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20100715145834.20885.20341.stgit@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C3F437C.00D0,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

should be for 2.6.34 and 2.6.35.

Thanks

Yinghai

On 07/15/2010 07:58 AM, Catalin Marinas wrote:
> With commits 08677214 and 59be5a8e, alloc_bootmem()/free_bootmem() and
> friends use the early_res functions for memory management when
> NO_BOOTMEM is enabled. This patch adds the kmemleak calls in the
> corresponding code paths for bootmem allocations.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  kernel/early_res.c |    6 ++++++
>  mm/page_alloc.c    |    5 +++++
>  2 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/early_res.c b/kernel/early_res.c
> index 31aa933..7bfae88 100644
> --- a/kernel/early_res.c
> +++ b/kernel/early_res.c
> @@ -7,6 +7,8 @@
>  #include <linux/bootmem.h>
>  #include <linux/mm.h>
>  #include <linux/early_res.h>
> +#include <linux/slab.h>
> +#include <linux/kmemleak.h>
>  
>  /*
>   * Early reserved memory areas.
> @@ -319,6 +321,8 @@ void __init free_early(u64 start, u64 end)
>  	struct early_res *r;
>  	int i;
>  
> +	kmemleak_free_part(__va(start), end - start);
> +
>  	i = find_overlapped_early(start, end);
>  	r = &early_res[i];
>  	if (i >= max_early_res || r->end != end || r->start != start)
> @@ -333,6 +337,8 @@ void __init free_early_partial(u64 start, u64 end)
>  	struct early_res *r;
>  	int i;
>  
> +	kmemleak_free_part(__va(start), end - start);
> +
>  	if (start == end)
>  		return;
>  
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 431214b..68319dd 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3659,6 +3659,11 @@ void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
>  		ptr = phys_to_virt(addr);
>  		memset(ptr, 0, size);
>  		reserve_early_without_check(addr, addr + size, "BOOTMEM");
> +		/*
> +		 * The min_count is set to 0 so that bootmem allocated blocks
> +		 * are never reported as leaks.
> +		 */
> +		kmemleak_alloc(ptr, size, 0, 0);
>  		return ptr;
>  	}
>  

