Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab1J0WDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 18:03:02 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56538 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab1J0WCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 18:02:54 -0400
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, greg@kroah.com
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 9/9] gma500: Convert Medfield to work with new output handling
Date: Fri, 28 Oct 2011 00:02:14 +0200
Message-Id: <1319752934-1919-10-git-send-email-patrik.r.jakobsson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
References: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is WIP and is lacking code for putting a type on psb_intel_encoder.
Medfield has some wacky encoder and connector handling which doesn't fit our
model but Medfield is going to need more work anyways so I don't care much
about it at the moment.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
---
 drivers/staging/gma500/mdfld_dsi_dbi.c       |    5 +++
 drivers/staging/gma500/mdfld_dsi_dpi.c       |    5 +++
 drivers/staging/gma500/mdfld_dsi_output.c    |   40 ++++++++++++++++---------
 drivers/staging/gma500/mdfld_intel_display.c |   14 ++++----
 drivers/staging/gma500/medfield.h            |    6 ++--
 5 files changed, 45 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/gma500/mdfld_dsi_dbi.c b/drivers/staging/gma500/mdfld_dsi_dbi.c
index fd211f3..fa11309 100644
--- a/drivers/staging/gma500/mdfld_dsi_dbi.c
+++ b/drivers/staging/gma500/mdfld_dsi_dbi.c
@@ -635,6 +635,10 @@ static const struct drm_encoder_funcs mdfld_dsi_dbi_encoder_funcs = {
  * Allocate an mdfld_dsi_encoder and attach it to given @dsi_connector
  * return pointer of newly allocated DBI encoder, NULL on error
  */
+
+/* FIXME: We must mark the encoder type here in a psb_intel_encoder
+ * since we no longer have psb_intel_output.
+ */
 struct mdfld_dsi_encoder *mdfld_dsi_dbi_init(struct drm_device *dev,
 				struct mdfld_dsi_connector *dsi_connector,
 				struct panel_funcs *p_funcs)
@@ -719,6 +723,7 @@ struct mdfld_dsi_encoder *mdfld_dsi_dbi_init(struct drm_device *dev,
 	drm_encoder_helper_add(encoder, p_funcs->encoder_helper_funcs);
 
 	/* Attach to given connector */
+	/* FIXME: Use psb_intel_connector_attach_encoder here instead */
 	drm_mode_connector_attach_encoder(connector, encoder);
 
 	/* Set possible CRTCs and clones */
diff --git a/drivers/staging/gma500/mdfld_dsi_dpi.c b/drivers/staging/gma500/mdfld_dsi_dpi.c
index e685f12..ad50c1b4 100644
--- a/drivers/staging/gma500/mdfld_dsi_dpi.c
+++ b/drivers/staging/gma500/mdfld_dsi_dpi.c
@@ -709,6 +709,10 @@ void mdfld_dsi_dpi_mode_set(struct drm_encoder *encoder,
  * Allocate an mdfld_dsi_encoder and attach it to given @dsi_connector
  * return pointer of newly allocated DPI encoder, NULL on error
  */ 
+
+/* FIXME: We must mark the encoder type here in a psb_intel_encoder
+ * since we no longer have psb_intel_output.
+ */
 struct mdfld_dsi_encoder *mdfld_dsi_dpi_init(struct drm_device *dev, 
 				struct mdfld_dsi_connector *dsi_connector,
 				struct panel_funcs *p_funcs)
@@ -790,6 +794,7 @@ struct mdfld_dsi_encoder *mdfld_dsi_dpi_init(struct drm_device *dev,
 				p_funcs->encoder_helper_funcs);
 	
 	/* Attach to given connector */
+	/* FIXME: Use psb_intel_connector attach_encoder here instead */
 	drm_mode_connector_attach_encoder(connector, encoder);
 	
 	/* Set possible crtcs and clones */
diff --git a/drivers/staging/gma500/mdfld_dsi_output.c b/drivers/staging/gma500/mdfld_dsi_output.c
index 9050c0f..42b2eff 100644
--- a/drivers/staging/gma500/mdfld_dsi_output.c
+++ b/drivers/staging/gma500/mdfld_dsi_output.c
@@ -471,10 +471,10 @@ static void mdfld_dsi_connector_restore(struct drm_connector * connector)
 
 static enum drm_connector_status mdfld_dsi_connector_detect(struct drm_connector * connector, bool force)
 {
-	struct psb_intel_output *psb_output
-					= to_psb_intel_output(connector);
-	struct mdfld_dsi_connector *dsi_connector
-	                                = MDFLD_DSI_CONNECTOR(psb_output);
+	struct psb_intel_connector *psb_intel_connector =
+					to_psb_intel_connector(connector);
+	struct mdfld_dsi_connector *dsi_connector =
+				MDFLD_DSI_CONNECTOR(psb_intel_connector);
 	return dsi_connector->status;
 }
 
@@ -552,8 +552,10 @@ set_prop_error:
 
 static void mdfld_dsi_connector_destroy(struct drm_connector *connector)
 {
-	struct psb_intel_output * psb_output = to_psb_intel_output(connector);
-	struct mdfld_dsi_connector * dsi_connector = MDFLD_DSI_CONNECTOR(psb_output);
+	struct psb_intel_connector *psb_intel_connector =
+					to_psb_intel_connector(connector);
+	struct mdfld_dsi_connector *dsi_connector =
+				MDFLD_DSI_CONNECTOR(psb_intel_connector);
 	struct mdfld_dsi_pkg_sender * sender;
 	
 	if(!dsi_connector)
@@ -571,8 +573,10 @@ static void mdfld_dsi_connector_destroy(struct drm_connector *connector)
 
 static int mdfld_dsi_connector_get_modes(struct drm_connector * connector)
 {
-	struct psb_intel_output * psb_output = to_psb_intel_output(connector);
-	struct mdfld_dsi_connector * dsi_connector = MDFLD_DSI_CONNECTOR(psb_output);
+	struct psb_intel_connector *psb_intel_connector =
+					to_psb_intel_connector(connector);
+	struct mdfld_dsi_connector *dsi_connector =
+				MDFLD_DSI_CONNECTOR(psb_intel_connector);
 	struct mdfld_dsi_config * dsi_config = mdfld_dsi_get_config(dsi_connector);
 	struct drm_display_mode * fixed_mode = dsi_config->fixed_mode;
 	struct drm_display_mode * dup_mode = NULL;
@@ -597,8 +601,10 @@ static int mdfld_dsi_connector_get_modes(struct drm_connector * connector)
 
 static int mdfld_dsi_connector_mode_valid(struct drm_connector * connector, struct drm_display_mode * mode)
 {
-	struct psb_intel_output * psb_output = to_psb_intel_output(connector);
-	struct mdfld_dsi_connector * dsi_connector = MDFLD_DSI_CONNECTOR(psb_output);
+	struct psb_intel_connector *psb_intel_connector =
+					to_psb_intel_connector(connector);
+	struct mdfld_dsi_connector *dsi_connector =
+				MDFLD_DSI_CONNECTOR(psb_intel_connector);
 	struct mdfld_dsi_config * dsi_config = mdfld_dsi_get_config(dsi_connector);
 	struct drm_display_mode * fixed_mode = dsi_config->fixed_mode;
 
@@ -674,8 +680,10 @@ static void mdfld_dsi_connector_dpms(struct drm_connector *connector, int mode)
 static struct drm_encoder *mdfld_dsi_connector_best_encoder(
                                         struct drm_connector *connector) 
 {
-	struct psb_intel_output * psb_output = to_psb_intel_output(connector);
-	struct mdfld_dsi_connector * dsi_connector = MDFLD_DSI_CONNECTOR(psb_output);
+	struct psb_intel_connector *psb_intel_connector =
+					to_psb_intel_connector(connector);
+	struct mdfld_dsi_connector *dsi_connector =
+				MDFLD_DSI_CONNECTOR(psb_intel_connector);
 	struct mdfld_dsi_config * dsi_config = mdfld_dsi_get_config(dsi_connector);
 	struct mdfld_dsi_encoder * encoder = NULL;
 	
@@ -874,7 +882,7 @@ void mdfld_dsi_output_init(struct drm_device *dev,
 {
 	struct mdfld_dsi_config * dsi_config;
 	struct mdfld_dsi_connector * dsi_connector;
-	struct psb_intel_output * psb_output;
+	struct psb_intel_connector *psb_intel_connector;
 	struct drm_connector * connector;
 	struct mdfld_dsi_encoder * encoder;
 	struct drm_psb_private * dev_priv = dev->dev_private;
@@ -950,11 +958,13 @@ void mdfld_dsi_output_init(struct drm_device *dev,
 	}
 
 	/*init drm connector object*/
-	psb_output = &dsi_connector->base;
+	psb_intel_connector = &dsi_connector->base;
 	
+	/* FIXME: Cannot mark type here since we have no psb_intel_encoder.
 	psb_output->type = (pipe == 0) ? INTEL_OUTPUT_MIPI : INTEL_OUTPUT_MIPI2;
+	*/
 
-	connector = &psb_output->base;
+	connector = &psb_intel_connector->base;
 	/* Revisit type if MIPI/HDMI bridges ever appear on Medfield */
 	drm_connector_init(dev, connector, &mdfld_dsi_connector_funcs,
 						DRM_MODE_CONNECTOR_LVDS);
diff --git a/drivers/staging/gma500/mdfld_intel_display.c b/drivers/staging/gma500/mdfld_intel_display.c
index 8eb827e..7c99033 100644
--- a/drivers/staging/gma500/mdfld_intel_display.c
+++ b/drivers/staging/gma500/mdfld_intel_display.c
@@ -1000,10 +1000,10 @@ static int mdfld_crtc_mode_set(struct drm_crtc *crtc,
 	bool is_crt = false, is_lvds = false, is_tv = false;
 	bool is_mipi = false, is_mipi2 = false, is_hdmi = false;
 	struct drm_mode_config *mode_config = &dev->mode_config;
-	struct psb_intel_output *psb_intel_output = NULL;
+	struct psb_intel_encoder *psb_intel_encoder = NULL;
 	uint64_t scalingType = DRM_MODE_SCALE_FULLSCREEN;
 	struct drm_encoder *encoder;
-	struct drm_connector *connector;
+	struct drm_connector *connector = NULL;
 	int timeout = 0;
 
 	dev_dbg(dev->dev, "pipe = 0x%x \n", pipe);
@@ -1090,11 +1090,11 @@ static int mdfld_crtc_mode_set(struct drm_crtc *crtc,
 		if (encoder->crtc != crtc)
 			continue;
 
-		psb_intel_output = to_psb_intel_output(connector);
+		psb_intel_encoder = to_psb_intel_encoder(encoder);
 		
-		dev_dbg(dev->dev, "output->type = 0x%x \n", psb_intel_output->type);
+		dev_dbg(dev->dev, "encoder->type = 0x%x \n", psb_intel_encoder->type);
 
-		switch (psb_intel_output->type) {
+		switch (psb_intel_encoder->type) {
 		case INTEL_OUTPUT_LVDS:
 			is_lvds = true;
 			break;
@@ -1144,8 +1144,8 @@ static int mdfld_crtc_mode_set(struct drm_crtc *crtc,
 
 	REG_WRITE(dsppos_reg, 0);
 
-	if (psb_intel_output)
-		drm_connector_property_get_value(&psb_intel_output->base,
+	if (connector)
+		drm_connector_property_get_value(connector,
 			dev->mode_config.scaling_mode_property, &scalingType);
 
 	if (scalingType == DRM_MODE_SCALE_NO_SCALE) {
diff --git a/drivers/staging/gma500/medfield.h b/drivers/staging/gma500/medfield.h
index 09e9687..39c9e3a 100644
--- a/drivers/staging/gma500/medfield.h
+++ b/drivers/staging/gma500/medfield.h
@@ -209,7 +209,7 @@ struct mdfld_dsi_connector {
 	 * This is ugly, but I have to use connector in it! :-(
 	 * FIXME: use drm_connector instead.
 	 */
-	struct psb_intel_output base;
+	struct psb_intel_connector base;
 
 	int pipe;
 	void *private;
@@ -250,8 +250,8 @@ struct mdfld_dsi_config {
 	int dvr_ic_inited;
 };
 
-#define MDFLD_DSI_CONNECTOR(psb_output) \
-		(container_of(psb_output, struct mdfld_dsi_connector, base))
+#define MDFLD_DSI_CONNECTOR(psb_connector) \
+		(container_of(psb_connector, struct mdfld_dsi_connector, base))
 
 #define MDFLD_DSI_ENCODER(encoder) \
 		(container_of(encoder, struct mdfld_dsi_encoder, base))
-- 
1.7.4.1

