Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1LAN5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 08:57:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52299 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754354Ab1LAN46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 08:56:58 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: Mark WM1811 GPIO6 register volatile for later revisions
Date: Thu,  1 Dec 2011 13:56:54 +0000
Message-Id: <1322747814-31877-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322747814-31877-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1322747814-31877-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For later chip revisions the WM1811 GPIO6 register is always volatile so
store the device revision when initialising the driver and then check at
runtime if we're running on a newer device.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c       |   12 +++++++-----
 drivers/mfd/wm8994-regmap.c     |   19 +++++++++++++++++--
 include/linux/mfd/wm8994/core.h |    1 +
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 92aa22f..3160cdd 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -446,15 +446,16 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 			ret);
 		goto err_enable;
 	}
+	wm8994->revision = ret;
 
 	switch (wm8994->type) {
 	case WM8994:
-		switch (ret) {
+		switch (wm8994->revision) {
 		case 0:
 		case 1:
 			dev_warn(wm8994->dev,
 				 "revision %c not fully supported\n",
-				 'A' + ret);
+				 'A' + wm8994->revision);
 			break;
 		default:
 			break;
@@ -462,14 +463,15 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		break;
 	case WM1811:
 		/* Revision C did not change the relevant layer */
-		if (ret > 1)
-			ret++;
+		if (wm8994->revision > 1)
+			wm8994->revision++;
 		break;
 	default:
 		break;
 	}
 
-	dev_info(wm8994->dev, "%s revision %c\n", devname, 'A' + ret);
+	dev_info(wm8994->dev, "%s revision %c\n", devname,
+		 'A' + wm8994->revision);
 
 	if (pdata) {
 		wm8994->irq_base = pdata->irq_base;
diff --git a/drivers/mfd/wm8994-regmap.c b/drivers/mfd/wm8994-regmap.c
index d98a70e..2fdefa124 100644
--- a/drivers/mfd/wm8994-regmap.c
+++ b/drivers/mfd/wm8994-regmap.c
@@ -12,6 +12,7 @@
  *
  */
 
+#include <linux/mfd/wm8994/core.h>
 #include <linux/mfd/wm8994/registers.h>
 #include <linux/regmap.h>
 
@@ -210,7 +211,6 @@ static struct reg_default wm1811_defaults[] = {
 	{ 0x0702, 0xA101 },    /* R1794 - Pull Control (BCLK2) */
 	{ 0x0703, 0xA101 },    /* R1795 - Pull Control (DACLRCLK2) */
 	{ 0x0704, 0xA101 },    /* R1796 - Pull Control (DACDAT2) */
-	{ 0x0705, 0xA101 },    /* R1797 - GPIO 6 */
 	{ 0x0707, 0xA101 },    /* R1799 - GPIO 8 */
 	{ 0x0708, 0xA101 },    /* R1800 - GPIO 9 */
 	{ 0x0709, 0xA101 },    /* R1801 - GPIO 10 */
@@ -1145,6 +1145,21 @@ static bool wm8994_volatile_register(struct device *dev, unsigned int reg)
 	}
 }
 
+static bool wm1811_volatile_register(struct device *dev, unsigned int reg)
+{
+	struct wm8994 *wm8994 = dev_get_drvdata(dev);
+
+	switch (reg) {
+	case WM8994_GPIO_6:
+		if (wm8994->revision > 1)
+			return true;
+		else
+			return false;
+	default:
+		return wm8994_volatile_register(dev, reg);
+	}
+}
+
 static bool wm8958_volatile_register(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
@@ -1185,7 +1200,7 @@ struct regmap_config wm1811_regmap_config = {
 	.num_reg_defaults = ARRAY_SIZE(wm1811_defaults),
 
 	.max_register = WM8994_MAX_REGISTER,
-	.volatile_reg = wm8994_volatile_register,
+	.volatile_reg = wm1811_volatile_register,
 	.readable_reg = wm1811_readable_register,
 };
 
diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
index c22b352..9eff2a3 100644
--- a/include/linux/mfd/wm8994/core.h
+++ b/include/linux/mfd/wm8994/core.h
@@ -56,6 +56,7 @@ struct wm8994 {
 	struct mutex irq_lock;
 
 	enum wm8994_type type;
+	int revision;
 
 	struct device *dev;
 	struct regmap *regmap;
-- 
1.7.7.3

