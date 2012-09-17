Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab2IQAv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:51:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33999 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754890Ab2IQAvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:45 -0400
Message-Id: <20120917003629.574867527@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>
Subject: [ 024/135] drm/radeon/atom: rework DIG modesetting on DCE3+
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 8d1af57ae3c4458ed0de93ef97f388dd1b3239c7 upstream.

The ordering is important and the current drm code
wasn't cutting it for modern DIG encoders.  We need
to have information about crtc before setting up
the encoders so I've shifted the ordering a bit.
Probably we'll need a full rework akin to danvet's
recent intel patchs.  This patch fixes numerous
issues with DP bridge chips and makes link training
much more reliable.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: drop DCE6 cases]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---

--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1344,6 +1344,8 @@ radeon_atom_encoder_dpms_dig(struct drm_
 	struct drm_device *dev = encoder->dev;
 	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
+	struct drm_encoder *ext_encoder = radeon_get_external_encoder(encoder);
+	struct radeon_encoder_atom_dig *dig = radeon_encoder->enc_priv;
 	struct drm_connector *connector = radeon_get_connector_for_encoder(encoder);
 	struct radeon_connector *radeon_connector = NULL;
 	struct radeon_connector_atom_dig *radeon_dig_connector = NULL;
@@ -1355,12 +1357,38 @@ radeon_atom_encoder_dpms_dig(struct drm_
 
 	switch (mode) {
 	case DRM_MODE_DPMS_ON:
-		/* some early dce3.2 boards have a bug in their transmitter control table */
-		if ((rdev->family == CHIP_RV710) || (rdev->family == CHIP_RV730) ||
-		    ASIC_IS_DCE41(rdev) || ASIC_IS_DCE5(rdev))
+		if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE5(rdev)) {
+			if (!connector)
+				dig->panel_mode = DP_PANEL_MODE_EXTERNAL_DP_MODE;
+			else
+				dig->panel_mode = radeon_dp_get_panel_mode(encoder, connector);
+
+			/* setup and enable the encoder */
+			atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_SETUP, 0);
+			atombios_dig_encoder_setup(encoder,
+						   ATOM_ENCODER_CMD_SETUP_PANEL_MODE,
+						   dig->panel_mode);
+			if (ext_encoder) {
+				if (ASIC_IS_DCE41(rdev))
+					atombios_external_encoder_setup(encoder, ext_encoder,
+									EXTERNAL_ENCODER_ACTION_V3_ENCODER_SETUP);
+			}
+			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE, 0, 0);
+		} else if (ASIC_IS_DCE4(rdev)) {
+			/* setup and enable the encoder */
+			atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_SETUP, 0);
+			/* enable the transmitter */
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE, 0, 0);
-		else
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE_OUTPUT, 0, 0);
+		} else {
+			/* setup and enable the encoder and transmitter */
+			atombios_dig_encoder_setup(encoder, ATOM_ENABLE, 0);
+			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_SETUP, 0, 0);
+			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE, 0, 0);
+			/* some early dce3.2 boards have a bug in their transmitter control table */
+			if ((rdev->family != CHIP_RV710) || (rdev->family != CHIP_RV730))
+				atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE_OUTPUT, 0, 0);
+		}
 		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(encoder)) && connector) {
 			if (connector->connector_type == DRM_MODE_CONNECTOR_eDP) {
 				atombios_set_edp_panel_power(connector,
@@ -1377,10 +1403,19 @@ radeon_atom_encoder_dpms_dig(struct drm_
 	case DRM_MODE_DPMS_STANDBY:
 	case DRM_MODE_DPMS_SUSPEND:
 	case DRM_MODE_DPMS_OFF:
-		if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE5(rdev))
+		if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE5(rdev)) {
+			/* disable the transmitter */
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE, 0, 0);
-		else
+		} else if (ASIC_IS_DCE4(rdev)) {
+			/* disable the transmitter */
+			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE_OUTPUT, 0, 0);
+			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE, 0, 0);
+		} else {
+			/* disable the encoder and transmitter */
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE_OUTPUT, 0, 0);
+			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE, 0, 0);
+			atombios_dig_encoder_setup(encoder, ATOM_DISABLE, 0);
+		}
 		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(encoder)) && connector) {
 			if (ASIC_IS_DCE4(rdev))
 				atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_DP_VIDEO_OFF, 0);
@@ -1805,10 +1840,12 @@ radeon_atom_encoder_mode_set(struct drm_
 	struct drm_device *dev = encoder->dev;
 	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
-	struct drm_encoder *ext_encoder = radeon_get_external_encoder(encoder);
 
 	radeon_encoder->pixel_clock = adjusted_mode->clock;
 
+	/* need to call this here rather than in prepare() since we need some crtc info */
+	radeon_atom_encoder_dpms(encoder, DRM_MODE_DPMS_OFF);
+
 	if (ASIC_IS_AVIVO(rdev) && !ASIC_IS_DCE4(rdev)) {
 		if (radeon_encoder->active_device & (ATOM_DEVICE_CV_SUPPORT | ATOM_DEVICE_TV_SUPPORT))
 			atombios_yuv_setup(encoder, true);
@@ -1827,38 +1864,7 @@ radeon_atom_encoder_mode_set(struct drm_
 	case ENCODER_OBJECT_ID_INTERNAL_UNIPHY1:
 	case ENCODER_OBJECT_ID_INTERNAL_UNIPHY2:
 	case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_LVTMA:
-		if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE5(rdev)) {
-			struct drm_connector *connector = radeon_get_connector_for_encoder(encoder);
-			struct radeon_encoder_atom_dig *dig = radeon_encoder->enc_priv;
-
-			if (!connector)
-				dig->panel_mode = DP_PANEL_MODE_EXTERNAL_DP_MODE;
-			else
-				dig->panel_mode = radeon_dp_get_panel_mode(encoder, connector);
-
-			/* setup and enable the encoder */
-			atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_SETUP, 0);
-			atombios_dig_encoder_setup(encoder,
-						   ATOM_ENCODER_CMD_SETUP_PANEL_MODE,
-						   dig->panel_mode);
-		} else if (ASIC_IS_DCE4(rdev)) {
-			/* disable the transmitter */
-			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE, 0, 0);
-			/* setup and enable the encoder */
-			atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_SETUP, 0);
-
-			/* enable the transmitter */
-			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE, 0, 0);
-		} else {
-			/* disable the encoder and transmitter */
-			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE, 0, 0);
-			atombios_dig_encoder_setup(encoder, ATOM_DISABLE, 0);
-
-			/* setup and enable the encoder and transmitter */
-			atombios_dig_encoder_setup(encoder, ATOM_ENABLE, 0);
-			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_SETUP, 0, 0);
-			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE, 0, 0);
-		}
+		/* handled in dpms */
 		break;
 	case ENCODER_OBJECT_ID_INTERNAL_DDI:
 	case ENCODER_OBJECT_ID_INTERNAL_DVO1:
@@ -1879,14 +1885,6 @@ radeon_atom_encoder_mode_set(struct drm_
 		break;
 	}
 
-	if (ext_encoder) {
-		if (ASIC_IS_DCE41(rdev))
-			atombios_external_encoder_setup(encoder, ext_encoder,
-							EXTERNAL_ENCODER_ACTION_V3_ENCODER_SETUP);
-		else
-			atombios_external_encoder_setup(encoder, ext_encoder, ATOM_ENABLE);
-	}
-
 	atombios_apply_encoder_quirks(encoder, adjusted_mode);
 
 	if (atombios_get_encoder_mode(encoder) == ATOM_ENCODER_MODE_HDMI) {
@@ -2059,7 +2057,6 @@ static void radeon_atom_encoder_prepare(
 	}
 
 	radeon_atom_output_lock(encoder, true);
-	radeon_atom_encoder_dpms(encoder, DRM_MODE_DPMS_OFF);
 
 	if (connector) {
 		struct radeon_connector *radeon_connector = to_radeon_connector(connector);
@@ -2080,6 +2077,7 @@ static void radeon_atom_encoder_prepare(
 
 static void radeon_atom_encoder_commit(struct drm_encoder *encoder)
 {
+	/* need to call this here as we need the crtc set up */
 	radeon_atom_encoder_dpms(encoder, DRM_MODE_DPMS_ON);
 	radeon_atom_output_lock(encoder, false);
 }
@@ -2120,14 +2118,7 @@ static void radeon_atom_encoder_disable(
 	case ENCODER_OBJECT_ID_INTERNAL_UNIPHY1:
 	case ENCODER_OBJECT_ID_INTERNAL_UNIPHY2:
 	case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_LVTMA:
-		if (ASIC_IS_DCE4(rdev))
-			/* disable the transmitter */
-			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE, 0, 0);
-		else {
-			/* disable the encoder and transmitter */
-			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE, 0, 0);
-			atombios_dig_encoder_setup(encoder, ATOM_DISABLE, 0);
-		}
+		/* handled in dpms */
 		break;
 	case ENCODER_OBJECT_ID_INTERNAL_DDI:
 	case ENCODER_OBJECT_ID_INTERNAL_DVO1:


