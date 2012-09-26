Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab2IZKrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:47:07 -0400
Received: from [216.32.181.181] ([216.32.181.181]:10118 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754501Ab2IZKqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 06:46:31 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MAYDV3-01-D4Z-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/19] x86, msi: Use IRQ remapping specific setup_msi_irqs routine
Date: Wed, 26 Sep 2012 12:44:38 +0200
Message-ID: <1348656291-10375-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
References: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use seperate routines to setup MSI IRQs for both
irq_remapping_enabled cases.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/irq_remapping.h |   12 -------
 arch/x86/include/asm/pci.h           |    2 ++
 arch/x86/kernel/apic/io_apic.c       |   26 ++--------------
 drivers/iommu/irq_remapping.c        |   57 ++++++++++++++++++++++++++++++++--
 4 files changed, 59 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 5fb9bbb..0ee1e88 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -47,9 +47,6 @@ extern void free_remapped_irq(int irq);
 extern void compose_remapped_msi_msg(struct pci_dev *pdev,
 				     unsigned int irq, unsigned int dest,
 				     struct msi_msg *msg, u8 hpet_id);
-extern int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec);
-extern int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
-				  int index, int sub_handle);
 extern int setup_hpet_msi_remapped(unsigned int irq, unsigned int id);
 
 #else  /* CONFIG_IRQ_REMAP */
@@ -83,15 +80,6 @@ static inline void compose_remapped_msi_msg(struct pci_dev *pdev,
 					    struct msi_msg *msg, u8 hpet_id)
 {
 }
-static inline int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
-{
-	return -ENODEV;
-}
-static inline int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
-					 int index, int sub_handle)
-{
-	return -ENODEV;
-}
 static inline int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
 {
 	return -ENODEV;
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index df75d07..1470b53 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -121,9 +121,11 @@ static inline void x86_restore_msi_irqs(struct pci_dev *dev, int irq)
 #define arch_teardown_msi_irq x86_teardown_msi_irq
 #define arch_restore_msi_irqs x86_restore_msi_irqs
 /* implemented in arch/x86/kernel/apic/io_apic. */
+struct msi_desc;
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 void native_teardown_msi_irq(unsigned int irq);
 void native_restore_msi_irqs(struct pci_dev *dev, int irq);
+int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq);
 /* default to the implementation in drivers/lib/msi.c */
 #define HAVE_DEFAULT_MSI_TEARDOWN_IRQS
 #define HAVE_DEFAULT_MSI_RESTORE_IRQS
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ab07371..5ae0292 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3145,7 +3145,7 @@ static struct irq_chip msi_chip = {
 	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
-static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
+int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 {
 	struct irq_chip *chip = &msi_chip;
 	struct msi_msg msg;
@@ -3172,9 +3172,9 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
-	int node, ret, sub_handle, index = 0;
 	unsigned int irq, irq_want;
 	struct msi_desc *msidesc;
+	int node, ret;
 
 	/* x86 doesn't support multiple MSI yet */
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
@@ -3182,36 +3182,16 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 
 	node = dev_to_node(&dev->dev);
 	irq_want = nr_irqs_gsi;
-	sub_handle = 0;
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 		irq = create_irq_nr(irq_want, node);
 		if (irq == 0)
 			return -1;
+
 		irq_want = irq + 1;
-		if (!irq_remapping_enabled)
-			goto no_ir;
 
-		if (!sub_handle) {
-			/*
-			 * allocate the consecutive block of IRTE's
-			 * for 'nvec'
-			 */
-			index = msi_alloc_remapped_irq(dev, irq, nvec);
-			if (index < 0) {
-				ret = index;
-				goto error;
-			}
-		} else {
-			ret = msi_setup_remapped_irq(dev, irq, index,
-						     sub_handle);
-			if (ret < 0)
-				goto error;
-		}
-no_ir:
 		ret = setup_msi_irq(dev, msidesc, irq);
 		if (ret < 0)
 			goto error;
-		sub_handle++;
 	}
 	return 0;
 
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index f439151..984104b 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -4,6 +4,8 @@
 #include <linux/cpumask.h>
 #include <linux/errno.h>
 #include <linux/msi.h>
+#include <linux/irq.h>
+#include <linux/pci.h>
 
 #include <asm/hw_irq.h>
 #include <asm/irq_remapping.h>
@@ -21,6 +23,10 @@ int no_x2apic_optout;
 
 static struct irq_remap_ops *remap_ops;
 
+static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec);
+static int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
+				  int index, int sub_handle);
+
 static void irq_remapping_disable_io_apic(void)
 {
 	/*
@@ -34,9 +40,54 @@ static void irq_remapping_disable_io_apic(void)
 		disconnect_bsp_APIC(0);
 }
 
+static int irq_remapping_setup_msi_irqs(struct pci_dev *dev,
+					int nvec, int type)
+{
+	int node, ret, sub_handle, index = 0;
+	struct msi_desc *msidesc;
+	unsigned int irq;
+
+	/* We don't support multiple MSI yet */
+	if (type == PCI_CAP_ID_MSI && nvec > 1)
+		return 1;
+
+	node		= dev_to_node(&dev->dev);
+	irq		= get_nr_irqs_gsi();
+	sub_handle	= 0;
+
+	list_for_each_entry(msidesc, &dev->msi_list, list) {
+
+		irq = create_irq_nr(irq, node);
+		if (irq == 0)
+			return -1;
+
+		if (sub_handle == 0)
+			ret = index = msi_alloc_remapped_irq(dev, irq, nvec);
+		else
+			ret = msi_setup_remapped_irq(dev, irq, index, sub_handle);
+
+		if (ret < 0)
+			goto error;
+
+		ret = setup_msi_irq(dev, msidesc, irq);
+		if (ret < 0)
+			goto error;
+
+		sub_handle += 1;
+		irq        += 1;
+	}
+
+	return 0;
+
+error:
+	destroy_irq(irq);
+	return ret;
+}
+
 static void __init irq_remapping_modify_x86_ops(void)
 {
 	x86_io_apic_ops.disable		= irq_remapping_disable_io_apic;
+	x86_msi.setup_msi_irqs		= irq_remapping_setup_msi_irqs;
 	x86_msi.setup_hpet_msi		= setup_hpet_msi_remapped;
 }
 
@@ -181,7 +232,7 @@ void compose_remapped_msi_msg(struct pci_dev *pdev,
 	remap_ops->compose_msi_msg(pdev, irq, dest, msg, hpet_id);
 }
 
-int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
+static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
 {
 	if (!remap_ops || !remap_ops->msi_alloc_irq)
 		return -ENODEV;
@@ -189,8 +240,8 @@ int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
 	return remap_ops->msi_alloc_irq(pdev, irq, nvec);
 }
 
-int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
-			   int index, int sub_handle)
+static int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
+				  int index, int sub_handle)
 {
 	if (!remap_ops || !remap_ops->msi_setup_irq)
 		return -ENODEV;
-- 
1.7.9.5


