Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab2CMSNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:13:33 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30327 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470Ab2CMSNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:13:31 -0400
Date: Tue, 13 Mar 2012 19:13:25 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH] i2c-s3c2410: Add HDMIPHY quirk for S3C2440
In-reply-to: <4F5F838A.6030908@samsung.com>
To: ben-linux@fluff.org
Cc: thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1331662405-7877-1-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.9
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <4F5F838A.6030908@samsung.com>
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
 .../devicetree/bindings/i2c/samsung-i2c.txt        |   11 +++++-
 drivers/i2c/busses/i2c-s3c2410.c                   |   35 ++++++++++++++++++++
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/samsung-i2c.txt b/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
index 38832c7..c6670f9 100644
--- a/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
+++ b/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
@@ -10,14 +10,21 @@ Required properties:
     region.
   - interrupts: interrupt number to the cpu.
   - samsung,i2c-sda-delay: Delay (in ns) applied to data line (SDA) edges.
-  - gpios: The order of the gpios should be the following: <SDA, SCL>.
-    The gpio specifier depends on the gpio controller.
 
 Optional properties:
+  - gpios: The order of the gpios should be the following: <SDA, SCL>.
+    The gpio specifier depends on the gpio controller. Required in all cases
+    except when "samsung,i2c-no-gpio" is also specified.
+  - samsung,i2c-no-gpio: input/output lines of the controller are
+    permanently wired to the respective client, there are no gpio
+    lines that need to be configured to enable this controller
   - samsung,i2c-slave-addr: Slave address in multi-master enviroment. If not
     specified, default value is 0.
   - samsung,i2c-max-bus-freq: Desired frequency in Hz of the bus. If not
     specified, the default value in Hz is 100000.
+  - samsung,i2c-quirk-hdmiphy: Quirk for HDMI PHY block found on
+    Exynos4 platform - reduce timeout and reset controller after each
+    transfer
 
 Example:
 
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index f84d26f..fa5f8c4 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -52,6 +52,8 @@ static const struct of_device_id s3c24xx_i2c_match[];
 #define TYPE_BITS		0x000000ff
 #define TYPE_S3C2410		0x00000001
 #define TYPE_S3C2440		0x00000002
+#define FLAG_HDMIPHY		0x00000100
+#define FLAG_NO_GPIO		0x00000200
 
 /* i2c controller state */
 enum s3c24xx_i2c_state {
@@ -481,6 +483,13 @@ static int s3c24xx_i2c_set_master(struct s3c24xx_i2c *i2c)
 	unsigned long iicstat;
 	int timeout = 400;
 
+	/* the timeout for HDMIPHY is reduced to 10 ms because
+	 * the hangup is expected to happen, so waiting 400 ms
+	 * causes only unnecessary system hangup
+	 */
+	if (i2c->type & FLAG_HDMIPHY)
+		timeout = 10;
+
 	while (timeout-- > 0) {
 		iicstat = readl(i2c->regs + S3C2410_IICSTAT);
 
@@ -490,6 +499,15 @@ static int s3c24xx_i2c_set_master(struct s3c24xx_i2c *i2c)
 		msleep(1);
 	}
 
+	/* hang-up of bus dedicated for HDMIPHY occurred, resetting */
+	if (i2c->type & FLAG_HDMIPHY) {
+		writel(0, i2c->regs + S3C2410_IICCON);
+		writel(0, i2c->regs + S3C2410_IICSTAT);
+		writel(0, i2c->regs + S3C2410_IICDS);
+
+		return 0;
+	}
+
 	return -ETIMEDOUT;
 }
 
@@ -771,6 +789,9 @@ static int s3c24xx_i2c_parse_dt_gpio(struct s3c24xx_i2c *i2c)
 {
 	int idx, gpio, ret;
 
+	if (i2c->type & FLAG_NO_GPIO)
+		return 0;
+
 	for (idx = 0; idx < 2; idx++) {
 		gpio = of_get_gpio(i2c->dev->of_node, idx);
 		if (!gpio_is_valid(gpio)) {
@@ -795,6 +816,10 @@ free_gpio:
 static void s3c24xx_i2c_dt_gpio_free(struct s3c24xx_i2c *i2c)
 {
 	unsigned int idx;
+
+	if (i2c->type & FLAG_NO_GPIO)
+		return;
+
 	for (idx = 0; idx < 2; idx++)
 		gpio_free(i2c->gpios[idx]);
 }
@@ -871,6 +896,13 @@ s3c24xx_i2c_parse_dt(struct device_node *np, struct s3c24xx_i2c *i2c)
 		return;
 
 	pdata->bus_num = -1; /* i2c bus number is dynamically assigned */
+
+	if (of_get_property(np, "samsung,i2c-quirk-hdmiphy", NULL))
+		i2c->type |= FLAG_HDMIPHY;
+
+	if (of_get_property(np, "samsung,i2c-no-gpio", NULL))
+		i2c->type |= FLAG_NO_GPIO;
+
 	of_property_read_u32(np, "samsung,i2c-sda-delay", &pdata->sda_delay);
 	of_property_read_u32(np, "samsung,i2c-slave-addr", &pdata->slave_addr);
 	of_property_read_u32(np, "samsung,i2c-max-bus-freq",
@@ -1128,6 +1160,9 @@ static struct platform_device_id s3c24xx_driver_ids[] = {
 	}, {
 		.name		= "s3c2440-i2c",
 		.driver_data	= TYPE_S3C2440,
+	}, {
+		.name		= "s3c2440-hdmiphy-i2c",
+		.driver_data	= TYPE_S3C2440 | FLAG_HDMIPHY | FLAG_NO_GPIO,
 	}, { },
 };
 MODULE_DEVICE_TABLE(platform, s3c24xx_driver_ids);
-- 
1.7.9

