Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab1DSOt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:49:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52980 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752789Ab1DSOtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:49:23 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 6/8] gma500: GEM - now we have the basics we shall stick pins
 in it
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 19 Apr 2011 15:28:21 +0100
Message-ID: <20110419142809.16479.83632.stgit@localhost.localdomain>
In-Reply-To: <20110419142432.16479.89255.stgit@localhost.localdomain>
References: <20110419142432.16479.89255.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_gtt.c           |   70 +++++++++++++++++++++-------
 drivers/staging/gma500/psb_gtt.h           |   13 ++---
 drivers/staging/gma500/psb_intel_display.c |   33 ++++++++-----
 3 files changed, 80 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 090d30e..a991c12 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -66,7 +66,6 @@ u32 *psb_gtt_entry(struct drm_device *dev, struct gtt_range *r)
 	return dev_priv->gtt_map + (offset >> PAGE_SHIFT);
 }
 
-
 /**
  *	psb_gtt_insert	-	put an object into the GART
  *	@dev: our DRM device
@@ -77,21 +76,19 @@ u32 *psb_gtt_entry(struct drm_device *dev, struct gtt_range *r)
  *
  *	FIXME: gtt lock ?
  */
-int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
+static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 {
 	u32 *gtt_slot, pte;
 	int numpages = (r->resource.end + 1 - r->resource.start) >> PAGE_SHIFT;
 	struct page **pages;
 	int i;
 
-	if (r->stolen)
-		return 0;
 	if (r->pages == NULL) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
 
-	WARN_ON(r->in_gart);	/* refcount these maybe ? */
+	WARN_ON(r->stolen);	/* refcount these maybe ? */
 
 	gtt_slot = psb_gtt_entry(dev, r);
 	pages = r->pages;
@@ -118,16 +115,14 @@ int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
  *	page table entries with the dummy page
  */
 
-void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
+static void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 *gtt_slot, pte;
 	int numpages = (r->resource.end + 1 - r->resource.start) >> PAGE_SHIFT;
 	int i;
 
-	if (r->stolen)
-		return;
-	WARN_ON(!r->in_gart);
+	WARN_ON(r->stolen);
 
 	gtt_slot = psb_gtt_entry(dev, r);
 	pte = psb_gtt_mask_pte(page_to_pfn(dev_priv->scratch_page), 0);;
@@ -146,7 +141,7 @@ void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
  *	Pin and build an in kernel list of the pages that back our GEM object.
  *	While we hold this the pages cannot be swapped out
  */
-int psb_gtt_attach_pages(struct gtt_range *gt)
+static int psb_gtt_attach_pages(struct gtt_range *gt)
 {
 	struct inode *inode;
 	struct address_space *mapping;
@@ -189,13 +184,11 @@ err:
  *	must have been removed from the GART as they could now be paged out
  *	and move bus address.
  */
-void psb_gtt_detach_pages(struct gtt_range *gt)
+static void psb_gtt_detach_pages(struct gtt_range *gt)
 {
 	int i;
 	int pages = (gt->resource.end + 1 - gt->resource.start) >> PAGE_SHIFT;
 
-	WARN_ON(gt->in_gart);
-
 	for (i = 0; i < pages; i++) {
 		/* FIXME: do we need to force dirty */
 		set_page_dirty(gt->pages[i]);
@@ -207,6 +200,50 @@ void psb_gtt_detach_pages(struct gtt_range *gt)
 }
 
 /*
+ *	Manage pinning of resources into the GART
+ */
+
+int psb_gtt_pin(struct drm_device *dev, struct gtt_range *gt)
+{
+	int ret;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	mutex_lock(&dev_priv->gtt_mutex);
+
+	if (gt->in_gart == 0 && gt->stolen == 0) {
+		ret = psb_gtt_attach_pages(gt);
+		if (ret < 0)
+			goto out;
+		ret = psb_gtt_insert(dev, gt);
+		if (ret < 0) {
+			psb_gtt_detach_pages(gt);
+			goto out;
+		}
+	}
+	gt->in_gart++;
+out:
+	mutex_unlock(&dev_priv->gtt_mutex);
+	return ret;
+}
+
+void psb_gtt_unpin(struct drm_device *dev, struct gtt_range *gt)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	mutex_lock(&dev_priv->gtt_mutex);
+
+	WARN_ON(!gt->in_gart);
+
+	gt->in_gart--;
+	if (gt->in_gart == 0 && gt->stolen == 0) {
+		psb_gtt_remove(dev, gt);
+		psb_gtt_detach_pages(gt);
+	}
+
+	mutex_unlock(&dev_priv->gtt_mutex);
+}
+	
+/*
  *	GTT resource allocator - allocate and manage GTT address space
  */
 
@@ -265,10 +302,7 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 static void psb_gtt_destroy(struct kref *kref)
 {
 	struct gtt_range *gt = container_of(kref, struct gtt_range, kref);
-	if (gt->in_gart && !gt->stolen)
-		psb_gtt_remove(gt->gem.dev, gt);
-	if (gt->pages)
-		psb_gtt_detach_pages(gt);
+	WARN_ON(gt->in_gart && !gt->stolen);
 	release_resource(&gt->resource);
 	kfree(gt);
 }
@@ -345,6 +379,8 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 	int ret = 0;
 	uint32_t pte;
 
+	mutex_init(&dev_priv->gtt_mutex);
+
 	dev_priv->pg = pg = psb_gtt_alloc(dev);
 	if (pg == NULL)
 	        return -ENOMEM;
diff --git a/drivers/staging/gma500/psb_gtt.h b/drivers/staging/gma500/psb_gtt.h
index b5d6530..dc553e0 100644
--- a/drivers/staging/gma500/psb_gtt.h
+++ b/drivers/staging/gma500/psb_gtt.h
@@ -44,18 +44,17 @@ struct gtt_range {
 	struct resource resource;
 	u32 offset;
 	struct kref kref;
-        struct drm_gem_object gem;	/* GEM high level stuff */
-        int in_gart;			/* Currently in the GART */
-        int stolen;			/* Backed from stolen RAM */
-        struct page **pages;		/* Backing pages if present */
+	struct drm_gem_object gem;	/* GEM high level stuff */
+	int in_gart;			/* Currently in the GART (ref ct) */
+        bool stolen;			/* Backed from stolen RAM */
+	struct page **pages;		/* Backing pages if present */
 };
 
-extern int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r);
-extern void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r);
-
 extern struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 						const char *name, int backed);
 extern void psb_gtt_kref_put(struct gtt_range *gt);
 extern void psb_gtt_free_range(struct drm_device *dev, struct gtt_range *gt);
+extern int psb_gtt_pin(struct drm_device *dev, struct gtt_range *gt);
+extern void psb_gtt_unpin(struct drm_device *dev, struct gtt_range *gt);
 
 #endif
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index 4d384d5..b5a36d2 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -341,7 +341,6 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 	/* struct drm_i915_master_private *master_priv; */
 	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
 	struct psb_framebuffer *psbfb = to_psb_fb(crtc->fb);
-	struct psb_intel_mode_device *mode_dev = psb_intel_crtc->mode_dev;
 	int pipe = psb_intel_crtc->pipe;
 	unsigned long start, offset;
 	int dspbase = (pipe == 0 ? DSPABASE : DSPBBASE);
@@ -1020,8 +1019,6 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 				 uint32_t width, uint32_t height)
 {
 	struct drm_device *dev = crtc->dev;
-	struct drm_psb_private *dev_priv =
-				(struct drm_psb_private *)dev->dev_private;
 	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
 	int pipe = psb_intel_crtc->pipe;
 	uint32_t control = (pipe == 0) ? CURACNTR : CURBCNTR;
@@ -1048,6 +1045,9 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 
 		/* Unpin the old GEM object */
 		if (psb_intel_crtc->cursor_obj) {
+                	gt = container_of(psb_intel_crtc->cursor_obj,
+                	                        struct gtt_range, gem);
+			psb_gtt_unpin(crtc->dev, gt);
 			drm_gem_object_unreference(psb_intel_crtc->cursor_obj);
 			psb_intel_crtc->cursor_obj = NULL;
 		}
@@ -1070,19 +1070,17 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 		return -ENOMEM;
 	}
 
-	/*insert this bo into gtt*/
-	DRM_DEBUG("%s: map meminfo for hw cursor. handle %x\n",
-						__func__, handle);
+	gt = container_of(obj, struct gtt_range, gem);
 
-/* Pin : FIXME
+	/* Pin the memory into the GTT */
+	ret = psb_gtt_pin(crtc->dev, gt);
 	if (ret) {
-		DRM_ERROR("Can not map meminfo to GTT. handle 0x%x\n", handle);
+		DRM_ERROR("Can not pin down handle 0x%x\n", handle);
 		return ret;
 	}
-*/
-	gt = container_of(obj, struct gtt_range, gem);
 
-	addr = gt->resource.start;
+
+	addr = gt->offset;	/* Or resource.start ??? */
 
 	psb_intel_crtc->cursor_addr = addr;
 
@@ -1099,6 +1097,9 @@ static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
 
 	/* unpin the old bo */
 	if (psb_intel_crtc->cursor_obj && psb_intel_crtc->cursor_obj != obj) {
+               	gt = container_of(psb_intel_crtc->cursor_obj,
+               	                        struct gtt_range, gem);
+		psb_gtt_unpin(crtc->dev, gt);
 		drm_gem_object_unreference(psb_intel_crtc->cursor_obj);
 		psb_intel_crtc->cursor_obj = obj;
 	}
@@ -1301,8 +1302,16 @@ struct drm_display_mode *psb_intel_crtc_mode_get(struct drm_device *dev,
 static void psb_intel_crtc_destroy(struct drm_crtc *crtc)
 {
 	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	struct gtt_range *gt;
 
-	/* FIXME: do we need to put the final GEM cursor ? */
+	/* Unpin the old GEM object */
+	if (psb_intel_crtc->cursor_obj) {
+		gt = container_of(psb_intel_crtc->cursor_obj,
+						struct gtt_range, gem);
+		psb_gtt_unpin(crtc->dev, gt);
+		drm_gem_object_unreference(psb_intel_crtc->cursor_obj);
+		psb_intel_crtc->cursor_obj = NULL;
+	}
 	kfree(psb_intel_crtc->crtc_state);
 	drm_crtc_cleanup(crtc);
 	kfree(psb_intel_crtc);

