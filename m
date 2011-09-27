Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1I0GML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:12:11 -0400
Received: from home.keithp.com ([63.227.221.253]:55071 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab1I0GMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:12:07 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 9/9] drm/i915: Initialize PCH refclks at modeset init time
Date: Mon, 26 Sep 2011 23:11:46 -0700
Message-Id: <1317103906-4649-10-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317103906-4649-1-git-send-email-keithp@keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com>
 <1317103906-4649-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reference clock configuration must be done before any mode setting
can occur as all outputs must be disabled to change
anything. Initialize the clocks after turning everything off during
the initialization process.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_display.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 919db79..1cc0962 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5109,7 +5109,10 @@ static int i9xx_crtc_mode_set(struct drm_crtc *crtc,
 	return ret;
 }
 
-static void ironlake_update_pch_refclk(struct drm_device *dev)
+/*
+ * Initialize reference clocks when the driver loads
+ */
+static void ironlake_init_pch_refclk(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_mode_config *mode_config = &dev->mode_config;
@@ -5401,8 +5404,6 @@ static int ironlake_crtc_mode_set(struct drm_crtc *crtc,
 	ironlake_compute_m_n(intel_crtc->bpp, lane, target_clock, link_bw,
 			     &m_n);
 
-	ironlake_update_pch_refclk(dev);
-
 	fp = clock.n << 16 | clock.m1 << 8 | clock.m2;
 	if (has_reduced_clock)
 		fp2 = reduced_clock.n << 16 | reduced_clock.m1 << 8 |
@@ -7274,6 +7275,9 @@ static void intel_setup_outputs(struct drm_device *dev)
 
 	/* disable all the possible outputs/crtcs before entering KMS mode */
 	drm_helper_disable_unused_functions(dev);
+
+	if (HAS_PCH_SPLIT(dev))
+		ironlake_init_pch_refclk(dev);
 }
 
 static void intel_user_framebuffer_destroy(struct drm_framebuffer *fb)
-- 
1.7.6.3

