Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab2CGLvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:51:24 -0500
Received: from mail-fa0-f74.google.com ([209.85.161.74]:57914 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab2CGLvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:51:01 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 4/9] drm/i915/intel_i2c: cleanup gmbus/gpio pin assignments
Date: Wed,  7 Mar 2012 19:50:45 +0800
Message-Id: <1331121050-17857-5-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no "disabled" port 0.  So, don't even try to initialize/scan
it, etc.  This saves a bit of time when initializing the driver, since
the we can avoid a 50ms timeout waiting for a device to respond on
a port that doesn't even exist.

Similarly, don't initialize the reserved port, either.

Tested on Sandybridge (gen 6, PCH == CougarPoint) hardware.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/i915_reg.h  |    1 -
 drivers/gpu/drm/i915/intel_i2c.c |   64 ++++++++++++++++++--------------------
 2 files changed, 30 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 56af0df..89cace2 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -699,7 +699,6 @@
 #define   GMBUS_PORT_DPB	5 /* SDVO, HDMIB */
 #define   GMBUS_PORT_DPD	6 /* HDMID */
 #define   GMBUS_PORT_RESERVED	7 /* 7 reserved */
-#define   GMBUS_NUM_PORTS	8
 #define GMBUS1			0x5104 /* command/status */
 #define   GMBUS_SW_CLR_INT	(1<<31)
 #define   GMBUS_SW_RDY		(1<<30)
diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index dd8c699..b2cc7f2 100644
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
 
 #define I2C_RISEFALL_TIME 20
@@ -150,32 +164,23 @@ static void set_data(void *data, int state_high)
 static struct i2c_adapter *
 intel_gpio_create(struct drm_i915_private *dev_priv, u32 pin)
 {
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
 	struct intel_gpio *gpio;
 
-	if (pin >= ARRAY_SIZE(map_pin_to_reg) || !map_pin_to_reg[pin])
+	pin -= 1;  /* NB: -1 to map pin pair to gmbus array index */
+	if (pin >= ARRAY_SIZE(gmbus_ports))
 		return NULL;
 
 	gpio = kzalloc(sizeof(struct intel_gpio), GFP_KERNEL);
 	if (gpio == NULL)
 		return NULL;
 
-	gpio->reg = map_pin_to_reg[pin];
+	gpio->reg = gmbus_ports[pin].reg;
 	if (HAS_PCH_SPLIT(dev_priv->dev))
 		gpio->reg += PCH_GPIOA - GPIOA;
 	gpio->dev_priv = dev_priv;
 
 	snprintf(gpio->adapter.name, sizeof(gpio->adapter.name),
-		 "i915 GPIO%c", "?BACDE?F"[pin]);
+		 "i915 GPIO%c", "BACDEF"[pin]);
 	gpio->adapter.owner = THIS_MODULE;
 	gpio->adapter.algo_data	= &gpio->algo;
 	gpio->adapter.dev.parent = &dev_priv->dev->pdev->dev;
@@ -370,33 +375,22 @@ static const struct i2c_algorithm gmbus_algorithm = {
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
 
-	dev_priv->gmbus = kcalloc(sizeof(struct intel_gmbus), GMBUS_NUM_PORTS,
-				  GFP_KERNEL);
+	dev_priv->gmbus = kcalloc(sizeof(struct intel_gmbus),
+				  ARRAY_SIZE(gmbus_ports), GFP_KERNEL);
 	if (dev_priv->gmbus == NULL)
 		return -ENOMEM;
 
-	for (i = 0; i < GMBUS_NUM_PORTS; i++) {
+	for (i = 0; i < ARRAY_SIZE(gmbus_ports); i++) {
 		struct intel_gmbus *bus = &dev_priv->gmbus[i];
+		int port = i + 1; /* +1 to map gmbus index to pin pair */
 
 		bus->adapter.owner = THIS_MODULE;
 		bus->adapter.class = I2C_CLASS_DDC;
-		snprintf(bus->adapter.name,
-			 sizeof(bus->adapter.name),
-			 "i915 gmbus %s",
-			 names[i]);
+		snprintf(bus->adapter.name, sizeof(bus->adapter.name),
+			 "i915 gmbus %s", gmbus_ports[i].name);
 
 		bus->adapter.dev.parent = &dev->pdev->dev;
 		bus->adapter.algo_data	= dev_priv;
@@ -407,10 +401,10 @@ int intel_setup_gmbus(struct drm_device *dev)
 			goto err;
 
 		/* By default use a conservative clock rate */
-		bus->reg0 = i | GMBUS_RATE_100KHZ;
+		bus->reg0 = port | GMBUS_RATE_100KHZ;
 
 		/* XXX force bit banging until GMBUS is fully debugged */
-		bus->force_bit = intel_gpio_create(dev_priv, i);
+		bus->force_bit = intel_gpio_create(dev_priv, port);
 	}
 
 	intel_i2c_reset(dev_priv->dev);
@@ -430,7 +424,9 @@ err:
 struct i2c_adapter *intel_gmbus_get_bus(struct drm_i915_private *dev_priv,
 					int pin)
 {
-	return (pin < GMBUS_NUM_PORTS) ? &dev_priv->gmbus[pin].adapter : NULL;
+	pin -= 1;  /* NB: -1 to map pin pair to gmbus array index */
+	return (pin < ARRAY_SIZE(gmbus_ports)) ?
+			&dev_priv->gmbus[pin].adapter : NULL;
 }
 
 void intel_gmbus_set_speed(struct i2c_adapter *adapter, int speed)
@@ -467,7 +463,7 @@ void intel_teardown_gmbus(struct drm_device *dev)
 	if (dev_priv->gmbus == NULL)
 		return;
 
-	for (i = 0; i < GMBUS_NUM_PORTS; i++) {
+	for (i = 0; i < ARRAY_SIZE(gmbus_ports); i++) {
 		struct intel_gmbus *bus = &dev_priv->gmbus[i];
 		if (bus->force_bit) {
 			i2c_del_adapter(bus->force_bit);
-- 
1.7.7.3

