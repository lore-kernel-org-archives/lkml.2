Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab2BIW1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:27:14 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:43809 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758623Ab2BIWWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:22:42 -0500
MIME-Version: 1.0
From: Yufeng Shen <miletus@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, Yufeng Shen <miletus@chromium.org>
Subject: [PATCH] drm/i915: Fix race condition in accessing GMBUS
Date: Thu,  9 Feb 2012 17:14:57 -0500
Message-Id: <1328825697-23685-1-git-send-email-miletus@chromium.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GMBUS has several ports and each has it's own corresponding
I2C adpater. When multiple I2C adapters call gmbus_xfer() at
the same time there is a race condition in using the underlying
GMBUS controller. Fixing this by adding a mutex lock when calling
gmbus_xfer().

Signed-off-by: Yufeng Shen <miletus@chromium.org>
---
 drivers/gpu/drm/i915/i915_drv.h  |    2 ++
 drivers/gpu/drm/i915/intel_i2c.c |   21 ++++++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 9689ca3..d0f826e 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -733,6 +733,8 @@ typedef struct drm_i915_private {
 	u8 corr;
 	spinlock_t *mchdev_lock;
 
+	struct mutex gmbus_mutex;
+
 	enum no_fbc_reason no_fbc_reason;
 
 	struct drm_mm_node *compressed_fb;
diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index d30cccc..24fafdc 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -233,11 +233,16 @@ gmbus_xfer(struct i2c_adapter *adapter,
 					       struct intel_gmbus,
 					       adapter);
 	struct drm_i915_private *dev_priv = adapter->algo_data;
-	int i, reg_offset;
+	int i, reg_offset, ret;
 
-	if (bus->force_bit)
-		return intel_i2c_quirk_xfer(dev_priv,
+	mutex_lock(&dev_priv->gmbus_mutex);
+
+	if (bus->force_bit) {
+		ret = intel_i2c_quirk_xfer(dev_priv,
 					    bus->force_bit, msgs, num);
+		mutex_unlock(&dev_priv->gmbus_mutex);
+		return ret;
+	}
 
 	reg_offset = HAS_PCH_SPLIT(dev_priv->dev) ? PCH_GMBUS0 - GMBUS0 : 0;
 
@@ -321,6 +326,7 @@ done:
 	 * start of the next xfer, till then let it sleep.
 	 */
 	I915_WRITE(GMBUS0 + reg_offset, 0);
+	mutex_unlock(&dev_priv->gmbus_mutex);
 	return i;
 
 timeout:
@@ -331,9 +337,12 @@ timeout:
 	/* Hardware may not support GMBUS over these pins? Try GPIO bitbanging instead. */
 	bus->force_bit = intel_gpio_create(dev_priv, bus->reg0 & 0xff);
 	if (!bus->force_bit)
-		return -ENOMEM;
+		ret = -ENOMEM;
+	else
+		ret = intel_i2c_quirk_xfer(dev_priv, bus->force_bit, msgs, num);
 
-	return intel_i2c_quirk_xfer(dev_priv, bus->force_bit, msgs, num);
+	mutex_unlock(&dev_priv->gmbus_mutex);
+	return ret;
 }
 
 static u32 gmbus_func(struct i2c_adapter *adapter)
@@ -380,6 +389,8 @@ int intel_setup_gmbus(struct drm_device *dev)
 	if (dev_priv->gmbus == NULL)
 		return -ENOMEM;
 
+	mutex_init(&dev_priv->gmbus_mutex);
+
 	for (i = 0; i < GMBUS_NUM_PORTS; i++) {
 		struct intel_gmbus *bus = &dev_priv->gmbus[i];
 
-- 
1.7.3.1

