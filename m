Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090Ab2LNXED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:04:03 -0500
Received: from mail.kernel.org ([198.145.19.201]:40824 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756993Ab2LNXD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:03:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 11/37] drm/i915: do not ignore eDP bpc settings from vbt
Date: Fri, 14 Dec 2012 15:00:48 -0800
Message-Id: <20121214222255.428958839@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222252.781413287@linuxfoundation.org>
References: <20121214222252.781413287@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3791,6 +3791,17 @@ static bool intel_choose_pipe_bpp_dither
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


