Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab0JRR10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 13:27:26 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50847 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511Ab0JRR1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 13:27:24 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] ppc/vio: use dma ops helpers
Date: Mon, 18 Oct 2010 10:26:59 -0700
Message-Id: <1287422825-14999-3-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287422825-14999-1-git-send-email-nacc@us.ibm.com>
References: <1287422825-14999-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the set_dma_ops helper. Instead of modifying vio_dma_mapping_ops,
just create a trivial wrapper for dma_supported.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
 arch/powerpc/kernel/vio.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index d692989..3c3083f 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -602,6 +602,11 @@ static void vio_dma_iommu_unmap_sg(struct device *dev,
 	vio_cmo_dealloc(viodev, alloc_size);
 }
 
+static int vio_dma_iommu_dma_supported(struct device *dev, u64 mask)
+{
+        return dma_iommu_ops.dma_supported(dev, mask);
+}
+
 struct dma_map_ops vio_dma_mapping_ops = {
 	.alloc_coherent = vio_dma_iommu_alloc_coherent,
 	.free_coherent  = vio_dma_iommu_free_coherent,
@@ -609,6 +614,7 @@ struct dma_map_ops vio_dma_mapping_ops = {
 	.unmap_sg       = vio_dma_iommu_unmap_sg,
 	.map_page       = vio_dma_iommu_map_page,
 	.unmap_page     = vio_dma_iommu_unmap_page,
+	.dma_supported  = vio_dma_iommu_dma_supported,
 
 };
 
@@ -860,8 +866,7 @@ static void vio_cmo_bus_remove(struct vio_dev *viodev)
 
 static void vio_cmo_set_dma_ops(struct vio_dev *viodev)
 {
-	vio_dma_mapping_ops.dma_supported = dma_iommu_ops.dma_supported;
-	viodev->dev.archdata.dma_ops = &vio_dma_mapping_ops;
+	set_dma_ops(&viodev->dev, &vio_dma_mapping_ops);
 }
 
 /**
@@ -1246,7 +1251,7 @@ struct vio_dev *vio_register_device_node(struct device_node *of_node)
 	if (firmware_has_feature(FW_FEATURE_CMO))
 		vio_cmo_set_dma_ops(viodev);
 	else
-		viodev->dev.archdata.dma_ops = &dma_iommu_ops;
+		set_dma_ops(&viodev->dev, &dma_iommu_ops);
 	set_iommu_table_base(&viodev->dev, vio_build_iommu_table(viodev));
 	set_dev_node(&viodev->dev, of_node_to_nid(of_node));
 
-- 
1.7.1

