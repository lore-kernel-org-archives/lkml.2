Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab1KATCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:02:20 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28357 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab1KATCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:02:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, thellstrom@vmware.com, thomas@shipmail.org,
        airlied@redhat.com, jglisse@redhat.com, bskeggs@redhat.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 02/11] nouveau/radeon: Set coherent DMA mask
Date: Tue,  1 Nov 2011 14:47:23 -0400
Message-Id: <1320173252-2812-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
References: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4EB04231.016C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the storage devices that use the dmapool set the coherent DMA
mask so they can properly use the dmapool. Since the TTM DMA pool
code is based on that and dma_alloc_coherent checks the
'coherent_dma_mask' and not 'dma_mask' we want to set it.

Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/nouveau/nouveau_mem.c  |    5 +++++
 drivers/gpu/drm/radeon/radeon_device.c |    6 ++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_mem.c b/drivers/gpu/drm/nouveau/nouveau_mem.c
index 5ee14d2..8b39520 100644
--- a/drivers/gpu/drm/nouveau/nouveau_mem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_mem.c
@@ -408,6 +408,11 @@ nouveau_mem_vram_init(struct drm_device *dev)
 	if (ret)
 		return ret;
 
+	ret = pci_set_consistent_dma_mask(dev->pdev, DMA_BIT_MASK(dma_bits));
+	if (ret) {
+		/* Reset to default value. */
+		pci_set_consistent_dma_mask(dev->pdev, DMA_BIT_MASK(32));
+	}
 	dev_priv->fb_phys = pci_resource_start(dev->pdev, 1);
 
 	ret = nouveau_ttm_global_init(dev_priv);
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 7cfaa7e..0c0a970 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -757,8 +757,14 @@ int radeon_device_init(struct radeon_device *rdev,
 	r = pci_set_dma_mask(rdev->pdev, DMA_BIT_MASK(dma_bits));
 	if (r) {
 		rdev->need_dma32 = true;
+		dma_bits = 32;
 		printk(KERN_WARNING "radeon: No suitable DMA available.\n");
 	}
+	r = pci_set_consistent_dma_mask(rdev->pdev, DMA_BIT_MASK(dma_bits));
+	if (r) {
+		pci_set_consistent_dma_mask(rdev->pdev, DMA_BIT_MASK(32));
+		printk(KERN_WARNING "radeon: No coherent DMA available.\n");
+	}
 
 	/* Registers mapping */
 	/* TODO: block userspace mapping of io register */
-- 
1.7.6.4

