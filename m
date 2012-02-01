Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab2BAVg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:36:26 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46257 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757293Ab2BAVKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:01 -0500
X-Sasl-enc: Druu6OvejwTurObDZCt5KEocqJYryIGThcef2lkWYdHa 1328130600
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:44 2012
Message-Id: <20120201210044.680366029@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [09/89] drm/radeon/kms: move panel mode setup into encoder mode set
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 386d4d751e8e0b4b693bb724f09aae064ee5297d upstream.

Needs to happen earlier in the mode set.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_dp.c       |   22 ++++++++++------------
 drivers/gpu/drm/radeon/atombios_encoders.c |   11 +++++++++++
 drivers/gpu/drm/radeon/radeon_mode.h       |    3 +++
 3 files changed, 24 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -549,8 +549,8 @@ bool radeon_dp_getdpcd(struct radeon_con
 	return false;
 }
 
-static void radeon_dp_set_panel_mode(struct drm_encoder *encoder,
-				     struct drm_connector *connector)
+int radeon_dp_get_panel_mode(struct drm_encoder *encoder,
+			     struct drm_connector *connector)
 {
 	struct drm_device *dev = encoder->dev;
 	struct radeon_device *rdev = dev->dev_private;
@@ -558,7 +558,7 @@ static void radeon_dp_set_panel_mode(str
 	int panel_mode = DP_PANEL_MODE_EXTERNAL_DP_MODE;
 
 	if (!ASIC_IS_DCE4(rdev))
-		return;
+		return panel_mode;
 
 	if (radeon_connector_encoder_get_dp_bridge_encoder_id(connector) ==
 	    ENCODER_OBJECT_ID_NUTMEG)
@@ -572,14 +572,7 @@ static void radeon_dp_set_panel_mode(str
 			panel_mode = DP_PANEL_MODE_INTERNAL_DP2_MODE;
 	}
 
-	atombios_dig_encoder_setup(encoder,
-				   ATOM_ENCODER_CMD_SETUP_PANEL_MODE,
-				   panel_mode);
-
-	if ((connector->connector_type == DRM_MODE_CONNECTOR_eDP) &&
-	    (panel_mode == DP_PANEL_MODE_INTERNAL_DP2_MODE)) {
-		radeon_write_dpcd_reg(radeon_connector, DP_EDP_CONFIGURATION_SET, 1);
-	}
+	return panel_mode;
 }
 
 void radeon_dp_set_link_config(struct drm_connector *connector,
@@ -717,6 +710,8 @@ static void radeon_dp_set_tp(struct rade
 
 static int radeon_dp_link_train_init(struct radeon_dp_link_train_info *dp_info)
 {
+	struct radeon_encoder *radeon_encoder = to_radeon_encoder(dp_info->encoder);
+	struct radeon_encoder_atom_dig *dig = radeon_encoder->enc_priv;
 	u8 tmp;
 
 	/* power up the sink */
@@ -732,7 +727,10 @@ static int radeon_dp_link_train_init(str
 		radeon_write_dpcd_reg(dp_info->radeon_connector,
 				      DP_DOWNSPREAD_CTRL, 0);
 
-	radeon_dp_set_panel_mode(dp_info->encoder, dp_info->connector);
+	if ((dp_info->connector->connector_type == DRM_MODE_CONNECTOR_eDP) &&
+	    (dig->panel_mode == DP_PANEL_MODE_INTERNAL_DP2_MODE)) {
+		radeon_write_dpcd_reg(dp_info->radeon_connector, DP_EDP_CONFIGURATION_SET, 1);
+	}
 
 	/* set the lane count on the sink */
 	tmp = dp_info->dp_lane_count;
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1822,10 +1822,21 @@ radeon_atom_encoder_mode_set(struct drm_
 	case ENCODER_OBJECT_ID_INTERNAL_UNIPHY2:
 	case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_LVTMA:
 		if (ASIC_IS_DCE4(rdev)) {
+			struct drm_connector *connector = radeon_get_connector_for_encoder(encoder);
+			struct radeon_encoder_atom_dig *dig = radeon_encoder->enc_priv;
+
+			if (!connector)
+				dig->panel_mode = DP_PANEL_MODE_EXTERNAL_DP_MODE;
+			else
+				dig->panel_mode = radeon_dp_get_panel_mode(encoder, connector);
+
 			/* disable the transmitter */
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE, 0, 0);
 			/* setup and enable the encoder */
 			atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_SETUP, 0);
+			atombios_dig_encoder_setup(encoder,
+						   ATOM_ENCODER_CMD_SETUP_PANEL_MODE,
+						   dig->panel_mode);
 
 			/* enable the transmitter */
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE, 0, 0);
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -362,6 +362,7 @@ struct radeon_encoder_atom_dig {
 	struct backlight_device *bl_dev;
 	int dpms_mode;
 	uint8_t backlight_level;
+	int panel_mode;
 };
 
 struct radeon_encoder_atom_dac {
@@ -482,6 +483,8 @@ extern void radeon_dp_link_train(struct
 extern bool radeon_dp_needs_link_train(struct radeon_connector *radeon_connector);
 extern u8 radeon_dp_getsinktype(struct radeon_connector *radeon_connector);
 extern bool radeon_dp_getdpcd(struct radeon_connector *radeon_connector);
+extern int radeon_dp_get_panel_mode(struct drm_encoder *encoder,
+				    struct drm_connector *connector);
 extern void atombios_dig_encoder_setup(struct drm_encoder *encoder, int action, int panel_mode);
 extern void radeon_atom_encoder_init(struct radeon_device *rdev);
 extern void atombios_dig_transmitter_setup(struct drm_encoder *encoder,


