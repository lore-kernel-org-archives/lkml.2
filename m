Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab2GGVzb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 17:55:31 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:57746 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab2GGVza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 17:55:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4][update] hwmon / gpio-fan: Use struct dev_pm_ops for power management
Date: Sun, 8 Jul 2012 00:01:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <linux@roeck-us.net>, Kukjin Kim <kgene.kim@samsung.com>
References: <201207072302.16491.rjw@sisk.pl> <201207072305.28595.rjw@sisk.pl>
In-Reply-To: <201207072305.28595.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207080001.03666.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the gpio-fan driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct platform_driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

dev_get_drvdata() may be used directly instead of being wrapped in
platform_get_drvdata(to_platform_device()).

---
 drivers/hwmon/gpio-fan.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: linux/drivers/hwmon/gpio-fan.c
===================================================================
--- linux.orig/drivers/hwmon/gpio-fan.c
+++ linux/drivers/hwmon/gpio-fan.c
@@ -503,9 +503,9 @@ static int __devexit gpio_fan_remove(str
 }
 
 #ifdef CONFIG_PM
-static int gpio_fan_suspend(struct platform_device *pdev, pm_message_t state)
+static int gpio_fan_suspend(struct device *dev)
 {
-	struct gpio_fan_data *fan_data = platform_get_drvdata(pdev);
+	struct gpio_fan_data *fan_data = dev_get_drvdata(dev);
 
 	if (fan_data->ctrl) {
 		fan_data->resume_speed = fan_data->speed_index;
@@ -515,27 +515,28 @@ static int gpio_fan_suspend(struct platf
 	return 0;
 }
 
-static int gpio_fan_resume(struct platform_device *pdev)
+static int gpio_fan_resume(struct device *dev)
 {
-	struct gpio_fan_data *fan_data = platform_get_drvdata(pdev);
+	struct gpio_fan_data *fan_data = dev_get_drvdata(dev);
 
 	if (fan_data->ctrl)
 		set_fan_speed(fan_data, fan_data->resume_speed);
 
 	return 0;
 }
+
+static SIMPLE_DEV_PM_OPS(gpio_fan_pm, gpio_fan_suspend, gpio_fan_resume);
+#define GPIO_FAN_PM	(&gpio_fan_pm)
 #else
-#define gpio_fan_suspend NULL
-#define gpio_fan_resume NULL
+#define GPIO_FAN_PM	NULL
 #endif
 
 static struct platform_driver gpio_fan_driver = {
 	.probe		= gpio_fan_probe,
 	.remove		= __devexit_p(gpio_fan_remove),
-	.suspend	= gpio_fan_suspend,
-	.resume		= gpio_fan_resume,
 	.driver	= {
 		.name	= "gpio-fan",
+		.pm	= GPIO_FAN_PM,
 	},
 };
 

