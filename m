Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab0CVBio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 21:38:44 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:38901 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab0CVBia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 21:38:30 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 07/10] x86/irq: use irq_desc *desc with irq_chip
Date: Sun, 21 Mar 2010 18:36:07 -0700
Message-Id: <1269221770-9667-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BA6C9E7.0015,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

need to apply after eric's CHIP_PARAM_DESC patch

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/Kconfig                            |    1 +
 arch/x86/include/asm/hardirq.h              |    2 +-
 arch/x86/include/asm/hpet.h                 |    8 +-
 arch/x86/include/asm/hw_irq.h               |    1 -
 arch/x86/include/asm/i8259.h                |    2 +-
 arch/x86/kernel/apic/io_apic.c              |  153 +++++++++++----------------
 arch/x86/kernel/hpet.c                      |   16 ++--
 arch/x86/kernel/i8259.c                     |   31 +++---
 arch/x86/kernel/irq.c                       |   12 +-
 arch/x86/kernel/uv_irq.c                    |   15 ++--
 arch/x86/kernel/visws_quirks.c              |   29 +++---
 arch/x86/kernel/vmiclock_32.c               |    8 +-
 arch/x86/lguest/boot.c                      |    8 +-
 drivers/gpio/langwell_gpio.c                |   11 +-
 drivers/gpio/pca953x.c                      |   23 +++--
 drivers/gpio/timbgpio.c                     |   17 ++--
 drivers/infiniband/hw/ipath/ipath_iba6110.c |    2 +-
 drivers/mfd/ezx-pcap.c                      |   12 ++-
 drivers/mfd/twl4030-irq.c                   |   16 ++--
 drivers/mfd/wm831x-irq.c                    |   18 ++--
 drivers/misc/sgi-gru/grufile.c              |    2 +-
 drivers/pci/dmar.c                          |   20 ++--
 drivers/pci/htirq.c                         |   22 ++--
 drivers/pci/msi.c                           |   48 ++++-----
 drivers/xen/events.c                        |   22 ++--
 include/asm-generic/hardirq.h               |    4 +-
 include/linux/dmar.h                        |    8 +-
 include/linux/htirq.h                       |   11 +-
 include/linux/irq.h                         |    7 +-
 include/linux/msi.h                         |   13 +--
 kernel/irq/handle.c                         |    8 +-
 kernel/irq/internals.h                      |    7 +-
 kernel/irq/migration.c                      |   10 +-
 33 files changed, 279 insertions(+), 288 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a80bce..1b47c54 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -58,6 +58,7 @@ config X86
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
+	select CHIP_PARAM_DESC
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 0f85764..9b4b8f3 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -44,7 +44,7 @@ DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 #define set_softirq_pending(x)	percpu_write(irq_stat.__softirq_pending, (x))
 #define or_softirq_pending(x)	percpu_or(irq_stat.__softirq_pending, (x))
 
-extern void ack_bad_irq(unsigned int irq);
+extern void ack_bad_irq(struct irq_desc *desc);
 
 extern u64 arch_irq_stat_cpu(unsigned int cpu);
 #define arch_irq_stat_cpu	arch_irq_stat_cpu
diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index 1d5c08a..16c2257 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -74,10 +74,10 @@ extern void hpet_disable(void);
 extern unsigned int hpet_readl(unsigned int a);
 extern void force_hpet_resume(void);
 
-extern void hpet_msi_unmask(unsigned int irq);
-extern void hpet_msi_mask(unsigned int irq);
-extern void hpet_msi_write(unsigned int irq, struct msi_msg *msg);
-extern void hpet_msi_read(unsigned int irq, struct msi_msg *msg);
+extern void hpet_msi_unmask(struct irq_desc *);
+extern void hpet_msi_mask(struct irq_desc *);
+extern void hpet_msi_write(struct irq_desc *desc, struct msi_msg *msg);
+extern void hpet_msi_read(struct irq_desc *desc, struct msi_msg *msg);
 
 #ifdef CONFIG_PCI_MSI
 extern int arch_setup_hpet_msi(unsigned int irq, unsigned int id);
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index d23cf94..2417e29 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -96,7 +96,6 @@ struct irq_cfg {
 	u8			move_in_progress : 1;
 };
 
-extern struct irq_cfg *irq_cfg(unsigned int);
 int assign_irq_vector(struct irq_desc *, struct irq_cfg *,
 			 const struct cpumask *);
 extern void send_cleanup_vector(struct irq_cfg *);
diff --git a/arch/x86/include/asm/i8259.h b/arch/x86/include/asm/i8259.h
index 1655147..0b2ad6f 100644
--- a/arch/x86/include/asm/i8259.h
+++ b/arch/x86/include/asm/i8259.h
@@ -58,7 +58,7 @@ struct legacy_pic {
 	void (*mask_all)(void);
 	void (*restore_mask)(void);
 	void (*init)(int auto_eoi);
-	int (*irq_pending)(unsigned int irq);
+	int (*irq_pending)(struct irq_desc *desc);
 	void (*make_irq)(unsigned int irq);
 };
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index cd2f193..f908af5 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -176,18 +176,6 @@ int __init arch_early_irq_init(void)
 }
 
 #ifdef CONFIG_SPARSE_IRQ
-struct irq_cfg *irq_cfg(unsigned int irq)
-{
-	struct irq_cfg *cfg = NULL;
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-	if (desc)
-		cfg = desc->chip_data;
-
-	return cfg;
-}
-
 static struct irq_cfg *get_one_free_irq_cfg(int node)
 {
 	struct irq_cfg *cfg;
@@ -336,10 +324,6 @@ int arch_init_irq_desc(struct irq_desc *desc, int node,
 }
 
 #else
-struct irq_cfg *irq_cfg(unsigned int irq)
-{
-	return irq < nr_irqs ? irq_cfgx + irq : NULL;
-}
 
 void x86_copy_chip_data(struct irq_desc *old_desc,
 			   struct irq_desc *desc, int node)
@@ -619,16 +603,12 @@ static void unmask_IO_APIC_irq_desc(struct irq_desc *desc)
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void mask_IO_APIC_irq(unsigned int irq)
+static void mask_IO_APIC_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	mask_IO_APIC_irq_desc(desc);
 }
-static void unmask_IO_APIC_irq(unsigned int irq)
+static void unmask_IO_APIC_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	unmask_IO_APIC_irq_desc(desc);
 }
 
@@ -1497,7 +1477,7 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 
 	ioapic_register_intr(irq, desc, trigger);
 	if (irq < legacy_pic->nr_legacy_irqs)
-		legacy_pic->chip->mask(irq);
+		legacy_pic->chip->mask(desc);
 
 	ioapic_write_entry(apic_id, pin, entry);
 }
@@ -2296,29 +2276,29 @@ static int __init timer_irq_works(void)
  * an edge even if it isn't on the 8259A...
  */
 
-static unsigned int startup_ioapic_irq(unsigned int irq)
+static unsigned int startup_ioapic_irq(struct irq_desc *desc)
 {
 	int was_pending = 0;
 	unsigned long flags;
 	struct irq_cfg *cfg;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	if (irq < legacy_pic->nr_legacy_irqs) {
-		legacy_pic->chip->mask(irq);
-		if (legacy_pic->irq_pending(irq))
+	if (desc->irq < legacy_pic->nr_legacy_irqs) {
+		legacy_pic->chip->mask(desc);
+		if (legacy_pic->irq_pending(desc))
 			was_pending = 1;
 	}
-	cfg = irq_cfg(irq);
+	cfg = desc->chip_data;
 	__unmask_IO_APIC_irq(cfg);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return was_pending;
 }
 
-static int ioapic_retrigger_irq(unsigned int irq)
+static int ioapic_retrigger_irq(struct irq_desc *desc)
 {
 
-	struct irq_cfg *cfg = irq_cfg(irq);
+	struct irq_cfg *cfg = desc->chip_data;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
@@ -2427,12 +2407,8 @@ set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 }
 
 static int
-set_ioapic_affinity_irq(unsigned int irq, const struct cpumask *mask)
+set_ioapic_affinity_irq(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-
 	return set_ioapic_affinity_irq_desc(desc, mask);
 }
 
@@ -2495,11 +2471,9 @@ static int set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
 {
 	return migrate_ioapic_irq_desc(desc, mask);
 }
-static int set_ir_ioapic_affinity_irq(unsigned int irq,
+static int set_ir_ioapic_affinity_irq(struct irq_desc *desc,
 				       const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	return set_ir_ioapic_affinity_irq_desc(desc, mask);
 }
 #else
@@ -2592,12 +2566,10 @@ void irq_force_complete_move(int irq)
 static inline void irq_complete_move(struct irq_desc **descp) {}
 #endif
 
-static void ack_apic_edge(unsigned int irq)
+static void ack_apic_edge(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	irq_complete_move(&desc);
-	move_native_irq(irq);
+	move_native_irq(desc);
 	ack_APIC_irq();
 }
 
@@ -2656,9 +2628,8 @@ static void eoi_ioapic_irq(struct irq_desc *desc)
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void ack_apic_level(unsigned int irq)
+static void ack_apic_level(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long v;
 	int i;
 	struct irq_cfg *cfg;
@@ -2758,21 +2729,19 @@ static void ack_apic_level(unsigned int irq)
 		 */
 		cfg = desc->chip_data;
 		if (!io_apic_level_ack_pending(cfg))
-			move_masked_irq(irq);
+			move_masked_irq(desc);
 		unmask_IO_APIC_irq_desc(desc);
 	}
 }
 
 #ifdef CONFIG_INTR_REMAP
-static void ir_ack_apic_edge(unsigned int irq)
+static void ir_ack_apic_edge(struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
 
-static void ir_ack_apic_level(unsigned int irq)
+static void ir_ack_apic_level(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	ack_APIC_irq();
 	eoi_ioapic_irq(desc);
 }
@@ -2850,7 +2819,7 @@ static inline void init_IO_APIC_traps(void)
  * The local APIC irq-chip implementation:
  */
 
-static void mask_lapic_irq(unsigned int irq)
+static void mask_lapic_irq(struct irq_desc *desc)
 {
 	unsigned long v;
 
@@ -2858,7 +2827,7 @@ static void mask_lapic_irq(unsigned int irq)
 	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
 }
 
-static void unmask_lapic_irq(unsigned int irq)
+static void unmask_lapic_irq(struct irq_desc *desc)
 {
 	unsigned long v;
 
@@ -2866,7 +2835,7 @@ static void unmask_lapic_irq(unsigned int irq)
 	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
 }
 
-static void ack_lapic_irq(unsigned int irq)
+static void ack_lapic_irq(struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
@@ -2995,7 +2964,7 @@ static inline void __init check_timer(void)
 	/*
 	 * get/set the timer IRQ vector:
 	 */
-	legacy_pic->chip->mask(0);
+	legacy_pic->chip->mask(desc);
 	assign_irq_vector(desc, cfg, apic->target_cpus());
 
 	/*
@@ -3067,7 +3036,7 @@ static inline void __init check_timer(void)
 		if (timer_irq_works()) {
 			if (nmi_watchdog == NMI_IO_APIC) {
 				setup_nmi();
-				legacy_pic->chip->unmask(0);
+				legacy_pic->chip->unmask(desc);
 			}
 			if (disable_timer_pin_1 > 0)
 				clear_IO_APIC_pin(apic1, pin1);
@@ -3090,14 +3059,14 @@ static inline void __init check_timer(void)
 		 */
 		replace_pin_at_irq_node(cfg, node, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
-		legacy_pic->chip->unmask(0);
+		legacy_pic->chip->unmask(desc);
 		if (timer_irq_works()) {
 			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
 			timer_through_8259 = 1;
 			if (nmi_watchdog == NMI_IO_APIC) {
-				legacy_pic->chip->mask(0);
+				legacy_pic->chip->mask(desc);
 				setup_nmi();
-				legacy_pic->chip->unmask(0);
+				legacy_pic->chip->unmask(desc);
 			}
 			goto out;
 		}
@@ -3105,7 +3074,7 @@ static inline void __init check_timer(void)
 		 * Cleanup, just in case ...
 		 */
 		local_irq_disable();
-		legacy_pic->chip->mask(0);
+		legacy_pic->chip->mask(desc);
 		clear_IO_APIC_pin(apic2, pin2);
 		apic_printk(APIC_QUIET, KERN_INFO "....... failed.\n");
 	}
@@ -3124,14 +3093,14 @@ static inline void __init check_timer(void)
 
 	lapic_register_intr(0, desc);
 	apic_write(APIC_LVT0, APIC_DM_FIXED | cfg->vector);	/* Fixed mode */
-	legacy_pic->chip->unmask(0);
+	legacy_pic->chip->unmask(desc);
 
 	if (timer_irq_works()) {
 		apic_printk(APIC_QUIET, KERN_INFO "..... works.\n");
 		goto out;
 	}
 	local_irq_disable();
-	legacy_pic->chip->mask(0);
+	legacy_pic->chip->mask(desc);
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | cfg->vector);
 	apic_printk(APIC_QUIET, KERN_INFO "..... failed.\n");
 
@@ -3373,10 +3342,10 @@ void destroy_irq(unsigned int irq)
  * MSI message composition
  */
 #ifdef CONFIG_PCI_MSI
-static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
+static int msi_compose_msg(struct pci_dev *pdev, struct irq_desc *desc,
 			   struct msi_msg *msg, u8 hpet_id)
 {
-	struct irq_desc *desc;
+	unsigned int irq = desc->irq;
 	struct irq_cfg *cfg;
 	int err;
 	unsigned dest;
@@ -3384,7 +3353,6 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 	if (disable_apic)
 		return -ENXIO;
 
-	desc = irq_to_desc(irq);
 	cfg = desc->chip_data;
 	err = assign_irq_vector(desc, cfg, apic->target_cpus());
 	if (err)
@@ -3452,9 +3420,9 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 }
 
 #ifdef CONFIG_SMP
-static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int
+set_msi_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
@@ -3464,14 +3432,14 @@ static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 
 	cfg = desc->chip_data;
 
-	read_msi_msg_desc(desc, &msg);
+	read_msi_msg(desc, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
-	write_msi_msg_desc(desc, &msg);
+	write_msi_msg(desc, &msg);
 
 	return 0;
 }
@@ -3481,9 +3449,9 @@ static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
  * done in the process context using interrupt-remapping hardware.
  */
 static int
-ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
+ir_set_msi_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq = desc->irq;
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned int dest;
 	struct irte irte;
@@ -3581,16 +3549,16 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 {
 	int ret;
 	struct msi_msg msg;
+	struct irq_desc *desc = irq_to_desc(irq);
 
-	ret = msi_compose_msg(dev, irq, &msg, -1);
+	ret = msi_compose_msg(dev, desc, &msg, -1);
 	if (ret < 0)
 		return ret;
 
 	set_irq_msi(irq, msidesc);
-	write_msi_msg(irq, &msg);
+	write_msi_msg(desc, &msg);
 
 	if (irq_remapped(irq)) {
-		struct irq_desc *desc = irq_to_desc(irq);
 		/*
 		 * irq migration in process context
 		 */
@@ -3672,9 +3640,9 @@ void arch_teardown_msi_irq(unsigned int irq)
 
 #if defined (CONFIG_DMAR) || defined (CONFIG_INTR_REMAP)
 #ifdef CONFIG_SMP
-static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int
+dmar_msi_set_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
@@ -3684,14 +3652,14 @@ static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 	cfg = desc->chip_data;
 
-	dmar_msi_read(irq, &msg);
+	dmar_msi_read(desc, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
-	dmar_msi_write(irq, &msg);
+	dmar_msi_write(desc, &msg);
 
 	return 0;
 }
@@ -3716,11 +3684,12 @@ int arch_setup_dmar_msi(unsigned int irq)
 {
 	int ret;
 	struct msi_msg msg;
+	struct irq_desc *desc = irq_to_desc(irq);
 
-	ret = msi_compose_msg(NULL, irq, &msg, -1);
+	ret = msi_compose_msg(NULL, desc, &msg, -1);
 	if (ret < 0)
 		return ret;
-	dmar_msi_write(irq, &msg);
+	dmar_msi_write(desc, &msg);
 	set_irq_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
 		"edge");
 	return 0;
@@ -3730,9 +3699,9 @@ int arch_setup_dmar_msi(unsigned int irq)
 #ifdef CONFIG_HPET_TIMER
 
 #ifdef CONFIG_SMP
-static int hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int
+hpet_msi_set_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
@@ -3742,14 +3711,14 @@ static int hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 	cfg = desc->chip_data;
 
-	hpet_msi_read(irq, &msg);
+	hpet_msi_read(desc, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
-	hpet_msi_write(irq, &msg);
+	hpet_msi_write(desc, &msg);
 
 	return 0;
 }
@@ -3804,11 +3773,11 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 			return -1;
 	}
 
-	ret = msi_compose_msg(NULL, irq, &msg, id);
+	ret = msi_compose_msg(NULL, desc, &msg, id);
 	if (ret < 0)
 		return ret;
 
-	hpet_msi_write(irq, &msg);
+	hpet_msi_write(desc, &msg);
 	desc->status |= IRQ_MOVE_PCNTXT;
 	if (irq_remapped(irq))
 		set_irq_chip_and_handler_name(irq, &ir_hpet_msi_type,
@@ -3829,10 +3798,10 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 
 #ifdef CONFIG_SMP
 
-static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
+static void target_ht_irq(struct irq_desc *desc, unsigned int dest, u8 vector)
 {
 	struct ht_irq_msg msg;
-	fetch_ht_irq_msg(irq, &msg);
+	fetch_ht_irq_msg(desc, &msg);
 
 	msg.address_lo &= ~(HT_IRQ_LOW_VECTOR_MASK | HT_IRQ_LOW_DEST_ID_MASK);
 	msg.address_hi &= ~(HT_IRQ_HIGH_DEST_ID_MASK);
@@ -3840,12 +3809,12 @@ static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
 	msg.address_lo |= HT_IRQ_LOW_VECTOR(vector) | HT_IRQ_LOW_DEST_ID(dest);
 	msg.address_hi |= HT_IRQ_HIGH_DEST_ID(dest);
 
-	write_ht_irq_msg(irq, &msg);
+	write_ht_irq_msg(desc, &msg);
 }
 
-static int set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int
+set_ht_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	unsigned int dest;
 
@@ -3854,7 +3823,7 @@ static int set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
 
 	cfg = desc->chip_data;
 
-	target_ht_irq(irq, dest, cfg->vector);
+	target_ht_irq(desc, dest, cfg->vector);
 
 	return 0;
 }
@@ -3909,7 +3878,7 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 				HT_IRQ_LOW_MT_ARBITRATED) |
 			HT_IRQ_LOW_IRQ_MASKED;
 
-		write_ht_irq_msg(irq, &msg);
+		write_ht_irq_msg(desc, &msg);
 
 		set_irq_chip_and_handler_name(irq, &ht_irq_chip,
 					      handle_edge_irq, "edge");
@@ -4399,7 +4368,7 @@ void __init pre_init_apic_IRQ0(void)
 
 	setup_local_APIC();
 
-	cfg = irq_cfg(0);
+	cfg = desc->chip_data;
 	add_pin_to_irq_node(cfg, 0, 0, 0);
 	set_irq_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq, "edge");
 
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ee4fa1b..3355b99 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -426,9 +426,9 @@ static int hpet_legacy_next_event(unsigned long delta,
 static DEFINE_PER_CPU(struct hpet_dev *, cpu_hpet_dev);
 static struct hpet_dev	*hpet_devs;
 
-void hpet_msi_unmask(unsigned int irq)
+void hpet_msi_unmask(struct irq_desc *desc)
 {
-	struct hpet_dev *hdev = get_irq_data(irq);
+	struct hpet_dev *hdev = get_irq_desc_data(desc);
 	unsigned int cfg;
 
 	/* unmask it */
@@ -437,10 +437,10 @@ void hpet_msi_unmask(unsigned int irq)
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
-void hpet_msi_mask(unsigned int irq)
+void hpet_msi_mask(struct irq_desc *desc)
 {
 	unsigned int cfg;
-	struct hpet_dev *hdev = get_irq_data(irq);
+	struct hpet_dev *hdev = get_irq_desc_data(desc);
 
 	/* mask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
@@ -448,17 +448,17 @@ void hpet_msi_mask(unsigned int irq)
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
-void hpet_msi_write(unsigned int irq, struct msi_msg *msg)
+void hpet_msi_write(struct irq_desc *desc, struct msi_msg *msg)
 {
-	struct hpet_dev *hdev = get_irq_data(irq);
+	struct hpet_dev *hdev = get_irq_desc_data(desc);
 
 	hpet_writel(msg->data, HPET_Tn_ROUTE(hdev->num));
 	hpet_writel(msg->address_lo, HPET_Tn_ROUTE(hdev->num) + 4);
 }
 
-void hpet_msi_read(unsigned int irq, struct msi_msg *msg)
+void hpet_msi_read(struct irq_desc *desc, struct msi_msg *msg)
 {
-	struct hpet_dev *hdev = get_irq_data(irq);
+	struct hpet_dev *hdev = get_irq_desc_data(desc);
 
 	msg->data = hpet_readl(HPET_Tn_ROUTE(hdev->num));
 	msg->address_lo = hpet_readl(HPET_Tn_ROUTE(hdev->num) + 4);
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index fb725ee..b248555 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -33,13 +33,13 @@
 
 static int i8259A_auto_eoi;
 DEFINE_RAW_SPINLOCK(i8259A_lock);
-static void mask_and_ack_8259A(unsigned int);
+static void mask_and_ack_8259A(struct irq_desc *desc);
 static void mask_8259A(void);
 static void unmask_8259A(void);
-static void disable_8259A_irq(unsigned int irq);
-static void enable_8259A_irq(unsigned int irq);
+static void disable_8259A_irq(struct irq_desc *desc);
+static void enable_8259A_irq(struct irq_desc *desc);
 static void init_8259A(int auto_eoi);
-static int i8259A_irq_pending(unsigned int irq);
+static int i8259A_irq_pending(struct irq_desc *desc);
 
 struct irq_chip i8259A_chip = {
 	.name		= "XT-PIC",
@@ -69,8 +69,9 @@ unsigned int cached_irq_mask = 0xffff;
  */
 unsigned long io_apic_irqs;
 
-static void disable_8259A_irq(unsigned int irq)
+static void disable_8259A_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = 1 << irq;
 	unsigned long flags;
 
@@ -83,8 +84,9 @@ static void disable_8259A_irq(unsigned int irq)
 	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
-static void enable_8259A_irq(unsigned int irq)
+static void enable_8259A_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = ~(1 << irq);
 	unsigned long flags;
 
@@ -97,8 +99,9 @@ static void enable_8259A_irq(unsigned int irq)
 	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
-static int i8259A_irq_pending(unsigned int irq)
+static int i8259A_irq_pending(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = 1<<irq;
 	unsigned long flags;
 	int ret;
@@ -151,8 +154,9 @@ static inline int i8259A_irq_real(unsigned int irq)
  * first, _then_ send the EOI, and the order of EOI
  * to the two 8259s is important!
  */
-static void mask_and_ack_8259A(unsigned int irq)
+static void mask_and_ack_8259A(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int irqmask = 1 << irq;
 	unsigned long flags;
 
@@ -372,17 +376,18 @@ static void init_8259A(int auto_eoi)
  */
 
 static void legacy_pic_noop(void) { };
+static void legacy_pic_desc_noop(struct irq_desc *desc) { };
 static void legacy_pic_uint_noop(unsigned int unused) { };
 static void legacy_pic_int_noop(int unused) { };
 
 static struct irq_chip dummy_pic_chip  = {
 	.name = "dummy pic",
-	.mask = legacy_pic_uint_noop,
-	.unmask = legacy_pic_uint_noop,
-	.disable = legacy_pic_uint_noop,
-	.mask_ack = legacy_pic_uint_noop,
+	.mask = legacy_pic_desc_noop,
+	.unmask = legacy_pic_desc_noop,
+	.disable = legacy_pic_desc_noop,
+	.mask_ack = legacy_pic_desc_noop,
 };
-static int legacy_pic_irq_pending_noop(unsigned int irq)
+static int legacy_pic_irq_pending_noop(struct irq_desc *desc)
 {
 	return 0;
 }
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index f71625c..ae70844 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -24,10 +24,10 @@ void (*x86_platform_ipi_callback)(void) = NULL;
  * 'what should we do if we get a hw irq event on an illegal vector'.
  * each architecture has to answer this themselves.
  */
-void ack_bad_irq(unsigned int irq)
+void ack_bad_irq(struct irq_desc *desc)
 {
 	if (printk_ratelimit())
-		pr_err("unexpected IRQ trap at vector %02x\n", irq);
+		pr_err("unexpected IRQ trap at irq %02x\n", desc->irq);
 
 	/*
 	 * Currently unexpected vectors happen only on SMP and APIC.
@@ -316,15 +316,15 @@ void fixup_irqs(void)
 		}
 
 		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->mask)
-			desc->chip->mask(irq);
+			desc->chip->mask(desc);
 
 		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, affinity);
+			desc->chip->set_affinity(desc, affinity);
 		else if (!(warned++))
 			set_affinity = 0;
 
 		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->unmask)
-			desc->chip->unmask(irq);
+			desc->chip->unmask(desc);
 
 		raw_spin_unlock(&desc->lock);
 
@@ -357,7 +357,7 @@ void fixup_irqs(void)
 
 			raw_spin_lock(&desc->lock);
 			if (desc->chip->retrigger)
-				desc->chip->retrigger(irq);
+				desc->chip->retrigger(desc);
 			raw_spin_unlock(&desc->lock);
 		}
 	}
diff --git a/arch/x86/kernel/uv_irq.c b/arch/x86/kernel/uv_irq.c
index 44c430d..ed4ce50 100644
--- a/arch/x86/kernel/uv_irq.c
+++ b/arch/x86/kernel/uv_irq.c
@@ -27,18 +27,18 @@ struct uv_irq_2_mmr_pnode{
 static spinlock_t		uv_irq_lock;
 static struct rb_root		uv_irq_root;
 
-static int uv_set_irq_affinity(unsigned int, const struct cpumask *);
+static int uv_set_irq_affinity(struct irq_desc *desc, const struct cpumask *);
 
-static void uv_noop(unsigned int irq)
+static void uv_noop(struct irq_desc *desc)
 {
 }
 
-static unsigned int uv_noop_ret(unsigned int irq)
+static unsigned int uv_noop_ret(struct irq_desc *desc)
 {
 	return 0;
 }
 
-static void uv_ack_apic(unsigned int irq)
+static void uv_ack_apic(struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
@@ -156,7 +156,7 @@ arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) !=
 			sizeof(unsigned long));
 
-	cfg = irq_cfg(irq);
+	cfg = desc->chip_data;
 
 	err = assign_irq_vector(desc, cfg, eligible_cpu);
 	if (err != 0)
@@ -208,9 +208,10 @@ static void arch_disable_uv_irq(int mmr_pnode, unsigned long mmr_offset)
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
 }
 
-static int uv_set_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int
+uv_set_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq = desc->irq;
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned int dest;
 	unsigned long mmr_value;
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index e680ea5..8bd5075 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -430,14 +430,15 @@ static int is_co_apic(unsigned int irq)
  * This is the SGI Cobalt (IO-)APIC:
  */
 
-static void enable_cobalt_irq(unsigned int irq)
+static void enable_cobalt_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	co_apic_set(is_co_apic(irq), irq);
 }
 
-static void disable_cobalt_irq(unsigned int irq)
+static void disable_cobalt_irq(struct irq_desc *desc)
 {
-	int entry = is_co_apic(irq);
+	int entry = is_co_apic(desc->irq);
 
 	co_apic_write(CO_APIC_LO(entry), CO_APIC_MASK);
 	co_apic_read(CO_APIC_LO(entry));
@@ -448,37 +449,35 @@ static void disable_cobalt_irq(unsigned int irq)
  * map this to the Cobalt APIC entry where it's physically wired.
  * This is called via request_irq -> setup_irq -> irq_desc->startup()
  */
-static unsigned int startup_cobalt_irq(unsigned int irq)
+static unsigned int startup_cobalt_irq(struct irq_desc *desc)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_to_desc(irq);
 
 	spin_lock_irqsave(&cobalt_lock, flags);
 	if ((desc->status & (IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING)))
 		desc->status &= ~(IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING);
-	enable_cobalt_irq(irq);
+	enable_cobalt_irq(desc);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 	return 0;
 }
 
-static void ack_cobalt_irq(unsigned int irq)
+static void ack_cobalt_irq(struct irq_desc *desc)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&cobalt_lock, flags);
-	disable_cobalt_irq(irq);
+	disable_cobalt_irq(desc);
 	apic_write(APIC_EOI, APIC_EIO_ACK);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
 
-static void end_cobalt_irq(unsigned int irq)
+static void end_cobalt_irq(struct irq_desc *desc)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_to_desc(irq);
 
 	spin_lock_irqsave(&cobalt_lock, flags);
 	if (!(desc->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
-		enable_cobalt_irq(irq);
+		enable_cobalt_irq(desc);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
 
@@ -503,19 +502,19 @@ static struct irq_chip cobalt_irq_type = {
  * interrupt controller type, and through a special virtual interrupt-
  * controller. Device drivers only see the virtual interrupt sources.
  */
-static unsigned int startup_piix4_master_irq(unsigned int irq)
+static unsigned int startup_piix4_master_irq(struct irq_desc *desc)
 {
 	legacy_pic->init(0);
 
-	return startup_cobalt_irq(irq);
+	return startup_cobalt_irq(desc);
 }
 
-static void end_piix4_master_irq(unsigned int irq)
+static void end_piix4_master_irq(struct irq_desc *desc)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&cobalt_lock, flags);
-	enable_cobalt_irq(irq);
+	enable_cobalt_irq(desc);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
 
diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index fb65235..41257f6 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -84,7 +84,7 @@ static inline unsigned int vmi_get_timer_vector(void)
 
 /** vmi clockchip */
 #ifdef CONFIG_X86_LOCAL_APIC
-static unsigned int startup_timer_irq(unsigned int irq)
+static unsigned int startup_timer_irq(struct irq_desc *desc)
 {
 	unsigned long val = apic_read(APIC_LVTT);
 	apic_write(APIC_LVTT, vmi_get_timer_vector());
@@ -92,19 +92,19 @@ static unsigned int startup_timer_irq(unsigned int irq)
 	return (val & APIC_SEND_PENDING);
 }
 
-static void mask_timer_irq(unsigned int irq)
+static void mask_timer_irq(struct irq_desc *desc)
 {
 	unsigned long val = apic_read(APIC_LVTT);
 	apic_write(APIC_LVTT, val | APIC_LVT_MASKED);
 }
 
-static void unmask_timer_irq(unsigned int irq)
+static void unmask_timer_irq(struct irq_desc *desc)
 {
 	unsigned long val = apic_read(APIC_LVTT);
 	apic_write(APIC_LVTT, val & ~APIC_LVT_MASKED);
 }
 
-static void ack_timer_irq(unsigned int irq)
+static void ack_timer_irq(struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index e0f6b26..be7a653 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -789,14 +789,14 @@ static void lguest_flush_tlb_kernel(void)
  * simple as setting a bit.  We don't actually "ack" interrupts as such, we
  * just mask and unmask them.  I wonder if we should be cleverer?
  */
-static void disable_lguest_irq(unsigned int irq)
+static void disable_lguest_irq(struct irq_desc *desc)
 {
-	set_bit(irq, lguest_data.blocked_interrupts);
+	set_bit(desc->irq, lguest_data.blocked_interrupts);
 }
 
-static void enable_lguest_irq(unsigned int irq)
+static void enable_lguest_irq(struct irq_desc *desc)
 {
-	clear_bit(irq, lguest_data.blocked_interrupts);
+	clear_bit(desc->irq, lguest_data.blocked_interrupts);
 }
 
 /* This structure describes the lguest IRQ controller. */
diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index 6c0ebbd..9283da1 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -113,9 +113,10 @@ static int lnw_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	return lnw->irq_base + offset;
 }
 
-static int lnw_irq_type(unsigned irq, unsigned type)
+static int lnw_irq_type(CHIP_PARAM, unsigned type)
 {
-	struct lnw_gpio *lnw = get_irq_chip_data(irq);
+	CHIP_VAR_IRQ
+	CHIP_VAR struct lnw_gpio *lnw = get_irq_desc_chip_data(desc);
 	u32 gpio = irq - lnw->irq_base;
 	u8 reg = gpio / 32;
 	unsigned long flags;
@@ -142,11 +143,11 @@ static int lnw_irq_type(unsigned irq, unsigned type)
 	return 0;
 };
 
-static void lnw_irq_unmask(unsigned irq)
+static void lnw_irq_unmask(CHIP_PARAM)
 {
 };
 
-static void lnw_irq_mask(unsigned irq)
+static void lnw_irq_mask(CHIP_PARAM)
 {
 };
 
@@ -184,7 +185,7 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 		/* clear the edge detect status bit */
 		writel(gedr_v, gedr);
 	}
-	desc->chip->eoi(irq);
+	desc->chip->eoi(CHIP_ARG);
 }
 
 static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index ab5daab..ed615c0 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -227,37 +227,40 @@ static int pca953x_gpio_to_irq(struct gpio_chip *gc, unsigned off)
 	return chip->irq_base + off;
 }
 
-static void pca953x_irq_mask(unsigned int irq)
+static void pca953x_irq_mask(struct irq_desc *desc)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	CHIP_VAR_IRQ
+	CHIP_VAR struct pca953x_chip *chip = get_irq_desc_chip_data(desc);
 
 	chip->irq_mask &= ~(1 << (irq - chip->irq_base));
 }
 
-static void pca953x_irq_unmask(unsigned int irq)
+static void pca953x_irq_unmask(struct irq_desc *desc)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	CHIP_VAR_IRQ
+	CHIP_VAR struct pca953x_chip *chip = get_irq_desc_chip_data(desc);
 
 	chip->irq_mask |= 1 << (irq - chip->irq_base);
 }
 
-static void pca953x_irq_bus_lock(unsigned int irq)
+static void pca953x_irq_bus_lock(struct irq_desc *desc)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	CHIP_VAR struct pca953x_chip *chip = get_irq_desc_chip_data(desc);
 
 	mutex_lock(&chip->irq_lock);
 }
 
-static void pca953x_irq_bus_sync_unlock(unsigned int irq)
+static void pca953x_irq_bus_sync_unlock(struct irq_desc *desc)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	CHIP_VAR struct pca953x_chip *chip = get_irq_desc_chip_data(desc);
 
 	mutex_unlock(&chip->irq_lock);
 }
 
-static int pca953x_irq_set_type(unsigned int irq, unsigned int type)
+static int pca953x_irq_set_type(struct irq_desc *desc, unsigned int type)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	CHIP_VAR_IRQ
+	CHIP_VAR struct pca953x_chip *chip = get_irq_desc_chip_data(desc);
 	uint16_t level = irq - chip->irq_base;
 	uint16_t mask = 1 << level;
 
diff --git a/drivers/gpio/timbgpio.c b/drivers/gpio/timbgpio.c
index d4295fa..83160dc 100644
--- a/drivers/gpio/timbgpio.c
+++ b/drivers/gpio/timbgpio.c
@@ -107,25 +107,28 @@ static int timbgpio_to_irq(struct gpio_chip *gpio, unsigned offset)
 /*
  * GPIO IRQ
  */
-static void timbgpio_irq_disable(unsigned irq)
+static void timbgpio_irq_disable(CHIP_PARAM)
 {
-	struct timbgpio *tgpio = get_irq_chip_data(irq);
+	CHIP_VAR_IRQ
+	CHIP_VAR struct timbgpio *tgpio = get_irq_desc_chip_data(desc);
 	int offset = irq - tgpio->irq_base;
 
 	timbgpio_update_bit(&tgpio->gpio, offset, TGPIO_IER, 0);
 }
 
-static void timbgpio_irq_enable(unsigned irq)
+static void timbgpio_irq_enable(struct irq_desc *desc)
 {
-	struct timbgpio *tgpio = get_irq_chip_data(irq);
+	CHIP_VAR_IRQ
+	CHIP_VAR struct timbgpio *tgpio = get_irq_desc_chip_data(desc);
 	int offset = irq - tgpio->irq_base;
 
 	timbgpio_update_bit(&tgpio->gpio, offset, TGPIO_IER, 1);
 }
 
-static int timbgpio_irq_type(unsigned irq, unsigned trigger)
+static int timbgpio_irq_type(CHIP_PARAM, unsigned trigger)
 {
-	struct timbgpio *tgpio = get_irq_chip_data(irq);
+	CHIP_VAR_IRQ
+	CHIP_VAR struct timbgpio *tgpio = get_irq_desc_chip_data(desc);
 	int offset = irq - tgpio->irq_base;
 	unsigned long flags;
 	u32 lvr, flr, bflr = 0;
@@ -185,7 +188,7 @@ static void timbgpio_irq(unsigned int irq, struct irq_desc *desc)
 	unsigned long ipr;
 	int offset;
 
-	desc->chip->ack(irq);
+	desc->chip->ack(CHIP_ARG);
 	ipr = ioread32(tgpio->membase + TGPIO_IPR);
 	iowrite32(ipr, tgpio->membase + TGPIO_ICR);
 
diff --git a/drivers/infiniband/hw/ipath/ipath_iba6110.c b/drivers/infiniband/hw/ipath/ipath_iba6110.c
index 37d12e5..4cbae45 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba6110.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba6110.c
@@ -986,7 +986,7 @@ static int ipath_ht_intconfig(struct ipath_devdata *dd)
 	return ret;
 }
 
-static void ipath_ht_irq_update(struct pci_dev *dev, int irq,
+static void ipath_ht_irq_update(struct pci_dev *dev, struct irq_desc *desc,
 				struct ht_irq_msg *msg)
 {
 	struct ipath_devdata *dd = pci_get_drvdata(dev);
diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index df405af..f63bb23 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -143,17 +143,19 @@ int pcap_to_irq(struct pcap_chip *pcap, int irq)
 }
 EXPORT_SYMBOL_GPL(pcap_to_irq);
 
-static void pcap_mask_irq(unsigned int irq)
+static void pcap_mask_irq(CHIP_PARAM)
 {
-	struct pcap_chip *pcap = get_irq_chip_data(irq);
+	CHIP_VAR_IRQ
+	CHIP_VAR struct pcap_chip *pcap = get_irq_desc_chip_data(desc);
 
 	pcap->msr |= 1 << irq_to_pcap(pcap, irq);
 	queue_work(pcap->workqueue, &pcap->msr_work);
 }
 
-static void pcap_unmask_irq(unsigned int irq)
+static void pcap_unmask_irq(CHIP_PARAM)
 {
-	struct pcap_chip *pcap = get_irq_chip_data(irq);
+	CHIP_VAR_IRQ
+	CHIP_VAR struct pcap_chip *pcap = get_irq_desc_chip_data(desc);
 
 	pcap->msr &= ~(1 << irq_to_pcap(pcap, irq));
 	queue_work(pcap->workqueue, &pcap->msr_work);
@@ -217,7 +219,7 @@ static void pcap_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
 	struct pcap_chip *pcap = get_irq_data(irq);
 
-	desc->chip->ack(irq);
+	desc->chip->ack(desc);
 	queue_work(pcap->workqueue, &pcap->isr_work);
 	return;
 }
diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 9df9a5a..3e69ad3 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -595,9 +595,10 @@ static void twl4030_sih_do_edge(struct work_struct *work)
  * completion, potentially including some re-ordering, of these requests.
  */
 
-static void twl4030_sih_mask(unsigned irq)
+static void twl4030_sih_mask(CHIP_PARAM)
 {
-	struct sih_agent *sih = get_irq_chip_data(irq);
+	CHIP_VAR_IRQ
+	CHIP_VAR struct sih_agent *sih = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 
 	spin_lock_irqsave(&sih_agent_lock, flags);
@@ -607,9 +608,10 @@ static void twl4030_sih_mask(unsigned irq)
 	spin_unlock_irqrestore(&sih_agent_lock, flags);
 }
 
-static void twl4030_sih_unmask(unsigned irq)
+static void twl4030_sih_unmask(CHIP_PARAM)
 {
-	struct sih_agent *sih = get_irq_chip_data(irq);
+	CHIP_VAR_IRQ
+	CHIP_VAR struct sih_agent *sih = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 
 	spin_lock_irqsave(&sih_agent_lock, flags);
@@ -619,10 +621,10 @@ static void twl4030_sih_unmask(unsigned irq)
 	spin_unlock_irqrestore(&sih_agent_lock, flags);
 }
 
-static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
+static int twl4030_sih_set_type(CHIP_PARAM, unsigned trigger)
 {
-	struct sih_agent *sih = get_irq_chip_data(irq);
-	struct irq_desc *desc = irq_to_desc(irq);
+	CHIP_VAR_IRQ
+	CHIP_VAR struct sih_agent *sih = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 
 	if (!desc) {
diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 3013276..eac701e 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -346,16 +346,16 @@ static inline struct wm831x_irq_data *irq_to_wm831x_irq(struct wm831x *wm831x,
 	return &wm831x_irqs[irq - wm831x->irq_base];
 }
 
-static void wm831x_irq_lock(unsigned int irq)
+static void wm831x_irq_lock(CHIP_PARAM)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	CHIP_VAR struct wm831x *wm831x = get_irq_desc_chip_data(desc);
 
 	mutex_lock(&wm831x->irq_lock);
 }
 
-static void wm831x_irq_sync_unlock(unsigned int irq)
+static void wm831x_irq_sync_unlock(CHIP_PARAM
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	CHIP_VAR struct wm831x *wm831x = get_irq_desc_chip_data(desc);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(wm831x->irq_masks_cur); i++) {
@@ -372,17 +372,19 @@ static void wm831x_irq_sync_unlock(unsigned int irq)
 	mutex_unlock(&wm831x->irq_lock);
 }
 
-static void wm831x_irq_unmask(unsigned int irq)
+static void wm831x_irq_unmask(CHIP_PARAM)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	CHIP_VAR_IRQ
+	CHIP_VAR struct wm831x *wm831x = get_irq_desc_chip_data(desc);
 	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, irq);
 
 	wm831x->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
 }
 
-static void wm831x_irq_mask(unsigned int irq)
+static void wm831x_irq_mask(CHIP_PARAM)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	CHIP_VAR_IRQ
+	CHIP_VAR struct wm831x *wm831x = get_irq_desc_chip_data(desc);
 	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, irq);
 
 	wm831x->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index cb3b4d2..71aed9f 100644
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -348,7 +348,7 @@ static unsigned long gru_chiplet_cpu_to_mmr(int chiplet, int cpu, int *corep)
 
 static int gru_irq_count[GRU_CHIPLETS_PER_BLADE];
 
-static void gru_noop(unsigned int irq)
+static void gru_noop(CHIP_PARAM)
 {
 }
 
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 83aae47..00b6aee 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1230,9 +1230,10 @@ const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
 	}
 }
 
-void dmar_msi_unmask(unsigned int irq)
+void dmar_msi_unmask(CHIP_PARAM)
 {
-	struct intel_iommu *iommu = get_irq_data(irq);
+	CHIP_VAR
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 	unsigned long flag;
 
 	/* unmask it */
@@ -1243,10 +1244,11 @@ void dmar_msi_unmask(unsigned int irq)
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
-void dmar_msi_mask(unsigned int irq)
+void dmar_msi_mask(CHIP_PARAM)
 {
+	CHIP_VAR
 	unsigned long flag;
-	struct intel_iommu *iommu = get_irq_data(irq);
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 
 	/* mask it */
 	spin_lock_irqsave(&iommu->register_lock, flag);
@@ -1256,9 +1258,10 @@ void dmar_msi_mask(unsigned int irq)
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
-void dmar_msi_write(int irq, struct msi_msg *msg)
+void dmar_msi_write(CHIP_PARAM, struct msi_msg *msg)
 {
-	struct intel_iommu *iommu = get_irq_data(irq);
+	CHIP_VAR
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 	unsigned long flag;
 
 	spin_lock_irqsave(&iommu->register_lock, flag);
@@ -1268,9 +1271,10 @@ void dmar_msi_write(int irq, struct msi_msg *msg)
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
-void dmar_msi_read(int irq, struct msi_msg *msg)
+void dmar_msi_read(CHIP_PARAM, struct msi_msg *msg)
 {
-	struct intel_iommu *iommu = get_irq_data(irq);
+	CHIP_VAR
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 	unsigned long flag;
 
 	spin_lock_irqsave(&iommu->register_lock, flag);
diff --git a/drivers/pci/htirq.c b/drivers/pci/htirq.c
index 737a1c4..d9c5f0d 100644
--- a/drivers/pci/htirq.c
+++ b/drivers/pci/htirq.c
@@ -33,9 +33,9 @@ struct ht_irq_cfg {
 };
 
 
-void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
+void write_ht_irq_msg(struct irq_desc *desc, struct ht_irq_msg *msg)
 {
-	struct ht_irq_cfg *cfg = get_irq_data(irq);
+	struct ht_irq_cfg *cfg = get_irq_desc_data(desc);
 	unsigned long flags;
 	spin_lock_irqsave(&ht_irq_lock, flags);
 	if (cfg->msg.address_lo != msg->address_lo) {
@@ -47,39 +47,39 @@ void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
 		pci_write_config_dword(cfg->dev, cfg->pos + 4, msg->address_hi);
 	}
 	if (cfg->update)
-		cfg->update(cfg->dev, irq, msg);
+		cfg->update(cfg->dev, desc, msg);
 	spin_unlock_irqrestore(&ht_irq_lock, flags);
 	cfg->msg = *msg;
 }
 
-void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
+void fetch_ht_irq_msg(struct irq_desc *desc, struct ht_irq_msg *msg)
 {
-	struct ht_irq_cfg *cfg = get_irq_data(irq);
+	struct ht_irq_cfg *cfg = get_irq_desc_data(desc);
 	*msg = cfg->msg;
 }
 
-void mask_ht_irq(unsigned int irq)
+void mask_ht_irq(struct irq_desc *desc)
 {
 	struct ht_irq_cfg *cfg;
 	struct ht_irq_msg msg;
 
-	cfg = get_irq_data(irq);
+	cfg = get_irq_desc_data(desc);
 
 	msg = cfg->msg;
 	msg.address_lo |= 1;
-	write_ht_irq_msg(irq, &msg);
+	write_ht_irq_msg(desc, &msg);
 }
 
-void unmask_ht_irq(unsigned int irq)
+void unmask_ht_irq(struct irq_desc *desc)
 {
 	struct ht_irq_cfg *cfg;
 	struct ht_irq_msg msg;
 
-	cfg = get_irq_data(irq);
+	cfg = get_irq_desc_data(desc);
 
 	msg = cfg->msg;
 	msg.address_lo &= ~1;
-	write_ht_irq_msg(irq, &msg);
+	write_ht_irq_msg(desc, &msg);
 }
 
 /**
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index f9cf317..98ac7a6 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -169,9 +169,10 @@ static void msix_mask_irq(struct msi_desc *desc, u32 flag)
 	desc->masked = __msix_mask_irq(desc, flag);
 }
 
-static void msi_set_mask_bit(unsigned irq, u32 flag)
+static void msi_set_mask_bit(struct irq_desc *descx, u32 flag)
 {
-	struct msi_desc *desc = get_irq_msi(irq);
+	unsigned int irq = descx->irq;
+	struct msi_desc *desc = get_irq_desc_msi(descx);
 
 	if (desc->msi_attrib.is_msix) {
 		msix_mask_irq(desc, flag);
@@ -182,18 +183,21 @@ static void msi_set_mask_bit(unsigned irq, u32 flag)
 	}
 }
 
-void mask_msi_irq(unsigned int irq)
+void mask_msi_irq(CHIP_PARAM)
 {
-	msi_set_mask_bit(irq, 1);
+	CHIP_VAR;
+	msi_set_mask_bit(desc, 1);
 }
 
-void unmask_msi_irq(unsigned int irq)
+void unmask_msi_irq(CHIP_PARAM)
 {
-	msi_set_mask_bit(irq, 0);
+	CHIP_VAR;
+	msi_set_mask_bit(desc, 0);
 }
 
-void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
+void read_msi_msg(CHIP_PARAM, struct msi_msg *msg)
 {
+	CHIP_VAR
 	struct msi_desc *entry = get_irq_desc_msi(desc);
 	if (entry->msi_attrib.is_msix) {
 		void __iomem *base = entry->mask_base +
@@ -221,15 +225,9 @@ void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
 	}
 }
 
-void read_msi_msg(unsigned int irq, struct msi_msg *msg)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	read_msi_msg_desc(desc, msg);
-}
-
-void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
+void write_msi_msg(CHIP_PARAM, struct msi_msg *msg)
 {
+	CHIP_VAR
 	struct msi_desc *entry = get_irq_desc_msi(desc);
 	if (entry->msi_attrib.is_msix) {
 		void __iomem *base;
@@ -264,13 +262,6 @@ void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
 	entry->msg = *msg;
 }
 
-void write_msi_msg(unsigned int irq, struct msi_msg *msg)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	write_msi_msg_desc(desc, msg);
-}
-
 static void free_msi_irqs(struct pci_dev *dev)
 {
 	struct msi_desc *entry, *tmp;
@@ -319,16 +310,19 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
 	int pos;
 	u16 control;
 	struct msi_desc *entry;
+	unsigned int irq = dev->irq;
+	struct irq_desc *desc;
 
 	if (!dev->msi_enabled)
 		return;
 
-	entry = get_irq_msi(dev->irq);
+	desc = irq_to_desc(irq);
+	entry = get_irq_desc_msi(desc);
 	pos = entry->msi_attrib.pos;
 
 	pci_intx_for_msi(dev, 0);
 	msi_set_enable(dev, pos, 0);
-	write_msi_msg(dev->irq, &entry->msg);
+	write_msi_msg(CHIP_ARG, &entry->msg);
 
 	pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &control);
 	msi_mask_irq(entry, msi_capable_mask(control), entry->masked);
@@ -356,7 +350,11 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
 	pci_write_config_word(dev, pos + PCI_MSIX_FLAGS, control);
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
-		write_msi_msg(entry->irq, &entry->msg);
+		unsigned int irq = entry->irq;
+#ifdef CONFIG_CHIP_PARAM_DESC
+		struct irq_desc *desc = irq_to_desc(irq);
+#endif
+		write_msi_msg(CHIP_ARG, &entry->msg);
 		msix_mask_irq(entry, entry->masked);
 	}
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 64cbbe4..65372ad 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -730,11 +730,11 @@ static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 	return 0;
 }
 
-static int set_affinity_irq(unsigned irq, const struct cpumask *dest)
+static int set_affinity_irq(CHIP_PARAM, const struct cpumask *dest)
 {
 	unsigned tcpu = cpumask_first(dest);
 
-	return rebind_irq_to_cpu(irq, tcpu);
+	CHIP_VAR_IRQ return rebind_irq_to_cpu(irq, tcpu);
 }
 
 int resend_irq_on_evtchn(unsigned int irq)
@@ -753,35 +753,35 @@ int resend_irq_on_evtchn(unsigned int irq)
 	return 1;
 }
 
-static void enable_dynirq(unsigned int irq)
+static void enable_dynirq(CHIP_PARAM)
 {
-	int evtchn = evtchn_from_irq(irq);
+	CHIP_VAR_IRQ int evtchn = evtchn_from_irq(irq);
 
 	if (VALID_EVTCHN(evtchn))
 		unmask_evtchn(evtchn);
 }
 
-static void disable_dynirq(unsigned int irq)
+static void disable_dynirq(CHIP_PARAM)
 {
-	int evtchn = evtchn_from_irq(irq);
+	CHIP_VAR_IRQ int evtchn = evtchn_from_irq(irq);
 
 	if (VALID_EVTCHN(evtchn))
 		mask_evtchn(evtchn);
 }
 
-static void ack_dynirq(unsigned int irq)
+static void ack_dynirq(CHIP_PARAM)
 {
-	int evtchn = evtchn_from_irq(irq);
+	CHIP_VAR_IRQ int evtchn = evtchn_from_irq(irq);
 
-	move_native_irq(irq);
+	move_native_irq(CHIP_ARG);
 
 	if (VALID_EVTCHN(evtchn))
 		clear_evtchn(evtchn);
 }
 
-static int retrigger_dynirq(unsigned int irq)
+static int retrigger_dynirq(CHIP_PARAM)
 {
-	int evtchn = evtchn_from_irq(irq);
+	CHIP_VAR_IRQ int evtchn = evtchn_from_irq(irq);
 	struct shared_info *sh = HYPERVISOR_shared_info;
 	int ret = 0;
 
diff --git a/include/asm-generic/hardirq.h b/include/asm-generic/hardirq.h
index 62f5908..23b0724 100644
--- a/include/asm-generic/hardirq.h
+++ b/include/asm-generic/hardirq.h
@@ -12,8 +12,10 @@ typedef struct {
 #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
 
 #ifndef ack_bad_irq
-static inline void ack_bad_irq(unsigned int irq)
+static inline void ack_bad_irq(CHIP_PARAM)
 {
+	CHIP_VAR_IRQ
+
 	printk(KERN_CRIT "unexpected IRQ trap at vector %02x\n", irq);
 }
 #endif
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 659a765..425c38a 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -187,10 +187,10 @@ static inline int set_msi_sid(struct irte *irte, struct pci_dev *dev)
 /* Can't use the common MSI interrupt functions
  * since DMAR is not a pci device
  */
-extern void dmar_msi_unmask(unsigned int irq);
-extern void dmar_msi_mask(unsigned int irq);
-extern void dmar_msi_read(int irq, struct msi_msg *msg);
-extern void dmar_msi_write(int irq, struct msi_msg *msg);
+extern void dmar_msi_unmask(CHIP_PARAM);
+extern void dmar_msi_mask(CHIP_PARAM);
+extern void dmar_msi_read(CHIP_PARAM, struct msi_msg *msg);
+extern void dmar_msi_write(CHIP_PARAM, struct msi_msg *msg);
 extern int dmar_set_interrupt(struct intel_iommu *iommu);
 extern irqreturn_t dmar_fault(int irq, void *dev_id);
 extern int arch_setup_dmar_msi(unsigned int irq);
diff --git a/include/linux/htirq.h b/include/linux/htirq.h
index c96ea46..91cf055 100644
--- a/include/linux/htirq.h
+++ b/include/linux/htirq.h
@@ -7,16 +7,17 @@ struct ht_irq_msg {
 };
 
 /* Helper functions.. */
-void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
-void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
-void mask_ht_irq(unsigned int irq);
-void unmask_ht_irq(unsigned int irq);
+struct irq_desc;
+void fetch_ht_irq_msg(struct irq_desc *desc, struct ht_irq_msg *msg);
+void write_ht_irq_msg(struct irq_desc *desc, struct ht_irq_msg *msg);
+void mask_ht_irq(struct irq_desc *);
+void unmask_ht_irq(struct irq_desc *);
 
 /* The arch hook for getting things started */
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev);
 
 /* For drivers of buggy hardware */
-typedef void (ht_irq_update_t)(struct pci_dev *dev, int irq,
+typedef void (ht_irq_update_t)(struct pci_dev *dev, struct irq_desc *desc,
 			       struct ht_irq_msg *msg);
 int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update);
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 5a110a4..36ea6ac 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -264,8 +264,8 @@ extern void remove_irq(unsigned int irq, struct irqaction *act);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 
-void move_native_irq(unsigned int irq);
-void move_masked_irq(unsigned int irq);
+void move_native_irq(CHIP_PARAM);
+void move_masked_irq(CHIP_PARAM);
 
 #else /* CONFIG_GENERIC_PENDING_IRQ */
 
@@ -349,9 +349,6 @@ static inline void generic_handle_irq(unsigned int irq)
 extern void note_interrupt(unsigned int irq, struct irq_desc *desc,
 			   irqreturn_t action_ret);
 
-/* Resending of interrupts :*/
-void check_irq_resend(struct irq_desc *desc, unsigned int irq);
-
 /* Enable/disable irq debugging output: */
 extern int noirqdebug_setup(char *str);
 
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 6991ab5..2ab1cd3 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -3,6 +3,8 @@
 
 #include <linux/list.h>
 
+#include <linux/irq.h>
+
 struct msi_msg {
 	u32	address_lo;	/* low 32 bits of msi message address */
 	u32	address_hi;	/* high 32 bits of msi message address */
@@ -10,13 +12,10 @@ struct msi_msg {
 };
 
 /* Helper functions */
-struct irq_desc;
-extern void mask_msi_irq(unsigned int irq);
-extern void unmask_msi_irq(unsigned int irq);
-extern void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
-extern void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
-extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
-extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
+extern void mask_msi_irq(CHIP_PARAM);
+extern void unmask_msi_irq(CHIP_PARAM);
+extern void read_msi_msg(CHIP_PARAM, struct msi_msg *msg);
+extern void write_msi_msg(CHIP_PARAM, struct msi_msg *msg);
 
 struct msi_desc {
 	struct {
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 9e4a0a0..1c1d465 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -38,9 +38,9 @@ struct lock_class_key irq_desc_lock_class;
  */
 void handle_bad_irq(unsigned int irq, struct irq_desc *desc)
 {
-	print_irq_desc(irq, desc);
+	print_irq_desc(desc);
 	kstat_incr_irqs_this_cpu(irq, desc);
-	ack_bad_irq(irq);
+	ack_bad_irq(CHIP_ARG);
 }
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
@@ -299,8 +299,8 @@ static void ack_bad(CHIP_PARAM)
 {
 	CHIP_VAR;
 
-	print_irq_desc(desc->irq, desc);
-	ack_bad_irq(desc->irq);
+	print_irq_desc(desc);
+	ack_bad_irq(CHIP_ARG);
 }
 
 /*
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 2a9ec5e..dca36c4 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -14,6 +14,8 @@ extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		unsigned long flags);
 extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
 extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
+/* Resending of interrupts :*/
+void check_irq_resend(struct irq_desc *desc, unsigned int irq);
 
 extern struct lock_class_key irq_desc_lock_class;
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
@@ -61,10 +63,11 @@ static inline void chip_bus_sync_unlock(unsigned int irq, struct irq_desc *desc)
 
 #define P(f) if (desc->status & f) printk("%14s set\n", #f)
 
-static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
+static inline void print_irq_desc(struct irq_desc *desc)
 {
 	printk("irq %d, desc: %p, depth: %d, count: %d, unhandled: %d\n",
-		irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
+		desc->irq, desc, desc->depth, desc->irq_count,
+		desc->irqs_unhandled);
 	printk("->handle_irq():  %p, ", desc->handle_irq);
 	print_symbol("%s\n", (unsigned long)desc->handle_irq);
 	printk("->chip(): %p, ", desc->chip);
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 5821159..849b3d0 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -4,9 +4,9 @@
 
 #include "internals.h"
 
-void move_masked_irq(unsigned int irq)
+void move_masked_irq(CHIP_PARAM)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	CHIP_VAR
 
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
@@ -51,9 +51,9 @@ void move_masked_irq(unsigned int irq)
 	cpumask_clear(desc->pending_mask);
 }
 
-void move_native_irq(unsigned int irq)
+void move_native_irq(CHIP_PARAM)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	CHIP_VAR
 
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
@@ -62,7 +62,7 @@ void move_native_irq(unsigned int irq)
 		return;
 
 	desc->chip->mask(CHIP_ARG);
-	move_masked_irq(irq);
+	move_masked_irq(CHIP_ARG);
 	desc->chip->unmask(CHIP_ARG);
 }
 
-- 
1.6.4.2

