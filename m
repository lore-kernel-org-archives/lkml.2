Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab1ISWWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:22:34 -0400
Received: from home.keithp.com ([63.227.221.253]:41905 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819Ab1ISWW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:22:29 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 6/9] drm/i915: Make sure eDP power is on before using aux channel
Date: Mon, 19 Sep 2011 15:22:00 -0700
Message-Id: <1316470923-27832-7-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1316470923-27832-1-git-send-email-keithp@keithp.com>
References: <1316470923-27832-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The eDP panel may not be able to respond to aux channel communications
unless it has power supplied. During mode setting, power may be
cut-off during panel power sequencing. Make sure that any aux channel
communications will work by forcing vdd power active as needed.

This also delays after turning power on and off to ensure that the
panel is keeping up.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   84 +++++++++++++++++++++++++++++---------
 1 files changed, 64 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index a983d0f..41b1e05 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -595,10 +595,15 @@ intel_dp_i2c_aux_ch(struct i2c_adapter *adapter, int mode,
 	return -EREMOTEIO;
 }
 
+static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp);
+static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp);
+
 static int
 intel_dp_i2c_init(struct intel_dp *intel_dp,
 		  struct intel_connector *intel_connector, const char *name)
 {
+	int	ret;
+
 	DRM_DEBUG_KMS("i2c_init %s\n", name);
 	intel_dp->algo.running = false;
 	intel_dp->algo.address = 0;
@@ -612,7 +617,10 @@ intel_dp_i2c_init(struct intel_dp *intel_dp,
 	intel_dp->adapter.algo_data = &intel_dp->algo;
 	intel_dp->adapter.dev.parent = &intel_connector->base.kdev;
 
-	return i2c_dp_aux_add_bus(&intel_dp->adapter);
+	ironlake_edp_panel_vdd_on(intel_dp);
+	ret = i2c_dp_aux_add_bus(&intel_dp->adapter);
+	ironlake_edp_panel_vdd_off(intel_dp);
+	return ret;
 }
 
 static bool
@@ -830,14 +838,20 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 {
 	struct drm_device *dev = intel_dp->base.base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 pp;
+	u32 pp, pp_status;
 
+	if (!is_edp(intel_dp))
+		return;
+	DRM_DEBUG_KMS("Turn eDP VDD on\n");
 	/*
 	 * If the panel wasn't on, make sure there's not a currently
 	 * active PP sequence before enabling AUX VDD.
 	 */
-	if (!(I915_READ(PCH_PP_STATUS) & PP_ON))
+	pp_status = I915_READ(PCH_PP_STATUS);
+	if (!(pp_status & PP_ON)) {
+		DRM_DEBUG_KMS("eDP VDD was not on\n");
 		msleep(dev_priv->panel_t3);
+	}
 
 	pp = I915_READ(PCH_PP_CONTROL);
 	pp &= ~PANEL_UNLOCK_MASK;
@@ -845,6 +859,9 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 	pp |= EDP_FORCE_VDD;
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
+	DRM_DEBUG_KMS("PCH_PP_STATUS: 0x%08x PCH_PP_CONTROL: 0x%08x\n",
+		      I915_READ(PCH_PP_STATUS), I915_READ(PCH_PP_CONTROL));
+	msleep(1000);
 }
 
 static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp)
@@ -853,6 +870,9 @@ static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 pp;
 
+	if (!is_edp(intel_dp))
+		return;
+	DRM_DEBUG_KMS("Turn eDP VDD off\n");
 	pp = I915_READ(PCH_PP_CONTROL);
 	pp &= ~PANEL_UNLOCK_MASK;
 	pp |= PANEL_UNLOCK_REGS;
@@ -862,6 +882,9 @@ static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp)
 
 	/* Make sure sequencer is idle before allowing subsequent activity */
 	msleep(dev_priv->panel_t12);
+	DRM_DEBUG_KMS("PCH_PP_STATUS: 0x%08x PCH_PP_CONTROL: 0x%08x\n",
+		      I915_READ(PCH_PP_STATUS), I915_READ(PCH_PP_CONTROL));
+	msleep(1000);
 }
 
 /* Returns true if the panel was already on when called */
@@ -1016,7 +1039,9 @@ static void intel_dp_prepare(struct drm_encoder *encoder)
 	struct drm_device *dev = encoder->dev;
 
 	/* Wake up the sink first */
+	ironlake_edp_panel_vdd_on(intel_dp);
 	intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_ON);
+	ironlake_edp_panel_vdd_off(intel_dp);
 
 	if (is_edp(intel_dp)) {
 		ironlake_edp_backlight_off(dev);
@@ -1034,21 +1059,17 @@ static void intel_dp_commit(struct drm_encoder *encoder)
 	struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 	struct drm_device *dev = encoder->dev;
 
-	if (is_edp(intel_dp))
-		ironlake_edp_panel_vdd_on(intel_dp);
-
+	ironlake_edp_panel_vdd_on(intel_dp);
 	intel_dp_start_link_train(intel_dp);
 
-	if (is_edp(intel_dp)) {
+	if (is_edp(intel_dp))
 		ironlake_edp_panel_on(intel_dp);
-		ironlake_edp_panel_vdd_off(intel_dp);
-	}
 
 	intel_dp_complete_link_train(intel_dp);
 
 	if (is_edp(intel_dp))
 		ironlake_edp_backlight_on(dev);
-
+	ironlake_edp_panel_vdd_off(intel_dp);
 	intel_dp->dpms_mode = DRM_MODE_DPMS_ON;
 }
 
@@ -1060,6 +1081,7 @@ intel_dp_dpms(struct drm_encoder *encoder, int mode)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	uint32_t dp_reg = I915_READ(intel_dp->output_reg);
 
+	ironlake_edp_panel_vdd_on(intel_dp);
 	if (mode != DRM_MODE_DPMS_ON) {
 		if (is_edp(intel_dp))
 			ironlake_edp_backlight_off(dev);
@@ -1070,20 +1092,17 @@ intel_dp_dpms(struct drm_encoder *encoder, int mode)
 		if (is_edp(intel_dp) && !is_pch_edp(intel_dp))
 			ironlake_edp_pll_off(encoder);
 	} else {
-		if (is_edp(intel_dp))
-			ironlake_edp_panel_vdd_on(intel_dp);
 		intel_dp_sink_dpms(intel_dp, mode);
 		if (!(dp_reg & DP_PORT_EN)) {
 			intel_dp_start_link_train(intel_dp);
-			if (is_edp(intel_dp)) {
+			if (is_edp(intel_dp))
 				ironlake_edp_panel_on(intel_dp);
-				ironlake_edp_panel_vdd_off(intel_dp);
-			}
 			intel_dp_complete_link_train(intel_dp);
 		}
 		if (is_edp(intel_dp))
 			ironlake_edp_backlight_on(dev);
 	}
+	ironlake_edp_panel_vdd_off(intel_dp);
 	intel_dp->dpms_mode = mode;
 }
 
@@ -1710,6 +1729,31 @@ g4x_dp_detect(struct intel_dp *intel_dp)
 	return intel_dp_detect_dpcd(intel_dp);
 }
 
+static struct edid *
+intel_dp_get_edid(struct drm_connector *connector, struct i2c_adapter *adapter)
+{
+	struct intel_dp *intel_dp = intel_attached_dp(connector);
+	struct edid	*edid;
+
+	ironlake_edp_panel_vdd_on(intel_dp);
+	edid = drm_get_edid(connector, adapter);
+	ironlake_edp_panel_vdd_off(intel_dp);
+	return edid;
+}
+
+static int
+intel_dp_get_edid_modes(struct drm_connector *connector, struct i2c_adapter *adapter)
+{
+	struct intel_dp *intel_dp = intel_attached_dp(connector);
+	int	ret;
+
+	ironlake_edp_panel_vdd_on(intel_dp);
+	ret = intel_ddc_get_modes(connector, adapter);
+	ironlake_edp_panel_vdd_off(intel_dp);
+	return ret;
+}
+
+
 /**
  * Uses CRT_HOTPLUG_EN and CRT_HOTPLUG_STAT to detect DP connection.
  *
@@ -1742,7 +1786,7 @@ intel_dp_detect(struct drm_connector *connector, bool force)
 	if (intel_dp->force_audio) {
 		intel_dp->has_audio = intel_dp->force_audio > 0;
 	} else {
-		edid = drm_get_edid(connector, &intel_dp->adapter);
+		edid = intel_dp_get_edid(connector, &intel_dp->adapter);
 		if (edid) {
 			intel_dp->has_audio = drm_detect_monitor_audio(edid);
 			connector->display_info.raw_edid = NULL;
@@ -1763,7 +1807,7 @@ static int intel_dp_get_modes(struct drm_connector *connector)
 	/* We should parse the EDID data and find out if it has an audio sink
 	 */
 
-	ret = intel_ddc_get_modes(connector, &intel_dp->adapter);
+	ret = intel_dp_get_edid_modes(connector, &intel_dp->adapter);
 	if (ret) {
 		if (is_edp(intel_dp) && !dev_priv->panel_fixed_mode) {
 			struct drm_display_mode *newmode;
@@ -1808,7 +1852,7 @@ intel_dp_detect_audio(struct drm_connector *connector)
 	struct edid *edid;
 	bool has_audio = false;
 
-	edid = drm_get_edid(connector, &intel_dp->adapter);
+	edid = intel_dp_get_edid(connector, &intel_dp->adapter);
 	if (edid) {
 		has_audio = drm_detect_monitor_audio(edid);
 
@@ -2068,8 +2112,6 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 			break;
 	}
 
-	intel_dp_i2c_init(intel_dp, intel_connector, name);
-
 	/* Cache some DPCD data in the eDP case */
 	if (is_edp(intel_dp)) {
 		bool ret;
@@ -2101,6 +2143,8 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 		}
 	}
 
+	intel_dp_i2c_init(intel_dp, intel_connector, name);
+
 	intel_encoder->hot_plug = intel_dp_hot_plug;
 
 	if (is_edp(intel_dp)) {
-- 
1.7.6.3

