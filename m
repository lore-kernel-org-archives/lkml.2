Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1FOTVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:21:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63614 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab1FOTUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:20:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        stefano.stabellini@eu.citrix.com, Ian.Campbell@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/8] xen/pci: Use the xen_register_pirq from both HVM and initial domain case
Date: Wed, 15 Jun 2011 15:19:44 -0400
Message-Id: <1308165587-24902-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308165587-24902-1-git-send-email-konrad.wilk@oracle.com>
References: <1308165587-24902-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090206.4DF905E2.000E:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. to cut down on the code duplicity.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |   73 ++++++++++++++-------------------------------------
 1 files changed, 20 insertions(+), 53 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 251480f..7c60a9b 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -62,61 +62,18 @@ static int xen_pcifront_enable_irq(struct pci_dev *dev)
 }
 
 #ifdef CONFIG_ACPI
-static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
-				 int trigger, int polarity)
+static int xen_register_pirq(u32 gsi, int triggering, bool alloc_pirq)
 {
-	int rc, irq;
+	int rc, pirq = -1, irq = -1;
 	struct physdev_map_pirq map_irq;
 	int shareable = 0;
 	char *name;
 
-	if (!xen_hvm_domain())
-		return -1;
-
-	map_irq.domid = DOMID_SELF;
-	map_irq.type = MAP_PIRQ_TYPE_GSI;
-	map_irq.index = gsi;
-	map_irq.pirq = -1;
-
-	rc = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq, &map_irq);
-	if (rc) {
-		printk(KERN_WARNING "xen map irq failed %d\n", rc);
-		return -1;
-	}
-
-	if (trigger == ACPI_EDGE_SENSITIVE) {
-		shareable = 0;
-		name = "ioapic-edge";
-	} else {
-		shareable = 1;
-		name = "ioapic-level";
+	if (alloc_pirq) {
+		pirq = xen_allocate_pirq_gsi(gsi);
+		if (pirq < 0)
+			goto out;
 	}
-
-	irq = xen_bind_pirq_gsi_to_irq(gsi, map_irq.pirq, shareable, name);
-
-	printk(KERN_DEBUG "xen: --> irq=%d, pirq=%d\n", irq, map_irq.pirq);
-
-	return irq;
-}
-#endif
-
-#ifdef CONFIG_XEN_DOM0
-#ifdef CONFIG_ACPI
-static int xen_register_pirq(u32 gsi, int triggering)
-{
-	int rc, pirq, irq = -1;
-	struct physdev_map_pirq map_irq;
-	int shareable = 0;
-	char *name;
-
-	if (!xen_pv_domain())
-		return -1;
-
-
-	pirq = xen_allocate_pirq_gsi(gsi);
-	if (pirq < 0)
-		goto out;
-
 	map_irq.domid = DOMID_SELF;
 	map_irq.type = MAP_PIRQ_TYPE_GSI;
 	map_irq.index = gsi;
@@ -136,16 +93,26 @@ static int xen_register_pirq(u32 gsi, int triggering)
 		name = "ioapic-level";
 	}
 
-	irq = xen_bind_pirq_gsi_to_irq(gsi, pirq, shareable, name);
+	irq = xen_bind_pirq_gsi_to_irq(gsi, map_irq.pirq, shareable, name);
 	if (irq < 0)
 		goto out;
 
-	printk(KERN_DEBUG "xen: --> pirq=%d -> irq=%d\n", pirq, irq);
+	printk(KERN_DEBUG "xen: --> pirq=%d -> irq=%d\n", pirq, map_irq.pirq);
 
 out:
 	return irq;
 }
 
+static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
+				 int trigger, int polarity)
+{
+	if (!xen_hvm_domain())
+		return -1;
+
+	return xen_register_pirq(gsi, trigger, false);
+}
+
+#ifdef CONFIG_XEN_DOM0
 static int xen_register_gsi(u32 gsi, int triggering, int polarity)
 {
 	int rc, irq;
@@ -157,7 +124,7 @@ static int xen_register_gsi(u32 gsi, int triggering, int polarity)
 	printk(KERN_DEBUG "xen: registering gsi %u triggering %d polarity %d\n",
 			gsi, triggering, polarity);
 
-	irq = xen_register_pirq(gsi, triggering);
+	irq = xen_register_pirq(gsi, triggering, true);
 
 	setup_gsi.gsi = gsi;
 	setup_gsi.triggering = (triggering == ACPI_EDGE_SENSITIVE ? 0 : 1);
@@ -476,7 +443,7 @@ void __init xen_setup_pirqs(void)
 			continue;
 
 		xen_register_pirq(irq,
-			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE);
+			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE, true);
 	}
 #endif
 }
-- 
1.7.4.1

