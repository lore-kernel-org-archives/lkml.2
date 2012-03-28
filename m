Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab2C1MxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:53:13 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:64432 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab2C1MwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:52:06 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 04/14 v5] drm/i915/intel_i2c: use i2c pre/post_xfer functions to setup gpio xfers
Date: Wed, 28 Mar 2012 20:51:47 +0800
Message-Id: <1332939117-6513-5-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
References: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of rolling our own custom quirk_xfer function, use the bit_algo
pre_xfer and post_xfer functions to setup and teardown bit-banged
i2c transactions.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/intel_i2c.c |   60 +++++++++++++++++++++----------------
 1 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 9347281..1bb6362 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -137,6 +137,35 @@ static void set_data(void *data, int state_high)
 	POSTING_READ(bus->gpio_reg);
 }
 
+static int
+intel_gpio_pre_xfer(struct i2c_adapter *adapter)
+{
+	struct intel_gmbus *bus = container_of(adapter,
+					       struct intel_gmbus,
+					       adapter);
+	struct drm_i915_private *dev_priv = bus->dev_priv;
+
+	intel_i2c_reset(dev_priv->dev);
+	intel_i2c_quirk_set(dev_priv, true);
+	set_data(bus, 1);
+	set_clock(bus, 1);
+	udelay(I2C_RISEFALL_TIME);
+	return 0;
+}
+
+static void
+intel_gpio_post_xfer(struct i2c_adapter *adapter)
+{
+	struct intel_gmbus *bus = container_of(adapter,
+					       struct intel_gmbus,
+					       adapter);
+	struct drm_i915_private *dev_priv = bus->dev_priv;
+
+	set_data(bus, 1);
+	set_clock(bus, 1);
+	intel_i2c_quirk_set(dev_priv, false);
+}
+
 static bool
 intel_gpio_setup(struct intel_gmbus *bus, u32 pin)
 {
@@ -166,6 +195,8 @@ intel_gpio_setup(struct intel_gmbus *bus, u32 pin)
 	algo->setscl = set_clock;
 	algo->getsda = get_data;
 	algo->getscl = get_clock;
+	algo->pre_xfer = intel_gpio_pre_xfer;
+	algo->post_xfer = intel_gpio_post_xfer;
 	algo->udelay = I2C_RISEFALL_TIME;
 	algo->timeout = usecs_to_jiffies(2200);
 	algo->data = bus;
@@ -174,30 +205,6 @@ intel_gpio_setup(struct intel_gmbus *bus, u32 pin)
 }
 
 static int
-intel_i2c_quirk_xfer(struct intel_gmbus *bus,
-		     struct i2c_msg *msgs,
-		     int num)
-{
-	struct drm_i915_private *dev_priv = bus->dev_priv;
-	int ret;
-
-	intel_i2c_reset(dev_priv->dev);
-
-	intel_i2c_quirk_set(dev_priv, true);
-	set_data(bus, 1);
-	set_clock(bus, 1);
-	udelay(I2C_RISEFALL_TIME);
-
-	ret = i2c_bit_algo.master_xfer(&bus->adapter, msgs, num);
-
-	set_data(bus, 1);
-	set_clock(bus, 1);
-	intel_i2c_quirk_set(dev_priv, false);
-
-	return ret;
-}
-
-static int
 gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
 		bool last)
 {
@@ -287,7 +294,7 @@ gmbus_xfer(struct i2c_adapter *adapter,
 	mutex_lock(&dev_priv->gmbus_mutex);
 
 	if (bus->force_bit) {
-		ret = intel_i2c_quirk_xfer(bus, msgs, num);
+		ret = i2c_bit_algo.master_xfer(adapter, msgs, num);
 		goto out;
 	}
 
@@ -351,8 +358,9 @@ timeout:
 		ret = -EIO;
 	} else {
 		bus->force_bit = true;
-		ret = intel_i2c_quirk_xfer(bus, msgs, num);
+		ret = i2c_bit_algo.master_xfer(adapter, msgs, num);
 	}
+
 out:
 	mutex_unlock(&dev_priv->gmbus_mutex);
 	return ret;
-- 
1.7.7.3

