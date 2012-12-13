Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab2LMOQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:16:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45196 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933575Ab2LMOPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:15:37 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 240/241] drm/i915: do not default to 18 bpp for eDP if missing from VBT
Date: Thu, 13 Dec 2012 12:00:05 -0200
Message-Id: <1355407206-17100-241-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 9a30a61f3516871c5c638fd7c025fbaa11ddf7fe upstream.

commit 500a8cc466a24e2fbc4c86ef9c6467ae2ffdeb0c
Author: Zhenyu Wang <zhenyuw@linux.intel.com>
Date:   Wed Jan 13 11:19:52 2010 +0800

    drm/i915: parse eDP panel color depth from VBT block

originally introduced parsing bpp for eDP from VBT, with a default of 18
bpp if the eDP BIOS data block is not present. Turns out that default seems
to break the Macbook Pro with retina display, as noted in

commit 4344b813f105a19f793f1fd93ad775b784648b95
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri Aug 10 11:10:20 2012 +0200

    drm/i915: ignore eDP bpc settings from vbt

Since we can't ignore bpc settings from VBT completely after all, get rid
of the default. Do not clamp eDP to 18 bpp by default if the eDP BDB is
missing from VBT.

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Tested-by: Henrik Rydberg <rydberg@euromail.se>
[danvet: paste in the updated commit message from irc.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/intel_bios.c    |   11 ++---------
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index 3534593..c4b9892 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -500,12 +500,8 @@ parse_edp(struct drm_i915_private *dev_priv, struct bdb_header *bdb)
 
 	edp = find_section(bdb, BDB_EDP);
 	if (!edp) {
-		if (SUPPORTS_EDP(dev_priv->dev) && dev_priv->edp.support) {
-			DRM_DEBUG_KMS("No eDP BDB found but eDP panel "
-				      "supported, assume %dbpp panel color "
-				      "depth.\n",
-				      dev_priv->edp.bpp);
-		}
+		if (SUPPORTS_EDP(dev_priv->dev) && dev_priv->edp.support)
+			DRM_DEBUG_KMS("No eDP BDB found but eDP panel supported.\n");
 		return;
 	}
 
@@ -658,9 +654,6 @@ init_vbt_defaults(struct drm_i915_private *dev_priv)
 	dev_priv->lvds_use_ssc = 1;
 	dev_priv->lvds_ssc_freq = intel_bios_ssc_frequency(dev, 1);
 	DRM_DEBUG_KMS("Set default to SSC at %dMHz\n", dev_priv->lvds_ssc_freq);
-
-	/* eDP data */
-	dev_priv->edp.bpp = 18;
 }
 
 static int __init intel_no_opregion_vbt_callback(const struct dmi_system_id *id)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 9916052..552a229 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3620,7 +3620,7 @@ static bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
 			/* Use VBT settings if we have an eDP panel */
 			unsigned int edp_bpc = dev_priv->edp.bpp / 3;
 
-			if (edp_bpc < display_bpc) {
+			if (edp_bpc && edp_bpc < display_bpc) {
 				DRM_DEBUG_KMS("clamping display bpc (was %d) to eDP (%d)\n", display_bpc, edp_bpc);
 				display_bpc = edp_bpc;
 			}
-- 
1.7.9.5

