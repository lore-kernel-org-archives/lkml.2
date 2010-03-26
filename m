Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab0CZUeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 16:34:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:46478 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab0CZUeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 16:34:11 -0400
Message-ID: <4BAD1A09.7030702@kernel.org>
Date: Fri, 26 Mar 2010 13:33:13 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix allocation done in get_free_all_memory_range()
References: <4BACF1CB020000780003737A@vpn.id2.novell.com>
In-Reply-To: <4BACF1CB020000780003737A@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2010 09:41 AM, Jan Beulich wrote:
> Even when get_max_mapped() returns a value beyond the DMA32 range,
> this can't be taken to mean an alocation from that range will succeed.
> Hence, the code should still fall back to an allocation starting at
> the bottom of memory if the first one failed.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  kernel/early_res.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> --- linux-2.6.34-rc2/kernel/early_res.c	2010-03-25 15:23:45.000000000 +0100
> +++ 2.6.34-rc2-get_free_all_memory_range-retry-alloc/kernel/early_res.c	2010-03-26 14:49:41.000000000 +0100
> @@ -387,9 +387,7 @@ static void __init subtract_early_res(st
>  int __init get_free_all_memory_range(struct range **rangep, int nodeid)
>  {
>  	int i, count;
> -	u64 start = 0, end;
> -	u64 size;
> -	u64 mem;
> +	u64 end, size, mem = -1ULL;
>  	struct range *range;
>  	int nr_range;
>  
> @@ -403,9 +401,11 @@ int __init get_free_all_memory_range(str
>  	end = get_max_mapped();
>  #ifdef MAX_DMA32_PFN
>  	if (end > (MAX_DMA32_PFN << PAGE_SHIFT))
> -		start = MAX_DMA32_PFN << PAGE_SHIFT;
> +		mem = find_fw_memmap_area(MAX_DMA32_PFN << PAGE_SHIFT, end,
> +					  size, sizeof(struct range));
>  #endif
> -	mem = find_fw_memmap_area(start, end, size, sizeof(struct range));
> +	if (mem == -1ULL)
> +		mem = find_fw_memmap_area(0, end, size, sizeof(struct range));
>  	if (mem == -1ULL)
>  		panic("can not find more space for range free");

Acked-by: Yinghai Lu <yinghai@kernel.org>

Thanks for catching it.

Yinghai
