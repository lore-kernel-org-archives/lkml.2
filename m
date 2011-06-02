Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab1FBSUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:20:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36559 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754072Ab1FBSUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:20:02 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/9] mfd: Implement support for multiple WM831x devices
Date: Thu,  2 Jun 2011 19:18:48 +0100
Message-Id: <1307038735-18788-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1307038735-18788-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110602181808.GA18726@opensource.wolfsonmicro.com>
 <1307038735-18788-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Systems using this functionality will be uncommon.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 265f75f..04994b2 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1440,7 +1440,7 @@ static struct mfd_cell backlight_devs[] = {
 int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 {
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
-	int rev;
+	int rev, wm831x_num;
 	enum wm831x_parent parent;
 	int ret, i;
 
@@ -1592,6 +1592,12 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 		}
 	}
 
+	/* Multiply by 10 as we have many subdevices of the same type */
+	if (pdata && pdata->wm831x_num)
+		wm831x_num = pdata->wm831x_num * 10;
+	else
+		wm831x_num = -1;
+
 	ret = wm831x_irq_init(wm831x, irq);
 	if (ret != 0)
 		goto err;
@@ -1609,19 +1615,19 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	/* The core device is up, instantiate the subdevices. */
 	switch (parent) {
 	case WM8310:
-		ret = mfd_add_devices(wm831x->dev, -1,
+		ret = mfd_add_devices(wm831x->dev, wm831x_num,
 				      wm8310_devs, ARRAY_SIZE(wm8310_devs),
 				      NULL, wm831x->irq_base);
 		break;
 
 	case WM8311:
-		ret = mfd_add_devices(wm831x->dev, -1,
+		ret = mfd_add_devices(wm831x->dev, wm831x_num,
 				      wm8311_devs, ARRAY_SIZE(wm8311_devs),
 				      NULL, wm831x->irq_base);
 		break;
 
 	case WM8312:
-		ret = mfd_add_devices(wm831x->dev, -1,
+		ret = mfd_add_devices(wm831x->dev, wm831x_num,
 				      wm8312_devs, ARRAY_SIZE(wm8312_devs),
 				      NULL, wm831x->irq_base);
 		break;
@@ -1630,7 +1636,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	case WM8321:
 	case WM8325:
 	case WM8326:
-		ret = mfd_add_devices(wm831x->dev, -1,
+		ret = mfd_add_devices(wm831x->dev, wm831x_num,
 				      wm8320_devs, ARRAY_SIZE(wm8320_devs),
 				      NULL, wm831x->irq_base);
 		break;
@@ -1647,7 +1653,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 
 	if (pdata && pdata->backlight) {
 		/* Treat errors as non-critical */
-		ret = mfd_add_devices(wm831x->dev, -1, backlight_devs,
+		ret = mfd_add_devices(wm831x->dev, wm831x_num, backlight_devs,
 				      ARRAY_SIZE(backlight_devs), NULL,
 				      wm831x->irq_base);
 		if (ret < 0)
-- 
1.7.5.3

