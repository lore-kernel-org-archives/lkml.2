Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab0IBSqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 14:46:38 -0400
Received: from c60.cesmail.net ([216.154.195.49]:49180 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab0IBSqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 14:46:37 -0400
Subject: [PATCH] i915: revert some checks added by commit 32aad86f
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 02 Sep 2010 14:46:34 -0400
Message-ID: <20100902184634.18566.78849.stgit@mj.roinet.com>
User-Agent: StGit/0.15-97-g9680
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes blur-like screen corruption on the following card:

VGA compatible controller [0300]: Intel Corporation 82G33/G31 Express
Integrated Graphics Controller [8086:29c2] (rev 10)

intel_sdvo_mode_set() should not return prematurely just because some
features are not supported.

https://bugzilla.kernel.org/show_bug.cgi?id=17151

Signed-off-by: Pavel Roskin <proski@gnu.org>
Reported-by: Jonathan Corbet <corbet@lwn.net>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/intel_sdvo.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 093e914..1640e49d 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1108,10 +1108,9 @@ static void intel_sdvo_mode_set(struct drm_encoder *encoder,
 	in_out.in0 = intel_sdvo->attached_output;
 	in_out.in1 = 0;
 
-	if (!intel_sdvo_set_value(intel_sdvo,
-				  SDVO_CMD_SET_IN_OUT_MAP,
-				  &in_out, sizeof(in_out)))
-		return;
+	intel_sdvo_set_value(intel_sdvo,
+			     SDVO_CMD_SET_IN_OUT_MAP,
+			     &in_out, sizeof(in_out));
 
 	if (intel_sdvo->is_hdmi) {
 		if (!intel_sdvo_set_avi_infoframe(intel_sdvo, mode))
@@ -1137,8 +1136,7 @@ static void intel_sdvo_mode_set(struct drm_encoder *encoder,
 						  intel_sdvo->attached_output))
 			return;
 
-		if (!intel_sdvo_set_output_timing(intel_sdvo, &input_dtd))
-			return;
+		intel_sdvo_set_output_timing(intel_sdvo, &input_dtd);
 	}
 
 	/* Set the input timing to the screen. Assume always input 0. */
@@ -1165,8 +1163,7 @@ static void intel_sdvo_mode_set(struct drm_encoder *encoder,
 		intel_sdvo_set_input_timing(encoder, &input_dtd);
 	}
 #else
-	if (!intel_sdvo_set_input_timing(intel_sdvo, &input_dtd))
-		return;
+	intel_sdvo_set_input_timing(intel_sdvo, &input_dtd);
 #endif
 
 	sdvo_pixel_multiply = intel_sdvo_get_pixel_multiplier(mode);
