Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1GOQl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:41:29 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35808 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab1GOQl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:41:28 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 03/15] gma500: add an mmap ioctl
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 15 Jul 2011 17:32:38 +0100
Message-ID: <20110715163223.28759.85326.stgit@localhost.localdomain>
In-Reply-To: <20110715163117.28759.14946.stgit@localhost.localdomain>
References: <20110715163117.28759.14946.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This does the same as the dumb mmap but we want them separated in the ABI
in case a future extension to the dumb interface means we can't treat them
the same way.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/gem.c     |    8 ++++++++
 drivers/staging/gma500/psb_drm.h |   12 ++++++++++++
 drivers/staging/gma500/psb_drv.c |    8 +++++++-
 drivers/staging/gma500/psb_drv.h |    2 ++
 4 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/gem.c b/drivers/staging/gma500/gem.c
index 68ecd5f..d7b74b6 100644
--- a/drivers/staging/gma500/gem.c
+++ b/drivers/staging/gma500/gem.c
@@ -261,3 +261,11 @@ int psb_gem_create_ioctl(struct drm_device *dev, void *data,
 	return psb_gem_create(file, dev, args->size, &args->handle);
 }
 
+int psb_gem_mmap_ioctl(struct drm_device *dev, void *data,
+					struct drm_file *file)
+{
+	struct drm_psb_gem_mmap *args = data;
+	return dev->driver->dumb_map_offset(file, dev,
+						args->handle, &args->offset);
+}
+
diff --git a/drivers/staging/gma500/psb_drm.h b/drivers/staging/gma500/psb_drm.h
index eef53f3..70115a9 100644
--- a/drivers/staging/gma500/psb_drm.h
+++ b/drivers/staging/gma500/psb_drm.h
@@ -162,6 +162,7 @@ struct drm_psb_register_rw_arg {
 
 #define DRM_PSB_GEM_CREATE	0x10
 #define DRM_PSB_2D_OP		0x11
+#define DRM_PSB_GEM_MMAP	0x12
 #define DRM_PSB_DPST		0x1B
 #define DRM_PSB_GAMMA		0x1C
 #define DRM_PSB_DPST_BL		0x1D
@@ -203,4 +204,15 @@ struct drm_psb_2d_op {
 	__u32 cmd[PSB_2D_OP_BUFLEN];
 };
 
+struct drm_psb_gem_mmap {
+	__u32 handle;
+	__u32 pad;
+	/**
+	 * Fake offset to use for subsequent mmap call
+	 *
+	 * This is a fixed-size type for 32/64 compatibility.
+	 */
+	__u64 offset;
+};
+
 #endif
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 36bb716..b8b9864 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -127,6 +127,9 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 #define DRM_IOCTL_PSB_2D_OP	\
 		DRM_IOW(DRM_PSB_2D_OP + DRM_COMMAND_BASE, \
 			 struct drm_psb_2d_op)
+#define DRM_IOCTL_PSB_GEM_MMAP	\
+		DRM_IOWR(DRM_PSB_GEM_MMAP + DRM_COMMAND_BASE, \
+			 struct drm_psb_gem_mmap)
 
 static int psb_sizes_ioctl(struct drm_device *dev, void *data,
 			   struct drm_file *file_priv);
@@ -167,7 +170,10 @@ static struct drm_ioctl_desc psb_ioctls[] = {
 					psb_intel_get_pipe_from_crtc_id, 0),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GEM_CREATE, psb_gem_create_ioctl,
 						DRM_UNLOCKED | DRM_AUTH),
-	PSB_IOCTL_DEF(DRM_IOCTL_PSB_2D_OP, psb_accel_ioctl, DRM_UNLOCKED),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_2D_OP, psb_accel_ioctl,
+						DRM_UNLOCKED| DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GEM_MMAP, psb_gem_mmap_ioctl,
+						DRM_UNLOCKED | DRM_AUTH),
 };
 
 static void psb_lastclose(struct drm_device *dev)
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index db3e356..daf3ca5 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -799,6 +799,8 @@ extern int psb_gem_dumb_map_gtt(struct drm_file *file, struct drm_device *dev,
 extern int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern int psb_gem_create_ioctl(struct drm_device *dev, void *data,
 			struct drm_file *file);
+extern int psb_gem_mmap_ioctl(struct drm_device *dev, void *data,
+					struct drm_file *file);
 
 /* psb_device.c */
 extern const struct psb_ops psb_chip_ops;

