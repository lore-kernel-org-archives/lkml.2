Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab1LOG0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:26:41 -0500
Received: from ozlabs.org ([203.10.76.45]:46747 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250Ab1LOGZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:25:53 -0500
From: David Gibson <david@gibson.dropbear.id.au>
To: alex.williamson@redhat.com
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, joerg.roedel@amd.com,
        dwmw2@infradead.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com, rusty@rustcorp.com.au,
        iommu@lists.linux-foundation.org, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] device_isolation: Support isolation on POWER p5ioc2 bridges
Date: Thu, 15 Dec 2011 17:25:39 +1100
Message-Id: <1323930340-24055-3-git-send-email-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323930340-24055-1-git-send-email-david@gibson.dropbear.id.au>
References: <1323930340-24055-1-git-send-email-david@gibson.dropbear.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to the code for the powernv platform to create
and populate isolation groups on hardware using the p5ioc2 PCI host
bridge used on some IBM POWER systems.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 arch/powerpc/platforms/powernv/pci-p5ioc2.c |   14 +++++++++++++-
 arch/powerpc/platforms/powernv/pci.h        |    3 +++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-p5ioc2.c b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
index 4c80f7c..24847a9 100644
--- a/arch/powerpc/platforms/powernv/pci-p5ioc2.c
+++ b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
@@ -20,6 +20,7 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/msi.h>
+#include <linux/device_isolation.h>
 
 #include <asm/sections.h>
 #include <asm/io.h>
@@ -88,10 +89,21 @@ static void pnv_pci_init_p5ioc2_msis(struct pnv_phb *phb) { }
 static void __devinit pnv_pci_p5ioc2_dma_dev_setup(struct pnv_phb *phb,
 						   struct pci_dev *pdev)
 {
-	if (phb->p5ioc2.iommu_table.it_map == NULL)
+	if (phb->p5ioc2.iommu_table.it_map == NULL) {
 		iommu_init_table(&phb->p5ioc2.iommu_table, phb->hose->node);
+#ifdef CONFIG_DEVICE_ISOLATION
+		phb->p5ioc2.di_group = kzalloc(sizeof(*(phb->p5ioc2.di_group)),
+					       GFP_KERNEL);
+		BUG_ON(!phb->p5ioc2.di_group ||
+		       (device_isolation_group_init(phb->p5ioc2.di_group,
+						    "p5ioc2:%llx", phb->opal_id) < 0));
+#endif
+	}
 
 	set_iommu_table_base(&pdev->dev, &phb->p5ioc2.iommu_table);
+#ifdef CONFIG_DEVICE_ISOLATION
+	device_isolation_dev_add(phb->p5ioc2.di_group, &pdev->dev);
+#endif
 }
 
 static void __init pnv_pci_init_p5ioc2_phb(struct device_node *np,
diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
index 28ae4ca..a2dc071 100644
--- a/arch/powerpc/platforms/powernv/pci.h
+++ b/arch/powerpc/platforms/powernv/pci.h
@@ -77,6 +77,9 @@ struct pnv_phb {
 	union {
 		struct {
 			struct iommu_table iommu_table;
+#ifdef CONFIG_DEVICE_ISOLATION
+			struct device_isolation_group *di_group;
+#endif
 		} p5ioc2;
 
 		struct {
-- 
1.7.7.3

