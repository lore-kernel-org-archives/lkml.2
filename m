Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab2C0Sgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 14:36:39 -0400
Received: from mail-vx0-f202.google.com ([209.85.220.202]:46574 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab2C0Sg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 14:36:29 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 12/13 v4] drm/i915/intel_i2c: use INDEX cycles for i2c read transactions
Date: Wed, 28 Mar 2012 02:36:21 +0800
Message-Id: <1332873382-29373-13-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332873382-29373-1-git-send-email-djkurtz@chromium.org>
References: <1332873382-29373-1-git-send-email-djkurtz@chromium.org>
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
 drivers/gpu/drm/i915/intel_i2c.c |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 43a3ca3..c71f3dc 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -204,13 +204,15 @@ intel_gpio_setup(struct intel_gmbus *bus, u32 pin)
 }
 
 static int
-gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
+gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
+		u32 gmbus1)
 {
 	int reg_offset = dev_priv->gpio_mmio_base;
 	u16 len = msg->len;
 	u8 *buf = msg->buf;
 
 	I915_WRITE(GMBUS1 + reg_offset,
+		   gmbus1 |
 		   GMBUS_CYCLE_WAIT |
 		   (len << GMBUS_BYTE_COUNT_SHIFT) |
 		   (msg->addr << GMBUS_SLAVE_ADDR_SHIFT) |
@@ -300,8 +302,34 @@ gmbus_xfer(struct i2c_adapter *adapter,
 	I915_WRITE(GMBUS0 + reg_offset, bus->reg0);
 
 	for (i = 0; i < num; i++) {
+		bool last = i + 1 == num;
+		u32 gmbus5 = 0;
+		u32 gmbus1 = 0;
+
+		/*
+		 * The gmbus controller can combine a 1 or 2 byte write with a
+		 * read that immediately follows it by using an "INDEX" cycle.
+		 */
+		if (!last &&
+		    !(msgs[i].flags & I2C_M_RD) &&
+		    (msgs[i + 1].flags & I2C_M_RD) &&
+		    msgs[i].len <= 2) {
+			if (msgs[i].len == 2)
+				gmbus5 = GMBUS_2BYTE_INDEX_EN |
+					 msgs[i].buf[1] |
+					 (msgs[i].buf[0] << 8);
+			if (msgs[i].len == 1)
+				gmbus1 = GMBUS_CYCLE_INDEX |
+					 (msgs[i].buf[0] <<
+					  GMBUS_SLAVE_INDEX_SHIFT);
+			i += 1;  /* set i to the index of the read xfer */
+		}
+
+		/* GMBUS5 holds 16-bit index, but must be 0 if not used */
+		I915_WRITE(GMBUS5 + reg_offset, gmbus5);
+
 		if (msgs[i].flags & I2C_M_RD)
-			ret = gmbus_xfer_read(dev_priv, &msgs[i]);
+			ret = gmbus_xfer_read(dev_priv, &msgs[i], gmbus1);
 		else
 			ret = gmbus_xfer_write(dev_priv, &msgs[i]);
 
-- 
1.7.7.3

