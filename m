Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1GEOth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:49:37 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59136 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab1GEOtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:49:35 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 26/49] gma500: add more ops
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:39:50 +0100
Message-ID: <20110705143942.23872.84957.stgit@localhost.localdomain>
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Split the 2d properties, name, and various function vectors out so that we
can get rid of more conditional gloop in favour of a per device structure.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mdfld_device.c      |    5 +++++
 drivers/staging/gma500/mrst_device.c       |    5 +++++
 drivers/staging/gma500/psb_device.c        |    5 +++++
 drivers/staging/gma500/psb_drv.h           |   11 +++++++++++
 drivers/staging/gma500/psb_fb.c            |    8 ++++----
 drivers/staging/gma500/psb_intel_display.c |   21 +++++----------------
 6 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/gma500/mdfld_device.c b/drivers/staging/gma500/mdfld_device.c
index e86e476..3955448 100644
--- a/drivers/staging/gma500/mdfld_device.c
+++ b/drivers/staging/gma500/mdfld_device.c
@@ -687,6 +687,11 @@ static int mdfld_power_up(struct drm_device *dev)
 }
 
 const struct psb_ops mdfld_chip_ops = {
+	.name = "Medfield",
+	.accel_2d = 0,
+	.crtc_helper = &mdfld_helper_funcs,
+	.crtc_funcs = &mdfld_intel_crtc_funcs,
+
 	.output_init = mdfld_output_init,
 
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
diff --git a/drivers/staging/gma500/mrst_device.c b/drivers/staging/gma500/mrst_device.c
index daeeb18..79cd784 100644
--- a/drivers/staging/gma500/mrst_device.c
+++ b/drivers/staging/gma500/mrst_device.c
@@ -352,6 +352,11 @@ static int mrst_power_up(struct drm_device *dev)
 }
 
 const struct psb_ops mrst_chip_ops = {
+	.name = "Moorestown",
+	.accel_2d = 1,
+	.crtc_helper = &mrst_helper_funcs,
+	.crtc_funcs = &psb_intel_crtc_funcs,
+
 	.output_init = mrst_output_init,
 
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
diff --git a/drivers/staging/gma500/psb_device.c b/drivers/staging/gma500/psb_device.c
index 4a3c516..0402171 100644
--- a/drivers/staging/gma500/psb_device.c
+++ b/drivers/staging/gma500/psb_device.c
@@ -282,6 +282,11 @@ int psb_power_up(struct drm_device *dev)
 }
 
 const struct psb_ops psb_chip_ops = {
+	.name = "Poulsbo",
+	.accel_2d = 1,
+	.crtc_helper = &psb_intel_helper_funcs,
+	.crtc_funcs = &psb_intel_crtc_funcs,
+
 	.output_init = psb_output_init,
 
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index b0908f2..4bc5e8d 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -617,6 +617,13 @@ struct drm_psb_private {
  */
  
 struct psb_ops {
+	const char *name;
+	unsigned int accel_2d:1;
+
+	/* Sub functions */
+	struct drm_crtc_helper_funcs const *crtc_helper;
+	struct drm_crtc_funcs const *crtc_funcs;
+
 	/* Display management hooks */
 	int (*output_init)(struct drm_device *dev);
 	/* Power management hooks */
@@ -759,6 +766,10 @@ extern const struct drm_crtc_helper_funcs mrst_helper_funcs;
 extern void mrst_lvds_init(struct drm_device *dev,
 		    struct psb_intel_mode_device *mode_dev);
 
+/* psb_intel_display.c */
+extern const struct drm_crtc_helper_funcs psb_intel_helper_funcs;
+extern const struct drm_crtc_funcs psb_intel_crtc_funcs;
+
 /* psb_intel_lvds.c */
 extern void psb_intel_lvds_prepare(struct drm_encoder *encoder);
 extern void psb_intel_lvds_commit(struct drm_encoder *encoder);
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 32d9016..349fff8 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -211,7 +211,7 @@ static int psbfb_ioctl(struct fb_info *info, unsigned int cmd,
 	case 0x12345678:
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
-		if (IS_MFLD(dev))
+		if (!dev_priv->ops->accel_2d)
 			return -EOPNOTSUPP;
 		if (get_user(l, p))
 			return -EFAULT;
@@ -240,7 +240,7 @@ static struct fb_ops psbfb_ops = {
 	.fb_ioctl = psbfb_ioctl,
 };
 
-static struct fb_ops psbfb_mfld_ops = {
+static struct fb_ops psbfb_unaccel_ops = {
 	.owner = THIS_MODULE,
 	.fb_check_var = drm_fb_helper_check_var,
 	.fb_set_par = drm_fb_helper_set_par,
@@ -426,8 +426,8 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 
 	info->flags = FBINFO_DEFAULT;
 	/* No 2D engine */
-	if (IS_MFLD(dev))
-		info->fbops = &psbfb_mfld_ops;
+	if (!dev_priv->ops->accel_2d)
+		info->fbops = &psbfb_unaccel_ops;
 	else
 		info->fbops = &psbfb_ops;
 
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index 0e9758a..c38e819 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -1260,7 +1260,7 @@ void psb_intel_crtc_destroy(struct drm_crtc *crtc)
 	kfree(psb_intel_crtc);
 }
 
-static const struct drm_crtc_helper_funcs psb_intel_helper_funcs = {
+const struct drm_crtc_helper_funcs psb_intel_helper_funcs = {
 	.dpms = psb_intel_crtc_dpms,
 	.mode_fixup = psb_intel_crtc_mode_fixup,
 	.mode_set = psb_intel_crtc_mode_set,
@@ -1304,12 +1304,8 @@ void psb_intel_crtc_init(struct drm_device *dev, int pipe,
 		return;
 	}
 
-	if (IS_MFLD(dev))
-		drm_crtc_init(dev, &psb_intel_crtc->base,
-						&mdfld_intel_crtc_funcs);
-	else
-        	drm_crtc_init(dev, &psb_intel_crtc->base,
-						&psb_intel_crtc_funcs);
+	/* Set the CRTC operations from the chip specific data */
+	drm_crtc_init(dev, &psb_intel_crtc->base, dev_priv->ops->crtc_funcs);
 
 	drm_mode_crtc_set_gamma_size(&psb_intel_crtc->base, 256);
 	psb_intel_crtc->pipe = pipe;
@@ -1332,15 +1328,8 @@ void psb_intel_crtc_init(struct drm_device *dev, int pipe,
 	psb_intel_crtc->mode_dev = mode_dev;
 	psb_intel_crtc->cursor_addr = 0;
 
-	if (IS_MRST(dev))
-		drm_crtc_helper_add(&psb_intel_crtc->base,
-				    &mrst_helper_funcs);
-	else if (IS_MFLD(dev))
-		drm_crtc_helper_add(&psb_intel_crtc->base,
-				    &mdfld_helper_funcs);
-	else
-		drm_crtc_helper_add(&psb_intel_crtc->base,
-				    &psb_intel_helper_funcs);
+	drm_crtc_helper_add(&psb_intel_crtc->base,
+	                                dev_priv->ops->crtc_helper);
 
 	/* Setup the array of drm_connector pointer array */
 	psb_intel_crtc->mode_set.crtc = &psb_intel_crtc->base;

