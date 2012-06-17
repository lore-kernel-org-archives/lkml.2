Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab2FQSWI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:22:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50084 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757904Ab2FQSWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:03 -0400
Message-Id: <20120617175941.924141588@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 18:59:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Subject: [ 04/69] drm/i915: fix up ivb plane 3 pageflips
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit cb05d8dedefa3066bf5d74ef88c6ca6cf4bd1c87 upstream.

Or at least plug another gapping hole. Apparrently hw desingers only
moved the bit field, but did not bother ot re-enumerate the planes
when adding support for a 3rd pipe.

Discovered by i-g-t/flip_test.

This may or may not fix the reference bugzilla, because that one
smells like we have still larger fish to fry.

v2: Fixup the impossible case to catch programming errors, noticed by
Chris Wilson.

References: https://bugs.freedesktop.org/show_bug.cgi?id=50069
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Tested-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_reg.h      |    8 ++++++++
 drivers/gpu/drm/i915/intel_display.c |   19 ++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -164,6 +164,14 @@
 #define MI_DISPLAY_FLIP		MI_INSTR(0x14, 2)
 #define MI_DISPLAY_FLIP_I915	MI_INSTR(0x14, 1)
 #define   MI_DISPLAY_FLIP_PLANE(n) ((n) << 20)
+/* IVB has funny definitions for which plane to flip. */
+#define   MI_DISPLAY_FLIP_IVB_PLANE_A  (0 << 19)
+#define   MI_DISPLAY_FLIP_IVB_PLANE_B  (1 << 19)
+#define   MI_DISPLAY_FLIP_IVB_SPRITE_A (2 << 19)
+#define   MI_DISPLAY_FLIP_IVB_SPRITE_B (3 << 19)
+#define   MI_DISPLAY_FLIP_IVB_PLANE_C  (4 << 19)
+#define   MI_DISPLAY_FLIP_IVB_SPRITE_C (5 << 19)
+
 #define MI_SET_CONTEXT		MI_INSTR(0x18, 0)
 #define   MI_MM_SPACE_GTT		(1<<8)
 #define   MI_MM_SPACE_PHYSICAL		(0<<8)
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7176,17 +7176,34 @@
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
 	struct intel_ring_buffer *ring = &dev_priv->ring[BCS];
+	uint32_t plane_bit = 0;
 	int ret;
 
 	ret = intel_pin_and_fence_fb_obj(dev, obj, ring);
 	if (ret)
 		goto err;
 
+	switch(intel_crtc->plane) {
+	case PLANE_A:
+		plane_bit = MI_DISPLAY_FLIP_IVB_PLANE_A;
+		break;
+	case PLANE_B:
+		plane_bit = MI_DISPLAY_FLIP_IVB_PLANE_B;
+		break;
+	case PLANE_C:
+		plane_bit = MI_DISPLAY_FLIP_IVB_PLANE_C;
+		break;
+	default:
+		WARN_ONCE(1, "unknown plane in flip command\n");
+		ret = -ENODEV;
+		goto err;
+	}
+
 	ret = intel_ring_begin(ring, 4);
 	if (ret)
 		goto err_unpin;
 
-	intel_ring_emit(ring, MI_DISPLAY_FLIP_I915 | (intel_crtc->plane << 19));
+	intel_ring_emit(ring, MI_DISPLAY_FLIP_I915 | plane_bit);
 	intel_ring_emit(ring, (fb->pitch | obj->tiling_mode));
 	intel_ring_emit(ring, (obj->gtt_offset));
 	intel_ring_emit(ring, (MI_NOOP));


