Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236Ab0JHRdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:33:51 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38348 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759114Ab0JHRds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:33:48 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 09/11] ppc/iommu: pass phb only to iommu_table_setparms_lpar
Date: Fri,  8 Oct 2010 10:33:10 -0700
Message-Id: <1286559192-10898-10-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
References: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iommu_table_setparms_lpar needs either the phb or the subbusnumber
(not both), pass the phb to make it similar to iommu_table_setparms.

Note: In cases where a caller was passing bus->number previously to
iommu_table_setparms_lpar() rather than phb->bus->number, this can lead
to a different value in tbl->it_busno. The only example of this was the
removed pci_dma_dev_setup_pSeriesLP(), removed in "ppc/iommu: remove
unneeded pci_dma_dev_setup_pSeriesLP".

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
 arch/powerpc/platforms/pseries/iommu.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index d8bb9be..8ec81df 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -323,14 +323,13 @@ static void iommu_table_setparms(struct pci_controller *phb,
 static void iommu_table_setparms_lpar(struct pci_controller *phb,
 				      struct device_node *dn,
 				      struct iommu_table *tbl,
-				      const void *dma_window,
-				      int bussubno)
+				      const void *dma_window)
 {
 	unsigned long offset, size;
 
-	tbl->it_busno  = bussubno;
 	of_parse_dma_window(dn, dma_window, &tbl->it_index, &offset, &size);
 
+	tbl->it_busno = phb->bus->number;
 	tbl->it_base   = 0;
 	tbl->it_blocksize  = 16;
 	tbl->it_type = TCE_PCI;
@@ -493,8 +492,7 @@ static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
 	if (!pci->iommu_table) {
 		tbl = kzalloc_node(sizeof(struct iommu_table), GFP_KERNEL,
 				   pci->phb->node);
-		iommu_table_setparms_lpar(pci->phb, pdn, tbl, dma_window,
-			pci->phb->bus->number);
+		iommu_table_setparms_lpar(pci->phb, pdn, tbl, dma_window);
 		pci->iommu_table = iommu_init_table(tbl, pci->phb->node);
 		pr_debug("  created table: %p\n", pci->iommu_table);
 	} else {
-- 
1.7.1

