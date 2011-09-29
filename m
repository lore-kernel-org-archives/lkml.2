Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab1I2Ufr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:35:47 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51964 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab1I2Uer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:34:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, thellstrom@vmware.com,
        dri-devel@lists.freedesktop.org, bskeggs@redhat.com,
        j.glisse@redhat.com, thomas@shipmail.org, airlied@redhat.com,
        airlied@linux.ie, alexdeucher@gmail.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 7/9] nouveau/radeon: Set coherent DMA mask
Date: Thu, 29 Sep 2011 16:33:50 -0400
Message-Id: <1317328432-25620-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317328432-25620-1-git-send-email-konrad.wilk@oracle.com>
References: <1317328432-25620-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E84D63D.0051:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the storage devices that use the dmapool set the coherent DMA
mask so they can properly use the dmapool. Since the TTM DMA pool
code is based on that and dma_alloc_coherent checks the
'coherent_dma_mask' and not 'dma_mask' we want to set it.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/nouveau/nouveau_mem.c  |    5 +++++
 drivers/gpu/drm/radeon/radeon_device.c |    6 ++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_mem.c b/drivers/gpu/drm/nouveau/nouveau_mem.c
index a2d7e35..bb6ccbd 100644
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
1.7.4.1

