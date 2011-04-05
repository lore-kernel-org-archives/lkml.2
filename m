Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab1DERzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:55:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65175 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab1DERzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:55:15 -0400
Message-ID: <4D9B5765.2060106@kernel.org>
Date: Tue, 05 Apr 2011 10:54:45 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] x86-32, NUMA: Make @size in init_aloc_remap() represent
 bytes
References: <1301955840-7246-1-git-send-email-tj@kernel.org> <1301955840-7246-7-git-send-email-tj@kernel.org>
In-Reply-To: <1301955840-7246-7-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D9B5771.0147,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2011 03:23 PM, Tejun Heo wrote:
> @size variable in init_alloc_remap() is confusing in that it starts as
> number of bytes as its name implies and then becomes number of pages.
> Make it consistently represent bytes.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Yinghai Lu<yinghai@kernel.org>
> Cc: David Rientjes<rientjes@google.com>
> Cc: Thomas Gleixner<tglx@linutronix.de
> Cc: Ingo Molnar<mingo@redhat.com>
> Cc: "H. Peter Anvin"<hpa@zytor.com>
> ---
>   arch/x86/mm/numa_32.c |   18 +++++++-----------
>   1 files changed, 7 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
> index 30933fe..99310d2 100644
> --- a/arch/x86/mm/numa_32.c
> +++ b/arch/x86/mm/numa_32.c
> @@ -286,22 +286,19 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
>   	size = node_remap_size[nid];
>   	size += ALIGN(sizeof(pg_data_t), PAGE_SIZE);
>
> -	/* convert size to large (pmd size) pages, rounding up */
> -	size = (size + LARGE_PAGE_BYTES - 1) / LARGE_PAGE_BYTES;
> -	/* now the roundup is correct, convert to PAGE_SIZE pages */
> -	size = size * PTRS_PER_PTE;
> +	/* align to large page */
> +	size = ALIGN(size, LARGE_PAGE_BYTES);
>
>   	node_pa = memblock_find_in_range(node_start_pfn[nid]<<  PAGE_SHIFT,
>   					 (u64)node_end_pfn[nid]<<  PAGE_SHIFT,
> -					 (u64)size<<  PAGE_SHIFT,
> -					 LARGE_PAGE_BYTES);
> +					 size, LARGE_PAGE_BYTES);
>   	if (node_pa == MEMBLOCK_ERROR)
>   		panic("Can not get kva ram\n");
>
> -	node_remap_size[nid] = size;
> +	node_remap_size[nid] = size>>  PAGE_SHIFT;
>   	node_remap_offset[nid] = offset;
>   	printk(KERN_DEBUG "Reserving %ld pages of KVA for lmem_map of node %d at %llx\n",
> -	       size, nid, node_pa>>  PAGE_SHIFT);
> +	       size>>  PAGE_SHIFT, nid, node_pa>>  PAGE_SHIFT);
>
>   	/*
>   	 *  prevent kva address below max_low_pfn want it on system
> @@ -315,12 +312,11 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
>   	 *  So memblock_x86_reserve_range here, hope we don't run out
>   	 *  of that array
>   	 */
> -	memblock_x86_reserve_range(node_pa, node_pa + ((u64)size<<  PAGE_SHIFT),
> -				   "KVA RAM");
> +	memblock_x86_reserve_range(node_pa, node_pa + size, "KVA RAM");
>
>   	node_remap_start_pfn[nid] = node_pa>>  PAGE_SHIFT;
>
> -	return size;
> +	return size>>  PAGE_SHIFT;
>   }
>
>   static void init_remap_allocator(int nid)

Acked-by: Yinghai Lu <yinghai@kernel.org>
