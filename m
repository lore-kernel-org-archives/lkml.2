Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423Ab0JSLRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:17:55 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:49801 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348Ab0JSLRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:17:54 -0400
X-IronPort-AV: E=Sophos;i="4.57,350,1283745600"; 
   d="scan'208";a="118686914"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        Stefano.Stabellini@eu.citrix.com, Qing He <qing.he@intel.com>,
        Yunhong Jiang <yunhong.jiang@intel.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 03/10] xen: remap MSIs into pirqs when running as initial domain
Date: Tue, 19 Oct 2010 12:17:11 +0100
Message-Id: <1287487038-6643-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1010191207010.2423@kaball-desktop>
References: <alpine.DEB.2.00.1010191207010.2423@kaball-desktop>
X-OriginalArrivalTime: 19 Oct 2010 11:17:53.0390 (UTC) FILETIME=[45DE08E0:01CB6F7F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing He <qing.he@intel.com>

Implement xen_create_msi_irq to create an msi and remap it as pirq.
Use xen_create_msi_irq to implement an initial domain specific version
of setup_msi_irqs.

Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Yunhong Jiang <yunhong.jiang@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/pci/xen.c   |   55 ++++++++++++++++++++++++++++++---------------
 drivers/xen/events.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/xen/events.h |    4 +++
 3 files changed, 101 insertions(+), 18 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 3a1017d..4f5df3d 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -135,14 +135,12 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	if (!v)
 		return -ENOMEM;
 
-	if (!xen_initial_domain()) {
-		if (type == PCI_CAP_ID_MSIX)
-			ret = xen_pci_frontend_enable_msix(dev, &v, nvec);
-		else
-			ret = xen_pci_frontend_enable_msi(dev, &v);
-		if (ret)
-			goto error;
-	}
+	if (type == PCI_CAP_ID_MSIX)
+		ret = xen_pci_frontend_enable_msix(dev, &v, nvec);
+	else
+		ret = xen_pci_frontend_enable_msi(dev, &v);
+	if (ret)
+		goto error;
 	i = 0;
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 		irq = xen_allocate_pirq(v[i], 0, /* not sharable */
@@ -172,23 +170,40 @@ error:
 
 static void xen_teardown_msi_irqs(struct pci_dev *dev)
 {
-	/* Only do this when were are in non-privileged mode.*/
-	if (!xen_initial_domain()) {
-		struct msi_desc *msidesc;
-
-		msidesc = list_entry(dev->msi_list.next, struct msi_desc, list);
-		if (msidesc->msi_attrib.is_msix)
-			xen_pci_frontend_disable_msix(dev);
-		else
-			xen_pci_frontend_disable_msi(dev);
-	}
+	struct msi_desc *msidesc;
 
+	msidesc = list_entry(dev->msi_list.next, struct msi_desc, list);
+	if (msidesc->msi_attrib.is_msix)
+		xen_pci_frontend_disable_msix(dev);
+	else
+		xen_pci_frontend_disable_msi(dev);
 }
 
 static void xen_teardown_msi_irq(unsigned int irq)
 {
 	xen_destroy_irq(irq);
 }
+
+static int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	int irq, ret;
+	struct msi_desc *msidesc;
+
+	list_for_each_entry(msidesc, &dev->msi_list, list) {
+		irq = xen_create_msi_irq(dev, msidesc, type);
+		if (irq < 0)
+			return -1;
+
+		ret = set_irq_msi(irq, msidesc);
+		if (ret)
+			goto error;
+	}
+	return 0;
+
+error:
+	xen_destroy_irq(irq);
+	return ret;
+}
 #endif
 
 static int xen_pcifront_enable_irq(struct pci_dev *dev)
@@ -367,6 +382,10 @@ static int acpi_register_gsi_xen(struct device *dev, u32 gsi,
 
 static int __init pci_xen_initial_domain(void)
 {
+#ifdef CONFIG_PCI_MSI
+	x86_msi.setup_msi_irqs = xen_initdom_setup_msi_irqs;
+	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
+#endif
 	xen_setup_acpi_sci();
 	__acpi_register_gsi = acpi_register_gsi_xen;
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 4138def..d59debb 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -29,6 +29,7 @@
 #include <linux/bootmem.h>
 #include <linux/slab.h>
 #include <linux/irqnr.h>
+#include <linux/pci.h>
 
 #include <asm/desc.h>
 #include <asm/ptrace.h>
@@ -658,6 +659,10 @@ out:
 	return irq;
 }
 
+#ifdef CONFIG_PCI_MSI
+#include <linux/msi.h>
+#include "../pci/msi.h"
+
 void xen_allocate_pirq_msi(char *name, int *irq, int *pirq)
 {
 	spin_lock(&irq_mapping_update_lock);
@@ -680,6 +685,61 @@ out:
 	spin_unlock(&irq_mapping_update_lock);
 }
 
+int xen_create_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int type)
+{
+	int irq = -1;
+	struct physdev_map_pirq map_irq;
+	int rc;
+	int pos;
+	u32 table_offset, bir;
+
+	memset(&map_irq, 0, sizeof(map_irq));
+	map_irq.domid = DOMID_SELF;
+	map_irq.type = MAP_PIRQ_TYPE_MSI;
+	map_irq.index = -1;
+	map_irq.pirq = -1;
+	map_irq.bus = dev->bus->number;
+	map_irq.devfn = dev->devfn;
+
+	if (type == PCI_CAP_ID_MSIX) {
+		pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
+
+		pci_read_config_dword(dev, msix_table_offset_reg(pos),
+					&table_offset);
+		bir = (u8)(table_offset & PCI_MSIX_FLAGS_BIRMASK);
+
+		map_irq.table_base = pci_resource_start(dev, bir);
+		map_irq.entry_nr = msidesc->msi_attrib.entry_nr;
+	}
+
+	spin_lock(&irq_mapping_update_lock);
+
+	irq = find_unbound_irq();
+
+	if (irq == -1)
+		goto out;
+
+	rc = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq, &map_irq);
+	if (rc) {
+		printk(KERN_WARNING "xen map irq failed %d\n", rc);
+
+		dynamic_irq_cleanup(irq);
+
+		irq = -1;
+		goto out;
+	}
+	irq_info[irq] = mk_pirq_info(0, map_irq.pirq, 0, map_irq.index);
+
+	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
+			handle_level_irq,
+			(type == PCI_CAP_ID_MSIX) ? "msi-x":"msi");
+
+out:
+	spin_unlock(&irq_mapping_update_lock);
+	return irq;
+}
+#endif
+
 int xen_destroy_irq(int irq)
 {
 	struct irq_desc *desc;
diff --git a/include/xen/events.h b/include/xen/events.h
index 0c58db6..8fa27dc 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -72,8 +72,12 @@ void xen_hvm_evtchn_do_upcall(void);
  * usual. */
 int xen_allocate_pirq(unsigned gsi, int shareable, char *name);
 int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name);
+
+#ifdef CONFIG_PCI_MSI
 /* Allocate an irq and a pirq to be used with MSIs. */
 void xen_allocate_pirq_msi(char *name, int *irq, int *pirq);
+int xen_create_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int type);
+#endif
 
 /* De-allocates the above mentioned physical interrupt. */
 int xen_destroy_irq(int irq);
-- 
1.5.6.5

