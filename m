Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab2BAVgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:36:05 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58991 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757283Ab2BAVKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:03 -0500
X-Sasl-enc: ber3qn0erBoG+VKP1sziv20hfYdoEnmPVQjXqvdO4H6r 1328130601
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:44 2012
Message-Id: <20120201210044.760939071@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [10/89] drm/radeon/kms: rework modeset sequence for DCE41 and DCE5
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 3a47824d85eeca122895646f027dc63480994199 upstream.

dig transmitter control table only has ENABLE/DISABLE actions
on DCE4.1/DCE5.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=44955

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_encoders.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1352,7 +1352,8 @@ radeon_atom_encoder_dpms_dig(struct drm_
 	switch (mode) {
 	case DRM_MODE_DPMS_ON:
 		/* some early dce3.2 boards have a bug in their transmitter control table */
-		if ((rdev->family == CHIP_RV710) || (rdev->family == CHIP_RV730))
+		if ((rdev->family == CHIP_RV710) || (rdev->family == CHIP_RV730) ||
+		    ASIC_IS_DCE41(rdev) || ASIC_IS_DCE5(rdev))
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE, 0, 0);
 		else
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE_OUTPUT, 0, 0);
@@ -1362,8 +1363,6 @@ radeon_atom_encoder_dpms_dig(struct drm_
 							     ATOM_TRANSMITTER_ACTION_POWER_ON);
 				radeon_dig_connector->edp_on = true;
 			}
-			if (ASIC_IS_DCE4(rdev))
-				atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_DP_VIDEO_OFF, 0);
 			radeon_dp_link_train(encoder, connector);
 			if (ASIC_IS_DCE4(rdev))
 				atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_DP_VIDEO_ON, 0);
@@ -1374,7 +1373,10 @@ radeon_atom_encoder_dpms_dig(struct drm_
 	case DRM_MODE_DPMS_STANDBY:
 	case DRM_MODE_DPMS_SUSPEND:
 	case DRM_MODE_DPMS_OFF:
-		atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE_OUTPUT, 0, 0);
+		if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE5(rdev))
+			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE, 0, 0);
+		else
+			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE_OUTPUT, 0, 0);
 		if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(encoder)) && connector) {
 			if (ASIC_IS_DCE4(rdev))
 				atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_DP_VIDEO_OFF, 0);
@@ -1821,7 +1823,7 @@ radeon_atom_encoder_mode_set(struct drm_
 	case ENCODER_OBJECT_ID_INTERNAL_UNIPHY1:
 	case ENCODER_OBJECT_ID_INTERNAL_UNIPHY2:
 	case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_LVTMA:
-		if (ASIC_IS_DCE4(rdev)) {
+		if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE5(rdev)) {
 			struct drm_connector *connector = radeon_get_connector_for_encoder(encoder);
 			struct radeon_encoder_atom_dig *dig = radeon_encoder->enc_priv;
 
@@ -1830,13 +1832,16 @@ radeon_atom_encoder_mode_set(struct drm_
 			else
 				dig->panel_mode = radeon_dp_get_panel_mode(encoder, connector);
 
-			/* disable the transmitter */
-			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE, 0, 0);
 			/* setup and enable the encoder */
 			atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_SETUP, 0);
 			atombios_dig_encoder_setup(encoder,
 						   ATOM_ENCODER_CMD_SETUP_PANEL_MODE,
 						   dig->panel_mode);
+		} else if (ASIC_IS_DCE4(rdev)) {
+			/* disable the transmitter */
+			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_DISABLE, 0, 0);
+			/* setup and enable the encoder */
+			atombios_dig_encoder_setup(encoder, ATOM_ENCODER_CMD_SETUP, 0);
 
 			/* enable the transmitter */
 			atombios_dig_transmitter_setup(encoder, ATOM_TRANSMITTER_ACTION_ENABLE, 0, 0);


