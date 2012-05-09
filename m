Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab2EIGKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:10:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39031 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756677Ab2EIFxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:33 -0400
Message-Id: <20120509055044.638885245@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:17 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Keith Packard <keithp@keithp.com>
Subject: [ 108/167] [PATCH] drm/i915: relative_constants_mode race fix
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Widawsky <ben@bwidawsk.net>

commit e2971bdab2b761683353da383c0fd5ac704d1cca upstream.

dev_priv keeps track of the current addressing mode that gets set at
execbuffer time. Unfortunately the existing code was doing this before
acquiring struct_mutex which leaves a race with another thread also
doing an execbuffer. If that wasn't bad enough, relocate_slow drops
struct_mutex which opens a much more likely error where another thread
comes in and modifies the state while relocate_slow is being slow.

The solution here is to just defer setting this state until we
absolutely need it, and we know we'll have struct_mutex for the
remainder of our code path.

v2: Keith noticed a bug in the original patch.

Signed-off-by: Ben Widawsky <ben@bwidawsk.net>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   29 +++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index c681dc1..68e5b41 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -1033,19 +1033,6 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 			if (INTEL_INFO(dev)->gen > 5 &&
 			    mode == I915_EXEC_CONSTANTS_REL_SURFACE)
 				return -EINVAL;
-
-			ret = intel_ring_begin(ring, 4);
-			if (ret)
-				return ret;
-
-			intel_ring_emit(ring, MI_NOOP);
-			intel_ring_emit(ring, MI_LOAD_REGISTER_IMM(1));
-			intel_ring_emit(ring, INSTPM);
-			intel_ring_emit(ring,
-					I915_EXEC_CONSTANTS_MASK << 16 | mode);
-			intel_ring_advance(ring);
-
-			dev_priv->relative_constants_mode = mode;
 		}
 		break;
 	default:
@@ -1176,6 +1163,22 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 		}
 	}
 
+	if (ring == &dev_priv->ring[RCS] &&
+	    mode != dev_priv->relative_constants_mode) {
+		ret = intel_ring_begin(ring, 4);
+		if (ret)
+				goto err;
+
+		intel_ring_emit(ring, MI_NOOP);
+		intel_ring_emit(ring, MI_LOAD_REGISTER_IMM(1));
+		intel_ring_emit(ring, INSTPM);
+		intel_ring_emit(ring,
+				I915_EXEC_CONSTANTS_MASK << 16 | mode);
+		intel_ring_advance(ring);
+
+		dev_priv->relative_constants_mode = mode;
+	}
+
 	trace_i915_gem_ring_dispatch(ring, seqno);
 
 	exec_start = batch_obj->gtt_offset + args->batch_start_offset;
-- 
1.7.10



