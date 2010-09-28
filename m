Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0I1MRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:17:30 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:47172 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab0I1MR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:17:28 -0400
X-IronPort-AV: E=Sophos;i="4.57,247,1283745600"; 
   d="scan'208";a="115729350"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 01/12] xen: remap GSIs as pirqs when running as initial domain
Date: Tue, 28 Sep 2010 13:16:47 +0100
Message-Id: <1285676218-26218-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
References: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
X-OriginalArrivalTime: 28 Sep 2010 12:17:02.0839 (UTC) FILETIME=[0ED43870:01CB5F07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Implement xen_register_gsi to setup the correct triggering and polarity
properties of a gsi.
Implement xen_register_pirq to register a particular gsi as pirq and
receive interrupts as events.
Call xen_setup_pirqs to register all the legacy ISA irqs as pirqs.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/pci/xen.c              |  144 ++++++++++++++++++++++++++++++++++++++-
 drivers/xen/events.c            |   13 ++++
 include/xen/events.h            |    2 +
 include/xen/interface/physdev.h |   10 +++
 4 files changed, 168 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 6fbc81a..cb8d5be 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -18,6 +18,108 @@
 #include <xen/events.h>
 #include <asm/xen/pci.h>
 
+static int xen_register_pirq(u32 gsi, int triggering)
+{
+	int rc, irq;
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
+
+	irq = xen_allocate_pirq(gsi, shareable, name);
+
+	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
+
+	if (irq < 0)
+		goto out;
+
+	map_irq.domid = DOMID_SELF;
+	map_irq.type = MAP_PIRQ_TYPE_GSI;
+	map_irq.index = gsi;
+	map_irq.pirq = irq;
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
+static int xen_register_gsi(u32 gsi, int triggering, int polarity)
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
+	irq = xen_register_pirq(gsi, triggering);
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
+#ifdef CONFIG_ACPI
+static __init void xen_setup_acpi_sci(void)
+{
+	int rc;
+	int trigger, polarity;
+	int gsi = acpi_sci_override_gsi;
+
+	if (!gsi)
+		return;
+
+	rc = acpi_get_override_irq(gsi, &trigger, &polarity);
+	if (rc)
+		return;
+	trigger = trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE;
+	polarity = polarity ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
+	
+	printk("xen: sci override: global_irq=%d trigger=%d polarity=%d\n",
+			gsi, trigger, polarity);
+
+	gsi = xen_register_gsi(gsi,	trigger, polarity);
+	/*
+	 * stash over-ride to indicate we've been here
+	 * and for later update of acpi_gbl_FADT
+	 */
+	printk("xen: acpi sci %d\n", gsi);
+
+	return;
+}
+#else
+static __init void xen_setup_acpi_sci(void)
+{
+}
+#endif
+
 int xen_hvm_register_pirq(u32 gsi, int triggering)
 {
 	int rc, irq;
@@ -211,10 +313,15 @@ static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
 	return xen_hvm_register_pirq(gsi, trigger);
 }
 
+static int acpi_register_gsi_xen(struct device *dev, u32 gsi,
+				 int trigger, int polarity)
+{
+	return xen_register_gsi(gsi, trigger, polarity);
+}
 
 int __init pci_xen_init(void)
 {
-	if (!xen_pv_domain() || xen_initial_domain())
+ 	if (!xen_pv_domain() || xen_initial_domain())
 		return -ENODEV;
 
 	printk(KERN_INFO "PCI: setting up Xen PCI frontend stub\n");
@@ -242,6 +349,41 @@ int __init pci_xen_init(void)
 	return 0;
 }
 
+static int __init pci_xen_initial_domain(void)
+{
+	xen_setup_acpi_sci();
+	__acpi_register_gsi = acpi_register_gsi_xen;
+
+	return 0;
+}
+
+void __init xen_setup_pirqs(void)
+{
+	int irq;
+#ifndef CONFIG_SMP
+	int nr_ioapics = 1;
+#endif
+
+	pci_xen_initial_domain();
+
+	if (0 == nr_ioapics) {
+		for (irq = 0; irq < NR_IRQS_LEGACY; irq++)
+			xen_allocate_pirq(irq, 0, "xt-pic");
+		return;
+	}
+
+	/* Pre-allocate legacy irqs */
+	for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
+		int trigger, polarity;
+
+		if (acpi_get_override_irq(irq, &trigger, &polarity) == -1)
+			continue;
+
+		xen_register_pirq(irq,
+			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE);
+	}
+}
+
 int __init pci_xen_hvm_init(void)
 {
 	if (!xen_feature(XENFEAT_hvm_pirqs))
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index a31677e..27e4b70 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -676,6 +676,8 @@ out:
 int xen_destroy_irq(int irq)
 {
 	struct irq_desc *desc;
+	struct physdev_unmap_pirq unmap_irq;
+	struct irq_info *info = info_for_irq(irq);
 	int rc = -ENOENT;
 
 	spin_lock(&irq_mapping_update_lock);
@@ -684,6 +686,15 @@ int xen_destroy_irq(int irq)
 	if (!desc)
 		goto out;
 
+	if (xen_initial_domain()) {
+		unmap_irq.pirq = info->u.pirq.gsi;
+		unmap_irq.domid = DOMID_SELF;
+		rc = HYPERVISOR_physdev_op(PHYSDEVOP_unmap_pirq, &unmap_irq);
+		if (rc) {
+			printk(KERN_WARNING "unmap irq failed %d\n", rc);
+			goto out;
+		}
+	}
 	irq_info[irq] = mk_unbound_info();
 
 	dynamic_irq_cleanup(irq);
@@ -1410,5 +1421,7 @@ void __init xen_init_IRQ(void)
 		pci_xen_hvm_init();
 	} else {
 		irq_ctx_init(smp_processor_id());
+		if (xen_initial_domain())
+			xen_setup_pirqs();
 	}
 }
diff --git a/include/xen/events.h b/include/xen/events.h
index 5e67be7..9853fce 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -84,4 +84,6 @@ int xen_vector_from_irq(unsigned pirq);
 /* Return gsi allocated to pirq */
 int xen_gsi_from_irq(unsigned pirq);
 
+void xen_setup_pirqs(void);
+
 #endif	/* _XEN_EVENTS_H */
diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
index 69a72b9..a85d76c 100644
--- a/include/xen/interface/physdev.h
+++ b/include/xen/interface/physdev.h
@@ -151,6 +151,16 @@ struct physdev_op {
 	} u;
 };
 
+#define PHYSDEVOP_setup_gsi    21
+struct physdev_setup_gsi {
+    int gsi;
+    /* IN */
+    uint8_t triggering;
+    /* IN */
+    uint8_t polarity;
+    /* IN */
+};
+
 #define PHYSDEVOP_get_nr_pirqs    22
 struct physdev_nr_pirqs {
     /* OUT */
-- 
1.5.6.5

