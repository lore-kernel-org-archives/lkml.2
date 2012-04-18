Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab2DRNy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:54:29 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34148 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2DRNy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:54:27 -0400
From: Rob Clark <rob.clark@linaro.org>
To: linaro-mm-sig@lists.linaro.org
Cc: patches@linaro.org, linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        rebecca@android.com, Rob Clark <rob@ti.com>
Subject: [PATCH] WIP: staging: drm/omap: dmabuf/prime mmap support
Date: Wed, 18 Apr 2012 08:54:20 -0500
Message-Id: <1334757260-16351-1-git-send-email-rob.clark@linaro.org>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Clark <rob@ti.com>

There are still a few places to cleanup, and possibly things can be
made a bit easier for individual drm drivers by some helpers in drm
core.  But this is enough for a proof of concept.

With this, I can allocate cached buffers, fill them w/ software from
userspace, and on kernel side with fault handling and PTE shootdown
track which pages must be flushed to simulate coherency.

Fyi, you can find my kernel branch, with this patch on top of Daniel's
dmabuf mmap patch, here:

https://github.com/robclark/kernel-omap4/commits/dmabuf/mmap
---
 drivers/staging/omapdrm/omap_drv.h        |    4 +
 drivers/staging/omapdrm/omap_fb.c         |    6 +-
 drivers/staging/omapdrm/omap_gem.c        |   99 ++++++++++++++++++++++++++---
 drivers/staging/omapdrm/omap_gem_dmabuf.c |   45 +++++++++++++
 4 files changed, 142 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_drv.h b/drivers/staging/omapdrm/omap_drv.h
index 2b41152..5812e20 100644
--- a/drivers/staging/omapdrm/omap_drv.h
+++ b/drivers/staging/omapdrm/omap_drv.h
@@ -138,6 +138,8 @@ int omap_gem_dumb_destroy(struct drm_file *file, struct drm_device *dev,
 int omap_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
 		struct drm_mode_create_dumb *args);
 int omap_gem_mmap(struct file *filp, struct vm_area_struct *vma);
+int omap_gem_mmap_obj(struct drm_gem_object *obj,
+		struct vm_area_struct *vma);
 int omap_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
 int omap_gem_op_start(struct drm_gem_object *obj, enum omap_gem_op op);
 int omap_gem_op_finish(struct drm_gem_object *obj, enum omap_gem_op op);
@@ -145,6 +147,8 @@ int omap_gem_op_sync(struct drm_gem_object *obj, enum omap_gem_op op);
 int omap_gem_op_async(struct drm_gem_object *obj, enum omap_gem_op op,
 		void (*fxn)(void *arg), void *arg);
 int omap_gem_roll(struct drm_gem_object *obj, uint32_t roll);
+int omap_gem_dma_sync(struct drm_gem_object *obj,
+		enum dma_data_direction dir);
 int omap_gem_get_paddr(struct drm_gem_object *obj,
 		dma_addr_t *paddr, bool remap);
 int omap_gem_put_paddr(struct drm_gem_object *obj);
diff --git a/drivers/staging/omapdrm/omap_fb.c b/drivers/staging/omapdrm/omap_fb.c
index 04b235b..ac32b3d 100644
--- a/drivers/staging/omapdrm/omap_fb.c
+++ b/drivers/staging/omapdrm/omap_fb.c
@@ -197,8 +197,10 @@ int omap_framebuffer_replace(struct drm_framebuffer *a,
 			pa->paddr = 0;
 		}
 
-		if (pb && !ret)
-			ret = omap_gem_get_paddr(pb->bo, &pb->paddr, true);
+		if (pb && !ret) {
+			ret = omap_gem_get_paddr(pb->bo, &pb->paddr, true) ||
+					omap_gem_dma_sync(pb->bo, DMA_TO_DEVICE);
+		}
 	}
 
 	if (ret) {
diff --git a/drivers/staging/omapdrm/omap_gem.c b/drivers/staging/omapdrm/omap_gem.c
index c5ba334..be7f6c0 100644
--- a/drivers/staging/omapdrm/omap_gem.c
+++ b/drivers/staging/omapdrm/omap_gem.c
@@ -212,8 +212,11 @@ static DEFINE_SPINLOCK(sync_lock);
 /** ensure backing pages are allocated */
 static int omap_gem_attach_pages(struct drm_gem_object *obj)
 {
+	struct drm_device *dev = obj->dev;
 	struct omap_gem_object *omap_obj = to_omap_bo(obj);
 	struct page **pages;
+	int i, npages = obj->size >> PAGE_SHIFT;
+	dma_addr_t *addrs;
 
 	WARN_ON(omap_obj->pages);
 
@@ -231,16 +234,18 @@ static int omap_gem_attach_pages(struct drm_gem_object *obj)
 	 * DSS, GPU, etc. are not cache coherent:
 	 */
 	if (omap_obj->flags & (OMAP_BO_WC|OMAP_BO_UNCACHED)) {
-		int i, npages = obj->size >> PAGE_SHIFT;
-		dma_addr_t *addrs = kmalloc(npages * sizeof(addrs), GFP_KERNEL);
+		addrs = kmalloc(npages * sizeof(addrs), GFP_KERNEL);
 		for (i = 0; i < npages; i++) {
-			addrs[i] = dma_map_page(obj->dev->dev, pages[i],
+			addrs[i] = dma_map_page(dev->dev, pages[i],
 					0, PAGE_SIZE, DMA_BIDIRECTIONAL);
 		}
-		omap_obj->addrs = addrs;
+	} else {
+		addrs = kzalloc(npages * sizeof(addrs), GFP_KERNEL);
 	}
 
+	omap_obj->addrs = addrs;
 	omap_obj->pages = pages;
+
 	return 0;
 }
 
@@ -258,10 +263,11 @@ static void omap_gem_detach_pages(struct drm_gem_object *obj)
 			dma_unmap_page(obj->dev->dev, omap_obj->addrs[i],
 					PAGE_SIZE, DMA_BIDIRECTIONAL);
 		}
-		kfree(omap_obj->addrs);
-		omap_obj->addrs = NULL;
 	}
 
+	kfree(omap_obj->addrs);
+	omap_obj->addrs = NULL;
+
 	_drm_gem_put_pages(obj, omap_obj->pages, true, false);
 	omap_obj->pages = NULL;
 }
@@ -336,6 +342,13 @@ static int fault_1d(struct drm_gem_object *obj,
 			vma->vm_start) >> PAGE_SHIFT;
 
 	if (omap_obj->pages) {
+		if ((omap_obj->flags & OMAP_BO_CACHE_MASK) == OMAP_BO_CACHED) {
+			if (omap_obj->addrs[pgoff]) {
+				dma_unmap_page(obj->dev->dev, omap_obj->addrs[pgoff],
+						PAGE_SIZE, DMA_BIDIRECTIONAL);
+				omap_obj->addrs[pgoff] = 0;
+			}
+		}
 		pfn = page_to_pfn(omap_obj->pages[pgoff]);
 	} else {
 		BUG_ON(!(omap_obj->flags & OMAP_BO_DMA));
@@ -510,7 +523,6 @@ fail:
 /** We override mainly to fix up some of the vm mapping flags.. */
 int omap_gem_mmap(struct file *filp, struct vm_area_struct *vma)
 {
-	struct omap_gem_object *omap_obj;
 	int ret;
 
 	ret = drm_gem_mmap(filp, vma);
@@ -519,8 +531,14 @@ int omap_gem_mmap(struct file *filp, struct vm_area_struct *vma)
 		return ret;
 	}
 
-	/* after drm_gem_mmap(), it is safe to access the obj */
-	omap_obj = to_omap_bo(vma->vm_private_data);
+	return omap_gem_mmap_obj(vma->vm_private_data, vma);
+}
+
+
+int omap_gem_mmap_obj(struct drm_gem_object *obj,
+		struct vm_area_struct *vma)
+{
+	struct omap_gem_object *omap_obj = to_omap_bo(obj);
 
 	vma->vm_flags &= ~VM_PFNMAP;
 	vma->vm_flags |= VM_MIXEDMAP;
@@ -530,12 +548,34 @@ int omap_gem_mmap(struct file *filp, struct vm_area_struct *vma)
 	} else if (omap_obj->flags & OMAP_BO_UNCACHED) {
 		vma->vm_page_prot = pgprot_noncached(vm_get_page_prot(vma->vm_flags));
 	} else {
+		/*
+		 * We do have some private objects, at least for scanout buffers
+		 * on hardware without DMM/TILER.  But these are allocated write-
+		 * combine
+		 */
+		if (WARN_ON(!obj->filp))
+			return -EINVAL;
+
+		// TODO quick hack to avoid needing to re-invent my own vmops:
+		WARN_ON(obj->filp->private_data);
+		obj->filp->private_data = vma->vm_file->private_data;
+		fput(vma->vm_file);
+		get_file(obj->filp);
+
+		/*
+		 * Shunt off cached objs to shmem file so they have their own
+		 * address_space (so unmap_mapping_range does what we want)
+		 */
+		vma->vm_pgoff = 0;
+		vma->vm_file  = obj->filp;
+
 		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	}
 
-	return ret;
+	return 0;
 }
 
+
 /**
  * omap_gem_dumb_create	-	create a dumb buffer
  * @drm_file: our client file
@@ -645,6 +685,44 @@ fail:
 	return ret;
 }
 
+int omap_gem_dma_sync(struct drm_gem_object *obj,
+		enum dma_data_direction dir)
+{
+	struct drm_device *dev = obj->dev;
+	struct omap_gem_object *omap_obj = to_omap_bo(obj);
+	int ret = 0;
+
+	// TODO not sure if I want this to be automagic or new flag set
+	// when allocating buffer (or maybe instead a flag to explictly
+	// disable?
+
+	if ((omap_obj->flags & OMAP_BO_CACHE_MASK) == OMAP_BO_CACHED) {
+		int i, npages = obj->size >> PAGE_SHIFT;
+		struct page **pages = omap_obj->pages;
+		bool dirty = false;
+
+		if (WARN_ON(!obj->filp))
+			return -EINVAL;
+
+		for (i = 0; i < npages; i++) {
+			if (!omap_obj->addrs[i]) {
+				// TODO using BIDIRECTIONAL for now because in the
+				// fault handler we don't really know the direction..
+				omap_obj->addrs[i] = dma_map_page(dev->dev, pages[i], 0,
+						PAGE_SIZE, DMA_BIDIRECTIONAL);
+				dirty = true;
+			}
+		}
+
+		if (dirty) {
+			unmap_mapping_range(obj->filp->f_mapping, 0,
+					omap_gem_mmap_size(obj), 1);
+		}
+	}
+
+	return ret;
+}
+
 /* Get physical address for DMA.. if 'remap' is true, and the buffer is not
  * already contiguous, remap it to pin in physically contiguous memory.. (ie.
  * map in TILER)
@@ -709,6 +787,7 @@ int omap_gem_get_paddr(struct drm_gem_object *obj,
 		*paddr = omap_obj->paddr;
 	} else {
 		ret = -EINVAL;
+		goto fail;
 	}
 
 fail:
diff --git a/drivers/staging/omapdrm/omap_gem_dmabuf.c b/drivers/staging/omapdrm/omap_gem_dmabuf.c
index 2fa39e8..85a0b1c 100644
--- a/drivers/staging/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/staging/omapdrm/omap_gem_dmabuf.c
@@ -34,6 +34,8 @@ static struct sg_table *omap_gem_map_dma_buf(
 	if (!sg)
 		return ERR_PTR(-ENOMEM);
 
+	omap_gem_dma_sync(obj, dir);
+
 	/* camera, etc, need physically contiguous.. but we need a
 	 * better way to know this..
 	 */
@@ -131,6 +133,48 @@ static void omap_gem_dmabuf_kunmap(struct dma_buf *buffer,
 	kunmap(pages[page_num]);
 }
 
+/* TODO: perhaps this could be a helper: */
+static int omap_gem_dmabuf_mmap(struct dma_buf *buffer,
+		struct vm_area_struct *vma)
+{
+	struct drm_gem_object *obj = buffer->priv;
+	int ret = 0;
+
+	if (WARN_ON(!obj->filp))
+		return -EINVAL;
+
+	// TODO maybe we can split up drm_gem_mmap to avoid duplicating
+	// some here.. or at least have a drm_dmabuf helper..
+
+	/* Check for valid size. */
+	if (omap_gem_mmap_size(obj) < vma->vm_end - vma->vm_start) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (!obj->dev->driver->gem_vm_ops) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	vma->vm_flags |= VM_RESERVED | VM_IO | VM_PFNMAP | VM_DONTEXPAND;
+	vma->vm_ops = obj->dev->driver->gem_vm_ops;
+	vma->vm_private_data = obj;
+	vma->vm_page_prot =  pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+
+	/* Take a ref for this mapping of the object, so that the fault
+	 * handler can dereference the mmap offset's pointer to the object.
+	 * This reference is cleaned up by the corresponding vm_close
+	 * (which should happen whether the vma was created by this call, or
+	 * by a vm_open due to mremap or partial unmap or whatever).
+	 */
+	vma->vm_ops->open(vma);
+
+out_unlock:
+
+	return omap_gem_mmap_obj(obj, vma);
+}
+
 struct dma_buf_ops omap_dmabuf_ops = {
 		.map_dma_buf = omap_gem_map_dma_buf,
 		.unmap_dma_buf = omap_gem_unmap_dma_buf,
@@ -141,6 +185,7 @@ struct dma_buf_ops omap_dmabuf_ops = {
 		.kunmap_atomic = omap_gem_dmabuf_kunmap_atomic,
 		.kmap = omap_gem_dmabuf_kmap,
 		.kunmap = omap_gem_dmabuf_kunmap,
+		.mmap = omap_gem_dmabuf_mmap,
 };
 
 struct dma_buf * omap_gem_prime_export(struct drm_device *dev,
-- 
1.7.9.1

