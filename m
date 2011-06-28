Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab1F1WHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:07:18 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40983 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab1F1WHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:07:03 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 15/29] gma500: Use the GEM tweaks to provide a GEM frame buffer
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:06:39 +0100
Message-ID: <20110628220637.898.36502.stgit@bob.linux.org.uk>
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

We can now make our system frame buffer a GEM object.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_fb.c  |   11 +++++++----
 drivers/staging/gma500/psb_gem.c |   11 ++++++++---
 2 files changed, 15 insertions(+), 7 deletions(-)


diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index fb75aba..400dbee 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -186,6 +186,8 @@ static int psbfb_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct psb_framebuffer *psbfb = vma->vm_private_data;
 	struct drm_device *dev = psbfb->base.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	/* FIXME: assumes fb at stolen base which may not be true */
 	unsigned long phys_addr = (unsigned long)dev_priv->stolen_base;
 
 	page_num = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
@@ -381,8 +383,11 @@ static struct gtt_range *psbfb_alloc(struct drm_device *dev, int aligned_size)
 	struct gtt_range *backing;
 	/* Begin by trying to use stolen memory backing */
 	backing = psb_gtt_alloc_range(dev, aligned_size, "fb", 1);
-	if (backing)
-		return backing;
+	if (backing) {
+	        if (drm_gem_private_object_init(dev, &backing->gem, aligned_size) == 0)
+        		return backing;
+                psb_gtt_free_range(dev, backing);
+        }
 	/* Next try using GEM host memory */
 	backing = psb_gtt_alloc_range(dev, aligned_size, "fb(gem)", 0);
 	if (backing == NULL)
@@ -683,8 +688,6 @@ static int psb_user_framebuffer_create_handle(struct drm_framebuffer *fb,
 {
         struct psb_framebuffer *psbfb = to_psb_fb(fb);
         struct gtt_range *r = psbfb->gtt;
-        if (r->stolen)
-                return -EOPNOTSUPP;
         return drm_gem_handle_create(file_priv, &r->gem, handle);
 }
 
diff --git a/drivers/staging/gma500/psb_gem.c b/drivers/staging/gma500/psb_gem.c
index 7f6f479..4aec38c 100644
--- a/drivers/staging/gma500/psb_gem.c
+++ b/drivers/staging/gma500/psb_gem.c
@@ -49,7 +49,7 @@ void psb_gem_free_object(struct drm_gem_object *obj)
 		kfree(list->map);
 		list->map = NULL;
 	}
-	drm_gem_object_release(obj);
+	drm_gem_object_release_wrap(obj);
 	/* This must occur last as it frees up the memory of the GEM object */
 	psb_gtt_free_range(obj->dev, gtt);
 }
@@ -268,9 +268,11 @@ int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	unsigned long pfn;
 	pgoff_t page_offset;
 	struct drm_device *dev;
+	struct drm_psb_private *dev_priv;
 
 	obj = vma->vm_private_data;	/* GEM object */
 	dev = obj->dev;
+	dev_priv = dev->dev_private;
 
 	r = container_of(obj, struct gtt_range, gem);	/* Get the gtt range */
 
@@ -294,8 +296,11 @@ int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	page_offset = ((unsigned long) vmf->virtual_address - vma->vm_start)
 				>> PAGE_SHIFT;
 
-        /* CPU view of the page, don't go via the GART for CPU writes */
-	pfn = page_to_phys(r->pages[page_offset]) >> PAGE_SHIFT;
+	/* CPU view of the page, don't go via the GART for CPU writes */
+	if (r->stolen)
+		pfn = (dev_priv->stolen_base + r->offset) >> PAGE_SHIFT;
+	else
+		pfn = page_to_pfn(r->pages[page_offset]);
 	ret = vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
 
 fail:

