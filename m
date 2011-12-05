Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab1LEIrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 03:47:06 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:12634 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab1LEIrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 03:47:04 -0500
X-AuditID: cbfee61b-b7c4cae000003c38-a6-4edc8507fa94
From: Thomas Abraham <thomas.abraham@linaro.org>
To: rpurdie@rpsys.net
Cc: ben-linux@fluff.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH] backlight: add regulator support for platform_lcd driver
Date: Mon, 05 Dec 2011 14:18:41 +0530
Message-id: <1323074921-29291-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power source to the lcd panel or the lcd interface such as lvds
transmitters could be controlled by a regulator supply. Add support
for enabling/disabling the regulator when switching power to lcd.

Two new elements 'min_uV' and 'max_uV' in the platform data are added
to allow platform code to specifiy the desired output voltage from the
regulator.

Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/video/backlight/platform_lcd.c |   29 +++++++++++++++++++++++++++++
 include/video/platform_lcd.h           |    7 +++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
index 302330a..ffa8108 100644
--- a/drivers/video/backlight/platform_lcd.c
+++ b/drivers/video/backlight/platform_lcd.c
@@ -17,6 +17,8 @@
 #include <linux/backlight.h>
 #include <linux/lcd.h>
 #include <linux/slab.h>
+#include <linux/regulator/consumer.h>
+#include <linux/regulator/machine.h>
 
 #include <video/platform_lcd.h>
 
@@ -44,11 +46,38 @@ static int platform_lcd_get_power(struct lcd_device *lcd)
 static int platform_lcd_set_power(struct lcd_device *lcd, int power)
 {
 	struct platform_lcd *plcd = to_our_lcd(lcd);
+	struct regulator *lcd_regulator;
 	int lcd_power = 1;
 
 	if (power == FB_BLANK_POWERDOWN || plcd->suspended)
 		lcd_power = 0;
 
+	/*
+	 * If power to lcd and/or lcd interface is controlled using a regulator,
+	 * enable or disable the regulator based in the power setting.
+	 */
+	lcd_regulator = regulator_get(plcd->us, "vcc_lcd");
+	if (IS_ERR(lcd_regulator)) {
+		dev_info(plcd->us, "could not get regulator\n");
+		goto set_power;
+	}
+
+	if (lcd_power) {
+		if (plcd->pdata->min_uV || plcd->pdata->max_uV)
+			if (regulator_set_voltage(lcd_regulator,
+				plcd->pdata->min_uV, plcd->pdata->max_uV))
+				dev_info(plcd->us,
+					"regulator voltage set failed\n");
+
+		if (regulator_enable(lcd_regulator))
+			dev_info(plcd->us, "failed to enable regulator\n");
+	} else {
+		regulator_disable(lcd_regulator);
+	}
+
+	regulator_put(lcd_regulator);
+
+set_power:
 	plcd->pdata->set_power(plcd->pdata, lcd_power);
 	plcd->power = power;
 
diff --git a/include/video/platform_lcd.h b/include/video/platform_lcd.h
index ad3bdfe..acd5d21 100644
--- a/include/video/platform_lcd.h
+++ b/include/video/platform_lcd.h
@@ -14,8 +14,15 @@
 struct plat_lcd_data;
 struct fb_info;
 
+/**
+ * struct plat_lcd_data - platform data for platform_lcd driver.
+ * @min_uV: Minimum required voltage output from the regulator.
+ * @max_uV: Maximum acceptable voltage output from the regulator.
+ */
 struct plat_lcd_data {
 	void	(*set_power)(struct plat_lcd_data *, unsigned int power);
 	int	(*match_fb)(struct plat_lcd_data *, struct fb_info *);
+	int	min_uV;
+	int	max_uV;
 };
 
-- 
1.6.6.rc2

