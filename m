Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1GOQkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:40:19 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55500 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1GOQkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:40:17 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 01/15] gma500: Cursor interface
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 15 Jul 2011 17:31:26 +0100
Message-ID: <20110715163117.28759.14946.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We need to provide an interface to create additional buffers for the cursor

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/gem.c     |   11 +++++++++++
 drivers/staging/gma500/psb_drm.h |   15 +++++++--------
 drivers/staging/gma500/psb_drv.c |    5 +++++
 drivers/staging/gma500/psb_drv.h |    8 +++++---
 4 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/gma500/gem.c b/drivers/staging/gma500/gem.c
index a63ad9e..68ecd5f 100644
--- a/drivers/staging/gma500/gem.c
+++ b/drivers/staging/gma500/gem.c
@@ -250,3 +250,14 @@ fail:
 		return VM_FAULT_SIGBUS;
 	}
 }
+
+/*
+ *	GEM interfaces for our specific client
+ */
+int psb_gem_create_ioctl(struct drm_device *dev, void *data,
+					struct drm_file *file)
+{
+	struct drm_psb_gem_create *args = data;
+	return psb_gem_create(file, dev, args->size, &args->handle);
+}
+
diff --git a/drivers/staging/gma500/psb_drm.h b/drivers/staging/gma500/psb_drm.h
index 5dcf045..7175117 100644
--- a/drivers/staging/gma500/psb_drm.h
+++ b/drivers/staging/gma500/psb_drm.h
@@ -159,18 +159,11 @@ struct drm_psb_register_rw_arg {
  * corresponding defines where they're
  * defined elsewhere.
  */
-#define DRM_PVR_RESERVED1	0x12
-#define DRM_PVR_RESERVED2	0x13
-#define DRM_PVR_RESERVED3	0x14
-#define DRM_PVR_RESERVED4	0x15
-#define DRM_PVR_RESERVED5	0x16
 
+#define DRM_PSB_GEM_CREATE	0x10
 #define DRM_PSB_DPST		0x1B
 #define DRM_PSB_GAMMA		0x1C
 #define DRM_PSB_DPST_BL		0x1D
-
-#define DRM_PVR_RESERVED6	0x1E
-
 #define DRM_PSB_GET_PIPE_FROM_CRTC_ID 0x1F
 
 #define PSB_MODE_OPERATION_MODE_VALID	0x01
@@ -191,4 +184,10 @@ struct psb_drm_dpu_rect {
 	int width, height;    
 };  
 
+struct drm_psb_gem_create {
+	__u64 size;
+	__u32 handle;
+	__u32 pad;
+};
+
 #endif
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index f626480..a753977 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -121,6 +121,9 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 #define DRM_IOCTL_PSB_GET_PIPE_FROM_CRTC_ID	\
 		DRM_IOWR(DRM_PSB_GET_PIPE_FROM_CRTC_ID + DRM_COMMAND_BASE, \
 			 struct drm_psb_get_pipe_from_crtc_id_arg)
+#define DRM_IOCTL_PSB_GEM_CREATE	\
+		DRM_IOWR(DRM_PSB_GEM_CREATE + DRM_COMMAND_BASE, \
+			 struct drm_psb_gem_create)
 
 static int psb_sizes_ioctl(struct drm_device *dev, void *data,
 			   struct drm_file *file_priv);
@@ -159,6 +162,8 @@ static struct drm_ioctl_desc psb_ioctls[] = {
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_DPST_BL, psb_dpst_bl_ioctl, DRM_AUTH),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GET_PIPE_FROM_CRTC_ID,
 					psb_intel_get_pipe_from_crtc_id, 0),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GEM_CREATE, psb_gem_create_ioctl,
+						DRM_UNLOCKED | DRM_AUTH),
 
 };
 
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 50a4f17..12d13ae 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -782,18 +782,20 @@ extern const struct drm_connector_helper_funcs
 					psb_intel_lvds_connector_helper_funcs;
 extern const struct drm_connector_funcs psb_intel_lvds_connector_funcs;
 
-/* psb_gem.c */
+/* gem.c */
 extern int psb_gem_init_object(struct drm_gem_object *obj);
 extern void psb_gem_free_object(struct drm_gem_object *obj);
 extern int psb_gem_get_aperture(struct drm_device *dev, void *data,
-				struct drm_file *file);
+			struct drm_file *file);
 extern int psb_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
 			struct drm_mode_create_dumb *args);
 extern int psb_gem_dumb_destroy(struct drm_file *file, struct drm_device *dev,
 			uint32_t handle);
 extern int psb_gem_dumb_map_gtt(struct drm_file *file, struct drm_device *dev,
-			 uint32_t handle, uint64_t *offset);
+			uint32_t handle, uint64_t *offset);
 extern int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
+extern int psb_gem_create_ioctl(struct drm_device *dev, void *data,
+			struct drm_file *file);
 
 /* psb_device.c */
 extern const struct psb_ops psb_chip_ops;

