Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab1I1XPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:15:36 -0400
Received: from home.keithp.com ([63.227.221.253]:41550 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab1I1XPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 19:15:33 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 9/9] drm/i915: Initialize PCH refclks at modeset init time
Date: Wed, 28 Sep 2011 16:15:27 -0700
Message-Id: <1317251727-9320-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317103906-4649-10-git-send-email-keithp@keithp.com>
References: <1317103906-4649-10-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reference clock configuration must be done before any mode setting
can occur as all outputs must be disabled to change
anything. Initialize the clocks after turning everything off during
the initialization process.

Also, re-initialize the refclk at resume time.

Signed-off-by: Keith Packard <keithp@keithp.com>
---

v2 - re-initialize the refclk at resume time.

 drivers/gpu/drm/i915/i915_drv.c      |    3 +++
 drivers/gpu/drm/i915/i915_drv.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |   10 +++++++---
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 58480de..2b6c2d2 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -471,6 +471,9 @@ static int i915_drm_thaw(struct drm_device *dev)
 		error = i915_gem_init_ringbuffer(dev);
 		mutex_unlock(&dev->struct_mutex);
 
+		if (HAS_PCH_SPLIT(dev))
+			ironlake_init_pch_refclk(dev);
+
 		drm_mode_config_reset(dev);
 		drm_irq_install(dev);
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 18df595..98f2e0b 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1302,6 +1302,7 @@ extern int intel_modeset_vga_set_state(struct drm_device *dev, bool state);
 extern bool intel_fbc_enabled(struct drm_device *dev);
 extern void intel_disable_fbc(struct drm_device *dev);
 extern bool ironlake_set_drps(struct drm_device *dev, u8 val);
+extern void ironlake_init_pch_refclk(struct drm_device *dev);
 extern void ironlake_enable_rc6(struct drm_device *dev);
 extern void gen6_set_rps(struct drm_device *dev, u8 val);
 extern void intel_detect_pch (struct drm_device *dev);
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index b072a35..91d7d5ed 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5109,7 +5109,10 @@ static int i9xx_crtc_mode_set(struct drm_crtc *crtc,
 	return ret;
 }
 
-static void ironlake_update_pch_refclk(struct drm_device *dev)
+/*
+ * Initialize reference clocks when the driver loads
+ */
+void ironlake_init_pch_refclk(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_mode_config *mode_config = &dev->mode_config;
@@ -5411,8 +5414,6 @@ static int ironlake_crtc_mode_set(struct drm_crtc *crtc,
 	ironlake_compute_m_n(intel_crtc->bpp, lane, target_clock, link_bw,
 			     &m_n);
 
-	ironlake_update_pch_refclk(dev);
-
 	fp = clock.n << 16 | clock.m1 << 8 | clock.m2;
 	if (has_reduced_clock)
 		fp2 = reduced_clock.n << 16 | reduced_clock.m1 << 8 |
@@ -7284,6 +7285,9 @@ static void intel_setup_outputs(struct drm_device *dev)
 
 	/* disable all the possible outputs/crtcs before entering KMS mode */
 	drm_helper_disable_unused_functions(dev);
+
+	if (HAS_PCH_SPLIT(dev))
+		ironlake_init_pch_refclk(dev);
 }
 
 static void intel_user_framebuffer_destroy(struct drm_framebuffer *fb)
-- 
1.7.6.3

