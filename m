Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab0LIWsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:48:33 -0500
Received: from relay3.sgi.com ([192.48.152.1]:56895 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750796Ab0LIWsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:48:31 -0500
Date: Thu, 9 Dec 2010 14:48:30 -0800
From: Arthur Kepner <akepner@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH RESEND] x86/irq: assign vectors from numa_node
Message-ID: <20101209224830.GH20481@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Resending with expanded cc list.)

Several drivers (e.g., mlx4_core) do something similar to:

	err = pci_enable_msix(pdev, entries, num_possible_cpus());

which takes us down this code path:

	pci_enable_msix
	native_setup_msi_irqs
	create_irq_nr
	__assign_irq_vector

__assign_irq_vector() preferentially uses vectors from low-numbered 
CPUs. On a system with a large number (>256) CPUs this can result in 
a CPU running out of vectors, and subsequent attempts to assign an 
interrupt to that CPU will fail.

The following patch prefers vectors from the node associated with the 
device (if the device is associated with a node). This should make it 
far less likely that a single CPU's vectors will be exhausted.

Signed-off-by: Arthur Kepner <akepner@sgi.com>
---

 io_apic.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 77 insertions(+), 4 deletions(-)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7cc0a72..af5f9d8 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1117,6 +1117,49 @@ next:
 	return err;
 }
 
+static int
+__assign_irq_vector_node(int irq, struct irq_cfg *cfg,
+			 const struct cpumask *mask, int node)
+{
+	int err = -EAGAIN;
+	int cpu, best_cpu = -1, min_vector_count = NR_VECTORS;
+
+	for_each_cpu_and(cpu, cpumask_of_node(node), mask) {
+		/* find the 'best' CPU to take this vector -
+		 * the one with the fewest assigned vectors is
+		 * considered 'best' */
+		int i, vector_count = 0;
+
+		if (!cpu_online(cpu))
+			continue;
+
+		for (i = FIRST_EXTERNAL_VECTOR + VECTOR_OFFSET_START;
+		     i < NR_VECTORS ; i++)
+			if (per_cpu(vector_irq, cpu)[i] != -1)
+				vector_count++;
+
+		if (vector_count < min_vector_count) {
+			min_vector_count = vector_count;
+			best_cpu = cpu;
+		}
+	}
+
+	if (best_cpu >= 0) {
+		cpumask_var_t tmp_mask;
+
+		if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
+			return -ENOMEM;
+
+		cpumask_clear(tmp_mask);
+		cpumask_set_cpu(best_cpu, tmp_mask);
+		err = __assign_irq_vector(irq, cfg, tmp_mask);
+
+		free_cpumask_var(tmp_mask);
+	}
+
+	return err;
+}
+
 int assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 {
 	int err;
@@ -1128,6 +1171,39 @@ int assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	return err;
 }
 
+static int
+assign_irq_vector_node(int irq, struct irq_cfg *cfg,
+		       const struct cpumask *mask, int node)
+{
+	int err;
+	unsigned long flags;
+
+	if (node == NUMA_NO_NODE)
+		return assign_irq_vector(irq, cfg, mask);
+
+	raw_spin_lock_irqsave(&vector_lock, flags);
+	err = __assign_irq_vector_node(irq, cfg, mask, node);
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
+
+	if (err != 0)
+		/* uh oh - try again w/o specifying a node */
+		return assign_irq_vector(irq, cfg, mask);
+	else {
+		/* and set the affinity mask so that only
+		 * CPUs on 'node' will be used */
+		struct irq_desc *desc = irq_to_desc(irq);
+		unsigned long flags;
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+		cpumask_and(desc->irq_data.affinity, cpu_online_mask,
+			    cpumask_of_node(node));
+		desc->status |= IRQ_AFFINITY_SET;
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+	}
+
+	return err;
+}
+
 static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 {
 	int cpu, vector;
@@ -3057,7 +3133,6 @@ device_initcall(ioapic_init_sysfs);
 unsigned int create_irq_nr(unsigned int from, int node)
 {
 	struct irq_cfg *cfg;
-	unsigned long flags;
 	unsigned int ret = 0;
 	int irq;
 
@@ -3073,10 +3148,8 @@ unsigned int create_irq_nr(unsigned int from, int node)
 		return 0;
 	}
 
-	raw_spin_lock_irqsave(&vector_lock, flags);
-	if (!__assign_irq_vector(irq, cfg, apic->target_cpus()))
+	if (!assign_irq_vector_node(irq, cfg, apic->target_cpus(), node))
 		ret = irq;
-	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
 	if (ret) {
 		set_irq_chip_data(irq, cfg);
