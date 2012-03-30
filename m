Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308Ab2C3Lrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:47:45 -0400
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:56174 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267Ab2C3Lqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:46:50 -0400
MIME-Version: 1.0
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 5/8 v7] drm/i915/intel_i2c: use INDEX cycles for i2c read transactions
Date: Fri, 30 Mar 2012 19:46:40 +0800
Message-Id: <1333108003-6341-6-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
References: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is very common for an i2c device to require a small 1 or 2 byte write
followed by a read.  For example, when reading from an i2c EEPROM it is
common to write and address, offset or index followed by a reading some
values.

The i915 gmbus controller provides a special "INDEX" cycle for performing
such a small write followed by a read.  The INDEX can be either one or two
bytes long.  The advantage of using such a cycle is that the CPU has
slightly less work to do once the read with INDEX cycle is started.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |   54 +++++++++++++++++++++++++++++++++++---
 1 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 25f2c9e..9c07ff2 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -204,13 +204,15 @@ intel_gpio_setup(struct intel_gmbus *bus, u32 pin)
 }
 
 static int
-gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
+gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
+		u32 gmbus1_index)
 {
 	int reg_offset = dev_priv->gpio_mmio_base;
 	u16 len = msg->len;
 	u8 *buf = msg->buf;
 
 	I915_WRITE(GMBUS1 + reg_offset,
+		   gmbus1_index |
 		   GMBUS_CYCLE_WAIT |
 		   (len << GMBUS_BYTE_COUNT_SHIFT) |
 		   (msg->addr << GMBUS_SLAVE_ADDR_SHIFT) |
@@ -276,6 +278,46 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
 	return 0;
 }
 
+/*
+ * The gmbus controller can combine a 1 or 2 byte write with a read that
+ * immediately follows it by using an "INDEX" cycle.
+ */
+static bool
+gmbus_is_index_read(struct i2c_msg *msgs, int i, int num)
+{
+	return (i + 1 < num &&
+		!(msgs[i].flags & I2C_M_RD) && msgs[i].len <= 2 &&
+		(msgs[i + 1].flags & I2C_M_RD));
+}
+
+static int
+gmbus_xfer_index_read(struct drm_i915_private *dev_priv, struct i2c_msg *msgs)
+{
+	int reg_offset = dev_priv->gpio_mmio_base;
+	u32 gmbus1_index = 0;
+	u32 gmbus5 = 0;
+	int ret;
+
+	if (msgs[0].len == 2)
+		gmbus5 = GMBUS_2BYTE_INDEX_EN |
+			 msgs[0].buf[1] | (msgs[0].buf[0] << 8);
+	if (msgs[0].len == 1)
+		gmbus1_index = GMBUS_CYCLE_INDEX |
+			       (msgs[0].buf[0] << GMBUS_SLAVE_INDEX_SHIFT);
+
+	/* GMBUS5 holds 16-bit index */
+	if (gmbus5)
+		I915_WRITE(GMBUS5 + reg_offset, gmbus5);
+
+	ret = gmbus_xfer_read(dev_priv, &msgs[1], gmbus1_index);
+
+	/* Clear GMBUS5 after each index transfer */
+	if (gmbus5)
+		I915_WRITE(GMBUS5 + reg_offset, 0);
+
+	return ret;
+}
+
 static int
 gmbus_xfer(struct i2c_adapter *adapter,
 	   struct i2c_msg *msgs,
@@ -300,10 +342,14 @@ gmbus_xfer(struct i2c_adapter *adapter,
 	I915_WRITE(GMBUS0 + reg_offset, bus->reg0);
 
 	for (i = 0; i < num; i++) {
-		if (msgs[i].flags & I2C_M_RD)
-			ret = gmbus_xfer_read(dev_priv, &msgs[i]);
-		else
+		if (gmbus_is_index_read(msgs, i, num)) {
+			ret = gmbus_xfer_index_read(dev_priv, &msgs[i]);
+			i += 1;  /* set i to the index of the read xfer */
+		} else if (msgs[i].flags & I2C_M_RD) {
+			ret = gmbus_xfer_read(dev_priv, &msgs[i], 0);
+		} else {
 			ret = gmbus_xfer_write(dev_priv, &msgs[i]);
+		}
 
 		if (ret == -ETIMEDOUT)
 			goto timeout;
-- 
1.7.7.3

