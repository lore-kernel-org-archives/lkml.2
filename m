Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab1GOQmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:42:47 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35820 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab1GOQmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:42:46 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 07/15] gma500: fix compile warnings when
 CONFIG_BACKLIGHT_CLASS_DEVICE is not defined
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 15 Jul 2011 17:33:57 +0100
Message-ID: <20110715163353.28759.57635.stgit@localhost.localdomain>
In-Reply-To: <20110715163117.28759.14946.stgit@localhost.localdomain>
References: <20110715163117.28759.14946.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Octavian Purdila <octavian.purdila@intel.com>

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
[Fixed up for other changes, and tidied some existing variable names]
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/backlight.c        |    2 ++
 drivers/staging/gma500/mdfld_dsi_output.c |    5 ++---
 drivers/staging/gma500/psb_drv.c          |   28 +++++++++++++---------------
 drivers/staging/gma500/psb_intel_lvds.c   |   19 +++++++------------
 4 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/gma500/backlight.c b/drivers/staging/gma500/backlight.c
index d3e698b..2079395 100644
--- a/drivers/staging/gma500/backlight.c
+++ b/drivers/staging/gma500/backlight.c
@@ -31,6 +31,8 @@ int gma_backlight_init(struct drm_device *dev)
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	return dev_priv->ops->backlight_init(dev);
+#else
+	return 0;
 #endif
 }
 
diff --git a/drivers/staging/gma500/mdfld_dsi_output.c b/drivers/staging/gma500/mdfld_dsi_output.c
index e911ef2..ff75ece 100644
--- a/drivers/staging/gma500/mdfld_dsi_output.c
+++ b/drivers/staging/gma500/mdfld_dsi_output.c
@@ -467,8 +467,6 @@ static int mdfld_dsi_connector_set_property(struct drm_connector * connector,
 											uint64_t value)
 {
 	struct drm_encoder * encoder = connector->encoder;
-	struct backlight_device * psb_bd;
-	struct drm_psb_private * dev_priv = encoder->dev->dev_private;
 
 	if (!strcmp(property->name, "scaling mode") && encoder) {
 		struct psb_intel_crtc * psb_crtc = to_psb_intel_crtc(encoder->crtc);
@@ -515,13 +513,14 @@ static int mdfld_dsi_connector_set_property(struct drm_connector * connector,
 		}
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
 	} else if (!strcmp(property->name, "backlight") && encoder) {
+		struct drm_psb_private *dev_priv = encoder->dev->dev_private;
+		struct backlight_device *psb_bd = dev_priv->backlight_device;
 		dev_dbg(encoder->dev->dev, "backlight level = %d\n", (int)value);
 		if (drm_connector_property_set_value(connector, property, value))
 			goto set_prop_error;
 		else {
 			dev_dbg(encoder->dev->dev,
 			                "set brightness to %d", (int)value);
-			psb_bd = dev_priv->backlight_device;
 			if (psb_bd) {
 				psb_bd->props.brightness = value;
 				backlight_update_status(psb_bd);
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index f96a619..6b03951ebd 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -536,20 +536,24 @@ static int psb_dc_state_ioctl(struct drm_device *dev, void * data,
 	return -EINVAL;
 }
 
-static int psb_dpst_bl_ioctl(struct drm_device *dev, void *data,
-		       struct drm_file *file_priv)
+static inline void get_brightness(struct backlight_device *bd)
 {
-	struct drm_psb_private *dev_priv = psb_priv(dev);
-	uint32_t *arg = data;
-	struct backlight_device *bd = dev_priv->backlight_device;
-	dev_priv->blc_adj2 = *arg;
-
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
 	if (bd) {
 		bd->props.brightness = bd->ops->get_brightness(bd);
 		backlight_update_status(bd);
 	}
 #endif
+}
+
+static int psb_dpst_bl_ioctl(struct drm_device *dev, void *data,
+		       struct drm_file *file_priv)
+{
+	struct drm_psb_private *dev_priv = psb_priv(dev);
+	uint32_t *arg = data;
+
+	dev_priv->blc_adj2 = *arg;
+	get_brightness(dev_priv->backlight_device);
 	return 0;
 }
 
@@ -558,15 +562,9 @@ static int psb_adb_ioctl(struct drm_device *dev, void *data,
 {
 	struct drm_psb_private *dev_priv = psb_priv(dev);
 	uint32_t *arg = data;
-	struct backlight_device *bd = dev_priv->backlight_device;
-	dev_priv->blc_adj1 = *arg;
 
-#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
-	if (bd) {
-		bd->props.brightness = bd->ops->get_brightness(bd);
-		backlight_update_status(bd);
-	}
-#endif
+	dev_priv->blc_adj1 = *arg;
+	get_brightness(dev_priv->backlight_device);
 	return 0;
 }
 
diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index 03132a4..da6f5c8 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -467,8 +467,6 @@ static void psb_intel_lvds_mode_set(struct drm_encoder *encoder,
 				struct drm_display_mode *mode,
 				struct drm_display_mode *adjusted_mode)
 {
-	struct psb_intel_mode_device *mode_dev =
-	    enc_to_psb_intel_output(encoder)->mode_dev;
 	struct drm_device *dev = encoder->dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 pfit_control;
@@ -571,17 +569,14 @@ int psb_intel_lvds_set_property(struct drm_connector *connector,
 				       uint64_t value)
 {
 	struct drm_encoder *encoder = connector->encoder;
-	struct drm_psb_private *dev_priv;
 
 	if (!encoder)
 		return -1;
 
-	dev_priv = encoder->dev->dev_private;
-
 	if (!strcmp(property->name, "scaling mode")) {
 		struct psb_intel_crtc *crtc =
 					to_psb_intel_crtc(encoder->crtc);
-		uint64_t curValue;
+		uint64_t curval;
 
 		if (!crtc)
 			goto set_prop_error;
@@ -599,10 +594,10 @@ int psb_intel_lvds_set_property(struct drm_connector *connector,
 
 		if (drm_connector_property_get_value(connector,
 						     property,
-						     &curValue))
+						     &curval))
 			goto set_prop_error;
 
-		if (curValue == value)
+		if (curval == value)
 			goto set_prop_done;
 
 		if (drm_connector_property_set_value(connector,
@@ -626,8 +621,8 @@ int psb_intel_lvds_set_property(struct drm_connector *connector,
 			goto set_prop_error;
 		else {
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
-			struct backlight_device *bd =
-					dev_priv->backlight_device;
+			struct drm_psb_private *devp = encoder->dev->dev_private;
+			struct backlight_device *bd = devp->backlight_device;
 			if (bd) {
 				bd->props.brightness = value;
 				backlight_update_status(bd);
@@ -635,9 +630,9 @@ int psb_intel_lvds_set_property(struct drm_connector *connector,
 #endif
 		}
 	} else if (!strcmp(property->name, "DPMS")) {
-		struct drm_encoder_helper_funcs *pEncHFuncs
+		struct drm_encoder_helper_funcs *hfuncs
 						= encoder->helper_private;
-		pEncHFuncs->dpms(encoder, value);
+		hfuncs->dpms(encoder, value);
 	}
 
 set_prop_done:

