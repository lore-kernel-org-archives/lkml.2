Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab1F1WD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:03:57 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35035 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab1F1WDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:03:49 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 02/29] gma500: Make GTT pages uncached
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:03:25 +0100
Message-ID: <20110628220322.898.22988.stgit@bob.linux.org.uk>
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

Clean up the GTT code a bit, make the pages uncached and go via the proper
interfaces. This avoids any aliasing problems.

On the CPU side we need to access the pages via their true addresses not via
the GTT. This is fine for GEM created fb objects for X. For the kernel fb
when not in stolen RAM we are going to need to use vm_map_ram() and hope we
have enough virtual address space to steal.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_fb.c  |    9 ++++++++-
 drivers/staging/gma500/psb_gem.c |   26 +++++++-------------------
 drivers/staging/gma500/psb_gtt.c |   27 ++++++++++++++-------------
 3 files changed, 29 insertions(+), 33 deletions(-)


diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 084c36b..b276fe9 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -346,6 +346,11 @@ err:
  *	and back it with a GEM object.
  *
  *	In this case the GEM object has no handle. 
+ *
+ *	FIXME: console speed up - allocate twice the space if room and use
+ *	hardware scrolling for acceleration.
+ *	FIXME: we need to vm_map_ram  a linear mapping if the object has to
+ *	be GEM host mapped, otherwise the cfb layer's brain will fall out.
  */
 static struct gtt_range *psbfb_alloc(struct drm_device *dev, int aligned_size)
 {
@@ -436,7 +441,7 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 
 	/* Accessed via stolen memory directly, This only works for stolem
 	   memory however. Need to address this once we start using gtt
-	   pages we allocate */
+	   pages we allocate. FIXME: vm_map_ram for that case */
 	info->screen_base = (char *)dev_priv->vram_addr + backing->offset;
 	info->screen_size = size;
 	memset(info->screen_base, 0, size);
@@ -676,6 +681,8 @@ static void psb_user_framebuffer_destroy(struct drm_framebuffer *fb)
 	struct psb_framebuffer *psbfb = to_psb_fb(fb);
 	struct gtt_range *r = psbfb->gtt;
 
+	pr_err("user framebuffer destroy %p, fbdev %p\n",
+						psbfb, psbfb->fbdev);
 	if (psbfb->fbdev)
 		psbfb_remove(dev, fb);
 
diff --git a/drivers/staging/gma500/psb_gem.c b/drivers/staging/gma500/psb_gem.c
index 76ff7ba..98d8ab3 100644
--- a/drivers/staging/gma500/psb_gem.c
+++ b/drivers/staging/gma500/psb_gem.c
@@ -40,7 +40,6 @@ int psb_gem_init_object(struct drm_gem_object *obj)
 void psb_gem_free_object(struct drm_gem_object *obj)
 {
 	struct gtt_range *gtt = container_of(obj, struct gtt_range, gem);
-	psb_gtt_free_range(obj->dev, gtt);
 	if (obj->map_list.map) {
 		/* Do things GEM should do for us */
 		struct drm_gem_mm *mm = obj->dev->mm_private;
@@ -51,6 +50,8 @@ void psb_gem_free_object(struct drm_gem_object *obj)
 		list->map = NULL;
 	}
 	drm_gem_object_release(obj);
+	/* This must occur last as it frees up the memory of the GEM object */
+	psb_gtt_free_range(obj->dev, gtt);
 }
 
 int psb_gem_get_aperture(struct drm_device *dev, void *data,
@@ -245,19 +246,13 @@ int psb_gem_dumb_destroy(struct drm_file *file, struct drm_device *dev,
  *	but we need to do the actual page work.
  *
  *	This code eventually needs to handle faulting objects in and out
- *	of the GART and repacking it when we run out of space. We can put
+ *	of the GTT and repacking it when we run out of space. We can put
  *	that off for now and for our simple uses
  *
  *	The VMA was set up by GEM. In doing so it also ensured that the
  *	vma->vm_private_data points to the GEM object that is backing this
  *	mapping.
  *
- *	To avoid aliasing and cache funnies we want to map the object
- *	through the GART. For the moment this is slightly hackish. It would
- *	be nicer if GEM provided mmap opened/closed hooks for us giving
- *	the object so that we could track things nicely. That needs changes
- *	to the core GEM code so must be tackled post staging
- *
  *	FIXME
  */
 int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
@@ -289,20 +284,13 @@ int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 		r->mmapping = 1;
 	}
 
-	/* FIXME: Locking. We may also need to repack the GART sometimes */
-
-	/* Page relative to the VMA start */
+	/* Page relative to the VMA start - we must calculate this ourselves
+	   because vmf->pgoff is the fake GEM offset */
 	page_offset = ((unsigned long) vmf->virtual_address - vma->vm_start)
 				>> PAGE_SHIFT;
 
-	/* Bus address of the page is gart + object offset + page offset */
-	/* Assumes gtt allocations are page aligned */
-	pfn = (r->resource.start >> PAGE_SHIFT) + page_offset;
-
-	pr_debug("Object GTT base at %p\n", (void *)(r->resource.start));
-	pr_debug("Inserting %p pfn %lx, pa %lx\n", vmf->virtual_address,
-	        pfn, pfn << PAGE_SHIFT);
-
+        /* CPU view of the page, don't go via the GART for CPU writes */
+	pfn = page_to_phys(r->pages[page_offset]) >> PAGE_SHIFT;
 	ret = vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
 
 fail:
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index ec31ffe..2ddab50 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -28,11 +28,11 @@
  */
 
 /**
- *	psb_gtt_mask_pte	-	generate GART pte entry
+ *	psb_gtt_mask_pte	-	generate GTT pte entry
  *	@pfn: page number to encode
- *	@type: type of memory in the GART
+ *	@type: type of memory in the GTT
  *
- *	Set the GART entry for the appropriate memory type.
+ *	Set the GTT entry for the appropriate memory type.
  */
 static inline uint32_t psb_gtt_mask_pte(uint32_t pfn, int type)
 {
@@ -49,11 +49,11 @@ static inline uint32_t psb_gtt_mask_pte(uint32_t pfn, int type)
 }
 
 /**
- *	psb_gtt_entry		-	find the GART entries for a gtt_range
+ *	psb_gtt_entry		-	find the GTT entries for a gtt_range
  *	@dev: our DRM device
  *	@r: our GTT range
  * 
- *	Given a gtt_range object return the GART offset of the page table
+ *	Given a gtt_range object return the GTT offset of the page table
  *	entries for this gtt_range
  */
 u32 *psb_gtt_entry(struct drm_device *dev, struct gtt_range *r)
@@ -67,12 +67,12 @@ u32 *psb_gtt_entry(struct drm_device *dev, struct gtt_range *r)
 }
 
 /**
- *	psb_gtt_insert	-	put an object into the GART
+ *	psb_gtt_insert	-	put an object into the GTT
  *	@dev: our DRM device
  *	@r: our GTT range
  *
  *	Take our preallocated GTT range and insert the GEM object into
- *	the GART.
+ *	the GTT.
  *
  *	FIXME: gtt lock ?
  */
@@ -93,10 +93,10 @@ static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 	gtt_slot = psb_gtt_entry(dev, r);
 	pages = r->pages;
 
-	/* Make sure we have no alias present */
-	wbinvd();
+	/* Make sure changes are visible to the GPU */
+	set_pages_array_uc(pages, numpages);
 
-	/* Write our page entries into the GART itself */
+	/* Write our page entries into the GTT itself */
 	for (i = 0; i < numpages; i++) {
 		pte = psb_gtt_mask_pte(page_to_pfn(*pages++), 0/*type*/);
 		iowrite32(pte, gtt_slot++);
@@ -108,11 +108,11 @@ static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 }
 
 /**
- *	psb_gtt_remove	-	remove an object from the GART
+ *	psb_gtt_remove	-	remove an object from the GTT
  *	@dev: our DRM device
  *	@r: our GTT range
  *
- *	Remove a preallocated GTT range from the GART. Overwrite all the
+ *	Remove a preallocated GTT range from the GTT. Overwrite all the
  *	page table entries with the dummy page
  */
 
@@ -131,6 +131,7 @@ static void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
 	for (i = 0; i < numpages; i++)
 		iowrite32(pte, gtt_slot++);
 	ioread32(gtt_slot - 1);
+	set_pages_array_wb(r->pages, numpages);
 }
 
 /**
@@ -182,7 +183,7 @@ err:
  *	@gt: the gtt range
  *
  *	Undo the effect of psb_gtt_attach_pages. At this point the pages
- *	must have been removed from the GART as they could now be paged out
+ *	must have been removed from the GTT as they could now be paged out
  *	and move bus address.
  *
  *	FIXME: Do we need to cache flush when we update the GTT

