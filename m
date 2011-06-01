Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429Ab1FAKzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 06:55:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39793 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933373Ab1FAKzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 06:55:03 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Only register wm831x RTC device if the 32.768kHz crystal is enabled
Date: Wed,  1 Jun 2011 11:54:59 +0100
Message-Id: <1306925699-9310-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RTC uses the 32.768kHz crystal so if it's not enabled (and it can only
be enabled via OTP or InstantConfig, not runtime software) the RTC can't
function.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c |   48 ++++++++++++++++++++++++++------------------
 1 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index ff57a16..58f033b 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -976,11 +976,6 @@ static struct mfd_cell wm8310_devs[] = {
 		.resources = wm831x_power_resources,
 	},
 	{
-		.name = "wm831x-rtc",
-		.num_resources = ARRAY_SIZE(wm831x_rtc_resources),
-		.resources = wm831x_rtc_resources,
-	},
-	{
 		.name = "wm831x-status",
 		.id = 1,
 		.num_resources = ARRAY_SIZE(wm831x_status1_resources),
@@ -1108,11 +1103,6 @@ static struct mfd_cell wm8311_devs[] = {
 		.resources = wm831x_power_resources,
 	},
 	{
-		.name = "wm831x-rtc",
-		.num_resources = ARRAY_SIZE(wm831x_rtc_resources),
-		.resources = wm831x_rtc_resources,
-	},
-	{
 		.name = "wm831x-status",
 		.id = 1,
 		.num_resources = ARRAY_SIZE(wm831x_status1_resources),
@@ -1264,11 +1254,6 @@ static struct mfd_cell wm8312_devs[] = {
 		.resources = wm831x_power_resources,
 	},
 	{
-		.name = "wm831x-rtc",
-		.num_resources = ARRAY_SIZE(wm831x_rtc_resources),
-		.resources = wm831x_rtc_resources,
-	},
-	{
 		.name = "wm831x-status",
 		.id = 1,
 		.num_resources = ARRAY_SIZE(wm831x_status1_resources),
@@ -1395,11 +1380,6 @@ static struct mfd_cell wm8320_devs[] = {
 		.resources = wm831x_on_resources,
 	},
 	{
-		.name = "wm831x-rtc",
-		.num_resources = ARRAY_SIZE(wm831x_rtc_resources),
-		.resources = wm831x_rtc_resources,
-	},
-	{
 		.name = "wm831x-status",
 		.id = 1,
 		.num_resources = ARRAY_SIZE(wm831x_status1_resources),
@@ -1426,6 +1406,13 @@ static struct mfd_cell touch_devs[] = {
 	},
 };
 
+static struct mfd_cell rtc_devs[] = {
+	{
+		.name = "wm831x-rtc",
+		.num_resources = ARRAY_SIZE(wm831x_rtc_resources),
+		.resources = wm831x_rtc_resources,
+	},
+};
 
 static struct mfd_cell backlight_devs[] = {
 	{
@@ -1658,6 +1645,27 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 		goto err_irq;
 	}
 
+	/* The RTC can only be used if the 32.768kHz crystal is
+	 * enabled; this can't be controlled by software at runtime.
+	 */
+	ret = wm831x_reg_read(wm831x, WM831X_CLOCK_CONTROL_2);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Failed to read clock status: %d\n", ret);
+		goto err_irq;
+	}
+
+	if (ret & WM831X_XTAL_ENA) {
+		ret = mfd_add_devices(wm831x->dev, wm831x_num,
+				      rtc_devs, ARRAY_SIZE(rtc_devs),
+				      NULL, wm831x->irq_base);
+		if (ret != 0) {
+			dev_err(wm831x->dev, "Failed to add RTC: %d\n", ret);
+			goto err_irq;
+		}
+	} else {
+		dev_info(wm831x->dev, "32.768kHz clock disabled, no RTC\n");
+	}
+
 	if (pdata && pdata->backlight) {
 		/* Treat errors as non-critical */
 		ret = mfd_add_devices(wm831x->dev, wm831x_num, backlight_devs,
-- 
1.7.5.3

