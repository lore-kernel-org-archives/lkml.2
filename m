Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1J0WCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 18:02:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56538 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab1J0WCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 18:02:52 -0400
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, greg@kroah.com
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 7/9] gma500: Convert Cedarview to work with new output handling
Date: Fri, 28 Oct 2011 00:02:12 +0200
Message-Id: <1319752934-1919-8-git-send-email-patrik.r.jakobsson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
References: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace psb_intel_output with psb_intel_encoder and psb_intel_connector.
Things will need to be cleaned up and tested so consider this an initial
patch for Cedarview.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
---
 drivers/staging/gma500/cdv_intel_crt.c     |   47 +++++++-----
 drivers/staging/gma500/cdv_intel_display.c |   14 ++--
 drivers/staging/gma500/cdv_intel_hdmi.c    |  112 +++++++++++++++-----------
 drivers/staging/gma500/cdv_intel_lvds.c    |  117 +++++++++++++++-------------
 drivers/staging/gma500/psb_drv.h           |    2 +-
 drivers/staging/gma500/psb_intel_drv.h     |    5 +
 6 files changed, 169 insertions(+), 128 deletions(-)

diff --git a/drivers/staging/gma500/cdv_intel_crt.c b/drivers/staging/gma500/cdv_intel_crt.c
index efda63b..6d0f10b 100644
--- a/drivers/staging/gma500/cdv_intel_crt.c
+++ b/drivers/staging/gma500/cdv_intel_crt.c
@@ -204,9 +204,10 @@ static enum drm_connector_status cdv_intel_crt_detect(
 
 static void cdv_intel_crt_destroy(struct drm_connector *connector)
 {
-	struct psb_intel_output *intel_output = to_psb_intel_output(connector);
+	struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(connector);
 
-	psb_intel_i2c_destroy(intel_output->ddc_bus);
+	psb_intel_i2c_destroy(psb_intel_encoder->ddc_bus);
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
 	kfree(connector);
@@ -214,9 +215,9 @@ static void cdv_intel_crt_destroy(struct drm_connector *connector)
 
 static int cdv_intel_crt_get_modes(struct drm_connector *connector)
 {
-	struct psb_intel_output *intel_output =
-				to_psb_intel_output(connector);
-	return psb_intel_ddc_get_modes(intel_output);
+	struct psb_intel_encoder *psb_intel_encoder =
+				psb_intel_attached_encoder(connector);
+	return psb_intel_ddc_get_modes(connector, &psb_intel_encoder->ddc_bus->adapter);
 }
 
 static int cdv_intel_crt_set_property(struct drm_connector *connector,
@@ -266,27 +267,31 @@ void cdv_intel_crt_init(struct drm_device *dev,
 			struct psb_intel_mode_device *mode_dev)
 {
 
-	struct psb_intel_output *psb_intel_output;
+	struct psb_intel_connector *psb_intel_connector;
+	struct psb_intel_encoder *psb_intel_encoder;
 	struct drm_connector *connector;
 	struct drm_encoder *encoder;
 
 	u32 i2c_reg;
 
-	psb_intel_output = kzalloc(sizeof(struct psb_intel_output), GFP_KERNEL);
-	if (!psb_intel_output)
+	psb_intel_encoder = kzalloc(sizeof(struct psb_intel_encoder), GFP_KERNEL);
+	if (!psb_intel_encoder)
 		return;
 
-	psb_intel_output->mode_dev = mode_dev;
-	connector = &psb_intel_output->base;
+	psb_intel_connector = kzalloc(sizeof(struct psb_intel_connector), GFP_KERNEL);
+	if (!psb_intel_connector)
+		goto failed_connector;
+
+	connector = &psb_intel_connector->base;
 	drm_connector_init(dev, connector,
 		&cdv_intel_crt_connector_funcs, DRM_MODE_CONNECTOR_VGA);
 
-	encoder = &psb_intel_output->enc;
+	encoder = &psb_intel_encoder->base;
 	drm_encoder_init(dev, encoder,
 		&cdv_intel_crt_enc_funcs, DRM_MODE_ENCODER_DAC);
 
-	drm_mode_connector_attach_encoder(&psb_intel_output->base,
-					  &psb_intel_output->enc);
+	psb_intel_connector_attach_encoder(psb_intel_connector,
+					   psb_intel_encoder);
 
 	/* Set up the DDC bus. */
 	i2c_reg = GPIOA;
@@ -295,15 +300,15 @@ void cdv_intel_crt_init(struct drm_device *dev,
 	if (dev_priv->crt_ddc_bus != 0)
 		i2c_reg = dev_priv->crt_ddc_bus;
 	}*/
-	psb_intel_output->ddc_bus = psb_intel_i2c_create(dev,
-						i2c_reg, "CRTDDC_A");
-	if (!psb_intel_output->ddc_bus) {
+	psb_intel_encoder->ddc_bus = psb_intel_i2c_create(dev,
+							  i2c_reg, "CRTDDC_A");
+	if (!psb_intel_encoder->ddc_bus) {
 		dev_printk(KERN_ERR, &dev->pdev->dev, "DDC bus registration "
 			   "failed.\n");
 		goto failed_ddc;
 	}
 
-	psb_intel_output->type = INTEL_OUTPUT_ANALOG;
+	psb_intel_encoder->type = INTEL_OUTPUT_ANALOG;
 	/*
 	psb_intel_output->clone_mask = (1 << INTEL_ANALOG_CLONE_BIT);
 	psb_intel_output->crtc_mask = (1 << 0) | (1 << 1);
@@ -319,8 +324,10 @@ void cdv_intel_crt_init(struct drm_device *dev,
 
 	return;
 failed_ddc:
-	drm_encoder_cleanup(&psb_intel_output->enc);
-	drm_connector_cleanup(&psb_intel_output->base);
-	kfree(psb_intel_output);
+	drm_encoder_cleanup(&psb_intel_encoder->base);
+	drm_connector_cleanup(&psb_intel_connector->base);
+	kfree(psb_intel_connector);
+failed_connector:
+	kfree(psb_intel_encoder);
 	return;
 }
diff --git a/drivers/staging/gma500/cdv_intel_display.c b/drivers/staging/gma500/cdv_intel_display.c
index 7b97c60..dfff2a6 100644
--- a/drivers/staging/gma500/cdv_intel_display.c
+++ b/drivers/staging/gma500/cdv_intel_display.c
@@ -342,7 +342,7 @@ cdv_dpll_set_clock_cdv(struct drm_device *dev, struct drm_crtc *crtc,
 }
 
 /*
- * Returns whether any output on the specified pipe is of the specified type
+ * Returns whether any encoder on the specified pipe is of the specified type
  */
 bool cdv_intel_pipe_has_type(struct drm_crtc *crtc, int type)
 {
@@ -352,9 +352,9 @@ bool cdv_intel_pipe_has_type(struct drm_crtc *crtc, int type)
 
 	list_for_each_entry(l_entry, &mode_config->connector_list, head) {
 		if (l_entry->encoder && l_entry->encoder->crtc == crtc) {
-			struct psb_intel_output *psb_intel_output =
-			    to_psb_intel_output(l_entry);
-			if (psb_intel_output->type == type)
+			struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(l_entry);
+			if (psb_intel_encoder->type == type)
 				return true;
 		}
 	}
@@ -752,14 +752,14 @@ static int cdv_intel_crtc_mode_set(struct drm_crtc *crtc,
 	struct drm_connector *connector;
 
 	list_for_each_entry(connector, &mode_config->connector_list, head) {
-		struct psb_intel_output *psb_intel_output =
-		    to_psb_intel_output(connector);
+		struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(connector);
 
 		if (!connector->encoder
 		    || connector->encoder->crtc != crtc)
 			continue;
 
-		switch (psb_intel_output->type) {
+		switch (psb_intel_encoder->type) {
 		case INTEL_OUTPUT_LVDS:
 			is_lvds = true;
 			break;
diff --git a/drivers/staging/gma500/cdv_intel_hdmi.c b/drivers/staging/gma500/cdv_intel_hdmi.c
index cbca2b0..50d7cfb 100644
--- a/drivers/staging/gma500/cdv_intel_hdmi.c
+++ b/drivers/staging/gma500/cdv_intel_hdmi.c
@@ -63,8 +63,8 @@ static void cdv_hdmi_mode_set(struct drm_encoder *encoder,
 			struct drm_display_mode *adjusted_mode)
 {
 	struct drm_device *dev = encoder->dev;
-	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
-	struct mid_intel_hdmi_priv *hdmi_priv = output->dev_priv;
+	struct psb_intel_encoder *psb_intel_encoder = to_psb_intel_encoder(encoder);
+	struct mid_intel_hdmi_priv *hdmi_priv = psb_intel_encoder->dev_priv;
 	u32 hdmib;
 	struct drm_crtc *crtc = encoder->crtc;
 	struct psb_intel_crtc *intel_crtc = to_psb_intel_crtc(crtc);
@@ -98,8 +98,9 @@ static bool cdv_hdmi_mode_fixup(struct drm_encoder *encoder,
 static void cdv_hdmi_dpms(struct drm_encoder *encoder, int mode)
 {
 	struct drm_device *dev = encoder->dev;
-	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
-	struct mid_intel_hdmi_priv *hdmi_priv = output->dev_priv;
+	struct psb_intel_encoder *psb_intel_encoder =
+						to_psb_intel_encoder(encoder);
+	struct mid_intel_hdmi_priv *hdmi_priv = psb_intel_encoder->dev_priv;
 	u32 hdmib;
 
 	hdmib = REG_READ(hdmi_priv->hdmi_reg);
@@ -114,8 +115,9 @@ static void cdv_hdmi_dpms(struct drm_encoder *encoder, int mode)
 static void cdv_hdmi_save(struct drm_connector *connector)
 {
 	struct drm_device *dev = connector->dev;
-	struct psb_intel_output *output = to_psb_intel_output(connector);
-	struct mid_intel_hdmi_priv *hdmi_priv = output->dev_priv;
+	struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(connector);
+	struct mid_intel_hdmi_priv *hdmi_priv = psb_intel_encoder->dev_priv;
 
 	hdmi_priv->save_HDMIB = REG_READ(hdmi_priv->hdmi_reg);
 }
@@ -123,8 +125,9 @@ static void cdv_hdmi_save(struct drm_connector *connector)
 static void cdv_hdmi_restore(struct drm_connector *connector)
 {
 	struct drm_device *dev = connector->dev;
-	struct psb_intel_output *output = to_psb_intel_output(connector);
-	struct mid_intel_hdmi_priv *hdmi_priv = output->dev_priv;
+	struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(connector);
+	struct mid_intel_hdmi_priv *hdmi_priv = psb_intel_encoder->dev_priv;
 
 	REG_WRITE(hdmi_priv->hdmi_reg, hdmi_priv->save_HDMIB);
 	REG_READ(hdmi_priv->hdmi_reg);
@@ -133,14 +136,15 @@ static void cdv_hdmi_restore(struct drm_connector *connector)
 static enum drm_connector_status cdv_hdmi_detect(
 				struct drm_connector *connector, bool force)
 {
-	struct psb_intel_output *psb_intel_output =
-						to_psb_intel_output(connector);
-	struct mid_intel_hdmi_priv *hdmi_priv = psb_intel_output->dev_priv;
+	struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(connector);
+	struct psb_intel_connector *psb_intel_connector =
+					to_psb_intel_connector(connector);
+	struct mid_intel_hdmi_priv *hdmi_priv = psb_intel_encoder->dev_priv;
 	struct edid *edid = NULL;
 	enum drm_connector_status status = connector_status_disconnected;
 
-	edid = drm_get_edid(&psb_intel_output->base,
-			 psb_intel_output->hdmi_i2c_adapter);
+	edid = drm_get_edid(connector, &psb_intel_encoder->i2c_bus->adapter);
 
 	hdmi_priv->has_hdmi_sink = false;
 	hdmi_priv->has_hdmi_audio = false;
@@ -153,7 +157,7 @@ static enum drm_connector_status cdv_hdmi_detect(
 						drm_detect_monitor_audio(edid);
 		}
 
-		psb_intel_output->base.display_info.raw_edid = NULL;
+		psb_intel_connector->base.display_info.raw_edid = NULL;
 		kfree(edid);
 	}
 	return status;
@@ -220,17 +224,15 @@ static int cdv_hdmi_set_property(struct drm_connector *connector,
  */
 static int cdv_hdmi_get_modes(struct drm_connector *connector)
 {
-	struct psb_intel_output *psb_intel_output =
-					to_psb_intel_output(connector);
+	struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(connector);
 	struct edid *edid = NULL;
 	int ret = 0;
 
-	edid = drm_get_edid(&psb_intel_output->base,
-			 psb_intel_output->hdmi_i2c_adapter);
+	edid = drm_get_edid(connector, &psb_intel_encoder->i2c_bus->adapter);
 	if (edid) {
-		drm_mode_connector_update_edid_property(&psb_intel_output->
-							base, edid);
-		ret = drm_add_edid_modes(&psb_intel_output->base, edid);
+		drm_mode_connector_update_edid_property(connector, edid);
+		ret = drm_add_edid_modes(connector, edid);
 		kfree(edid);
 	}
 	return ret;
@@ -266,11 +268,11 @@ static int cdv_hdmi_mode_valid(struct drm_connector *connector,
 
 static void cdv_hdmi_destroy(struct drm_connector *connector)
 {
-	struct psb_intel_output *psb_intel_output =
-					to_psb_intel_output(connector);
+	struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(connector);
 
-	if (psb_intel_output->ddc_bus)
-		psb_intel_i2c_destroy(psb_intel_output->ddc_bus);
+	if (psb_intel_encoder->i2c_bus)
+		psb_intel_i2c_destroy(psb_intel_encoder->i2c_bus);
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
 	kfree(connector);
@@ -304,34 +306,45 @@ static const struct drm_connector_funcs cdv_hdmi_connector_funcs = {
 void cdv_hdmi_init(struct drm_device *dev,
 			struct psb_intel_mode_device *mode_dev, int reg)
 {
-	struct psb_intel_output *psb_intel_output;
+	struct psb_intel_encoder *psb_intel_encoder;
+	struct psb_intel_connector *psb_intel_connector;
 	struct drm_connector *connector;
 	struct drm_encoder *encoder;
 	struct mid_intel_hdmi_priv *hdmi_priv;
 	int ddc_bus;
 
-	psb_intel_output = kzalloc(sizeof(struct psb_intel_output) +
-			       sizeof(struct mid_intel_hdmi_priv), GFP_KERNEL);
-	if (!psb_intel_output)
+	psb_intel_encoder = kzalloc(sizeof(struct psb_intel_encoder),
+				    GFP_KERNEL);
+
+	if (!psb_intel_encoder)
 		return;
 
-	hdmi_priv = (struct mid_intel_hdmi_priv *)(psb_intel_output + 1);
-	psb_intel_output->mode_dev = mode_dev;
-	connector = &psb_intel_output->base;
-	encoder = &psb_intel_output->enc;
-	drm_connector_init(dev, &psb_intel_output->base,
+	psb_intel_connector = kzalloc(sizeof(struct psb_intel_connector),
+				      GFP_KERNEL);
+
+	if (!psb_intel_connector)
+		goto err_connector;
+
+	hdmi_priv = kzalloc(sizeof(struct mid_intel_hdmi_priv), GFP_KERNEL);
+
+	if (!hdmi_priv)
+		goto err_priv;
+
+	connector = &psb_intel_connector->base;
+	encoder = &psb_intel_encoder->base;
+	drm_connector_init(dev, connector,
 			   &cdv_hdmi_connector_funcs,
 			   DRM_MODE_CONNECTOR_DVID);
 
-	drm_encoder_init(dev, &psb_intel_output->enc, &psb_intel_lvds_enc_funcs,
+	drm_encoder_init(dev, encoder, &psb_intel_lvds_enc_funcs,
 			 DRM_MODE_ENCODER_TMDS);
 
-	drm_mode_connector_attach_encoder(&psb_intel_output->base,
-					  &psb_intel_output->enc);
-	psb_intel_output->type = INTEL_OUTPUT_HDMI;
+	psb_intel_connector_attach_encoder(psb_intel_connector,
+					   psb_intel_encoder);
+	psb_intel_encoder->type = INTEL_OUTPUT_HDMI;
 	hdmi_priv->hdmi_reg = reg;
 	hdmi_priv->has_hdmi_sink = false;
-	psb_intel_output->dev_priv = hdmi_priv;
+	psb_intel_encoder->dev_priv = hdmi_priv;
 
 	drm_encoder_helper_add(encoder, &cdv_hdmi_helper_funcs);
 	drm_connector_helper_add(connector,
@@ -341,7 +354,8 @@ void cdv_hdmi_init(struct drm_device *dev,
 	connector->doublescan_allowed = false;
 
 	drm_connector_attach_property(connector,
-	    dev->mode_config.scaling_mode_property, DRM_MODE_SCALE_FULLSCREEN);
+				      dev->mode_config.scaling_mode_property,
+				      DRM_MODE_SCALE_FULLSCREEN);
 
 	switch (reg) {
 	case SDVOB:
@@ -356,21 +370,25 @@ void cdv_hdmi_init(struct drm_device *dev,
 		break;
 	}
 
-	psb_intel_output->ddc_bus = psb_intel_i2c_create(dev,
+	psb_intel_encoder->i2c_bus = psb_intel_i2c_create(dev,
 				ddc_bus, (reg == SDVOB) ? "HDMIB" : "HDMIC");
 
-	if (!psb_intel_output->ddc_bus) {
+	if (!psb_intel_encoder->i2c_bus) {
 		dev_err(dev->dev, "No ddc adapter available!\n");
 		goto failed_ddc;
 	}
-	psb_intel_output->hdmi_i2c_adapter =
-				&(psb_intel_output->ddc_bus->adapter);
+
+	hdmi_priv->hdmi_i2c_adapter =
+				&(psb_intel_encoder->i2c_bus->adapter);
 	hdmi_priv->dev = dev;
 	drm_sysfs_connector_add(connector);
 	return;
 
 failed_ddc:
-	drm_encoder_cleanup(&psb_intel_output->enc);
-	drm_connector_cleanup(&psb_intel_output->base);
-	kfree(psb_intel_output);
+	drm_encoder_cleanup(encoder);
+	drm_connector_cleanup(connector);
+err_priv:
+	kfree(psb_intel_connector);
+err_connector:
+	kfree(psb_intel_encoder);
 }
diff --git a/drivers/staging/gma500/cdv_intel_lvds.c b/drivers/staging/gma500/cdv_intel_lvds.c
index 988b2d0..50e744b 100644
--- a/drivers/staging/gma500/cdv_intel_lvds.c
+++ b/drivers/staging/gma500/cdv_intel_lvds.c
@@ -195,8 +195,9 @@ static void cdv_intel_lvds_set_backlight(struct drm_device *dev, int level)
  * Sets the power state for the panel.
  */
 static void cdv_intel_lvds_set_power(struct drm_device *dev,
-				 struct psb_intel_output *output, bool on)
+				     struct drm_encoder *encoder, bool on)
 {
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 pp_status;
 
 	if (!gma_power_begin(dev, true))
@@ -210,8 +211,7 @@ static void cdv_intel_lvds_set_power(struct drm_device *dev,
 		} while ((pp_status & PP_ON) == 0);
 
 		cdv_intel_lvds_set_backlight(dev,
-					 output->
-					 mode_dev->backlight_duty_cycle);
+				dev_priv->mode_dev.backlight_duty_cycle);
 	} else {
 		cdv_intel_lvds_set_backlight(dev, 0);
 
@@ -227,11 +227,10 @@ static void cdv_intel_lvds_set_power(struct drm_device *dev,
 static void cdv_intel_lvds_encoder_dpms(struct drm_encoder *encoder, int mode)
 {
 	struct drm_device *dev = encoder->dev;
-	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
 	if (mode == DRM_MODE_DPMS_ON)
-		cdv_intel_lvds_set_power(dev, output, true);
+		cdv_intel_lvds_set_power(dev, encoder, true);
 	else
-		cdv_intel_lvds_set_power(dev, output, false);
+		cdv_intel_lvds_set_power(dev, encoder, false);
 	/* XXX: We never power down the LVDS pairs. */
 }
 
@@ -244,12 +243,12 @@ static void cdv_intel_lvds_restore(struct drm_connector *connector)
 }
 
 int cdv_intel_lvds_mode_valid(struct drm_connector *connector,
-				 struct drm_display_mode *mode)
+			      struct drm_display_mode *mode)
 {
-	struct psb_intel_output *psb_intel_output =
-				to_psb_intel_output(connector);
+	struct drm_device *dev = connector->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct drm_display_mode *fixed_mode =
-	    psb_intel_output->mode_dev->panel_fixed_mode;
+					dev_priv->mode_dev.panel_fixed_mode;
 
 	/* just in case */
 	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
@@ -272,9 +271,9 @@ bool cdv_intel_lvds_mode_fixup(struct drm_encoder *encoder,
 				  struct drm_display_mode *mode,
 				  struct drm_display_mode *adjusted_mode)
 {
-	struct psb_intel_mode_device *mode_dev =
-	    enc_to_psb_intel_output(encoder)->mode_dev;
 	struct drm_device *dev = encoder->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_intel_mode_device *mode_dev = &dev_priv->mode_dev;
 	struct drm_encoder *tmp_encoder;
 	struct drm_display_mode *panel_fixed_mode = mode_dev->panel_fixed_mode;
 
@@ -321,8 +320,8 @@ bool cdv_intel_lvds_mode_fixup(struct drm_encoder *encoder,
 static void cdv_intel_lvds_prepare(struct drm_encoder *encoder)
 {
 	struct drm_device *dev = encoder->dev;
-	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
-	struct psb_intel_mode_device *mode_dev = output->mode_dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_intel_mode_device *mode_dev = &dev_priv->mode_dev;
 
 	if (!gma_power_begin(dev, true))
 		return;
@@ -331,7 +330,7 @@ static void cdv_intel_lvds_prepare(struct drm_encoder *encoder)
 	mode_dev->backlight_duty_cycle = (mode_dev->saveBLC_PWM_CTL &
 					  BACKLIGHT_DUTY_CYCLE_MASK);
 
-	cdv_intel_lvds_set_power(dev, output, false);
+	cdv_intel_lvds_set_power(dev, encoder, false);
 
 	gma_power_end(dev);
 }
@@ -339,14 +338,14 @@ static void cdv_intel_lvds_prepare(struct drm_encoder *encoder)
 static void cdv_intel_lvds_commit(struct drm_encoder *encoder)
 {
 	struct drm_device *dev = encoder->dev;
-	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
-	struct psb_intel_mode_device *mode_dev = output->mode_dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_intel_mode_device *mode_dev = &dev_priv->mode_dev;
 
 	if (mode_dev->backlight_duty_cycle == 0)
 		mode_dev->backlight_duty_cycle =
 		    cdv_intel_lvds_get_max_backlight(dev);
 
-	cdv_intel_lvds_set_power(dev, output, true);
+	cdv_intel_lvds_set_power(dev, encoder, true);
 }
 
 static void cdv_intel_lvds_mode_set(struct drm_encoder *encoder,
@@ -401,13 +400,13 @@ static enum drm_connector_status cdv_intel_lvds_detect(
 static int cdv_intel_lvds_get_modes(struct drm_connector *connector)
 {
 	struct drm_device *dev = connector->dev;
-	struct psb_intel_output *psb_intel_output =
-					to_psb_intel_output(connector);
-	struct psb_intel_mode_device *mode_dev =
-					psb_intel_output->mode_dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(connector);
+	struct psb_intel_mode_device *mode_dev = &dev_priv->mode_dev;
 	int ret;
 
-	ret = psb_intel_ddc_get_modes(psb_intel_output);
+	ret = psb_intel_ddc_get_modes(connector, &psb_intel_encoder->i2c_bus->adapter);
 
 	if (ret)
 		return ret;
@@ -439,11 +438,11 @@ static int cdv_intel_lvds_get_modes(struct drm_connector *connector)
  */
 void cdv_intel_lvds_destroy(struct drm_connector *connector)
 {
-	struct psb_intel_output *psb_intel_output =
-					to_psb_intel_output(connector);
+	struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(connector);
 
-	if (psb_intel_output->ddc_bus)
-		psb_intel_i2c_destroy(psb_intel_output->ddc_bus);
+	if (psb_intel_encoder->i2c_bus)
+		psb_intel_i2c_destroy(psb_intel_encoder->i2c_bus);
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
 	kfree(connector);
@@ -565,7 +564,8 @@ const struct drm_encoder_funcs cdv_intel_lvds_enc_funcs = {
 void cdv_intel_lvds_init(struct drm_device *dev,
 		     struct psb_intel_mode_device *mode_dev)
 {
-	struct psb_intel_output *psb_intel_output;
+	struct psb_intel_encoder *psb_intel_encoder;
+	struct psb_intel_connector *psb_intel_connector;
 	struct cdv_intel_lvds_priv *lvds_priv;
 	struct drm_connector *connector;
 	struct drm_encoder *encoder;
@@ -575,32 +575,38 @@ void cdv_intel_lvds_init(struct drm_device *dev,
 	u32 lvds;
 	int pipe;
 
-	psb_intel_output = kzalloc(sizeof(struct psb_intel_output) +
-			sizeof(struct cdv_intel_lvds_priv), GFP_KERNEL);
-	if (!psb_intel_output)
+	psb_intel_encoder = kzalloc(sizeof(struct psb_intel_encoder),
+				    GFP_KERNEL);
+	if (!psb_intel_encoder)
 		return;
 
-	lvds_priv = (struct cdv_intel_lvds_priv *)(psb_intel_output + 1);
+	psb_intel_connector = kzalloc(sizeof(struct psb_intel_connector),
+				      GFP_KERNEL);
+	if (!psb_intel_connector)
+		goto failed_connector;
 
-	psb_intel_output->dev_priv = lvds_priv;
+	lvds_priv = kzalloc(sizeof(struct cdv_intel_lvds_priv), GFP_KERNEL);
+	if (!lvds_priv)
+		goto failed_lvds_priv;
 
-	psb_intel_output->mode_dev = mode_dev;
-	connector = &psb_intel_output->base;
-	encoder = &psb_intel_output->enc;
+	psb_intel_encoder->dev_priv = lvds_priv;
 
+	connector = &psb_intel_connector->base;
+	encoder = &psb_intel_encoder->base;
 
-	drm_connector_init(dev, &psb_intel_output->base,
+
+	drm_connector_init(dev, connector,
 			   &cdv_intel_lvds_connector_funcs,
 			   DRM_MODE_CONNECTOR_LVDS);
 
-	drm_encoder_init(dev, &psb_intel_output->enc,
+	drm_encoder_init(dev, encoder,
 			 &cdv_intel_lvds_enc_funcs,
 			 DRM_MODE_ENCODER_LVDS);
 
 
-	drm_mode_connector_attach_encoder(&psb_intel_output->base,
-					  &psb_intel_output->enc);
-	psb_intel_output->type = INTEL_OUTPUT_LVDS;
+	psb_intel_connector_attach_encoder(psb_intel_connector,
+					   psb_intel_encoder);
+	psb_intel_encoder->type = INTEL_OUTPUT_LVDS;
 
 	drm_encoder_helper_add(encoder, &cdv_intel_lvds_helper_funcs);
 	drm_connector_helper_add(connector,
@@ -621,16 +627,16 @@ void cdv_intel_lvds_init(struct drm_device *dev,
 	 * Set up I2C bus
 	 * FIXME: distroy i2c_bus when exit
 	 */
-	psb_intel_output->i2c_bus = psb_intel_i2c_create(dev,
+	psb_intel_encoder->i2c_bus = psb_intel_i2c_create(dev,
 							 GPIOB,
 							 "LVDSBLC_B");
-	if (!psb_intel_output->i2c_bus) {
+	if (!psb_intel_encoder->i2c_bus) {
 		dev_printk(KERN_ERR,
 			&dev->pdev->dev, "I2C bus registration failed.\n");
 		goto failed_blc_i2c;
 	}
-	psb_intel_output->i2c_bus->slave_addr = 0x2C;
-	dev_priv->lvds_i2c_bus =  psb_intel_output->i2c_bus;
+	psb_intel_encoder->i2c_bus->slave_addr = 0x2C;
+	dev_priv->lvds_i2c_bus = psb_intel_encoder->i2c_bus;
 
 	/*
 	 * LVDS discovery:
@@ -643,10 +649,10 @@ void cdv_intel_lvds_init(struct drm_device *dev,
 	 */
 
 	/* Set up the DDC bus. */
-	psb_intel_output->ddc_bus = psb_intel_i2c_create(dev,
+	psb_intel_encoder->ddc_bus = psb_intel_i2c_create(dev,
 							 GPIOC,
 							 "LVDSDDC_C");
-	if (!psb_intel_output->ddc_bus) {
+	if (!psb_intel_encoder->ddc_bus) {
 		dev_printk(KERN_ERR, &dev->pdev->dev,
 			   "DDC bus registration " "failed.\n");
 		goto failed_ddc;
@@ -656,7 +662,8 @@ void cdv_intel_lvds_init(struct drm_device *dev,
 	 * Attempt to get the fixed panel mode from DDC.  Assume that the
 	 * preferred mode is the right one.
 	 */
-	psb_intel_ddc_get_modes(psb_intel_output);
+	psb_intel_ddc_get_modes(connector,
+				&psb_intel_encoder->ddc_bus->adapter);
 	list_for_each_entry(scan, &connector->probed_modes, head) {
 		if (scan->type & DRM_MODE_TYPE_PREFERRED) {
 			mode_dev->panel_fixed_mode =
@@ -707,15 +714,19 @@ out:
 
 failed_find:
 	printk(KERN_ERR "Failed find\n");
-	if (psb_intel_output->ddc_bus)
-		psb_intel_i2c_destroy(psb_intel_output->ddc_bus);
+	if (psb_intel_encoder->ddc_bus)
+		psb_intel_i2c_destroy(psb_intel_encoder->ddc_bus);
 failed_ddc:
 	printk(KERN_ERR "Failed DDC\n");
-	if (psb_intel_output->i2c_bus)
-		psb_intel_i2c_destroy(psb_intel_output->i2c_bus);
+	if (psb_intel_encoder->i2c_bus)
+		psb_intel_i2c_destroy(psb_intel_encoder->i2c_bus);
 failed_blc_i2c:
 	printk(KERN_ERR "Failed BLC\n");
 	drm_encoder_cleanup(encoder);
 	drm_connector_cleanup(connector);
-	kfree(connector);
+	kfree(lvds_priv);
+failed_lvds_priv:
+	kfree(psb_intel_connector);
+failed_connector:
+	kfree(psb_intel_encoder);
 }
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 7b91cd0..e2a58a7 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -375,7 +375,7 @@ struct drm_psb_private {
 	struct drm_display_mode *sdvo_lvds_vbt_mode;
 
 	struct bdb_lvds_backlight *lvds_bl; /* LVDS backlight info from VBT */
-	struct psb_intel_i2c_chan *lvds_i2c_bus;
+	struct psb_intel_i2c_chan *lvds_i2c_bus; /* FIXME: Remove this? */
 
 	/* Feature bits from the VBIOS */
 	unsigned int int_tv_support:1;
diff --git a/drivers/staging/gma500/psb_intel_drv.h b/drivers/staging/gma500/psb_intel_drv.h
index f027431..1346aa7 100644
--- a/drivers/staging/gma500/psb_intel_drv.h
+++ b/drivers/staging/gma500/psb_intel_drv.h
@@ -139,6 +139,11 @@ struct psb_intel_encoder {
 	int crtc_mask;
 	int clone_mask;
 	void *dev_priv; /* For sdvo_priv, lvds_priv, etc... */
+
+	/* FIXME: Either make SDVO and LVDS store it's i2c here or give CDV it's
+	   own set of output privates */
+	struct psb_intel_i2c_chan *i2c_bus;
+	struct psb_intel_i2c_chan *ddc_bus;
 };
 
 struct psb_intel_connector {
-- 
1.7.4.1

