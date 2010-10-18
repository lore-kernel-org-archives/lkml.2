Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab0JRR1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 13:27:25 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50846 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab0JRR1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 13:27:24 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, Olof Johansson <olof@lixom.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Yinghai Lu <yinghai@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] ppc/pasemi: clean up pasemi iommu table initializations
Date: Mon, 18 Oct 2010 10:27:00 -0700
Message-Id: <1287422825-14999-4-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287422825-14999-1-git-send-email-nacc@us.ibm.com>
References: <1287422825-14999-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need for empty helpers with iommu off, the ppc_md hooks are optional.

The direct_dma_ops are the default pci_dma_ops, so no need to set in the
them iommu off case.

No need to set the device tree device_node pci node iommu pointer, its
only used for dlpar remove.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Olof Johansson <olof@lixom.net>
---
 arch/powerpc/platforms/pasemi/iommu.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/platforms/pasemi/iommu.c b/arch/powerpc/platforms/pasemi/iommu.c
index 1f9fb2c..14943ef 100644
--- a/arch/powerpc/platforms/pasemi/iommu.c
+++ b/arch/powerpc/platforms/pasemi/iommu.c
@@ -156,20 +156,12 @@ static void iommu_table_iobmap_setup(void)
 
 static void pci_dma_bus_setup_pasemi(struct pci_bus *bus)
 {
-	struct device_node *dn;
-
 	pr_debug("pci_dma_bus_setup, bus %p, bus->self %p\n", bus, bus->self);
 
 	if (!iommu_table_iobmap_inited) {
 		iommu_table_iobmap_inited = 1;
 		iommu_table_iobmap_setup();
 	}
-
-	dn = pci_bus_to_OF_node(bus);
-
-	if (dn)
-		PCI_DN(dn)->iommu_table = &iommu_table_iobmap;
-
 }
 
 
@@ -192,9 +184,6 @@ static void pci_dma_dev_setup_pasemi(struct pci_dev *dev)
 	set_iommu_table_base(&dev->dev, &iommu_table_iobmap);
 }
 
-static void pci_dma_bus_setup_null(struct pci_bus *b) { }
-static void pci_dma_dev_setup_null(struct pci_dev *d) { }
-
 int __init iob_init(struct device_node *dn)
 {
 	unsigned long tmp;
@@ -251,14 +240,8 @@ void __init iommu_init_early_pasemi(void)
 	iommu_off = of_chosen &&
 			of_get_property(of_chosen, "linux,iommu-off", NULL);
 #endif
-	if (iommu_off) {
-		/* Direct I/O, IOMMU off */
-		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_null;
-		ppc_md.pci_dma_bus_setup = pci_dma_bus_setup_null;
-		set_pci_dma_ops(&dma_direct_ops);
-
+	if (iommu_off)
 		return;
-	}
 
 	iob_init(NULL);
 
-- 
1.7.1

