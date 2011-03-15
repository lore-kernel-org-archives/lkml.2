Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab1COQRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:17:41 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37436 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758153Ab1COQRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:17:39 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.33+drm33.15
Date: Tue, 15 Mar 2011 17:17:37 +0100
Message-Id: <1300205857-8054-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: linux-kernel@vger.kernel.org
To: stable@kernel.org
To: kernel-team@lists.ubuntu.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.33+drm33.15 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release updates the DRM subsystem only.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* drm/radeon: fall back to GTT if bo creation/validation in VRAM fails.
* drm/radeon/kms: Fix retrying ttm_bo_init() after it failed once.
* drm: fix unsigned vs signed comparison issue in modeset ctl ioctl.
* Linux 2.6.32.33+drm33.15

 Makefile                               |    2 +-
 drivers/gpu/drm/drm_irq.c              |    3 ++-
 drivers/gpu/drm/radeon/radeon_object.c |   29 +++++++++++++++++++----------
 include/drm/drmP.h                     |    2 +-
 4 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/Makefile b/Makefile
index 382e455..8415533 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .33+drm33.14
+EXTRAVERSION = .33+drm33.15
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index b98384d..d07dfe1 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -543,7 +543,8 @@ int drm_modeset_ctl(struct drm_device *dev, void *data,
 		    struct drm_file *file_priv)
 {
 	struct drm_modeset_ctl *modeset = data;
-	int crtc, ret = 0;
+	int ret = 0;
+	unsigned int crtc;

 	/* If drm_vblank_init() hasn't been called yet, just no-op */
 	if (!dev->num_crtcs)
diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index f1da370..d856a59 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -101,6 +101,8 @@ int radeon_bo_create(struct radeon_device *rdev, struct drm_gem_object *gobj,
 		type = ttm_bo_type_device;
 	}
 	*bo_ptr = NULL;
+
+retry:
 	bo = kzalloc(sizeof(struct radeon_bo), GFP_KERNEL);
 	if (bo == NULL)
 		return -ENOMEM;
@@ -108,17 +110,21 @@ int radeon_bo_create(struct radeon_device *rdev, struct drm_gem_object *gobj,
 	bo->gobj = gobj;
 	bo->surface_reg = -1;
 	INIT_LIST_HEAD(&bo->list);
-
 	radeon_ttm_placement_from_domain(bo, domain);
 	/* Kernel allocation are uninterruptible */
 	r = ttm_bo_init(&rdev->mman.bdev, &bo->tbo, size, type,
 			&bo->placement, 0, 0, !kernel, NULL, size,
 			&radeon_ttm_bo_destroy);
 	if (unlikely(r != 0)) {
-		if (r != -ERESTARTSYS)
+		if (r != -ERESTARTSYS) {
+			if (domain == RADEON_GEM_DOMAIN_VRAM) {
+				domain |= RADEON_GEM_DOMAIN_GTT;
+				goto retry;
+			}
 			dev_err(rdev->dev,
 				"object_init failed for (%lu, 0x%08X)\n",
 				size, domain);
+		}
 		return r;
 	}
 	*bo_ptr = bo;
@@ -310,6 +316,7 @@ int radeon_bo_list_validate(struct list_head *head)
 {
 	struct radeon_bo_list *lobj;
 	struct radeon_bo *bo;
+	u32 domain;
 	int r;

 	r = radeon_bo_list_reserve(head);
@@ -319,17 +326,19 @@ int radeon_bo_list_validate(struct list_head *head)
 	list_for_each_entry(lobj, head, list) {
 		bo = lobj->bo;
 		if (!bo->pin_count) {
-			if (lobj->wdomain) {
-				radeon_ttm_placement_from_domain(bo,
-								lobj->wdomain);
-			} else {
-				radeon_ttm_placement_from_domain(bo,
-								lobj->rdomain);
-			}
+			domain = lobj->wdomain ? lobj->wdomain : lobj->rdomain;
+
+		retry:
+			radeon_ttm_placement_from_domain(bo, domain);
 			r = ttm_bo_validate(&bo->tbo, &bo->placement,
 						true, false);
-			if (unlikely(r))
+			if (unlikely(r)) {
+				if (r != -ERESTARTSYS && domain == RADEON_GEM_DOMAIN_VRAM) {
+					domain |= RADEON_GEM_DOMAIN_GTT;
+					goto retry;
+				}
 				return r;
+			}
 		}
 		lobj->gpu_offset = radeon_bo_gpu_offset(bo);
 		lobj->tiling_flags = bo->tiling_flags;
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index ffac157..c6c8eb9 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1020,7 +1020,7 @@ struct drm_device {
 	struct pci_controller *hose;
 #endif
 	struct drm_sg_mem *sg;	/**< Scatter gather memory */
-	int num_crtcs;                  /**< Number of CRTCs on this device */
+	unsigned int num_crtcs;                  /**< Number of CRTCs on this device */
 	void *dev_private;		/**< device private data */
 	void *mm_private;
 	struct address_space *dev_mapping;
