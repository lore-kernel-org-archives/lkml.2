Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab1ITEgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 00:36:48 -0400
Received: from home.keithp.com ([63.227.221.253]:51782 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab1ITEgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 00:36:47 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH] drm/i915: FBC off for ironlake, otherwise on by default
Date: Mon, 19 Sep 2011 21:36:36 -0700
Message-Id: <1316493396-31555-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the default FBC behaviour chipset specific, allowing us to turn
it on by default for everything except Ironlake where it has been
seen to cause trouble with screen updates.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_drv.c      |    4 ++--
 drivers/gpu/drm/i915/intel_display.c |   10 +++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index ce045a8..f07e425 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -67,11 +67,11 @@ module_param_named(i915_enable_rc6, i915_enable_rc6, int, 0600);
 MODULE_PARM_DESC(i915_enable_rc6,
 		"Enable power-saving render C-state 6 (default: true)");
 
-unsigned int i915_enable_fbc __read_mostly = 1;
+unsigned int i915_enable_fbc __read_mostly = -1;
 module_param_named(i915_enable_fbc, i915_enable_fbc, int, 0600);
 MODULE_PARM_DESC(i915_enable_fbc,
 		"Enable frame buffer compression for power savings "
-		"(default: false)");
+		"(default: -1 (use per-chip default))");
 
 unsigned int i915_lvds_downclock __read_mostly = 0;
 module_param_named(lvds_downclock, i915_lvds_downclock, int, 0400);
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 9fb4a40..bc05deb 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1799,6 +1799,7 @@ static void intel_update_fbc(struct drm_device *dev)
 	struct drm_framebuffer *fb;
 	struct intel_framebuffer *intel_fb;
 	struct drm_i915_gem_object *obj;
+	int enable_fbc;
 
 	DRM_DEBUG_KMS("\n");
 
@@ -1839,7 +1840,14 @@ static void intel_update_fbc(struct drm_device *dev)
 	intel_fb = to_intel_framebuffer(fb);
 	obj = intel_fb->obj;
 
-	if (!i915_enable_fbc) {
+	enable_fbc = i915_enable_fbc;
+	if (enable_fbc < 0) {
+		DRM_DEBUG_KMS("fbc set to per-chip default\n");
+		enable_fbc = 1;
+		if (INTEL_INFO(dev)->gen == 5)
+			enable_fbc = 0;
+	}
+	if (!enable_fbc) {
 		DRM_DEBUG_KMS("fbc disabled per module param (default off)\n");
 		dev_priv->no_fbc_reason = FBC_MODULE_PARAM;
 		goto out_disable;
-- 
1.7.6.3

