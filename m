Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1FBSUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:20:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36555 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753864Ab1FBSUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:20:02 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/9] mfd: Allow touchscreen to be disabled on wm831x devices
Date: Thu,  2 Jun 2011 19:18:49 +0100
Message-Id: <1307038735-18788-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1307038735-18788-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110602181808.GA18726@opensource.wolfsonmicro.com>
 <1307038735-18788-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow platform data to flag the touchscreen as disabled so that if the
touch driver is built in we don't end up causing lots of work by spuriously
detecting touchscreen activity on systems where it isn't in use.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c        |   27 +++++++++++++++++----------
 include/linux/mfd/wm831x/pdata.h |    3 +++
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 04994b2..ff57a16 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1125,11 +1125,6 @@ static struct mfd_cell wm8311_devs[] = {
 		.resources = wm831x_status2_resources,
 	},
 	{
-		.name = "wm831x-touch",
-		.num_resources = ARRAY_SIZE(wm831x_touch_resources),
-		.resources = wm831x_touch_resources,
-	},
-	{
 		.name = "wm831x-watchdog",
 		.num_resources = ARRAY_SIZE(wm831x_wdt_resources),
 		.resources = wm831x_wdt_resources,
@@ -1286,11 +1281,6 @@ static struct mfd_cell wm8312_devs[] = {
 		.resources = wm831x_status2_resources,
 	},
 	{
-		.name = "wm831x-touch",
-		.num_resources = ARRAY_SIZE(wm831x_touch_resources),
-		.resources = wm831x_touch_resources,
-	},
-	{
 		.name = "wm831x-watchdog",
 		.num_resources = ARRAY_SIZE(wm831x_wdt_resources),
 		.resources = wm831x_wdt_resources,
@@ -1428,6 +1418,15 @@ static struct mfd_cell wm8320_devs[] = {
 	},
 };
 
+static struct mfd_cell touch_devs[] = {
+	{
+		.name = "wm831x-touch",
+		.num_resources = ARRAY_SIZE(wm831x_touch_resources),
+		.resources = wm831x_touch_resources,
+	},
+};
+
+
 static struct mfd_cell backlight_devs[] = {
 	{
 		.name = "wm831x-backlight",
@@ -1624,12 +1623,20 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 		ret = mfd_add_devices(wm831x->dev, wm831x_num,
 				      wm8311_devs, ARRAY_SIZE(wm8311_devs),
 				      NULL, wm831x->irq_base);
+		if (!pdata || !pdata->disable_touch)
+			mfd_add_devices(wm831x->dev, wm831x_num,
+					touch_devs, ARRAY_SIZE(touch_devs),
+					NULL, wm831x->irq_base);
 		break;
 
 	case WM8312:
 		ret = mfd_add_devices(wm831x->dev, wm831x_num,
 				      wm8312_devs, ARRAY_SIZE(wm8312_devs),
 				      NULL, wm831x->irq_base);
+		if (!pdata || !pdata->disable_touch)
+			mfd_add_devices(wm831x->dev, wm831x_num,
+					touch_devs, ARRAY_SIZE(touch_devs),
+					NULL, wm831x->irq_base);
 		break;
 
 	case WM8320:
diff --git a/include/linux/mfd/wm831x/pdata.h b/include/linux/mfd/wm831x/pdata.h
index ff42d70..0ba2459 100644
--- a/include/linux/mfd/wm831x/pdata.h
+++ b/include/linux/mfd/wm831x/pdata.h
@@ -120,6 +120,9 @@ struct wm831x_pdata {
 	/** Put the /IRQ line into CMOS mode */
 	bool irq_cmos;
 
+	/** Disable the touchscreen */
+	bool disable_touch;
+
 	int irq_base;
 	int gpio_base;
 	int gpio_defaults[WM831X_GPIO_NUM];
-- 
1.7.5.3

