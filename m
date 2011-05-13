Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab1EMK20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:28:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35810 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751978Ab1EMK2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:28:24 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 2/2] gma500: finish off the fault handler
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 13 May 2011 11:09:32 +0100
Message-ID: <20110513100837.10267.73332.stgit@localhost.localdomain>
In-Reply-To: <20110513100808.10267.77941.stgit@localhost.localdomain>
References: <20110513100808.10267.77941.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GEM wants to mmap the object through the GTT (which avoids aliasing) so we
need to put the object into the GTT before we provide the fault mapping for
it.

While we are at it update the pin interface so that it digs dev out of the
GEM object itself. This provides a rather cleaner API and call environment.
Fix th refcount/on-off confusion in the pin API.

At this point we get a bit further with modetest but if we write to the
new GEM mapping we hang solid and as yet I don't know why.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_gem.c           |   35 ++++++++++++++++-
 drivers/staging/gma500/psb_gtt.c           |   59 +++++++++++++++++++++++-----
 drivers/staging/gma500/psb_gtt.h           |    5 +-
 drivers/staging/gma500/psb_intel_display.c |   14 +++----
 4 files changed, 93 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/gma500/psb_gem.c b/drivers/staging/gma500/psb_gem.c
index 2132fe9..76ff7ba 100644
--- a/drivers/staging/gma500/psb_gem.c
+++ b/drivers/staging/gma500/psb_gem.c
@@ -1,5 +1,5 @@
 /*
- *  psb backlight interface
+ *  psb GEM interface
  *
  * Copyright (c) 2011, Intel Corporation.
  *
@@ -251,6 +251,14 @@ int psb_gem_dumb_destroy(struct drm_file *file, struct drm_device *dev,
  *	The VMA was set up by GEM. In doing so it also ensured that the
  *	vma->vm_private_data points to the GEM object that is backing this
  *	mapping.
+ *
+ *	To avoid aliasing and cache funnies we want to map the object
+ *	through the GART. For the moment this is slightly hackish. It would
+ *	be nicer if GEM provided mmap opened/closed hooks for us giving
+ *	the object so that we could track things nicely. That needs changes
+ *	to the core GEM code so must be tackled post staging
+ *
+ *	FIXME
  */
 int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
@@ -259,10 +267,28 @@ int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	int ret;
 	unsigned long pfn;
 	pgoff_t page_offset;
+	struct drm_device *dev;
 
 	obj = vma->vm_private_data;	/* GEM object */
+	dev = obj->dev;
+
 	r = container_of(obj, struct gtt_range, gem);	/* Get the gtt range */
 
+	/* Make sure we don't parallel update on a fault, nor move or remove
+	   something from beneath our feet */
+	mutex_lock(&dev->struct_mutex);
+
+	/* For now the mmap pins the object and it stays pinned. As things
+	   stand that will do us no harm */
+	if (r->mmapping == 0) {
+		ret = psb_gtt_pin(r);
+		if (ret < 0) {
+		        DRM_ERROR("gma500: pin failed: %d\n", ret);
+		        goto fail;
+                }
+		r->mmapping = 1;
+	}
+
 	/* FIXME: Locking. We may also need to repack the GART sometimes */
 
 	/* Page relative to the VMA start */
@@ -273,7 +299,14 @@ int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	/* Assumes gtt allocations are page aligned */
 	pfn = (r->resource.start >> PAGE_SHIFT) + page_offset;
 
+	pr_debug("Object GTT base at %p\n", (void *)(r->resource.start));
+	pr_debug("Inserting %p pfn %lx, pa %lx\n", vmf->virtual_address,
+	        pfn, pfn << PAGE_SHIFT);
+
 	ret = vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
+
+fail:
+        mutex_unlock(&dev->struct_mutex);
 	switch (ret) {
 	case 0:
 	case -ERESTARTSYS:
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index dc0a4b7..74c5a65 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -78,6 +78,7 @@ u32 *psb_gtt_entry(struct drm_device *dev, struct gtt_range *r)
  */
 static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 {
+        struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 *gtt_slot, pte;
 	int numpages = (r->resource.end + 1 - r->resource.start) >> PAGE_SHIFT;
 	struct page **pages;
@@ -93,6 +94,9 @@ static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 	gtt_slot = psb_gtt_entry(dev, r);
 	pages = r->pages;
 
+	/* Make sure we have no alias present */
+	wbinvd();
+
 	/* Write our page entries into the GART itself */
 	for (i = 0; i < numpages; i++) {
 		pte = psb_gtt_mask_pte(page_to_pfn(*pages++), 0/*type*/);
@@ -101,8 +105,6 @@ static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 	/* Make sure all the entries are set before we return */
 	ioread32(gtt_slot - 1);
 	
-	r->in_gart = 1;
-
 	return 0;
 }
 
@@ -130,8 +132,6 @@ static void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
 	for (i = 0; i < numpages; i++)
 		iowrite32(pte, gtt_slot++);
 	ioread32(gtt_slot - 1);
-	
-	r->in_gart = 0;
 }
 
 /**
@@ -140,6 +140,8 @@ static void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
  *
  *	Pin and build an in kernel list of the pages that back our GEM object.
  *	While we hold this the pages cannot be swapped out
+ *
+ *	FIXME: Do we need to cache flush when we update the GTT
  */
 static int psb_gtt_attach_pages(struct gtt_range *gt)
 {
@@ -183,6 +185,8 @@ err:
  *	Undo the effect of psb_gtt_attach_pages. At this point the pages
  *	must have been removed from the GART as they could now be paged out
  *	and move bus address.
+ *
+ *	FIXME: Do we need to cache flush when we update the GTT
  */
 static void psb_gtt_detach_pages(struct gtt_range *gt)
 {
@@ -199,13 +203,20 @@ static void psb_gtt_detach_pages(struct gtt_range *gt)
 	gt->pages = NULL;
 }
 
-/*
- *	Manage pinning of resources into the GART
+/**
+ *	psb_gtt_pin		-	pin pages into the GTT
+ *	@gt: range to pin
+ *
+ *	Pin a set of pages into the GTT. The pins are refcounted so that
+ *	multiple pins need multiple unpins to undo.
+ *
+ *	Non GEM backed objects treat this as a no-op as they are always GTT
+ *	backed objects.
  */
-
-int psb_gtt_pin(struct drm_device *dev, struct gtt_range *gt)
+int psb_gtt_pin(struct gtt_range *gt)
 {
 	int ret;
+	struct drm_device *dev = gt->gem.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 
 	mutex_lock(&dev_priv->gtt_mutex);
@@ -226,8 +237,20 @@ out:
 	return ret;
 }
 
-void psb_gtt_unpin(struct drm_device *dev, struct gtt_range *gt)
+/**
+ *	psb_gtt_unpin		-	Drop a GTT pin requirement
+ *	@gt: range to pin
+ *
+ *	Undoes the effect of psb_gtt_pin. On the last drop the GEM object
+ *	will be removed from the GTT which will also drop the page references
+ *	and allow the VM to clean up or page stuff.
+ *
+ *	Non GEM backed objects treat this as a no-op as they are always GTT
+ *	backed objects.
+ */
+void psb_gtt_unpin(struct gtt_range *gt)
 {
+	struct drm_device *dev = gt->gem.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 
 	mutex_lock(&dev_priv->gtt_mutex);
@@ -239,7 +262,6 @@ void psb_gtt_unpin(struct drm_device *dev, struct gtt_range *gt)
 		psb_gtt_remove(dev, gt);
 		psb_gtt_detach_pages(gt);
 	}
-
 	mutex_unlock(&dev_priv->gtt_mutex);
 }
 	
@@ -286,6 +308,8 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
         gt->resource.name = name;
         gt->stolen = backed;
         gt->in_gart = backed;
+        /* Ensure this is set for non GEM objects */
+        gt->gem.dev = dev;
 	kref_init(&gt->kref);
 
 	ret = allocate_resource(dev_priv->gtt_mem, &gt->resource,
@@ -298,9 +322,24 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 	return NULL;
 }
 
+/**
+ *	psb_gtt_destroy		-	final free up of a gtt
+ *	@kref: the kref of the gtt
+ *
+ *	Called from the kernel kref put when the final reference to our
+ *	GTT object is dropped. At that point we can free up the resources.
+ *
+ *	For now we handle mmap clean up here to work around limits in GEM
+ */
 static void psb_gtt_destroy(struct kref *kref)
 {
 	struct gtt_range *gt = container_of(kref, struct gtt_range, kref);
+
+	/* Undo the mmap pin if we are destroying the object */
+	if (gt->mmapping) {
+		psb_gtt_unpin(gt);
+		gt->mmapping = 0;
+	}
 	WARN_ON(gt->in_gart && !gt->stolen);
 	release_resource(&gt->resource);
 	kfree(gt);
diff --git a/drivers/staging/gma500/psb_gtt.h b/drivers/staging/gma500/psb_gtt.h
index dc553e0..535ae00 100644
--- a/drivers/staging/gma500/psb_gtt.h
+++ b/drivers/staging/gma500/psb_gtt.h
@@ -47,6 +47,7 @@ struct gtt_range {
 	struct drm_gem_object gem;	/* GEM high level stuff */
 	int in_gart;			/* Currently in the GART (ref ct) */
         bool stolen;			/* Backed from stolen RAM */
+        bool mmapping;			/* Is mmappable */
 	struct page **pages;		/* Backing pages if present */
 };
 
@@ -54,7 +55,7 @@ extern struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 						const char *name, int backed);
 extern void psb_gtt_kref_put(struct gtt_range *gt);
 extern void psb_gtt_free_range(struct drm_device *dev, struct gtt_range *gt);
-extern int psb_gtt_pin(struct drm_device *dev, struct gtt_range *gt);
-extern void psb_gtt_unpin(struct drm_device *dev, struct gtt_range *gt);
+extern int psb_gtt_pin(struct gtt_range *gt);
+extern void psb_gtt_unpin(struct gtt_range *gt);
 
 #endif
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index c56ab82..c3e9d28 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -363,7 +363,7 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 
 	/* We are displaying this buffer, make sure it is actually loaded
 	   into the GTT */
-	ret = psb_gtt_pin(dev, psbfb->gtt);
+	ret = psb_gtt_pin(psbfb->gtt);
 	if (ret < 0)
 		goto psb_intel_pipe_set_base_exit;
 	start = psbfb->gtt->offset;
@@ -392,7 +392,7 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 	default:
 		DRM_ERROR("Unknown color depth\n");
 		ret = -EINVAL;
-		psb_gtt_unpin(dev, psbfb->gtt);
+		psb_gtt_unpin(psbfb->gtt);
 		goto psb_intel_pipe_set_base_exit;
 	}
 	REG_WRITE(dspcntr_reg, dspcntr);
@@ -411,7 +411,7 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 
 	/* If there was a previous display we can now unpin it */
 	if (old_fb)
-		psb_gtt_unpin(dev, to_psb_fb(old_fb)->gtt);
+		psb_gtt_unpin(to_psb_fb(old_fb)->gtt);
 
 psb_intel_pipe_set_base_exit:
 	gma_power_end(dev);
@@ -1057,7 +1057,7 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 		if (psb_intel_crtc->cursor_obj) {
 			gt = container_of(psb_intel_crtc->cursor_obj,
 							struct gtt_range, gem);
-			psb_gtt_unpin(crtc->dev, gt);
+			psb_gtt_unpin(gt);
 			drm_gem_object_unreference(psb_intel_crtc->cursor_obj);
 			psb_intel_crtc->cursor_obj = NULL;
 		}
@@ -1083,7 +1083,7 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 	gt = container_of(obj, struct gtt_range, gem);
 
 	/* Pin the memory into the GTT */
-	ret = psb_gtt_pin(crtc->dev, gt);
+	ret = psb_gtt_pin(gt);
 	if (ret) {
 		DRM_ERROR("Can not pin down handle 0x%x\n", handle);
 		return ret;
@@ -1109,7 +1109,7 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 	if (psb_intel_crtc->cursor_obj && psb_intel_crtc->cursor_obj != obj) {
 		gt = container_of(psb_intel_crtc->cursor_obj,
 							struct gtt_range, gem);
-		psb_gtt_unpin(crtc->dev, gt);
+		psb_gtt_unpin(gt);
 		drm_gem_object_unreference(psb_intel_crtc->cursor_obj);
 		psb_intel_crtc->cursor_obj = obj;
 	}
@@ -1318,7 +1318,7 @@ static void psb_intel_crtc_destroy(struct drm_crtc *crtc)
 	if (psb_intel_crtc->cursor_obj) {
 		gt = container_of(psb_intel_crtc->cursor_obj,
 						struct gtt_range, gem);
-		psb_gtt_unpin(crtc->dev, gt);
+		psb_gtt_unpin(gt);
 		drm_gem_object_unreference(psb_intel_crtc->cursor_obj);
 		psb_intel_crtc->cursor_obj = NULL;
 	}

