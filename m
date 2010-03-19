Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab0CSTEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 15:04:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:34439 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab0CSTEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 15:04:14 -0400
Message-ID: <4BA3CA3E.7010207@kernel.org>
Date: Fri, 19 Mar 2010 12:02:22 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ian Campbell <ian.campbell@citrix.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       lguest@ozlabs.org, Paul Mundt <lethal@linux-sh.org>,
       linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/2] irq: move some interrupt arch_* functions into struct
 irq_chip.
References: <1268998032.10129.44653.camel@zakaz.uk.xensource.com> <1268998041-22707-1-git-send-email-ian.campbell@citrix.com>
In-Reply-To: <1268998041-22707-1-git-send-email-ian.campbell@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check

Subject: [PATCH -v4] irq: move some interrupt arch_* functions into struct irq_chip.
From: Ian Campbell <ian.campbell@citrix.com>

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

-v4: yinghai add irq_to_desc_alloc_node_x...
     so could leave default path not changed...

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
 arch/powerpc/kernel/irq.c      |    2 -
 arch/x86/include/asm/hw_irq.h  |    7 +++++
 arch/x86/kernel/apic/io_apic.c |   49 +++++++++++++++++++++++++++++++++++++----
 arch/x86/kernel/uv_irq.c       |    3 ++
 drivers/xen/events.c           |    7 +++++
 include/linux/interrupt.h      |    1 
 include/linux/irq.h            |   20 ++++++++++++----
 kernel/irq/chip.c              |    7 +++++
 kernel/irq/handle.c            |   13 ++++++----
 kernel/irq/numa_migrate.c      |   12 ++++++++--
 kernel/softirq.c               |    5 ----
 11 files changed, 101 insertions(+), 25 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/irq.c
+++ linux-2.6/arch/powerpc/kernel/irq.c
@@ -1088,7 +1088,7 @@ int arch_early_irq_init(void)
 	return 0;
 }
 
-int arch_init_chip_data(struct irq_desc *desc, int node)
+int arch_init_irq_desc(struct irq_desc *desc, int node, init_chip_data_fn fn)
 {
 	desc->status |= IRQ_NOREQUEST;
 	return 0;
Index: linux-2.6/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hw_irq.h
+++ linux-2.6/arch/x86/include/asm/hw_irq.h
@@ -20,9 +20,9 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/smp.h>
+#include <linux/irq.h>
 
 #include <asm/atomic.h>
-#include <asm/irq.h>
 #include <asm/sections.h>
 
 /* Interrupt handlers registered during init_IRQ */
@@ -61,6 +61,11 @@ extern void init_VISWS_APIC_irqs(void);
 extern void setup_IO_APIC(void);
 extern void disable_IO_APIC(void);
 
+extern void x86_copy_chip_data(struct irq_desc *old_desc,
+				  struct irq_desc *desc, int node);
+extern void x86_free_chip_data(struct irq_desc *old_desc,
+				  struct irq_desc *desc);
+
 struct io_apic_irq_attr {
 	int ioapic;
 	int ioapic_pin;
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -211,7 +211,7 @@ static struct irq_cfg *get_one_free_irq_
 	return cfg;
 }
 
-int arch_init_chip_data(struct irq_desc *desc, int node)
+static int x86_init_chip_data(struct irq_desc *desc, int node)
 {
 	struct irq_cfg *cfg;
 
@@ -287,8 +287,8 @@ static void free_irq_2_pin(struct irq_cf
 	old_cfg->irq_2_pin = NULL;
 }
 
-void arch_init_copy_chip_data(struct irq_desc *old_desc,
-				 struct irq_desc *desc, int node)
+void x86_copy_chip_data(struct irq_desc *old_desc,
+			   struct irq_desc *desc, int node)
 {
 	struct irq_cfg *cfg;
 	struct irq_cfg *old_cfg;
@@ -312,7 +312,7 @@ static void free_irq_cfg(struct irq_cfg
 	kfree(old_cfg);
 }
 
-void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
+void x86_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
 {
 	struct irq_cfg *old_cfg, *cfg;
 
@@ -329,6 +329,14 @@ void arch_free_chip_data(struct irq_desc
 	}
 }
 /* end for move_irq_desc */
+int arch_init_irq_desc(struct irq_desc *desc, int node,
+			 init_chip_data_fn init_chip_data)
+{
+	if (!init_chip_data)
+		return x86_init_chip_data(desc, node);
+
+	return init_chip_data(desc, node);
+}
 
 #else
 struct irq_cfg *irq_cfg(unsigned int irq)
@@ -336,6 +344,15 @@ struct irq_cfg *irq_cfg(unsigned int irq
 	return irq < nr_irqs ? irq_cfgx + irq : NULL;
 }
 
+void x86_copy_chip_data(struct irq_desc *old_desc,
+			   struct irq_desc *desc, int node)
+{
+}
+
+void x86_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
+{
+}
+
 #endif
 
 struct io_apic {
@@ -2747,6 +2764,9 @@ static struct irq_chip ioapic_chip __rea
 	.set_affinity	= set_ioapic_affinity_irq,
 #endif
 	.retrigger	= ioapic_retrigger_irq,
+
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
 };
 
 static struct irq_chip ir_ioapic_chip __read_mostly = {
@@ -2762,6 +2782,9 @@ static struct irq_chip ir_ioapic_chip __
 #endif
 #endif
 	.retrigger	= ioapic_retrigger_irq,
+
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
 };
 
 static inline void init_IO_APIC_traps(void)
@@ -3474,6 +3497,9 @@ static struct irq_chip msi_chip = {
 	.set_affinity	= set_msi_irq_affinity,
 #endif
 	.retrigger	= ioapic_retrigger_irq,
+
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
 };
 
 static struct irq_chip msi_ir_chip = {
@@ -3487,6 +3513,9 @@ static struct irq_chip msi_ir_chip = {
 #endif
 #endif
 	.retrigger	= ioapic_retrigger_irq,
+
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
 };
 
 /*
@@ -3646,6 +3675,9 @@ static struct irq_chip dmar_msi_type = {
 	.set_affinity = dmar_msi_set_affinity,
 #endif
 	.retrigger = ioapic_retrigger_irq,
+
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
 };
 
 int arch_setup_dmar_msi(unsigned int irq)
@@ -3703,6 +3735,9 @@ static struct irq_chip ir_hpet_msi_type
 #endif
 #endif
 	.retrigger = ioapic_retrigger_irq,
+
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
 };
 
 static struct irq_chip hpet_msi_type = {
@@ -3714,6 +3749,9 @@ static struct irq_chip hpet_msi_type = {
 	.set_affinity = hpet_msi_set_affinity,
 #endif
 	.retrigger = ioapic_retrigger_irq,
+
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
 };
 
 int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
@@ -3800,6 +3838,9 @@ static struct irq_chip ht_irq_chip = {
 	.set_affinity	= set_ht_irq_affinity,
 #endif
 	.retrigger	= ioapic_retrigger_irq,
+
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
 };
 
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
Index: linux-2.6/arch/x86/kernel/uv_irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/uv_irq.c
+++ linux-2.6/arch/x86/kernel/uv_irq.c
@@ -55,6 +55,9 @@ struct irq_chip uv_irq_chip = {
 	.eoi		= uv_ack_apic,
 	.end		= uv_noop,
 	.set_affinity	= uv_set_irq_affinity,
+
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
 };
 
 /*
Index: linux-2.6/drivers/xen/events.c
===================================================================
--- linux-2.6.orig/drivers/xen/events.c
+++ linux-2.6/drivers/xen/events.c
@@ -329,6 +329,11 @@ static void unmask_evtchn(int port)
 	put_cpu();
 }
 
+static int xen_init_chip_data(struct irq_desc *desc, int node)
+{
+	return 0;
+}
+
 static int find_unbound_irq(void)
 {
 	int irq;
@@ -341,7 +346,7 @@ static int find_unbound_irq(void)
 	if (irq == nr_irqs)
 		panic("No available IRQ to bind to: increase nr_irqs!\n");
 
-	desc = irq_to_desc_alloc_node(irq, 0);
+	desc = irq_to_desc_alloc_node_x(irq, 0, xen_init_chip_data);
 	if (WARN_ON(desc == NULL))
 		return -1;
 
Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -611,6 +611,5 @@ struct irq_desc;
 extern int early_irq_init(void);
 extern int arch_probe_nr_irqs(void);
 extern int arch_early_irq_init(void);
-extern int arch_init_chip_data(struct irq_desc *desc, int node);
 
 #endif
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -131,6 +131,12 @@ struct irq_chip {
 	void		(*bus_lock)(unsigned int irq);
 	void		(*bus_sync_unlock)(unsigned int irq);
 
+	/* for move_irq_desc */
+	void		(*copy_chip_data)(struct irq_desc *old_desc,
+					  struct irq_desc *desc, int node);
+	void		(*free_chip_data)(struct irq_desc *old_desc,
+					  struct irq_desc *desc);
+
 	/* Currently used only by UML, might disappear one day.*/
 #ifdef CONFIG_IRQ_RELEASE_METHOD
 	void		(*release)(unsigned int irq, void *dev_id);
@@ -208,10 +214,6 @@ struct irq_desc {
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
-extern void arch_init_copy_chip_data(struct irq_desc *old_desc,
-					struct irq_desc *desc, int node);
-extern void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc);
-
 #ifndef CONFIG_SPARSE_IRQ
 extern struct irq_desc irq_desc[NR_IRQS];
 #endif
@@ -225,7 +227,15 @@ static inline struct irq_desc *move_irq_
 }
 #endif
 
-extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node);
+typedef int (*init_chip_data_fn)(struct irq_desc *, int node);
+int arch_init_irq_desc(struct irq_desc *desc, int node, init_chip_data_fn fn);
+struct irq_desc *irq_to_desc_alloc_node_x(unsigned int irq, int node,
+					       init_chip_data_fn fn);
+static inline struct irq_desc *irq_to_desc_alloc_node(unsigned int irq,
+							 int node)
+{
+	return irq_to_desc_alloc_node_x(irq, node, NULL);
+}
 
 /*
  * Pick up the arch-dependent methods:
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -100,7 +100,8 @@ void __ref init_kstat_irqs(struct irq_de
 	}
 }
 
-static void init_one_irq_desc(int irq, struct irq_desc *desc, int node)
+static void init_one_irq_desc(int irq, struct irq_desc *desc, int node,
+			      init_chip_data_fn init_chip_data)
 {
 	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
 
@@ -120,7 +121,7 @@ static void init_one_irq_desc(int irq, s
 		BUG_ON(1);
 	}
 	init_desc_masks(desc);
-	arch_init_chip_data(desc, node);
+	arch_init_irq_desc(desc, node, init_chip_data);
 }
 
 /*
@@ -198,7 +199,8 @@ int __init early_irq_init(void)
 	return arch_early_irq_init();
 }
 
-struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
+struct irq_desc * __ref irq_to_desc_alloc_node_x(unsigned int irq, int node,
+					       init_chip_data_fn init_chip_data)
 {
 	struct irq_desc *desc;
 	unsigned long flags;
@@ -227,7 +229,7 @@ struct irq_desc * __ref irq_to_desc_allo
 		printk(KERN_ERR "can not alloc irq_desc\n");
 		BUG_ON(1);
 	}
-	init_one_irq_desc(irq, desc, node);
+	init_one_irq_desc(irq, desc, node, init_chip_data);
 
 	set_irq_desc(irq, desc);
 
@@ -277,7 +279,8 @@ struct irq_desc *irq_to_desc(unsigned in
 	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
 }
 
-struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node)
+struct irq_desc *irq_to_desc_alloc_node_x(unsigned int irq, int node,
+					init_chip_data_fn init_chip_data)
 {
 	return irq_to_desc(irq);
 }
Index: linux-2.6/kernel/irq/numa_migrate.c
===================================================================
--- linux-2.6.orig/kernel/irq/numa_migrate.c
+++ linux-2.6/kernel/irq/numa_migrate.c
@@ -47,7 +47,8 @@ static bool init_copy_one_irq_desc(int i
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 	init_copy_kstat_irqs(old_desc, desc, node, nr_cpu_ids);
 	init_copy_desc_masks(old_desc, desc);
-	arch_init_copy_chip_data(old_desc, desc, node);
+	if (desc->chip->copy_chip_data)
+		desc->chip->copy_chip_data(old_desc, desc, node);
 	return true;
 }
 
@@ -55,7 +56,8 @@ static void free_one_irq_desc(struct irq
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
Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c
+++ linux-2.6/kernel/softirq.c
@@ -895,8 +895,3 @@ int __init __weak arch_early_irq_init(vo
 {
 	return 0;
 }
-
-int __weak arch_init_chip_data(struct irq_desc *desc, int node)
-{
-	return 0;
-}
Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c
+++ linux-2.6/kernel/irq/chip.c
@@ -758,3 +758,10 @@ void __init set_irq_probe(unsigned int i
 	desc->status &= ~IRQ_NOPROBE;
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
+
+int __weak arch_init_irq_desc(struct irq_desc *desc, int node,
+				 init_chip_data_fn init_chip_data)
+{
+	return 0;
+}
+
