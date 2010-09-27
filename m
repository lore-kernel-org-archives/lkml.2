Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037Ab0I0EIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 00:08:07 -0400
Received: from relay3.sgi.com ([192.48.152.1]:46506 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750905Ab0I0EIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 00:08:04 -0400
Date: Sun, 26 Sep 2010 21:08:03 -0700
From: Arthur Kepner <akepner@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC/PATCH] x86/irq: round-robin distribution of irqs to cpus w/in
	node
Message-ID: <20100927040803.GJ20474@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


SGI has encountered situations where particular CPUs run out of
interrupt vectors on systems with many (several hundred or more)
CPUs. This happens because some drivers (particularly the mlx4_core
driver) select the number of interrupts they allocate based on the
number of CPUs, and because of how the default irq affinity is used.

Do  psuedo round-robin distribution of irqs to CPUs within a node 
to avoid (or at least delay) running out of vectors on any particular 
CPU.

Signed-off-by: Arthur Kepner <akepner@sgi.com>
---

 arch/x86/kernel/apic/io_apic.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f1efeba..ad540a9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3254,6 +3254,8 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
 	for (new = irq_want; new < nr_irqs; new++) {
+		cpumask_var_t tmp_mask;
+
 		desc_new = irq_to_desc_alloc_node(new, node);
 		if (!desc_new) {
 			printk(KERN_INFO "can not get irq_desc for %d\n", new);
@@ -3267,8 +3269,30 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 		desc_new = move_irq_desc(desc_new, node);
 		cfg_new = desc_new->chip_data;
 
-		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
-			irq = new;
+		if ((node != -1) && alloc_cpumask_var(&tmp_mask, GFP_ATOMIC)) {
+
+			static int cpu;
+
+			/* try to place irq on a cpu in the node in psuedo-
+			 * round robin order*/
+
+			cpu = __next_cpu_nr(cpu, cpumask_of_node(node));
+			if (cpu >= nr_cpu_ids)
+				cpu = 0;
+
+			cpumask_set_cpu(cpu, tmp_mask);
+
+			if (cpumask_test_cpu(cpu, apic->target_cpus()) &&
+			    __assign_irq_vector(new, cfg_new, tmp_mask) == 0)
+				irq = new;
+
+			free_cpumask_var(tmp_mask);
+		}
+
+		if (irq == 0)
+			if (__assign_irq_vector(new, cfg_new,
+						apic->target_cpus()) == 0)
+				irq = new;
 		break;
 	}
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
