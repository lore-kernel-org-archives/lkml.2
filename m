Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab2DWQYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:24:07 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19183 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab2DWQXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:23:50 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 23 Apr 2012 18:24:01 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 2/2] i2c-s3c2410: Add HDMIPHY quirk for S3C2440
In-reply-to: <1335198241-19344-1-git-send-email-k.lewandowsk@samsung.com>
To: w.sang@pengutronix.de
Cc: m.szyprowski@samsung.com, ben-linux@fluff.org, thomas.abraham@linaro.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, kyungmin.park@samsung.com,
        broonie@opensource.wolfsonmicro.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1335198241-19344-3-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.9.5
References: <1335198241-19344-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for s3c2440 I2C bus controller dedicated HDMIPHY device on
Exynos4 platform. Some quirks are introduced due to differences between HDMIPHY
and other I2C controllers on Exynos4.  These differences are:
- no GPIOs, HDMIPHY is inside the SoC and the controller is connected
  internally
- due to unknown reason (probably HW bug in HDMIPHY and/or the controller) a
  transfer fails to finish. The controller hangs after sending the last byte,
  the workaround for this bug is resetting the controller after each transfer

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Tested-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/i2c/samsung-i2c.txt        |    8 ++++--
 drivers/i2c/busses/i2c-s3c2410.c                   |   30 ++++++++++++++++++++
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/samsung-i2c.txt b/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
index 38832c7..b6cb5a1 100644
--- a/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
+++ b/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
@@ -6,14 +6,18 @@ Required properties:
   - compatible: value should be either of the following.
       (a) "samsung, s3c2410-i2c", for i2c compatible with s3c2410 i2c.
       (b) "samsung, s3c2440-i2c", for i2c compatible with s3c2440 i2c.
+      (c) "samsung, s3c2440-hdmiphy-i2c", for s3c2440-like i2c used
+          inside HDMIPHY block found on several samsung SoCs
   - reg: physical base address of the controller and length of memory mapped
     region.
   - interrupts: interrupt number to the cpu.
   - samsung,i2c-sda-delay: Delay (in ns) applied to data line (SDA) edges.
-  - gpios: The order of the gpios should be the following: <SDA, SCL>.
-    The gpio specifier depends on the gpio controller.
 
 Optional properties:
+  - gpios: The order of the gpios should be the following: <SDA, SCL>.
+    The gpio specifier depends on the gpio controller. Required in all
+    cases except for "samsung,s3c2440-hdmiphy-i2c" whose input/output
+    lines are permanently wired to the respective client
   - samsung,i2c-slave-addr: Slave address in multi-master enviroment. If not
     specified, default value is 0.
   - samsung,i2c-max-bus-freq: Desired frequency in Hz of the bus. If not
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 23736ff..fa0b134 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -46,6 +46,8 @@
 
 /* Treat S3C2410 as baseline hardware, anything else is supported via quirks */
 #define QUIRK_S3C2440		(1 << 0)
+#define QUIRK_HDMIPHY		(1 << 1)
+#define QUIRK_NO_GPIO		(1 << 2)
 
 /* i2c controller state */
 enum s3c24xx_i2c_state {
@@ -93,6 +95,9 @@ static struct platform_device_id s3c24xx_driver_ids[] = {
 	}, {
 		.name		= "s3c2440-i2c",
 		.driver_data	= QUIRK_S3C2440,
+	}, {
+		.name		= "s3c2440-hdmiphy-i2c",
+		.driver_data	= QUIRK_S3C2440 | QUIRK_HDMIPHY | QUIRK_NO_GPIO,
 	}, { },
 };
 MODULE_DEVICE_TABLE(platform, s3c24xx_driver_ids);
@@ -101,6 +106,8 @@ MODULE_DEVICE_TABLE(platform, s3c24xx_driver_ids);
 static const struct of_device_id s3c24xx_i2c_match[] = {
 	{ .compatible = "samsung,s3c2410-i2c", .data = (void *)0 },
 	{ .compatible = "samsung,s3c2440-i2c", .data = (void *)QUIRK_S3C2440 },
+	{ .compatible = "samsung,s3c2440-hdmiphy-i2c",
+	  .data = (void *)(QUIRK_S3C2440 | QUIRK_HDMIPHY | QUIRK_NO_GPIO) },
 	{},
 };
 MODULE_DEVICE_TABLE(of, s3c24xx_i2c_match);
@@ -483,6 +490,13 @@ static int s3c24xx_i2c_set_master(struct s3c24xx_i2c *i2c)
 	unsigned long iicstat;
 	int timeout = 400;
 
+	/* the timeout for HDMIPHY is reduced to 10 ms because
+	 * the hangup is expected to happen, so waiting 400 ms
+	 * causes only unnecessary system hangup
+	 */
+	if (i2c->quirks & QUIRK_HDMIPHY)
+		timeout = 10;
+
 	while (timeout-- > 0) {
 		iicstat = readl(i2c->regs + S3C2410_IICSTAT);
 
@@ -492,6 +506,15 @@ static int s3c24xx_i2c_set_master(struct s3c24xx_i2c *i2c)
 		msleep(1);
 	}
 
+	/* hang-up of bus dedicated for HDMIPHY occurred, resetting */
+	if (i2c->quirks & QUIRK_HDMIPHY) {
+		writel(0, i2c->regs + S3C2410_IICCON);
+		writel(0, i2c->regs + S3C2410_IICSTAT);
+		writel(0, i2c->regs + S3C2410_IICDS);
+
+		return 0;
+	}
+
 	return -ETIMEDOUT;
 }
 
@@ -773,6 +796,9 @@ static int s3c24xx_i2c_parse_dt_gpio(struct s3c24xx_i2c *i2c)
 {
 	int idx, gpio, ret;
 
+	if (i2c->quirks & QUIRK_NO_GPIO)
+		return 0;
+
 	for (idx = 0; idx < 2; idx++) {
 		gpio = of_get_gpio(i2c->dev->of_node, idx);
 		if (!gpio_is_valid(gpio)) {
@@ -797,6 +823,10 @@ free_gpio:
 static void s3c24xx_i2c_dt_gpio_free(struct s3c24xx_i2c *i2c)
 {
 	unsigned int idx;
+
+	if (i2c->quirks & QUIRK_NO_GPIO)
+		return;
+
 	for (idx = 0; idx < 2; idx++)
 		gpio_free(i2c->gpios[idx]);
 }
-- 
1.7.9.5

