Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab2EIF6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:58:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39128 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756587Ab2EIFxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:47 -0400
Message-Id: <20120509055044.770648857@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kenneth Graunke <kenneth@whitecape.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Eric Anholt <eric@anholt.net>,
        Keith Packard <keithp@keithp.com>
Subject: [ 109/167] [PATCH] drm/i915: Force sync command ordering (Gen6+)
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

commit 84f9f938be4156e4baea466688bd6abae1c9e6ba upstream.

The docs say this is required for Gen7, and since the bit was added for
Gen6, we are also setting it there pit pf paranoia. Particularly as
Chris points out, if PIPE_CONTROL counts as a 3d state packet.

This was found through doc inspection by Ken and applies to Gen6+;

Reported-by: Kenneth Graunke <kenneth@whitecape.org>
Signed-off-by: Ben Widawsky <ben@bwidawsk.net>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    9 +++++++--
 drivers/gpu/drm/i915/i915_reg.h            |    1 +
 drivers/gpu/drm/i915/intel_ringbuffer.c    |    5 +++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 68e5b41..11545ff 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -984,6 +984,7 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 	struct intel_ring_buffer *ring;
 	u32 exec_start, exec_len;
 	u32 seqno;
+	u32 mask;
 	int ret, mode, i;
 
 	if (!i915_gem_check_execbuffer(args)) {
@@ -1021,6 +1022,7 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 	}
 
 	mode = args->flags & I915_EXEC_CONSTANTS_MASK;
+	mask = I915_EXEC_CONSTANTS_MASK;
 	switch (mode) {
 	case I915_EXEC_CONSTANTS_REL_GENERAL:
 	case I915_EXEC_CONSTANTS_ABSOLUTE:
@@ -1033,6 +1035,10 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 			if (INTEL_INFO(dev)->gen > 5 &&
 			    mode == I915_EXEC_CONSTANTS_REL_SURFACE)
 				return -EINVAL;
+
+			/* The HW changed the meaning on this bit on gen6 */
+			if (INTEL_INFO(dev)->gen >= 6)
+				mask &= ~I915_EXEC_CONSTANTS_REL_SURFACE;
 		}
 		break;
 	default:
@@ -1172,8 +1178,7 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 		intel_ring_emit(ring, MI_NOOP);
 		intel_ring_emit(ring, MI_LOAD_REGISTER_IMM(1));
 		intel_ring_emit(ring, INSTPM);
-		intel_ring_emit(ring,
-				I915_EXEC_CONSTANTS_MASK << 16 | mode);
+		intel_ring_emit(ring, mask << 16 | mode);
 		intel_ring_advance(ring);
 
 		dev_priv->relative_constants_mode = mode;
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 194d987..3ae2c7c 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -442,6 +442,7 @@
 #define   INSTPM_AGPBUSY_DIS (1<<11) /* gen3: when disabled, pending interrupts
 					will not assert AGPBUSY# and will only
 					be delivered when out of C3. */
+#define   INSTPM_FORCE_ORDERING				(1<<7) /* GEN6+ */
 #define ACTHD	        0x020c8
 #define FW_BLC		0x020d8
 #define FW_BLC2		0x020dc
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index ca70e2f..f5dae5de 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -414,6 +414,11 @@ static int init_render_ring(struct intel_ring_buffer *ring)
 			return ret;
 	}
 
+	if (INTEL_INFO(dev)->gen >= 6) {
+		I915_WRITE(INSTPM,
+			   INSTPM_FORCE_ORDERING << 16 | INSTPM_FORCE_ORDERING);
+	}
+
 	return ret;
 }
 
-- 
1.7.10



