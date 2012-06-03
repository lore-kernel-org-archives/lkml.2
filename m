Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab2FCMhr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 08:37:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33944 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482Ab2FCMhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 08:37:46 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] mfd: wm8350: Add regmap cache support
Date: Sun,  3 Jun 2012 13:37:22 +0100
Message-Id: <1338727044-23960-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the most simple possible transformation on the existing code so keep
the table sitting around, further patches in this series will delete the
existing cache code - the main purpose of this patch is to ensure that
we always have a cache for bisection.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c       |   29 ++++++++++++--------
 drivers/mfd/wm8350-i2c.c        |    5 ----
 drivers/mfd/wm8350-regmap.c     |   56 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm8350/core.h |    7 ++++-
 4 files changed, 80 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 8a9b11c..fadcbbe 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -32,9 +32,6 @@
 #include <linux/mfd/wm8350/supply.h>
 #include <linux/mfd/wm8350/wdt.h>
 
-#define WM8350_UNLOCK_KEY		0x0013
-#define WM8350_LOCK_KEY			0x0000
-
 #define WM8350_CLOCK_CONTROL_1		0x28
 #define WM8350_AIF_TEST			0x74
 
@@ -295,15 +292,20 @@ EXPORT_SYMBOL_GPL(wm8350_block_write);
  */
 int wm8350_reg_lock(struct wm8350 *wm8350)
 {
-	u16 key = WM8350_LOCK_KEY;
 	int ret;
 
+	mutex_lock(&reg_lock_mutex);
+
 	ldbg(__func__);
-	mutex_lock(&io_mutex);
-	ret = wm8350_write(wm8350, WM8350_SECURITY, 1, &key);
+
+	ret = wm8350_reg_write(wm8350, WM8350_SECURITY, WM8350_LOCK_KEY);
 	if (ret)
 		dev_err(wm8350->dev, "lock failed\n");
-	mutex_unlock(&io_mutex);
+
+	wm8350->unlocked = false;
+
+	mutex_unlock(&reg_lock_mutex);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(wm8350_reg_lock);
@@ -319,15 +321,20 @@ EXPORT_SYMBOL_GPL(wm8350_reg_lock);
  */
 int wm8350_reg_unlock(struct wm8350 *wm8350)
 {
-	u16 key = WM8350_UNLOCK_KEY;
 	int ret;
 
+	mutex_lock(&reg_lock_mutex);
+
 	ldbg(__func__);
-	mutex_lock(&io_mutex);
-	ret = wm8350_write(wm8350, WM8350_SECURITY, 1, &key);
+
+	ret = wm8350_reg_write(wm8350, WM8350_SECURITY, WM8350_UNLOCK_KEY);
 	if (ret)
 		dev_err(wm8350->dev, "unlock failed\n");
-	mutex_unlock(&io_mutex);
+
+	wm8350->unlocked = true;
+
+	mutex_unlock(&reg_lock_mutex);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(wm8350_reg_unlock);
diff --git a/drivers/mfd/wm8350-i2c.c b/drivers/mfd/wm8350-i2c.c
index a68aceb..2e57101 100644
--- a/drivers/mfd/wm8350-i2c.c
+++ b/drivers/mfd/wm8350-i2c.c
@@ -23,11 +23,6 @@
 #include <linux/regmap.h>
 #include <linux/slab.h>
 
-static const struct regmap_config wm8350_regmap = {
-	.reg_bits = 8,
-	.val_bits = 16,
-};
-
 static int wm8350_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
diff --git a/drivers/mfd/wm8350-regmap.c b/drivers/mfd/wm8350-regmap.c
index e965139..7974cad 100644
--- a/drivers/mfd/wm8350-regmap.c
+++ b/drivers/mfd/wm8350-regmap.c
@@ -3433,3 +3433,59 @@ const struct wm8350_reg_access wm8350_reg_io_map[] = {
 	{ 0x0000, 0x0000, 0x0000 }, /* R254 */
 	{ 0x0000, 0x0000, 0x0000 }, /* R255 */
 };
+
+static bool wm8350_readable(struct device *dev, unsigned int reg)
+{
+	return wm8350_reg_io_map[reg].readable;
+}
+
+static bool wm8350_writeable(struct device *dev, unsigned int reg)
+{
+	struct wm8350 *wm8350 = dev_get_drvdata(dev);
+
+	if (!wm8350->unlocked) {
+		if ((reg >= WM8350_GPIO_FUNCTION_SELECT_1 &&
+		     reg <= WM8350_GPIO_FUNCTION_SELECT_4) ||
+		    (reg >= WM8350_BATTERY_CHARGER_CONTROL_1 &&
+		     reg <= WM8350_BATTERY_CHARGER_CONTROL_3))
+			return false;
+	}
+
+	return wm8350_reg_io_map[reg].writable;
+}
+
+static bool wm8350_volatile(struct device *dev, unsigned int reg)
+{
+	return wm8350_reg_io_map[reg].vol;
+}
+
+static bool wm8350_precious(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case WM8350_SYSTEM_INTERRUPTS:
+	case WM8350_INT_STATUS_1:
+	case WM8350_INT_STATUS_2:
+	case WM8350_POWER_UP_INT_STATUS:
+	case WM8350_UNDER_VOLTAGE_INT_STATUS:
+	case WM8350_OVER_CURRENT_INT_STATUS:
+	case WM8350_GPIO_INT_STATUS:
+	case WM8350_COMPARATOR_INT_STATUS:
+		return true;
+
+	default:
+		return false;
+	}
+}
+
+const struct regmap_config wm8350_regmap = {
+	.reg_bits = 8,
+	.val_bits = 16,
+
+	.cache_type = REGCACHE_RBTREE,
+
+	.max_register = WM8350_MAX_REGISTER,
+	.readable_reg = wm8350_readable,
+	.writeable_reg = wm8350_writeable,
+	.volatile_reg = wm8350_volatile,
+	.precious_reg = wm8350_precious,
+};
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index 9192b64..cba9bc8 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -17,6 +17,7 @@
 #include <linux/mutex.h>
 #include <linux/interrupt.h>
 #include <linux/completion.h>
+#include <linux/regmap.h>
 
 #include <linux/mfd/wm8350/audio.h>
 #include <linux/mfd/wm8350/gpio.h>
@@ -66,6 +67,9 @@
 
 #define WM8350_MAX_REGISTER                     0xFF
 
+#define WM8350_UNLOCK_KEY		0x0013
+#define WM8350_LOCK_KEY			0x0000
+
 /*
  * Field Definitions.
  */
@@ -582,6 +586,7 @@
 
 #define WM8350_NUM_IRQ_REGS 7
 
+extern const struct regmap_config wm8350_regmap;
 struct wm8350_reg_access {
 	u16 readable;		/* Mask of readable bits */
 	u16 writable;		/* Mask of writable bits */
@@ -602,7 +607,6 @@ extern const u16 wm8352_mode2_defaults[];
 extern const u16 wm8352_mode3_defaults[];
 
 struct wm8350;
-struct regmap;
 
 struct wm8350_hwmon {
 	struct platform_device *pdev;
@@ -615,6 +619,7 @@ struct wm8350 {
 	/* device IO */
 	struct regmap *regmap;
 	u16 *reg_cache;
+	bool unlocked;
 
 	struct mutex auxadc_mutex;
 	struct completion auxadc_done;
-- 
1.7.10

