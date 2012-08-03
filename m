Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab2HCQDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:03:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43277 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab2HCQCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:02:36 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: dri-devel@lists.freedesktop.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        Andreas Heider <andreas@meetr.de>
Subject: [RFC PATCH 4/5] drm/i915: make intel_lvds_get_edid() more robust
Date: Fri,  3 Aug 2012 11:02:20 -0500
Message-Id: <1344009741-14248-5-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
References: <1344009741-14248-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intel_lvds_get_edid() needs to be called when switching GPUs, but it's
currently making assumptions that it will only be called once and that
there's always an LVDS connector present when it's called. Fix these
assumptions.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index c1ab632..9d05a90 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -906,9 +906,18 @@ static bool intel_lvds_get_edid(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_connector *connector = dev_priv->int_lvds_connector;
-	struct intel_lvds *intel_lvds = intel_attached_lvds(connector);
+	struct intel_lvds *intel_lvds;
 	struct drm_display_mode *scan; /* *modes, *bios_mode; */
 
+	if (!connector)
+		return false;
+
+	intel_lvds = intel_attached_lvds(connector);
+
+	/* If we already have an EDID, no need to check again */
+	if (intel_lvds->edid)
+		return true;
+
 	/*
 	 * Attempt to get the fixed panel mode from DDC.  Assume that the
 	 * preferred mode is the right one.
@@ -939,6 +948,12 @@ static bool intel_lvds_get_edid(struct drm_device *dev)
 
 	list_for_each_entry(scan, &connector->probed_modes, head) {
 		if (scan->type & DRM_MODE_TYPE_PREFERRED) {
+			/*
+			 * If we already have a preferred mode from another
+			 * source, prefer the one from the EDID.
+			 */
+			if (intel_lvds->fixed_mode)
+				drm_mode_destroy(dev, intel_lvds->fixed_mode);
 			intel_lvds->fixed_mode =
 				drm_mode_duplicate(dev, scan);
 			intel_find_lvds_downclock(dev,
-- 
1.7.9.5

