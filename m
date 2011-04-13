Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab1DMJ6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 05:58:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48638 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751409Ab1DMJ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 05:58:41 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 4/5] gma500: Add a gtt allocator
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 13 Apr 2011 10:37:03 +0100
Message-ID: <20110413093624.28527.33558.stgit@localhost.localdomain>
In-Reply-To: <20110413093519.28527.36552.stgit@localhost.localdomain>
References: <20110413093519.28527.36552.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment we don't do any page backing for the GTT so only the stolen
area pages will actually work. That is fine for our initial framebuffer and
a bit of testing but will need resolution (including alternate mmap methods
and the like for s/g areas) eventually.

Rather than use some of the overcomplex stuff in the DRM we use the existing
Linux resource allocators to hand out framebuffers and the like. This also has
the nice result that /proc/iomem shows the allocations.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.h |   16 +++-
 drivers/staging/gma500/psb_fb.c  |   32 +++++---
 drivers/staging/gma500/psb_fb.h  |   13 +--
 drivers/staging/gma500/psb_gtt.c |  155 ++++++++++++++++++++++++++++++++++++++
 drivers/staging/gma500/psb_gtt.h |   30 ++++++-
 5 files changed, 217 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index c3609e0..7a0506a 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -21,6 +21,7 @@
 #define _PSB_DRV_H_
 
 #include <linux/version.h>
+#include <linux/kref.h>
 
 #include <drm/drmP.h>
 #include "drm_global.h"
@@ -228,6 +229,7 @@ struct psb_intel_opregion {
 	int enabled;
 };
 
+
 struct drm_psb_private {
 	struct drm_device *dev;
 
@@ -235,19 +237,29 @@ struct drm_psb_private {
 
 	struct psb_gtt *pg;
 
-	/*GTT Memory manager*/
+	/* GTT Memory manager */
 	struct psb_gtt_mm *gtt_mm;
 	struct page *scratch_page;
 
+	struct mutex gtt_mutex;
+	struct resource *gtt_mem;	/* Our PCI resource */
+	struct gtt_range *gtt_handles[GTT_MAX];
+
+	struct gtt_range *fb;		/* System frame buffer */
+
 	struct psb_mmu_driver *mmu;
 	struct psb_mmu_pd *pf_pd;
 
+	/*
+	 * Register base
+	 */
+
 	uint8_t *sgx_reg;
 	uint8_t *vdc_reg;
 	uint32_t gatt_free_offset;
 
 	/*
-	 *Fencing / irq.
+	 * Fencing / irq.
 	 */
 
 	uint32_t vdc_irq_mask;
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 665096f..06715e8 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -256,15 +256,15 @@ static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 	DRM_DEBUG("vm_pgoff 0x%lx, screen base %p vram_addr %p\n",
 				vma->vm_pgoff, fb_screen_base, pg->vram_addr);
 
-	/*if using stolen memory, */
-	if (fb_screen_base == pg->vram_addr) {
+        /* FIXME: ultimately this needs to become 'if entirely stolen memory' */
+	if (1 || fb_screen_base == pg->vram_addr) {
 		vma->vm_ops = &psbfb_vm_ops;
 		vma->vm_private_data = (void *)psbfb;
 		vma->vm_flags |= VM_RESERVED | VM_IO |
 						VM_MIXEDMAP | VM_DONTEXPAND;
 	} else {
-	/*using IMG meminfo, can I use pvrmmap to map it?*/
-
+	        /* GTT memory backed by kernel/user pages, needs a different
+	           approach ? */
 	}
 
 	return 0;
@@ -328,7 +328,7 @@ static struct drm_framebuffer *psb_framebuffer_create
 
 	drm_helper_mode_fill_fb_struct(&fb->base, r);
 
-	fb->bo = mm_private;
+	fb->mem = mm_private;
 
 	return &fb->base;
 
@@ -464,8 +464,6 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	struct psb_framebuffer *psbfb;
 	struct drm_mode_fb_cmd mode_cmd;
 	struct device *device = &dev->pdev->dev;
-
-	struct ttm_buffer_object *fbo = NULL;
 	int size, aligned_size;
 	int ret;
 
@@ -480,8 +478,14 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	size = mode_cmd.pitch * mode_cmd.height;
 	aligned_size = ALIGN(size, PAGE_SIZE);
 
+	/* Allocate the framebuffer in the GTT */
+	/* FIXME: this cannot live in dev_priv once we go multi head */
+	dev_priv->fb = psb_gtt_alloc_range(dev, aligned_size, "fb");
+	if (dev_priv->fb == NULL)
+	        return -ENOMEM;
+
 	mutex_lock(&dev->struct_mutex);
-	fb = psb_framebuffer_create(dev, &mode_cmd, fbo);
+	fb = psb_framebuffer_create(dev, &mode_cmd, dev_priv->fb);
 	if (!fb) {
 		DRM_ERROR("failed to allocate fb.\n");
 		ret = -ENOMEM;
@@ -510,7 +514,11 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	info->fbops = &psbfb_ops;
 	info->fix.smem_start = dev->mode_config.fb_base;
 	info->fix.smem_len = size;
-	info->screen_base = (char *)pg->vram_addr;
+
+	/* Accessed via stolen memory directly, This only works for stolem
+	   memory however. Need to address this once we start using gtt
+	   pages we allocate */
+	info->screen_base = (char *)pg->vram_addr + dev_priv->fb->offset;
 	info->screen_size = size;
 	memset(info->screen_base, 0, size);
 
@@ -540,6 +548,8 @@ out_err0:
 	fb->funcs->destroy(fb);
 out_err1:
 	mutex_unlock(&dev->struct_mutex);
+	psb_gtt_free_range(dev, dev_priv->fb);
+	dev_priv->fb = NULL;
 	return ret;
 }
 
@@ -586,15 +596,14 @@ int psb_fbdev_destroy(struct drm_device *dev, struct psb_fbdev *fbdev)
 
 	if (fbdev->psb_fb_helper.fbdev) {
 		info = fbdev->psb_fb_helper.fbdev;
+		psb_gtt_free_range(dev, psbfb->mem);
 		unregister_framebuffer(info);
 		iounmap(info->screen_base);
 		framebuffer_release(info);
 	}
 
 	drm_fb_helper_fini(&fbdev->psb_fb_helper);
-
 	drm_framebuffer_cleanup(&psbfb->base);
-
 	return 0;
 }
 
@@ -652,7 +661,6 @@ int psbfb_remove(struct drm_device *dev, struct drm_framebuffer *fb)
 		return 0;
 
 	info = psbfb->fbdev;
-	psbfb->pvrBO = NULL;
 
 	if (info)
 		framebuffer_release(info);
diff --git a/drivers/staging/gma500/psb_fb.h b/drivers/staging/gma500/psb_fb.h
index b4fab92..b943a9f 100644
--- a/drivers/staging/gma500/psb_fb.h
+++ b/drivers/staging/gma500/psb_fb.h
@@ -28,16 +28,11 @@
 
 #include "psb_drv.h"
 
-/*IMG Headers*/
-/*#include "servicesint.h"*/
-
 struct psb_framebuffer {
 	struct drm_framebuffer base;
 	struct address_space *addr_space;
-	struct ttm_buffer_object *bo;
-	struct fb_info * fbdev;
-	/* struct ttm_bo_kmap_obj kmap; */
-	void *pvrBO;	/* FIXME: sort this out */
+	struct fb_info *fbdev;
+	struct gtt_range *mem;
 	void * hKernelMemInfo;
 	uint32_t size;
 	uint32_t offset;
@@ -45,15 +40,13 @@ struct psb_framebuffer {
 
 struct psb_fbdev {
 	struct drm_fb_helper psb_fb_helper;
-	struct psb_framebuffer * pfb;
+	struct psb_framebuffer *pfb;
 };
 
 
 #define to_psb_fb(x) container_of(x, struct psb_framebuffer, base)
 
-
 extern int psb_intel_connector_clones(struct drm_device *dev, int type_mask);
 
-
 #endif
 
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 5f2acef..a97e7be 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -94,8 +94,10 @@ int psb_gtt_init(struct psb_gtt *pg, int resume)
 	PSB_WVDC32(pg->pge_ctl | _PSB_PGETBL_ENABLED, PSB_PGETBL_CTL);
 	(void) PSB_RVDC32(PSB_PGETBL_CTL);
 
-	pg->initialized = 1;
+	/* The root resource we allocate address space from */
+	dev_priv->gtt_mem = &dev->pdev->resource[PSB_GATT_RESOURCE];
 
+	pg->initialized = 1;
 	pg->gtt_phys_start = pg->pge_ctl & PAGE_MASK;
 
 	pg->gatt_start = pci_resource_start(dev->pdev, PSB_GATT_RESOURCE);
@@ -884,3 +886,154 @@ int psb_gtt_unmap_meminfo(struct drm_device *dev, void * hKernelMemInfo)
 	return 0;
 }
 
+/*
+ *	GTT resource allocator
+ */
+
+/**
+ *	psb_gtt_alloc_handle	-	allocate a handle to a GTT map
+ *	@dev: our DRM device
+ *	@gt: Our GTT range
+ *
+ *	Assign a handle to a gtt range object. For the moment we use a very
+ *	simplistic interface.
+ */
+int psb_gtt_alloc_handle(struct drm_device *dev, struct gtt_range *gt)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int h;
+
+	mutex_lock(&dev_priv->gtt_mutex);
+	for (h = 0; h < GTT_MAX; h++) {
+		if (dev_priv->gtt_handles[h] == NULL) {
+			dev_priv->gtt_handles[h] = gt;
+			gt->handle = h;
+			kref_get(&gt->kref);
+			mutex_unlock(&dev_priv->gtt_mutex);
+			return h;
+		}
+	}
+	mutex_unlock(&dev_priv->gtt_mutex);
+	return -ENOSPC;
+}
+
+/**
+ *	psb_gtt_release_handle	-	release a handle to a GTT map
+ *	@dev: our DRM device
+ *	@gt: Our GTT range
+ *
+ *	Remove the handle from a gtt range object
+ */
+int psb_gtt_release_handle(struct drm_device *dev, struct gtt_range *gt)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	if (gt->handle < 0 || gt->handle >= GTT_MAX) {
+		gt->handle = -1;
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	mutex_lock(&dev_priv->gtt_mutex);
+	dev_priv->gtt_handles[gt->handle] = NULL;
+	gt->handle = -1;
+	mutex_unlock(&dev_priv->gtt_mutex);
+	psb_gtt_kref_put(gt);
+	return 0;
+}
+
+/**
+ *	psb_gtt_lookup_handle	-	look up a GTT handle
+ *	@dev: our DRM device
+ *	@handle: our handle
+ *
+ *	Look up a gtt handle and return the gtt or NULL. The object returned
+ *	has a reference held so the caller must drop this when finished.
+ */
+struct gtt_range *psb_gtt_lookup_handle(struct drm_device *dev, int handle)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct gtt_range *gt;
+
+	if (handle < 0 || handle > GTT_MAX)
+		return ERR_PTR(-EINVAL);
+
+	mutex_lock(&dev_priv->gtt_mutex);
+	gt = dev_priv->gtt_handles[handle];
+	kref_get(&gt->kref);
+	mutex_unlock(&dev_priv->gtt_mutex);
+
+	if (gt == NULL)
+		return ERR_PTR(-ENOENT);
+	return gt;
+}
+
+/**
+ *	psb_gtt_alloc_range	-	allocate GTT address space
+ *	@dev: Our DRM device
+ *	@len: length (bytes) of address space required
+ *	@name: resource name
+ *
+ *	Ask the kernel core to find us a suitable range of addresses
+ *	to use for a GTT mapping.
+ *
+ *	Returns a gtt_range structure describing the object, or NULL on
+ *	error. On successful return the resource is both allocated and marked
+ *	as in use.
+ */
+struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
+							const char *name)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct gtt_range *gt;
+	struct resource *r = dev_priv->gtt_mem;
+	int ret;
+
+	gt = kzalloc(sizeof(struct gtt_range), GFP_KERNEL);
+	if (gt == NULL)
+		return NULL;
+        gt->handle = -1;
+        gt->resource.name = name;
+	kref_init(&gt->kref);
+
+	ret = allocate_resource(dev_priv->gtt_mem, &gt->resource,
+				len, 0, -1, /*r->start, r->end - 1, */
+				PAGE_SIZE, NULL, NULL);
+	if (ret == 0) {
+	        gt->offset = gt->resource.start - r->start;
+		return gt;
+        }
+	kfree(gt);
+	return NULL;
+}
+
+static void psb_gtt_destroy(struct kref *kref)
+{
+	struct gtt_range *gt = container_of(kref, struct gtt_range, kref);
+	release_resource(&gt->resource);
+	kfree(gt);
+}
+
+/**
+ *	psb_gtt_kref_put	-	drop reference to a GTT object
+ *	@gt: the GT being dropped
+ *
+ *	Drop a reference to a psb gtt
+ */
+void psb_gtt_kref_put(struct gtt_range *gt)
+{
+	kref_put(&gt->kref, psb_gtt_destroy);
+}
+
+/**
+ *	psb_gtt_free_range	-	release GTT address space
+ *	@dev: our DRM device
+ *	@gt: a mapping created with psb_gtt_alloc_range
+ *
+ *	Release a resource that was allocated with psb_gtt_alloc_range
+ */
+void psb_gtt_free_range(struct drm_device *dev, struct gtt_range *gt)
+{
+	if (gt->handle != -1)
+		psb_gtt_release_handle(dev, gt);
+	psb_gtt_kref_put(gt);
+}
diff --git a/drivers/staging/gma500/psb_gtt.h b/drivers/staging/gma500/psb_gtt.h
index 5ddc3ae..010ef70 100644
--- a/drivers/staging/gma500/psb_gtt.h
+++ b/drivers/staging/gma500/psb_gtt.h
@@ -80,11 +80,33 @@ extern int psb_gtt_map_meminfo(struct drm_device *dev,
 				uint32_t *offset);
 extern int psb_gtt_unmap_meminfo(struct drm_device *dev,
 				 void * hKernelMemInfo);
-extern int psb_gtt_map_meminfo_ioctl(struct drm_device *dev, void *data,
-				     struct drm_file *file_priv);
-extern int psb_gtt_unmap_meminfo_ioctl(struct drm_device *dev, void *data,
-				       struct drm_file *file_priv);
 extern int psb_gtt_mm_init(struct psb_gtt *pg);
 extern void psb_gtt_mm_takedown(void);
 
+/* Each gtt_range describes an allocation in the GTT area */
+struct gtt_range {
+	struct resource resource;
+	u32 offset;
+	int handle;
+	struct kref kref;
+};
+
+/* Most GTT handles we allow allocation of - for now five is fine: we need
+   - Two framebuffers
+   - Maybe an upload area
+   - One cursor (eventually)
+   - One fence page (possibly)
+*/
+
+#define	GTT_MAX		5
+
+extern int psb_gtt_alloc_handle(struct drm_device *dev, struct gtt_range *gt);
+extern int psb_gtt_release_handle(struct drm_device *dev, struct gtt_range *gt);
+extern struct gtt_range *psb_gtt_lookup_handle(struct drm_device *dev,
+							int handle);
+extern struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
+							const char *name);
+extern void psb_gtt_kref_put(struct gtt_range *gt);
+extern void psb_gtt_free_range(struct drm_device *dev, struct gtt_range *gt);
+
 #endif

