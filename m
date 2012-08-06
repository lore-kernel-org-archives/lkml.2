Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab2HFPfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:35:13 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62830 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab2HFPfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:35:10 -0400
Date: Mon, 6 Aug 2012 16:35:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, w.sang@pengutronix.de, linux-i2c@vger.kernel.org
Subject: [PATCH 1/1 v2] i2c: Add default configuration into the Nomadik I2C
 driver.
Message-ID: <20120806153503.GH10524@gmail.com>
References: <1344266253-14050-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344266253-14050-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like I introduced a merge error on the last patch. Trying again:

From: Lee Jones <lee.jones@linaro.org>
Date: Mon, 6 Aug 2012 11:04:14 +0100
Subject: [PATCH 1/1 v2] i2c: Add default configuration into the Nomadik I2C
 driver.

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
 .../mali/mali400ko/driver/src/devicedrv/mali/arch  |    1 +
 drivers/i2c/busses/i2c-nomadik.c                   |   28 +++++++++++++-------
 2 files changed, 19 insertions(+), 10 deletions(-)
 create mode 120000 drivers/gpu/mali/mali400ko/driver/src/devicedrv/mali/arch

diff --git a/drivers/gpu/mali/mali400ko/driver/src/devicedrv/mali/arch b/drivers/gpu/mali/mali400ko/driver/src/devicedrv/mali/arch
new file mode 120000
index 0000000..427334b
--- /dev/null
+++ b/drivers/gpu/mali/mali400ko/driver/src/devicedrv/mali/arch
@@ -0,0 +1 @@
+/home/ljkenny/projects/linaro/snowball/snowball/drivers/gpu/mali/mali400ko/driver/src/devicedrv/mali/arch-ux500
\ No newline at end of file
diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 5e6f1ee..61b00ed 100644
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
+	struct nmk_i2c_controller *pdata = adev->dev.platform_data;
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
