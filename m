Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab0JSN27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:28:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:39586 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758570Ab0JSN26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:28:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,350,1283756400"; 
   d="scan'208";a="618184376"
Subject: Re: [patch]x86: spread tlb flush vector between nodes
From: Shaohua Li <shaohua.li@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <20101019103759.GC32212@elte.hu>
References: <1286955698.13317.5.camel@sli10-conroe.sh.intel.com>
	 <20101013081629.GA1621@basil.fritz.box>
	 <1286959176.24888.6.camel@sli10-conroe.sh.intel.com>
	 <1287466757.29515.2.camel@sli10-conroe.sh.intel.com>
	 <6dd05e19-05ef-48e4-b42d-d18c913fa4d7@email.android.com>
	 <20101019084423.GB27723@elte.hu>
	 <1287478532.9456.0.camel@sli10-conroe.sh.intel.com>
	 <20101019103759.GC32212@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 21:28:51 +0800
Message-ID: <1287494931.1699.12.camel@shli-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 18:37 +0800, Ingo Molnar wrote:
> * Shaohua Li <shaohua.li@intel.com> wrote:
> 
> > On Tue, 2010-10-19 at 16:44 +0800, Ingo Molnar wrote:
> > > * H. Peter Anvin <hpa@zytor.com> wrote:
> > > 
> > > > Technically, it is way too late for anything new in this merge window, but we can 
> > > > try to make a reasonable assessment of the risk since the merge window got 
> > > > delayed.  However, this close to the merge window you cannot just expect to be 
> > > > merged even if the patch itself is OK.
> > > 
> > > a prompt re-send of the patch today-ish, with proper changelog, etc. and with 
> > > the new tuning in place is definitely a must.
> >
> > the previous patch has changelog. what did you mean a new tuning?
> 
> The new tuning would be the 8->32 patch - but that would be a more complex and 
> separate (and definitely controversial) patch anyway.
Yes, I'm working on it. And it hasn't too many relation with this patch.

> So if hpa gives his ack we can try this current spread-tlb-vectors-better patch in 
> -tip and see how it fares. Could you please update the changelog to specify the 20% 
> improvement more precisely? What kind of workload was used and how was the 
> improvement measured?
Below is the updated patch which describes the workload I use.


Currently flush tlb vector allocation is based on below equation:
	sender = smp_processor_id() % 8
This isn't optimal, CPUs from different node can have the same vector, this
causes a lot of lock contention. Instead, we can assign the same vectors to
CPUs from the same node, while different node has different vectors. This has
below advantages:
a. if there is lock contention, the lock contention is between CPUs from one
node. This should be much cheaper than the contention between nodes.
b. completely avoid lock contention between nodes. This especially benefits
kswapd, which is the biggest user of tlb flush, since kswapd sets its affinity
to specific node.

In my test, this could reduce > 20% CPU overhead in extreme case. The test
machine has 4 nodes and each node has 16 CPUs. I then bind each node's kswapd
to the first CPU of the node. I run a workload with 4 sequential mmap file
read thread. The files are empty sparse file. This workload will trigger a
lot of page reclaim and tlbflush. The kswapd bind is to easy trigger the
extreme tlb flush lock contention because otherwise kswapd keeps migrating
between CPUs of a node and I can't get stable result. Sure in real workload,
we can't always see so big tlb flush lock contention, but it's possible.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 arch/x86/mm/tlb.c |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/mm/tlb.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/tlb.c	2010-10-13 20:40:19.000000000 +0800
+++ linux-2.6/arch/x86/mm/tlb.c	2010-10-13 23:19:26.000000000 +0800
@@ -5,6 +5,7 @@
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/cpu.h>
 
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
@@ -52,6 +53,8 @@
    want false sharing in the per cpu data segment. */
 static union smp_flush_state flush_state[NUM_INVALIDATE_TLB_VECTORS];
 
+static int tlb_vector_offset[NR_CPUS] __read_mostly;
+
 /*
  * We cannot call mmdrop() because we are in interrupt context,
  * instead update mm->cpu_vm_mask.
@@ -173,7 +176,7 @@
 	union smp_flush_state *f;
 
 	/* Caller has disabled preemption */
-	sender = smp_processor_id() % NUM_INVALIDATE_TLB_VECTORS;
+	sender = tlb_vector_offset[smp_processor_id()];
 	f = &flush_state[sender];
 
 	/*
@@ -218,6 +221,46 @@
 	flush_tlb_others_ipi(cpumask, mm, va);
 }
 
+static void __cpuinit calculate_tlb_offset(void)
+{
+	int cpu, node, nr_node_vecs;
+	/*
+	 * we are changing tlb_vector_offset[] for each CPU in runtime, but this
+	 * will not cause inconsistency, as the write is atomic under X86. we
+	 * might see more lock contentions in a short time, but after all CPU's
+	 * tlb_vector_offset[] are changed, everything should go normal
+	 *
+	 * Note: if NUM_INVALIDATE_TLB_VECTORS % nr_online_nodes !=0, we might
+	 * waste some vectors.
+	 **/
+	if (nr_online_nodes > NUM_INVALIDATE_TLB_VECTORS)
+		nr_node_vecs = 1;
+	else
+		nr_node_vecs = NUM_INVALIDATE_TLB_VECTORS/nr_online_nodes;
+
+	for_each_online_node(node) {
+		int node_offset = (node % NUM_INVALIDATE_TLB_VECTORS) *
+			nr_node_vecs;
+		int cpu_offset = 0;
+		for_each_cpu(cpu, cpumask_of_node(node)) {
+			tlb_vector_offset[cpu] = node_offset + cpu_offset;
+			cpu_offset++;
+			cpu_offset = cpu_offset % nr_node_vecs;
+		}
+	}
+}
+
+static int tlb_cpuhp_notify(struct notifier_block *n,
+		unsigned long action, void *hcpu)
+{
+	switch (action & 0xf) {
+	case CPU_ONLINE:
+	case CPU_DEAD:
+		calculate_tlb_offset();
+	}
+	return NOTIFY_OK;
+}
+
 static int __cpuinit init_smp_flush(void)
 {
 	int i;
@@ -225,6 +268,8 @@
 	for (i = 0; i < ARRAY_SIZE(flush_state); i++)
 		raw_spin_lock_init(&flush_state[i].tlbstate_lock);
 
+	calculate_tlb_offset();
+	hotcpu_notifier(tlb_cpuhp_notify, 0);
 	return 0;
 }
 core_initcall(init_smp_flush);


