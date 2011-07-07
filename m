Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab1GGTIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:08:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:43795 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756373Ab1GGTIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:08:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 09/10] xen/pci: Remove 'xen_allocate_pirq_gsi'.
Date: Thu,  7 Jul 2011 15:08:25 -0400
Message-Id: <1310065706-18797-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
References: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090206.4E160438.00E7:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
X-Greylist: IP, sender and recipient auto-whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Thu, 07 Jul 2011 19:08:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the past (2.6.38) the 'xen_allocate_pirq_gsi' would allocate
an entry in a Linux IRQ -> {XEN_IRQ, type, event, ..} array. All
of that has been removed in 2.6.39 and the Xen IRQ subsystem uses
an linked list that is populated when the call to
'xen_allocate_irq_gsi' (universally done from any of the xen_bind_*
calls) is done. The 'xen_allocate_pirq_gsi' is a NOP and there is
no need for it anymore so lets remove it.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c   |   37 ++++++++++++-------------------------
 drivers/xen/events.c |    5 -----
 include/xen/events.h |    2 --
 3 files changed, 12 insertions(+), 32 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 6eddc52..f07c419 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -37,14 +37,8 @@ static int xen_pcifront_enable_irq(struct pci_dev *dev)
 			 rc);
 		return rc;
 	}
-
-	rc = xen_allocate_pirq_gsi(gsi);
-	if (rc < 0) {
-		dev_warn(&dev->dev, "Xen PCI: failed to allocate a PIRQ for GSI%d: %d\n",
-			 gsi, rc);
-		return rc;
-	}
-	pirq = rc;
+	/* In PV DomU the Xen PCI backend puts the PIRQ in the interrupt line.*/
+	pirq = gsi;
 
 	if (gsi < NR_IRQS_LEGACY)
 		share = 0;
@@ -63,18 +57,16 @@ static int xen_pcifront_enable_irq(struct pci_dev *dev)
 
 #ifdef CONFIG_ACPI
 static int xen_register_pirq(u32 gsi, int gsi_override, int triggering,
-			     bool alloc_pirq)
+			     bool set_pirq)
 {
 	int rc, pirq = -1, irq = -1;
 	struct physdev_map_pirq map_irq;
 	int shareable = 0;
 	char *name;
 
-	if (alloc_pirq) {
-		pirq = xen_allocate_pirq_gsi(gsi);
-		if (pirq < 0)
-			goto out;
-	}
+	if (set_pirq)
+		pirq = gsi;
+
 	map_irq.domid = DOMID_SELF;
 	map_irq.type = MAP_PIRQ_TYPE_GSI;
 	map_irq.index = gsi;
@@ -112,8 +104,8 @@ static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
 	if (!xen_hvm_domain())
 		return -1;
 
-	return xen_register_pirq(gsi, -1 /* no GSI override */,
-				 trigger, false /* no PIRQ allocation */);
+	return xen_register_pirq(gsi, -1 /* no GSI override */, trigger,
+				 false /* no mapping of GSI to PIRQ */);
 }
 
 #ifdef CONFIG_XEN_DOM0
@@ -430,7 +422,7 @@ static __init void xen_setup_acpi_sci(void)
 
 int __init pci_xen_initial_domain(void)
 {
-	int pirq, irq;
+	int irq;
 
 #ifdef CONFIG_PCI_MSI
 	x86_msi.setup_msi_irqs = xen_initdom_setup_msi_irqs;
@@ -447,16 +439,11 @@ int __init pci_xen_initial_domain(void)
 
 		xen_register_pirq(irq, -1 /* no GSI override */,
 			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE,
-			true /* allocate IRQ */);
+			true /* Map GSI to PIRQ */);
 	}
 	if (0 == nr_ioapics) {
-		for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
-			pirq = xen_allocate_pirq_gsi(irq);
-			if (WARN(pirq < 0,
-				 "Could not allocate PIRQ for legacy interrupt\n"))
-				break;
-			irq = xen_bind_pirq_gsi_to_irq(irq, pirq, 0, "xt-pic");
-		}
+		for (irq = 0; irq < NR_IRQS_LEGACY; irq++)
+			xen_bind_pirq_gsi_to_irq(irq, irq, 0, "xt-pic");
 	}
 	return 0;
 }
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 23f1b81..da70f5c 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -615,11 +615,6 @@ static int find_irq_by_gsi(unsigned gsi)
 	return -1;
 }
 
-int xen_allocate_pirq_gsi(unsigned gsi)
-{
-	return gsi;
-}
-
 /*
  * Do not make any assumptions regarding the relationship between the
  * IRQ number returned here and the Xen pirq argument.
diff --git a/include/xen/events.h b/include/xen/events.h
index 9af21e1..d287997 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -74,8 +74,6 @@ int xen_set_callback_via(uint64_t via);
 void xen_evtchn_do_upcall(struct pt_regs *regs);
 void xen_hvm_evtchn_do_upcall(void);
 
-/* Allocate a pirq for a physical interrupt, given a gsi. */
-int xen_allocate_pirq_gsi(unsigned gsi);
 /* Bind a pirq for a physical interrupt to an irq. */
 int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 			     unsigned pirq, int shareable, char *name);
-- 
1.7.4.1

