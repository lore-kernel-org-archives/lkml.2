Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab1KDMsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:48:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57184 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab1KDMsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:48:39 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <linux-kernel@vger.kernel.org>, <broonie@opensource.wolfsonmicro.com>,
        <lrg@ti.com>, <sameo@linux.intel.com>, <nsekhar@ti.com>
CC: <linux-omap@vger.kernel.org>, Afzal Mohammed <afzal@ti.com>
Subject: [PATCH 1/2] mfd: TPS65910: Improvements
Date: Fri, 4 Nov 2011 18:18:32 +0530
Message-ID: <1320410912-20293-1-git-send-email-afzal@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two changes,

1. TPS65910 can be used even if interrupt is unused.
 Hence let probe succeed in case interrupts can't be
 initialized and let Kernel only to cry about it

2. struct tps65910_platform_data usage can be avoided
 by making use of struct tps65910_board to simplify
 driver. Hence remove it

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/mfd/tps65910-irq.c   |   15 +++++++--------
 drivers/mfd/tps65910.c       |   20 ++------------------
 include/linux/mfd/tps65910.h |    8 +-------
 3 files changed, 10 insertions(+), 33 deletions(-)

diff --git a/drivers/mfd/tps65910-irq.c b/drivers/mfd/tps65910-irq.c
index a56be93..8955838 100644
--- a/drivers/mfd/tps65910-irq.c
+++ b/drivers/mfd/tps65910-irq.c
@@ -153,18 +153,17 @@ static struct irq_chip tps65910_irq_chip = {
 	.irq_enable = tps65910_irq_enable,
 };
 
-int tps65910_irq_init(struct tps65910 *tps65910, int irq,
-		    struct tps65910_platform_data *pdata)
+int tps65910_irq_init(struct tps65910 *tps65910, struct tps65910_board *bdata)
 {
 	int ret, cur_irq;
 	int flags = IRQF_ONESHOT;
 
-	if (!irq) {
+	if (!bdata->irq) {
 		dev_warn(tps65910->dev, "No interrupt support, no core IRQ\n");
 		return -EINVAL;
 	}
 
-	if (!pdata || !pdata->irq_base) {
+	if (!bdata || !bdata->irq_base) {
 		dev_warn(tps65910->dev, "No interrupt support, no IRQ base\n");
 		return -EINVAL;
 	}
@@ -172,8 +171,8 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 	tps65910->irq_mask = 0xFFFFFF;
 
 	mutex_init(&tps65910->irq_lock);
-	tps65910->chip_irq = irq;
-	tps65910->irq_base = pdata->irq_base;
+	tps65910->chip_irq = bdata->irq;
+	tps65910->irq_base = bdata->irq_base;
 
 	switch (tps65910_chip_id(tps65910)) {
 	case TPS65910:
@@ -202,10 +201,10 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 #endif
 	}
 
-	ret = request_threaded_irq(irq, NULL, tps65910_irq, flags,
+	ret = request_threaded_irq(bdata->irq, NULL, tps65910_irq, flags,
 				   "tps65910", tps65910);
 
-	irq_set_irq_type(irq, IRQ_TYPE_LEVEL_LOW);
+	irq_set_irq_type(bdata->irq, IRQ_TYPE_LEVEL_LOW);
 
 	if (ret != 0)
 		dev_err(tps65910->dev, "Failed to request IRQ: %d\n", ret);
diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 25d5d72..22f2914 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -135,7 +135,6 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 {
 	struct tps65910 *tps65910;
 	struct tps65910_board *pmic_plat_data;
-	struct tps65910_platform_data *init_data;
 	int ret = 0;
 	unsigned char buff;
 
@@ -143,15 +142,9 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	if (!pmic_plat_data)
 		return -EINVAL;
 
-	init_data = kzalloc(sizeof(struct tps65910_platform_data), GFP_KERNEL);
-	if (init_data == NULL)
-		return -ENOMEM;
-
 	tps65910 = kzalloc(sizeof(struct tps65910), GFP_KERNEL);
-	if (tps65910 == NULL) {
-		kfree(init_data);
+	if (tps65910 == NULL)
 		return -ENOMEM;
-	}
 
 	i2c_set_clientdata(i2c, tps65910);
 	tps65910->dev = &i2c->dev;
@@ -182,23 +175,14 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err;
 
-	init_data->irq = pmic_plat_data->irq;
-	init_data->irq_base = pmic_plat_data->irq_base;
-
 	tps65910_gpio_init(tps65910, pmic_plat_data->gpio_base);
 
-	ret = tps65910_irq_init(tps65910, init_data->irq, init_data);
-	if (ret < 0)
-		goto err2;
+	tps65910_irq_init(tps65910, pmic_plat_data);
 
-	kfree(init_data);
 	return ret;
 
-err2:
-	mfd_remove_devices(tps65910->dev);
 err:
 	kfree(tps65910);
-	kfree(init_data);
 	return ret;
 }
 
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 207b8b2..b845f28 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -816,16 +816,10 @@ struct tps65910 {
 	u32 irq_mask;
 };
 
-struct tps65910_platform_data {
-	int irq;
-	int irq_base;
-};
-
 int tps65910_set_bits(struct tps65910 *tps65910, u8 reg, u8 mask);
 int tps65910_clear_bits(struct tps65910 *tps65910, u8 reg, u8 mask);
 void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base);
-int tps65910_irq_init(struct tps65910 *tps65910, int irq,
-		struct tps65910_platform_data *pdata);
+int tps65910_irq_init(struct tps65910 *tps65910, struct tps65910_board *pdata);
 int tps65910_irq_exit(struct tps65910 *tps65910);
 
 static inline int tps65910_chip_id(struct tps65910 *tps65910)
-- 
1.6.2.4

