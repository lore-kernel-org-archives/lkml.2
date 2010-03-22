Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab0CVBlu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 21:41:50 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:37887 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab0CVBlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 21:41:47 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yinghai@kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       lguest@ozlabs.org, Paul Mundt <lethal@linux-sh.org>,
       linux-sh@vger.kernel.org
Subject: [PATCH 01/10] irq: move some interrupt arch_* functions into struct irq_chip.
Date: Sun, 21 Mar 2010 18:36:01 -0700
Message-Id: <1269221770-9667-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BA6CA39.0086,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 arch/powerpc/kernel/irq.c      |    2 +-
 arch/x86/include/asm/hw_irq.h  |    7 +++++-
 arch/x86/kernel/apic/io_apic.c |   49 ++++++++++++++++++++++++++++++++++++---
 arch/x86/kernel/uv_irq.c       |    3 ++
 drivers/xen/events.c           |    7 +++++-
 include/linux/interrupt.h      |    1 -
 include/linux/irq.h            |   21 +++++++++++++----
 kernel/irq/chip.c              |    7 +++++
 kernel/irq/handle.c            |   13 ++++++----
 kernel/irq/numa_migrate.c      |   12 ++++++++-
 kernel/softirq.c               |    5 ----
 11 files changed, 102 insertions(+), 25 deletions(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 64f6f20..cafd378 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -1088,7 +1088,7 @@ int arch_early_irq_init(void)
 	return 0;
 }
 
-int arch_init_chip_data(struct irq_desc *desc, int node)
+int arch_init_irq_desc(struct irq_desc *desc, int node, init_chip_data_fn fn)
 {
 	desc->status |= IRQ_NOREQUEST;
 	return 0;
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 46c0fe0..767d3f8 100644
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
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 463de9a..a917fdf 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -211,7 +211,7 @@ static struct irq_cfg *get_one_free_irq_cfg(int node)
 	return cfg;
 }
 
-int arch_init_chip_data(struct irq_desc *desc, int node)
+static int x86_init_chip_data(struct irq_desc *desc, int node)
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
 
@@ -329,6 +329,14 @@ void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
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
@@ -336,6 +344,15 @@ struct irq_cfg *irq_cfg(unsigned int irq)
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
@@ -2747,6 +2764,9 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.set_affinity	= set_ioapic_affinity_irq,
 #endif
 	.retrigger	= ioapic_retrigger_irq,
+
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
 };
 
 static struct irq_chip ir_ioapic_chip __read_mostly = {
@@ -2762,6 +2782,9 @@ static struct irq_chip ir_ioapic_chip __read_mostly = {
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
@@ -3703,6 +3735,9 @@ static struct irq_chip ir_hpet_msi_type = {
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
diff --git a/arch/x86/kernel/uv_irq.c b/arch/x86/kernel/uv_irq.c
index ece73d8..4c61f1b 100644
--- a/arch/x86/kernel/uv_irq.c
+++ b/arch/x86/kernel/uv_irq.c
@@ -55,6 +55,9 @@ struct irq_chip uv_irq_chip = {
 	.eoi		= uv_ack_apic,
 	.end		= uv_noop,
 	.set_affinity	= uv_set_irq_affinity,
+
+	.copy_chip_data = x86_copy_chip_data,
+	.free_chip_data = x86_free_chip_data,
 };
 
 /*
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 2f84137..64cbbe4 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
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
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 75f3f00..0b0d679 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -611,6 +611,5 @@ struct irq_desc;
 extern int early_irq_init(void);
 extern int arch_probe_nr_irqs(void);
 extern int arch_early_irq_init(void);
-extern int arch_init_chip_data(struct irq_desc *desc, int node);
 
 #endif
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 707ab12..60f3368 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -140,6 +140,13 @@ struct irq_chip {
 	 * Will disappear.
 	 */
 	const char	*typename;
+
+	/* for move_irq_desc */
+	void		(*copy_chip_data)(struct irq_desc *old_desc,
+					  struct irq_desc *desc, int node);
+	void		(*free_chip_data)(struct irq_desc *old_desc,
+					  struct irq_desc *desc);
+
 };
 
 struct timer_rand_state;
@@ -208,10 +215,6 @@ struct irq_desc {
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
-extern void arch_init_copy_chip_data(struct irq_desc *old_desc,
-					struct irq_desc *desc, int node);
-extern void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc);
-
 #ifndef CONFIG_SPARSE_IRQ
 extern struct irq_desc irq_desc[NR_IRQS];
 #endif
@@ -225,7 +228,15 @@ static inline struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
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
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index bbba585..3dcdd2f 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -758,3 +758,10 @@ void __init set_irq_probe(unsigned int irq)
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
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 76d5a67..f30c9c7 100644
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
 
@@ -120,7 +121,7 @@ static void init_one_irq_desc(int irq, struct irq_desc *desc, int node)
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
@@ -227,7 +229,7 @@ struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 		printk(KERN_ERR "can not alloc irq_desc\n");
 		BUG_ON(1);
 	}
-	init_one_irq_desc(irq, desc, node);
+	init_one_irq_desc(irq, desc, node, init_chip_data);
 
 	set_irq_desc(irq, desc);
 
@@ -277,7 +279,8 @@ struct irq_desc *irq_to_desc(unsigned int irq)
 	return (irq < NR_IRQS) ? irq_desc + irq : NULL;
 }
 
-struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node)
+struct irq_desc *irq_to_desc_alloc_node_x(unsigned int irq, int node,
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
index 7c1a67e..7df0209 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -895,8 +895,3 @@ int __init __weak arch_early_irq_init(void)
 {
 	return 0;
 }
-
-int __weak arch_init_chip_data(struct irq_desc *desc, int node)
-{
-	return 0;
-}
-- 
1.6.4.2

