Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777Ab2C1S07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:26:59 -0400
Received: from mail-wg0-f74.google.com ([74.125.82.74]:41863 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab2C1S0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:26:46 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 4/7 v6] drm/i915/intel_i2c: use WAIT cycle, not STOP
Date: Thu, 29 Mar 2012 02:26:36 +0800
Message-Id: <1332959199-32161-5-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332959199-32161-1-git-send-email-djkurtz@chromium.org>
References: <1332959199-32161-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i915 is only able to generate a STOP cycle (i.e. finalize an i2c
transaction) during a DATA or WAIT phase.  In other words, the
controller rejects a STOP requested as part of the first transaction in a
sequence.

Thus, for the first transaction we must always use a WAIT cycle, detect
when the device has finished (and is in a WAIT phase), and then either
start the next transaction, or, if there are no more transactions,
generate a STOP cycle.

Note: Theoretically, the last transaction of a multi-transaction sequence
could initiate a STOP cycle.  However, this slight optimization is left
for another patch.  We return -ETIMEDOUT if the hardware doesn't
deactivate after the STOP cycle.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 9707868..25f2c9e 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -204,8 +204,7 @@ intel_gpio_setup(struct intel_gmbus *bus, u32 pin)
 }
 
 static int
-gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
-		bool last)
+gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
 {
 	int reg_offset = dev_priv->gpio_mmio_base;
 	u16 len = msg->len;
@@ -213,7 +212,6 @@ gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
 
 	I915_WRITE(GMBUS1 + reg_offset,
 		   GMBUS_CYCLE_WAIT |
-		   (last ? GMBUS_CYCLE_STOP : 0) |
 		   (len << GMBUS_BYTE_COUNT_SHIFT) |
 		   (msg->addr << GMBUS_SLAVE_ADDR_SHIFT) |
 		   GMBUS_SLAVE_READ | GMBUS_SW_RDY);
@@ -239,8 +237,7 @@ gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
 }
 
 static int
-gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
-		bool last)
+gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
 {
 	int reg_offset = dev_priv->gpio_mmio_base;
 	u16 len = msg->len;
@@ -256,7 +253,6 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
 	I915_WRITE(GMBUS3 + reg_offset, val);
 	I915_WRITE(GMBUS1 + reg_offset,
 		   GMBUS_CYCLE_WAIT |
-		   (last ? GMBUS_CYCLE_STOP : 0) |
 		   (msg->len << GMBUS_BYTE_COUNT_SHIFT) |
 		   (msg->addr << GMBUS_SLAVE_ADDR_SHIFT) |
 		   GMBUS_SLAVE_WRITE | GMBUS_SW_RDY);
@@ -289,7 +285,8 @@ gmbus_xfer(struct i2c_adapter *adapter,
 					       struct intel_gmbus,
 					       adapter);
 	struct drm_i915_private *dev_priv = bus->dev_priv;
-	int i, reg_offset, ret;
+	int i, reg_offset;
+	int ret = 0;
 
 	mutex_lock(&dev_priv->gmbus_mutex);
 
@@ -303,20 +300,17 @@ gmbus_xfer(struct i2c_adapter *adapter,
 	I915_WRITE(GMBUS0 + reg_offset, bus->reg0);
 
 	for (i = 0; i < num; i++) {
-		bool last = i + 1 == num;
-
 		if (msgs[i].flags & I2C_M_RD)
-			ret = gmbus_xfer_read(dev_priv, &msgs[i], last);
+			ret = gmbus_xfer_read(dev_priv, &msgs[i]);
 		else
-			ret = gmbus_xfer_write(dev_priv, &msgs[i], last);
+			ret = gmbus_xfer_write(dev_priv, &msgs[i]);
 
 		if (ret == -ETIMEDOUT)
 			goto timeout;
 		if (ret == -ENXIO)
 			goto clear_err;
 
-		if (!last &&
-		    wait_for(I915_READ(GMBUS2 + reg_offset) &
+		if (wait_for(I915_READ(GMBUS2 + reg_offset) &
 			     (GMBUS_SATOER | GMBUS_HW_WAIT_PHASE),
 			     50))
 			goto timeout;
@@ -324,15 +318,21 @@ gmbus_xfer(struct i2c_adapter *adapter,
 			goto clear_err;
 	}
 
+	/* Generate a STOP condition on the bus */
+	I915_WRITE(GMBUS1 + reg_offset, GMBUS_CYCLE_STOP | GMBUS_SW_RDY);
+
 	/* Mark the GMBUS interface as disabled after waiting for idle.
 	 * We will re-enable it at the start of the next xfer,
 	 * till then let it sleep.
 	 */
-	if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) == 0, 10))
+	if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) == 0,
+		     10)) {
 		DRM_INFO("GMBUS [%s] timed out waiting for idle\n",
 			 adapter->name);
+		ret = -ETIMEDOUT;
+	}
 	I915_WRITE(GMBUS0 + reg_offset, 0);
-	ret = i;
+	ret = ret ?: i;
 	goto out;
 
 clear_err:
-- 
1.7.7.3

