Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab1HZLsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 07:48:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12181 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab1HZLr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 07:47:59 -0400
X-AuditID: cbfee61b-b7b7fae000005864-be-4e5787ec141e
Date: Fri, 26 Aug 2011 20:47:54 +0900
From: Inki Dae <inki.dae@samsung.com>
Subject: [RFC][PATCH v3] DRM: add DRM Driver for Samsung SoC EXYNOS4210.
To: airlied@linux.ie, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        jy0922.shim@samsung.com, Inki Dae <inki.dae@samsung.com>
Message-id: <1314359274-21585-1-git-send-email-inki.dae@samsung.com>
X-Mailer: git-send-email 1.7.0.4
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 26 Aug 2011 11:48:34.0259 (UTC)
 FILETIME=[15949A30:01CC63E6]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a DRM Driver for Samsung SoC Exynos4210 and now enables only FIMD yet
but we will add HDMI support also in the future.

this patch is based on git repository below:
git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git,
branch name: drm-next
commit-id: bcc65fd8e929a9d9d34d814d6efc1d2793546922

you can refer to our working repository below:
http://git.infradead.org/users/kmpark/linux-2.6-samsung
branch name: samsung-drm

We tried to re-use lowlevel codes of the FIMD driver(s3c-fb.c
based on Linux framebuffer) but couldn't so because lowlevel codes
of s3c-fb.c are included internally and so FIMD module of this driver has
its own lowlevel codes.

We used GEM framework for buffer management and DMA APIs(dma_alloc_*)
for buffer allocation. by using DMA API, we could use CMA later.

Refer to this link for CMA(Continuous Memory Allocator):
http://lkml.org/lkml/2011/7/20/45

this driver supports only physically continuous memory(non-iommu).

Links to previous versions of the patchset:
v1: < https://lwn.net/Articles/454380/ >
v2: < http://www.spinics.net/lists/kernel/msg1224275.html >

Changelog v2:
DRM: add DRM_IOCTL_SAMSUNG_GEM_MMAP ioctl command.

     this feature maps user address space to physical memory region
     once user application requests DRM_IOCTL_SAMSUNG_GEM_MMAP ioctl.

DRM: code clean and add exception codes.

Changelog v3:
DRM: Support multiple irq.

     FIMD and HDMI have their own irq handler but DRM Framework can regiter only one irq handler
     this patch supports mutiple irq for Samsung SoC.

DRM: Consider modularization.

     each DRM, FIMD could be built as a module.

DRM: Have indenpendent crtc object.

     crtc isn't specific to SoC Platform so this patch gets a crtc to be used as common object.
     created crtc could be attached to any encoder object.

DRM: code clean and add exception codes.

Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: SeungWoo Kim <sw0312.kim@samsung.com>
Signed-off-by: kyungmin.park <kyungmin.park@samsung.com>
---
 drivers/gpu/drm/Kconfig                         |    2 +
 drivers/gpu/drm/Makefile                        |    1 +
 drivers/gpu/drm/samsung/Kconfig                 |   18 +
 drivers/gpu/drm/samsung/Makefile                |   11 +
 drivers/gpu/drm/samsung/samsung_drm_buf.c       |  140 ++++++
 drivers/gpu/drm/samsung/samsung_drm_buf.h       |   78 +++
 drivers/gpu/drm/samsung/samsung_drm_connector.c |  260 ++++++++++
 drivers/gpu/drm/samsung/samsung_drm_connector.h |   34 ++
 drivers/gpu/drm/samsung/samsung_drm_core.c      |  212 ++++++++
 drivers/gpu/drm/samsung/samsung_drm_crtc.c      |  334 +++++++++++++
 drivers/gpu/drm/samsung/samsung_drm_crtc.h      |   36 ++
 drivers/gpu/drm/samsung/samsung_drm_drv.c       |  241 +++++++++
 drivers/gpu/drm/samsung/samsung_drm_encoder.c   |  250 +++++++++
 drivers/gpu/drm/samsung/samsung_drm_encoder.h   |   45 ++
 drivers/gpu/drm/samsung/samsung_drm_fb.c        |  248 +++++++++
 drivers/gpu/drm/samsung/samsung_drm_fb.h        |   47 ++
 drivers/gpu/drm/samsung/samsung_drm_fbdev.c     |  409 +++++++++++++++
 drivers/gpu/drm/samsung/samsung_drm_fbdev.h     |   37 ++
 drivers/gpu/drm/samsung/samsung_drm_fimd.c      |  611 +++++++++++++++++++++++
 drivers/gpu/drm/samsung/samsung_drm_gem.c       |  492 ++++++++++++++++++
 drivers/gpu/drm/samsung/samsung_drm_gem.h       |   76 +++
 include/drm/samsung_drm.h                       |  267 ++++++++++
 22 files changed, 3849 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpu/drm/samsung/Kconfig
 create mode 100644 drivers/gpu/drm/samsung/Makefile
 create mode 100644 drivers/gpu/drm/samsung/samsung_drm_buf.c
 create mode 100644 drivers/gpu/drm/samsung/samsung_drm_buf.h
 create mode 100644 drivers/gpu/drm/samsung/samsung_drm_connector.c
 create mode 100644 drivers/gpu/drm/samsung/samsung_drm_connector.h
 create mode 100644 drivers/gpu/drm/samsung/samsung_drm_core.c
 create mode 100644 drivers/gpu/drm/samsung/samsung_drm_crtc.c
 create mode 100644 drivers/gpu/drm/samsung/samsung_drm_crtc.h
 create mode 100644 drivers/gpu/drm/samsung/samsung_drm_drv.c
 create mode 100644 drivers/gpu/drm/samsung/samsung_drm_encoder.c
 create mode 100644 drivers/gpu/drm/samsung/samsung_drm_encoder.h
 create mode 100644 drivers/gpu/drm/samsung/samsung_drm_fb.c
 create mode 100644 drivers/gpu/drm/samsung/samsung_drm_fb.h
 create mode 100644 drivers/gpu/drm/samsung/samsung_drm_fbdev.c
 create mode 100644 drivers/gpu/drm/samsung/samsung_drm_fbdev.h
 create mode 100644 drivers/gpu/drm/samsung/samsung_drm_fimd.c
 create mode 100644 drivers/gpu/drm/samsung/samsung_drm_gem.c
 create mode 100644 drivers/gpu/drm/samsung/samsung_drm_gem.h
 create mode 100644 include/drm/samsung_drm.h

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index b493663..ce6d3ec 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -158,3 +158,5 @@ config DRM_SAVAGE
 	help
 	  Choose this option if you have a Savage3D/4/SuperSavage/Pro/Twister
 	  chipset. If M is selected the module will be called savage.
+
+source "drivers/gpu/drm/samsung/Kconfig"
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 89cf05a..0c6e773 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -35,4 +35,5 @@ obj-$(CONFIG_DRM_SAVAGE)+= savage/
 obj-$(CONFIG_DRM_VMWGFX)+= vmwgfx/
 obj-$(CONFIG_DRM_VIA)	+=via/
 obj-$(CONFIG_DRM_NOUVEAU) +=nouveau/
+obj-$(CONFIG_DRM_SAMSUNG) +=samsung/
 obj-y			+= i2c/
diff --git a/drivers/gpu/drm/samsung/Kconfig b/drivers/gpu/drm/samsung/Kconfig
new file mode 100644
index 0000000..34cedda
--- /dev/null
+++ b/drivers/gpu/drm/samsung/Kconfig
@@ -0,0 +1,18 @@
+config DRM_SAMSUNG
+	tristate "DRM Support for Samsung SoC EXYNOS Series"
+	depends on DRM && PLAT_SAMSUNG
+	select DRM_KMS_HELPER
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
+	help
+	  Choose this option if you have a Samsung SoC EXYNOS chipset.
+	  If M is selected the module will be called samsungdrm.
+
+config DRM_SAMSUNG_FIMD
+	tristate "Samsung DRM FIMD"
+	depends on DRM_SAMSUNG
+	help
+	  Choose this option if you want to use Samsung FIMD for DRM.
+	  If M is selected, the module will be called samsung_drm_fimd
diff --git a/drivers/gpu/drm/samsung/Makefile b/drivers/gpu/drm/samsung/Makefile
new file mode 100644
index 0000000..70f89f3
--- /dev/null
+++ b/drivers/gpu/drm/samsung/Makefile
@@ -0,0 +1,11 @@
+#
+# Makefile for the drm device driver.  This driver provides support for the
+# Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher.
+
+ccflags-y := -Iinclude/drm -Idrivers/gpu/drm/samsung
+samsungdrm-y := samsung_drm_drv.o samsung_drm_encoder.o samsung_drm_connector.o \
+		samsung_drm_crtc.o samsung_drm_fbdev.o samsung_drm_fb.o \
+		samsung_drm_buf.o samsung_drm_gem.o samsung_drm_core.o
+
+obj-$(CONFIG_DRM_SAMSUNG) += samsungdrm.o
+obj-$(CONFIG_DRM_SAMSUNG_FIMD) += samsung_drm_fimd.o
diff --git a/drivers/gpu/drm/samsung/samsung_drm_buf.c b/drivers/gpu/drm/samsung/samsung_drm_buf.c
new file mode 100644
index 0000000..563d07e
--- /dev/null
+++ b/drivers/gpu/drm/samsung/samsung_drm_buf.c
@@ -0,0 +1,140 @@
+/* samsung_drm_buf.c
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Author: Inki Dae <inki.dae@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include "drmP.h"
+#include "drm.h"
+
+#include <drm/samsung_drm.h>
+
+#include "samsung_drm_buf.h"
+
+static DEFINE_MUTEX(samsung_drm_buf_lock);
+
+static int lowlevel_buffer_allocate(struct drm_device *dev,
+		struct samsung_drm_buf_entry *entry)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	entry->vaddr = dma_alloc_writecombine(dev->dev, entry->size,
+			(dma_addr_t *)&entry->paddr, GFP_KERNEL);
+	if (!entry->paddr) {
+		DRM_ERROR("failed to allocate buffer.\n");
+		return -ENOMEM;
+	}
+
+	DRM_DEBUG_KMS("allocated : vaddr(0x%x), paddr(0x%x), size(0x%x)\n",
+			(unsigned int)entry->vaddr, entry->paddr, entry->size);
+
+	return 0;
+}
+
+static void lowlevel_buffer_deallocate(struct drm_device *dev,
+		struct samsung_drm_buf_entry *entry)
+{
+	DRM_DEBUG_KMS("%s.\n", __FILE__);
+
+	dma_free_writecombine(dev->dev, entry->size, entry->vaddr,
+			entry->paddr);
+
+	DRM_DEBUG_KMS("deallocated : vaddr(0x%x), paddr(0x%x), size(0x%x)\n",
+			(unsigned int)entry->vaddr, entry->paddr, entry->size);
+}
+
+static void  samsung_drm_buf_del(struct drm_device *dev,
+		struct samsung_drm_gem_obj *obj)
+{
+	DRM_DEBUG_KMS("%s.\n", __FILE__);
+
+	lowlevel_buffer_deallocate(dev, obj->entry);
+
+	kfree(obj->entry);
+
+	kfree(obj);
+}
+
+struct samsung_drm_gem_obj *samsung_drm_buf_new(struct drm_device *dev,
+		unsigned int size)
+{
+	struct samsung_drm_gem_obj *obj;
+	struct samsung_drm_buf_entry *entry;
+	int ret;
+
+	DRM_DEBUG_KMS("%s.\n", __FILE__);
+	DRM_DEBUG_KMS("desired size = 0x%x\n", size);
+
+	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj) {
+		DRM_ERROR("failed to allocate samsung_drm_gem_obj.\n");
+		return NULL;
+	}
+
+	/* use only one memory plane yet. */
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry) {
+		DRM_ERROR("failed to allocate samsung_drm_buf_entry.\n");
+		return NULL;
+	}
+
+	entry->size = size;
+
+	/* allocate memory region and set it to vaddr and paddr. */
+	ret = lowlevel_buffer_allocate(dev, entry);
+	if (ret < 0)
+		return NULL;
+
+	obj->entry = entry;
+
+	return obj;
+}
+
+struct samsung_drm_gem_obj *samsung_drm_buf_create(struct drm_device *dev,
+		unsigned int size)
+{
+	struct samsung_drm_gem_obj *obj;
+
+	DRM_DEBUG_KMS("%s.\n", __FILE__);
+
+	obj = samsung_drm_buf_new(dev, size);
+	if (!obj)
+		return NULL;
+
+	DRM_DEBUG_KMS("buffer id : 0x%x\n", obj->id);
+
+	return obj;
+}
+
+int samsung_drm_buf_destroy(struct drm_device *dev,
+		struct samsung_drm_gem_obj *in_obj)
+{
+	DRM_DEBUG_KMS("%s.\n", __FILE__);
+
+	samsung_drm_buf_del(dev, in_obj);
+
+	return 0;
+}
+
+MODULE_AUTHOR("Inki Dae <inki.dae@samsung.com>");
+MODULE_DESCRIPTION("Samsung SoC DRM Buffer Management Module");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/samsung/samsung_drm_buf.h b/drivers/gpu/drm/samsung/samsung_drm_buf.h
new file mode 100644
index 0000000..d6a7e95
--- /dev/null
+++ b/drivers/gpu/drm/samsung/samsung_drm_buf.h
@@ -0,0 +1,78 @@
+/* samsung_drm_buf.h
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Author: Inki Dae <inki.dae@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef _SAMSUNG_DRM_BUF_H_
+#define _SAMSUNG_DRM_BUF_H_
+
+/**
+ * samsung drm buffer entry structure.
+ *
+ * @paddr: physical address of allocated memory.
+ * @vaddr: kernel virtual address of allocated memory.
+ * @size: size of allocated memory.
+ */
+struct samsung_drm_buf_entry {
+	unsigned int paddr;
+	void __iomem *vaddr;
+	unsigned int size;
+};
+
+/**
+ * samsung drm buffer structure.
+ *
+ * @entry: pointer to samsung drm buffer entry object.
+ * @flags: it means memory type to be alloated or cache attributes.
+ * @handle: pointer to specific buffer object.
+ * @id: unique id to specific buffer object.
+ *
+ * ps. this object would be transfered to user as kms_bo.handle so
+ *	user can access to memory through kms_bo.handle.
+ */
+struct samsung_drm_gem_obj {
+	struct drm_gem_object base;
+	struct samsung_drm_buf_entry *entry;
+	unsigned int flags;
+
+	unsigned int handle;
+	unsigned int id;
+};
+
+/* create new buffer object and memory region and add the object to list. */
+struct samsung_drm_gem_obj *samsung_drm_buf_new(struct drm_device *dev,
+		unsigned int size);
+
+/* allocate physical memory and add its object to list. */
+struct samsung_drm_gem_obj *samsung_drm_buf_create(struct drm_device *dev,
+		unsigned int size);
+
+/* remove allocated physical memory. */
+int samsung_drm_buf_destroy(struct drm_device *dev,
+		struct samsung_drm_gem_obj *in_obj);
+
+/* find object added to list. */
+struct samsung_drm_gem_obj *samsung_drm_buffer_find(struct drm_device *dev,
+		struct samsung_drm_gem_obj *in_obj, unsigned int paddr);
+
+#endif
diff --git a/drivers/gpu/drm/samsung/samsung_drm_connector.c b/drivers/gpu/drm/samsung/samsung_drm_connector.c
new file mode 100644
index 0000000..987a629
--- /dev/null
+++ b/drivers/gpu/drm/samsung/samsung_drm_connector.c
@@ -0,0 +1,260 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Authors:
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *	SeungWoo Kim <sw0312.kim@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include "drmP.h"
+#include "drm_crtc_helper.h"
+
+#include <drm/samsung_drm.h>
+
+#include "samsung_drm_encoder.h"
+
+#define MAX_EDID 256
+#define to_samsung_connector(x)	container_of(x, struct samsung_drm_connector,\
+				drm_connector)
+
+struct samsung_drm_connector {
+	struct drm_connector	drm_connector;
+	struct drm_encoder	*encoder;
+};
+
+/* convert samsung_video_timings to drm_display_mode */
+static inline void
+convert_to_display_mode(struct fb_videomode *timing,
+			struct drm_display_mode *mode)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	mode->clock = timing->pixclock / 1000;
+
+	mode->hdisplay = timing->xres;
+	mode->hsync_start = mode->hdisplay + timing->left_margin;
+	mode->hsync_end = mode->hsync_start + timing->hsync_len;
+	mode->htotal = mode->hsync_end + timing->right_margin;
+
+	mode->vdisplay = timing->yres;
+	mode->vsync_start = mode->vdisplay + timing->upper_margin;
+	mode->vsync_end = mode->vsync_start + timing->vsync_len;
+	mode->vtotal = mode->vsync_end + timing->lower_margin;
+}
+
+/* convert drm_display_mode to samsung_video_timings */
+static inline void
+convert_to_video_timing(struct drm_display_mode *mode,
+			struct fb_videomode *timing)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	timing->pixclock = mode->clock * 1000;
+
+	timing->xres = mode->hdisplay;
+	timing->left_margin = mode->hsync_start - mode->hdisplay;
+	timing->hsync_len = mode->hsync_end - mode->hsync_start;
+	timing->right_margin = mode->htotal - mode->hsync_end;
+
+	timing->yres = mode->vdisplay;
+	timing->upper_margin = mode->vsync_start - mode->vdisplay;
+	timing->vsync_len = mode->vsync_end - mode->vsync_start;
+	timing->lower_margin = mode->vtotal - mode->vsync_end;
+}
+
+static int samsung_drm_connector_get_modes(struct drm_connector *connector)
+{
+	struct samsung_drm_connector *samsung_connector =
+		to_samsung_connector(connector);
+	struct samsung_drm_display *display =
+		samsung_drm_get_manager(samsung_connector->encoder)->display;
+	unsigned int count;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (display && display->get_edid) {
+		void *edid = kzalloc(MAX_EDID, GFP_KERNEL);
+		if (!edid) {
+			DRM_ERROR("failed to allocate edid\n");
+			return 0;
+		}
+
+		display->get_edid(connector, edid, MAX_EDID);
+
+		drm_mode_connector_update_edid_property(connector, edid);
+		count = drm_add_edid_modes(connector, edid);
+
+		kfree(connector->display_info.raw_edid);
+		connector->display_info.raw_edid = edid;
+	} else {
+		struct drm_display_mode *mode = drm_mode_create(connector->dev);
+		struct fb_videomode *timing;
+
+		if (display && display->get_timing)
+			timing = display->get_timing();
+		else
+			return 0;
+
+		convert_to_display_mode(timing, mode);
+
+		mode->type = DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
+		drm_mode_set_name(mode);
+		drm_mode_probed_add(connector, mode);
+
+		count = 1;
+	}
+
+	return count;
+}
+
+static int samsung_drm_connector_mode_valid(struct drm_connector *connector,
+					    struct drm_display_mode *mode)
+{
+	struct samsung_drm_connector *samsung_connector =
+		to_samsung_connector(connector);
+	struct samsung_drm_display *display =
+		samsung_drm_get_manager(samsung_connector->encoder)->display;
+	struct fb_videomode timing;
+	int ret = MODE_BAD;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	convert_to_video_timing(mode, &timing);
+
+	if (display && display->check_timing)
+		if (!display->check_timing((void *)&timing))
+			ret = MODE_OK;
+
+	return ret;
+}
+
+struct drm_encoder *samsung_drm_best_encoder(struct drm_connector *connector)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+	return to_samsung_connector(connector)->encoder;
+}
+
+static struct drm_connector_helper_funcs samsung_connector_helper_funcs = {
+	.get_modes	= samsung_drm_connector_get_modes,
+	.mode_valid	= samsung_drm_connector_mode_valid,
+	.best_encoder	= samsung_drm_best_encoder,
+};
+
+/* get detection status of display device. */
+static enum drm_connector_status
+samsung_drm_connector_detect(struct drm_connector *connector, bool force)
+{
+	struct samsung_drm_connector *samsung_connector =
+		to_samsung_connector(connector);
+	struct samsung_drm_display *display =
+		samsung_drm_get_manager(samsung_connector->encoder)->display;
+	unsigned int ret = connector_status_unknown;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (display && display->is_connected) {
+		if (display->is_connected())
+			ret = connector_status_connected;
+		else
+			ret = connector_status_disconnected;
+	}
+
+	return ret;
+}
+
+static void samsung_drm_connector_destroy(struct drm_connector *connector)
+{
+	struct samsung_drm_connector *samsung_connector =
+		to_samsung_connector(connector);
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	drm_sysfs_connector_remove(connector);
+	drm_connector_cleanup(connector);
+	connector->dev->mode_config.num_connector--;
+	kfree(samsung_connector);
+}
+
+static struct drm_connector_funcs samsung_connector_funcs = {
+	.dpms		= drm_helper_connector_dpms,
+	.fill_modes	= drm_helper_probe_single_connector_modes,
+	.detect		= samsung_drm_connector_detect,
+	.destroy	= samsung_drm_connector_destroy,
+};
+
+struct drm_connector *samsung_drm_connector_create(struct drm_device *dev,
+						   struct drm_encoder *encoder)
+{
+	struct samsung_drm_connector *samsung_connector;
+	struct samsung_drm_manager *manager = samsung_drm_get_manager(encoder);
+	struct drm_connector *connector;
+	int type;
+	int err;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	samsung_connector = kzalloc(sizeof(*samsung_connector), GFP_KERNEL);
+	if (!samsung_connector) {
+		DRM_ERROR("failed to allocate connector\n");
+		return NULL;
+	}
+
+	samsung_connector->encoder = encoder;
+	connector = &samsung_connector->drm_connector;
+
+	switch (manager->display->type) {
+	case SAMSUNG_DISPLAY_TYPE_HDMI:
+		type = DRM_MODE_CONNECTOR_HDMIA;
+		break;
+	default:
+		type = DRM_MODE_CONNECTOR_Unknown;
+		break;
+	}
+
+	drm_connector_init(dev, connector, &samsung_connector_funcs, type);
+	drm_connector_helper_add(connector, &samsung_connector_helper_funcs);
+
+	err = drm_sysfs_connector_add(connector);
+	if (err)
+		goto err_connector;
+
+	err = drm_mode_connector_attach_encoder(connector, encoder);
+	if (err) {
+		DRM_ERROR("failed to attach a connector to a encoder\n");
+		goto err_sysfs;
+	}
+
+	DRM_DEBUG_KMS("connector has been created\n");
+
+	return connector;
+
+err_sysfs:
+	drm_sysfs_connector_remove(connector);
+err_connector:
+	drm_connector_cleanup(connector);
+	kfree(samsung_connector);
+	return NULL;
+}
+
+MODULE_AUTHOR("Inki Dae <inki.dae@samsung.com>");
+MODULE_DESCRIPTION("Samsung SoC DRM Connector Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/samsung/samsung_drm_connector.h b/drivers/gpu/drm/samsung/samsung_drm_connector.h
new file mode 100644
index 0000000..638d2b3
--- /dev/null
+++ b/drivers/gpu/drm/samsung/samsung_drm_connector.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Authors:
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *	SeungWoo Kim <sw0312.kim@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef _SAMSUNG_DRM_CONNECTOR_H_
+#define _SAMSUNG_DRM_CONNECTOR_H_
+
+struct drm_connector *samsung_drm_connector_create(struct drm_device *dev,
+						   struct drm_encoder *encoder);
+
+#endif
diff --git a/drivers/gpu/drm/samsung/samsung_drm_core.c b/drivers/gpu/drm/samsung/samsung_drm_core.c
new file mode 100644
index 0000000..6221922
--- /dev/null
+++ b/drivers/gpu/drm/samsung/samsung_drm_core.c
@@ -0,0 +1,212 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Author:
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include "drmP.h"
+#include "samsung_drm_encoder.h"
+#include "samsung_drm_connector.h"
+#include "samsung_drm_fbdev.h"
+
+#include <drm/samsung_drm.h>
+
+static DEFINE_MUTEX(samsung_drm_mutex);
+static LIST_HEAD(samsung_drm_subdrv_list);
+static struct drm_device *drm_dev;
+
+static int samsung_drm_subdrv_probe(struct drm_device *dev,
+				    struct samsung_drm_subdrv *subdrv)
+{
+	struct drm_encoder *encoder;
+	struct drm_connector *connector;
+	int ret;
+
+	if (subdrv->probe) {
+		ret = subdrv->probe(dev);
+		if (ret)
+			return ret;
+	}
+
+	/* all crtc is available */
+	encoder = samsung_drm_encoder_create(dev, &subdrv->manager,
+			(1 << MAX_CRTC) - 1);
+	if (!encoder) {
+		DRM_ERROR("failed to create encoder\n");
+		return -EFAULT;
+	}
+
+	connector = samsung_drm_connector_create(dev, encoder);
+	if (!connector) {
+		DRM_ERROR("failed to create connector\n");
+		encoder->funcs->destroy(encoder);
+		return -EFAULT;
+	}
+
+	subdrv->encoder = encoder;
+	subdrv->connector = connector;
+
+	return 0;
+}
+
+static void samsung_drm_subdrv_remove(struct drm_device *dev,
+				      struct samsung_drm_subdrv *subdrv)
+{
+	if (subdrv->remove)
+		subdrv->remove(dev);
+
+	if (subdrv->encoder) {
+		struct drm_encoder *encoder = subdrv->encoder;
+		encoder->funcs->destroy(encoder);
+		subdrv->encoder = NULL;
+	}
+
+	if (subdrv->connector) {
+		struct drm_connector *connector = subdrv->connector;
+		connector->funcs->destroy(connector);
+		subdrv->connector = NULL;
+	}
+}
+
+int samsung_drm_device_register(struct drm_device *dev)
+{
+	struct samsung_drm_subdrv *subdrv, *n;
+	int err;
+
+	if (!dev)
+		return -EINVAL;
+
+	if (drm_dev) {
+		DRM_ERROR("Already drm device were registered\n");
+		return -EBUSY;
+	}
+
+	mutex_lock(&samsung_drm_mutex);
+	list_for_each_entry_safe(subdrv, n, &samsung_drm_subdrv_list, list) {
+		err = samsung_drm_subdrv_probe(dev, subdrv);
+		if (err) {
+			DRM_ERROR("samsung drm subdrv probe failed\n");
+			list_del(&subdrv->list);
+		}
+	}
+
+	drm_dev = dev;
+	mutex_unlock(&samsung_drm_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(samsung_drm_device_register);
+
+void samsung_drm_device_unregister(struct drm_device *dev)
+{
+	struct samsung_drm_subdrv *subdrv;
+
+	if (!dev || dev != drm_dev) {
+		WARN(1, "Unexpected drm device unregister!\n");
+		return;
+	}
+
+	mutex_lock(&samsung_drm_mutex);
+	list_for_each_entry(subdrv, &samsung_drm_subdrv_list, list)
+		samsung_drm_subdrv_remove(dev, subdrv);
+
+	drm_dev = NULL;
+	mutex_unlock(&samsung_drm_mutex);
+}
+EXPORT_SYMBOL_GPL(samsung_drm_device_unregister);
+
+static int samsung_drm_mode_group_reinit(struct drm_device *dev)
+{
+	struct drm_mode_group *group = &dev->primary->mode_group;
+	uint32_t *id_list = group->id_list;
+	int ret;
+
+	ret = drm_mode_group_init_legacy_group(dev, group);
+	if (ret < 0)
+		return ret;
+
+	kfree(id_list);
+	return 0;
+}
+
+int samsung_drm_subdrv_register(struct samsung_drm_subdrv *subdrv)
+{
+	int err;
+
+	if (!subdrv)
+		return -EINVAL;
+
+	mutex_lock(&samsung_drm_mutex);
+	if (drm_dev) {
+		err = samsung_drm_subdrv_probe(drm_dev, subdrv);
+		if (err) {
+			DRM_ERROR("failed to probe samsung drm subdrv\n");
+			mutex_unlock(&samsung_drm_mutex);
+			return err;
+		}
+
+		err = samsung_drm_fbdev_reinit(drm_dev);
+		if (err) {
+			DRM_ERROR("failed to reinitialize samsung drm fbdev\n");
+			samsung_drm_subdrv_remove(drm_dev, subdrv);
+			mutex_unlock(&samsung_drm_mutex);
+			return err;
+		}
+
+		err = samsung_drm_mode_group_reinit(drm_dev);
+		if (err) {
+			DRM_ERROR("failed to reinitialize mode group\n");
+			samsung_drm_fbdev_fini(drm_dev);
+			samsung_drm_subdrv_remove(drm_dev, subdrv);
+			mutex_unlock(&samsung_drm_mutex);
+			return err;
+		}
+	}
+
+	list_add_tail(&subdrv->list, &samsung_drm_subdrv_list);
+	mutex_unlock(&samsung_drm_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(samsung_drm_subdrv_register);
+
+void samsung_drm_subdrv_unregister(struct samsung_drm_subdrv *subdrv)
+{
+	if (!subdrv) {
+		WARN(1, "Unexpected samsung drm subdrv unregister!\n");
+		return;
+	}
+
+	mutex_lock(&samsung_drm_mutex);
+	if (drm_dev) {
+		samsung_drm_subdrv_remove(drm_dev, subdrv);
+
+		/* FIXME: error check */
+		samsung_drm_fbdev_reinit(drm_dev);
+		samsung_drm_mode_group_reinit(drm_dev);
+	}
+
+	list_del(&subdrv->list);
+	mutex_unlock(&samsung_drm_mutex);
+}
+EXPORT_SYMBOL_GPL(samsung_drm_subdrv_unregister);
diff --git a/drivers/gpu/drm/samsung/samsung_drm_crtc.c b/drivers/gpu/drm/samsung/samsung_drm_crtc.c
new file mode 100644
index 0000000..1c5a70a
--- /dev/null
+++ b/drivers/gpu/drm/samsung/samsung_drm_crtc.c
@@ -0,0 +1,334 @@
+/* samsung_drm_crtc.c
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Authors:
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *	SeungWoo Kim <sw0312.kim@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include "drmP.h"
+#include "drm_crtc_helper.h"
+
+#include <drm/samsung_drm.h>
+
+#include "samsung_drm_fb.h"
+#include "samsung_drm_encoder.h"
+
+#define to_samsung_crtc(x)	container_of(x, struct samsung_drm_crtc,\
+				drm_crtc)
+
+/*
+ * @fb_x: horizontal position from framebuffer base
+ * @fb_y: vertical position from framebuffer base
+ * @base_x: horizontal position from screen base
+ * @base_y: vertical position from screen base
+ * @crtc_w: width of crtc
+ * @crtc_h: height of crtc
+ */
+struct samsung_drm_crtc_pos {
+	unsigned int fb_x;
+	unsigned int fb_y;
+	unsigned int base_x;
+	unsigned int base_y;
+	unsigned int crtc_w;
+	unsigned int crtc_h;
+};
+
+struct samsung_drm_crtc {
+	struct drm_crtc			drm_crtc;
+	struct samsung_drm_overlay	overlay;
+	unsigned int			pipe;
+};
+
+static void samsung_drm_overlay_update(struct samsung_drm_overlay *overlay,
+				       struct drm_framebuffer *fb,
+				       struct drm_display_mode *mode,
+				       struct samsung_drm_crtc_pos *pos)
+{
+	struct samsung_drm_buffer_info buffer_info;
+	unsigned int actual_w = pos->crtc_w;
+	unsigned int actual_h = pos->crtc_h;
+	unsigned int hw_w;
+	unsigned int hw_h;
+
+	/* update buffer address of framebuffer. */
+	samsung_drm_fb_update_buf_off(fb, pos->fb_x, pos->fb_y, &buffer_info);
+	overlay->paddr = buffer_info.paddr;
+	overlay->vaddr = buffer_info.vaddr;
+
+	hw_w = mode->hdisplay - pos->base_x;
+	hw_h = mode->vdisplay - pos->base_y;
+
+	if (actual_w > hw_w)
+		actual_w = hw_w;
+	if (actual_h > hw_h)
+		actual_h = hw_h;
+
+	overlay->offset_x = pos->base_x;
+	overlay->offset_y = pos->base_y;
+	overlay->width = actual_w;
+	overlay->height = actual_h;
+
+	DRM_DEBUG_KMS("overlay : offset_x/y(%d,%d), width/height(%d,%d)",
+			overlay->offset_x, overlay->offset_y,
+			overlay->width, overlay->height);
+
+	overlay->buf_offsize = fb->width - actual_w;
+	overlay->line_size = actual_w;
+	overlay->end_buf_off = fb->width * actual_h;
+}
+
+static int samsung_drm_crtc_update(struct drm_crtc *crtc)
+{
+	struct samsung_drm_crtc *samsung_crtc;
+	struct samsung_drm_overlay *overlay;
+	struct samsung_drm_crtc_pos pos;
+	struct drm_display_mode *mode = &crtc->mode;
+	struct drm_framebuffer *fb = crtc->fb;
+
+	if (!mode || !fb)
+		return -EINVAL;
+
+	samsung_crtc = to_samsung_crtc(crtc);
+	overlay = &samsung_crtc->overlay;
+
+	memset(&pos, 0, sizeof(struct samsung_drm_crtc_pos));
+	pos.fb_x = crtc->x;
+	pos.fb_y = crtc->y;
+	pos.crtc_w = fb->width - crtc->x;
+	pos.crtc_h = fb->height - crtc->y;
+
+	samsung_drm_overlay_update(overlay, crtc->fb, mode, &pos);
+
+	return 0;
+}
+
+/* CRTC helper functions */
+static void samsung_drm_crtc_dpms(struct drm_crtc *crtc, int mode)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+	/* TODO */
+}
+
+static void samsung_drm_crtc_prepare(struct drm_crtc *crtc)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+	/* drm framework doesn't check NULL. */
+}
+
+static void samsung_drm_crtc_commit(struct drm_crtc *crtc)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	samsung_drm_fn_encoder(crtc, NULL, samsung_drm_encoder_crtc_commit);
+}
+
+static bool
+samsung_drm_crtc_mode_fixup(struct drm_crtc *crtc,
+			    struct drm_display_mode *mode,
+			    struct drm_display_mode *adjusted_mode)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+	/* drm framework doesn't check NULL */
+	return true;
+}
+
+static int
+samsung_drm_crtc_mode_set(struct drm_crtc *crtc, struct drm_display_mode *mode,
+			  struct drm_display_mode *adjusted_mode, int x, int y,
+			  struct drm_framebuffer *old_fb)
+{
+	struct samsung_drm_crtc *samsung_crtc = to_samsung_crtc(crtc);
+	struct samsung_drm_overlay *overlay = &samsung_crtc->overlay;
+	int ret;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	mode = adjusted_mode;
+
+	ret = samsung_drm_crtc_update(crtc);
+	if (ret)
+		return ret;
+
+	samsung_drm_fn_encoder(crtc, overlay,
+			samsung_drm_encoder_crtc_mode_set);
+
+	return ret;
+}
+
+static int samsung_drm_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
+					  struct drm_framebuffer *old_fb)
+{
+	struct samsung_drm_crtc *samsung_crtc = to_samsung_crtc(crtc);
+	struct samsung_drm_overlay *overlay = &samsung_crtc->overlay;
+	int ret;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	ret = samsung_drm_crtc_update(crtc);
+	if (ret)
+		return ret;
+
+	samsung_drm_fn_encoder(crtc, overlay,
+			samsung_drm_encoder_crtc_mode_set);
+	samsung_drm_fn_encoder(crtc, NULL, samsung_drm_encoder_crtc_commit);
+
+	return ret;
+}
+
+static void samsung_drm_crtc_load_lut(struct drm_crtc *crtc)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+	/* drm framework doesn't check NULL */
+}
+
+static struct drm_crtc_helper_funcs samsung_crtc_helper_funcs = {
+	.dpms		= samsung_drm_crtc_dpms,
+	.prepare	= samsung_drm_crtc_prepare,
+	.commit		= samsung_drm_crtc_commit,
+	.mode_fixup	= samsung_drm_crtc_mode_fixup,
+	.mode_set	= samsung_drm_crtc_mode_set,
+	.mode_set_base	= samsung_drm_crtc_mode_set_base,
+	.load_lut	= samsung_drm_crtc_load_lut,
+};
+
+/* CRTC functions */
+static int samsung_drm_crtc_page_flip(struct drm_crtc *crtc,
+				      struct drm_framebuffer *fb,
+				      struct drm_pending_vblank_event *event)
+{
+	struct drm_device *dev = crtc->dev;
+	struct samsung_drm_private *dev_priv = dev->dev_private;
+	struct samsung_drm_crtc *samsung_crtc = to_samsung_crtc(crtc);
+	struct samsung_drm_overlay *overlay = &samsung_crtc->overlay;
+	struct drm_framebuffer *old_fb = crtc->fb;
+	int ret;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	mutex_lock(&dev->struct_mutex);
+
+	if (event && !dev_priv->pageflip_event) {
+		list_add_tail(&event->base.link,
+				&dev_priv->pageflip_event_list);
+
+		ret = drm_vblank_get(dev, samsung_crtc->pipe);
+		if (ret) {
+			DRM_DEBUG("failed to acquire vblank counter\n");
+			goto out;
+		}
+
+		dev_priv->pageflip_event = true;
+	}
+
+	crtc->fb = fb;
+
+	ret = samsung_drm_crtc_update(crtc);
+	if (ret) {
+		crtc->fb = old_fb;
+		if (event && dev_priv->pageflip_event) {
+			drm_vblank_put(dev, samsung_crtc->pipe);
+			dev_priv->pageflip_event = false;
+		}
+
+		goto out;
+	}
+
+	samsung_drm_fn_encoder(crtc, overlay,
+			samsung_drm_encoder_crtc_mode_set);
+	samsung_drm_fn_encoder(crtc, NULL, samsung_drm_encoder_crtc_commit);
+
+out:
+	mutex_unlock(&dev->struct_mutex);
+	return ret;
+}
+
+static void samsung_drm_crtc_destroy(struct drm_crtc *crtc)
+{
+	struct samsung_drm_crtc *samsung_crtc = to_samsung_crtc(crtc);
+	struct samsung_drm_private *private = crtc->dev->dev_private;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	private->crtc[samsung_crtc->pipe] = NULL;
+
+	drm_crtc_cleanup(crtc);
+	kfree(samsung_crtc);
+}
+
+static struct drm_crtc_funcs samsung_crtc_funcs = {
+	.set_config	= drm_crtc_helper_set_config,
+	.page_flip	= samsung_drm_crtc_page_flip,
+	.destroy	= samsung_drm_crtc_destroy,
+};
+
+int samsung_drm_crtc_create(struct drm_device *dev, unsigned int nr)
+{
+	struct samsung_drm_crtc *samsung_crtc;
+	struct samsung_drm_private *private = dev->dev_private;
+	struct drm_crtc *crtc;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	samsung_crtc = kzalloc(sizeof(*samsung_crtc), GFP_KERNEL);
+	if (!samsung_crtc) {
+		DRM_ERROR("failed to allocate samsung crtc\n");
+		return -ENOMEM;
+	}
+
+	samsung_crtc->pipe = nr;
+	crtc = &samsung_crtc->drm_crtc;
+
+	private->crtc[nr] = crtc;
+
+	drm_crtc_init(dev, crtc, &samsung_crtc_funcs);
+	drm_crtc_helper_add(crtc, &samsung_crtc_helper_funcs);
+
+	return 0;
+}
+
+int samsung_drm_crtc_enable_vblank(struct drm_device *dev, int crtc)
+{
+	struct samsung_drm_private *private = dev->dev_private;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	samsung_drm_fn_encoder(private->crtc[crtc], &crtc,
+			samsung_drm_enable_vblank);
+
+	return 0;
+}
+
+void samsung_drm_crtc_disable_vblank(struct drm_device *dev, int crtc)
+{
+	struct samsung_drm_private *private = dev->dev_private;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	samsung_drm_fn_encoder(private->crtc[crtc], &crtc,
+			samsung_drm_disable_vblank);
+}
+
+MODULE_AUTHOR("Inki Dae <inki.dae@samsung.com>");
+MODULE_DESCRIPTION("Samsung SoC DRM CRTC Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/samsung/samsung_drm_crtc.h b/drivers/gpu/drm/samsung/samsung_drm_crtc.h
new file mode 100644
index 0000000..9256c7e
--- /dev/null
+++ b/drivers/gpu/drm/samsung/samsung_drm_crtc.h
@@ -0,0 +1,36 @@
+/* samsung_drm_crtc.h
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Authors:
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *	SeungWoo Kim <sw0312.kim@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef _SAMSUNG_DRM_CRTC_H_
+#define _SAMSUNG_DRM_CRTC_H_
+
+int samsung_drm_crtc_create(struct drm_device *dev, unsigned int nr);
+int samsung_drm_crtc_enable_vblank(struct drm_device *dev, int crtc);
+void samsung_drm_crtc_disable_vblank(struct drm_device *dev, int crtc);
+
+#endif
diff --git a/drivers/gpu/drm/samsung/samsung_drm_drv.c b/drivers/gpu/drm/samsung/samsung_drm_drv.c
new file mode 100644
index 0000000..eefb08b
--- /dev/null
+++ b/drivers/gpu/drm/samsung/samsung_drm_drv.c
@@ -0,0 +1,241 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Authors:
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *	SeungWoo Kim <sw0312.kim@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include "drmP.h"
+#include "drm.h"
+
+#include <drm/samsung_drm.h>
+
+#include "samsung_drm_crtc.h"
+#include "samsung_drm_fbdev.h"
+#include "samsung_drm_fb.h"
+#include "samsung_drm_gem.h"
+
+#define DRIVER_NAME	"samsung-drm"
+#define DRIVER_DESC	"Samsung SoC DRM"
+#define DRIVER_DATE	"20110530"
+#define DRIVER_MAJOR	1
+#define DRIVER_MINOR	0
+
+static int samsung_drm_load(struct drm_device *dev, unsigned long flags)
+{
+	struct samsung_drm_private *private;
+	int ret;
+	int nr;
+
+	DRM_DEBUG_DRIVER("%s\n", __FILE__);
+
+	private = kzalloc(sizeof(struct samsung_drm_private), GFP_KERNEL);
+	if (!private) {
+		DRM_ERROR("failed to allocate private\n");
+		return -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&private->pageflip_event_list);
+	dev->dev_private = (void *)private;
+
+	drm_mode_config_init(dev);
+
+	samsung_drm_mode_config_init(dev);
+
+	for (nr = 0; nr < MAX_CRTC; nr++) {
+		ret = samsung_drm_crtc_create(dev, nr);
+		if (ret)
+			goto err_crtc;
+	}
+
+	ret = drm_vblank_init(dev, MAX_CRTC);
+	if (ret)
+		goto err_crtc;
+
+	ret = samsung_drm_device_register(dev);
+	if (ret)
+		goto err_vblank;
+
+	ret = samsung_drm_fbdev_init(dev);
+	if (ret) {
+		DRM_ERROR("failed to initialize drm fbdev\n");
+		goto err_drm_device;
+	}
+
+	return 0;
+
+err_drm_device:
+	samsung_drm_device_unregister(dev);
+err_vblank:
+	drm_vblank_cleanup(dev);
+err_crtc:
+	drm_mode_config_cleanup(dev);
+	kfree(private);
+
+	return ret;
+}
+
+static int samsung_drm_unload(struct drm_device *dev)
+{
+	samsung_drm_fbdev_fini(dev);
+	samsung_drm_device_unregister(dev);
+	drm_vblank_cleanup(dev);
+	drm_mode_config_cleanup(dev);
+	kfree(dev->dev_private);
+
+	return 0;
+}
+
+static int samsung_drm_open(struct drm_device *dev, struct drm_file *file_priv)
+{
+	DRM_DEBUG_DRIVER("%s\n", __FILE__);
+
+	return 0;
+}
+
+static void samsung_drm_lastclose(struct drm_device *dev)
+{
+	samsung_drm_fbdev_restore_mode(dev);
+}
+
+static int samsung_drm_master_create(struct drm_device *dev,
+		struct drm_master *master)
+{
+	DRM_DEBUG_DRIVER("%s\n", __FILE__);
+
+	master->driver_priv = NULL;
+
+	return 0;
+}
+
+static int samsung_drm_master_set(struct drm_device *dev,
+				  struct drm_file *file_priv, bool from_open)
+{
+	struct drm_master *master = file_priv->master;
+
+	DRM_DEBUG_DRIVER("%s\n", __FILE__);
+
+	master->lock.hw_lock = kzalloc(sizeof(struct drm_hw_lock), GFP_KERNEL);
+	if (!master->lock.hw_lock) {
+		DRM_DEBUG("failed to allocate hw_lock\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static struct vm_operations_struct samsung_drm_gem_vm_ops = {
+	.fault = samsung_drm_gem_fault,
+	.open = drm_gem_vm_open,
+	.close = drm_gem_vm_close,
+};
+
+static struct drm_ioctl_desc samsung_ioctls[] = {
+	DRM_IOCTL_DEF_DRV(SAMSUNG_GEM_CREATE, samsung_drm_gem_create_ioctl,
+			DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(SAMSUNG_GEM_MAP_OFFSET,
+			samsung_drm_gem_map_offset_ioctl, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(SAMSUNG_GEM_MMAP,
+			samsung_drm_gem_mmap_ioctl, DRM_UNLOCKED),
+};
+
+static struct drm_driver samsung_drm_driver = {
+	.driver_features	= DRIVER_HAVE_IRQ | DRIVER_BUS_PLATFORM |
+				  DRIVER_MODESET | DRIVER_GEM,
+	.load			= samsung_drm_load,
+	.unload			= samsung_drm_unload,
+	.open			= samsung_drm_open,
+	.lastclose		= samsung_drm_lastclose,
+	.get_vblank_counter	= drm_vblank_count,
+	.enable_vblank		= samsung_drm_crtc_enable_vblank,
+	.disable_vblank		= samsung_drm_crtc_disable_vblank,
+	.master_create		= samsung_drm_master_create,
+	.master_set		= samsung_drm_master_set,
+	.gem_init_object	= samsung_drm_gem_init_object,
+	.gem_free_object	= samsung_drm_gem_free_object,
+	.gem_vm_ops		= &samsung_drm_gem_vm_ops,
+	.dumb_create		= samsung_drm_gem_dumb_create,
+	.dumb_map_offset	= samsung_drm_gem_dumb_map_offset,
+	.dumb_destroy		= samsung_drm_gem_dumb_destroy,
+	.ioctls			= samsung_ioctls,
+	.fops = {
+		.owner		= THIS_MODULE,
+		.open		= drm_open,
+		.mmap		= samsung_drm_gem_mmap,
+		.poll		= drm_poll,
+		.read		= drm_read,
+		.unlocked_ioctl	= drm_ioctl,
+		.release	= drm_release,
+	},
+	.name	= DRIVER_NAME,
+	.desc	= DRIVER_DESC,
+	.date	= DRIVER_DATE,
+	.major	= DRIVER_MAJOR,
+	.minor	= DRIVER_MINOR,
+};
+
+static int samsung_drm_platform_probe(struct platform_device *pdev)
+{
+	DRM_DEBUG_DRIVER("%s\n", __FILE__);
+
+	samsung_drm_driver.num_ioctls = DRM_ARRAY_SIZE(samsung_ioctls);
+
+	return drm_platform_init(&samsung_drm_driver, pdev);
+}
+
+static int samsung_drm_platform_remove(struct platform_device *pdev)
+{
+	DRM_DEBUG_DRIVER("%s\n", __FILE__);
+
+	drm_platform_exit(&samsung_drm_driver, pdev);
+
+	return 0;
+}
+
+static struct platform_driver samsung_drm_platform_driver = {
+	.probe		= samsung_drm_platform_probe,
+	.remove		= __devexit_p(samsung_drm_platform_remove),
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= DRIVER_NAME,
+	},
+};
+
+static int __init samsung_drm_init(void)
+{
+	DRM_DEBUG_DRIVER("%s\n", __FILE__);
+
+	return platform_driver_register(&samsung_drm_platform_driver);
+}
+
+static void __exit samsung_drm_exit(void)
+{
+	platform_driver_unregister(&samsung_drm_platform_driver);
+}
+
+module_init(samsung_drm_init);
+module_exit(samsung_drm_exit);
+
+MODULE_AUTHOR("Inki Dae <inki.dae@samsung.com>");
+MODULE_DESCRIPTION("Samsung SoC DRM Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/samsung/samsung_drm_encoder.c b/drivers/gpu/drm/samsung/samsung_drm_encoder.c
new file mode 100644
index 0000000..d1cb04e
--- /dev/null
+++ b/drivers/gpu/drm/samsung/samsung_drm_encoder.c
@@ -0,0 +1,250 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Authors:
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *	SeungWoo Kim <sw0312.kim@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include "drmP.h"
+#include "drm_crtc_helper.h"
+
+#include <drm/samsung_drm.h>
+
+#include "samsung_drm_encoder.h"
+
+#define to_samsung_encoder(x)	container_of(x, struct samsung_drm_encoder,\
+				drm_encoder)
+
+struct samsung_drm_encoder {
+	struct drm_encoder		drm_encoder;
+	struct samsung_drm_manager	*manager;
+};
+
+static void samsung_drm_encoder_dpms(struct drm_encoder *encoder, int mode)
+{
+	struct drm_device *dev = encoder->dev;
+	struct drm_connector *connector;
+	struct samsung_drm_manager *manager = samsung_drm_get_manager(encoder);
+
+	DRM_DEBUG_KMS("%s, encoder dpms: %d\n", __FILE__, mode);
+
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		if (connector->encoder == encoder) {
+			struct samsung_drm_display *display = manager->display;
+
+			if (display && display->power_on)
+				display->power_on(mode);
+		}
+	}
+}
+
+static bool
+samsung_drm_encoder_mode_fixup(struct drm_encoder *encoder,
+			       struct drm_display_mode *mode,
+			       struct drm_display_mode *adjusted_mode)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	return true;
+}
+
+static void samsung_drm_encoder_mode_set(struct drm_encoder *encoder,
+					 struct drm_display_mode *mode,
+					 struct drm_display_mode *adjusted_mode)
+{
+	struct drm_device *dev = encoder->dev;
+	struct drm_connector *connector;
+	struct samsung_drm_manager *manager = samsung_drm_get_manager(encoder);
+	struct samsung_drm_manager_ops *manager_ops = manager->ops;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	mode = adjusted_mode;
+
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		if (connector->encoder == encoder)
+			if (manager_ops && manager_ops->mode_set)
+				manager_ops->mode_set(manager->dev, mode);
+	}
+}
+
+static void samsung_drm_encoder_prepare(struct drm_encoder *encoder)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+}
+
+static void samsung_drm_encoder_commit(struct drm_encoder *encoder)
+{
+	struct samsung_drm_manager *manager = samsung_drm_get_manager(encoder);
+	struct samsung_drm_manager_ops *manager_ops = manager->ops;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (manager_ops && manager_ops->commit)
+		manager_ops->commit(manager->dev);
+}
+
+static struct drm_crtc *
+samsung_drm_encoder_get_crtc(struct drm_encoder *encoder)
+{
+	return encoder->crtc;
+}
+
+static struct drm_encoder_helper_funcs samsung_encoder_helper_funcs = {
+	.dpms		= samsung_drm_encoder_dpms,
+	.mode_fixup	= samsung_drm_encoder_mode_fixup,
+	.mode_set	= samsung_drm_encoder_mode_set,
+	.prepare	= samsung_drm_encoder_prepare,
+	.commit		= samsung_drm_encoder_commit,
+	.get_crtc	= samsung_drm_encoder_get_crtc,
+};
+
+static void samsung_drm_encoder_destroy(struct drm_encoder *encoder)
+{
+	struct samsung_drm_encoder *samsung_encoder =
+		to_samsung_encoder(encoder);
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	samsung_encoder->manager->pipe = -1;
+
+	drm_encoder_cleanup(encoder);
+	encoder->dev->mode_config.num_encoder--;
+	kfree(samsung_encoder);
+}
+
+static struct drm_encoder_funcs samsung_encoder_funcs = {
+	.destroy = samsung_drm_encoder_destroy,
+};
+
+struct drm_encoder *
+samsung_drm_encoder_create(struct drm_device *dev,
+			   struct samsung_drm_manager *manager,
+			   unsigned int possible_crtcs)
+{
+	struct drm_encoder *encoder;
+	struct samsung_drm_encoder *samsung_encoder;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (!manager || !possible_crtcs)
+		return NULL;
+
+	if (!manager->dev)
+		return NULL;
+
+	samsung_encoder = kzalloc(sizeof(*samsung_encoder), GFP_KERNEL);
+	if (!samsung_encoder) {
+		DRM_ERROR("failed to allocate encoder\n");
+		return NULL;
+	}
+
+	samsung_encoder->manager = manager;
+	encoder = &samsung_encoder->drm_encoder;
+	encoder->possible_crtcs = possible_crtcs;
+
+	DRM_DEBUG_KMS("possible_crtcs = 0x%x\n", encoder->possible_crtcs);
+
+	drm_encoder_init(dev, encoder, &samsung_encoder_funcs,
+			DRM_MODE_ENCODER_TMDS);
+
+	drm_encoder_helper_add(encoder, &samsung_encoder_helper_funcs);
+
+	DRM_DEBUG_KMS("encoder has been created\n");
+
+	return encoder;
+}
+
+struct samsung_drm_manager *samsung_drm_get_manager(struct drm_encoder *encoder)
+{
+	return to_samsung_encoder(encoder)->manager;
+}
+
+void samsung_drm_fn_encoder(struct drm_crtc *crtc, void *data,
+			    void (*fn)(struct drm_encoder *, void *))
+{
+	struct drm_device *dev = crtc->dev;
+	struct drm_encoder *encoder;
+
+	list_for_each_entry(encoder, &dev->mode_config.encoder_list, head) {
+		if (encoder->crtc != crtc)
+			continue;
+
+		fn(encoder, data);
+	}
+}
+
+void samsung_drm_enable_vblank(struct drm_encoder *encoder, void *data)
+{
+	struct samsung_drm_manager *manager =
+		to_samsung_encoder(encoder)->manager;
+	struct samsung_drm_manager_ops *manager_ops = manager->ops;
+	int crtc = *(int *)data;
+
+	if (manager->pipe == -1)
+		manager->pipe = crtc;
+
+	/* old_crtc checking needs? FIXME!!! */
+
+	if (manager_ops->enable_vblank)
+		manager_ops->enable_vblank(manager->dev);
+}
+
+void samsung_drm_disable_vblank(struct drm_encoder *encoder, void *data)
+{
+	struct samsung_drm_manager *manager =
+		to_samsung_encoder(encoder)->manager;
+	struct samsung_drm_manager_ops *manager_ops = manager->ops;
+	int crtc = *(int *)data;
+
+	if (manager->pipe == -1)
+		manager->pipe = crtc;
+
+	/* old_crtc checking needs? FIXME!!! */
+
+	if (manager_ops->disable_vblank)
+		manager_ops->disable_vblank(manager->dev);
+}
+
+void samsung_drm_encoder_crtc_commit(struct drm_encoder *encoder, void *data)
+{
+	struct samsung_drm_manager *manager =
+		to_samsung_encoder(encoder)->manager;
+	struct samsung_drm_overlay_ops *overlay_ops = manager->overlay_ops;
+
+	overlay_ops->commit(manager->dev);
+}
+
+void samsung_drm_encoder_crtc_mode_set(struct drm_encoder *encoder, void *data)
+{
+	struct samsung_drm_manager *manager =
+		to_samsung_encoder(encoder)->manager;
+	struct samsung_drm_overlay_ops *overlay_ops = manager->overlay_ops;
+	struct samsung_drm_overlay *overlay = data;
+
+	overlay_ops->mode_set(manager->dev, overlay);
+}
+
+MODULE_AUTHOR("Inki Dae <inki.dae@samsung.com>");
+MODULE_DESCRIPTION("Samsung SoC DRM Encoder Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/samsung/samsung_drm_encoder.h b/drivers/gpu/drm/samsung/samsung_drm_encoder.h
new file mode 100644
index 0000000..99040b2
--- /dev/null
+++ b/drivers/gpu/drm/samsung/samsung_drm_encoder.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Authors:
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *	SeungWoo Kim <sw0312.kim@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef _SAMSUNG_DRM_ENCODER_H_
+#define _SAMSUNG_DRM_ENCODER_H_
+
+struct samsung_drm_manager;
+
+struct drm_encoder *samsung_drm_encoder_create(struct drm_device *dev,
+					       struct samsung_drm_manager *mgr,
+					       unsigned int possible_crtcs);
+struct samsung_drm_manager *
+samsung_drm_get_manager(struct drm_encoder *encoder);
+void samsung_drm_fn_encoder(struct drm_crtc *crtc, void *data,
+			    void (*fn)(struct drm_encoder *, void *));
+void samsung_drm_enable_vblank(struct drm_encoder *encoder, void *data);
+void samsung_drm_disable_vblank(struct drm_encoder *encoder, void *data);
+void samsung_drm_encoder_crtc_commit(struct drm_encoder *encoder, void *data);
+void samsung_drm_encoder_crtc_mode_set(struct drm_encoder *encoder, void *data);
+
+#endif
diff --git a/drivers/gpu/drm/samsung/samsung_drm_fb.c b/drivers/gpu/drm/samsung/samsung_drm_fb.c
new file mode 100644
index 0000000..42096eb
--- /dev/null
+++ b/drivers/gpu/drm/samsung/samsung_drm_fb.c
@@ -0,0 +1,248 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Authors:
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *	SeungWoo Kim <sw0312.kim@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include "drmP.h"
+#include "drm_crtc.h"
+#include "drm_crtc_helper.h"
+
+#include "samsung_drm_fb.h"
+#include "samsung_drm_buf.h"
+#include "samsung_drm_gem.h"
+
+#define to_samsung_fb(x)	container_of(x, struct samsung_drm_fb, fb)
+
+struct samsung_drm_fb {
+	struct drm_framebuffer		fb;
+	struct drm_file			*file_priv;
+	struct samsung_drm_gem_obj	*samsung_gem_obj;
+	unsigned int			is_default;
+
+	/* samsung gem object handle. */
+	unsigned int			gem_handle;
+	/* unique id to buffer object. */
+	unsigned int			id;
+
+	unsigned int			fb_size;
+	unsigned long			paddr;
+	void __iomem			*vaddr;
+};
+
+static void samsung_drm_fb_destroy(struct drm_framebuffer *fb)
+{
+	struct samsung_drm_fb *samsung_fb = to_samsung_fb(fb);
+	int ret;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	drm_framebuffer_cleanup(fb);
+
+	if (samsung_fb->is_default) {
+		ret = drm_gem_handle_delete(samsung_fb->file_priv,
+				samsung_fb->gem_handle);
+		if (ret < 0)
+			DRM_ERROR("failed to delete drm_gem_handle.\n");
+	}
+
+	kfree(samsung_fb);
+}
+
+static int samsung_drm_fb_create_handle(struct drm_framebuffer *fb,
+					struct drm_file *file_priv,
+					unsigned int *handle)
+{
+	struct samsung_drm_fb *samsung_fb = to_samsung_fb(fb);
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (!samsung_fb->gem_handle) {
+		DRM_ERROR("can't get id to buffer object.\n");
+		return -EINVAL;
+	}
+
+	*handle = samsung_fb->gem_handle;
+
+	DRM_DEBUG_KMS("got buffer object id(%d)\n", *handle);
+
+	return 0;
+}
+
+static int samsung_drm_fb_dirty(struct drm_framebuffer *fb,
+				struct drm_file *file_priv, unsigned flags,
+				unsigned color, struct drm_clip_rect *clips,
+				unsigned num_clips)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	/*
+	 * update framebuffer and its hardware.
+	 * - this callback would be called by user application
+	 *	with DRM_IOCTL_MODE_DIRTYFB command.
+	 *
+	 * ps. Userspace can notify the driver via this callback
+	 * that an area of the framebuffer has been changed then should
+	 * be flushed to the display hardware.
+	 */
+
+	return 0;
+}
+
+static struct drm_framebuffer_funcs samsung_drm_fb_funcs = {
+	.destroy	= samsung_drm_fb_destroy,
+	.create_handle	= samsung_drm_fb_create_handle,
+	.dirty		= samsung_drm_fb_dirty,
+};
+
+static struct drm_framebuffer *
+samsung_drm_fb_init(struct drm_file *file_priv, struct drm_device *dev,
+		    struct drm_mode_fb_cmd *mode_cmd)
+{
+	struct samsung_drm_fb *samsung_fb;
+	struct drm_framebuffer *fb;
+	struct samsung_drm_gem_obj *samsung_gem_obj;
+	unsigned int size, gem_handle = 0;
+	int ret;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	mode_cmd->pitch = max(mode_cmd->pitch,
+			mode_cmd->width * (mode_cmd->bpp >> 3));
+
+	DRM_LOG_KMS("drm fb create(%dx%d)\n",
+			mode_cmd->width, mode_cmd->height);
+
+	samsung_fb = kzalloc(sizeof(*samsung_fb), GFP_KERNEL);
+	if (!samsung_fb) {
+		DRM_ERROR("failed to allocate samsung drm framebuffer.\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	fb = &samsung_fb->fb;
+	ret = drm_framebuffer_init(dev, fb, &samsung_drm_fb_funcs);
+	if (ret) {
+		DRM_ERROR("failed to initialize framebuffer.\n");
+		goto fail;
+	}
+
+	DRM_LOG_KMS("create: fb id: %d\n", fb->base.id);
+
+	size = mode_cmd->pitch * mode_cmd->height;
+
+	/*
+	 * mode_cmd->handle could be pointer to a buffer allocated by user
+	 * application using KMS library.
+	 */
+	if (!mode_cmd->handle) {
+		samsung_gem_obj = samsung_drm_buf_create(dev, size);
+		if (!samsung_gem_obj)
+			return ERR_PTR(-ENOMEM);
+	} else {
+		samsung_gem_obj = find_samsung_drm_gem_object(file_priv, dev,
+				mode_cmd->handle);
+		if (!samsung_gem_obj)
+			return ERR_PTR(-EINVAL);
+
+		gem_handle = mode_cmd->handle;
+	}
+
+	/* first is default framebuffer */
+	if (dev->mode_config.num_fb == 1)
+		samsung_fb->is_default = 1;
+
+	samsung_fb->file_priv = file_priv;
+	samsung_fb->samsung_gem_obj = samsung_gem_obj;
+	samsung_fb->gem_handle = gem_handle;
+	samsung_fb->id = samsung_gem_obj->id;
+	samsung_fb->fb_size = size;
+	samsung_fb->vaddr = samsung_gem_obj->entry->vaddr;
+	samsung_fb->paddr = samsung_gem_obj->entry->paddr;
+
+	DRM_DEBUG_KMS("handle = 0x%x, id = %d\n",
+			samsung_gem_obj->handle, samsung_gem_obj->id);
+	DRM_DEBUG_KMS("fb: size = 0x%x, vaddr = 0x%x, paddr = 0x%x\n",
+			samsung_fb->fb_size, (unsigned int)samsung_fb->vaddr,
+			(unsigned int)samsung_fb->paddr);
+
+	drm_helper_mode_fill_fb_struct(fb, mode_cmd);
+
+	return fb;
+
+fail:
+	kfree(samsung_fb);
+
+	return ERR_PTR(ret);
+}
+
+struct drm_framebuffer *samsung_drm_fb_create(struct drm_device *dev,
+					      struct drm_file *file_priv,
+					      struct drm_mode_fb_cmd *mode_cmd)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	return samsung_drm_fb_init(file_priv, dev, mode_cmd);
+}
+
+void samsung_drm_fb_update_buf_off(struct drm_framebuffer *fb,
+				   unsigned int x, unsigned int y,
+				   struct samsung_drm_buffer_info *info)
+{
+	struct samsung_drm_fb *samsung_fb = to_samsung_fb(fb);
+	unsigned long offset;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	offset = x * (fb->bits_per_pixel >> 3);
+	offset += y * fb->pitch;
+
+	info->base_addr = samsung_fb->paddr;
+	info->vaddr = samsung_fb->vaddr + offset;
+	info->paddr = samsung_fb->paddr + offset;
+
+	DRM_DEBUG_KMS("updated vaddr = 0x%x, paddr = 0x%x, offset = 0x%x\n",
+			(unsigned int)info->vaddr,
+			(unsigned int)info->paddr,
+			(unsigned int)offset);
+}
+
+static struct drm_mode_config_funcs samsung_drm_mode_config_funcs = {
+	.fb_create = samsung_drm_fb_create,
+};
+
+void samsung_drm_mode_config_init(struct drm_device *dev)
+{
+	dev->mode_config.min_width = 0;
+	dev->mode_config.min_height = 0;
+
+	/*
+	 * It sets max width and height as default value(4096x4096).
+	 * this value would be used to check for framebuffer size limitation
+	 * at drm_mode_addfb().
+	 */
+	dev->mode_config.max_width = 4096;
+	dev->mode_config.max_height = 4096;
+
+	dev->mode_config.funcs = &samsung_drm_mode_config_funcs;
+}
diff --git a/drivers/gpu/drm/samsung/samsung_drm_fb.h b/drivers/gpu/drm/samsung/samsung_drm_fb.h
new file mode 100644
index 0000000..5c54521
--- /dev/null
+++ b/drivers/gpu/drm/samsung/samsung_drm_fb.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Authors:
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *	SeungWoo Kim <sw0312.kim@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef _SAMSUNG_DRM_FB_H_
+#define _SAMSUNG_DRM_FB_H
+
+struct samsung_drm_buffer_info {
+	unsigned long base_addr;
+	unsigned long paddr;
+	void __iomem *vaddr;
+};
+
+void samsung_drm_fb_update_buf_off(struct drm_framebuffer *fb,
+				   unsigned int x, unsigned int y,
+				   struct samsung_drm_buffer_info *info);
+
+struct drm_framebuffer *samsung_drm_fb_create(struct drm_device *dev,
+					      struct drm_file *file_priv,
+					      struct drm_mode_fb_cmd *mode_cmd);
+
+void samsung_drm_mode_config_init(struct drm_device *dev);
+
+#endif
diff --git a/drivers/gpu/drm/samsung/samsung_drm_fbdev.c b/drivers/gpu/drm/samsung/samsung_drm_fbdev.c
new file mode 100644
index 0000000..9349d20
--- /dev/null
+++ b/drivers/gpu/drm/samsung/samsung_drm_fbdev.c
@@ -0,0 +1,409 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Authors:
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *	SeungWoo Kim <sw0312.kim@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include "drmP.h"
+#include "drm_crtc.h"
+#include "drm_fb_helper.h"
+#include "drm_crtc_helper.h"
+#include "samsung_drm_fb.h"
+
+#include <drm/samsung_drm.h>
+
+#define to_samsung_fbdev(x)	container_of(x, struct samsung_drm_fbdev,\
+				drm_fb_helper)
+
+struct samsung_drm_fbdev {
+	struct drm_fb_helper	drm_fb_helper;
+	struct drm_framebuffer	*fb;
+};
+
+static inline unsigned int chan_to_field(unsigned int chan,
+					 struct fb_bitfield *bf)
+{
+	chan &= 0xffff;
+	chan >>= 16 - bf->length;
+
+	return chan << bf->offset;
+}
+
+static int samsung_drm_fbdev_setcolreg(unsigned regno, unsigned red,
+				       unsigned green, unsigned blue,
+				       unsigned transp, struct fb_info *info)
+{
+	unsigned int val;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	switch (info->fix.visual) {
+	case FB_VISUAL_TRUECOLOR:
+		if (regno < 16) {
+			u32 *pal = info->pseudo_palette;
+
+			val = chan_to_field(red, &info->var.red);
+			val |= chan_to_field(green, &info->var.green);
+			val |= chan_to_field(blue, &info->var.blue);
+
+			pal[regno] = val;
+		}
+		break;
+	default:
+		return 1;
+	}
+
+	return 0;
+}
+
+static struct fb_ops samsung_drm_fb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_fillrect	= cfb_fillrect,
+	.fb_copyarea	= cfb_copyarea,
+	.fb_imageblit	= cfb_imageblit,
+	.fb_check_var	= drm_fb_helper_check_var,
+	.fb_set_par	= drm_fb_helper_set_par,
+	.fb_setcolreg	= samsung_drm_fbdev_setcolreg,
+	.fb_blank	= drm_fb_helper_blank,
+	.fb_pan_display	= drm_fb_helper_pan_display,
+	.fb_setcmap	= drm_fb_helper_setcmap,
+};
+
+static void samsung_drm_fbdev_update(struct drm_fb_helper *helper,
+				     struct drm_framebuffer *fb,
+				     unsigned int fb_width,
+				     unsigned int fb_height)
+{
+	struct fb_info *fbi = helper->fbdev;
+	struct drm_device *dev = helper->dev;
+	struct samsung_drm_fbdev *samsung_fb = to_samsung_fbdev(helper);
+	struct samsung_drm_buffer_info buffer_info;
+	unsigned int size = fb_width * fb_height * (fb->bits_per_pixel >> 3);
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	samsung_fb->fb = fb;
+
+	drm_fb_helper_fill_fix(fbi, fb->pitch, fb->depth);
+	drm_fb_helper_fill_var(fbi, helper, fb_width, fb_height);
+
+	samsung_drm_fb_update_buf_off(fb, fbi->var.xoffset, fbi->var.yoffset,
+			&buffer_info);
+
+	dev->mode_config.fb_base = buffer_info.base_addr;
+
+	fbi->screen_base = buffer_info.vaddr;
+	fbi->screen_size = size;
+	fbi->fix.smem_start = buffer_info.paddr;
+	fbi->fix.smem_len = size;
+}
+
+static int samsung_drm_fbdev_create(struct drm_fb_helper *helper,
+				    struct drm_fb_helper_surface_size *sizes)
+{
+	struct samsung_drm_fbdev *samsung_fbdev = to_samsung_fbdev(helper);
+	struct drm_device *dev = helper->dev;
+	struct fb_info *fbi;
+	struct drm_mode_fb_cmd mode_cmd = { 0 };
+	struct platform_device *pdev = dev->platformdev;
+	int ret;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	DRM_DEBUG_KMS("surface width(%d), height(%d) and bpp(%d\n",
+			sizes->surface_width, sizes->surface_height,
+			sizes->surface_bpp);
+
+	mode_cmd.width = sizes->surface_width;
+	mode_cmd.height = sizes->surface_height;
+	mode_cmd.bpp = sizes->surface_bpp;
+	mode_cmd.depth = sizes->surface_depth;
+
+	mutex_lock(&dev->struct_mutex);
+
+	fbi = framebuffer_alloc(0, &pdev->dev);
+	if (!fbi) {
+		DRM_ERROR("failed to allocate fb info.\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	samsung_fbdev->fb = samsung_drm_fb_create(dev, NULL, &mode_cmd);
+	if (IS_ERR(samsung_fbdev->fb)) {
+		DRM_ERROR("failed to create drm dramebuffer.\n");
+		ret = PTR_ERR(samsung_fbdev->fb);
+		goto out;
+	}
+
+	helper->fb = samsung_fbdev->fb;
+	helper->fbdev = fbi;
+
+	fbi->par = helper;
+	fbi->flags = FBINFO_FLAG_DEFAULT;
+	fbi->fbops = &samsung_drm_fb_ops;
+
+	ret = fb_alloc_cmap(&fbi->cmap, 256, 0);
+	if (ret) {
+		DRM_ERROR("failed to allocate cmap.\n");
+		goto out;
+	}
+
+	samsung_drm_fbdev_update(helper, helper->fb, sizes->fb_width,
+			sizes->fb_height);
+
+out:
+	mutex_unlock(&dev->struct_mutex);
+	return ret;
+}
+
+static bool
+samsung_drm_fbdev_is_samefb(struct drm_framebuffer *fb,
+			    struct drm_fb_helper_surface_size *sizes)
+{
+	if (fb->width != sizes->surface_width)
+		return false;
+	if (fb->height != sizes->surface_height)
+		return false;
+	if (fb->bits_per_pixel != sizes->surface_bpp)
+		return false;
+	if (fb->depth != sizes->surface_depth)
+		return false;
+
+	return true;
+}
+
+static int samsung_drm_fbdev_recreate(struct drm_fb_helper *helper,
+				      struct drm_fb_helper_surface_size *sizes)
+{
+	struct drm_device *dev = helper->dev;
+	struct samsung_drm_fbdev *samsung_fbdev = to_samsung_fbdev(helper);
+	struct drm_framebuffer *fb = samsung_fbdev->fb;
+	struct drm_mode_fb_cmd mode_cmd = { 0 };
+
+	if (helper->fb != fb) {
+		DRM_ERROR("drm framebuffer is different\n");
+		return -EINVAL;
+	}
+
+	if (samsung_drm_fbdev_is_samefb(fb, sizes))
+		return 0;
+
+	mode_cmd.width = sizes->surface_width;
+	mode_cmd.height = sizes->surface_height;
+	mode_cmd.bpp = sizes->surface_bpp;
+	mode_cmd.depth = sizes->surface_depth;
+
+	if (fb->funcs->destroy)
+		fb->funcs->destroy(fb);
+
+	samsung_fbdev->fb = samsung_drm_fb_create(dev, NULL, &mode_cmd);
+	if (IS_ERR(samsung_fbdev->fb)) {
+		DRM_ERROR("failed to allocate fb.\n");
+		return PTR_ERR(samsung_fbdev->fb);
+	}
+
+	helper->fb = samsung_fbdev->fb;
+	samsung_drm_fbdev_update(helper, helper->fb, sizes->fb_width,
+			sizes->fb_height);
+
+	return 0;
+}
+
+static int samsung_drm_fbdev_probe(struct drm_fb_helper *helper,
+				   struct drm_fb_helper_surface_size *sizes)
+{
+	int ret = 0;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (!helper->fb) {
+		ret = samsung_drm_fbdev_create(helper, sizes);
+		if (ret < 0) {
+			DRM_ERROR("failed to create fbdev.\n");
+			return ret;
+		}
+
+		/*
+		 * fb_helper expects a value more than 1 if succeed
+		 * because register_framebuffer() should be called.
+		 */
+		ret = 1;
+	} else {
+		ret = samsung_drm_fbdev_recreate(helper, sizes);
+		if (ret < 0) {
+			DRM_ERROR("failed to reconfigure fbdev\n");
+			return ret;
+		}
+	}
+
+	return ret;
+}
+
+static struct drm_fb_helper_funcs samsung_drm_fb_helper_funcs = {
+	.fb_probe =	samsung_drm_fbdev_probe,
+};
+
+int samsung_drm_fbdev_init(struct drm_device *dev)
+{
+	struct samsung_drm_fbdev *fbdev;
+	struct samsung_drm_private *private = dev->dev_private;
+	struct drm_fb_helper *helper;
+	unsigned int num_crtc;
+	int ret;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (!dev->mode_config.num_crtc || !dev->mode_config.num_connector)
+		return 0;
+
+	fbdev = kzalloc(sizeof(*fbdev), GFP_KERNEL);
+	if (!fbdev) {
+		DRM_ERROR("failed to allocate drm fbdev.\n");
+		return -ENOMEM;
+	}
+
+	private->fb_helper = helper = &fbdev->drm_fb_helper;
+	helper->funcs = &samsung_drm_fb_helper_funcs;
+
+	num_crtc = dev->mode_config.num_crtc;
+
+	ret = drm_fb_helper_init(dev, helper, num_crtc, 4);
+	if (ret < 0) {
+		DRM_ERROR("failed to initialize drm fb helper.\n");
+		goto fail;
+	}
+
+	ret = drm_fb_helper_single_add_all_connectors(helper);
+	if (ret < 0) {
+		DRM_ERROR("failed to register drm_fb_helper_connector.\n");
+		goto fail;
+
+	}
+
+	ret = drm_fb_helper_initial_config(helper, 32);
+	if (ret < 0) {
+		DRM_ERROR("failed to set up hw configuration.\n");
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	private->fb_helper = NULL;
+	kfree(fbdev);
+
+	return ret;
+}
+
+static void samsung_drm_fbdev_destroy(struct drm_device *dev,
+				      struct drm_fb_helper *fb_helper)
+{
+	struct drm_framebuffer *fb;
+	struct fb_info *info;
+
+	/* release drm framebuffer and real buffer */
+	if (fb_helper->fb && fb_helper->fb->funcs) {
+		fb = fb_helper->fb;
+		if (fb->funcs->destroy)
+			fb->funcs->destroy(fb);
+	}
+
+	/* release linux framebuffer */
+	if (fb_helper->fbdev) {
+		info = fb_helper->fbdev;
+		unregister_framebuffer(info);
+		if (info->cmap.len)
+			fb_dealloc_cmap(&info->cmap);
+		framebuffer_release(info);
+	}
+
+	drm_fb_helper_fini(fb_helper);
+}
+
+void samsung_drm_fbdev_fini(struct drm_device *dev)
+{
+	struct samsung_drm_private *private = dev->dev_private;
+	struct samsung_drm_fbdev *fbdev;
+
+	if (!private || !private->fb_helper)
+		return;
+
+	fbdev = to_samsung_fbdev(private->fb_helper);
+
+	samsung_drm_fbdev_destroy(dev, private->fb_helper);
+	kfree(fbdev);
+	private->fb_helper = NULL;
+}
+
+void samsung_drm_fbdev_restore_mode(struct drm_device *dev)
+{
+	struct samsung_drm_private *private = dev->dev_private;
+
+	if (!private || !private->fb_helper)
+		return;
+
+	drm_fb_helper_restore_fbdev_mode(private->fb_helper);
+}
+
+int samsung_drm_fbdev_reinit(struct drm_device *dev)
+{
+	struct samsung_drm_private *private = dev->dev_private;
+	int ret;
+
+	if (!private)
+		return -EINVAL;
+
+	if (!dev->mode_config.num_connector) {
+		samsung_drm_fbdev_fini(dev);
+		return 0;
+	}
+
+	if (private->fb_helper) {
+		struct drm_fb_helper *fb_helper = private->fb_helper;
+
+		drm_fb_helper_fini(fb_helper);
+
+		ret = drm_fb_helper_init(dev, fb_helper,
+				dev->mode_config.num_crtc, 4);
+		if (ret < 0) {
+			DRM_ERROR("failed to initialize drm fb helper\n");
+			return ret;
+		}
+
+		ret = drm_fb_helper_single_add_all_connectors(fb_helper);
+		if (ret < 0) {
+			DRM_ERROR("failed to add fb helper to connectors\n");
+			return ret;
+		}
+
+		ret = drm_fb_helper_initial_config(fb_helper, 32);
+		if (ret < 0) {
+			DRM_ERROR("failed to set up hw configuration.\n");
+			return ret;
+		}
+	} else
+		ret = samsung_drm_fbdev_init(dev);
+
+	return ret;
+}
diff --git a/drivers/gpu/drm/samsung/samsung_drm_fbdev.h b/drivers/gpu/drm/samsung/samsung_drm_fbdev.h
new file mode 100644
index 0000000..3ef4e0d
--- /dev/null
+++ b/drivers/gpu/drm/samsung/samsung_drm_fbdev.h
@@ -0,0 +1,37 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *
+ * Authors:
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *	SeungWoo Kim <sw0312.kim@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef _SAMSUNG_DRM_FBDEV_H_
+#define _SAMSUNG_DRM_FBDEV_H_
+
+int samsung_drm_fbdev_init(struct drm_device *dev);
+int samsung_drm_fbdev_reinit(struct drm_device *dev);
+void samsung_drm_fbdev_fini(struct drm_device *dev);
+void samsung_drm_fbdev_restore_mode(struct drm_device *dev);
+
+#endif
diff --git a/drivers/gpu/drm/samsung/samsung_drm_fimd.c b/drivers/gpu/drm/samsung/samsung_drm_fimd.c
new file mode 100644
index 0000000..e4dadc1
--- /dev/null
+++ b/drivers/gpu/drm/samsung/samsung_drm_fimd.c
@@ -0,0 +1,611 @@
+/*
+ * Copyright (C) 2011 Samsung Electronics Co.Ltd
+ * Author: Joonyoung Shim <jy0922.shim@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+/*
+ * TODO list
+ *  - Code cleanup(FIXME and TODO parts)
+ *  - Support multiple driver instance
+ *  - Clock gating and Power management
+ *  - Writeback feature
+ */
+
+#include "drmP.h"
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+
+#include <drm/samsung_drm.h>
+#include <plat/regs-fb-v4.h>
+
+#include "samsung_drm_fbdev.h"
+#include "samsung_drm_crtc.h"
+
+/* irq_flags bits */
+#define FIMD_VSYNC_IRQ_EN	0
+
+#define VIDOSD_A(win)	(VIDOSD_BASE + 0x00 + (win) * 16)
+#define VIDOSD_B(win)	(VIDOSD_BASE + 0x04 + (win) * 16)
+#define VIDOSD_C(win)	(VIDOSD_BASE + 0x08 + (win) * 16)
+#define VIDOSD_D(win)	(VIDOSD_BASE + 0x0C + (win) * 16)
+
+#define VIDWx_BUF_START(win, buf)	(VIDW_BUF_START(buf) + (win) * 8)
+#define VIDWx_BUF_END(win, buf)		(VIDW_BUF_END(buf) + (win) * 8)
+#define VIDWx_BUF_SIZE(win, buf)	(VIDW_BUF_SIZE(buf) + (win) * 4)
+
+#define WINDOWS_NR	5
+
+#define get_fimd_data(dev)	platform_get_drvdata(to_platform_device(dev))
+
+struct fimd_win_data {
+	unsigned int		offset_x;
+	unsigned int		offset_y;
+	unsigned int		width;
+	unsigned int		height;
+	unsigned int		paddr;
+	void __iomem		*vaddr;
+	unsigned int		end_buf_off;
+	unsigned int		buf_offsize;
+	unsigned int		line_size;	/* bytes */
+};
+
+struct fimd_data {
+	struct drm_crtc			*crtc;
+	struct clk			*bus_clk;
+	struct clk			*lcd_clk;
+	struct resource			*regs_res;
+	void __iomem			*regs;
+	struct fimd_win_data		win_data[WINDOWS_NR];
+	unsigned int			clkdiv;
+	unsigned int			default_win;
+	unsigned int			bpp;
+	unsigned long			irq_flags;
+	u32				vidcon0;
+	u32				vidcon1;
+};
+
+/* TODO: remove global variables */
+static struct samsung_drm_subdrv fimd_subdrv;
+static struct fb_videomode fimd_timing;
+
+static bool fimd_display_is_connected(void)
+{
+	return true;
+}
+
+static void *fimd_get_timing(void)
+{
+	return &fimd_timing;
+}
+
+static int fimd_check_timing(void *timing)
+{
+	return 0;
+}
+
+static int fimd_display_power_on(int mode)
+{
+	return 0;
+}
+
+static struct samsung_drm_display fimd_display = {
+	.type = SAMSUNG_DISPLAY_TYPE_LCD,
+	.is_connected = fimd_display_is_connected,
+	.get_timing = fimd_get_timing,
+	.check_timing = fimd_check_timing,
+	.power_on = fimd_display_power_on,
+};
+
+static void fimd_commit(struct device *dev)
+{
+	struct fimd_data *data = get_fimd_data(dev);
+	void __iomem *regs = data->regs;
+	u32 val;
+
+	/* vidcon0 */
+	val = data->vidcon0;
+	val &= ~(VIDCON0_CLKVAL_F_MASK | VIDCON0_CLKDIR);
+
+	if (data->clkdiv > 1)
+		val |= VIDCON0_CLKVAL_F(data->clkdiv - 1) | VIDCON0_CLKDIR;
+	else
+		val &= ~VIDCON0_CLKDIR;	/* 1:1 clock */
+
+	val |= VIDCON0_ENVID | VIDCON0_ENVID_F;
+	writel(val, regs + VIDCON0);
+
+	/* vidcon1 */
+	writel(data->vidcon1, regs + VIDCON1);
+
+	/* vidtcon0 */
+	val = VIDTCON0_VBPD(fimd_timing.upper_margin - 1) |
+	       VIDTCON0_VFPD(fimd_timing.lower_margin - 1) |
+	       VIDTCON0_VSPW(fimd_timing.vsync_len - 1);
+	writel(val, regs + VIDTCON0);
+
+	/* vidtcon1 */
+	val = VIDTCON1_HBPD(fimd_timing.left_margin - 1) |
+	       VIDTCON1_HFPD(fimd_timing.right_margin - 1) |
+	       VIDTCON1_HSPW(fimd_timing.hsync_len - 1);
+	writel(val, regs + VIDTCON1);
+
+	/* vidtcon2 */
+	val = VIDTCON2_LINEVAL(fimd_timing.yres - 1) |
+	       VIDTCON2_HOZVAL(fimd_timing.xres - 1);
+	writel(val, regs + VIDTCON2);
+}
+
+static int fimd_enable_vblank(struct device *dev)
+{
+	struct fimd_data *data = get_fimd_data(dev);
+	void __iomem *regs = data->regs;
+	u32 val;
+
+	if (!test_and_set_bit(FIMD_VSYNC_IRQ_EN, &data->irq_flags)) {
+		val = readl(regs + VIDINTCON0);
+
+		val |= VIDINTCON0_INT_ENABLE;
+		val |= VIDINTCON0_INT_FRAME;
+
+		val &= ~VIDINTCON0_FRAMESEL0_MASK;
+		val |= VIDINTCON0_FRAMESEL0_VSYNC;
+		val &= ~VIDINTCON0_FRAMESEL1_MASK;
+		val |= VIDINTCON0_FRAMESEL1_NONE;
+
+		writel(val, regs + VIDINTCON0);
+	}
+
+	return 0;
+}
+
+static void fimd_disable_vblank(struct device *dev)
+{
+	struct fimd_data *data = get_fimd_data(dev);
+	void __iomem *regs = data->regs;
+	u32 val;
+
+	if (test_and_clear_bit(FIMD_VSYNC_IRQ_EN, &data->irq_flags)) {
+		val = readl(regs + VIDINTCON0);
+
+		val &= ~VIDINTCON0_INT_FRAME;
+		val &= ~VIDINTCON0_INT_ENABLE;
+
+		writel(val, regs + VIDINTCON0);
+	}
+}
+
+static struct samsung_drm_manager_ops fimd_manager_ops = {
+	.commit = fimd_commit,
+	.enable_vblank = fimd_enable_vblank,
+	.disable_vblank = fimd_disable_vblank,
+};
+
+static void fimd_win_mode_set(struct device *dev,
+			      struct samsung_drm_overlay *overlay)
+{
+	struct fimd_data *data = get_fimd_data(dev);
+	struct fimd_win_data *win_data;
+
+	if (!overlay) {
+		dev_err(dev, "overlay is NULL\n");
+		return;
+	}
+
+	win_data = &data->win_data[data->default_win];
+
+	win_data->offset_x = overlay->offset_x;
+	win_data->offset_y = overlay->offset_y;
+	win_data->width = overlay->width;
+	win_data->height = overlay->height;
+	win_data->paddr = overlay->paddr;
+	win_data->vaddr = overlay->vaddr;
+	win_data->end_buf_off = overlay->end_buf_off * (data->bpp >> 3);
+	win_data->buf_offsize = overlay->buf_offsize * (data->bpp >> 3);
+	win_data->line_size = overlay->line_size * (data->bpp >> 3);
+}
+
+static void fimd_win_commit(struct device *dev)
+{
+	struct fimd_data *data = get_fimd_data(dev);
+	void __iomem *regs = data->regs;
+	struct fimd_win_data *win_data;
+	int win = data->default_win;
+	u32 val;
+
+	if (win < 0 || win > WINDOWS_NR)
+		return;
+
+	win_data = &data->win_data[win];
+
+	/* protect windows */
+	val = readl(regs + SHADOWCON);
+	val |= SHADOWCON_WINx_PROTECT(win);
+	writel(val, regs + SHADOWCON);
+
+	/* buffer start address */
+	val = win_data->paddr;
+	writel(val, regs + VIDWx_BUF_START(win, 0));
+
+	/* buffer end address */
+	val = win_data->paddr + win_data->end_buf_off;
+	writel(val, regs + VIDWx_BUF_END(win, 0));
+
+	/* buffer size */
+	val = VIDW_BUF_SIZE_OFFSET(win_data->buf_offsize) |
+		VIDW_BUF_SIZE_PAGEWIDTH(win_data->line_size);
+	writel(val, regs + VIDWx_BUF_SIZE(win, 0));
+
+	/* OSD position */
+	val = VIDOSDxA_TOPLEFT_X(win_data->offset_x) |
+		VIDOSDxA_TOPLEFT_Y(win_data->offset_y);
+	writel(val, regs + VIDOSD_A(win));
+
+	val = VIDOSDxB_BOTRIGHT_X(win_data->offset_x + win_data->width - 1) |
+		VIDOSDxB_BOTRIGHT_Y(win_data->offset_y + win_data->height - 1);
+	writel(val, regs + VIDOSD_B(win));
+
+	/* TODO: OSD alpha */
+
+	/* OSD size */
+	if (win != 3 && win != 4) {
+		u32 offset = VIDOSD_D(win);
+		if (win == 0)
+			offset = VIDOSD_C(win);
+		val = win_data->width * win_data->height;
+		writel(val, regs + offset);
+	}
+
+	/* FIXME: remove fixed values */
+	val = WINCONx_ENWIN;
+	val |= WINCON0_BPPMODE_24BPP_888;
+	val |= WINCONx_WSWP;
+	val |= WINCONx_BURSTLEN_16WORD;
+	writel(val, regs + WINCON(win));
+
+	/* TODO: colour key */
+
+	/* Enable DMA channel and unprotect windows */
+	val = readl(regs + SHADOWCON);
+	val |= SHADOWCON_CHx_ENABLE(win);
+	val &= ~SHADOWCON_WINx_PROTECT(win);
+	writel(val, regs + SHADOWCON);
+}
+
+static void fimd_win_disable(struct device *dev)
+{
+	struct fimd_data *data = get_fimd_data(dev);
+	void __iomem *regs = data->regs;
+	struct fimd_win_data *win_data;
+	int win = data->default_win;
+	u32 val;
+
+	if (win < 0 || win > WINDOWS_NR)
+		return;
+
+	win_data = &data->win_data[win];
+
+	/* protect windows */
+	val = readl(regs + SHADOWCON);
+	val |= SHADOWCON_WINx_PROTECT(win);
+	writel(val, regs + SHADOWCON);
+
+	/* wincon */
+	val = readl(regs + WINCON(win));
+	val &= ~WINCONx_ENWIN;
+	writel(val, regs + WINCON(win));
+
+	/* unprotect windows */
+	val = readl(regs + SHADOWCON);
+	val &= ~SHADOWCON_CHx_ENABLE(win);
+	val &= ~SHADOWCON_WINx_PROTECT(win);
+	writel(val, regs + SHADOWCON);
+}
+
+static struct samsung_drm_overlay_ops fimd_overlay_ops = {
+	.mode_set = fimd_win_mode_set,
+	.commit = fimd_win_commit,
+	.disable = fimd_win_disable,
+};
+
+/* for pageflip event */
+static void fimd_finish_pageflip(struct drm_device *drm_dev, int crtc)
+{
+	struct samsung_drm_private *dev_priv = drm_dev->dev_private;
+	struct drm_pending_vblank_event *e, *t;
+	struct timeval now;
+	unsigned long flags;
+
+	if (!dev_priv->pageflip_event)
+		return;
+
+	spin_lock_irqsave(&drm_dev->event_lock, flags);
+
+	list_for_each_entry_safe(e, t, &dev_priv->pageflip_event_list,
+			base.link) {
+		do_gettimeofday(&now);
+		e->event.sequence = 0;
+		e->event.tv_sec = now.tv_sec;
+		e->event.tv_usec = now.tv_usec;
+
+		list_move_tail(&e->base.link, &e->base.file_priv->event_list);
+		wake_up_interruptible(&e->base.file_priv->event_wait);
+	}
+
+	drm_vblank_put(drm_dev, crtc);
+	dev_priv->pageflip_event = false;
+
+	spin_unlock_irqrestore(&drm_dev->event_lock, flags);
+}
+
+static irqreturn_t fimd_irq_handler(DRM_IRQ_ARGS)
+{
+	struct drm_device *drm_dev = (struct drm_device *)arg;
+	struct device *dev = fimd_subdrv.manager.dev;
+	struct samsung_drm_manager *manager = &fimd_subdrv.manager;
+	struct fimd_data *data = get_fimd_data(dev);
+	void __iomem *regs = data->regs;
+	u32 val;
+
+	val = readl(regs + VIDINTCON1);
+
+	if (val & VIDINTCON1_INT_FRAME)
+		/* VSYNC interrupt */
+		writel(VIDINTCON1_INT_FRAME, regs + VIDINTCON1);
+
+	drm_handle_vblank(drm_dev, manager->pipe);
+	fimd_finish_pageflip(drm_dev, manager->pipe);
+
+	return IRQ_HANDLED;
+}
+
+static int fimd_subdrv_probe(struct drm_device *drm_dev)
+{
+	struct drm_driver *drm_driver = drm_dev->driver;
+	int ret;
+
+	drm_driver->irq_handler = fimd_irq_handler;
+
+	ret = drm_irq_install(drm_dev);
+	if (ret) {
+		drm_driver->irq_handler = NULL;
+		return ret;
+	}
+
+	/* FIXME */
+	drm_dev->vblank_disable_allowed = 1;
+
+	return 0;
+}
+
+static void fimd_subdrv_remove(struct drm_device *drm_dev)
+{
+	struct drm_driver *drm_driver = drm_dev->driver;
+
+	drm_irq_uninstall(drm_dev);
+
+	drm_driver->irq_handler = NULL;
+}
+
+static struct samsung_drm_subdrv fimd_subdrv = {
+	.probe = fimd_subdrv_probe,
+	.remove = fimd_subdrv_remove,
+	.manager = {
+		.pipe = -1,
+		.ops = &fimd_manager_ops,
+		.overlay_ops = &fimd_overlay_ops,
+		.display = &fimd_display,
+	},
+};
+
+static int fimd_calc_clkdiv(struct fimd_data *data,
+			    struct fb_videomode *timing)
+{
+	unsigned long clk = clk_get_rate(data->lcd_clk);
+	u32 retrace;
+	u32 clkdiv;
+	u32 best_framerate = 0;
+	u32 framerate;
+
+	retrace = timing->left_margin + timing->hsync_len +
+				timing->right_margin + timing->xres;
+	retrace *= timing->upper_margin + timing->vsync_len +
+				timing->lower_margin + timing->yres;
+
+	/* default framerate is 60Hz */
+	if (!timing->refresh)
+		timing->refresh = 60;
+
+	clk /= retrace;
+
+	for (clkdiv = 1; clkdiv < 0x100; clkdiv++) {
+		int tmp;
+
+		/* get best framerate */
+		framerate = clk / clkdiv;
+		tmp = timing->refresh - framerate;
+		if (tmp < 0) {
+			best_framerate = framerate;
+			continue;
+		} else {
+			if (!best_framerate)
+				best_framerate = framerate;
+			else if (tmp < (best_framerate - framerate))
+				best_framerate = framerate ;
+			break;
+		}
+	}
+
+	return clkdiv;
+}
+
+static void fimd_clear_win(struct fimd_data *data, int win)
+{
+	void __iomem *regs = data->regs;
+	u32 val;
+
+	writel(0, regs + WINCON(win));
+	writel(0, regs + VIDOSD_A(win));
+	writel(0, regs + VIDOSD_B(win));
+	writel(0, regs + VIDOSD_C(win));
+
+	if (win == 1 || win == 2)
+		writel(0, regs + VIDOSD_D(win));
+
+	val = readl(regs + SHADOWCON);
+	val &= ~SHADOWCON_WINx_PROTECT(win);
+	writel(val, regs + SHADOWCON);
+}
+
+static int __devinit fimd_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct fimd_data *data;
+	struct samsung_drm_fimd_pdata *pdata;
+	struct resource *res;
+	int win;
+	int ret;
+
+	printk(KERN_DEBUG "[%d] %s\n", __LINE__, __func__);
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(dev, "no platform data specified\n");
+		return -EINVAL;
+	}
+
+	data = kzalloc(sizeof(struct fimd_data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->bus_clk = clk_get(dev, "fimd");
+	if (IS_ERR(data->bus_clk)) {
+		dev_err(dev, "failed to get bus clock\n");
+		ret = PTR_ERR(data->bus_clk);
+		goto err_data;
+	}
+
+	clk_enable(data->bus_clk);
+
+	data->lcd_clk = clk_get(dev, "sclk_fimd");
+	if (IS_ERR(data->lcd_clk)) {
+		dev_err(dev, "failed to get lcd clock\n");
+		ret = PTR_ERR(data->lcd_clk);
+		goto err_bus_clk;
+	}
+
+	clk_enable(data->lcd_clk);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "failed to find registers\n");
+		ret = -ENOENT;
+		goto err_clk;
+	}
+
+	data->regs_res = request_mem_region(res->start, resource_size(res),
+					   dev_name(dev));
+	if (!data->regs_res) {
+		dev_err(dev, "failed to claim register region\n");
+		ret = -ENOENT;
+		goto err_clk;
+	}
+
+	data->regs = ioremap(res->start, resource_size(res));
+	if (!data->regs) {
+		dev_err(dev, "failed to map registers\n");
+		ret = -ENXIO;
+		goto err_req_region;
+	}
+
+	for (win = 0; win < WINDOWS_NR; win++)
+		fimd_clear_win(data, win);
+
+	data->clkdiv = fimd_calc_clkdiv(data, &pdata->timing);
+	data->vidcon0 = pdata->vidcon0;
+	data->vidcon1 = pdata->vidcon1;
+	data->default_win = pdata->default_win;
+	data->bpp = pdata->bpp;
+
+	platform_set_drvdata(pdev, data);
+
+	memcpy(&fimd_timing, &pdata->timing,
+			sizeof(struct fb_videomode));
+	fimd_timing.pixclock = clk_get_rate(data->lcd_clk) / data->clkdiv;
+
+	fimd_subdrv.manager.dev = dev;
+
+	samsung_drm_subdrv_register(&fimd_subdrv);
+
+	return 0;
+
+err_req_region:
+	release_resource(data->regs_res);
+	kfree(data->regs_res);
+
+err_clk:
+	clk_disable(data->lcd_clk);
+	clk_put(data->lcd_clk);
+
+err_bus_clk:
+	clk_disable(data->bus_clk);
+	clk_put(data->bus_clk);
+
+err_data:
+	kfree(data);
+	return ret;
+}
+
+static int __devexit fimd_remove(struct platform_device *pdev)
+{
+	struct fimd_data *data = platform_get_drvdata(pdev);
+
+	samsung_drm_subdrv_unregister(&fimd_subdrv);
+
+	clk_disable(data->lcd_clk);
+	clk_disable(data->bus_clk);
+	clk_put(data->lcd_clk);
+	clk_put(data->bus_clk);
+
+	iounmap(data->regs);
+	release_resource(data->regs_res);
+	kfree(data->regs_res);
+
+	kfree(data);
+
+	return 0;
+}
+
+static struct platform_driver fimd_driver = {
+	.probe		= fimd_probe,
+	.remove		= __devexit_p(fimd_remove),
+	.driver		= {
+		.name	= "exynos4-fb",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init fimd_init(void)
+{
+	return platform_driver_register(&fimd_driver);
+}
+
+static void __exit fimd_exit(void)
+{
+	platform_driver_unregister(&fimd_driver);
+}
+
+module_init(fimd_init);
+module_exit(fimd_exit);
+
+MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
+MODULE_DESCRIPTION("Samsung DRM FIMD Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/samsung/samsung_drm_gem.c b/drivers/gpu/drm/samsung/samsung_drm_gem.c
new file mode 100644
index 0000000..1e167a6
--- /dev/null
+++ b/drivers/gpu/drm/samsung/samsung_drm_gem.c
@@ -0,0 +1,492 @@
+/* samsung_drm_gem.c
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Author: Inki Dae <inki.dae@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include "drmP.h"
+#include "drm.h"
+#include "samsung_drm.h"
+
+#include <drm/samsung_drm.h>
+
+#include "samsung_drm_gem.h"
+#include "samsung_drm_buf.h"
+
+static unsigned int convert_to_vm_err_msg(int msg)
+{
+	unsigned int out_msg;
+
+	switch (msg) {
+	case 0:
+	case -ERESTARTSYS:
+	case -EINTR:
+		out_msg = VM_FAULT_NOPAGE;
+		break;
+
+	case -ENOMEM:
+		out_msg = VM_FAULT_OOM;
+		break;
+
+	default:
+		out_msg = VM_FAULT_SIGBUS;
+		break;
+	}
+
+	return out_msg;
+}
+
+static unsigned int get_gem_mmap_offset(struct drm_gem_object *obj)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	return (unsigned int)obj->map_list.hash.key << PAGE_SHIFT;
+}
+
+/**
+ * samsung_drm_gem_create_mmap_offset - create a fake mmap offset for an object
+ * @obj: obj in question
+ *
+ * GEM memory mapping works by handing back to userspace a fake mmap offset
+ * it can use in a subsequent mmap(2) call.  The DRM core code then looks
+ * up the object based on the offset and sets up the various memory mapping
+ * structures.
+ *
+ * This routine allocates and attaches a fake offset for @obj.
+ */
+static int
+samsung_drm_gem_create_mmap_offset(struct drm_gem_object *obj)
+{
+	struct drm_device *dev = obj->dev;
+	struct drm_gem_mm *mm = dev->mm_private;
+	struct drm_map_list *list;
+	struct drm_local_map *map;
+	int ret = 0;
+
+	/* Set the object up for mmap'ing */
+	list = &obj->map_list;
+	list->map = kzalloc(sizeof(struct drm_map_list), GFP_KERNEL);
+	if (!list->map)
+		return -ENOMEM;
+
+	map = list->map;
+	map->type = _DRM_GEM;
+	map->size = obj->size;
+	map->handle = obj;
+
+	/* Get a DRM GEM mmap offset allocated... */
+	list->file_offset_node = drm_mm_search_free(&mm->offset_manager,
+						    obj->size / PAGE_SIZE,
+						    0, 0);
+	if (!list->file_offset_node) {
+		DRM_ERROR("failed to allocate offset for bo %d\n",
+			  obj->name);
+		ret = -ENOSPC;
+		goto out_free_list;
+	}
+
+	list->file_offset_node = drm_mm_get_block(list->file_offset_node,
+						  obj->size / PAGE_SIZE,
+						  0);
+	if (!list->file_offset_node) {
+		ret = -ENOMEM;
+		goto out_free_list;
+	}
+
+	list->hash.key = list->file_offset_node->start;
+	ret = drm_ht_insert_item(&mm->offset_hash, &list->hash);
+	if (ret) {
+		DRM_ERROR("failed to add to map hash\n");
+		goto out_free_mm;
+	}
+
+	return 0;
+
+out_free_mm:
+	drm_mm_put_block(list->file_offset_node);
+out_free_list:
+	kfree(list->map);
+	list->map = NULL;
+
+	return ret;
+}
+
+static void
+samsung_drm_gem_free_mmap_offset(struct drm_gem_object *obj)
+{
+	struct drm_device *dev = obj->dev;
+	struct drm_gem_mm *mm = dev->mm_private;
+	struct drm_map_list *list = &obj->map_list;
+
+	drm_ht_remove_item(&mm->offset_hash, &list->hash);
+	drm_mm_put_block(list->file_offset_node);
+	kfree(list->map);
+	list->map = NULL;
+}
+
+static int samsung_drm_gem_create(struct drm_file *file, struct drm_device *dev,
+		unsigned int size, unsigned int *handle_p)
+{
+	struct samsung_drm_gem_obj *samsung_gem_obj;
+	struct drm_gem_object *obj;
+	unsigned int handle;
+	int ret;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	size = roundup(size, PAGE_SIZE);
+
+	/* allocate the new buffer object and memory region. */
+	samsung_gem_obj = samsung_drm_buf_create(dev, size);
+	if (!samsung_gem_obj)
+		return -ENOMEM;
+
+	obj = &samsung_gem_obj->base;
+
+	ret = drm_gem_object_init(dev, obj, size);
+	if (ret < 0) {
+		DRM_ERROR("failed to initailize gem object.\n");
+		goto out;
+	}
+
+	DRM_DEBUG_KMS("created file object = 0x%x\n", (unsigned int)obj->filp);
+
+	ret = samsung_drm_gem_create_mmap_offset(obj);
+	if (ret < 0) {
+		DRM_ERROR("failed to allocate mmap offset.\n");
+		goto out;
+	}
+
+	/**
+	 * allocate a id of idr table where the obj is registered
+	 * and handle has the id what user can see.
+	 */
+	ret = drm_gem_handle_create(file, obj, &handle);
+	if (ret) {
+		drm_gem_object_release(obj);
+		samsung_drm_buf_destroy(dev, samsung_gem_obj);
+		goto out;
+	}
+
+	DRM_DEBUG_KMS("gem handle = 0x%x\n", handle);
+
+	/* drop reference from allocate - handle holds it now. */
+	drm_gem_object_unreference_unlocked(obj);
+
+	*handle_p = handle;
+
+	return 0;
+
+out:
+	drm_gem_object_unreference_unlocked(obj);
+
+	samsung_drm_buf_destroy(dev, samsung_gem_obj);
+
+	kfree(samsung_gem_obj);
+
+	return ret;
+}
+
+int samsung_drm_gem_create_ioctl(struct drm_device *dev, void *data,
+		struct drm_file *file)
+{
+	struct drm_samsung_gem_create *args = data;
+
+	DRM_DEBUG_KMS("%s : size = 0x%x\n", __FILE__, args->size);
+
+	return samsung_drm_gem_create(file, dev, args->size, &args->handle);
+}
+
+int samsung_drm_gem_map_offset_ioctl(struct drm_device *dev, void *data,
+		struct drm_file *file)
+{
+	struct drm_samsung_gem_map_off *args = data;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	DRM_DEBUG_KMS("handle = 0x%x, offset = 0x%x\n",
+			args->handle, (u32)args->offset);
+
+	if (!(dev->driver->driver_features & DRIVER_GEM)) {
+		DRM_ERROR("not support GEM.\n");
+		return -ENODEV;
+	}
+
+	return samsung_drm_gem_dumb_map_offset(file, dev, args->handle,
+			&args->offset);
+}
+
+static int samsung_drm_gem_mmap_buffer(struct file *filp,
+		struct vm_area_struct *vma)
+{
+	struct drm_gem_object *obj = filp->private_data;
+	struct samsung_drm_gem_obj *samsung_gem_obj = to_samsung_gem_obj(obj);
+	struct samsung_drm_buf_entry *entry;
+	unsigned long pfn, size;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	vma->vm_flags |= (VM_IO | VM_RESERVED);
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	vma->vm_file = filp;
+
+	size = vma->vm_end - vma->vm_start;
+	entry = samsung_gem_obj->entry;
+
+	/* check if the region to be mapped is valid or not. */
+	if ((entry->paddr + vma->vm_pgoff + size) >
+			(entry->paddr + entry->size)) {
+		drm_gem_object_unreference_unlocked(obj);
+		DRM_ERROR("desired size is bigger then real size.\n");
+		return -EINVAL;
+	}
+
+	pfn = (samsung_gem_obj->entry->paddr + vma->vm_pgoff) >> PAGE_SHIFT;
+
+	DRM_DEBUG_KMS("offset = 0x%x, pfn to be mapped = 0x%x\n",
+			(u32)vma->vm_pgoff, (u32)pfn);
+
+	if (remap_pfn_range(vma, vma->vm_start, pfn,
+				vma->vm_end - vma->vm_start,
+				vma->vm_page_prot)) {
+		DRM_ERROR("failed to remap pfn range.\n");
+		return -EAGAIN;
+	}
+
+	return 0;
+}
+
+static const struct file_operations samsung_drm_gem_fops = {
+	.mmap = samsung_drm_gem_mmap_buffer,
+};
+
+int samsung_drm_gem_mmap_ioctl(struct drm_device *dev, void *data,
+		struct drm_file *filp)
+{
+	struct drm_samsung_gem_mmap *args = data;
+	struct drm_gem_object *obj;
+	unsigned int addr;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	if (!(dev->driver->driver_features & DRIVER_GEM)) {
+		DRM_ERROR("not support GEM.\n");
+		return -ENODEV;
+	}
+
+	obj = drm_gem_object_lookup(dev, filp, args->handle);
+	if (!obj) {
+		DRM_ERROR("failed to lookup gem object.\n");
+		return -EINVAL;
+	}
+
+	obj->filp->f_op = &samsung_drm_gem_fops;
+	obj->filp->private_data = obj;
+
+	down_write(&current->mm->mmap_sem);
+	addr = do_mmap(obj->filp, 0, args->size,
+			PROT_READ | PROT_WRITE, MAP_SHARED, args->offset);
+	up_write(&current->mm->mmap_sem);
+
+	drm_gem_object_unreference_unlocked(obj);
+
+	if (IS_ERR((void *)addr))
+		return PTR_ERR((void *)addr);
+
+	args->mapped = addr;
+
+	DRM_DEBUG_KMS("mapped = 0x%x\n", args->mapped);
+
+	return 0;
+}
+
+int samsung_drm_gem_init_object(struct drm_gem_object *obj)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	return 0;
+}
+
+void samsung_drm_gem_free_object(struct drm_gem_object *gem_obj)
+{
+	struct samsung_drm_gem_obj *samsung_gem_obj;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	DRM_DEBUG_KMS("handle count = %d\n",
+			atomic_read(&gem_obj->handle_count));
+
+	if (gem_obj->map_list.map)
+		samsung_drm_gem_free_mmap_offset(gem_obj);
+
+	/* release file pointer to gem object. */
+	drm_gem_object_release(gem_obj);
+
+	samsung_gem_obj = to_samsung_gem_obj(gem_obj);
+
+	samsung_drm_buf_destroy(gem_obj->dev, samsung_gem_obj);
+}
+
+struct samsung_drm_gem_obj *
+		find_samsung_drm_gem_object(struct drm_file *file_priv,
+			struct drm_device *dev, unsigned int handle)
+{
+	struct drm_gem_object *gem_obj;
+
+	gem_obj = drm_gem_object_lookup(dev, file_priv, handle);
+	if (!gem_obj) {
+		DRM_LOG_KMS("a invalid gem object not registered to lookup.\n");
+		return NULL;
+	}
+
+	/**
+	 * unreference refcount of the gem object.
+	 * at drm_gem_object_lookup(), the gem object was referenced.
+	 */
+	drm_gem_object_unreference(gem_obj);
+
+	return to_samsung_gem_obj(gem_obj);
+}
+
+int samsung_drm_gem_dumb_create(struct drm_file *file_priv,
+		struct drm_device *dev, struct drm_mode_create_dumb *args)
+{
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	/**
+	 * alocate memory to be used for framebuffer.
+	 * - this callback would be called by user application
+	 *	with DRM_IOCTL_MODE_CREATE_DUMB command.
+	 */
+
+	args->pitch = args->width * args->bpp >> 3;
+	args->size = args->pitch * args->height;
+
+	return samsung_drm_gem_create(file_priv, dev, args->size,
+			&args->handle);
+}
+
+int samsung_drm_gem_dumb_map_offset(struct drm_file *file_priv,
+		struct drm_device *dev, uint32_t handle, uint64_t *offset)
+{
+	struct samsung_drm_gem_obj *samsung_gem_obj;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	mutex_lock(&dev->struct_mutex);
+
+	/**
+	 * get offset of memory allocated for drm framebuffer.
+	 * - this callback would be called by user application
+	 *	with DRM_IOCTL_MODE_MAP_DUMB command.
+	 */
+
+	samsung_gem_obj = find_samsung_drm_gem_object(file_priv, dev, handle);
+	if (!samsung_gem_obj) {
+		DRM_ERROR("failed to get samsung_drm_get_obj.\n");
+		mutex_unlock(&dev->struct_mutex);
+		return -EINVAL;
+	}
+
+	*offset = get_gem_mmap_offset(&samsung_gem_obj->base);
+
+	DRM_DEBUG_KMS("offset = 0x%x\n", (unsigned int)*offset);
+
+	mutex_unlock(&dev->struct_mutex);
+
+	return 0;
+}
+
+int samsung_drm_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct drm_gem_object *obj = vma->vm_private_data;
+	struct samsung_drm_gem_obj *samsung_gem_obj = to_samsung_gem_obj(obj);
+	struct drm_device *dev = obj->dev;
+	unsigned long pfn;
+	pgoff_t page_offset;
+	int ret;
+
+	page_offset = ((unsigned long)vmf->virtual_address -
+			vma->vm_start) >> PAGE_SHIFT;
+
+	mutex_lock(&dev->struct_mutex);
+
+	pfn = (samsung_gem_obj->entry->paddr >> PAGE_SHIFT) + page_offset;
+
+	ret = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address, pfn);
+
+	mutex_unlock(&dev->struct_mutex);
+
+	return convert_to_vm_err_msg(ret);
+}
+
+int samsung_drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	int ret;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	/* set vm_area_struct. */
+	ret = drm_gem_mmap(filp, vma);
+	if (ret < 0) {
+		DRM_ERROR("failed to mmap.\n");
+		return ret;
+	}
+
+	vma->vm_flags &= ~VM_PFNMAP;
+	vma->vm_flags |= VM_MIXEDMAP;
+
+	return ret;
+}
+
+
+int samsung_drm_gem_dumb_destroy(struct drm_file *file_priv,
+		struct drm_device *dev, unsigned int handle)
+{
+	struct samsung_drm_gem_obj *samsung_gem_obj;
+	int ret;
+
+	DRM_DEBUG_KMS("%s\n", __FILE__);
+
+	samsung_gem_obj = find_samsung_drm_gem_object(file_priv, dev, handle);
+	if (!samsung_gem_obj) {
+		DRM_ERROR("failed to get samsung_drm_get_obj.\n");
+		return -EINVAL;
+	}
+
+	/**
+	 * obj->refcount and obj->handle_count are decreased and
+	 * if both them are 0 then samsung_drm_gem_free_object()
+	 * would be called by callback to release resources.
+	 */
+	ret = drm_gem_handle_delete(file_priv, handle);
+	if (ret < 0) {
+		DRM_ERROR("failed to delete drm_gem_handle.\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+MODULE_AUTHOR("Inki Dae <inki.dae@samsung.com>");
+MODULE_DESCRIPTION("Samsung SoC DRM GEM Module");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/samsung/samsung_drm_gem.h b/drivers/gpu/drm/samsung/samsung_drm_gem.h
new file mode 100644
index 0000000..dbc0ab2
--- /dev/null
+++ b/drivers/gpu/drm/samsung/samsung_drm_gem.h
@@ -0,0 +1,76 @@
+/* samsung_drm_gem.h
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Authoer: Inki Dae <inki.dae@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef _SAMSUNG_DRM_GEM_H_
+#define _SAMSUNG_DRM_GEM_H_
+
+#define to_samsung_gem_obj(x)	container_of(x,\
+			struct samsung_drm_gem_obj, base)
+
+/* create a new mm object and get a handle to it. */
+int samsung_drm_gem_create_ioctl(struct drm_device *dev, void *data,
+		struct drm_file *file);
+
+/* get buffer offset to map to user space. */
+int samsung_drm_gem_map_offset_ioctl(struct drm_device *dev, void *data,
+		struct drm_file *file);
+
+/* unmap a buffer from user space. */
+int samsung_drm_gem_munmap_ioctl(struct drm_device *dev, void *data,
+		struct drm_file *file);
+
+/* initialize gem object. */
+int samsung_drm_gem_init_object(struct drm_gem_object *obj);
+
+/* free gem object. */
+void samsung_drm_gem_free_object(struct drm_gem_object *gem_obj);
+
+struct samsung_drm_gem_obj *
+		find_samsung_drm_gem_object(struct drm_file *file_priv,
+			struct drm_device *dev, unsigned int handle);
+
+/* create memory region for drm framebuffer. */
+int samsung_drm_gem_dumb_create(struct drm_file *file_priv,
+		struct drm_device *dev, struct drm_mode_create_dumb *args);
+
+/* map memory region for drm framebuffer to user space. */
+int samsung_drm_gem_dumb_map_offset(struct drm_file *file_priv,
+		struct drm_device *dev, uint32_t handle, uint64_t *offset);
+
+/* page fault handler and mmap fault address(virtual) to physical memory. */
+int samsung_drm_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
+
+/* mmap gem object. */
+int samsung_drm_gem_mmap_ioctl(struct drm_device *dev, void *data,
+		struct drm_file *filp);
+
+/* set vm_flags and we can change vm attribute to other here. */
+int samsung_drm_gem_mmap(struct file *filp, struct vm_area_struct *vma);
+
+/* destroy memory region allocated. */
+int samsung_drm_gem_dumb_destroy(struct drm_file *file_priv,
+		struct drm_device *dev, unsigned int handle);
+
+#endif
diff --git a/include/drm/samsung_drm.h b/include/drm/samsung_drm.h
new file mode 100644
index 0000000..05dc460
--- /dev/null
+++ b/include/drm/samsung_drm.h
@@ -0,0 +1,267 @@
+/* samsung_drm.h
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Authors:
+ *	Inki Dae <inki.dae@samsung.com>
+ *	Joonyoung Shim <jy0922.shim@samsung.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef _SAMSUNG_DRM_H_
+#define _SAMSUNG_DRM_H_
+
+#include "drm.h"
+
+#define MAX_CRTC	2
+
+struct drm_device;
+struct samsung_drm_overlay;
+struct drm_connector;
+
+enum samsung_drm_output_type {
+	SAMSUNG_DISPLAY_TYPE_NONE,
+	SAMSUNG_DISPLAY_TYPE_LCD,	/* RGB or CPU Interface. */
+	SAMSUNG_DISPLAY_TYPE_HDMI,	/* HDMI Interface. */
+};
+
+/**
+ * Samsung drm overlay ops structure.
+ *
+ * @mode_set: copy drm overlay info to hw specific overlay info.
+ * @commit: set hw specific overlay into to hw.
+ */
+struct samsung_drm_overlay_ops {
+	void (*mode_set)(struct device *subdrv_dev,
+			 struct samsung_drm_overlay *overlay);
+	void (*commit)(struct device *subdrv_dev);
+	void (*disable)(struct device *subdrv_dev);
+};
+
+/**
+ * Samsung drm common overlay structure.
+ *
+ * @win_num: window number.
+ * @offset_x: offset to x position.
+ * @offset_y: offset to y position.
+ * @pos_x: x position.
+ * @pos_y: y position.
+ * @width: window width.
+ * @height: window height.
+ * @bpp: bit per pixel.
+ * @paddr: physical memory address to this overlay.
+ * @vaddr: virtual memory addresss to this overlay.
+ * @buf_off: start offset of framebuffer to be displayed.
+ * @end_buf_off: end offset of framebuffer to be displayed.
+ * @buf_offsize: this value has result from
+ *			(framebuffer width - display width) * bpp.
+ * @line_size: line size to this overlay memory in bytes.
+ * @default_win: a window to be enabled.
+ * @color_key: color key on or off.
+ * @index_color: if using color key feature then this value would be used
+ *			as index color.
+ * @local_path: in case of lcd type, local path mode on or off.
+ * @transparency: transparency on or off.
+ * @activated: activated or not.
+ * @subdrv_dev: pointer to device object for subdrv device driver.
+ * @ops: pointer to samsung_drm_overlay_ops.
+ *
+ * this structure is common to Samsung SoC and would be copied
+ * to hardware specific overlay info.
+ */
+struct samsung_drm_overlay {
+	unsigned int offset_x;
+	unsigned int offset_y;
+	unsigned int width;
+	unsigned int height;
+	unsigned int paddr;
+	void __iomem *vaddr;
+	unsigned int buf_off;
+	unsigned int end_buf_off;
+	unsigned int buf_offsize;
+	unsigned int line_size;
+
+	bool default_win;
+	bool color_key;
+	unsigned int index_color;
+	bool local_path;
+	bool transparency;
+	bool activated;
+};
+
+/**
+ * Samsung DRM Display Structure.
+ *	- this structure is common to analog tv, digital tv and lcd panel.
+ *
+ * @dev: pointer to specific device object.
+ * @is_connected: check for that display is connected or not.
+ * @get_edid: get edid modes from display driver.
+ * @get_timing: get timing object from display driver.
+ * @check_timing: check if timing is valid or not.
+ * @power_on: display device on or off.
+ */
+struct samsung_drm_display {
+	unsigned int type;
+	bool (*is_connected)(void);
+	int (*get_edid)(struct drm_connector *connector, u8 *edid, int len);
+	void *(*get_timing)(void);
+	int (*check_timing)(void *timing);
+	int (*power_on)(int mode);
+};
+
+/**
+ * Samsung drm manager ops
+ *
+ * @mode_set: convert drm_display_mode to hw specific display mode and
+ *	      would be called by encoder->mode_set().
+ * @commit: set current hw specific display mode to hw.
+ * @enable_vblank: specific driver callback for enabling vblank interrupt.
+ * @disable_vblank: specific driver callback for disabling vblank interrupt.
+ */
+struct samsung_drm_manager_ops {
+	void (*mode_set)(struct device *subdrv_dev, void *mode);
+	void (*commit)(struct device *subdrv_dev);
+	int (*enable_vblank)(struct device *subdrv_dev);
+	void (*disable_vblank)(struct device *subdrv_dev);
+};
+
+/**
+ * Samsung drm common manager structure.
+ *
+ * @dev: pointer to device object for subdrv device driver.
+ * @ops: ops pointer to samsung drm common framebuffer.
+ *	 ops of fimd or hdmi driver should be set to this ones.
+ */
+struct samsung_drm_manager {
+	struct device *dev;
+	int pipe;
+	struct samsung_drm_manager_ops *ops;
+	struct samsung_drm_overlay_ops *overlay_ops;
+	struct samsung_drm_display *display;
+};
+
+/**
+ * Samsung drm private structure.
+ */
+struct samsung_drm_private {
+	struct drm_fb_helper *fb_helper;
+
+	/* for pageflip */
+	struct list_head pageflip_event_list;
+	bool pageflip_event;
+
+	struct drm_crtc *crtc[MAX_CRTC];
+
+	/* add some structures. */
+};
+
+struct samsung_drm_subdrv {
+	struct list_head list;
+
+	/* driver ops */
+	int (*probe)(struct drm_device *dev);
+	void (*remove)(struct drm_device *dev);
+
+	struct samsung_drm_manager manager;
+	struct drm_encoder *encoder;
+	struct drm_connector *connector;
+};
+
+int samsung_drm_device_register(struct drm_device *dev);
+void samsung_drm_device_unregister(struct drm_device *dev);
+int samsung_drm_subdrv_register(struct samsung_drm_subdrv *drm_subdrv);
+void samsung_drm_subdrv_unregister(struct samsung_drm_subdrv *drm_subdrv);
+
+/**
+ * User-desired buffer creation information structure.
+ *
+ * @usr_addr: an address allocated by user process and this address
+ *	would be mmapped to physical region by fault handler.
+ * @size: requested size for the object.
+ *	- this size value would be page-aligned internally.
+ * @flags: user request for setting memory type or cache attributes.
+ * @handle: returned handle for the object.
+ */
+struct drm_samsung_gem_create {
+	unsigned int usr_addr;
+	unsigned int size;
+	unsigned int flags;
+
+	unsigned int handle;
+};
+
+/**
+ * A structure for getting buffer offset.
+ *
+ * @handle: a pointer to gem object created.
+ * @offset: relatived offset value of the memory region allocated.
+ *	- this value should be set by user.
+ */
+struct drm_samsung_gem_map_off {
+	unsigned int handle;
+	uint64_t offset;
+};
+
+/**
+ * A structure for mapping buffer.
+ *
+ * @handle: a pointer to gem object created.
+ * @offset: relatived offset value of the memory region allocated.
+ *	- this value should be set by user.
+ * @size: memory size to be mapped.
+ * @mapped: user virtual address to be mapped.
+ */
+struct drm_samsung_gem_mmap {
+	unsigned int handle;
+	uint64_t offset;
+	unsigned int size;
+
+	unsigned int mapped;
+};
+
+#define DRM_SAMSUNG_GEM_CREATE		0x00
+#define DRM_SAMSUNG_GEM_MAP_OFFSET	0x01
+#define DRM_SAMSUNG_GEM_MMAP		0x02
+
+#define DRM_IOCTL_SAMSUNG_GEM_CREATE		DRM_IOWR(DRM_COMMAND_BASE + \
+		DRM_SAMSUNG_GEM_CREATE, struct drm_samsung_gem_create)
+
+#define DRM_IOCTL_SAMSUNG_GEM_MAP_OFFSET	DRM_IOWR(DRM_COMMAND_BASE + \
+		DRM_SAMSUNG_GEM_MAP_OFFSET, struct drm_samsung_gem_map_off)
+
+#define DRM_IOCTL_SAMSUNG_GEM_MMAP	DRM_IOWR(DRM_COMMAND_BASE + \
+		DRM_SAMSUNG_GEM_MMAP, struct drm_samsung_gem_mmap)
+
+/**
+ * Platform Specific Structure for DRM based FIMD.
+ *
+ * @timing: default video mode for initializing
+ * @default_win: default window layer number to be used for UI.
+ * @bpp: default bit per pixel.
+ */
+struct samsung_drm_fimd_pdata {
+	struct fb_videomode		timing;
+	u32				vidcon0;
+	u32				vidcon1;
+	unsigned int			default_win;
+	unsigned int			bpp;
+};
+
+#endif
-- 
1.7.0.4

