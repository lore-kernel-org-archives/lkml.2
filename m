Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2IFLcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:32:52 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:59868 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2IFLcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:32:48 -0400
X-AuditID: b753bd60-8ecbeba0000047ca-fc-504888dd60d6
X-AuditID: b753bd60-8ecbeba0000047ca-fc-504888dd60d6
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 12/21] x86/apic: Enable external interrupt routing to
 slave CPUs
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Sep 2012 20:28:22 +0900
Message-ID: <20120906112822.13320.29060.stgit@kvmdev>
In-Reply-To: <20120906112718.13320.8231.stgit@kvmdev>
References: <20120906112718.13320.8231.stgit@kvmdev>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable APIC to handle interrupts on slave CPUs, and enables interrupt
routing to slave CPUs by setting IRQ affinity.

As slave CPUs which run a KVM guest handle external interrupts directly in
the vCPUs, the guest's vector/IRQ mapping is different from the host's.
That requires interrupts to be routed either online CPUs or slave CPUs.

In this patch, if online CPUs are contained in specified affinity settings,
the affinity settings will be only applied to online CPUs. If every
specified CPU is slave, IRQ will be routed to slave CPUs.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/include/asm/apic.h           |    6 ++---
 arch/x86/kernel/apic/io_apic.c        |   43 ++++++++++++++++++++++++---------
 arch/x86/kernel/apic/x2apic_cluster.c |    8 +++---
 drivers/iommu/intel_irq_remapping.c   |   30 +++++++++++++++++++----
 kernel/irq/manage.c                   |    4 ++-
 kernel/irq/migration.c                |    2 +-
 kernel/irq/proc.c                     |    2 +-
 7 files changed, 67 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index f342612..d37ae5c 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -535,7 +535,7 @@ extern void generic_bigsmp_probe(void);
 static inline const struct cpumask *default_target_cpus(void)
 {
 #ifdef CONFIG_SMP
-	return cpu_online_mask;
+	return cpu_online_or_slave_mask;
 #else
 	return cpumask_of(0);
 #endif
@@ -543,7 +543,7 @@ static inline const struct cpumask *default_target_cpus(void)
 
 static inline const struct cpumask *online_target_cpus(void)
 {
-	return cpu_online_mask;
+	return cpu_online_or_slave_mask;
 }
 
 DECLARE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_bios_cpu_apicid);
@@ -602,7 +602,7 @@ flat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 {
 	unsigned long cpu_mask = cpumask_bits(cpumask)[0] &
 				 cpumask_bits(andmask)[0] &
-				 cpumask_bits(cpu_online_mask)[0] &
+				 cpumask_bits(cpu_online_or_slave_mask)[0] &
 				 APIC_ALL_CPUS;
 
 	if (likely(cpu_mask)) {
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c265593..0cd2682 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1125,7 +1125,7 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	/* Only try and allocate irqs on cpus that are present */
 	err = -ENOSPC;
 	cpumask_clear(cfg->old_domain);
-	cpu = cpumask_first_and(mask, cpu_online_mask);
+	cpu = cpumask_first_and(mask, cpu_online_or_slave_mask);
 	while (cpu < nr_cpu_ids) {
 		int new_cpu, vector, offset;
 
@@ -1158,14 +1158,14 @@ next:
 		if (unlikely(current_vector == vector)) {
 			cpumask_or(cfg->old_domain, cfg->old_domain, tmp_mask);
 			cpumask_andnot(tmp_mask, mask, cfg->old_domain);
-			cpu = cpumask_first_and(tmp_mask, cpu_online_mask);
+			cpu = cpumask_first_and(tmp_mask, cpu_online_or_slave_mask);
 			continue;
 		}
 
 		if (test_bit(vector, used_vectors))
 			goto next;
 
-		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
+		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_or_slave_mask)
 			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
 				goto next;
 		/* Found one! */
@@ -1175,7 +1175,7 @@ next:
 			cfg->move_in_progress = 1;
 			cpumask_copy(cfg->old_domain, cfg->domain);
 		}
-		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
+		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_or_slave_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		cfg->vector = vector;
 		cpumask_copy(cfg->domain, tmp_mask);
@@ -1204,7 +1204,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 	BUG_ON(!cfg->vector);
 
 	vector = cfg->vector;
-	for_each_cpu_and(cpu, cfg->domain, cpu_online_mask)
+	for_each_cpu_and(cpu, cfg->domain, cpu_online_or_slave_mask)
 		per_cpu(vector_irq, cpu)[vector] = -1;
 
 	cfg->vector = 0;
@@ -1212,7 +1212,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 
 	if (likely(!cfg->move_in_progress))
 		return;
-	for_each_cpu_and(cpu, cfg->old_domain, cpu_online_mask) {
+	for_each_cpu_and(cpu, cfg->old_domain, cpu_online_or_slave_mask) {
 		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
 								vector++) {
 			if (per_cpu(vector_irq, cpu)[vector] != irq)
@@ -2354,28 +2354,47 @@ int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 {
 	struct irq_cfg *cfg = data->chip_data;
 	unsigned int irq = data->irq;
+	cpumask_var_t new_mask;
+	bool mask_ok = false;
 	int err;
 
 	if (!config_enabled(CONFIG_SMP))
 		return -1;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
+	if (!cpumask_intersects(mask, cpu_online_or_slave_mask))
 		return -EINVAL;
 
+#ifdef CONFIG_SLAVE_CPU
+	/* Set affinity to either online cpus or slave cpus */
+	mask_ok = alloc_cpumask_var(&new_mask, GFP_ATOMIC);
+	if (mask_ok) {
+		cpumask_and(new_mask, mask, cpu_online_mask);
+		if (cpumask_empty(new_mask))
+			cpumask_copy(new_mask, mask);
+		err = assign_irq_vector(irq, cfg, new_mask);
+	} else if (!cpumask_intersects(mask, cpu_online_mask) ||
+		   !cpumask_intersects(mask, cpu_slave_mask))
+		err = assign_irq_vector(irq, cfg, mask);
+	else
+		return -ENOMEM;
+#else
 	err = assign_irq_vector(irq, cfg, mask);
+#endif
 	if (err)
-		return err;
+		goto error;
 
 	err = apic->cpu_mask_to_apicid_and(mask, cfg->domain, dest_id);
 	if (err) {
 		if (assign_irq_vector(irq, cfg, data->affinity))
 			pr_err("Failed to recover vector for irq %d\n", irq);
-		return err;
+		goto error;
 	}
 
-	cpumask_copy(data->affinity, mask);
-
-	return 0;
+	cpumask_copy(data->affinity, mask_ok ? new_mask : mask);
+error:
+	if (mask_ok)
+		free_cpumask_var(new_mask);
+	return err;
 }
 
 static int
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index c88baa4..7403e1e 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -106,7 +106,7 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	int i;
 
 	for_each_cpu_and(i, cpumask, andmask) {
-		if (!cpumask_test_cpu(i, cpu_online_mask))
+		if (!cpumask_test_cpu(i, cpu_online_or_slave_mask))
 			continue;
 		dest = per_cpu(x86_cpu_to_logical_apicid, i);
 		cluster = x2apic_cluster(i);
@@ -117,7 +117,7 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 		return -EINVAL;
 
 	for_each_cpu_and(i, cpumask, andmask) {
-		if (!cpumask_test_cpu(i, cpu_online_mask))
+		if (!cpumask_test_cpu(i, cpu_online_or_slave_mask))
 			continue;
 		if (cluster != x2apic_cluster(i))
 			continue;
@@ -137,7 +137,7 @@ static void init_x2apic_ldr(void)
 	per_cpu(x86_cpu_to_logical_apicid, this_cpu) = apic_read(APIC_LDR);
 
 	__cpu_set(this_cpu, per_cpu(cpus_in_cluster, this_cpu));
-	for_each_online_cpu(cpu) {
+	for_each_cpu(cpu, cpu_online_or_slave_mask) {
 		if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
 			continue;
 		__cpu_set(this_cpu, per_cpu(cpus_in_cluster, cpu));
@@ -169,7 +169,7 @@ update_clusterinfo(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
-		for_each_online_cpu(cpu) {
+		for_each_cpu(cpu, cpu_online_or_slave_mask) {
 			if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
 				continue;
 			__cpu_clear(this_cpu, per_cpu(cpus_in_cluster, cpu));
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index af8904d..df38334 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -931,26 +931,43 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	struct irq_cfg *cfg = data->chip_data;
 	unsigned int dest, irq = data->irq;
 	struct irte irte;
+	cpumask_var_t new_mask;
+	bool mask_ok = false;
 	int err;
 
 	if (!config_enabled(CONFIG_SMP))
 		return -EINVAL;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
+	if (!cpumask_intersects(mask, cpu_online_or_slave_mask))
 		return -EINVAL;
 
 	if (get_irte(irq, &irte))
 		return -EBUSY;
 
+#ifdef CONFIG_SLAVE_CPU
+	/* Set affinity to either online cpus only or slave cpus only */
+	mask_ok = alloc_cpumask_var(&new_mask, GFP_ATOMIC);
+	if (mask_ok) {
+		cpumask_and(new_mask, mask, cpu_online_mask);
+		if (cpumask_empty(new_mask))
+			cpumask_copy(new_mask, mask);
+		err = assign_irq_vector(irq, cfg, new_mask);
+	} else if (!cpumask_intersects(mask, cpu_online_mask) ||
+		   !cpumask_intersects(mask, cpu_slave_mask))
+		err = assign_irq_vector(irq, cfg, mask);
+	else
+		return -ENOMEM;
+#else
 	err = assign_irq_vector(irq, cfg, mask);
+#endif
 	if (err)
-		return err;
+		goto error;
 
 	err = apic->cpu_mask_to_apicid_and(cfg->domain, mask, &dest);
 	if (err) {
 		if (assign_irq_vector(irq, cfg, data->affinity))
 			pr_err("Failed to recover vector for irq %d\n", irq);
-		return err;
+		goto error;
 	}
 
 	irte.vector = cfg->vector;
@@ -970,8 +987,11 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
 
-	cpumask_copy(data->affinity, mask);
-	return 0;
+	cpumask_copy(data->affinity, mask_ok ? new_mask : mask);
+error:
+	if (mask_ok)
+		free_cpumask_var(new_mask);
+	return err;
 }
 
 static void intel_compose_msi_msg(struct pci_dev *pdev,
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 4c69326..dafe0505 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -308,13 +308,13 @@ setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 	 */
 	if (irqd_has_set(&desc->irq_data, IRQD_AFFINITY_SET)) {
 		if (cpumask_intersects(desc->irq_data.affinity,
-				       cpu_online_mask))
+				       cpu_online_or_slave_mask))
 			set = desc->irq_data.affinity;
 		else
 			irqd_clear(&desc->irq_data, IRQD_AFFINITY_SET);
 	}
 
-	cpumask_and(mask, cpu_online_mask, set);
+	cpumask_and(mask, cpu_online_or_slave_mask, set);
 	if (node != NUMA_NO_NODE) {
 		const struct cpumask *nodemask = cpumask_of_node(node);
 
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index ca3f4aa..6e3aaa9 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -42,7 +42,7 @@ void irq_move_masked_irq(struct irq_data *idata)
 	 * For correct operation this depends on the caller
 	 * masking the irqs.
 	 */
-	if (cpumask_any_and(desc->pending_mask, cpu_online_mask) < nr_cpu_ids)
+	if (cpumask_any_and(desc->pending_mask, cpu_online_or_slave_mask) < nr_cpu_ids)
 		irq_do_set_affinity(&desc->irq_data, desc->pending_mask, false);
 
 	cpumask_clear(desc->pending_mask);
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 4bd4faa..76bd7b2 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -103,7 +103,7 @@ static ssize_t write_irq_affinity(int type, struct file *file,
 	 * way to make the system unusable accidentally :-) At least
 	 * one online CPU still has to be targeted.
 	 */
-	if (!cpumask_intersects(new_value, cpu_online_mask)) {
+	if (!cpumask_intersects(new_value, cpu_online_or_slave_mask)) {
 		/* Special case for empty set - allow the architecture
 		   code to set default SMP affinity. */
 		err = irq_select_affinity_usr(irq, new_value) ? -EINVAL : count;


