Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab2FMQHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 12:07:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42039 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab2FMQHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 12:07:50 -0400
Message-ID: <4FD8BAD2.50703@linaro.org>
Date: Wed, 13 Jun 2012 17:07:46 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org
Subject: [PATCH 1/3] i2c: Add Device Tree support to the Nomadik I2C driver
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-10-git-send-email-lee.jones@linaro.org> <CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com>
In-Reply-To: <CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>
Date: Tue, 17 Apr 2012 16:04:13 +0100
Subject: [PATCH 1/3] i2c: Add Device Tree support to the Nomadik I2C driver

Here we apply the bindings required for successful Device Tree
probing of the i2c-nomadik driver. We also apply a fall-back
configuration in case either one is not provided, or a required
element is missing from the one supplied.

Cc: linux-i2c@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/i2c/busses/i2c-nomadik.c |   92 ++++++++++++++++++++++++++++++++++----
 1 file changed, 84 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index a92440d..b97f52e 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -23,6 +23,7 @@
 #include <linux/io.h>
 #include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
+#include <linux/of.h>
 
 #include <plat/i2c.h>
 
@@ -899,15 +900,86 @@ static const struct i2c_algorithm nmk_i2c_algo = {
 	.functionality	= nmk_i2c_functionality
 };
 
+static struct nmk_i2c_controller u8500_i2c = {
+	/*
+	 * Slave data setup time; 250ns, 100ns, and 10ns, which
+	 * is 14, 6 and 2 respectively for a 48Mhz i2c clock.
+	 */
+	.slsu           = 0xe,
+	.tft            = 1,      /* Tx FIFO threshold */
+	.rft            = 8,      /* Rx FIFO threshold */
+	.clk_freq       = 100000, /* std. mode operation */
+	.timeout        = 200,    /* Slave response timeout(ms) */
+	.sm             = I2C_FREQ_MODE_FAST,
+};
+
+static int __devinit
+nmk_i2c_of_probe(struct device_node *np, struct nmk_i2c_controller *pdata)
+{
+	of_property_read_u32(np, "clock-frequency", (u32*)&pdata->clk_freq);
+	if (!pdata->clk_freq) {
+		pr_warn("%s: Clock frequency not found\n", np->full_name);
+		return -EINVAL;
+	}
+
+	of_property_read_u32(np, "stericsson,slsu", (u32*)&pdata->slsu);
+	if (!pdata->slsu) {
+		pr_warn("%s: Data line delay not found\n", np->full_name);
+		return -EINVAL;
+	}
+
+	of_property_read_u32(np, "stericsson,tft", (u32*)&pdata->tft);
+	if (!pdata->tft) {
+		pr_warn("%s: Tx FIFO threshold not found\n", np->full_name);
+		return -EINVAL;
+	}
+
+	of_property_read_u32(np, "stericsson,rft", (u32*)&pdata->rft);
+	if (!pdata->rft) {
+		pr_warn("%s: Rx FIFO threshold not found\n", np->full_name);
+		return -EINVAL;
+	}
+
+	of_property_read_u32(np, "stericsson,timeout", (u32*)&pdata->timeout);
+	if (!pdata->timeout) {
+		pr_warn("%s: Timeout not found\n", np->full_name);
+		return -EINVAL;
+	}
+
+	if (of_get_property(np, "stericsson,i2c_freq_mode_fast", NULL))
+		pdata->sm = I2C_FREQ_MODE_FAST;
+	else
+		pdata->sm = I2C_FREQ_MODE_STANDARD;
+
+	return 0;
+}
+
 static int __devinit nmk_i2c_probe(struct platform_device *pdev)
 {
 	int ret = 0;
 	struct resource *res;
-	struct nmk_i2c_controller *pdata =
-			pdev->dev.platform_data;
+	struct nmk_i2c_controller *pdata = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
 	struct nmk_i2c_dev	*dev;
 	struct i2c_adapter *adap;
 
+	if (np) {
+		if (!pdata) {
+			pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+			if (!pdata) {
+				ret = -ENOMEM;
+				goto err_no_mem;
+			}
+		}
+		ret = nmk_i2c_of_probe(np, pdata);
+		if (ret)
+			kfree(pdata);
+	}
+
+	if (!pdata)
+		/* No i2c configuration found, using the default. */
+		pdata = &u8500_i2c;
+
 	dev = kzalloc(sizeof(struct nmk_i2c_dev), GFP_KERNEL);
 	if (!dev) {
 		dev_err(&pdev->dev, "cannot allocate memory\n");
@@ -974,12 +1046,10 @@ static int __devinit nmk_i2c_probe(struct platform_device *pdev)
 
 	/* fetch the controller configuration from machine */
 	dev->cfg.clk_freq = pdata->clk_freq;
-	dev->cfg.slsu	= pdata->slsu;
-	dev->cfg.tft	= pdata->tft;
-	dev->cfg.rft	= pdata->rft;
-	dev->cfg.sm	= pdata->sm;
-
-	i2c_set_adapdata(adap, dev);
+	dev->cfg.slsu	  = pdata->slsu;
+	dev->cfg.tft	  = pdata->tft;
+	dev->cfg.rft	  = pdata->rft;
+	dev->cfg.sm	  = pdata->sm;	i2c_set_adapdata(adap, dev);
 
 	dev_info(&pdev->dev,
 		 "initialize %s on virtual base %p\n",
@@ -1038,11 +1108,17 @@ static int __devexit nmk_i2c_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id nmk_gpio_match[] = {
+	{ .compatible = "st,nomadik-i2c", },
+	{},
+};
+
 static struct platform_driver nmk_i2c_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
 		.name = DRIVER_NAME,
 		.pm = &nmk_i2c_pm,
+		.of_match_table = nmk_gpio_match,
 	},
 	.probe = nmk_i2c_probe,
 	.remove = __devexit_p(nmk_i2c_remove),
-- 
1.7.9.5
