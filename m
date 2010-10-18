Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab0JRSdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:33:23 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42291 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544Ab0JRSdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:33:22 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] ppc64 iommu: use coherent_dma_mask for alloc_coherent
Date: Mon, 18 Oct 2010 10:27:04 -0700
Message-Id: <1287422825-14999-8-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287422825-14999-1-git-send-email-nacc@us.ibm.com>
References: <1287422825-14999-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IOMMU code has been passing the dma-mask instead of the
coherent_dma_mask to the iommu allocator.  Coherent allocations should
be made using the coherent_dma_mask.

Also update the vio code to ensure the coherent_dma_mask is set. Without
this change drivers, such as ibmvscsi, fail to load with the corrected
dma_iommu_alloc_coherent().

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
We currently don't check the mask other than to warn when its being set,
so I don't think this is stable material.
---
 arch/powerpc/kernel/dma-iommu.c |    2 +-
 arch/powerpc/kernel/vio.c       |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/dma-iommu.c b/arch/powerpc/kernel/dma-iommu.c
index 6e54a0f..e755415 100644
--- a/arch/powerpc/kernel/dma-iommu.c
+++ b/arch/powerpc/kernel/dma-iommu.c
@@ -19,7 +19,7 @@ static void *dma_iommu_alloc_coherent(struct device *dev, size_t size,
 				      dma_addr_t *dma_handle, gfp_t flag)
 {
 	return iommu_alloc_coherent(dev, get_iommu_table_base(dev), size,
-				    dma_handle, device_to_mask(dev), flag,
+				    dma_handle, dev->coherent_dma_mask, flag,
 				    dev_to_node(dev));
 }
 
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 3c3083f..f15b3df 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -1259,6 +1259,10 @@ struct vio_dev *vio_register_device_node(struct device_node *of_node)
 	viodev->dev.parent = &vio_bus_device.dev;
 	viodev->dev.bus = &vio_bus_type;
 	viodev->dev.release = vio_dev_release;
+        /* needed to ensure proper operation of coherent allocations
+         * later, in case driver doesn't set it explicitly */
+        dma_set_mask(&viodev->dev, DMA_BIT_MASK(64));
+        dma_set_coherent_mask(&viodev->dev, DMA_BIT_MASK(64));
 
 	/* register with generic device framework */
 	if (device_register(&viodev->dev)) {
-- 
1.7.1

