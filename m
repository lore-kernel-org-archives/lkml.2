Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab0I3XRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:17:20 -0400
Received: from www.tglx.de ([62.245.132.106]:52804 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756258Ab0I3XRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:17:16 -0400
Message-Id: <20100930221741.229471958@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:16:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 28/47] x86: ioapic/hpet: Convert to new chip functions
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=x86-hept-convert.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/hpet.h    |   10 ++++++----
 arch/x86/kernel/apic/io_apic.c |   30 ++++++++++++++----------------
 arch/x86/kernel/hpet.c         |   16 ++++++----------
 3 files changed, 26 insertions(+), 30 deletions(-)

Index: linux-2.6-tip/arch/x86/include/asm/hpet.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/hpet.h
+++ linux-2.6-tip/arch/x86/include/asm/hpet.h
@@ -74,10 +74,12 @@ extern void hpet_disable(void);
 extern unsigned int hpet_readl(unsigned int a);
 extern void force_hpet_resume(void);
 
-extern void hpet_msi_unmask(unsigned int irq);
-extern void hpet_msi_mask(unsigned int irq);
-extern void hpet_msi_write(unsigned int irq, struct msi_msg *msg);
-extern void hpet_msi_read(unsigned int irq, struct msi_msg *msg);
+struct irq_data;
+extern void hpet_msi_unmask(struct irq_data *data);
+extern void hpet_msi_mask(struct irq_data *data);
+struct hpet_dev;
+extern void hpet_msi_write(struct hpet_dev *hdev, struct msi_msg *msg);
+extern void hpet_msi_read(struct hpet_dev *hdev, struct msi_msg *msg);
 
 #ifdef CONFIG_PCI_MSI
 extern int arch_setup_hpet_msi(unsigned int irq, unsigned int id);
Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -3626,26 +3626,25 @@ int arch_setup_dmar_msi(unsigned int irq
 #ifdef CONFIG_HPET_TIMER
 
 #ifdef CONFIG_SMP
-static int hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int hpet_msi_set_affinity(struct irq_data *data,
+				 const struct cpumask *mask, bool force)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg;
+	struct irq_desc *desc = irq_to_desc(data->irq);
+	struct irq_cfg *cfg = data->chip_data;
 	struct msi_msg msg;
 	unsigned int dest;
 
 	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
 
-	cfg = get_irq_desc_chip_data(desc);
-
-	hpet_msi_read(irq, &msg);
+	hpet_msi_read(data->handler_data, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
-	hpet_msi_write(irq, &msg);
+	hpet_msi_write(data->handler_data, &msg);
 
 	return 0;
 }
@@ -3654,8 +3653,8 @@ static int hpet_msi_set_affinity(unsigne
 
 static struct irq_chip ir_hpet_msi_type = {
 	.name = "IR-HPET_MSI",
-	.unmask = hpet_msi_unmask,
-	.mask = hpet_msi_mask,
+	.irq_unmask = hpet_msi_unmask,
+	.irq_mask = hpet_msi_mask,
 #ifdef CONFIG_INTR_REMAP
 	.irq_ack = ir_ack_apic_edge,
 #ifdef CONFIG_SMP
@@ -3667,20 +3666,19 @@ static struct irq_chip ir_hpet_msi_type 
 
 static struct irq_chip hpet_msi_type = {
 	.name = "HPET_MSI",
-	.unmask = hpet_msi_unmask,
-	.mask = hpet_msi_mask,
+	.irq_unmask = hpet_msi_unmask,
+	.irq_mask = hpet_msi_mask,
 	.irq_ack = ack_apic_edge,
 #ifdef CONFIG_SMP
-	.set_affinity = hpet_msi_set_affinity,
+	.irq_set_affinity = hpet_msi_set_affinity,
 #endif
 	.irq_retrigger = ioapic_retrigger_irq,
 };
 
 int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 {
-	int ret;
 	struct msi_msg msg;
-	struct irq_desc *desc = irq_to_desc(irq);
+	int ret;
 
 	if (intr_remapping_enabled) {
 		struct intel_iommu *iommu = map_hpet_to_ir(id);
@@ -3698,8 +3696,8 @@ int arch_setup_hpet_msi(unsigned int irq
 	if (ret < 0)
 		return ret;
 
-	hpet_msi_write(irq, &msg);
-	desc->status |= IRQ_MOVE_PCNTXT;
+	hpet_msi_write(get_irq_data(irq), &msg);
+	irq_set_status_flags(irq,IRQ_MOVE_PCNTXT);
 	if (irq_remapped(irq))
 		set_irq_chip_and_handler_name(irq, &ir_hpet_msi_type,
 					      handle_edge_irq, "edge");
Index: linux-2.6-tip/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/hpet.c
+++ linux-2.6-tip/arch/x86/kernel/hpet.c
@@ -440,9 +440,9 @@ static int hpet_legacy_next_event(unsign
 static DEFINE_PER_CPU(struct hpet_dev *, cpu_hpet_dev);
 static struct hpet_dev	*hpet_devs;
 
-void hpet_msi_unmask(unsigned int irq)
+void hpet_msi_unmask(struct irq_data *data)
 {
-	struct hpet_dev *hdev = get_irq_data(irq);
+	struct hpet_dev *hdev = data->handler_data;
 	unsigned int cfg;
 
 	/* unmask it */
@@ -451,10 +451,10 @@ void hpet_msi_unmask(unsigned int irq)
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
-void hpet_msi_mask(unsigned int irq)
+void hpet_msi_mask(struct irq_data *data)
 {
+	struct hpet_dev *hdev = data->handler_data;
 	unsigned int cfg;
-	struct hpet_dev *hdev = get_irq_data(irq);
 
 	/* mask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
@@ -462,18 +462,14 @@ void hpet_msi_mask(unsigned int irq)
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
-void hpet_msi_write(unsigned int irq, struct msi_msg *msg)
+void hpet_msi_write(struct hpet_dev *hdev, struct msi_msg *msg)
 {
-	struct hpet_dev *hdev = get_irq_data(irq);
-
 	hpet_writel(msg->data, HPET_Tn_ROUTE(hdev->num));
 	hpet_writel(msg->address_lo, HPET_Tn_ROUTE(hdev->num) + 4);
 }
 
-void hpet_msi_read(unsigned int irq, struct msi_msg *msg)
+void hpet_msi_read(struct hpet_dev *hdev, struct msi_msg *msg)
 {
-	struct hpet_dev *hdev = get_irq_data(irq);
-
 	msg->data = hpet_readl(HPET_Tn_ROUTE(hdev->num));
 	msg->address_lo = hpet_readl(HPET_Tn_ROUTE(hdev->num) + 4);
 	msg->address_hi = 0;


