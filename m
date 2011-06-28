Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab1F1WEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:04:09 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35038 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab1F1WEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:04:02 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 03/29] gma500: Ensure the frame buffer has a linear virtual
 mapping
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:03:37 +0100
Message-ID: <20110628220335.898.61954.stgit@bob.linux.org.uk>
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

We need this for the framebuffer in order to ensure that the kernel
framebuffer layer can handle it when using KMS. Except for the base
framebuffer this isn't a concern.

Add an npage field to the gtt as too many copies of the page calculation
are getting spread around the code.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_fb.c  |   47 ++++++++++++++++++++++++--------------
 drivers/staging/gma500/psb_fb.h  |    1 +
 drivers/staging/gma500/psb_gtt.c |   18 ++++++---------
 drivers/staging/gma500/psb_gtt.h |    5 ++--
 4 files changed, 42 insertions(+), 29 deletions(-)


diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index b276fe9..4b05cdc 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -254,17 +254,13 @@ static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 				vma->vm_pgoff, fb_screen_base,
                                 dev_priv->vram_addr);
 
-        /* FIXME: ultimately this needs to become 'if entirely stolen memory' */
-	if (1 || fb_screen_base == dev_priv->vram_addr) {
-		vma->vm_ops = &psbfb_vm_ops;
-		vma->vm_private_data = (void *)psbfb;
-		vma->vm_flags |= VM_RESERVED | VM_IO |
-						VM_MIXEDMAP | VM_DONTEXPAND;
-	} else {
-	        /* GTT memory backed by kernel/user pages, needs a different
-	           approach ? - GEM ? */
-	}
-
+        /* If this is a GEM object then info->screen_base is the virtual
+           kernel remapping of the object. FIXME: Review if this is
+           suitable for our mmap work */
+	vma->vm_ops = &psbfb_vm_ops;
+	vma->vm_private_data = (void *)psbfb;
+	vma->vm_flags |= VM_RESERVED | VM_IO |
+					VM_MIXEDMAP | VM_DONTEXPAND;
 	return 0;
 }
 
@@ -349,8 +345,6 @@ err:
  *
  *	FIXME: console speed up - allocate twice the space if room and use
  *	hardware scrolling for acceleration.
- *	FIXME: we need to vm_map_ram  a linear mapping if the object has to
- *	be GEM host mapped, otherwise the cfb layer's brain will fall out.
  */
 static struct gtt_range *psbfb_alloc(struct drm_device *dev, int aligned_size)
 {
@@ -439,10 +433,22 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	info->fix.smem_start = dev->mode_config.fb_base;
 	info->fix.smem_len = size;
 
-	/* Accessed via stolen memory directly, This only works for stolem
-	   memory however. Need to address this once we start using gtt
-	   pages we allocate. FIXME: vm_map_ram for that case */
-	info->screen_base = (char *)dev_priv->vram_addr + backing->offset;
+	if (backing->stolen) {
+		/* Accessed stolen memory directly */
+		info->screen_base = (char *)dev_priv->vram_addr +
+							backing->offset;
+	} else {
+		/* Pin the pages into the GTT and create a mapping to them */
+		psb_gtt_pin(backing);
+		info->screen_base = vm_map_ram(backing->pages, backing->npage,
+				-1, PAGE_KERNEL);
+		if (info->screen_base == NULL) {
+			psb_gtt_unpin(backing);
+			ret = -ENOMEM;
+			goto out_err0;
+		}
+		psbfb->vm_map = 1;
+	}
 	info->screen_size = size;
 	memset(info->screen_base, 0, size);
 
@@ -570,6 +576,13 @@ int psb_fbdev_destroy(struct drm_device *dev, struct psb_fbdev *fbdev)
 
 	if (fbdev->psb_fb_helper.fbdev) {
 		info = fbdev->psb_fb_helper.fbdev;
+
+		/* If this is our base framebuffer then kill any virtual map
+		   for the framebuffer layer and unpin it */
+		if (psbfb->vm_map) {
+			vm_unmap_ram(info->screen_base, psbfb->gtt->npage);
+			psb_gtt_unpin(psbfb->gtt);
+		}
 		/* FIXME: this is a bit more inside knowledge than I'd like
 		   but I don't see how to make a fake GEM object of the
 		   stolen space nicely */
diff --git a/drivers/staging/gma500/psb_fb.h b/drivers/staging/gma500/psb_fb.h
index c8ec0d6..2153c74 100644
--- a/drivers/staging/gma500/psb_fb.h
+++ b/drivers/staging/gma500/psb_fb.h
@@ -33,6 +33,7 @@ struct psb_framebuffer {
 	struct address_space *addr_space;
 	struct fb_info *fbdev;
 	struct gtt_range *gtt;
+	bool vm_map;		/* True if we must undo a vm_map_ram */
 };
 
 struct psb_fbdev {
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 2ddab50..6a24246 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -79,7 +79,6 @@ u32 *psb_gtt_entry(struct drm_device *dev, struct gtt_range *r)
 static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 {
 	u32 *gtt_slot, pte;
-	int numpages = resource_size(&r->resource) >> PAGE_SHIFT;
 	struct page **pages;
 	int i;
 
@@ -94,10 +93,10 @@ static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 	pages = r->pages;
 
 	/* Make sure changes are visible to the GPU */
-	set_pages_array_uc(pages, numpages);
+	set_pages_array_uc(pages, r->npage);
 
 	/* Write our page entries into the GTT itself */
-	for (i = 0; i < numpages; i++) {
+	for (i = 0; i < r->npage; i++) {
 		pte = psb_gtt_mask_pte(page_to_pfn(*pages++), 0/*type*/);
 		iowrite32(pte, gtt_slot++);
 	}
@@ -120,7 +119,6 @@ static void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 *gtt_slot, pte;
-	int numpages = resource_size(&r->resource) >> PAGE_SHIFT;
 	int i;
 
 	WARN_ON(r->stolen);
@@ -128,10 +126,10 @@ static void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
 	gtt_slot = psb_gtt_entry(dev, r);
 	pte = psb_gtt_mask_pte(page_to_pfn(dev_priv->scratch_page), 0);;
 
-	for (i = 0; i < numpages; i++)
+	for (i = 0; i < r->npage; i++)
 		iowrite32(pte, gtt_slot++);
 	ioread32(gtt_slot - 1);
-	set_pages_array_wb(r->pages, numpages);
+	set_pages_array_wb(r->pages, r->npage);
 }
 
 /**
@@ -149,7 +147,7 @@ static int psb_gtt_attach_pages(struct gtt_range *gt)
 	struct address_space *mapping;
 	int i;
 	struct page *p;
-	int pages = resource_size(&gt->resource) >> PAGE_SHIFT;
+	int pages = gt->gem.size / PAGE_SIZE;
 
 	WARN_ON(gt->pages);
 
@@ -160,6 +158,8 @@ static int psb_gtt_attach_pages(struct gtt_range *gt)
 	gt->pages = kmalloc(pages * sizeof(struct page *), GFP_KERNEL);
 	if (gt->pages == NULL)
 		return -ENOMEM;
+	gt->npage = pages;
+
 	for (i = 0; i < pages; i++) {
 		/* FIXME: review flags later */
 		p = read_cache_page_gfp(mapping, i,
@@ -191,9 +191,7 @@ err:
 static void psb_gtt_detach_pages(struct gtt_range *gt)
 {
 	int i;
-	int pages = resource_size(&gt->resource) >> PAGE_SHIFT;
-
-	for (i = 0; i < pages; i++) {
+	for (i = 0; i < gt->npage; i++) {
 		/* FIXME: do we need to force dirty */
 		set_page_dirty(gt->pages[i]);
 		/* Undo the reference we took when populating the table */
diff --git a/drivers/staging/gma500/psb_gtt.h b/drivers/staging/gma500/psb_gtt.h
index 535ae00..37287eb 100644
--- a/drivers/staging/gma500/psb_gtt.h
+++ b/drivers/staging/gma500/psb_gtt.h
@@ -46,9 +46,10 @@ struct gtt_range {
 	struct kref kref;
 	struct drm_gem_object gem;	/* GEM high level stuff */
 	int in_gart;			/* Currently in the GART (ref ct) */
-        bool stolen;			/* Backed from stolen RAM */
-        bool mmapping;			/* Is mmappable */
+	bool stolen;			/* Backed from stolen RAM */
+	bool mmapping;			/* Is mmappable */
 	struct page **pages;		/* Backing pages if present */
+	int npage;			/* Number of backing pages */
 };
 
 extern struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,

