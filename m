Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830Ab1GKStq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:49:46 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58560 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758206Ab1GKStp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:49:45 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/4] gma500: don't dynamically allocate the psb_gtt struct
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 11 Jul 2011 19:40:34 +0100
Message-ID: <20110711183954.8996.55082.stgit@localhost.localdomain>
In-Reply-To: <20110711183933.8996.37507.stgit@localhost.localdomain>
References: <20110711183933.8996.37507.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

It's part of the psb_device so just make it part of the struct not a
pointer. This does cause a bit of noise shuffling indirections.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/accel_2d.c             |    2 +-
 drivers/staging/gma500/framebuffer.c          |    4 ++--
 drivers/staging/gma500/gtt.c                  |   24 +++++++-----------------
 drivers/staging/gma500/gtt.h                  |    3 +--
 drivers/staging/gma500/mdfld_dsi_dbi.c        |    2 +-
 drivers/staging/gma500/mdfld_dsi_pkg_sender.c |    2 +-
 drivers/staging/gma500/psb_drv.c              |    6 +++---
 drivers/staging/gma500/psb_drv.h              |    2 +-
 8 files changed, 17 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/gma500/accel_2d.c b/drivers/staging/gma500/accel_2d.c
index 5ca4c42..c719017 100644
--- a/drivers/staging/gma500/accel_2d.c
+++ b/drivers/staging/gma500/accel_2d.c
@@ -69,7 +69,7 @@ void psb_spank(struct drm_psb_private *dev_priv)
 	PSB_WSGX32(PSB_RSGX32(PSB_CR_BIF_CTRL) & ~_PSB_CB_CTRL_CLEAR_FAULT,
 		   PSB_CR_BIF_CTRL);
 	(void) PSB_RSGX32(PSB_CR_BIF_CTRL);
-	PSB_WSGX32(dev_priv->pg->gatt_start, PSB_CR_BIF_TWOD_REQ_BASE);
+	PSB_WSGX32(dev_priv->gtt.gatt_start, PSB_CR_BIF_TWOD_REQ_BASE);
 }
 
 /**
diff --git a/drivers/staging/gma500/framebuffer.c b/drivers/staging/gma500/framebuffer.c
index e2ee579..76b986f 100644
--- a/drivers/staging/gma500/framebuffer.c
+++ b/drivers/staging/gma500/framebuffer.c
@@ -458,14 +458,14 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	}
 	info->screen_size = size;
 
-	if (dev_priv->pg->stolen_size) {
+	if (dev_priv->gtt.stolen_size) {
 		info->apertures = alloc_apertures(1);
 		if (!info->apertures) {
 			ret = -ENOMEM;
 			goto out_unref;
 		}
 		info->apertures->ranges[0].base = dev->mode_config.fb_base;
-		info->apertures->ranges[0].size = dev_priv->pg->stolen_size;
+		info->apertures->ranges[0].size = dev_priv->gtt.stolen_size;
 	}
 
 	drm_fb_helper_fill_fix(info, fb->pitch, fb->depth);
diff --git a/drivers/staging/gma500/gtt.c b/drivers/staging/gma500/gtt.c
index 7a1a89a..461ead2 100644
--- a/drivers/staging/gma500/gtt.c
+++ b/drivers/staging/gma500/gtt.c
@@ -287,10 +287,10 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 	if (backed) {
 		/* The start of the GTT is the stolen pages */
 		start = r->start;
-		end = r->start + dev_priv->pg->stolen_size - 1;
+		end = r->start + dev_priv->gtt.stolen_size - 1;
 	} else {
 		/* The rest we will use for GEM backed objects */
-		start = r->start + dev_priv->pg->stolen_size;
+		start = r->start + dev_priv->gtt.stolen_size;
 		end = r->end;
 	}
 
@@ -332,17 +332,10 @@ void psb_gtt_free_range(struct drm_device *dev, struct gtt_range *gt)
 	kfree(gt);
 }
 
-struct psb_gtt *psb_gtt_alloc(struct drm_device *dev)
+void psb_gtt_alloc(struct drm_device *dev)
 {
-	struct psb_gtt *tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
-
-	if (!tmp)
-		return NULL;
-
-	init_rwsem(&tmp->sem);
-	tmp->dev = dev;
-
-	return tmp;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	init_rwsem(&dev_priv->gtt.sem);
 }
 
 void psb_gtt_takedown(struct drm_device *dev)
@@ -361,8 +354,6 @@ void psb_gtt_takedown(struct drm_device *dev)
 	}
 	if (dev_priv->vram_addr)
 		iounmap(dev_priv->gtt_map);
-	kfree(dev_priv->pg);
-	dev_priv->pg = NULL;
 }
 
 int psb_gtt_init(struct drm_device *dev, int resume)
@@ -381,9 +372,8 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 
 	mutex_init(&dev_priv->gtt_mutex);
 
-	dev_priv->pg = pg = psb_gtt_alloc(dev);
-	if (pg == NULL)
-		return -ENOMEM;
+	psb_gtt_alloc(dev);
+	pg = &dev_priv->gtt;
 
 	/* Enable the GTT */
 	pci_read_config_word(dev->pdev, PSB_GMCH_CTRL, &dev_priv->gmch_ctrl);
diff --git a/drivers/staging/gma500/gtt.h b/drivers/staging/gma500/gtt.h
index 4d6dc5f..e0e1cb6 100644
--- a/drivers/staging/gma500/gtt.h
+++ b/drivers/staging/gma500/gtt.h
@@ -24,7 +24,6 @@
 
 /* This wants cleaning up with respect to the psb_dev and un-needed stuff */
 struct psb_gtt {
-	struct drm_device *dev;
 	uint32_t gatt_start;
 	uint32_t mmu_gatt_start;
 	uint32_t gtt_start;
@@ -36,7 +35,7 @@ struct psb_gtt {
 	struct rw_semaphore sem;
 };
 
-/*Exported functions*/
+/* Exported functions */
 extern int psb_gtt_init(struct drm_device *dev, int resume);
 extern void psb_gtt_takedown(struct drm_device *dev);
 
diff --git a/drivers/staging/gma500/mdfld_dsi_dbi.c b/drivers/staging/gma500/mdfld_dsi_dbi.c
index 4897345..1421f49 100644
--- a/drivers/staging/gma500/mdfld_dsi_dbi.c
+++ b/drivers/staging/gma500/mdfld_dsi_dbi.c
@@ -769,7 +769,7 @@ struct mdfld_dsi_encoder *mdfld_dsi_dbi_init(struct drm_device *dev,
 	struct drm_connector *connector = NULL;
 	struct drm_encoder *encoder = NULL;
 	struct drm_display_mode *fixed_mode = NULL;
-	struct psb_gtt *pg = dev_priv ? (dev_priv->pg) : NULL;
+	struct psb_gtt *pg = dev_priv ? (&dev_priv->gtt) : NULL;
 
 #ifdef CONFIG_MDFLD_DSI_DPU
 	struct mdfld_dbi_dpu_info *dpu_info = dev_priv ? (dev_priv->dbi_dpu_info) : NULL;
diff --git a/drivers/staging/gma500/mdfld_dsi_pkg_sender.c b/drivers/staging/gma500/mdfld_dsi_pkg_sender.c
index 9b543eb..745d4ad 100644
--- a/drivers/staging/gma500/mdfld_dsi_pkg_sender.c
+++ b/drivers/staging/gma500/mdfld_dsi_pkg_sender.c
@@ -953,7 +953,7 @@ int mdfld_dsi_pkg_sender_init(struct mdfld_dsi_connector *dsi_connector,
 					mdfld_dsi_get_config(dsi_connector);
 	struct drm_device *dev = dsi_config->dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct psb_gtt *pg = dev_priv->pg;
+	struct psb_gtt *pg = &dev_priv->gtt;
 	int i;
 	struct mdfld_dsi_pkg *pkg, *tmp;
 
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index b85e538..f626480 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -176,7 +176,7 @@ static int psb_do_init(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv =
 	    (struct drm_psb_private *) dev->dev_private;
-	struct psb_gtt *pg = dev_priv->pg;
+	struct psb_gtt *pg = &dev_priv->gtt;
 
 	uint32_t stolen_gtt;
 
@@ -255,7 +255,7 @@ static int psb_driver_unload(struct drm_device *dev)
 			dev_priv->pf_pd = NULL;
 		}
 		if (dev_priv->mmu) {
-			struct psb_gtt *pg = dev_priv->pg;
+			struct psb_gtt *pg = &dev_priv->gtt;
 
 			down_read(&pg->sem);
 			psb_mmu_remove_pfn_sequence(
@@ -352,7 +352,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	if (!dev_priv->mmu)
 		goto out_err;
 
-	pg = dev_priv->pg;
+	pg = &dev_priv->gtt;
 
 	tt_pages = (pg->gatt_pages < PSB_TT_PRIV0_PLIMIT) ?
 		(pg->gatt_pages) : PSB_TT_PRIV0_PLIMIT;
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index f5ecd6d..50a4f17 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -263,7 +263,7 @@ struct drm_psb_private {
 	struct drm_device *dev;
 	const struct psb_ops *ops;
 
-	struct psb_gtt *pg;
+	struct psb_gtt gtt;
 
 	/* GTT Memory manager */
 	struct psb_gtt_mm *gtt_mm;

