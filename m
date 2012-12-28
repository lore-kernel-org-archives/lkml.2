Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab2L1TvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:51:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55097 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754571Ab2L1TRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:45 -0500
Message-Id: <20121228190359.584470292@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 148/173] drm/i915: do not ignore eDP bpc settings from vbt
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 461a637..4154bcd 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3841,6 +3841,17 @@ static bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
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


