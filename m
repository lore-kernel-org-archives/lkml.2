Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010Ab2EQNp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 09:45:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49108 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab2EQNpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 09:45:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/18] i2c: Add Device Tree support to the Nomadik I2C driver
Date: Thu, 17 May 2012 14:45:06 +0100
Message-Id: <1337262323-27692-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337262323-27692-1-git-send-email-lee.jones@linaro.org>
References: <1337262323-27692-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we move the i2c-nomadik's default settings into the driver
rather than specifying them from platform code. At the time of
this writing we only have one user, the u8500. As new users are
added, it is expected that they will be Device Tree compliant.
If this is the case, we will look up their initialisation values
by compatible entry, then apply them forthwith.

Cc: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/i2c/busses/i2c-nomadik.c |   40 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 5267ab9..cd45563 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -23,6 +23,7 @@
 #include <linux/io.h>
 #include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
+#include <linux/of_device.h>
 
 #include <plat/i2c.h>
 
@@ -899,15 +900,51 @@ static const struct i2c_algorithm nmk_i2c_algo = {
 	.functionality	= nmk_i2c_functionality
 };
 
+static struct nmk_i2c_controller u8500_i2c = {
+       /*
+        * slave data setup time, which is
+        * 250 ns,100ns,10ns which is 14,6,2
+        * respectively for a 48 Mhz
+        * i2c clock
+        */
+       .slsu           = 0xe,
+       /* Tx FIFO threshold */
+       .tft            = 1,
+       /* Rx FIFO threshold */
+       .rft            = 8,
+       /* std. mode operation */
+       .clk_freq       = 100000,
+       /* Slave response timeout(ms) */
+       .timeout        = 200,
+       .sm             = I2C_FREQ_MODE_FAST,
+};
+
+
+static const struct of_device_id nmk_gpio_match[] = {
+	{ .compatible = "st,nomadik-i2c", .data = &u8500_i2c, },
+	{}
+};
+
 static int __devinit nmk_i2c_probe(struct platform_device *pdev)
 {
 	int ret = 0;
 	struct resource *res;
-	struct nmk_i2c_controller *pdata =
+	const struct nmk_i2c_controller *pdata =
 			pdev->dev.platform_data;
+        const struct of_device_id *of_id =
+                        of_match_device(nmk_gpio_match, &pdev->dev);
 	struct nmk_i2c_dev	*dev;
 	struct i2c_adapter *adap;
 
+	if (!pdata) {
+		if (of_id && of_id->data)
+			/* Looks like we're booting via Device Tree. */
+			pdata = of_id->data;
+		else
+			/* No i2c configuration found, using the default. */
+			pdata = &u8500_i2c;
+	}
+
 	dev = kzalloc(sizeof(struct nmk_i2c_dev), GFP_KERNEL);
 	if (!dev) {
 		dev_err(&pdev->dev, "cannot allocate memory\n");
@@ -1044,6 +1081,7 @@ static struct platform_driver nmk_i2c_driver = {
 		.owner = THIS_MODULE,
 		.name = DRIVER_NAME,
 		.pm = &nmk_i2c_pm,
+		.of_match_table = nmk_gpio_match,
 	},
 	.probe = nmk_i2c_probe,
 	.remove = __devexit_p(nmk_i2c_remove),
-- 
1.7.9.5

