Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab1ISWWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:22:24 -0400
Received: from home.keithp.com ([63.227.221.253]:41877 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab1ISWWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:22:22 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 3/9] drm/i915: Only use VBT panel mode on eDP if no EDID is found
Date: Mon, 19 Sep 2011 15:21:57 -0700
Message-Id: <1316470923-27832-4-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1316470923-27832-1-git-send-email-keithp@keithp.com>
References: <1316470923-27832-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're going to assume that EDID is more reliable than the VBT tables
for eDP panels, which is notably true on MacBook machines where the
VBT contains completely bogus data.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index f0cfb6b..8ab2a88 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1748,7 +1748,16 @@ static int intel_dp_get_modes(struct drm_connector *connector)
 
 	/* if eDP has no EDID, try to use fixed panel mode from VBT */
 	if (is_edp(intel_dp)) {
-		if (dev_priv->panel_fixed_mode != NULL) {
+		/* initialize panel mode from VBT if available for eDP */
+		if (dev_priv->panel_fixed_mode == NULL && dev_priv->lfp_lvds_vbt_mode != NULL) {
+			dev_priv->panel_fixed_mode =
+				drm_mode_duplicate(dev, dev_priv->lfp_lvds_vbt_mode);
+			if (dev_priv->panel_fixed_mode) {
+				dev_priv->panel_fixed_mode->type |=
+					DRM_MODE_TYPE_PREFERRED;
+			}
+		}
+		if (dev_priv->panel_fixed_mode) {
 			struct drm_display_mode *mode;
 			mode = drm_mode_duplicate(dev, dev_priv->panel_fixed_mode);
 			drm_mode_probed_add(connector, mode);
@@ -2061,15 +2070,6 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 	intel_encoder->hot_plug = intel_dp_hot_plug;
 
 	if (is_edp(intel_dp)) {
-		/* initialize panel mode from VBT if available for eDP */
-		if (dev_priv->lfp_lvds_vbt_mode) {
-			dev_priv->panel_fixed_mode =
-				drm_mode_duplicate(dev, dev_priv->lfp_lvds_vbt_mode);
-			if (dev_priv->panel_fixed_mode) {
-				dev_priv->panel_fixed_mode->type |=
-					DRM_MODE_TYPE_PREFERRED;
-			}
-		}
 		dev_priv->int_edp_connector = connector;
 		intel_panel_setup_backlight(dev);
 	}
-- 
1.7.6.3

