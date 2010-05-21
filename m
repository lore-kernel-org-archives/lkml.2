Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab0EUNVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 09:21:54 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:27029 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab0EUNVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 09:21:52 -0400
Subject: Re: [PATCH] online CPU before memory failed in pcpu_alloc_pages()
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: minskey guo <chaohong_guo@linux.intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       prarit@redhat.com, andi.kleen@intel.com, linux-kernel@vger.kernel.org,
       minskey guo <chaohong.guo@intel.com>, Tejun Heo <tj@kernel.org>,
       stable@kernel.org
In-Reply-To: <4BF64E79.4010401@linux.intel.com>
References: <1274163442-7081-1-git-send-email-chaohong_guo@linux.intel.com>
	 <20100520134359.fdfb397e.akpm@linux-foundation.org>
	 <20100521105512.0c2cf254.sfr@canb.auug.org.au>
	 <20100521134424.45e0ee36.kamezawa.hiroyu@jp.fujitsu.com>
	 <4BF642BB.2020402@linux.intel.com>
	 <20100521173940.8f130205.kamezawa.hiroyu@jp.fujitsu.com>
	 <4BF64E79.4010401@linux.intel.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Fri, 21 May 2010 09:21:47 -0400
Message-Id: <1274448107.9131.87.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 17:12 +0800, minskey guo wrote:
> On 05/21/2010 04:39 PM, KAMEZAWA Hiroyuki wrote:
> > On Fri, 21 May 2010 16:22:19 +0800
> > minskey guo<chaohong_guo@linux.intel.com>  wrote:
> >
> >> Yes.  I can use cpu_to_mem().  only some little difference during
> >> CPU online:  1st cpu within memoryless node gets memory from current
> >> node or the node to which the cpu0 belongs,
> >>
> >>
> >> But I have a question about the patch:
> >>
> >>      numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch,
> >>
> >>
> >>
> >>
> >> @@ -2968,9 +2991,23 @@ static int __build_all_zonelists(void *d
> >> ...
> >>
> >> -	for_each_possible_cpu(cpu)
> >> +	for_each_possible_cpu(cpu) {
> >> 		setup_pageset(&per_cpu(boot_pageset, cpu), 0);
> >> ...
> >>
> >> +#ifdef CONFIG_HAVE_MEMORYLESS_NODES
> >> + 	if (cpu_online(cpu))
> >> +		cpu_to_mem(cpu) = local_memory_node(cpu_to_node(cpu));
> >> +#endif
> 
> Look at the above code,  int __build_all_zonelists(),  cpu_to_mem(cpu)
> is set only when cpu is onlined.  Suppose that a node with local memory,
> all memory segments are onlined first, and then,  cpus within that node
> are onlined one by one,  in this case,  where does the cpu_to_mem(cpu)
> for the last cpu get its value ?

Minskey:

As I mentioned to Kame-san, x86 does not define
CONFIG_HAVE_MEMORYLESS_NODES, so this code is not compiled for that
arch.  If x86 did support memoryless nodes--i.e., did not hide them and
reassign the cpus to other nodes, as is the case for ia64--then we could
have on-line cpus associated with memoryless nodes.  The code above is
in __build_all_zonelists() so that in the case where we add memory to a
previously memoryless node, we re-evaluate the "local memory node" for
all online cpus.

For cpu hotplug--again, if x86 supports memoryless nodes--we'll need to
add a similar chunk to the path where we set up the cpu_to_node map for
a hotplugged cpu.  See, for example, the call to set_numa_mem() in
smp_callin() in arch/ia64/kernel/smpboot.c.  But currently, I don't
think you can use the numa_mem_id()/cpu_to_mem() interfaces for your
purpose.  I suppose you could change page_alloc.c to compile
local_memory_node() #if defined(CONFIG_HAVE_MEMORYLESS_NODES) || defined
(CPU_HOTPLUG) and use that function to find the nearest memory.  It
should return a valid node after zonelists have been rebuilt.

Does that make sense?

Lee
> 
> 
> >
> > So, cpu_to_node(cpu) for possible cpus will have NUMA_NO_NODE(-1)
> > or the number of the nearest node.
> >
> > IIUC, if SRAT is not broken, all pxm has its own node_id.
> 
> Thank you very much for the info,  I have been thinking why node_id
> is (-1) in some cases.
> 
> 
> -minskey
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

