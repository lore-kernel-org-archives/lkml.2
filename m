Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab0HTI1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:27:39 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:55832 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866Ab0HTI1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:27:31 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 2/2] MFD: switch AB3100 to use MFD cells
Date: Fri, 20 Aug 2010 10:27:12 +0200
Message-ID: <1282292832-4604-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This switches the AB3100 core driver to using MFD cells for
subdevices instead of spawning common platform devices.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/Kconfig       |    1 +
 drivers/mfd/ab3100-core.c |  129 ++++++++++++++++++++++++---------------------
 2 files changed, 69 insertions(+), 61 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index bfc80d6..22985d0 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -444,6 +444,7 @@ config ABX500_CORE
 config AB3100_CORE
 	bool "ST-Ericsson AB3100 Mixed Signal Circuit core functions"
 	depends on I2C=y && ABX500_CORE
+	select MFD_CORE
 	default y if ARCH_U300
 	help
 	  Select this to enable the AB3100 Mixed Signal IC core
diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 1be9fb6..8e84e78 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -19,6 +19,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
+#include <linux/mfd/core.h>
 #include <linux/mfd/abx500.h>
 
 /* These are the only registers inside AB3100 used in this main file */
@@ -146,7 +147,7 @@ static int ab3100_set_test_register_interruptible(struct ab3100 *ab3100,
 }
 
 static int ab3100_get_register_interruptible(struct ab3100 *ab3100,
-	u8 reg, u8 *regval)
+					     u8 reg, u8 *regval)
 {
 	int err;
 
@@ -202,7 +203,7 @@ static int ab3100_get_register_interruptible(struct ab3100 *ab3100,
 }
 
 static int get_register_interruptible(struct device *dev, u8 bank, u8 reg,
-	u8 *value)
+				      u8 *value)
 {
 	struct ab3100 *ab3100 = dev_get_drvdata(dev->parent);
 
@@ -742,52 +743,64 @@ static int __devinit ab3100_setup(struct ab3100 *ab3100)
 	return err;
 }
 
-/*
- * Here we define all the platform devices that appear
- * as children of the AB3100. These are regular platform
- * devices with the IORESOURCE_IO .start and .end set
- * to correspond to the internal AB3100 register range
- * mapping to the corresponding subdevice.
- */
-
-#define AB3100_DEVICE(devname, devid)				\
-static struct platform_device ab3100_##devname##_device = {	\
-	.name		= devid,				\
-	.id		= -1,					\
-}
-
-/* This lists all the subdevices */
-AB3100_DEVICE(dac, "ab3100-dac");
-AB3100_DEVICE(leds, "ab3100-leds");
-AB3100_DEVICE(power, "ab3100-power");
-AB3100_DEVICE(regulators, "ab3100-regulators");
-AB3100_DEVICE(sim, "ab3100-sim");
-AB3100_DEVICE(uart, "ab3100-uart");
-AB3100_DEVICE(rtc, "ab3100-rtc");
-AB3100_DEVICE(charger, "ab3100-charger");
-AB3100_DEVICE(boost, "ab3100-boost");
-AB3100_DEVICE(adc, "ab3100-adc");
-AB3100_DEVICE(fuelgauge, "ab3100-fuelgauge");
-AB3100_DEVICE(vibrator, "ab3100-vibrator");
-AB3100_DEVICE(otp, "ab3100-otp");
-AB3100_DEVICE(codec, "ab3100-codec");
-
-static struct platform_device *
-ab3100_platform_devs[] = {
-	&ab3100_dac_device,
-	&ab3100_leds_device,
-	&ab3100_power_device,
-	&ab3100_regulators_device,
-	&ab3100_sim_device,
-	&ab3100_uart_device,
-	&ab3100_rtc_device,
-	&ab3100_charger_device,
-	&ab3100_boost_device,
-	&ab3100_adc_device,
-	&ab3100_fuelgauge_device,
-	&ab3100_vibrator_device,
-	&ab3100_otp_device,
-	&ab3100_codec_device,
+/* The subdevices of the AB3100 */
+static struct mfd_cell ab3100_devs[] = {
+	{
+		.name = "ab3100-dac",
+		.id = -1,
+	},
+	{
+		.name = "ab3100-leds",
+		.id = -1,
+	},
+	{
+		.name = "ab3100-power",
+		.id = -1,
+	},
+	{
+		.name = "ab3100-regulators",
+		.id = -1,
+	},
+	{
+		.name = "ab3100-sim",
+		.id = -1,
+	},
+	{
+		.name = "ab3100-uart",
+		.id = -1,
+	},
+	{
+		.name = "ab3100-rtc",
+		.id = -1,
+	},
+	{
+		.name = "ab3100-charger",
+		.id = -1,
+	},
+	{
+		.name = "ab3100-boost",
+		.id = -1,
+	},
+	{
+		.name = "ab3100-adc",
+		.id = -1,
+	},
+	{
+		.name = "ab3100-fuelgauge",
+		.id = -1,
+	},
+	{
+		.name = "ab3100-vibrator",
+		.id = -1,
+	},
+	{
+		.name = "ab3100-otp",
+		.id = -1,
+	},
+	{
+		.name = "ab3100-codec",
+		.id = -1,
+	},
 };
 
 struct ab_family_id {
@@ -934,18 +947,14 @@ static int __devinit ab3100_probe(struct i2c_client *client,
 	if (err)
 		goto exit_no_ops;
 
-	/* Set parent and a pointer back to the container in device data */
-	for (i = 0; i < ARRAY_SIZE(ab3100_platform_devs); i++) {
-		ab3100_platform_devs[i]->dev.parent =
-			&client->dev;
-		ab3100_platform_devs[i]->dev.platform_data =
-			ab3100_plf_data;
-		platform_set_drvdata(ab3100_platform_devs[i], ab3100);
+	/* Set up and register the platform devices. */
+	for (i = 0; i < ARRAY_SIZE(ab3100_devs); i++) {
+		ab3100_devs[i].platform_data = ab3100_plf_data;
+		ab3100_devs[i].data_size = sizeof(struct ab3100_platform_data);
 	}
 
-	/* Register the platform devices */
-	platform_add_devices(ab3100_platform_devs,
-			     ARRAY_SIZE(ab3100_platform_devs));
+	err = mfd_add_devices(&client->dev, 0, ab3100_devs,
+		ARRAY_SIZE(ab3100_devs), NULL, 0);
 
 	ab3100_setup_debugfs(ab3100);
 
@@ -964,11 +973,9 @@ static int __devinit ab3100_probe(struct i2c_client *client,
 static int __devexit ab3100_remove(struct i2c_client *client)
 {
 	struct ab3100 *ab3100 = i2c_get_clientdata(client);
-	int i;
 
 	/* Unregister subdevices */
-	for (i = 0; i < ARRAY_SIZE(ab3100_platform_devs); i++)
-		platform_device_unregister(ab3100_platform_devs[i]);
+	mfd_remove_devices(&client->dev);
 
 	ab3100_remove_debugfs();
 	i2c_unregister_device(ab3100->testreg_client);
-- 
1.6.3.3

