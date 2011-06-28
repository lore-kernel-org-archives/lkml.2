Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1F1WGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:06:47 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40978 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab1F1WGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:06:37 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 13/29] gma500: Kill spare kref
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:06:12 +0100
Message-ID: <20110628220610.898.21862.stgit@bob.linux.org.uk>
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

We are using the underlying kref in the GEM object so we don't need our own

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_fb.c  |    1 -
 drivers/staging/gma500/psb_gtt.c |   41 ++++++--------------------------------
 drivers/staging/gma500/psb_gtt.h |    1 -
 3 files changed, 6 insertions(+), 37 deletions(-)


diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 988f4db..fb75aba 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -231,7 +231,6 @@ static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 	struct psb_fbdev *fbdev = info->par;
 	struct psb_framebuffer *psbfb = &fbdev->pfb;
 	char *fb_screen_base = NULL;
-	struct drm_device *dev = psbfb->base.dev;
 
 	if (vma->vm_pgoff != 0)
 		return -EINVAL;
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 54a9308..9da1375 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -303,8 +303,6 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 	gt->in_gart = backed;
 	/* Ensure this is set for non GEM objects */
 	gt->gem.dev = dev;
-	kref_init(&gt->kref);
-
 	ret = allocate_resource(dev_priv->gtt_mem, &gt->resource,
 				len, start, end, PAGE_SIZE, NULL, NULL);
 	if (ret == 0) {
@@ -316,18 +314,15 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 }
 
 /**
- *	psb_gtt_destroy		-	final free up of a gtt
- *	@kref: the kref of the gtt
- *
- *	Called from the kernel kref put when the final reference to our
- *	GTT object is dropped. At that point we can free up the resources.
+ *	psb_gtt_free_range	-	release GTT address space
+ *	@dev: our DRM device
+ *	@gt: a mapping created with psb_gtt_alloc_range
  *
- *	For now we handle mmap clean up here to work around limits in GEM
+ *	Release a resource that was allocated with psb_gtt_alloc_range. If the object
+ *	has been pinned by mmap users we clean this up here currently.
  */
-static void psb_gtt_destroy(struct kref *kref)
+void psb_gtt_free_range(struct drm_device *dev, struct gtt_range *gt)
 {
-	struct gtt_range *gt = container_of(kref, struct gtt_range, kref);
-
 	/* Undo the mmap pin if we are destroying the object */
 	if (gt->mmapping) {
 		psb_gtt_unpin(gt);
@@ -338,30 +333,6 @@ static void psb_gtt_destroy(struct kref *kref)
 	kfree(gt);
 }
 
-/**
- *	psb_gtt_kref_put	-	drop reference to a GTT object
- *	@gt: the GT being dropped
- *
- *	Drop a reference to a psb gtt
- */
-void psb_gtt_kref_put(struct gtt_range *gt)
-{
-	kref_put(&gt->kref, psb_gtt_destroy);
-}
-
-/**
- *	psb_gtt_free_range	-	release GTT address space
- *	@dev: our DRM device
- *	@gt: a mapping created with psb_gtt_alloc_range
- *
- *	Release a resource that was allocated with psb_gtt_alloc_range
- */
-void psb_gtt_free_range(struct drm_device *dev, struct gtt_range *gt)
-{
-	psb_gtt_kref_put(gt);
-}
-
-
 struct psb_gtt *psb_gtt_alloc(struct drm_device *dev)
 {
 	struct psb_gtt *tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
diff --git a/drivers/staging/gma500/psb_gtt.h b/drivers/staging/gma500/psb_gtt.h
index 7e1f21e..4d6dc5f 100644
--- a/drivers/staging/gma500/psb_gtt.h
+++ b/drivers/staging/gma500/psb_gtt.h
@@ -44,7 +44,6 @@ extern void psb_gtt_takedown(struct drm_device *dev);
 struct gtt_range {
 	struct resource resource;	/* Resource for our allocation */
 	u32 offset;			/* GTT offset of our object */
-	struct kref kref;		/* Can probably go FIXME - GEM kref will do */
 	struct drm_gem_object gem;	/* GEM high level stuff */
 	int in_gart;			/* Currently in the GART (ref ct) */
 	bool stolen;			/* Backed from stolen RAM */

