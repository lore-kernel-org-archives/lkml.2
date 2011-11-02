Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1KBGVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 02:21:01 -0400
Received: from home.keithp.com ([63.227.221.253]:33655 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264Ab1KBGU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 02:20:56 -0400
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH 4/7] drm/i915: Let panel power sequencing hardware do its job
Date: Tue,  1 Nov 2011 23:20:27 -0700
Message-Id: <1320214830-12696-5-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320214830-12696-1-git-send-email-keithp@keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The panel power sequencing hardware tracks the stages of panel power
sequencing and signals when the panel is completely on or off. Instead
of blindly assuming the panel timings will work, poll the panel power
status register until it shows the correct values.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_reg.h |   17 ++++-
 drivers/gpu/drm/i915/intel_dp.c |  138 +++++++++++++++++++++------------------
 2 files changed, 87 insertions(+), 68 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 5a09416..275d149 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1553,12 +1553,21 @@
  */
 #define   PP_READY		(1 << 30)
 #define   PP_SEQUENCE_NONE	(0 << 28)
-#define   PP_SEQUENCE_ON	(1 << 28)
-#define   PP_SEQUENCE_OFF	(2 << 28)
-#define   PP_SEQUENCE_MASK	0x30000000
+#define   PP_SEQUENCE_POWER_UP	(1 << 28)
+#define   PP_SEQUENCE_POWER_DOWN (2 << 28)
+#define   PP_SEQUENCE_MASK	(3 << 28)
+#define   PP_SEQUENCE_SHIFT	28
 #define   PP_CYCLE_DELAY_ACTIVE	(1 << 27)
-#define   PP_SEQUENCE_STATE_ON_IDLE (1 << 3)
 #define   PP_SEQUENCE_STATE_MASK 0x0000000f
+#define   PP_SEQUENCE_STATE_OFF_IDLE	(0x0 << 0)
+#define   PP_SEQUENCE_STATE_OFF_S0_1	(0x1 << 0)
+#define   PP_SEQUENCE_STATE_OFF_S0_2	(0x2 << 0)
+#define   PP_SEQUENCE_STATE_OFF_S0_3	(0x3 << 0)
+#define   PP_SEQUENCE_STATE_ON_IDLE	(0x8 << 0)
+#define   PP_SEQUENCE_STATE_ON_S1_0	(0x9 << 0)
+#define   PP_SEQUENCE_STATE_ON_S1_2	(0xa << 0)
+#define   PP_SEQUENCE_STATE_ON_S1_3	(0xb << 0)
+#define   PP_SEQUENCE_STATE_RESET	(0xf << 0)
 #define PP_CONTROL	0x61204
 #define   POWER_TARGET_ON	(1 << 0)
 #define PP_ON_DELAYS	0x61208
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 185fae6..d6c6608 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -66,7 +66,6 @@ struct intel_dp {
 	struct drm_display_mode *panel_fixed_mode;  /* for eDP */
 	struct delayed_work panel_vdd_work;
 	bool want_panel_vdd;
-	unsigned long panel_off_jiffies;
 };
 
 /**
@@ -915,32 +914,56 @@ intel_dp_mode_set(struct drm_encoder *encoder, struct drm_display_mode *mode,
 	}
 }
 
-static void ironlake_wait_panel_off(struct intel_dp *intel_dp)
+#define IDLE_ON_MASK		(PP_ON | PP_READY | PP_SEQUENCE_MASK | 0                     | PP_SEQUENCE_STATE_MASK)
+#define IDLE_ON_VALUE   	(PP_ON | PP_READY | PP_SEQUENCE_NONE | 0                     | PP_SEQUENCE_STATE_ON_IDLE)
+
+#define IDLE_OFF_MASK		(PP_ON | 0        | PP_SEQUENCE_MASK | 0                     | PP_SEQUENCE_STATE_MASK)
+#define IDLE_OFF_VALUE		(0     | 0        | PP_SEQUENCE_NONE | 0                     | PP_SEQUENCE_STATE_OFF_IDLE)
+
+#define IDLE_CYCLE_MASK		(PP_ON | 0        | PP_SEQUENCE_MASK | PP_CYCLE_DELAY_ACTIVE | PP_SEQUENCE_STATE_MASK)
+#define IDLE_CYCLE_VALUE	(0     | 0        | PP_SEQUENCE_NONE | 0                     | PP_SEQUENCE_STATE_OFF_IDLE)
+
+static void ironlake_wait_panel_status(struct intel_dp *intel_dp,
+				       u32 mask,
+				       u32 value)
 {
-	unsigned long	off_time;
-	unsigned long	delay;
+	struct drm_device *dev = intel_dp->base.base.dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
 
-	DRM_DEBUG_KMS("Wait for panel power off time\n");
+	DRM_DEBUG_KMS("mask %08x value %08x status %08x control %08x\n",
+		      mask, value,
+		      I915_READ(PCH_PP_STATUS),
+		      I915_READ(PCH_PP_CONTROL));
 
-	if (ironlake_edp_have_panel_power(intel_dp) ||
-	    ironlake_edp_have_panel_vdd(intel_dp))
+	if (_wait_for((I915_READ(PCH_PP_STATUS) & mask) == value,
+		      5000,
+		      10))
 	{
-		DRM_DEBUG_KMS("Panel still on, no delay needed\n");
-		return;
+		DRM_ERROR("Panel status timeout: status %08x control %08x\n",
+			  I915_READ(PCH_PP_STATUS),
+			  I915_READ(PCH_PP_CONTROL));
 	}
+}
 
-	off_time = intel_dp->panel_off_jiffies + msecs_to_jiffies(intel_dp->panel_power_down_delay);
-	if (time_after(jiffies, off_time)) {
-		DRM_DEBUG_KMS("Time already passed");
-		return;
-	}
-	delay = jiffies_to_msecs(off_time - jiffies);
-	if (delay > intel_dp->panel_power_down_delay)
-		delay = intel_dp->panel_power_down_delay;
-	DRM_DEBUG_KMS("Waiting an additional %ld ms\n", delay);
-	msleep(delay);
+static void ironlake_wait_panel_on(struct intel_dp *intel_dp)
+{
+	DRM_DEBUG_KMS("Wait for panel power on\n");
+	ironlake_wait_panel_status(intel_dp, IDLE_ON_MASK, IDLE_ON_VALUE);
 }
 
+static void ironlake_wait_panel_off(struct intel_dp *intel_dp)
+{
+	DRM_DEBUG_KMS("Wait for panel power off time\n");
+	ironlake_wait_panel_status(intel_dp, IDLE_OFF_MASK, IDLE_OFF_VALUE);
+}
+
+static void ironlake_wait_panel_power_cycle(struct intel_dp *intel_dp)
+{
+	DRM_DEBUG_KMS("Wait for panel power cycle\n");
+	ironlake_wait_panel_status(intel_dp, IDLE_CYCLE_MASK, IDLE_CYCLE_VALUE);
+}
+
+
 /* Read the current pp_control value, unlocking the register if it
  * is locked
  */
@@ -968,12 +991,15 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 	     "eDP VDD already requested on\n");
 
 	intel_dp->want_panel_vdd = true;
+
 	if (ironlake_edp_have_panel_vdd(intel_dp)) {
 		DRM_DEBUG_KMS("eDP VDD already on\n");
 		return;
 	}
 
-	ironlake_wait_panel_off(intel_dp);
+	if (!ironlake_edp_have_panel_power(intel_dp))
+		ironlake_wait_panel_power_cycle(intel_dp);
+
 	pp = ironlake_get_pp_control(dev_priv);
 	pp |= EDP_FORCE_VDD;
 	I915_WRITE(PCH_PP_CONTROL, pp);
@@ -1005,7 +1031,8 @@ static void ironlake_panel_vdd_off_sync(struct intel_dp *intel_dp)
 		/* Make sure sequencer is idle before allowing subsequent activity */
 		DRM_DEBUG_KMS("PCH_PP_STATUS: 0x%08x PCH_PP_CONTROL: 0x%08x\n",
 			      I915_READ(PCH_PP_STATUS), I915_READ(PCH_PP_CONTROL));
-		intel_dp->panel_off_jiffies = jiffies;
+
+		msleep(intel_dp->panel_power_down_delay);
 	}
 }
 
@@ -1043,21 +1070,25 @@ static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp, bool sync)
 	}
 }
 
-/* Returns true if the panel was already on when called */
 static void ironlake_edp_panel_on(struct intel_dp *intel_dp)
 {
 	struct drm_device *dev = intel_dp->base.base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 pp, idle_on_mask = PP_ON | PP_SEQUENCE_STATE_ON_IDLE;
+	u32 pp;
 
 	if (!is_edp(intel_dp))
 		return;
-	if (ironlake_edp_have_panel_power(intel_dp))
+
+	DRM_DEBUG_KMS("Turn eDP power on\n");
+
+	if (ironlake_edp_have_panel_power(intel_dp)) {
+		DRM_DEBUG_KMS("eDP power already on\n");
 		return;
+	}
 
-	ironlake_wait_panel_off(intel_dp);
-	pp = ironlake_get_pp_control(dev_priv);
+	ironlake_wait_panel_power_cycle(intel_dp);
 
+	pp = ironlake_get_pp_control(dev_priv);
 	if (IS_GEN5(dev)) {
 		/* ILK workaround: disable reset around power sequence */
 		pp &= ~PANEL_POWER_RESET;
@@ -1066,13 +1097,13 @@ static void ironlake_edp_panel_on(struct intel_dp *intel_dp)
 	}
 
 	pp |= POWER_TARGET_ON;
+	if (!IS_GEN5(dev))
+		pp |= PANEL_POWER_RESET;
+
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
 
-	if (wait_for((I915_READ(PCH_PP_STATUS) & idle_on_mask) == idle_on_mask,
-		     5000))
-		DRM_ERROR("panel on wait timed out: 0x%08x\n",
-			  I915_READ(PCH_PP_STATUS));
+	ironlake_wait_panel_on(intel_dp);
 
 	if (IS_GEN5(dev)) {
 		pp |= PANEL_POWER_RESET; /* restore panel reset bit */
@@ -1081,44 +1112,25 @@ static void ironlake_edp_panel_on(struct intel_dp *intel_dp)
 	}
 }
 
-static void ironlake_edp_panel_off(struct drm_encoder *encoder)
+static void ironlake_edp_panel_off(struct intel_dp *intel_dp)
 {
-	struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
-	struct drm_device *dev = encoder->dev;
+	struct drm_device *dev = intel_dp->base.base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 pp, idle_off_mask = PP_ON | PP_SEQUENCE_MASK |
-		PP_CYCLE_DELAY_ACTIVE | PP_SEQUENCE_STATE_MASK;
+	u32 pp;
 
 	if (!is_edp(intel_dp))
 		return;
-	pp = ironlake_get_pp_control(dev_priv);
 
-	if (IS_GEN5(dev)) {
-		/* ILK workaround: disable reset around power sequence */
-		pp &= ~PANEL_POWER_RESET;
-		I915_WRITE(PCH_PP_CONTROL, pp);
-		POSTING_READ(PCH_PP_CONTROL);
-	}
-
-	intel_dp->panel_off_jiffies = jiffies;
+	DRM_DEBUG_KMS("Turn eDP power off\n");
 
-	if (IS_GEN5(dev)) {
-		pp &= ~POWER_TARGET_ON;
-		I915_WRITE(PCH_PP_CONTROL, pp);
-		POSTING_READ(PCH_PP_CONTROL);
-		pp &= ~POWER_TARGET_ON;
-		I915_WRITE(PCH_PP_CONTROL, pp);
-		POSTING_READ(PCH_PP_CONTROL);
-		msleep(intel_dp->panel_power_cycle_delay);
+	WARN(intel_dp->want_panel_vdd, "Cannot turn power off while VDD is on\n");
 
-		if (wait_for((I915_READ(PCH_PP_STATUS) & idle_off_mask) == 0, 5000))
-			DRM_ERROR("panel off wait timed out: 0x%08x\n",
-				  I915_READ(PCH_PP_STATUS));
+	pp = ironlake_get_pp_control(dev_priv);
+	pp &= ~(POWER_TARGET_ON | EDP_FORCE_VDD | PANEL_POWER_RESET | EDP_BLC_ENABLE);
+	I915_WRITE(PCH_PP_CONTROL, pp);
+	POSTING_READ(PCH_PP_CONTROL);
 
-		pp |= PANEL_POWER_RESET; /* restore panel reset bit */
-		I915_WRITE(PCH_PP_CONTROL, pp);
-		POSTING_READ(PCH_PP_CONTROL);
-	}
+	ironlake_wait_panel_off(intel_dp);
 }
 
 static void ironlake_edp_backlight_on(struct intel_dp *intel_dp)
@@ -1232,7 +1244,7 @@ static void intel_dp_prepare(struct drm_encoder *encoder)
 	 */
 	ironlake_edp_backlight_off(intel_dp);
 	intel_dp_link_down(intel_dp);
-	ironlake_edp_panel_off(encoder);
+	ironlake_edp_panel_off(intel_dp);
 }
 
 static void intel_dp_commit(struct drm_encoder *encoder)
@@ -1246,7 +1258,6 @@ static void intel_dp_commit(struct drm_encoder *encoder)
 	intel_dp_start_link_train(intel_dp);
 	ironlake_edp_panel_on(intel_dp);
 	ironlake_edp_panel_vdd_off(intel_dp, true);
-
 	intel_dp_complete_link_train(intel_dp);
 	ironlake_edp_backlight_on(intel_dp);
 
@@ -1270,7 +1281,7 @@ intel_dp_dpms(struct drm_encoder *encoder, int mode)
 			ironlake_edp_backlight_off(intel_dp);
 		intel_dp_sink_dpms(intel_dp, mode);
 		intel_dp_link_down(intel_dp);
-		ironlake_edp_panel_off(encoder);
+		ironlake_edp_panel_off(intel_dp);
 		if (is_edp(intel_dp) && !is_pch_edp(intel_dp))
 			ironlake_edp_pll_off(encoder);
 		ironlake_edp_panel_vdd_off(intel_dp, false);
@@ -2407,11 +2418,10 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 		DRM_DEBUG_KMS("backlight on delay %d, off delay %d\n",
 			      intel_dp->backlight_on_delay, intel_dp->backlight_off_delay);
 
-		intel_dp->panel_off_jiffies = jiffies - intel_dp->panel_power_down_delay;
-
 		ironlake_edp_panel_vdd_on(intel_dp);
 		ret = intel_dp_get_dpcd(intel_dp);
 		ironlake_edp_panel_vdd_off(intel_dp, false);
+
 		if (ret) {
 			if (intel_dp->dpcd[DP_DPCD_REV] >= 0x11)
 				dev_priv->no_aux_handshake =
-- 
1.7.7

