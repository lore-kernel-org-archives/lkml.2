Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761892Ab2KAR7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 13:59:20 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46671 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2KAR7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 13:59:17 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH 2/2] mfd: vexpress-sysreg: Use MMIO driver for platform LEDs
Date: Thu,  1 Nov 2012 17:58:42 +0000
Message-Id: <1351792722-15250-2-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1351792722-15250-1-git-send-email-pawel.moll@arm.com>
References: <1351792722-15250-1-git-send-email-pawel.moll@arm.com>
X-OriginalArrivalTime: 01 Nov 2012 17:59:14.0577 (UTC) FILETIME=[9AB59010:01CDB85A]
X-MC-Unique: 112110117591519201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qA1HxZso026062

This patch removes custom code for controlling LEDs on
Versatile Express platform and register MFD cell for
the SYS_LED register for the leds-mmio-simple driver.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/mfd/Kconfig           |    1 +
 drivers/mfd/vexpress-sysreg.c |  125 +++++++++++++++--------------------------
 2 files changed, 46 insertions(+), 80 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 637bcdf..611d989 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1073,6 +1073,7 @@ endmenu
 
 config VEXPRESS_CONFIG
 	bool
+	select MFD_CORE
 	help
 	  Platform configuration infrastructure for the ARM Ltd.
 	  Versatile Express.
diff --git a/drivers/mfd/vexpress-sysreg.c b/drivers/mfd/vexpress-sysreg.c
index 059d6b1..2241b98 100644
--- a/drivers/mfd/vexpress-sysreg.c
+++ b/drivers/mfd/vexpress-sysreg.c
@@ -15,6 +15,7 @@
 #include <linux/gpio.h>
 #include <linux/io.h>
 #include <linux/leds.h>
+#include <linux/mfd/core.h>
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
@@ -406,6 +407,35 @@ static struct gpio_chip vexpress_sysreg_gpio_chip = {
 };
 
 
+static struct mfd_cell vexpress_sysreg_leds = {
+	.name = "leds-mmio-simple",
+	.platform_data = &(struct mmio_simple_leds_platform_data) {
+		.reg_size = 32,
+		.shift = 0,
+		.width = 8,
+		.names = (const char *[]) {
+			"v2m:green:user1", "v2m:green:user2",
+			"v2m:green:user3", "v2m:green:user4",
+			"v2m:green:user5", "v2m:green:user6",
+			"v2m:green:user7", "v2m:green:user8",
+		},
+		.default_triggers = (const char *[]) {
+			"heartbeat", "mmc0",
+			"cpu0", "cpu1",
+			"cpu2", "cpu3",
+			"cpu4", "cpu5",
+		},
+		.init_off = true,
+	},
+	.pdata_size = sizeof(struct mmio_simple_leds_platform_data),
+	.num_resources = 1,
+	.resources = (struct resource []) {
+		DEFINE_RES_MEM(SYS_LED, 4),
+	},
+	.ignore_resource_conflicts = true,
+};
+
+
 static ssize_t vexpress_sysreg_sys_id_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -438,14 +468,19 @@ static int __devinit vexpress_sysreg_probe(struct platform_device *pdev)
 	setup_timer(&vexpress_sysreg_config_timer,
 			vexpress_sysreg_config_complete, 0);
 
+	err = mfd_add_devices(&pdev->dev, 0, &vexpress_sysreg_leds, 1,
+			res, 0, NULL);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to add LED device! (%d)\n", err);
+		goto error_mfd_add_devices;
+	}
+
 	vexpress_sysreg_gpio_chip.dev = &pdev->dev;
 	err = gpiochip_add(&vexpress_sysreg_gpio_chip);
 	if (err) {
-		vexpress_config_bridge_unregister(
-				vexpress_sysreg_config_bridge);
 		dev_err(&pdev->dev, "Failed to register GPIO chip! (%d)\n",
 				err);
-		return err;
+		goto error_gpiochip_add;
 	}
 
 	vexpress_sysreg_dev = &pdev->dev;
@@ -453,6 +488,13 @@ static int __devinit vexpress_sysreg_probe(struct platform_device *pdev)
 	device_create_file(vexpress_sysreg_dev, &dev_attr_sys_id);
 
 	return 0;
+
+error_gpiochip_add:
+	mfd_remove_devices(&pdev->dev);
+error_mfd_add_devices:
+	vexpress_config_bridge_unregister(vexpress_sysreg_config_bridge);
+	return err;
+
 }
 
 static const struct of_device_id vexpress_sysreg_match[] = {
@@ -473,80 +515,3 @@ static int __init vexpress_sysreg_init(void)
 	return platform_driver_register(&vexpress_sysreg_driver);
 }
 core_initcall(vexpress_sysreg_init);
-
-
-#if defined(CONFIG_LEDS_CLASS)
-
-struct vexpress_sysreg_led {
-	u32 mask;
-	struct led_classdev cdev;
-} vexpress_sysreg_leds[] = {
-	{ .mask = 1 << 0, .cdev.name = "v2m:green:user1",
-			.cdev.default_trigger = "heartbeat", },
-	{ .mask = 1 << 1, .cdev.name = "v2m:green:user2",
-			.cdev.default_trigger = "mmc0", },
-	{ .mask = 1 << 2, .cdev.name = "v2m:green:user3",
-			.cdev.default_trigger = "cpu0", },
-	{ .mask = 1 << 3, .cdev.name = "v2m:green:user4",
-			.cdev.default_trigger = "cpu1", },
-	{ .mask = 1 << 4, .cdev.name = "v2m:green:user5",
-			.cdev.default_trigger = "cpu2", },
-	{ .mask = 1 << 5, .cdev.name = "v2m:green:user6",
-			.cdev.default_trigger = "cpu3", },
-	{ .mask = 1 << 6, .cdev.name = "v2m:green:user7",
-			.cdev.default_trigger = "cpu4", },
-	{ .mask = 1 << 7, .cdev.name = "v2m:green:user8",
-			.cdev.default_trigger = "cpu5", },
-};
-
-static DEFINE_SPINLOCK(vexpress_sysreg_leds_lock);
-
-static void vexpress_sysreg_led_brightness_set(struct led_classdev *cdev,
-		enum led_brightness brightness)
-{
-	struct vexpress_sysreg_led *led = container_of(cdev,
-			struct vexpress_sysreg_led, cdev);
-	unsigned long flags;
-	u32 val;
-
-	spin_lock_irqsave(&vexpress_sysreg_leds_lock, flags);
-
-	val = readl(vexpress_sysreg_base + SYS_LED);
-	if (brightness == LED_OFF)
-		val &= ~led->mask;
-	else
-		val |= led->mask;
-	writel(val, vexpress_sysreg_base + SYS_LED);
-
-	spin_unlock_irqrestore(&vexpress_sysreg_leds_lock, flags);
-}
-
-static int __init vexpress_sysreg_init_leds(void)
-{
-	struct vexpress_sysreg_led *led;
-	int i;
-
-	/* Clear all user LEDs */
-	writel(0, vexpress_sysreg_base + SYS_LED);
-
-	for (i = 0, led = vexpress_sysreg_leds;
-			i < ARRAY_SIZE(vexpress_sysreg_leds); i++, led++) {
-		int err;
-
-		led->cdev.brightness_set = vexpress_sysreg_led_brightness_set;
-		err = led_classdev_register(vexpress_sysreg_dev, &led->cdev);
-		if (err) {
-			dev_err(vexpress_sysreg_dev,
-					"Failed to register LED %d! (%d)\n",
-					i, err);
-			while (led--, i--)
-				led_classdev_unregister(&led->cdev);
-			return err;
-		}
-	}
-
-	return 0;
-}
-device_initcall(vexpress_sysreg_init_leds);
-
-#endif
-- 
1.7.10.4


