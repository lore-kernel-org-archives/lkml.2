Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab1KQA3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 19:29:50 -0500
Received: from home.keithp.com ([63.227.221.253]:42876 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648Ab1KQA3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 19:29:49 -0500
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH] drm/i915: Hook up Ivybridge eDP
Date: Wed, 16 Nov 2011 16:29:40 -0800
Message-Id: <1321489780-17085-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Ivybridge eDP control register looks like a cross between a
Cougarpoint PCH DP control register and a Sandybridge eDP control
register.

Where things trivially match, share the code. Where there are any
tricky bits, just split things out into two obviously separate code paths.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_reg.h |   18 +++++
 drivers/gpu/drm/i915/intel_dp.c |  151 ++++++++++++++++++++++++++++++---------
 2 files changed, 135 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index b080cc8..43f27ad 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3447,6 +3447,24 @@
 #define  EDP_LINK_TRAIN_800_1200MV_0DB_SNB_B	(0x38<<22)
 #define  EDP_LINK_TRAIN_VOL_EMP_MASK_SNB	(0x3f<<22)
 
+/* IVB */
+#define EDP_LINK_TRAIN_400MV_0DB_IVB		(0x24 <<22)
+#define EDP_LINK_TRAIN_400MV_3_5DB_IVB		(0x2a <<22)
+#define EDP_LINK_TRAIN_400MV_6DB_IVB		(0x2f <<22)
+#define EDP_LINK_TRAIN_600MV_0DB_IVB		(0x30 <<22)
+#define EDP_LINK_TRAIN_600MV_3_5DB_IVB		(0x36 <<22)
+#define EDP_LINK_TRAIN_800MV_0DB_IVB		(0x38 <<22)
+#define EDP_LINK_TRAIN_800MV_3_5DB_IVB		(0x33 <<22)
+
+/* legacy values */
+#define EDP_LINK_TRAIN_500MV_0DB_IVB		(0x00 <<22)
+#define EDP_LINK_TRAIN_1000MV_0DB_IVB		(0x20 <<22)
+#define EDP_LINK_TRAIN_500MV_3_5DB_IVB		(0x02 <<22)
+#define EDP_LINK_TRAIN_1000MV_3_5DB_IVB		(0x22 <<22)
+#define EDP_LINK_TRAIN_1000MV_6DB_IVB		(0x23 <<22)
+
+#define  EDP_LINK_TRAIN_VOL_EMP_MASK_IVB	(0x3f<<22)
+
 #define  FORCEWAKE				0xA18C
 #define  FORCEWAKE_ACK				0x130090
 
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index ec28aeb..f63c6b2 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -361,8 +361,8 @@ intel_dp_aux_ch(struct intel_dp *intel_dp,
 	 * clock divider.
 	 */
 	if (is_cpu_edp(intel_dp)) {
-		if (IS_GEN6(dev))
-			aux_clock_divider = 200; /* SNB eDP input clock at 400Mhz */
+		if (IS_GEN6(dev) || IS_GEN7(dev))
+			aux_clock_divider = 200; /* SNB & IVB eDP input clock at 400Mhz */
 		else
 			aux_clock_divider = 225; /* eDP input clock at 450Mhz */
 	} else if (HAS_PCH_SPLIT(dev))
@@ -816,10 +816,11 @@ intel_dp_mode_set(struct drm_encoder *encoder, struct drm_display_mode *mode,
 	}
 
 	/*
-	 * There are three kinds of DP registers:
+	 * There are four kinds of DP registers:
 	 *
 	 * 	IBX PCH
-	 * 	CPU
+	 * 	SNB CPU
+	 *	IVB CPU
 	 * 	CPT PCH
 	 *
 	 * IBX PCH and CPU are the same for almost everything,
@@ -872,7 +873,26 @@ intel_dp_mode_set(struct drm_encoder *encoder, struct drm_display_mode *mode,
 
 	/* Split out the IBX/CPU vs CPT settings */
 
-	if (!HAS_PCH_CPT(dev) || is_cpu_edp(intel_dp)) {
+	if (is_cpu_edp(intel_dp) && IS_GEN7(dev)) {
+		if (adjusted_mode->flags & DRM_MODE_FLAG_PHSYNC)
+			intel_dp->DP |= DP_SYNC_HS_HIGH;
+		if (adjusted_mode->flags & DRM_MODE_FLAG_PVSYNC)
+			intel_dp->DP |= DP_SYNC_VS_HIGH;
+		intel_dp->DP |= DP_LINK_TRAIN_OFF_CPT;
+
+		if (intel_dp->link_configuration[1] & DP_LANE_COUNT_ENHANCED_FRAME_EN)
+			intel_dp->DP |= DP_ENHANCED_FRAMING;
+
+		intel_dp->DP |= intel_crtc->pipe << 29;
+
+		/* don't miss out required setting for eDP */
+		intel_dp->DP |= DP_PLL_ENABLE;
+		if (adjusted_mode->clock < 200000)
+			intel_dp->DP |= DP_PLL_FREQ_160MHZ;
+		else
+			intel_dp->DP |= DP_PLL_FREQ_270MHZ;
+		
+	} else if (!HAS_PCH_CPT(dev) || is_cpu_edp(intel_dp)) {
 		intel_dp->DP |= intel_dp->color_range;
 
 		if (adjusted_mode->flags & DRM_MODE_FLAG_PHSYNC)
@@ -1374,34 +1394,60 @@ static char	*link_train_names[] = {
  * These are source-specific values; current Intel hardware supports
  * a maximum voltage of 800mV and a maximum pre-emphasis of 6dB
  */
-#define I830_DP_VOLTAGE_MAX	    DP_TRAIN_VOLTAGE_SWING_800
-#define I830_DP_VOLTAGE_MAX_CPT	    DP_TRAIN_VOLTAGE_SWING_1200
 
 static uint8_t
-intel_dp_pre_emphasis_max(uint8_t voltage_swing)
+intel_dp_voltage_max(struct intel_dp *intel_dp)
 {
-	switch (voltage_swing & DP_TRAIN_VOLTAGE_SWING_MASK) {
-	case DP_TRAIN_VOLTAGE_SWING_400:
-		return DP_TRAIN_PRE_EMPHASIS_6;
-	case DP_TRAIN_VOLTAGE_SWING_600:
-		return DP_TRAIN_PRE_EMPHASIS_6;
-	case DP_TRAIN_VOLTAGE_SWING_800:
-		return DP_TRAIN_PRE_EMPHASIS_3_5;
-	case DP_TRAIN_VOLTAGE_SWING_1200:
-	default:
-		return DP_TRAIN_PRE_EMPHASIS_0;
+	struct drm_device *dev = intel_dp->base.base.dev;
+
+	if (IS_GEN7(dev) && is_cpu_edp(intel_dp))
+		return DP_TRAIN_VOLTAGE_SWING_800;
+	else if (HAS_PCH_CPT(dev) && !is_cpu_edp(intel_dp))
+		return DP_TRAIN_VOLTAGE_SWING_1200;
+	else
+		return DP_TRAIN_VOLTAGE_SWING_800;
+}
+
+static uint8_t
+intel_dp_pre_emphasis_max(struct intel_dp *intel_dp, uint8_t voltage_swing)
+{
+	struct drm_device *dev = intel_dp->base.base.dev;
+
+	if (IS_GEN7(dev) && is_cpu_edp(intel_dp)) {
+		switch (voltage_swing & DP_TRAIN_VOLTAGE_SWING_MASK) {
+		case DP_TRAIN_VOLTAGE_SWING_400:
+			return DP_TRAIN_PRE_EMPHASIS_6;
+		case DP_TRAIN_VOLTAGE_SWING_600:
+		case DP_TRAIN_VOLTAGE_SWING_800:
+			return DP_TRAIN_PRE_EMPHASIS_3_5;
+		default:
+			return DP_TRAIN_PRE_EMPHASIS_0;
+		}
+		
+	} else {
+		switch (voltage_swing & DP_TRAIN_VOLTAGE_SWING_MASK) {
+		case DP_TRAIN_VOLTAGE_SWING_400:
+			return DP_TRAIN_PRE_EMPHASIS_6;
+		case DP_TRAIN_VOLTAGE_SWING_600:
+			return DP_TRAIN_PRE_EMPHASIS_6;
+		case DP_TRAIN_VOLTAGE_SWING_800:
+			return DP_TRAIN_PRE_EMPHASIS_3_5;
+		case DP_TRAIN_VOLTAGE_SWING_1200:
+		default:
+			return DP_TRAIN_PRE_EMPHASIS_0;
+		}
 	}
 }
 
 static void
 intel_get_adjust_train(struct intel_dp *intel_dp, uint8_t link_status[DP_LINK_STATUS_SIZE])
 {
-	struct drm_device *dev = intel_dp->base.base.dev;
 	uint8_t v = 0;
 	uint8_t p = 0;
 	int lane;
 	uint8_t	*adjust_request = link_status + (DP_ADJUST_REQUEST_LANE0_1 - DP_LANE0_1_STATUS);
-	int voltage_max;
+	uint8_t voltage_max;
+	uint8_t preemph_max;
 
 	for (lane = 0; lane < intel_dp->lane_count; lane++) {
 		uint8_t this_v = intel_get_adjust_request_voltage(adjust_request, lane);
@@ -1413,15 +1459,13 @@ intel_get_adjust_train(struct intel_dp *intel_dp, uint8_t link_status[DP_LINK_ST
 			p = this_p;
 	}
 
-	if (HAS_PCH_CPT(dev) && !is_cpu_edp(intel_dp))
-		voltage_max = I830_DP_VOLTAGE_MAX_CPT;
-	else
-		voltage_max = I830_DP_VOLTAGE_MAX;
+	voltage_max = intel_dp_voltage_max(intel_dp);
 	if (v >= voltage_max)
 		v = voltage_max | DP_TRAIN_MAX_SWING_REACHED;
 
-	if (p >= intel_dp_pre_emphasis_max(v))
-		p = intel_dp_pre_emphasis_max(v) | DP_TRAIN_MAX_PRE_EMPHASIS_REACHED;
+	preemph_max = intel_dp_pre_emphasis_max(intel_dp, v);
+	if (p >= preemph_max)
+		p = preemph_max | DP_TRAIN_MAX_PRE_EMPHASIS_REACHED;
 
 	for (lane = 0; lane < 4; lane++)
 		intel_dp->train_set[lane] = v | p;
@@ -1493,6 +1537,37 @@ intel_gen6_edp_signal_levels(uint8_t train_set)
 	}
 }
 
+/* Gen7's DP voltage swing and pre-emphasis control */
+static uint32_t
+intel_gen7_edp_signal_levels(uint8_t train_set)
+{
+	int signal_levels = train_set & (DP_TRAIN_VOLTAGE_SWING_MASK |
+					 DP_TRAIN_PRE_EMPHASIS_MASK);
+	switch (signal_levels) {
+	case DP_TRAIN_VOLTAGE_SWING_400 | DP_TRAIN_PRE_EMPHASIS_0:
+		return EDP_LINK_TRAIN_400MV_0DB_IVB;
+	case DP_TRAIN_VOLTAGE_SWING_400 | DP_TRAIN_PRE_EMPHASIS_3_5:
+		return EDP_LINK_TRAIN_400MV_3_5DB_IVB;
+	case DP_TRAIN_VOLTAGE_SWING_400 | DP_TRAIN_PRE_EMPHASIS_6:
+		return EDP_LINK_TRAIN_400MV_6DB_IVB;
+
+	case DP_TRAIN_VOLTAGE_SWING_600 | DP_TRAIN_PRE_EMPHASIS_0:
+		return EDP_LINK_TRAIN_600MV_0DB_IVB;
+	case DP_TRAIN_VOLTAGE_SWING_600 | DP_TRAIN_PRE_EMPHASIS_3_5:
+		return EDP_LINK_TRAIN_600MV_3_5DB_IVB;
+
+	case DP_TRAIN_VOLTAGE_SWING_800 | DP_TRAIN_PRE_EMPHASIS_0:
+		return EDP_LINK_TRAIN_800MV_0DB_IVB;
+	case DP_TRAIN_VOLTAGE_SWING_800 | DP_TRAIN_PRE_EMPHASIS_3_5:
+		return EDP_LINK_TRAIN_800MV_3_5DB_IVB;
+
+	default:
+		DRM_DEBUG_KMS("Unsupported voltage swing/pre-emphasis level:"
+			      "0x%x\n", signal_levels);
+		return EDP_LINK_TRAIN_500MV_0DB_IVB;
+	}
+}
+
 static uint8_t
 intel_get_lane_status(uint8_t link_status[DP_LINK_STATUS_SIZE],
 		      int lane)
@@ -1598,7 +1673,8 @@ intel_dp_start_link_train(struct intel_dp *intel_dp)
 				  DP_LINK_CONFIGURATION_SIZE);
 
 	DP |= DP_PORT_EN;
-	if (HAS_PCH_CPT(dev) && !is_cpu_edp(intel_dp))
+
+	if (HAS_PCH_CPT(dev) && (IS_GEN7(dev) || !is_cpu_edp(intel_dp)))
 		DP &= ~DP_LINK_TRAIN_MASK_CPT;
 	else
 		DP &= ~DP_LINK_TRAIN_MASK;
@@ -1612,7 +1688,11 @@ intel_dp_start_link_train(struct intel_dp *intel_dp)
 		uint8_t	    link_status[DP_LINK_STATUS_SIZE];
 		uint32_t    signal_levels;
 
-		if (IS_GEN6(dev) && is_cpu_edp(intel_dp)) {
+
+		if (IS_GEN7(dev) && is_cpu_edp(intel_dp)) {
+			signal_levels = intel_gen7_edp_signal_levels(intel_dp->train_set[0]);
+			DP = (DP & ~EDP_LINK_TRAIN_VOL_EMP_MASK_IVB) | signal_levels;
+		} else if (IS_GEN6(dev) && is_cpu_edp(intel_dp)) {
 			signal_levels = intel_gen6_edp_signal_levels(intel_dp->train_set[0]);
 			DP = (DP & ~EDP_LINK_TRAIN_VOL_EMP_MASK_SNB) | signal_levels;
 		} else {
@@ -1621,7 +1701,7 @@ intel_dp_start_link_train(struct intel_dp *intel_dp)
 			DP = (DP & ~(DP_VOLTAGE_MASK|DP_PRE_EMPHASIS_MASK)) | signal_levels;
 		}
 
-		if (HAS_PCH_CPT(dev) && !is_cpu_edp(intel_dp))
+		if (HAS_PCH_CPT(dev) && (IS_GEN7(dev) || !is_cpu_edp(intel_dp)))
 			reg = DP | DP_LINK_TRAIN_PAT_1_CPT;
 		else
 			reg = DP | DP_LINK_TRAIN_PAT_1;
@@ -1702,7 +1782,10 @@ intel_dp_complete_link_train(struct intel_dp *intel_dp)
 			break;
 		}
 
-		if (IS_GEN6(dev) && is_cpu_edp(intel_dp)) {
+		if (IS_GEN7(dev) && is_cpu_edp(intel_dp)) {
+			signal_levels = intel_gen7_edp_signal_levels(intel_dp->train_set[0]);
+			DP = (DP & ~EDP_LINK_TRAIN_VOL_EMP_MASK_IVB) | signal_levels;
+		} else if (IS_GEN6(dev) && is_cpu_edp(intel_dp)) {
 			signal_levels = intel_gen6_edp_signal_levels(intel_dp->train_set[0]);
 			DP = (DP & ~EDP_LINK_TRAIN_VOL_EMP_MASK_SNB) | signal_levels;
 		} else {
@@ -1710,7 +1793,7 @@ intel_dp_complete_link_train(struct intel_dp *intel_dp)
 			DP = (DP & ~(DP_VOLTAGE_MASK|DP_PRE_EMPHASIS_MASK)) | signal_levels;
 		}
 
-		if (HAS_PCH_CPT(dev) && !is_cpu_edp(intel_dp))
+		if (HAS_PCH_CPT(dev) && (IS_GEN7(dev) || !is_cpu_edp(intel_dp)))
 			reg = DP | DP_LINK_TRAIN_PAT_2_CPT;
 		else
 			reg = DP | DP_LINK_TRAIN_PAT_2;
@@ -1751,7 +1834,7 @@ intel_dp_complete_link_train(struct intel_dp *intel_dp)
 		++tries;
 	}
 
-	if (HAS_PCH_CPT(dev) && !is_cpu_edp(intel_dp))
+	if (HAS_PCH_CPT(dev) && (IS_GEN7(dev) || !is_cpu_edp(intel_dp)))
 		reg = DP | DP_LINK_TRAIN_OFF_CPT;
 	else
 		reg = DP | DP_LINK_TRAIN_OFF;
@@ -1781,7 +1864,7 @@ intel_dp_link_down(struct intel_dp *intel_dp)
 		udelay(100);
 	}
 
-	if (HAS_PCH_CPT(dev) && !is_cpu_edp(intel_dp)) {
+	if (HAS_PCH_CPT(dev) && (IS_GEN7(dev) || !is_cpu_edp(intel_dp))) {
 		DP &= ~DP_LINK_TRAIN_MASK_CPT;
 		I915_WRITE(intel_dp->output_reg, DP | DP_LINK_TRAIN_PAT_IDLE_CPT);
 	} else {
@@ -1793,7 +1876,7 @@ intel_dp_link_down(struct intel_dp *intel_dp)
 	msleep(17);
 
 	if (is_edp(intel_dp)) {
-		if (HAS_PCH_CPT(dev) && !is_cpu_edp(intel_dp))
+		if (HAS_PCH_CPT(dev) && (IS_GEN7(dev) || !is_cpu_edp(intel_dp)))
 			DP |= DP_LINK_TRAIN_OFF_CPT;
 		else
 			DP |= DP_LINK_TRAIN_OFF;
-- 
1.7.7.2

