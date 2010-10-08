Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113Ab0JHRdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:33:41 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54517 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758941Ab0JHRdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:33:39 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [RFC PATCH 05/11] ppc: do not search for dma-window property on dlpar remove
Date: Fri,  8 Oct 2010 10:33:06 -0700
Message-Id: <1286559192-10898-6-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
References: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iommu_table pointer in the pci auxiliary struct of device_node has
not been used by the iommu ops since the dma refactor of
12d04eef927bf61328af2c7cbe756c96f98ac3bf, however this code still uses
it to find tables for dlpar. By only setting the PCI_DN iommu_table
pointer on nodes with dma window properties, we will be able to quickly
find the node for later checks, and can remove the table without looking
for the the dma window property on dlpar remove.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
 arch/powerpc/platforms/pseries/iommu.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 9184db3..8ab32da 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -455,9 +455,6 @@ static void pci_dma_bus_setup_pSeriesLP(struct pci_bus *bus)
 		ppci->iommu_table = iommu_init_table(tbl, ppci->phb->node);
 		pr_debug("  created table: %p\n", ppci->iommu_table);
 	}
-
-	if (pdn != dn)
-		PCI_DN(dn)->iommu_table = ppci->iommu_table;
 }
 
 
@@ -571,8 +568,7 @@ static int iommu_reconfig_notifier(struct notifier_block *nb, unsigned long acti
 
 	switch (action) {
 	case PSERIES_RECONFIG_REMOVE:
-		if (pci && pci->iommu_table &&
-		    of_get_property(np, "ibm,dma-window", NULL))
+		if (pci && pci->iommu_table)
 			iommu_free_table(pci->iommu_table, np->full_name);
 		break;
 	default:
-- 
1.7.1

