Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1DDNcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 09:32:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47338 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754429Ab1DDNca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:32:30 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Provide platform data for WM831x GPIO configuration
Date: Mon,  4 Apr 2011 11:04:42 +0900
Message-Id: <1301882682-29329-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the GPIO mode of WM831x devices to be configured using platform data.
Users may provide a table of GPIO register values in gpio_defaults[]. In
order to allow 0 to be set explicitly out of range values are accepted and
masked off, with a WM831X_GPIO_CONFIGURE define provided to set an out of
range value.

This can be used to configure higher numbered GPIOs or override values set
in OTP for GPIOs configured using OTP.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c        |   13 ++++++++++++-
 include/linux/mfd/wm831x/pdata.h |    4 ++++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 3fe9a58..265f75f 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1442,7 +1442,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
 	int rev;
 	enum wm831x_parent parent;
-	int ret;
+	int ret, i;
 
 	mutex_init(&wm831x->io_lock);
 	mutex_init(&wm831x->key_lock);
@@ -1581,6 +1581,17 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 		}
 	}
 
+	if (pdata) {
+		for (i = 0; i < ARRAY_SIZE(pdata->gpio_defaults); i++) {
+			if (!pdata->gpio_defaults[i])
+				continue;
+
+			wm831x_reg_write(wm831x,
+					 WM831X_GPIO1_CONTROL + i,
+					 pdata->gpio_defaults[i] & 0xffff);
+		}
+	}
+
 	ret = wm831x_irq_init(wm831x, irq);
 	if (ret != 0)
 		goto err;
diff --git a/include/linux/mfd/wm831x/pdata.h b/include/linux/mfd/wm831x/pdata.h
index 632d156..ff42d70 100644
--- a/include/linux/mfd/wm831x/pdata.h
+++ b/include/linux/mfd/wm831x/pdata.h
@@ -105,6 +105,9 @@ struct wm831x_watchdog_pdata {
 #define WM831X_MAX_LDO    11
 #define WM831X_MAX_ISINK  2
 
+#define WM831X_GPIO_CONFIGURE 0x10000
+#define WM831X_GPIO_NUM 16
+
 struct wm831x_pdata {
 	/** Used to distinguish multiple WM831x chips */
 	int wm831x_num;
@@ -119,6 +122,7 @@ struct wm831x_pdata {
 
 	int irq_base;
 	int gpio_base;
+	int gpio_defaults[WM831X_GPIO_NUM];
 	struct wm831x_backlight_pdata *backlight;
 	struct wm831x_backup_pdata *backup;
 	struct wm831x_battery_pdata *battery;
-- 
1.7.4.1

