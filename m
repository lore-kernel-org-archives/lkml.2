Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab1I3BNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:13:44 -0400
Received: from home.keithp.com ([63.227.221.253]:49842 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273Ab1I3BKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:10:19 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 19/21] drm/i915: Asynchronous eDP panel power off
Date: Thu, 29 Sep 2011 18:09:51 -0700
Message-Id: <1317344993-24945-20-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317344993-24945-1-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the same basic plan as the VDD force delayed power off, make
turning the panel power off asynchronous.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   71 +++++++++++++++++++++++++++++----------
 1 files changed, 53 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 08817b0..7120ba7 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -62,8 +62,9 @@ struct intel_dp {
 	int panel_power_up_delay;
 	int panel_power_down_delay;
 	struct drm_display_mode *panel_fixed_mode;  /* for eDP */
-	struct delayed_work panel_vdd_work;
+	struct delayed_work panel_work;
 	bool want_panel_vdd;
+	bool want_panel_power;
 	unsigned long panel_off_jiffies;
 };
 
@@ -906,7 +907,9 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 	}
 }
 
-static void ironlake_panel_vdd_off_sync(struct intel_dp *intel_dp)
+static void ironlake_edp_panel_off_sync(struct intel_dp *intel_dp);
+
+static void ironlake_edp_panel_vdd_off_sync(struct intel_dp *intel_dp)
 {
 	struct drm_device *dev = intel_dp->base.base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -927,14 +930,15 @@ static void ironlake_panel_vdd_off_sync(struct intel_dp *intel_dp)
 	}
 }
 
-static void ironlake_panel_vdd_work(struct work_struct *__work)
+static void ironlake_panel_work(struct work_struct *__work)
 {
 	struct intel_dp *intel_dp = container_of(to_delayed_work(__work),
-						 struct intel_dp, panel_vdd_work);
+						 struct intel_dp, panel_work);
 	struct drm_device *dev = intel_dp->base.base.dev;
 
 	mutex_lock(&dev->struct_mutex);
-	ironlake_panel_vdd_off_sync(intel_dp);
+	ironlake_edp_panel_vdd_off_sync(intel_dp);
+	ironlake_edp_panel_off_sync(intel_dp);
 	mutex_unlock(&dev->struct_mutex);
 }
 
@@ -943,20 +947,20 @@ static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp, bool sync)
 	if (!is_edp(intel_dp))
 		return;
 
-	DRM_DEBUG_KMS("Turn eDP VDD off %d\n", intel_dp->want_panel_vdd);
+	DRM_DEBUG_KMS("Turn eDP VDD off %d\n", sync);
 	WARN(!intel_dp->want_panel_vdd, "eDP VDD not forced on");
 	
 	intel_dp->want_panel_vdd = false;
 
 	if (sync) {
-		ironlake_panel_vdd_off_sync(intel_dp);
+		ironlake_edp_panel_vdd_off_sync(intel_dp);
 	} else {
 		/*
 		 * Queue the timer to fire a long
 		 * time from now (relative to the power down delay)
 		 * to keep the panel power up across a sequence of operations
 		 */
-		schedule_delayed_work(&intel_dp->panel_vdd_work,
+		schedule_delayed_work(&intel_dp->panel_work,
 				      msecs_to_jiffies(intel_dp->panel_power_down_delay * 5));
 	}
 }
@@ -968,10 +972,16 @@ static void ironlake_edp_panel_on (struct intel_dp *intel_dp)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 pp, idle_on_mask = PP_ON | PP_SEQUENCE_STATE_ON_IDLE;
 
-	if (ironlake_edp_have_panel_power(intel_dp))
+	DRM_DEBUG_KMS("Turn eDP panel on\n");
+	if (ironlake_edp_have_panel_power(intel_dp)) {
+		DRM_DEBUG_KMS("eDP panel already on\n");
 		return;
+	}
 
 	ironlake_wait_panel_off(intel_dp);
+
+	intel_dp->want_panel_power = true;
+
 	pp = I915_READ(PCH_PP_CONTROL);
 	pp &= ~PANEL_UNLOCK_MASK;
 	pp |= PANEL_UNLOCK_REGS;
@@ -995,14 +1005,16 @@ static void ironlake_edp_panel_on (struct intel_dp *intel_dp)
 	POSTING_READ(PCH_PP_CONTROL);
 }
 
-static void ironlake_edp_panel_off(struct drm_encoder *encoder)
+static void ironlake_edp_panel_off_sync(struct intel_dp *intel_dp)
 {
-	struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
-	struct drm_device *dev = encoder->dev;
+	struct drm_device *dev = intel_dp->base.base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 pp, idle_off_mask = PP_ON | PP_SEQUENCE_MASK |
 		PP_CYCLE_DELAY_ACTIVE | PP_SEQUENCE_STATE_MASK;
 
+	if (intel_dp->want_panel_power || !ironlake_edp_have_panel_power(intel_dp))
+		return;
+
 	pp = I915_READ(PCH_PP_CONTROL);
 	pp &= ~PANEL_UNLOCK_MASK;
 	pp |= PANEL_UNLOCK_REGS;
@@ -1026,6 +1038,28 @@ static void ironlake_edp_panel_off(struct drm_encoder *encoder)
 	intel_dp->panel_off_jiffies = jiffies;
 }
 
+static void ironlake_edp_panel_off(struct drm_encoder *encoder, bool sync)
+{
+	struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
+
+	DRM_DEBUG_KMS("Turn eDP panel off %d\n", sync);
+
+	intel_dp->want_panel_power = false;
+
+	if (sync)
+		ironlake_edp_panel_off_sync(intel_dp);
+	else {
+		/*
+		 * Queue the timer to fire a long
+		 * time from now (relative to the power down delay)
+		 * to keep the panel power up across a sequence of operations
+		 */
+		schedule_delayed_work(&intel_dp->panel_work,
+				      msecs_to_jiffies(intel_dp->panel_power_down_delay * 5));
+	}
+		
+}
+
 static void ironlake_edp_backlight_on (struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -1121,7 +1155,7 @@ static void intel_dp_prepare(struct drm_encoder *encoder)
 
 	if (is_edp(intel_dp)) {
 		ironlake_edp_backlight_off(dev);
-		ironlake_edp_panel_off(encoder);
+		ironlake_edp_panel_off(encoder, false);
 		if (!is_pch_edp(intel_dp))
 			ironlake_edp_pll_on(encoder);
 		else
@@ -1165,7 +1199,7 @@ intel_dp_dpms(struct drm_encoder *encoder, int mode)
 		intel_dp_sink_dpms(intel_dp, mode);
 		intel_dp_link_down(intel_dp);
 		if (is_edp(intel_dp))
-			ironlake_edp_panel_off(encoder);
+			ironlake_edp_panel_off(encoder, true);
 		if (is_edp(intel_dp) && !is_pch_edp(intel_dp))
 			ironlake_edp_pll_off(encoder);
 	} else {
@@ -2016,8 +2050,9 @@ static void intel_dp_encoder_destroy(struct drm_encoder *encoder)
 	i2c_del_adapter(&intel_dp->adapter);
 	drm_encoder_cleanup(encoder);
 	if (is_edp(intel_dp)) {
-		cancel_delayed_work_sync(&intel_dp->panel_vdd_work);
-		ironlake_panel_vdd_off_sync(intel_dp);
+		cancel_delayed_work_sync(&intel_dp->panel_work);
+		ironlake_edp_panel_vdd_off_sync(intel_dp);
+		ironlake_edp_panel_off_sync(intel_dp);
 	}
 	kfree(intel_dp);
 }
@@ -2157,8 +2192,8 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 
 	if (is_edp(intel_dp)) {
 		intel_encoder->clone_mask = (1 << INTEL_EDP_CLONE_BIT);
-		INIT_DELAYED_WORK(&intel_dp->panel_vdd_work,
-				  ironlake_panel_vdd_work);
+		INIT_DELAYED_WORK(&intel_dp->panel_work,
+				  ironlake_panel_work);
 	}
 
 	intel_encoder->crtc_mask = (1 << 0) | (1 << 1);
-- 
1.7.6.3

