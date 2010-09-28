Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab0I1MRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:17:32 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:47172 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab0I1MRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:17:30 -0400
X-IronPort-AV: E=Sophos;i="4.57,247,1283745600"; 
   d="scan'208";a="115729356"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Qing He <qing.he@intel.com>, Yunhong Jiang <yunhong.jiang@intel.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 02/12] xen: remap MSIs into pirqs when running as initial domain
Date: Tue, 28 Sep 2010 13:16:48 +0100
Message-Id: <1285676218-26218-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
References: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
X-OriginalArrivalTime: 28 Sep 2010 12:17:05.0167 (UTC) FILETIME=[103771F0:01CB5F07]
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
 arch/x86/pci/xen.c   |   55 +++++++++++++++++++++++++++++++---------------
 drivers/xen/events.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/xen/events.h |    2 +
 3 files changed, 97 insertions(+), 18 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index cb8d5be..8453e36 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -229,14 +229,12 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
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
@@ -266,23 +264,40 @@ error:
 
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
+int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
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
@@ -351,6 +366,10 @@ int __init pci_xen_init(void)
 
 static int __init pci_xen_initial_domain(void)
 {
+#ifdef CONFIG_PCI_MSI
+	x86_msi.setup_msi_irqs = xen_initdom_setup_msi_irqs;
+	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
+#endif
 	xen_setup_acpi_sci();
 	__acpi_register_gsi = acpi_register_gsi_xen;
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 27e4b70..b83918a 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -29,6 +29,8 @@
 #include <linux/bootmem.h>
 #include <linux/slab.h>
 #include <linux/irqnr.h>
+#include <linux/pci.h>
+#include <linux/msi.h>
 
 #include <asm/desc.h>
 #include <asm/ptrace.h>
@@ -49,6 +51,8 @@
 #include <xen/interface/hvm/hvm_op.h>
 #include <xen/interface/hvm/params.h>
 
+#include "../pci/msi.h"
+
 /*
  * This lock protects updates to the following mapping and reference-count
  * arrays. The lock does not need to be acquired to read the mapping tables.
@@ -704,6 +708,60 @@ out:
 	return rc;
 }
 
+int xen_create_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int type)
+{
+	int irq = 0;
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
+
 int xen_vector_from_irq(unsigned irq)
 {
 	return vector_from_irq(irq);
diff --git a/include/xen/events.h b/include/xen/events.h
index 9853fce..8cd18a5 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -78,6 +78,8 @@ void xen_allocate_pirq_msi(char *name, int *irq, int *pirq);
 /* De-allocates the above mentioned physical interrupt. */
 int xen_destroy_irq(int irq);
 
+int xen_create_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int type);
+
 /* Return vector allocated to pirq */
 int xen_vector_from_irq(unsigned pirq);
 
-- 
1.5.6.5

