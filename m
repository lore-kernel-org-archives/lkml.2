Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab1JSWUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:20:33 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:57238 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab1JSWUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:20:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        thellstrom@vmware.com, thomas@shipmail.org, airlied@redhat.com
Cc: xen-devel@lists.xensource.com, j.glisse@redhat.com, bskeggs@redhat.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Francisco Jerez <currojerez@riseup.net>
Subject: [PATCH 10/11] nouveau/ttm/dma: Enable the TTM DMA pool if device can only do 32-bit DMA.
Date: Wed, 19 Oct 2011 18:19:31 -0400
Message-Id: <1319062772-2793-11-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319062772-2793-1-git-send-email-konrad.wilk@oracle.com>
References: <1319062772-2793-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020209.4E9F4D09.0088:SCFMA922111,ss=1,re=-4.000,fgs=0
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

