Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab1KATEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:04:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31668 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab1KATCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:02:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, thellstrom@vmware.com, thomas@shipmail.org,
        airlied@redhat.com, jglisse@redhat.com, bskeggs@redhat.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Francisco Jerez <currojerez@riseup.net>
Subject: [PATCH 10/11] nouveau/ttm/dma: Enable the TTM DMA pool if device can only do 32-bit DMA.
Date: Tue,  1 Nov 2011 14:47:31 -0400
Message-Id: <1320173252-2812-11-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
References: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4EB04233.0049,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the card is capable of more than 32-bit, then use the default
TTM page pool code which allocates from anywhere in the memory.

Note: If the 'ttm.no_dma' parameter is set, the override is ignored
and the default TTM pool is used.

CC: Ben Skeggs <bskeggs@redhat.com>
CC: Francisco Jerez <currojerez@riseup.net>
CC: Dave Airlie <airlied@redhat.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/nouveau/nouveau_debugfs.c |    1 +
 drivers/gpu/drm/nouveau/nouveau_sgdma.c   |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_debugfs.c b/drivers/gpu/drm/nouveau/nouveau_debugfs.c
index 8e15923..f52c2db 100644
--- a/drivers/gpu/drm/nouveau/nouveau_debugfs.c
+++ b/drivers/gpu/drm/nouveau/nouveau_debugfs.c
@@ -178,6 +178,7 @@ static struct drm_info_list nouveau_debugfs_list[] = {
 	{ "memory", nouveau_debugfs_memory_info, 0, NULL },
 	{ "vbios.rom", nouveau_debugfs_vbios_image, 0, NULL },
 	{ "ttm_page_pool", ttm_page_alloc_debugfs, 0, NULL },
+	{ "ttm_dma_page_pool", ttm_dma_page_alloc_debugfs, 0, NULL },
 };
 #define NOUVEAU_DEBUGFS_ENTRIES ARRAY_SIZE(nouveau_debugfs_list)
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
index 9b570c3..e0d4474 100644
--- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
@@ -2,6 +2,7 @@
 #include "nouveau_drv.h"
 #include <linux/pagemap.h>
 #include <linux/slab.h>
+#include <ttm/ttm_page_alloc.h>
 
 #define NV_CTXDMA_PAGE_SHIFT 12
 #define NV_CTXDMA_PAGE_SIZE  (1 << NV_CTXDMA_PAGE_SHIFT)
@@ -417,6 +418,10 @@ nouveau_sgdma_init_ttm(struct drm_device *dev)
 	nvbe->dev = dev;
 
 	nvbe->backend.func = dev_priv->gart_info.func;
+	if ((dev->dev) && (dma_get_mask(dev->dev) <= DMA_BIT_MASK(32))) {
+		if (ttm_dma_override(nvbe->backend.func))
+			nvbe->backend.dev = dev->dev;
+	}
 	return &nvbe->backend;
 }
 
-- 
1.7.6.4

