Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741Ab1LPXcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 18:32:53 -0500
Received: from home.keithp.com ([63.227.221.253]:36335 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab1LPXcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 18:32:45 -0500
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>, Daniel Vetter <daniel@ffwll.ch>
Subject: [PATCH] Revert "drm/i915: fix infinite recursion on unbind due to ilk vt-d w/a"
Date: Fri, 16 Dec 2011 15:33:34 -0800
Message-Id: <1324078414-10945-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit eb1711bb94991e93669c5a1b5f84f11be2d51ea1.

This patch has been reported by two people to cause memory corruption
and application crashes. It exists solely to fix a problem with the
VT-d workarounds for Ironlake. I would back those out as well as
without this change, that work-around causes an infinite recursion for
anyone foolish enough to actually try VT-d for graphics.

So, without this patch, and when using VT-d for graphics on Ironlake,
people will experience infinite recursion crashes. With this patch, we
get memory corruption on all systems.

Cc: dri-devel@lists.freedesktop.org
Cc: Daniel Vetter <daniel@ffwll.ch>
Reported-by: Alex Villací­s Lasso <a_villacis@palosanto.com>
Reported-by: Dirk Hohndel <dirk@hohndel.org>
Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_gem.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 60ff1b6..8359dc7 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2026,13 +2026,8 @@ i915_wait_request(struct intel_ring_buffer *ring,
 	 * to handle this, the waiter on a request often wants an associated
 	 * buffer to have made it to the inactive list, and we would need
 	 * a separate wait queue to handle that.
-	 *
-	 * To avoid a recursion with the ilk VT-d workaround (that calls
-	 * gpu_idle when unbinding objects with interruptible==false) don't
-	 * retire requests in that case (because it might call unbind if the
-	 * active list holds the last reference to the object).
 	 */
-	if (ret == 0 && dev_priv->mm.interruptible)
+	if (ret == 0)
 		i915_gem_retire_requests_ring(ring);
 
 	return ret;
-- 
1.7.7.3

