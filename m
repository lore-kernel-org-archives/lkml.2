Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169Ab2EVBxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:53:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45486 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab2EVBxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:53:39 -0400
Date: Mon, 21 May 2012 18:53:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: PowerPC boot failures in next-20120521
In-Reply-To: <20120522114051.0c9db9a7c2d660bc9e0e1be2@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.1205211846120.20916@chino.kir.corp.google.com>
References: <20120522114051.0c9db9a7c2d660bc9e0e1be2@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Stephen Rothwell wrote:

> Unable to handle kernel paging request for data at address 0x00001688
> Faulting instruction address: 0xc00000000016e154
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=32 NUMA pSeries
> Modules linked in:
> NIP: c00000000016e154 LR: c0000000001b9140 CTR: 0000000000000000
> REGS: c0000003fc8c76d0 TRAP: 0300   Not tainted  (3.4.0-autokern1)
> MSR: 8000000000009032 <SF,EE,ME,IR,DR,RI>  CR: 24044022  XER: 00000003
> SOFTE: 1
> CFAR: 000000000000562c
> DAR: 0000000000001688, DSISR: 40000000
> TASK = c0000003fc8c8000[1] 'swapper/0' THREAD: c0000003fc8c4000 CPU: 0
> GPR00: 0000000000000000 c0000003fc8c7950 c000000000d05b30 00000000000012d0 
> GPR04: 0000000000000000 0000000000001680 0000000000000000 c0000003fe032f60 
> GPR08: 0004005400000001 0000000000000000 ffffffffffffc980 c000000000d24fe0 
> GPR12: 0000000024044024 c00000000f33b000 0000000001a3fa78 00000000009bac00 
> GPR16: 0000000000e1f338 0000000002d513f0 0000000000001680 0000000000000000 
> GPR20: 0000000000000001 c0000003fc8c7c00 0000000000000000 0000000000000001 
> GPR24: 0000000000000001 c000000000d1b490 0000000000000000 0000000000001680 
> GPR28: 0000000000000000 0000000000000000 c000000000c7ce58 c0000003fe009200 
> NIP [c00000000016e154] .__alloc_pages_nodemask+0xc4/0x8f0
> LR [c0000000001b9140] .new_slab+0xd0/0x3c0
> Call Trace:
> [c0000003fc8c7950] [2e6e756d615f696e] 0x2e6e756d615f696e (unreliable)
> [c0000003fc8c7ae0] [c0000000001b9140] .new_slab+0xd0/0x3c0
> [c0000003fc8c7b90] [c0000000001b9844] .__slab_alloc+0x254/0x5b0
> [c0000003fc8c7cd0] [c0000000001bb7a4] .kmem_cache_alloc_node_trace+0x94/0x260
> [c0000003fc8c7d80] [c000000000ba36d0] .numa_init+0x98/0x1dc
> [c0000003fc8c7e10] [c00000000000ace4] .do_one_initcall+0x1a4/0x1e0
> [c0000003fc8c7ed0] [c000000000b7b354] .kernel_init+0x124/0x2e0
> [c0000003fc8c7f90] [c0000000000211c8] .kernel_thread+0x54/0x70
> Instruction dump:
> 5400d97e 7b170020 0b000000 eb3e8000 3b800000 80190088 2f800000 40de0014 
> 7860efe2 787c6fe2 78000fa4 7f9c0378 <e81b0008> 83f90000 2fa00000 7fff1838 
> ---[ end trace 31fd0ba7d8756001 ]---
> 
> swapper/0 (1) used greatest stack depth: 10864 bytes left
> Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> 
> I may be completely wrong, but I guess the obvious target would be the
> sched/numa branch that came in via the tip tree.
> 
> Config file attached.  I haven't had a chance to try to bisect this yet.
> 
> Anyone have any ideas?

Yeah, it's sched/numa since that's what introduced numa_init().  It does 
for_each_node() for each node and does a kmalloc_node() even though that 
node may not be online.  Slub ends up passing this node to the page 
allocator through alloc_pages_exact_node().  CONFIG_DEBUG_VM would have 
caught this and your config confirms its not enabled.

sched/numa either needs a memory hotplug notifier or it needs to pass 
NUMA_NO_NODE for nodes that aren't online.  Until we get the former, the 
following should fix it.


sched, numa: Allocate node_queue on any node for offline nodes

struct node_queue must be allocated with NUMA_NO_NODE for nodes that are 
not (yet) online, otherwise the page allocator has a bad zonelist.

Signed-off-by: David Rientjes <rientjes@google.com>
---
diff --git a/kernel/sched/numa.c b/kernel/sched/numa.c
--- a/kernel/sched/numa.c
+++ b/kernel/sched/numa.c
@@ -885,7 +885,8 @@ static __init int numa_init(void)
 
 	for_each_node(node) {
 		struct node_queue *nq = kmalloc_node(sizeof(*nq),
-				GFP_KERNEL | __GFP_ZERO, node);
+				GFP_KERNEL | __GFP_ZERO,
+				node_online(node) ? node : NUMA_NO_NODE);
 		BUG_ON(!nq);
 
 		spin_lock_init(&nq->lock);
