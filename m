Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab2A0H02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 02:26:28 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:49116 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2A0H01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 02:26:27 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 1/7] x86, irq: Modify irq chip one time when irq remapping is enabled
Date: Thu, 26 Jan 2012 23:25:47 -0800
Message-Id: <1327649153-16477-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327649153-16477-1-git-send-email-yinghai@kernel.org>
References: <1327649153-16477-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F225190.00F2,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we don't need change irq chip during every irq setup.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/io_apic.h |    2 ++
 arch/x86/kernel/apic/apic.c    |    9 ++++++++-
 arch/x86/kernel/apic/io_apic.c |   23 +++++++++++++++++------
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 690d1cc..142a6b9 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -176,6 +176,8 @@ extern void mp_save_irq(struct mpc_intsrc *m);
 
 extern void disable_ioapic_support(void);
 
+void irq_remap_modify_chips(void);
+
 #else  /* !CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 2eec05b..87aa884 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1512,6 +1512,8 @@ void enable_x2apic(void)
 int __init enable_IR(void)
 {
 #ifdef CONFIG_IRQ_REMAP
+	int ret;
+
 	if (!intr_remapping_supported()) {
 		pr_debug("intr-remapping not supported\n");
 		return -1;
@@ -1523,7 +1525,12 @@ int __init enable_IR(void)
 		return -1;
 	}
 
-	return enable_intr_remapping();
+	ret = enable_intr_remapping();
+
+	if (ret >= 0)
+		irq_remap_modify_chips();
+
+	return ret;
 #endif
 	return -1;
 }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index fb07275..e4ee9bc 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1313,7 +1313,6 @@ static void ioapic_register_intr(unsigned int irq, struct irq_cfg *cfg,
 
 	if (irq_remapped(cfg)) {
 		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-		irq_remap_modify_chip_defaults(chip);
 		fasteoi = trigger != 0;
 	}
 
@@ -2634,6 +2633,8 @@ static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
 
 static void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 {
+	apic_printk(APIC_DEBUG, KERN_DEBUG "irq_chip: %s ==> IR-%s",
+			 chip->name, chip->name);
 	chip->irq_print_chip = ir_print_prefix;
 	chip->irq_ack = ir_ack_apic_edge;
 	chip->irq_eoi = ir_ack_apic_level;
@@ -3268,10 +3269,8 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 	irq_set_msi_desc(irq, msidesc);
 	write_msi_msg(irq, &msg);
 
-	if (irq_remapped(irq_get_chip_data(irq))) {
+	if (irq_remapped(irq_get_chip_data(irq)))
 		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-		irq_remap_modify_chip_defaults(chip);
-	}
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 
@@ -3459,8 +3458,6 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 
 	hpet_msi_write(irq_get_handler_data(irq), &msg);
 	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	if (irq_remapped(irq_get_chip_data(irq)))
-		irq_remap_modify_chip_defaults(chip);
 
 	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
 	return 0;
@@ -3468,6 +3465,20 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 #endif
 
 #endif /* CONFIG_PCI_MSI */
+
+void irq_remap_modify_chips(void)
+{
+#ifdef CONFIG_IRQ_REMAP
+	irq_remap_modify_chip_defaults(&ioapic_chip);
+# ifdef CONFIG_PCI_MSI
+	irq_remap_modify_chip_defaults(&msi_chip);
+#  ifdef CONFIG_HPET_TIMER
+	irq_remap_modify_chip_defaults(&hpet_msi_type);
+#  endif
+# endif
+#endif
+}
+
 /*
  * Hypertransport interrupt support
  */
-- 
1.7.7

