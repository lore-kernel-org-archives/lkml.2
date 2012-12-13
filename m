Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589Ab2LMOPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:15:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45190 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486Ab2LMOPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:15:34 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 239/241] drm/i915: do not ignore eDP bpc settings from vbt
Date: Thu, 13 Dec 2012 12:00:04 -0200
Message-Id: <1355407206-17100-240-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 2f4f649a69a9eb51f6e98130e19dd90a260a4145 upstream.

There are laptops out there that need the eDP bpc from VBT. This is
effectively a revert of

commit 4344b813f105a19f793f1fd93ad775b784648b95
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri Aug 10 11:10:20 2012 +0200

    drm/i915: ignore eDP bpc settings from vbt

but putting the VBT check after the EDID check to see them both in dmesg if
this clamps more than the EDID. We have enough history with bpc clamping to
warrant the extra debug info.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=47641
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=56401
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 0865f27..9916052 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3616,6 +3616,17 @@ static bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
 			}
 		}
 
+		if (intel_encoder->type == INTEL_OUTPUT_EDP) {
+			/* Use VBT settings if we have an eDP panel */
+			unsigned int edp_bpc = dev_priv->edp.bpp / 3;
+
+			if (edp_bpc < display_bpc) {
+				DRM_DEBUG_KMS("clamping display bpc (was %d) to eDP (%d)\n", display_bpc, edp_bpc);
+				display_bpc = edp_bpc;
+			}
+			continue;
+		}
+
 		/*
 		 * HDMI is either 12 or 8, so if the display lets 10bpc sneak
 		 * through, clamp it down.  (Note: >12bpc will be caught below.)
-- 
1.7.9.5

