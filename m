Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab2C1Mx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:53:28 -0400
Received: from mail-yw0-f74.google.com ([209.85.213.74]:33108 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2C1MwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:52:05 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 06/14 v5] drm/i915/intel_i2c: gmbus disabled and reserved ports are invalid
Date: Wed, 28 Mar 2012 20:51:49 +0800
Message-Id: <1332939117-6513-7-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
References: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no GMBUS "disabled" port 0, nor "reserved" port 7.
For the other 6 ports there is a fixed 1:1 mapping between pin pairs and
gmbus ports, which means every real gmbus port has a gpio pin.

Given these realizations, clean up gmbus initialization.

Tested on Sandybridge (gen 6, PCH == CougarPoint) hardware.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/i915_drv.h  |    3 +-
 drivers/gpu/drm/i915/i915_reg.h  |    2 +-
 drivers/gpu/drm/i915/intel_i2c.c |   70 ++++++++++++++-----------------------
 3 files changed, 29 insertions(+), 46 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 44e6430..c5ad7b9 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -303,7 +303,6 @@ struct intel_fbc_work;
 struct intel_gmbus {
 	struct i2c_adapter adapter;
 	bool force_bit;
-	bool has_gpio;
 	u32 reg0;
 	u32 gpio_reg;
 	struct i2c_algo_bit_data bit_algo;
@@ -1344,7 +1343,7 @@ extern int intel_setup_gmbus(struct drm_device *dev);
 extern void intel_teardown_gmbus(struct drm_device *dev);
 extern inline bool intel_gmbus_is_port_valid(unsigned port)
 {
-	return (port >= GMBUS_PORT_DISABLED && port <= GMBUS_PORT_RESERVED);
+	return (port >= GMBUS_PORT_SSC && port <= GMBUS_PORT_DPD);
 }
 
 extern struct i2c_adapter *intel_gmbus_get_adapter(
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index accd8ee..a8d218c 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -744,7 +744,7 @@
 #define   GMBUS_PORT_DPB	5 /* SDVO, HDMIB */
 #define   GMBUS_PORT_DPD	6 /* HDMID */
 #define   GMBUS_PORT_RESERVED	7 /* 7 reserved */
-#define   GMBUS_NUM_PORTS	8
+#define   GMBUS_NUM_PORTS	(GMBUS_PORT_DPD - GMBUS_PORT_SSC + 1)
 #define GMBUS1			0x5104 /* command/status */
 #define   GMBUS_SW_CLR_INT	(1<<31)
 #define   GMBUS_SW_RDY		(1<<30)
diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 2f65d01..dcde6f6 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -35,6 +35,20 @@
 #include "i915_drm.h"
 #include "i915_drv.h"
 
+struct gmbus_port {
+	const char *name;
+	int reg;
+};
+
+static const struct gmbus_port gmbus_ports[] = {
+	{ "ssc", GPIOB },
+	{ "vga", GPIOA },
+	{ "panel", GPIOC },
+	{ "dpc", GPIOD },
+	{ "dpb", GPIOE },
+	{ "dpd", GPIOF },
+};
+
 /* Intel GPIO access functions */
 
 #define I2C_RISEFALL_TIME 10
@@ -166,29 +180,16 @@ intel_gpio_post_xfer(struct i2c_adapter *adapter)
 	intel_i2c_quirk_set(dev_priv, false);
 }
 
-static bool
+static void
 intel_gpio_setup(struct intel_gmbus *bus, u32 pin)
 {
 	struct drm_i915_private *dev_priv = bus->dev_priv;
-	static const int map_pin_to_reg[] = {
-		0,
-		GPIOB,
-		GPIOA,
-		GPIOC,
-		GPIOD,
-		GPIOE,
-		GPIOF,
-		0,
-	};
 	struct i2c_algo_bit_data *algo;
 
-	if (pin >= ARRAY_SIZE(map_pin_to_reg) || !map_pin_to_reg[pin])
-		return false;
-
 	algo = &bus->bit_algo;
 
-	bus->gpio_reg = map_pin_to_reg[pin];
-	bus->gpio_reg += dev_priv->gpio_mmio_base;
+	/* -1 to map pin pair to gmbus index */
+	bus->gpio_reg = dev_priv->gpio_mmio_base + gmbus_ports[pin - 1].reg;
 
 	bus->adapter.algo_data = algo;
 	algo->setsda = set_data;
@@ -200,8 +201,6 @@ intel_gpio_setup(struct intel_gmbus *bus, u32 pin)
 	algo->udelay = I2C_RISEFALL_TIME;
 	algo->timeout = usecs_to_jiffies(2200);
 	algo->data = bus;
-
-	return true;
 }
 
 static int
@@ -351,15 +350,9 @@ timeout:
 		 bus->adapter.name, bus->reg0 & 0xff);
 	I915_WRITE(GMBUS0 + reg_offset, 0);
 
-	/* Hardware may not support GMBUS over these pins?
-	 * Try GPIO bitbanging instead.
-	 */
-	if (!bus->has_gpio) {
-		ret = -EIO;
-	} else {
-		bus->force_bit = true;
-		ret = i2c_bit_algo.master_xfer(adapter, msgs, num);
-	}
+	/* Hardware may not support GMBUS over these pins? Try GPIO bitbanging instead. */
+	bus->force_bit = true;
+	ret = i2c_bit_algo.master_xfer(adapter, msgs, num);
 
 out:
 	mutex_unlock(&dev_priv->gmbus_mutex);
@@ -386,16 +379,6 @@ static const struct i2c_algorithm gmbus_algorithm = {
  */
 int intel_setup_gmbus(struct drm_device *dev)
 {
-	static const char *names[GMBUS_NUM_PORTS] = {
-		"disabled",
-		"ssc",
-		"vga",
-		"panel",
-		"dpc",
-		"dpb",
-		"dpd",
-		"reserved",
-	};
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int ret, i;
 
@@ -413,13 +396,14 @@ int intel_setup_gmbus(struct drm_device *dev)
 
 	for (i = 0; i < GMBUS_NUM_PORTS; i++) {
 		struct intel_gmbus *bus = &dev_priv->gmbus[i];
+		u32 port = i + 1; /* +1 to map gmbus index to pin pair */
 
 		bus->adapter.owner = THIS_MODULE;
 		bus->adapter.class = I2C_CLASS_DDC;
 		snprintf(bus->adapter.name,
 			 sizeof(bus->adapter.name),
 			 "i915 gmbus %s",
-			 names[i]);
+			 gmbus_ports[i].name);
 
 		bus->adapter.dev.parent = &dev->pdev->dev;
 		bus->dev_priv = dev_priv;
@@ -430,9 +414,9 @@ int intel_setup_gmbus(struct drm_device *dev)
 			goto err;
 
 		/* By default use a conservative clock rate */
-		bus->reg0 = i | GMBUS_RATE_100KHZ;
+		bus->reg0 = port | GMBUS_RATE_100KHZ;
 
-		bus->has_gpio = intel_gpio_setup(bus, i);
+		intel_gpio_setup(bus, port);
 	}
 
 	intel_i2c_reset(dev_priv->dev);
@@ -453,8 +437,9 @@ struct i2c_adapter *intel_gmbus_get_adapter(struct drm_i915_private *dev_priv,
 					    unsigned port)
 {
 	WARN_ON(!intel_gmbus_is_port_valid(port));
+	/* -1 to map pin pair to gmbus index */
 	return (intel_gmbus_is_port_valid(port)) ?
-		&dev_priv->gmbus[port].adapter : NULL;
+		&dev_priv->gmbus[port - 1].adapter : NULL;
 }
 
 void intel_gmbus_set_speed(struct i2c_adapter *adapter, int speed)
@@ -468,8 +453,7 @@ void intel_gmbus_force_bit(struct i2c_adapter *adapter, bool force_bit)
 {
 	struct intel_gmbus *bus = to_intel_gmbus(adapter);
 
-	if (bus->has_gpio)
-		bus->force_bit = force_bit;
+	bus->force_bit = force_bit;
 }
 
 void intel_teardown_gmbus(struct drm_device *dev)
-- 
1.7.7.3

