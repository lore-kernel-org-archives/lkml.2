Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab1DMJ7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 05:59:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48640 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752741Ab1DMJ7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 05:59:01 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 5/5] gma500: Tidy up the allocations
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 13 Apr 2011 10:37:24 +0100
Message-ID: <20110413093709.28527.23051.stgit@localhost.localdomain>
In-Reply-To: <20110413093519.28527.36552.stgit@localhost.localdomain>
References: <20110413093519.28527.36552.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we can do allocations we need to shuffle the fb resource into the fb so
we can one day have multiple frame buffer objects.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.h |    2 --
 drivers/staging/gma500/psb_fb.c  |   13 ++++++-------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 7a0506a..9da6a33 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -245,8 +245,6 @@ struct drm_psb_private {
 	struct resource *gtt_mem;	/* Our PCI resource */
 	struct gtt_range *gtt_handles[GTT_MAX];
 
-	struct gtt_range *fb;		/* System frame buffer */
-
 	struct psb_mmu_driver *mmu;
 	struct psb_mmu_pd *pf_pd;
 
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 06715e8..0bad4e0 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -466,6 +466,7 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	struct device *device = &dev->pdev->dev;
 	int size, aligned_size;
 	int ret;
+	struct gtt_range *backing;
 
 	mode_cmd.width = sizes->surface_width;
 	mode_cmd.height = sizes->surface_height;
@@ -479,13 +480,12 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	aligned_size = ALIGN(size, PAGE_SIZE);
 
 	/* Allocate the framebuffer in the GTT */
-	/* FIXME: this cannot live in dev_priv once we go multi head */
-	dev_priv->fb = psb_gtt_alloc_range(dev, aligned_size, "fb");
-	if (dev_priv->fb == NULL)
+	backing = psb_gtt_alloc_range(dev, aligned_size, "fb");
+	if (backing == NULL)
 	        return -ENOMEM;
 
 	mutex_lock(&dev->struct_mutex);
-	fb = psb_framebuffer_create(dev, &mode_cmd, dev_priv->fb);
+	fb = psb_framebuffer_create(dev, &mode_cmd, backing);
 	if (!fb) {
 		DRM_ERROR("failed to allocate fb.\n");
 		ret = -ENOMEM;
@@ -518,7 +518,7 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	/* Accessed via stolen memory directly, This only works for stolem
 	   memory however. Need to address this once we start using gtt
 	   pages we allocate */
-	info->screen_base = (char *)pg->vram_addr + dev_priv->fb->offset;
+	info->screen_base = (char *)pg->vram_addr + backing->offset;
 	info->screen_size = size;
 	memset(info->screen_base, 0, size);
 
@@ -548,8 +548,7 @@ out_err0:
 	fb->funcs->destroy(fb);
 out_err1:
 	mutex_unlock(&dev->struct_mutex);
-	psb_gtt_free_range(dev, dev_priv->fb);
-	dev_priv->fb = NULL;
+	psb_gtt_free_range(dev, backing);
 	return ret;
 }
 

