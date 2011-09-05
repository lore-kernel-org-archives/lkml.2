Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab1IETAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 15:00:42 -0400
Received: from home.keithp.com ([63.227.221.253]:47608 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab1IETAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 15:00:37 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH] drm/i915: Enable dither whenever display bpc < frame buffer bpc
Date: Mon,  5 Sep 2011 12:00:15 -0700
Message-Id: <1315249215-13956-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <4E650BB8.8040507@hartkopp.net>
References: <4E650BB8.8040507@hartkopp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to enable dithering on any pipe where the frame buffer has
more color resolution than the output device.

The previous code was incorrectly clamping the frame buffer bpc to the
display bpc, effectively disabling dithering all of the time as the
computed frame buffer bpc would never be larger than the display bpc.

Signed-off-by: Keith Packard <keithp@keithp.com>
Reported-by: Oliver Hartkopp <socketcan@hartkopp.net>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 drivers/gpu/drm/i915/intel_display.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 56a8554..9fb4a40 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4687,13 +4687,13 @@ static bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
 		bpc = 6; /* min is 18bpp */
 		break;
 	case 24:
-		bpc = min((unsigned int)8, display_bpc);
+		bpc = 8;
 		break;
 	case 30:
-		bpc = min((unsigned int)10, display_bpc);
+		bpc = 10;
 		break;
 	case 48:
-		bpc = min((unsigned int)12, display_bpc);
+		bpc = 12;
 		break;
 	default:
 		DRM_DEBUG("unsupported depth, assuming 24 bits\n");
@@ -4701,10 +4701,12 @@ static bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
 		break;
 	}
 
+	display_bpc = min(display_bpc, bpc);
+
 	DRM_DEBUG_DRIVER("setting pipe bpc to %d (max display bpc %d)\n",
 			 bpc, display_bpc);
 
-	*pipe_bpp = bpc * 3;
+	*pipe_bpp = display_bpc * 3;
 
 	return display_bpc != bpc;
 }
-- 
1.7.5.4

