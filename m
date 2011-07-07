Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab1GGTIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:08:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:57823 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab1GGTIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:08:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 01/10] xen/pci: Shuffle code around.
Date: Thu,  7 Jul 2011 15:08:17 -0400
Message-Id: <1310065706-18797-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
References: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E160437.0133:SCFMA922111,ss=1,re=-6.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file is hard to read. Move the code around so that
the contents of it follows a uniform format:
 - setup GSIs - PV, HVM, and initial domain case
 - then MSI/MSI-x setup - PV, HVM and then initial domain case.
 - then MSI/MSI-x teardown - same order.
 - lastly, the __init functions in PV, HVM, and initial domain order.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |  346 ++++++++++++++++++++++++++--------------------------
 1 files changed, 173 insertions(+), 173 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index f567965..ba4077b 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -19,6 +19,43 @@
 #include <xen/events.h>
 #include <asm/xen/pci.h>
 
+static int xen_pcifront_enable_irq(struct pci_dev *dev)
+{
+	int rc;
+	int share = 1;
+	int pirq;
+	u8 gsi;
+
+	rc = pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &gsi);
+	if (rc < 0) {
+		dev_warn(&dev->dev, "Xen PCI: failed to read interrupt line: %d\n",
+			 rc);
+		return rc;
+	}
+
+	rc = xen_allocate_pirq_gsi(gsi);
+	if (rc < 0) {
+		dev_warn(&dev->dev, "Xen PCI: failed to allocate a PIRQ for GSI%d: %d\n",
+			 gsi, rc);
+		return rc;
+	}
+	pirq = rc;
+
+	if (gsi < NR_IRQS_LEGACY)
+		share = 0;
+
+	rc = xen_bind_pirq_gsi_to_irq(gsi, pirq, share, "pcifront");
+	if (rc < 0) {
+		dev_warn(&dev->dev, "Xen PCI: failed to bind GSI%d (PIRQ%d) to IRQ: %d\n",
+			 gsi, pirq, rc);
+		return rc;
+	}
+
+	dev->irq = rc;
+	dev_info(&dev->dev, "Xen PCI mapped GSI%d to IRQ%d\n", gsi, dev->irq);
+	return 0;
+}
+
 #ifdef CONFIG_ACPI
 static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
 				 int trigger, int polarity)
@@ -58,6 +95,87 @@ static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
 }
 #endif
 
+#ifdef CONFIG_XEN_DOM0
+static int xen_register_pirq(u32 gsi, int gsi_override, int triggering)
+{
+	int rc, pirq, irq = -1;
+	struct physdev_map_pirq map_irq;
+	int shareable = 0;
+	char *name;
+
+	if (!xen_pv_domain())
+		return -1;
+
+	if (triggering == ACPI_EDGE_SENSITIVE) {
+		shareable = 0;
+		name = "ioapic-edge";
+	} else {
+		shareable = 1;
+		name = "ioapic-level";
+	}
+	pirq = xen_allocate_pirq_gsi(gsi);
+	if (pirq < 0)
+		goto out;
+
+	if (gsi_override >= 0)
+		irq = xen_bind_pirq_gsi_to_irq(gsi_override, pirq, shareable, name);
+	else
+		irq = xen_bind_pirq_gsi_to_irq(gsi, pirq, shareable, name);
+	if (irq < 0)
+		goto out;
+
+	printk(KERN_DEBUG "xen: --> pirq=%d -> irq=%d (gsi=%d)\n", pirq, irq, gsi);
+
+	map_irq.domid = DOMID_SELF;
+	map_irq.type = MAP_PIRQ_TYPE_GSI;
+	map_irq.index = gsi;
+	map_irq.pirq = pirq;
+
+	rc = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq, &map_irq);
+	if (rc) {
+		printk(KERN_WARNING "xen map irq failed %d\n", rc);
+		return -1;
+	}
+
+out:
+	return irq;
+}
+
+static int xen_register_gsi(u32 gsi, int gsi_override, int triggering, int polarity)
+{
+	int rc, irq;
+	struct physdev_setup_gsi setup_gsi;
+
+	if (!xen_pv_domain())
+		return -1;
+
+	printk(KERN_DEBUG "xen: registering gsi %u triggering %d polarity %d\n",
+			gsi, triggering, polarity);
+
+	irq = xen_register_pirq(gsi, gsi_override, triggering);
+
+	setup_gsi.gsi = gsi;
+	setup_gsi.triggering = (triggering == ACPI_EDGE_SENSITIVE ? 0 : 1);
+	setup_gsi.polarity = (polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
+
+	rc = HYPERVISOR_physdev_op(PHYSDEVOP_setup_gsi, &setup_gsi);
+	if (rc == -EEXIST)
+		printk(KERN_INFO "Already setup the GSI :%d\n", gsi);
+	else if (rc) {
+		printk(KERN_ERR "Failed to setup GSI :%d, err_code:%d\n",
+				gsi, rc);
+	}
+
+	return irq;
+}
+
+static int acpi_register_gsi_xen(struct device *dev, u32 gsi,
+				 int trigger, int polarity)
+{
+	return xen_register_gsi(gsi, -1 /* no GSI override */, trigger, polarity);
+}
+#endif
+
 #if defined(CONFIG_PCI_MSI)
 #include <linux/msi.h>
 #include <asm/msidef.h>
@@ -65,6 +183,46 @@ static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
 struct xen_pci_frontend_ops *xen_pci_frontend;
 EXPORT_SYMBOL_GPL(xen_pci_frontend);
 
+/*
+ * For MSI interrupts we have to use drivers/xen/event.s functions to
+ * allocate an irq_desc and setup the right */
+static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	int irq, ret, i;
+	struct msi_desc *msidesc;
+	int *v;
+
+	v = kzalloc(sizeof(int) * max(1, nvec), GFP_KERNEL);
+	if (!v)
+		return -ENOMEM;
+
+	if (type == PCI_CAP_ID_MSIX)
+		ret = xen_pci_frontend_enable_msix(dev, v, nvec);
+	else
+		ret = xen_pci_frontend_enable_msi(dev, v);
+	if (ret)
+		goto error;
+	i = 0;
+	list_for_each_entry(msidesc, &dev->msi_list, list) {
+		irq = xen_bind_pirq_msi_to_irq(dev, msidesc, v[i], 0,
+					       (type == PCI_CAP_ID_MSIX) ?
+					       "pcifront-msi-x" :
+					       "pcifront-msi",
+						DOMID_SELF);
+		if (irq < 0)
+			goto free;
+		i++;
+	}
+	kfree(v);
+	return 0;
+
+error:
+	dev_err(&dev->dev, "Xen PCI frontend has not registered MSI/MSI-X support!\n");
+free:
+	kfree(v);
+	return ret;
+}
+
 #define XEN_PIRQ_MSI_DATA  (MSI_DATA_TRIGGER_EDGE | \
 		MSI_DATA_LEVEL_ASSERT | (3 << 8) | MSI_DATA_VECTOR(0))
 
@@ -123,67 +281,6 @@ error:
 	return -ENODEV;
 }
 
-/*
- * For MSI interrupts we have to use drivers/xen/event.s functions to
- * allocate an irq_desc and setup the right */
-
-
-static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
-{
-	int irq, ret, i;
-	struct msi_desc *msidesc;
-	int *v;
-
-	v = kzalloc(sizeof(int) * max(1, nvec), GFP_KERNEL);
-	if (!v)
-		return -ENOMEM;
-
-	if (type == PCI_CAP_ID_MSIX)
-		ret = xen_pci_frontend_enable_msix(dev, v, nvec);
-	else
-		ret = xen_pci_frontend_enable_msi(dev, v);
-	if (ret)
-		goto error;
-	i = 0;
-	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq = xen_bind_pirq_msi_to_irq(dev, msidesc, v[i], 0,
-					       (type == PCI_CAP_ID_MSIX) ?
-					       "pcifront-msi-x" :
-					       "pcifront-msi",
-						DOMID_SELF);
-		if (irq < 0)
-			goto free;
-		i++;
-	}
-	kfree(v);
-	return 0;
-
-error:
-	dev_err(&dev->dev, "Xen PCI frontend has not registered MSI/MSI-X support!\n");
-free:
-	kfree(v);
-	return ret;
-}
-
-static void xen_teardown_msi_irqs(struct pci_dev *dev)
-{
-	struct msi_desc *msidesc;
-
-	msidesc = list_entry(dev->msi_list.next, struct msi_desc, list);
-	if (msidesc->msi_attrib.is_msix)
-		xen_pci_frontend_disable_msix(dev);
-	else
-		xen_pci_frontend_disable_msi(dev);
-
-	/* Free the IRQ's and the msidesc using the generic code. */
-	default_teardown_msi_irqs(dev);
-}
-
-static void xen_teardown_msi_irq(unsigned int irq)
-{
-	xen_destroy_irq(irq);
-}
-
 #ifdef CONFIG_XEN_DOM0
 static int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
@@ -242,44 +339,28 @@ out:
 	return ret;
 }
 #endif
-#endif
 
-static int xen_pcifront_enable_irq(struct pci_dev *dev)
+static void xen_teardown_msi_irqs(struct pci_dev *dev)
 {
-	int rc;
-	int share = 1;
-	int pirq;
-	u8 gsi;
+	struct msi_desc *msidesc;
 
-	rc = pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &gsi);
-	if (rc < 0) {
-		dev_warn(&dev->dev, "Xen PCI: failed to read interrupt line: %d\n",
-			 rc);
-		return rc;
-	}
+	msidesc = list_entry(dev->msi_list.next, struct msi_desc, list);
+	if (msidesc->msi_attrib.is_msix)
+		xen_pci_frontend_disable_msix(dev);
+	else
+		xen_pci_frontend_disable_msi(dev);
 
-	rc = xen_allocate_pirq_gsi(gsi);
-	if (rc < 0) {
-		dev_warn(&dev->dev, "Xen PCI: failed to allocate a PIRQ for GSI%d: %d\n",
-			 gsi, rc);
-		return rc;
-	}
-	pirq = rc;
+	/* Free the IRQ's and the msidesc using the generic code. */
+	default_teardown_msi_irqs(dev);
+}
 
-	if (gsi < NR_IRQS_LEGACY)
-		share = 0;
+static void xen_teardown_msi_irq(unsigned int irq)
+{
+	xen_destroy_irq(irq);
+}
 
-	rc = xen_bind_pirq_gsi_to_irq(gsi, pirq, share, "pcifront");
-	if (rc < 0) {
-		dev_warn(&dev->dev, "Xen PCI: failed to bind GSI%d (PIRQ%d) to IRQ: %d\n",
-			 gsi, pirq, rc);
-		return rc;
-	}
+#endif
 
-	dev->irq = rc;
-	dev_info(&dev->dev, "Xen PCI mapped GSI%d to IRQ%d\n", gsi, dev->irq);
-	return 0;
-}
 
 int __init pci_xen_init(void)
 {
@@ -327,79 +408,6 @@ int __init pci_xen_hvm_init(void)
 }
 
 #ifdef CONFIG_XEN_DOM0
-static int xen_register_pirq(u32 gsi, int gsi_override, int triggering)
-{
-	int rc, pirq, irq = -1;
-	struct physdev_map_pirq map_irq;
-	int shareable = 0;
-	char *name;
-
-	if (!xen_pv_domain())
-		return -1;
-
-	if (triggering == ACPI_EDGE_SENSITIVE) {
-		shareable = 0;
-		name = "ioapic-edge";
-	} else {
-		shareable = 1;
-		name = "ioapic-level";
-	}
-	pirq = xen_allocate_pirq_gsi(gsi);
-	if (pirq < 0)
-		goto out;
-
-	if (gsi_override >= 0)
-		irq = xen_bind_pirq_gsi_to_irq(gsi_override, pirq, shareable, name);
-	else
-		irq = xen_bind_pirq_gsi_to_irq(gsi, pirq, shareable, name);
-	if (irq < 0)
-		goto out;
-
-	printk(KERN_DEBUG "xen: --> pirq=%d -> irq=%d (gsi=%d)\n", pirq, irq, gsi);
-
-	map_irq.domid = DOMID_SELF;
-	map_irq.type = MAP_PIRQ_TYPE_GSI;
-	map_irq.index = gsi;
-	map_irq.pirq = pirq;
-
-	rc = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq, &map_irq);
-	if (rc) {
-		printk(KERN_WARNING "xen map irq failed %d\n", rc);
-		return -1;
-	}
-
-out:
-	return irq;
-}
-
-static int xen_register_gsi(u32 gsi, int gsi_override, int triggering, int polarity)
-{
-	int rc, irq;
-	struct physdev_setup_gsi setup_gsi;
-
-	if (!xen_pv_domain())
-		return -1;
-
-	printk(KERN_DEBUG "xen: registering gsi %u triggering %d polarity %d\n",
-			gsi, triggering, polarity);
-
-	irq = xen_register_pirq(gsi, gsi_override, triggering);
-
-	setup_gsi.gsi = gsi;
-	setup_gsi.triggering = (triggering == ACPI_EDGE_SENSITIVE ? 0 : 1);
-	setup_gsi.polarity = (polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-
-	rc = HYPERVISOR_physdev_op(PHYSDEVOP_setup_gsi, &setup_gsi);
-	if (rc == -EEXIST)
-		printk(KERN_INFO "Already setup the GSI :%d\n", gsi);
-	else if (rc) {
-		printk(KERN_ERR "Failed to setup GSI :%d, err_code:%d\n",
-				gsi, rc);
-	}
-
-	return irq;
-}
-
 static __init void xen_setup_acpi_sci(void)
 {
 	int rc;
@@ -447,12 +455,6 @@ static __init void xen_setup_acpi_sci(void)
 	return;
 }
 
-static int acpi_register_gsi_xen(struct device *dev, u32 gsi,
-				 int trigger, int polarity)
-{
-	return xen_register_gsi(gsi, -1 /* no GSI override */, trigger, polarity);
-}
-
 static int __init pci_xen_initial_domain(void)
 {
 #ifdef CONFIG_PCI_MSI
@@ -493,9 +495,7 @@ void __init xen_setup_pirqs(void)
 			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE);
 	}
 }
-#endif
 
-#ifdef CONFIG_XEN_DOM0
 struct xen_device_domain_owner {
 	domid_t domain;
 	struct pci_dev *dev;
-- 
1.7.4.1

