Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab2CIS5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:57:06 -0500
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:32779 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758739Ab2CIS4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:56:37 -0500
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2012 13:56:36 EST
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 04/10 v2] drm/i915/intel_i2c: cleanup gmbus/gpio pin assignments
Date: Sat, 10 Mar 2012 02:48:18 +0800
Message-Id: <1331318904-20577-5-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331318904-20577-1-git-send-email-djkurtz@chromium.org>
References: <1331318904-20577-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no "disabled" port 0.  So, don't even try to initialize/scan
it, etc.  This saves a bit of time when initializing the driver, since
it avoids a 50ms timeout waiting for a device to respond on a port that
doesn't even exist.

Similarly, don't initialize the "reserved" port 7, either.

Tested on Sandybridge (gen 6, PCH == CougarPoint) hardware.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/i915_reg.h  |    1 -
 drivers/gpu/drm/i915/intel_i2c.c |   64 +++++++++++++++++--------------------
 2 files changed, 29 insertions(+), 36 deletions(-)

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
index 87a3abf..f53f525 100644
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
@@ -150,32 +164,22 @@ static void set_data(void *data, int state_high)
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
-		return NULL;
+	pin -= 1;  /* NB: -1 to map pin pair to gmbus array index */
+	BUG_ON(pin >= ARRAY_SIZE(gmbus_ports));
 
 	gpio = kzalloc(sizeof(struct intel_gpio), GFP_KERNEL);
 	if (gpio == NULL)
 		return NULL;
 
-	gpio->reg = map_pin_to_reg[pin];
+	gpio->reg = gmbus_ports[pin].reg;
 	if (HAS_PCH_SPLIT(dev_priv->dev))
 		gpio->reg += PCH_GPIOA - GPIOA;
 	gpio->dev_priv = dev_priv;
 
 	snprintf(gpio->adapter.name, sizeof(gpio->adapter.name),
-		 "i915 GPIO%c", "?BACDEF?"[pin]);
+		 "i915 GPIO%c", "BACDEF"[pin]);
 	gpio->adapter.owner = THIS_MODULE;
 	gpio->adapter.algo_data	= &gpio->algo;
 	gpio->adapter.dev.parent = &dev_priv->dev->pdev->dev;
@@ -369,33 +373,22 @@ static const struct i2c_algorithm gmbus_algorithm = {
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
+		u32 port = i + 1; /* +1 to map gmbus index to pin pair */
 
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
@@ -406,10 +399,10 @@ int intel_setup_gmbus(struct drm_device *dev)
 			goto err;
 
 		/* By default use a conservative clock rate */
-		bus->reg0 = i | GMBUS_RATE_100KHZ;
+		bus->reg0 = port | GMBUS_RATE_100KHZ;
 
 		/* XXX force bit banging until GMBUS is fully debugged */
-		bus->force_bit = intel_gpio_create(dev_priv, i);
+		bus->force_bit = intel_gpio_create(dev_priv, port);
 	}
 
 	intel_i2c_reset(dev_priv->dev);
@@ -429,7 +422,8 @@ err:
 struct i2c_adapter *intel_gmbus_get_adapter(struct drm_i915_private *dev_priv,
 					    unsigned pin)
 {
-	BUG_ON(pin >= GMBUS_NUM_PORTS);
+	pin -= 1;  /* NB: -1 to map pin pair to gmbus array index */
+	BUG_ON(pin >= ARRAY_SIZE(gmbus_ports));
 	return &dev_priv->gmbus[pin].adapter;
 }
 
@@ -467,7 +461,7 @@ void intel_teardown_gmbus(struct drm_device *dev)
 	if (dev_priv->gmbus == NULL)
 		return;
 
-	for (i = 0; i < GMBUS_NUM_PORTS; i++) {
+	for (i = 0; i < ARRAY_SIZE(gmbus_ports); i++) {
 		struct intel_gmbus *bus = &dev_priv->gmbus[i];
 		if (bus->force_bit) {
 			i2c_del_adapter(bus->force_bit);
-- 
1.7.7.3

