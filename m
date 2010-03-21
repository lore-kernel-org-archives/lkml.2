Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab0CUHSm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 03:18:42 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:47284 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab0CUHSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 03:18:22 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 12/20] genericirq: change ack/mask in irq_chip to take irq_desc instead of irq -- x86 and core
Date: Sun, 21 Mar 2010 00:13:13 -0700
Message-Id: <1269155601-18247-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BA5C7B1.005C,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will have
void            (*ack)(struct irq_desc *desc);
void            (*mask)(struct irq_desc *desc);
void            (*mask_ack)(struct irq_desc *desc);
void            (*unmask)(struct irq_desc *desc);
void            (*eoi)(struct irq_desc *desc);

so for sparseirq with raidix tree, we don't call extra irq_to_desc, and could use desc directly

-v2: change all member of irq_chip to use desc only.
-v2.1: update after legacy_pic
-v2.2: update to irq one short fix

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/alpha/include/asm/hardirq.h            |    3 +-
 arch/alpha/kernel/irq.c                     |    4 +-
 arch/arm/include/asm/hw_irq.h               |    3 +-
 arch/arm/kernel/irq.c                       |    2 +-
 arch/blackfin/include/asm/hardirq.h         |    3 +-
 arch/blackfin/kernel/irqchip.c              |    4 +-
 arch/frv/include/asm/hardirq.h              |    3 +-
 arch/ia64/hp/sim/hpsim_irq.c                |    6 +-
 arch/ia64/include/asm/hardirq.h             |    2 +-
 arch/ia64/kernel/iosapic.c                  |   41 ++++----
 arch/ia64/kernel/irq.c                      |   10 +-
 arch/ia64/kernel/irq_lsapic.c               |    8 +-
 arch/ia64/kernel/msi_ia64.c                 |   21 +++--
 arch/ia64/kernel/smpboot.c                  |    6 +-
 arch/ia64/sn/kernel/irq.c                   |   25 +++--
 arch/ia64/sn/kernel/msi_sn.c                |   12 ++-
 arch/mips/include/asm/hardirq.h             |    3 +-
 arch/mips/kernel/irq.c                      |    3 +-
 arch/mn10300/include/asm/hardirq.h          |    2 +-
 arch/mn10300/kernel/irq.c                   |    4 +-
 arch/powerpc/include/asm/hardirq.h          |    4 +-
 arch/sh/include/asm/hardirq.h               |    3 +-
 arch/sh/kernel/irq.c                        |    4 +-
 arch/sparc/include/asm/hardirq_64.h         |    3 +-
 arch/sparc/kernel/irq_64.c                  |    3 +-
 arch/um/kernel/irq.c                        |    2 +-
 arch/x86/include/asm/hardirq.h              |    2 +-
 arch/x86/include/asm/hpet.h                 |    8 +-
 arch/x86/include/asm/hw_irq.h               |    1 -
 arch/x86/include/asm/i8259.h                |    2 +-
 arch/x86/kernel/apic/io_apic.c              |  143 ++++++++++-----------------
 arch/x86/kernel/hpet.c                      |   16 ++--
 arch/x86/kernel/i8259.c                     |   31 ++++---
 arch/x86/kernel/irq.c                       |   12 +-
 arch/x86/kernel/uv_irq.c                    |   14 ++--
 arch/x86/kernel/visws_quirks.c              |   29 +++---
 arch/x86/kernel/vmiclock_32.c               |    8 +-
 arch/x86/lguest/boot.c                      |    8 +-
 arch/xtensa/include/asm/hardirq.h           |    3 +-
 arch/xtensa/kernel/irq.c                    |    4 +-
 drivers/dma/ipu/ipu_irq.c                   |   18 ++--
 drivers/gpio/langwell_gpio.c                |   11 +-
 drivers/gpio/pca953x.c                      |   23 +++--
 drivers/gpio/pl061.c                        |   19 ++--
 drivers/gpio/timbgpio.c                     |   17 ++--
 drivers/gpio/vr41xx_giu.c                   |   32 +++---
 drivers/infiniband/hw/ipath/ipath_iba6110.c |    2 +-
 drivers/mfd/asic3.c                         |   27 +++--
 drivers/mfd/ezx-pcap.c                      |   12 ++-
 drivers/mfd/htc-egpio.c                     |   12 ++-
 drivers/mfd/t7l66xb.c                       |    8 +-
 drivers/mfd/tc6393xb.c                      |   14 ++-
 drivers/mfd/twl4030-irq.c                   |   16 ++--
 drivers/mfd/wm831x-irq.c                    |   18 ++--
 drivers/misc/sgi-gru/grufile.c              |    2 +-
 drivers/parisc/dino.c                       |   12 +-
 drivers/parisc/eisa.c                       |   10 +-
 drivers/parisc/gsc.c                        |   12 +-
 drivers/parisc/iosapic.c                    |   16 ++-
 drivers/parisc/superio.c                    |   10 +-
 drivers/pci/dmar.c                          |   16 ++--
 drivers/pci/htirq.c                         |   22 ++--
 drivers/pci/msi.c                           |   13 ++-
 drivers/vlynq/vlynq.c                       |   23 +++--
 drivers/xen/events.c                        |   22 ++--
 include/asm-generic/hardirq.h               |    4 +-
 include/linux/dmar.h                        |    8 +-
 include/linux/htirq.h                       |   11 +-
 include/linux/irq.h                         |   49 +++++-----
 include/linux/msi.h                         |    4 +-
 kernel/irq/autoprobe.c                      |   12 +-
 kernel/irq/chip.c                           |   68 ++++++-------
 kernel/irq/handle.c                         |   24 ++---
 kernel/irq/internals.h                      |   16 ++--
 kernel/irq/manage.c                         |   67 ++++++-------
 kernel/irq/migration.c                      |   16 +--
 kernel/irq/pm.c                             |    4 +-
 kernel/irq/resend.c                         |    8 +-
 kernel/irq/spurious.c                       |    4 +-
 79 files changed, 585 insertions(+), 562 deletions(-)

diff --git a/arch/alpha/include/asm/hardirq.h b/arch/alpha/include/asm/hardirq.h
index 242c09b..80f79f4 100644
--- a/arch/alpha/include/asm/hardirq.h
+++ b/arch/alpha/include/asm/hardirq.h
@@ -1,7 +1,8 @@
 #ifndef _ALPHA_HARDIRQ_H
 #define _ALPHA_HARDIRQ_H
 
-void ack_bad_irq(unsigned int irq);
+struct irq_desc;
+void ack_bad_irq(struct irq_desc *desc);
 #define ack_bad_irq ack_bad_irq
 
 #include <asm-generic/hardirq.h>
diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index 5f2cf23..08a6384 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -33,10 +33,10 @@
 
 volatile unsigned long irq_err_count;
 
-void ack_bad_irq(unsigned int irq)
+void ack_bad_irq(struct irq_desc *desc)
 {
 	irq_err_count++;
-	printk(KERN_CRIT "Unexpected IRQ trap at vector %u\n", irq);
+	printk(KERN_CRIT "Unexpected IRQ trap at vector %u\n", desc->irq);
 }
 
 #ifdef CONFIG_SMP 
diff --git a/arch/arm/include/asm/hw_irq.h b/arch/arm/include/asm/hw_irq.h
index 90831f6..43a8c03 100644
--- a/arch/arm/include/asm/hw_irq.h
+++ b/arch/arm/include/asm/hw_irq.h
@@ -4,7 +4,8 @@
 #ifndef _ARCH_ARM_HW_IRQ_H
 #define _ARCH_ARM_HW_IRQ_H
 
-static inline void ack_bad_irq(int irq)
+struct irq_desc;
+static inline void ack_bad_irq(struct irq_desc *desc)
 {
 	extern unsigned long irq_err_count;
 	irq_err_count++;
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index b7cb45b..265e78c 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -116,7 +116,7 @@ asmlinkage void __exception asm_do_IRQ(unsigned int irq, struct pt_regs *regs)
 	if (unlikely(irq >= NR_IRQS)) {
 		if (printk_ratelimit())
 			printk(KERN_WARNING "Bad IRQ%u\n", irq);
-		ack_bad_irq(irq);
+		ack_bad_irq(irq_to_desc(irq));
 	} else {
 		generic_handle_irq(irq);
 	}
diff --git a/arch/blackfin/include/asm/hardirq.h b/arch/blackfin/include/asm/hardirq.h
index c078dd7..e5ed5d5 100644
--- a/arch/blackfin/include/asm/hardirq.h
+++ b/arch/blackfin/include/asm/hardirq.h
@@ -9,7 +9,8 @@
 
 #define __ARCH_IRQ_EXIT_IRQS_DISABLED	1
 
-extern void ack_bad_irq(unsigned int irq);
+struct irq_desc;
+extern void ack_bad_irq(struct irq_desc *desc);
 #define ack_bad_irq ack_bad_irq
 
 /* Define until common code gets sane defaults */
diff --git a/arch/blackfin/kernel/irqchip.c b/arch/blackfin/kernel/irqchip.c
index 64cff54..707a93b 100644
--- a/arch/blackfin/kernel/irqchip.c
+++ b/arch/blackfin/kernel/irqchip.c
@@ -15,10 +15,10 @@
 #include <asm/pda.h>
 
 static atomic_t irq_err_count;
-void ack_bad_irq(unsigned int irq)
+void ack_bad_irq(struct irq_desc *desc)
 {
 	atomic_inc(&irq_err_count);
-	printk(KERN_ERR "IRQ: spurious interrupt %d\n", irq);
+	printk(KERN_ERR "IRQ: spurious interrupt %d\n", desc->irq);
 }
 
 static struct irq_desc bad_irq_desc = {
diff --git a/arch/frv/include/asm/hardirq.h b/arch/frv/include/asm/hardirq.h
index 5fc8b6f..2c49141 100644
--- a/arch/frv/include/asm/hardirq.h
+++ b/arch/frv/include/asm/hardirq.h
@@ -14,8 +14,9 @@
 
 #include <asm/atomic.h>
 
+struct irq_desc;
 extern atomic_t irq_err_count;
-static inline void ack_bad_irq(int irq)
+static inline void ack_bad_irq(struct irq_desc *desc)
 {
 	atomic_inc(&irq_err_count);
 }
diff --git a/arch/ia64/hp/sim/hpsim_irq.c b/arch/ia64/hp/sim/hpsim_irq.c
index b272261..de7c5d1 100644
--- a/arch/ia64/hp/sim/hpsim_irq.c
+++ b/arch/ia64/hp/sim/hpsim_irq.c
@@ -11,18 +11,18 @@
 #include <linux/irq.h>
 
 static unsigned int
-hpsim_irq_startup (unsigned int irq)
+hpsim_irq_startup(struct irq_desc *desc)
 {
 	return 0;
 }
 
 static void
-hpsim_irq_noop (unsigned int irq)
+hpsim_irq_noop(struct irq_desc *desc)
 {
 }
 
 static int
-hpsim_set_affinity_noop(unsigned int a, const struct cpumask *b)
+hpsim_set_affinity_noop(struct irq_desc *desc, const struct cpumask *b)
 {
 	return 0;
 }
diff --git a/arch/ia64/include/asm/hardirq.h b/arch/ia64/include/asm/hardirq.h
index d514cd9..cc9950b 100644
--- a/arch/ia64/include/asm/hardirq.h
+++ b/arch/ia64/include/asm/hardirq.h
@@ -22,6 +22,6 @@
 
 extern void __iomem *ipi_base_addr;
 
-void ack_bad_irq(unsigned int irq);
+void ack_bad_irq(struct irq_desc *desc);
 
 #endif /* _ASM_IA64_HARDIRQ_H */
diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
index 95ac77a..0edfbb4 100644
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -264,7 +264,7 @@ set_rte (unsigned int gsi, unsigned int irq, unsigned int dest, int mask)
 }
 
 static void
-nop (unsigned int irq)
+nop(struct irq_desc *desc)
 {
 	/* do nothing... */
 }
@@ -294,8 +294,9 @@ kexec_disable_iosapic(void)
 #endif
 
 static void
-mask_irq (unsigned int irq)
+mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 low32;
 	int rte_index;
 	struct iosapic_rte_info *rte;
@@ -312,8 +313,9 @@ mask_irq (unsigned int irq)
 }
 
 static void
-unmask_irq (unsigned int irq)
+unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 low32;
 	int rte_index;
 	struct iosapic_rte_info *rte;
@@ -328,11 +330,11 @@ unmask_irq (unsigned int irq)
 	}
 }
 
-
 static int
-iosapic_set_affinity(unsigned int irq, const struct cpumask *mask)
+iosapic_set_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
 #ifdef CONFIG_SMP
+	unsigned int irq = desc->irq;
 	u32 high32, low32;
 	int cpu, dest, rte_index;
 	int redir = (irq & IA64_IRQ_REDIRECTED) ? 1 : 0;
@@ -386,31 +388,32 @@ iosapic_set_affinity(unsigned int irq, const struct cpumask *mask)
  */
 
 static unsigned int
-iosapic_startup_level_irq (unsigned int irq)
+iosapic_startup_level_irq (struct irq_desc *desc)
 {
-	unmask_irq(irq);
+	unmask_irq(desc);
 	return 0;
 }
 
 static void
-iosapic_end_level_irq (unsigned int irq)
+iosapic_end_level_irq (struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ia64_vector vec = irq_to_vector(irq);
 	struct iosapic_rte_info *rte;
 	int do_unmask_irq = 0;
 
 	irq_complete_move(irq);
-	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
+	if (unlikely(desc->status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
-		mask_irq(irq);
+		mask_irq(desc);
 	}
 
 	list_for_each_entry(rte, &iosapic_intr_info[irq].rtes, rte_list)
 		iosapic_eoi(rte->iosapic->addr, vec);
 
 	if (unlikely(do_unmask_irq)) {
-		move_masked_irq(irq);
-		unmask_irq(irq);
+		move_masked_irq(desc);
+		unmask_irq(desc);
 	}
 }
 
@@ -437,9 +440,9 @@ static struct irq_chip irq_type_iosapic_level = {
  */
 
 static unsigned int
-iosapic_startup_edge_irq (unsigned int irq)
+iosapic_startup_edge_irq (struct irq_desc *desc)
 {
-	unmask_irq(irq);
+	unmask_irq(desc);
 	/*
 	 * IOSAPIC simply drops interrupts pended while the
 	 * corresponding pin was masked, so we can't know if an
@@ -449,20 +452,20 @@ iosapic_startup_edge_irq (unsigned int irq)
 }
 
 static void
-iosapic_ack_edge_irq (unsigned int irq)
+iosapic_ack_edge_irq (struct irq_desc *desc)
 {
-	struct irq_desc *idesc = irq_desc + irq;
+	unsigned int irq = desc->irq;
 
 	irq_complete_move(irq);
-	move_native_irq(irq);
+	move_native_irq(desc);
 	/*
 	 * Once we have recorded IRQ_PENDING already, we can mask the
 	 * interrupt for real. This prevents IRQ storms from unhandled
 	 * devices.
 	 */
-	if ((idesc->status & (IRQ_PENDING|IRQ_DISABLED)) ==
+	if ((desc->status & (IRQ_PENDING|IRQ_DISABLED)) ==
 	    (IRQ_PENDING|IRQ_DISABLED))
-		mask_irq(irq);
+		mask_irq(desc);
 }
 
 #define iosapic_enable_edge_irq		unmask_irq
diff --git a/arch/ia64/kernel/irq.c b/arch/ia64/kernel/irq.c
index 94ee9d0..d4fe756 100644
--- a/arch/ia64/kernel/irq.c
+++ b/arch/ia64/kernel/irq.c
@@ -27,9 +27,9 @@
  * 'what should we do if we get a hw irq event on an illegal vector'.
  * each architecture has to answer this themselves.
  */
-void ack_bad_irq(unsigned int irq)
+void ack_bad_irq(struct irq_desc *desc)
 {
-	printk(KERN_ERR "Unexpected irq vector 0x%x on CPU %u!\n", irq, smp_processor_id());
+	printk(KERN_ERR "Unexpected irq vector 0x%x on CPU %u!\n", desc->irq, smp_processor_id());
 }
 
 #ifdef CONFIG_IA64_GENERIC
@@ -162,10 +162,10 @@ static void migrate_irqs(void)
 			 */
 			if (desc->chip && desc->chip->disable &&
 				desc->chip->enable && desc->chip->set_affinity) {
-				desc->chip->disable(irq);
-				desc->chip->set_affinity(irq,
+				desc->chip->disable(desc);
+				desc->chip->set_affinity(desc,
 							 cpumask_of(new_cpu));
-				desc->chip->enable(irq);
+				desc->chip->enable(desc);
 			} else {
 				WARN_ON((!(desc->chip) || !(desc->chip->disable) ||
 						!(desc->chip->enable) ||
diff --git a/arch/ia64/kernel/irq_lsapic.c b/arch/ia64/kernel/irq_lsapic.c
index fc1549d..438641a 100644
--- a/arch/ia64/kernel/irq_lsapic.c
+++ b/arch/ia64/kernel/irq_lsapic.c
@@ -15,19 +15,21 @@
 #include <linux/irq.h>
 
 static unsigned int
-lsapic_noop_startup (unsigned int irq)
+lsapic_noop_startup(struct irq_desc *desc)
 {
 	return 0;
 }
 
 static void
-lsapic_noop (unsigned int irq)
+lsapic_noop(struct irq_desc *desc)
 {
 	/* nothing to do... */
 }
 
-static int lsapic_retrigger(unsigned int irq)
+static int lsapic_retrigger(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	ia64_resend_irq(irq);
 
 	return 1;
diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index 6c89228..d33f88c 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -12,9 +12,10 @@
 static struct irq_chip	ia64_msi_chip;
 
 #ifdef CONFIG_SMP
-static int ia64_set_msi_irq_affinity(unsigned int irq,
+static int ia64_set_msi_irq_affinity(struct irq_desc *desc,
 				      const cpumask_t *cpu_mask)
 {
+	unsigned int irq = desc->irq;
 	struct msi_msg msg;
 	u32 addr, data;
 	int cpu = first_cpu(*cpu_mask);
@@ -38,7 +39,7 @@ static int ia64_set_msi_irq_affinity(unsigned int irq,
 	msg.data = data;
 
 	write_msi_msg(irq, &msg);
-	cpumask_copy(irq_desc[irq].affinity, cpumask_of(cpu));
+	cpumask_copy(desc->affinity, cpumask_of(cpu));
 
 	return 0;
 }
@@ -84,15 +85,17 @@ void ia64_teardown_msi_irq(unsigned int irq)
 	destroy_irq(irq);
 }
 
-static void ia64_ack_msi_irq(unsigned int irq)
+static void ia64_ack_msi_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	irq_complete_move(irq);
-	move_native_irq(irq);
+	move_native_irq(desc);
 	ia64_eoi();
 }
 
-static int ia64_msi_retrigger_irq(unsigned int irq)
+static int ia64_msi_retrigger_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int vector = irq_to_vector(irq);
 	ia64_resend_irq(vector);
 
@@ -132,8 +135,9 @@ void arch_teardown_msi_irq(unsigned int irq)
 
 #ifdef CONFIG_DMAR
 #ifdef CONFIG_SMP
-static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int dmar_msi_set_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
+	unsigned int irq = desc->irq;
 	struct irq_cfg *cfg = irq_cfg + irq;
 	struct msi_msg msg;
 	int cpu = cpumask_first(mask);
@@ -152,7 +156,7 @@ static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID_CPU(cpu_physical_id(cpu));
 
 	dmar_msi_write(irq, &msg);
-	cpumask_copy(irq_desc[irq].affinity, mask);
+	cpumask_copy(desc->affinity, mask);
 
 	return 0;
 }
@@ -198,11 +202,12 @@ int arch_setup_dmar_msi(unsigned int irq)
 {
 	int ret;
 	struct msi_msg msg;
+	struct irq_desc *desc = irq_to_desc(irq);
 
 	ret = msi_compose_msg(NULL, irq, &msg);
 	if (ret < 0)
 		return ret;
-	dmar_msi_write(irq, &msg);
+	dmar_msi_write(desc, &msg);
 	set_irq_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
 		"edge");
 	return 0;
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index e5230b2..7241118 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -696,9 +696,9 @@ int migrate_platform_irqs(unsigned int cpu)
 			 * polling before making changes.
 			 */
 			if (desc) {
-				desc->chip->disable(ia64_cpe_irq);
-				desc->chip->set_affinity(ia64_cpe_irq, mask);
-				desc->chip->enable(ia64_cpe_irq);
+				desc->chip->disable(desc);
+				desc->chip->set_affinity(desc, mask);
+				desc->chip->enable(desc);
 				printk ("Re-targetting CPEI to cpu %d\n", new_cpei_cpu);
 			}
 		}
diff --git a/arch/ia64/sn/kernel/irq.c b/arch/ia64/sn/kernel/irq.c
index 40d6eed..78bf9c3 100644
--- a/arch/ia64/sn/kernel/irq.c
+++ b/arch/ia64/sn/kernel/irq.c
@@ -77,31 +77,34 @@ u64 sn_intr_redirect(nasid_t local_nasid, int local_widget,
 	return ret_stuff.status;
 }
 
-static unsigned int sn_startup_irq(unsigned int irq)
+static unsigned int sn_startup_irq(struct irq_desc *desc)
 {
 	return 0;
 }
 
-static void sn_shutdown_irq(unsigned int irq)
+static void sn_shutdown_irq(struct irq_desc *desc)
 {
 }
 
 extern void ia64_mca_register_cpev(int);
 
-static void sn_disable_irq(unsigned int irq)
+static void sn_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (irq == local_vector_to_irq(IA64_CPE_VECTOR))
 		ia64_mca_register_cpev(0);
 }
 
-static void sn_enable_irq(unsigned int irq)
+static void sn_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (irq == local_vector_to_irq(IA64_CPE_VECTOR))
 		ia64_mca_register_cpev(irq);
 }
 
-static void sn_ack_irq(unsigned int irq)
+static void sn_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u64 event_occurred, mask;
 
 	irq = irq & 0xff;
@@ -110,11 +113,12 @@ static void sn_ack_irq(unsigned int irq)
 	HUB_S((u64*)LOCAL_MMR_ADDR(SH_EVENT_OCCURRED_ALIAS), mask);
 	__set_bit(irq, (volatile void *)pda->sn_in_service_ivecs);
 
-	move_native_irq(irq);
+	move_native_irq(desc);
 }
 
-static void sn_end_irq(unsigned int irq)
+static void sn_end_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int ivec;
 	u64 event_occurred;
 
@@ -227,8 +231,9 @@ finish_up:
 	return new_irq_info;
 }
 
-static int sn_set_affinity_irq(unsigned int irq, const struct cpumask *mask)
+static int sn_set_affinity_irq(struct irq_desc *desc, const struct cpumask *mask)
 {
+	unsigned int irq = desc->irq;
 	struct sn_irq_info *sn_irq_info, *sn_irq_info_safe;
 	nasid_t nasid;
 	int slice;
@@ -258,12 +263,12 @@ void sn_set_err_irq_affinity(unsigned int irq) { }
 #endif
 
 static void
-sn_mask_irq(unsigned int irq)
+sn_mask_irq(struct irq_desc *desc)
 {
 }
 
 static void
-sn_unmask_irq(unsigned int irq)
+sn_unmask_irq(struct irq_desc *desc)
 {
 }
 
diff --git a/arch/ia64/sn/kernel/msi_sn.c b/arch/ia64/sn/kernel/msi_sn.c
index fbbfb97..df63df0 100644
--- a/arch/ia64/sn/kernel/msi_sn.c
+++ b/arch/ia64/sn/kernel/msi_sn.c
@@ -151,9 +151,10 @@ int sn_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *entry)
 }
 
 #ifdef CONFIG_SMP
-static int sn_set_msi_irq_affinity(unsigned int irq,
+static int sn_set_msi_irq_affinity(struct irq_desc *desc,
 				    const struct cpumask *cpu_mask)
 {
+	unsigned int irq = desc->irq;
 	struct msi_msg msg;
 	int slice;
 	nasid_t nasid;
@@ -205,20 +206,21 @@ static int sn_set_msi_irq_affinity(unsigned int irq,
 	msg.address_lo = (u32)(bus_addr & 0x00000000ffffffff);
 
 	write_msi_msg(irq, &msg);
-	cpumask_copy(irq_desc[irq].affinity, cpu_mask);
+	cpumask_copy(desc->affinity, cpu_mask);
 
 	return 0;
 }
 #endif /* CONFIG_SMP */
 
-static void sn_ack_msi_irq(unsigned int irq)
+static void sn_ack_msi_irq(struct irq_desc *desc)
 {
-	move_native_irq(irq);
+	move_native_irq(desc);
 	ia64_eoi();
 }
 
-static int sn_msi_retrigger_irq(unsigned int irq)
+static int sn_msi_retrigger_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int vector = irq;
 	ia64_resend_irq(vector);
 
diff --git a/arch/mips/include/asm/hardirq.h b/arch/mips/include/asm/hardirq.h
index c977a86..a230b5e 100644
--- a/arch/mips/include/asm/hardirq.h
+++ b/arch/mips/include/asm/hardirq.h
@@ -10,7 +10,8 @@
 #ifndef _ASM_HARDIRQ_H
 #define _ASM_HARDIRQ_H
 
-extern void ack_bad_irq(unsigned int irq);
+struct irq_desc;
+extern void ack_bad_irq(struct irq_desc *desc);
 #define ack_bad_irq ack_bad_irq
 
 #include <asm-generic/hardirq.h>
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index 981f86c..619db4a 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -74,8 +74,9 @@ void free_irqno(unsigned int irq)
  * 'what should we do if we get a hw irq event on an illegal vector'.
  * each architecture has to answer this themselves.
  */
-void ack_bad_irq(unsigned int irq)
+void ack_bad_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	smtc_im_ack_irq(irq);
 	printk("unexpected IRQ # %d\n", irq);
 }
diff --git a/arch/mn10300/include/asm/hardirq.h b/arch/mn10300/include/asm/hardirq.h
index 54d9501..725a812 100644
--- a/arch/mn10300/include/asm/hardirq.h
+++ b/arch/mn10300/include/asm/hardirq.h
@@ -26,7 +26,7 @@ typedef struct {
 
 #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
 
-extern void ack_bad_irq(int irq);
+extern void ack_bad_irq(struct irq_desc *desc);
 
 /*
  * manipulate stubs in the MN10300 CPU Trap/Interrupt Vector table
diff --git a/arch/mn10300/kernel/irq.c b/arch/mn10300/kernel/irq.c
index e2d5ed8..bc98665 100644
--- a/arch/mn10300/kernel/irq.c
+++ b/arch/mn10300/kernel/irq.c
@@ -100,9 +100,9 @@ static struct irq_chip mn10300_cpu_pic_edge = {
  * 'what should we do if we get a hw irq event on an illegal vector'.
  * each architecture has to answer this themselves.
  */
-void ack_bad_irq(int irq)
+void ack_bad_irq(struct irq_desc *desc)
 {
-	printk(KERN_WARNING "unexpected IRQ trap at vector %02x\n", irq);
+	printk(KERN_WARNING "unexpected IRQ trap at vector %02x\n", desc->irq);
 }
 
 /*
diff --git a/arch/powerpc/include/asm/hardirq.h b/arch/powerpc/include/asm/hardirq.h
index 3147a29..945c7d2 100644
--- a/arch/powerpc/include/asm/hardirq.h
+++ b/arch/powerpc/include/asm/hardirq.h
@@ -18,9 +18,9 @@ DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 
 #define local_softirq_pending()	__get_cpu_var(irq_stat).__softirq_pending
 
-static inline void ack_bad_irq(unsigned int irq)
+static inline void ack_bad_irq(struct irq_desc *desc)
 {
-	printk(KERN_CRIT "unexpected IRQ trap at vector %02x\n", irq);
+	printk(KERN_CRIT "unexpected IRQ trap at vector %02x\n", desc->irq);
 }
 
 extern u64 arch_irq_stat_cpu(unsigned int cpu);
diff --git a/arch/sh/include/asm/hardirq.h b/arch/sh/include/asm/hardirq.h
index 48b1913..c5c08c8 100644
--- a/arch/sh/include/asm/hardirq.h
+++ b/arch/sh/include/asm/hardirq.h
@@ -11,6 +11,7 @@ typedef struct {
 
 #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
 
-extern void ack_bad_irq(unsigned int irq);
+struct irq_desc;
+extern void ack_bad_irq(struct irq_desc *desc);
 
 #endif /* __ASM_SH_HARDIRQ_H */
diff --git a/arch/sh/kernel/irq.c b/arch/sh/kernel/irq.c
index d2d41d0..556e3d3 100644
--- a/arch/sh/kernel/irq.c
+++ b/arch/sh/kernel/irq.c
@@ -25,10 +25,10 @@ atomic_t irq_err_count;
  * each architecture has to answer this themselves, it doesn't deserve
  * a generic callback i think.
  */
-void ack_bad_irq(unsigned int irq)
+void ack_bad_irq(struct irq_desc *desc)
 {
 	atomic_inc(&irq_err_count);
-	printk("unexpected IRQ trap at vector %02x\n", irq);
+	printk("unexpected IRQ trap at vector %02x\n", desc->irq);
 }
 
 #if defined(CONFIG_PROC_FS)
diff --git a/arch/sparc/include/asm/hardirq_64.h b/arch/sparc/include/asm/hardirq_64.h
index 7c29fd1..6601974 100644
--- a/arch/sparc/include/asm/hardirq_64.h
+++ b/arch/sparc/include/asm/hardirq_64.h
@@ -12,7 +12,8 @@
 #define local_softirq_pending() \
 	(local_cpu_data().__softirq_pending)
 
-void ack_bad_irq(unsigned int irq);
+struct irq_desc;
+void ack_bad_irq(struct irq_desc *desc);
 
 #define HARDIRQ_BITS	8
 
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index e1cbdb9..4e7419c 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -689,8 +689,9 @@ unsigned int sun4v_build_virq(u32 devhandle, unsigned int devino)
 	return virt_irq;
 }
 
-void ack_bad_irq(unsigned int virt_irq)
+void ack_bad_irq(struct irq_desc_desc *desc)
 {
+	unsigned int virt_irq = desc->irq;
 	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
 
 	if (!ino)
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 89474ba..2c21218 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -362,7 +362,7 @@ EXPORT_SYMBOL(reactivate_fd);
  * irq_chip must define (startup || enable) &&
  * (shutdown || disable) && end
  */
-static void dummy(unsigned int irq)
+static void dummy(struct irq_desc *desc)
 {
 }
 
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
index cd2f193..d3b2f0b 100644
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
@@ -3452,9 +3420,8 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 }
 
 #ifdef CONFIG_SMP
-static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int set_msi_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
@@ -3481,9 +3448,9 @@ static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
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
@@ -3581,8 +3548,9 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 {
 	int ret;
 	struct msi_msg msg;
+	struct irq_desc *desc = irq_to_desc(irq);
 
-	ret = msi_compose_msg(dev, irq, &msg, -1);
+	ret = msi_compose_msg(dev, desc, &msg, -1);
 	if (ret < 0)
 		return ret;
 
@@ -3590,7 +3558,6 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 	write_msi_msg(irq, &msg);
 
 	if (irq_remapped(irq)) {
-		struct irq_desc *desc = irq_to_desc(irq);
 		/*
 		 * irq migration in process context
 		 */
@@ -3672,9 +3639,8 @@ void arch_teardown_msi_irq(unsigned int irq)
 
 #if defined (CONFIG_DMAR) || defined (CONFIG_INTR_REMAP)
 #ifdef CONFIG_SMP
-static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int dmar_msi_set_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
@@ -3684,14 +3650,14 @@ static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 
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
@@ -3716,11 +3682,12 @@ int arch_setup_dmar_msi(unsigned int irq)
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
@@ -3730,9 +3697,8 @@ int arch_setup_dmar_msi(unsigned int irq)
 #ifdef CONFIG_HPET_TIMER
 
 #ifdef CONFIG_SMP
-static int hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int hpet_msi_set_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
@@ -3742,14 +3708,14 @@ static int hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 
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
@@ -3804,11 +3770,11 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
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
@@ -3829,10 +3795,10 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 
 #ifdef CONFIG_SMP
 
-static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
+static void target_ht_irq(struct irq_desc *desc, unsigned int dest, u8 vector)
 {
 	struct ht_irq_msg msg;
-	fetch_ht_irq_msg(irq, &msg);
+	fetch_ht_irq_msg(desc, &msg);
 
 	msg.address_lo &= ~(HT_IRQ_LOW_VECTOR_MASK | HT_IRQ_LOW_DEST_ID_MASK);
 	msg.address_hi &= ~(HT_IRQ_HIGH_DEST_ID_MASK);
@@ -3840,12 +3806,11 @@ static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
 	msg.address_lo |= HT_IRQ_LOW_VECTOR(vector) | HT_IRQ_LOW_DEST_ID(dest);
 	msg.address_hi |= HT_IRQ_HIGH_DEST_ID(dest);
 
-	write_ht_irq_msg(irq, &msg);
+	write_ht_irq_msg(desc, &msg);
 }
 
-static int set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int set_ht_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	unsigned int dest;
 
@@ -3854,7 +3819,7 @@ static int set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
 
 	cfg = desc->chip_data;
 
-	target_ht_irq(irq, dest, cfg->vector);
+	target_ht_irq(desc, dest, cfg->vector);
 
 	return 0;
 }
@@ -3909,7 +3874,7 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 				HT_IRQ_LOW_MT_ARBITRATED) |
 			HT_IRQ_LOW_IRQ_MASKED;
 
-		write_ht_irq_msg(irq, &msg);
+		write_ht_irq_msg(desc, &msg);
 
 		set_irq_chip_and_handler_name(irq, &ht_irq_chip,
 					      handle_edge_irq, "edge");
@@ -4399,7 +4364,7 @@ void __init pre_init_apic_IRQ0(void)
 
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
index 44c430d..2b601d3 100644
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
@@ -208,9 +208,9 @@ static void arch_disable_uv_irq(int mmr_pnode, unsigned long mmr_offset)
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
 }
 
-static int uv_set_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int uv_set_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
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
diff --git a/arch/xtensa/include/asm/hardirq.h b/arch/xtensa/include/asm/hardirq.h
index 87cb19d..f0230ff 100644
--- a/arch/xtensa/include/asm/hardirq.h
+++ b/arch/xtensa/include/asm/hardirq.h
@@ -22,7 +22,8 @@ typedef struct {
 	unsigned int __nmi_count;	       /* arch dependent */
 } ____cacheline_aligned irq_cpustat_t;
 
-void ack_bad_irq(unsigned int irq);
+struct irq_desc;
+void ack_bad_irq(struct irq_desc *desc);
 #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
 
 #endif	/* _XTENSA_HARDIRQ_H */
diff --git a/arch/xtensa/kernel/irq.c b/arch/xtensa/kernel/irq.c
index 8cd3848..f86cf05 100644
--- a/arch/xtensa/kernel/irq.c
+++ b/arch/xtensa/kernel/irq.c
@@ -30,9 +30,9 @@ atomic_t irq_err_count;
  * 'what should we do if we get a hw irq event on an illegal vector'.
  * each architecture has to answer this themselves.
  */
-void ack_bad_irq(unsigned int irq)
+void ack_bad_irq(struct irq_desc *desc)
 {
-          printk("unexpected IRQ trap at vector %02x\n", irq);
+          printk("unexpected IRQ trap at vector %02x\n", desc->irq);
 }
 
 /*
diff --git a/drivers/dma/ipu/ipu_irq.c b/drivers/dma/ipu/ipu_irq.c
index dd8ebc7..62f4307 100644
--- a/drivers/dma/ipu/ipu_irq.c
+++ b/drivers/dma/ipu/ipu_irq.c
@@ -94,9 +94,9 @@ static struct ipu_irq_map *src2map(unsigned int src)
 	return NULL;
 }
 
-static void ipu_irq_unmask(unsigned int irq)
+static void ipu_irq_unmask(struct irq_desc *desc)
 {
-	struct ipu_irq_map *map = get_irq_chip_data(irq);
+	struct ipu_irq_map *map = get_irq_desc_chip_data(desc);
 	struct ipu_irq_bank *bank;
 	uint32_t reg;
 	unsigned long lock_flags;
@@ -106,7 +106,7 @@ static void ipu_irq_unmask(unsigned int irq)
 	bank = map->bank;
 	if (!bank) {
 		spin_unlock_irqrestore(&bank_lock, lock_flags);
-		pr_err("IPU: %s(%u) - unmapped!\n", __func__, irq);
+		pr_err("IPU: %s(%u) - unmapped!\n", __func__, desc->irq);
 		return;
 	}
 
@@ -117,9 +117,9 @@ static void ipu_irq_unmask(unsigned int irq)
 	spin_unlock_irqrestore(&bank_lock, lock_flags);
 }
 
-static void ipu_irq_mask(unsigned int irq)
+static void ipu_irq_mask(struct irq_desc *desc)
 {
-	struct ipu_irq_map *map = get_irq_chip_data(irq);
+	struct ipu_irq_map *map = get_irq_desc_chip_data(desc);
 	struct ipu_irq_bank *bank;
 	uint32_t reg;
 	unsigned long lock_flags;
@@ -129,7 +129,7 @@ static void ipu_irq_mask(unsigned int irq)
 	bank = map->bank;
 	if (!bank) {
 		spin_unlock_irqrestore(&bank_lock, lock_flags);
-		pr_err("IPU: %s(%u) - unmapped!\n", __func__, irq);
+		pr_err("IPU: %s(%u) - unmapped!\n", __func__, desc->irq);
 		return;
 	}
 
@@ -140,9 +140,9 @@ static void ipu_irq_mask(unsigned int irq)
 	spin_unlock_irqrestore(&bank_lock, lock_flags);
 }
 
-static void ipu_irq_ack(unsigned int irq)
+static void ipu_irq_ack(struct irq_desc *desc)
 {
-	struct ipu_irq_map *map = get_irq_chip_data(irq);
+	struct ipu_irq_map *map = get_irq_desc_chip_data(desc);
 	struct ipu_irq_bank *bank;
 	unsigned long lock_flags;
 
@@ -151,7 +151,7 @@ static void ipu_irq_ack(unsigned int irq)
 	bank = map->bank;
 	if (!bank) {
 		spin_unlock_irqrestore(&bank_lock, lock_flags);
-		pr_err("IPU: %s(%u) - unmapped!\n", __func__, irq);
+		pr_err("IPU: %s(%u) - unmapped!\n", __func__, desc->irq);
 		return;
 	}
 
diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index 6c0ebbd..0eb44e7 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -113,9 +113,10 @@ static int lnw_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	return lnw->irq_base + offset;
 }
 
-static int lnw_irq_type(unsigned irq, unsigned type)
+static int lnw_irq_type(struct irq_desc *desc, unsigned type)
 {
-	struct lnw_gpio *lnw = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct lnw_gpio *lnw = get_irq_desc_chip_data(desc);
 	u32 gpio = irq - lnw->irq_base;
 	u8 reg = gpio / 32;
 	unsigned long flags;
@@ -142,11 +143,11 @@ static int lnw_irq_type(unsigned irq, unsigned type)
 	return 0;
 };
 
-static void lnw_irq_unmask(unsigned irq)
+static void lnw_irq_unmask(struct irq_desc *desc)
 {
 };
 
-static void lnw_irq_mask(unsigned irq)
+static void lnw_irq_mask(struct irq_desc *desc)
 {
 };
 
@@ -184,7 +185,7 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 		/* clear the edge detect status bit */
 		writel(gedr_v, gedr);
 	}
-	desc->chip->eoi(irq);
+	desc->chip->eoi(desc);
 }
 
 static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index ab5daab..9fb1ba3 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -227,37 +227,40 @@ static int pca953x_gpio_to_irq(struct gpio_chip *gc, unsigned off)
 	return chip->irq_base + off;
 }
 
-static void pca953x_irq_mask(unsigned int irq)
+static void pca953x_irq_mask(struct irq_desc *desc)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct pca953x_chip *chip = get_irq_desc_chip_data(desc);
 
 	chip->irq_mask &= ~(1 << (irq - chip->irq_base));
 }
 
-static void pca953x_irq_unmask(unsigned int irq)
+static void pca953x_irq_unmask(struct irq_desc *desc)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct pca953x_chip *chip = get_irq_desc_chip_data(desc);
 
 	chip->irq_mask |= 1 << (irq - chip->irq_base);
 }
 
-static void pca953x_irq_bus_lock(unsigned int irq)
+static void pca953x_irq_bus_lock(struct irq_desc *desc)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	struct pca953x_chip *chip = get_irq_desc_chip_data(desc);
 
 	mutex_lock(&chip->irq_lock);
 }
 
-static void pca953x_irq_bus_sync_unlock(unsigned int irq)
+static void pca953x_irq_bus_sync_unlock(struct irq_desc *desc)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	struct pca953x_chip *chip = get_irq_desc_chip_data(desc);
 
 	mutex_unlock(&chip->irq_lock);
 }
 
-static int pca953x_irq_set_type(unsigned int irq, unsigned int type)
+static int pca953x_irq_set_type(struct irq_desc *desc, unsigned int type)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct pca953x_chip *chip = get_irq_desc_chip_data(desc);
 	uint16_t level = irq - chip->irq_base;
 	uint16_t mask = 1 << level;
 
diff --git a/drivers/gpio/pl061.c b/drivers/gpio/pl061.c
index 3ad1eeb..9dddd6e 100644
--- a/drivers/gpio/pl061.c
+++ b/drivers/gpio/pl061.c
@@ -122,9 +122,10 @@ static int pl061_to_irq(struct gpio_chip *gc, unsigned offset)
 /*
  * PL061 GPIO IRQ
  */
-static void pl061_irq_disable(unsigned irq)
+static void pl061_irq_disable(struct irq_desc *desc)
 {
-	struct pl061_gpio *chip = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct pl061_gpio *chip = get_irq_desc_chip_data(desc);
 	int offset = irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpioie;
@@ -136,9 +137,10 @@ static void pl061_irq_disable(unsigned irq)
 	spin_unlock_irqrestore(&chip->irq_lock, flags);
 }
 
-static void pl061_irq_enable(unsigned irq)
+static void pl061_irq_enable(struct irq_desc *desc)
 {
-	struct pl061_gpio *chip = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct pl061_gpio *chip = get_irq_desc_chip_data(desc);
 	int offset = irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpioie;
@@ -150,9 +152,10 @@ static void pl061_irq_enable(unsigned irq)
 	spin_unlock_irqrestore(&chip->irq_lock, flags);
 }
 
-static int pl061_irq_type(unsigned irq, unsigned trigger)
+static int pl061_irq_type(struct irq_desc *desc, unsigned trigger)
 {
-	struct pl061_gpio *chip = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct pl061_gpio *chip = get_irq_desc_chip_data(desc);
 	int offset = irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpiois, gpioibe, gpioiev;
@@ -207,7 +210,7 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 	struct list_head *ptr;
 	struct pl061_gpio *chip;
 
-	desc->chip->ack(irq);
+	desc->chip->ack(desc);
 	list_for_each(ptr, chip_list) {
 		unsigned long pending;
 		int offset;
@@ -222,7 +225,7 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 		for_each_set_bit(offset, &pending, PL061_GPIO_NR)
 			generic_handle_irq(pl061_to_irq(&chip->gc, offset));
 	}
-	desc->chip->unmask(irq);
+	desc->chip->unmask(desc);
 }
 
 static int __init pl061_probe(struct amba_device *dev, struct amba_id *id)
diff --git a/drivers/gpio/timbgpio.c b/drivers/gpio/timbgpio.c
index d4295fa..55c51f5 100644
--- a/drivers/gpio/timbgpio.c
+++ b/drivers/gpio/timbgpio.c
@@ -107,25 +107,28 @@ static int timbgpio_to_irq(struct gpio_chip *gpio, unsigned offset)
 /*
  * GPIO IRQ
  */
-static void timbgpio_irq_disable(unsigned irq)
+static void timbgpio_irq_disable(struct irq_desc *desc)
 {
-	struct timbgpio *tgpio = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct timbgpio *tgpio = get_irq_desc_chip_data(desc);
 	int offset = irq - tgpio->irq_base;
 
 	timbgpio_update_bit(&tgpio->gpio, offset, TGPIO_IER, 0);
 }
 
-static void timbgpio_irq_enable(unsigned irq)
+static void timbgpio_irq_enable(struct irq_desc *desc)
 {
-	struct timbgpio *tgpio = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct timbgpio *tgpio = get_irq_desc_chip_data(desc);
 	int offset = irq - tgpio->irq_base;
 
 	timbgpio_update_bit(&tgpio->gpio, offset, TGPIO_IER, 1);
 }
 
-static int timbgpio_irq_type(unsigned irq, unsigned trigger)
+static int timbgpio_irq_type(struct irq_desc *desc, unsigned trigger)
 {
-	struct timbgpio *tgpio = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct timbgpio *tgpio = get_irq_desc_chip_data(desc);
 	int offset = irq - tgpio->irq_base;
 	unsigned long flags;
 	u32 lvr, flr, bflr = 0;
@@ -185,7 +188,7 @@ static void timbgpio_irq(unsigned int irq, struct irq_desc *desc)
 	unsigned long ipr;
 	int offset;
 
-	desc->chip->ack(irq);
+	desc->chip->ack(desc);
 	ipr = ioread32(tgpio->membase + TGPIO_IPR);
 	iowrite32(ipr, tgpio->membase + TGPIO_ICR);
 
diff --git a/drivers/gpio/vr41xx_giu.c b/drivers/gpio/vr41xx_giu.c
index b16c9a8..ea2e00f 100644
--- a/drivers/gpio/vr41xx_giu.c
+++ b/drivers/gpio/vr41xx_giu.c
@@ -111,28 +111,28 @@ static inline u16 giu_clear(u16 offset, u16 clear)
 	return data;
 }
 
-static void ack_giuint_low(unsigned int irq)
+static void ack_giuint_low(struct irq_desc *desc)
 {
-	giu_write(GIUINTSTATL, 1 << GPIO_PIN_OF_IRQ(irq));
+	giu_write(GIUINTSTATL, 1 << GPIO_PIN_OF_IRQ(desc->irq));
 }
 
-static void mask_giuint_low(unsigned int irq)
+static void mask_giuint_low(struct irq_desc *desc)
 {
-	giu_clear(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(irq));
+	giu_clear(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(desc->irq));
 }
 
-static void mask_ack_giuint_low(unsigned int irq)
+static void mask_ack_giuint_low(struct irq_desc *desc)
 {
 	unsigned int pin;
 
-	pin = GPIO_PIN_OF_IRQ(irq);
+	pin = GPIO_PIN_OF_IRQ(desc->irq);
 	giu_clear(GIUINTENL, 1 << pin);
 	giu_write(GIUINTSTATL, 1 << pin);
 }
 
-static void unmask_giuint_low(unsigned int irq)
+static void unmask_giuint_low(struct irq_desc *desc)
 {
-	giu_set(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(irq));
+	giu_set(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(desc->irq));
 }
 
 static struct irq_chip giuint_low_irq_chip = {
@@ -143,29 +143,29 @@ static struct irq_chip giuint_low_irq_chip = {
 	.unmask		= unmask_giuint_low,
 };
 
-static void ack_giuint_high(unsigned int irq)
+static void ack_giuint_high(struct irq_desc *desc)
 {
 	giu_write(GIUINTSTATH,
-		  1 << (GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET));
+		  1 << (GPIO_PIN_OF_IRQ(desc->irq) - GIUINT_HIGH_OFFSET));
 }
 
-static void mask_giuint_high(unsigned int irq)
+static void mask_giuint_high(struct irq_desc *desc)
 {
-	giu_clear(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET));
+	giu_clear(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(desc->irq) - GIUINT_HIGH_OFFSET));
 }
 
-static void mask_ack_giuint_high(unsigned int irq)
+static void mask_ack_giuint_high(struct irq_desc *desc)
 {
 	unsigned int pin;
 
-	pin = GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET;
+	pin = GPIO_PIN_OF_IRQ(desc->irq) - GIUINT_HIGH_OFFSET;
 	giu_clear(GIUINTENH, 1 << pin);
 	giu_write(GIUINTSTATH, 1 << pin);
 }
 
-static void unmask_giuint_high(unsigned int irq)
+static void unmask_giuint_high(struct irq_desc *desc)
 {
-	giu_set(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET));
+	giu_set(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(desc->irq) - GIUINT_HIGH_OFFSET));
 }
 
 static struct irq_chip giuint_high_irq_chip = {
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
diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 95c1e6b..609da5b 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -142,7 +142,7 @@ static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
 	unsigned long flags;
 	struct asic3 *asic;
 
-	desc->chip->ack(irq);
+	desc->chip->ack(desc);
 
 	asic = desc->handler_data;
 
@@ -225,9 +225,10 @@ static inline int asic3_irq_to_index(struct asic3 *asic, int irq)
 	return (irq - asic->irq_base) & 0xf;
 }
 
-static void asic3_mask_gpio_irq(unsigned int irq)
+static void asic3_mask_gpio_irq(struct irq_desc *desc)
 {
-	struct asic3 *asic = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct asic3 *asic = get_irq_desc_chip_data(desc);
 	u32 val, bank, index;
 	unsigned long flags;
 
@@ -241,9 +242,10 @@ static void asic3_mask_gpio_irq(unsigned int irq)
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
-static void asic3_mask_irq(unsigned int irq)
+static void asic3_mask_irq(struct irq_desc *desc)
 {
-	struct asic3 *asic = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct asic3 *asic = get_irq_desc_chip_data(desc);
 	int regval;
 	unsigned long flags;
 
@@ -262,9 +264,10 @@ static void asic3_mask_irq(unsigned int irq)
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
-static void asic3_unmask_gpio_irq(unsigned int irq)
+static void asic3_unmask_gpio_irq(struct irq_desc *desc)
 {
-	struct asic3 *asic = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct asic3 *asic = get_irq_desc_chip_data(desc);
 	u32 val, bank, index;
 	unsigned long flags;
 
@@ -278,9 +281,10 @@ static void asic3_unmask_gpio_irq(unsigned int irq)
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
-static void asic3_unmask_irq(unsigned int irq)
+static void asic3_unmask_irq(struct irq_desc *desc)
 {
-	struct asic3 *asic = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct asic3 *asic = get_irq_desc_chip_data(desc);
 	int regval;
 	unsigned long flags;
 
@@ -299,9 +303,10 @@ static void asic3_unmask_irq(unsigned int irq)
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
-static int asic3_gpio_irq_type(unsigned int irq, unsigned int type)
+static int asic3_gpio_irq_type(struct irq_desc *desc, unsigned int type)
 {
-	struct asic3 *asic = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct asic3 *asic = get_irq_desc_chip_data(desc);
 	u32 bank, index;
 	u16 trigger, level, edge, bit;
 	unsigned long flags;
diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index df405af..26d6f9b 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -143,17 +143,19 @@ int pcap_to_irq(struct pcap_chip *pcap, int irq)
 }
 EXPORT_SYMBOL_GPL(pcap_to_irq);
 
-static void pcap_mask_irq(unsigned int irq)
+static void pcap_mask_irq(struct irq_desc *desc)
 {
-	struct pcap_chip *pcap = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct pcap_chip *pcap = get_irq_desc_chip_data(desc);
 
 	pcap->msr |= 1 << irq_to_pcap(pcap, irq);
 	queue_work(pcap->workqueue, &pcap->msr_work);
 }
 
-static void pcap_unmask_irq(unsigned int irq)
+static void pcap_unmask_irq(struct irq_desc *desc)
 {
-	struct pcap_chip *pcap = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct pcap_chip *pcap = get_irq_desc_chip_data(desc);
 
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
diff --git a/drivers/mfd/htc-egpio.c b/drivers/mfd/htc-egpio.c
index addb846..629176b 100644
--- a/drivers/mfd/htc-egpio.c
+++ b/drivers/mfd/htc-egpio.c
@@ -69,22 +69,24 @@ static inline void ack_irqs(struct egpio_info *ei)
 			ei->ack_write, ei->ack_register << ei->bus_shift);
 }
 
-static void egpio_ack(unsigned int irq)
+static void egpio_ack(struct irq_desc *desc)
 {
 }
 
 /* There does not appear to be a way to proactively mask interrupts
  * on the egpio chip itself.  So, we simply ignore interrupts that
  * aren't desired. */
-static void egpio_mask(unsigned int irq)
+static void egpio_mask(struct irq_desc *desc)
 {
-	struct egpio_info *ei = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct egpio_info *ei = get_irq_desc_chip_data(desc);
 	ei->irqs_enabled &= ~(1 << (irq - ei->irq_start));
 	pr_debug("EGPIO mask %d %04x\n", irq, ei->irqs_enabled);
 }
-static void egpio_unmask(unsigned int irq)
+static void egpio_unmask(struct irq_desc *desc)
 {
-	struct egpio_info *ei = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct egpio_info *ei = get_irq_desc_chip_data(desc);
 	ei->irqs_enabled |= 1 << (irq - ei->irq_start);
 	pr_debug("EGPIO unmask %d %04x\n", irq, ei->irqs_enabled);
 }
diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
index 26d9176..05f23cd 100644
--- a/drivers/mfd/t7l66xb.c
+++ b/drivers/mfd/t7l66xb.c
@@ -198,9 +198,10 @@ static void t7l66xb_irq(unsigned int irq, struct irq_desc *desc)
 				generic_handle_irq(irq_base + i);
 }
 
-static void t7l66xb_irq_mask(unsigned int irq)
+static void t7l66xb_irq_mask(struct irq_desc *desc)
 {
-	struct t7l66xb *t7l66xb = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct t7l66xb *t7l66xb = get_irq_desc_chip_data(desc);
 	unsigned long			flags;
 	u8 imr;
 
@@ -211,8 +212,9 @@ static void t7l66xb_irq_mask(unsigned int irq)
 	spin_unlock_irqrestore(&t7l66xb->lock, flags);
 }
 
-static void t7l66xb_irq_unmask(unsigned int irq)
+static void t7l66xb_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct t7l66xb *t7l66xb = get_irq_chip_data(irq);
 	unsigned long flags;
 	u8 imr;
diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index c59e5c5..882a463 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -512,7 +512,7 @@ static int tc6393xb_register_gpio(struct tc6393xb *tc6393xb, int gpio_base)
 static void
 tc6393xb_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct tc6393xb *tc6393xb = get_irq_data(irq);
+	struct tc6393xb *tc6393xb = get_irq_desc_chip_data(desc);
 	unsigned int isr;
 	unsigned int i, irq_base;
 
@@ -526,13 +526,14 @@ tc6393xb_irq(unsigned int irq, struct irq_desc *desc)
 		}
 }
 
-static void tc6393xb_irq_ack(unsigned int irq)
+static void tc6393xb_irq_ack(struct irq_desc *desc)
 {
 }
 
-static void tc6393xb_irq_mask(unsigned int irq)
+static void tc6393xb_irq_mask(struct irq_desc *desc)
 {
-	struct tc6393xb *tc6393xb = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct tc6393xb *tc6393xb = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 	u8 imr;
 
@@ -543,9 +544,10 @@ static void tc6393xb_irq_mask(unsigned int irq)
 	spin_unlock_irqrestore(&tc6393xb->lock, flags);
 }
 
-static void tc6393xb_irq_unmask(unsigned int irq)
+static void tc6393xb_irq_unmask(struct irq_desc *desc)
 {
-	struct tc6393xb *tc6393xb = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct tc6393xb *tc6393xb = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 	u8 imr;
 
diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 9df9a5a..b5e30d5 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -595,9 +595,10 @@ static void twl4030_sih_do_edge(struct work_struct *work)
  * completion, potentially including some re-ordering, of these requests.
  */
 
-static void twl4030_sih_mask(unsigned irq)
+static void twl4030_sih_mask(struct irq_desc *desc)
 {
-	struct sih_agent *sih = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct sih_agent *sih = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 
 	spin_lock_irqsave(&sih_agent_lock, flags);
@@ -607,9 +608,10 @@ static void twl4030_sih_mask(unsigned irq)
 	spin_unlock_irqrestore(&sih_agent_lock, flags);
 }
 
-static void twl4030_sih_unmask(unsigned irq)
+static void twl4030_sih_unmask(struct irq_desc *desc)
 {
-	struct sih_agent *sih = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct sih_agent *sih = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 
 	spin_lock_irqsave(&sih_agent_lock, flags);
@@ -619,10 +621,10 @@ static void twl4030_sih_unmask(unsigned irq)
 	spin_unlock_irqrestore(&sih_agent_lock, flags);
 }
 
-static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
+static int twl4030_sih_set_type(struct irq_desc *desc, unsigned trigger)
 {
-	struct sih_agent *sih = get_irq_chip_data(irq);
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq = desc->irq;
+	struct sih_agent *sih = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 
 	if (!desc) {
diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 3013276..18ec226 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -346,16 +346,16 @@ static inline struct wm831x_irq_data *irq_to_wm831x_irq(struct wm831x *wm831x,
 	return &wm831x_irqs[irq - wm831x->irq_base];
 }
 
-static void wm831x_irq_lock(unsigned int irq)
+static void wm831x_irq_lock(struct irq_desc *desc)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	struct wm831x *wm831x = get_irq_desc_chip_data(desc);
 
 	mutex_lock(&wm831x->irq_lock);
 }
 
-static void wm831x_irq_sync_unlock(unsigned int irq)
+static void wm831x_irq_sync_unlock(struct irq_desc *des)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	struct wm831x *wm831x = get_irq_desc_chip_data(desc);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(wm831x->irq_masks_cur); i++) {
@@ -372,17 +372,19 @@ static void wm831x_irq_sync_unlock(unsigned int irq)
 	mutex_unlock(&wm831x->irq_lock);
 }
 
-static void wm831x_irq_unmask(unsigned int irq)
+static void wm831x_irq_unmask(struct irq_desc *desc)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct wm831x *wm831x = get_irq_desc_chip_data(desc);
 	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, irq);
 
 	wm831x->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
 }
 
-static void wm831x_irq_mask(unsigned int irq)
+static void wm831x_irq_mask(struct irq_desc *desc)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct wm831x *wm831x = get_irq_desc_chip_data(desc);
 	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, irq);
 
 	wm831x->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index cb3b4d2..36281e3 100644
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -348,7 +348,7 @@ static unsigned long gru_chiplet_cpu_to_mmr(int chiplet, int cpu, int *corep)
 
 static int gru_irq_count[GRU_CHIPLETS_PER_BLADE];
 
-static void gru_noop(unsigned int irq)
+static void gru_noop(struct irq_desc *desc)
 {
 }
 
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index c542c7b..3c89196 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -296,9 +296,9 @@ static struct pci_port_ops dino_port_ops = {
 	.outl	= dino_out32
 };
 
-static void dino_disable_irq(unsigned int irq)
+static void dino_disable_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq = desc->irq;
 	struct dino_device *dino_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, dino_dev->global_irq, DINO_LOCAL_IRQS);
 
@@ -309,9 +309,9 @@ static void dino_disable_irq(unsigned int irq)
 	__raw_writel(dino_dev->imr, dino_dev->hba.base_addr+DINO_IMR);
 }
 
-static void dino_enable_irq(unsigned int irq)
+static void dino_enable_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq = desc->irq;
 	struct dino_device *dino_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, dino_dev->global_irq, DINO_LOCAL_IRQS);
 	u32 tmp;
@@ -347,9 +347,9 @@ static void dino_enable_irq(unsigned int irq)
 	}
 }
 
-static unsigned int dino_startup_irq(unsigned int irq)
+static unsigned int dino_startup_irq(struct irq_desc *desc)
 {
-	dino_enable_irq(irq);
+	dino_enable_irq(desc);
 	return 0;
 }
 
diff --git a/drivers/parisc/eisa.c b/drivers/parisc/eisa.c
index 46f503f..f00d28e 100644
--- a/drivers/parisc/eisa.c
+++ b/drivers/parisc/eisa.c
@@ -144,8 +144,9 @@ static unsigned int eisa_irq_level __read_mostly; /* default to edge triggered *
 
 
 /* called by free irq */
-static void eisa_disable_irq(unsigned int irq)
+static void eisa_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 
 	EISA_DBG("disable irq %d\n", irq);
@@ -164,8 +165,9 @@ static void eisa_disable_irq(unsigned int irq)
 }
 
 /* called by request irq */
-static void eisa_enable_irq(unsigned int irq)
+static void eisa_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 	EISA_DBG("enable irq %d\n", irq);
 		
@@ -182,9 +184,9 @@ static void eisa_enable_irq(unsigned int irq)
 	EISA_DBG("pic1 mask %02x\n", eisa_in8(0xa1));
 }
 
-static unsigned int eisa_startup_irq(unsigned int irq)
+static unsigned int eisa_startup_irq(struct irq_desc *desc)
 {
-	eisa_enable_irq(irq);
+	eisa_enable_irq(desc);
 	return 0;
 }
 
diff --git a/drivers/parisc/gsc.c b/drivers/parisc/gsc.c
index c4e1f3c..d2fc47b 100644
--- a/drivers/parisc/gsc.c
+++ b/drivers/parisc/gsc.c
@@ -106,9 +106,9 @@ int gsc_find_local_irq(unsigned int irq, int *global_irqs, int limit)
 	return NO_IRQ;
 }
 
-static void gsc_asic_disable_irq(unsigned int irq)
+static void gsc_asic_disable_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq = desc->irq;
 	struct gsc_asic *irq_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, irq_dev->global_irq, 32);
 	u32 imr;
@@ -122,9 +122,9 @@ static void gsc_asic_disable_irq(unsigned int irq)
 	gsc_writel(imr, irq_dev->hpa + OFFSET_IMR);
 }
 
-static void gsc_asic_enable_irq(unsigned int irq)
+static void gsc_asic_enable_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq = desc->irq;
 	struct gsc_asic *irq_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, irq_dev->global_irq, 32);
 	u32 imr;
@@ -142,9 +142,9 @@ static void gsc_asic_enable_irq(unsigned int irq)
 	 */
 }
 
-static unsigned int gsc_asic_startup_irq(unsigned int irq)
+static unsigned int gsc_asic_startup_irq(struct irq_desc *desc)
 {
-	gsc_asic_enable_irq(irq);
+	gsc_asic_enable_irq(desc);
 	return 0;
 }
 
diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
index c768367..2ac290b 100644
--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -622,8 +622,9 @@ static struct vector_info *iosapic_get_vector(unsigned int irq)
 	return desc->chip_data;
 }
 
-static void iosapic_disable_irq(unsigned int irq)
+static void iosapic_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 	struct vector_info *vi = iosapic_get_vector(irq);
 	u32 d0, d1;
@@ -635,8 +636,9 @@ static void iosapic_disable_irq(unsigned int irq)
 	spin_unlock_irqrestore(&iosapic_lock, flags);
 }
 
-static void iosapic_enable_irq(unsigned int irq)
+static void iosapic_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct vector_info *vi = iosapic_get_vector(irq);
 	u32 d0, d1;
 
@@ -686,8 +688,9 @@ printk("\n");
  * i386/ia64 support ISA devices and have to deal with
  * edge-triggered interrupts too.
  */
-static void iosapic_end_irq(unsigned int irq)
+static void iosapic_end_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct vector_info *vi = iosapic_get_vector(irq);
 	DBG(KERN_DEBUG "end_irq(%d): eoi(%p, 0x%x)\n", irq,
 			vi->eoi_addr, vi->eoi_data);
@@ -695,16 +698,17 @@ static void iosapic_end_irq(unsigned int irq)
 	cpu_end_irq(irq);
 }
 
-static unsigned int iosapic_startup_irq(unsigned int irq)
+static unsigned int iosapic_startup_irq(struct irq_desc *desc)
 {
-	iosapic_enable_irq(irq);
+	iosapic_enable_irq(desc);
 	return 0;
 }
 
 #ifdef CONFIG_SMP
-static int iosapic_set_affinity_irq(unsigned int irq,
+static int iosapic_set_affinity_irq(struct irq_desc *desc,
 				     const struct cpumask *dest)
 {
+	unsigned int irq = desc->irq;
 	struct vector_info *vi = iosapic_get_vector(irq);
 	u32 d0, d1, dummy_d0;
 	unsigned long flags;
diff --git a/drivers/parisc/superio.c b/drivers/parisc/superio.c
index f7806d8..084b1c7 100644
--- a/drivers/parisc/superio.c
+++ b/drivers/parisc/superio.c
@@ -286,8 +286,9 @@ superio_init(struct pci_dev *pcidev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_87560_LIO, superio_init);
 
-static void superio_disable_irq(unsigned int irq)
+static void superio_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u8 r8;
 
 	if ((irq < 1) || (irq == 2) || (irq > 7)) {
@@ -303,8 +304,9 @@ static void superio_disable_irq(unsigned int irq)
 	outb (r8,IC_PIC1+1);
 }
 
-static void superio_enable_irq(unsigned int irq)
+static void superio_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u8 r8;
 
 	if ((irq < 1) || (irq == 2) || (irq > 7)) {
@@ -319,9 +321,9 @@ static void superio_enable_irq(unsigned int irq)
 	outb (r8,IC_PIC1+1);
 }
 
-static unsigned int superio_startup_irq(unsigned int irq)
+static unsigned int superio_startup_irq(struct irq_desc *desc)
 {
-	superio_enable_irq(irq);
+	superio_enable_irq(desc);
 	return 0;
 }
 
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 83aae47..6b5ad63 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1230,9 +1230,9 @@ const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
 	}
 }
 
-void dmar_msi_unmask(unsigned int irq)
+void dmar_msi_unmask(struct irq_desc *desc)
 {
-	struct intel_iommu *iommu = get_irq_data(irq);
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 	unsigned long flag;
 
 	/* unmask it */
@@ -1243,10 +1243,10 @@ void dmar_msi_unmask(unsigned int irq)
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
-void dmar_msi_mask(unsigned int irq)
+void dmar_msi_mask(struct irq_desc *desc)
 {
 	unsigned long flag;
-	struct intel_iommu *iommu = get_irq_data(irq);
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 
 	/* mask it */
 	spin_lock_irqsave(&iommu->register_lock, flag);
@@ -1256,9 +1256,9 @@ void dmar_msi_mask(unsigned int irq)
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
-void dmar_msi_write(int irq, struct msi_msg *msg)
+void dmar_msi_write(struct irq_desc *desc, struct msi_msg *msg)
 {
-	struct intel_iommu *iommu = get_irq_data(irq);
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 	unsigned long flag;
 
 	spin_lock_irqsave(&iommu->register_lock, flag);
@@ -1268,9 +1268,9 @@ void dmar_msi_write(int irq, struct msi_msg *msg)
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
-void dmar_msi_read(int irq, struct msi_msg *msg)
+void dmar_msi_read(struct irq_desc *desc, struct msi_msg *msg)
 {
-	struct intel_iommu *iommu = get_irq_data(irq);
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
index f9cf317..3eecee3 100644
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
@@ -182,14 +183,14 @@ static void msi_set_mask_bit(unsigned irq, u32 flag)
 	}
 }
 
-void mask_msi_irq(unsigned int irq)
+void mask_msi_irq(struct irq_desc *desc)
 {
-	msi_set_mask_bit(irq, 1);
+	msi_set_mask_bit(desc, 1);
 }
 
-void unmask_msi_irq(unsigned int irq)
+void unmask_msi_irq(struct irq_desc *desc)
 {
-	msi_set_mask_bit(irq, 0);
+	msi_set_mask_bit(desc, 0);
 }
 
 void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
index 9554ad5..34a11e5 100644
--- a/drivers/vlynq/vlynq.c
+++ b/drivers/vlynq/vlynq.c
@@ -133,10 +133,11 @@ static void vlynq_reset(struct vlynq_device *dev)
 	msleep(5);
 }
 
-static void vlynq_irq_unmask(unsigned int irq)
+static void vlynq_irq_unmask(struct irq_desc *desc)
 {
 	u32 val;
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct vlynq_device *dev = get_irq_desc_chip_data(desc);
 	int virq;
 
 	BUG_ON(!dev);
@@ -146,10 +147,11 @@ static void vlynq_irq_unmask(unsigned int irq)
 	writel(val, &dev->remote->int_device[virq >> 2]);
 }
 
-static void vlynq_irq_mask(unsigned int irq)
+static void vlynq_irq_mask(struct irq_desc *desc)
 {
 	u32 val;
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct vlynq_device *dev = get_irq_desc_chip_data(desc);
 	int virq;
 
 	BUG_ON(!dev);
@@ -159,10 +161,11 @@ static void vlynq_irq_mask(unsigned int irq)
 	writel(val, &dev->remote->int_device[virq >> 2]);
 }
 
-static int vlynq_irq_type(unsigned int irq, unsigned int flow_type)
+static int vlynq_irq_type(struct irq_desc *desc, unsigned int flow_type)
 {
 	u32 val;
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct vlynq_device *dev = get_irq_desc_chip_data(desc);
 	int virq;
 
 	BUG_ON(!dev);
@@ -190,9 +193,9 @@ static int vlynq_irq_type(unsigned int irq, unsigned int flow_type)
 	return 0;
 }
 
-static void vlynq_local_ack(unsigned int irq)
+static void vlynq_local_ack(struct irq_desc *desc)
 {
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	struct vlynq_device *dev = get_irq_desc_chip_data(desc);
 
 	u32 status = readl(&dev->local->status);
 
@@ -201,9 +204,9 @@ static void vlynq_local_ack(unsigned int irq)
 	writel(status, &dev->local->status);
 }
 
-static void vlynq_remote_ack(unsigned int irq)
+static void vlynq_remote_ack(struct irq_desc *desc)
 {
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	struct vlynq_device *dev = get_irq_desc_chip_data(desc);
 
 	u32 status = readl(&dev->remote->status);
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 64cbbe4..fd16b80 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -730,11 +730,11 @@ static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 	return 0;
 }
 
-static int set_affinity_irq(unsigned irq, const struct cpumask *dest)
+static int set_affinity_irq(struct irq_desc *desc, const struct cpumask *dest)
 {
 	unsigned tcpu = cpumask_first(dest);
 
-	return rebind_irq_to_cpu(irq, tcpu);
+	return rebind_irq_to_cpu(desc->irq, tcpu);
 }
 
 int resend_irq_on_evtchn(unsigned int irq)
@@ -753,35 +753,35 @@ int resend_irq_on_evtchn(unsigned int irq)
 	return 1;
 }
 
-static void enable_dynirq(unsigned int irq)
+static void enable_dynirq(struct irq_desc *desc)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(desc->irq);
 
 	if (VALID_EVTCHN(evtchn))
 		unmask_evtchn(evtchn);
 }
 
-static void disable_dynirq(unsigned int irq)
+static void disable_dynirq(struct irq_desc *desc)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(desc->irq);
 
 	if (VALID_EVTCHN(evtchn))
 		mask_evtchn(evtchn);
 }
 
-static void ack_dynirq(unsigned int irq)
+static void ack_dynirq(struct irq_desc *desc)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(desc->irq);
 
-	move_native_irq(irq);
+	move_native_irq(desc);
 
 	if (VALID_EVTCHN(evtchn))
 		clear_evtchn(evtchn);
 }
 
-static int retrigger_dynirq(unsigned int irq)
+static int retrigger_dynirq(struct irq_desc *desc)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(desc->irq);
 	struct shared_info *sh = HYPERVISOR_shared_info;
 	int ret = 0;
 
diff --git a/include/asm-generic/hardirq.h b/include/asm-generic/hardirq.h
index 62f5908..afc7506 100644
--- a/include/asm-generic/hardirq.h
+++ b/include/asm-generic/hardirq.h
@@ -12,9 +12,9 @@ typedef struct {
 #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
 
 #ifndef ack_bad_irq
-static inline void ack_bad_irq(unsigned int irq)
+static inline void ack_bad_irq(struct irq_desc *desc)
 {
-	printk(KERN_CRIT "unexpected IRQ trap at vector %02x\n", irq);
+	printk(KERN_CRIT "unexpected IRQ trap at vector %02x\n", desc->irq);
 }
 #endif
 
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 659a765..6b4227a 100644
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
+extern void dmar_msi_unmask(struct irq_desc *);
+extern void dmar_msi_mask(struct irq_desc *);
+extern void dmar_msi_read(struct irq_desc *desc, struct msi_msg *msg);
+extern void dmar_msi_write(struct irq_desc *desc, struct msi_msg *msg);
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
index 60f3368..fb8c376 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -110,30 +110,31 @@ struct msi_desc;
  */
 struct irq_chip {
 	const char	*name;
-	unsigned int	(*startup)(unsigned int irq);
-	void		(*shutdown)(unsigned int irq);
-	void		(*enable)(unsigned int irq);
-	void		(*disable)(unsigned int irq);
-
-	void		(*ack)(unsigned int irq);
-	void		(*mask)(unsigned int irq);
-	void		(*mask_ack)(unsigned int irq);
-	void		(*unmask)(unsigned int irq);
-	void		(*eoi)(unsigned int irq);
-
-	void		(*end)(unsigned int irq);
-	int		(*set_affinity)(unsigned int irq,
+	unsigned int	(*startup)(struct irq_desc *desc);
+	void		(*shutdown)(struct irq_desc *desc);
+	void		(*enable)(struct irq_desc *desc);
+	void		(*disable)(struct irq_desc *desc);
+
+	void		(*ack)(struct irq_desc *desc);
+	void		(*mask)(struct irq_desc *desc);
+	void		(*mask_ack)(struct irq_desc *desc);
+	void		(*unmask)(struct irq_desc *desc);
+	void		(*eoi)(struct irq_desc *desc);
+
+	void		(*end)(struct irq_desc *desc);
+	int		(*set_affinity)(struct irq_desc *desc,
 					const struct cpumask *dest);
-	int		(*retrigger)(unsigned int irq);
-	int		(*set_type)(unsigned int irq, unsigned int flow_type);
-	int		(*set_wake)(unsigned int irq, unsigned int on);
+	int		(*retrigger)(struct irq_desc *desc);
 
-	void		(*bus_lock)(unsigned int irq);
-	void		(*bus_sync_unlock)(unsigned int irq);
+	int		(*set_type)(struct irq_desc *desc, unsigned int flow_type);
+	int		(*set_wake)(struct irq_desc *desc, unsigned int on);
+
+	void		(*bus_lock)(struct irq_desc *desc);
+	void		(*bus_sync_unlock)(struct irq_desc *desc);
 
 	/* Currently used only by UML, might disappear one day.*/
 #ifdef CONFIG_IRQ_RELEASE_METHOD
-	void		(*release)(unsigned int irq, void *dev_id);
+	void		(*release)(struct irq_desc *desc, void *dev_id);
 #endif
 	/*
 	 * For compatibility, ->typename is copied into ->name.
@@ -252,8 +253,8 @@ extern void remove_irq(unsigned int irq, struct irqaction *act);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 
-void move_native_irq(int irq);
-void move_masked_irq(int irq);
+void move_native_irq(struct irq_desc *desc);
+void move_masked_irq(struct irq_desc *desc);
 
 #else /* CONFIG_GENERIC_PENDING_IRQ */
 
@@ -261,11 +262,11 @@ static inline void move_irq(int irq)
 {
 }
 
-static inline void move_native_irq(int irq)
+static inline void move_native_irq(struct irq_desc *desc)
 {
 }
 
-static inline void move_masked_irq(int irq)
+static inline void move_masked_irq(struct irq_desc *desc)
 {
 }
 
@@ -338,7 +339,7 @@ extern void note_interrupt(unsigned int irq, struct irq_desc *desc,
 			   irqreturn_t action_ret);
 
 /* Resending of interrupts :*/
-void check_irq_resend(struct irq_desc *desc, unsigned int irq);
+void check_irq_resend(struct irq_desc *desc);
 
 /* Enable/disable irq debugging output: */
 extern int noirqdebug_setup(char *str);
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 6991ab5..dc6a904 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -11,8 +11,8 @@ struct msi_msg {
 
 /* Helper functions */
 struct irq_desc;
-extern void mask_msi_irq(unsigned int irq);
-extern void unmask_msi_irq(unsigned int irq);
+extern void mask_msi_irq(struct irq_desc *);
+extern void unmask_msi_irq(struct irq_desc *);
 extern void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index 2295a31..02ab31e 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -58,8 +58,8 @@ unsigned long probe_irq_on(void)
 			 * progress:
 			 */
 			if (desc->chip->set_type)
-				desc->chip->set_type(i, IRQ_TYPE_PROBE);
-			desc->chip->startup(i);
+				desc->chip->set_type(desc, IRQ_TYPE_PROBE);
+			desc->chip->startup(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -76,7 +76,7 @@ unsigned long probe_irq_on(void)
 		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			desc->status |= IRQ_AUTODETECT | IRQ_WAITING;
-			if (desc->chip->startup(i))
+			if (desc->chip->startup(desc))
 				desc->status |= IRQ_PENDING;
 		}
 		raw_spin_unlock_irq(&desc->lock);
@@ -98,7 +98,7 @@ unsigned long probe_irq_on(void)
 			/* It triggered already - consider it spurious. */
 			if (!(status & IRQ_WAITING)) {
 				desc->status = status & ~IRQ_AUTODETECT;
-				desc->chip->shutdown(i);
+				desc->chip->shutdown(desc);
 			} else
 				if (i < 32)
 					mask |= 1 << i;
@@ -137,7 +137,7 @@ unsigned int probe_irq_mask(unsigned long val)
 				mask |= 1 << i;
 
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->chip->shutdown(i);
+			desc->chip->shutdown(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -181,7 +181,7 @@ int probe_irq_off(unsigned long val)
 				nr_of_irqs++;
 			}
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->chip->shutdown(i);
+			desc->chip->shutdown(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 3dcdd2f..043557a 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -131,7 +131,7 @@ int set_irq_chip(unsigned int irq, struct irq_chip *chip)
 	unsigned long flags;
 
 	if (!desc) {
-		WARN(1, KERN_ERR "Trying to install chip for IRQ%d\n", irq);
+		WARN(1, KERN_ERR "Trying to install chip for IRQ%d\n",irq);
 		return -EINVAL;
 	}
 
@@ -287,40 +287,34 @@ EXPORT_SYMBOL_GPL(set_irq_nested_thread);
 /*
  * default enable function
  */
-static void default_enable(unsigned int irq)
+static void default_enable(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	desc->chip->unmask(irq);
+	desc->chip->unmask(desc);
 	desc->status &= ~IRQ_MASKED;
 }
 
 /*
  * default disable function
  */
-static void default_disable(unsigned int irq)
+static void default_disable(struct irq_desc *desc)
 {
 }
 
 /*
  * default startup function
  */
-static unsigned int default_startup(unsigned int irq)
+static unsigned int default_startup(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	desc->chip->enable(irq);
+	desc->chip->enable(desc);
 	return 0;
 }
 
 /*
  * default shutdown function
  */
-static void default_shutdown(unsigned int irq)
+static void default_shutdown(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	desc->chip->mask(irq);
+	desc->chip->mask(desc);
 	desc->status |= IRQ_MASKED;
 }
 
@@ -350,30 +344,30 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 		chip->end = dummy_irq_chip.end;
 }
 
-static inline void mask_ack_irq(struct irq_desc *desc, int irq)
+static inline void mask_ack_irq(struct irq_desc *desc)
 {
 	if (desc->chip->mask_ack)
-		desc->chip->mask_ack(irq);
+		desc->chip->mask_ack(desc);
 	else {
-		desc->chip->mask(irq);
+		desc->chip->mask(desc);
 		if (desc->chip->ack)
-			desc->chip->ack(irq);
+			desc->chip->ack(desc);
 	}
 	desc->status |= IRQ_MASKED;
 }
 
-static inline void mask_irq(struct irq_desc *desc, int irq)
+static inline void mask_irq(struct irq_desc *desc)
 {
 	if (desc->chip->mask) {
-		desc->chip->mask(irq);
+		desc->chip->mask(desc);
 		desc->status |= IRQ_MASKED;
 	}
 }
 
-static inline void unmask_irq(struct irq_desc *desc, int irq)
+static inline void unmask_irq(struct irq_desc *desc)
 {
 	if (desc->chip->unmask) {
-		desc->chip->unmask(irq);
+		desc->chip->unmask(desc);
 		desc->status &= ~IRQ_MASKED;
 	}
 }
@@ -476,7 +470,7 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	irqreturn_t action_ret;
 
 	raw_spin_lock(&desc->lock);
-	mask_ack_irq(desc, irq);
+	mask_ack_irq(desc);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
@@ -502,7 +496,7 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	desc->status &= ~IRQ_INPROGRESS;
 
 	if (!(desc->status & (IRQ_DISABLED | IRQ_ONESHOT)))
-		unmask_irq(desc, irq);
+		unmask_irq(desc);
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
@@ -539,7 +533,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
 		desc->status |= IRQ_PENDING;
-		mask_irq(desc, irq);
+		mask_irq(desc);
 		goto out;
 	}
 
@@ -554,7 +548,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 out:
-	desc->chip->eoi(irq);
+	desc->chip->eoi(desc);
 
 	raw_spin_unlock(&desc->lock);
 }
@@ -590,14 +584,14 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
 		    !desc->action)) {
 		desc->status |= (IRQ_PENDING | IRQ_MASKED);
-		mask_ack_irq(desc, irq);
+		mask_ack_irq(desc);
 		goto out_unlock;
 	}
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
 	if (desc->chip->ack)
-		desc->chip->ack(irq);
+		desc->chip->ack(desc);
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
@@ -607,7 +601,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		irqreturn_t action_ret;
 
 		if (unlikely(!action)) {
-			mask_irq(desc, irq);
+			mask_irq(desc);
 			goto out_unlock;
 		}
 
@@ -619,7 +613,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		if (unlikely((desc->status &
 			       (IRQ_PENDING | IRQ_MASKED | IRQ_DISABLED)) ==
 			      (IRQ_PENDING | IRQ_MASKED))) {
-			unmask_irq(desc, irq);
+			unmask_irq(desc);
 		}
 
 		desc->status &= ~IRQ_PENDING;
@@ -651,14 +645,14 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	if (desc->chip->ack)
-		desc->chip->ack(irq);
+		desc->chip->ack(desc);
 
 	action_ret = handle_IRQ_event(irq, desc->action);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
 	if (desc->chip->eoi)
-		desc->chip->eoi(irq);
+		desc->chip->eoi(desc);
 }
 
 void
@@ -670,7 +664,7 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 
 	if (!desc) {
 		printk(KERN_ERR
-		       "Trying to install type control for IRQ%d\n", irq);
+		       "Trying to install type control for IRQ%d\n",irq);
 		return;
 	}
 
@@ -689,13 +683,13 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		desc->chip = &dummy_irq_chip;
 	}
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irqsave(&desc->lock, flags);
 
 	/* Uninstall? */
 	if (handle == handle_bad_irq) {
 		if (desc->chip != &no_irq_chip)
-			mask_ack_irq(desc, irq);
+			mask_ack_irq(desc);
 		desc->status |= IRQ_DISABLED;
 		desc->depth = 1;
 	}
@@ -706,10 +700,10 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		desc->status &= ~IRQ_DISABLED;
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
 		desc->depth = 0;
-		desc->chip->startup(irq);
+		desc->chip->startup(desc);
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL_GPL(__set_irq_handler);
 
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index f30c9c7..d7a61a0 100644
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
+	ack_bad_irq(desc);
 }
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
@@ -295,22 +295,20 @@ void clear_kstat_irqs(struct irq_desc *desc)
  * What should we do if we get a hw irq event on an illegal vector?
  * Each architecture has to answer this themself.
  */
-static void ack_bad(unsigned int irq)
+static void ack_bad(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	print_irq_desc(irq, desc);
-	ack_bad_irq(irq);
+	print_irq_desc(desc);
+	ack_bad_irq(desc);
 }
 
 /*
  * NOP functions
  */
-static void noop(unsigned int irq)
+static void noop(struct irq_desc *desc)
 {
 }
 
-static unsigned int noop_ret(unsigned int irq)
+static unsigned int noop_ret(struct irq_desc *des)
 {
 	return 0;
 }
@@ -464,19 +462,19 @@ unsigned int __do_IRQ(unsigned int irq)
 		 * No locking required for CPU-local interrupts:
 		 */
 		if (desc->chip->ack)
-			desc->chip->ack(irq);
+			desc->chip->ack(desc);
 		if (likely(!(desc->status & IRQ_DISABLED))) {
 			action_ret = handle_IRQ_event(irq, desc->action);
 			if (!noirqdebug)
 				note_interrupt(irq, desc, action_ret);
 		}
-		desc->chip->end(irq);
+		desc->chip->end(desc);
 		return 1;
 	}
 
 	raw_spin_lock(&desc->lock);
 	if (desc->chip->ack)
-		desc->chip->ack(irq);
+		desc->chip->ack(desc);
 	/*
 	 * REPLAY is when Linux resends an IRQ that was dropped earlier
 	 * WAITING is used by probe to mark irqs that are being tested
@@ -536,7 +534,7 @@ out:
 	 * The ->end() handler has to deal with interrupts which got
 	 * disabled while the handler was running.
 	 */
-	desc->chip->end(irq);
+	desc->chip->end(desc);
 	raw_spin_unlock(&desc->lock);
 
 	return 1;
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index c63f3bc..f74a64f 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -12,8 +12,8 @@ extern void compat_irq_chip_set_default_handler(struct irq_desc *desc);
 
 extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		unsigned long flags);
-extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
-extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
+extern void __disable_irq(struct irq_desc *desc, bool susp);
+extern void __enable_irq(struct irq_desc *desc, bool resume);
 
 extern struct lock_class_key irq_desc_lock_class;
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
@@ -41,16 +41,16 @@ extern int irq_select_affinity_usr(unsigned int irq);
 extern void irq_set_thread_affinity(struct irq_desc *desc);
 
 /* Inline functions for support of irq chips on slow busses */
-static inline void chip_bus_lock(unsigned int irq, struct irq_desc *desc)
+static inline void chip_bus_lock(struct irq_desc *desc)
 {
 	if (unlikely(desc->chip->bus_lock))
-		desc->chip->bus_lock(irq);
+		desc->chip->bus_lock(desc);
 }
 
-static inline void chip_bus_sync_unlock(unsigned int irq, struct irq_desc *desc)
+static inline void chip_bus_sync_unlock(struct irq_desc *desc)
 {
 	if (unlikely(desc->chip->bus_sync_unlock))
-		desc->chip->bus_sync_unlock(irq);
+		desc->chip->bus_sync_unlock(desc);
 }
 
 /*
@@ -61,10 +61,10 @@ static inline void chip_bus_sync_unlock(unsigned int irq, struct irq_desc *desc)
 
 #define P(f) if (desc->status & f) printk("%14s set\n", #f)
 
-static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
+static inline void print_irq_desc(struct irq_desc *desc)
 {
 	printk("irq %d, desc: %p, depth: %d, count: %d, unhandled: %d\n",
-		irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
+		desc->irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
 	printk("->handle_irq():  %p, ", desc->handle_irq);
 	print_symbol("%s\n", (unsigned long)desc->handle_irq);
 	printk("->chip(): %p, ", desc->chip);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 69a3d7b..868521a 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -118,7 +118,7 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PCNTXT) {
-		if (!desc->chip->set_affinity(irq, cpumask)) {
+		if (!desc->chip->set_affinity(desc, cpumask)) {
 			cpumask_copy(desc->affinity, cpumask);
 			irq_set_thread_affinity(desc);
 		}
@@ -128,7 +128,7 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 		cpumask_copy(desc->pending_mask, cpumask);
 	}
 #else
-	if (!desc->chip->set_affinity(irq, cpumask)) {
+	if (!desc->chip->set_affinity(desc, cpumask)) {
 		cpumask_copy(desc->affinity, cpumask);
 		irq_set_thread_affinity(desc);
 	}
@@ -161,7 +161,7 @@ static int setup_affinity(unsigned int irq, struct irq_desc *desc)
 
 	cpumask_and(desc->affinity, cpu_online_mask, irq_default_affinity);
 set_affinity:
-	desc->chip->set_affinity(irq, desc->affinity);
+	desc->chip->set_affinity(desc, desc->affinity);
 
 	return 0;
 }
@@ -197,7 +197,7 @@ static inline int setup_affinity(unsigned int irq, struct irq_desc *desc)
 }
 #endif
 
-void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
+void __disable_irq(struct irq_desc *desc, bool suspend)
 {
 	if (suspend) {
 		if (!desc->action || (desc->action->flags & IRQF_TIMER))
@@ -207,7 +207,7 @@ void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 
 	if (!desc->depth++) {
 		desc->status |= IRQ_DISABLED;
-		desc->chip->disable(irq);
+		desc->chip->disable(desc);
 	}
 }
 
@@ -230,11 +230,11 @@ void disable_irq_nosync(unsigned int irq)
 	if (!desc)
 		return;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	__disable_irq(desc, irq, false);
+	__disable_irq(desc, false);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(disable_irq_nosync);
 
@@ -263,7 +263,7 @@ void disable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(disable_irq);
 
-void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
+void __enable_irq(struct irq_desc *desc, bool resume)
 {
 	if (resume)
 		desc->status &= ~IRQ_SUSPENDED;
@@ -271,7 +271,7 @@ void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 	switch (desc->depth) {
 	case 0:
  err_out:
-		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
+		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", desc->irq);
 		break;
 	case 1: {
 		unsigned int status = desc->status & ~IRQ_DISABLED;
@@ -280,7 +280,7 @@ void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 			goto err_out;
 		/* Prevent probing on this irq: */
 		desc->status = status | IRQ_NOPROBE;
-		check_irq_resend(desc, irq);
+		check_irq_resend(desc);
 		/* fall-through */
 	}
 	default:
@@ -307,21 +307,20 @@ void enable_irq(unsigned int irq)
 	if (!desc)
 		return;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	__enable_irq(desc, irq, false);
+	__enable_irq(desc, false);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(enable_irq);
 
-static int set_irq_wake_real(unsigned int irq, unsigned int on)
+static int set_irq_wake_real(struct irq_desc *desc, unsigned int on)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	int ret = -ENXIO;
 
 	if (desc->chip->set_wake)
-		ret = desc->chip->set_wake(irq, on);
+		ret = desc->chip->set_wake(desc, on);
 
 	return ret;
 }
@@ -350,7 +349,7 @@ int set_irq_wake(unsigned int irq, unsigned int on)
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	if (on) {
 		if (desc->wake_depth++ == 0) {
-			ret = set_irq_wake_real(irq, on);
+			ret = set_irq_wake_real(desc, on);
 			if (ret)
 				desc->wake_depth = 0;
 			else
@@ -360,7 +359,7 @@ int set_irq_wake(unsigned int irq, unsigned int on)
 		if (desc->wake_depth == 0) {
 			WARN(1, "Unbalanced IRQ %d wake disable\n", irq);
 		} else if (--desc->wake_depth == 0) {
-			ret = set_irq_wake_real(irq, on);
+			ret = set_irq_wake_real(desc, on);
 			if (ret)
 				desc->wake_depth = 1;
 			else
@@ -425,7 +424,7 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 	}
 
 	/* caller masked out all except trigger mode flags */
-	ret = chip->set_type(irq, flags);
+	ret = chip->set_type(desc, flags);
 
 	if (ret)
 		pr_err("setting trigger mode %d for irq %u failed (%pF)\n",
@@ -481,10 +480,10 @@ static int irq_wait_for_interrupt(struct irqaction *action)
  * handler finished. unmask if the interrupt has not been disabled and
  * is marked MASKED.
  */
-static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc)
+static void irq_finalize_oneshot(struct irq_desc *desc)
 {
 again:
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irq(&desc->lock);
 
 	/*
@@ -498,17 +497,17 @@ again:
 	 */
 	if (unlikely(desc->status & IRQ_INPROGRESS)) {
 		raw_spin_unlock_irq(&desc->lock);
-		chip_bus_sync_unlock(irq, desc);
+		chip_bus_sync_unlock(desc);
 		cpu_relax();
 		goto again;
 	}
 
 	if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
 		desc->status &= ~IRQ_MASKED;
-		desc->chip->unmask(irq);
+		desc->chip->unmask(desc);
 	}
 	raw_spin_unlock_irq(&desc->lock);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 
 #ifdef CONFIG_SMP
@@ -580,7 +579,7 @@ static int irq_thread(void *data)
 			action->thread_fn(action->irq, action->dev_id);
 
 			if (oneshot)
-				irq_finalize_oneshot(action->irq, desc);
+				irq_finalize_oneshot(desc);
 		}
 
 		wake = atomic_dec_and_test(&desc->threads_active);
@@ -756,7 +755,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
 			desc->status &= ~IRQ_DISABLED;
-			desc->chip->startup(irq);
+			desc->chip->startup(desc);
 		} else
 			/* Undo nested disables: */
 			desc->depth = 1;
@@ -790,7 +789,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	 */
 	if (shared && (desc->status & IRQ_SPURIOUS_DISABLED)) {
 		desc->status &= ~IRQ_SPURIOUS_DISABLED;
-		__enable_irq(desc, irq, false);
+		__enable_irq(desc, false);
 	}
 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
@@ -897,9 +896,9 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	if (!desc->action) {
 		desc->status |= IRQ_DISABLED;
 		if (desc->chip->shutdown)
-			desc->chip->shutdown(irq);
+			desc->chip->shutdown(desc);
 		else
-			desc->chip->disable(irq);
+			desc->chip->disable(desc);
 	}
 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
@@ -968,9 +967,9 @@ void free_irq(unsigned int irq, void *dev_id)
 	if (!desc)
 		return;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	kfree(__free_irq(irq, dev_id));
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(free_irq);
 
@@ -1077,9 +1076,9 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	action->name = devname;
 	action->dev_id = dev_id;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	retval = __setup_irq(irq, desc, action);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 
 	if (retval)
 		kfree(action);
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 2419622..6b3d1aa 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -4,10 +4,8 @@
 
 #include "internals.h"
 
-void move_masked_irq(int irq)
+void move_masked_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
 
@@ -43,7 +41,7 @@ void move_masked_irq(int irq)
 	 */
 	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
 		   < nr_cpu_ids))
-		if (!desc->chip->set_affinity(irq, desc->pending_mask)) {
+		if (!desc->chip->set_affinity(desc, desc->pending_mask)) {
 			cpumask_copy(desc->affinity, desc->pending_mask);
 			irq_set_thread_affinity(desc);
 		}
@@ -51,18 +49,16 @@ void move_masked_irq(int irq)
 	cpumask_clear(desc->pending_mask);
 }
 
-void move_native_irq(int irq)
+void move_native_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
 
 	if (unlikely(desc->status & IRQ_DISABLED))
 		return;
 
-	desc->chip->mask(irq);
-	move_masked_irq(irq);
-	desc->chip->unmask(irq);
+	desc->chip->mask(desc);
+	move_masked_irq(desc);
+	desc->chip->unmask(desc);
 }
 
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 0d4005d..a43c93d 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -29,7 +29,7 @@ void suspend_device_irqs(void)
 		unsigned long flags;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
-		__disable_irq(desc, irq, true);
+		__disable_irq(desc, true);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 
@@ -57,7 +57,7 @@ void resume_device_irqs(void)
 			continue;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
-		__enable_irq(desc, irq, true);
+		__enable_irq(desc, true);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 090c376..ddf75cd 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -53,14 +53,14 @@ static DECLARE_TASKLET(resend_tasklet, resend_irqs, 0);
  *
  * Is called with interrupts disabled and desc->lock held.
  */
-void check_irq_resend(struct irq_desc *desc, unsigned int irq)
+void check_irq_resend(struct irq_desc *desc)
 {
 	unsigned int status = desc->status;
 
 	/*
 	 * Make sure the interrupt is enabled, before resending it:
 	 */
-	desc->chip->enable(irq);
+	desc->chip->enable(desc);
 
 	/*
 	 * We do not resend level type interrupts. Level type
@@ -70,10 +70,10 @@ void check_irq_resend(struct irq_desc *desc, unsigned int irq)
 	if ((status & (IRQ_LEVEL | IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
 		desc->status = (status & ~IRQ_PENDING) | IRQ_REPLAY;
 
-		if (!desc->chip->retrigger || !desc->chip->retrigger(irq)) {
+		if (!desc->chip->retrigger || !desc->chip->retrigger(desc)) {
 #ifdef CONFIG_HARDIRQS_SW_RESEND
 			/* Set it pending and activate the softirq: */
-			set_bit(irq, irqs_resend);
+			set_bit(desc->irq, irqs_resend);
 			tasklet_schedule(&resend_tasklet);
 #endif
 		}
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 89fb90a..42b0972 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -79,7 +79,7 @@ static int try_one_irq(int irq, struct irq_desc *desc)
 	 * IRQ controller clean up too
 	 */
 	if (work && desc->chip && desc->chip->end)
-		desc->chip->end(irq);
+		desc->chip->end(desc);
 	raw_spin_unlock(&desc->lock);
 
 	return ok;
@@ -254,7 +254,7 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
 		desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
 		desc->depth++;
-		desc->chip->disable(irq);
+		desc->chip->disable(desc);
 
 		mod_timer(&poll_spurious_irq_timer,
 			  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
-- 
1.6.4.2

