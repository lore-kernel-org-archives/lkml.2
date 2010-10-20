Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab0JTDHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:07:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:48388 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab0JTDHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:07:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,354,1283756400"; 
   d="scan'208";a="848944355"
Subject: [PATCH 2/2]x86: spread tlb flush vector between nodes
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, "Chen, Tim C" <tim.c.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 11:07:03 +0800
Message-ID: <1287544023.4571.8.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

In my test, this could reduce > 20% CPU overhead in extreme case.The test
machine has 4 nodes and each node has 16 CPUs. I then bind each node's kswapd
to the first CPU of the node. I run a workload with 4 sequential mmap file
read thread. The files are empty sparse file. This workload will trigger a
lot of page reclaim and tlbflush. The kswapd bind is to easy trigger the
extreme tlb flush lock contention because otherwise kswapd keeps migrating
between CPUs of a node and I can't get stable result. Sure in real workload,
we can't always see so big tlb flush lock contention, but it's possible.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 arch/x86/mm/tlb.c |   48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

Index: linux/arch/x86/mm/tlb.c
===================================================================
--- linux.orig/arch/x86/mm/tlb.c	2010-10-20 10:07:53.000000000 +0800
+++ linux/arch/x86/mm/tlb.c	2010-10-20 10:09:26.000000000 +0800
@@ -5,6 +5,7 @@
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/cpu.h>
 
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
@@ -52,6 +53,8 @@ union smp_flush_state {
    want false sharing in the per cpu data segment. */
 static union smp_flush_state flush_state[NUM_INVALIDATE_TLB_VECTORS];
 
+static DEFINE_PER_CPU_READ_MOSTLY(int, tlb_vector_offset);
+
 /*
  * We cannot call mmdrop() because we are in interrupt context,
  * instead update mm->cpu_vm_mask.
@@ -173,7 +176,7 @@ static void flush_tlb_others_ipi(const s
 	union smp_flush_state *f;
 
 	/* Caller has disabled preemption */
-	sender = smp_processor_id() % NUM_INVALIDATE_TLB_VECTORS;
+	sender = per_cpu(tlb_vector_offset, smp_processor_id());
 	f = &flush_state[sender];
 
 	/*
@@ -218,6 +221,47 @@ void native_flush_tlb_others(const struc
 	flush_tlb_others_ipi(cpumask, mm, va);
 }
 
+static void __cpuinit calculate_tlb_offset(void)
+{
+	int cpu, node, nr_node_vecs;
+	/*
+	 * we are changing tlb_vector_offset for each CPU in runtime, but this
+	 * will not cause inconsistency, as the write is atomic under X86. we
+	 * might see more lock contentions in a short time, but after all CPU's
+	 * tlb_vector_offset are changed, everything should go normal
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
+			per_cpu(tlb_vector_offset, cpu) = node_offset +
+				cpu_offset;
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
@@ -225,6 +269,8 @@ static int __cpuinit init_smp_flush(void
 	for (i = 0; i < ARRAY_SIZE(flush_state); i++)
 		raw_spin_lock_init(&flush_state[i].tlbstate_lock);
 
+	calculate_tlb_offset();
+	hotcpu_notifier(tlb_cpuhp_notify, 0);
 	return 0;
 }
 core_initcall(init_smp_flush);


