Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab1I3BLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:11:19 -0400
Received: from home.keithp.com ([63.227.221.253]:49899 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756597Ab1I3BKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:10:33 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 14/21] drm/i915: Correct eDP panel power sequencing delay computations
Date: Thu, 29 Sep 2011 18:09:46 -0700
Message-Id: <1317344993-24945-15-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317344993-24945-1-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store the panel power sequencing delays in the dp private structure,
rather than the global device structure. Who knows, maybe we'll get
more than one eDP device in the future.

Look at both the current hardware register settings and the VBT
specified panel power sequencing timings. Use the maximum of the two
delays, to make sure things work reliably. If there is no VBT data,
then those values will be initialized to zero, so we'll just use the
values as programmed in the hardware.

This patch computes power-up and power-down delays, rather than using
portions of the appropriate delay values as found in the hardware. The
eDP specified delay between raising VCC and communicating over the aux
channel includes both the power rise time (T1) and the aux channel
communication delay (T3). The eDP specified delay between powering
down the device and powering it back up includes both the power fall
time (T11) and the device idle time (T12).

>From the hardware, I'm taking the T3 value from the PP_OFF_DELAYS
Power_Down_delay value, which is actually documented to be the 'T3
time sequence' value used 'during power up'. There aren't separate T1
and T2 values, but there is a combined T1+T2 value in the PP_ON_DELAYS
register, so I use that instead.

VBT doesn't provide any values for T1 or T2, so we'll always just use
the hardware value for that.

The panel power up delay is thus T1 + T2 + T3, which should be
sufficient in all cases.

The panel power down delay is T1 + T2 + T12, using T1+T2 as a proxy
for T11, which isn't available anywhere.

On the macbook air I'm testing with, this yields a power-up delay of
over 200ms and a power-down delay of over 600ms. It all works now, but
we're frobbing these power controls several times during mode setting,
making the whole process take an awfully long time.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_drv.h |    1 -
 drivers/gpu/drm/i915/intel_dp.c |   59 ++++++++++++++++++++++++++++----------
 2 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 7916bd9..bcdf58b 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -672,7 +672,6 @@ typedef struct drm_i915_private {
 	unsigned int lvds_border_bits;
 	/* Panel fitter placement and size for Ironlake+ */
 	u32 pch_pf_pos, pch_pf_size;
-	int panel_t3, panel_t12;
 
 	struct drm_crtc *plane_to_crtc_mapping[2];
 	struct drm_crtc *pipe_to_crtc_mapping[2];
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index fbc19e4..7ebbdff 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -59,6 +59,8 @@ struct intel_dp {
 	bool is_pch_edp;
 	uint8_t	train_set[4];
 	uint8_t link_status[DP_LINK_STATUS_SIZE];
+	int panel_power_up_delay;
+	int panel_power_down_delay;
 };
 
 /**
@@ -838,7 +840,7 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 {
 	struct drm_device *dev = intel_dp->base.base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 pp;
+	u32 pp, pp_status;
 
 	if (!is_edp(intel_dp))
 		return;
@@ -847,10 +849,7 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 	 * If the panel wasn't on, make sure there's not a currently
 	 * active PP sequence before enabling AUX VDD.
 	 */
-	if (!(I915_READ(PCH_PP_STATUS) & PP_ON)) {
-		DRM_DEBUG_KMS("eDP VDD was not on\n");
-		msleep(dev_priv->panel_t3);
-	}
+	pp_status = I915_READ(PCH_PP_STATUS);
 
 	pp = I915_READ(PCH_PP_CONTROL);
 	pp &= ~PANEL_UNLOCK_MASK;
@@ -860,7 +859,10 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 	POSTING_READ(PCH_PP_CONTROL);
 	DRM_DEBUG_KMS("PCH_PP_STATUS: 0x%08x PCH_PP_CONTROL: 0x%08x\n",
 		      I915_READ(PCH_PP_STATUS), I915_READ(PCH_PP_CONTROL));
-	msleep(1000);
+	if (!(pp_status & PP_ON)) {
+		msleep(intel_dp->panel_power_up_delay);
+		DRM_DEBUG_KMS("eDP VDD was not on\n");
+	}
 }
 
 static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp)
@@ -880,10 +882,9 @@ static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp)
 	POSTING_READ(PCH_PP_CONTROL);
 
 	/* Make sure sequencer is idle before allowing subsequent activity */
-	msleep(dev_priv->panel_t12);
 	DRM_DEBUG_KMS("PCH_PP_STATUS: 0x%08x PCH_PP_CONTROL: 0x%08x\n",
 		      I915_READ(PCH_PP_STATUS), I915_READ(PCH_PP_CONTROL));
-	msleep(1000);
+	msleep(intel_dp->panel_power_down_delay);
 }
 
 /* Returns true if the panel was already on when called */
@@ -921,8 +922,10 @@ static bool ironlake_edp_panel_on (struct intel_dp *intel_dp)
 	return false;
 }
 
-static void ironlake_edp_panel_off (struct drm_device *dev)
+static void ironlake_edp_panel_off(struct drm_encoder *encoder)
 {
+	struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
+	struct drm_device *dev = encoder->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 pp, idle_off_mask = PP_ON | PP_SEQUENCE_MASK |
 		PP_CYCLE_DELAY_ACTIVE | PP_SEQUENCE_STATE_MASK;
@@ -939,6 +942,7 @@ static void ironlake_edp_panel_off (struct drm_device *dev)
 	pp &= ~POWER_TARGET_ON;
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
+	msleep(intel_dp->panel_power_down_delay);
 
 	if (wait_for((I915_READ(PCH_PP_STATUS) & idle_off_mask) == 0, 5000))
 		DRM_ERROR("panel off wait timed out: 0x%08x\n",
@@ -1044,7 +1048,7 @@ static void intel_dp_prepare(struct drm_encoder *encoder)
 
 	if (is_edp(intel_dp)) {
 		ironlake_edp_backlight_off(dev);
-		ironlake_edp_panel_off(dev);
+		ironlake_edp_panel_off(encoder);
 		if (!is_pch_edp(intel_dp))
 			ironlake_edp_pll_on(encoder);
 		else
@@ -1088,7 +1092,7 @@ intel_dp_dpms(struct drm_encoder *encoder, int mode)
 		intel_dp_sink_dpms(intel_dp, mode);
 		intel_dp_link_down(intel_dp);
 		if (is_edp(intel_dp))
-			ironlake_edp_panel_off(dev);
+			ironlake_edp_panel_off(encoder);
 		if (is_edp(intel_dp) && !is_pch_edp(intel_dp))
 			ironlake_edp_pll_off(encoder);
 	} else {
@@ -2117,16 +2121,39 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 	/* Cache some DPCD data in the eDP case */
 	if (is_edp(intel_dp)) {
 		bool ret;
-		u32 pp_on, pp_div;
+		u32 pp_on, pp_off, pp_div;
+		int current_t1_2;
+		int current_t3;
+		int current_t12;
+		int vbt_t3;
+		int vbt_t12;
 
 		pp_on = I915_READ(PCH_PP_ON_DELAYS);
+		pp_off = I915_READ(PCH_PP_OFF_DELAYS);
 		pp_div = I915_READ(PCH_PP_DIVISOR);
 
 		/* Get T3 & T12 values (note: VESA not bspec terminology) */
-		dev_priv->panel_t3 = (pp_on & 0x1fff0000) >> 16;
-		dev_priv->panel_t3 /= 10; /* t3 in 100us units */
-		dev_priv->panel_t12 = pp_div & 0xf;
-		dev_priv->panel_t12 *= 100; /* t12 in 100ms units */
+
+		current_t1_2 = (pp_on & 0x1fff0000) >> 16;
+		current_t1_2 = (current_t1_2 + 9) / 10; /* t1+t2 in 100us units */
+
+		current_t3 = (pp_off & 0x1fff0000) >> 16;
+		current_t3 = (current_t3 + 9) / 10;	/* t3 in 100us units */
+
+		current_t12 = pp_div & 0xf;
+		current_t12 *= 100; /* t12 in 100ms units */
+
+		vbt_t3 = (dev_priv->edp.pps.t3 + 9) / 10;
+		vbt_t12 = (dev_priv->edp.pps.t12 + 9) / 10;
+		DRM_DEBUG_KMS("current t3 %d t12 %d\n",
+			      current_t3, current_t12);
+		DRM_DEBUG_KMS("VBT t3 %d t12 %d\n",
+			      vbt_t3, vbt_t12);
+
+		intel_dp->panel_power_up_delay = current_t1_2 + max(current_t3, vbt_t3);
+		intel_dp->panel_power_down_delay = current_t1_2 + max(current_t12, vbt_t12);
+		DRM_DEBUG_KMS("panel power up delay %d, power down delay %d\n",
+			      intel_dp->panel_power_up_delay, intel_dp->panel_power_down_delay);
 
 		ironlake_edp_panel_vdd_on(intel_dp);
 		ret = intel_dp_get_dpcd(intel_dp);
-- 
1.7.6.3

