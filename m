Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab2C1MxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:53:15 -0400
Received: from mail-gx0-f202.google.com ([209.85.161.202]:37439 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab2C1MwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:52:06 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 14/14 v5] drm/i915/intel_i2c: remove POSTING_READ() from gmbus transfers
Date: Wed, 28 Mar 2012 20:51:57 +0800
Message-Id: <1332939117-6513-15-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
References: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The POSTING_READ() calls were originally added to make sure the writes
were flushed before any timing delays and across loops.
However, the normal I915_READ() and I915_WRITE() macros already call
readl() / writel(), which already have an explicit mb().

Now that the code has settled a bit, let's remove them.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 2865313..be2852e 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -131,7 +131,6 @@ static void set_clock(void *data, int state_high)
 			GPIO_CLOCK_VAL_MASK;
 
 	I915_WRITE_NOTRACE(bus->gpio_reg, reserved | clock_bits);
-	POSTING_READ(bus->gpio_reg);
 }
 
 static void set_data(void *data, int state_high)
@@ -148,7 +147,6 @@ static void set_data(void *data, int state_high)
 			GPIO_DATA_VAL_MASK;
 
 	I915_WRITE_NOTRACE(bus->gpio_reg, reserved | data_bits);
-	POSTING_READ(bus->gpio_reg);
 }
 
 static int
@@ -217,7 +215,6 @@ gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
 		   (len << GMBUS_BYTE_COUNT_SHIFT) |
 		   (msg->addr << GMBUS_SLAVE_ADDR_SHIFT) |
 		   GMBUS_SLAVE_READ | GMBUS_SW_RDY);
-	POSTING_READ(GMBUS2 + reg_offset);
 	do {
 		int ret;
 		u32 val, loop = 0;
@@ -261,7 +258,6 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
 		   (msg->len << GMBUS_BYTE_COUNT_SHIFT) |
 		   (msg->addr << GMBUS_SLAVE_ADDR_SHIFT) |
 		   GMBUS_SLAVE_WRITE | GMBUS_SW_RDY);
-	POSTING_READ(GMBUS2 + reg_offset);
 	while (len) {
 		int ret;
 		u32 gmbus2;
@@ -272,7 +268,6 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
 		} while (--len && ++loop < 4);
 
 		I915_WRITE(GMBUS3 + reg_offset, val);
-		POSTING_READ(GMBUS2 + reg_offset);
 
 		ret = wait_for((gmbus2 = I915_READ(GMBUS2 + reg_offset)) &
 			       (GMBUS_SATOER | GMBUS_HW_RDY),
-- 
1.7.7.3

