Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab1J0WEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 18:04:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56538 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab1J0WCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 18:02:47 -0400
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, greg@kroah.com
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 4/9] gma500: Convert PSB LVDS to new output handling
Date: Fri, 28 Oct 2011 00:02:09 +0200
Message-Id: <1319752934-1919-5-git-send-email-patrik.r.jakobsson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
References: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LVDS for PSB now uses psb_intel_encoder and psb_intel_connectors instead of
psb_intel_output. i2c_bus and ddc_bus are moved to lvds_priv. There was also a
pointer to mode_dev (for no obvious reason) that we now get directly from
dev_priv.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
---
 drivers/staging/gma500/psb_intel_lvds.c |  151 +++++++++++++++++--------------
 1 files changed, 83 insertions(+), 68 deletions(-)

diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index 21022e1..766536b 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -59,6 +59,9 @@ struct psb_intel_lvds_priv {
 	uint32_t savePFIT_CONTROL;
 	uint32_t savePFIT_PGM_RATIOS;
 	uint32_t saveBLC_PWM_CTL;
+
+	struct psb_intel_i2c_chan *i2c_bus;
+	struct psb_intel_i2c_chan *ddc_bus;
 };
 
 
@@ -214,9 +217,10 @@ static void psb_intel_lvds_set_backlight(struct drm_device *dev, int level)
 /*
  * Sets the power state for the panel.
  */
-static void psb_intel_lvds_set_power(struct drm_device *dev,
-				 struct psb_intel_output *output, bool on)
+static void psb_intel_lvds_set_power(struct drm_device *dev, bool on)
 {
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_intel_mode_device *mode_dev = &dev_priv->mode_dev;
 	u32 pp_status;
 
 	if (!gma_power_begin(dev, true)) {
@@ -232,8 +236,7 @@ static void psb_intel_lvds_set_power(struct drm_device *dev,
 		} while ((pp_status & PP_ON) == 0);
 
 		psb_intel_lvds_set_backlight(dev,
-					 output->
-					 mode_dev->backlight_duty_cycle);
+					     mode_dev->backlight_duty_cycle);
 	} else {
 		psb_intel_lvds_set_backlight(dev, 0);
 
@@ -250,12 +253,11 @@ static void psb_intel_lvds_set_power(struct drm_device *dev,
 static void psb_intel_lvds_encoder_dpms(struct drm_encoder *encoder, int mode)
 {
 	struct drm_device *dev = encoder->dev;
-	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
 
 	if (mode == DRM_MODE_DPMS_ON)
-		psb_intel_lvds_set_power(dev, output, true);
+		psb_intel_lvds_set_power(dev, true);
 	else
-		psb_intel_lvds_set_power(dev, output, false);
+		psb_intel_lvds_set_power(dev, false);
 
 	/* XXX: We never power down the LVDS pairs. */
 }
@@ -265,10 +267,10 @@ static void psb_intel_lvds_save(struct drm_connector *connector)
 	struct drm_device *dev = connector->dev;
 	struct drm_psb_private *dev_priv =
 		(struct drm_psb_private *)dev->dev_private;
-	struct psb_intel_output *psb_intel_output =
-		to_psb_intel_output(connector);
+	struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(connector);
 	struct psb_intel_lvds_priv *lvds_priv =
-		(struct psb_intel_lvds_priv *)psb_intel_output->dev_priv;
+		(struct psb_intel_lvds_priv *)psb_intel_encoder->dev_priv;
 
 	lvds_priv->savePP_ON = REG_READ(LVDSPP_ON);
 	lvds_priv->savePP_OFF = REG_READ(LVDSPP_OFF);
@@ -305,10 +307,10 @@ static void psb_intel_lvds_restore(struct drm_connector *connector)
 {
 	struct drm_device *dev = connector->dev;
 	u32 pp_status;
-	struct psb_intel_output *psb_intel_output =
-					to_psb_intel_output(connector);
+	struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(connector);
 	struct psb_intel_lvds_priv *lvds_priv =
-		(struct psb_intel_lvds_priv *)psb_intel_output->dev_priv;
+		(struct psb_intel_lvds_priv *)psb_intel_encoder->dev_priv;
 
 	dev_dbg(dev->dev, "(0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x)\n",
 			lvds_priv->savePP_ON,
@@ -346,13 +348,14 @@ static void psb_intel_lvds_restore(struct drm_connector *connector)
 int psb_intel_lvds_mode_valid(struct drm_connector *connector,
 				 struct drm_display_mode *mode)
 {
-	struct psb_intel_output *psb_intel_output =
-				to_psb_intel_output(connector);
+	struct drm_psb_private *dev_priv = connector->dev->dev_private;
+	struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(connector);
 	struct drm_display_mode *fixed_mode =
-	    psb_intel_output->mode_dev->panel_fixed_mode;
+					dev_priv->mode_dev.panel_fixed_mode;
 
-	if (psb_intel_output->type == INTEL_OUTPUT_MIPI2)
-		fixed_mode = psb_intel_output->mode_dev->panel_fixed_mode2;
+	if (psb_intel_encoder->type == INTEL_OUTPUT_MIPI2)
+		fixed_mode = dev_priv->mode_dev.panel_fixed_mode2;
 
 	/* just in case */
 	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
@@ -375,17 +378,17 @@ bool psb_intel_lvds_mode_fixup(struct drm_encoder *encoder,
 				  struct drm_display_mode *mode,
 				  struct drm_display_mode *adjusted_mode)
 {
-	struct psb_intel_mode_device *mode_dev =
-	    enc_to_psb_intel_output(encoder)->mode_dev;
 	struct drm_device *dev = encoder->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_intel_mode_device *mode_dev = &dev_priv->mode_dev;
 	struct psb_intel_crtc *psb_intel_crtc =
 				to_psb_intel_crtc(encoder->crtc);
 	struct drm_encoder *tmp_encoder;
 	struct drm_display_mode *panel_fixed_mode = mode_dev->panel_fixed_mode;
-	struct psb_intel_output *psb_intel_output =
-					enc_to_psb_intel_output(encoder);
+	struct psb_intel_encoder *psb_intel_encoder =
+						to_psb_intel_encoder(encoder);
 
-	if (psb_intel_output->type == INTEL_OUTPUT_MIPI2)
+	if (psb_intel_encoder->type == INTEL_OUTPUT_MIPI2)
 		panel_fixed_mode = mode_dev->panel_fixed_mode2;
 
 	/* PSB requires the LVDS is on pipe B, MRST has only one pipe anyway */
@@ -440,8 +443,8 @@ bool psb_intel_lvds_mode_fixup(struct drm_encoder *encoder,
 static void psb_intel_lvds_prepare(struct drm_encoder *encoder)
 {
 	struct drm_device *dev = encoder->dev;
-	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
-	struct psb_intel_mode_device *mode_dev = output->mode_dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_intel_mode_device *mode_dev = &dev_priv->mode_dev;
 
 	if (!gma_power_begin(dev, true))
 		return;
@@ -450,7 +453,7 @@ static void psb_intel_lvds_prepare(struct drm_encoder *encoder)
 	mode_dev->backlight_duty_cycle = (mode_dev->saveBLC_PWM_CTL &
 					  BACKLIGHT_DUTY_CYCLE_MASK);
 
-	psb_intel_lvds_set_power(dev, output, false);
+	psb_intel_lvds_set_power(dev, false);
 
 	gma_power_end(dev);
 }
@@ -458,14 +461,14 @@ static void psb_intel_lvds_prepare(struct drm_encoder *encoder)
 static void psb_intel_lvds_commit(struct drm_encoder *encoder)
 {
 	struct drm_device *dev = encoder->dev;
-	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
-	struct psb_intel_mode_device *mode_dev = output->mode_dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_intel_mode_device *mode_dev = &dev_priv->mode_dev;
 
 	if (mode_dev->backlight_duty_cycle == 0)
 		mode_dev->backlight_duty_cycle =
 		    psb_intel_lvds_get_max_backlight(dev);
 
-	psb_intel_lvds_set_power(dev, output, true);
+	psb_intel_lvds_set_power(dev, true);
 }
 
 static void psb_intel_lvds_mode_set(struct drm_encoder *encoder,
@@ -520,14 +523,15 @@ static enum drm_connector_status psb_intel_lvds_detect(struct drm_connector
 static int psb_intel_lvds_get_modes(struct drm_connector *connector)
 {
 	struct drm_device *dev = connector->dev;
-	struct psb_intel_output *psb_intel_output =
-					to_psb_intel_output(connector);
-	struct psb_intel_mode_device *mode_dev =
-					psb_intel_output->mode_dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_intel_mode_device *mode_dev = &dev_priv->mode_dev;
+	struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(connector);
+	struct psb_intel_lvds_priv *lvds_priv = psb_intel_encoder->dev_priv;
 	int ret = 0;
 
 	if (!IS_MRST(dev))
-		ret = psb_intel_ddc_get_modes(psb_intel_output);
+		ret = psb_intel_ddc_get_modes(connector, &lvds_priv->i2c_bus->adapter);
 
 	if (ret)
 		return ret;
@@ -560,11 +564,12 @@ static int psb_intel_lvds_get_modes(struct drm_connector *connector)
  */
 void psb_intel_lvds_destroy(struct drm_connector *connector)
 {
-	struct psb_intel_output *psb_intel_output =
-					to_psb_intel_output(connector);
+	struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(connector);
+	struct psb_intel_lvds_priv *lvds_priv = psb_intel_encoder->dev_priv;
 
-	if (psb_intel_output->ddc_bus)
-		psb_intel_i2c_destroy(psb_intel_output->ddc_bus);
+	if (lvds_priv->ddc_bus)
+		psb_intel_i2c_destroy(lvds_priv->ddc_bus);
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
 	kfree(connector);
@@ -693,9 +698,10 @@ const struct drm_encoder_funcs psb_intel_lvds_enc_funcs = {
  * modes we can display on the LVDS panel (if present).
  */
 void psb_intel_lvds_init(struct drm_device *dev,
-		     struct psb_intel_mode_device *mode_dev)
+			 struct psb_intel_mode_device *mode_dev)
 {
-	struct psb_intel_output *psb_intel_output;
+	struct psb_intel_encoder *psb_intel_encoder;
+	struct psb_intel_connector *psb_intel_connector;
 	struct psb_intel_lvds_priv *lvds_priv;
 	struct drm_connector *connector;
 	struct drm_encoder *encoder;
@@ -705,33 +711,43 @@ void psb_intel_lvds_init(struct drm_device *dev,
 	u32 lvds;
 	int pipe;
 
-	psb_intel_output = kzalloc(sizeof(struct psb_intel_output), GFP_KERNEL);
-	if (!psb_intel_output)
+	psb_intel_encoder =
+			kzalloc(sizeof(struct psb_intel_encoder), GFP_KERNEL);
+
+	if (!psb_intel_encoder) {
+		dev_err(dev->dev, "psb_intel_encoder allocation error\n");
 		return;
+	}
+
+	psb_intel_connector =
+		kzalloc(sizeof(struct psb_intel_connector), GFP_KERNEL);
+
+	if (!psb_intel_connector) {
+		kfree(psb_intel_encoder);
+		dev_err(dev->dev, "psb_intel_connector allocation error\n");
+	}
 
 	lvds_priv = kzalloc(sizeof(struct psb_intel_lvds_priv), GFP_KERNEL);
 	if (!lvds_priv) {
-		kfree(psb_intel_output);
 		dev_err(dev->dev, "LVDS private allocation error\n");
-		return;
+		goto failed_connector;
 	}
 
-	psb_intel_output->dev_priv = lvds_priv;
-	psb_intel_output->mode_dev = mode_dev;
+	psb_intel_encoder->dev_priv = lvds_priv;
 
-	connector = &psb_intel_output->base;
-	encoder = &psb_intel_output->enc;
-	drm_connector_init(dev, &psb_intel_output->base,
+	connector = &psb_intel_connector->base;
+	encoder = &psb_intel_encoder->base;
+	drm_connector_init(dev, connector,
 			   &psb_intel_lvds_connector_funcs,
 			   DRM_MODE_CONNECTOR_LVDS);
 
-	drm_encoder_init(dev, &psb_intel_output->enc,
+	drm_encoder_init(dev, encoder,
 			 &psb_intel_lvds_enc_funcs,
 			 DRM_MODE_ENCODER_LVDS);
 
-	drm_mode_connector_attach_encoder(&psb_intel_output->base,
-					  &psb_intel_output->enc);
-	psb_intel_output->type = INTEL_OUTPUT_LVDS;
+	psb_intel_connector_attach_encoder(psb_intel_connector,
+					   psb_intel_encoder);
+	psb_intel_encoder->type = INTEL_OUTPUT_LVDS;
 
 	drm_encoder_helper_add(encoder, &psb_intel_lvds_helper_funcs);
 	drm_connector_helper_add(connector,
@@ -752,16 +768,14 @@ void psb_intel_lvds_init(struct drm_device *dev,
 	 * Set up I2C bus
 	 * FIXME: distroy i2c_bus when exit
 	 */
-	psb_intel_output->i2c_bus = psb_intel_i2c_create(dev,
-							 GPIOB,
-							 "LVDSBLC_B");
-	if (!psb_intel_output->i2c_bus) {
+	lvds_priv->i2c_bus = psb_intel_i2c_create(dev, GPIOB, "LVDSBLC_B");
+	if (!lvds_priv->i2c_bus) {
 		dev_printk(KERN_ERR,
 			&dev->pdev->dev, "I2C bus registration failed.\n");
 		goto failed_blc_i2c;
 	}
-	psb_intel_output->i2c_bus->slave_addr = 0x2C;
-	dev_priv->lvds_i2c_bus =  psb_intel_output->i2c_bus;
+	lvds_priv->i2c_bus->slave_addr = 0x2C;
+	dev_priv->lvds_i2c_bus =  lvds_priv->i2c_bus;
 
 	/*
 	 * LVDS discovery:
@@ -774,10 +788,8 @@ void psb_intel_lvds_init(struct drm_device *dev,
 	 */
 
 	/* Set up the DDC bus. */
-	psb_intel_output->ddc_bus = psb_intel_i2c_create(dev,
-							 GPIOC,
-							 "LVDSDDC_C");
-	if (!psb_intel_output->ddc_bus) {
+	lvds_priv->ddc_bus = psb_intel_i2c_create(dev, GPIOC, "LVDSDDC_C");
+	if (!lvds_priv->ddc_bus) {
 		dev_printk(KERN_ERR, &dev->pdev->dev,
 			   "DDC bus registration " "failed.\n");
 		goto failed_ddc;
@@ -787,7 +799,7 @@ void psb_intel_lvds_init(struct drm_device *dev,
 	 * Attempt to get the fixed panel mode from DDC.  Assume that the
 	 * preferred mode is the right one.
 	 */
-	psb_intel_ddc_get_modes(psb_intel_output);
+	psb_intel_ddc_get_modes(connector, &lvds_priv->ddc_bus->adapter);
 	list_for_each_entry(scan, &connector->probed_modes, head) {
 		if (scan->type & DRM_MODE_TYPE_PREFERRED) {
 			mode_dev->panel_fixed_mode =
@@ -841,14 +853,17 @@ out:
 	return;
 
 failed_find:
-	if (psb_intel_output->ddc_bus)
-		psb_intel_i2c_destroy(psb_intel_output->ddc_bus);
+	if (lvds_priv->ddc_bus)
+		psb_intel_i2c_destroy(lvds_priv->ddc_bus);
 failed_ddc:
-	if (psb_intel_output->i2c_bus)
-		psb_intel_i2c_destroy(psb_intel_output->i2c_bus);
+	if (lvds_priv->i2c_bus)
+		psb_intel_i2c_destroy(lvds_priv->i2c_bus);
 failed_blc_i2c:
 	drm_encoder_cleanup(encoder);
 	drm_connector_cleanup(connector);
 	kfree(connector);
+failed_connector:
+	if (psb_intel_connector)
+		kfree(psb_intel_connector);
 }
 
-- 
1.7.4.1

