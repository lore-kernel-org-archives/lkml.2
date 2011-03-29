Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab1C2MXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 08:23:16 -0400
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:61045
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753299Ab1C2MXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 08:23:15 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: intel-gfx@lists.freedesktop.org
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915: Move the irq wait queue initialisation into the ring init
Date: Tue, 29 Mar 2011 13:23:05 +0100
Message-Id: <1301401385-8935-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk>
References: <1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Required so that we don't obliterate the queue if initialising the
rings after the global IRQ handler is installed.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---

This patch is required in conjunction with the first to prevent an oops
the first time we try to use i915_wait_request (i.e. when starting X).
-Chris

---
 drivers/gpu/drm/i915/i915_irq.c         |    6 ------
 drivers/gpu/drm/i915/intel_ringbuffer.c |    1 +
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 188b497..46ccfc8 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1688,12 +1688,6 @@ int i915_driver_irq_postinstall(struct drm_device *dev)
 	u32 enable_mask = I915_INTERRUPT_ENABLE_FIX | I915_INTERRUPT_ENABLE_VAR;
 	u32 error_mask;
 
-	DRM_INIT_WAITQUEUE(&dev_priv->ring[RCS].irq_queue);
-	if (HAS_BSD(dev))
-		DRM_INIT_WAITQUEUE(&dev_priv->ring[VCS].irq_queue);
-	if (HAS_BLT(dev))
-		DRM_INIT_WAITQUEUE(&dev_priv->ring[BCS].irq_queue);
-
 	dev_priv->vblank_pipe = DRM_I915_VBLANK_PIPE_A | DRM_I915_VBLANK_PIPE_B;
 
 	if (HAS_PCH_SPLIT(dev))
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index e9e6f71..884556d 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -800,6 +800,7 @@ int intel_init_ring_buffer(struct drm_device *dev,
 	INIT_LIST_HEAD(&ring->request_list);
 	INIT_LIST_HEAD(&ring->gpu_write_list);
 
+	init_waitqueue_head(&ring->irq_queue);
 	spin_lock_init(&ring->irq_lock);
 	ring->irq_mask = ~0;
 
-- 
1.7.4.1

