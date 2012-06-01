Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982Ab2FAOGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:06:05 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:30870
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759950Ab2FAOFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:05:18 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M4XZ4G-02-3IR-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 1/2] iommu/amd: Cache pdev pointer to root-bridge
Date: Fri, 1 Jun 2012 16:05:00 +0200
Message-ID: <1338559501-15478-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At some point pci_get_bus_and_slot started to enable
interrupts. Since this function is used in the
amd_iommu_resume path it will enable interrupts on resume
which causes a warning. The fix will use a cached pointer
to the root-bridge to re-enable the IOMMU in case the BIOS
is broken.

Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
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
-- 
1.7.9.5


