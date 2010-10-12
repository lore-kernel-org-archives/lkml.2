Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab0JLQnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:43:00 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:32802 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492Ab0JLQm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:42:58 -0400
X-IronPort-AV: E=Sophos;i="4.57,320,1283745600"; 
   d="scan'208";a="117745972"
From: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3 02/10] xen: remap GSIs as pirqs when running as initial domain
Date: Tue, 12 Oct 2010 17:42:42 +0100
Message-Id: <1286901770-8612-2-git-send-email-Stefano.Stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1010121043030.2422@kaball-desktop>
References: <alpine.DEB.2.00.1010121043030.2422@kaball-desktop>
X-OriginalArrivalTime: 12 Oct 2010 16:42:58.0318 (UTC) FILETIME=[86D19AE0:01CB6A2C]
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
 arch/x86/include/asm/xen/pci.h  |    7 ++
 arch/x86/pci/xen.c              |  132 +++++++++++++++++++++++++++++++++++++++
 drivers/xen/events.c            |   13 ++++
 include/xen/interface/physdev.h |   10 +++
 4 files changed, 162 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/xen/pci.h b/arch/x86/include/asm/xen/pci.h
index f89a42a..2329b3e 100644
--- a/arch/x86/include/asm/xen/pci.h
+++ b/arch/x86/include/asm/xen/pci.h
@@ -13,6 +13,13 @@ static inline int pci_xen_hvm_init(void)
 	return -1;
 }
 #endif
+#if defined(CONFIG_XEN_DOM0)
+void __init xen_setup_pirqs(void);
+#else
+static inline void __init xen_setup_pirqs(void)
+{
+}
+#endif
 
 #if defined(CONFIG_PCI_MSI)
 #if defined(CONFIG_PCI_XEN)
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index fb20d05..5d87774 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -262,3 +262,135 @@ int __init pci_xen_hvm_init(void)
 #endif
 	return 0;
 }
+
+#ifdef CONFIG_XEN_DOM0
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
+	gsi = xen_register_gsi(gsi, trigger, polarity);
+	printk("xen: acpi sci %d\n", gsi);
+
+	return;
+}
+
+static int acpi_register_gsi_xen(struct device *dev, u32 gsi,
+				 int trigger, int polarity)
+{
+	return xen_register_gsi(gsi, trigger, polarity);
+}
+
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
+#endif
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 2edbf7c..4138def 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -683,6 +683,8 @@ out:
 int xen_destroy_irq(int irq)
 {
 	struct irq_desc *desc;
+	struct physdev_unmap_pirq unmap_irq;
+	struct irq_info *info = info_for_irq(irq);
 	int rc = -ENOENT;
 
 	spin_lock(&irq_mapping_update_lock);
@@ -691,6 +693,15 @@ int xen_destroy_irq(int irq)
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
@@ -1427,5 +1438,7 @@ void __init xen_init_IRQ(void)
 		pci_xen_hvm_init();
 	} else {
 		irq_ctx_init(smp_processor_id());
+		if (xen_initial_domain())
+			xen_setup_pirqs();
 	}
 }
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

