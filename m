Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab2C1MwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:52:12 -0400
Received: from mail-yw0-f74.google.com ([209.85.213.74]:33161 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab2C1MwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:52:05 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 01/14 v5] drm/i915/intel_i2c: refactor gmbus_xfer
Date: Wed, 28 Mar 2012 20:51:44 +0800
Message-Id: <1332939117-6513-2-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
References: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out gmbus_xfer_read/write() helper functions.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/intel_i2c.c |  151 +++++++++++++++++++++++---------------
 1 files changed, 92 insertions(+), 59 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 0713cc2..30675ce 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -198,6 +198,82 @@ intel_i2c_quirk_xfer(struct intel_gmbus *bus,
 }
 
 static int
+gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
+		bool last)
+{
+	int reg_offset = dev_priv->gpio_mmio_base;
+	u16 len = msg->len;
+	u8 *buf = msg->buf;
+
+	I915_WRITE(GMBUS1 + reg_offset,
+		   GMBUS_CYCLE_WAIT |
+		   (last ? GMBUS_CYCLE_STOP : 0) |
+		   (len << GMBUS_BYTE_COUNT_SHIFT) |
+		   (msg->addr << GMBUS_SLAVE_ADDR_SHIFT) |
+		   GMBUS_SLAVE_READ | GMBUS_SW_RDY);
+	POSTING_READ(GMBUS2 + reg_offset);
+	do {
+		u32 val, loop = 0;
+
+		if (wait_for(I915_READ(GMBUS2 + reg_offset) &
+			     (GMBUS_SATOER | GMBUS_HW_RDY),
+			     50))
+			return -ETIMEDOUT;
+		if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
+			return -ENXIO;
+
+		val = I915_READ(GMBUS3 + reg_offset);
+		do {
+			*buf++ = val & 0xff;
+			val >>= 8;
+		} while (--len && ++loop < 4);
+	} while (len);
+
+	return 0;
+}
+
+static int
+gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
+		bool last)
+{
+	int reg_offset = dev_priv->gpio_mmio_base;
+	u16 len = msg->len;
+	u8 *buf = msg->buf;
+	u32 val, loop;
+
+	val = loop = 0;
+	do {
+		val |= *buf++ << (8 * loop);
+	} while (--len && ++loop < 4);
+
+	I915_WRITE(GMBUS3 + reg_offset, val);
+	I915_WRITE(GMBUS1 + reg_offset,
+		   GMBUS_CYCLE_WAIT |
+		   (last ? GMBUS_CYCLE_STOP : 0) |
+		   (msg->len << GMBUS_BYTE_COUNT_SHIFT) |
+		   (msg->addr << GMBUS_SLAVE_ADDR_SHIFT) |
+		   GMBUS_SLAVE_WRITE | GMBUS_SW_RDY);
+	POSTING_READ(GMBUS2 + reg_offset);
+	while (len) {
+		if (wait_for(I915_READ(GMBUS2 + reg_offset) &
+			     (GMBUS_SATOER | GMBUS_HW_RDY),
+			     50))
+			return -ETIMEDOUT;
+		if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
+			return -ENXIO;
+
+		val = loop = 0;
+		do {
+			val |= *buf++ << (8 * loop);
+		} while (--len && ++loop < 4);
+
+		I915_WRITE(GMBUS3 + reg_offset, val);
+		POSTING_READ(GMBUS2 + reg_offset);
+	}
+	return 0;
+}
+
+static int
 gmbus_xfer(struct i2c_adapter *adapter,
 	   struct i2c_msg *msgs,
 	   int num)
@@ -220,65 +296,22 @@ gmbus_xfer(struct i2c_adapter *adapter,
 	I915_WRITE(GMBUS0 + reg_offset, bus->reg0);
 
 	for (i = 0; i < num; i++) {
-		u16 len = msgs[i].len;
-		u8 *buf = msgs[i].buf;
-
-		if (msgs[i].flags & I2C_M_RD) {
-			I915_WRITE(GMBUS1 + reg_offset,
-				   GMBUS_CYCLE_WAIT |
-				   (i + 1 == num ? GMBUS_CYCLE_STOP : 0) |
-				   (len << GMBUS_BYTE_COUNT_SHIFT) |
-				   (msgs[i].addr << GMBUS_SLAVE_ADDR_SHIFT) |
-				   GMBUS_SLAVE_READ | GMBUS_SW_RDY);
-			POSTING_READ(GMBUS2+reg_offset);
-			do {
-				u32 val, loop = 0;
-
-				if (wait_for(I915_READ(GMBUS2 + reg_offset) & (GMBUS_SATOER | GMBUS_HW_RDY), 50))
-					goto timeout;
-				if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
-					goto clear_err;
-
-				val = I915_READ(GMBUS3 + reg_offset);
-				do {
-					*buf++ = val & 0xff;
-					val >>= 8;
-				} while (--len && ++loop < 4);
-			} while (len);
-		} else {
-			u32 val, loop;
-
-			val = loop = 0;
-			do {
-				val |= *buf++ << (8 * loop);
-			} while (--len && ++loop < 4);
-
-			I915_WRITE(GMBUS3 + reg_offset, val);
-			I915_WRITE(GMBUS1 + reg_offset,
-				   GMBUS_CYCLE_WAIT |
-				   (i + 1 == num ? GMBUS_CYCLE_STOP : 0) |
-				   (msgs[i].len << GMBUS_BYTE_COUNT_SHIFT) |
-				   (msgs[i].addr << GMBUS_SLAVE_ADDR_SHIFT) |
-				   GMBUS_SLAVE_WRITE | GMBUS_SW_RDY);
-			POSTING_READ(GMBUS2+reg_offset);
-
-			while (len) {
-				if (wait_for(I915_READ(GMBUS2 + reg_offset) & (GMBUS_SATOER | GMBUS_HW_RDY), 50))
-					goto timeout;
-				if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
-					goto clear_err;
-
-				val = loop = 0;
-				do {
-					val |= *buf++ << (8 * loop);
-				} while (--len && ++loop < 4);
-
-				I915_WRITE(GMBUS3 + reg_offset, val);
-				POSTING_READ(GMBUS2+reg_offset);
-			}
-		}
-
-		if (i + 1 < num && wait_for(I915_READ(GMBUS2 + reg_offset) & (GMBUS_SATOER | GMBUS_HW_WAIT_PHASE), 50))
+		bool last = i + 1 == num;
+
+		if (msgs[i].flags & I2C_M_RD)
+			ret = gmbus_xfer_read(dev_priv, &msgs[i], last);
+		else
+			ret = gmbus_xfer_write(dev_priv, &msgs[i], last);
+
+		if (ret == -ETIMEDOUT)
+			goto timeout;
+		if (ret == -ENXIO)
+			goto clear_err;
+
+		if (!last &&
+		    wait_for(I915_READ(GMBUS2 + reg_offset) &
+			     (GMBUS_SATOER | GMBUS_HW_WAIT_PHASE),
+			     50))
 			goto timeout;
 		if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
 			goto clear_err;
-- 
1.7.7.3

