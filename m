Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab0HEOks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:40:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:41637 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933399Ab0HEOka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:40:30 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 6/9] drm/i915: use new fb debug hooks
Date: Thu,  5 Aug 2010 09:39:55 -0500
Message-Id: <1281019198-6777-7-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019198-6777-6-git-send-email-jason.wessel@windriver.com>
References: <1281019198-6777-1-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-2-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-3-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-4-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-5-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-6-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:40:08.0842 (UTC) FILETIME=[1A2DCEA0:01CB34AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Barnes <jbarnes@virtuousgeek.org>

Implement atomic kernel mode settings using the fb layer's debug hook
system for supporting debugger interaction.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/gpu/drm/i915/intel_display.c |   98 +++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/i915/intel_fb.c      |    2 +
 2 files changed, 99 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 5e21b31..eff28e5 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -975,7 +975,10 @@ void
 intel_wait_for_vblank(struct drm_device *dev)
 {
 	/* Wait for 20ms, i.e. one cycle at 50hz. */
-	msleep(20);
+	if (in_dbg_master())
+		mdelay(20); /* The kernel debugger cannot call msleep() */
+	else
+		msleep(20);
 }
 
 /* Parameters have changed, update FBC info */
@@ -1314,6 +1317,98 @@ intel_pin_and_fence_fb_obj(struct drm_device *dev, struct drm_gem_object *obj)
 	return 0;
 }
 
+/* Assume fb object is pinned & idle & fenced and just update base pointers */
+static int
+intel_pipe_set_base_atomic(struct drm_crtc *crtc, struct drm_framebuffer *fb,
+			   int x, int y)
+{
+	struct drm_device *dev = crtc->dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
+	struct intel_framebuffer *intel_fb;
+	struct drm_i915_gem_object *obj_priv;
+	struct drm_gem_object *obj;
+	int plane = intel_crtc->plane;
+	unsigned long Start, Offset;
+	int dspbase = (plane == 0 ? DSPAADDR : DSPBADDR);
+	int dspsurf = (plane == 0 ? DSPASURF : DSPBSURF);
+	int dspstride = (plane == 0) ? DSPASTRIDE : DSPBSTRIDE;
+	int dsptileoff = (plane == 0 ? DSPATILEOFF : DSPBTILEOFF);
+	int dspcntr_reg = (plane == 0) ? DSPACNTR : DSPBCNTR;
+	u32 dspcntr;
+
+	switch (plane) {
+	case 0:
+	case 1:
+		break;
+	default:
+		DRM_ERROR("Can't update plane %d in SAREA\n", plane);
+		return -EINVAL;
+	}
+
+	intel_fb = to_intel_framebuffer(fb);
+	obj = intel_fb->obj;
+	obj_priv = to_intel_bo(obj);
+
+	dspcntr = I915_READ(dspcntr_reg);
+	/* Mask out pixel format bits in case we change it */
+	dspcntr &= ~DISPPLANE_PIXFORMAT_MASK;
+	switch (fb->bits_per_pixel) {
+	case 8:
+		dspcntr |= DISPPLANE_8BPP;
+		break;
+	case 16:
+		if (fb->depth == 15)
+			dspcntr |= DISPPLANE_15_16BPP;
+		else
+			dspcntr |= DISPPLANE_16BPP;
+		break;
+	case 24:
+	case 32:
+		dspcntr |= DISPPLANE_32BPP_NO_ALPHA;
+		break;
+	default:
+		DRM_ERROR("Unknown color depth\n");
+		return -EINVAL;
+	}
+	if (IS_I965G(dev)) {
+		if (obj_priv->tiling_mode != I915_TILING_NONE)
+			dspcntr |= DISPPLANE_TILED;
+		else
+			dspcntr &= ~DISPPLANE_TILED;
+	}
+
+	if (IS_IRONLAKE(dev))
+		/* must disable */
+		dspcntr |= DISPPLANE_TRICKLE_FEED_DISABLE;
+
+	I915_WRITE(dspcntr_reg, dspcntr);
+
+	Start = obj_priv->gtt_offset;
+	Offset = y * fb->pitch + x * (fb->bits_per_pixel / 8);
+
+	DRM_DEBUG("Writing base %08lX %08lX %d %d\n", Start, Offset, x, y);
+	I915_WRITE(dspstride, fb->pitch);
+	if (IS_I965G(dev)) {
+		I915_WRITE(dspbase, Offset);
+		I915_READ(dspbase);
+		I915_WRITE(dspsurf, Start);
+		I915_READ(dspsurf);
+		I915_WRITE(dsptileoff, (y << 16) | x);
+	} else {
+		I915_WRITE(dspbase, Start + Offset);
+		I915_READ(dspbase);
+	}
+
+	if ((IS_I965G(dev) || plane == 0))
+		intel_update_fbc(crtc, &crtc->mode);
+
+	intel_wait_for_vblank(dev);
+	intel_increase_pllclock(crtc, true);
+
+	return 0;
+}
+
 static int
 intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 		    struct drm_framebuffer *old_fb)
@@ -4814,6 +4909,7 @@ static const struct drm_crtc_helper_funcs intel_helper_funcs = {
 	.mode_fixup = intel_crtc_mode_fixup,
 	.mode_set = intel_crtc_mode_set,
 	.mode_set_base = intel_pipe_set_base,
+	.mode_set_base_atomic = intel_pipe_set_base_atomic,
 	.prepare = intel_crtc_prepare,
 	.commit = intel_crtc_commit,
 	.load_lut = intel_crtc_load_lut,
diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index 3e18c9e..54acd8b 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -61,6 +61,8 @@ static struct fb_ops intelfb_ops = {
 	.fb_pan_display = drm_fb_helper_pan_display,
 	.fb_blank = drm_fb_helper_blank,
 	.fb_setcmap = drm_fb_helper_setcmap,
+	.fb_debug_enter = drm_fb_helper_debug_enter,
+	.fb_debug_leave = drm_fb_helper_debug_leave,
 };
 
 static int intelfb_create(struct intel_fbdev *ifbdev,
-- 
1.6.4.rc1

