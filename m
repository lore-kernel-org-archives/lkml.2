Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1DSOsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:48:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52964 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753118Ab1DSOsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:48:31 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 2/8] gma500: begin adding GEM
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 19 Apr 2011 15:27:28 +0100
Message-ID: <20110419142716.16479.30257.stgit@localhost.localdomain>
In-Reply-To: <20110419142432.16479.89255.stgit@localhost.localdomain>
References: <20110419142432.16479.89255.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This puts in place the infrastructure for GEM allocators. Our implementation
is fairly simplistic at this point and we don't deal with things like
evicting objects from the GART to make space, nor compaction.

We extent our gtt_range struct to include a GEM object and that allows GEM
to do all the handle management and most of the memory mapping work for us.

This patch also doesn't load GEM pages into the GART so the GEM side isn't
very useful. Before we can do that a fair bit of work is needed reworking the
internal GTT code.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile  |    1 
 drivers/staging/gma500/psb_drv.c |   18 +++
 drivers/staging/gma500/psb_drv.h |   16 +++
 drivers/staging/gma500/psb_fb.c  |  198 ++++++++++++++----------------------
 drivers/staging/gma500/psb_gem.c |  207 ++++++++++++++++++++++++++++++++++++++
 drivers/staging/gma500/psb_gtt.c |   85 +---------------
 drivers/staging/gma500/psb_gtt.h |   17 +--
 7 files changed, 318 insertions(+), 224 deletions(-)
 create mode 100644 drivers/staging/gma500/psb_gem.c

diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index e00557e..0c4f7b6 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -5,6 +5,7 @@ ccflags-y += -Iinclude/drm
 
 psb_gfx-y += psb_bl.o \
 	  psb_drv.o \
+	  psb_gem.o \
 	  psb_fb.o \
 	  psb_2d.o \
 	  psb_gtt.o \
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index d87e00d..d871061 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -1405,9 +1405,15 @@ static const struct dev_pm_ops psb_pm_ops = {
 	.runtime_idle = psb_runtime_idle,
 };
 
+static struct vm_operations_struct psb_gem_vm_ops = {
+	.fault = psb_gem_fault,
+	.open = drm_gem_vm_open,
+	.close = drm_gem_vm_close,
+};
+
 static struct drm_driver driver = {
 	.driver_features = DRIVER_HAVE_IRQ | DRIVER_IRQ_SHARED | \
-			   DRIVER_IRQ_VBL | DRIVER_MODESET,
+			   DRIVER_IRQ_VBL | DRIVER_MODESET| DRIVER_GEM ,
 	.load = psb_driver_load,
 	.unload = psb_driver_unload,
 
@@ -1421,13 +1427,19 @@ static struct drm_driver driver = {
 	.enable_vblank = psb_enable_vblank,
 	.disable_vblank = psb_disable_vblank,
 	.get_vblank_counter = psb_get_vblank_counter,
-	.firstopen = NULL,
 	.lastclose = psb_lastclose,
 	.open = psb_driver_open,
+	.preclose = psb_driver_preclose,
 	.postclose = psb_driver_close,
 	.reclaim_buffers = drm_core_reclaim_buffers,
 
-	.preclose = psb_driver_preclose,
+	.gem_init_object = psb_gem_init_object,
+	.gem_free_object = psb_gem_free_object,
+	.gem_vm_ops = &psb_gem_vm_ops,
+	.dumb_create = psb_gem_dumb_create,
+	.dumb_map_offset = psb_gem_dumb_map_gtt,
+	.dumb_destroy = psb_gem_dumb_destroy,
+
 	.fops = {
 		 .owner = THIS_MODULE,
 		 .open = psb_open,
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 9da6a33..aa68ae7 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -243,7 +243,6 @@ struct drm_psb_private {
 
 	struct mutex gtt_mutex;
 	struct resource *gtt_mem;	/* Our PCI resource */
-	struct gtt_range *gtt_handles[GTT_MAX];
 
 	struct psb_mmu_driver *mmu;
 	struct psb_mmu_pd *pf_pd;
@@ -627,9 +626,22 @@ extern const struct drm_connector_helper_funcs
 					psb_intel_lvds_connector_helper_funcs;
 extern const struct drm_connector_funcs psb_intel_lvds_connector_funcs;
 
+/* psb_gem.c */
+extern int psb_gem_init_object(struct drm_gem_object *obj);
+extern void psb_gem_free_object(struct drm_gem_object *obj);
+extern int psb_gem_get_aperture(struct drm_device *dev, void *data,
+				struct drm_file *file);
+extern int psb_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
+			struct drm_mode_create_dumb *args);
+extern int psb_gem_dumb_destroy(struct drm_file *file, struct drm_device *dev,
+			uint32_t handle);
+extern int psb_gem_dumb_map_gtt(struct drm_file *file, struct drm_device *dev,
+			 uint32_t handle, uint64_t *offset);
+extern int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
+
 
 /*
- *Debug print bits setting
+ * Debug print bits setting
  */
 #define PSB_D_GENERAL (1 << 0)
 #define PSB_D_INIT    (1 << 1)
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index e06365b..ffbbbb6 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -264,7 +264,7 @@ static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 						VM_MIXEDMAP | VM_DONTEXPAND;
 	} else {
 	        /* GTT memory backed by kernel/user pages, needs a different
-	           approach ? */
+	           approach ? - GEM ? */
 	}
 
 	return 0;
@@ -337,122 +337,13 @@ err:
 	return NULL;
 }
 
-static struct drm_framebuffer *psb_user_framebuffer_create
-			(struct drm_device *dev, struct drm_file *filp,
-			 struct drm_mode_fb_cmd *r)
-{
-        return NULL;
-#if 0
-	struct ttm_buffer_object *bo = NULL;
-	uint64_t size;
-
-	bo = ttm_buffer_object_lookup(psb_fpriv(filp)->tfile, r->handle);
-	if (!bo)
-		return NULL;
-
-	/* JB: TODO not drop, make smarter */
-	size = ((uint64_t) bo->num_pages) << PAGE_SHIFT;
-	if (size < r->width * r->height * 4)
-		return NULL;
-
-	/* JB: TODO not drop, refcount buffer */
-	return psb_framebuffer_create(dev, r, bo);
-
-	struct psb_framebuffer *psbfb;
-	struct drm_framebuffer *fb;
-	struct fb_info *info;
-	void *psKernelMemInfo = NULL;
-	void * hKernelMemInfo = (void *)r->handle;
-	struct drm_psb_private *dev_priv
-		= (struct drm_psb_private *)dev->dev_private;
-	struct psb_fbdev *fbdev = dev_priv->fbdev;
-	struct psb_gtt *pg = dev_priv->pg;
-	int ret;
-	uint32_t offset;
-	uint64_t size;
-
-	ret = psb_get_meminfo_by_handle(hKernelMemInfo, &psKernelMemInfo);
-	if (ret) {
-		DRM_ERROR("Cannot get meminfo for handle 0x%x\n",
-						(u32)hKernelMemInfo);
-		return NULL;
-	}
-
-	DRM_DEBUG("Got Kernel MemInfo for handle %lx\n",
-		  (u32)hKernelMemInfo);
-
-	/* JB: TODO not drop, make smarter */
-	size = psKernelMemInfo->ui32AllocSize;
-	if (size < r->height * r->pitch)
-		return NULL;
-
-	/* JB: TODO not drop, refcount buffer */
-	/* return psb_framebuffer_create(dev, r, bo); */
-
-	fb = psb_framebuffer_create(dev, r, (void *)psKernelMemInfo);
-	if (!fb) {
-		DRM_ERROR("failed to allocate fb.\n");
-		return NULL;
-	}
-
-	psbfb = to_psb_fb(fb);
-	psbfb->size = size;
-	psbfb->hKernelMemInfo = hKernelMemInfo;
-
-	DRM_DEBUG("Mapping to gtt..., KernelMemInfo %p\n", psKernelMemInfo);
-
-	/*if not VRAM, map it into tt aperture*/
-	if (psKernelMemInfo->pvLinAddrKM != pg->vram_addr) {
-		ret = psb_gtt_map_meminfo(dev, hKernelMemInfo, &offset);
-		if (ret) {
-			DRM_ERROR("map meminfo for 0x%x failed\n",
-				  (u32)hKernelMemInfo);
-			return NULL;
-		}
-		psbfb->offset = (offset << PAGE_SHIFT);
-	} else {
-		psbfb->offset = 0;
-	}
-	info = framebuffer_alloc(0, &dev->pdev->dev);
-	if (!info)
-		return NULL;
-
-	strcpy(info->fix.id, "psbfb");
-
-	info->flags = FBINFO_DEFAULT;
-	info->fix.accel = FB_ACCEL_I830;	/*FIXMEAC*/
-	info->fbops = &psbfb_ops;
-
-	info->fix.smem_start = dev->mode_config.fb_base;
-	info->fix.smem_len = size;
-
-	info->screen_base = psKernelMemInfo->pvLinAddrKM;
-	info->screen_size = size;
-
-	drm_fb_helper_fill_fix(info, fb->pitch, fb->depth);
-	drm_fb_helper_fill_var(info, &fbdev->psb_fb_helper,
-							fb->width, fb->height);
-
-	info->fix.mmio_start = pci_resource_start(dev->pdev, 0);
-	info->fix.mmio_len = pci_resource_len(dev->pdev, 0);
-
-	info->pixmap.size = 64 * 1024;
-	info->pixmap.buf_align = 8;
-	info->pixmap.access_align = 32;
-	info->pixmap.flags = FB_PIXMAP_SYSTEM;
-	info->pixmap.scan_align = 1;
-
-	psbfb->fbdev = info;
-	fbdev->pfb = psbfb;
-
-	fbdev->psb_fb_helper.fb = fb;
-	fbdev->psb_fb_helper.fbdev = info;
-	MRSTLFBHandleChangeFB(dev, psbfb);
-
-	return fb;
-#endif
-}
-
+/**
+ *	psbfb_create		-	create a framebuffer
+ *	@fbdev: the framebuffer device
+ *	@sizes: specification of the layout
+ *
+ *	Create a framebuffer to the specifications provided
+ */
 static int psbfb_create(struct psb_fbdev *fbdev,
 				struct drm_fb_helper_surface_size *sizes)
 {
@@ -552,6 +443,47 @@ out_err1:
 	return ret;
 }
 
+/**
+ *	psb_user_framebuffer_create	-	create framebuffer
+ *	@dev: our DRM device
+ *	@filp: client file
+ *	@cmd: mode request
+ *
+ *	Create a new framebuffer backed by a userspace GEM object
+ */
+static struct drm_framebuffer *psb_user_framebuffer_create
+			(struct drm_device *dev, struct drm_file *filp,
+			 struct drm_mode_fb_cmd *cmd)
+{
+        struct gtt_range *r;
+        struct drm_gem_object *obj;
+        struct psb_framebuffer *psbfb;
+
+        /* Find the GEM object and thus the gtt range object that is
+           to back this space */
+	obj = drm_gem_object_lookup(dev, filp, cmd->handle);
+	if (obj == NULL)
+	        return ERR_PTR(-ENOENT);
+
+        /* Allocate a framebuffer */
+        psbfb = kzalloc(sizeof(*psbfb), GFP_KERNEL);
+        if (psbfb == NULL) {
+                drm_gem_object_unreference_unlocked(obj);
+                return ERR_PTR(-ENOMEM);
+        }
+        
+        /* Let the core code do all the work */
+        r = container_of(obj, struct gtt_range, gem);
+	if (psb_framebuffer_create(dev, cmd, r) == NULL) {
+                drm_gem_object_unreference_unlocked(obj);
+                kfree(psbfb);
+                return ERR_PTR(-EINVAL);
+        }
+        /* Return the drm_framebuffer contained within the psb fbdev which
+           has been initialized by the framebuffer creation */
+        return &psbfb->base;
+}
+
 static void psbfb_gamma_set(struct drm_crtc *crtc, u16 red, u16 green,
 							u16 blue, int regno)
 {
@@ -667,28 +599,46 @@ int psbfb_remove(struct drm_device *dev, struct drm_framebuffer *fb)
 }
 /*EXPORT_SYMBOL(psbfb_remove); */
 
+/**
+ *	psb_user_framebuffer_create_handle - add hamdle to a framebuffer
+ *	@fb: framebuffer
+ *	@file_priv: our DRM file
+ *	@handle: returned handle
+ *
+ *	Our framebuffer object is a GTT range which also contains a GEM
+ *	object. We need to turn it into a handle for userspace. GEM will do
+ *	the work for us
+ */
 static int psb_user_framebuffer_create_handle(struct drm_framebuffer *fb,
 					      struct drm_file *file_priv,
 					      unsigned int *handle)
 {
-	/* JB: TODO currently we can't go from a bo to a handle with ttm */
-	(void) file_priv;
-	*handle = 0;
-	return 0;
+        struct psb_framebuffer *psbfb = to_psb_fb(fb);
+        struct gtt_range *r = psbfb->mem;
+        return drm_gem_handle_create(file_priv, &r->gem, handle);
 }
 
+/**
+ *	psb_user_framebuffer_destroy	-	destruct user created fb
+ *	@fb: framebuffer
+ *
+ *	User framebuffers are backed by GEM objects so all we have to do is
+ *	clean up a bit and drop the reference, GEM will handle the fallout
+ */
 static void psb_user_framebuffer_destroy(struct drm_framebuffer *fb)
 {
 	struct drm_device *dev = fb->dev;
 	struct psb_framebuffer *psbfb = to_psb_fb(fb);
+	struct gtt_range *r = psbfb->mem;
 
-	/*ummap gtt pages*/
-	psb_gtt_unmap_meminfo(dev, psbfb->hKernelMemInfo);
 	if (psbfb->fbdev)
 		psbfb_remove(dev, fb);
 
-	/* JB: TODO not drop, refcount buffer */
+        /* Let DRM do its clean up */
 	drm_framebuffer_cleanup(fb);
+	/*  We are no longer using the resource in GEM */
+	drm_gem_object_unreference_unlocked(&r->gem);
+
 	kfree(fb);
 }
 
diff --git a/drivers/staging/gma500/psb_gem.c b/drivers/staging/gma500/psb_gem.c
new file mode 100644
index 0000000..0438bf4
--- /dev/null
+++ b/drivers/staging/gma500/psb_gem.c
@@ -0,0 +1,207 @@
+/*
+ *  psb backlight interface
+ *
+ * Copyright (c) 2011, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors: Alan Cox
+ *
+ * TODO:
+ *	-	we don't actually put GEM objects into the GART yet
+ *	-	we need to work out if the MMU is relevant as well (eg for
+ *		accelerated operations on a GEM object)
+ *	-	cache coherency
+ *
+ * ie this is just an initial framework to get us going.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include "psb_drm.h"
+#include "psb_drv.h"
+
+int psb_gem_init_object(struct drm_gem_object *obj)
+{
+	return -EINVAL;
+}
+
+void psb_gem_free_object(struct drm_gem_object *obj)
+{
+	drm_gem_object_release(obj);
+}
+
+int psb_gem_get_aperture(struct drm_device *dev, void *data,
+				struct drm_file *file)
+{
+	return -EINVAL;
+}
+
+/**
+ *	psb_gem_dumb_map_gtt	-	buffer mapping for dumb interface
+ *	@file: our drm client file
+ *	@dev: drm device
+ *	@handle: GEM handle to the object (from dumb_create)
+ *
+ *	Do the necessary setup to allow the mapping of the frame buffer
+ *	into user memory. We don't have to do much here at the moment.
+ */
+int psb_gem_dumb_map_gtt(struct drm_file *file, struct drm_device *dev,
+			 uint32_t handle, uint64_t *offset)
+{
+	struct drm_gem_object *obj;
+	if (!(dev->driver->driver_features & DRIVER_GEM))
+		return -ENODEV;
+	/* GEM does all our handle to object mapping */
+	obj = drm_gem_object_lookup(dev, file, handle);
+	if (obj == NULL)
+		return -ENOENT;
+	/* What validation is needed here ? */
+	
+	/* GEM works out the hash offsets for us */
+	*offset = (u64)obj->map_list.hash.key << PAGE_SHIFT;
+	drm_gem_object_unreference(obj);
+	return 0;
+}
+
+/**
+ *	psb_gem_create		-	create a mappable object
+ *	@file: the DRM file of the client
+ *	@dev: our device
+ *	@size: the size requested
+ *	@handlep: returned handle (opaque number)
+ *
+ *	Create a GEM object, fill in the boilerplate and attach a handle to
+ *	it so that userspace can speak about it. This does the core work
+ *	for the various methods that do/will create GEM objects for things
+ */
+static int psb_gem_create(struct drm_file *file,
+	struct drm_device *dev, uint64_t size, uint32_t *handlep)
+{
+	struct gtt_range *r;
+	int ret;
+	u32 handle;
+
+	size = roundup(size, PAGE_SIZE);
+
+	/* Allocate our object - for now a direct gtt range which is not 
+	   stolen memory backed */
+	r = psb_gtt_alloc_range(dev, size, "gem", 0);
+	if (IS_ERR(r))
+		return PTR_ERR(r);
+	/* Initialize the extra goodies GEM needs to do all the hard work */
+	if (drm_gem_object_init(dev, &r->gem, size) != 0) {
+		psb_gtt_free_range(dev, r);
+		/* GEM doesn't give an error code and we don't have an
+		   EGEMSUCKS so make something up for now - FIXME */
+		return -ENOMEM;
+	}
+	/* Give the object a handle so we can carry it more easily */
+	ret = drm_gem_handle_create(file, &r->gem, &handle);
+	if (ret) {
+		drm_gem_object_release(&r->gem);
+		psb_gtt_free_range(dev, r);
+		return ret;
+	}
+	/* We have the initial and handle reference but need only one now */
+	drm_gem_object_unreference(&r->gem);
+	*handlep = handle;
+	return 0;
+}
+
+/**
+ *	psb_gem_dumb_create	-	create a dumb buffer
+ *	@drm_file: our client file
+ *	@dev: our device
+ *	@args: the requested arguments copied from userspace
+ *
+ *	Allocate a buffer suitable for use for a frame buffer of the
+ *	form described by user space. Give userspace a handle by which
+ *	to reference it.
+ */
+int psb_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
+			struct drm_mode_create_dumb *args)
+{
+	args->pitch = ALIGN(args->width & ((args->bpp + 1) / 8), 64);
+	args->size = args->pitch * args->height;
+	return psb_gem_create(file, dev, args->size, &args->handle);
+}
+
+/**
+ *	psb_gem_dumb_destroy	-	destroy a dumb buffer
+ *	@file: client file
+ *	@dev: our DRM device
+ *	@handle: the object handle
+ *
+ *	Destroy a handle that was created via psb_gem_dumb_create, at least
+ *	we hope it was created that way. i915 seems to assume the caller
+ *	does the checking but that might be worth review ! FIXME
+ */
+int psb_gem_dumb_destroy(struct drm_file *file, struct drm_device *dev,
+			uint32_t handle)
+{
+	/* No special work needed, drop the reference and see what falls out */
+	return drm_gem_handle_delete(file, handle);
+}
+
+/**
+ *	psb_gem_fault		-	pagefault handler for GEM objects
+ *	@vma: the VMA of the GEM object
+ *	@vmf: fault detail
+ *
+ *	Invoked when a fault occurs on an mmap of a GEM managed area. GEM
+ *	does most of the work for us including the actual map/unmap calls
+ *	but we need to do the actual page work.
+ *
+ *	This code eventually needs to handle faulting objects in and out
+ *	of the GART and repacking it when we run out of space. We can put
+ *	that off for now and for our simple uses
+ *
+ *	The VMA was set up by GEM. In doing so it also ensured that the
+ *	vma->vm_private_data points to the GEM object that is backing this
+ *	mapping.
+ */
+int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct drm_gem_object *obj;
+	struct gtt_range *r;
+	int ret;
+	unsigned long pfn;
+	pgoff_t page_offset;
+
+	obj = vma->vm_private_data;	/* GEM object */
+	r = container_of(obj, struct gtt_range, gem);	/* Get the gtt range */
+
+	/* FIXME: Locking. We may also need to repack the GART sometimes */
+
+	/* Page relative to the VMA start */
+	page_offset = ((unsigned long) vmf->virtual_address - vma->vm_start)
+				>> PAGE_SHIFT;
+
+	/* Bus address of the page is gart + object offset + page offset */
+	/* Assumes gtt allocations are page aligned */
+	pfn = (r->resource.start >> PAGE_SHIFT) + page_offset;
+
+	ret = vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
+	switch (ret) {
+	case 0:
+	case -ERESTARTSYS:
+	case -EINTR:
+		return VM_FAULT_NOPAGE;
+	case -ENOMEM:
+		return VM_FAULT_OOM;
+	default:
+		return VM_FAULT_SIGBUS;
+	}
+}
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 69323f9..4846fef 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -887,87 +887,10 @@ int psb_gtt_unmap_meminfo(struct drm_device *dev, void * hKernelMemInfo)
 }
 
 /*
- *	GTT resource allocator
+ *	GTT resource allocator - allocate and manage GTT address space
  */
 
 /**
- *	psb_gtt_alloc_handle	-	allocate a handle to a GTT map
- *	@dev: our DRM device
- *	@gt: Our GTT range
- *
- *	Assign a handle to a gtt range object. For the moment we use a very
- *	simplistic interface.
- */
-int psb_gtt_alloc_handle(struct drm_device *dev, struct gtt_range *gt)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	int h;
-
-	mutex_lock(&dev_priv->gtt_mutex);
-	for (h = 0; h < GTT_MAX; h++) {
-		if (dev_priv->gtt_handles[h] == NULL) {
-			dev_priv->gtt_handles[h] = gt;
-			gt->handle = h;
-			kref_get(&gt->kref);
-			mutex_unlock(&dev_priv->gtt_mutex);
-			return h;
-		}
-	}
-	mutex_unlock(&dev_priv->gtt_mutex);
-	return -ENOSPC;
-}
-
-/**
- *	psb_gtt_release_handle	-	release a handle to a GTT map
- *	@dev: our DRM device
- *	@gt: Our GTT range
- *
- *	Remove the handle from a gtt range object
- */
-int psb_gtt_release_handle(struct drm_device *dev, struct gtt_range *gt)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-
-	if (gt->handle < 0 || gt->handle >= GTT_MAX) {
-		gt->handle = -1;
-		WARN_ON(1);
-		return -EINVAL;
-	}
-	mutex_lock(&dev_priv->gtt_mutex);
-	dev_priv->gtt_handles[gt->handle] = NULL;
-	gt->handle = -1;
-	mutex_unlock(&dev_priv->gtt_mutex);
-	psb_gtt_kref_put(gt);
-	return 0;
-}
-
-/**
- *	psb_gtt_lookup_handle	-	look up a GTT handle
- *	@dev: our DRM device
- *	@handle: our handle
- *
- *	Look up a gtt handle and return the gtt or NULL. The object returned
- *	has a reference held so the caller must drop this when finished.
- */
-struct gtt_range *psb_gtt_lookup_handle(struct drm_device *dev, int handle)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct gtt_range *gt;
-
-	if (handle < 0 || handle > GTT_MAX)
-		return ERR_PTR(-EINVAL);
-
-	mutex_lock(&dev_priv->gtt_mutex);
-	gt = dev_priv->gtt_handles[handle];
-	kref_get(&gt->kref);
-	mutex_unlock(&dev_priv->gtt_mutex);
-
-	if (gt == NULL)
-		return ERR_PTR(-ENOENT);
-	return gt;
-}
-
-/**
  *	psb_gtt_alloc_range	-	allocate GTT address space
  *	@dev: Our DRM device
  *	@len: length (bytes) of address space required
@@ -1003,8 +926,9 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 	gt = kzalloc(sizeof(struct gtt_range), GFP_KERNEL);
 	if (gt == NULL)
 		return NULL;
-        gt->handle = -1;
         gt->resource.name = name;
+        gt->stolen = backed;
+        gt->in_gart = backed;
 	kref_init(&gt->kref);
 
 	ret = allocate_resource(dev_priv->gtt_mem, &gt->resource,
@@ -1020,6 +944,7 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 static void psb_gtt_destroy(struct kref *kref)
 {
 	struct gtt_range *gt = container_of(kref, struct gtt_range, kref);
+	WARN_ON(gt->in_gart && !gt->stolen);
 	release_resource(&gt->resource);
 	kfree(gt);
 }
@@ -1044,7 +969,5 @@ void psb_gtt_kref_put(struct gtt_range *gt)
  */
 void psb_gtt_free_range(struct drm_device *dev, struct gtt_range *gt)
 {
-	if (gt->handle != -1)
-		psb_gtt_release_handle(dev, gt);
 	psb_gtt_kref_put(gt);
 }
diff --git a/drivers/staging/gma500/psb_gtt.h b/drivers/staging/gma500/psb_gtt.h
index dc2259c..1b5bec0 100644
--- a/drivers/staging/gma500/psb_gtt.h
+++ b/drivers/staging/gma500/psb_gtt.h
@@ -87,23 +87,12 @@ extern void psb_gtt_mm_takedown(void);
 struct gtt_range {
 	struct resource resource;
 	u32 offset;
-	int handle;
 	struct kref kref;
+        struct drm_gem_object gem;	/* GEM high level stuff */
+        int in_gart;			/* Currently in the GART */
+        int stolen;			/* Backed from stolen RAM */
 };
 
-/* Most GTT handles we allow allocation of - for now five is fine: we need
-   - Two framebuffers
-   - Maybe an upload area
-   - One cursor (eventually)
-   - One fence page (possibly)
-*/
-
-#define	GTT_MAX		5
-
-extern int psb_gtt_alloc_handle(struct drm_device *dev, struct gtt_range *gt);
-extern int psb_gtt_release_handle(struct drm_device *dev, struct gtt_range *gt);
-extern struct gtt_range *psb_gtt_lookup_handle(struct drm_device *dev,
-							int handle);
 extern struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 						const char *name, int backed);
 extern void psb_gtt_kref_put(struct gtt_range *gt);

