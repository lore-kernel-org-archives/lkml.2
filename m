Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992Ab1EMALJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 20:11:09 -0400
Received: from home.keithp.com ([63.227.221.253]:39650 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932356Ab1EMALG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 20:11:06 -0400
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH 2/2] drm/i915: TVDAC_STATE_CHG does not indicate successful load-detect
Date: Thu, 12 May 2011 17:10:58 -0700
Message-Id: <1305245458-29826-2-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1305245458-29826-1-git-send-email-keithp@keithp.com>
References: <1305245458-29826-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not use this bit to indicate that load detection has completed,
instead just wait for vblank, at which point the load registers will
have been updated.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_tv.c |   40 +++++++++++++++++++-------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index 876064c..b371863 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1283,26 +1283,26 @@ intel_tv_detect_type (struct intel_tv *intel_tv,
 			      to_intel_crtc(intel_tv->base.base.crtc)->pipe);
 
 	type = -1;
-	if (wait_for((tv_dac = I915_READ(TV_DAC)) & TVDAC_STATE_CHG, 20) == 0) {
-		DRM_DEBUG_KMS("TV detected: %x, %x\n", tv_ctl, tv_dac);
-		/*
-		 *  A B C
-		 *  0 1 1 Composite
-		 *  1 0 X svideo
-		 *  0 0 0 Component
-		 */
-		if ((tv_dac & TVDAC_SENSE_MASK) == (TVDAC_B_SENSE | TVDAC_C_SENSE)) {
-			DRM_DEBUG_KMS("Detected Composite TV connection\n");
-			type = DRM_MODE_CONNECTOR_Composite;
-		} else if ((tv_dac & (TVDAC_A_SENSE|TVDAC_B_SENSE)) == TVDAC_A_SENSE) {
-			DRM_DEBUG_KMS("Detected S-Video TV connection\n");
-			type = DRM_MODE_CONNECTOR_SVIDEO;
-		} else if ((tv_dac & TVDAC_SENSE_MASK) == 0) {
-			DRM_DEBUG_KMS("Detected Component TV connection\n");
-			type = DRM_MODE_CONNECTOR_Component;
-		} else {
-			DRM_DEBUG_KMS("Unrecognised TV connection\n");
-		}
+	tv_dac = I915_READ(TV_DAC);
+	DRM_DEBUG_KMS("TV detected: %x, %x\n", tv_ctl, tv_dac);
+	/*
+	 *  A B C
+	 *  0 1 1 Composite
+	 *  1 0 X svideo
+	 *  0 0 0 Component
+	 */
+	if ((tv_dac & TVDAC_SENSE_MASK) == (TVDAC_B_SENSE | TVDAC_C_SENSE)) {
+		DRM_DEBUG_KMS("Detected Composite TV connection\n");
+		type = DRM_MODE_CONNECTOR_Composite;
+	} else if ((tv_dac & (TVDAC_A_SENSE|TVDAC_B_SENSE)) == TVDAC_A_SENSE) {
+		DRM_DEBUG_KMS("Detected S-Video TV connection\n");
+		type = DRM_MODE_CONNECTOR_SVIDEO;
+	} else if ((tv_dac & TVDAC_SENSE_MASK) == 0) {
+		DRM_DEBUG_KMS("Detected Component TV connection\n");
+		type = DRM_MODE_CONNECTOR_Component;
+	} else {
+		DRM_DEBUG_KMS("Unrecognised TV connection\n");
+		type = -1;
 	}
 
 	I915_WRITE(TV_DAC, save_tv_dac & ~TVDAC_STATE_CHG_EN);
-- 
1.7.5.1

