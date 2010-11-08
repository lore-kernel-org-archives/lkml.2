Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab0KHXYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:24:25 -0500
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:61159
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754711Ab0KHXYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:24:23 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Jon Masters <jonathan@jonmasters.org>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915: Fix LVDS fixed-mode regression from 219adae1
Date: Mon,  8 Nov 2010 23:24:12 +0000
Message-Id: <1289258652-22665-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289257727.3916.429.camel@constitution.bos.jonmasters.org>
References: <1289257727.3916.429.camel@constitution.bos.jonmasters.org>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 219adae1 cached the EDID found during LVDS init, but in the
process prevented the init routine from discovering the preferred
fixed-mode for the panel. This was causing us to guess the correct mode,
which sometimes is wide of the mark.

Reported-by: Jon Masters <jonathan@jonmasters.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/intel_lvds.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index f1a6499..4324a32 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -481,11 +481,8 @@ static int intel_lvds_get_modes(struct drm_connector *connector)
 	struct drm_device *dev = connector->dev;
 	struct drm_display_mode *mode;
 
-	if (intel_lvds->edid) {
-		drm_mode_connector_update_edid_property(connector,
-							intel_lvds->edid);
+	if (intel_lvds->edid)
 		return drm_add_edid_modes(connector, intel_lvds->edid);
-	}
 
 	mode = drm_mode_duplicate(dev, intel_lvds->fixed_mode);
 	if (mode == 0)
@@ -939,7 +936,16 @@ void intel_lvds_init(struct drm_device *dev)
 	 */
 	intel_lvds->edid = drm_get_edid(connector,
 					&dev_priv->gmbus[pin].adapter);
-
+	if (intel_lvds->edid) {
+		if (drm_add_edid_modes(connector,
+				       intel_lvds->edid)) {
+			drm_mode_connector_update_edid_property(connector,
+								intel_lvds->edid);
+		} else {
+			kfree(intel_lvds->edid);
+			intel_lvds->edid = NULL;
+		}
+	}
 	if (!intel_lvds->edid) {
 		/* Didn't get an EDID, so
 		 * Set wide sync ranges so we get all modes
-- 
1.7.2.3

