Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab2HFPRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:17:45 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49280 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab2HFPRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:17:42 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, w.sang@pengutronix.de, Lee Jones <lee.jones@linaro.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH 1/1] i2c: Add default configuration into the Nomadik I2C driver.
Date: Mon,  6 Aug 2012 16:17:33 +0100
Message-Id: <1344266253-14050-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this moment in time there is only one known configuration for the
Nomadik I2C driver. By not holding that configuration in the driver
adds some unnecessary overhead in platform code. The configuration
as already been removed from platform code, this patch checks for any
over-riding configurations. If there aren't any, the default is used.

Cc: linux-i2c@vger.kernel.org
Acked-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/i2c/busses/i2c-nomadik.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 5e6f1ee..e42e526 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -350,10 +350,6 @@ static void setup_i2c_controller(struct nmk_i2c_dev *dev)
 
 	i2c_clk = clk_get_rate(dev->clk);
 
-	/* fallback to std. mode if machine has not provided it */
-	if (dev->cfg.clk_freq == 0)
-		dev->cfg.clk_freq = 100000;
-
 	/*
 	 * The spec says, in case of std. mode the divider is
 	 * 2 whereas it is 3 for fast and fastplus mode of
@@ -911,20 +907,32 @@ static const struct i2c_algorithm nmk_i2c_algo = {
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
+	.clk_freq       = 400000, /* fast mode operation */
+	.timeout        = 200,    /* Slave response timeout(ms) */
+	.sm             = I2C_FREQ_MODE_FAST,
+};
+
 static atomic_t adapter_id = ATOMIC_INIT(0);
 
 static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 {
 	int ret = 0;
-	struct nmk_i2c_controller *pdata =
-			adev->dev.platform_data;
+	struct nmk_i2c_controller *pdata = pdev->dev.platform_data;
 	struct nmk_i2c_dev	*dev;
 	struct i2c_adapter *adap;
 
-	if (!pdata) {
-		dev_warn(&adev->dev, "no platform data\n");
-		return -ENODEV;
-	}
+	if (!pdata)
+		/* No i2c configuration found, using the default. */
+		pdata = &u8500_i2c;
+
 	dev = kzalloc(sizeof(struct nmk_i2c_dev), GFP_KERNEL);
 	if (!dev) {
 		dev_err(&adev->dev, "cannot allocate memory\n");
-- 
1.7.9.5

