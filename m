Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab2C0Shc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 14:37:32 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:39485 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab2C0Sg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 14:36:29 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 13/13 v4] drm/i915/intel_i2c: reuse GMBUS2 value read in polling loop
Date: Wed, 28 Mar 2012 02:36:22 +0800
Message-Id: <1332873382-29373-14-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332873382-29373-1-git-send-email-djkurtz@chromium.org>
References: <1332873382-29373-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save the GMBUS2 value read while polling for state changes, and then
reuse this value when determining for which reason the loops were exited.
This is a small optimization which saves a couple of bus accesses for
memory mapped IO registers.

To avoid "assigning in if clause" checkpatch errors", use a ret variable
to store the wait_for macro return value.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index c71f3dc..174fc71 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -210,6 +210,7 @@ gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
 	int reg_offset = dev_priv->gpio_mmio_base;
 	u16 len = msg->len;
 	u8 *buf = msg->buf;
+	u32 gmbus2;
 
 	I915_WRITE(GMBUS1 + reg_offset,
 		   gmbus1 |
@@ -219,13 +220,15 @@ gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
 		   GMBUS_SLAVE_READ | GMBUS_SW_RDY);
 	POSTING_READ(GMBUS2 + reg_offset);
 	do {
+		int ret;
 		u32 val, loop = 0;
 
-		if (wait_for(I915_READ(GMBUS2 + reg_offset) &
-			     (GMBUS_SATOER | GMBUS_HW_RDY),
-			     50))
+		ret = wait_for((gmbus2 = I915_READ(GMBUS2 + reg_offset)) &
+			       (GMBUS_SATOER | GMBUS_HW_RDY),
+			       50);
+		if (ret)
 			return -ETIMEDOUT;
-		if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
+		if (gmbus2 & GMBUS_SATOER)
 			return -ENXIO;
 
 		val = I915_READ(GMBUS3 + reg_offset);
@@ -245,6 +248,7 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
 	u16 len = msg->len;
 	u8 *buf = msg->buf;
 	u32 val, loop;
+	u32 gmbus2;
 
 	val = loop = 0;
 	while (len && loop < 4) {
@@ -260,6 +264,7 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
 		   GMBUS_SLAVE_WRITE | GMBUS_SW_RDY);
 	POSTING_READ(GMBUS2 + reg_offset);
 	while (len) {
+		int ret;
 		val = loop = 0;
 		do {
 			val |= *buf++ << (8 * loop);
@@ -268,11 +273,12 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
 		I915_WRITE(GMBUS3 + reg_offset, val);
 		POSTING_READ(GMBUS2 + reg_offset);
 
-		if (wait_for(I915_READ(GMBUS2 + reg_offset) &
-			     (GMBUS_SATOER | GMBUS_HW_RDY),
-			     50))
+		ret = wait_for((gmbus2 = I915_READ(GMBUS2 + reg_offset)) &
+			       (GMBUS_SATOER | GMBUS_HW_RDY),
+			       50);
+		if (ret)
 			return -ETIMEDOUT;
-		if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
+		if (gmbus2 & GMBUS_SATOER)
 			return -ENXIO;
 	}
 	return 0;
@@ -289,6 +295,7 @@ gmbus_xfer(struct i2c_adapter *adapter,
 	struct drm_i915_private *dev_priv = bus->dev_priv;
 	int i, reg_offset;
 	int ret = 0;
+	u32 gmbus2 = 0;
 
 	mutex_lock(&dev_priv->gmbus_mutex);
 
@@ -338,11 +345,12 @@ gmbus_xfer(struct i2c_adapter *adapter,
 		if (ret == -ENXIO)
 			goto clear_err;
 
-		if (wait_for(I915_READ(GMBUS2 + reg_offset) &
-			     (GMBUS_SATOER | GMBUS_HW_WAIT_PHASE),
-			     50))
+		ret = wait_for((gmbus2 = I915_READ(GMBUS2 + reg_offset)) &
+			       (GMBUS_SATOER | GMBUS_HW_WAIT_PHASE),
+			       50);
+		if (ret)
 			goto timeout;
-		if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
+		if (gmbus2 & GMBUS_SATOER)
 			goto clear_err;
 	}
 
-- 
1.7.7.3

