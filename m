Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab2C1Mx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:53:26 -0400
Received: from mail-yw0-f74.google.com ([209.85.213.74]:34760 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab2C1MwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:52:05 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 07/14 v5] drm/i915/intel_i2c: allocate gmbus array as part of drm_i915_private
Date: Wed, 28 Mar 2012 20:51:50 +0800
Message-Id: <1332939117-6513-8-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
References: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This memory is always allocated, and it is always a fixed size, so just
allocate it along with the rest of the driver state.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_drv.h  |    2 +-
 drivers/gpu/drm/i915/intel_i2c.c |   10 ----------
 2 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index c5ad7b9..6983b4b 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -326,7 +326,7 @@ typedef struct drm_i915_private {
 	/** gt_lock is also taken in irq contexts. */
 	struct spinlock gt_lock;
 
-	struct intel_gmbus *gmbus;
+	struct intel_gmbus gmbus[GMBUS_NUM_PORTS];
 
 	/** gmbus_mutex protects against concurrent usage of the single hw gmbus
 	 * controller on different i2c buses. */
diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index dcde6f6..c12db72 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -387,11 +387,6 @@ int intel_setup_gmbus(struct drm_device *dev)
 	else
 		dev_priv->gpio_mmio_base = 0;
 
-	dev_priv->gmbus = kcalloc(GMBUS_NUM_PORTS, sizeof(struct intel_gmbus),
-				  GFP_KERNEL);
-	if (dev_priv->gmbus == NULL)
-		return -ENOMEM;
-
 	mutex_init(&dev_priv->gmbus_mutex);
 
 	for (i = 0; i < GMBUS_NUM_PORTS; i++) {
@@ -428,8 +423,6 @@ err:
 		struct intel_gmbus *bus = &dev_priv->gmbus[i];
 		i2c_del_adapter(&bus->adapter);
 	}
-	kfree(dev_priv->gmbus);
-	dev_priv->gmbus = NULL;
 	return ret;
 }
 
@@ -468,7 +461,4 @@ void intel_teardown_gmbus(struct drm_device *dev)
 		struct intel_gmbus *bus = &dev_priv->gmbus[i];
 		i2c_del_adapter(&bus->adapter);
 	}
-
-	kfree(dev_priv->gmbus);
-	dev_priv->gmbus = NULL;
 }
-- 
1.7.7.3

