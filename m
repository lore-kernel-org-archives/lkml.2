Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab1KBGU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 02:20:56 -0400
Received: from home.keithp.com ([63.227.221.253]:33638 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab1KBGUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 02:20:51 -0400
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH 1/7] drm/i915: Move common PCH_PP_CONTROL setup to ironlake_get_pp_control
Date: Tue,  1 Nov 2011 23:20:24 -0700
Message-Id: <1320214830-12696-2-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320214830-12696-1-git-send-email-keithp@keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every usage of PCH_PP_CONTROL sets the PANEL_UNLOCK_REGS value to
ensure that writes will be respected, move this to a common function
to make the driver cleaner.

No functional changes.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 7259034..efe5f9e 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -906,6 +906,19 @@ static void ironlake_wait_panel_off(struct intel_dp *intel_dp)
 	msleep(delay);
 }
 
+/* Read the current pp_control value, unlocking the register if it
+ * is locked
+ */
+
+static  u32 ironlake_get_pp_control(struct drm_i915_private *dev_priv)
+{
+	u32	control = I915_READ(PCH_PP_CONTROL);
+
+	control &= ~PANEL_UNLOCK_MASK;
+	control |= PANEL_UNLOCK_REGS;
+	return control;
+}
+
 static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 {
 	struct drm_device *dev = intel_dp->base.base.dev;
@@ -926,9 +939,7 @@ static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp)
 	}
 
 	ironlake_wait_panel_off(intel_dp);
-	pp = I915_READ(PCH_PP_CONTROL);
-	pp &= ~PANEL_UNLOCK_MASK;
-	pp |= PANEL_UNLOCK_REGS;
+	pp = ironlake_get_pp_control(dev_priv);
 	pp |= EDP_FORCE_VDD;
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
@@ -951,9 +962,7 @@ static void ironlake_panel_vdd_off_sync(struct intel_dp *intel_dp)
 	u32 pp;
 
 	if (!intel_dp->want_panel_vdd && ironlake_edp_have_panel_vdd(intel_dp)) {
-		pp = I915_READ(PCH_PP_CONTROL);
-		pp &= ~PANEL_UNLOCK_MASK;
-		pp |= PANEL_UNLOCK_REGS;
+		pp = ironlake_get_pp_control(dev_priv);
 		pp &= ~EDP_FORCE_VDD;
 		I915_WRITE(PCH_PP_CONTROL, pp);
 		POSTING_READ(PCH_PP_CONTROL);
@@ -1012,9 +1021,7 @@ static void ironlake_edp_panel_on(struct intel_dp *intel_dp)
 		return;
 
 	ironlake_wait_panel_off(intel_dp);
-	pp = I915_READ(PCH_PP_CONTROL);
-	pp &= ~PANEL_UNLOCK_MASK;
-	pp |= PANEL_UNLOCK_REGS;
+	pp = ironlake_get_pp_control(dev_priv);
 
 	if (IS_GEN5(dev)) {
 		/* ILK workaround: disable reset around power sequence */
@@ -1049,9 +1056,7 @@ static void ironlake_edp_panel_off(struct drm_encoder *encoder)
 
 	if (!is_edp(intel_dp))
 		return;
-	pp = I915_READ(PCH_PP_CONTROL);
-	pp &= ~PANEL_UNLOCK_MASK;
-	pp |= PANEL_UNLOCK_REGS;
+	pp = ironlake_get_pp_control(dev_priv);
 
 	if (IS_GEN5(dev)) {
 		/* ILK workaround: disable reset around power sequence */
@@ -1098,9 +1103,7 @@ static void ironlake_edp_backlight_on(struct intel_dp *intel_dp)
 	 * allowing it to appear.
 	 */
 	msleep(intel_dp->backlight_on_delay);
-	pp = I915_READ(PCH_PP_CONTROL);
-	pp &= ~PANEL_UNLOCK_MASK;
-	pp |= PANEL_UNLOCK_REGS;
+	pp = ironlake_get_pp_control(dev_priv);
 	pp |= EDP_BLC_ENABLE;
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
@@ -1116,9 +1119,7 @@ static void ironlake_edp_backlight_off(struct intel_dp *intel_dp)
 		return;
 
 	DRM_DEBUG_KMS("\n");
-	pp = I915_READ(PCH_PP_CONTROL);
-	pp &= ~PANEL_UNLOCK_MASK;
-	pp |= PANEL_UNLOCK_REGS;
+	pp = ironlake_get_pp_control(dev_priv);
 	pp &= ~EDP_BLC_ENABLE;
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
-- 
1.7.7

