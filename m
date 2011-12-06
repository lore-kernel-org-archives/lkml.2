Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab1LFLOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:14:34 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45105 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153Ab1LFLOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:14:33 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH] drm/i915: fix infinite recursion on unbind due to ilk vt-d w/a
Date: Tue,  6 Dec 2011 12:12:33 +0100
Message-Id: <1323169953-7697-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recursion loop goes retire_requests->unbind->gpu_idle->retire_reqeusts.

Every time we go through this we need a
- active object that can be retired
- and there are no other references to that object than the one from
  the active list, so that it gets unbound and freed immediately.
Otherwise the recursion stops. So the recursion is only limited by the
number of objects that fit these requirements sitting in the active list
any time retire_request is called.

Issue exercised by tests/gem_unref_active_buffers from i-g-t.

There's been a decent bikeshed discussion whether it wouldn't be
better to pass around a flag, but imo this is o.k. for such a limited
case that only supports a w/a.

Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Chris Wilson <chris@chris-wilson> # we built better
	bikesheds, but this keeps the rain off for now
---
 drivers/gpu/drm/i915/i915_gem.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 036bc58..d7d5801 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2026,8 +2026,13 @@ i915_wait_request(struct intel_ring_buffer *ring,
 	 * to handle this, the waiter on a request often wants an associated
 	 * buffer to have made it to the inactive list, and we would need
 	 * a separate wait queue to handle that.
+	 *
+	 * To avoid a recursion with the ilk VT-d workaround (that calls
+	 * gpu_idle when unbinding objects with interruptible==false) don't
+	 * retire requests in that case (because it might call unbind if the
+	 * active list holds the last reference to the object).
 	 */
-	if (ret == 0)
+	if (ret == 0 && dev_priv->mm.interruptible)
 		i915_gem_retire_requests_ring(ring);
 
 	return ret;
-- 
1.7.6.4

