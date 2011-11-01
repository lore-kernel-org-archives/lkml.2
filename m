Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab1KATDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:03:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31947 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab1KATCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:02:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, thellstrom@vmware.com, thomas@shipmail.org,
        airlied@redhat.com, jglisse@redhat.com, bskeggs@redhat.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alex Deucher <alexdeucher@gmail.com>
Subject: [PATCH 11/11] radeon/ttm/dma: Enable the TTM DMA pool if the device can only do 32-bit.
Date: Tue,  1 Nov 2011 14:47:32 -0400
Message-Id: <1320173252-2812-12-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
References: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4EB04233.010C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. with the exception that we do not handle the AGP case. We only
deal with PCIe cards such as ATI ES1000 or HD3200 that have been
detected to only do DMA up to 32-bits.

Note: If the ttm.no_dma is set, this operation will not override
the TTM page pool to use the DMA one.

CC: Dave Airlie <airlied@redhat.com>
CC: Alex Deucher <alexdeucher@gmail.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/radeon/radeon_ttm.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 60125dd..2e7419f 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -761,6 +761,10 @@ struct ttm_backend *radeon_ttm_backend_create(struct radeon_device *rdev)
 	gtt->backend.bdev = &rdev->mman.bdev;
 	gtt->backend.flags = 0;
 	gtt->backend.func = &radeon_backend_func;
+	if (rdev->need_dma32) {
+		if (ttm_dma_override(gtt->backend.func))
+			gtt->backend.dev = rdev->dev;
+	}
 	gtt->rdev = rdev;
 	gtt->pages = NULL;
 	gtt->num_pages = 0;
@@ -792,8 +796,8 @@ static int radeon_mm_dump_table(struct seq_file *m, void *data)
 static int radeon_ttm_debugfs_init(struct radeon_device *rdev)
 {
 #if defined(CONFIG_DEBUG_FS)
-	static struct drm_info_list radeon_mem_types_list[RADEON_DEBUGFS_MEM_TYPES+1];
-	static char radeon_mem_types_names[RADEON_DEBUGFS_MEM_TYPES+1][32];
+	static struct drm_info_list radeon_mem_types_list[RADEON_DEBUGFS_MEM_TYPES+2];
+	static char radeon_mem_types_names[RADEON_DEBUGFS_MEM_TYPES+2][32];
 	unsigned i;
 
 	for (i = 0; i < RADEON_DEBUGFS_MEM_TYPES; i++) {
@@ -815,8 +819,15 @@ static int radeon_ttm_debugfs_init(struct radeon_device *rdev)
 	radeon_mem_types_list[i].name = radeon_mem_types_names[i];
 	radeon_mem_types_list[i].show = &ttm_page_alloc_debugfs;
 	radeon_mem_types_list[i].driver_features = 0;
-	radeon_mem_types_list[i].data = NULL;
-	return radeon_debugfs_add_files(rdev, radeon_mem_types_list, RADEON_DEBUGFS_MEM_TYPES+1);
+	radeon_mem_types_list[i++].data = NULL;
+	if (rdev->need_dma32) {
+		sprintf(radeon_mem_types_names[i], "ttm_dma_page_pool");
+		radeon_mem_types_list[i].name = radeon_mem_types_names[i];
+		radeon_mem_types_list[i].show = &ttm_dma_page_alloc_debugfs;
+		radeon_mem_types_list[i].driver_features = 0;
+		radeon_mem_types_list[i++].data = NULL;
+	}
+	return radeon_debugfs_add_files(rdev, radeon_mem_types_list, i);
 
 #endif
 	return 0;
-- 
1.7.6.4

