Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab1ISWW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:22:27 -0400
Received: from home.keithp.com ([63.227.221.253]:41895 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab1ISWW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:22:26 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 8/9] drm/i915: Move eDP panel fixed mode from dev_priv to intel_dp
Date: Mon, 19 Sep 2011 15:22:02 -0700
Message-Id: <1316470923-27832-9-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1316470923-27832-1-git-send-email-keithp@keithp.com>
References: <1316470923-27832-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This value doesn't come directly from the VBT, and so is rather
specific to the particular DP output.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_drv.h |    1 -
 drivers/gpu/drm/i915/intel_dp.c |   35 ++++++++++++++++-------------------
 2 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index bcdf58b..e6dd19e 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -347,7 +347,6 @@ typedef struct drm_i915_private {
 	/* LVDS info */
 	int backlight_level;  /* restore backlight to this value */
 	bool backlight_enabled;
-	struct drm_display_mode *panel_fixed_mode;
 	struct drm_display_mode *lfp_lvds_vbt_mode; /* if any */
 	struct drm_display_mode *sdvo_lvds_vbt_mode; /* if any */
 
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index f1d6105..5bc30f9 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -61,6 +61,7 @@ struct intel_dp {
 	uint8_t link_status[DP_LINK_STATUS_SIZE];
 	int panel_power_up_delay;
 	int panel_power_down_delay;
+	struct drm_display_mode *panel_fixed_mode;  /* for eDP */
 };
 
 /**
@@ -202,16 +203,14 @@ intel_dp_mode_valid(struct drm_connector *connector,
 		    struct drm_display_mode *mode)
 {
 	struct intel_dp *intel_dp = intel_attached_dp(connector);
-	struct drm_device *dev = connector->dev;
-	struct drm_i915_private *dev_priv = dev->dev_private;
 	int max_link_clock = intel_dp_link_clock(intel_dp_max_link_bw(intel_dp));
 	int max_lanes = intel_dp_max_lane_count(intel_dp);
 
-	if (is_edp(intel_dp) && dev_priv->panel_fixed_mode) {
-		if (mode->hdisplay > dev_priv->panel_fixed_mode->hdisplay)
+	if (is_edp(intel_dp) && intel_dp->panel_fixed_mode) {
+		if (mode->hdisplay > intel_dp->panel_fixed_mode->hdisplay)
 			return MODE_PANEL;
 
-		if (mode->vdisplay > dev_priv->panel_fixed_mode->vdisplay)
+		if (mode->vdisplay > intel_dp->panel_fixed_mode->vdisplay)
 			return MODE_PANEL;
 	}
 
@@ -630,22 +629,21 @@ intel_dp_mode_fixup(struct drm_encoder *encoder, struct drm_display_mode *mode,
 		    struct drm_display_mode *adjusted_mode)
 {
 	struct drm_device *dev = encoder->dev;
-	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 	int lane_count, clock;
 	int max_lane_count = intel_dp_max_lane_count(intel_dp);
 	int max_clock = intel_dp_max_link_bw(intel_dp) == DP_LINK_BW_2_7 ? 1 : 0;
 	static int bws[2] = { DP_LINK_BW_1_62, DP_LINK_BW_2_7 };
 
-	if (is_edp(intel_dp) && dev_priv->panel_fixed_mode) {
-		intel_fixed_panel_mode(dev_priv->panel_fixed_mode, adjusted_mode);
+	if (is_edp(intel_dp) && intel_dp->panel_fixed_mode) {
+		intel_fixed_panel_mode(intel_dp->panel_fixed_mode, adjusted_mode);
 		intel_pch_panel_fitting(dev, DRM_MODE_SCALE_FULLSCREEN,
 					mode, adjusted_mode);
 		/*
 		 * the mode->clock is used to calculate the Data&Link M/N
 		 * of the pipe. For the eDP the fixed clock should be used.
 		 */
-		mode->clock = dev_priv->panel_fixed_mode->clock;
+		mode->clock = intel_dp->panel_fixed_mode->clock;
 	}
 
 	for (lane_count = 1; lane_count <= max_lane_count; lane_count <<= 1) {
@@ -1812,35 +1810,34 @@ static int intel_dp_get_modes(struct drm_connector *connector)
 
 	ret = intel_dp_get_edid_modes(connector, &intel_dp->adapter);
 	if (ret) {
-		if (is_edp(intel_dp) && !dev_priv->panel_fixed_mode) {
+		if (is_edp(intel_dp) && !intel_dp->panel_fixed_mode) {
 			struct drm_display_mode *newmode;
 			list_for_each_entry(newmode, &connector->probed_modes,
 					    head) {
-				if (newmode->type & DRM_MODE_TYPE_PREFERRED) {
-					dev_priv->panel_fixed_mode =
+				if ((newmode->type & DRM_MODE_TYPE_PREFERRED)) {
+					intel_dp->panel_fixed_mode =
 						drm_mode_duplicate(dev, newmode);
 					break;
 				}
 			}
 		}
-
 		return ret;
 	}
 
 	/* if eDP has no EDID, try to use fixed panel mode from VBT */
 	if (is_edp(intel_dp)) {
 		/* initialize panel mode from VBT if available for eDP */
-		if (dev_priv->panel_fixed_mode == NULL && dev_priv->lfp_lvds_vbt_mode != NULL) {
-			dev_priv->panel_fixed_mode =
+		if (intel_dp->panel_fixed_mode == NULL && dev_priv->lfp_lvds_vbt_mode != NULL) {
+			intel_dp->panel_fixed_mode =
 				drm_mode_duplicate(dev, dev_priv->lfp_lvds_vbt_mode);
-			if (dev_priv->panel_fixed_mode) {
-				dev_priv->panel_fixed_mode->type |=
+			if (intel_dp->panel_fixed_mode) {
+				intel_dp->panel_fixed_mode->type |=
 					DRM_MODE_TYPE_PREFERRED;
 			}
 		}
-		if (dev_priv->panel_fixed_mode) {
+		if (intel_dp->panel_fixed_mode) {
 			struct drm_display_mode *mode;
-			mode = drm_mode_duplicate(dev, dev_priv->panel_fixed_mode);
+			mode = drm_mode_duplicate(dev, intel_dp->panel_fixed_mode);
 			drm_mode_probed_add(connector, mode);
 			return 1;
 		}
-- 
1.7.6.3

