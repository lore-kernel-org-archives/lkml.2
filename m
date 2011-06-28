Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab1F1WFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:05:25 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35053 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1F1WFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:05:20 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 08/29] gma500: trim some of the debug
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:04:55 +0100
Message-ID: <20110628220453.898.81145.stgit@bob.linux.org.uk>
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

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_fb.c  |    6 +-----
 drivers/staging/gma500/psb_gem.c |   11 -----------
 drivers/staging/gma500/psb_gtt.c |    2 --
 3 files changed, 1 insertions(+), 18 deletions(-)


diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index d005025..156f8ad 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -727,17 +727,13 @@ static void psb_user_framebuffer_destroy(struct drm_framebuffer *fb)
 
 	/* Should never get stolen memory for a user fb */
 	WARN_ON(r->stolen);
-	pr_err("user framebuffer destroy %p, fbdev %p\n",
-						psbfb, psbfb->fbdev);
+
 	/* Check if we are erroneously live */
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head)
 		if (crtc->fb == fb)
 			reset = 1;
 
 	if (reset)
-		pr_err("DRM: gma500, forcing reset\n");
-
-	if (reset)
 		/* 
 		 * Now force a sane response before we permit the DRM crc layer to
 		 * do stupid things like blank the display. Instead we reset this
diff --git a/drivers/staging/gma500/psb_gem.c b/drivers/staging/gma500/psb_gem.c
index b24b964..125ea6b 100644
--- a/drivers/staging/gma500/psb_gem.c
+++ b/drivers/staging/gma500/psb_gem.c
@@ -51,7 +51,6 @@ void psb_gem_free_object(struct drm_gem_object *obj)
 	}
 	drm_gem_object_release(obj);
 	/* This must occur last as it frees up the memory of the GEM object */
-	pr_err("GEM destroyed %p, %p\n", gtt, obj);
 	psb_gtt_free_range(obj->dev, gtt);
 }
 
@@ -177,8 +176,6 @@ static int psb_gem_create(struct drm_file *file,
 
 	size = roundup(size, PAGE_SIZE);
 
-	dev_err(dev->dev, "GEM creating %lld\n", size);
-
 	/* Allocate our object - for now a direct gtt range which is not 
 	   stolen memory backed */
 	r = psb_gtt_alloc_range(dev, size, "gem", 0);
@@ -206,8 +203,6 @@ static int psb_gem_create(struct drm_file *file,
 	/* We have the initial and handle reference but need only one now */
 	drm_gem_object_unreference(&r->gem);
 	*handlep = handle;
-	dev_err(dev->dev, "GEM handle %x for %p OK\n",
-				handle, &r->gem);
 	return 0;
 }
 
@@ -283,12 +278,9 @@ int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	   something from beneath our feet */
 	mutex_lock(&dev->struct_mutex);
 
-	dev_err(dev->dev, "Fault on GTT %p\n", r);
-
 	/* For now the mmap pins the object and it stays pinned. As things
 	   stand that will do us no harm */
 	if (r->mmapping == 0) {
-		dev_err(dev->dev, "Need to pin %p\n", r);
 		ret = psb_gtt_pin(r);
 		if (ret < 0) {
 		        DRM_ERROR("gma500: pin failed: %d\n", ret);
@@ -302,13 +294,10 @@ int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	page_offset = ((unsigned long) vmf->virtual_address - vma->vm_start)
 				>> PAGE_SHIFT;
 
-	dev_err(dev->dev, "Page offset %p %d\n", r, (int)page_offset);
         /* CPU view of the page, don't go via the GART for CPU writes */
 	pfn = page_to_phys(r->pages[page_offset]) >> PAGE_SHIFT;
 	ret = vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
 
-	dev_err(dev->dev, "PFN %ld for VA %p = %d\n", pfn, vmf->virtual_address, ret);
-
 fail:
         mutex_unlock(&dev->struct_mutex);
 	switch (ret) {
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index c6a7492..5a296e1 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -314,7 +314,6 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 				len, start, end, PAGE_SIZE, NULL, NULL);
 	if (ret == 0) {
 		gt->offset = gt->resource.start - r->start;
-		dev_err(dev->dev, "GTT new %p, %d\n", gt, gt->stolen);
 		return gt;
 	}
 	kfree(gt);
@@ -341,7 +340,6 @@ static void psb_gtt_destroy(struct kref *kref)
 	}
 	WARN_ON(gt->in_gart && !gt->stolen);
 	release_resource(&gt->resource);
-	pr_err("GTT destroyed %p, %d\n", gt, gt->stolen);
 	kfree(gt);
 }
 

