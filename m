Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761965Ab2FHFVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:21:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43233 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761292Ab2FHFHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:21 -0400
Message-Id: <20120608041851.241383792@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 77/82] iommu/amd: Cache pdev pointer to root-bridge
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit c1bf94ec1e12d76838ad485158aecf208ebd8fb9 upstream.

At some point pci_get_bus_and_slot started to enable
interrupts. Since this function is used in the
amd_iommu_resume path it will enable interrupts on resume
which causes a warning. The fix will use a cached pointer
to the root-bridge to re-enable the IOMMU in case the BIOS
is broken.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/amd_iommu_init.c  |   13 +++++--------
 drivers/iommu/amd_iommu_types.h |    3 +++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index c567903..542024b 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1029,6 +1029,9 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	if (!iommu->dev)
 		return 1;
 
+	iommu->root_pdev = pci_get_bus_and_slot(iommu->dev->bus->number,
+						PCI_DEVFN(0, 0));
+
 	iommu->cap_ptr = h->cap_ptr;
 	iommu->pci_seg = h->pci_seg;
 	iommu->mmio_phys = h->mmio_phys;
@@ -1323,20 +1326,16 @@ static void iommu_apply_resume_quirks(struct amd_iommu *iommu)
 {
 	int i, j;
 	u32 ioc_feature_control;
-	struct pci_dev *pdev = NULL;
+	struct pci_dev *pdev = iommu->root_pdev;
 
 	/* RD890 BIOSes may not have completely reconfigured the iommu */
-	if (!is_rd890_iommu(iommu->dev))
+	if (!is_rd890_iommu(iommu->dev) || !pdev)
 		return;
 
 	/*
 	 * First, we need to ensure that the iommu is enabled. This is
 	 * controlled by a register in the northbridge
 	 */
-	pdev = pci_get_bus_and_slot(iommu->dev->bus->number, PCI_DEVFN(0, 0));
-
-	if (!pdev)
-		return;
 
 	/* Select Northbridge indirect register 0x75 and enable writing */
 	pci_write_config_dword(pdev, 0x60, 0x75 | (1 << 7));
@@ -1346,8 +1345,6 @@ static void iommu_apply_resume_quirks(struct amd_iommu *iommu)
 	if (!(ioc_feature_control & 0x1))
 		pci_write_config_dword(pdev, 0x64, ioc_feature_control | 1);
 
-	pci_dev_put(pdev);
-
 	/* Restore the iommu BAR */
 	pci_write_config_dword(iommu->dev, iommu->cap_ptr + 4,
 			       iommu->stored_addr_lo);
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 2452f3b..2435555 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -481,6 +481,9 @@ struct amd_iommu {
 	/* Pointer to PCI device of this IOMMU */
 	struct pci_dev *dev;
 
+	/* Cache pdev to root device for resume quirks */
+	struct pci_dev *root_pdev;
+
 	/* physical address of MMIO space */
 	u64 mmio_phys;
 	/* virtual address of MMIO space */


