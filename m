Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab0EUInz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:43:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45012 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab0EUInx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:43:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 21 May 2010 17:39:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: minskey guo <chaohong_guo@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       prarit@redhat.com, andi.kleen@intel.com, linux-kernel@vger.kernel.org,
       minskey guo <chaohong.guo@intel.com>, Tejun Heo <tj@kernel.org>,
       stable@kernel.org
Subject: Re: [PATCH] online CPU before memory failed in pcpu_alloc_pages()
Message-Id: <20100521173940.8f130205.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4BF642BB.2020402@linux.intel.com>
References: <1274163442-7081-1-git-send-email-chaohong_guo@linux.intel.com>
	<20100520134359.fdfb397e.akpm@linux-foundation.org>
	<20100521105512.0c2cf254.sfr@canb.auug.org.au>
	<20100521134424.45e0ee36.kamezawa.hiroyu@jp.fujitsu.com>
	<4BF642BB.2020402@linux.intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 16:22:19 +0800
minskey guo <chaohong_guo@linux.intel.com> wrote:

> Yes.  I can use cpu_to_mem().  only some little difference during
> CPU online:  1st cpu within memoryless node gets memory from current
> node or the node to which the cpu0 belongs,
> 
> 
> But I have a question about the patch:
> 
>     numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch,
> 
> 
> 
> 
> @@ -2968,9 +2991,23 @@ static int __build_all_zonelists(void *d
> ...
> 
> -	for_each_possible_cpu(cpu)
> +	for_each_possible_cpu(cpu) {
> 		setup_pageset(&per_cpu(boot_pageset, cpu), 0);
> ...
> 
> +#ifdef CONFIG_HAVE_MEMORYLESS_NODES
> + 	if (cpu_online(cpu))
> +		cpu_to_mem(cpu) = local_memory_node(cpu_to_node(cpu));
> +#endif
> 
> 
> Look at the last two lines, suppose that memory is onlined before CPUs,
> where will cpu_to_mem(cpu) be set to the right nodeid for the last
> onlined cpu ?  Does that CPU always get memory from the node including 
> cpu0 for slab allocator where cpu_to_mem() is used ?
> 
build_all_zonelist() is called at boot, initialization.
And it calls local_memory_node(cpu_to_node(cpu)) for possible cpus.

So, "how cpu_to_node() for possible cpus is configured" is important.
At quick look, root/arch/x86/mm/numa_64.c has following code.


 786 /*
 787  * Setup early cpu_to_node.
 788  *
 789  * Populate cpu_to_node[] only if x86_cpu_to_apicid[],
 790  * and apicid_to_node[] tables have valid entries for a CPU.
 791  * This means we skip cpu_to_node[] initialisation for NUMA
 792  * emulation and faking node case (when running a kernel compiled
 793  * for NUMA on a non NUMA box), which is OK as cpu_to_node[]
 794  * is already initialized in a round robin manner at numa_init_array,
 795  * prior to this call, and this initialization is good enough
 796  * for the fake NUMA cases.
 797  *
 798  * Called before the per_cpu areas are setup.
 799  */
 800 void __init init_cpu_to_node(void)
 801 {
 802         int cpu;
 803         u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
 804 
 805         BUG_ON(cpu_to_apicid == NULL);
 806 
 807         for_each_possible_cpu(cpu) {
 808                 int node;
 809                 u16 apicid = cpu_to_apicid[cpu];
 810 
 811                 if (apicid == BAD_APICID)
 812                         continue;
 813                 node = apicid_to_node[apicid];
 814                 if (node == NUMA_NO_NODE)
 815                         continue;
 816                 if (!node_online(node))
 817                         node = find_near_online_node(node);
 818                 numa_set_node(cpu, node);
 819         }
 820 }


So, cpu_to_node(cpu) for possible cpus will have NUMA_NO_NODE(-1)
or the number of the nearest node.

IIUC, if SRAT is not broken, all pxm has its own node_id. So,
cpu_to_node(cpu) will return the nearest node and cpu_to_mem() will
find the nearest node with memory.

Thanks,
-Kame



