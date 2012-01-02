Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119Ab2ABFwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 00:52:24 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61230 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2ABFvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 00:51:49 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-a7-4f0145f41571
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, patches@linaro.org
Subject: [RFC][PATCH 2/4] lcd: platform-lcd: Add support for Hydis hv070wsa lcd
 panel
Date: Mon, 02 Jan 2012 11:24:33 +0530
Message-id: <1325483675-21908-3-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1325483675-21908-2-git-send-email-thomas.abraham@linaro.org>
References: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>
 <1325483675-21908-2-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Hydis hv070wsa lcd panel setup and control support in platform-lcd driver.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/video/backlight/Kconfig        |    6 ++++
 drivers/video/backlight/platform_lcd.c |   49 ++++++++++++++++++++++++++++++++
 include/video/platform_lcd.h           |    6 ++++
 3 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 278aeaa..ef4e9a7 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -86,6 +86,12 @@ config LCD_PLATFORM
 	  This driver provides a platform-device registered LCD power
 	  control interface.
 
+config LCD_HYDIS_HV070WSA
+	tristate "Hydis HV070WSA LCD"
+	depends on LCD_PLATFORM
+	help
+	  Enable support for Hydis HV070WSA lcd panel
+
 config LCD_TOSA
 	tristate "Sharp SL-6000 LCD Driver"
 	depends on SPI && MACH_TOSA
diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
index 707c81f..feb4fd0 100644
--- a/drivers/video/backlight/platform_lcd.c
+++ b/drivers/video/backlight/platform_lcd.c
@@ -17,6 +17,7 @@
 #include <linux/backlight.h>
 #include <linux/lcd.h>
 #include <linux/slab.h>
+#include <linux/gpio.h>
 
 #include <video/platform_lcd.h>
 
@@ -160,10 +161,58 @@ static int platform_lcd_resume(struct platform_device *pdev)
 #define platform_lcd_resume NULL
 #endif
 
+#ifdef CONFIG_LCD_HYDIS_HV070WSA
+static int lcd_hv070wsa_init(struct platform_lcd *plcd)
+{
+	struct plat_lcd_hydis_hv070wsa_pdata *pdata = plcd->lcd_pdata;
+	int err;
+
+	if (!pdata) {
+		dev_err(plcd->us, "no platform data\n");
+		return -EINVAL;
+	}
+
+	err = gpio_request(pdata->gpio, "HV070WSA_GPIO");
+	if (err) {
+		dev_err(plcd->us, "gpio request failed for %d\n", pdata->gpio);
+		return err;
+	}
+
+	return 0;
+}
+
+static void lcd_hv070wsa_deinit(struct platform_lcd *plcd)
+{
+	struct plat_lcd_hydis_hv070wsa_pdata *pdata = plcd->lcd_pdata;
+
+	gpio_free(pdata->gpio);
+}
+
+static void lcd_hv070wsa_set_power(struct platform_lcd *plcd, unsigned int pwr)
+{
+	struct plat_lcd_hydis_hv070wsa_pdata *pdata = plcd->lcd_pdata;
+
+	gpio_direction_output(pdata->gpio, pwr);
+}
+
+static struct plat_lcd_driver_data hv070wsa_driver_data = {
+	.lcd_init	= lcd_hv070wsa_init,
+	.lcd_deinit	= lcd_hv070wsa_deinit,
+	.set_power	= lcd_hv070wsa_set_power,
+};
+#define HV070WSA_DRV_DATA ((kernel_ulong_t)&hv070wsa_driver_data)
+#else
+#define HV070WSA_DRV_DATA (kernel_ulong_t)NULL
+#endif /* CONFIG_LCD_HYDIS_HV070WSA */
 
 static struct platform_device_id platform_lcd_driver_ids[] = {
+	{
+		.name		= "hv070wsa",
+		.driver_data	= HV070WSA_DRV_DATA,
+	},
 	{ },
 };
+MODULE_DEVICE_TABLE(platform, platform_lcd_driver_ids);
 
 static struct platform_driver platform_lcd_driver = {
 	.driver		= {
diff --git a/include/video/platform_lcd.h b/include/video/platform_lcd.h
index 8e6081a..d2fa188 100644
--- a/include/video/platform_lcd.h
+++ b/include/video/platform_lcd.h
@@ -10,3 +10,9 @@
  * published by the Free Software Foundation.
  *
 */
+
+#ifdef CONFIG_LCD_HYDIS_HV070WSA
+struct plat_lcd_hydis_hv070wsa_pdata {
+	unsigned int		gpio;
+};
+#endif
-- 
1.6.6.rc2

