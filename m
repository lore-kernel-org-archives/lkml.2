Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab2BMWfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 17:35:39 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:36780 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2BMWfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 17:35:37 -0500
MIME-Version: 1.0
From: y@google.com
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Ben Widawsky <ben@bwidawsk.net>, Yufeng Shen <miletus@chromium.org>
Subject: [PATCH] drm/i915: Fix race condition in accessing GMBUS
Date: Mon, 13 Feb 2012 17:35:33 -0500
Message-Id: <4f399036.091c0e0a.2a24.2301SMTPIN_ADDED@gmr-mx.google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1328825697-23685-1-git-send-email-miletus@chromium.org>
References: <1328825697-23685-1-git-send-email-miletus@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yufeng Shen <miletus@chromium.org>

Moved gmbus_mutex below intel_gmbus and added comments.
Rebased to drm-intel-next-queued.

----------------------------------------------------------------

GMBUS has several ports and each has it's own corresponding
I2C adpater. When multiple I2C adapters call gmbus_xfer() at
the same time there is a race condition in using the underlying
GMBUS controller. Fixing this by adding a mutex lock when calling
gmbus_xfer().

Signed-off-by: Yufeng Shen <miletus@chromium.org>
---
 drivers/gpu/drm/i915/i915_drv.h  |    8 ++++++++
 drivers/gpu/drm/i915/intel_i2c.c |   24 +++++++++++++++++-------
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 563d24e..40027de 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -313,6 +313,14 @@ typedef struct drm_i915_private {
 		u32 reg0;
 	} *gmbus;
 
+	/** Multiple intel_gmbus i2c adapters are actually sharing the same
+	underlying GMBUS controller. i2c core protects concurrent use of
+	the same i2c adapter but is not aware of the concurrent use of the
+	underlying GMBUS controller. gmbus_mutex is used to prevent the race
+	condition from the perspective of GMBUS controller.
+	*/
+	struct mutex gmbus_mutex;
+
 	struct pci_dev *bridge_dev;
 	struct intel_ring_buffer ring[I915_NUM_RINGS];
 	uint32_t next_seqno;
diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index d30cccc..fc75d71 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -233,11 +233,15 @@ gmbus_xfer(struct i2c_adapter *adapter,
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
+		goto out;
+	}
 
 	reg_offset = HAS_PCH_SPLIT(dev_priv->dev) ? PCH_GMBUS0 - GMBUS0 : 0;
 
@@ -321,7 +325,8 @@ done:
 	 * start of the next xfer, till then let it sleep.
 	 */
 	I915_WRITE(GMBUS0 + reg_offset, 0);
-	return i;
+	ret = i;
+	goto out;
 
 timeout:
 	DRM_INFO("GMBUS timed out, falling back to bit banging on pin %d [%s]\n",
@@ -331,9 +336,12 @@ timeout:
 	/* Hardware may not support GMBUS over these pins? Try GPIO bitbanging instead. */
 	bus->force_bit = intel_gpio_create(dev_priv, bus->reg0 & 0xff);
 	if (!bus->force_bit)
-		return -ENOMEM;
-
-	return intel_i2c_quirk_xfer(dev_priv, bus->force_bit, msgs, num);
+		ret = -ENOMEM;
+	else
+		ret = intel_i2c_quirk_xfer(dev_priv, bus->force_bit, msgs, num);
+out:
+	mutex_unlock(&dev_priv->gmbus_mutex);
+	return ret;
 }
 
 static u32 gmbus_func(struct i2c_adapter *adapter)
@@ -380,6 +388,8 @@ int intel_setup_gmbus(struct drm_device *dev)
 	if (dev_priv->gmbus == NULL)
 		return -ENOMEM;
 
+	mutex_init(&dev_priv->gmbus_mutex);
+
 	for (i = 0; i < GMBUS_NUM_PORTS; i++) {
 		struct intel_gmbus *bus = &dev_priv->gmbus[i];
 
-- 
1.7.3.1

