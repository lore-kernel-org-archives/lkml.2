Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1IVSgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 14:36:20 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36844 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1IVSgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 14:36:19 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] gma500: gtt based hardware scrolling console
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Thu, 22 Sep 2011 19:43:47 +0100
Message-ID: <20110922184316.25068.54702.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Add support for GTT based scrolling. Instead of pushing bits around we simply
use the GTT to change the mappings. This provides us with a very fast way to
scroll the display providing we have enough memory to allocate on 4K line
boundaries. In practice this seems to be the case except for very big displays
such as HDMI. It works out nicely on the usual configurations are netbooks and
tablets.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/framebuffer.c |   85 +++++++++++++++++++++++++++++-----
 drivers/staging/gma500/gtt.c         |   51 +++++++++++++++++++-
 drivers/staging/gma500/gtt.h         |    3 +
 3 files changed, 123 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/gma500/framebuffer.c b/drivers/staging/gma500/framebuffer.c
index 7748331..3f39a37 100644
--- a/drivers/staging/gma500/framebuffer.c
+++ b/drivers/staging/gma500/framebuffer.c
@@ -37,6 +37,7 @@
 #include "psb_intel_reg.h"
 #include "psb_intel_drv.h"
 #include "framebuffer.h"
+#include "gtt.h"
 
 #include "mdfld_output.h"
 
@@ -91,6 +92,21 @@ static int psbfb_setcolreg(unsigned regno, unsigned red, unsigned green,
 	return 0;
 }
 
+static int psbfb_pan(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	struct psb_fbdev *fbdev = info->par;
+	struct psb_framebuffer *psbfb = &fbdev->pfb;
+	struct drm_device *dev = psbfb->base.dev;
+
+	/*
+	 *	We have to poke our nose in here. The core fb code assumes
+	 *	panning is part of the hardware that can be invoked before
+	 *	the actual fb is mapped. In our case that isn't quite true.
+	 */
+	if (psbfb->gtt->npage)
+        	psb_gtt_roll(dev, psbfb->gtt, var->yoffset);
+	return 0;
+}
 
 void psbfb_suspend(struct drm_device *dev)
 {
@@ -217,6 +233,21 @@ static struct fb_ops psbfb_ops = {
 	.fb_ioctl = psbfb_ioctl,
 };
 
+static struct fb_ops psbfb_roll_ops = {
+	.owner = THIS_MODULE,
+	.fb_check_var = drm_fb_helper_check_var,
+	.fb_set_par = drm_fb_helper_set_par,
+	.fb_blank = drm_fb_helper_blank,
+	.fb_setcolreg = psbfb_setcolreg,
+	.fb_fillrect = cfb_fillrect,
+	.fb_copyarea = cfb_copyarea,
+	.fb_imageblit = cfb_imageblit,
+	.fb_pan_display = psbfb_pan,
+	.fb_mmap = psbfb_mmap,
+	.fb_sync = psbfb_sync,
+	.fb_ioctl = psbfb_ioctl,
+};
+
 static struct fb_ops psbfb_unaccel_ops = {
 	.owner = THIS_MODULE,
 	.fb_check_var = drm_fb_helper_check_var,
@@ -304,6 +335,7 @@ static struct drm_framebuffer *psb_framebuffer_create
  *	psbfb_alloc		-	allocate frame buffer memory
  *	@dev: the DRM device
  *	@aligned_size: space needed
+ *	@force: fall back to GEM buffers if need be
  *
  *	Allocate the frame buffer. In the usual case we get a GTT range that
  *	is stolen memory backed and life is simple. If there isn't sufficient
@@ -311,11 +343,9 @@ static struct drm_framebuffer *psb_framebuffer_create
  *	and back it with a GEM object.
  *
  *	In this case the GEM object has no handle.
- *
- *	FIXME: console speed up - allocate twice the space if room and use
- *	hardware scrolling for acceleration.
  */
-static struct gtt_range *psbfb_alloc(struct drm_device *dev, int aligned_size)
+static struct gtt_range *psbfb_alloc(struct drm_device *dev,
+						int aligned_size, int force)
 {
 	struct gtt_range *backing;
 	/* Begin by trying to use stolen memory backing */
@@ -326,6 +356,9 @@ static struct gtt_range *psbfb_alloc(struct drm_device *dev, int aligned_size)
 			return backing;
 		psb_gtt_free_range(dev, backing);
 	}
+	if (!force)
+		return NULL;
+
 	/* Next try using GEM host memory */
 	backing = psb_gtt_alloc_range(dev, aligned_size, "fb(gem)", 0);
 	if (backing == NULL)
@@ -359,6 +392,7 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	int size;
 	int ret;
 	struct gtt_range *backing;
+	int gtt_roll = 1;
 
 	mode_cmd.width = sizes->surface_width;
 	mode_cmd.height = sizes->surface_height;
@@ -368,17 +402,37 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	if (mode_cmd.bpp == 24)
 		mode_cmd.bpp = 32;
 
-	/* HW requires pitch to be 64 byte aligned */
-	mode_cmd.pitch =  ALIGN(mode_cmd.width * ((mode_cmd.bpp + 7) / 8), 64);
+	/* Acceleration via the GTT requires pitch to be 4096 byte aligned 
+	   (ie 1024 or 2048 pixels in normal use) */
+	mode_cmd.pitch =  ALIGN(mode_cmd.width * ((mode_cmd.bpp + 7) / 8), 4096);
 	mode_cmd.depth = sizes->surface_depth;
 
 	size = mode_cmd.pitch * mode_cmd.height;
 	size = ALIGN(size, PAGE_SIZE);
 
 	/* Allocate the framebuffer in the GTT with stolen page backing */
-	backing = psbfb_alloc(dev, size);
-	if (backing == NULL)
-		return -ENOMEM;
+	backing = psbfb_alloc(dev, size, 0);
+	if (backing == NULL) {
+		/*
+		 *	We couldn't get the space we wanted, fall back to the
+		 *	display engine requirement instead.  The HW requires
+		 *	the pitch to be 64 byte aligned
+		 */
+
+		gtt_roll = 0;	/* Don't use GTT accelerated scrolling */
+
+		mode_cmd.pitch =  ALIGN(mode_cmd.width * ((mode_cmd.bpp + 7) / 8), 64);
+		mode_cmd.depth = sizes->surface_depth;
+
+		size = mode_cmd.pitch * mode_cmd.height;
+		size = ALIGN(size, PAGE_SIZE);
+
+		/* Allocate the framebuffer in the GTT with stolen page
+		   backing when there is room */
+		backing = psbfb_alloc(dev, size, 1);
+		if (backing == NULL)
+			return -ENOMEM;
+	}
 
 	mutex_lock(&dev->struct_mutex);
 
@@ -402,11 +456,14 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	strcpy(info->fix.id, "psbfb");
 
 	info->flags = FBINFO_DEFAULT;
-	/* No 2D engine */
-	if (!dev_priv->ops->accel_2d)
-		info->fbops = &psbfb_unaccel_ops;
-	else
+	if (gtt_roll) {	/* GTT rolling seems best */
+		info->fbops = &psbfb_roll_ops;
+		info->flags |= FBINFO_HWACCEL_YPAN;
+        }
+	else if (dev_priv->ops->accel_2d)	/* 2D engine */
 		info->fbops = &psbfb_ops;
+	else	/* Software */
+		info->fbops = &psbfb_unaccel_ops;
 
 	ret = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (ret) {
@@ -416,6 +473,8 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 
 	info->fix.smem_start = dev->mode_config.fb_base;
 	info->fix.smem_len = size;
+	info->fix.ywrapstep = gtt_roll;
+	info->fix.ypanstep = gtt_roll;
 
 	if (backing->stolen) {
 		/* Accessed stolen memory directly */
diff --git a/drivers/staging/gma500/gtt.c b/drivers/staging/gma500/gtt.c
index a246239..e770bd1 100644
--- a/drivers/staging/gma500/gtt.c
+++ b/drivers/staging/gma500/gtt.c
@@ -95,12 +95,17 @@ static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 	set_pages_array_uc(pages, r->npage);
 
 	/* Write our page entries into the GTT itself */
-	for (i = 0; i < r->npage; i++) {
-		pte = psb_gtt_mask_pte(page_to_pfn(*pages++), 0/*type*/);
+	for (i = r->roll; i < r->npage; i++) {
+		pte = psb_gtt_mask_pte(page_to_pfn(r->pages[i]), 0);
+		iowrite32(pte, gtt_slot++);
+	}
+	for (i = 0; i < r->roll; i++) {
+		pte = psb_gtt_mask_pte(page_to_pfn(r->pages[i]), 0);
 		iowrite32(pte, gtt_slot++);
 	}
 	/* Make sure all the entries are set before we return */
 	ioread32(gtt_slot - 1);
+
 	return 0;
 }
 
@@ -113,7 +118,6 @@ static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
  *	page table entries with the dummy page. This is protected via the gtt
  *	mutex which the caller must hold.
  */
-
 static void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
@@ -132,6 +136,46 @@ static void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
 }
 
 /**
+ *	psb_gtt_roll	-	set scrolling position
+ *	@dev: our DRM device
+ *	@r: the gtt mapping we are using
+ *	@roll: roll offset
+ *
+ *	Roll an existing pinned mapping by moving the pages through the GTT.
+ *	This allows us to implement hardware scrolling on the consoles without
+ *	a 2D engine
+ */
+void psb_gtt_roll(struct drm_device *dev, struct gtt_range *r, int roll)
+{
+	u32 *gtt_slot, pte;
+	int i;
+
+	if (roll >= r->npage) {
+		WARN_ON(1);
+		return;
+	}
+
+	r->roll = roll;
+
+	/* Not currently in the GTT - no worry we will write the mapping at
+	   the right position when it gets pinned */
+	if (!r->stolen && !r->in_gart)
+		return;
+
+	gtt_slot = psb_gtt_entry(dev, r);
+
+	for (i = r->roll; i < r->npage; i++) {
+		pte = psb_gtt_mask_pte(page_to_pfn(r->pages[i]), 0);
+		iowrite32(pte, gtt_slot++);
+	}
+	for (i = 0; i < r->roll; i++) {
+		pte = psb_gtt_mask_pte(page_to_pfn(r->pages[i]), 0);
+		iowrite32(pte, gtt_slot++);
+	}
+	ioread32(gtt_slot - 1);
+}
+
+/**
  *	psb_gtt_attach_pages	-	attach and pin GEM pages
  *	@gt: the gtt range
  *
@@ -302,6 +346,7 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 	gt->resource.name = name;
 	gt->stolen = backed;
 	gt->in_gart = backed;
+	gt->roll = 0;
 	/* Ensure this is set for non GEM objects */
 	gt->gem.dev = dev;
 	ret = allocate_resource(dev_priv->gtt_mem, &gt->resource,
diff --git a/drivers/staging/gma500/gtt.h b/drivers/staging/gma500/gtt.h
index e0e1cb6..aa17423 100644
--- a/drivers/staging/gma500/gtt.h
+++ b/drivers/staging/gma500/gtt.h
@@ -49,6 +49,7 @@ struct gtt_range {
 	bool mmapping;			/* Is mmappable */
 	struct page **pages;		/* Backing pages if present */
 	int npage;			/* Number of backing pages */
+	int roll;			/* Roll applied to the GTT entries */
 };
 
 extern struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
@@ -57,5 +58,7 @@ extern void psb_gtt_kref_put(struct gtt_range *gt);
 extern void psb_gtt_free_range(struct drm_device *dev, struct gtt_range *gt);
 extern int psb_gtt_pin(struct gtt_range *gt);
 extern void psb_gtt_unpin(struct gtt_range *gt);
+extern void psb_gtt_roll(struct drm_device *dev,
+					struct gtt_range *gt, int roll);
 
 #endif

