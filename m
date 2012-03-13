Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810Ab2CMQyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:54:52 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25339 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab2CMQyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:54:49 -0400
Date: Tue, 13 Mar 2012 17:54:38 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 2/3] i2c-s3c2410: Rework device type handling
In-reply-to: <1331657679-31302-1-git-send-email-k.lewandowsk@samsung.com>
To: ben-linux@fluff.org
Cc: thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1331657679-31302-3-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.9
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1331657679-31302-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganize driver a bit to better handle device tree-based systems:

 - move machine type to driver's private structure instead of
   quering platform device variants in runtime

 - replace s3c24xx_i2c_type enum with plain unsigned int that can
   hold not only device type but also hw revision-specific quirks

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/i2c/busses/i2c-s3c2410.c |   53 +++++++++++++++++++++++---------------
 1 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 85e3664..f84d26f 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -44,8 +44,16 @@
 #include <plat/regs-iic.h>
 #include <plat/iic.h>
 
-/* i2c controller state */
+#ifdef CONFIG_OF
+static const struct of_device_id s3c24xx_i2c_match[];
+#endif
+
+/* reserve lower 8 bits for device type, use remaining space for hw quirks */
+#define TYPE_BITS		0x000000ff
+#define TYPE_S3C2410		0x00000001
+#define TYPE_S3C2440		0x00000002
 
+/* i2c controller state */
 enum s3c24xx_i2c_state {
 	STATE_IDLE,
 	STATE_START,
@@ -54,14 +62,10 @@ enum s3c24xx_i2c_state {
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
+	unsigned int            type;
 	unsigned int		suspended:1;
 
 	struct i2c_msg		*msg;
@@ -88,26 +92,32 @@ struct s3c24xx_i2c {
 #endif
 };
 
-/* default platform data removed, dev should always carry data. */
-
-/* s3c24xx_i2c_is2440()
+/* s3c24xx_i2c_is_type()
  *
- * return true is this is an s3c2440
+ * return true if this controller is of specified type
 */
 
-static inline int s3c24xx_i2c_is2440(struct s3c24xx_i2c *i2c)
+static inline int s3c24xx_i2c_is_type(struct s3c24xx_i2c *i2c, unsigned int type)
 {
-	struct platform_device *pdev = to_platform_device(i2c->dev);
-	enum s3c24xx_i2c_type type;
+	return (i2c->type & TYPE_BITS) == type;
+}
+
+/* s3c24xx_get_device_type
+ *
+ * Get controller type either from device tree or platform device variant.
+*/
 
+static inline unsigned int s3c24xx_get_device_type(struct platform_device *pdev)
+{
 #ifdef CONFIG_OF
-	if (i2c->dev->of_node)
-		return of_device_is_compatible(i2c->dev->of_node,
-				"samsung,s3c2440-i2c");
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(&s3c24xx_i2c_match[0], pdev->dev.of_node);
+		return (unsigned int)match->data;
+	}
 #endif
 
-	type = platform_get_device_id(pdev)->driver_data;
-	return type == TYPE_S3C2440;
+	return platform_get_device_id(pdev)->driver_data;
 }
 
 /* s3c24xx_i2c_master_complete
@@ -676,7 +686,7 @@ static int s3c24xx_i2c_clockrate(struct s3c24xx_i2c *i2c, unsigned int *got)
 
 	writel(iiccon, i2c->regs + S3C2410_IICCON);
 
-	if (s3c24xx_i2c_is2440(i2c)) {
+	if (s3c24xx_i2c_is_type(i2c, TYPE_S3C2440)) {
 		unsigned long sda_delay;
 
 		if (pdata->sda_delay) {
@@ -906,6 +916,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 		goto err_noclk;
 	}
 
+	i2c->type = s3c24xx_get_device_type(pdev);
 	if (pdata)
 		memcpy(i2c->pdata, pdata, sizeof(*pdata));
 	else
@@ -1123,8 +1134,8 @@ MODULE_DEVICE_TABLE(platform, s3c24xx_driver_ids);
 
 #ifdef CONFIG_OF
 static const struct of_device_id s3c24xx_i2c_match[] = {
-	{ .compatible = "samsung,s3c2410-i2c" },
-	{ .compatible = "samsung,s3c2440-i2c" },
+	{ .compatible = "samsung,s3c2410-i2c", .data = (void *)TYPE_S3C2410 },
+	{ .compatible = "samsung,s3c2440-i2c", .data = (void *)TYPE_S3C2440 },
 	{},
 };
 MODULE_DEVICE_TABLE(of, s3c24xx_i2c_match);
-- 
1.7.9

