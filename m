Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab1EKWZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:25:13 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44605 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab1EKWZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:25:11 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Milton Miller <miltonm@bga.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Schmidt <will_schmidt@vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] pseries/iommu: add additional checks when changing iommu mask
Date: Wed, 11 May 2011 15:24:57 -0700
Message-Id: <1305152704-4864-2-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305152704-4864-1-git-send-email-nacc@us.ibm.com>
References: <1305152704-4864-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milton Miller <miltonm@bga.com>

Do not check dma supported until we have chosen the right dma ops.
Check that the device is pci before treating it as such.

Check the mask is supported by the selected dma ops before
committing it.

We only need to set iommu ops if it is not the current ops; this
avoids searching the tree for the iommu table unnecessarily.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
 arch/powerpc/platforms/pseries/iommu.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 44d47ac..05c101e 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -1026,9 +1026,12 @@ static int dma_set_mask_pSeriesLP(struct device *dev, u64 dma_mask)
 	const void *dma_window = NULL;
 	u64 dma_offset;
 
-	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
+	if (!dev->dma_mask)
 		return -EIO;
 
+	if (!dev_is_pci(dev))
+		goto check_mask;
+
 	pdev = to_pci_dev(dev);
 
 	/* only attempt to use a new window if 64-bit DMA is requested */
@@ -1059,13 +1062,17 @@ static int dma_set_mask_pSeriesLP(struct device *dev, u64 dma_mask)
 		}
 	}
 
-	/* fall-through to iommu ops */
-	if (!ddw_enabled) {
-		dev_info(dev, "Using 32-bit DMA via iommu\n");
+	/* fall back on iommu ops, restore table pointer with ops */
+	if (!ddw_enabled && get_dma_ops(dev) != &dma_iommu_ops) {
+		dev_info(dev, "Restoring 32-bit DMA via iommu\n");
 		set_dma_ops(dev, &dma_iommu_ops);
 		pci_dma_dev_setup_pSeriesLP(pdev);
 	}
 
+check_mask:
+	if (!dma_supported(dev, dma_mask))
+		return -EIO;
+
 	*dev->dma_mask = dma_mask;
 	return 0;
 }
-- 
1.7.4.1

