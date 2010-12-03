Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0LCPhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:37:18 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:54006 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655Ab0LCPhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:37:14 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <dmitry.torokhov@gmail.com>,
        <sameo@linux.intel.com>, <ben-linux@fluff.org>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sundar Iyer <sundar.iyer@stericsson.com>
Subject: [PATCH 09/20] mfd/tc3589x: add block identifier for multiple child devices
Date: Fri, 3 Dec 2010 20:35:42 +0530
Message-ID: <1291388753-14662-10-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add block identifier to be able to add multiple mfd clients
to the mfd core

Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500.c |    1 +
 drivers/mfd/tc3589x.c              |   28 +++++++++++++++++++++++-----
 include/linux/mfd/tc3589x.h        |    7 +++++++
 3 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 6aaf382..703840b 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -123,6 +123,7 @@ static struct tc3589x_gpio_platform_data mop500_tc35892_gpio_data = {
 };
 
 static struct tc3589x_platform_data mop500_tc35892_data = {
+	.block		= TC3589x_BLOCK_GPIO,
 	.gpio		= &mop500_tc35892_gpio_data,
 	.irq_base	= MOP500_EGPIO_IRQ_BASE,
 };
diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index 7deff53..0ed9669 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -129,7 +129,7 @@ static struct resource gpio_resources[] = {
 	},
 };
 
-static struct mfd_cell tc3589x_devs[] = {
+static struct mfd_cell tc3589x_dev_gpio[] = {
 	{
 		.name		= "tc3589x-gpio",
 		.num_resources	= ARRAY_SIZE(gpio_resources),
@@ -240,6 +240,26 @@ static int tc3589x_chip_init(struct tc3589x *tc3589x)
 	return tc3589x_reg_write(tc3589x, TC3589x_RSTINTCLR, 0x1);
 }
 
+static int __devinit tc3589x_device_init(struct tc3589x *tc3589x)
+{
+	int ret = 0;
+	unsigned int blocks = tc3589x->pdata->block;
+
+	if (blocks & TC3589x_BLOCK_GPIO) {
+		ret = mfd_add_devices(tc3589x->dev, -1, tc3589x_dev_gpio,
+				ARRAY_SIZE(tc3589x_dev_gpio), NULL,
+				tc3589x->irq_base);
+		if (ret) {
+			dev_err(tc3589x->dev, "failed to add gpio child\n");
+			return ret;
+		}
+		dev_info(tc3589x->dev, "added gpio block\n");
+	}
+
+	return ret;
+
+}
+
 static int __devinit tc3589x_probe(struct i2c_client *i2c,
 				   const struct i2c_device_id *id)
 {
@@ -281,11 +301,9 @@ static int __devinit tc3589x_probe(struct i2c_client *i2c,
 		goto out_removeirq;
 	}
 
-	ret = mfd_add_devices(tc3589x->dev, -1, tc3589x_devs,
-			      ARRAY_SIZE(tc3589x_devs), NULL,
-			      tc3589x->irq_base);
+	ret = tc3589x_device_init(tc3589x);
 	if (ret) {
-		dev_err(tc3589x->dev, "failed to add children\n");
+		dev_err(tc3589x->dev, "failed to add child devices\n");
 		goto out_freeirq;
 	}
 
diff --git a/include/linux/mfd/tc3589x.h b/include/linux/mfd/tc3589x.h
index ea19188..da00958 100644
--- a/include/linux/mfd/tc3589x.h
+++ b/include/linux/mfd/tc3589x.h
@@ -9,6 +9,11 @@
 
 #include <linux/device.h>
 
+enum tx3589x_block {
+	TC3589x_BLOCK_GPIO        = 1 << 0,
+	TC3589x_BLOCK_KEYPAD      = 1 << 1,
+};
+
 #define TC3589x_RSTCTRL_IRQRST	(1 << 4)
 #define TC3589x_RSTCTRL_TIMRST	(1 << 3)
 #define TC3589x_RSTCTRL_ROTRST	(1 << 2)
@@ -122,10 +127,12 @@ struct tc3589x_gpio_platform_data {
 
 /**
  * struct tc3589x_platform_data - TC3589x platform data
+ * @block: bitmask of blocks to enable (use TC3589x_BLOCK_*)
  * @irq_base: base IRQ number.  %TC3589x_NR_IRQS irqs will be used.
  * @gpio: GPIO-specific platform data
  */
 struct tc3589x_platform_data {
+	unsigned int block;
 	int irq_base;
 	struct tc3589x_gpio_platform_data *gpio;
 };
-- 
1.7.2.dirty

