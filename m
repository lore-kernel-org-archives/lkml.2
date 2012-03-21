Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab2CUTML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:12:11 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16924 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab2CUTME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:12:04 -0400
Date: Wed, 21 Mar 2012 20:11:52 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 2/3] i2c-s3c2410: Rework device type handling
In-reply-to: <1332357113-2973-1-git-send-email-k.lewandowsk@samsung.com>
To: w.sang@pengutronix.de
Cc: ben-linux@fluff.org, m.szyprowski@samsung.com, thomas.abraham@linaro.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, kyungmin.park@samsung.com,
        broonie@opensource.wolfsonmicro.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1332357113-2973-3-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.9
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1332357113-2973-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganize driver a bit to better handle device tree-based systems:

 - move machine type to driver's private structure instead of
   quering platform device variants in runtime

 - replace s3c24xx_i2c_type enum with unsigned int that holds
   bitmask with revision-specific quirks

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/i2c/busses/i2c-s3c2410.c |   47 ++++++++++++++++++-------------------
 1 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 85e3664..f7b6a14 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -44,8 +44,14 @@
 #include <plat/regs-iic.h>
 #include <plat/iic.h>
 
-/* i2c controller state */
+#ifdef CONFIG_OF
+static const struct of_device_id s3c24xx_i2c_match[];
+#endif
 
+/* Treat S3C2410 as baseline hardware, anything else is supported via quirks */
+#define QUIRK_S3C2440		(1 << 0)
+
+/* i2c controller state */
 enum s3c24xx_i2c_state {
 	STATE_IDLE,
 	STATE_START,
@@ -54,14 +60,10 @@ enum s3c24xx_i2c_state {
 	STATE_STOP
 };
 
-enum s3c24xx_i2c_type {
-	TYPE_S3C2410,
-	TYPE_S3C2440,
-};
-
 struct s3c24xx_i2c {
 	spinlock_t		lock;
 	wait_queue_head_t	wait;
+	unsigned int            quirks;
 	unsigned int		suspended:1;
 
 	struct i2c_msg		*msg;
@@ -88,26 +90,22 @@ struct s3c24xx_i2c {
 #endif
 };
 
-/* default platform data removed, dev should always carry data. */
-
-/* s3c24xx_i2c_is2440()
+/* s3c24xx_get_device_quirks
  *
- * return true is this is an s3c2440
+ * Get controller type either from device tree or platform device variant.
 */
 
-static inline int s3c24xx_i2c_is2440(struct s3c24xx_i2c *i2c)
+static inline unsigned int s3c24xx_get_device_quirks(struct platform_device *pdev)
 {
-	struct platform_device *pdev = to_platform_device(i2c->dev);
-	enum s3c24xx_i2c_type type;
-
 #ifdef CONFIG_OF
-	if (i2c->dev->of_node)
-		return of_device_is_compatible(i2c->dev->of_node,
-				"samsung,s3c2440-i2c");
+        if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(&s3c24xx_i2c_match[0], pdev->dev.of_node);
+		return (unsigned int)match->data;
+        }
 #endif
 
-	type = platform_get_device_id(pdev)->driver_data;
-	return type == TYPE_S3C2440;
+	return platform_get_device_id(pdev)->driver_data;
 }
 
 /* s3c24xx_i2c_master_complete
@@ -676,7 +674,7 @@ static int s3c24xx_i2c_clockrate(struct s3c24xx_i2c *i2c, unsigned int *got)
 
 	writel(iiccon, i2c->regs + S3C2410_IICCON);
 
-	if (s3c24xx_i2c_is2440(i2c)) {
+	if (i2c->quirks & QUIRK_S3C2440) {
 		unsigned long sda_delay;
 
 		if (pdata->sda_delay) {
@@ -906,6 +904,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 		goto err_noclk;
 	}
 
+	i2c->quirks = s3c24xx_get_device_quirks(pdev);
 	if (pdata)
 		memcpy(i2c->pdata, pdata, sizeof(*pdata));
 	else
@@ -1113,18 +1112,18 @@ static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
 static struct platform_device_id s3c24xx_driver_ids[] = {
 	{
 		.name		= "s3c2410-i2c",
-		.driver_data	= TYPE_S3C2410,
+		.driver_data	= 0,
 	}, {
 		.name		= "s3c2440-i2c",
-		.driver_data	= TYPE_S3C2440,
+		.driver_data	= QUIRK_S3C2440,
 	}, { },
 };
 MODULE_DEVICE_TABLE(platform, s3c24xx_driver_ids);
 
 #ifdef CONFIG_OF
 static const struct of_device_id s3c24xx_i2c_match[] = {
-	{ .compatible = "samsung,s3c2410-i2c" },
-	{ .compatible = "samsung,s3c2440-i2c" },
+	{ .compatible = "samsung,s3c2410-i2c", .data = (void *)0 },
+	{ .compatible = "samsung,s3c2440-i2c", .data = (void *)QUIRK_S3C2440 },
 	{},
 };
 MODULE_DEVICE_TABLE(of, s3c24xx_i2c_match);
-- 
1.7.9

