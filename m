Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab2JNOlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:41:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46115 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753761Ab2JNOlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:46 -0400
Message-Id: <20121014143553.503267707@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jiri Slaby <jirislaby@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 146/147] drm/i915: Mark untiled BLT commands as fenced on gen2/3
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 7dd4906586274f3945f2aeaaa5a33b451c3b4bba upstream.

The BLT commands on gen2/3 utilize the fence registers and so we cannot
modify any fences for the object whilst those commands are in flight.
Currently we marked tiled commands as occupying a fence, but forgot to
restrict the untiled commands from preventing a fence being assigned
before they were completed.

One side-effect is that we ten have to double check that a fence was
allocated for a fenced buffer during move-to-active.

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=43427
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=47990
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Testcase: i-g-t/tests/gem_tiled_after_untiled_blt
Tested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: The nesting of if-statements in the old
 i915_gem_execbuffer_reserve() differs from pin_and_fence_object(),
 so don't move the assignment of obj->pending_fenced_gpu_access but
 adjust the boolean expression as recommended by Daniel Vetter.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_gem.c            |   15 +++++++++------
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    2 +-
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1543,16 +1543,19 @@ i915_gem_object_move_to_active(struct dr
 	list_move_tail(&obj->ring_list, &ring->active_list);
 
 	obj->last_rendering_seqno = seqno;
-	if (obj->fenced_gpu_access) {
-		struct drm_i915_fence_reg *reg;
-
-		BUG_ON(obj->fence_reg == I915_FENCE_REG_NONE);
 
+	if (obj->fenced_gpu_access) {
 		obj->last_fenced_seqno = seqno;
 		obj->last_fenced_ring = ring;
 
-		reg = &dev_priv->fence_regs[obj->fence_reg];
-		list_move_tail(&reg->lru_list, &dev_priv->mm.fence_list);
+		/* Bump MRU to take account of the delayed flush */
+		if (obj->fence_reg != I915_FENCE_REG_NONE) {
+			struct drm_i915_fence_reg *reg;
+
+			reg = &dev_priv->fence_regs[obj->fence_reg];
+			list_move_tail(&reg->lru_list,
+				       &dev_priv->mm.fence_list);
+		}
 	}
 }
 
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -574,7 +574,8 @@ i915_gem_execbuffer_reserve(struct intel
 					if (ret)
 						break;
 				}
-				obj->pending_fenced_gpu_access = need_fence;
+				obj->pending_fenced_gpu_access =
+					!!(entry->flags & EXEC_OBJECT_NEEDS_FENCE);
 			}
 
 			entry->offset = obj->gtt_offset;


