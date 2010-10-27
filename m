Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab0J0UVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 16:21:12 -0400
Received: from claw.goop.org ([74.207.240.146]:35079 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593Ab0J0UVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 16:21:11 -0400
Message-ID: <4CC889AF.1020402@goop.org>
Date: Wed, 27 Oct 2010 13:21:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: early_node_mem()'s memory allocation policy
References: <4CC753AD.1090403@goop.org> <4CC7BD6D.2030104@kernel.org>
In-Reply-To: <4CC7BD6D.2030104@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/26/2010 10:49 PM, Yinghai Lu wrote:
> please check
>
> [PATCH] x86, memblock: Fix early_node_mem with big reserved region.
>
> Jeremy said Xen could reserve huge mem but still show as ram in e820.
>
> early_node_mem could not find range because of start/end adjusting.
>
> Let's use memblock_find_in_range instead ***_node. So get real top down in fallback path.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>

Yes, that works.  Could you queue it for upstream?  Without this we see
Xen crashes with certain memory configurations.

Thanks,
    J

> diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
> index 60f4985..7ffc9b7 100644
> --- a/arch/x86/mm/numa_64.c
> +++ b/arch/x86/mm/numa_64.c
> @@ -178,11 +178,8 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
>  
>  	/* extend the search scope */
>  	end = max_pfn_mapped << PAGE_SHIFT;
> -	if (end > (MAX_DMA32_PFN<<PAGE_SHIFT))
> -		start = MAX_DMA32_PFN<<PAGE_SHIFT;
> -	else
> -		start = MAX_DMA_PFN<<PAGE_SHIFT;
> -	mem = memblock_x86_find_in_range_node(nodeid, start, end, size, align);
> +	start = MAX_DMA_PFN << PAGE_SHIFT;
> +	mem = memblock_find_in_range(start, end, size, align);
>  	if (mem != MEMBLOCK_ERROR)
>  		return __va(mem);
>  
>

