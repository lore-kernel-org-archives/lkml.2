Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab1KBGVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 02:21:04 -0400
Received: from home.keithp.com ([63.227.221.253]:33657 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431Ab1KBGU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 02:20:56 -0400
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH 3/7] drm/i915: Treat PCH eDP like DP in most places
Date: Tue,  1 Nov 2011 23:20:26 -0700
Message-Id: <1320214830-12696-4-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320214830-12696-1-git-send-email-keithp@keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCH eDP has many of the same needs as regular PCH DP connections,
including the DP_CTl bit settings, the TRANS_DP_CTL register.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_display.c |    3 +-
 drivers/gpu/drm/i915/intel_dp.c      |  112 ++++++++++++++++++++++++----------
 2 files changed, 81 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 9fa342e..53eb29e 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2933,7 +2933,8 @@ static void ironlake_pch_enable(struct drm_crtc *crtc)
 
 	/* For PCH DP, enable TRANS_DP_CTL */
 	if (HAS_PCH_CPT(dev) &&
-	    intel_pipe_has_type(crtc, INTEL_OUTPUT_DISPLAYPORT)) {
+	    (intel_pipe_has_type(crtc, INTEL_OUTPUT_DISPLAYPORT) ||
+	     intel_pipe_has_type(crtc, INTEL_OUTPUT_EDP))) {
 		u32 bpc = (I915_READ(PIPECONF(pipe)) & PIPE_BPC_MASK) >> 5;
 		reg = TRANS_DP_CTL(pipe);
 		temp = I915_READ(reg);
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 2c0c482..185fae6 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -766,10 +766,10 @@ intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_display_mode *mode,
 			continue;
 
 		intel_dp = enc_to_intel_dp(encoder);
-		if (intel_dp->base.type == INTEL_OUTPUT_DISPLAYPORT) {
+		if (intel_dp->base.type == INTEL_OUTPUT_DISPLAYPORT || is_pch_edp(intel_dp)) {
 			lane_count = intel_dp->lane_count;
 			break;
-		} else if (is_edp(intel_dp)) {
+		} else if (is_cpu_edp(intel_dp)) {
 			lane_count = dev_priv->edp.lanes;
 			break;
 		}
@@ -808,6 +808,7 @@ intel_dp_mode_set(struct drm_encoder *encoder, struct drm_display_mode *mode,
 		  struct drm_display_mode *adjusted_mode)
 {
 	struct drm_device *dev = encoder->dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 	struct drm_crtc *crtc = intel_dp->base.base.crtc;
 	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
@@ -820,18 +821,31 @@ intel_dp_mode_set(struct drm_encoder *encoder, struct drm_display_mode *mode,
 			ironlake_edp_pll_off(encoder);
 	}
 
-	intel_dp->DP = DP_VOLTAGE_0_4 | DP_PRE_EMPHASIS_0;
-	intel_dp->DP |= intel_dp->color_range;
+	/*
+	 * There are three kinds of DP registers:
+	 *
+	 * 	IBX PCH
+	 * 	CPU
+	 * 	CPT PCH
+	 *
+	 * IBX PCH and CPU are the same for almost everything,
+	 * except that the CPU DP PLL is configured in this
+	 * register
+	 *
+	 * CPT PCH is quite different, having many bits moved
+	 * to the TRANS_DP_CTL register instead. That
+	 * configuration happens (oddly) in ironlake_pch_enable
+	 */
 
-	if (adjusted_mode->flags & DRM_MODE_FLAG_PHSYNC)
-		intel_dp->DP |= DP_SYNC_HS_HIGH;
-	if (adjusted_mode->flags & DRM_MODE_FLAG_PVSYNC)
-		intel_dp->DP |= DP_SYNC_VS_HIGH;
+	/* Preserve the BIOS-computed detected bit. This is
+	 * supposed to be read-only.
+	 */
+	intel_dp->DP = I915_READ(intel_dp->output_reg) & DP_DETECTED;
+	intel_dp->DP |=  DP_VOLTAGE_0_4 | DP_PRE_EMPHASIS_0;
 
-	if (HAS_PCH_CPT(dev) && !is_cpu_edp(intel_dp))
-		intel_dp->DP |= DP_LINK_TRAIN_OFF_CPT;
-	else
-		intel_dp->DP |= DP_LINK_TRAIN_OFF;
+	/* Handle DP bits in common between all three register formats */
+
+	intel_dp->DP |= DP_VOLTAGE_0_4 | DP_PRE_EMPHASIS_0;
 
 	switch (intel_dp->lane_count) {
 	case 1:
@@ -850,32 +864,54 @@ intel_dp_mode_set(struct drm_encoder *encoder, struct drm_display_mode *mode,
 		intel_dp->DP |= DP_AUDIO_OUTPUT_ENABLE;
 		intel_write_eld(encoder, adjusted_mode);
 	}
-
 	memset(intel_dp->link_configuration, 0, DP_LINK_CONFIGURATION_SIZE);
 	intel_dp->link_configuration[0] = intel_dp->link_bw;
 	intel_dp->link_configuration[1] = intel_dp->lane_count;
 	intel_dp->link_configuration[8] = DP_SET_ANSI_8B10B;
-
 	/*
 	 * Check for DPCD version > 1.1 and enhanced framing support
 	 */
 	if (intel_dp->dpcd[DP_DPCD_REV] >= 0x11 &&
 	    (intel_dp->dpcd[DP_MAX_LANE_COUNT] & DP_ENHANCED_FRAME_CAP)) {
 		intel_dp->link_configuration[1] |= DP_LANE_COUNT_ENHANCED_FRAME_EN;
-		intel_dp->DP |= DP_ENHANCED_FRAMING;
 	}
 
-	/* CPT DP's pipe select is decided in TRANS_DP_CTL */
-	if (intel_crtc->pipe == 1 && !HAS_PCH_CPT(dev))
-		intel_dp->DP |= DP_PIPEB_SELECT;
+	/* Split out the IBX/CPU vs CPT settings */
 
-	if (is_cpu_edp(intel_dp)) {
-		/* don't miss out required setting for eDP */
-		intel_dp->DP |= DP_PLL_ENABLE;
-		if (adjusted_mode->clock < 200000)
-			intel_dp->DP |= DP_PLL_FREQ_160MHZ;
-		else
-			intel_dp->DP |= DP_PLL_FREQ_270MHZ;
+	if (!HAS_PCH_CPT(dev) || is_cpu_edp(intel_dp)) {
+		intel_dp->DP |= intel_dp->color_range;
+
+		if (adjusted_mode->flags & DRM_MODE_FLAG_PHSYNC)
+			intel_dp->DP |= DP_SYNC_HS_HIGH;
+		if (adjusted_mode->flags & DRM_MODE_FLAG_PVSYNC)
+			intel_dp->DP |= DP_SYNC_VS_HIGH;
+		intel_dp->DP |= DP_LINK_TRAIN_OFF;
+
+		if (intel_dp->link_configuration[1] & DP_LANE_COUNT_ENHANCED_FRAME_EN)
+			intel_dp->DP |= DP_ENHANCED_FRAMING;
+
+		/*
+		 * Check for DPCD version > 1.1 and enhanced framing support
+		 */
+		if (intel_dp->dpcd[DP_DPCD_REV] >= 0x11 &&
+		    (intel_dp->dpcd[DP_MAX_LANE_COUNT] & DP_ENHANCED_FRAME_CAP)) {
+			intel_dp->link_configuration[1] |= DP_LANE_COUNT_ENHANCED_FRAME_EN;
+			intel_dp->DP |= DP_ENHANCED_FRAMING;
+		}
+
+		if (intel_crtc->pipe == 1)
+			intel_dp->DP |= DP_PIPEB_SELECT;
+
+		if (is_cpu_edp(intel_dp)) {
+			/* don't miss out required setting for eDP */
+			intel_dp->DP |= DP_PLL_ENABLE;
+			if (adjusted_mode->clock < 200000)
+				intel_dp->DP |= DP_PLL_FREQ_160MHZ;
+			else
+				intel_dp->DP |= DP_PLL_FREQ_270MHZ;
+		}
+	} else {
+		intel_dp->DP |= DP_LINK_TRAIN_OFF_CPT;
 	}
 }
 
@@ -1341,6 +1377,7 @@ static char	*link_train_names[] = {
  * a maximum voltage of 800mV and a maximum pre-emphasis of 6dB
  */
 #define I830_DP_VOLTAGE_MAX	    DP_TRAIN_VOLTAGE_SWING_800
+#define I830_DP_VOLTAGE_MAX_CPT	    DP_TRAIN_VOLTAGE_SWING_1200
 
 static uint8_t
 intel_dp_pre_emphasis_max(uint8_t voltage_swing)
@@ -1378,8 +1415,12 @@ intel_get_adjust_train(struct intel_dp *intel_dp, uint8_t link_status[DP_LINK_ST
 			p = this_p;
 	}
 
-	if (v >= I830_DP_VOLTAGE_MAX)
-		v = I830_DP_VOLTAGE_MAX | DP_TRAIN_MAX_SWING_REACHED;
+	if (HAS_PCH_CPT(dev) && !is_cpu_edp(intel_dp))
+		voltage_max = I830_DP_VOLTAGE_MAX_CPT;
+	else
+		voltage_max = I830_DP_VOLTAGE_MAX;
+	if (v >= voltage_max)
+		v = voltage_max | DP_TRAIN_MAX_SWING_REACHED;
 
 	if (p >= intel_dp_pre_emphasis_max(v))
 		p = intel_dp_pre_emphasis_max(v) | DP_TRAIN_MAX_PRE_EMPHASIS_REACHED;
@@ -1570,7 +1611,8 @@ intel_dp_start_link_train(struct intel_dp *intel_dp)
 		/* Use intel_dp->train_set[0] to set the voltage and pre emphasis values */
 		uint8_t	    link_status[DP_LINK_STATUS_SIZE];
 		uint32_t    signal_levels;
-		if (IS_GEN6(dev) && is_edp(intel_dp)) {
+
+		if (IS_GEN6(dev) && is_cpu_edp(intel_dp)) {
 			signal_levels = intel_gen6_edp_signal_levels(intel_dp->train_set[0]);
 			DP = (DP & ~EDP_LINK_TRAIN_VOL_EMP_MASK_SNB) | signal_levels;
 		} else {
@@ -1650,12 +1692,11 @@ intel_dp_complete_link_train(struct intel_dp *intel_dp)
 			break;
 		}
 
-		if (IS_GEN6(dev) && is_edp(intel_dp)) {
+		if (IS_GEN6(dev) && is_cpu_edp(intel_dp)) {
 			signal_levels = intel_gen6_edp_signal_levels(intel_dp->train_set[0]);
 			DP = (DP & ~EDP_LINK_TRAIN_VOL_EMP_MASK_SNB) | signal_levels;
 		} else {
 			signal_levels = intel_dp_signal_levels(intel_dp->train_set[0]);
-			DRM_DEBUG_KMS("training pattern 1 signal levels %08x\n", signal_levels);
 			DP = (DP & ~(DP_VOLTAGE_MASK|DP_PRE_EMPHASIS_MASK)) | signal_levels;
 		}
 
@@ -1741,8 +1782,12 @@ intel_dp_link_down(struct intel_dp *intel_dp)
 
 	msleep(17);
 
-	if (is_edp(intel_dp))
-		DP |= DP_LINK_TRAIN_OFF;
+	if (is_edp(intel_dp)) {
+		if (HAS_PCH_CPT(dev) && !is_cpu_edp(intel_dp))
+			DP |= DP_LINK_TRAIN_OFF_CPT;
+		else
+			DP |= DP_LINK_TRAIN_OFF;
+	}
 
 	if (!HAS_PCH_CPT(dev) &&
 	    I915_READ(intel_dp->output_reg) & DP_PIPEB_SELECT) {
@@ -2186,7 +2231,8 @@ intel_trans_dp_port_sel(struct drm_crtc *crtc)
 			continue;
 
 		intel_dp = enc_to_intel_dp(encoder);
-		if (intel_dp->base.type == INTEL_OUTPUT_DISPLAYPORT)
+		if (intel_dp->base.type == INTEL_OUTPUT_DISPLAYPORT ||
+		    intel_dp->base.type == INTEL_OUTPUT_EDP)
 			return intel_dp->output_reg;
 	}
 
-- 
1.7.7

