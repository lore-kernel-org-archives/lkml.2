Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181Ab0CSL1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 07:27:45 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:50272 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab0CSL1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 07:27:42 -0400
X-IronPort-AV: E=Sophos;i="4.51,273,1267419600"; 
   d="scan'208";a="88757703"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yinghai@kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       lguest@ozlabs.org, Paul Mundt <lethal@linux-sh.org>,
       linux-sh@vger.kernel.org
Subject: [PATCH 1/2] irq: move some interrupt arch_* functions into struct irq_chip.
Date: Fri, 19 Mar 2010 11:27:20 +0000
Message-Id: <1268998041-22707-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1268998032.10129.44653.camel@zakaz.uk.xensource.com>
References: <1268998032.10129.44653.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 19 Mar 2010 11:27:40.0181 (UTC) FILETIME=[2F38BC50:01CAC757]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move arch_init_copy_chip_data and arch_free_chip_data into function
pointers in struct irq_chip since they operate on irq_desc->chip_data.

arch_init_chip_data cannot be moved into struct irq_chip because
irq_desc->chip is not known at the time the irq_desc is setup. Instead
rename arch_init_chip_data to arch_init_irq_desc for PowerPC, the
only other user, whose usage better matches the new name.

To replace the x86 arch_init_chip_data functionality
irq_to_desc_alloc_node now takes a pointer to a function to allocate
the chip data. This is necessary to ensure the allocation happens
under the correct locking at the core level. On PowerPC and SH
architectures (the other users of irq_to_desc_alloc_node) pass in NULL
which retains existing chip_data behaviour.

I've retained the chip_data behaviour for uv_irq although it isn't
clear to me if these interrupt types support migration or how closely
related to the APIC modes they really are. If it weren't for this the
x86_{init,copy,free}_chip_data functions could be static to
io_apic.c.

I've tested by booting on an 64 bit x86 system with sparse IRQ enabled
and 32 bit without, but it's not clear to me what actions I need to
take to actually exercise some of these code paths.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Michael Ellerman <michael@ellerman.id.au> [PowerPC rename portion]
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: x86@kernel.org
Cc: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest@ozlabs.org
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
---
 arch/powerpc/kernel/irq.c      |    4 +-
 arch/sh/kernel/cpu/irq/ipr.c   |    2 +-
 arch/x86/include/asm/hw_irq.h  |   11 ++++++-
 arch/x86/kernel/apic/io_apic.c |   64 ++++++++++++++++++++++++++++++++++-----
 arch/x86/kernel/uv_irq.c       |    5 +++
 arch/x86/lguest/boot.c         |    2 +-
 drivers/sh/intc.c              |    7 ++--
 drivers/xen/events.c           |    2 +-
 include/linux/interrupt.h      |    2 +-
 include/linux/irq.h            |   16 +++++++---
 kernel/irq/handle.c            |   15 ++++++---
 kernel/irq/numa_migrate.c      |   12 ++++++-
 kernel/softirq.c               |    3 +-
 13 files changed, 112 insertions(+), 33 deletions(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 64f6f20..dc5a8c1 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -670,7 +670,7 @@ static int irq_setup_virq(struct irq_host *host, unsigned int virq,
 {
 	struct irq_desc *desc;
 
-	desc = irq_to_desc_alloc_node(virq, 0);
+	desc = irq_to_desc_alloc_node(virq, 0, NULL);
 	if (!desc) {
 		pr_debug("irq: -> allocating desc failed\n");
 		goto error;
@@ -1088,7 +1088,7 @@ int arch_early_irq_init(void)
 	return 0;
 }
 
-int arch_init_chip_data(struct irq_desc *desc, int node)
+int arch_init_irq_desc(struct irq_desc *desc, int node)
 {
 	desc->status |= IRQ_NOREQUEST;
 	return 0;
diff --git a/arch/sh/kernel/cpu/irq/ipr.c b/arch/sh/kernel/cpu/irq/ipr.c
index 9282d96..cf31454 100644
--- a/arch/sh/kernel/cpu/irq/ipr.c
+++ b/arch/sh/kernel/cpu/irq/ipr.c
@@ -67,7 +67,7 @@ void register_ipr_controller(struct ipr_desc *desc)
 		BUG_ON(p->ipr_idx >= desc->nr_offsets);
 		BUG_ON(!desc->ipr_offsets[p->ipr_idx]);
 
-		irq_desc = irq_to_desc_alloc_node(p->irq, numa_node_id());
+		irq_desc = irq_to_desc_alloc_node(p->irq, numa_node_id(), NULL);
 		if (unlikely(!irq_desc)) {
 			printk(KERN_INFO "can not get irq_desc for %d\n",
 			       p->irq);
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index a929c9e..1bc7063 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -20,9 +20,9 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/smp.h>
+#include <linux/irq.h>
 
 #include <asm/atomic.h>
-#include <asm/irq.h>
 #include <asm/sections.h>
 
 /* Interrupt handlers registered during init_IRQ */
@@ -61,6 +61,15 @@ extern void init_VISWS_APIC_irqs(void);
 extern void setup_IO_APIC(void);
 extern void disable_IO_APIC(void);
 
+extern int x86_init_chip_data(struct irq_desc *desc, int node);
+
+#ifdef CONFIG_SPARSE_IRQ
+extern void x86_copy_chip_data(struct irq_desc *old_desc,
+				  struct irq_desc *desc, int node);
+extern void x86_free_chip_data(struct irq_desc *old_desc,
+				  struct irq_desc *desc);
+#endif
+
 struct io_apic_irq_attr {
 	int ioapic;
 	int ioapic_pin;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e4e0ddc..035b6d2 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -211,7 +211,7 @@ static struct irq_cfg *get_one_free_irq_cfg(int node)
 	return cfg;
 }
 
-int arch_init_chip_data(struct irq_desc *desc, int node)
+int x86_init_chip_data(struct irq_desc *desc, int node)
 {
 	struct irq_cfg *cfg;
 
@@ -287,8 +287,8 @@ static void free_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg)
 	old_cfg->irq_2_pin = NULL;
 }
 
-void arch_init_copy_chip_data(struct irq_desc *old_desc,
-				 struct irq_desc *desc, int node)
+void x86_copy_chip_data(struct irq_desc *old_desc,
+			   struct irq_desc *desc, int node)
 {
 	struct irq_cfg *cfg;
 	struct irq_cfg *old_cfg;
@@ -312,7 +312,7 @@ static void free_irq_cfg(struct irq_cfg *old_cfg)
 	kfree(old_cfg);
 }
 
-void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
+void x86_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
 {
 	struct irq_cfg *old_cfg, *cfg;
 
@@ -336,6 +336,11 @@ struct irq_cfg *irq_cfg(unsigned int irq)
 	return irq < nr_irqs ? irq_cfgx + irq : NULL;
 }
 
+int x86_init_chip_data(struct irq_desc *desc, int node)
+{
+	return 0;
+}
+
 #endif
 
 struct io_apic {
@@ -1515,7 +1520,7 @@ static void __init setup_IO_APIC_irqs(void)
 				apic->multi_timer_check(apic_id, irq))
 			continue;
 
-		desc = irq_to_desc_alloc_node(irq, node);
+		desc = irq_to_desc_alloc_node(irq, node, x86_init_chip_data);
 		if (!desc) {
 			printk(KERN_INFO "can not get irq_desc for %d\n", irq);
 			continue;
@@ -1565,7 +1570,7 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 	if (desc)
 		return;
 #endif
-	desc = irq_to_desc_alloc_node(irq, node);
+	desc = irq_to_desc_alloc_node(irq, node, x86_init_chip_data);
 	if (!desc) {
 		printk(KERN_INFO "can not get irq_desc for %d\n", irq);
 		return;
@@ -2739,6 +2744,11 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.set_affinity	= set_ioapic_affinity_irq,
 #endif
 	.retrigger	= ioapic_retrigger_irq,
+
+#ifdef CONFIG_SPARSE_IRQ
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
+#endif
 };
 
 static struct irq_chip ir_ioapic_chip __read_mostly = {
@@ -2754,6 +2764,11 @@ static struct irq_chip ir_ioapic_chip __read_mostly = {
 #endif
 #endif
 	.retrigger	= ioapic_retrigger_irq,
+
+#ifdef CONFIG_SPARSE_IRQ
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
+#endif
 };
 
 static inline void init_IO_APIC_traps(void)
@@ -3256,7 +3271,8 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
 	for (new = irq_want; new < nr_irqs; new++) {
-		desc_new = irq_to_desc_alloc_node(new, node);
+		desc_new = irq_to_desc_alloc_node(new, node,
+						  x86_init_chip_data);
 		if (!desc_new) {
 			printk(KERN_INFO "can not get irq_desc for %d\n", new);
 			continue;
@@ -3466,6 +3482,11 @@ static struct irq_chip msi_chip = {
 	.set_affinity	= set_msi_irq_affinity,
 #endif
 	.retrigger	= ioapic_retrigger_irq,
+
+#ifdef CONFIG_SPARSE_IRQ
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
+#endif
 };
 
 static struct irq_chip msi_ir_chip = {
@@ -3479,6 +3500,11 @@ static struct irq_chip msi_ir_chip = {
 #endif
 #endif
 	.retrigger	= ioapic_retrigger_irq,
+
+#ifdef CONFIG_SPARSE_IRQ
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
+#endif
 };
 
 /*
@@ -3638,6 +3664,11 @@ static struct irq_chip dmar_msi_type = {
 	.set_affinity = dmar_msi_set_affinity,
 #endif
 	.retrigger = ioapic_retrigger_irq,
+
+#ifdef CONFIG_SPARSE_IRQ
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
+#endif
 };
 
 int arch_setup_dmar_msi(unsigned int irq)
@@ -3695,6 +3726,11 @@ static struct irq_chip ir_hpet_msi_type = {
 #endif
 #endif
 	.retrigger = ioapic_retrigger_irq,
+
+#ifdef CONFIG_SPARSE_IRQ
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
+#endif
 };
 
 static struct irq_chip hpet_msi_type = {
@@ -3706,6 +3742,11 @@ static struct irq_chip hpet_msi_type = {
 	.set_affinity = hpet_msi_set_affinity,
 #endif
 	.retrigger = ioapic_retrigger_irq,
+
+#ifdef CONFIG_SPARSE_IRQ
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
+#endif
 };
 
 int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
@@ -3792,6 +3833,11 @@ static struct irq_chip ht_irq_chip = {
 	.set_affinity	= set_ht_irq_affinity,
 #endif
 	.retrigger	= ioapic_retrigger_irq,
+
+#ifdef CONFIG_SPARSE_IRQ
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
+#endif
 };
 
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
@@ -3914,7 +3960,7 @@ static int __io_apic_set_pci_routing(struct device *dev, int irq,
 	else
 		node = cpu_to_node(boot_cpu_id);
 
-	desc = irq_to_desc_alloc_node(irq, node);
+	desc = irq_to_desc_alloc_node(irq, node, x86_init_chip_data);
 	if (!desc) {
 		printk(KERN_INFO "can not get irq_desc %d\n", irq);
 		return 0;
@@ -4312,7 +4358,7 @@ void __init pre_init_apic_IRQ0(void)
 #ifndef CONFIG_SMP
 	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_physical_apicid);
 #endif
-	desc = irq_to_desc_alloc_node(0, 0);
+	desc = irq_to_desc_alloc_node(0, 0, x86_init_chip_data);
 
 	setup_local_APIC();
 
diff --git a/arch/x86/kernel/uv_irq.c b/arch/x86/kernel/uv_irq.c
index ece73d8..df2c6d6 100644
--- a/arch/x86/kernel/uv_irq.c
+++ b/arch/x86/kernel/uv_irq.c
@@ -55,6 +55,11 @@ struct irq_chip uv_irq_chip = {
 	.eoi		= uv_ack_apic,
 	.end		= uv_noop,
 	.set_affinity	= uv_set_irq_affinity,
+
+#ifdef CONFIG_SPARSE_IRQ
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
+#endif
 };
 
 /*
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 7e59dc1..659241a 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -841,7 +841,7 @@ static void __init lguest_init_IRQ(void)
  */
 void lguest_setup_irq(unsigned int irq)
 {
-	irq_to_desc_alloc_node(irq, 0);
+	irq_to_desc_alloc_node(irq, 0, NULL);
 	set_irq_chip_and_handler_name(irq, &lguest_irq_controller,
 				      handle_level_irq, "level");
 }
diff --git a/drivers/sh/intc.c b/drivers/sh/intc.c
index 3a5a17d..99f89dd 100644
--- a/drivers/sh/intc.c
+++ b/drivers/sh/intc.c
@@ -870,7 +870,7 @@ void __init register_intc_controller(struct intc_desc *desc)
 		if (!vect->enum_id)
 			continue;
 
-		irq_desc = irq_to_desc_alloc_node(irq, numa_node_id());
+		irq_desc = irq_to_desc_alloc_node(irq, numa_node_id(), NULL);
 		if (unlikely(!irq_desc)) {
 			pr_info("can't get irq_desc for %d\n", irq);
 			continue;
@@ -890,7 +890,8 @@ void __init register_intc_controller(struct intc_desc *desc)
 			 * IRQ support, each vector still needs to have
 			 * its own backing irq_desc.
 			 */
-			irq_desc = irq_to_desc_alloc_node(irq2, numa_node_id());
+			irq_desc = irq_to_desc_alloc_node(irq2, numa_node_id(),
+							  NULL);
 			if (unlikely(!irq_desc)) {
 				pr_info("can't get irq_desc for %d\n", irq2);
 				continue;
@@ -1012,7 +1013,7 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 		__set_bit(new, intc_irq_map);
 	}
 
-	desc = irq_to_desc_alloc_node(new, node);
+	desc = irq_to_desc_alloc_node(new, node, NULL);
 	if (unlikely(!desc)) {
 		pr_info("can't get irq_desc for %d\n", new);
 		goto out_unlock;
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 2f84137..0d4f0d3 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -341,7 +341,7 @@ static int find_unbound_irq(void)
 	if (irq == nr_irqs)
 		panic("No available IRQ to bind to: increase nr_irqs!\n");
 
-	desc = irq_to_desc_alloc_node(irq, 0);
+	desc = irq_to_desc_alloc_node(irq, 0, NULL);
 	if (WARN_ON(desc == NULL))
 		return -1;
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 75f3f00..cc4cd22 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -611,6 +611,6 @@ struct irq_desc;
 extern int early_irq_init(void);
 extern int arch_probe_nr_irqs(void);
 extern int arch_early_irq_init(void);
-extern int arch_init_chip_data(struct irq_desc *desc, int node);
+extern int arch_init_irq_desc(struct irq_desc *desc, int node);
 
 #endif
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 707ab12..e262ca0 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -131,6 +131,14 @@ struct irq_chip {
 	void		(*bus_lock)(unsigned int irq);
 	void		(*bus_sync_unlock)(unsigned int irq);
 
+	/* for move_irq_desc */
+#ifdef CONFIG_SPARSE_IRQ
+	void		(*copy_chip_data)(struct irq_desc *old_desc,
+					  struct irq_desc *desc, int node);
+	void		(*free_chip_data)(struct irq_desc *old_desc,
+					  struct irq_desc *desc);
+#endif
+
 	/* Currently used only by UML, might disappear one day.*/
 #ifdef CONFIG_IRQ_RELEASE_METHOD
 	void		(*release)(unsigned int irq, void *dev_id);
@@ -208,10 +216,6 @@ struct irq_desc {
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
-extern void arch_init_copy_chip_data(struct irq_desc *old_desc,
-					struct irq_desc *desc, int node);
-extern void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc);
-
 #ifndef CONFIG_SPARSE_IRQ
 extern struct irq_desc irq_desc[NR_IRQS];
 #endif
@@ -225,7 +229,9 @@ static inline struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
 }
 #endif
 
-extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node);
+typedef int (*init_chip_data_fn)(struct irq_desc *, int node);
+extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node,
+					       init_chip_data_fn fn);
 
 /*
  * Pick up the arch-dependent methods:
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 76d5a67..eb060e1 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -100,7 +100,8 @@ void __ref init_kstat_irqs(struct irq_desc *desc, int node, int nr)
 	}
 }
 
-static void init_one_irq_desc(int irq, struct irq_desc *desc, int node)
+static void init_one_irq_desc(int irq, struct irq_desc *desc, int node,
+			      init_chip_data_fn init_chip_data)
 {
 	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
 
@@ -120,7 +121,9 @@ static void init_one_irq_desc(int irq, struct irq_desc *desc, int node)
 		BUG_ON(1);
 	}
 	init_desc_masks(desc);
-	arch_init_chip_data(desc, node);
+	arch_init_irq_desc(desc, node);
+	if (init_chip_data)
+		init_chip_data(desc, node);
 }
 
 /*
@@ -198,7 +201,8 @@ int __init early_irq_init(void)
 	return arch_early_irq_init();
 }
 
-struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
+struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node,
+					       init_chip_data_fn init_chip_data)
 {
 	struct irq_desc *desc;
 	unsigned long flags;
@@ -227,7 +231,7 @@ struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 		printk(KERN_ERR "can not alloc irq_desc\n");
 		BUG_ON(1);
 	}
-	init_one_irq_desc(irq, desc, node);
+	init_one_irq_desc(irq, desc, node, init_chip_data);
 
 	set_irq_desc(irq, desc);
 
@@ -277,7 +281,8 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
 }
 
-struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node)
+struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node,
+					init_chip_data_fn init_chip_data)
 {
 	return irq_to_desc(irq);
 }
diff --git a/kernel/irq/numa_migrate.c b/kernel/irq/numa_migrate.c
index 963559d..9ea09c9 100644
--- a/kernel/irq/numa_migrate.c
+++ b/kernel/irq/numa_migrate.c
@@ -47,7 +47,8 @@ static bool init_copy_one_irq_desc(int irq, struct irq_desc *old_desc,
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 	init_copy_kstat_irqs(old_desc, desc, node, nr_cpu_ids);
 	init_copy_desc_masks(old_desc, desc);
-	arch_init_copy_chip_data(old_desc, desc, node);
+	if (desc->chip->copy_chip_data)
+		desc->chip->copy_chip_data(old_desc, desc, node);
 	return true;
 }
 
@@ -55,7 +56,8 @@ static void free_one_irq_desc(struct irq_desc *old_desc, struct irq_desc *desc)
 {
 	free_kstat_irqs(old_desc, desc);
 	free_desc_masks(old_desc, desc);
-	arch_free_chip_data(old_desc, desc);
+	if (desc->chip->free_chip_data)
+		desc->chip->free_chip_data(old_desc, desc);
 }
 
 static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
@@ -107,9 +109,15 @@ out_unlock:
 
 struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
 {
+
 	/* those static or target node is -1, do not move them */
 	if (desc->irq < NR_IRQS_LEGACY || node == -1)
 		return desc;
+	/* IRQ chip does not support movement */
+	if (desc->chip_data &&
+	    (desc->chip->copy_chip_data == NULL ||
+	     desc->chip->free_chip_data == NULL))
+		return desc;
 
 	if (desc->node != node)
 		desc = __real_move_irq_desc(desc, node);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7c1a67e..3f4b80e 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -895,8 +895,7 @@ int __init __weak arch_early_irq_init(void)
 {
 	return 0;
 }
-
-int __weak arch_init_chip_data(struct irq_desc *desc, int node)
+int __weak arch_init_irq_desc(struct irq_desc *desc, int node)
 {
 	return 0;
 }
-- 
1.5.6.5

