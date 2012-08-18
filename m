Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab2HRRec (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:34:32 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:39723 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab2HRRe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:34:28 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: dma-iommu: fix IOMMU window check
Date: Sat, 18 Aug 2012 20:34:15 +0300
Message-Id: <1345311255-30657-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking for device mask to cover the whole IOMMU table is too strict.
IOMMU allocators should handle mask constraint properly for each
allocation.

The patch enables to use old AirPort Extreme cards on PowerMacs with
more than 1GB of memory; without the patch the driver init fails with:

  b43-pci-bridge 0001:01:01.0: Warning: IOMMU window too big for device mask
  b43-pci-bridge 0001:01:01.0: mask: 0x3fffffff, table end: 0x80000000
  b43-phy0 ERROR: The machine/kernel does not support the required 30-bit DMA mask

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/powerpc/kernel/dma-iommu.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/dma-iommu.c b/arch/powerpc/kernel/dma-iommu.c
index 2d7bb8c..e489752 100644
--- a/arch/powerpc/kernel/dma-iommu.c
+++ b/arch/powerpc/kernel/dma-iommu.c
@@ -83,11 +83,10 @@ static int dma_iommu_dma_supported(struct device *dev, u64 mask)
 		return 0;
 	}
 
-	if ((tbl->it_offset + tbl->it_size) > (mask >> IOMMU_PAGE_SHIFT)) {
-		dev_info(dev, "Warning: IOMMU window too big for device mask\n");
-		dev_info(dev, "mask: 0x%08llx, table end: 0x%08lx\n",
-				mask, (tbl->it_offset + tbl->it_size) <<
-				IOMMU_PAGE_SHIFT);
+	if (tbl->it_offset > (mask >> IOMMU_PAGE_SHIFT)) {
+		dev_info(dev, "Warning: IOMMU offset too big for device mask\n");
+		dev_info(dev, "mask: 0x%08llx, table offset: 0x%08lx\n",
+				mask, tbl->it_offset << IOMMU_PAGE_SHIFT);
 		return 0;
 	} else
 		return 1;
-- 
1.7.2.5

