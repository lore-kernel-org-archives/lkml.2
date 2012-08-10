Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab2HJJKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 05:10:06 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40182 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012Ab2HJJKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 05:10:03 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Benoit Gschwind <gschwind@gnu-log.net>,
        Francois Rigaut <frigaut@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: ingore eDP bpc settings
Date: Fri, 10 Aug 2012 11:10:20 +0200
Message-Id: <1344589820-9753-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has originally been introduced to not oversubscribe the dp links
in

commit 885a5fb5b120a5c7e0b3baad7b0feb5a89f76c18
Author: Zhenyu Wang <zhenyuw@linux.intel.com>
Date:   Tue Jan 12 05:38:31 2010 +0800

    drm/i915: fix pixel color depth setting on eDP

Since then we've fixed up the dp link bandwidth calculation code for
code and should now automatically fall back to 6bpc dithering. So this
is unnecessary.

Furthermore it seems to break the new MacbookPro with retina display,
hence let's just rip this out.

Reported-by: Benoit Gschwind <gschwind@gnu-log.net>
Cc: Benoit Gschwind <gschwind@gnu-log.net>
Cc: Francois Rigaut <frigaut@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

--

Testing feedback highgly welcome, and thanks for Benoit for finding
out that the bpc computations are busted.
-Daniel
---
 drivers/gpu/drm/i915/intel_display.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index bddb290..ddd4db3 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3755,17 +3755,6 @@ static bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
 			continue;
 		}
 
-		if (intel_encoder->type == INTEL_OUTPUT_EDP) {
-			/* Use VBT settings if we have an eDP panel */
-			unsigned int edp_bpc = dev_priv->edp.bpp / 3;
-
-			if (edp_bpc < display_bpc) {
-				DRM_DEBUG_KMS("clamping display bpc (was %d) to eDP (%d)\n", display_bpc, edp_bpc);
-				display_bpc = edp_bpc;
-			}
-			continue;
-		}
-
 		/* Not one of the known troublemakers, check the EDID */
 		list_for_each_entry(connector, &dev->mode_config.connector_list,
 				    head) {
-- 
1.7.10.4

