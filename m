Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1F1WGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:06:20 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40972 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab1F1WGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:06:12 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 11/29] gma500: nuke the last bits of TTM code
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:05:47 +0100
Message-ID: <20110628220530.898.46329.stgit@bob.linux.org.uk>
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

We don't seem to need this for our task.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.c |    6 ----
 drivers/staging/gma500/psb_gtt.c |   62 ++++++++++++--------------------------
 2 files changed, 19 insertions(+), 49 deletions(-)


diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 9bd0a5d..ab1da30 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -409,8 +409,6 @@ static int psb_do_init(struct drm_device *dev)
 	struct psb_gtt *pg = dev_priv->pg;
 
 	uint32_t stolen_gtt;
-	uint32_t tt_start;
-	uint32_t tt_pages;
 
 	int ret = -ENOMEM;
 
@@ -449,10 +447,6 @@ static int psb_do_init(struct drm_device *dev)
 
 	spin_lock_init(&dev_priv->irqmask_lock);
 
-	tt_pages = (pg->gatt_pages < PSB_TT_PRIV0_PLIMIT) ?
-	    pg->gatt_pages : PSB_TT_PRIV0_PLIMIT;
-	tt_start = dev_priv->gatt_free_offset - pg->mmu_gatt_start;
-	tt_pages -= tt_start >> PAGE_SHIFT;
 	/* FIXME: can we kill ta_mem_size ? */
 	dev_priv->sizes.ta_mem_size = 0;
 
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 5a296e1..8fcb833 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -138,8 +138,6 @@ static void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
  *
  *	Pin and build an in kernel list of the pages that back our GEM object.
  *	While we hold this the pages cannot be swapped out
- *
- *	FIXME: Do we need to cache flush when we update the GTT
  */
 static int psb_gtt_attach_pages(struct gtt_range *gt)
 {
@@ -185,8 +183,6 @@ err:
  *	Undo the effect of psb_gtt_attach_pages. At this point the pages
  *	must have been removed from the GTT as they could now be paged out
  *	and move bus address.
- *
- *	FIXME: Do we need to cache flush when we update the GTT
  */
 static void psb_gtt_detach_pages(struct gtt_range *gt)
 {
@@ -194,7 +190,6 @@ static void psb_gtt_detach_pages(struct gtt_range *gt)
 	for (i = 0; i < gt->npage; i++) {
 		/* FIXME: do we need to force dirty */
 		set_page_dirty(gt->pages[i]);
-		/* Undo the reference we took when populating the table */
 		page_cache_release(gt->pages[i]);
 	}
 	kfree(gt->pages);
@@ -384,7 +379,6 @@ void psb_gtt_takedown(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 
-	/* FIXME: iounmap dev_priv->vram_addr etc */
 	if (dev_priv->gtt_map) {
 		iounmap(dev_priv->gtt_map);
 		dev_priv->gtt_map = NULL;
@@ -395,6 +389,8 @@ void psb_gtt_takedown(struct drm_device *dev)
 		PSB_WVDC32(dev_priv->pge_ctl, PSB_PGETBL_CTL);
 		(void) PSB_RVDC32(PSB_PGETBL_CTL);
 	}
+	if (dev_priv->vram_addr)
+		iounmap(dev_priv->gtt_map);
 	kfree(dev_priv->pg);
 	dev_priv->pg = NULL;
 }
@@ -407,8 +403,6 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 	unsigned i, num_pages;
 	unsigned pfn_base;
 	uint32_t vram_pages;
-	uint32_t tt_pages;
-	uint32_t *ttm_gtt_map;
 	uint32_t dvmt_mode = 0;
 	struct psb_gtt *pg;
 
@@ -421,6 +415,7 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 	if (pg == NULL)
 		return -ENOMEM;
 
+        /* Enable the GTT */
 	pci_read_config_word(dev->pdev, PSB_GMCH_CTRL, &dev_priv->gmch_ctrl);
 	pci_write_config_word(dev->pdev, PSB_GMCH_CTRL,
 			      dev_priv->gmch_ctrl | _PSB_GMCH_ENABLED);
@@ -431,30 +426,26 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 
 	/* The root resource we allocate address space from */
 	dev_priv->gtt_mem = &dev->pdev->resource[PSB_GATT_RESOURCE];
-
 	dev_priv->gtt_initialized = 1;
 
 	pg->gtt_phys_start = dev_priv->pge_ctl & PAGE_MASK;
 
 	pg->gatt_start = pci_resource_start(dev->pdev, PSB_GATT_RESOURCE);
-	/* fix me: video mmu has hw bug to access 0x0D0000000,
-	 * then make gatt start at 0x0e000,0000 */
+	/* 
+	 *	FIXME: video mmu has hw bug to access 0x0D0000000,
+	 *	then make gatt start at 0x0e000,0000
+	 */
 	pg->mmu_gatt_start = 0xE0000000;
+
 	pg->gtt_start = pci_resource_start(dev->pdev, PSB_GTT_RESOURCE);
-	gtt_pages =
-	    pci_resource_len(dev->pdev, PSB_GTT_RESOURCE) >> PAGE_SHIFT;
-	pg->gatt_pages = pci_resource_len(dev->pdev, PSB_GATT_RESOURCE)
-	    >> PAGE_SHIFT;
+	gtt_pages = pci_resource_len(dev->pdev, PSB_GTT_RESOURCE) >> PAGE_SHIFT;
+	pg->gatt_pages = pci_resource_len(dev->pdev, PSB_GATT_RESOURCE) >> PAGE_SHIFT;
 
 	pci_read_config_dword(dev->pdev, PSB_BSM, &dev_priv->stolen_base);
 	vram_stolen_size = pg->gtt_phys_start - dev_priv->stolen_base - PAGE_SIZE;
 
 	stolen_size = vram_stolen_size;
 
-	printk(KERN_INFO"GMMADR(region 0) start: 0x%08x (%dM).\n",
-		pg->gatt_start, pg->gatt_pages/256);
-	printk(KERN_INFO"GTTADR(region 3) start: 0x%08x (can map %dM RAM), and actual RAM base 0x%08x.\n",
-		pg->gtt_start, gtt_pages * 4, pg->gtt_phys_start);
 	printk(KERN_INFO "Stolen memory information\n");
 	printk(KERN_INFO "       base in RAM: 0x%x\n", dev_priv->stolen_base);
 	printk(KERN_INFO "       size: %luK, calculated by (GTT RAM base) - (Stolen base), seems wrong\n",
@@ -473,8 +464,11 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 	pg->gtt_pages = gtt_pages;
 	pg->stolen_size = stolen_size;
 	dev_priv->vram_stolen_size = vram_stolen_size;
-	dev_priv->gtt_map =
-	    ioremap_nocache(pg->gtt_phys_start, gtt_pages << PAGE_SHIFT);
+
+	/*
+	 *	Map the GTT and the stolen memory area
+	 */
+	dev_priv->gtt_map = ioremap_nocache(pg->gtt_phys_start, gtt_pages << PAGE_SHIFT);
 	if (!dev_priv->gtt_map) {
 		DRM_ERROR("Failure to map gtt.\n");
 		ret = -ENOMEM;
@@ -488,15 +482,8 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 		goto out_err;
 	}
 
-	DRM_DEBUG("gma500: vram kernel virtual address %p\n", dev_priv->vram_addr);
-
-	tt_pages = (pg->gatt_pages < PSB_TT_PRIV0_PLIMIT) ?
-		(pg->gatt_pages) : PSB_TT_PRIV0_PLIMIT;
-
-	ttm_gtt_map = dev_priv->gtt_map + tt_pages / 2;
-
 	/*
-	 * insert vram stolen pages.
+	 * Insert vram stolen pages into the GTT
 	 */
 
 	pfn_base = dev_priv->stolen_base >> PAGE_SHIFT;
@@ -509,26 +496,15 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 	}
 
 	/*
-	 * Init rest of gtt managed by IMG.
-	 */
-	pfn_base = page_to_pfn(dev_priv->scratch_page);
-	pte = psb_gtt_mask_pte(pfn_base, 0);
-	for (; i < tt_pages / 2 - 1; ++i)
-		iowrite32(pte, dev_priv->gtt_map + i);
-
-	/*
-	 * Init rest of gtt managed by TTM.
+	 * Init rest of GTT to the scratch page to avoid accidents or scribbles
 	 */
 
 	pfn_base = page_to_pfn(dev_priv->scratch_page);
 	pte = psb_gtt_mask_pte(pfn_base, 0);
-	PSB_DEBUG_INIT("Initializing the rest of a total "
-		       "of %d gtt pages.\n", pg->gatt_pages);
+	for (; i < gtt_pages; ++i)
+		iowrite32(pte, dev_priv->gtt_map + i);
 
-	for (; i < pg->gatt_pages - tt_pages / 2; ++i)
-		iowrite32(pte, ttm_gtt_map + i);
 	(void) ioread32(dev_priv->gtt_map + i - 1);
-
 	return 0;
 
 out_err:

