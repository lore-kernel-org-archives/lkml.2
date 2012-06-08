Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828Ab2FHOwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:52:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59621 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab2FHOwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:52:11 -0400
Date: Fri, 8 Jun 2012 07:51:56 -0700
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-ff164324123c0fe181d8de7dadcc7b3fbe25f2cf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@kernel.org, yinghai@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20120607131559.GF4759@dhcp-26-207.brq.redhat.com>
References: <20120607131559.GF4759@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Make cpu_mask_to_apicid()
  operations return error code
Git-Commit-ID: ff164324123c0fe181d8de7dadcc7b3fbe25f2cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 08 Jun 2012 07:52:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff164324123c0fe181d8de7dadcc7b3fbe25f2cf
Gitweb:     http://git.kernel.org/tip/ff164324123c0fe181d8de7dadcc7b3fbe25f2cf
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Thu, 7 Jun 2012 15:15:59 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 8 Jun 2012 11:44:29 +0200

x86/apic: Make cpu_mask_to_apicid() operations return error code

Current cpu_mask_to_apicid() and cpu_mask_to_apicid_and()
implementations have few shortcomings:

1. A value returned by cpu_mask_to_apicid() is written to
hardware registers unconditionally. Should BAD_APICID get ever
returned it will be written to a hardware too. But the value of
BAD_APICID is not universal across all hardware in all modes and
might cause unexpected results, i.e. interrupts might get routed
to CPUs that are not configured to receive it.

2. Because the value of BAD_APICID is not universal it is
counter- intuitive to return it for a hardware where it does not
make sense (i.e. x2apic).

3. cpu_mask_to_apicid_and() operation is thought as an
complement to cpu_mask_to_apicid() that only applies a AND mask
on top of a cpumask being passed. Yet, as consequence of 18374d8
commit the two operations are inconsistent in that of:
  cpu_mask_to_apicid() should not get a offline CPU with the cpumask
  cpu_mask_to_apicid_and() should not fail and return BAD_APICID
These limitations are impossible to realize just from looking at
the operations prototypes.

Most of these shortcomings are resolved by returning a error
code instead of BAD_APICID. As the result, faults are reported
back early rather than possibilities to cause a unexpected
behaviour exist (in case of [1]).

The only exception is setup_timer_IRQ0_pin() routine. Although
obviously controversial to this fix, its existing behaviour is
preserved to not break the fragile check_timer() and would
better addressed in a separate fix.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/20120607131559.GF4759@dhcp-26-207.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/apic.h           |   44 ++++++++++++-----
 arch/x86/kernel/apic/apic.c           |   33 +++++++------
 arch/x86/kernel/apic/es7000_32.c      |   21 +++++---
 arch/x86/kernel/apic/io_apic.c        |   88 +++++++++++++++++++++------------
 arch/x86/kernel/apic/numaq_32.c       |   14 +++--
 arch/x86/kernel/apic/summit_32.c      |   22 +++++---
 arch/x86/kernel/apic/x2apic_cluster.c |   24 +++++----
 arch/x86/kernel/apic/x2apic_uv_x.c    |   27 +++++++---
 arch/x86/platform/uv/uv_irq.c         |    7 ++-
 drivers/iommu/intel_irq_remapping.c   |   13 ++++-
 10 files changed, 188 insertions(+), 105 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index e3fecd5..ae91f9c 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -331,9 +331,11 @@ struct apic {
 	unsigned long (*set_apic_id)(unsigned int id);
 	unsigned long apic_id_mask;
 
-	unsigned int (*cpu_mask_to_apicid)(const struct cpumask *cpumask);
-	unsigned int (*cpu_mask_to_apicid_and)(const struct cpumask *cpumask,
-					       const struct cpumask *andmask);
+	int (*cpu_mask_to_apicid)(const struct cpumask *cpumask,
+				  unsigned int *apicid);
+	int (*cpu_mask_to_apicid_and)(const struct cpumask *cpumask,
+				      const struct cpumask *andmask,
+				      unsigned int *apicid);
 
 	/* ipi */
 	void (*send_IPI_mask)(const struct cpumask *mask, int vector);
@@ -591,29 +593,45 @@ static inline int default_phys_pkg_id(int cpuid_apic, int index_msb)
 
 #endif
 
-static inline unsigned int
-flat_cpu_mask_to_apicid(const struct cpumask *cpumask)
+static inline int
+__flat_cpu_mask_to_apicid(unsigned long cpu_mask, unsigned int *apicid)
 {
-	return cpumask_bits(cpumask)[0] & APIC_ALL_CPUS;
+	cpu_mask &= APIC_ALL_CPUS;
+	if (likely(cpu_mask)) {
+		*apicid = (unsigned int)cpu_mask;
+		return 0;
+	} else {
+		return -EINVAL;
+	}
 }
 
-static inline unsigned int
+static inline int
+flat_cpu_mask_to_apicid(const struct cpumask *cpumask,
+			unsigned int *apicid)
+{
+	return __flat_cpu_mask_to_apicid(cpumask_bits(cpumask)[0], apicid);
+}
+
+static inline int
 flat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-			    const struct cpumask *andmask)
+			    const struct cpumask *andmask,
+			    unsigned int *apicid)
 {
 	unsigned long mask1 = cpumask_bits(cpumask)[0];
 	unsigned long mask2 = cpumask_bits(andmask)[0];
 	unsigned long mask3 = cpumask_bits(cpu_online_mask)[0];
 
-	return (unsigned int)(mask1 & mask2 & mask3);
+	return __flat_cpu_mask_to_apicid(mask1 & mask2 & mask3, apicid);
 }
 
-extern unsigned int
-default_cpu_mask_to_apicid(const struct cpumask *cpumask);
+extern int
+default_cpu_mask_to_apicid(const struct cpumask *cpumask,
+			   unsigned int *apicid);
 
-extern unsigned int
+extern int
 default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-			       const struct cpumask *andmask);
+			       const struct cpumask *andmask,
+			       unsigned int *apicid);
 
 static inline bool
 flat_vector_allocation_domain(int cpu, struct cpumask *retmask)
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 96a2608..b8d9260 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2123,24 +2123,26 @@ void default_init_apic_ldr(void)
 	apic_write(APIC_LDR, val);
 }
 
-unsigned int default_cpu_mask_to_apicid(const struct cpumask *cpumask)
+static inline int __default_cpu_to_apicid(int cpu, unsigned int *apicid)
 {
-	int cpu;
-
-	/*
-	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
-	 * May as well be the first.
-	 */
-	cpu = cpumask_first(cpumask);
-	if (likely((unsigned)cpu < nr_cpu_ids))
-		return per_cpu(x86_cpu_to_apicid, cpu);
+	if (likely((unsigned int)cpu < nr_cpu_ids)) {
+		*apicid = per_cpu(x86_cpu_to_apicid, cpu);
+		return 0;
+	} else {
+		return -EINVAL;
+	}
+}
 
-	return BAD_APICID;
+int default_cpu_mask_to_apicid(const struct cpumask *cpumask,
+			       unsigned int *apicid)
+{
+	int cpu = cpumask_first(cpumask);
+	return __default_cpu_to_apicid(cpu, apicid);
 }
 
-unsigned int
-default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-			       const struct cpumask *andmask)
+int default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+				   const struct cpumask *andmask,
+				   unsigned int *apicid)
 {
 	int cpu;
 
@@ -2148,7 +2150,8 @@ default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
 	}
-	return per_cpu(x86_cpu_to_apicid, cpu);
+
+	return __default_cpu_to_apicid(cpu, apicid);
 }
 
 /*
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 3c42865..515ebb0 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -525,7 +525,8 @@ static int es7000_check_phys_apicid_present(int cpu_physical_apicid)
 	return 1;
 }
 
-static unsigned int es7000_cpu_mask_to_apicid(const struct cpumask *cpumask)
+static int
+es7000_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *dest_id)
 {
 	unsigned int round = 0;
 	int cpu, uninitialized_var(apicid);
@@ -539,31 +540,33 @@ static unsigned int es7000_cpu_mask_to_apicid(const struct cpumask *cpumask)
 		if (round && APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
 			WARN(1, "Not a valid mask!");
 
-			return BAD_APICID;
+			return -EINVAL;
 		}
 		apicid = new_apicid;
 		round++;
 	}
-	return apicid;
+	*dest_id = apicid;
+	return 0;
 }
 
-static unsigned int
+static int
 es7000_cpu_mask_to_apicid_and(const struct cpumask *inmask,
-			      const struct cpumask *andmask)
+			      const struct cpumask *andmask,
+			      unsigned int *apicid)
 {
-	int apicid = early_per_cpu(x86_cpu_to_logical_apicid, 0);
+	*apicid = early_per_cpu(x86_cpu_to_logical_apicid, 0);
 	cpumask_var_t cpumask;
 
 	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
-		return apicid;
+		return 0;
 
 	cpumask_and(cpumask, inmask, andmask);
 	cpumask_and(cpumask, cpumask, cpu_online_mask);
-	apicid = es7000_cpu_mask_to_apicid(cpumask);
+	es7000_cpu_mask_to_apicid(cpumask, apicid);
 
 	free_cpumask_var(cpumask);
 
-	return apicid;
+	return 0;
 }
 
 static int es7000_phys_pkg_id(int cpuid_apic, int index_msb)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4061a7d..0deb773 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1359,7 +1359,14 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
 		return;
 
-	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
+	if (apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus(),
+					 &dest)) {
+		pr_warn("Failed to obtain apicid for ioapic %d, pin %d\n",
+			mpc_ioapic_id(attr->ioapic), attr->ioapic_pin);
+		__clear_irq_vector(irq, cfg);
+
+		return;
+	}
 
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
@@ -1474,6 +1481,7 @@ static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
 					unsigned int pin, int vector)
 {
 	struct IO_APIC_route_entry entry;
+	unsigned int dest;
 
 	if (irq_remapping_enabled)
 		return;
@@ -1484,9 +1492,12 @@ static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
 	 * We use logical delivery to get the timer IRQ
 	 * to the first CPU.
 	 */
+	if (unlikely(apic->cpu_mask_to_apicid(apic->target_cpus(), &dest)))
+		dest = BAD_APICID;
+
 	entry.dest_mode = apic->irq_dest_mode;
 	entry.mask = 0;			/* don't mask IRQ for edge */
-	entry.dest = apic->cpu_mask_to_apicid(apic->target_cpus());
+	entry.dest = dest;
 	entry.delivery_mode = apic->irq_delivery_mode;
 	entry.polarity = 0;
 	entry.trigger = 0;
@@ -2245,16 +2256,25 @@ int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			  unsigned int *dest_id)
 {
 	struct irq_cfg *cfg = data->chip_data;
+	unsigned int irq = data->irq;
+	int err;
 
 	if (!cpumask_intersects(mask, cpu_online_mask))
-		return -1;
+		return -EINVAL;
 
-	if (assign_irq_vector(data->irq, data->chip_data, mask))
-		return -1;
+	err = assign_irq_vector(irq, cfg, mask);
+	if (err)
+		return err;
+
+	err = apic->cpu_mask_to_apicid_and(mask, cfg->domain, dest_id);
+	if (err) {
+		if (assign_irq_vector(irq, cfg, data->affinity))
+			pr_err("Failed to recover vector for irq %d\n", irq);
+		return err;
+	}
 
 	cpumask_copy(data->affinity, mask);
 
-	*dest_id = apic->cpu_mask_to_apicid_and(mask, cfg->domain);
 	return 0;
 }
 
@@ -3040,7 +3060,10 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 	if (err)
 		return err;
 
-	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
+	err = apic->cpu_mask_to_apicid_and(cfg->domain,
+					   apic->target_cpus(), &dest);
+	if (err)
+		return err;
 
 	if (irq_remapped(cfg)) {
 		compose_remapped_msi_msg(pdev, irq, dest, msg, hpet_id);
@@ -3361,6 +3384,8 @@ static struct irq_chip ht_irq_chip = {
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 {
 	struct irq_cfg *cfg;
+	struct ht_irq_msg msg;
+	unsigned dest;
 	int err;
 
 	if (disable_apic)
@@ -3368,36 +3393,37 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 
 	cfg = irq_cfg(irq);
 	err = assign_irq_vector(irq, cfg, apic->target_cpus());
-	if (!err) {
-		struct ht_irq_msg msg;
-		unsigned dest;
+	if (err)
+		return err;
 
-		dest = apic->cpu_mask_to_apicid_and(cfg->domain,
-						    apic->target_cpus());
+	err = apic->cpu_mask_to_apicid_and(cfg->domain,
+					   apic->target_cpus(), &dest);
+	if (err)
+		return err;
 
-		msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
+	msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
 
-		msg.address_lo =
-			HT_IRQ_LOW_BASE |
-			HT_IRQ_LOW_DEST_ID(dest) |
-			HT_IRQ_LOW_VECTOR(cfg->vector) |
-			((apic->irq_dest_mode == 0) ?
-				HT_IRQ_LOW_DM_PHYSICAL :
-				HT_IRQ_LOW_DM_LOGICAL) |
-			HT_IRQ_LOW_RQEOI_EDGE |
-			((apic->irq_delivery_mode != dest_LowestPrio) ?
-				HT_IRQ_LOW_MT_FIXED :
-				HT_IRQ_LOW_MT_ARBITRATED) |
-			HT_IRQ_LOW_IRQ_MASKED;
+	msg.address_lo =
+		HT_IRQ_LOW_BASE |
+		HT_IRQ_LOW_DEST_ID(dest) |
+		HT_IRQ_LOW_VECTOR(cfg->vector) |
+		((apic->irq_dest_mode == 0) ?
+			HT_IRQ_LOW_DM_PHYSICAL :
+			HT_IRQ_LOW_DM_LOGICAL) |
+		HT_IRQ_LOW_RQEOI_EDGE |
+		((apic->irq_delivery_mode != dest_LowestPrio) ?
+			HT_IRQ_LOW_MT_FIXED :
+			HT_IRQ_LOW_MT_ARBITRATED) |
+		HT_IRQ_LOW_IRQ_MASKED;
 
-		write_ht_irq_msg(irq, &msg);
+	write_ht_irq_msg(irq, &msg);
 
-		irq_set_chip_and_handler_name(irq, &ht_irq_chip,
-					      handle_edge_irq, "edge");
+	irq_set_chip_and_handler_name(irq, &ht_irq_chip,
+				      handle_edge_irq, "edge");
 
-		dev_printk(KERN_DEBUG, &dev->dev, "irq %d for HT\n", irq);
-	}
-	return err;
+	dev_printk(KERN_DEBUG, &dev->dev, "irq %d for HT\n", irq);
+
+	return 0;
 }
 #endif /* CONFIG_HT_IRQ */
 
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index eb2d466..2b55514 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -406,16 +406,20 @@ static inline int numaq_check_phys_apicid_present(int phys_apicid)
  * We use physical apicids here, not logical, so just return the default
  * physical broadcast to stop people from breaking us
  */
-static unsigned int numaq_cpu_mask_to_apicid(const struct cpumask *cpumask)
+static int
+numaq_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *apicid)
 {
-	return 0x0F;
+	*apicid = 0x0F;
+	return 0;
 }
 
-static inline unsigned int
+static int
 numaq_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-			     const struct cpumask *andmask)
+			     const struct cpumask *andmask,
+			     unsigned int *apicid)
 {
-	return 0x0F;
+	*apicid = 0x0F;
+	return 0;
 }
 
 /* No NUMA-Q box has a HT CPU, but it can't hurt to use the default code. */
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 35d254c..5766d84 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -263,7 +263,8 @@ static int summit_check_phys_apicid_present(int physical_apicid)
 	return 1;
 }
 
-static unsigned int summit_cpu_mask_to_apicid(const struct cpumask *cpumask)
+static int
+summit_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *dest_id)
 {
 	unsigned int round = 0;
 	int cpu, apicid = 0;
@@ -276,30 +277,33 @@ static unsigned int summit_cpu_mask_to_apicid(const struct cpumask *cpumask)
 
 		if (round && APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
 			printk("%s: Not a valid mask!\n", __func__);
-			return BAD_APICID;
+			return -EINVAL;
 		}
 		apicid |= new_apicid;
 		round++;
 	}
-	return apicid;
+	*dest_id = apicid;
+	return 0;
 }
 
-static unsigned int summit_cpu_mask_to_apicid_and(const struct cpumask *inmask,
-			      const struct cpumask *andmask)
+static int
+summit_cpu_mask_to_apicid_and(const struct cpumask *inmask,
+			      const struct cpumask *andmask,
+			      unsigned int *apicid)
 {
-	int apicid = early_per_cpu(x86_cpu_to_logical_apicid, 0);
+	*apicid = early_per_cpu(x86_cpu_to_logical_apicid, 0);
 	cpumask_var_t cpumask;
 
 	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
-		return apicid;
+		return 0;
 
 	cpumask_and(cpumask, inmask, andmask);
 	cpumask_and(cpumask, cpumask, cpu_online_mask);
-	apicid = summit_cpu_mask_to_apicid(cpumask);
+	summit_cpu_mask_to_apicid(cpumask, apicid);
 
 	free_cpumask_var(cpumask);
 
-	return apicid;
+	return 0;
 }
 
 /*
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 612622c..5f86f79 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -96,24 +96,26 @@ static void x2apic_send_IPI_all(int vector)
 	__x2apic_send_IPI_mask(cpu_online_mask, vector, APIC_DEST_ALLINC);
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
+static int
+x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *apicid)
 {
 	int cpu = cpumask_first(cpumask);
-	u32 dest = 0;
 	int i;
 
-	if (cpu > nr_cpu_ids)
-		return BAD_APICID;
+	if (cpu >= nr_cpu_ids)
+		return -EINVAL;
 
+	*apicid = 0;
 	for_each_cpu_and(i, cpumask, per_cpu(cpus_in_cluster, cpu))
-		dest |= per_cpu(x86_cpu_to_logical_apicid, i);
+		*apicid |= per_cpu(x86_cpu_to_logical_apicid, i);
 
-	return dest;
+	return 0;
 }
 
-static unsigned int
+static int
 x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-			      const struct cpumask *andmask)
+			      const struct cpumask *andmask,
+			      unsigned int *apicid)
 {
 	u32 dest = 0;
 	u16 cluster;
@@ -128,7 +130,7 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	}
 
 	if (!dest)
-		return BAD_APICID;
+		return -EINVAL;
 
 	for_each_cpu_and(i, cpumask, andmask) {
 		if (!cpumask_test_cpu(i, cpu_online_mask))
@@ -138,7 +140,9 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 		dest |= per_cpu(x86_cpu_to_logical_apicid, i);
 	}
 
-	return dest;
+	*apicid = dest;
+
+	return 0;
 }
 
 static void init_x2apic_ldr(void)
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index df89a7d..2f3030f 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -269,23 +269,31 @@ static void uv_init_apic_ldr(void)
 {
 }
 
-static unsigned int uv_cpu_mask_to_apicid(const struct cpumask *cpumask)
+static inline int __uv_cpu_to_apicid(int cpu, unsigned int *apicid)
+{
+	if (likely((unsigned int)cpu < nr_cpu_ids)) {
+		*apicid = per_cpu(x86_cpu_to_apicid, cpu) | uv_apicid_hibits;
+		return 0;
+	} else {
+		return -EINVAL;
+	}
+}
+
+static int
+uv_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *apicid)
 {
 	/*
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
 	int cpu = cpumask_first(cpumask);
-
-	if ((unsigned)cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_apicid, cpu) | uv_apicid_hibits;
-	else
-		return BAD_APICID;
+	return __uv_cpu_to_apicid(cpu, apicid);
 }
 
-static unsigned int
+static int
 uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-			  const struct cpumask *andmask)
+			  const struct cpumask *andmask,
+			  unsigned int *apicid)
 {
 	int cpu;
 
@@ -297,7 +305,8 @@ uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
 	}
-	return per_cpu(x86_cpu_to_apicid, cpu) | uv_apicid_hibits;
+
+	return __uv_cpu_to_apicid(cpu, apicid);
 }
 
 static unsigned int x2apic_get_apic_id(unsigned long x)
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index f25c276..dd1ff39 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -135,6 +135,7 @@ arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	unsigned long mmr_value;
 	struct uv_IO_APIC_route_entry *entry;
 	int mmr_pnode, err;
+	unsigned int dest;
 
 	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) !=
 			sizeof(unsigned long));
@@ -143,6 +144,10 @@ arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	if (err != 0)
 		return err;
 
+	err = apic->cpu_mask_to_apicid(eligible_cpu, &dest);
+	if (err != 0)
+		return err;
+
 	if (limit == UV_AFFINITY_CPU)
 		irq_set_status_flags(irq, IRQ_NO_BALANCING);
 	else
@@ -159,7 +164,7 @@ arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	entry->polarity		= 0;
 	entry->trigger		= 0;
 	entry->mask		= 0;
-	entry->dest		= apic->cpu_mask_to_apicid(eligible_cpu);
+	entry->dest		= dest;
 
 	mmr_pnode = uv_blade_to_pnode(mmr_blade);
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 6d34706..dafbad0 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -924,6 +924,7 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	struct irq_cfg *cfg = data->chip_data;
 	unsigned int dest, irq = data->irq;
 	struct irte irte;
+	int err;
 
 	if (!cpumask_intersects(mask, cpu_online_mask))
 		return -EINVAL;
@@ -931,10 +932,16 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	if (get_irte(irq, &irte))
 		return -EBUSY;
 
-	if (assign_irq_vector(irq, cfg, mask))
-		return -EBUSY;
+	err = assign_irq_vector(irq, cfg, mask);
+	if (err)
+		return err;
 
-	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
+	err = apic->cpu_mask_to_apicid_and(cfg->domain, mask, &dest);
+	if (err) {
+		if (assign_irq_vector(irq, cfg, data->affinity));
+			pr_err("Failed to recover vector for irq %d\n", irq);
+		return err;
+	}
 
 	irte.vector = cfg->vector;
 	irte.dest_id = IRTE_DEST(dest);
