Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab1CHPlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:41:24 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:37544 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab1CHPlV (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 8 Mar 2011 10:41:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org,
        Thomas Hellstrom <thomas@shipmail.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] ttm: Pass in 'struct device' to TTM so it can do DMA API on behalf of device.
Date: Tue,  8 Mar 2011 10:39:49 -0500
Message-Id: <1299598789-20402-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299598789-20402-1-git-send-email-konrad.wilk@oracle.com>
References: <1299598789-20402-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D764E0F.00ED,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to pass in the 'struct device' to the TTM layer in a nice way.
This is not strictly required, but it does make accounting of
pages and their DMA addresses correct when using CONFIG_DMA_API_DEBUG=y.

This patch builds on top of "ttm: Include the 'struct dev' when using the DMA API."
and moves the mechanism of passing in 'struct device' to the TTM API.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/nouveau/nouveau_mem.c |    4 ++--
 drivers/gpu/drm/radeon/radeon_ttm.c   |    4 ++--
 drivers/gpu/drm/ttm/ttm_bo.c          |    4 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c   |    4 ++--
 include/drm/ttm/ttm_bo_driver.h       |    5 ++++-
 5 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_mem.c b/drivers/gpu/drm/nouveau/nouveau_mem.c
index 7b57067..3706156 100644
--- a/drivers/gpu/drm/nouveau/nouveau_mem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_mem.c
@@ -409,11 +409,11 @@ nouveau_mem_vram_init(struct drm_device *dev)
 	if (ret)
 		return ret;
 
-	dev_priv->ttm.bdev.dev = dev->dev;
 	ret = ttm_bo_device_init(&dev_priv->ttm.bdev,
 				 dev_priv->ttm.bo_global_ref.ref.object,
 				 &nouveau_bo_driver, DRM_FILE_PAGE_OFFSET,
-				 dma_bits <= 32 ? true : false);
+				 dma_bits <= 32 ? true : false,
+				 dev->dev);
 	if (ret) {
 		NV_ERROR(dev, "Error initialising bo driver: %d\n", ret);
 		return ret;
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index d19bfcf..371890c 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -513,12 +513,12 @@ int radeon_ttm_init(struct radeon_device *rdev)
 	if (r) {
 		return r;
 	}
-	rdev->mman.bdev.dev = rdev->dev;
 	/* No others user of address space so set it to 0 */
 	r = ttm_bo_device_init(&rdev->mman.bdev,
 			       rdev->mman.bo_global_ref.ref.object,
 			       &radeon_bo_driver, DRM_FILE_PAGE_OFFSET,
-			       rdev->need_dma32);
+			       rdev->need_dma32,
+			       rdev->dev);
 	if (r) {
 		DRM_ERROR("failed initializing buffer object driver(%d).\n", r);
 		return r;
diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index af61fc2..278a2d3 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -1526,12 +1526,14 @@ int ttm_bo_device_init(struct ttm_bo_device *bdev,
 		       struct ttm_bo_global *glob,
 		       struct ttm_bo_driver *driver,
 		       uint64_t file_page_offset,
-		       bool need_dma32)
+		       bool need_dma32,
+		       struct device *dev)
 {
 	int ret = -EINVAL;
 
 	rwlock_init(&bdev->vm_lock);
 	bdev->driver = driver;
+	bdev->dev = dev;
 
 	memset(bdev->man, 0, sizeof(bdev->man));
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 4a8c789..803d979 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -322,11 +322,11 @@ static int vmw_driver_load(struct drm_device *dev, unsigned long chipset)
 	ttm_lock_set_kill(&dev_priv->fbdev_master.lock, false, SIGTERM);
 	dev_priv->active_master = &dev_priv->fbdev_master;
 
-	dev_priv->bdev.dev = dev->dev;
 	ret = ttm_bo_device_init(&dev_priv->bdev,
 				 dev_priv->bo_global_ref.ref.object,
 				 &vmw_bo_driver, VMWGFX_FILE_PAGE_OFFSET,
-				 false);
+				 false,
+				 dev->dev);
 	if (unlikely(ret != 0)) {
 		DRM_ERROR("Failed initializing TTM buffer object driver.\n");
 		goto out_err1;
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index 7589c0a..2024a74 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -793,6 +793,8 @@ extern int ttm_bo_device_release(struct ttm_bo_device *bdev);
  * @file_page_offset: Offset into the device address space that is available
  * for buffer data. This ensures compatibility with other users of the
  * address space.
+ * @need_dma32: Allocate pages under 4GB
+ * @dev: 'struct device' of the PCI device.
  *
  * Initializes a struct ttm_bo_device:
  * Returns:
@@ -801,7 +803,8 @@ extern int ttm_bo_device_release(struct ttm_bo_device *bdev);
 extern int ttm_bo_device_init(struct ttm_bo_device *bdev,
 			      struct ttm_bo_global *glob,
 			      struct ttm_bo_driver *driver,
-			      uint64_t file_page_offset, bool need_dma32);
+			      uint64_t file_page_offset, bool need_dma32,
+			      struct device *dev);
 
 /**
  * ttm_bo_unmap_virtual
-- 
1.7.1

