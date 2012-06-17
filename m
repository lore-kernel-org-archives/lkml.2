Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab2FQSWg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:22:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50080 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757849Ab2FQSWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:02 -0400
Message-Id: <20120617175941.782602149@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 18:59:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 03/69] drm/i915: Unpin the flip target if we fail to queue the flip
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 83d4092b0381e5dd6f312b2ec57121dcf0fcbade upstream.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2:
 - adjust context
 - we don't have intel_unpin_fb_obj(); use i915_gem_object_unpin()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |   50 ++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7009,14 +7009,14 @@
 
 	ret = intel_pin_and_fence_fb_obj(dev, obj, LP_RING(dev_priv));
 	if (ret)
-		goto out;
+		goto err;
 
 	/* Offset into the new buffer for cases of shared fbs between CRTCs */
 	offset = crtc->y * fb->pitch + crtc->x * fb->bits_per_pixel/8;
 
 	ret = BEGIN_LP_RING(6);
 	if (ret)
-		goto out;
+		goto err_unpin;
 
 	/* Can't queue multiple flips, so wait for the previous
 	 * one to finish before executing the next.
@@ -7033,7 +7033,11 @@
 	OUT_RING(obj->gtt_offset + offset);
 	OUT_RING(MI_NOOP);
 	ADVANCE_LP_RING();
-out:
+	return 0;
+
+err_unpin:
+	i915_gem_object_unpin(obj);
+err:
 	return ret;
 }
 
@@ -7050,14 +7054,14 @@
 
 	ret = intel_pin_and_fence_fb_obj(dev, obj, LP_RING(dev_priv));
 	if (ret)
-		goto out;
+		goto err;
 
 	/* Offset into the new buffer for cases of shared fbs between CRTCs */
 	offset = crtc->y * fb->pitch + crtc->x * fb->bits_per_pixel/8;
 
 	ret = BEGIN_LP_RING(6);
 	if (ret)
-		goto out;
+		goto err_unpin;
 
 	if (intel_crtc->plane)
 		flip_mask = MI_WAIT_FOR_PLANE_B_FLIP;
@@ -7072,7 +7076,11 @@
 	OUT_RING(MI_NOOP);
 
 	ADVANCE_LP_RING();
-out:
+	return 0;
+
+err_unpin:
+	i915_gem_object_unpin(obj);
+err:
 	return ret;
 }
 
@@ -7088,11 +7096,11 @@
 
 	ret = intel_pin_and_fence_fb_obj(dev, obj, LP_RING(dev_priv));
 	if (ret)
-		goto out;
+		goto err;
 
 	ret = BEGIN_LP_RING(4);
 	if (ret)
-		goto out;
+		goto err_unpin;
 
 	/* i965+ uses the linear or tiled offsets from the
 	 * Display Registers (which do not change across a page-flip)
@@ -7111,7 +7119,11 @@
 	pipesrc = I915_READ(PIPESRC(intel_crtc->pipe)) & 0x0fff0fff;
 	OUT_RING(pf | pipesrc);
 	ADVANCE_LP_RING();
-out:
+	return 0;
+
+err_unpin:
+	i915_gem_object_unpin(obj);
+err:
 	return ret;
 }
 
@@ -7127,11 +7139,11 @@
 
 	ret = intel_pin_and_fence_fb_obj(dev, obj, LP_RING(dev_priv));
 	if (ret)
-		goto out;
+		goto err;
 
 	ret = BEGIN_LP_RING(4);
 	if (ret)
-		goto out;
+		goto err_unpin;
 
 	OUT_RING(MI_DISPLAY_FLIP |
 		 MI_DISPLAY_FLIP_PLANE(intel_crtc->plane));
@@ -7142,7 +7154,11 @@
 	pipesrc = I915_READ(PIPESRC(intel_crtc->pipe)) & 0x0fff0fff;
 	OUT_RING(pf | pipesrc);
 	ADVANCE_LP_RING();
-out:
+	return 0;
+
+err_unpin:
+	i915_gem_object_unpin(obj);
+err:
 	return ret;
 }
 
@@ -7164,18 +7180,22 @@
 
 	ret = intel_pin_and_fence_fb_obj(dev, obj, ring);
 	if (ret)
-		goto out;
+		goto err;
 
 	ret = intel_ring_begin(ring, 4);
 	if (ret)
-		goto out;
+		goto err_unpin;
 
 	intel_ring_emit(ring, MI_DISPLAY_FLIP_I915 | (intel_crtc->plane << 19));
 	intel_ring_emit(ring, (fb->pitch | obj->tiling_mode));
 	intel_ring_emit(ring, (obj->gtt_offset));
 	intel_ring_emit(ring, (MI_NOOP));
 	intel_ring_advance(ring);
-out:
+	return 0;
+
+err_unpin:
+	i915_gem_object_unpin(obj);
+err:
 	return ret;
 }
 


