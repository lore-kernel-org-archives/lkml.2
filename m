Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab1DERoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:44:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45687 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab1DERog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:44:36 -0400
Message-ID: <4D9B54EB.5030503@kernel.org>
Date: Tue, 05 Apr 2011 10:44:11 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/14] x86-32, NUMA: Rename @node_kva to @node_pa in init_alloc_remap()
References: <1301955840-7246-1-git-send-email-tj@kernel.org> <1301955840-7246-6-git-send-email-tj@kernel.org>
In-Reply-To: <1301955840-7246-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D9B54F5.00AF,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2011 03:23 PM, Tejun Heo wrote:
> init_alloc_remap() is about to do more and using _kva suffix for
> physical address becomes confusing because the function will be
> handling both physical and virtual addresses.  Rename @node_kva to
> @node_pa.
>
> This is trivial rename and doesn't cause any behavior difference.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> ---
>   arch/x86/mm/numa_32.c |   19 +++++++++----------
>   1 files changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
> index 5039e9b..30933fe 100644
> --- a/arch/x86/mm/numa_32.c
> +++ b/arch/x86/mm/numa_32.c
> @@ -267,7 +267,7 @@ void resume_map_numa_kva(pgd_t *pgd_base)
>   static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
>   {
>   	unsigned long size;
> -	u64 node_kva;
> +	u64 node_pa;
>
>   	/*
>   	 * The acpi/srat node info can show hot-add memroy zones where
> @@ -291,17 +291,17 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
>   	/* now the roundup is correct, convert to PAGE_SIZE pages */
>   	size = size * PTRS_PER_PTE;
>
> -	node_kva = memblock_find_in_range(node_start_pfn[nid]<<  PAGE_SHIFT,
> -					  (u64)node_end_pfn[nid]<<  PAGE_SHIFT,
> -					  (u64)size<<  PAGE_SHIFT,
> -					  LARGE_PAGE_BYTES);
> -	if (node_kva == MEMBLOCK_ERROR)
> +	node_pa = memblock_find_in_range(node_start_pfn[nid]<<  PAGE_SHIFT,
> +					 (u64)node_end_pfn[nid]<<  PAGE_SHIFT,
> +					 (u64)size<<  PAGE_SHIFT,
> +					 LARGE_PAGE_BYTES);
> +	if (node_pa == MEMBLOCK_ERROR)
>   		panic("Can not get kva ram\n");
>
>   	node_remap_size[nid] = size;
>   	node_remap_offset[nid] = offset;
>   	printk(KERN_DEBUG "Reserving %ld pages of KVA for lmem_map of node %d at %llx\n",
> -	       size, nid, node_kva>>  PAGE_SHIFT);
> +	       size, nid, node_pa>>  PAGE_SHIFT);
>
>   	/*
>   	 *  prevent kva address below max_low_pfn want it on system
> @@ -315,11 +315,10 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
>   	 *  So memblock_x86_reserve_range here, hope we don't run out
>   	 *  of that array
>   	 */
> -	memblock_x86_reserve_range(node_kva,
> -				   node_kva + ((u64)size<<  PAGE_SHIFT),
> +	memblock_x86_reserve_range(node_pa, node_pa + ((u64)size<<  PAGE_SHIFT),
>   				   "KVA RAM");
>
> -	node_remap_start_pfn[nid] = node_kva>>  PAGE_SHIFT;
> +	node_remap_start_pfn[nid] = node_pa>>  PAGE_SHIFT;
>
>   	return size;
>   }

Acked-by: Yinghai Lu <yinghai@kernel.org>
