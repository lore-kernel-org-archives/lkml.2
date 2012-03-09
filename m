Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab2CIS4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:56:31 -0500
Received: from mail-bk0-f74.google.com ([209.85.214.74]:62435 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab2CIS43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:56:29 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 07/10 v2] drm/i915/intel_i2c: use WAIT cycle, not STOP
Date: Sat, 10 Mar 2012 02:48:21 +0800
Message-Id: <1331318904-20577-8-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331318904-20577-1-git-send-email-djkurtz@chromium.org>
References: <1331318904-20577-1-git-send-email-djkurtz@chromium.org>
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
 drivers/gpu/drm/i915/intel_i2c.c |   42 +++++++++++++++++++++++++------------
 1 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 151b828..b79a181 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -260,7 +260,7 @@ gmbus_xfer(struct i2c_adapter *adapter,
 
 		if (msgs[i].flags & I2C_M_RD) {
 			I915_WRITE(GMBUS1 + reg_offset,
-				   GMBUS_CYCLE_WAIT | (i + 1 == num ? GMBUS_CYCLE_STOP : 0) |
+				   GMBUS_CYCLE_WAIT |
 				   (len << GMBUS_BYTE_COUNT_SHIFT) |
 				   (msgs[i].addr << GMBUS_SLAVE_ADDR_SHIFT) |
 				   GMBUS_SLAVE_READ | GMBUS_SW_RDY);
@@ -272,7 +272,8 @@ gmbus_xfer(struct i2c_adapter *adapter,
 					     (GMBUS_SATOER | GMBUS_HW_RDY),
 					     50))
 					goto timeout;
-				if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
+				if (I915_READ(GMBUS2 + reg_offset) &
+				    GMBUS_SATOER)
 					goto clear_err;
 
 				val = I915_READ(GMBUS3 + reg_offset);
@@ -291,20 +292,13 @@ gmbus_xfer(struct i2c_adapter *adapter,
 
 			I915_WRITE(GMBUS3 + reg_offset, val);
 			I915_WRITE(GMBUS1 + reg_offset,
-				   (i + 1 == num ? GMBUS_CYCLE_STOP : GMBUS_CYCLE_WAIT) |
+				   GMBUS_CYCLE_WAIT |
 				   (msgs[i].len << GMBUS_BYTE_COUNT_SHIFT) |
 				   (msgs[i].addr << GMBUS_SLAVE_ADDR_SHIFT) |
 				   GMBUS_SLAVE_WRITE | GMBUS_SW_RDY);
 			POSTING_READ(GMBUS2 + reg_offset);
 
 			while (len) {
-				if (wait_for(I915_READ(GMBUS2 + reg_offset) &
-					     (GMBUS_SATOER | GMBUS_HW_RDY),
-					     50))
-					goto timeout;
-				if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
-					goto clear_err;
-
 				val = loop = 0;
 				do {
 					val |= *buf++ << (8 * loop);
@@ -312,11 +306,18 @@ gmbus_xfer(struct i2c_adapter *adapter,
 
 				I915_WRITE(GMBUS3 + reg_offset, val);
 				POSTING_READ(GMBUS2 + reg_offset);
+
+				if (wait_for(I915_READ(GMBUS2 + reg_offset) &
+					     (GMBUS_SATOER | GMBUS_HW_RDY),
+					     50))
+					goto timeout;
+				if (I915_READ(GMBUS2 + reg_offset) &
+					      GMBUS_SATOER)
+					goto clear_err;
 			}
 		}
 
-		if (i + 1 < num &&
-		    wait_for(I915_READ(GMBUS2 + reg_offset) &
+		if (wait_for(I915_READ(GMBUS2 + reg_offset) &
 			     (GMBUS_SATOER | GMBUS_HW_WAIT_PHASE),
 			     50))
 			goto timeout;
@@ -344,9 +345,22 @@ clear_err:
 	ret = -ENXIO;
 
 done:
-	/* Mark the GMBUS interface as disabled. We will re-enable it at the
-	 * start of the next xfer, till then let it sleep.
+	if (I915_READ(GMBUS2 + reg_offset) & GMBUS_HW_WAIT_PHASE) {
+		I915_WRITE(GMBUS1 + reg_offset,
+			   GMBUS_CYCLE_STOP | GMBUS_SW_RDY);
+		POSTING_READ(GMBUS2 + reg_offset);
+	}
+
+	/* Mark the GMBUS interface as disabled after waiting for idle.
+	 * We will re-enable it at the start of the next xfer,
+	 * till then let it sleep.
 	 */
+	if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) == 0,
+		     10)) {
+		DRM_INFO("GMBUS [%s] timed out waiting for IDLE\n",
+			 adapter->name);
+		ret = -ETIMEDOUT;
+	}
 	I915_WRITE(GMBUS0 + reg_offset, 0);
 
 	mutex_unlock(&dev_priv->gmbus_mutex);
-- 
1.7.7.3

