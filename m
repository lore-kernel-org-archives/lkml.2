Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab1CIRnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:43:31 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:8739 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932879Ab1CIRlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:41:42 -0500
X-IronPort-AV: E=Sophos;i="4.62,291,1297054800"; 
   d="scan'208";a="139432608"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 06/14] xen: events: refactor GSI pirq bindings functions
Date: Wed,  9 Mar 2011 17:41:18 +0000
Message-Id: <1299692486-28634-6-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 09 Mar 2011 17:41:41.0477 (UTC) FILETIME=[3FEC0150:01CBDE81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the example set by xen_allocate_pirq_msi and
xen_bind_pirq_msi_to_irq:

xen_allocate_pirq becomes xen_allocate_pirq_gsi and now only allocates
a pirq number and does not bind it.

xen_map_pirq_gsi becomes xen_bind_pirq_gsi_to_irq and binds an
existing pirq.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 arch/x86/pci/xen.c   |   40 ++++++++++++++++++++++++++++------------
 drivers/xen/events.c |    7 ++++---
 include/xen/events.h |   10 +++++++---
 3 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 8c4085a..b0fb79d 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -50,7 +50,7 @@ static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
 		name = "ioapic-level";
 	}
 
-	irq = xen_map_pirq_gsi(map_irq.pirq, gsi, shareable, name);
+	irq = xen_bind_pirq_gsi_to_irq(gsi, map_irq.pirq, shareable, name);
 
 	printk(KERN_DEBUG "xen: --> irq=%d, pirq=%d\n", irq, map_irq.pirq);
 
@@ -237,6 +237,7 @@ static int xen_pcifront_enable_irq(struct pci_dev *dev)
 {
 	int rc;
 	int share = 1;
+	int pirq;
 	u8 gsi;
 
 	rc = pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &gsi);
@@ -246,13 +247,21 @@ static int xen_pcifront_enable_irq(struct pci_dev *dev)
 		return rc;
 	}
 
+	rc = xen_allocate_pirq_gsi(gsi);
+	if (rc < 0) {
+		dev_warn(&dev->dev, "Xen PCI: failed to allocate a PIRQ for GSI%d: %d\n",
+			 gsi, rc);
+		return rc;
+	}
+	pirq = rc;
+
 	if (gsi < NR_IRQS_LEGACY)
 		share = 0;
 
-	rc = xen_allocate_pirq(gsi, share, "pcifront");
+	rc = xen_bind_pirq_gsi_to_irq(gsi, pirq, share, "pcifront");
 	if (rc < 0) {
-		dev_warn(&dev->dev, "Xen PCI: failed to register GSI%d: %d\n",
-			 gsi, rc);
+		dev_warn(&dev->dev, "Xen PCI: failed to bind GSI%d (PIRQ%d) to IRQ: %d\n",
+			 gsi, pirq, rc);
 		return rc;
 	}
 
@@ -309,7 +318,7 @@ int __init pci_xen_hvm_init(void)
 #ifdef CONFIG_XEN_DOM0
 static int xen_register_pirq(u32 gsi, int triggering)
 {
-	int rc, irq;
+	int rc, pirq, irq = -1;
 	struct physdev_map_pirq map_irq;
 	int shareable = 0;
 	char *name;
@@ -325,17 +334,20 @@ static int xen_register_pirq(u32 gsi, int triggering)
 		name = "ioapic-level";
 	}
 
-	irq = xen_allocate_pirq(gsi, shareable, name);
-
-	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
+	pirq = xen_allocate_pirq_gsi(gsi);
+	if (pirq < 0)
+		goto out;
 
+	irq = xen_bind_pirq_gsi_to_irq(gsi, pirq, shareable, name);
 	if (irq < 0)
 		goto out;
 
+	printk(KERN_DEBUG "xen: --> pirq=%d -> irq=%d\n", pirq, irq);
+
 	map_irq.domid = DOMID_SELF;
 	map_irq.type = MAP_PIRQ_TYPE_GSI;
 	map_irq.index = gsi;
-	map_irq.pirq = irq;
+	map_irq.pirq = pirq;
 
 	rc = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq, &map_irq);
 	if (rc) {
@@ -422,13 +434,17 @@ static int __init pci_xen_initial_domain(void)
 
 void __init xen_setup_pirqs(void)
 {
-	int irq;
+	int pirq, irq;
 
 	pci_xen_initial_domain();
 
 	if (0 == nr_ioapics) {
-		for (irq = 0; irq < NR_IRQS_LEGACY; irq++)
-			xen_allocate_pirq(irq, 0, "xt-pic");
+		for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
+			pirq = xen_allocate_pirq_gsi(irq);
+			if (pirq < 0)
+				break;
+			irq = xen_bind_pirq_gsi_to_irq(irq, pirq, 0, "xt-pic");
+		}
 		return;
 	}
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index e828456..a40b2a1 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -568,9 +568,9 @@ static int find_irq_by_gsi(unsigned gsi)
 	return -1;
 }
 
-int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
+int xen_allocate_pirq_gsi(unsigned gsi)
 {
-	return xen_map_pirq_gsi(gsi, gsi, shareable, name);
+	return gsi;
 }
 
 /*
@@ -580,7 +580,8 @@ int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
  * Note: We don't assign an event channel until the irq actually started
  * up.  Return an existing irq if we've already got one for the gsi.
  */
-int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name)
+int xen_bind_pirq_gsi_to_irq(unsigned gsi,
+			     unsigned pirq, int shareable, char *name)
 {
 	int irq = -1;
 	struct physdev_irq irq_op;
diff --git a/include/xen/events.h b/include/xen/events.h
index 99a64f0..32ebeba 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -68,12 +68,16 @@ int xen_set_callback_via(uint64_t via);
 void xen_evtchn_do_upcall(struct pt_regs *regs);
 void xen_hvm_evtchn_do_upcall(void);
 
-/* Allocate an irq for a physical interrupt, given a gsi. */
-int xen_allocate_pirq(unsigned gsi, int shareable, char *name);
-int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name);
+/* Allocate a pirq for a physical interrupt, given a gsi. */
+int xen_allocate_pirq_gsi(unsigned gsi);
+/* Bind a pirq for a physical interrupt to an irq. */
+int xen_bind_pirq_gsi_to_irq(unsigned gsi,
+			     unsigned pirq, int shareable, char *name);
 
 #ifdef CONFIG_PCI_MSI
+/* Allocate a pirq for a MSI style physical interrupt. */
 int xen_allocate_pirq_msi(struct pci_dev *dev, struct msi_desc *msidesc);
+/* Bind an PSI pirq to an irq. */
 int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 			     int pirq, int vector, const char *name);
 #endif
-- 
1.5.6.5

