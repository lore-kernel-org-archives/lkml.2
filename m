Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935276Ab1KJDbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:31:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934631Ab1KJDa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:30:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:21 2011
Message-Id: <20111109212720.908238119@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [202/262] drm/radeon/kms: properly set panel mode for eDP
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 00dfb8df5bf8c3afe4c0bb8361133156b06b7a2c upstream.

This should make eDP more reliable.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_dp.c |   11 +++++++++++
 include/drm/drm_dp_helper.h          |    3 +++
 2 files changed, 14 insertions(+)

--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -553,6 +553,7 @@ static void radeon_dp_set_panel_mode(str
 {
 	struct drm_device *dev = encoder->dev;
 	struct radeon_device *rdev = dev->dev_private;
+	struct radeon_connector *radeon_connector = to_radeon_connector(connector);
 	int panel_mode = DP_PANEL_MODE_EXTERNAL_DP_MODE;
 
 	if (!ASIC_IS_DCE4(rdev))
@@ -560,10 +561,20 @@ static void radeon_dp_set_panel_mode(str
 
 	if (radeon_connector_encoder_is_dp_bridge(connector))
 		panel_mode = DP_PANEL_MODE_INTERNAL_DP1_MODE;
+	else if (connector->connector_type == DRM_MODE_CONNECTOR_eDP) {
+		u8 tmp = radeon_read_dpcd_reg(radeon_connector, DP_EDP_CONFIGURATION_CAP);
+		if (tmp & 1)
+			panel_mode = DP_PANEL_MODE_INTERNAL_DP2_MODE;
+	}
 
 	atombios_dig_encoder_setup(encoder,
 				   ATOM_ENCODER_CMD_SETUP_PANEL_MODE,
 				   panel_mode);
+
+	if ((connector->connector_type == DRM_MODE_CONNECTOR_eDP) &&
+	    (panel_mode == DP_PANEL_MODE_INTERNAL_DP2_MODE)) {
+		radeon_write_dpcd_reg(radeon_connector, DP_EDP_CONFIGURATION_SET, 1);
+	}
 }
 
 void radeon_dp_set_link_config(struct drm_connector *connector,
--- a/include/drm/drm_dp_helper.h
+++ b/include/drm/drm_dp_helper.h
@@ -72,6 +72,7 @@
 
 #define DP_MAIN_LINK_CHANNEL_CODING         0x006
 
+#define DP_EDP_CONFIGURATION_CAP            0x00d
 #define DP_TRAINING_AUX_RD_INTERVAL         0x00e
 
 /* link configuration */
@@ -133,6 +134,8 @@
 #define DP_MAIN_LINK_CHANNEL_CODING_SET	    0x108
 # define DP_SET_ANSI_8B10B		    (1 << 0)
 
+#define DP_EDP_CONFIGURATION_SET            0x10a
+
 #define DP_LANE0_1_STATUS		    0x202
 #define DP_LANE2_3_STATUS		    0x203
 # define DP_LANE_CR_DONE		    (1 << 0)


