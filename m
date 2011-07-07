Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab1GGTIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:08:49 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:57822 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab1GGTIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:08:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 05/10] xen/pci: Use the xen_register_pirq for HVM and initial domain users
Date: Thu,  7 Jul 2011 15:08:21 -0400
Message-Id: <1310065706-18797-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
References: <1310065706-18797-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4E160437.0125:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. to cut down on the code duplicity.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c |   75 ++++++++++++++++------------------------------------
 1 files changed, 23 insertions(+), 52 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 6b7d849..55c8cc3 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -62,60 +62,19 @@ static int xen_pcifront_enable_irq(struct pci_dev *dev)
 }
 
 #ifdef CONFIG_ACPI
-static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
-				 int trigger, int polarity)
+static int xen_register_pirq(u32 gsi, int gsi_override, int triggering,
+			     bool alloc_pirq)
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
-	pirq = xen_allocate_pirq_gsi(gsi);
-	if (pirq < 0)
-		goto out;
-
 	map_irq.domid = DOMID_SELF;
 	map_irq.type = MAP_PIRQ_TYPE_GSI;
 	map_irq.index = gsi;
@@ -138,15 +97,26 @@ static int xen_register_pirq(u32 gsi, int gsi_override, int triggering)
 	if (gsi_override >= 0)
 		gsi = gsi_override;
 
-	irq = xen_bind_pirq_gsi_to_irq(gsi, pirq, shareable, name);
+	irq = xen_bind_pirq_gsi_to_irq(gsi, map_irq.pirq, shareable, name);
 	if (irq < 0)
 		goto out;
 
-	printk(KERN_DEBUG "xen: --> pirq=%d -> irq=%d (gsi=%d)\n", pirq, irq, gsi);
+	printk(KERN_DEBUG "xen: --> pirq=%d -> irq=%d (gsi=%d)\n", map_irq.pirq, irq, gsi);
 out:
 	return irq;
 }
 
+static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
+				     int trigger, int polarity)
+{
+	if (!xen_hvm_domain())
+		return -1;
+
+	return xen_register_pirq(gsi, -1 /* no GSI override */,
+				 trigger, false /* no PIRQ allocation */);
+}
+
+#ifdef CONFIG_XEN_DOM0
 static int xen_register_gsi(u32 gsi, int gsi_override, int triggering, int polarity)
 {
 	int rc, irq;
@@ -158,7 +128,7 @@ static int xen_register_gsi(u32 gsi, int gsi_override, int triggering, int polar
 	printk(KERN_DEBUG "xen: registering gsi %u triggering %d polarity %d\n",
 			gsi, triggering, polarity);
 
-	irq = xen_register_pirq(gsi, gsi_override, triggering);
+	irq = xen_register_pirq(gsi, gsi_override, triggering, true);
 
 	setup_gsi.gsi = gsi;
 	setup_gsi.triggering = (triggering == ACPI_EDGE_SENSITIVE ? 0 : 1);
@@ -497,7 +467,8 @@ void __init xen_setup_pirqs(void)
 			continue;
 
 		xen_register_pirq(irq, -1 /* no GSI override */,
-			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE);
+			trigger ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE,
+			true /* allocate IRQ */);
 	}
 #endif
 }
-- 
1.7.4.1

