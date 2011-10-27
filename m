Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab1J0WDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 18:03:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50887 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab1J0WCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 18:02:53 -0400
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, greg@kroah.com
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 8/9] gma500: Convert Moorestown to work with new output handling
Date: Fri, 28 Oct 2011 00:02:13 +0200
Message-Id: <1319752934-1919-9-git-send-email-patrik.r.jakobsson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
References: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace psb_intel_output with psb_intel_encoder and psb_intel_connector.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
---
 drivers/staging/gma500/mrst_crtc.c |   18 ++++----
 drivers/staging/gma500/mrst_hdmi.c |   29 ++++++++-----
 drivers/staging/gma500/mrst_lvds.c |   79 +++++++++++++++++++++++------------
 3 files changed, 79 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/gma500/mrst_crtc.c b/drivers/staging/gma500/mrst_crtc.c
index c9311a5..05fa7ee 100644
--- a/drivers/staging/gma500/mrst_crtc.c
+++ b/drivers/staging/gma500/mrst_crtc.c
@@ -313,9 +313,9 @@ static int mrst_crtc_mode_set(struct drm_crtc *crtc,
 	bool is_crt = false, is_lvds = false, is_tv = false;
 	bool is_mipi = false;
 	struct drm_mode_config *mode_config = &dev->mode_config;
-	struct psb_intel_output *psb_intel_output = NULL;
+	struct psb_intel_encoder *psb_intel_encoder = NULL;
 	uint64_t scalingType = DRM_MODE_SCALE_FULLSCREEN;
-	struct drm_encoder *encoder;
+	struct drm_connector *connector;
 
 	if (!gma_power_begin(dev, true))
 		return 0;
@@ -327,13 +327,13 @@ static int mrst_crtc_mode_set(struct drm_crtc *crtc,
 		adjusted_mode,
 		sizeof(struct drm_display_mode));
 
-	list_for_each_entry(encoder, &mode_config->encoder_list, head) {
-
-		if (encoder->crtc != crtc)
+	list_for_each_entry(connector, &mode_config->connector_list, head) {
+		if (!connector->encoder || connector->encoder->crtc != crtc)
 			continue;
 
-		psb_intel_output = enc_to_psb_intel_output(encoder);
-		switch (psb_intel_output->type) {
+		psb_intel_encoder = psb_intel_attached_encoder(connector);
+
+		switch (psb_intel_encoder->type) {
 		case INTEL_OUTPUT_LVDS:
 			is_lvds = true;
 			break;
@@ -363,8 +363,8 @@ static int mrst_crtc_mode_set(struct drm_crtc *crtc,
 		  ((mode->crtc_hdisplay - 1) << 16) |
 		  (mode->crtc_vdisplay - 1));
 
-	if (psb_intel_output)
-		drm_connector_property_get_value(&psb_intel_output->base,
+	if (psb_intel_encoder)
+		drm_connector_property_get_value(connector,
 			dev->mode_config.scaling_mode_property, &scalingType);
 
 	if (scalingType == DRM_MODE_SCALE_NO_SCALE) {
diff --git a/drivers/staging/gma500/mrst_hdmi.c b/drivers/staging/gma500/mrst_hdmi.c
index e66607e..4e4e5ba 100644
--- a/drivers/staging/gma500/mrst_hdmi.c
+++ b/drivers/staging/gma500/mrst_hdmi.c
@@ -643,29 +643,33 @@ static const struct drm_encoder_funcs mrst_hdmi_enc_funcs = {
 void mrst_hdmi_init(struct drm_device *dev,
 					struct psb_intel_mode_device *mode_dev)
 {
-	struct psb_intel_output *psb_intel_output;
+	struct psb_intel_encoder *psb_intel_encoder;
+	struct psb_intel_connector *psb_intel_connector;
 	struct drm_connector *connector;
 	struct drm_encoder *encoder;
 
-	psb_intel_output = kzalloc(sizeof(struct psb_intel_output), GFP_KERNEL);
-	if (!psb_intel_output)
+	psb_intel_encoder = kzalloc(sizeof(struct psb_intel_encoder), GFP_KERNEL);
+	if (!psb_intel_encoder)
 		return;
 
-	psb_intel_output->mode_dev = mode_dev;
-	connector = &psb_intel_output->base;
-	encoder = &psb_intel_output->enc;
-	drm_connector_init(dev, &psb_intel_output->base,
+	psb_intel_connector = kzalloc(sizeof(struct psb_intel_connector), GFP_KERNEL);
+	if (!psb_intel_connector)
+		goto failed_connector;
+
+	connector = &psb_intel_connector->base;
+	encoder = &psb_intel_encoder->base;
+	drm_connector_init(dev, connector,
 			   &mrst_hdmi_connector_funcs,
 			   DRM_MODE_CONNECTOR_DVID);
 
-	drm_encoder_init(dev, &psb_intel_output->enc,
+	drm_encoder_init(dev, encoder,
 			 &mrst_hdmi_enc_funcs,
 			 DRM_MODE_ENCODER_TMDS);
 
-	drm_mode_connector_attach_encoder(&psb_intel_output->base,
-					  &psb_intel_output->enc);
+	psb_intel_connector_attach_encoder(psb_intel_connector,
+					   psb_intel_encoder);
 
-	psb_intel_output->type = INTEL_OUTPUT_HDMI;
+	psb_intel_encoder->type = INTEL_OUTPUT_HDMI;
 	drm_encoder_helper_add(encoder, &mrst_hdmi_helper_funcs);
 	drm_connector_helper_add(connector, &mrst_hdmi_connector_helper_funcs);
 
@@ -675,6 +679,9 @@ void mrst_hdmi_init(struct drm_device *dev,
 	drm_sysfs_connector_add(connector);
 
 	return;
+
+failed_connector:
+	kfree(psb_intel_encoder);
 }
 
 static DEFINE_PCI_DEVICE_TABLE(hdmi_ids) = {
diff --git a/drivers/staging/gma500/mrst_lvds.c b/drivers/staging/gma500/mrst_lvds.c
index e7999a2..28f68ff 100644
--- a/drivers/staging/gma500/mrst_lvds.c
+++ b/drivers/staging/gma500/mrst_lvds.c
@@ -43,7 +43,8 @@
  * Sets the power state for the panel.
  */
 static void mrst_lvds_set_power(struct drm_device *dev,
-				struct psb_intel_output *output, bool on)
+				struct psb_intel_encoder *psb_intel_encoder,
+				bool on)
 {
 	u32 pp_status;
 	struct drm_psb_private *dev_priv = dev->dev_private;
@@ -77,12 +78,13 @@ static void mrst_lvds_set_power(struct drm_device *dev,
 static void mrst_lvds_dpms(struct drm_encoder *encoder, int mode)
 {
 	struct drm_device *dev = encoder->dev;
-	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
+	struct psb_intel_encoder *psb_intel_encoder =
+						to_psb_intel_encoder(encoder);
 
 	if (mode == DRM_MODE_DPMS_ON)
-		mrst_lvds_set_power(dev, output, true);
+		mrst_lvds_set_power(dev, psb_intel_encoder, true);
 	else
-		mrst_lvds_set_power(dev, output, false);
+		mrst_lvds_set_power(dev, psb_intel_encoder, false);
 
 	/* XXX: We never power down the LVDS pairs. */
 }
@@ -91,10 +93,12 @@ static void mrst_lvds_mode_set(struct drm_encoder *encoder,
 			       struct drm_display_mode *mode,
 			       struct drm_display_mode *adjusted_mode)
 {
-	struct psb_intel_mode_device *mode_dev =
-				enc_to_psb_intel_output(encoder)->mode_dev;
 	struct drm_device *dev = encoder->dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_intel_mode_device *mode_dev = &dev_priv->mode_dev;
+	struct drm_mode_config *mode_config = &dev->mode_config;
+	struct drm_connector *connector = NULL;
+	struct drm_crtc *crtc = encoder->crtc;
 	u32 lvds_port;
 	uint64_t v = DRM_MODE_SCALE_FULLSCREEN;
 
@@ -118,8 +122,19 @@ static void mrst_lvds_mode_set(struct drm_encoder *encoder,
 
 	REG_WRITE(LVDS, lvds_port);
 
+	/* Find the connector we're trying to set up */
+	list_for_each_entry(connector, &mode_config->connector_list, head) {
+		if (!connector->encoder || connector->encoder->crtc != crtc)
+			continue;
+	}
+
+	if (!connector) {
+		DRM_ERROR("Couldn't find connector when setting mode");
+		return;
+	}
+
 	drm_connector_property_get_value(
-		&enc_to_psb_intel_output(encoder)->base,
+		connector,
 		dev->mode_config.scaling_mode_property,
 		&v);
 
@@ -150,8 +165,10 @@ static void mrst_lvds_mode_set(struct drm_encoder *encoder,
 static void mrst_lvds_prepare(struct drm_encoder *encoder)
 {
 	struct drm_device *dev = encoder->dev;
-	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
-	struct psb_intel_mode_device *mode_dev = output->mode_dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_intel_encoder *psb_intel_encoder =
+						to_psb_intel_encoder(encoder);
+	struct psb_intel_mode_device *mode_dev = &dev_priv->mode_dev;
 
 	if (!gma_power_begin(dev, true))
 		return;
@@ -159,7 +176,7 @@ static void mrst_lvds_prepare(struct drm_encoder *encoder)
 	mode_dev->saveBLC_PWM_CTL = REG_READ(BLC_PWM_CTL);
 	mode_dev->backlight_duty_cycle = (mode_dev->saveBLC_PWM_CTL &
 					  BACKLIGHT_DUTY_CYCLE_MASK);
-	mrst_lvds_set_power(dev, output, false);
+	mrst_lvds_set_power(dev, psb_intel_encoder, false);
 	gma_power_end(dev);
 }
 
@@ -185,13 +202,15 @@ static u32 mrst_lvds_get_max_backlight(struct drm_device *dev)
 static void mrst_lvds_commit(struct drm_encoder *encoder)
 {
 	struct drm_device *dev = encoder->dev;
-	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
-	struct psb_intel_mode_device *mode_dev = output->mode_dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_intel_encoder *psb_intel_encoder =
+						to_psb_intel_encoder(encoder);
+	struct psb_intel_mode_device *mode_dev = &dev_priv->mode_dev;
 
 	if (mode_dev->backlight_duty_cycle == 0)
 		mode_dev->backlight_duty_cycle =
 					mrst_lvds_get_max_backlight(dev);
-	mrst_lvds_set_power(dev, output, true);
+	mrst_lvds_set_power(dev, psb_intel_encoder, true);
 }
 
 static const struct drm_encoder_helper_funcs mrst_lvds_helper_funcs = {
@@ -289,7 +308,8 @@ mrst_lvds_get_configuration_mode(struct drm_device *dev)
 void mrst_lvds_init(struct drm_device *dev,
 		    struct psb_intel_mode_device *mode_dev)
 {
-	struct psb_intel_output *psb_intel_output;
+	struct psb_intel_encoder *psb_intel_encoder;
+	struct psb_intel_connector *psb_intel_connector;
 	struct drm_connector *connector;
 	struct drm_encoder *encoder;
 	struct drm_psb_private *dev_priv =
@@ -299,24 +319,27 @@ void mrst_lvds_init(struct drm_device *dev,
 	struct i2c_adapter *i2c_adap;
 	struct drm_display_mode *scan;	/* *modes, *bios_mode; */
 
-	psb_intel_output = kzalloc(sizeof(struct psb_intel_output), GFP_KERNEL);
-	if (!psb_intel_output)
+	psb_intel_encoder = kzalloc(sizeof(struct psb_intel_encoder), GFP_KERNEL);
+	if (!psb_intel_encoder)
 		return;
 
-	psb_intel_output->mode_dev = mode_dev;
-	connector = &psb_intel_output->base;
-	encoder = &psb_intel_output->enc;
+	psb_intel_connector = kzalloc(sizeof(struct psb_intel_encoder), GFP_KERNEL);
+	if (!psb_intel_connector)
+		goto failed_connector;
+
+	connector = &psb_intel_connector->base;
+	encoder = &psb_intel_encoder->base;
 	dev_priv->is_lvds_on = true;
-	drm_connector_init(dev, &psb_intel_output->base,
+	drm_connector_init(dev, connector,
 			   &psb_intel_lvds_connector_funcs,
 			   DRM_MODE_CONNECTOR_LVDS);
 
-	drm_encoder_init(dev, &psb_intel_output->enc, &psb_intel_lvds_enc_funcs,
+	drm_encoder_init(dev, encoder, &psb_intel_lvds_enc_funcs,
 			 DRM_MODE_ENCODER_LVDS);
 
-	drm_mode_connector_attach_encoder(&psb_intel_output->base,
-					  &psb_intel_output->enc);
-	psb_intel_output->type = INTEL_OUTPUT_LVDS;
+	psb_intel_connector_attach_encoder(psb_intel_connector,
+					   psb_intel_encoder);
+	psb_intel_encoder->type = INTEL_OUTPUT_LVDS;
 
 	drm_encoder_helper_add(encoder, &mrst_lvds_helper_funcs);
 	drm_connector_helper_add(connector,
@@ -395,13 +418,15 @@ out:
 
 failed_find:
 	dev_dbg(dev->dev, "No LVDS modes found, disabling.\n");
-	if (psb_intel_output->ddc_bus)
-		psb_intel_i2c_destroy(psb_intel_output->ddc_bus);
+	if (psb_intel_encoder->ddc_bus)
+		psb_intel_i2c_destroy(psb_intel_encoder->ddc_bus);
 
 /* failed_ddc: */
 
 	drm_encoder_cleanup(encoder);
 	drm_connector_cleanup(connector);
-	kfree(connector);
+	kfree(psb_intel_connector);
+failed_connector:
+	kfree(psb_intel_encoder);
 }
 
-- 
1.7.4.1

