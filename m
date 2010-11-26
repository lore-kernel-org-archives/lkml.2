Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab0KZO7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 09:59:11 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:13738 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab0KZO7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 09:59:09 -0500
X-IronPort-AV: E=Sophos;i="4.59,261,1288569600"; 
   d="scan'208";a="3066090"
Date: Fri, 26 Nov 2010 14:59:10 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: linux-kernel@vger.kernel.org
CC: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: [PATCH] xen: fix MSI setup and teardown for PV on HVM guests
Message-ID: <alpine.DEB.2.00.1011251904370.2373@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen: fix MSI setup and teardown for PV on HVM guests

When remapping MSIs into pirqs for PV on HVM guests, qemu is responsible
for doing the actual mapping and unmapping.
We only give qemu the desired pirq number when we ask to do the mapping
the first time, after that we should be reading back the pirq number
from qemu every time we want to re-enable the MSI.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index d7b5109..ff81d67 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -98,8 +98,26 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	struct msi_msg msg;
 
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
+		__read_msi_msg(msidesc, &msg);
+		pirq = MSI_ADDR_EXT_DEST_ID(msg.address_hi) |
+			((msg.address_lo >> MSI_ADDR_DEST_ID_SHIFT) & 0xff);
+		if (xen_irq_from_pirq(pirq) >= 0 &&
+			msg.data == (MSI_DATA_TRIGGER_EDGE |
+					     MSI_DATA_LEVEL_ASSERT |
+						 (3 << 8) |
+						 MSI_DATA_VECTOR(0))) {
+			xen_allocate_pirq_msi((type == PCI_CAP_ID_MSIX) ?
+					"msi-x" : "msi", &irq, &pirq, XEN_ALLOC_IRQ);
+			if (irq < 0 || pirq < 0)
+				goto error;
+			ret = set_irq_msi(irq, msidesc);
+			if (ret < 0)
+				goto error_while;
+			printk(KERN_DEBUG "xen: msi already setup: pirq=%d\n", pirq);
+			return 0;
+		}
 		xen_allocate_pirq_msi((type == PCI_CAP_ID_MSIX) ?
-				"msi-x" : "msi", &irq, &pirq);
+				"msi-x" : "msi", &irq, &pirq, (XEN_ALLOC_IRQ | XEN_ALLOC_PIRQ));
 		if (irq < 0 || pirq < 0)
 			goto error;
 		printk(KERN_DEBUG "xen: msi --> irq=%d, pirq=%d\n", irq, pirq);
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 6e5dd92..5de6a6c 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -668,17 +668,21 @@ out:
 #include <linux/msi.h>
 #include "../pci/msi.h"
 
-void xen_allocate_pirq_msi(char *name, int *irq, int *pirq)
+void xen_allocate_pirq_msi(char *name, int *irq, int *pirq, int alloc)
 {
 	spin_lock(&irq_mapping_update_lock);
 
-	*irq = find_unbound_irq();
-	if (*irq == -1)
-		goto out;
+	if (alloc & XEN_ALLOC_IRQ) {
+		*irq = find_unbound_irq();
+		if (*irq == -1)
+			goto out;
+	}
 
-	*pirq = find_unbound_pirq(MAP_PIRQ_TYPE_MSI);
-	if (*pirq == -1)
-		goto out;
+	if (alloc & XEN_ALLOC_PIRQ) {
+		*pirq = find_unbound_pirq(MAP_PIRQ_TYPE_MSI);
+		if (*pirq == -1)
+			goto out;
+	}
 
 	set_irq_chip_and_handler_name(*irq, &xen_pirq_chip,
 				      handle_level_irq, name);
@@ -766,6 +770,7 @@ int xen_destroy_irq(int irq)
 			printk(KERN_WARNING "unmap irq failed %d\n", rc);
 			goto out;
 		}
+		pirq_to_irq[info->u.pirq.pirq] = -1;
 	}
 	irq_info[irq] = mk_unbound_info();
 
@@ -786,6 +791,11 @@ int xen_gsi_from_irq(unsigned irq)
 	return gsi_from_irq(irq);
 }
 
+int xen_irq_from_pirq(unsigned pirq)
+{
+	return pirq_to_irq[pirq];
+}
+
 int bind_evtchn_to_irq(unsigned int evtchn)
 {
 	int irq;
diff --git a/include/xen/events.h b/include/xen/events.h
index 646dd17..00f53dd 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -76,7 +76,9 @@ int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name);
 
 #ifdef CONFIG_PCI_MSI
 /* Allocate an irq and a pirq to be used with MSIs. */
-void xen_allocate_pirq_msi(char *name, int *irq, int *pirq);
+#define XEN_ALLOC_PIRQ (1 << 0)
+#define XEN_ALLOC_IRQ  (1 << 1)
+void xen_allocate_pirq_msi(char *name, int *irq, int *pirq, int alloc_mask);
 int xen_create_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int type);
 #endif
 
@@ -89,4 +91,7 @@ int xen_vector_from_irq(unsigned pirq);
 /* Return gsi allocated to pirq */
 int xen_gsi_from_irq(unsigned pirq);
 
+/* Return irq from pirq */
+int xen_irq_from_pirq(unsigned pirq);
+
 #endif	/* _XEN_EVENTS_H */
