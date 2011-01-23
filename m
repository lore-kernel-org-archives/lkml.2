Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab1AWNGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 08:06:19 -0500
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:57244
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751273Ab1AWNGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 08:06:18 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915: Handle the no-interrupts case for UMS by polling
Date: Sun, 23 Jan 2011 13:06:05 +0000
Message-Id: <1295787965-6849-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <201101231128.22951.chris2553@googlemail.com>
References: <201101231128.22951.chris2553@googlemail.com>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the driver calls into the kernel to wait for a breadcrumb to pass,
but hasn't enabled interrupts, fallback to polling the breadcrumb value.

Reported-by: Chris Clayton <chris2553@googlemail.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/i915_irq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 98106b7..4b5a35c 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1293,12 +1293,12 @@ static int i915_wait_irq(struct drm_device * dev, int irq_nr)
 	if (master_priv->sarea_priv)
 		master_priv->sarea_priv->perf_boxes |= I915_BOX_WAIT;
 
-	ret = -ENODEV;
 	if (ring->irq_get(ring)) {
 		DRM_WAIT_ON(ret, ring->irq_queue, 3 * DRM_HZ,
 			    READ_BREADCRUMB(dev_priv) >= irq_nr);
 		ring->irq_put(ring);
-	}
+	} else if (wait_for(READ_BREADCRUMB(dev_priv) >= irq_nr, 3000))
+		ret = -EBUSY;
 
 	if (ret == -EBUSY) {
 		DRM_ERROR("EBUSY -- rec: %d emitted: %d\n",
-- 
1.7.2.3

