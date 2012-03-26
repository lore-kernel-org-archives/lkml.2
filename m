Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab2CZO2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:28:22 -0400
Received: from mail-lb0-f202.google.com ([209.85.217.202]:36993 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527Ab2CZO05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:26:57 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 03/11 v3] drm/i915/intel_i2c: use i2c pre/post_xfer functions to setup gpio xfers
Date: Mon, 26 Mar 2012 22:26:42 +0800
Message-Id: <1332772010-19619-4-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
References: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of rolling our own custom quirk_xfer function, use the bit_algo
pre_xfer and post_xfer functions to setup and teardown bit-banged
i2c transactions.

gmbus_xfer uses .force_bit to determine which i2c_algorithm to use,
either i2c_bit_algo.master_xfer or its own.  So, Similarly, let gmbus_func
use .force_bit to determine which i2c functionalities are available,
either i2c_bit_algo.functionality, or its own.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |   72 +++++++++++++++++++++++--------------
 1 files changed, 45 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 54f85a1..ae08a08 100644
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
 gmbus_xfer(struct i2c_adapter *adapter,
 	   struct i2c_msg *msgs,
 	   int num)
@@ -211,7 +218,7 @@ gmbus_xfer(struct i2c_adapter *adapter,
 	mutex_lock(&dev_priv->gmbus_mutex);
 
 	if (bus->force_bit) {
-		ret = intel_i2c_quirk_xfer(bus, msgs, num);
+		ret = i2c_bit_algo.master_xfer(adapter, msgs, num);
 		goto out;
 	}
 
@@ -325,8 +332,9 @@ timeout:
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
@@ -334,11 +342,21 @@ out:
 
 static u32 gmbus_func(struct i2c_adapter *adapter)
 {
-	return i2c_bit_algo.functionality(adapter) &
+	struct intel_gmbus *bus = container_of(adapter,
+					       struct intel_gmbus,
+					       adapter);
+	struct drm_i915_private *dev_priv = bus->dev_priv;
+	u32 func;
+
+	mutex_lock(&dev_priv->gmbus_mutex);
+	func = bus->force_bit ? i2c_bit_algo.functionality(adapter) :
 		(I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL |
 		/* I2C_FUNC_10BIT_ADDR | */
 		I2C_FUNC_SMBUS_READ_BLOCK_DATA |
 		I2C_FUNC_SMBUS_BLOCK_PROC_CALL);
+	mutex_unlock(&dev_priv->gmbus_mutex);
+
+	return func;
 }
 
 static const struct i2c_algorithm gmbus_algorithm = {
-- 
1.7.7.3

