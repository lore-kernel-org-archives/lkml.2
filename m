Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab1ISWWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:22:46 -0400
Received: from home.keithp.com ([63.227.221.253]:41915 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932855Ab1ISWWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:22:32 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 9/9] drm/i915: Disable eDP VDD in a delayed work proc instead of synchronously
Date: Mon, 19 Sep 2011 15:22:03 -0700
Message-Id: <1316470923-27832-10-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1316470923-27832-1-git-send-email-keithp@keithp.com>
References: <1316470923-27832-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no good reason to turn off the eDP force VDD bit synchronously
while probing devices; that just sticks a huge delay into all mode
setting paths. Instead, queue a delayed work proc to disable the VDD
force bit and then remember when that fires to ensure that the
appropriate delay is respected before trying to turn it back on.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   93 +++++++++++++++++++++++++++++++++-----
 1 files changed, 80 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 5bc30f9..8130e82 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -62,6 +62,9 @@ struct intel_dp {
 	int panel_power_up_delay;
 	int panel_power_down_delay;
 	struct drm_display_mode *panel_fixed_mode;  /* for eDP */
+	struct delayed_work panel_vdd_work;
+	bool panel_vdd_force;
+	unsigned long panel_off_jiffies;
 };
 
 /**
@@ -834,6 +837,23 @@ intel_dp_mode_set(struct drm_encoder *encoder, struct drm_display_mode *mode,
 	}
 }
 
+static void ironlake_wait_panel_off(struct intel_dp *intel_dp)
+{
+	unsigned long	off_time;
+	unsigned long	delay;
+	DRM_DEBUG_KMS("Wait for panel power off time\n");
+	off_time = intel_dp->panel_off_jiffies + msecs_to_jiffies(intel_dp->panel_power_down_delay);
+	if (time_after(jiffies, off_time)) {
+		DRM_DEBUG_KMS("Time already passed");
+		return;
+	}
+	delay = jiffies_to_msecs(off_time - jiffies);
+	if (delay > intel_dp->panel_power_down_delay)
+		delay = intel_dp->panel_power_down_delay;
+	DRM_DEBUG_KMS("Waiting an additional %ld ms\n", delay);
+	msleep(delay);
+}
+
 static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 {
 	struct drm_device *dev = intel_dp->base.base.dev;
@@ -843,13 +863,18 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 	if (!is_edp(intel_dp))
 		return;
 	DRM_DEBUG_KMS("Turn eDP VDD on\n");
-	/*
-	 * If the panel wasn't on, make sure there's not a currently
-	 * active PP sequence before enabling AUX VDD.
-	 */
-	pp_status = I915_READ(PCH_PP_STATUS);
 
+	WARN(intel_dp->panel_vdd_force,
+	     "eDP VDD already forced on\n");
+
+	intel_dp->panel_vdd_force = true;
 	pp = I915_READ(PCH_PP_CONTROL);
+	if (pp & EDP_FORCE_VDD) {
+		DRM_DEBUG_KMS("eDP VDD already on\n");
+		return;
+	}
+
+	ironlake_wait_panel_off(intel_dp);
 	pp &= ~PANEL_UNLOCK_MASK;
 	pp |= PANEL_UNLOCK_REGS;
 	pp |= EDP_FORCE_VDD;
@@ -857,21 +882,23 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 	POSTING_READ(PCH_PP_CONTROL);
 	DRM_DEBUG_KMS("PCH_PP_STATUS: 0x%08x PCH_PP_CONTROL: 0x%08x\n",
 		      I915_READ(PCH_PP_STATUS), I915_READ(PCH_PP_CONTROL));
+
+	/*
+	 * If the panel wasn't on, delay before accessing aux channel
+	 */
+	pp_status = I915_READ(PCH_PP_STATUS);
 	if (!(pp_status & PP_ON)) {
+		DRM_DEBUG_KMS("eDP was not running\n");
 		msleep(intel_dp->panel_power_up_delay);
-		DRM_DEBUG_KMS("eDP VDD was not on\n");
 	}
 }
 
-static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp)
+static void ironlake_panel_vdd_delayed_off(struct intel_dp *intel_dp)
 {
 	struct drm_device *dev = intel_dp->base.base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 pp;
 
-	if (!is_edp(intel_dp))
-		return;
-	DRM_DEBUG_KMS("Turn eDP VDD off\n");
 	pp = I915_READ(PCH_PP_CONTROL);
 	pp &= ~PANEL_UNLOCK_MASK;
 	pp |= PANEL_UNLOCK_REGS;
@@ -882,7 +909,37 @@ static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp)
 	/* Make sure sequencer is idle before allowing subsequent activity */
 	DRM_DEBUG_KMS("PCH_PP_STATUS: 0x%08x PCH_PP_CONTROL: 0x%08x\n",
 		      I915_READ(PCH_PP_STATUS), I915_READ(PCH_PP_CONTROL));
-	msleep(intel_dp->panel_power_down_delay);
+	intel_dp->panel_off_jiffies = jiffies;
+}
+
+static void ironlake_panel_vdd_work(struct work_struct *__work)
+{
+	struct intel_dp *intel_dp = container_of(to_delayed_work(__work),
+						 struct intel_dp, panel_vdd_work);
+	struct drm_device *dev = intel_dp->base.base.dev;
+
+	mutex_lock(&dev->struct_mutex);
+	if (!intel_dp->panel_vdd_force)
+		ironlake_panel_vdd_delayed_off(intel_dp);
+	mutex_unlock(&dev->struct_mutex);
+}
+
+static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp)
+{
+	if (!is_edp(intel_dp))
+		return;
+
+	DRM_DEBUG_KMS("Turn eDP VDD off %d\n", intel_dp->panel_vdd_force);
+	WARN(!intel_dp->panel_vdd_force, "eDP VDD not forced on");
+	
+	intel_dp->panel_vdd_force = false;
+	/*
+	 * Queue the timer to fire a long
+	 * time from now (relative to the power down delay)
+	 * to keep the panel power up across a sequence of operations
+	 */
+	schedule_delayed_work(&intel_dp->panel_vdd_work,
+			      msecs_to_jiffies(intel_dp->panel_power_down_delay * 5));
 }
 
 /* Returns true if the panel was already on when called */
@@ -895,6 +952,7 @@ static bool ironlake_edp_panel_on (struct intel_dp *intel_dp)
 	if (I915_READ(PCH_PP_STATUS) & PP_ON)
 		return true;
 
+	ironlake_wait_panel_off(intel_dp);
 	pp = I915_READ(PCH_PP_CONTROL);
 	pp &= ~PANEL_UNLOCK_MASK;
 	pp |= PANEL_UNLOCK_REGS;
@@ -940,7 +998,6 @@ static void ironlake_edp_panel_off(struct drm_encoder *encoder)
 	pp &= ~POWER_TARGET_ON;
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
-	msleep(intel_dp->panel_power_down_delay);
 
 	if (wait_for((I915_READ(PCH_PP_STATUS) & idle_off_mask) == 0, 5000))
 		DRM_ERROR("panel off wait timed out: 0x%08x\n",
@@ -949,6 +1006,7 @@ static void ironlake_edp_panel_off(struct drm_encoder *encoder)
 	pp |= PANEL_POWER_RESET; /* restore panel reset bit */
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
+	intel_dp->panel_off_jiffies = jiffies;
 }
 
 static void ironlake_edp_backlight_on (struct drm_device *dev)
@@ -1937,6 +1995,10 @@ static void intel_dp_encoder_destroy(struct drm_encoder *encoder)
 
 	i2c_del_adapter(&intel_dp->adapter);
 	drm_encoder_cleanup(encoder);
+	if (is_edp(intel_dp)) {
+		cancel_delayed_work_sync(&intel_dp->panel_vdd_work);
+		ironlake_panel_vdd_delayed_off(intel_dp);
+	}
 	kfree(intel_dp);
 }
 
@@ -2073,8 +2135,11 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 	else if (output_reg == DP_D || output_reg == PCH_DP_D)
 		intel_encoder->clone_mask = (1 << INTEL_DP_D_CLONE_BIT);
 
-	if (is_edp(intel_dp))
+	if (is_edp(intel_dp)) {
 		intel_encoder->clone_mask = (1 << INTEL_EDP_CLONE_BIT);
+		INIT_DELAYED_WORK(&intel_dp->panel_vdd_work,
+				  ironlake_panel_vdd_work);
+	}
 
 	intel_encoder->crtc_mask = (1 << 0) | (1 << 1);
 	connector->interlace_allowed = true;
@@ -2149,6 +2214,8 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 		DRM_DEBUG_KMS("panel power up delay %d, power down delay %d\n",
 			      intel_dp->panel_power_up_delay, intel_dp->panel_power_down_delay);
 
+		intel_dp->panel_off_jiffies = jiffies - intel_dp->panel_power_down_delay;
+
 		ironlake_edp_panel_vdd_on(intel_dp);
 		ret = intel_dp_get_dpcd(intel_dp);
 		ironlake_edp_panel_vdd_off(intel_dp);
-- 
1.7.6.3

