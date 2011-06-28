Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab1F1WFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:05:01 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35047 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1F1WEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:04:54 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 06/29] gma500: revamp frame buffer creation and handling
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:04:30 +0100
Message-ID: <20110628220429.898.69509.stgit@bob.linux.org.uk>
In-Reply-To: <20110628220151.898.15775.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Restructure this to work the same way as the i915 frame buffer does. That
cleans up various chunks of code.

We can now set a mode in modetest but mode restore is a bit iffy

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_2d.c  |   13 +--
 drivers/staging/gma500/psb_fb.c  |  195 +++++++++++++++++++++-----------------
 drivers/staging/gma500/psb_fb.h  |    2 
 drivers/staging/gma500/psb_gem.c |   18 +++-
 drivers/staging/gma500/psb_gtt.c |    2 
 5 files changed, 133 insertions(+), 97 deletions(-)


diff --git a/drivers/staging/gma500/psb_2d.c b/drivers/staging/gma500/psb_2d.c
index 0bd834c..060eeaf 100644
--- a/drivers/staging/gma500/psb_2d.c
+++ b/drivers/staging/gma500/psb_2d.c
@@ -148,7 +148,7 @@ static void psbfb_fillrect_accel(struct fb_info *info,
 				 const struct fb_fillrect *r)
 {
 	struct psb_fbdev *fbdev = info->par;
-	struct psb_framebuffer *psbfb = fbdev->pfb;
+	struct psb_framebuffer *psbfb = &fbdev->pfb;
 	struct drm_device *dev = psbfb->base.dev;
 	struct drm_framebuffer *fb = fbdev->psb_fb_helper.fb;
 	struct drm_psb_private *dev_priv = dev->dev_private;
@@ -291,7 +291,7 @@ static void psbfb_copyarea_accel(struct fb_info *info,
 				 const struct fb_copyarea *a)
 {
 	struct psb_fbdev *fbdev = info->par;
-	struct psb_framebuffer *psbfb = fbdev->pfb;
+	struct psb_framebuffer *psbfb = &fbdev->pfb;
 	struct drm_device *dev = psbfb->base.dev;
 	struct drm_framebuffer *fb = fbdev->psb_fb_helper.fb;
 	struct drm_psb_private *dev_priv = dev->dev_private;
@@ -360,19 +360,12 @@ void psbfb_imageblit(struct fb_info *info, const struct fb_image *image)
 int psbfb_sync(struct fb_info *info)
 {
 	struct psb_fbdev *fbdev = info->par;
-	struct psb_framebuffer *psbfb = fbdev->pfb;
+	struct psb_framebuffer *psbfb = &fbdev->pfb;
 	struct drm_device *dev = psbfb->base.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	unsigned long _end = jiffies + DRM_HZ;
 	int busy = 0;
 
-#if 0
-        /* Just a way to quickly test if cmd issue explodes */
-	u32 test[2] = {
-	        PSB_2D_FENCE_BH,
-        };
-	psbfb_2d_submit(dev_priv, test, 1);
-#endif	
 	/*
 	 * First idle the 2D engine.
 	 */
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 4b05cdc..5977add 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -235,7 +235,7 @@ static struct vm_operations_struct psbfb_vm_ops = {
 static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
 	struct psb_fbdev *fbdev = info->par;
-	struct psb_framebuffer *psbfb = fbdev->pfb;
+	struct psb_framebuffer *psbfb = &fbdev->pfb;
 	char *fb_screen_base = NULL;
 	struct drm_device *dev = psbfb->base.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
@@ -267,7 +267,7 @@ static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 static int psbfb_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg)
 {
 	struct psb_fbdev *fbdev = info->par;
-	struct psb_framebuffer *psbfb = fbdev->pfb;
+	struct psb_framebuffer *psbfb = &fbdev->pfb;
 	struct drm_device *dev = psbfb->base.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 __user *p = (u32 __user *)arg;
@@ -304,8 +304,58 @@ static struct fb_ops psbfb_ops = {
 	.fb_ioctl = psbfb_ioctl,
 };
 
+/**
+ *	psb_framebuffer_init	-	initialize a framebuffer
+ *	@dev: our DRM device
+ *	@fb: framebuffer to set up
+ *	@mode_cmd: mode description
+ *	@gt: backing object
+ *
+ *	Configure and fill in the boilerplate for our frame buffer. Return
+ *	0 on success or an error code if we fail.
+ */
+static int psb_framebuffer_init(struct drm_device *dev,
+                                struct psb_framebuffer *fb,
+                                struct drm_mode_fb_cmd *mode_cmd,
+                                struct gtt_range *gt)
+{
+        int ret;
+
+        if (mode_cmd->pitch & 63)
+                return -EINVAL;
+        switch (mode_cmd->bpp) {
+        case 8:
+        case 16:
+        case 24:
+        case 32:
+                break;
+        default:
+                return -EINVAL;
+        }
+        ret = drm_framebuffer_init(dev, &fb->base, &psb_fb_funcs);
+        if (ret) {
+                dev_err(dev->dev, "framebuffer init failed: %d\n", ret);
+                return ret;
+        }
+        drm_helper_mode_fill_fb_struct(&fb->base, mode_cmd);
+        fb->gtt = gt;
+        return 0;
+}
+                
+/**
+ *	psb_framebuffer_create	-	create a framebuffer backed by gt
+ *	@dev: our DRM device
+ *	@mode_cmd: the description of the requested mode
+ *	@gt: the backing object
+ *
+ *	Create a framebuffer object backed by the gt, and fill in the
+ *	boilerplate required
+ *
+ *	TODO: review object references
+ */
 static struct drm_framebuffer *psb_framebuffer_create
-			(struct drm_device *dev, struct drm_mode_fb_cmd *r,
+			(struct drm_device *dev,
+			 struct drm_mode_fb_cmd *mode_cmd,
 			 struct gtt_range *gt)
 {
 	struct psb_framebuffer *fb;
@@ -313,22 +363,14 @@ static struct drm_framebuffer *psb_framebuffer_create
 
 	fb = kzalloc(sizeof(*fb), GFP_KERNEL);
 	if (!fb)
-		return NULL;
-
-	ret = drm_framebuffer_init(dev, &fb->base, &psb_fb_funcs);
-
-	if (ret)
-		goto err;
-
-	drm_helper_mode_fill_fb_struct(&fb->base, r);
-
-	fb->gtt = gt;
-
-	return &fb->base;
+		return ERR_PTR(-ENOMEM);
 
-err:
-	kfree(fb);
-	return NULL;
+	ret = psb_framebuffer_init(dev, fb, mode_cmd, gt);
+	if (ret) {
+	        kfree(fb);
+	        return ERR_PTR(ret);
+        }
+        return &fb->base;
 }
 
 /**
@@ -380,56 +422,63 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct fb_info *info;
 	struct drm_framebuffer *fb;
-	struct psb_framebuffer *psbfb;
+	struct psb_framebuffer *psbfb = &fbdev->pfb;
 	struct drm_mode_fb_cmd mode_cmd;
 	struct device *device = &dev->pdev->dev;
-	int size, aligned_size;
+	int size;
 	int ret;
 	struct gtt_range *backing;
 
 	mode_cmd.width = sizes->surface_width;
 	mode_cmd.height = sizes->surface_height;
+	mode_cmd.bpp = sizes->surface_bpp;
+
+	/* No 24bit packed */
+	if (mode_cmd.bpp == 24)
+        	mode_cmd.bpp = 32;
 
-	mode_cmd.bpp = 32;
 	/* HW requires pitch to be 64 byte aligned */
-	mode_cmd.pitch =  ALIGN(mode_cmd.width * ((mode_cmd.bpp + 1) / 8), 64);
-	mode_cmd.depth = 24;
+	mode_cmd.pitch =  ALIGN(mode_cmd.width * ((mode_cmd.bpp + 7) / 8), 64);
+	mode_cmd.depth = sizes->surface_depth;
 
 	size = mode_cmd.pitch * mode_cmd.height;
-	aligned_size = ALIGN(size, PAGE_SIZE);
+	size = ALIGN(size, PAGE_SIZE);
 
 	/* Allocate the framebuffer in the GTT with stolen page backing */
-	backing = psbfb_alloc(dev, aligned_size);
+	backing = psbfb_alloc(dev, size);
 	if (backing == NULL)
 	        return -ENOMEM;
 
 	mutex_lock(&dev->struct_mutex);
-	fb = psb_framebuffer_create(dev, &mode_cmd, backing);
-	if (!fb) {
-		DRM_ERROR("failed to allocate fb.\n");
-		ret = -ENOMEM;
-		goto out_err1;
-	}
-	psbfb = to_psb_fb(fb);
 
-	info = framebuffer_alloc(sizeof(struct psb_fbdev), device);
+	info = framebuffer_alloc(0, device);
 	if (!info) {
 		ret = -ENOMEM;
-		goto out_err0;
+		goto out_err1;
 	}
-
 	info->par = fbdev;
 
+	ret = psb_framebuffer_init(dev, psbfb, &mode_cmd, backing);
+	if (ret)
+		goto out_unref;
+
+        fb = &psbfb->base;
 	psbfb->fbdev = info;
 
 	fbdev->psb_fb_helper.fb = fb;
 	fbdev->psb_fb_helper.fbdev = info;
-	fbdev->pfb = psbfb;
 
 	strcpy(info->fix.id, "psbfb");
 
 	info->flags = FBINFO_DEFAULT;
 	info->fbops = &psbfb_ops;
+
+	ret = fb_alloc_cmap(&info->cmap, 256, 0);
+	if (ret) {
+		ret = -ENOMEM;
+		goto out_unref;
+	}
+
 	info->fix.smem_start = dev->mode_config.fb_base;
 	info->fix.smem_len = size;
 
@@ -445,18 +494,18 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 		if (info->screen_base == NULL) {
 			psb_gtt_unpin(backing);
 			ret = -ENOMEM;
-			goto out_err0;
+			goto out_unref;
 		}
 		psbfb->vm_map = 1;
 	}
 	info->screen_size = size;
-	memset(info->screen_base, 0, size);
+/*	memset(info->screen_base, 0, size); */
 
 	if (dev_priv->pg->stolen_size) {
 		info->apertures = alloc_apertures(1);
 		if (!info->apertures) {
 			ret = -ENOMEM;
-			goto out_err0;
+			goto out_unref;
 		}
 		info->apertures->ranges[0].base = dev->mode_config.fb_base;
 		info->apertures->ranges[0].size = dev_priv->pg->stolen_size;
@@ -484,8 +533,14 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	mutex_unlock(&dev->struct_mutex);
 
 	return 0;
-out_err0:
-	fb->funcs->destroy(fb);
+out_unref:
+        if (backing->stolen)
+                psb_gtt_free_range(dev, backing);
+        else {
+                if (psbfb->vm_map)
+                        vm_unmap_ram(info->screen_base, backing->npage);
+                drm_gem_object_unreference(&backing->gem);
+        }
 out_err1:
 	mutex_unlock(&dev->struct_mutex);
 	psb_gtt_free_range(dev, backing);
@@ -506,7 +561,6 @@ static struct drm_framebuffer *psb_user_framebuffer_create
 {
         struct gtt_range *r;
         struct drm_gem_object *obj;
-        struct psb_framebuffer *psbfb;
 
         /* Find the GEM object and thus the gtt range object that is
            to back this space */
@@ -514,23 +568,9 @@ static struct drm_framebuffer *psb_user_framebuffer_create
 	if (obj == NULL)
 	        return ERR_PTR(-ENOENT);
 
-        /* Allocate a framebuffer */
-        psbfb = kzalloc(sizeof(*psbfb), GFP_KERNEL);
-        if (psbfb == NULL) {
-                drm_gem_object_unreference_unlocked(obj);
-                return ERR_PTR(-ENOMEM);
-        }
-        
         /* Let the core code do all the work */
         r = container_of(obj, struct gtt_range, gem);
-	if (psb_framebuffer_create(dev, cmd, r) == NULL) {
-                drm_gem_object_unreference_unlocked(obj);
-                kfree(psbfb);
-                return ERR_PTR(-EINVAL);
-        }
-        /* Return the drm_framebuffer contained within the psb fbdev which
-           has been initialized by the framebuffer creation */
-        return &psbfb->base;
+	return psb_framebuffer_create(dev, cmd, r);
 }
 
 static void psbfb_gamma_set(struct drm_crtc *crtc, u16 red, u16 green,
@@ -572,7 +612,7 @@ struct drm_fb_helper_funcs psb_fb_helper_funcs = {
 int psb_fbdev_destroy(struct drm_device *dev, struct psb_fbdev *fbdev)
 {
 	struct fb_info *info;
-	struct psb_framebuffer *psbfb = fbdev->pfb;
+	struct psb_framebuffer *psbfb = &fbdev->pfb;
 
 	if (fbdev->psb_fb_helper.fbdev) {
 		info = fbdev->psb_fb_helper.fbdev;
@@ -583,6 +623,15 @@ int psb_fbdev_destroy(struct drm_device *dev, struct psb_fbdev *fbdev)
 			vm_unmap_ram(info->screen_base, psbfb->gtt->npage);
 			psb_gtt_unpin(psbfb->gtt);
 		}
+		unregister_framebuffer(info);
+		if (info->cmap.len)
+		        fb_dealloc_cmap(&info->cmap);
+		framebuffer_release(info);
+	}
+	drm_fb_helper_fini(&fbdev->psb_fb_helper);
+	drm_framebuffer_cleanup(&psbfb->base);
+	
+	if (psbfb->gtt) {
 		/* FIXME: this is a bit more inside knowledge than I'd like
 		   but I don't see how to make a fake GEM object of the
 		   stolen space nicely */
@@ -590,13 +639,7 @@ int psb_fbdev_destroy(struct drm_device *dev, struct psb_fbdev *fbdev)
 			psb_gtt_free_range(dev, psbfb->gtt);
 		else
 			drm_gem_object_unreference(&psbfb->gtt->gem);
-		unregister_framebuffer(info);
-		iounmap(info->screen_base);
-		framebuffer_release(info);
-	}
-
-	drm_fb_helper_fini(&fbdev->psb_fb_helper);
-	drm_framebuffer_cleanup(&psbfb->base);
+        }
 	return 0;
 }
 
@@ -644,22 +687,6 @@ static void psbfb_output_poll_changed(struct drm_device *dev)
 	drm_fb_helper_hotplug_event(&fbdev->psb_fb_helper);
 }
 
-int psbfb_remove(struct drm_device *dev, struct drm_framebuffer *fb)
-{
-	struct fb_info *info;
-	struct psb_framebuffer *psbfb = to_psb_fb(fb);
-
-	if (drm_psb_no_fb)
-		return 0;
-
-	info = psbfb->fbdev;
-
-	if (info)
-		framebuffer_release(info);
-	return 0;
-}
-/*EXPORT_SYMBOL(psbfb_remove); */
-
 /**
  *	psb_user_framebuffer_create_handle - add hamdle to a framebuffer
  *	@fb: framebuffer
@@ -690,15 +717,13 @@ static int psb_user_framebuffer_create_handle(struct drm_framebuffer *fb,
  */
 static void psb_user_framebuffer_destroy(struct drm_framebuffer *fb)
 {
-	struct drm_device *dev = fb->dev;
 	struct psb_framebuffer *psbfb = to_psb_fb(fb);
 	struct gtt_range *r = psbfb->gtt;
 
+	/* Should never get stolen memory for a user fb */
+	WARN_ON(r->stolen);
 	pr_err("user framebuffer destroy %p, fbdev %p\n",
 						psbfb, psbfb->fbdev);
-	if (psbfb->fbdev)
-		psbfb_remove(dev, fb);
-
         /* Let DRM do its clean up */
 	drm_framebuffer_cleanup(fb);
 	/*  We are no longer using the resource in GEM */
diff --git a/drivers/staging/gma500/psb_fb.h b/drivers/staging/gma500/psb_fb.h
index 2153c74..fd7e51a 100644
--- a/drivers/staging/gma500/psb_fb.h
+++ b/drivers/staging/gma500/psb_fb.h
@@ -38,7 +38,7 @@ struct psb_framebuffer {
 
 struct psb_fbdev {
 	struct drm_fb_helper psb_fb_helper;
-	struct psb_framebuffer *pfb;
+	struct psb_framebuffer pfb;
 };
 
 
diff --git a/drivers/staging/gma500/psb_gem.c b/drivers/staging/gma500/psb_gem.c
index 98d8ab3..b24b964 100644
--- a/drivers/staging/gma500/psb_gem.c
+++ b/drivers/staging/gma500/psb_gem.c
@@ -51,6 +51,7 @@ void psb_gem_free_object(struct drm_gem_object *obj)
 	}
 	drm_gem_object_release(obj);
 	/* This must occur last as it frees up the memory of the GEM object */
+	pr_err("GEM destroyed %p, %p\n", gtt, obj);
 	psb_gtt_free_range(obj->dev, gtt);
 }
 
@@ -176,21 +177,28 @@ static int psb_gem_create(struct drm_file *file,
 
 	size = roundup(size, PAGE_SIZE);
 
+	dev_err(dev->dev, "GEM creating %lld\n", size);
+
 	/* Allocate our object - for now a direct gtt range which is not 
 	   stolen memory backed */
 	r = psb_gtt_alloc_range(dev, size, "gem", 0);
-	if (r == NULL)
+	if (r == NULL) {
+		dev_err(dev->dev, "no memory for %lld byte GEM object\n", size);
 		return -ENOSPC;
+	}
 	/* Initialize the extra goodies GEM needs to do all the hard work */
 	if (drm_gem_object_init(dev, &r->gem, size) != 0) {
 		psb_gtt_free_range(dev, r);
 		/* GEM doesn't give an error code and we don't have an
 		   EGEMSUCKS so make something up for now - FIXME */
+		dev_err(dev->dev, "GEM init failed for %lld\n", size);
 		return -ENOMEM;
 	}
 	/* Give the object a handle so we can carry it more easily */
 	ret = drm_gem_handle_create(file, &r->gem, &handle);
 	if (ret) {
+		dev_err(dev->dev, "GEM handle failed for %p, %lld\n",
+							&r->gem, size);
 		drm_gem_object_release(&r->gem);
 		psb_gtt_free_range(dev, r);
 		return ret;
@@ -198,6 +206,8 @@ static int psb_gem_create(struct drm_file *file,
 	/* We have the initial and handle reference but need only one now */
 	drm_gem_object_unreference(&r->gem);
 	*handlep = handle;
+	dev_err(dev->dev, "GEM handle %x for %p OK\n",
+				handle, &r->gem);
 	return 0;
 }
 
@@ -273,9 +283,12 @@ int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	   something from beneath our feet */
 	mutex_lock(&dev->struct_mutex);
 
+	dev_err(dev->dev, "Fault on GTT %p\n", r);
+
 	/* For now the mmap pins the object and it stays pinned. As things
 	   stand that will do us no harm */
 	if (r->mmapping == 0) {
+		dev_err(dev->dev, "Need to pin %p\n", r);
 		ret = psb_gtt_pin(r);
 		if (ret < 0) {
 		        DRM_ERROR("gma500: pin failed: %d\n", ret);
@@ -289,10 +302,13 @@ int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	page_offset = ((unsigned long) vmf->virtual_address - vma->vm_start)
 				>> PAGE_SHIFT;
 
+	dev_err(dev->dev, "Page offset %p %d\n", r, (int)page_offset);
         /* CPU view of the page, don't go via the GART for CPU writes */
 	pfn = page_to_phys(r->pages[page_offset]) >> PAGE_SHIFT;
 	ret = vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
 
+	dev_err(dev->dev, "PFN %ld for VA %p = %d\n", pfn, vmf->virtual_address, ret);
+
 fail:
         mutex_unlock(&dev->struct_mutex);
 	switch (ret) {
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 5a296e1..c6a7492 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -314,6 +314,7 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 				len, start, end, PAGE_SIZE, NULL, NULL);
 	if (ret == 0) {
 		gt->offset = gt->resource.start - r->start;
+		dev_err(dev->dev, "GTT new %p, %d\n", gt, gt->stolen);
 		return gt;
 	}
 	kfree(gt);
@@ -340,6 +341,7 @@ static void psb_gtt_destroy(struct kref *kref)
 	}
 	WARN_ON(gt->in_gart && !gt->stolen);
 	release_resource(&gt->resource);
+	pr_err("GTT destroyed %p, %d\n", gt, gt->stolen);
 	kfree(gt);
 }
 

