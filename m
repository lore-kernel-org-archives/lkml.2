Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1KBGU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 02:20:58 -0400
Received: from home.keithp.com ([63.227.221.253]:33643 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab1KBGUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 02:20:52 -0400
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH 5/7] drm/i915: Make DP prepare/commit consistent with DP dpms
Date: Tue,  1 Nov 2011 23:20:28 -0700
Message-Id: <1320214830-12696-6-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320214830-12696-1-git-send-email-keithp@keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure the sequence of operations in all three functions makes
sense:

 1) The backlight must be off unless the screen is running
 2) The link must be running to turn the eDP panel on/off
 3) The CPU eDP PLL must be running until everything is off

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index d6c6608..6be6a04 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1234,17 +1234,18 @@ static void intel_dp_prepare(struct drm_encoder *encoder)
 {
 	struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 
+	ironlake_edp_backlight_off(intel_dp);
+	ironlake_edp_panel_off(intel_dp);
+
 	/* Wake up the sink first */
 	ironlake_edp_panel_vdd_on(intel_dp);
 	intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_ON);
+	intel_dp_link_down(intel_dp);
 	ironlake_edp_panel_vdd_off(intel_dp, false);
 
 	/* Make sure the panel is off before trying to
 	 * change the mode
 	 */
-	ironlake_edp_backlight_off(intel_dp);
-	intel_dp_link_down(intel_dp);
-	ironlake_edp_panel_off(intel_dp);
 }
 
 static void intel_dp_commit(struct drm_encoder *encoder)
@@ -1276,16 +1277,20 @@ intel_dp_dpms(struct drm_encoder *encoder, int mode)
 	uint32_t dp_reg = I915_READ(intel_dp->output_reg);
 
 	if (mode != DRM_MODE_DPMS_ON) {
+		ironlake_edp_backlight_off(intel_dp);
+		ironlake_edp_panel_off(intel_dp);
+
 		ironlake_edp_panel_vdd_on(intel_dp);
-		if (is_edp(intel_dp))
-			ironlake_edp_backlight_off(intel_dp);
 		intel_dp_sink_dpms(intel_dp, mode);
 		intel_dp_link_down(intel_dp);
-		ironlake_edp_panel_off(intel_dp);
-		if (is_edp(intel_dp) && !is_pch_edp(intel_dp))
-			ironlake_edp_pll_off(encoder);
 		ironlake_edp_panel_vdd_off(intel_dp, false);
+
+		if (is_cpu_edp(intel_dp))
+			ironlake_edp_pll_off(encoder);
 	} else {
+		if (is_cpu_edp(intel_dp))
+			ironlake_edp_pll_on(encoder);
+
 		ironlake_edp_panel_vdd_on(intel_dp);
 		intel_dp_sink_dpms(intel_dp, mode);
 		if (!(dp_reg & DP_PORT_EN)) {
@@ -1293,7 +1298,6 @@ intel_dp_dpms(struct drm_encoder *encoder, int mode)
 			ironlake_edp_panel_on(intel_dp);
 			ironlake_edp_panel_vdd_off(intel_dp, true);
 			intel_dp_complete_link_train(intel_dp);
-			ironlake_edp_backlight_on(intel_dp);
 		} else
 			ironlake_edp_panel_vdd_off(intel_dp, false);
 		ironlake_edp_backlight_on(intel_dp);
-- 
1.7.7

