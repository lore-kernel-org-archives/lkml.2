Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab1KBGVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 02:21:08 -0400
Received: from home.keithp.com ([63.227.221.253]:33670 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748Ab1KBGVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 02:21:00 -0400
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH 2/7] drm/i915: Remove link_status field from intel_dp structure
Date: Tue,  1 Nov 2011 23:20:25 -0700
Message-Id: <1320214830-12696-3-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320214830-12696-1-git-send-email-keithp@keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No persistent data was ever stored here, so link_status is instead
allocated on the stack as needed.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   65 +++++++++++++++++++++-----------------
 1 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index efe5f9e..2c0c482 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -58,7 +58,6 @@ struct intel_dp {
 	struct i2c_algo_dp_aux_data algo;
 	bool is_pch_edp;
 	uint8_t	train_set[4];
-	uint8_t link_status[DP_LINK_STATUS_SIZE];
 	int panel_power_up_delay;
 	int panel_power_down_delay;
 	int panel_power_cycle_delay;
@@ -1285,11 +1284,11 @@ intel_dp_aux_native_read_retry(struct intel_dp *intel_dp, uint16_t address,
  * link status information
  */
 static bool
-intel_dp_get_link_status(struct intel_dp *intel_dp)
+intel_dp_get_link_status(struct intel_dp *intel_dp, uint8_t link_status[DP_LINK_STATUS_SIZE])
 {
 	return intel_dp_aux_native_read_retry(intel_dp,
 					      DP_LANE0_1_STATUS,
-					      intel_dp->link_status,
+					      link_status,
 					      DP_LINK_STATUS_SIZE);
 }
 
@@ -1301,27 +1300,25 @@ intel_dp_link_status(uint8_t link_status[DP_LINK_STATUS_SIZE],
 }
 
 static uint8_t
-intel_get_adjust_request_voltage(uint8_t link_status[DP_LINK_STATUS_SIZE],
+intel_get_adjust_request_voltage(uint8_t adjust_request[2],
 				 int lane)
 {
-	int	    i = DP_ADJUST_REQUEST_LANE0_1 + (lane >> 1);
 	int	    s = ((lane & 1) ?
 			 DP_ADJUST_VOLTAGE_SWING_LANE1_SHIFT :
 			 DP_ADJUST_VOLTAGE_SWING_LANE0_SHIFT);
-	uint8_t l = intel_dp_link_status(link_status, i);
+	uint8_t l = adjust_request[lane>>1];
 
 	return ((l >> s) & 3) << DP_TRAIN_VOLTAGE_SWING_SHIFT;
 }
 
 static uint8_t
-intel_get_adjust_request_pre_emphasis(uint8_t link_status[DP_LINK_STATUS_SIZE],
+intel_get_adjust_request_pre_emphasis(uint8_t adjust_request[2],
 				      int lane)
 {
-	int	    i = DP_ADJUST_REQUEST_LANE0_1 + (lane >> 1);
 	int	    s = ((lane & 1) ?
 			 DP_ADJUST_PRE_EMPHASIS_LANE1_SHIFT :
 			 DP_ADJUST_PRE_EMPHASIS_LANE0_SHIFT);
-	uint8_t l = intel_dp_link_status(link_status, i);
+	uint8_t l = adjust_request[lane>>1];
 
 	return ((l >> s) & 3) << DP_TRAIN_PRE_EMPHASIS_SHIFT;
 }
@@ -1362,15 +1359,18 @@ intel_dp_pre_emphasis_max(uint8_t voltage_swing)
 }
 
 static void
-intel_get_adjust_train(struct intel_dp *intel_dp)
+intel_get_adjust_train(struct intel_dp *intel_dp, uint8_t link_status[DP_LINK_STATUS_SIZE])
 {
+	struct drm_device *dev = intel_dp->base.base.dev;
 	uint8_t v = 0;
 	uint8_t p = 0;
 	int lane;
+	uint8_t	*adjust_request = link_status + (DP_ADJUST_REQUEST_LANE0_1 - DP_LANE0_1_STATUS);
+	int voltage_max;
 
 	for (lane = 0; lane < intel_dp->lane_count; lane++) {
-		uint8_t this_v = intel_get_adjust_request_voltage(intel_dp->link_status, lane);
-		uint8_t this_p = intel_get_adjust_request_pre_emphasis(intel_dp->link_status, lane);
+		uint8_t this_v = intel_get_adjust_request_voltage(adjust_request, lane);
+		uint8_t this_p = intel_get_adjust_request_pre_emphasis(adjust_request, lane);
 
 		if (this_v > v)
 			v = this_v;
@@ -1389,7 +1389,7 @@ intel_get_adjust_train(struct intel_dp *intel_dp)
 }
 
 static uint32_t
-intel_dp_signal_levels(uint8_t train_set, int lane_count)
+intel_dp_signal_levels(uint8_t train_set)
 {
 	uint32_t	signal_levels = 0;
 
@@ -1458,9 +1458,8 @@ static uint8_t
 intel_get_lane_status(uint8_t link_status[DP_LINK_STATUS_SIZE],
 		      int lane)
 {
-	int i = DP_LANE0_1_STATUS + (lane >> 1);
 	int s = (lane & 1) * 4;
-	uint8_t l = intel_dp_link_status(link_status, i);
+	uint8_t l = link_status[lane>>1];
 
 	return (l >> s) & 0xf;
 }
@@ -1485,18 +1484,18 @@ intel_clock_recovery_ok(uint8_t link_status[DP_LINK_STATUS_SIZE], int lane_count
 			 DP_LANE_CHANNEL_EQ_DONE|\
 			 DP_LANE_SYMBOL_LOCKED)
 static bool
-intel_channel_eq_ok(struct intel_dp *intel_dp)
+intel_channel_eq_ok(struct intel_dp *intel_dp, uint8_t link_status[DP_LINK_STATUS_SIZE])
 {
 	uint8_t lane_align;
 	uint8_t lane_status;
 	int lane;
 
-	lane_align = intel_dp_link_status(intel_dp->link_status,
+	lane_align = intel_dp_link_status(link_status,
 					  DP_LANE_ALIGN_STATUS_UPDATED);
 	if ((lane_align & DP_INTERLANE_ALIGN_DONE) == 0)
 		return false;
 	for (lane = 0; lane < intel_dp->lane_count; lane++) {
-		lane_status = intel_get_lane_status(intel_dp->link_status, lane);
+		lane_status = intel_get_lane_status(link_status, lane);
 		if ((lane_status & CHANNEL_EQ_BITS) != CHANNEL_EQ_BITS)
 			return false;
 	}
@@ -1569,12 +1568,14 @@ intel_dp_start_link_train(struct intel_dp *intel_dp)
 	clock_recovery = false;
 	for (;;) {
 		/* Use intel_dp->train_set[0] to set the voltage and pre emphasis values */
+		uint8_t	    link_status[DP_LINK_STATUS_SIZE];
 		uint32_t    signal_levels;
 		if (IS_GEN6(dev) && is_edp(intel_dp)) {
 			signal_levels = intel_gen6_edp_signal_levels(intel_dp->train_set[0]);
 			DP = (DP & ~EDP_LINK_TRAIN_VOL_EMP_MASK_SNB) | signal_levels;
 		} else {
-			signal_levels = intel_dp_signal_levels(intel_dp->train_set[0], intel_dp->lane_count);
+			signal_levels = intel_dp_signal_levels(intel_dp->train_set[0]);
+			DRM_DEBUG_KMS("training pattern 1 signal levels %08x\n", signal_levels);
 			DP = (DP & ~(DP_VOLTAGE_MASK|DP_PRE_EMPHASIS_MASK)) | signal_levels;
 		}
 
@@ -1590,10 +1591,13 @@ intel_dp_start_link_train(struct intel_dp *intel_dp)
 		/* Set training pattern 1 */
 
 		udelay(100);
-		if (!intel_dp_get_link_status(intel_dp))
+		if (!intel_dp_get_link_status(intel_dp, link_status)) {
+			DRM_ERROR("failed to get link status\n");
 			break;
+		}
 
-		if (intel_clock_recovery_ok(intel_dp->link_status, intel_dp->lane_count)) {
+		if (intel_clock_recovery_ok(link_status, intel_dp->lane_count)) {
+			DRM_DEBUG_KMS("clock recovery OK\n");
 			clock_recovery = true;
 			break;
 		}
@@ -1615,7 +1619,7 @@ intel_dp_start_link_train(struct intel_dp *intel_dp)
 		voltage = intel_dp->train_set[0] & DP_TRAIN_VOLTAGE_SWING_MASK;
 
 		/* Compute new intel_dp->train_set as requested by target */
-		intel_get_adjust_train(intel_dp);
+		intel_get_adjust_train(intel_dp, link_status);
 	}
 
 	intel_dp->DP = DP;
@@ -1638,6 +1642,7 @@ intel_dp_complete_link_train(struct intel_dp *intel_dp)
 	for (;;) {
 		/* Use intel_dp->train_set[0] to set the voltage and pre emphasis values */
 		uint32_t    signal_levels;
+		uint8_t	    link_status[DP_LINK_STATUS_SIZE];
 
 		if (cr_tries > 5) {
 			DRM_ERROR("failed to train DP, aborting\n");
@@ -1649,7 +1654,8 @@ intel_dp_complete_link_train(struct intel_dp *intel_dp)
 			signal_levels = intel_gen6_edp_signal_levels(intel_dp->train_set[0]);
 			DP = (DP & ~EDP_LINK_TRAIN_VOL_EMP_MASK_SNB) | signal_levels;
 		} else {
-			signal_levels = intel_dp_signal_levels(intel_dp->train_set[0], intel_dp->lane_count);
+			signal_levels = intel_dp_signal_levels(intel_dp->train_set[0]);
+			DRM_DEBUG_KMS("training pattern 1 signal levels %08x\n", signal_levels);
 			DP = (DP & ~(DP_VOLTAGE_MASK|DP_PRE_EMPHASIS_MASK)) | signal_levels;
 		}
 
@@ -1665,17 +1671,17 @@ intel_dp_complete_link_train(struct intel_dp *intel_dp)
 			break;
 
 		udelay(400);
-		if (!intel_dp_get_link_status(intel_dp))
+		if (!intel_dp_get_link_status(intel_dp, link_status))
 			break;
 
 		/* Make sure clock is still ok */
-		if (!intel_clock_recovery_ok(intel_dp->link_status, intel_dp->lane_count)) {
+		if (!intel_clock_recovery_ok(link_status, intel_dp->lane_count)) {
 			intel_dp_start_link_train(intel_dp);
 			cr_tries++;
 			continue;
 		}
 
-		if (intel_channel_eq_ok(intel_dp)) {
+		if (intel_channel_eq_ok(intel_dp, link_status)) {
 			channel_eq = true;
 			break;
 		}
@@ -1690,7 +1696,7 @@ intel_dp_complete_link_train(struct intel_dp *intel_dp)
 		}
 
 		/* Compute new intel_dp->train_set as requested by target */
-		intel_get_adjust_train(intel_dp);
+		intel_get_adjust_train(intel_dp, link_status);
 		++tries;
 	}
 
@@ -1822,6 +1828,7 @@ static void
 intel_dp_check_link_status(struct intel_dp *intel_dp)
 {
 	u8 sink_irq_vector;
+	u8 link_status[DP_LINK_STATUS_SIZE];
 
 	if (intel_dp->dpms_mode != DRM_MODE_DPMS_ON)
 		return;
@@ -1830,7 +1837,7 @@ intel_dp_check_link_status(struct intel_dp *intel_dp)
 		return;
 
 	/* Try to read receiver status if the link appears to be up */
-	if (!intel_dp_get_link_status(intel_dp)) {
+	if (!intel_dp_get_link_status(intel_dp, link_status)) {
 		intel_dp_link_down(intel_dp);
 		return;
 	}
@@ -1855,7 +1862,7 @@ intel_dp_check_link_status(struct intel_dp *intel_dp)
 			DRM_DEBUG_DRIVER("CP or sink specific irq unhandled\n");
 	}
 
-	if (!intel_channel_eq_ok(intel_dp)) {
+	if (!intel_channel_eq_ok(intel_dp, link_status)) {
 		DRM_DEBUG_KMS("%s: channel EQ not ok, retraining\n",
 			      drm_get_encoder_name(&intel_dp->base.base));
 		intel_dp_start_link_train(intel_dp);
-- 
1.7.7

