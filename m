Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab2HCQCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:02:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43270 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2HCQCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:02:34 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: dri-devel@lists.freedesktop.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        Andreas Heider <andreas@meetr.de>
Subject: [RFC PATCH 3/5] drm/i915: register LVDS connector even if we can't get a panel mode
Date: Fri,  3 Aug 2012 11:02:19 -0500
Message-Id: <1344009741-14248-4-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
References: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Apple hybrid graphics machines do not have the LVDS panel connected
to the integrated GPU at boot and also do not supply a VBT. The LVDS
connector is not registered as a result, making it impossible to support
graphics switching.

This patch changes intel_lvds_init() to register the connector even if
we can't find any panel modes. This makes it necessary to always check
intel_lvds->fixed_mode before use, as it could now be NULL.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |   48 +++++++++++++++----------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 5069137..c1ab632 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -161,6 +161,8 @@ static int intel_lvds_mode_valid(struct drm_connector *connector,
 	struct intel_lvds *intel_lvds = intel_attached_lvds(connector);
 	struct drm_display_mode *fixed_mode = intel_lvds->fixed_mode;
 
+	if (!fixed_mode)
+		return MODE_PANEL;
 	if (mode->hdisplay > fixed_mode->hdisplay)
 		return MODE_PANEL;
 	if (mode->vdisplay > fixed_mode->vdisplay)
@@ -262,7 +264,8 @@ static bool intel_lvds_mode_fixup(struct drm_encoder *encoder,
 	 * with the panel scaling set up to source from the H/VDisplay
 	 * of the original mode.
 	 */
-	intel_fixed_panel_mode(intel_lvds->fixed_mode, adjusted_mode);
+	if (intel_lvds->fixed_mode)
+		intel_fixed_panel_mode(intel_lvds->fixed_mode, adjusted_mode);
 
 	if (HAS_PCH_SPLIT(dev)) {
 		intel_pch_panel_fitting(dev, intel_lvds->fitting_mode,
@@ -461,12 +464,13 @@ static int intel_lvds_get_modes(struct drm_connector *connector)
 {
 	struct intel_lvds *intel_lvds = intel_attached_lvds(connector);
 	struct drm_device *dev = connector->dev;
-	struct drm_display_mode *mode;
+	struct drm_display_mode *mode = NULL;
 
 	if (intel_lvds->edid)
 		return drm_add_edid_modes(connector, intel_lvds->edid);
 
-	mode = drm_mode_duplicate(dev, intel_lvds->fixed_mode);
+	if (intel_lvds->fixed_mode)
+		mode = drm_mode_duplicate(dev, intel_lvds->fixed_mode);
 	if (mode == NULL)
 		return 0;
 
@@ -1073,26 +1077,21 @@ bool intel_lvds_init(struct drm_device *dev)
 	 */
 
 	/* Ironlake: FIXME if still fail, not try pipe mode now */
-	if (HAS_PCH_SPLIT(dev))
-		goto failed;
-
-	lvds = I915_READ(LVDS);
-	pipe = (lvds & LVDS_PIPEB_SELECT) ? 1 : 0;
-	crtc = intel_get_crtc_for_pipe(dev, pipe);
-
-	if (crtc && (lvds & LVDS_PORT_EN)) {
-		intel_lvds->fixed_mode = intel_crtc_mode_get(dev, crtc);
-		if (intel_lvds->fixed_mode) {
-			intel_lvds->fixed_mode->type |=
-				DRM_MODE_TYPE_PREFERRED;
-			goto out;
+	if (!HAS_PCH_SPLIT(dev)) {
+		lvds = I915_READ(LVDS);
+		pipe = (lvds & LVDS_PIPEB_SELECT) ? 1 : 0;
+		crtc = intel_get_crtc_for_pipe(dev, pipe);
+
+		if (crtc && (lvds & LVDS_PORT_EN)) {
+			intel_lvds->fixed_mode = intel_crtc_mode_get(dev, crtc);
+			if (intel_lvds->fixed_mode) {
+				intel_lvds->fixed_mode->type |=
+					DRM_MODE_TYPE_PREFERRED;
+				goto out;
+			}
 		}
 	}
 
-	/* If we still don't have a mode after all that, give up. */
-	if (!intel_lvds->fixed_mode)
-		goto failed;
-
 out:
 	/*
 	 * Unlock registers and just
@@ -1116,13 +1115,4 @@ out:
 	intel_panel_setup_backlight(dev);
 
 	return true;
-
-failed:
-	DRM_DEBUG_KMS("No LVDS modes found, disabling.\n");
-	dev_priv->int_lvds_connector = NULL;
-	drm_connector_cleanup(connector);
-	drm_encoder_cleanup(encoder);
-	kfree(intel_lvds);
-	kfree(intel_connector);
-	return false;
 }
-- 
1.7.9.5

