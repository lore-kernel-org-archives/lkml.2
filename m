Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab1BETpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 14:45:04 -0500
Received: from www.tglx.de ([62.245.132.106]:60087 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab1BETpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 14:45:02 -0500
Message-Id: <20110205193903.807610260@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 Feb 2011 19:44:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Subject: [patch 4/8] ia64: Convert msi_sn to new irq_chip functions
References: <20110205193740.964969119@linutronix.de>
Content-Disposition: inline; filename=ia64-convert-msi-sn-irq-chip.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/sn/kernel/msi_sn.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

Index: linux-next/arch/ia64/sn/kernel/msi_sn.c
===================================================================
--- linux-next.orig/arch/ia64/sn/kernel/msi_sn.c
+++ linux-next/arch/ia64/sn/kernel/msi_sn.c
@@ -152,8 +152,8 @@ int sn_setup_msi_irq(struct pci_dev *pde
 }
 
 #ifdef CONFIG_SMP
-static int sn_set_msi_irq_affinity(unsigned int irq,
-				    const struct cpumask *cpu_mask)
+static int sn_set_msi_irq_affinity(struct irq_data *data,
+				   const struct cpumask *cpu_mask, bool force)
 {
 	struct msi_msg msg;
 	int slice;
@@ -164,7 +164,7 @@ static int sn_set_msi_irq_affinity(unsig
 	struct sn_irq_info *sn_irq_info;
 	struct sn_irq_info *new_irq_info;
 	struct sn_pcibus_provider *provider;
-	unsigned int cpu;
+	unsigned int cpu, irq = data->irq;
 
 	cpu = cpumask_first(cpu_mask);
 	sn_irq_info = sn_msi_info[irq].sn_irq_info;
@@ -206,33 +206,33 @@ static int sn_set_msi_irq_affinity(unsig
 	msg.address_lo = (u32)(bus_addr & 0x00000000ffffffff);
 
 	write_msi_msg(irq, &msg);
-	cpumask_copy(irq_desc[irq].affinity, cpu_mask);
+	cpumask_copy(data->affinity, cpu_mask);
 
 	return 0;
 }
 #endif /* CONFIG_SMP */
 
-static void sn_ack_msi_irq(unsigned int irq)
+static void sn_ack_msi_irq(struct irq_data *data)
 {
-	move_native_irq(irq);
+	move_native_irq(data->irq);
 	ia64_eoi();
 }
 
-static int sn_msi_retrigger_irq(unsigned int irq)
+static int sn_msi_retrigger_irq(struct irq_data *data)
 {
-	unsigned int vector = irq;
+	unsigned int vector = data->irq;
 	ia64_resend_irq(vector);
 
 	return 1;
 }
 
 static struct irq_chip sn_msi_chip = {
-	.name		= "PCI-MSI",
-	.irq_mask	= mask_msi_irq,
-	.irq_unmask	= unmask_msi_irq,
-	.ack		= sn_ack_msi_irq,
+	.name			= "PCI-MSI",
+	.irq_mask		= mask_msi_irq,
+	.irq_unmask		= unmask_msi_irq,
+	.irq_ack		= sn_ack_msi_irq,
 #ifdef CONFIG_SMP
-	.set_affinity	= sn_set_msi_irq_affinity,
+	.irq_set_affinity	= sn_set_msi_irq_affinity,
 #endif
-	.retrigger	= sn_msi_retrigger_irq,
+	.irq_retrigger		= sn_msi_retrigger_irq,
 };


