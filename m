Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab2KZRCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:02:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47164 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab2KZRB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:01:58 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Adam Jackson <ajax@redhat.com>, Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 035/270] drm/i915: use adjusted_mode instead of mode for checking the 6bpc force flag
Date: Mon, 26 Nov 2012 14:55:25 -0200
Message-Id: <1353949160-26803-36-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 0c96c65b48fba3ffe9822a554cbc0cd610765cd5 upstream.

The dithering introduced in

commit 3b5c78a35cf7511c15e09a9b0ffab290a42d9bcf
Author: Adam Jackson <ajax@redhat.com>
Date:   Tue Dec 13 15:41:00 2011 -0800

    drm/i915/dp: Dither down to 6bpc if it makes the mode fit

stores the INTEL_MODE_DP_FORCE_6BPC flag in the private_flags of the
adjusted mode, while i9xx_crtc_mode_set() and ironlake_crtc_mode_set() use
the original mode, without the flag, so it would never have any
effect. However, the BPC was clamped by VBT settings, making things work by
coincidence, until that part was removed in

commit 4344b813f105a19f793f1fd93ad775b784648b95
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri Aug 10 11:10:20 2012 +0200

Use adjusted_mode instead of mode when checking for
INTEL_MODE_DP_FORCE_6BPC to make the flag have effect.

v2: Don't forget to fix this in i9xx_crtc_mode_set() also, pointed out by
Daniel both before and after sending the first patch.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=47621
CC: Adam Jackson <ajax@redhat.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Adam Jackson <ajax@redhat.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 6f0d039..0865f27 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4087,7 +4087,7 @@ static int i9xx_crtc_mode_set(struct drm_crtc *crtc,
 	/* default to 8bpc */
 	pipeconf &= ~(PIPECONF_BPP_MASK | PIPECONF_DITHER_EN);
 	if (is_dp) {
-		if (mode->private_flags & INTEL_MODE_DP_FORCE_6BPC) {
+		if (adjusted_mode->private_flags & INTEL_MODE_DP_FORCE_6BPC) {
 			pipeconf |= PIPECONF_BPP_6 |
 				    PIPECONF_DITHER_EN |
 				    PIPECONF_DITHER_TYPE_SP;
@@ -4464,7 +4464,7 @@ static int ironlake_crtc_mode_set(struct drm_crtc *crtc,
 	/* determine panel color depth */
 	temp = I915_READ(PIPECONF(pipe));
 	temp &= ~PIPE_BPC_MASK;
-	dither = intel_choose_pipe_bpp_dither(crtc, &pipe_bpp, mode);
+	dither = intel_choose_pipe_bpp_dither(crtc, &pipe_bpp, adjusted_mode);
 	switch (pipe_bpp) {
 	case 18:
 		temp |= PIPE_6BPC;
-- 
1.7.9.5

