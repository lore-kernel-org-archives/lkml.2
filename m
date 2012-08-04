Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2HDSJi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 14:09:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab2HDSJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 14:09:29 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 2/2] amd-iommu: Fix ACS path checking
To: joerg.roedel@amd.com, dwmw2@infradead.org
Cc: iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsahern@gmail.com
Date: Sat, 04 Aug 2012 12:09:03 -0600
Message-ID: <20120804180901.6144.28457.stgit@bling.home>
In-Reply-To: <20120804180155.6144.83332.stgit@bling.home>
References: <20120804180155.6144.83332.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SR-IOV can create buses without a bridge.  There may be other cases
where this happens as well.  In these cases skip to the parent bus
and continue testing devices there.
    
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/iommu/amd_iommu.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 6d1cbdf..b64502d 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -296,8 +296,13 @@ static int iommu_init_device(struct device *dev)
 	} else
 		dma_pdev = pci_dev_get(pdev);
 
+	/* Account for quirked devices */
 	swap_pci_ref(&dma_pdev, pci_get_dma_source(dma_pdev));
 
+	/*
+	 * If it's a multifunction device that does not support our
+	 * required ACS flags, add to the same group as function 0.
+	 */
 	if (dma_pdev->multifunction &&
 	    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS))
 		swap_pci_ref(&dma_pdev,
@@ -305,14 +310,28 @@ static int iommu_init_device(struct device *dev)
 					  PCI_DEVFN(PCI_SLOT(dma_pdev->devfn),
 					  0)));
 
+	/*
+	 * Devices on the root bus go through the iommu.  If that's not us,
+	 * find the next upstream device and test ACS up to the root bus.
+	 * Finding the next device may require skipping virtual buses.
+	 */
 	while (!pci_is_root_bus(dma_pdev->bus)) {
-		if (pci_acs_path_enabled(dma_pdev->bus->self,
-					 NULL, REQ_ACS_FLAGS))
+		struct pci_bus *bus = dma_pdev->bus;
+
+		while (!bus->self) {
+			if (!pci_is_root_bus(bus))
+				bus = bus->parent;
+			else
+				goto root_bus;
+		}
+
+		if (pci_acs_path_enabled(bus->self, NULL, REQ_ACS_FLAGS))
 			break;
 
-		swap_pci_ref(&dma_pdev, pci_dev_get(dma_pdev->bus->self));
+		swap_pci_ref(&dma_pdev, pci_dev_get(bus->self));
 	}
 
+root_bus:
 	group = iommu_group_get(&dma_pdev->dev);
 	pci_dev_put(dma_pdev);
 	if (!group) {

