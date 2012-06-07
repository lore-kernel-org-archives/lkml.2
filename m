Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab2FGEVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:21:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827Ab2FGEVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:21:17 -0400
Message-Id: <20120607040347.317603430@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:50 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 74/82] iommu/amd: Cache pdev pointer to root-bridge
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu_init.c  |   13 +++++--------
 drivers/iommu/amd_iommu_types.h |    3 +++
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1029,6 +1029,9 @@ static int __init init_iommu_one(struct
 	if (!iommu->dev)
 		return 1;
 
+	iommu->root_pdev = pci_get_bus_and_slot(iommu->dev->bus->number,
+						PCI_DEVFN(0, 0));
+
 	iommu->cap_ptr = h->cap_ptr;
 	iommu->pci_seg = h->pci_seg;
 	iommu->mmio_phys = h->mmio_phys;
@@ -1323,20 +1326,16 @@ static void iommu_apply_resume_quirks(st
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
@@ -1346,8 +1345,6 @@ static void iommu_apply_resume_quirks(st
 	if (!(ioc_feature_control & 0x1))
 		pci_write_config_dword(pdev, 0x64, ioc_feature_control | 1);
 
-	pci_dev_put(pdev);
-
 	/* Restore the iommu BAR */
 	pci_write_config_dword(iommu->dev, iommu->cap_ptr + 4,
 			       iommu->stored_addr_lo);
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


