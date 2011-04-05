Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1DESFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:05:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31028 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1DESFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:05:06 -0400
Message-ID: <4D9B59B7.80102@kernel.org>
Date: Tue, 05 Apr 2011 11:04:39 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/14] x86-32, NUMA: Calculate remap size in common code
References: <1301955840-7246-1-git-send-email-tj@kernel.org> <1301955840-7246-8-git-send-email-tj@kernel.org>
In-Reply-To: <1301955840-7246-8-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D9B59C2.01AF,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2011 03:23 PM, Tejun Heo wrote:
> Only pgdat and memmap use remap area and there isn't much benefit in
> allowing per-node override.  In addition, the use of node_remap_size[]
> is confusing in that it contains number of bytes before remap
> initialization and then number of pages afterwards.
>
> Move remap size calculation for memap from specific NUMA config
> implementations to init_alloc_remap() and make node_remap_size[]
> static.
>
> The only behavior difference is that, before this patch, numaq_32
> didn't consider max_pfn when calculating the memmap size but it's
> enforced after this patch, which is the right thing to do.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Yinghai Lu<yinghai@kernel.org>
> Cc: David Rientjes<rientjes@google.com>
> Cc: Thomas Gleixner<tglx@linutronix.de
> Cc: Ingo Molnar<mingo@redhat.com>
> Cc: "H. Peter Anvin"<hpa@zytor.com>
> ---
>   arch/x86/include/asm/topology.h |    1 -
>   arch/x86/kernel/apic/numaq_32.c |    4 ----
>   arch/x86/mm/numa_32.c           |   10 ++++------
>   arch/x86/mm/srat_32.c           |    1 -
>   4 files changed, 4 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> index 910a708..8dba769 100644
> --- a/arch/x86/include/asm/topology.h
> +++ b/arch/x86/include/asm/topology.h
> @@ -95,7 +95,6 @@ extern void setup_node_to_cpumask_map(void);
>   #ifdef CONFIG_X86_32
>   extern unsigned long node_start_pfn[];
>   extern unsigned long node_end_pfn[];
> -extern unsigned long node_remap_size[];
>   #define node_has_online_mem(nid) (node_start_pfn[nid] != node_end_pfn[nid])
>
>   # define SD_CACHE_NICE_TRIES	1
> diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
> index 6273eee..0aced70 100644
> --- a/arch/x86/kernel/apic/numaq_32.c
> +++ b/arch/x86/kernel/apic/numaq_32.c
> @@ -93,10 +93,6 @@ static inline void numaq_register_node(int node, struct sys_cfg_data *scd)
>   						node_end_pfn[node]);
>
>   	memory_present(node, node_start_pfn[node], node_end_pfn[node]);
> -
> -	node_remap_size[node] = node_memmap_size_bytes(node,
> -					node_start_pfn[node],
> -					node_end_pfn[node]);
>   }
>
>   /*
> diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
> index 99310d2..9a73365 100644
> --- a/arch/x86/mm/numa_32.c
> +++ b/arch/x86/mm/numa_32.c
> @@ -104,7 +104,7 @@ extern unsigned long highend_pfn, highstart_pfn;
>
>   #define LARGE_PAGE_BYTES (PTRS_PER_PTE * PAGE_SIZE)
>
> -unsigned long node_remap_size[MAX_NUMNODES];
> +static unsigned long node_remap_size[MAX_NUMNODES];
>   static void *node_remap_start_vaddr[MAX_NUMNODES];
>   void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
>
> @@ -129,7 +129,6 @@ int __init get_memcfg_numa_flat(void)
>   	node_end_pfn[0] = max_pfn;
>   	memblock_x86_register_active_regions(0, 0, max_pfn);
>   	memory_present(0, 0, max_pfn);
> -	node_remap_size[0] = node_memmap_size_bytes(0, 0, max_pfn);
>
>           /* Indicate there is one node available. */
>   	nodes_clear(node_online_map);
> @@ -282,11 +281,10 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
>   	if (node_end_pfn[nid]>  max_pfn)
>   		node_end_pfn[nid] = max_pfn;
>
> -	/* ensure the remap includes space for the pgdat. */
> -	size = node_remap_size[nid];
> +	/* calculate the necessary space aligned to large page size */
> +	size = node_memmap_size_bytes(nid, node_start_pfn[nid],
> +				      min(node_end_pfn[nid], max_pfn));
>   	size += ALIGN(sizeof(pg_data_t), PAGE_SIZE);
> -
> -	/* align to large page */
>   	size = ALIGN(size, LARGE_PAGE_BYTES);
>
>   	node_pa = memblock_find_in_range(node_start_pfn[nid]<<  PAGE_SHIFT,
> diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
> index 48651c6..1b9e82c 100644
> --- a/arch/x86/mm/srat_32.c
> +++ b/arch/x86/mm/srat_32.c
> @@ -276,7 +276,6 @@ int __init get_memcfg_from_srat(void)
>   		unsigned long end = min(node_end_pfn[nid], max_pfn);
>
>   		memory_present(nid, start, end);
> -		node_remap_size[nid] = node_memmap_size_bytes(nid, start, end);
>   	}
>   	return 1;
>   out_fail:

Acked-by: Yinghai Lu <yinghai@kernel.org>
