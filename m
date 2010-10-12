Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab0JLQfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:35:16 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30077 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740Ab0JLQfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:35:14 -0400
X-IronPort-AV: E=Sophos;i="4.57,320,1283745600"; 
   d="scan'208";a="117744617"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad.wilk@oracle.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 7/7] xen: map MSIs into pirqs
Date: Tue, 12 Oct 2010 17:34:49 +0100
Message-Id: <1286901289-8156-7-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1010121121160.2423@kaball-desktop>
References: <alpine.DEB.2.00.1010121121160.2423@kaball-desktop>
X-OriginalArrivalTime: 12 Oct 2010 16:35:13.0764 (UTC) FILETIME=[71EC4A40:01CB6A2B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Map MSIs into pirqs, writing 0 in the MSI vector data field and the pirq
number in the MSI destination id field.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c   |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/xen/events.c |   22 +++++++++++++++++++
 include/xen/events.h |    2 +
 3 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 90a8f83..fb20d05 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -64,10 +64,62 @@ static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
 
 #if defined(CONFIG_PCI_MSI)
 #include <linux/msi.h>
+#include <asm/msidef.h>
 
 struct xen_pci_frontend_ops *xen_pci_frontend;
 EXPORT_SYMBOL_GPL(xen_pci_frontend);
 
+static void xen_msi_compose_msg(struct pci_dev *pdev, unsigned int pirq,
+		struct msi_msg *msg)
+{
+	/* We set vector == 0 to tell the hypervisor we don't care about it,
+	 * but we want a pirq setup instead.
+	 * We use the dest_id field to pass the pirq that we want. */
+	msg->address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID(pirq);
+	msg->address_lo =
+		MSI_ADDR_BASE_LO |
+		MSI_ADDR_DEST_MODE_PHYSICAL |
+		MSI_ADDR_REDIRECTION_CPU |
+		MSI_ADDR_DEST_ID(pirq);
+
+	msg->data =
+		MSI_DATA_TRIGGER_EDGE |
+		MSI_DATA_LEVEL_ASSERT |
+		/* delivery mode reserved */
+		(3 << 8) |
+		MSI_DATA_VECTOR(0);
+}
+
+static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	int irq, pirq, ret = 0;
+	struct msi_desc *msidesc;
+	struct msi_msg msg;
+
+	list_for_each_entry(msidesc, &dev->msi_list, list) {
+		xen_allocate_pirq_msi((type == PCI_CAP_ID_MSIX) ?
+				"msi-x" : "msi", &irq, &pirq);
+		if (irq < 0 || pirq < 0)
+			goto error;
+		printk(KERN_DEBUG "xen: msi --> irq=%d, pirq=%d\n", irq, pirq);
+		xen_msi_compose_msg(dev, pirq, &msg);
+		ret = set_irq_msi(irq, msidesc);
+		if (ret < 0)
+			goto error_while;
+		write_msi_msg(irq, &msg);
+	}
+	return 0;
+
+error_while:
+	unbind_from_irqhandler(irq, NULL);
+error:
+	if (ret == -ENODEV)
+		dev_err(&dev->dev, "Xen PCI frontend has not registered" \
+				" MSI/MSI-X support!\n");
+
+	return ret;
+}
+
 /*
  * For MSI interrupts we have to use drivers/xen/event.s functions to
  * allocate an irq_desc and setup the right */
@@ -203,5 +255,10 @@ int __init pci_xen_hvm_init(void)
 	 */
 	__acpi_register_gsi = acpi_register_gsi_xen_hvm;
 #endif
+
+#ifdef CONFIG_PCI_MSI
+	x86_msi.setup_msi_irqs = xen_hvm_setup_msi_irqs;
+	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
+#endif
 	return 0;
 }
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 5e4fe09..2edbf7c 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -658,6 +658,28 @@ out:
 	return irq;
 }
 
+void xen_allocate_pirq_msi(char *name, int *irq, int *pirq)
+{
+	spin_lock(&irq_mapping_update_lock);
+
+	*irq = find_unbound_irq();
+	if (*irq == -1)
+		goto out;
+
+	*pirq = find_unbound_pirq();
+	if (*pirq == -1)
+		goto out;
+
+	set_irq_chip_and_handler_name(*irq, &xen_pirq_chip,
+				      handle_level_irq, name);
+
+	irq_info[*irq] = mk_pirq_info(0, *pirq, 0, 0);
+	pirq_to_irq[*pirq] = *irq;
+
+out:
+	spin_unlock(&irq_mapping_update_lock);
+}
+
 int xen_destroy_irq(int irq)
 {
 	struct irq_desc *desc;
diff --git a/include/xen/events.h b/include/xen/events.h
index deec8fa..0c58db6 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -72,6 +72,8 @@ void xen_hvm_evtchn_do_upcall(void);
  * usual. */
 int xen_allocate_pirq(unsigned gsi, int shareable, char *name);
 int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name);
+/* Allocate an irq and a pirq to be used with MSIs. */
+void xen_allocate_pirq_msi(char *name, int *irq, int *pirq);
 
 /* De-allocates the above mentioned physical interrupt. */
 int xen_destroy_irq(int irq);
-- 
1.5.6.5

