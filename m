Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab2CZO1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:27:34 -0400
Received: from mail-bk0-f74.google.com ([209.85.214.74]:59945 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556Ab2CZO06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:26:58 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 09/11 v3] drm/i915/intel_i2c: use WAIT cycle, not STOP
Date: Mon, 26 Mar 2012 22:26:48 +0800
Message-Id: <1332772010-19619-10-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
References: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
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

This patch also takes advantage (in the write path) of the double-buffered
GMBUS3 data register by writing two 4-byte words before the first wait for
HW_RDY.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 9d5d286..7396d6e 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -212,7 +212,8 @@ gmbus_xfer(struct i2c_adapter *adapter,
 					       struct intel_gmbus,
 					       adapter);
 	struct drm_i915_private *dev_priv = bus->dev_priv;
-	int i, reg_offset, ret;
+	int i, reg_offset;
+	int ret = 0;
 
 	mutex_lock(&dev_priv->gmbus_mutex);
 
@@ -232,7 +233,6 @@ gmbus_xfer(struct i2c_adapter *adapter,
 		if (msgs[i].flags & I2C_M_RD) {
 			I915_WRITE(GMBUS1 + reg_offset,
 				   GMBUS_CYCLE_WAIT |
-				   (i + 1 == num ? GMBUS_CYCLE_STOP : 0) |
 				   (len << GMBUS_BYTE_COUNT_SHIFT) |
 				   (msgs[i].addr << GMBUS_SLAVE_ADDR_SHIFT) |
 				   GMBUS_SLAVE_READ | GMBUS_SW_RDY);
@@ -266,21 +266,12 @@ gmbus_xfer(struct i2c_adapter *adapter,
 			I915_WRITE(GMBUS3 + reg_offset, val);
 			I915_WRITE(GMBUS1 + reg_offset,
 				   GMBUS_CYCLE_WAIT |
-				   (i + 1 == num ? GMBUS_CYCLE_STOP : 0) |
 				   (msgs[i].len << GMBUS_BYTE_COUNT_SHIFT) |
 				   (msgs[i].addr << GMBUS_SLAVE_ADDR_SHIFT) |
 				   GMBUS_SLAVE_WRITE | GMBUS_SW_RDY);
 			POSTING_READ(GMBUS2 + reg_offset);
 
 			while (len) {
-				if (wait_for(I915_READ(GMBUS2 + reg_offset) &
-					     (GMBUS_SATOER | GMBUS_HW_RDY),
-					     50))
-					goto timeout;
-				if (I915_READ(GMBUS2 + reg_offset) &
-				    GMBUS_SATOER)
-					goto clear_err;
-
 				val = loop = 0;
 				do {
 					val |= *buf++ << (8 * loop);
@@ -288,11 +279,18 @@ gmbus_xfer(struct i2c_adapter *adapter,
 
 				I915_WRITE(GMBUS3 + reg_offset, val);
 				POSTING_READ(GMBUS2 + reg_offset);
+
+				if (wait_for(I915_READ(GMBUS2 + reg_offset) &
+					     (GMBUS_SATOER | GMBUS_HW_RDY),
+					     50))
+					goto timeout;
+				if (I915_READ(GMBUS2 + reg_offset) &
+				    GMBUS_SATOER)
+					goto clear_err;
 			}
 		}
 
-		if (i + 1 < num &&
-		    wait_for(I915_READ(GMBUS2 + reg_offset) &
+		if (wait_for(I915_READ(GMBUS2 + reg_offset) &
 			     (GMBUS_SATOER | GMBUS_HW_WAIT_PHASE),
 			     50))
 			goto timeout;
@@ -300,15 +298,21 @@ gmbus_xfer(struct i2c_adapter *adapter,
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

