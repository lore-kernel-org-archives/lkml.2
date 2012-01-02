Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab2ABFwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 00:52:05 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:23841 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2ABFvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 00:51:46 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-4d-4f0145f15f24
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, patches@linaro.org
Subject: [RFC][PATCH 1/4] lcd: platform-lcd: Eliminate need for platform data
Date: Mon, 02 Jan 2012 11:24:32 +0530
Message-id: <1325483675-21908-2-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>
References: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform data of platform-lcd driver includes pointers to platform specific
callbacks. These callbacks cannot be supported when adding device tree support.

Looking at all the usage of platform-lcd driver, the callbacks are mainly lcd
panel specific setup functions. Such setup functions can be moved into the
platform-lcd driver as lcd panel support, thereby not depending on platform
specific callbacks to be supplied as platform data.

For each of the lcd panel support that is added to the platform-lcd driver,
a set of panel specific callback functions need to be provided as driver
data. The platform-lcd driver uses these callback functions to setup and
control the lcd panel.

This patch eliminates the need for platform data and provides support for
adding lcd panel specific functionality.

Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/video/backlight/platform_lcd.c |   46 +++++++++++++++++++++++---------
 include/video/platform_lcd.h           |    9 ------
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
index 302330a..707c81f 100644
--- a/drivers/video/backlight/platform_lcd.c
+++ b/drivers/video/backlight/platform_lcd.c
@@ -23,12 +23,20 @@
 struct platform_lcd {
 	struct device		*us;
 	struct lcd_device	*lcd;
-	struct plat_lcd_data	*pdata;
+	void				*lcd_pdata;
+	struct plat_lcd_driver_data	*drv_data;
 
 	unsigned int		 power;
 	unsigned int		 suspended : 1;
 };
 
+struct plat_lcd_driver_data {
+	int	(*lcd_init)(struct platform_lcd *);
+	void	(*lcd_deinit)(struct platform_lcd *);
+	void	(*set_power)(struct platform_lcd *, unsigned int power);
+	int	(*match_fb)(struct platform_lcd *, struct fb_info *);
+};
+
 static inline struct platform_lcd *to_our_lcd(struct lcd_device *lcd)
 {
 	return lcd_get_data(lcd);
@@ -49,7 +57,8 @@ static int platform_lcd_set_power(struct lcd_device *lcd, int power)
 	if (power == FB_BLANK_POWERDOWN || plcd->suspended)
 		lcd_power = 0;
 
-	plcd->pdata->set_power(plcd->pdata, lcd_power);
+	if (plcd->drv_data->set_power)
+		plcd->drv_data->set_power(plcd, lcd_power);
 	plcd->power = power;
 
 	return 0;
@@ -58,10 +67,9 @@ static int platform_lcd_set_power(struct lcd_device *lcd, int power)
 static int platform_lcd_match(struct lcd_device *lcd, struct fb_info *info)
 {
 	struct platform_lcd *plcd = to_our_lcd(lcd);
-	struct plat_lcd_data *pdata = plcd->pdata;
 
-	if (pdata->match_fb)
-		return pdata->match_fb(pdata, info);
+	if (plcd->drv_data->match_fb)
+		return plcd->drv_data->match_fb(plcd, info);
 
 	return plcd->us->parent == info->device;
 }
@@ -72,19 +80,19 @@ static struct lcd_ops platform_lcd_ops = {
 	.check_fb	= platform_lcd_match,
 };
 
+static inline struct plat_lcd_driver_data *platform_lcd_get_driver_data(
+			struct platform_device *pdev)
+{
+	return (struct plat_lcd_driver_data *)
+			platform_get_device_id(pdev)->driver_data;
+}
+
 static int __devinit platform_lcd_probe(struct platform_device *pdev)
 {
-	struct plat_lcd_data *pdata;
 	struct platform_lcd *plcd;
 	struct device *dev = &pdev->dev;
 	int err;
 
-	pdata = pdev->dev.platform_data;
-	if (!pdata) {
-		dev_err(dev, "no platform data supplied\n");
-		return -EINVAL;
-	}
-
 	plcd = kzalloc(sizeof(struct platform_lcd), GFP_KERNEL);
 	if (!plcd) {
 		dev_err(dev, "no memory for state\n");
@@ -92,7 +100,12 @@ static int __devinit platform_lcd_probe(struct platform_device *pdev)
 	}
 
 	plcd->us = dev;
-	plcd->pdata = pdata;
+	plcd->lcd_pdata = plcd->us->platform_data;
+	plcd->drv_data = platform_lcd_get_driver_data(pdev);
+	err = plcd->drv_data->lcd_init(plcd);
+	if (err)
+		goto err_mem;
+
 	plcd->lcd = lcd_device_register(dev_name(dev), dev,
 					plcd, &platform_lcd_ops);
 	if (IS_ERR(plcd->lcd)) {
@@ -116,6 +129,7 @@ static int __devexit platform_lcd_remove(struct platform_device *pdev)
 	struct platform_lcd *plcd = platform_get_drvdata(pdev);
 
 	lcd_device_unregister(plcd->lcd);
+	plcd->drv_data->lcd_deinit(plcd);
 	kfree(plcd);
 
 	return 0;
@@ -146,6 +160,11 @@ static int platform_lcd_resume(struct platform_device *pdev)
 #define platform_lcd_resume NULL
 #endif
 
+
+static struct platform_device_id platform_lcd_driver_ids[] = {
+	{ },
+};
+
 static struct platform_driver platform_lcd_driver = {
 	.driver		= {
 		.name	= "platform-lcd",
@@ -155,6 +174,7 @@ static struct platform_driver platform_lcd_driver = {
 	.remove		= __devexit_p(platform_lcd_remove),
 	.suspend        = platform_lcd_suspend,
 	.resume         = platform_lcd_resume,
+	.id_table	= platform_lcd_driver_ids,
 };
 
 static int __init platform_lcd_init(void)
diff --git a/include/video/platform_lcd.h b/include/video/platform_lcd.h
index ad3bdfe..8e6081a 100644
--- a/include/video/platform_lcd.h
+++ b/include/video/platform_lcd.h
@@ -10,12 +10,3 @@
  * published by the Free Software Foundation.
  *
 */
-
-struct plat_lcd_data;
-struct fb_info;
-
-struct plat_lcd_data {
-	void	(*set_power)(struct plat_lcd_data *, unsigned int power);
-	int	(*match_fb)(struct plat_lcd_data *, struct fb_info *);
-};
-
-- 
1.6.6.rc2

