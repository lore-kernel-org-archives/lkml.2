Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab2F1GIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:08:48 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51513 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562Ab2F1GIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:08:42 -0400
X-AuditID: b753bd60-90ac1ba0000047ca-48-4febf4dd9858
X-AuditID: b753bd60-90ac1ba0000047ca-48-4febf4dd9858
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC PATCH 12/18] x86/apic: Enable external interrupt routing to
 slave CPUs
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 28 Jun 2012 15:08:22 +0900
Message-ID: <20120628060822.19298.65525.stgit@localhost.localdomain>
In-Reply-To: <20120628060719.19298.43879.stgit@localhost.localdomain>
References: <20120628060719.19298.43879.stgit@localhost.localdomain>
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

 arch/x86/include/asm/apic.h           |    4 ++--
 arch/x86/kernel/apic/apic_flat_64.c   |    2 +-
 arch/x86/kernel/apic/io_apic.c        |   21 ++++++++++++---------
 arch/x86/kernel/apic/x2apic_cluster.c |    6 +++---
 arch/x86/kernel/apic/x2apic_phys.c    |    2 +-
 drivers/iommu/intel_irq_remapping.c   |    2 +-
 kernel/irq/manage.c                   |    4 ++--
 kernel/irq/migration.c                |    2 +-
 kernel/irq/proc.c                     |    2 +-
 9 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index eaff479..706c4cd 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -531,7 +531,7 @@ extern void generic_bigsmp_probe(void);
 static inline const struct cpumask *default_target_cpus(void)
 {
 #ifdef CONFIG_SMP
-	return cpu_online_mask;
+	return cpu_online_or_slave_mask;
 #else
 	return cpumask_of(0);
 #endif
@@ -598,7 +598,7 @@ default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 {
 	unsigned long mask1 = cpumask_bits(cpumask)[0];
 	unsigned long mask2 = cpumask_bits(andmask)[0];
-	unsigned long mask3 = cpumask_bits(cpu_online_mask)[0];
+	unsigned long mask3 = cpumask_bits(cpu_online_or_slave_mask)[0];
 
 	return (unsigned int)(mask1 & mask2 & mask3);
 }
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 0e881c4..e0836e9 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -38,7 +38,7 @@ static int flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 
 static const struct cpumask *flat_target_cpus(void)
 {
-	return cpu_online_mask;
+	return cpu_online_or_slave_mask;
 }
 
 static void flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 5f0ff59..91b3905 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1125,7 +1125,7 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 
 	old_vector = cfg->vector;
 	if (old_vector) {
-		cpumask_and(tmp_mask, mask, cpu_online_mask);
+		cpumask_and(tmp_mask, mask, cpu_online_or_slave_mask);
 		cpumask_and(tmp_mask, cfg->domain, tmp_mask);
 		if (!cpumask_empty(tmp_mask)) {
 			free_cpumask_var(tmp_mask);
@@ -1135,7 +1135,7 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 
 	/* Only try and allocate irqs on cpus that are present */
 	err = -ENOSPC;
-	for_each_cpu_and(cpu, mask, cpu_online_mask) {
+	for_each_cpu_and(cpu, mask, cpu_online_or_slave_mask) {
 		int new_cpu;
 		int vector, offset;
 
@@ -1156,7 +1156,7 @@ next:
 		if (test_bit(vector, used_vectors))
 			goto next;
 
-		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
+		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_or_slave_mask)
 			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
 				goto next;
 		/* Found one! */
@@ -1166,7 +1166,7 @@ next:
 			cfg->move_in_progress = 1;
 			cpumask_copy(cfg->old_domain, cfg->domain);
 		}
-		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
+		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_or_slave_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		cfg->vector = vector;
 		cpumask_copy(cfg->domain, tmp_mask);
@@ -2200,10 +2200,10 @@ void send_cleanup_vector(struct irq_cfg *cfg)
 
 	if (unlikely(!alloc_cpumask_var(&cleanup_mask, GFP_ATOMIC))) {
 		unsigned int i;
-		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
+		for_each_cpu_and(i, cfg->old_domain, cpu_online_or_slave_mask)
 			apic->send_IPI_mask(cpumask_of(i), IRQ_MOVE_CLEANUP_VECTOR);
 	} else {
-		cpumask_and(cleanup_mask, cfg->old_domain, cpu_online_mask);
+		cpumask_and(cleanup_mask, cfg->old_domain, cpu_online_or_slave_mask);
 		apic->send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
 		free_cpumask_var(cleanup_mask);
 	}
@@ -2244,15 +2244,18 @@ int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 {
 	struct irq_cfg *cfg = data->chip_data;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
+	if (!cpumask_intersects(mask, cpu_online_or_slave_mask))
 		return -1;
 
 	if (assign_irq_vector(data->irq, data->chip_data, mask))
 		return -1;
 
-	cpumask_copy(data->affinity, mask);
+	/* Set affinity to either online cpus only or slave cpus only */
+	cpumask_and(data->affinity, mask, cpu_online_mask);
+	if (unlikely(cpumask_empty(data->affinity)))
+		cpumask_copy(data->affinity, mask);
 
-	*dest_id = apic->cpu_mask_to_apicid_and(mask, cfg->domain);
+	*dest_id = apic->cpu_mask_to_apicid_and(data->affinity, cfg->domain);
 	return 0;
 }
 
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index ff35cff..0a4d8af 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -121,7 +121,7 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	 * May as well be the first.
 	 */
 	for_each_cpu_and(cpu, cpumask, andmask) {
-		if (cpumask_test_cpu(cpu, cpu_online_mask))
+		if (cpumask_test_cpu(cpu, cpu_online_or_slave_mask))
 			break;
 	}
 
@@ -136,7 +136,7 @@ static void init_x2apic_ldr(void)
 	per_cpu(x86_cpu_to_logical_apicid, this_cpu) = apic_read(APIC_LDR);
 
 	__cpu_set(this_cpu, per_cpu(cpus_in_cluster, this_cpu));
-	for_each_online_cpu(cpu) {
+	for_each_cpu(cpu, cpu_online_or_slave_mask) {
 		if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
 			continue;
 		__cpu_set(this_cpu, per_cpu(cpus_in_cluster, cpu));
@@ -168,7 +168,7 @@ update_clusterinfo(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
-		for_each_online_cpu(cpu) {
+		for_each_cpu(cpu, cpu_online_or_slave_mask) {
 			if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
 				continue;
 			__cpu_clear(this_cpu, per_cpu(cpus_in_cluster, cpu));
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index c17e982..d4ac67e 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -101,7 +101,7 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	 * May as well be the first.
 	 */
 	for_each_cpu_and(cpu, cpumask, andmask) {
-		if (cpumask_test_cpu(cpu, cpu_online_mask))
+		if (cpumask_test_cpu(cpu, cpu_online_or_slave_mask))
 			break;
 	}
 
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 6d34706..0045139 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -925,7 +925,7 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	unsigned int dest, irq = data->irq;
 	struct irte irte;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
+	if (!cpumask_intersects(mask, cpu_online_or_slave_mask))
 		return -EINVAL;
 
 	if (get_irte(irq, &irte))
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 8c54823..73e5fd8 100644
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


