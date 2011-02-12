Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab1BLRsZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:48:25 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:57491 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1BLRsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:48:22 -0500
Message-ID: <4D56C79B.2060201@kernel.org>
Date: Sat, 12 Feb 2011 09:47:07 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 02/26] x86-64, NUMA: Simplify hotplug node handling in
 acpi_numa_memory_affinity_init()
References: <1297530663-26234-1-git-send-email-tj@kernel.org> <1297530663-26234-3-git-send-email-tj@kernel.org>
In-Reply-To: <1297530663-26234-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D56C7D6.013E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2011 09:10 AM, Tejun Heo wrote:
> Hotplug node handling in acpi_numa_memory_affinity_init() was
> unnecessarily complicated with storing the original nodes[] entry and
> restoring it afterwards.  Simplify it by not modifying the nodes[]
> entry for hotplug nodes from the beginning.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Brian Gerst <brgerst@gmail.com>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: Shaohui Zheng <shaohui.zheng@intel.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/mm/srat_64.c |   31 +++++++++++++------------------
>  1 files changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
> index 9a97261..e3e0dd3 100644
> --- a/arch/x86/mm/srat_64.c
> +++ b/arch/x86/mm/srat_64.c
> @@ -251,7 +251,7 @@ update_nodes_add(int node, unsigned long start, unsigned long end)
>  void __init
>  acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
>  {
> -	struct bootnode *nd, oldnode;
> +	struct bootnode *nd;
>  	unsigned long start, end;
>  	int node, pxm;
>  	int i;
> @@ -289,28 +289,23 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
>  		bad_srat();
>  		return;
>  	}
> -	nd = &nodes[node];
> -	oldnode = *nd;
> -	if (!node_test_and_set(node, nodes_parsed)) {
> -		nd->start = start;
> -		nd->end = end;
> -	} else {
> -		if (start < nd->start)
> -			nd->start = start;
> -		if (nd->end < end)
> -			nd->end = end;
> -	}
>  
>  	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
>  	       start, end);
>  
> -	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
> +	if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)) {
> +		nd = &nodes[node];
> +		if (!node_test_and_set(node, nodes_parsed)) {
> +			nd->start = start;
> +			nd->end = end;
> +		} else {
> +			if (start < nd->start)
> +				nd->start = start;
> +			if (nd->end < end)
> +				nd->end = end;
> +		}
> +	} else
>  		update_nodes_add(node, start, end);
> -		/* restore nodes[node] */
> -		*nd = oldnode;
> -		if ((nd->start | nd->end) == 0)
> -			node_clear(node, nodes_parsed);
> -	}
>  
>  	node_memblk_range[num_node_memblks].start = start;
>  	node_memblk_range[num_node_memblks].end = end;

after change
looks like nodes_parsed is not set anymore for node that only have hotplug memory.

Thanks

Yinghai
