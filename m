Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab1DSOsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:48:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52957 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752859Ab1DSOsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:48:13 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 1/8] gma500: add the ability to request backed space or not
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 19 Apr 2011 15:27:10 +0100
Message-ID: <20110419142658.16479.59689.stgit@localhost.localdomain>
In-Reply-To: <20110419142432.16479.89255.stgit@localhost.localdomain>
References: <20110419142432.16479.89255.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will will need this for doing a GEM allocator. It should also avoid any
crashes with the current code if the stolen area is too small.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_fb.c  |    4 ++--
 drivers/staging/gma500/psb_gtt.c |   17 ++++++++++++++---
 drivers/staging/gma500/psb_gtt.h |    2 +-
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 0bad4e0..e06365b 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -479,8 +479,8 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	size = mode_cmd.pitch * mode_cmd.height;
 	aligned_size = ALIGN(size, PAGE_SIZE);
 
-	/* Allocate the framebuffer in the GTT */
-	backing = psb_gtt_alloc_range(dev, aligned_size, "fb");
+	/* Allocate the framebuffer in the GTT with stolen page backing */
+	backing = psb_gtt_alloc_range(dev, aligned_size, "fb", 1);
 	if (backing == NULL)
 	        return -ENOMEM;
 
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index a97e7be..69323f9 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -972,6 +972,7 @@ struct gtt_range *psb_gtt_lookup_handle(struct drm_device *dev, int handle)
  *	@dev: Our DRM device
  *	@len: length (bytes) of address space required
  *	@name: resource name
+ *	@backed: resource should be backed by stolen pages
  *
  *	Ask the kernel core to find us a suitable range of addresses
  *	to use for a GTT mapping.
@@ -981,12 +982,23 @@ struct gtt_range *psb_gtt_lookup_handle(struct drm_device *dev, int handle)
  *	as in use.
  */
 struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
-							const char *name)
+						const char *name, int backed)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct gtt_range *gt;
 	struct resource *r = dev_priv->gtt_mem;
 	int ret;
+	unsigned long start, end;
+	
+	if (backed) {
+	        /* The start of the GTT is the stolen pages */
+	        start = r->start;
+	        end = r->start + dev_priv->pg->stolen_size - 1;
+        } else {
+                /* The rest we will use for GEM backed objects */
+                start = r->start + dev_priv->pg->stolen_size;
+                end = -1;
+        }
 
 	gt = kzalloc(sizeof(struct gtt_range), GFP_KERNEL);
 	if (gt == NULL)
@@ -996,8 +1008,7 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 	kref_init(&gt->kref);
 
 	ret = allocate_resource(dev_priv->gtt_mem, &gt->resource,
-				len, 0, -1, /*r->start, r->end - 1, */
-				PAGE_SIZE, NULL, NULL);
+				len, start, end, PAGE_SIZE, NULL, NULL);
 	if (ret == 0) {
 	        gt->offset = gt->resource.start - r->start;
 		return gt;
diff --git a/drivers/staging/gma500/psb_gtt.h b/drivers/staging/gma500/psb_gtt.h
index 010ef70..dc2259c 100644
--- a/drivers/staging/gma500/psb_gtt.h
+++ b/drivers/staging/gma500/psb_gtt.h
@@ -105,7 +105,7 @@ extern int psb_gtt_release_handle(struct drm_device *dev, struct gtt_range *gt);
 extern struct gtt_range *psb_gtt_lookup_handle(struct drm_device *dev,
 							int handle);
 extern struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
-							const char *name);
+						const char *name, int backed);
 extern void psb_gtt_kref_put(struct gtt_range *gt);
 extern void psb_gtt_free_range(struct drm_device *dev, struct gtt_range *gt);
 

