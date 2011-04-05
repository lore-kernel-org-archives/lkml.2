Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1DETOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 15:14:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18152 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab1DETOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 15:14:51 -0400
Message-ID: <4D9B6A10.5040804@kernel.org>
Date: Tue, 05 Apr 2011 12:14:24 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] x86-32, NUMA: Make pgdat allocation use alloc_remap()
References: <1301955840-7246-1-git-send-email-tj@kernel.org> <1301955840-7246-12-git-send-email-tj@kernel.org>
In-Reply-To: <1301955840-7246-12-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D9B6A1B.00C0,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2011 03:23 PM, Tejun Heo wrote:
> pgdat allocation is handled differnetly from other remap allocations -
> it's reserved during initialization.  There's no reason to handle this
> any differnetly.  Remap allocator is initialized for every node and if
> init failed the allocation will fail and pgdat allocation can fall
> back to generic code like anyone else.
>
> Remove special init-time pgdat reservation and make allocate_pgdat()
> use alloc_remap() like everyone else.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Yinghai Lu<yinghai@kernel.org>
> Cc: David Rientjes<rientjes@google.com>
> Cc: Thomas Gleixner<tglx@linutronix.de
> Cc: Ingo Molnar<mingo@redhat.com>
> Cc: "H. Peter Anvin"<hpa@zytor.com>
> ---
>   arch/x86/mm/numa_32.c |    7 +++----
>   1 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
> index 53ec13a..0184a9f 100644
> --- a/arch/x86/mm/numa_32.c
> +++ b/arch/x86/mm/numa_32.c
> @@ -160,9 +160,8 @@ static void __init allocate_pgdat(int nid)
>   {
>   	char buf[16];
>
> -	if (node_has_online_mem(nid)&&  node_remap_start_vaddr[nid])
> -		NODE_DATA(nid) = (pg_data_t *)node_remap_start_vaddr[nid];
> -	else {
> +	NODE_DATA(nid) = alloc_remap(nid, ALIGN(sizeof(pg_data_t), PAGE_SIZE));
> +	if (!NODE_DATA(nid)) {
>   		unsigned long pgdat_phys;
>   		pgdat_phys = memblock_find_in_range(min_low_pfn<<PAGE_SHIFT,
>   				 max_pfn_mapped<<PAGE_SHIFT,
> @@ -301,7 +300,7 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
>
>   	node_remap_start_vaddr[nid] = remap_va;
>   	node_remap_end_vaddr[nid] = remap_va + size;
> -	node_remap_alloc_vaddr[nid] = remap_va + ALIGN(sizeof(pg_data_t), PAGE_SIZE);
> +	node_remap_alloc_vaddr[nid] = remap_va;
>
>   	printk(KERN_DEBUG "remap_alloc: node %d [%08llx-%08llx) ->  [%p-%p)\n",
>   	       nid, node_pa, node_pa + size, remap_va, remap_va + size);

Acked-by: Yinghai Lu <yinghai@kernel.org>
